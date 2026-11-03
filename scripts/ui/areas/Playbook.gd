extends VBoxContainer
## S348 PLAYBOOK (operator S347: "a planning page on the ui to work on the training moves and plans? where you can try
## combos/transitions, escapes etc and see all the animations?"; Q-S294-71 "Yes, build it"; design Game
## Godot/research/PLAYBOOK_S347.md). The coach's whiteboard for one fighter at a time: her move map on the left (StrikeMap's
## cards, lit = she can use it, grey = pad time first), the move player on the right (her own body, the opponent a ghost):
## click a move and it plays, Replay, Slow motion. Tabs (S360, Q-S294-91): Moves (a move book by where in the ring each move
## is thrown, MoveWords), Game plan (the plan as lines, GamePlan; the map behind Open the map), Combos (S349 ComboBuilder:
## build a chain from her moves, ComboFlow rates it, her body throws it), Escapes (a move book, S359).

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const ComboBuilder := preload("res://scripts/ui/ComboBuilder.gd")
const MoveBook := preload("res://scripts/ui/MoveBook.gd")
const MoveWords := preload("res://scripts/rules/MoveWords.gd")
const GamePlan := preload("res://scripts/ui/GamePlan.gd")

## S359 (operator still: the player covered the plan panel - "remove the player or make it smaller?"): 400 x 440 beside
## the map (was 560 x 600), so the map and its side panel get the width; the Combos tab keeps its own bigger player.
const PLAYER := Vector2(400, 440)
const MAP_H := 760.0
const SLOW := 0.35
## The opponent the player's ghost wears: a fixed sparring partner (the page is about her moves, not a bout).

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
		0:
			add_child(_book(f, MoveWords.groups(), MoveWords.WORDS, "Click a move and it plays here."))   # S360 Q-S294-91
		1:
			add_child(_plan(main, f))
		2:
			add_child(ComboBuilder.make(main, f))   # S349 build step 3: her moves to try, the chain, its verdict, her body plays it
		3:
			add_child(_book(f, ESCAPES, ESCAPE_WORDS, "Click an escape and it plays here."))


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


## S360 (operator Q-S294-91: "build it make it interactive for player, with meaningful options and not chores and visually
## and progressively rewarding"): the game plan written as lines (GamePlan) beside her body; hovering an answer plays it.
func _plan(main: Node, f: Dictionary) -> Control:
	var h := UI.hbox(16)
	h.custom_minimum_size = Vector2(0, MAP_H)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(GamePlan.make(main, f, _play))
	h.add_child(scroll)
	h.add_child(_player_col(f, "Hover an answer and it plays here."))
	return h


## S359 ESCAPES (operator: "escapes has nothing, is that intentional?"): the ways out a boxer drills - off the ropes, out of
## the clinch, out of range - as a move book; each one plays on her body.
const ESCAPES := [
	["OFF THE ROPES", "Back on the ropes: turn out, counter out, or tie up.", ["pivot_out", "slip 2-3@own_ropes", "tie_up@own_ropes"]],
	["OUT OF THE CLINCH", "Tied up: make the space yourself, or wait for the referee.", ["push_off", "break"]],
	["OUT OF RANGE", "Under fire up close: roll under and out, or step back to boxing range.", ["roll_out", "step_back", "step_out"]],
]
const ESCAPE_WORDS := {
	"pivot_out": "Turn on the lead foot and step off the ropes to the side; out of there, the opponent faces the ropes.",
	"slip 2-3@own_ropes": "Slip the punch, cross and hook back coming off the ropes: the ropes spring the counter.",
	"tie_up@own_ropes": "Wrap the arms and smother the punches until the referee breaks it.",
	"push_off": "A step back out of the tie-up: make the space before the referee does.",
	"break": "The referee steps in and parts them; both back to long range.",
	"roll_out": "Roll under the hook and come up outside it, already moving away.",
	"step_back": "One step back from mid range to long range: out of hook reach.",
	"step_out": "Step out from long range to outside: rest out of reach.",
}


## A move book (MoveBook) beside the player: Moves (every move by where it is thrown, S360) and Escapes (S359).
func _book(f: Dictionary, groups: Array, words: Dictionary, prompt: String) -> Control:
	var h := UI.hbox(16)
	h.custom_minimum_size = Vector2(0, MAP_H)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(MoveBook.make(groups, words, f.get("moves", {}), _play, f.get("combos", {}), true))
	h.add_child(scroll)
	h.add_child(_player_col(f, prompt))
	return h


## The move player (her body, the partner a ghost), the move's name, Replay, Slow motion.
func _player_col(f: Dictionary, prompt: String) -> Control:
	var col := UI.vbox(8)
	col.custom_minimum_size = Vector2(PLAYER.x, 0)
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 12, 1, 6, 6))
	player = MovePlayer.new()
	player.name = "MovePlayer"
	player.bodies = [Faces.glb(Faces.pair(f, Faces.partner(f))[0]), Faces.glb(Faces.pair(f, Faces.partner(f))[1])]
	player.custom_minimum_size = PLAYER
	card.add_child(player)
	col.add_child(card)
	_name = UI.label(prompt, UI.BODY, UI.FG, "bold", true)
	col.add_child(_name)
	var btns := UI.hbox(8)
	btns.add_child(UI.button("Replay", "Btn", func(): _play(_move)))
	_slow = UI.button("Slow motion", "Btn", _toggle_slow)
	btns.add_child(_slow)
	col.add_child(btns)
	col.add_child(UI.muted("Your fighter's body, the partner a ghost. Lit moves work in a fight; grey ones need pad time first.", UI.SMALL, true))
	return col


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
