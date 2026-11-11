extends SceneTree
## FACEFRAME1. Every face slot on the real screens must show the whole head (hair to chin, ear to ear) plus a margin
## of 6% of that height. The visible rect is what the engine keeps: the atlas region, the stretch, the control, and
## any clip. Head boxes are scripts/ui/face_boxes.json.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightPoster := preload("res://scripts/ui/FightPoster.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")

var failures := 0
var main: Node
var _boxes := {}
var _rows: Array = []


func _initialize() -> void:
	var all = JSON.parse_string(FileAccess.get_file_as_string("res://scripts/ui/face_boxes.json"))
	_boxes = (all as Dictionary).get("sets", {}) if all is Dictionary else {}
	_check(not _boxes.is_empty(), "head boxes load")
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)
	await _settle()
	await _screens()
	_shapes()
	await _settle()
	print("CENSUS")
	print("screen | node | source | slot | stretch | visible | head | ok")
	for row in _rows:
		print(row)
	print("FACE_FRAME failures=%d" % failures)
	print("PASS face_frame_test" if failures == 0 else "FAIL face_frame_test")
	quit(failures)


func _screens() -> void:
	main.act("quick")
	await _settle()
	await _shoot("home")
	main.act("interview")
	await _settle()
	await _shoot("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("guideskip")
	main.close_modal()
	await _settle()
	await _shoot("signed")
	main.act("go", "fighters:0")
	await _settle()
	await _shoot("roster")
	var to_table: Button = main.find_child("View_table", true, false)
	if to_table != null:
		to_table.pressed.emit()
		await _settle()
		await _shoot("table")
	main.act("go", "gym:1")
	await _settle()
	await _shoot("people")
	main.act("go", "world:1")
	await _settle()
	await _shoot("ladder")
	var f: Dictionary = await _book()
	if f.is_empty():
		_check(false, "an even offer is booked")
		return
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _settle()
	await _shoot("training")
	main.act("camp", str(f["id"]))
	await _settle()
	await _shoot("camp")
	main.close_modal()
	await _settle()
	var poster: Control = FightPoster.build(main.career, f, 420.0)
	if poster != null:
		poster.position = Vector2(80, 40)
		main.add_child(poster)
		await _settle()
		await _shoot("poster")
		poster.queue_free()
	_check(_count("home") + _count("signed") > 0, "home draws a face")
	_check(_count("interview") > 0, "the interview draws a face")
	_check(_count("table") > 0, "the roster table draws a face")
	_check(_count("camp") > 0, "the camp draws a face")
	_check(_count("training") > 0, "the week board draws a face")
	_check(_count("poster") > 0, "the poster draws a face")
	_check(_count("people") > 0, "the people page draws a face")


func _book() -> Dictionary:
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	var offer := ""
	for _i in 60:
		for o in f["offers"]:
			if not bool(o["mismatch"]) and not bool(o["answered"]):
				offer = str(o["id"])
				break
		if offer != "":
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	if offer == "":
		return {}
	main.act("openBout", offer)
	await _settle()
	await _shoot("bout")
	main.act("accept", offer)
	await _settle()
	await _shoot("booked")
	return f


func _shoot(tag: String) -> void:
	var found: Array = []
	for node in _walk(main):
		if node is TextureRect and _is_face(node as TextureRect):
			found.append(node)
	var n := 0
	for node in found:
		var rect := node as TextureRect
		_reveal(rect)
		await process_frame
		if not _is_face(rect):
			continue
		var path := _root_path(rect.texture)
		var head := _head(_set_of(path), path.get_file().get_basename())
		var image := _root(rect.texture).get_size()
		var visible := _visible(rect)
		var ok := _holds(head, visible, image, rect)
		if not ok:
			failures += 1
		n += 1
		_rows.append("%s | %s | %s %dx%d | %.0fx%.0f | %s | %s | %s | %s" % [
			tag, str(rect.get_path()).replace(str(main.get_path()), ""), path.get_file(),
			int(image.x), int(image.y), rect.size.x, rect.size.y, _stretch(rect.stretch_mode),
			_r(visible), _r(head), "ok" if ok else "FAIL"])
	_rows.append("%s count %d" % [tag, n])


func _is_face(rect: TextureRect) -> bool:
	return rect.is_visible_in_tree() and rect.texture != null and rect.size.x >= 2.0 and rect.size.y >= 2.0 and _set_of(_root_path(rect.texture)) != ""


## Bring a slot into its scroll, so the crop measured is the one the player sees.
func _reveal(rect: Control) -> void:
	var n: Node = rect.get_parent()
	while n != null:
		if n is ScrollContainer:
			var sc := n as ScrollContainer
			var slot := rect.get_global_rect()
			var view := sc.get_global_rect()
			sc.scroll_vertical = int(maxf(0.0, sc.scroll_vertical + slot.position.y - view.position.y - 24.0))
			sc.scroll_horizontal = int(maxf(0.0, sc.scroll_horizontal + slot.position.x - view.position.x - 24.0))
		n = n.get_parent()


func _count(tag: String) -> int:
	var n := 0
	for row in _rows:
		if str(row).begins_with(tag + " |"):
			n += 1
	return n


func _holds(head: Rect2, visible: Rect2, image: Vector2, rect: TextureRect) -> bool:
	if head.size.x < 1.0 or visible.size.x < 1.0:
		return false
	var m := head.size.y * 0.06
	var safe := Rect2(head.position - Vector2(m, m), head.size + Vector2(m, m) * 2.0)
	safe = safe.intersection(Rect2(Vector2.ZERO, image))
	if bool(rect.get_meta("face_round", false)):
		return _circle_holds(safe, rect)
	return visible.grow(1.5).encloses(safe)


func _circle_holds(safe: Rect2, rect: TextureRect) -> bool:
	var region := _source_region(rect.texture)
	var slot := rect.size
	var c := slot * 0.5
	var rad := minf(slot.x, slot.y) * 0.5 + 1.0
	for p in [safe.position, Vector2(safe.end.x, safe.position.y), safe.end, Vector2(safe.position.x, safe.end.y)]:
		var u := Vector2((p.x - region.position.x) / region.size.x, (p.y - region.position.y) / region.size.y)
		if Vector2(u.x * slot.x, u.y * slot.y).distance_to(c) > rad:
			return false
	return true


## Picture pixels that land inside the slot, after stretch, atlas region and ancestor clips.
func _visible(rect: TextureRect) -> Rect2:
	var tex := rect.texture
	var tex_size := tex.get_size()
	if tex_size.x < 1.0 or tex_size.y < 1.0:
		return Rect2()
	var dest := _dest(rect.stretch_mode, rect.size, tex_size)
	var clip := Rect2(Vector2.ZERO, rect.size)
	var n: Node = rect.get_parent()
	while n is CanvasItem:
		if n is Control and (n as Control).clip_contents:
			var inv: Transform2D = rect.get_global_transform().affine_inverse()
			clip = clip.intersection(inv * (n as Control).get_global_rect())
		n = n.get_parent()
	var shown := dest.intersection(clip)
	if shown.size.x < 0.5 or shown.size.y < 0.5:
		return Rect2()
	var u := Rect2((shown.position - dest.position) / dest.size, shown.size / dest.size)
	var local := Rect2(u.position * tex_size, u.size * tex_size)
	var region := _source_region(tex)
	return Rect2(region.position + local.position, local.size)


func _dest(mode: int, slot: Vector2, tex: Vector2) -> Rect2:
	if mode == TextureRect.STRETCH_KEEP_ASPECT_COVERED:
		var w := tex.x * slot.y / tex.y
		var h := slot.y
		if w < slot.x:
			w = slot.x
			h = tex.y * w / tex.x
		return Rect2((slot.x - w) * 0.5, (slot.y - h) * 0.5, w, h)
	if mode == TextureRect.STRETCH_KEEP_ASPECT or mode == TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
		var w2 := tex.x * slot.y / tex.y
		var h2 := slot.y
		if w2 > slot.x:
			w2 = slot.x
			h2 = tex.y * w2 / tex.x
		var at := Vector2.ZERO
		if mode == TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
			at = (slot - Vector2(w2, h2)) * 0.5
		return Rect2(at, Vector2(w2, h2))
	if mode == TextureRect.STRETCH_KEEP:
		return Rect2(Vector2.ZERO, tex)
	if mode == TextureRect.STRETCH_KEEP_CENTERED:
		return Rect2((slot - tex) * 0.5, tex)
	return Rect2(Vector2.ZERO, slot)


func _source_region(tex: Texture2D) -> Rect2:
	if tex is AtlasTexture:
		var a := tex as AtlasTexture
		var parent := _source_region(a.atlas)
		return Rect2(parent.position + a.region.position, a.region.size)
	return Rect2(Vector2.ZERO, tex.get_size())


func _shapes() -> void:
	if not ResourceLoader.exists("res://scripts/ui/FaceFrame.gd"):
		return
	var FaceFrame: GDScript = load("res://scripts/ui/FaceFrame.gd")
	var tex: Texture2D = load("res://assets/ui/face/studio/mh_boxer_11.jpg")
	var head: Rect2 = FaceFrame.box_for(tex)
	var host := Control.new()
	host.size = Vector2(900, 500)
	host.position = Vector2(20, 20)
	main.add_child(host)
	var i := 0
	for spec in [["square", Vector2(180, 180), false], ["tall", Vector2(120, 220), false], ["wide", Vector2(280, 120), false], ["round", Vector2(200, 200), true]]:
		var r := TextureRect.new()
		r.name = "Shape_" + str(spec[0])
		r.texture = tex
		r.position = Vector2(20 + i * 220, 20)
		if bool(spec[2]):
			r.set_meta("face_round", true)
		FaceFrame.fit(r, head, spec[1], bool(spec[2]))
		host.add_child(r)
		i += 1
	# laid out below, once the frames exist
	for child in host.get_children():
		var r2 := child as TextureRect
		r2.size = r2.custom_minimum_size
		var image := _root(r2.texture).get_size()
		var ok := _holds(head, _visible(r2), image, r2)
		if not ok:
			failures += 1
		_rows.append("shape | %s | %s | %.0fx%.0f | %s | %s | %s | %s" % [
			r2.name, "studio", r2.size.x, r2.size.y, _stretch(r2.stretch_mode), _r(_visible(r2)), _r(head), "ok" if ok else "FAIL"])
	host.queue_free()


func _head(set_name: String, stem: String) -> Rect2:
	var table: Dictionary = _boxes.get(set_name, {})
	var row = table.get(stem, [])
	if row is Array and (row as Array).size() == 4:
		return Rect2(float(row[0]), float(row[1]), float(row[2]), float(row[3]))
	return Rect2()


func _set_of(path: String) -> String:
	if path.contains("/style_b/"):
		return "style_b"
	if path.contains("/face/studio/"):
		return "studio"
	if path.contains("/face/poster/"):
		return "poster"
	if path.contains("/fullbody/"):
		return "fullbody"
	if path.contains("guide_trainer"):
		return "guide"
	if path.contains("/face/"):
		return "dark"
	return ""


func _root(tex: Texture2D) -> Texture2D:
	var t := tex
	while t is AtlasTexture:
		t = (t as AtlasTexture).atlas
	return t


func _root_path(tex: Texture2D) -> String:
	var t := _root(tex)
	return "" if t == null else t.resource_path


func _stretch(mode: int) -> String:
	if mode == TextureRect.STRETCH_KEEP_ASPECT_COVERED:
		return "covered"
	if mode == TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
		return "centered"
	if mode == TextureRect.STRETCH_KEEP_ASPECT:
		return "aspect"
	if mode == TextureRect.STRETCH_SCALE:
		return "scale"
	return str(mode)


func _r(v: Rect2) -> String:
	return "%d,%d %dx%d" % [int(v.position.x), int(v.position.y), int(v.size.x), int(v.size.y)]


func _walk(n: Node) -> Array:
	var out: Array = [n]
	for c in n.get_children():
		out.append_array(_walk(c))
	return out


func _settle() -> void:
	root.size = Vector2i(1920, 1080)
	for _i in 3:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + what)
