extends RefCounted
## S354 (operator on the reception's three week cards: "i do not even understand why am choosing those. get it more rpg
## elements to this"; Kalli KALLI_RECEPTION_RPG_S354.md): a new fighter read as an RPG recruit - a class from the style, a
## potential in stars (a range until the fighter is known), each attribute's ceiling, two visible traits from the
## personality (with the effect the game already gives them), one habit, a signature move, an ambition; and ONE starting
## focus that replaces the cards. Pure static; the fighter dict is a Data.fighter_state (personality/habits by id).
##   class_of(style)  stars(pot) -> [lo, hi]  ceiling(f, stat)  traits(personality) -> [good, bad]  signature(f)
##   ambition(f)  FOCUS  apply_focus(f, id, day) -> String (news line)  default_cards(style)

## style -> [strength, weakness, the stat it is built on, the stat it lacks].
const CLASSES := {
	"Out-boxer": ["wins at range", "struggles when walked down", "speed", "power"],
	"Pressure fighter": ["walks opponents down", "runs out of gas if the plan fails", "conditioning", "defense"],
	"Counter-puncher": ["punishes every mistake", "gives away quiet rounds", "fight_iq", "conditioning"],
	"Volume puncher": ["out-throws anyone", "light on power", "conditioning", "power"],
	"Boxer-puncher": ["does a bit of everything", "master of nothing yet", "technique", "chin"],
	"Slugger": ["one punch changes a fight", "easy to out-box", "power", "technique"],
}
## Each trait names the effect the game already gives that personality score (CornerJobs.talk, Exchanges.uptake, the
## knockdown sides in BoutNight).
const GOOD := {
	"heart": ["Big heart", "beats more standing counts; comes back after a bad round"],
	"discipline": ["Disciplined", "\"Tell the truth\" in the corner lifts the next round"],
	"confidence": ["Confident", "a hard talk never sinks the next round"],
	"coachability": ["Listens", "more of each shout from the corner reaches the ring"],
	"loyalty": ["Loyal", "stays through a bad run"],
}
const BAD := {
	"temper": ["Short fuse", "\"Fire up\" makes the fighter wild; \"Calm down\" works best"],
	"confidence": ["Fragile", "a hard talk sinks the next round"],
	"discipline": ["Wanders off the plan", "\"Tell the truth\" does little"],
	"coachability": ["Stubborn", "less of each shout reaches the ring"],
	"heart": ["Folds when hurt", "stays down sooner"],
}
const FOCUS := {
	"signature": {"name": "Sharpen the signature", "gain": "+10 mastery on the signature move now", "why": "Wins sooner with what already works.", "cost": "the habit stays", "short": "+10 mastery now"},
	"habit": {"name": "Fix the habit", "gain": "The habit is trained out in 4 weeks", "why": "Stops losing the same way.", "cost": "no sharper weapon", "short": "habit gone in 4 weeks"},
	"ceiling": {"name": "Raise the ceiling", "gain": "+5 potential on every attribute", "why": "The long game.", "cost": "nothing shows for a while", "short": "+5 potential"},
}
const HABIT_WEEKS := 4
const STAR_SPAN := 0.5


static func class_of(style: String) -> Array:
	return CLASSES.get(style, CLASSES["Boxer-puncher"])


## Potential 0-100 -> stars 1-5 as a range [lo, hi] half a star either side (a coach's guess); known = the exact value.
static func stars(pot: int, known: bool = false) -> Array:
	var s := clampf((float(pot) - 60.0) / 7.5 + 1.0, 1.0, 5.0)
	if known:
		return [snappedf(s, 0.5), snappedf(s, 0.5)]
	return [maxf(1.0, snappedf(s - STAR_SPAN, 0.5)), minf(5.0, snappedf(s + STAR_SPAN, 0.5))]


## How high an attribute can go: the potential, +6 on the class's strength, -6 on its gap, never under now + 2.
static func ceiling(f: Dictionary, stat: String) -> float:
	var c := class_of(str(f.get("style", "")))
	var bias := 6.0 if stat == str(c[2]) else (-6.0 if stat == str(c[3]) else 0.0)
	var now := float((f.get("stats", {}) as Dictionary).get(stat, 50.0))
	return clampf(float(f.get("pot", 70)) + bias, now + 2.0, 99.0)


## The two traits on show: the best personality score as a strength, the worst (or a high temper) as a flaw. [[name, effect]].
static func traits(p: Dictionary) -> Array:
	var best := "heart"
	for k in GOOD.keys():
		if float(p.get(k, 50.0)) > float(p.get(best, 50.0)):
			best = k
	var worst := "confidence"
	var worst_v := 101.0
	for k in BAD.keys():
		var v := 100.0 - float(p.get(k, 50.0)) if k == "temper" else float(p.get(k, 50.0))
		if k != best and v < worst_v:
			worst_v = v
			worst = k
	return [GOOD[best], BAD[worst]]


## The move already a weapon (mastery 30+) with the highest mastery, else the best move; "" without moves.
static func signature(f: Dictionary) -> String:
	var moves: Dictionary = f.get("moves", {})
	var best := ""
	for m in moves.keys():
		if best == "" or float(moves[m]) > float(moves[best]):
			best = str(m)
	return best


static func ambition(f: Dictionary) -> String:
	var bouts := int(f.get("w", 0)) + int(f.get("l", 0))
	if bouts == 0:
		return "A first win in front of a home crowd"
	return "A regional title within a year" if int(f.get("pot", 70)) >= 78 else "A winning record by the summer"


## The starting focus at signing. Returns the news line.
static func apply_focus(f: Dictionary, id: String, day: int) -> String:
	match id:
		"signature":
			var s := signature(f)
			if s != "":
				f["moves"][s] = minf(100.0, float(f["moves"][s]) + 10.0)
			return "%s starts on the %s: +10 mastery." % [f.get("first", "The new fighter"), s.to_lower()]
		"habit":
			var hs: Array = f.get("habits", [])
			if not hs.is_empty():
				f["habit_fix"] = {"id": str(hs[0]), "until": day + HABIT_WEEKS * 7}
			return "%s starts on a habit: gone in %d weeks." % [f.get("first", "The new fighter"), HABIT_WEEKS]
		"ceiling":
			f["pot"] = mini(99, int(f.get("pot", 70)) + 5)
			return "%s starts on the long game: potential +5." % f.get("first", "The new fighter")
	return ""


## The week cards the old screen picked (move sharpness keeps reading f["cards"]): the class's three.
static func default_cards(style: String) -> Array:
	match style:
		"Pressure fighter", "Volume puncher", "Slugger":
			return ["Body work", "Pad rounds", "Hill sprints"]
		"Counter-puncher":
			return ["Defence drills", "Pad rounds", "Film study"]
	return ["Jab and move", "Pad rounds", "Hill sprints"]
