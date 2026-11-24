extends "res://tools/pics2d_bodycross_stage.gd"
## THE BODY CROSS, BEFORE v AFTER, on the pictures' own fixed side camera (orthographic, level, red on the left; never a
## corner frame - owner S537), AND THE SHEET OF TWELVE PICTURES the owner marks. BODYCROSS1 (S542) filmed the head cross
## against its new take; BODYCROSS2 (S545, C500 "does not reach opponent") the S542 take against the re-authored one;
## BODYCROSS3 (S546, owner C502 on BODYCROSS2's own sheet: "there is no elbow bent , the reaction should force the
## opponent to bend hisposture a bit") films:
##   before  an earlier version of the take (old=<its .res>, row=<its clip_db row as JSON>), as it was shown then:
##           old_as=filmed (S542: the game's finish armed, the hit man's take from its first key on the spot) or
##           old_as=own (S545: its own keys, the hit man's answer old_react=<take> by the v2 player's start rule);
##   after   the take as it is on disk on its own keys, the hit man playing react=<take> (game = the v2 player's pick).
## The same pair, the same camera (fixed for the whole film, wide enough for the hit man's step back). Each side is
## played whole at 60 pictures a second from the guard.
## THE SHEET: caps_before= / caps_after= name a tools/bodycross3_ruler.gd JSON of the same run. Every picture of its
## sheet (3 before the touch to 8 after) is then captioned with what the ruler read ON THAT PICTURE (the elbow as seen,
## his fold), and the twelve are tiled into <out>/<before|after>_sheet.png; <out>/touch_before_after.png holds each
## side's touch picture and the one TOUCH_LATER pictures after it.
## Writes <out>/<before|after>_NNN.png and prints which picture the contact key is drawn on.
##   python tools/hidden_desktop.py run --timeout=900 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_bodycross_film.gd -- <out_dir> art=toon set=w|m [who=0|1] [old=<res> row=<json> old_as=own old_react=<take>] [react=game|<take>] [caps_before=<json> caps_after=<json>]

const OLD_NAME := "pro_body_cross_old"
const NEW_NAME := "pro_body_cross"
const FILM_ORTHO_M := 3.0     # the pictures' 2.55 m, widened: a gut shot's take steps the hit man back up to 0.5 m
const FILM_SHIFT_M := 0.15    # ... and the camera stands this far toward his side
const TILE := 640
const COLS := 6
const TOUCH_LATER := 6        # the second still of each side: this many pictures (0.1 s) after the touch

var label: Label
var note: Label               # the caption of one sheet picture
var tag := ""
var pics := 0
var who := 0
var clip_now := ""
var caps: Array = []          # the ruler's rows of the side being filmed
var sheet := {}               # tag -> [[f, path]] the sheet's pictures as saved


func _initialize() -> void:
	if not await _setup():
		return
	_watch()
	sv.transparent_bg = false
	RenderingServer.set_default_clear_color(Color(0.20, 0.22, 0.26))
	var layer := CanvasLayer.new()
	sv.add_child(layer)
	label = Label.new()
	label.position = Vector2(20, 16)
	label.add_theme_font_size_override("font_size", 24)
	layer.add_child(label)
	note = Label.new()
	note.position = Vector2(20, 52)
	note.add_theme_font_size_override("font_size", 30)
	note.add_theme_color_override("font_color", Color(1.0, 0.92, 0.55))
	layer.add_child(note)
	who = int(_arg("who", "1" if _arg("set", "w") == "m" else "0"))
	if _arg("old", "") != "" and _adopt(_arg("old", ""), _arg("row", ""), OLD_NAME, NEW_NAME):
		var own := _arg("old_as", "filmed") == "own"
		await _side("before", OLD_NAME, own, _arg("old_react", "game") if own else "film", "BEFORE  " + _arg("old_words", "the take as it was"), _arg("caps_before", ""))
	await _side("after", NEW_NAME, true, _arg("react", "game"), "AFTER  " + _arg("words", "the take as it is now"), _arg("caps_after", ""))
	_tile_touch()
	print("BODYCROSS_FILM wrote=%d refused=%d" % [wrote, refused])
	quit(0 if refused == 0 else 1)


