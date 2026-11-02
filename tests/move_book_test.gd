extends SceneTree
## S359 the Playbook's Escapes tab as a move book (MoveBook): every escape is a card, each card plays its move in the
## player, a move she cannot use yet still shows (greyed) and plays.
## Population: a quick-start career with its first fighter signed (the film tool's start).

const Playbook := preload("res://scripts/ui/areas/Playbook.gd")

var _fails := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("go", "playbook:3")
	for i in 10:
		await process_frame
	var book := main.find_child("MoveBook", true, false)
	_check(book != null, "the Escapes tab is a move book, not a placeholder")
	var want := 0
	for g in Playbook.ESCAPES:
		want += (g[2] as Array).size()
	var cards: Array = book.find_children("Move_*", "Button", true, false) if book != null else []
	_check(cards.size() == want, "every escape has a card (%d of %d)" % [cards.size(), want])
	for g in Playbook.ESCAPES:
		for id in g[2]:
			_check(Playbook.ESCAPE_WORDS.has(str(id)), "%s says what it does" % id)
	var mp := main.find_child("MovePlayer", true, false)
	_check(mp != null, "the player sits beside the book")
	if book != null and mp != null:
		book.select("pivot_out")
		for i in 5:
			await process_frame
		_check(str(mp.get("_move_id")) == "pivot_out", "a card plays its move (%s)" % mp.get("_move_id"))
		_check(mp.custom_minimum_size == Playbook.PLAYER, "the smaller player (%s)" % mp.custom_minimum_size)
	print("MOVE_BOOK %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
