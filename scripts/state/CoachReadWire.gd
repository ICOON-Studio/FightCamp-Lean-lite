extends RefCounted
## S533 P4PBUILD1 stage 3: the coach's read on the real career. facts() gathers what CoachRead reads (one builder for the
## offer card and the bout page); snapshot() keeps the read's testable call when the bout is accepted; settle() scores it
## after the bout; record() is the coach's own tally (kept on the coach: a new coach starts clean, no coach keeps none).
## Read only: nothing here moves a bout's odds.

const CoachRead := preload("res://scripts/rules/CoachRead.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Region := preload("res://scripts/state/Region.gd")
const HotStreak := preload("res://scripts/state/HotStreak.gd")
const LoyaltyWire := preload("res://scripts/state/LoyaltyWire.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")


static func facts(c: Career, f: Dictionary, o: Dictionary) -> Dictionary:
	var opp: Dictionary = o["opp"]
	var day := int(o["day"])
	var sim: GDScript = load("res://scripts/state/Sim.gd")
	var bouts: GDScript = load("res://scripts/state/Bouts.gd")
	var wf: Dictionary = sim.weigh_forecast(c, f, day)
	var camp: Dictionary = BoutRead.camp_for(f, day - c.day)
	var band: Dictionary = BoutRead.band(f, opp, camp, c.seed, float(c.coach.get("rating", 0.0)))
	var rows: Array = Region.rankings(c, str(f["div"]))
	var mv: Dictionary = BoutRead.rank_move(rows, f, str(opp["name"]), Callable(Region, "before"), Region.RANK_MIN_WINS)
	var g: Dictionary = f.get("goal", {})
	var needs := bool((g.get("targets", {}) as Dictionary).get("booked_fight", false)) and not bool(f.get("booked_fight", false))
	var game := OppFile.main_game(opp)
	var place := str(PlanFight.GAME_CARD.get(game, "long"))
	var line := PlanBoard.pick(f.get("arrows", []), StrikeMap.MOVES, place, "", game) if game != "" else ""
	var ready := line != "" and PlanFight.can_do(StrikeMap.move(line), f.get("moves", {})) and FireLevel.mastery_of(f, line) >= FireLevel.USABLE_AT
	var later := -1
	for s in AskFlow.shows(c, f):
		if int(s["day"]) > day and bool(s.get("can_ask", false)) and later < 0:
			later = int(s["day"])
	var tally := record(c)
	return {"gap": roundi(BoutRead.mismatch(f, opp, camp, c.seed)), "unsafe": bool(o["mismatch"]),
		"rest": BoutRules.days_since_bout(c.results, str(f["id"]), day), "over": 0.0 if bool(wf.get("ok", true)) else float(wf.get("over", 0.0)),
		"hot": HotStreak.hot(c, f), "streak_words": HotStreak.words(c, f), "rank_now": int(mv["now"]), "rank_win": int(mv["win"]),
		"goal_needs_bout": needs, "goal_days": int(g.get("deadline_day", c.day - 1)) - c.day if not g.is_empty() else -1,
		"coach": not c.coach.is_empty(), "game_known": game != "", "game_place": str(StrikeMap.card(place).get("name", place)).to_lower(),
		"answer": str(StrikeMap.move(line).get("name", line)).to_lower() if line != "" else "", "answer_ready": ready,
		"lo": float(band["lo"]), "hi": float(band["hi"]), "days_out": day - c.day,
		"booked_morale": int(FighterProfile.MORALE_EVENTS.get("booked", 0)), "pass_price": int(bouts.pass_price(c, f, o)),
		"duck": HotStreak.would_duck(c, f, opp, true), "idle_weeks": int(f.get("idle_weeks", 0)), "idle_at": LoyaltyWire.IDLE_WEEKS,
		"idle_price": int(Loyalty.MOVES.get("no_bout", 0)), "later_days": later - c.day if later >= 0 else -1,
		"later_rest": later - day if later >= 0 else 0, "reads_right": int(tally[0]), "reads_of": int(tally[1])}


static func read(c: Career, f: Dictionary, o: Dictionary) -> Dictionary:
	return CoachRead.read(facts(c, f, o))


## On Accept (Bouts.accept): the read's one testable call rides on the bout. 1 = favoured (the whole win range at or over
## 50%), -1 = the underdog (all of it at or under), 0 = no call (never scored). Only a hired coach keeps a record.
static func snapshot(c: Career, f: Dictionary, o: Dictionary) -> void:
	if c.coach.is_empty() or not f.has("bout"):
		return
	var x := facts(c, f, o)
	f["bout"]["read_call"] = 1 if float(x["lo"]) >= 0.5 else (-1 if float(x["hi"]) <= 0.5 else 0)


## After the bout (BoutFinish): a win or a loss settles the call; a draw, a bout with no call or an old save settles nothing.
static func settle(c: Career, f: Dictionary, outcome: String) -> void:
	var call := int((f.get("bout", {}) as Dictionary).get("read_call", 0))
	if call == 0 or c.coach.is_empty() or not outcome in ["win", "loss"]:
		return
	var kept: Array = c.coach.get("reads", [])
	kept.append(1 if (call == 1) == (outcome == "win") else 0)
	while kept.size() > CoachRead.RECORD_KEEP:
		kept.pop_front()
	c.coach["reads"] = kept


## [right, resolved] over the coach's kept reads.
static func record(c: Career) -> Array:
	var kept: Array = c.coach.get("reads", [])
	var right := 0
	for v in kept:
		right += int(v)
	return [right, kept.size()]
