extends RefCounted
## S379 (operator on the fight's HEAD / LIVER / RIBS close-ups: "make these popout ... showing the region of the hit and a
## short summary of the organ condition"): the one line under a close-up - its name and value, what landed there in plain
## words, what that means for the fight. Pure static; at most MAX characters (the strip beside the body view is narrow).
##   line(name, value, entry, body, cut) -> String     entry = a BodyTip.log_hit entry {n, kinds {move: n}, big}
## e.g. "LIVER 50 - two body hooks, gas drains faster" is too long, so it reads "LIVER 50 - two hooks, gas drains faster".

const BM := preload("res://scripts/rules/BodyMap.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")

const MAX := 40
const COUNT := ["no", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
## Short punch words when the full ones (BodyTip.MOVE_WORDS) do not fit: at the ribs a hook is a body hook.
const SHORT := {"jab": ["jab", "jabs"], "cross": ["cross", "crosses"], "lead_hook": ["hook", "hooks"],
	"body_hook": ["hook", "hooks"], "rear_uppercut": ["uppercut", "uppercuts"]}
## What a band means. Every body shot costs gas for the rest of the fight (Exchanges.BODY_COST); at DOCTOR the doctor looks.
const BODY_WORDS := {"fine": "costs gas", "hurt": "gas drains faster", "critical": "badly hurt, gas going",
	"doctor": "doctor may stop it"}
const HEAD_WORDS := {"fine": "holding up", "hurt": "hurt", "critical": "badly hurt", "doctor": "doctor may stop it"}


static func line(name: String, value: float, entry: Dictionary, body: bool, cut: bool = false) -> String:
	var head := "%s %d" % [name, int(round(value))]
	var b := BM.band(value)
	var band: String = (BODY_WORDS if body else HEAD_WORDS)[b]
	# What it means, longest first: an open cut on a hurt face keeps the band words as long as they fit.
	var whats: Array = [band]
	if cut:
		whats = ["cut open"] if b == "fine" else ["cut open, " + band, "cut, " + band, band, "cut open"]
	var n := int(entry.get("n", 0))
	if n == 0:
		return _fit([head + " - nothing landed yet", head + " - " + str(whats[0]), head])
	var tries: Array = []
	for what in whats:
		for took in _took(entry):
			tries.append("%s - %s, %s" % [head, took, what])
	for what in whats:
		tries.append("%s - %s" % [head, what])
	tries.append(head)
	return _fit(tries)


## What landed, longest words first: "two big body hooks", "two body hooks", "two hooks"; several kinds: "five shots".
static func _took(entry: Dictionary) -> Array:
	var n := int(entry.get("n", 0))
	var kinds: Dictionary = entry.get("kinds", {})
	var big := int(entry.get("big", 0))
	var many := _count(n)
	var shots := "%s shot%s" % [many, "" if n == 1 else "s"]
	var only := ""
	for m in kinds:
		if int(kinds[m]) > 0:
			only = str(m) if only == "" else "+"
	if only == "" or only == "+" or not BodyTip.MOVE_WORDS.has(only):
		return ["%s, %s big" % [shots, _count(big)] if big > 0 else shots, shots]
	var k := 0 if n == 1 else 1
	var long: String = BodyTip.MOVE_WORDS[only][k]
	var short: String = SHORT[only][k]
	var out: Array = []
	if big > 0:
		out.append("%s %s%s" % [many, "big " if big == n else "", long] + ("" if big == n else ", %s big" % _count(big)))
	out.append("%s %s" % [many, long])
	out.append("%s %s" % [many, short])
	out.append(shots)
	return out


static func _count(n: int) -> String:
	return COUNT[n] if n >= 0 and n < COUNT.size() else str(n)


static func _fit(tries: Array) -> String:
	for t in tries:
		if str(t).length() <= MAX:
			return str(t)
	return str(tries[tries.size() - 1]).substr(0, MAX)
