extends SceneTree
## S348 the Playbook page (Q-S294-71) as the player meets it: quick start, PLAYBOOK in the menu, Moves tab, a click on a move
## on her map and it plays on her own body; one move again in slow motion; the Plans tab. Stills + checks; with Godot's
## --write-movie it is also the film (operator C196 on the move player: "needs to see video of it").
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --write-movie <out>/playbook.avi --script res://tools/playbook_film.gd -- <out>
## Prints PLAYBOOK_FILM failures=<n>.

const FastDraw := preload("res://tools/fast_draw.gd")
const MOVES := ["1-2", "1-2-3b", "slip 2-3", "pivot_out"]
## S361 TASK_ZIVAFOOT1: `moves=<id,id,...>` plays that list instead of MOVES (the ten footwork moves, in a row) and
## `onlymoves` ends the tour after them, so the film is just the moves. Each move gets MOVE_S before the next is picked.
const MOVE_S := 3.4

var main: Node
var out_dir := "user://playbook"
var failures := 0
var moves: Array = MOVES
var only_moves := false


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty() and not str(args[0]).contains("=") and str(args[0]) != "onlymoves":
		out_dir = args[0]
	for a in args:
		if str(a).begins_with("moves="):
			moves = str(a).trim_prefix("moves=").replace("+", " ").split(",", false)
		elif str(a) == "onlymoves":
			only_moves = true
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("area", "playbook")
	await _wait(20)
	var page: Node = root.find_child("Playbook", true, false)
	_check(page != null, "PLAYBOOK opens from the menu")
	var player: Node = page.find_child("MovePlayer", true, false) if page != null else null
	_check(player != null, "the move player sits on the page")
	var sb: Node = page.find_children("*", "Control", true, false).filter(func(n): return n.has_signal("move_picked")).front() if page != null else null
	# S361 S360 rebuilt the Moves tab as a move book (MoveBook) and left the map behind "Open the map", so the page's own
	# _play(id) is what picks a move now; the map's move_picked is still used when it is on the page.
	_check(sb != null or (page != null and page.has_method("_play")), "her move list sits on the page")
	if player == null or (sb == null and not page.has_method("_play")):
		_end()
		return
	await _shot("01_playbook_open", 1.0)
	for id in moves:
		if sb != null:
			sb.move_picked.emit(id)
		else:
			page.call("_play", id)
		await _wait(3)
		_check(player.get("_move_id") == id and bool(player.get("_playing")), "a click on %s plays it" % id)
		await _shot("02_%s" % str(id).replace(" ", "_"), 0.9)
		await create_timer(MOVE_S - 0.9).timeout
	if only_moves:
		_end()
		return
	(page.find_children("*", "Button", true, false).filter(func(b): return (b as Button).text == "Slow motion").front() as Button).pressed.emit()
	await _wait(2)
	_check(is_equal_approx(float(player.get("speed")), page.SLOW), "Slow motion plays her move at %.2f" % page.SLOW)
	await _shot("03_slow_1-2-3b", 1.6)
	await create_timer(4.0).timeout
	main.act("tab", "1")
	await _wait(20)
	page = root.find_child("Playbook", true, false)
	_check(page != null and page.find_children("*", "Button", true, false).any(func(b): return (b as Button).text == "Save plan"), "Plans tab: her plan board with Save plan")
	await _shot("04_plans_tab", 1.0)
	_end()


func _end() -> void:
	print("PLAYBOOK_FILM failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _wait(n: int) -> void:
	for i in n:
		await process_frame


func _shot(name: String, after_s: float) -> void:
	await create_timer(after_s).timeout
	var img: Image = await FastDraw.shot(self)
	img.save_png(out_dir.path_join(name + ".png"))
	print("wrote ", name)


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
