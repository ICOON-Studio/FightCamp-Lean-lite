extends "res://tools/layout_snapshot.gd"
## S544 (owner on the S544 build: "wtf is this why half the screen isout of bounds ?"): each test jump's screen as a still
## (layout_snapshot's _shot: a wireframe always, the real picture on the never-shown desktop) AND a bounds check - every
## visible Control outside a scroll area whose box ends below the 1080 screen or right of 1920 prints one BOUNDS line.
## Run (headless = wireframes + the check; on the hidden desktop = the real pictures too):
##   <godot> --headless --path . --script res://tools/jump_snapshot.gd -- <out_dir> noguide pro propair prohunger
##   then=<act>:<arg>,<act>:<arg> plays those acts after every jump (e.g. then=turnpro: to see the screen a click leads to)
## Inside a scrolling page: a card that starts on screen (60 px or more above the bottom) and ends below it is CUT.
## Ends with JUMP_SNAPSHOT bounds=<n>; exit 1 when n > 0.

const TestJump := preload("res://scripts/ui/TestJump.gd")

var _bad := 0


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	var then: Array = []
	for a in args:
		if str(a).begins_with("then="):
			then = Array(str(a).substr(5).split(","))
	for a in args.slice(1):
		var jump := str(a)
		if not TestJump.JUMPS.has(jump):
			continue
		main = load("res://scenes/Main.tscn").instantiate()
		root.add_child(main)
		await _settle()
		if DisplayServer.get_name() == "headless":
			main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
			main.size = Vector2(W, H)
		await _settle()
		var ok := TestJump.run(main, jump)
		main.clear_toast()
		var tag := "jump_" + jump
		for t in then:
			var parts := str(t).split(":")
			main.act(parts[0], str(parts[1]).replace("FID", str(main.career.fighter().get("id", ""))) if parts.size() > 1 else "")
			main.clear_toast()
			tag += "_" + parts[0]
		await _shot(tag)
		_bounds(tag, main)
		print("JUMP %s reached=%s" % [jump, ok])
		main.queue_free()
		await _settle()
	print("JUMP_SNAPSHOT bounds=%d" % _bad)
	quit(1 if _bad > 0 else 0)


## Every visible leaf (a word, a button, a picture, a bar) outside a scroll area that ends off the screen.
func _bounds(tag: String, node: Node) -> void:
	if node is Control:
		var c := node as Control
		if not c.is_visible_in_tree():
			return
		if c is ScrollContainer:   # a page may scroll, but no card may be cut by the bottom of the screen
			_cut(tag, c)
			return
		var leaf := c is Label or c is BaseButton or c is TextureRect or c.get_child_count() == 0
		if leaf and c.size.x > 1.0 and c.size.y > 1.0:
			var r := c.get_global_rect()
			if r.end.y > float(H) + 1.0 or r.end.x > float(W) + 1.0 or r.position.x < -1.0:
				var words := str((c as Label).text).left(40) if c is Label else (str((c as Button).text).left(40) if c is Button else "")
				_bad += 1
				if _bad <= 40:
					print("BOUNDS %s %s \"%s\" ends at x %.0f y %.0f" % [tag, c.name, words, r.end.x, r.end.y])
	for ch in node.get_children():
		_bounds(tag, ch)


## Cards (panels) under a scrolling page that the bottom of the screen cuts through.
func _cut(tag: String, node: Node) -> void:
	for ch in node.get_children():
		if not (ch is Control) or not (ch as Control).is_visible_in_tree() or ch is ScrollContainer or ch is ScrollBar:
			continue
		var r := (ch as Control).get_global_rect()
		if ch is PanelContainer and r.position.y < float(H) - 60.0 and r.end.y > float(H) + 2.0 and r.size.y < float(H):
			_bad += 1
			var title := ch.find_child("*", true, false)
			var words := ""
			for l in ch.find_children("*", "Label", true, false):
				words = str((l as Label).text).left(30)
				break
			print("BOUNDS %s card %s \"%s\" is cut by the bottom of the screen: %.0f to %.0f" % [tag, ch.name, words, r.position.y, r.end.y])
			continue
		_cut(tag, ch)
