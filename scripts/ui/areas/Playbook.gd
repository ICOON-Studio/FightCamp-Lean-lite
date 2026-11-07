extends VBoxContainer
## S348 PLAYBOOK (operator S347: "a planning page on the ui to work on the training moves and plans? where you can try
## combos/transitions, escapes etc and see all the animations?"; Q-S294-71 "Yes, build it"; design Game
## Godot/research/PLAYBOOK_S347.md). The coach's whiteboard for one fighter at a time: her move map on the left (StrikeMap's
## cards, lit = she can use it, grey = pad time first), the move player on the right (her own body, the opponent a ghost):
## click a move and it plays, Replay, Slow motion. Tabs (S360, Q-S294-91): Moves (a move book by where in the ring each move
## is thrown, MoveWords), Game plan (the plan as lines, GamePlan; the map behind Open the map), Combos (S349 ComboBuilder:
## build a chain from her moves, ComboFlow rates it, her body throws it), Escapes (a move book, S359).

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const ComboBuilder := preload("res://scripts/ui/ComboBuilder.gd")
const MoveBook := preload("res://scripts/ui/MoveBook.gd")
const MoveWords := preload("res://scripts/rules/MoveWords.gd")
const GamePlan := preload("res://scripts/ui/GamePlan.gd")
const MatPlayer := preload("res://scripts/ui/MatPlayer.gd")
const BjjFilm := preload("res://scripts/rules/BjjFilm.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const CoachSteps := preload("res://scripts/ui/CoachSteps.gd")
const MoveTip := preload("res://scripts/ui/MoveTip.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const MatTree := preload("res://scripts/ui/MatTree.gd")
const MatTreeInfo := preload("res://scripts/ui/MatTreeInfo.gd")

## S359 (operator still: the player covered the plan panel - "remove the player or make it smaller?"): 400 x 440 beside
## the map (was 560 x 600), so the map and its side panel get the width; the Combos tab keeps its own bigger player.
const PLAYER := Vector2(400, 440)
const MAP_H := 760.0
## S384 GAMETREE1 Ana's page: the moves list, the centre column (MatTree) and the mat, 1920 wide.
const MAT_H := 880.0
const BOOK_W := 450.0
const TREE_W := 790.0
const SLOW := 0.35
## The opponent the player's ghost wears: a fixed sparring partner (the page is about her moves, not a bout).

static var pick := ""      # the fighter on the page (her id), kept while the page re-renders

var player: Control
var _move := ""
var _name: Label
var _slow: Button
var _steps: Control   # S376 the coach's steps under Ana's mat (CoachSteps)


func build(main: Node) -> void:
	add_theme_constant_override("separation", 12)
	var c: Career = main.career
	# S387 a tab of the fighter's own page: the page's route names the fighter, so the old name chips are gone.
	var f: Dictionary = {}
	for x in c.fighters + c.grapplers:
		if str(x["id"]) == str(main.route.get("fighter", "")):
			f = x
	if f.is_empty():
		return
	pick = str(f["id"])
	# S375 (operator: "i expect to see the bjj moves not a female fighter doing box", "train her on bjj"): a no-gi athlete's
	# whiteboard is her syllabus on the mat - each move played on two bodies from GrappleMap, Drill it sends it to her classes.
	# S384 GAMETREE1: ONE page, no tab row (S387: the fighter page carries the name).
	if str(f.get("sport", "")) == "bjj":
		add_child(_mat_book(main, c, f))
		return
	add_child(_tabs(main))
	match int(main.route.get("ptab", 0)):
		0:
			add_child(_book(f, MoveWords.groups(), MoveWords.WORDS, "Click a move and it plays here."))   # S360 Q-S294-91
		1:
			add_child(_plan(main, f))
		2:
			add_child(ComboBuilder.make(main, f))   # S349 build step 3: her moves to try, the chain, its verdict, her body plays it
		3:
			add_child(_book(f, ESCAPES, ESCAPE_WORDS, "Click an escape and it plays here.", false))


## The fighter a Playbook link opens: `who`, else the fighter on the page, else the last one on the Playbook, else the first boxer.
static func fighter_id(c: Career, who: String, on_page: String) -> String:
	var ids: Array = (c.fighters + c.grapplers).map(func(x): return str(x["id"]))
	for id in [who, on_page, pick]:
		if ids.has(id):
			return id
	return str(ids[0]) if not ids.is_empty() else ""


func _tabs(main: Node) -> Control:
	var row := UI.hbox(4)
	var names: Array = Data.area("playbook")["tabs"]
	for i in names.size():
		var on := int(main.route.get("ptab", 0)) == i
		row.add_child(UI.button(names[i], "TabOn" if on else "Tab", main.act.bind("ptab", str(i))))
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


## S375 her syllabus as a move book beside the mat: each move's pad level toward owned (a weapon at the tick) and a
## signature, the one her classes drill, Watch (GrappleMap on two bodies, BjjFilm) and Drill it (NoGi "move:<id>").
## S384 GAMETREE1 (design 7, docs/mockups/S384_gametree.png): one page, three columns - the moves list (MatBook, now with
## the FELT step and the Links group: tree moves of the belt, taught in class, and a belt ahead at half rate), the centre
## column (MatTree: goal, plan strip, the map, leaks) and the mat. Hovering an edge plays it here.
func _mat_book(main: Node, c: Career, f: Dictionary) -> Control:
	var h := UI.hbox(16)
	h.custom_minimum_size = Vector2(0, MAT_H)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.custom_minimum_size = Vector2(BOOK_W, 0)
	var v := UI.vbox(6)
	v.name = "MatBook"
	v.custom_minimum_size = Vector2(BOOK_W - 14.0, 0)
	scroll.add_child(v)
	var belt := str(f.get("belt", "white"))
	v.add_child(UI.caps("%s'S MOVES - %s BELT: %s" % [str(f["first"]).to_upper(), belt.to_upper(),
		str((BeltRoad.SYLLABUS.get(belt, {}) as Dictionary).get("title", "")).to_upper()]))
	var drilling := MatTreeInfo.drilled(f, c.day)
	v.add_child(UI.muted("Drill a move and %s's classes work on it (+%.1f a week): felt at %d, owned at %d, a signature at %d." % [
		str(f["first"]), NoGi.DRILL_GAIN, int(BjjTree.T["FELT"]), int(BeltRoad.OWNED_AT), int(NoGi.SIGNATURE)], UI.TINY, true))
	var bjj: Dictionary = f.get("bjj", {})
	for g in NoGi.groups_of(f):
		v.add_child(UI.caps(str(g[0])))
		for id in g[1]:
			v.add_child(_mat_row(main, f, str(id), float(bjj.get(str(id), 0.0)), str(id) == drilling))
	var links := MatTreeInfo.links(f)
	if not links.is_empty():
		v.add_child(UI.caps("LINKS - TAUGHT IN CLASS"))
		for id in links:
			v.add_child(_mat_row(main, f, str(id), BjjTree.mastery(f, str(id)), str(id) == drilling, BjjTree.drill_plan_for(f, str(id))))
	var ahead := MatTreeInfo.ahead(f)
	if not ahead.is_empty():
		v.add_child(UI.caps("A BELT AHEAD - HALF RATE"))
		for id in ahead:
			v.add_child(_mat_row(main, f, str(id), BjjTree.mastery(f, str(id)), str(id) == drilling, BjjTree.drill_plan_for(f, str(id))))
	h.add_child(scroll)
	h.add_child(MatTree.make(main, f, c.day, _play_edge, TREE_W))
	var col := UI.vbox(8)
	col.custom_minimum_size = Vector2(PLAYER.x, 0)
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 12, 1, 6, 6))
	var mat := MatPlayer.new()
	mat.name = "MatPlayer"
	var stems := Faces.pair(f, Faces.partner(f))
	mat.bodies = [Faces.glb(stems[0]), Faces.glb(stems[1])]
	mat.custom_minimum_size = PLAYER
	card.add_child(mat)
	col.add_child(card)
	player = mat
	_name = UI.label("Hover a card or Watch a move and it plays here (GrappleMap).", UI.BODY, UI.FG, "bold", true)
	col.add_child(_name)
	# S376 BJJCOACH1: the coach's steps under the mat, lit as the film plays them; click one to play it and hold.
	_steps = CoachSteps.new()
	_steps.setup(mat)
	col.add_child(_steps)
	col.add_child(UI.muted("%s in red, the partner in blue. The moves are GrappleMap's (eel.is/GrappleMap), played at a coached pace." % f["first"], UI.SMALL, true))
	h.add_child(col)
	if drilling != "":
		mat.ready.connect(func(): _watch(drilling), CONNECT_ONE_SHOT)
	return h


