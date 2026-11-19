extends RefCounted
## S489 STEPVALUE1 build piece 3 (map ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md s2 ROPES, his Q-S294-231: "three in a
## round on your count = the next exchange is on the ropes"): the ROPES COUNT inside the live round. Each planned step that
## fired moves the count by its StepEffect row (step back +1; pivot out / step out clear it; cut off / herd add to the
## opponent's count). At StepEffect.ROPES_AT the next exchange is fought on the ropes card (own_ropes / opp_ropes) and the
## count starts again. Counts live on the round (lv), so they reset at the bell. Only the place changes here: the step's
## DENY / OPEN / DRAIN sizes wait for the map's probes (s9), so no unmeasured edge enters the fight.
##   after(lv, rec, arrow, planned) - updates lv["at"], lv["ropes"], lv["opp_ropes"], lv["ropes_times"], rec["ropes_put"]
##   times(lv) -> int   (how often this round your boxer was put on the ropes by the count)
## S525 STEPLEVERS (TREEVALUE2: roll_out / push_off read exactly 0 - their DENY / OPEN / DRAIN never reached the fight):
## a planned step that fires now does its StepEffect row, graded (StepEffect.scaled): DENY takes that share of the
## opponent's landed punches of its kind this exchange (DENY_SHARE = the kind's part of BoutBurn.MIX), DRAIN costs the
## opponent's tank n body units, the step's own "tank" costs ours (tie_up's refill stays ClinchRest's), OPEN gives the
## next planned PUNCH line +n x Exchanges.EDGE best. Every size an ESTIMATE until TREEVALUE3 reads 1.5-5 in 100.
##   open_edge(lv, arrow, planned) -> float   (before settle; spends the open either way)
##   levers(lv, s, arrow, planned, grade, rng) -> {denied, drain}   (after settle; edits s["landed"][1], lv cost / opp_drain / open)

const StepEffect := preload("res://scripts/rules/StepEffect.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const DENY_SHARE := {"all": 1.0, "power": 0.5, "head_hooks": 0.19}   ## BoutBurn.MIX: cross .25 + hooks .19 + uppercut .06; lead hook .13 + uppercut .06
const WRONG_COST := 0.2   ## ESTIMATE (step_in's map value, now every step's default) - sized by TREEVALUE5 / STEPTUNE3
static var levers_on: bool = true   ## tests turn it off for the control arm (the ropes count stays)


static func after(lv: Dictionary, rec: Dictionary, arrow: String, planned: bool) -> void:
	rec["ropes_put"] = ""
	var step := PlanFight.base_id(arrow)
	var row := StepEffect.effect(step)
	if not planned or row.is_empty():
		return
	lv["ropes"] = StepEffect.ropes_after(int(lv.get("ropes", 0)), step)
	lv["opp_ropes"] = int(lv.get("opp_ropes", 0)) + int(row.get("opp_ropes", 0))
	if StepEffect.on_ropes(int(lv["ropes"])):
		lv["at"] = "own_ropes"
		lv["ropes"] = 0
		lv["ropes_times"] = int(lv.get("ropes_times", 0)) + 1
		rec["ropes_put"] = "own"
	elif StepEffect.on_ropes(int(lv["opp_ropes"])):
		lv["at"] = "opp_ropes"
		lv["opp_ropes"] = 0
		rec["ropes_put"] = "opp"


static func times(lv: Dictionary) -> int:
	return int(lv.get("ropes_times", 0))


## S528 STEPS_SCOPE phase 1 (STEPTUNE2 s3: the open was spent on the next step line and never reached a punch): a planned
## STEP line passes the opening on to the punch after it; a planned punch spends it; an unplanned pick wastes it.
static func open_edge(lv: Dictionary, arrow: String, planned: bool) -> float:
	var e := float(lv.get("open", 0.0))
	if levers_on and planned and StepEffect.TABLE.has(PlanFight.base_id(arrow)):
		return 0.0   # kept for the punch after the step
	lv["open"] = 0.0
	if not levers_on or not planned:
		return 0.0
	return e * float(Exchanges.EDGE["best"])


## fit = PlanFight.fit for this exchange (LiveRound's fit_now). S528 phase 1 (STEPTUNE2 s2: no step ever cost anything
## when it was the wrong answer): a step on a "wrong" fit lets WRONG_COST more of her punches land (the row's
## wrong_extra_damage when it has one). out["extra"] = the punches it let in.
static func levers(lv: Dictionary, s: Dictionary, arrow: String, planned: bool, grade: String, rng: RandomNumberGenerator, fit := "") -> Dictionary:
	var step := PlanFight.base_id(arrow)
	if not levers_on or not planned or not StepEffect.TABLE.has(step):
		return {}
	var row := StepEffect.scaled(step, grade)
	var out := {"denied": 0, "drain": 0.0, "extra": 0}
	if fit == "wrong":
		var cost := float(StepEffect.effect(step).get("wrong_extra_damage", 0.0))
		cost = cost if cost > 0.0 else WRONG_COST
		var theirs0 := int(s["landed"][1])
		out["extra"] = floori(float(maxi(1, theirs0)) * cost + rng.randf())
		s["landed"][1] = theirs0 + int(out["extra"])
	var deny := float(row["deny"]) * float(DENY_SHARE.get(str(row["deny_on"]), 0.0))
	if deny > 0.0:
		var theirs := int(s["landed"][1])
		var cut := mini(theirs, floori(float(theirs) * deny + rng.randf()))
		s["landed"][1] = theirs - cut
		out["denied"] = cut
	if float(row["drain"]) > 0.0:
		out["drain"] = float(row["drain"]) * Exchanges.BODY_COST
		lv["opp_drain"] = float(lv.get("opp_drain", 0.0)) + float(out["drain"])
	if step != "tie_up":
		lv["cost"] = float(lv.get("cost", 0.0)) + float(row["tank"])
	lv["open"] = maxf(float(lv.get("open", 0.0)), float(row["open"]))   # two steps in a row: the bigger opening, not the sum
	return out
