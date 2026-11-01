extends SceneTree
## S344 TAPEFLOW1: bakes the still on each card of the fight flow (FlowView, GrappleFlows' node = a picture of the position):
## two of our boxers on our own ring at every StrikeMap place - outside, long, mid, inside, the clinch, her back on the ropes,
## the other's back on the ropes, the corner trap - filmed by the tape room's hard camera (TapeFilm). Red = our boxer (she
## is the one trapped on "own_ropes"), blue = the opponent. Writes assets/ui/flow/<card>.png (then import the project).
## Real pictures only (run it on the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/bake_flow_stills.gd -- [out_dir]
## Prints FLOWSTILL <file> per still and FLOWSTILL done.

const W := 1920
const H := 1080
const TapeFilm := preload("res://scripts/fight3d/TapeFilm.gd")
const CardStage := preload("res://scripts/fight3d/CardStage.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Data := preload("res://scripts/state/Data.gd")
const FastDraw := preload("res://tools/fast_draw.gd")
## The pair's middle part of the frame, saved OUT_W wide (3:2, the card's picture).
const CROP := Rect2(0.14, 0.04, 0.72, 0.92)
const OUT_W := 360
const OUT_H := 240
## Where the pair stands for the range cards: the middle of the gap StrikeMap names, centred a little off the ring's middle.
const START_A := Vector3(-0.6, 0.0, 0.3)
const START_B := Vector3(0.6, 0.0, 0.3)

var out_dir := "res://assets/ui/flow"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))
	FastDraw.begin()
	root.size = Vector2i(W, H)
	var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var n := 0
	for c in StrikeMap.CARDS:
		var id := str(c["id"])
		var film := TapeFilm.new()
		film.setup(opp, str(Data.lucy()["name"]))
		root.add_child(film)
		await _frames(3)
		_place(film.stage, id)
		film.load_clip({"beats": [], "shape": id})
		if id == "clinch":
			film.stage.clinch.start(0, 30.0)
		await _seconds(1.6)
		var path := "%s/%s.png" % [out_dir, id]
		var img: Image = film._vp.get_texture().get_image()
		var w := img.get_width()
		var h := img.get_height()
		img = img.get_region(Rect2i(int(w * CROP.position.x), int(h * CROP.position.y), int(w * CROP.size.x), int(h * CROP.size.y)))
		img.resize(OUT_W, OUT_H, Image.INTERPOLATE_LANCZOS)
		img.save_png(ProjectSettings.globalize_path(path))
		print("FLOWSTILL " + path)
		n += 1
		film.queue_free()
		await _frames(3)
	print("FLOWSTILL done %d" % n)
	quit(0)


## Stands the pair where the card puts them: the ropes and the corner from CardStage (held there - the ring's middle clamp
## off), a range card at the middle of its StrikeMap gap, the clinch close enough to tie up.
func _place(stage: Node3D, id: String) -> void:
	var gap := 0.4 if id == "clinch" else 1.0
	var tg := CardStage.target(id, START_A, START_B, Stage.RING_M)
	var a: Vector3 = tg.get("a", START_A)
	var b: Vector3 = tg.get("b", START_B)
	if not tg.has("a") or id in ["outside", "long", "mid", "inside"]:
		gap = float(tg.get("gap", gap))
		var mid := (START_A + START_B) * 0.5
		a = mid + Vector3.LEFT * gap * 0.5
		b = mid + Vector3.RIGHT * gap * 0.5
	stage.boxers[0]["pos"] = a
	stage.boxers[1]["pos"] = b
	stage.feet.want_m = a.distance_to(b)
	if id in ["own_ropes", "opp_ropes", "corner"] and stage.has_method("apply_card"):
		stage.apply_card(id)   # holds them at the ropes (FightStage, FIGHTCARD1); without it the ring's middle clamp pulls them in


func _frames(k: int) -> void:
	for i in k:
		await process_frame


func _seconds(s: float) -> void:
	await create_timer(s).timeout