## A move row: name (hover = the move's card), meter to the signature with the owned tick, level, felt / owned chip,
## Watch, Drill. `plan` = the Drill plan (default "move:<id>", S375; Links rows "tree:" / "ahead:", S384).
func _mat_row(main: Node, f: Dictionary, id: String, lvl: float, drilled: bool, plan: String = "") -> Control:
	var row := UI.hbox(5)
	row.name = "Mat_" + id
	if plan == "":
		plan = "move:" + id
	var nm := UI.label(BjjTree.move_name(id), UI.SMALL, UI.FG, "semi")
	nm.custom_minimum_size = Vector2(176, 0)
	nm.clip_text = true
	MoveTip.attach(nm, id, f)   # S382 MOVETIP1: hover the move's name - the hover card plays it on the mat
	row.add_child(nm)
	var st := BjjTree.state(lvl)
	var col := UI.GOLD if st == "signature" else (UI.GREEN if st == "owned" else (UI.AMBER if st == "felt" else UI.MUTED))
	row.add_child(UI.meter(clampf(lvl / NoGi.SIGNATURE, 0.0, 1.0), col, [BeltRoad.OWNED_AT / NoGi.SIGNATURE], 46.0))
	var num := UI.mono(("%.1f" % lvl) if absf(lvl - roundf(lvl)) > 0.04 else "%d" % int(roundf(lvl)), UI.TINY, UI.FG)
	num.custom_minimum_size = Vector2(34, 0)
	num.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(num)
	var mv_belt := str(BjjTree.move(id).get("belt", f.get("belt", "white")))
	var ahead := BeltRoad.rank(mv_belt) > BeltRoad.rank(str(f.get("belt", "white")))
	row.add_child(UI.chip("%s belt" % mv_belt if ahead and st == "learning" else st,
		"gold" if st == "signature" else ("green" if st == "owned" else ("amber" if st == "felt" else ""))))
	row.add_child(UI.spacer())
	var filmed := BjjFilm.film(id).size() > 0 or MatPlayer.tree_film(id) >= 0
	# S376: an unfilmed move still has the coach's steps to read (BjjSteps).
	var w := UI.button("Watch" if filmed else "Steps", "Btn", func(): _watch(id))
	w.tooltip_text = "" if filmed else "GrappleMap has no film of this move yet: the coach's steps only."
	w.name = "Watch_" + id
	w.add_theme_font_size_override("font_size", UI.TINY)
	row.add_child(w)
	var d := UI.button("Drilling" if drilled else "Drill", "BtnSolid" if drilled else "Btn", func():
		main.act("gdrill", "%s|%s" % [f["id"], plan])
		main.toast("%s's classes drill the %s." % [f["first"], BjjTree.move_name(id).to_lower()]), drilled)
	d.name = "Drill_" + id
	d.add_theme_font_size_override("font_size", UI.TINY)
	row.add_child(d)
	return row


