extends RefCounted
## TURNPROBE13 (S536) GREYBOX - NOT GAME CODE. Map v13's proposed turning-pro rules (ops/research/DESIGN_TURNPRO1_V13.md
## sections 3 to 5) as a LOCAL COPY for tools/turnprobe13.gd, so the map is measured before any critic scores it and before
## anything under scripts/ is touched (S534 DEPTH METHOD). Every constant here is the MAP's proposal; the game's own rules
## (ProCall, DebutPick, BoutFinish, ProLadder, Matchmaking) are the control arm and are called, never copied.
## v13 = v12 with three changes (docs/TURNPROBE12_RESULT.md section 2): (a) the Softer ask is gone - the only ask left is
## Later +2; (b) the name lasts: a tune-up win makes less name than a real fight (TUNE_NAME reputation, not the usual 5), so
## the safe road stops buying the same reputation a fight later; (c) the card shows what plays: the read's shortfall on a
## favourite is added back (TOP_LIFT) and the guarantee house aims its card at 78 (owner: "78 is fine").

const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const ProLean := preload("res://scripts/state/ProLean.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const Roster := preload("res://scripts/state/Roster.gd")

const STYLE := {"bow": ["Pressure fighter", "Loads up when hit"], "hf": ["Out-boxer", "Backs onto the ropes"]}   ## each house's debutant (v11, kept)
const WEEK_POINT := 0.01        ## the read counts the camp weeks PAST FOUR only: 1 point a week (probe 11, item 4)
const WEEKS_FREE := 4
const GAP_MIN := -6.0
const GAP_MAX := 14.0
const TOP_FROM := 0.60          ## the read errs low on a favourite (probe 12 stage A: 75.0 shown, 78.6 played; level at 60)
const TOP_LIFT := 0.20          ## ... so the card adds this share of every point the read stands over TOP_FROM
const AIM_UP := {"hf": 0.03}    ## the guarantee house aims its card at 78, not 75 (the misjudgement kept)
const TUNE_NAME := 2            ## a tune-up win is worth this much reputation, not BoutRules.WIN_REPUTATION (5)
const WIN_NAME := 5             ## mirrors BoutRules.WIN_REPUTATION
const LATER_FEE := 150          ## later +2: a calendar tool, unchanged
const LATER_WEEKS := 2
const NAME_PER_SEATS := 4       ## a ticket-house debut win: +1 reputation for every 4 seats sold on the night, on top of the usual 5
const NAME_TOP := 20
const ROAD_FIGHTS := 6          ## the house's road: the first six pro fights (ProLean.LEAN_FIGHTS)
const STEP_AFTER_WINS := 3      ## the guarantee house offers no step up before 3 pro wins


## The options a house has under v13: the plain offer only (Softer was right in 0 of 4 cells, probe 12). Later +2 is a
## calendar tool, read on the night only (stage A).
static func asks(_house: String) -> Array:
	return ["none"]


## The chance the v13 card shows: the game's read of the house's own debutant, the favourite's shortfall added back, plus
## a point a camp week past four.
static func card(f: Dictionary, t: Dictionary, coach: float) -> float:
	var house := str(t.get("key", ""))
	var opp: Dictionary = DebutOpp.make(f, float(t.get("opp_gap", 0.0)), int(t.get("opp_day", 0)), str(t.get("name", "")))
	if STYLE.has(house):
		opp["style"] = STYLE[house][0]
		opp["weak"] = STYLE[house][1]
	var fx: Dictionary = f.duplicate()
	fx["pro"] = true
	fx["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": DebutRead.ROUNDS}
	var out: Dictionary = BoutRead.CardOdds.result(BoutRead.round_edges(fx, opp, {"protocol": BoutRead.USUAL_CAMP}, coach), BoutRead.RingDuel.FORM_SD)
	var raw := float(out["win"])
	return raw + TOP_LIFT * maxf(0.0, raw - TOP_FROM) + WEEK_POINT * float(maxi(0, int(t.get("debut_weeks", 4)) - WEEKS_FREE))


## DebutPick's search on the v13 card: the gap whose shown chance is nearest the house's target for this boxer.
static func repick(f: Dictionary, t: Dictionary, coach: float) -> float:
	var want := float(t.get("opp_target", 0.65)) + float(AIM_UP.get(str(t.get("key", "")), 0.0))
	var lo := roundi(GAP_MIN * 10.0)
	var hi := roundi(GAP_MAX * 10.0)
	var t2: Dictionary = t.duplicate()
	while hi - lo > 1:
		var mid := (lo + hi) >> 1
		t2["opp_gap"] = float(mid) * 0.1
		if card(f, t2, coach) < want:
			lo = mid
		else:
			hi = mid
	t2["opp_gap"] = float(lo) * 0.1
	var r_lo := card(f, t2, coach)
	t2["opp_gap"] = float(hi) * 0.1
	var r_hi := card(f, t2, coach)
	return snappedf(float(hi if absf(r_hi - want) <= absf(r_lo - want) else lo) * 0.1, 0.1)


## Signs the house under v13: the re-picked debutant, one ask. The purse is today's (not a lever). Returns what the card showed.
static func sign(c: Career, f: Dictionary, house: String, ask: String) -> Dictionary:
	var o: Dictionary = c.pro_offer
	var coach := float(c.coach.get("rating", 0.0))
	var t: Dictionary = ProOfferWire.offer(o, house).duplicate()
	t["opp_gap"] = repick(f, t, coach)
	var plain := card(f, t, coach)
	match ask:
		"later2":
			t["purse"] = maxi(0, int(t["purse"]) - LATER_FEE)
			t["debut_weeks"] = int(t["debut_weeks"]) + LATER_WEEKS
	var shown := card(f, t, coach)
	var list: Array = o["offers"]
	for i in list.size():
		if str(list[i]["key"]) == house:
			list[i] = t
	Roster.turn_pro(c, house)
	if STYLE.has(house):
		f["bout"]["opp"]["style"] = STYLE[house][0]
		f["bout"]["opp"]["weak"] = STYLE[house][1]
	return {"gap": float(t["opp_gap"]), "plain": plain, "shown": shown}


## The night's lasting effects under v13, applied after the game's own result (BoutFinish has run; the boxer is on the table).
## gap = rating points the debutant sat under the boxer; stopped = the bout ended inside the distance.
static func after_debut(c: Career, f: Dictionary, house: String, _ask: String, sold: int, outcome: String, stopped: bool, gap: float) -> Dictionary:
	var out := {"name": 0, "seat": 0, "fans": 0, "rebuild": false}
	var e: Dictionary = ProLadder.entry(c, f)
	if e.is_empty():
		return out
	if outcome == "win":
		# the debut counts on the table as any pro win (Matchmaking.apply_result's fans line; opponent minus her = -gap)
		var fans := 1 + int(stopped) - int(-gap <= -MM.SOFT_GAP)
		e["fans"] = clampi(int(e.get("fans", 0)) + fans, MM.FANS_MIN, MM.FANS_MAX)
		out["fans"] = fans
		if house == "bow":   # the test, passed in front of the hall: the gym's name and the table's last seat
			var name_pts := mini(NAME_TOP, int(sold / NAME_PER_SEATS))
			c.reputation += name_pts
			out["name"] = name_pts
			out["seat"] = last_seat(c, f, e)
	elif outcome == "loss":
		var lost := MM.loss_fans(-gap)
		e["fans"] = clampi(int(e.get("fans", 0)) - lost, MM.FANS_MIN, MM.FANS_MAX)
		e["rebuild"] = true   # no step up until a rebuild win (ProLadder._make_offers, Matchmaking.ask)
		out["fans"] = -lost
		out["rebuild"] = true
	return out


## The table's last ranked seat goes to the boxer (the body of ProLadder._review_streak, without its 5-win gate).
static func last_seat(c: Career, f: Dictionary, e: Dictionary) -> int:
	if int(e.get("rank", 0)) > 0:
		return int(e["rank"])
	var last: Dictionary = {}
	for b in ProLadder.table(c, f):
		var r := int(b.get("rank", 0))
		if b != e and r > 0 and not b.get("retired", false) and (last.is_empty() or r > int(last["rank"])):
			last = b
	if last.is_empty():
		return 0
	e["rank"] = int(last["rank"])
	last["rank"] = 0
	return int(e["rank"])


## The house's road for the first six pro fights: the ticket house brings no tune-up (but the rebuild fight after a loss);
## the guarantee house no payday, and no step up before three pro wins. An emptied set stays as the promoter made it.
static func road(c: Career, f: Dictionary) -> void:
	var offers: Array = f.get("pro_offers", [])
	if offers.is_empty() or ProLean.pro_fights(f) >= ROAD_FIGHTS:
		return
	var house := str(f.get("pro_house", ""))
	var e: Dictionary = ProLadder.entry(c, f)
	var keep: Array = []
	for o in offers:
		var kind := str(o["kind"])
		if house == "bow" and kind == "tune" and not bool(e.get("rebuild", false)):
			continue
		if house == "hf" and (kind == "payday" or (kind == "above" and int(f.get("pro_w", 0)) < STEP_AFTER_WINS)):
			continue
		keep.append(o)
	if not keep.is_empty():
		f["pro_offers"] = keep


## The name lasts (v13): a pro win in a TUNE-UP makes TUNE_NAME reputation, not the usual 5. Applied after the game's own
## result (BoutFinish paid 5). kind = the row the bout was booked from ("tune" / "above" / "payday"). Returns what was taken back.
static func after_fight(c: Career, kind: String, outcome: String) -> int:
	if outcome != "win" or kind != "tune":
		return 0
	var back := mini(c.reputation, WIN_NAME - TUNE_NAME)
	c.reputation -= back
	return back
