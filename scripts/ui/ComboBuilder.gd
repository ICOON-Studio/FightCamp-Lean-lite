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
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const ComboStrip := preload("res://scripts/ui/ComboStrip.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const MoveTip := preload("res://scripts/ui/MoveTip.gd")
const PadView := preload("res://scripts/ui/PadView.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
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
	return "Not usable yet (mastery %d of %d): pad time first - Week, a pads night" % [int(m), int(Combos.LEARN_AT)]


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
	# S397 blind round 3 ("the middle panel is one line on a big white box"): it opens on a combination she can throw.
	if chain.is_empty():
		chain = starter(f)
	var col := UI.vbox(8)
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 12, 1, 6, 6))
	player = MovePlayer.new()
	player.name = "MovePlayer"
	var pair: Array = Faces.pair(f, Faces.partner(f))
	player.bodies = [Faces.glb(pair[0]), Faces.glb(pair[1])]
	player.custom_minimum_size = PLAYER_SIZE
	card.add_child(player)
	col.add_child(card)
	col.add_child(UI.muted("Your fighter throws the chain on a loop; the partner is a ghost.", UI.SMALL, true))
	add_child(col)
	_refresh(false)
	player.ready.connect(_play, CONNECT_ONE_SHOT)


## The chain the panel opens on: the 1-2-3 when she can throw it, else the 1-2.
static func starter(fighter: Dictionary) -> Array:
	var open: Array = Combos.unlocked(fighter.get("moves", {}))
	for id in ["1-2-3", "1-2"]:
		if open.has(id):
			for row in Combos.BOOK:
				if str(row["id"]) == id:
					return (row["beats"] as Array).duplicate()
	return ["jab", "cross"]


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
			MoveTip.attach(b, str(id), f)   # S382 MOVETIP1: the hover card plays it (its tier says what the tooltip said)
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
		b.tooltip_text = ", ".join(row["moves"]) + (": ready to throw in a fight" if can else ": try it here; every punch needs 30 on the pads before it works in a fight")
		if not can:
			b.modulate = Color(1, 1, 1, 0.6)
		MoveTip.attach(b, id, f)
		flow.add_child(b)
	v.add_child(flow)
	# S397 blind round 3 ("3b, 1-6-3 never explained"): the numbers coaches call, once.
	v.add_child(UI.label("1 jab · 2 cross · 3 lead hook · 6 uppercut · b to the body", UI.TINY, UI.MUTED, "body", true))
	# S376 (operator's S375 playtest: "the own-combo builder has no 'Drill it' button"): each of the fighter's own
	# combinations loads back into the builder AND goes on the pads from here, like the planner's Drill this week.
	var own: Array = OwnCombos.entries(f)
	if not own.is_empty():
		v.add_child(UI.caps("YOUR OWN"))
		var drilling := str(f.get("combo_learning", ""))
		for o in own:
			var row := UI.hbox(6)
			var b := UI.button("%s  (%d)" % [o["name"], int(o["score"])], "Btn", _load.bind((o["chain"] as Array).duplicate()))
			b.tooltip_text = "Load it back into the builder"
			row.add_child(b)
			var oid := str(o["id"])
			var need := OwnCombos.missing(f, o)
			var d := UI.button("Drilling" if drilling == oid else "Drill it", "Btn", _drill_own.bind(oid, str(o["name"])),
				drilling == oid or need != "", "Every punch in it must be Usable first (mastery %d)." % int(Combos.LEARN_AT) if need != "" else "")
			d.name = "DrillOwn_" + oid.replace(":", "_")
			row.add_child(d)
			v.add_child(row)
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
	# S370 the card strip (operator: "stitch moves ... display the combo strength/stamina cost"): her move cards, each join
	# judged, the totals under them (ComboStrip; the S359 gas words live on its GAS tile).
	var r := CF.rate(chain)
	var by_id := {}
	for e in PALETTE:
		by_id[e["id"]] = e
	var bid := book_id(chain)
	var strip := ComboStrip.strip(f, chain, r, by_id, _remove)
	_rows.add_child(strip)
	if bid != "" and not MoveClips.clips(bid).is_empty():
		_attach_pad_watch_row(strip, bid)
	_rows.add_child(ComboStrip.totals(f, chain, r, book_id(chain)))
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
	var ring := _ring(f, book_id(chain))
	if ring != null:
		_rows.add_child(ring)
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
	bid = book_id(chain)
	if bid != "":
		var open := Combos.unlocked(f.get("moves", {})).has(bid)
		var drill := UI.button("Drill it on the pads", "Btn", _drill.bind(bid), not open,
			"Every punch in the %s must be Usable first (mastery 30)" % bid)
		drill.name = "DrillCombo"
		btns.add_child(drill)
	_rows.add_child(btns)
	if play:
		_play()


