extends SceneTree
## MENUWORLD1: the World rankings page, on a real career with a ranked pro. The ladder, the win-chance band,
## Ask (only inside the promoter's band, grey once that rival is booked) and the key. Prints MENU_WORLD failures=<n>.

const Roster := preload("res://scripts/state/Roster.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var f := _ranked()
	if f.is_empty():
		_done()
		return
	FirstWeek.skip(main.career)
	var c: Career = main.career
	main.act("go", "world:1")
	await process_frame
	await process_frame
	_layout()
	var page := _node("RankingsPage")
	_check(page != null, "rankings page")
	_check(_node("FighterRow") != null, "fighter row")
	_check(_node("SportChips") != null and _node("ChipBoxing") != null, "boxing chip")
	var mma := _node("ChipMma")
	_check(mma != null and str(mma.tooltip_text) == "Not built yet", "MMA is marked not built")
	_check(mma != null and _icon_under(mma, "warn"), "MMA carries the warn icon")
	_check(_node("TitleRoute") != null, "title route")
	_check(_node("SideBySide") != null, "side by side")
	_check(_node("Key") != null, "key")
	_check(_node("NewsBox") != null, "news box")
	_check(_node("Rankings_wlw") != null, "the lightweight ladder")
	var rows := _rows()
	if rows == null:
		_check(false, "ladder rows")
		await _actions(f)
		_done()
		return
	_ladder(rows)
	var top := _by_rank(rows, 1)
	var band := _band(top)
	_check(band != null, "a win-chance band on the top row")
	var before := 0.0 if band == null else float(band.get_meta("span"))
	if top != null:
		main.act("proscout", "%s:%s" % [str(f["id"]), str(top.get_meta("oid"))])
		await process_frame
		var again := _band(_by_rank(_rows(), 1))
		_check(again != null and float(again.get_meta("span")) < before - 0.001, "the band is wider unscouted than scouted (%.3f then %.3f)" % [before, 0.0 if again == null else float(again.get_meta("span"))])
	var eighth := _boxer(c, f, 8)
	var booked: Dictionary = ProLadder.book(c, f, int(eighth.get("id", 0)), true)
	_check(bool(booked.get("ok", false)), "books a rival inside the band (%s)" % str(booked.get("reason", "")))
	main.render()
	await process_frame
	rows = _rows()
	_asks(rows)
	var hit := _booked_row(rows)
	var ask := _ask(hit)
	_check(ask != null and ask.disabled and str(ask.tooltip_text).contains("Booked"), "the booked rival's Ask is grey (%s)" % ("" if ask == null else ask.tooltip_text))
	_icons()
	await _actions(f)
	_done()


func _ranked() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	f["w"] = 9
	f["l"] = 1
	Roster.check_pro(c)
	Roster.turn_pro(c)
	ProLadder.join(c, f)
	f["bout"] = {}
	f["booked_fight"] = false
	var e := ProLadder.entry(c, f)
	var twelfth := _boxer(c, f, 12)
	_check(not e.is_empty() and not twelfth.is_empty(), "a real pro table")
	if e.is_empty() or twelfth.is_empty():
		return {}
	WR.apply_result_in(e, twelfth, ProLadder.table(c, f))
	_check(int(e.get("rank", 0)) > 0, "the fighter is ranked (#%d)" % int(e.get("rank", 0)))
	_unscout(f, 3)
	return f


func _boxer(c: Career, f: Dictionary, rank: int) -> Dictionary:
	for b in ProLadder.table(c, f):
		if int(b.get("rank", 0)) == rank and not bool(b.get("player", false)):
			return b
	return {}


func _ladder(rows: Node) -> void:
	var last := 0
	var you := 0
	var others := 0
	var n := rows.get_child_count()
	for i in n:
		var ch := rows.get_child(i)
		var rk := int(ch.get_meta("rank", 0))
		var mine := bool(ch.get_meta("mine", false))
		if mine and rk == 0:
			_check(i == n - 1, "an unranked fighter is pinned at the bottom")
		else:
			_check(rk > last, "rank order (%d then %d)" % [last, rk])
			if not mine:
				_check(rk <= 10, "only the top ten beside your fighter")
				others += 1
			last = rk
		if mine:
			you += 1
	_check(you == 1, "your fighter is on the ladder once")
	_check(others <= 10 and n <= 11, "at most 10 plus your fighter (%d)" % n)


func _asks(rows: Node) -> void:
	if rows == null:
		_check(false, "asks")
		return
	var shown := 0
	for ch in rows.get_children():
		var ask := _ask(ch)
		var reach := bool(ch.get_meta("reach", false))
		if bool(ch.get_meta("mine", false)):
			_check(ask == null, "no Ask on your own row")
		elif reach:
			_check(ask != null, "Ask on a row in reach (#%d)" % int(ch.get_meta("rank", 0)))
			shown += 1
		else:
			_check(ask == null, "no Ask out of reach (#%d)" % int(ch.get_meta("rank", 0)))
	_check(shown > 0, "at least one rival is inside the promoter's band")


func _icons() -> void:
	var page := _node("RankingsPage")
	var key := _node("Key")
	var drawn := 0
	if page == null or key == null:
		_check(false, "icons have a key")
		return
	for n in page.find_children("*", "TextureRect", true, false):
		if not n.has_meta("icon"):
			continue
		var id := str(n.get_meta("icon"))
		drawn += 1
		_check(key.find_child("Key_" + id, true, false) != null, "the key names %s" % id)
		_check(KitIcon.has_icon(id), "%s is a kit icon" % id)
	_check(drawn > 0, "the page draws icons")


func _actions(f: Dictionary) -> void:
	main.act("go", "world:0")
	await process_frame
	_check(_node("NewsCols") != null, "news is still there")
	_check(_node("Fixtures") != null, "the fixture list is still there")
	main.act("go", "world:2")
	await process_frame
	_check(" ".join(_texts(main._shell)).to_lower().contains("national"), "championships still open")
	main.act("go", "world:3")
	await process_frame
	_check(int(main.route["tab"]) == 1 and _node("RankingsPage") != null, "search still lands on rankings")
	var who := _node("Fighter_" + str(f["id"])) as Button
	_check(who != null, "the fighter's name is still a link")
	if who != null:
		who.pressed.emit()
		await process_frame
		_check(str(main.route["area"]) == "fighters", "the name opens the fighter")
	main.act("go", "world:1")
	await process_frame
	var file := _file()
	_check(file != null, "a rival's file is still a link")
	if file != null:
		file.pressed.emit()
		await process_frame
		_check(str(main.modal.get("type", "")) == "info" and str(main.modal.get("title", "")) != "", "the file opens")
		main.act("close")
	var c: Career = main.career
	if not c.grapplers.is_empty():
		_check(_node("MatLink_" + str(c.grapplers[0]["id"])) != null, "the mat link is still there")


func _rows() -> Node:
	var ladder := _node("Rankings_wlw")
	return null if ladder == null else ladder.find_child("LadderRows", true, false)


func _by_rank(rows: Node, rank: int) -> Node:
	if rows == null:
		return null
	for ch in rows.get_children():
		if int(ch.get_meta("rank", 0)) == rank and not bool(ch.get_meta("mine", false)):
			return ch
	return null


func _booked_row(rows: Node) -> Node:
	if rows == null:
		return null
	for ch in rows.get_children():
		if bool(ch.get_meta("booked_opp", false)):
			return ch
	return null


func _ask(row: Node) -> Button:
	return null if row == null else row.find_child("Ask_*", true, false) as Button


func _band(row: Node) -> Node:
	return null if row == null else row.find_child("WinBand", true, false)


func _file() -> Button:
	var box := _node("RegionFiles")
	return null if box == null else box.find_child("File_*", true, false) as Button


func _icon_under(n: Node, id: String) -> bool:
	if n == null:
		return false
	for ch in n.find_children("*", "TextureRect", true, false):
		if str(ch.get_meta("icon", "")) == id:
			return true
	return false


func _node(name: String) -> Node:
	return null if main._shell == null else main._shell.find_child(name, true, false)


func _texts(n: Node) -> Array:
	var out: Array = []
	if n == null:
		return out
	if n is Label:
		out.append((n as Label).text)
	for k in n.get_children():
		out.append_array(_texts(k))
	return out


## One rival with an empty file, so the page has an unscouted band beside the partly scouted ones.
func _unscout(f: Dictionary, rank: int) -> void:
	var b := _boxer(main.career, f, rank)
	if b.is_empty():
		return
	var book: Dictionary = f.get_or_add("pro_scout", {})
	book[str(int(b["id"]))] = {"id": int(b["id"]), "file_found": [], "scouted": false}


## Laid out at 1920x1080, guide strip already off, two frames after the page opened.
func _layout() -> void:
	_check(str(main.career.guide) == "", "guide strip hidden")
	var rows := _rows()
	_check(rows != null and rows.get_child_count() >= 10, "ten ladder rows to measure")
	if rows == null:
		return
	var you := false
	for ch in rows.get_children():
		if bool(ch.get_meta("mine", false)):
			you = true
		var btn := _name_button(ch)
		var wide := btn != null and btn.is_visible_in_tree() and btn.size.x >= 120.0
		_check(wide, "name button at least 120 px (%s)" % ("" if btn == null else "%s %.0f" % [btn.text, btn.size.x]))
		if btn != null:
			var tw := _text_width(btn, btn.text)
			_check(tw <= _text_room(btn) + 0.5, "name fits in its button (%s %.0f in %.0f)" % [btn.text, tw, _text_room(btn)])
		var style := _style_label(ch)
		_check(style != null, "a style label")
		if style != null:
			var sw := _text_width(style, style.text)
			_check(not style.clip_text and sw <= style.size.x + 0.5, "style fits (%s %.0f in %.0f)" % [style.text, sw, style.size.x])
		_check(_fully_shown(ch as Control), "row on screen without the list scrolling (%s)" % ch.name)
	_check(you, "the player's row is on the list")
	var head := _header_box(rows)
	var cells := _cells(rows.get_child(0))
	_check(head != null and cells != null and head.get_child_count() == cells.get_child_count(), "header and the first row share columns")
	if head != null and cells != null:
		var n := mini(head.get_child_count(), cells.get_child_count())
		for i in n:
			var dx := absf((head.get_child(i) as Control).get_global_rect().position.x - (cells.get_child(i) as Control).get_global_rect().position.x)
			_check(dx <= 4.0, "header %d lines up with its column (%.1f px)" % [i, dx])
		var last := cells.get_child(cells.get_child_count() - 1) as Control
		var board := _board()
		if last != null and board != null:
			var gap := absf(_inner_right(board) - last.get_global_rect().end.x)
			_check(gap <= 32.0, "last column reaches the board (%.1f px short)" % gap)
	var scroll := _page_scroll()
	if scroll == null:
		_check(false, "page scroll")
	else:
		var bar := scroll.get_v_scroll_bar()
		_check(bar.max_value <= bar.page + 1.0, "no page scrollbar (content %.0f, view %.0f)" % [bar.max_value, bar.page])
	for id in ["TitleRoute", "Key"]:
		var panel := _node(id) as Control
		_check(panel != null and _fully_shown(panel), "%s is on screen" % id)
	var bare: Node = null
	var part: Node = null
	for ch in rows.get_children():
		var band := _band(ch)
		if band == null or band.get("scouted") == null:
			continue
		if int(band.get("scouted")) == 0:
			bare = band
		elif int(band.get("scouted")) == 1:
			part = band
	_check(bare != null and part != null and int(bare.get("scouted")) != int(part.get("scouted")), "unscouted and partly scouted bands differ")


func _name_button(row: Node) -> Button:
	if row == null:
		return null
	for b in row.find_children("*", "Button", true, false):
		if str(b.name).begins_with("Ask"):
			continue
		return b as Button
	return null


func _style_label(row: Node) -> Label:
	var named := row.find_child("Style", true, false)
	if named is Label:
		return named
	for lab in row.find_children("*", "Label", true, false):
		var t := str((lab as Label).text)
		if t.contains("puncher") or t.contains("boxer") or t.contains("Swarmer") or t == "Out-boxer" or t == "Pressure fighter":
			return lab
	return null


func _header_box(rows: Node) -> HBoxContainer:
	var named := _node("LadderHead")
	if named is HBoxContainer:
		return named
	var p := rows.get_parent()
	if p == null:
		return null
	for ch in p.get_children():
		if ch is HBoxContainer:
			return ch
	return null


func _cells(row: Node) -> HBoxContainer:
	if row == null:
		return null
	for ch in row.get_children():
		if ch is HBoxContainer:
			return ch
	return null


func _board() -> Control:
	var page := _node("RankingsPage")
	if page == null:
		return null
	for ch in page.find_children("*", "PanelContainer", true, false):
		if str(ch.name).begins_with("Rankings_"):
			return ch
	return null


func _page_scroll() -> ScrollContainer:
	var n: Node = _node("RankingsPage")
	var last: ScrollContainer = null
	while n != null:
		if n is ScrollContainer:
			last = n
		n = n.get_parent()
	return last


func _inner_right(board: Control) -> float:
	var sb := board.get_theme_stylebox("panel")
	var inset := 0.0 if sb == null else sb.get_margin(SIDE_RIGHT)
	return board.get_global_rect().end.x - inset


func _fully_shown(c: Control) -> bool:
	if c == null or not c.is_visible_in_tree():
		return false
	var r := c.get_global_rect()
	if r.size.y < 8.0 or r.position.y < -1.0 or r.end.y > 1081.0:
		return false
	var p: Node = c.get_parent()
	while p != null:
		if p is ScrollContainer:
			var sr := (p as Control).get_global_rect()
			if r.position.y < sr.position.y - 1.0 or r.end.y > sr.end.y + 1.0:
				return false
		p = p.get_parent()
	return true


func _text_width(c: Control, text: String) -> float:
	var font := c.get_theme_font("font")
	if font == null:
		return 9999.0
	return font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, c.get_theme_font_size("font_size")).x


func _text_room(c: Control) -> float:
	var sb := c.get_theme_stylebox("normal")
	if sb == null:
		return c.size.x
	return c.size.x - sb.get_margin(SIDE_LEFT) - sb.get_margin(SIDE_RIGHT)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1


func _done() -> void:
	print("MENU_WORLD failures=%d" % failures)
	quit(0 if failures == 0 else 1)
