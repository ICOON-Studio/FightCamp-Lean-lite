extends RefCounted
## S470 LIVERRIBS1 step 4 (design map v2, rules 7 and 8): what a cracked rib asks of a corner.
##   YOUR boxer cracked (LiverFold._crack keeps bout.cracked.a): the corner minute carries a card, never pre-picked:
##     pull   -> retired on the stool ("RTD", a loss); the rib heals LiverRibs.HEAL_DAYS.pull days
##     defend -> the cracked side throws nothing (DEFEND_OUTPUT of her punches land); heals HEAL_DAYS.defend
##     fight  -> rule 6 as it stands (LiverRibs.CRACK_OUTPUT); heals HEAL_DAYS.fight, 1 in 10 WORSE_DAYS more
##   Nobody answers (SKIP BOUT, the coach's own calls) = fight. The injury after the bell is ALWAYS the cracked rib, with
##   the choice's days (Injuries.after_bout calls injury()).
##   The OPPONENT cracked: at each bell the other corner retires its boxer LiverRibs.corner_retires in 100 (more when
##   behind on rounds): "RTD_B", your boxer's win. Until then the round's lines say the corner is talking about it.
## Our fighter is side "a". Pure of screens: CrackStrip draws card().

const LiverRibs := preload("res://scripts/rules/LiverRibs.gd")

const KINDS := ["pull", "defend", "fight"]
## Defend the side: one hand of two is silent. ESTIMATE (the design's "0 punches from the cracked side").
const DEFEND_OUTPUT := 0.5
const STOP_B := "RTD_B"
## S471 rule 6's other half: the cracked side's guard. LiverRibs.CRACK_GUARD (-10) fighting through, DEFEND_GUARD (-4)
## when the corner said defend the side (the elbow stays home). A guard point is a defence point, and the fight's power
## is the mean of six stats (BoutRules.fight_power), so it reaches an exchange's edge divided by POWER_STATS.
const DEFEND_GUARD := -4.0
const POWER_STATS := 6.0


static func cracked(f: Dictionary, who: String) -> bool:
	return bool(((f.get("bout", {}) as Dictionary).get("cracked", {}) as Dictionary).get(who, false))


static func choice(f: Dictionary) -> String:
	return str((f.get("bout", {}) as Dictionary).get("crack_choice", ""))


## The corner minute's crack card: {comes, round, rows: [{kind, label, words}]}; {} when none is due (not cracked,
## already answered, no corner follows).
static func card(f: Dictionary, m: Dictionary, total: int) -> Dictionary:
	var rounds: Array = m.get("rounds", [])
	if rounds.is_empty() or rounds.size() >= total or str((rounds[-1] as Dictionary).get("stopped", "")) != "":
		return {}
	if not cracked(f, "a") or choice(f) != "":
		return {}
	var d: Dictionary = LiverRibs.HEAL_DAYS
	return {"comes": true, "round": rounds.size(), "rows": [
		{"kind": "pull", "label": "Pull your boxer out", "words": "A loss. Heals in %d days." % int(d["pull"]),
			"more": "Retired on the stool: the bout ends now as a loss."},
		{"kind": "defend", "label": "Defend the side", "words": "Half the punches land, side covered. Heals in %d days." % int(d["defend"]),
			"more": "Nothing is thrown from the cracked side for the rest of the bout."},
		{"kind": "fight", "label": "Fight through", "words": "That side at %d in 100. Heals in %d days (1 in 10: %d)." % [
			roundi(LiverRibs.CRACK_OUTPUT * 100.0), int(d["fight"]), int(d["fight"]) + LiverRibs.WORSE_DAYS],
			"more": "Both hands keep punching; the cracked side lands less. 1 time in 10 the rib gets worse."}]}


## The corner's answer ("" = none this minute). A pull retires her: BoutNight then opens no round.
static func answer(c, f: Dictionary, m: Dictionary, kind: String) -> void:
	if not KINDS.has(kind) or not cracked(f, "a") or choice(f) != "":
		return
	f["bout"]["crack_choice"] = kind
	if kind != "pull":
		return
	var r: Dictionary = (m["rounds"] as Array)[-1]
	r["stopped"] = "RTD"
	(r["lines"] as Array).append("Your corner retires your boxer on the stool: a cracked rib.")
	_book(c, f, int(LiverRibs.HEAL_DAYS["pull"]), "retired with a cracked rib")


## The edge a crack moves in every exchange (LiveRound adds it to her edge): her cracked side costs her, the opponent's
## cracked side pays her. 0.0 with no crack.
static func guard_edge(f: Dictionary) -> float:
	var e := 0.0
	if cracked(f, "a"):
		e += (DEFEND_GUARD if choice(f) == "defend" else LiverRibs.CRACK_GUARD) / POWER_STATS
	if cracked(f, "b"):
		e -= LiverRibs.CRACK_GUARD / POWER_STATS
	return e


## How much of a cracked side's punches land (LiveRound, rule 6): the choice decides.
static func output(f: Dictionary, who: String) -> float:
	return DEFEND_OUTPUT if who == "a" and choice(f) == "defend" else LiverRibs.CRACK_OUTPUT


## At a bell: does the OTHER corner retire its cracked boxer? True = the bout is over (the last round carries STOP_B).
## Rolled once a bell (m.crack_bell keeps the round), on its own dice.
static func bell(c, f: Dictionary, m: Dictionary, total: int) -> bool:
	var rounds: Array = m.get("rounds", [])
	if rounds.is_empty():
		return false
	var r: Dictionary = rounds[-1]
	if str(r.get("stopped", "")) != "":
		return str(r["stopped"]) == STOP_B
	if not cracked(f, "b") or rounds.size() >= total or int(m.get("crack_bell", 0)) >= rounds.size():
		return false
	m["crack_bell"] = rounds.size()
	var ours := rounds.filter(func(x): return bool(x["won"])).size()
	var rng := RandomNumberGenerator.new()
	rng.seed = int(c.day) * 131 + int(c.seed) * 7 + rounds.size() * 17 + 4470
	if rng.randf() < LiverRibs.corner_retires(true, ours * 2 > rounds.size()):
		r["stopped"] = STOP_B
		(r["lines"] as Array).append("The opponent's corner retires their boxer on the stool: a cracked rib.")
		return true
	(r["lines"] as Array).append("The opponent's corner is talking about stopping it: a cracked rib.")
	return false


## The injury a bout with a cracked rib leaves ({} = no crack, or the pull already booked it): always the cracked rib,
## the days by the corner's choice.
static func injury(f: Dictionary, m: Dictionary, roll: float) -> Dictionary:
	if not cracked(f, "a") or str(m.get("stopped", "")) == "RTD":
		return {}
	var kind := choice(f) if choice(f) != "" else "fight"
	return {"injured": true, "type": "ribs", "kind": "cracked", "days_out": LiverRibs.heal_days(kind, roll)}


static func _book(c, f: Dictionary, days: int, why: String) -> void:
	f["injury"] = {"type": "ribs", "kind": "cracked", "days_out": days, "until_day": int(c.day) + days, "choice": "", "why": why}
	f["next_offer_day"] = maxi(int(f.get("next_offer_day", 0)), int(c.day) + days)
