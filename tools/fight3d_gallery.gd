extends SceneTree
## S305 operator: "put all the animations in and work on how each animation appears". The move-set review reel: every punch
## beat x every outcome (lands, big shot, blocked, slipped, weaved, missed) plus tired / standing count / KO / win, each played
## the way FightView plays a beat (BeatClips picks, contact timing, hit / defence on time) from the broadcast camera.
## Blue throws, red answers. Frames: <out_dir>/<nn>_<case>/fNN.jpg (15 fps, 2.2 s) + cases.txt (one label a line).
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --fixed-fps 30 --script res://tools/fight3d_gallery.gd -- <out_dir>
## Then tools/gallery_reel.py <out_dir> makes the labelled video. `only=slip,weave` films just those outcomes (S306).

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const OUTCOMES := ["lands", "big", "block", "slip", "weave", "miss"]
const CROP := Rect2i(410, 60, 1100, 1000)

var out_dir := "user://fight3d_gallery"
var stage: Node3D
var labels: Array = []
var only: Array = []


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	for a in args:
		if str(a).begins_with("only="):
			only = str(a).substr(5).split(",")
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	for k in 20:
		await process_frame
	for move in BeatClips.PUNCH:
		for outcome in OUTCOMES:
			if only.is_empty() or only.has(outcome):
				await _punch(str(move), str(outcome))
	for extra in ([] if not only.is_empty() else [["tired", BeatClips.TIRED], ["standing count", BeatClips.DOWN], ["knocked out", BeatClips.OUT],
			["win", BeatClips.WIN]]):
		var clip := BeatClips.first(extra[1], stage.has_move)
		await _case("red %s (%s)" % [extra[0], clip], func(): stage.play(0, clip, BeatClips.speed(clip, "")))
	var f := FileAccess.open(out_dir + "/cases.txt", FileAccess.WRITE)
	for l in labels:
		f.store_line(str(l))
	f.close()
	print("GALLERY cases=%d" % labels.size())
	quit(0)


func _punch(move: String, outcome: String) -> void:
	var ctx := {"big": outcome == "big", "miss": outcome == "miss", "tired": false, "step": false, "roll": 0.0}
	var clip := BeatClips.punch(move, ctx, stage.has_move)
	var sp := BeatClips.speed(clip, move)
	var at := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S))) / sp
	var answer := ""
	# The same side rule and body-shot elbow block as FightView (S305).
	var hand := str(BeatClips.contact_row(clip).get("hand", ""))
	var from_left: bool = stage.hand_of(1, hand if hand != "" else "RightHand") == "LeftHand"
	if outcome in ["lands", "big"]:
		answer = BeatClips.react(move, false, stage.has_move)
	elif outcome in ["block", "slip", "weave"]:
		answer = BeatClips.defence(outcome, move, from_left, bool(stage.boxers[0].get("south", false)), stage.has_move)
		if outcome == "block" and move == "body_hook":
			answer = "elbow brace"
	var label := "%s %s: blue %s%s" % [move, outcome, clip, (" -> red " + answer) if answer != "" else ""]
	await _case(label, func():
		stage.play(1, clip, sp)
		if outcome in ["lands", "big"]:
			stage.land(1, clip, move == "body_hook" or clip.contains("kidney"))
			create_timer(at).timeout.connect(stage.hit.bind(0, answer, BeatClips.speed(answer, ""), 1, move, outcome == "big"))
		elif answer == "elbow brace":
			create_timer(at).timeout.connect((stage.boxers[0]["snap"] as Node).brace.bind(not from_left))
		elif answer != "":
			create_timer(at * (0.8 if outcome == "block" else 0.35)).timeout.connect(
				stage.play.bind(0, answer, BeatClips.speed(answer, ""))))


func _case(label: String, start: Callable) -> void:
	stage.guard(0)
	stage.guard(1)
	for k in 24:
		await process_frame
	var dir := "%s/%02d" % [out_dir, labels.size()]
	labels.append(label)
	DirAccess.make_dir_recursive_absolute(dir)
	print("GALLERY ", labels.size() - 1, " ", label)
	start.call()
	for k in 66:
		await process_frame
		if k % 2 == 0:
			var img := root.get_texture().get_image().get_region(CROP)
			img.resize(550, 500)
			img.save_jpg("%s/f%02d.jpg" % [dir, k / 2], 0.85)
