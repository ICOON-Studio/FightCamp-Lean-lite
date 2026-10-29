extends SceneTree
## S305 operator: "body shots do not seem to have any impact" - play ONE landed body shot the way FightView does
## (BeatClips.punch -> stage.play, stage.land, stage.hit at contact with BeatClips.react) and save frames from the
## broadcast camera, 1/15 s apart. Blue throws, red takes it. Run on the never-shown desktop with a fixed clock:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --fixed-fps 30 --script res://tools/fight3d_bodyshot.gd -- <out_dir> [big] [react=<clip>,<clip>,...] [rs=<speed>]
## react= plays each named hit reaction in turn (frames in <out_dir>/<clip>/) instead of the game's BeatClips.react pick.

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

var out_dir := "user://fight3d_bodyshot"
var stage: Node3D


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	var big := args.has("big")
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	for k in 20:
		await process_frame
	var reacts: Array = []
	var rs := -1.0
	for a in args:
		if str(a).begins_with("react="):
			reacts = Array(str(a).trim_prefix("react=").split(","))
		if str(a).begins_with("rs="):
			rs = float(str(a).trim_prefix("rs="))
	if reacts.is_empty():
		reacts = [BeatClips.react("body_hook", false, stage.has_move)]
	for hit in reacts:
		await _one(str(hit), rs, big)
	quit(0)


func _one(hit: String, rs: float, big: bool) -> void:
	var dir := "%s/%s" % [out_dir, hit]
	DirAccess.make_dir_recursive_absolute(dir)
	stage.guard(0)
	stage.guard(1)
	for k in 30:
		await process_frame
	var move := "body_hook"
	var clip := BeatClips.punch(move, {"big": big, "miss": false, "tired": false, "step": false, "roll": 0.5}, stage.has_move)
	var sp := BeatClips.speed(clip, move)
	var contact := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))
	var hs := rs if rs > 0.0 else BeatClips.speed(hit, "")
	print("BODYSHOT clip=%s speed=%.2f contact_s=%.3f react=%s has=%s react_speed=%.2f big=%s" % [clip, sp, contact, hit,
		stage.has_move(hit), hs, big])
	stage.play(1, clip, sp)
	stage.land(1, clip, true)
	create_timer(contact / sp).timeout.connect(stage.hit.bind(0, hit, hs, 1, move, big))
	var every := 4 if OS.get_cmdline_user_args().has("long") else 2
	for k in 30 * every:
		await process_frame
		if k % every == 0:
			root.get_texture().get_image().save_png("%s/b%02d.png" % [dir, k / every])
