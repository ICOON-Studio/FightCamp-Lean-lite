extends RefCounted
## FightLog (TASK FIGHTLOG1): the punch list of the fight analysis page.
## One line per punch beat, filters, counts, the live-log line. Pure static; no class_name; no preload.

## Punch moves the page shows. Each entry: [hand, punch, target].
const PUNCH := {
	"jab": ["lead", "jab", "head"],
	"cross": ["rear", "cross", "head"],
	"lead_hook": ["lead", "hook", "head"],
	"body_hook": ["lead", "hook", "body"],
	"rear_uppercut": ["rear", "uppercut", "head"],
	"lead_uppercut": ["lead", "uppercut", "head"],
	"rear_hook": ["rear", "hook", "head"],
	"body_cross": ["rear", "cross", "body"],
}

## After words the ringside camera can see (opponent only, seen true).
const AFTER_WORDS := {
	"guard_up": "guard up",
	"right_low": "right low",
	"left_low": "left low",
	"lunged": "lunged in",
	"stood": "stood still",
	"threw_on": "threw on",
}

## Range names indexed by place (Duels.PLACES: 0 long, 1 pocket, 2 inside).
const RANGE_WORDS := ["long", "mid", "inside"]


## One line per punch beat across all exchanges, in time order.
static func lines(exchanges: Array, round_n: int) -> Array:
	var raw: Array = []
	var idx: int = 0  # input order across ALL exchanges (ties keep it)
	for ex in exchanges:
		var ex_dict: Dictionary = ex
		var at: float = float(ex_dict.get("at", 0.0))
		var mode: String = str(ex_dict.get("mode", ""))
		var place: int = int(ex_dict.get("place", 0))
		var pinned: bool = bool(ex_dict.get("pinned", false))
		var ex_i: int = int(ex_dict.get("i", 0))
		var beats: Array = ex_dict.get("beats", [])
		for b in beats:
			var beat: Dictionary = b
			var move: String = str(beat.get("move", ""))
			if not PUNCH.has(move):
				idx += 1
				continue
			var result_raw: String = str(beat.get("result", ""))
			if result_raw == "none":
				idx += 1
				continue
			var def_raw: String = str(beat.get("def", ""))
			var who: String = str(beat.get("who", ""))
			var big: bool = bool(beat.get("big", false))
			var t_beat: float = float(beat.get("t", 0.0))
			var t_abs: float = at + t_beat
			var p_info: Array = PUNCH[move]
			var hand: String = str(p_info[0])
			var punch: String = str(p_info[1])
			var target: String = str(p_info[2])
			var res_word: String = _result_word(result_raw, def_raw, big)
			var range_word: String = _range_word(pinned, place)
			var after_word: String = _after_word(who, beat)
			var line := {
				"t": t_abs,
				"round": round_n,
				"who": who,
				"hand": hand,
				"punch": punch,
				"target": target,
				"result": res_word,
				"range": range_word,
				"after": after_word,
				"sit": mode,
				"ex": ex_i,
			}
			raw.append({"line": line, "t": t_abs, "idx": idx})
			idx += 1
	# Stable sort by t ascending (ties keep input order via idx).
	var n: int = raw.size()
	for i in range(1, n):
		var j: int = i
		while j > 0:
			var a_t: float = float(raw[j - 1]["t"])
			var b_t: float = float(raw[j]["t"])
			if a_t > b_t or (a_t == b_t and int(raw[j - 1]["idx"]) > int(raw[j]["idx"])):
				var tmp = raw[j]
				raw[j] = raw[j - 1]
				raw[j - 1] = tmp
				j -= 1
			else:
				break
	var out: Array = []
	for item in raw:
		out.append(item["line"])
	return out


## Format seconds as "m:ss" (floor the seconds).
static func clock(t: float) -> String:
	var total: int = int(floor(t))
	var m: int = total / 60
	var s: int = total % 60
	return "%d:%02d" % [m, s]


## The list's text for one line.
static func words(line: Dictionary) -> String:
	var t_str: String = clock(float(line["t"]))
	var hand: String = str(line["hand"])
	var punch: String = str(line["punch"])
	var target: String = str(line["target"])
	var result: String = str(line["result"])
	var after: String = str(line.get("after", ""))
	var base: String = "%s  %s %s to the %s - %s" % [t_str, hand, punch, target, result]
	if after != "":
		base += "  (" + after + ")"
	return base


