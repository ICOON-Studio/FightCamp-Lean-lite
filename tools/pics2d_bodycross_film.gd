extends "res://tools/pics2d_bodycross_stage.gd"
## THE BODY CROSS, BEFORE v AFTER, on the pictures' own fixed side camera (orthographic, level, red on the left; never a
## corner frame - owner S537). BODYCROSS1 (S542) filmed the head cross against its new take; BODYCROSS2 (S545, owner
## C500 on that film: "does not reach opponent ... trying to touch hime rather than punch him and hurt him") films:
##   before  the S542 take exactly as that film showed it (old=<the S542 .res>, row=<its clip_db row as JSON>): the
##           game's finish armed, the hit man's take from its first key on the spot;
##   after   the re-authored take on its own keys: no finish, the puncher where the take's glove meets his body, the
##           hit man's answer by the v2 player's own route for a landed body punch, both bodies travelling as their takes do.
## The same pair, the same camera (fixed for the whole film, wide enough for the hit man's step back). Each side is
## played whole at 60 pictures a second from the guard.
## Writes <out>/<before|after>_NNN.png and prints which picture the contact key is drawn on.
##   python tools/hidden_desktop.py run --timeout=900 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_bodycross_film.gd -- <out_dir> art=toon set=w|m [who=0|1] [old=<res> row=<json>] [react=game|<take>]

const OLD_NAME := "pro_body_cross_s542"
const NEW_NAME := "pro_body_cross"
const FILM_ORTHO_M := 3.0     # the pictures' 2.55 m, widened: a gut shot's take steps the hit man back up to 0.5 m
const FILM_SHIFT_M := 0.15    # ... and the camera stands this far toward his side

var label: Label
var tag := ""
var pics := 0
var who := 0


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
	who = int(_arg("who", "1" if _arg("set", "w") == "m" else "0"))
	if _arg("old", "") != "" and _adopt(_arg("old", ""), _arg("row", "")):
		await _side("before", OLD_NAME, false, "film", "BEFORE  the S542 take as it was filmed")
	await _side("after", NEW_NAME, true, _arg("react", "game"), "AFTER  elbow bent at the touch, the arm finishes into him")
	print("BODYCROSS_FILM wrote=%d refused=%d" % [wrote, refused])
	quit(0 if refused == 0 else 1)


## The S542 take beside the new one, on both bodies: its file, its clip_db row, its glove front at the contact
## (what Player2._sample reads for every take it knows).
func _adopt(path: String, row_path: String) -> bool:
	var row: Variant = JSON.parse_string(FileAccess.get_file_as_string(row_path))
	if not ResourceLoader.exists(path) or not (row is Dictionary):
		print("BODYCROSS_FILM no old take at %s / %s: the after side only" % [path, row_path])
		return false
	stage.v2.db["rows"][OLD_NAME] = row
	for i in 2:
		var bx: Dictionary = stage.boxers[i]
		var ap: AnimationPlayer = bx["ap"]
		var skel: Skeleton3D = bx["skel"]
		var prefix := str(ap.get_animation(NEW_NAME).track_get_path(0)).get_slice(":", 0)
		for ln in ap.get_animation_library_list():
			var lib := ap.get_animation_library(ln)
			if lib.has_animation(NEW_NAME):
				FightClips._add_baked(lib, skel, prefix, OLD_NAME, path)
		if not ap.has_animation(OLD_NAME):
			return false
		var hand: String = stage.hand_of(i, str(row.get("hand", "RightHand")))
		ap.play(OLD_NAME)
		ap.seek(float(row.get("contact_s", 0.3)), true)
		(bx["gloves"] as Node)._follow()
		stage.v2._fronts[i][OLD_NAME] = (bx["node"] as Node3D).global_transform.affine_inverse() * (stage.glove_front(i, hand) as Vector3)
		var hp := skel.get_bone_global_pose(skel.find_bone(hand))
		stage.v2._rels[i][OLD_NAME] = (skel.global_transform.basis * hp.basis).inverse() * ((stage.glove_front(i, hand) as Vector3) - skel.global_transform * hp.origin)
		stage.v2.guard(i)
	return true


func _side(t: String, clip: String, own: bool, react: String, words: String) -> void:
	tag = t
	pics = 0
	label.text = words
	var run := await _play_out(who, clip, own, react, _pic)
	var plan: Dictionary = run["react"]
	print("BODYCROSS_FILM %s %s: the contact key is drawn on picture %d of %d; the hit man plays %s; puncher stepped %.3f m" % [t, clip, int(run["kc"]) - 1, pics,
		FILM_REACT + " from its first key, on the spot" if react == "film" else "%s from %.3f s (the v2 player's route)" % [plan["clip"], plan["from_s"]], float((run["stage"] as Dictionary)["step"])])


## One picture of the film (the frame being drawn now). The camera never moves after the first one.
func _pic(k: int, _info: Dictionary) -> void:
	if k == 0:
		cam.size = FILM_ORTHO_M
		cam.global_position += axis * (1.0 if who == 0 else -1.0) * FILM_SHIFT_M
	await RenderingServer.frame_post_draw
	var bad := Gate.framed(stage, cam, [0, 1], SIZE)
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s_%03d: %s" % [tag, pics, "; ".join(PackedStringArray(bad))])
		refused += 1
	sv.get_texture().get_image().save_png(out_dir.path_join("%s_%03d.png" % [tag, pics]))
	pics += 1
	wrote += 1
