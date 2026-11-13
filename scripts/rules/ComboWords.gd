extends RefCounted
## S303 combo words (Kalli K-COMBOWORDS1, assets/data/combo_words.json): the coach while she drills a combination, the ring
## caption when a SIGNATURE combination lands whole or she is too tired to finish one, and the corner's energy line.
## Picks are fixed by a seed, so a replay agrees. Pure static; zero preloads.

const PATH := "res://assets/data/combo_words.json"
## MoveMastery SIGNATURE tier.
const SIGNATURE_AT := 85.0
## Energy bands of the corner line (Combos.FRESH_AT / Combos.TIRED_AT).
const FRESH_AT := 70.0
const EMPTY_AT := 20.0

static var _bank: Dictionary = {}


static func bank() -> Dictionary:
	if _bank.is_empty():
		_bank = {"combos": [], "energy_lines": {}}
		if FileAccess.file_exists(PATH):
			var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
			if parsed is Dictionary and (parsed as Dictionary).has("combos"):
				_bank = parsed
	return _bank


## kind: coach_learning / coach_signature / ring_lands / ring_tired; "" when the bank has none.
static func line(id: String, kind: String, name: String, seed_value: int) -> String:
	for c in bank().get("combos", []):
		if str(c.get("id", "")) == id:
			var pool: Array = c.get(kind, [])
			if pool.is_empty():
				return ""
			return fill(str(pool[absi(seed_value) % pool.size()]), name)
	return ""


static func band(energy: float) -> String:
	if energy >= FRESH_AT:
		return "fresh"
	return "tiring" if energy >= EMPTY_AT else "empty"


static func energy_line(energy: float, name: String, seed_value: int) -> String:
	var pool: Array = (bank().get("energy_lines", {}) as Dictionary).get(band(energy), [])
	if pool.is_empty():
		return ""
	return fill(str(pool[absi(seed_value) % pool.size()]), name)


## {name} filled; a lower-case role ("your boxer") that opens a sentence is capitalised (S448: the fight says roles).
static func fill(text: String, name: String) -> String:
	var out := text
	var i := out.find("{name}")
	while i >= 0:
		var w := name
		var j := i - 1
		while j >= 0 and out[j] == " ":
			j -= 1
		if j < 0 or out[j] in [".", "!", "?", "\""]:
			w = w.left(1).to_upper() + w.substr(1)
		out = out.substr(0, i) + w + out.substr(i + 6)
		i = out.find("{name}", i + w.length())
	return out


## Captions the round's combination runs (RoundScript beats carry combo_id; combo_cut on a run she left unfinished):
## a cut run -> ring_tired, a whole run that all lands with her mastery at SIGNATURE -> ring_lands. Once per side and kind
## a round, never over a caption already there. _names = [ours, theirs] (S448: the captions say "your boxer" / "the
## opponent", never the names); masteries = {"a": {id: m}, "b": {id: m}}.
static func caption(beats: Array, masteries: Dictionary, _names: Array, seed_value: int) -> void:
	var said := {}
	var i := 0
	while i < beats.size():
		var b: Dictionary = beats[i]
		var cid := str(b.get("combo_id", ""))
		if cid == "":
			i += 1
			continue
		var j := i
		while j + 1 < beats.size() and str(beats[j + 1].get("combo_id", "")) == cid and str(beats[j + 1]["who"]) == str(b["who"]):
			j += 1
		var who := str(b["who"])
		var last: Dictionary = beats[j]
		var kind := ""
		if bool(last.get("combo_cut", false)):
			kind = "ring_tired"
		else:
			var all_land := true
			for k in range(i, j + 1):
				if str(beats[k]["result"]) != "lands":
					all_land = false
			var m := float((masteries.get(who, {}) as Dictionary).get(cid, 0.0))
			if all_land and j > i and m >= SIGNATURE_AT:
				kind = "ring_lands"
		if kind != "" and not said.has(who + kind) and str(last.get("caption", "")) == "":
			var text := line(cid, kind, "your boxer" if who == "a" else "the opponent", seed_value + i)
			if text != "":
				last["caption"] = text
				said[who + kind] = true
		i = j + 1
