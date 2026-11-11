extends RefCounted
## Pace (push / steady / save) and Aim (where she goes on the other boxer's body): what each costs and buys.
## Pure static module. Exchanges reads edge/spend/output/recover; the shout bar reads pace_word/aim_word/offers.

const PACES := ["push", "steady", "save"]
const AIMS := ["", "head", "body", "left_ribs", "right_ribs", "head_hurt"]

## S323 balance-check (tools/exchange_balance.gd, 400 bouts a plan): at save -6 / +3 breath, "save all" won 0.46 and
## "save-steady-push" 0.64 < steady 0.67 - a round off never paid. Save -4 / +6.
const PACE_EDGE := {"push": 6.0, "steady": 0.0, "save": -4.0}
const PACE_SPEND := {"push": 1.35, "steady": 1.0, "save": 0.6}
const PACE_OUTPUT := {"push": 1.25, "steady": 1.0, "save": 0.75}
const SAVE_RECOVER := 6.0

const AIM_BODY_SHARE := {"": 0.2, "head": 0.08, "body": 0.5, "left_ribs": 0.6, "right_ribs": 0.6, "head_hurt": 0.08}
const HURT_AIM_EDGE := 4.0
const HURT_AIM_DAMAGE := 1.3
const BODY_ON_TIRED_EDGE := 3.0
const AIM_COST := 1.5

const _HURT_PLACES := ["left_ribs", "right_ribs", "head"]
const _BODY_AIMS := ["body", "left_ribs", "right_ribs"]


static func edge(pace: String, aim: String, opp_hurt: Dictionary, opp_burn: Dictionary) -> float:
	var e: float = float(PACE_EDGE.get(pace, 0.0))
	if aim != "":
		e -= AIM_COST
	if aim == "left_ribs" and bool(opp_hurt.get("left_ribs", false)):
		e += HURT_AIM_EDGE
	elif aim == "right_ribs" and bool(opp_hurt.get("right_ribs", false)):
		e += HURT_AIM_EDGE
	elif aim == "head_hurt" and bool(opp_hurt.get("head", false)):
		e += HURT_AIM_EDGE
	if aim in _BODY_AIMS:
		var core_b: float = float(opp_burn.get("core", 0.0))
		var legs_b: float = float(opp_burn.get("legs", 0.0))
		if core_b >= 50.0 or legs_b >= 50.0:
			e += BODY_ON_TIRED_EDGE
	return e


static func spend(pace: String) -> float:
	return float(PACE_SPEND.get(pace, 1.0))


static func output(pace: String) -> float:
	return float(PACE_OUTPUT.get(pace, 1.0))


static func recover(pace: String) -> float:
	if pace == "save":
		return SAVE_RECOVER
	return 0.0


static func body_share(aim: String) -> float:
	return float(AIM_BODY_SHARE.get(aim, 0.2))


static func damage(aim: String, place: String, opp_hurt: Dictionary) -> float:
	var names_place: String = ""
	if aim == "head_hurt":
		names_place = "head"
	elif aim == "left_ribs" or aim == "right_ribs":
		names_place = aim
	if names_place != "" and names_place == place and bool(opp_hurt.get(place, false)):
		return HURT_AIM_DAMAGE
	return 1.0


static func pace_word(pace: String) -> String:
	if pace == "push":
		return "Push now!"
	if pace == "steady":
		return "Stay steady"
	if pace == "save":
		return "Take this one easy"
	return ""


static func aim_word(aim: String) -> String:
	if aim == "":
		return ""
	if aim == "head":
		return "Head hunt"
	if aim == "body":
		return "Go to the body"
	if aim == "left_ribs":
		return "Left ribs!"
	if aim == "right_ribs":
		return "Right ribs!"
	if aim == "head_hurt":
		return "Finish the head!"
	return ""


## S430 (operator on the corner bar: "do these affect anything , they take effect immediately or how they work ?"): what the
## setting in force does, in one short line for the bar, and the longer version for the hover.
const WHEN := "Counts from the next exchange and stays on until you change it."
const PACE_EFFECT := {"push": "Push: wins more, tires faster", "steady": "Steady: no gain, no cost",
	"save": "Save: gives ground, rests"}
