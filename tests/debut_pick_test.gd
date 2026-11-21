extends SceneTree
## DEBUTPICK1 (S533, owner Q-286 "Pick to each boxer"): the promoter picks the debut opponent to fit the boxer. RED on
## main: scripts/rules/DebutPick.gd does not exist (the test cannot load), and the offer carried one fixed gap per house
## (3.0 / 6.0), which read 30 to 90 in 100 by boxer (docs/TURNPRO6_RESULT.md).
## Populations (all different people): (1) the six the game can sign as they walk in (Data.lucy + Data.PROSPECTS: four
## women, two men, five styles, both stances) for the pick alone; (2) Lucy Jackson and Tess Reilly played from signing to
## their first pro offer, signed through Roster.turn_pro on the offer the game made and played by the game's days to
## fight night, then NIGHTS bouts on PlanTest's scratch dice (day 50000 + k * 7) against the booked opponent.
## CONTROL ARM: the same six at each house's old fixed gap, read through the same instrument - it reads the wide spread
## the pick removes (so this test can read worse). Bounds, never exact counts.

const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const DebutPick := preload("res://scripts/rules/DebutPick.gd")
const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Tip := preload("res://scripts/ui/Tip.gd")

const NIGHTS := 200
const DICE_DAY := 50000
const SEEN_TOL := 0.03      ## the offer as the player first sees it (the day's training since the call has moved the boxer a little)
const READ_TOL := 0.012     ## one 0.1 step of gap is about half a point of read: the picked read sits this near its target
const UNDER := 0.10         ## played bouts may fall this far under the house's target
const OVER := 0.18          ## ... and this far over (the offer reads the boxer as today: the camp's training is still to come)
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const COACH := 58.0
var failures := 0


func _initialize() -> void:
	_targets()
	_picks()
	_words()
	_wired()
	_played(Data.lucy(), "Lucy")
	_played(Data.PROSPECTS[2], "Tess")
	print("DEBUT_PICK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS %s" % label)
	else:
		failures += 1
		print("FAIL %s" % label)


func _people() -> Array:
	var out: Array = []
	for p in [Data.lucy()] + Data.PROSPECTS:
		out.append(Data.fighter_state(p, 1))
	return out


## The house's target: its aim and a bounded, seeded misjudgement.
func _targets() -> void:
	_check(DebutPick.aim("hf") > DebutPick.aim("bow") + 2.0 * DebutPick.NOISE, "the safer house aims higher than the bigger gate, whatever the misjudgement")
	var bounded := true
	var same := true
	var seen := {}
	for f in _people():
		for key in ["bow", "hf"]:
			for day in range(100, 160):
				var t := DebutPick.target(key, f, day)
				bounded = bounded and absf(t - DebutPick.aim(key)) <= DebutPick.NOISE + 0.0001
				same = same and is_equal_approx(t, DebutPick.target(key, f, day))
				seen[snappedf(t, 0.001)] = true
	_check(bounded, "the target never leaves the aim by more than %.2f" % DebutPick.NOISE)
	_check(same, "the same boxer, house and day: the same target")
	_check(seen.size() > 20, "the matchmaker misjudges: the target is not one number (%d different values)" % seen.size())


## The pick against the fixed gap (control arm) on six different people.
func _picks() -> void:
	var rows: Dictionary = ProCall.promoters()
	for key in ["bow", "hf"]:
		var t: Dictionary = ProCall.terms(key, 0, false)
		var fixed_lo := 1.0; var fixed_hi := 0.0; var pick_lo := 1.0; var pick_hi := 0.0
		var near := true; var again := true; var gaps: Array = []
		for f in _people():
			var p := DebutPick.pick(f, t, 120, COACH)
			var shown := float(DebutRead.card(f, DebutPick.apply(f, t, 120, COACH), 120, COACH)["win"])
			var clamped := float(p["gap"]) <= DebutPick.GAP_MIN + 0.05 or float(p["gap"]) >= DebutPick.GAP_MAX - 0.05
			near = near and (clamped or absf(shown - float(p["target"])) <= READ_TOL)
			DebutPick.clear_cache()
			again = again and is_equal_approx(float(DebutPick.pick(f, t, 120, COACH)["gap"]), float(p["gap"]))
			var fixed := float(DebutRead.card(f, t, 120, COACH)["win"])
			fixed_lo = minf(fixed_lo, fixed); fixed_hi = maxf(fixed_hi, fixed)
			pick_lo = minf(pick_lo, shown); pick_hi = maxf(pick_hi, shown)
			gaps.append(float(p["gap"]))
		_check(near, "%s: the read the offer shows sits on the house's target for each of six boxers (gaps %s)" % [key, str(gaps)])
		_check(again, "%s: the same seed, the same pick (cache cleared between)" % key)
		_check(pick_hi - pick_lo <= 2.0 * DebutPick.NOISE + 2.0 * READ_TOL, "%s: picked, the six read %.3f to %.3f" % [key, pick_lo, pick_hi])
		_check(fixed_hi - fixed_lo > (pick_hi - pick_lo) + 0.05, "%s control arm: at the fixed gap %.1f the same six read %.3f to %.3f (wider than picked)" % [key, float(rows[key]["opp_gap"]), fixed_lo, fixed_hi])
		_check(gaps.min() < gaps.max() - 0.5, "%s: different boxers get different opponents (gap %.1f to %.1f)" % [key, gaps.min(), gaps.max()])
	var f0: Dictionary = _people()[0]
	_check(float(DebutPick.pick(f0, ProCall.terms("hf", 0, false), 120, COACH)["gap"]) > float(DebutPick.pick(f0, ProCall.terms("bow", 0, false), 120, COACH)["gap"]),
		"the safer house books the weaker debutant for the same boxer")


