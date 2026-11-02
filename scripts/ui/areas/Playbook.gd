extends VBoxContainer
## S348 PLAYBOOK (operator S347: "a planning page on the ui to work on the training moves and plans? where you can try
## combos/transitions, escapes etc and see all the animations?"; Q-S294-71 "Yes, build it"; design Game
## Godot/research/PLAYBOOK_S347.md). The coach's whiteboard for one fighter at a time: her move map on the left (StrikeMap's
## cards, lit = she can use it, grey = pad time first), the move player on the right (her own body, the opponent a ghost):
## click a move and it plays, Replay, Slow motion. Tabs: Moves (walk her map), Plans (her plan board, Save plan, See the
## flow), Combos (S349 ComboBuilder: build a chain from her moves, ComboFlow rates it, her body throws it), Escapes next.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const StrikeBrowser := preload("res://scripts/ui/StrikeBrowser.gd")
const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const ComboBuilder := preload("res://scripts/ui/ComboBuilder.gd")

const PLAYER := Vector2(560, 600)
const MAP_H := 760.0
const SLOW := 0.35
## The opponent the player's ghost wears: a fixed sparring partner (the page is about her moves, not a bout).
const PARTNER := {"name": "Maria Ortega"}

static var pick := ""      # the fighter on the page (her id), kept while the page re-renders

var player: Control
var _move := ""
var _name: Label
var _slow: Button


func build(main: Node) -> void:
	add_theme_constant_override("separation", 12)
	var c: Career = main.career
	AreaHead.add(self, main, "playbook")
	if c.fighters.is_empty():
		AreaHead.placeholder(self, "NO FIGHTERS YET", "Sign a fighter: moves, plans and escapes live here.")
		return
	var f: Dictionary = c.fighters[0]
	for x in c.fighters:
		if str(x["id"]) == pick:
			f = x
	pick = str(f["id"])
	add_child(_picker(main, c, f))
	match int(main.route["tab"]):
		0, 1:
			add_child(_board(main, f, int(main.route["tab"]) == 1))
		2:
			add_child(ComboBuilder.make(main, f))   # S349 build step 3: her moves to try, the chain, its verdict, her body plays it
		3:
			AreaHead.placeholder(self, "ESCAPES", "Next: off the ropes, out of the corner, tie-ups - each one plays, and Drill this puts it in the training week.")


## Her name chips: the page is one fighter's whiteboard.
func _picker(main: Node, c: Career, f: Dictionary) -> Control:
	var row := UI.hbox(8)
	row.add_child(UI.muted("Fighter", UI.SMALL))
	for x in c.fighters:
		var on := str(x["id"]) == str(f["id"])
		var id := str(x["id"])
		row.add_child(UI.button(str(x["name"]), "TabOn" if on else "Tab", func():
			pick = id
			main.render()))
	return row


## The map (left) and the player (right).
func _board(main: Node, f: Dictionary, plans: bool) -> Control:
	var h := UI.hbox(16)
	h.custom_minimum_size = Vector2(0, MAP_H)
	var sb: Control = StrikeBrowser.new()
	sb.embedded = true
	sb.start_plan = plans
	sb.for_fighter(main, f)
	sb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sb.move_picked.connect(_play)
	h.add_child(sb)
	var col := UI.vbox(8)
	col.custom_minimum_size = Vector2(PLAYER.x, 0)
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 12, 1, 6, 6))
	player = MovePlayer.new()
	player.name = "MovePlayer"
	player.bodies = [Faces.glb(Faces.pair(f, PARTNER)[0]), Faces.glb(Faces.pair(f, PARTNER)[1])]
	player.custom_minimum_size = PLAYER
	card.add_child(player)
	col.add_child(card)
	_name = UI.label("Click a move on the map and it plays here.", UI.BODY, UI.FG, "bold", true)
	col.add_child(_name)
	var btns := UI.hbox(8)
	btns.add_child(UI.button("Replay", "Btn", func(): _play(_move)))
	_slow = UI.button("Slow motion", "Btn", _toggle_slow)
	btns.add_child(_slow)
	col.add_child(btns)
	col.add_child(UI.muted("Your fighter's body, the partner a ghost. Lit moves work in a fight; grey ones need pad time first.", UI.SMALL, true))
	h.add_child(col)
	return h


func _play(id: String) -> void:
	if id == "" or player == null:
		return
	_move = id
	var mv := SM.move(id)
	_name.text = "%s  -  %s to %s" % [str(mv.get("name", id)), str(SM.card(str(mv.get("from", ""))).get("name", "")),
		str(SM.card(str(mv.get("to", ""))).get("name", ""))]
	player.show_move(id)


func _toggle_slow() -> void:
	player.speed = 1.0 if player.speed < 1.0 else SLOW
	_slow.text = "Normal speed" if player.speed < 1.0 else "Slow motion"
	if _move != "":
		_play(_move)
