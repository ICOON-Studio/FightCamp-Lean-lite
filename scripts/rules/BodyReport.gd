extends RefCounted
## The body report after each bout: which part went first, what to train next,
## and how this fight compared to the last. Pure static module, ZERO preloads.

const PARTS := ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs"]
const WENT_AT := 50.0
const NAMES := {"lead_shoulder": "jab shoulder", "rear_shoulder": "power shoulder", "lead_arm": "jab arm",
	"rear_arm": "power arm", "core": "body", "legs": "legs"}
const FOCUS := {"lead_shoulder": "technique", "lead_arm": "technique", "rear_shoulder": "power", "rear_arm": "power",
	"core": "conditioning", "legs": "conditioning"}
const FOCUS_LABEL := {"technique": "Technique", "power": "Power", "conditioning": "Conditioning"}


## The first part to reach WENT_AT: {"part": key, "round": 1-based round}. Within one round, the part with the highest
## burn wins (ties: the earlier key in PARTS). {} when no part ever reaches WENT_AT.
static func first_went(rounds: Array) -> Dictionary:
	var best_part: String = ""
	var best_burn: float = -1.0
	var best_round: int = -1
	for i in range(rounds.size()):
		var r: Dictionary = rounds[i]
		var round_best_part: String = ""
		var round_best_burn: float = -1.0
		for p in PARTS:
			var v: float = float(r.get(p, 0.0))
			if v >= WENT_AT and v > round_best_burn:
				round_best_part = p
				round_best_burn = v
		if round_best_part != "":
			if best_part == "" or round_best_burn > best_burn:
				best_part = round_best_part
				best_burn = round_best_burn
				best_round = i + 1
			break
	if best_part == "":
		return {}
	return {"part": best_part, "round": best_round}


## The part with the highest burn at the last bell ("" for no rounds; ties: earlier key in PARTS).
static func worst_at_end(rounds: Array) -> String:
	if rounds.is_empty():
		return ""
	var last: Dictionary = rounds[rounds.size() - 1]
	var best: String = PARTS[0]
	var best_v: float = float(last.get(PARTS[0], 0.0))
	for i in range(1, PARTS.size()):
		var p: String = PARTS[i]
		var v: float = float(last.get(p, 0.0))
		if v > best_v:
			best = p
			best_v = v
	return best


## The report for one fighter.
static func report(rounds: Array, who: String) -> Dictionary:
	var fw: Dictionary = first_went(rounds)
	if fw.is_empty():
		var n: int = rounds.size()
		var rounds_word: String = "round" if n == 1 else "rounds"
		return {"part": "", "round": 0, "focus": "",
			"line": "%s held up for all %d %s" % [who, n, rounds_word], "advice": ""}
	var part: String = str(fw["part"])
	var round_num: int = int(fw["round"])
	var focus: String = str(FOCUS[part])
	return {"part": part, "round": round_num, "focus": focus,
		"line": "%s's %s went in round %d" % [who, NAMES[part], round_num],
		"advice": "Next week: %s" % FOCUS_LABEL[focus]}


## The difference to her last bout's report, for the next result page.
static func change_line(last: Dictionary, now: Dictionary) -> String:
	var last_part: String = str(last.get("part", ""))
	var now_part: String = str(now.get("part", ""))
	var last_round: float = float(last.get("round", 0))
	var now_round: float = float(now.get("round", 0))
	if last_part == "":
		return ""
	var name: String = NAMES[last_part]
	var pro: String = "they" if last_part == "legs" else "it"
	if now_part == "":
		return "The %s held up this time (%s went in round %d last fight)" % [name, pro, int(last_round)]
	if now_part != last_part:
		return ""
	if now_round > last_round:
		return "The %s held until round %d this time (round %d last fight)" % [name, int(now_round), int(last_round)]
	if now_round == last_round:
		return "The %s went in round %d again" % [name, int(now_round)]
	return "The %s went sooner: round %d (round %d last fight)" % [name, int(now_round), int(last_round)]