func _words() -> void:
	var bow := DebutPick.apply(_people()[0], ProCall.terms("bow", 0, false), 120, COACH)
	var hf := DebutPick.apply(_people()[0], ProCall.terms("hf", 0, false), 120, COACH)
	_check(DebutPick.line(hf) == "picked as a winnable first night" and DebutPick.line(bow) == "picked to test your boxer", "each house says why it picked the opponent")
	_check(DebutPick.line(ProCall.terms("bow", 0, false)) == "", "an old offer with a fixed gap keeps its old words")
	var ok := true
	for t in [bow, hf]:
		var spec := Tip.spec(DebutPick.tip(t))
		var faults := Tip.faults(spec, DebutPick.line(t), ["Lucy", "Jackson"])
		ok = ok and faults.is_empty() and Tip._count(" ".join(Tip.prose(spec))) <= Tip.FULL_WORDS
		for w in [" he ", " she ", " her ", " him ", " his "]:
			ok = ok and not (" " + " ".join(Tip.prose(spec)).to_lower() + " " + DebutPick.line(t).to_lower() + " ").contains(w)
		if not faults.is_empty():
			print("  tip faults: %s" % str(faults))
	_check(ok, "the hover card: the tooltip standard's rules, 25 words, no name, no pronoun")
	var goal := {"w": 9, "l": 1, "pot": 80}   # S534 owner C442: the morale drop says why
	var why := ProOfferWire.morale_line(goal, true)
	_check(why.contains("a regional title") and why.contains("morale -5"), "a title-minded boxer's offer says why turning pro costs morale: %s" % why)
	_check(ProOfferWire.morale_line(goal, false) == "" and ProOfferWire.morale_line({"w": 0, "l": 0}, true) == "", "no morale line when neither choice moves it")


## The offer carries the pick, the asks move it, a save keeps it, turn_pro books it.
func _wired() -> void:
	var c := Career.quick_start()
	c.seed = 11
	c.members = 60
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["w"] = 9; f["l"] = 1; f["offers"] = []; f["age"] = 24; f["loyalty"] = 60
	Roster.check_pro(c)
	var offers: Array = c.pro_offer.get("offers", [])
	_check(offers.size() == 2, "both houses call (forecast within 15 of break-even)")
	var coach := float(c.coach.get("rating", 0.0))
	var ok := true
	for t in offers:
		var p := DebutPick.pick(f, ProCall.terms(str(t["key"]), 0, false), c.day, coach)
		ok = ok and bool(t.get("opp_picked", false)) and is_equal_approx(float(t["opp_gap"]), float(p["gap"])) and is_equal_approx(float(t["opp_target"]), float(p["target"]))
	_check(ok, "each house's offer carries the gap picked for this boxer (%s)" % str(offers.map(func(t): return t["opp_gap"])))
	var plain := float(ProOfferWire.offer(c.pro_offer, "hf")["opp_gap"])
	ProOfferWire.ask(c, "hf", "softer", 20)
	_check(is_equal_approx(float(ProOfferWire.offer(c.pro_offer, "hf")["opp_gap"]), plain + ProCall.SOFTER_OPP_ADD) and DebutPick.line(ProOfferWire.offer(c.pro_offer, "hf")) != "",
		"the softer-opponent ask moves the picked gap by %.1f" % ProCall.SOFTER_OPP_ADD)
	var c2: Career = SaveGame.from_dict(SaveGame.to_dict(c))
	var asked := float(ProOfferWire.offer(c.pro_offer, "hf")["opp_gap"])
	_check(is_equal_approx(float(ProOfferWire.offer(c2.pro_offer, "hf")["opp_gap"]), asked) and bool(ProOfferWire.offer(c2.pro_offer, "bow").get("opp_picked", false)),
		"a save keeps the picked opponent on the offer")
	var f2: Dictionary = c2.fighter()
	var want := DebutOpp.rating(f2["stats"], asked)
	var offered: Dictionary = DebutRead.card(f2, ProOfferWire.offer(c2.pro_offer, "hf"), c2.day + 3, coach)["opp"]
	c2.day += 3   # signed three days into the 14-day window: still the debutant the offer read
	Roster.turn_pro(c2, "hf")
	_check(is_equal_approx(float(f2["bout"]["opp"]["rating"]), want) and is_equal_approx(float(f2["bout"]["deal"]["opp_gap"]), asked) and str(f2["bout"]["opp"]["name"]) == str(offered["name"]),
		"turn_pro books the picked opponent, days later too (%s, rating %.1f)" % [str(offered["name"]), want])
	var c3: Career = SaveGame.from_dict(SaveGame.to_dict(c2))
	_check(is_equal_approx(float(c3.fighter()["bout"]["opp"]["rating"]), want) and str(c3.fighter()["bout"]["opp"]["name"]) == str(f2["bout"]["opp"]["name"]), "a save keeps the booked opponent")