const PACE_TIP := {
	"push": "Push now! More exchanges won and about a quarter more punches landed; the tank drains about a third faster. On an empty tank it backfires.",
	"steady": "Stay steady. The usual rhythm: nothing gained, nothing spent.",
	"save": "Take this one easy. Exchanges given away and about a quarter fewer punches landed; the tank drains much slower and the breath comes back."}


static func pace_effect(pace: String) -> String:
	return str(PACE_EFFECT.get(pace, ""))


static func pace_tip(pace: String) -> String:
	return "%s
%s" % [str(PACE_TIP.get(pace, "")), WHEN]


static func aim_effect(aim: String, opp: String) -> String:
	if aim == "head":
		return "Head: upstairs, easy to read"
	if aim == "body":
		return "Body: drains %s for later" % opp
	if aim == "left_ribs" or aim == "right_ribs":
		return "%s: hurt, hits harder" % ("Left ribs" if aim == "left_ribs" else "Right ribs")
	if aim == "head_hurt":
		return "The hurt head: hits harder"
	return "Own game: 1 in 5 to the body"


static func aim_tip(aim: String, opp: String) -> String:
	var t := "The usual game. About 1 punch in 5 goes to the body. Costs nothing."
	if aim == "head":
		t = "Head hunt. Nearly every punch goes upstairs. A named target is a little easier to read in every exchange."
	elif aim == "body":
		t = "Go to the body. Half the punches go downstairs; each one takes energy from %s for the rest of the fight. A named target is a little easier to read in every exchange." % opp
	elif aim == "left_ribs" or aim == "right_ribs":
		t = "The hurt ribs. More exchanges won and every punch there does about a third more damage."
	elif aim == "head_hurt":
		t = "Finish the head! %s is hurt there: more exchanges won and every punch there does about a third more damage." % opp
	return "%s
%s" % [t, WHEN]


static func offers(opp_hurt: Dictionary) -> Array:
	var out: Array = ["", "head", "body"]
	for place in _HURT_PLACES:
		if bool(opp_hurt.get(place, false)):
			if place == "left_ribs":
				out.append("left_ribs")
			elif place == "right_ribs":
				out.append("right_ribs")
			elif place == "head":
				out.append("head_hurt")
	return out


## S433: moved here from LiveRound (its 470-line cap, file_limits_test).
## AIMWIRE1: the opponent's hurt places and burn for PaceAim. A side's ribs are hurt when body shots on that side >= 4.
## S432 collect: the shots are NOT split 50/50 (two identical buttons): 60 % land on the liver side - the lead hook's side,
## the opponent's right ribs when she is orthodox, the left when she is southpaw - so that side hurts first and the corner's
## two rib calls mean different things. Burn: core from body shots (2.0 per shot), legs from energy drop (1.0 per point).
const RIB_HURT_AT := 4
const BURN_PER_BODY := 2.0
const BURN_PER_ENERGY := 1.0
const LIVER_SHARE := 0.6

static func opp_hurt(lv: Dictionary, stance: String = "orthodox") -> Dictionary:
	var bt: Dictionary = lv.get("body", {})
	var total := int(bt.get("b", 0))
	var liver := roundi(float(total) * LIVER_SHARE)
	var liver_side := "left_ribs" if stance.to_lower() == "southpaw" else "right_ribs"
	var other_side := "right_ribs" if liver_side == "left_ribs" else "left_ribs"
	return {"head": bool(lv.get("opp_hurt", false)), liver_side: liver >= RIB_HURT_AT, other_side: total - liver >= RIB_HURT_AT}

static func opp_burn(body_shots: int, opp_energy: float) -> Dictionary:
	return {"core": float(body_shots) * BURN_PER_BODY, "legs": (100.0 - opp_energy) * BURN_PER_ENERGY}


## S323 balance-check (tools/exchange_balance.gd: Push all fight won 0.88 vs Steady 0.67 - a dominant strategy; the tank
## it spent never came back to bite): pushing on an empty tank is sloppy work that walks onto counters. Push's edge fades
## from PUSH_GAS_FROM energy and turns against her by PUSH_GAS_ALL (PUSH_GAS off the edge there).
const PUSH_GAS_FROM := 55.0
const PUSH_GAS_ALL := 25.0
const PUSH_GAS := 12.0


static func push_gassed(pace: String, energy: float) -> float:
	if pace != "push":
		return 0.0
	return PUSH_GAS * clampf((PUSH_GAS_FROM - energy) / (PUSH_GAS_FROM - PUSH_GAS_ALL), 0.0, 1.0)
