extends SceneTree
## S304: does any defence / hit-reaction / tired clip raise a glove above the head? The S304 three-round film showed Blue
## holding her lead glove straight up over her head for ~0.7 s after a jab landed on her guard - no boxer blocks like
## that. For every clip BeatClips can pick for a defence, a reaction or a tired beat, on the game's body at 60 Hz: how far
## each glove rises above the head (the head bone, metres) and for how long. A glove more than OVER_HEAD_M above the head
## for longer than OVER_HEAD_S is HIGH. Headless:
##   <godot.exe> --headless --path . --script res://tools/glove_height_check.gd [-- clips=a,b,c]   (clips= measures those instead)

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const HZ := 60.0
var OVER_HEAD_M := 0.10   # over=<m> on the command line sets it (S304 block review: 0.03 = a glove at the temple)
const OVER_HEAD_S := 0.25


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	var clips: Array = []
	for table in [BeatClips.DEFENCE, BeatClips.REACT]:
		for k in table.keys():
			for c in table[k]:
				if not clips.has(c):
					clips.append(c)
	for c in BeatClips.TIRED + BeatClips.GUARD:
		if not clips.has(c):
			clips.append(c)
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("clips="):
			clips = Array(str(a).substr(6).split(","))
		elif str(a).begins_with("over="):
			OVER_HEAD_M = float(str(a).substr(5))
	var high: Array = []
	for c in clips:
		if not ap.has_animation(c):
			print("GLOVE %-30s (not on this body)" % c)
			continue
		var m := _measure(stage, bx, str(c))
		var bad: bool = float(m["over_s"]) > OVER_HEAD_S
		if bad:
			high.append(c)
		print("GLOVE %-30s %s peak %+.2f m above head (%s), %.2f s over %.2f m" % [c, "HIGH " if bad else "ok   ",
			m["peak"], m["hand"], m["over_s"], OVER_HEAD_M])
	print("GLOVE HIGH %d: %s" % [high.size(), ", ".join(high)])
	quit(0)


func _measure(stage: Node3D, bx: Dictionary, clip: String) -> Dictionary:
	var length: float = (bx["ap"] as AnimationPlayer).get_animation(clip).length
	var out := {"peak": -9.0, "hand": "", "over_s": 0.0}
	var t := 0.0
	while t <= length:
		var head_y: float = Stage.IdleMatch.pose_point(bx, clip, t, "Head").y
		var over := false
		for h in ["LeftHand", "RightHand"]:
			var rise: float = Stage.IdleMatch.pose_point(bx, clip, t, h).y - head_y
			if rise > float(out["peak"]):
				out["peak"] = rise
				out["hand"] = h
			over = over or rise > OVER_HEAD_M
		if over:
			out["over_s"] = float(out["over_s"]) + 1.0 / HZ
		t += 1.0 / HZ
	return out
