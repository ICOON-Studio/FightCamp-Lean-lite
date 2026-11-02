extends HBoxContainer
## S349 PLAYBOOK > Combos (Q-S294-71 build step 3; his "Build a smart combination" sheet; C201 on the flow: "make it look
## like a game, give the players a list with optional moves etc to try things like combos"). Left: MOVES TO TRY - her
## punches, defences and steps, and her book's combinations as one-click starts. Middle: the chain as numbered rows (the
## move, the coach's one-line cue), ComboFlow's verdict and its key lessons, Save to her book, Drill it on the pads when it
## is a book combination. Right: her own body throws the chain on a loop (MovePlayer.show_chain), the partner a ghost.
##   ComboBuilder.make(main, fighter) -> HBoxContainer

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const CF := preload("res://scripts/rules/ComboFlow.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const SCRIPT_PATH := "res://scripts/ui/ComboBuilder.gd"

## The moves she can chain: ComboFlow id, name, the clip her body plays, the move she must master (Data.MOVES; "" = none),
## the icon, and the coach's cue. ComboFlow's lead uppercut and rear hook have no clip and are not in her move set yet.
const PALETTE: Array[Dictionary] = [
	{"id": "jab", "name": "Jab", "clip": "pro_left_jab", "needs": "Jab", "icon": "hand-fist",
		"cue": "snap it out from the chin and back to the chin"},
	{"id": "cross", "name": "Cross", "clip": "pro_right_cross", "needs": "Cross", "icon": "hand-fist",
		"cue": "turn the back foot, hip through, chin behind the shoulder"},
	{"id": "lead_hook", "name": "Lead hook", "clip": "pro_left_hook", "needs": "Lead hook", "icon": "hand-fist",
		"cue": "elbow level with the fist, turn on the lead foot"},
	{"id": "body_hook", "name": "Body hook", "clip": "body_hook", "needs": "Body hook", "icon": "hand-fist",
		"cue": "dip the knees, not the head; dig under the elbow"},
	{"id": "rear_uppercut", "name": "Uppercut", "clip": "pro_right_uppercut", "needs": "Uppercut", "icon": "hand-fist",
		"cue": "drop the rear shoulder a touch, drive up from the legs"},
	{"id": "slip", "name": "Slip", "clip": "slip", "needs": "", "icon": "shield",
		"cue": "a small move off the centre line, eyes up"},
	{"id": "roll", "name": "Roll", "clip": "pro_left_weave", "needs": "", "icon": "shield",
		"cue": "bend the knees, roll under the hook, come up loaded"},
	{"id": "pivot", "name": "Pivot", "clip": "strafe_right", "needs": "", "icon": "refresh-cw",
		"cue": "lead foot is the hinge, swing the back foot out of line"},
	{"id": "step_in", "name": "Step in", "clip": "advance", "needs": "", "icon": "footprints",
		"cue": "lead foot first, behind the jab"},
	{"id": "step_back", "name": "Step back", "clip": "retreat", "needs": "", "icon": "footprints",
		"cue": "back foot first, the guard stays up"},
]
const MAX_MOVES := 8
const PLAYER_SIZE := Vector2(520, 560)
const PARTNER := {"name": "Maria Ortega"}

static var chain: Array = []   # the chain being built, kept while the page re-renders

var main: Node
var f: Dictionary
var player: Control
var _rows: VBoxContainer


static func make(m: Node, fighter: Dictionary) -> HBoxContainer:
	var b: HBoxContainer = load(SCRIPT_PATH).new()
	b.build(m, fighter)
	return b


static func entry(id: String) -> Dictionary:
	for p in PALETTE:
		if p["id"] == id:
			return p
	return {}


## "" when she can throw it in a fight, else why not (her mastery of that punch under Combos.LEARN_AT).
static func locked_why(fighter: Dictionary, id: String) -> String:
	var needs := str(entry(id).get("needs", ""))
	if needs == "":
		return ""
	var m := float((fighter.get("moves", {}) as Dictionary).get(needs, 0.0))
	if m >= Combos.LEARN_AT:
		return ""
	return "Not a weapon yet (%d of %d): pad time first - Training, Pads with the coach" % [int(m), int(Combos.LEARN_AT)]


## The book combination this chain is, by its beats ("" when it is her own).
static func book_id(c: Array) -> String:
	for row in Combos.BOOK:
		if (row["beats"] as Array) == c:
			return str(row["id"])
	return ""


func build(m: Node, fighter: Dictionary) -> void:
	main = m
	f = fighter
	name = "ComboBuilder"
	add_theme_constant_override("separation", 16)
	add_child(_palette())
	var mid := PanelContainer.new()
	mid.theme_type_variation = "Card"
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_rows = UI.vbox(8)
	_rows.name = "Chain"
	mid.add_child(_rows)
	add_child(mid)
	var col := UI.vbox(8)
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 12, 1, 6, 6))
	player = MovePlayer.new()
	player.name = "MovePlayer"
	var pair: Array = Faces.pair(f, PARTNER)
	player.bodies = [Faces.glb(pair[0]), Faces.glb(pair[1])]
	player.custom_minimum_size = PLAYER_SIZE
	card.add_child(player)
	col.add_child(card)
	col.add_child(UI.muted("Your fighter throws the chain on a loop; the partner is a ghost.", UI.SMALL, true))
	add_child(col)
	_refresh(false)