func _watch(id: String) -> void:
	if player == null or not player.has_method("play_move"):
		return
	var ok: bool = player.play_move(id)
	if _name != null:
		_name.text = BjjTree.move_name(id) if ok else "%s: GrappleMap has no film of it yet." % BjjTree.move_name(id)
	if is_instance_valid(_steps):
		_steps.show_move(id, ok)


## S384 GAMETREE1: an edge hovered in the centre column plays here - its film only when it is exact (never a wrong clip),
## else its from and to positions in turn.
func _play_edge(eid: String) -> void:
	if player == null or not player.has_method("play_seq"):
		return
	var e := BjjTree.edge(eid)
	var mv := str(e.get("move", ""))
	var film: Variant = e.get("film")
	var seq := -1
	if film is Dictionary and str(film.get("fit", "")) == "exact" and film.get("transition") != null:
		seq = int(film["transition"])
	var ok: bool = seq >= 0 and player.play_seq(seq)
	var a := str(BjjTree.node(str(e["from"])).get("name", ""))
	var b := str(BjjTree.node(str(e["ok"])).get("name", ""))
	if not ok:
		var pa: Variant = BjjTree.node(str(e["from"])).get("card_pose")
		var pb: Variant = BjjTree.node(str(e["ok"])).get("card_pose")
		player.show_poses(int(pa) if pa != null else -1, int(pb) if pb != null else -1)
	if _name != null:
		if ok:
			_name.text = "%s: %s to %s" % [BjjTree.move_name(mv), a.to_lower(), b.to_lower()]
		else:
			_name.text = "%s - no exact film yet: %s, then %s" % [BjjTree.move_name(mv), a.to_lower(), b.to_lower()]
	if is_instance_valid(_steps):
		_steps.show_move(mv, ok and seq == BjjFilm.find(MatPlayer.db(), mv))


## S359 ESCAPES (operator: "escapes has nothing, is that intentional?"): the ways out a boxer drills - off the ropes, out of
## the clinch, out of range - as a move book; each one plays on her body.
const ESCAPES := [
	["OFF THE ROPES", "Back on the ropes: turn out, counter out, or tie up.", ["pivot_out", "slip 2-3@own_ropes", "tie_up@own_ropes"]],
	["OUT OF THE CLINCH", "Tied up: make the space yourself and get back to boxing range.", ["push_off"]],
	["OUT OF RANGE", "Under fire up close: roll under and out, or step back to boxing range.", ["roll_out", "step_back", "step_out"]],
]
const ESCAPE_WORDS := {
	"pivot_out": "Turn on the lead foot and step off the ropes to the side; out of there, the opponent faces the ropes.",
	"slip 2-3@own_ropes": "Slip the punch, cross and hook back coming off the ropes: the ropes spring the counter.",
	"tie_up@own_ropes": "Wrap the arms and smother the punches, then push off the ropes.",
	"push_off": "Frame on the shoulders and step back out of the tie-up: make the space before the next punch.",
	"roll_out": "Roll under the hook and come up outside it, already moving away.",
	"step_back": "One step back from mid range to long range: out of hook reach.",
	"step_out": "Step out from long range to outside: rest out of reach.",
}


## A move book (MoveBook) beside the player: Moves (every move by where it is thrown, S360) and Escapes (S359).
func _book(f: Dictionary, groups: Array, words: Dictionary, prompt: String, next_line := true) -> Control:
	var h := UI.hbox(16)
	h.custom_minimum_size = Vector2(0, MAP_H)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(MoveBook.make(groups, words, f.get("moves", {}), _play, f.get("combos", {}), true, f, next_line))   # S382 hover cards
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
