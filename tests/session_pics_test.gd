extends SceneTree
## TRAINCLIPS1 r5: what the eight training cards must be, read off the PNGs themselves.
## The round-4 test passed while the pictures were wrong, so every check here measures the file on disk - never the
## skeleton or the scene before the ink pass ran. tools/bake_session_pics.gd writes the cards and session_pics.json.

const TW := preload("res://scripts/rules/TrainingWeek.gd")
const SPS := preload("res://tools/session_pic_style.gd")

const DIR := "res://assets/ui/training"
const JSON_PATH := "res://assets/ui/training/session_pics.json"
const MH_DIR := "res://assets/models/metahuman"
const BOARD := "res://scripts/ui/TrainingBoard.gd"
const SIZE := 256
const EDGE_PAD := 6                 # everything is drawn inside this margin
const MIN_BODY_FRAC := 0.75         # head to feet fills the card
const MIN_REACH_WIDTH_FRAC := 0.45  # a punch card is wide
const PROP_NEAR_PX := 6             # the prop touches the glove
const MIN_REACH_STRAIGHT := 0.45    # wrist to shoulder at contact, metres
const MIN_REACH_SHORT := 0.38       # a short punch (speed bag) and a hook (pads); the smallest body measures 0.399
const MIN_MITT_PX := 120
const MIN_PUNCH_REACH_PX := 60      # the fist ends up this far from her head in the picture
const HEAD_BAG_PX := 8              # no bag pixel this close to a head pixel
const MIN_OUTLINE_PX := 400
const MIN_KIT_PX := 300
const MIN_DIFF_FRAC := 0.02         # the eight cards of a body are eight pictures
const MAX_PNG_BYTES := 120 * 1024
const UPPER_IDS := ["shadow", "heavy_bag", "pads", "speed_bag"]   # the two-figure cards
const GLOVE_LEN_M := 0.20           # a glove's length: glove_gap is measured from the WRIST bone

var failures := 0
var _widths: Dictionary = {}
var _images_by_stem: Dictionary = {}