## MOVES TO TRY: each move adds itself to the chain; her book's combinations start one.
func _palette() -> Control:
	var p := PanelContainer.new()
	p.theme_type_variation = "Card"
	p.custom_minimum_size = Vector2(300, 0)
	var v := UI.vbox(6)
	p.add_child(v)
	v.add_child(UI.caps("MOVES TO TRY"))
	var groups := [["Punches", ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]], ["Defence", ["slip", "roll"]],
		["Feet", ["pivot", "step_in", "step_back"]]]
	for g in groups:
		v.add_child(UI.muted(str(g[0]), UI.TINY))
		var grid := GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 6)
		grid.add_theme_constant_override("v_separation", 6)
		for id in g[1]:
			var e := entry(str(id))
			var why := locked_why(f, str(id))
			var b := UI.button("+ " + str(e["name"]), "Btn", _add.bind(str(id)))
			b.name = "Try_" + str(id)
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.tooltip_text = why if why != "" else "Coach: %s" % e["cue"]
			if why != "":
				b.modulate = Color(1, 1, 1, 0.6)
			grid.add_child(b)
		v.add_child(grid)
	v.add_child(UI.sep())
	v.add_child(UI.caps("START FROM THE BOOK"))
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 6)
	flow.add_theme_constant_override("v_separation", 6)
	var open: Array = Combos.unlocked(f.get("moves", {}))
	for row in Combos.BOOK:
		var id := str(row["id"])
		var b := UI.button(id, "Btn", _load.bind((row["beats"] as Array).duplicate()))
		b.name = "Book_" + id.replace(" ", "_")
		var can := open.has(id)
		b.tooltip_text = ", ".join(row["moves"]) + (": she can throw it in a fight" if can else ": try it here; every punch needs 30 on the pads before she can use it")
		if not can:
			b.modulate = Color(1, 1, 1, 0.6)
		flow.add_child(b)
	v.add_child(flow)
	var own: Array = f.get("book", [])
	if not own.is_empty():
		v.add_child(UI.caps("YOUR OWN"))
		for o in own:
			var b := UI.button("%s  (%d)" % [o["name"], int(o["score"])], "Btn", _load.bind((o["chain"] as Array).duplicate()))
			b.tooltip_text = "Load it back into the builder"
			v.add_child(b)
	return p


func _add(id: String) -> void:
	if chain.size() >= MAX_MOVES:
		main.toast("Eight moves is the most one chain holds.")
		return
	chain.append(id)
	_refresh(true)


func _load(c: Array) -> void:
	chain = c.duplicate()
	_refresh(true)


func _clear() -> void:
	chain = []
	_refresh(false)


func _remove(i: int) -> void:
	chain.remove_at(i)
	_refresh(true)