func _attach_pad_watch_row(strip: Control, bid: String) -> void:
	var step1 := strip.find_child("Step_1", true, false)
	if step1 == null:
		return
	var row := step1.get_child(0) as VBoxContainer
	if row == null:
		return
	var top := row.get_child(0) as HBoxContainer
	if top == null:
		return
	var x_idx := top.get_child_count() - 1
	var w := UI.button("Watch on the pads", "Btn", _open_pad_view.bind(bid), false, "")
	w.name = "WatchPads_" + bid.replace(" ", "_").replace("-", "_")
	top.add_child(w)
	top.move_child(w, x_idx)


func _open_pad_view(bid: String) -> void:
	if bid == "" or MoveClips.clips(bid).is_empty():
		return
	PadView.open(main, f, bid)


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
	# S375 COMBOPLAN1: a saved chain is a combination of the fighter's own - the planner on the Training tab drills it.
	OwnCombos.ensure_ids(f)
	main.toast("Saved to %s's book: %s (%s, %d). Drill it from YOUR OWN, here or on the Training tab." % [f["first"], nm, r["word"], int(r["score"])])
	main.render()


func _drill_own(id: String, nm: String) -> void:
	main.act("combo", "%s|%s" % [f["id"], id])
	main.toast("%s drills the %s on the pads this week." % [f["first"], nm])


func _drill(id: String) -> void:
	main.act("combo", "%s|%s" % [f["id"], id])
	main.toast("%s drills the %s on the pads this week." % [f["first"], id])


## S355 the combo lab's hit rates (ComboOdds): how often this book combination lands whole in each of the opponent's games,
## against the next opponent (the main game marked) or an even one - the fight model's own dice.
static func _ring(fr: Dictionary, bid: String) -> Control:
	var bout: Dictionary = fr.get("bout", {})
	var opp: Dictionary = bout.get("opp", {}) if not bout.is_empty() and not bool(bout.get("done", false)) else {}
	var t := ComboOdds.table(bid, fr, opp)
	if t.is_empty():
		return null
	var box := UI.vbox(2)
	box.name = "Ring"
	box.add_child(UI.caps("IN THE RING - HOW OFTEN IT LANDS WHOLE vs %s" % (str(opp["first"]).to_upper() if not opp.is_empty() else "AN EVEN OPPONENT")))
	var g := GridContainer.new()
	g.columns = 3
	g.add_theme_constant_override("h_separation", 20)
	for r in t["rows"]:
		var main := str(r["sit"]) == str(t["main"])
		if str(r["fit"]) == "none" and not main:
			continue   # S398 (operator rule): a game it changes nothing in is not a row; the base rate is said once below
		g.add_child(UI.label(str(r["label"]) + ("  (main game)" if main else ""), UI.SMALL, UI.GOLD if main else UI.FG, "bold" if main else "body"))
		g.add_child(UI.mono("%d%%" % int(round(float(r["odds"]) * 100.0)), UI.BODY,
			{"best": UI.GREEN, "ok": UI.GREEN, "wrong": UI.RED}.get(str(r["fit"]), UI.FG)))
		g.add_child(UI.muted({"best": "its best game", "ok": "fits", "wrong": "walks into trouble", "none": "no help"}.get(str(r["fit"]), ""), UI.SMALL))
	box.add_child(g)
	box.add_child(UI.muted("An exchange with no combination: %d%%.%s" % [int(round(float(t["base"]) * 100.0)),
		"" if bool(t["drilled"]) else " Not drilled yet: it lands less well until it has pad time."], UI.SMALL, true))
	return box
