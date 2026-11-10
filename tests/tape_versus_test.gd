extends SceneTree
## Fight night's tape step is the versus picture: both sides, both buttons, every tape row inside the centre card,
## the card inside the screen, no word under 20 px, no sentence over 8 words, tags clear of the figures.

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")
const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = MAIN.instantiate()
	root.add_child(main)
	await _settle(4)
	await _picture()
	await _begin()
	await _sim()
	print("TAPE_VERSUS failures=%d" % failures)
	quit(failures)


func _picture() -> void:
	await _open()
	var page := main.modal_node() as Control
	_check(page != null and str(main.modal.get("step", "")) == "tape", "fight night opens on the tape step")
	if page == null:
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(page)
	await _settle(4)
	_check(page.find_child("Side_red", true, false) != null and page.find_child("Side_blue", true, false) != null, "a boxer on each side")
	var card := page.find_child("VersusCard", true, false) as Control
	_check(card != null, "the centre card is there")
	if card == null:
		return
	var cr := card.get_global_rect()
	_check(cr.position.x >= 0.0 and cr.position.y >= 0.0 and cr.end.x <= 1920.0 and cr.end.y <= 1080.0,
		"the centre card is inside the screen (%.1f,%.1f)-(%.1f,%.1f)" % [cr.position.x, cr.position.y, cr.end.x, cr.end.y])
	var f: Dictionary = main.career.fighter()
	var opp: Dictionary = f["bout"]["opp"]
	var data: Array = TapeRows.rows(f, opp, Faces.cm(Faces.stem(f)))
	var title := {"Record": "RECORD", "Age": "AGE", "Weight": "ON THE SCALES", "Height": "HEIGHT", "Reach": "REACH", "Stance": "STANCE"}
	for r in data:
		var row: Dictionary = r
		var key := str(row["label"])
		if not title.has(key):
			continue
		var node := card.find_child("Tape_" + str(title[key]), true, false) as Control
		_check(node != null, "the card shows %s" % key)
		if node == null:
			continue
		var rr := node.get_global_rect()
		_check(rr.position.x >= cr.position.x and rr.position.y >= cr.position.y and rr.end.x <= cr.end.x and rr.end.y <= cr.end.y,
			"%s is inside the centre card (%.1f,%.1f)-(%.1f,%.1f)" % [key, rr.position.x, rr.position.y, rr.end.x, rr.end.y])
		var texts: Array = []
		for c in node.get_children():
			if c is Label:
				texts.append((c as Label).text)
		_check(texts.size() == 3 and str(texts[0]) == str(row["left"]) and str(texts[2]) == str(row["right"]),
			"%s shows %s and %s" % [key, str(row["left"]), str(row["right"])])
	var threat := card.find_child("TapeThreat", true, false) as Label
	_check(threat != null and threat.text == "unknown: not on tape", "an unknown threat reads \"unknown: not on tape\" (%s)" % ("?" if threat == null else threat.text))
	_check(not OppFile.known(opp, "weapon"), "the weapon was not on tape")
	var film := card.find_child("FilmMark", true, false) as Control
	_check(film != null and film.custom_minimum_size.x >= 20.0 and film.custom_minimum_size.y >= 20.0, "the film mark is at least 20 px")
	var camp := card.find_child("TapeCamp", true, false) as Control
	_check(camp != null and _blob(camp).find(" of ") >= 0, "film tells read as a count beside the icon")
	for n in _walk(page):
		if not (n is Label or n is Button):
			continue
		var words := _words(n.text if n is Label else (n as Button).text)
		_check(words <= 8, "\"%s\" is %d words" % [_plain(n), words])
		var px := (n as Control).get_theme_font_size("font_size")
		_check(px >= 20, "\"%s\" is %d px" % [_plain(n), px])
		var low := " " + _plain(n).to_lower() + " "
		_check(low.find(" he ") < 0 and low.find(" she ") < 0, "\"%s\" has no he or she" % _plain(n))
	for fault in SlateWalk.faults(page):
		_check(false, str(fault))
	for corner in ["Side_red", "Side_blue"]:
		var side := page.find_child(corner, true, false) as Control
		if side == null:
			_check(false, corner + " is missing")
			continue
		var body := side.find_child("Body", true, false) as Control
		var tag := side.find_child("CornerTag", true, false) as Control
		_check(body != null and tag != null, corner + " has a figure and a tag")
		if body == null or tag == null:
			continue
		var gap := _gap(body.get_global_rect(), tag.get_global_rect())
		_check(gap >= 12.0, "%s tag clears the figure by %.1f px" % [corner, gap])
	var buttons: Array = card.find_children("*", "Button", true, false)
	_check(buttons.size() == 2, "two buttons only (%d)" % buttons.size())
	var sim := card.find_child("Sim", true, false) as Button
	var begin := card.find_child("Begin", true, false) as Button
	_check(sim != null and sim.text == "Sim to result" and str(sim.theme_type_variation) == "BtnQuiet", "Sim to result is the quiet button")
	_check(begin != null and begin.text == "Begin fight" and str(begin.theme_type_variation) == "BtnSolid", "Begin fight is the red button")
	if sim != null and begin != null:
		var sr := sim.get_global_rect()
		var br := begin.get_global_rect()
		_check(not sr.intersects(br) and sr.size.x > 1.0 and br.size.x > 1.0, "the two buttons do not overlap")
		_check(begin.tooltip_text.find("shout a call") >= 0, "the shout note is the Begin fight tooltip")
		_check(_blob(page).find("Every 30 seconds") < 0, "the shout note is not printed on the picture")