## Filter lines by picks. Each key optional; "" or missing = any.
static func filter(all: Array, picks: Dictionary) -> Array:
	var out: Array = []
	for line in all:
		var l: Dictionary = line
		var corner: String = str(picks.get("corner", ""))
		if corner != "" and str(l["who"]) != corner:
			continue
		var hand: String = str(picks.get("hand", ""))
		if hand != "" and str(l["hand"]) != hand:
			continue
		var punch: String = str(picks.get("punch", ""))
		if punch != "" and str(l["punch"]) != punch:
			continue
		var target: String = str(picks.get("target", ""))
		if target != "" and str(l["target"]) != target:
			continue
		var result: String = str(picks.get("result", ""))
		if result != "" and str(l["result"]) != result:
			continue
		var range_val: String = str(picks.get("range", ""))
		if range_val != "" and str(l["range"]) != range_val:
			continue
		var round_val: int = int(picks.get("round", 0))
		if round_val != 0 and int(l["round"]) != round_val:
			continue
		var game: String = str(picks.get("game", ""))
		if game != "" and str(l["sit"]) != game:
			continue
		var after: String = str(picks.get("after", ""))
		if after != "" and str(l["after"]) != after:
			continue
		out.append(l)
	return out


## The count line: "<shown> lines of <all> - landed <L> of <shown>, clean <C>".
static func count_line(shown: Array, all: Array) -> String:
	var shown_n: int = shown.size()
	var all_n: int = all.size()
	var landed: int = 0
	var clean: int = 0
	for line in shown:
		var r: String = str(line["result"])
		if r == "Landed" or r == "Clean":
			landed += 1
		if r == "Clean":
			clean += 1
	return "%d lines of %d - landed %d of %d, clean %d" % [shown_n, all_n, landed, shown_n, clean]


## Camera-seen counts for an After filter over opponent lines (who "b").
static func seen_count(all: Array, when_punch: String, after: String) -> Dictionary:
	var k: int = 0
	var n: int = 0
	var k_other: int = 0
	var n_other: int = 0
	for line in all:
		var l: Dictionary = line
		if str(l["who"]) != "b":
			continue
		var p: String = str(l["punch"])
		var a: String = str(l["after"])
		if p == when_punch:
			n += 1
			if a == after:
				k += 1
		else:
			n_other += 1
			if a == after:
				k_other += 1
	return {"k": k, "n": n, "k_other": k_other, "n_other": n_other}


## The live log's line for one exchange.
static func exchange_line(rec: Dictionary, game_word: String) -> String:
	var t_str: String = clock(float(rec.get("at", 0.0)))
	var won: bool = bool(rec.get("won", false))
	var landed_arr: Array = rec.get("landed", [0, 0])
	var a_count: int = int(landed_arr[0])
	var b_count: int = int(landed_arr[1])
	var first: int
	var second: int
	if won:
		first = a_count
		second = b_count
	else:
		first = b_count
		second = a_count
	var who_word: String = "you won it" if won else "they won it"
	return "%s %s - %s, %d to %d" % [t_str, game_word, who_word, first, second]


## --- helpers ---

static func _result_word(result_raw: String, def_raw: String, big: bool) -> String:
	if result_raw == "lands":
		if big:
			return "Clean"
		return "Landed"
	if result_raw == "blocked" or def_raw == "block":
		return "Blocked"
	if result_raw == "misses":
		if def_raw == "slip" or def_raw == "weave" or def_raw == "pull":
			return "Slipped"
		return "Missed"
	return "Missed"


static func _range_word(pinned: bool, place: int) -> String:
	if pinned:
		return "ropes"
	var idx: int = clampi(place, 0, 2)
	return RANGE_WORDS[idx]


static func _after_word(who: String, beat: Dictionary) -> String:
	if who != "b":
		return ""
	var seen: bool = bool(beat.get("seen", false))
	if not seen:
		return ""
	var after_key: String = str(beat.get("after", ""))
	if after_key == "" or not AFTER_WORDS.has(after_key):
		return ""
	return str(AFTER_WORDS[after_key])