## Played bouts: the boxer the game made, the offer the game made, the opponent turn_pro booked.
func _played(who: Dictionary, label: String) -> void:
	var c := _to_offer(who)
	_check(not c.pro_offer.is_empty(), "%s reaches a pro offer" % label)
	if c.pro_offer.is_empty():
		return
	var f: Dictionary = c.fighter_by_id(str(c.pro_offer["fid"]))
	var t: Dictionary = (c.pro_offer["offers"] as Array)[0]
	var key := str(t["key"])
	var target := float(t.get("opp_target", 0.0))
	var shown := float(DebutRead.card(f, t, c.day, float(c.coach.get("rating", 0.0)))["win"])
	_check(bool(t.get("opp_picked", false)) and absf(shown - target) <= SEEN_TOL, "%s, %s: the offer shows %.3f for a target of %.3f (gap %.1f)" % [label, key, shown, target, float(t["opp_gap"])])
	Roster.turn_pro(c, key)
	var guard := 0
	var made := false
	while guard < 200 and not c.closed and not (f["bout"] as Dictionary).is_empty():
		guard += 1
		_pre(c, f, false)
		if Bouts.fight_day(c, f):
			made = true
			break
		Sim.step_day(c)
	_check(made, "%s makes fight night" % label)
	if not made:
		return
	var tank := float(BoutRules.tank_parts_for(c.results, f, float(f.get("week_fatigue", 20.0)), int(f["bout"].get("day", c.day)))["off"])
	var wins := 0
	for k in NIGHTS:
		wins += int(_one(c, f, DICE_DAY + k * 7, tank) == "win")
	var share := float(wins) / float(NIGHTS)
	_check(share >= DebutPick.aim(key) - UNDER and share <= DebutPick.aim(key) + OVER, "%s, %s: %d played debuts won %.3f, inside %.2f under to %.2f over the house's aim %.2f" % [label, key, NIGHTS, share, UNDER, OVER, DebutPick.aim(key)])


func _one(c: Career, f: Dictionary, day: int, tank_off: float) -> String:
	var sc := Career.new()
	sc.day = day
	sc.coach = c.coach.duplicate(true)
	sc.seed = c.seed
	var sf: Dictionary = f.duplicate(true)
	sf["bout"]["stale"] = tank_off
	sf["bout"]["tank_why"] = ""
	sc.fighters = [sf]
	var m := BoutNight.fight_modal(sf)
	BoutNight.play_out(sc, sf, m)
	return BoutNight.outcome_of(sf, m)


func _to_offer(who: Dictionary) -> Career:
	var c := Career.quick_start()
	c.seed = 7000; c.first_hour = {}; FirstWeek.skip(c)
	c.applicant = who.duplicate(true)
	Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	f["ambition"] = "Turn pro as soon as the call comes"
	var guard := 0
	while c.day < 156 * 7 and not c.closed and guard < 5000 and c.pro_offer.is_empty():
		guard += 1
		_pre(c, f, true)
		Sim.step_day(c)
	return c


func _pre(c: Career, f: Dictionary, fight: bool) -> void:
	for o2 in (f["offers"] as Array).duplicate():
		if bool(o2["answered"]) or bool(o2["mismatch"]):
			continue
		if not (f["bout"] as Dictionary).is_empty():
			Bouts.decline(c, str(o2["id"]))
		else:
			Bouts.accept(c, str(o2["id"]))
	for o2 in (f["offers"] as Array).duplicate():
		if not bool(o2["answered"]):
			Bouts.decline(c, str(o2["id"]))
	if Bouts.camp_due(c, f):
		Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary).get("opp", {})), false)
	if Bouts.weigh_in_today(c, f):
		Bouts.weigh(c, f)
	if fight and Bouts.fight_day(c, f):
		Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
		Bouts.after_fight(c, f)
	if bool(f.get("goal_talk", false)):
		Bouts.set_goal(c, f, "five_round_engine")