func _side(t: String, clip: String, own: bool, react: String, words: String, caps_path: String) -> void:
	tag = t
	pics = 0
	clip_now = clip
	label.text = words + ("" if caps_path == "" else " - degrees as this camera sees them")
	note.text = ""
	caps = []
	sheet[t] = []
	var got: Variant = JSON.parse_string(FileAccess.get_file_as_string(caps_path)) if caps_path != "" else null
	if got is Dictionary:
		caps = (got as Dictionary).get("rows", [])
	var run := await _play_out(who, clip, own, react, _pic)
	var plan: Dictionary = run["react"]
	print("BODYCROSS_FILM %s %s: the contact key is drawn on picture %d of %d; the hit man plays %s; puncher stepped %.3f m" % [t, clip, int(run["kc"]) - 1, pics,
		FILM_REACT + " from its first key, on the spot" if react == "film" else "%s from %.3f s (the v2 player's start rule)" % [plan["clip"], plan["from_s"]], float((run["stage"] as Dictionary)["step"])])
	_tile(sheet[t], out_dir.path_join("%s_sheet.png" % t))


## What the ruler read on the picture now being drawn ("" = not one of the sheet's twelve): matched by the take's clock.
func _caption() -> Array:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	if caps.is_empty() or str(ap.current_animation) != clip_now:
		return []
	for r in caps:
		if absf(float(r["take_s"]) - ap.current_animation_position) <= 0.005:
			var f := int(r["f"])
			var txt := "%d  elbow %d" % [int(r["pic"]), int(round(float(r["elbow_seen_deg"])))]
			if f == 0:
				txt += "  THE TOUCH"
			elif f > 0:
				txt += "  %s  he bends %d" % ["glove on him" if bool(r["on_body"]) else "glove %d cm off" % int(round(100.0 * float(r["gap_m"]))), int(round(float(r["fold_deg"])))]
			return [f, txt]
	return []


## One picture of the film (the frame being drawn now). The camera never moves after the first one.
func _pic(k: int, _info: Dictionary) -> void:
	if k == 0:
		cam.size = FILM_ORTHO_M
		cam.global_position += axis * (1.0 if who == 0 else -1.0) * FILM_SHIFT_M
	var cap := _caption()
	note.text = "" if cap.is_empty() else str(cap[1])
	await RenderingServer.frame_post_draw
	var bad := Gate.framed(stage, cam, [0, 1], SIZE)
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s_%03d: %s" % [tag, pics, "; ".join(PackedStringArray(bad))])
		refused += 1
	var path := out_dir.path_join("%s_%03d.png" % [tag, pics])
	sv.get_texture().get_image().save_png(path)
	if not cap.is_empty():
		(sheet[tag] as Array).append([int(cap[0]), path])
	pics += 1
	wrote += 1


## Tiles saved pictures [[f, path]] into one sheet, COLS a row.
func _tile(list: Array, path: String) -> void:
	if list.is_empty():
		return
	var rows := int(ceil(float(list.size()) / COLS))
	var img := Image.create(TILE * mini(COLS, list.size()), TILE * rows, false, Image.FORMAT_RGBA8)
	for i in list.size():
		var one := Image.load_from_file(str(list[i][1]))
		one.convert(Image.FORMAT_RGBA8)
		one.resize(TILE, TILE, Image.INTERPOLATE_LANCZOS)
		img.blit_rect(one, Rect2i(0, 0, TILE, TILE), Vector2i((i % COLS) * TILE, (i / COLS) * TILE))
	img.save_png(path)
	print("BODYCROSS_FILM sheet %s: %d pictures" % [path.get_file(), list.size()])


## Each side's touch picture and the one TOUCH_LATER pictures after it, side by side.
func _tile_touch() -> void:
	var list: Array = []
	for t in ["before", "after"]:
		for e in sheet.get(t, []):
			if int(e[0]) == 0 or int(e[0]) == TOUCH_LATER:
				list.append(e)
	_tile(list, out_dir.path_join("touch_before_after.png"))