func _initialize() -> void:
	_check_training_board()
	var stems := _boxer_stems()
	for stem in stems:
		_images_by_stem[stem] = []
		for s in TW.SESSIONS:
			_check_one(stem, str(s["id"]))
		_check_unique(stem)
	_check_json(stems)
	_check_width_compare()
	print("SESSION_PICS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _boxer_stems() -> Array:
	var out: Array = []
	for f in DirAccess.get_files_at(MH_DIR):
		var file := str(f)
		if file.begins_with("mh_boxer_") and file.ends_with(".glb"):
			out.append(file.get_basename())
	out.sort()
	return out


## The board must ask the resource loader (an exported build has no loose files to stat) and fall back to the icon.
func _check_training_board() -> void:
	var src := FileAccess.get_file_as_string(BOARD)
	if not "ResourceLoader.exists(" in src:
		failures += 1
		print("FAIL TrainingBoard does not use ResourceLoader.exists for the session picture")
	if not "assets/ui/training" in src:
		failures += 1
		print("FAIL TrainingBoard does not look in assets/ui/training")
	if not "Icons.icon" in src:
		failures += 1
		print("FAIL TrainingBoard has no icon for a session without a picture")


func _check_one(stem: String, id: String) -> void:
	var path := "%s/%s_%s.png" % [DIR, stem, id]
	if not FileAccess.file_exists(path):
		failures += 1
		print("FAIL missing ", path)
		return
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.size() > MAX_PNG_BYTES:
		failures += 1
		print("FAIL too large ", path, " ", bytes.size())
	var img := Image.load_from_file(path)
	if img == null:
		failures += 1
		print("FAIL load ", path)
		return
	if img.get_width() != SIZE or img.get_height() != SIZE:
		failures += 1
		print("FAIL size ", path, " ", img.get_size())
		return
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	if not _corners_bg(img):
		failures += 1
		print("FAIL bg corners ", path)
	if not _opaque(img):
		failures += 1
		print("FAIL not an opaque tile ", path)
	if SPS.count_outline(img) < MIN_OUTLINE_PX:
		failures += 1
		print("FAIL outline pixels ", path, " ", SPS.count_outline(img))
	if _count_kit(img) < MIN_KIT_PX:
		failures += 1
		print("FAIL kit red ", path, " ", _count_kit(img))
	var box := SPS.figure_box(img)
	if box.size.x <= 0 or box.size.y <= 0:
		failures += 1
		print("FAIL empty ", path)
		return
	if float(box.size.y) / float(SIZE) < MIN_BODY_FRAC:
		failures += 1
		print("FAIL short body ", path, " h=", box.size.y)
	if box.position.x < EDGE_PAD or box.position.y < EDGE_PAD \
			or box.position.x + box.size.x > SIZE - EDGE_PAD or box.position.y + box.size.y > SIZE - EDGE_PAD:
		failures += 1
		print("FAIL cropped ", path, " box=", box)
	if id in ["heavy_bag", "pads", "speed_bag"] and not _prop_near_glove(img):
		failures += 1
		print("FAIL prop near glove ", path)
	if id == "heavy_bag":
		if not _prop_clear_border(img):
			failures += 1
			print("FAIL heavy_bag border ", path)
		if not _head_prop_clear(img, HEAD_BAG_PX):
			failures += 1
			print("FAIL bag within ", HEAD_BAG_PX, " px of her head ", path)
	if id == "pads" and _count_prop(img) < MIN_MITT_PX:
		failures += 1
		print("FAIL pads mitt pixels ", path, " ", _count_prop(img))
	if id in UPPER_IDS and _punch_reach_px(img, box) < MIN_PUNCH_REACH_PX:
		failures += 1
		print("FAIL punch reach px ", path, " ", _punch_reach_px(img, box))
	if id in ["shadow", "heavy_bag", "pads", "sparring", "neck"]:
		var wf := float(box.size.x) / float(SIZE)
		_widths["%s_%s" % [stem, id]] = wf
		if id in ["shadow", "heavy_bag", "pads"] and wf < MIN_REACH_WIDTH_FRAC:
			failures += 1
			print("FAIL narrow reach ", path, " w=", box.size.x)
	_images_by_stem[stem].append(img)


func _check_unique(stem: String) -> void:
	var imgs: Array = _images_by_stem[stem]
	for i in imgs.size():
		for j in range(i + 1, imgs.size()):
			if SPS.pixel_diff_frac(imgs[i], imgs[j]) < MIN_DIFF_FRAC:
				failures += 1
				print("FAIL too similar ", stem, " ", i, " ", j)


func _check_json(stems: Array) -> void:
	if not FileAccess.file_exists(JSON_PATH):
		failures += 1
		print("FAIL missing ", JSON_PATH)
		return
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(JSON_PATH))
	if not data is Dictionary:
		failures += 1
		print("FAIL json parse ", JSON_PATH)
		return
	for stem in stems:
		if not data.has(stem):
			failures += 1
			print("FAIL json missing stem ", stem)
			continue
		var row: Dictionary = data[stem]
		for sid in TW.SESSIONS:
			var id := str(sid["id"])
			if not row.has(id):
				failures += 1
				print("FAIL json missing ", stem, " ", id)
		_check_props(row, stem)
		_check_reach(row, stem)
		_check_speed_ball(row.get("speed_bag", {}), stem)


## The props touch the fist and stay off her head. glove_gap is wrist-to-prop, so a touching glove measures its own length.
func _check_props(row: Dictionary, stem: String) -> void:
	for sid in ["heavy_bag", "pads", "speed_bag"]:
		var m: Dictionary = row.get(sid, {})
		if m.is_empty():
			continue
		if float(m.get("glove_gap", 99.0)) > GLOVE_LEN_M:
			failures += 1
			print("FAIL glove_gap ", stem, " ", sid, " ", m)
		if float(m.get("head_prop", 0.0)) < 0.12:
			failures += 1
			print("FAIL head_prop ", stem, " ", sid, " ", m)


func _check_reach(row: Dictionary, stem: String) -> void:
	for sid in ["shadow", "heavy_bag"]:
		_reach_at_least(row.get(sid, {}), MIN_REACH_STRAIGHT, stem, sid)
	for sid in ["pads", "speed_bag"]:
		_reach_at_least(row.get(sid, {}), MIN_REACH_SHORT, stem, sid)


