extends RefCounted
## R50TRAIT1 every trait's lines: what it does now, the next line, and an upside as well as a downside.
## Pure static table over the game's own corner rules. The five: coachability, heart, confidence, temper,
## discipline (FighterProfile.TRAITS less loyalty, which is the morale bar).
## Each row: {at, dir: "under"|"from", side: "up"|"down", word, does, source: "code"|"new"}.
## "code" rows are proved against CornerJobs.talk / PushBack in the test; "new" rows are new hooks.

const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const PushBack := preload("res://scripts/rules/PushBack.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")

const THE_FIVE: Array = ["coachability", "heart", "confidence", "temper", "discipline"]
## Direction of good work: up for most, down for temper (lower is better).
const GOOD_DIR: Dictionary = {
	"coachability": "up", "heart": "up", "confidence": "up", "temper": "down", "discipline": "up",
}

const LINES: Dictionary = {
	"coachability": [
		{"at": 40, "dir": "under", "side": "down", "word": "Stubborn", "does": "a corner habit fix holds half", "source": "new"},
		{"at": 70, "dir": "from", "side": "up", "word": "Listens", "does": "the round's third shout lands in full too", "source": "new"},
	],
	"confidence": [
		{"at": 45, "dir": "under", "side": "down", "word": "Fragile", "does": "the truth backfires: -2", "source": "code"},
		{"at": 45, "dir": "from", "side": "up", "word": "Confident", "does": "a hard talk never sinks the next round", "source": "code"},
		{"at": 50, "dir": "under", "side": "up", "word": "", "does": "Fire up lifts +2.0, not +1.5", "source": "code"},
	],
	"temper": [
		{"at": 65, "dir": "from", "side": "down", "word": "Short fuse", "does": "Fire up turns wild (-2, hurt x1.6)", "source": "code"},
		{"at": 65, "dir": "from", "side": "up", "word": "", "does": "Calm down works: +1", "source": "code"},
	],
	"discipline": [
		{"at": 45, "dir": "under", "side": "down", "word": "", "does": "skips 1 alone morning in 3", "source": "new"},
		{"at": 50, "dir": "under", "side": "down", "word": "Wanders off the plan", "does": "pushes back on a Hard week", "source": "code"},
		{"at": 60, "dir": "from", "side": "up", "word": "Disciplined", "does": "the truth works: +1.2, not +0.3", "source": "code"},
	],
	"heart": [
		{"at": -1, "dir": "from", "side": "up", "word": "", "does": "stays up: referee stop odds x(1.4 - heart / 100)", "source": "code"},
		{"at": -1, "dir": "from", "side": "down", "word": "", "does": "stays down sooner: (1 - heart / 100) x 0.7 after a bad count", "source": "code"},
	],
}


## The rows in force at value v. Under means v < at, from means v >= at; heart rows with at -1 always in force.
static func rows_now(trait_name: String, v: float) -> Array:
	var rows: Array = LINES.get(trait_name, [])
	var out: Array = []
	for r in rows:
		var row: Dictionary = r
		if _in_force(row, v):
			out.append(row)
	return out


## The brief's name for rows_now (`now` reads better at the call: TraitLine.now("heart", 60)).
static func now(trait_name: String, v: float) -> Array:
	return rows_now(trait_name, v)


## The strongest word in force (Recruit GOOD / BAD words where the trait matches; "" when none).
static func word(trait_name: String, v: float) -> String:
	var rows := rows_now(trait_name, v)
	for r in rows:
		var row: Dictionary = r
		var w: String = str(row["word"])
		if w != "":
			return w
	return ""


## The nearest line v has not crossed in the direction the trait grows with good work.
## up for coachability, confidence, discipline; DOWN for temper. Heart: {}.
## Returns {at, word, does, side, points}; {} when none is left.
static func next_line(trait_name: String, v: float) -> Dictionary:
	if trait_name == "heart":
		return {}
	var rows: Array = LINES.get(trait_name, [])
	var dir_up: bool = str(GOOD_DIR.get(trait_name, "up")) == "up"
	var best: Dictionary = {}
	var best_dist: float = 999.0
	for r in rows:
		var row: Dictionary = r
		var at: float = float(row["at"])
		if at < 0.0:
			continue
		var dist: float
		if dir_up:
			if at <= v:
				continue
			dist = at - v
		else:
			if at >= v:
				continue
			dist = v - at
		if dist < best_dist:
			best_dist = dist
			# S442 collect: `side` is what CROSSING the line brings. A row that comes into force keeps its own side; a row
			# that ends flips it (losing a downside is a gain, losing an upside is a loss). `ends` tells the screen which.
			var ends: bool = (str(row["dir"]) == "under") == dir_up
			var side: String = str(row["side"])
			if ends:
				side = "down" if side == "up" else "up"
			best = {"at": at, "word": str(row["word"]), "does": str(row["does"]),
				"side": side, "ends": ends, "points": roundi(dist)}
	return best


## The rows whose state changed between before and after, each with {row, now: "in force" / "gone"}.
static func crossed(trait_name: String, before: float, after: float) -> Array:
	var rows: Array = LINES.get(trait_name, [])
	var out: Array = []
	for r in rows:
		var row: Dictionary = r
		var was := _in_force(row, before)
		var after_in := _in_force(row, after)
		if was and not after_in:
			out.append({"row": row, "now": "gone"})
		elif not was and after_in:
			out.append({"row": row, "now": "in force"})
	return out


## The per-point effect for hover. Coachability: uptake in 100; heart: the two Knockdowns factors; others "".
static func hover(trait_name: String, v: float) -> String:
	match trait_name:
		"coachability":
			var u: float = Exchanges.uptake(v, 0)
			return "takes in %d in 100 of each full shout" % roundi(u * 100.0)
		"heart":
			var stop_f: float = 1.4 - v / 100.0
			var down_f: float = (1.0 - v / 100.0) * float(Knockdowns.KO_ODDS)
			return "referee's stop odds x%.2f; stays down after a bad count x%.2f" % [stop_f, down_f]
	return ""


## One row per trait for a fighter's personality Dictionary: {trait, value, word, next}.
static func card(p: Dictionary) -> Array:
	var out: Array = []
	for t in THE_FIVE:
		var v: float = float(p.get(t, 50.0))
		out.append({"trait": t, "value": v, "word": word(t, v), "next": next_line(t, v)})
	return out


## Is this row in force at value v?
static func _in_force(row: Dictionary, v: float) -> bool:
	var at: float = float(row["at"])
	if at < 0.0:
		return true
	if str(row["dir"]) == "under":
		return v < at
	return v >= at
