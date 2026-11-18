extends RefCounted
## S516 LADDERWIRE stage 2 (season ladder v6, ops/research/LADDERWIRE_SCOPE_S515.md; map DESIGN_LADDER1_V6_DOLA.md R2,
## R4, R6): the ladder lines on one Ask card - both sides' ladder points, the reach (a boxer too far above is greyed
## OUT OF REACH, "Needs N more points"), the price of the bout in points, and whether the other corner Leans Yes or
## Leans No, with the biggest reason in words. Never random: the lean is LadderRep.yes_score on facts the game holds.
## Inputs the game does not hold yet stay neutral: "protecting" (no rival bookings ahead are kept) and the hot streak.
##   lines(c, f, opp) -> {mine, theirs, askable, status, needs, points, price, lean, yes, reason}
## Pure on its inputs; reads the career, writes nothing.

const LadderRep := preload("res://scripts/rules/LadderRep.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const RivalOffer := preload("res://scripts/rules/RivalOffer.gd")
const HotStreak := preload("res://scripts/state/HotStreak.gd")

## The temperament words a rival club's corner can have (R6), picked by the club's name and the career seed.
const TEMPERS := ["careful", "normal", "bold"]

## The biggest reason, in the coach's words (R6 factor -> line; "yes" / "no" picks the side it pushed).
const REASON := {
	"odds": {"yes": "they fancy their chances", "no": "they rate your boxer too highly"},
	"protecting": {"yes": "", "no": "they are protecting a bout"},
	"hot_streak": {"yes": "they take it even with your boxer on a run", "no": "your boxer is on a run"},
	"idle": {"yes": "they have been out a while and want a bout", "no": ""},
	"last_meeting": {"yes": "they beat you last time", "no": "you beat them last time"},
	"temperament": {"yes": "a bold corner", "no": "a careful corner"},
	"base": {"yes": "nothing against it", "no": "nothing for it"},
	"owed": {"yes": "they owe you this bout", "no": ""},
}


static func lines(c: Variant, f: Dictionary, opp: Dictionary) -> Dictionary:
	var mine := RankLine.rep(f)
	var theirs := RankLine.rep(opp)
	var reach := LadderRep.in_reach(mine, theirs)
	var needs := maxi(0, theirs - mine - LadderRep.reach_up(mine))
	var g := LadderRep.grey({"out_of_reach": not reach})
	var pr := LadderRep.price(mine, theirs)
	var day := int(c.day)
	# S518 R6: the hot streak (HotStreak) and DUCKED / OWED. c is a Career in the game; a bare stand-in has no results.
	var career := c is Career
	var hot := career and HotStreak.hot(c, f)
	var ys := LadderRep.yes_score({
		"their_expected_pct": int(round(100.0 * LadderRep.expected(theirs, mine))),
		"protecting": false,
		"my_hot_streak": hot,
		"their_rank_above": theirs - mine,
		"their_idle_weeks": idle_weeks(opp, day),
		"last_meeting": last_meeting(opp, str(f.get("name", ""))),
		"temperament": temper(str(opp.get("club", "")), int(c.seed)),
	})
	var oname := str(opp.get("name", ""))
	var owed := career and HotStreak.is_owed(c, f, oname)
	var ducks := HotStreak.ducks_of(c, f, oname).size() if career else 0
	if owed:
		ys = RivalOffer.owed_answer(true, int(ys["score"]))
		ys["yes"] = true
		ys["biggest"] = "owed"
	var yes := bool(ys["yes"])
	var reason := str((REASON.get(str(ys["biggest"]), REASON["base"]) as Dictionary)["yes" if yes else "no"])
	if reason == "":
		reason = str(REASON["base"]["yes" if yes else "no"])
	var chip := "OWED - they ducked your boxer twice: they must say yes." if owed else \
		("DUCKED once - one more No in %d weeks and they owe you the bout." % RivalOffer.DUCK_WINDOW if ducks == 1 else "")
	return {"mine": mine, "theirs": theirs, "askable": bool(g["askable"]), "status": str(g["status"]), "needs": needs,
		"points": "Ladder points: yours %d, theirs %d." % [mine, theirs],
		"price": "Win +%d points, loss %d points." % [int(pr["rep_win"]), int(pr["rep_loss"])],
		"reach": "" if reach else "OUT OF REACH - needs %d more point%s." % [needs, "" if needs == 1 else "s"],
		"lean": ("Leans Yes - %s." if yes else "Leans No - %s.") % reason, "yes": yes, "reason": reason,
		"hot": hot, "owed": owed, "ducks": ducks, "chip": chip}


## Weeks since the rival's last bout (her record is newest first, RivalPast), 0 when she has none.
static func idle_weeks(opp: Dictionary, day: int) -> int:
	var b: Array = opp.get("bouts", [])
	if b.is_empty() or not (b[0] is Dictionary):
		return 0
	return maxi(0, int((day - int((b[0] as Dictionary).get("d", day))) / 7))


## "they_won" / "they_lost" from her newest bout against `name`, "" when they never met.
static func last_meeting(opp: Dictionary, name: String) -> String:
	for b in opp.get("bouts", []):
		if b is Dictionary and str(b.get("vs", "")) == name:
			return "they_won" if bool(b.get("win", false)) else "they_lost"
	return ""


static func temper(club: String, seed: int) -> String:
	return TEMPERS[absi(hash("%s|%d" % [club, seed])) % TEMPERS.size()]