func _begin() -> void:
	await _open()
	var begin := (main.modal_node() as Node).find_child("Begin", true, false) as Button
	_check(begin != null, "Begin fight is on the tape")
	if begin != null:
		begin.pressed.emit()
	await _settle(3)
	_check(str(main.modal.get("step", "")) == "round", "Begin fight starts the round (fightstep start)")
	var node: Node = main.modal_node()
	_check(node != null and node.find_child("Shout_*", true, false) != null, "the round opens on the shout bar")


func _sim() -> void:
	await _open()
	var sim := (main.modal_node() as Node).find_child("Sim", true, false) as Button
	_check(sim != null, "Sim to result is on the tape")
	if sim != null:
		sim.pressed.emit()
	await _settle(3)
	_check(str(main.modal.get("step", "")) == "result", "Sim to result plays the bout (fightstep sim)")


func _open() -> void:
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	var f: Dictionary = c.fighter()
	f["offers"].append(Bouts._offer("lucy:tape", (Data.OPPONENTS[0] as Dictionary).duplicate(true), c.day + 21, c.day + 6, 4))
	main.act("accept", "lucy:tape")
	f = c.fighter()
	f["bout"]["day"] = c.day
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	f["camp"] = {"focus": "conditioning", "protocol": 2, "film": true}
	var opp: Dictionary = f["bout"]["opp"]
	var found: Array = (opp.get("file_found", []) as Array).duplicate()
	found.erase("weapon")
	found.erase("weakness")
	opp["file_found"] = found
	main.act("fightnight")
	await _settle(4)


func _gap(a: Rect2, b: Rect2) -> float:
	if a.intersects(b):
		return -1.0
	var dx := 0.0
	if a.end.x <= b.position.x:
		dx = b.position.x - a.end.x
	elif b.end.x <= a.position.x:
		dx = a.position.x - b.end.x
	var dy := 0.0
	if a.end.y <= b.position.y:
		dy = b.position.y - a.end.y
	elif b.end.y <= a.position.y:
		dy = a.position.y - b.end.y
	return maxf(dx, dy)


func _words(text: String) -> int:
	var n := 0
	for w in text.split(" ", false):
		if w.strip_edges() != "":
			n += 1
	return n


func _plain(n: Node) -> String:
	var t := (n as Label).text if n is Label else (n as Button).text
	return t.replace("\n", " ")


func _blob(node: Node) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for n in _walk(node):
		if n is Label:
			parts.append((n as Label).text)
	return "\n".join(parts)


func _walk(node: Node) -> Array:
	var out: Array = [node]
	for c in node.get_children():
		out.append_array(_walk(c))
	return out


func _settle(n: int) -> void:
	for _i in n:
		await process_frame


func _check(ok: bool, label: String) -> void:
	if ok:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)
