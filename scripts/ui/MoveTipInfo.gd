extends RefCounted
## S382 MOVETIP1 what the hover card (MoveTip) says - pure, split out of the card (round 2) so each file stays readable:
##   MoveTipInfo.info(move_id, fighter) -> {id, sport, name, tier, beats, glyphs, clips, sm, pic, glyph, gas, starts, leads,
##       lines}   move_id = a StrikeMap move, a ComboFlow move, a Data move name, a book combination or a syllabus move.

const SM := preload("res://scripts/rules/StrikeMap.gd")
const CF := preload("res://scripts/rules/ComboFlow.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjSteps := preload("res://scripts/rules/BjjSteps.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
## ComboBuilder preloads the card, so its palette is loaded at run time (no preload cycle).
const BUILDER := "res://scripts/ui/ComboBuilder.gd"
const MAX_LINKS := 3
const KIND_GLYPH := {"punch": "hand-fist", "defence": "shield", "step": "footprints"}


## "bjj" for a syllabus move (or the BJJ athlete's card), else "box" - cheap, for the card's warm-up.
static func sport(id: String, f: Dictionary) -> String:
	return "bjj" if str(f.get("sport", "")) == "bjj" or NoGi.NAMES.has(id) or BjjSteps.STEPS.has(id) else "box"


static func info(id: String, f: Dictionary) -> Dictionary:
	var d := {"id": id, "sport": "box", "name": id, "tier": "", "beats": [], "glyphs": [], "clips": [], "sm": "", "pic": id,
		"glyph": "hand-fist", "gas": 0.0, "starts": [], "leads": [], "lines": []}
	if sport(id, f) == "bjj":
		return _bjj(id, f, d)
	var moves: Dictionary = f.get("moves", {})
	var pal := _pal_id(id)
	var sm := SM.move(id)
	var combo := ""
	if not sm.is_empty():
		d["sm"] = id
		d["name"] = str(sm["name"])
		d["clips"] = MoveClips.clips(id)
		combo = str(sm["combo"])
		var kind := str(sm["kind"])
		d["beats"] = (Combos.row(combo).get("beats", []) as Array).duplicate() if combo != "" else ([id] if CF.MOVES.has(id) else [])
		d["glyph"] = "hand-fist" if kind == "combo" else ("shield" if kind == "defence" else "footprints")
		d["tier"] = "forced on you" if kind == "forced" else ("usable" if combo == "" else _combo_tier(f, combo))
	elif pal != "":
		var e := _entry(pal)
		d["name"] = str(e["name"])
		d["pic"] = pal
		d["beats"] = [pal]
		d["clips"] = [str(e["clip"])] if str(e.get("clip", "")) != "" else []
		d["glyph"] = KIND_GLYPH.get(str((CF.MOVES.get(pal, {}) as Dictionary).get("kind", "punch")), "hand-fist")
		var needs := str(e.get("needs", ""))
		d["tier"] = "usable" if needs == "" else MoveMastery.word(float(moves.get(needs, 0.0))).to_lower()
		if needs != "" and float(moves.get(needs, 0.0)) < Combos.LEARN_AT:
			d["lines"].append("Not usable yet (mastery %d of %d): pad time first." % [int(moves.get(needs, 0.0)), int(Combos.LEARN_AT)])
	elif not Combos.row(id).is_empty():
		combo = id
		d["beats"] = (Combos.row(id)["beats"] as Array).duplicate()
		d["clips"] = MoveClips.clips(id)
		d["tier"] = _combo_tier(f, id)
	else:   # a move with no film (the check hook): its name and her level, the ink card
		d["name"] = id
		d["tier"] = MoveMastery.word(float(moves.get(id, 0.0))).to_lower() if moves.has(id) else ""
		d["pic"] = id.to_lower().replace(" ", "_")
	var beats: Array = d["beats"]
	for b in beats:
		var e := _entry(str(b))
		d["glyphs"].append([KIND_GLYPH.get(str((CF.MOVES.get(str(b), {}) as Dictionary).get("kind", "punch")), "hand-fist"),
			str(e.get("name", str(b).capitalize()))])
	if beats.is_empty():
		d["glyphs"].append([d["glyph"], str(d["name"])])
	else:
		d["gas"] = 100.0 * CF.energy(beats, SkillAwards.economy_ids(f)) / Combos.ROUND_COST
		var l := links(beats)
		d["starts"] = l[0]
		d["leads"] = l[1]
	_box_lines(d, f, combo, sm)
	return d


## ComboFlow's joins: the moves that score best in front of the chain and after it ([starts, leads], names, best first).
static func links(beats: Array) -> Array:
	var base := float(CF.rate(beats)["score"])
	var before: Array = []
	var after: Array = []
	for e in _palette():
		var x := str(e["id"])
		before.append([float(CF.rate([x] + beats)["score"]) - base, str(e["name"])])
		after.append([float(CF.rate(beats + [x])["score"]) - base, str(e["name"])])
	return [_best(before), _best(after)]


static func _best(rows: Array) -> Array:
	var good := rows.filter(func(r): return float(r[0]) > 0.0)
	good.sort_custom(func(a, b): return float(a[0]) > float(b[0]))
	return good.slice(0, MAX_LINKS).map(func(r): return str(r[1]))


## At most two lines, numbers only: how often it lands whole (a book combination), how fast the first punch lands, where
## it is thrown and where it leaves her (a map move) or what it loads (a single punch).
static func _box_lines(d: Dictionary, f: Dictionary, combo: String, sm: Dictionary) -> void:
	var lines: Array = d["lines"]
	if combo != "":
		# S408 operator: "you do not show how you unlock it".
		var known: Dictionary = f.get("moves", {})
		var to_learn: Array = []
		for m in Combos.missing(combo, known):
			to_learn.append("%s to %d (now %d)" % [m, int(Combos.LEARN_AT), int(float(known.get(str(m), 0.0)))])
		if not to_learn.is_empty():
			lines.append("To unlock: train %s on the pads." % ", ".join(to_learn))
		var bout: Dictionary = f.get("bout", {})
		var opp: Dictionary = bout.get("opp", {}) if not bout.is_empty() and not bool(bout.get("done", false)) else {}
		var t := ComboOdds.table(combo, f, opp)
		if not t.is_empty():
			var best: Dictionary = (t["rows"] as Array)[0]
			for r in t["rows"]:
				if float(r["odds"]) > float(best["odds"]):
					best = r
			lines.append("Lands whole %d%% vs %s (%s) - %d%% with no combination." % [roundi(float(best["odds"]) * 100.0),
				"an even opponent" if opp.is_empty() else str(opp.get("first", "the opponent")), str(best["label"]).to_lower(),
				roundi(float(t["base"]) * 100.0)])
	var first := ""
	var punches := 0
	for b in d["beats"]:
		if BeatClips.IMPACT_S.has(str(b)):
			punches += 1
			if first == "":
				first = str(b)
	if lines.size() < 2 and first != "":
		lines.append(("First punch lands in %.2f s" % float(BeatClips.IMPACT_S[first])) + (" - %d punches." % punches if punches > 1 else "."))
	if lines.size() < 2 and not sm.is_empty():
		lines.append("Thrown at %s, ends at %s." % [str(SM.card(str(sm["from"])).get("name", "")).to_lower(),
			str(SM.card(str(sm["to"])).get("name", "")).to_lower()])
	if lines.size() < 2 and (d["beats"] as Array).size() == 1:
		var loads := str((CF.MOVES.get(str(d["beats"][0]), {}) as Dictionary).get("loads", ""))
		if loads != "":
			lines.append("Loads the %s hand for the next shot." % loads)
	d["lines"] = lines.slice(0, 2)


static func _combo_tier(f: Dictionary, combo: String) -> String:
	if not Combos.missing(combo, f.get("moves", {})).is_empty():
		return "locked"
	var v := float((f.get("combos", {}) as Dictionary).get(combo, 0.0))
	return MoveMastery.word(v).to_lower()


## A syllabus move: her level (learning / owned / signature, the mat book's words), the coach's first and last step.
static func _bjj(id: String, f: Dictionary, d: Dictionary) -> Dictionary:
	d["sport"] = "bjj"
	d["name"] = BjjTree.move_name(id)
	d["glyph"] = "user"
	# S384 GAMETREE1: the tree's mastery (a syllabus move's f["bjj"], a tree move's class time + drilling) and its step -
	# learning, felt (15, tried in rolling), owned, signature.
	var lvl := BjjTree.mastery(f, id)
	d["tier"] = BjjTree.state(lvl)
	var steps: Array = BjjSteps.steps(id)
	for s in steps:
		d["glyphs"].append(["user", str(s).get_slice(",", 0).get_slice(":", 0)])
	d["glyphs"] = (d["glyphs"] as Array).slice(0, 5)   # the coach's steps are its chain (no ComboFlow joins on the mat)
	var group := ""
	for g in NoGi.groups_of(f):
		if (g[1] as Array).has(id):
			group = str(g[0])
	d["lines"] = ["Level %d of %d - felt at %d, owned at %d." % [int(lvl), int(NoGi.SIGNATURE), int(BjjTree.T["FELT"]), int(BeltRoad.OWNED_AT)]]
	if group != "":
		d["lines"].append("%s, %d coach's steps." % [group, steps.size()])
	return d


static func _palette() -> Array:
	return load(BUILDER).PALETTE


static func _entry(id: String) -> Dictionary:
	for e in _palette():
		if str(e["id"]) == id:
			return e
	return {}


## A ComboFlow id itself, or the palette move a Data move name ("Lead hook") is.
static func _pal_id(id: String) -> String:
	for e in _palette():
		if str(e["id"]) == id or str(e["needs"]) == id:
			return str(e["id"])
	return ""