## The middle panel: numbered rows, the verdict, the lessons, the buttons; play the chain when asked.
func _refresh(play: bool) -> void:
	UI.clear(_rows)
	_rows.add_child(UI.display("BUILD A COMBINATION", 34))
	if chain.is_empty():
		_rows.add_child(UI.muted("Pick moves on the left, or start from a combination in the book. Two to four punches, then move the head.", UI.BODY, true))
		if player != null:
			player.stop()
		return
	for i in chain.size():
		_rows.add_child(_row(i, str(chain[i])))
	var r := CF.rate(chain)
	var word := str(r["word"])
	var col: Color = {"flows": UI.GREEN, "workable": UI.AMBER}.get(word, UI.RED)
	var verdict := UI.hbox(12)
	verdict.name = "Verdict"
	verdict.add_child(UI.label(word.to_upper(), UI.BODY + 8, col, "display"))
	verdict.add_child(UI.mono("%d / 100" % int(r["score"]), UI.BODY, col))
	verdict.add_child(UI.spacer())
	verdict.add_child(Icons.tip(UI.muted("tank %.2f" % CF.energy(chain)), "What the chain costs from the gas tank (Combos units; a round costs 18)"))
	_rows.add_child(verdict)
	var lessons := PanelContainer.new()
	lessons.name = "Lessons"
	lessons.add_theme_stylebox_override("panel", UI.box(Color("#fff7d6"), UI.YELLOW_EDGE, 8, 1, 12, 8))
	var lv := UI.vbox(2)
	lv.add_child(UI.caps("KEY LESSONS"))
	var said: Array = []
	for n in r["notes"]:
		if not said.has(str(n)):   # the coach says a lesson once, however often the chain earns it
			said.append(str(n))
			lv.add_child(UI.label("- " + str(n), UI.SMALL, UI.FG, "body", true))
	lessons.add_child(lv)
	_rows.add_child(lessons)
	var btns := UI.hbox(8)
	btns.add_child(UI.button("Play it", "BtnSolid", _play))
	btns.add_child(UI.button("Clear", "Btn", _clear))
	var locked := ""
	for id in chain:
		if locked == "":
			locked = locked_why(f, str(id))
	var save := UI.button("Save to the book", "Btn", _save, locked != "", locked)
	save.name = "SaveCombo"
	btns.add_child(save)
	var bid := book_id(chain)
	if bid != "":
		var open := Combos.unlocked(f.get("moves", {})).has(bid)
		var drill := UI.button("Drill it on the pads", "Btn", _drill.bind(bid), not open,
			"Every punch in the %s must be a weapon first (30 on the pads)" % bid)
		drill.name = "DrillCombo"
		btns.add_child(drill)
	_rows.add_child(btns)
	if play:
		_play()


func _row(i: int, id: String) -> Control:
	var e := entry(id)
	var h := UI.hbox(10)
	h.name = "Step_%d" % (i + 1)
	var num := PanelContainer.new()
	num.add_theme_stylebox_override("panel", UI.box(UI.GOLD, Color(0, 0, 0, 0), 15, 0, 0, 0))
	num.custom_minimum_size = Vector2(30, 30)
	var nl := UI.label(str(i + 1), UI.SMALL, Color.WHITE, "bold")
	nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	num.add_child(nl)
	h.add_child(num)
	h.add_child(Icons.icon(str(e.get("icon", "info")), 20, UI.FG, str(e.get("name", id))))
	var name_l := UI.label(str(e.get("name", id)), UI.BODY, UI.FG, "bold")
	name_l.custom_minimum_size = Vector2(120, 0)
	h.add_child(name_l)
	h.add_child(UI.muted(str(e.get("cue", "")), UI.SMALL, true))
	var why := locked_why(f, id)
	if why != "":
		h.add_child(Icons.tip(UI.chip("pad time first", "amber"), why))
	h.add_child(Icons.button("x", "Take it out", _remove.bind(i), UI.MUTED, 18))
	return h


func _play() -> void:
	if player == null or chain.is_empty():
		return
	var clips: Array = []
	for id in chain:
		clips.append(str(entry(str(id)).get("clip", "")))
	player.show_chain(clips)


func _save() -> void:
	var r := CF.rate(chain)
	if not f.has("book"):
		f["book"] = []
	var nm := book_id(chain)
	if nm == "":
		var names: Array = []
		for id in chain:
			names.append(str(entry(str(id)).get("name", id)).to_lower())
		nm = ", ".join(names)
	(f["book"] as Array).append({"name": nm, "chain": chain.duplicate(), "score": int(r["score"])})
	main.toast("Saved to %s's book: %s (%s, %d)." % [f["first"], nm, r["word"], int(r["score"])])
	main.render()


func _drill(id: String) -> void:
	main.act("combo", "%s|%s" % [f["id"], id])
	main.toast("%s drills the %s on the pads this week." % [f["first"], id])
