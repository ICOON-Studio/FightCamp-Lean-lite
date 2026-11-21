extends RefCounted
## TURNPRO6 (S533) the chance the pro offer shows for each house's debut. It reads the SAME opponent the bout will have
## (DebutOpp.make, as Roster.turn_pro) through the same walk of the bout every other read uses (BoutRead.round_edges: the
## duels, both tanks, the plan) on the card a pro debut is scored on (4 rounds: CardOdds - a level card is a draw, and the
## stoppages' share is fitted on real bouts). The boxer is read as today, on the club's usual camp and rested for the
## night (the camp's taper); the weeks of training still to come are not counted, so the read errs low by a point or two.
## Measured against real bouts by tools/turn_gap_probe.gd; tests/debut_read_test.gd bounds it.
##   card(f, t, day, coach) -> {win, draw, loss, opp}     words(t) -> "a debutant rated 1.0 under"

const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")

const ROUNDS := 4   ## mirrors Roster.PRO_ROUNDS


## f = the boxer today; t = one house's terms (ProCall.terms: opp_gap, name); day = the signing day; coach = his rating.
static func card(f: Dictionary, t: Dictionary, day: int, coach: float) -> Dictionary:
	var opp := DebutOpp.make(f, float(t.get("opp_gap", 0.0)), day, str(t.get("name", "")))
	var fx := f.duplicate()
	fx["pro"] = true
	fx["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": ROUNDS}
	var out := BoutRead.CardOdds.result(BoutRead.round_edges(fx, opp, {"protocol": BoutRead.USUAL_CAMP}, coach), BoutRead.RingDuel.FORM_SD)
	out["opp"] = opp
	return out


## The opponent line in the offer's words: the gap either way, never a minus sign.
static func words(t: Dictionary) -> String:
	var g := float(t.get("opp_gap", 0.0))
	if absf(g) < 0.05:
		return "a debutant rated level"
	return "a debutant rated %.1f %s" % [absf(g), "under" if g > 0.0 else "over"]