func _reach_at_least(m: Dictionary, need: float, stem: String, sid: String) -> void:
	if m.is_empty():
		return
	if float(m.get("reach", 0.0)) < need:
		failures += 1
		print("FAIL reach ", stem, " ", sid, " ", float(m.get("reach", 0.0)), " < ", need)


## The speed bag hangs in front of her at the height of the fists - at the top of a short punch, not thrown away. The
## round-4 rule ("the ball at least 0.15 m below her head") contradicted the brief's own pose, so it is gone; what has to
## hold is that the ball is not above her head, hangs in front, and her fist is up near her eyes.
func _check_speed_ball(m: Dictionary, stem: String) -> void:
	if m.is_empty():
		return
	if float(m.get("ball_below_head", -99.0)) < -0.06:
		failures += 1
		print("FAIL ball above her head ", stem, " ", m)
	if float(m.get("ball_in_front", -1.0)) < 0.15:
		failures += 1
		print("FAIL ball_in_front ", stem, " ", m)
	if float(m.get("hand_below_eyes", 99.0)) > 0.34:
		failures += 1
		print("FAIL speed bag hand not up at her eyes ", stem, " ", m)


## A punch card is wider than a guard card - the reach has to be in the picture, not just in the pose.
func _check_width_compare() -> void:
	var stem := "mh_boxer_10"
	if not _widths.has("%s_heavy_bag" % stem):
		return
	var hb: float = _widths["%s_heavy_bag" % stem]
	for sid in ["sparring", "neck"]:
		var k := "%s_%s" % [stem, sid]
		if _widths.has(k) and _widths[k] >= hb:
			failures += 1
			print("FAIL width not narrower than heavy_bag ", k, " ", _widths[k], " hb=", hb)


func _corners_bg(img: Image) -> bool:
	for p in [Vector2i(0, 0), Vector2i(SIZE - 1, 0), Vector2i(0, SIZE - 1), Vector2i(SIZE - 1, SIZE - 1)]:
		if not SPS.is_bg(img.get_pixel(p.x, p.y)):
			return false
	return true


func _opaque(img: Image) -> bool:
	for p in [Vector2i(0, 0), Vector2i(SIZE / 2, SIZE / 3), Vector2i(SIZE - 1, SIZE - 1)]:
		if img.get_pixel(p.x, p.y).a < 0.99:
			return false
	return true


func _prop_near_glove(img: Image) -> bool:
	var gloves: Array = SPS.kit_red_pixels(img)
	var props: Array = SPS.prop_pixels(img)
	if gloves.is_empty() or props.is_empty():
		return false
	for g in gloves:
		for p in props:
			if (g as Vector2i).distance_to(p) <= float(PROP_NEAR_PX):
				return true
	return false


## The furthest a glove pixel gets from her head's skin: the punch has to be out, not tucked in.
func _punch_reach_px(img: Image, box: Rect2i) -> float:
	var head := SPS.head_skin_pixels(img, box)
	var gloves: Array = SPS.kit_red_pixels(img)
	if head.is_empty() or gloves.is_empty():
		return 0.0
	var best := 0.0
	for g in gloves:
		var gp: Vector2i = g
		var near := INF
		for h in head:
			near = minf(near, gp.distance_to(h))
		best = maxf(best, near)
	return best


func _head_prop_clear(img: Image, need: int) -> bool:
	var box := SPS.figure_box(img)
	var head := SPS.head_skin_pixels(img, box)
	var props: Array = SPS.prop_pixels(img)
	if head.is_empty() or props.is_empty():
		return false
	var best := INF
	for p in props:
		for h in head:
			best = minf(best, (p as Vector2i).distance_to(h))
	return best >= float(need)


func _prop_clear_border(img: Image) -> bool:
	var pad := 5
	for y in SIZE:
		for x in SIZE:
			if not SPS.near_prop(img.get_pixel(x, y)):
				continue
			if x <= pad or x >= SIZE - 1 - pad or y <= pad or y >= SIZE - 1 - pad:
				return false
	return true


func _count_prop(img: Image) -> int:
	return SPS.prop_pixels(img).size()


func _count_kit(img: Image) -> int:
	return SPS.kit_red_pixels(img).size()