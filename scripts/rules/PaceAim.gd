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
		return "Her left ribs!"
	if aim == "right_ribs":
		return "Her right ribs!"
	if aim == "head_hurt":
		return "Finish the head!"
	return ""


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
