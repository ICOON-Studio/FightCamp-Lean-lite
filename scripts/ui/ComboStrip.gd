extends RefCounted
## S370 the combo card strip (operator: "stitch moves like hollywood animal does for the films ... and display the combo
## strength/stamina cost", "use the moves and strikes as cards"). PLAYBOOK > Combos shows the chain as her move CARDS
## stitched left to right: each card her level with the move, when it lands, the gas it costs and the damage it does; each
## join between two cards judged by ComboFlow's own rules (what that move added, in the coach's words); under it the
## totals - STRENGTH (ComboFlow's score), GAS (share of a round), LANDS IN (BeatClips.IMPACT_S, the shipped punch timing),
## DAMAGE (BodyMap's hit sizes) and, for a book combination, how often it lands whole against her next opponent
## (ComboOdds). Every number is the game's own; nothing here is a new rule.
##   strip(fighter, chain, rated, entries, on_remove) -> HFlowContainer   totals(fighter, chain, rated, book_id) -> Control

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const CF := preload("res://scripts/rules/ComboFlow.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

const CARD_SIZE := Vector2(136, 176)
const KIND_COLOR := {"punch": Color("#2f6fdb"), "defence": Color("#4f8a2c"), "step": Color("#8a5a2a")}
const KIND_TINT := {"punch": Color("#eef4ff"), "defence": Color("#f1f6ea"), "step": Color("#f7f0e8")}
const TIER_COLOR := {"UNLEARNED": UI.MUTED, "RAW": UI.AMBER, "USABLE": UI.GOLD, "SHARP": UI.GREEN, "SIGNATURE": UI.PURPLE}


## The cards and the joins, wrapping onto a second line past four. `entries[id]` = ComboBuilder.PALETTE's row.
static func strip(f: Dictionary, chain: Array, rated: Dictionary, entries: Dictionary, on_remove: Callable) -> HFlowContainer:
	var flow := HFlowContainer.new()
	flow.name = "Strip"
	flow.add_theme_constant_override("h_separation", 4)
	flow.add_theme_constant_override("v_separation", 12)
	var steps: Array = rated.get("steps", [])
	for i in chain.size():
		var st: Dictionary = steps[i] if i < steps.size() else {}
		if i > 0:
			flow.add_child(_join(st))
		var c := _card(f, i, str(chain[i]), entries.get(str(chain[i]), {}), chain, st, on_remove)
		flow.add_child(c)
		if i == chain.size() - 1:
			c.modulate = Color(1, 1, 1, 0)
			c.create_tween().tween_property(c, "modulate", Color.WHITE, 0.25)
	return flow


## One move card: name, hand and target, her level with it, when it lands, its gas and its damage.
static func _card(f: Dictionary, i: int, id: String, e: Dictionary, chain: Array, st: Dictionary, on_remove: Callable) -> Control:
	var m: Dictionary = CF.MOVES.get(id, {})
	var kind := str(m.get("kind", "punch"))
	var p := PanelContainer.new()
	p.name = "Step_%d" % (i + 1)
	p.custom_minimum_size = CARD_SIZE
	p.add_theme_stylebox_override("panel", UI.box(KIND_TINT.get(kind, UI.PANEL), KIND_COLOR.get(kind, UI.LINE), 12, 3, 10, 8))
	var v := UI.vbox(3)
	p.add_child(v)
	var top := UI.hbox(4)
	top.add_child(UI.label(str(i + 1), UI.TINY, KIND_COLOR.get(kind, UI.FG), "bold"))
	top.add_child(UI.spacer())
	top.add_child(Icons.button("x", "Take it out", on_remove.bind(i), UI.MUTED, 16))
	v.add_child(top)
	v.add_child(UI.label(str(e.get("name", id)), UI.BODY + 3, UI.FG, "display"))
	var what: String = {"punch": "%s hand - %s" % [str(m.get("hand", "")), str(m.get("level", ""))], "defence": "defence",
		"step": "feet"}.get(kind, kind)
	v.add_child(UI.muted(what, UI.TINY))
	var needs := str(e.get("needs", ""))
	if needs != "":
		var lv := float((f.get("moves", {}) as Dictionary).get(needs, 0.0))
		var t := MoveMastery.tier(lv)
		var lab := UI.label("%s %d" % [t, int(lv)], UI.TINY, TIER_COLOR.get(t, UI.FG), "bold")
		lab.tooltip_text = "Mastery of the %s: %d. %s" % [needs.to_lower(), int(lv),
			"A weapon in a fight from %d." % int(Combos.LEARN_AT) if lv < Combos.LEARN_AT else "Ready to throw in a fight."]
		v.add_child(lab)
		if lv < Combos.LEARN_AT:
			# Not a weapon yet: the card stays in the strip to try, faded, with the way to learn it.
			p.modulate = Color(1, 1, 1, 0.78)
			v.add_child(Icons.tip(UI.chip("pad time first", "amber"),
				"Not a weapon yet (%d of %d): pad time first - Training, Pads with the coach" % [int(lv), int(Combos.LEARN_AT)]))
	else:
		v.add_child(UI.muted("any boxer", UI.TINY))
	if BeatClips.IMPACT_S.has(id):
		v.add_child(UI.label("lands %.2f s" % float(BeatClips.IMPACT_S[id]), UI.TINY))
	var gas := 100.0 * (CF.energy(chain.slice(0, i + 1)) - CF.energy(chain.slice(0, i))) / Combos.ROUND_COST
	v.add_child(UI.label("gas +%.1f%%" % gas, UI.TINY, UI.AMBER if gas >= 2.0 else UI.FG))
	var dmg := _damage([id])
	if dmg["head"] + dmg["ribs"] > 0.0:
		v.add_child(UI.label("hurts %s %.1f" % ["ribs" if dmg["ribs"] > 0.0 else "head", dmg["ribs"] + dmg["head"]], UI.TINY))
	if i == 0 and float(st.get("delta", 0.0)) < 0.0:
		v.add_child(Icons.tip(UI.chip("slow opener", "red"), " ".join(st.get("notes", []))))
	return p


## Between two cards: what the second one added to the chain, in ComboFlow's words.
static func _join(st: Dictionary) -> Control:
	var d := float(st.get("delta", 0.0))
	var col: Color = UI.GREEN if d > 0.0 else (UI.RED if d < 0.0 else UI.MUTED)
	var v := UI.vbox(0)
	v.name = "Join"
	v.custom_minimum_size = Vector2(78, CARD_SIZE.y)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	var arrow := UI.label("->", UI.BODY + 4, col, "bold")
	arrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(arrow)
	var score := UI.label(("+%d" % int(d)) if d > 0.0 else (str(int(d)) if d < 0.0 else "even"), UI.SMALL, col, "bold")
	score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(score)
	var notes: Array = st.get("notes", [])
	if not notes.is_empty():
		var words := UI.label(_short(str(notes[0])), UI.TINY - 2, col, "body", true)
		words.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		words.custom_minimum_size = Vector2(76, 0)
		words.tooltip_text = "\n".join(notes)
		words.mouse_filter = Control.MOUSE_FILTER_PASS
		v.add_child(words)
	return v


## The totals under the strip. Named "Verdict" (tests/combo_builder_test.gd reads its words).
static func totals(f: Dictionary, chain: Array, rated: Dictionary, bid: String) -> Control:
	var g := GridContainer.new()
	g.name = "Verdict"
	g.columns = 5
	g.add_theme_constant_override("h_separation", 10)
	var word := str(rated["word"])
	var col: Color = {"flows": UI.GREEN, "workable": UI.AMBER}.get(word, UI.RED)
	g.add_child(_tile("STRENGTH", "%d" % int(rated["score"]), word.to_upper() + " (70+ flows)", col,
		{"title": "Combination strength", "rows": [["Score", "%d / 100" % int(rated["score"]), "", ""], ["Flows at", "70", "", ""],
		["Workable at", "45", "", ""]], "means": "how well each punch sets up the next: the loaded hand on time, level changes, moving the head after. Each join on the strip shows its share."}))
	var gas := CF.energy(chain)
	var share := 100.0 * gas / Combos.ROUND_COST
	var tank := _tile("GAS", "%d%%" % maxi(1, int(round(share))), "of a round, each time", UI.AMBER if share >= 8.0 else UI.FG,
		{"title": "Gas tank", "rows": [["This chain", "%.2f" % gas, "", ""], ["A whole round", "%.0f" % Combos.ROUND_COST, "", ""],
		["Share", "%.0f%%" % share, "", "watch" if share >= 8.0 else ""]],
		"means": "each throw takes %.0f%% of what a whole round of fighting costs. Long chains tire sooner." % share})
	tank.name = "Tank"
	g.add_child(tank)
	var t := 0.0
	for id in chain:
		t += float(BeatClips.IMPACT_S.get(str(id), 0.0))
	g.add_child(_tile("LANDS IN", "%.1f s" % t, "first to last punch", UI.FG,
		{"title": "Speed", "rows": [], "means": "the time the punches take to land, one after another (shipped boxing games' median punch timing). The longer it runs, the longer the boxer stands there to be hit."}))
	var dmg := _damage(chain)
	g.add_child(_tile("DAMAGE", "%.1f" % (dmg["head"] + dmg["ribs"]), "head %.1f - ribs %.1f" % [dmg["head"], dmg["ribs"]], UI.FG,
		{"title": "Damage if it all lands", "rows": [["Head", "%.1f" % dmg["head"], "", ""], ["Ribs", "%.1f" % dmg["ribs"], "", ""]],
		"means": "what the punches take off the opponent's body map when every one lands (a big shot doubles it). Ribs drain the gas too."}))
	g.add_child(_odds_tile(f, bid))
	return g


static func _odds_tile(f: Dictionary, bid: String) -> Control:
	var bout: Dictionary = f.get("bout", {})
	var opp: Dictionary = bout.get("opp", {}) if not bout.is_empty() and not bool(bout.get("done", false)) else {}
	var who := (str(opp["first"]) if not opp.is_empty() else "AN EVEN OPPONENT").to_upper()
	var tbl: Dictionary = ComboOdds.table(bid, f, opp) if bid != "" else {}
	if tbl.is_empty():
		return _tile("VS " + who, "-", "book combinations only", UI.MUTED,
			{"title": "In the ring", "rows": [], "means": "the ring odds exist for the combinations in the book; start from one on the left to see how often it lands whole."})
	var best := 0.0
	for r in tbl["rows"]:
		if str(r["sit"]) == str(tbl["main"]):
			best = float(r["odds"])
	return _tile("VS " + who, "%d%%" % int(round(best * 100.0)), "lands whole in the opponent's main game", UI.GREEN if best > float(tbl["base"]) else UI.FG,
		{"title": "In the ring", "rows": [["This combination", "%d%%" % int(round(best * 100.0)), "", ""],
		["No combination", "%d%%" % int(round(float(tbl["base"]) * 100.0)), "", ""]],
		"means": "how often it lands whole in the opponent's main game, the fight's own dice. The table below has every game."})


static func _tile(caps: String, big: String, small: String, col: Color, tip: Dictionary) -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 12, 8))
	p.custom_minimum_size = Vector2(150, 0)
	var v := UI.vbox(2)
	p.add_child(v)
	v.add_child(UI.caps(caps))
	v.add_child(UI.label(big, UI.BODY + 10, col, "bold"))
	v.add_child(UI.muted(small, UI.TINY, true))
	Tips.card(p, func(): return tip)
	return p


## Head and rib damage if every punch lands (BodyMap's own hit sizes; head = nose, eyes and head).
static func _damage(chain: Array) -> Dictionary:
	var out := {"head": 0.0, "ribs": 0.0}
	for id in chain:
		for h in BodyMap._punch_hits({"move": str(id), "t": 0, "who": 0}, false):
			out["ribs" if str(h["place"]).ends_with("ribs") else "head"] += float(h["dmg"])
	return out


## ComboFlow's sentence cut at its dash: "Double jab — fast reset ..." -> "Double jab".
static func _short(s: String) -> String:
	for sep in [" — ", " - "]:
		if s.contains(sep):
			return s.get_slice(sep, 0)
	return s
