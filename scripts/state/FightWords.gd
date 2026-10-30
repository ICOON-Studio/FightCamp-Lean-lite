extends RefCounted
## Fight night in words: three lines a round (opener, key moment, close) picked from a bank by opponent style, who won the
## round and the corner call before it. The bank is assets/data/fight_words.json when present (schema: Godot/research/
## TASK_K_FIGHTWORDS1.md in the old repo), else the prototype's lines below. Picks are fixed by a seed, so a replay agrees.

const PATH := "res://assets/data/fight_words.json"

const FALLBACK := {
	"opener": {"*": {"her": ["{her}'s jab finds {opp} early."], "their": ["{opp} walks her down."]}},
	"moment": {"*": {
		"her": {"none": ["{her} slips the {threat} and answers."], "long": ["{her} stays long and the jab keeps {opp} off her."],
			"body": ["{her} digs two hooks to the body. {opp} bends."], "calm": ["{her} breathes, sets her feet and picks her shots."]},
		"their": {"none": ["The {threat} lands twice."], "long": ["{opp} cuts the ring off; the jab finds only gloves."],
			"body": ["{her} goes to the body and walks onto the {threat}."], "calm": ["Calm is not enough: the {threat} lands twice."]},
	}},
	"close": {"her": ["Round to the red corner."], "their": ["Round to the blue corner."]},
}

static var _bank: Dictionary = {}


static func bank() -> Dictionary:
	if _bank.is_empty():
		_bank = FALLBACK
		if FileAccess.file_exists(PATH):
			var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
			if parsed is Dictionary and (parsed as Dictionary).has("opener"):
				_bank = parsed
	return _bank


## The three lines of one round. style e.g. "Pressure fighter"; corner "" for round 1.
static func round_lines(style: String, won: bool, corner: String, subs: Dictionary, seed_value: int) -> Array:
	var b := bank()
	var side := "her" if won else "their"
	var call := corner if corner != "" else "none"
	var opener: Array = _by_style(b["opener"], style).get(side, [])
	var moment: Array = (_by_style(b["moment"], style).get(side, {}) as Dictionary).get(call, [])
	var close: Array = (b["close"] as Dictionary).get(side, [])
	var out: Array = []
	var i := 0
	for pool in [opener, moment, close]:
		if pool.is_empty():
			continue
		out.append(fill(str(pool[absi(seed_value + i * 7) % pool.size()]), subs))
		i += 1
	return out


static func _by_style(section: Dictionary, style: String) -> Dictionary:
	if section.has(style):
		return section[style]
	if section.has("*"):
		return section["*"]
	return section.values()[0] if not section.is_empty() else {}


static func fill(line: String, subs: Dictionary) -> String:
	for k in subs.keys():
		line = line.replace("{%s}" % k, str(subs[k]))
	return line
