extends SceneTree
## S376 (operator: "hands are below canvas wtf"): every knockdown / knockout clip on Danny's body, sampled each second
## from 1.5 s, the pose AS DRAWN (pose_tap last in the stack): the lowest hand, forearm, head and hips centre, and the
## gap between the pelvis and the canvas. PASS: no hand centre under GLOVE_R, no forearm under 0.03, the pelvis on the
## canvas (hips centre 0.06-0.22 m when lying). `nofloor` = the control arm (FloorClear off). Run on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 640x360 \
##       --audio-driver Dummy --script res://tools/floor_clear_probe.gd [-- nofloor]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FloorClear := preload("res://scripts/fight3d/FloorClear.gd")
const CLIPS := ["pro_knockout_countdown_v1", "pro_knockout_countdown_v2", "pro_knockout_countdown_v3", "mc_knockout_count",
	"pro_knockout_v1", "pro_knockout_v2", "pro_knockout_v3", "pro_knockout_v4", "pro_knockout_v5"]
const BONES := ["LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "Head", "Hips", "Spine1", "Spine2"]

var failures := 0


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "red"}, {"glb": "res://assets/models/metahuman/mh_boxer_01.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	for b in BONES:
		if skel.find_bone(b) < 0:
			print("FLOOR missing bone ", b)
	var tap: SkeletonModifier3D = load("res://tools/pose_tap.gd").new()
	tap.setup(skel, BONES.filter(func(b): return skel.find_bone(b) >= 0))
	skel.add_child(tap)
	var worst := {"hand": 9.0, "arm": 9.0}
	for name in CLIPS:
		if not (bx["ap"] as AnimationPlayer).has_animation(name):
			continue
		var lows := {}
		var hips_lying: Array = []
		var length: float = (bx["ap"] as AnimationPlayer).get_animation(name).length
		var t := 1.5
		while t <= minf(length - 0.2, 24.0):
			Stage.IdleMatch.freeze(bx, name, t)
			for i in 3:
				await process_frame
			for b in tap.shown:
				var y := (skel.global_transform * (tap.shown[b] as Vector3)).y
				lows[b] = minf(float(lows.get(b, 9.0)), y)
			var hy := (skel.global_transform * (tap.shown.get("Hips", Vector3.ZERO) as Vector3)).y
			if hy < 0.3:
				hips_lying.append(hy)
			t += 1.0
		var hand := minf(float(lows.get("LeftHand", 9.0)), float(lows.get("RightHand", 9.0)))
		var arm := minf(float(lows.get("LeftLowerArm", 9.0)), float(lows.get("RightLowerArm", 9.0)))
		worst["hand"] = minf(float(worst["hand"]), hand)
		worst["arm"] = minf(float(worst["arm"]), arm)
		hips_lying.sort()
		var hmed: float = hips_lying[hips_lying.size() / 2] if not hips_lying.is_empty() else -1.0
		print("FLOOR %s: hand %.3f forearm %.3f head %.3f hips(lying median) %.3f" % [name, hand, arm, float(lows.get("Head", 9.0)), hmed])
		if not hips_lying.is_empty():
			_check(hmed >= 0.06 and hmed <= 0.22, "%s: the pelvis rests on the canvas (hips %.2f m)" % [name, hmed])
	_check(float(worst["hand"]) >= FloorClear.GLOVE_R - 0.01, "no glove under the canvas (lowest hand centre %.3f m)" % float(worst["hand"]))
	_check(float(worst["arm"]) >= 0.03, "no forearm under the canvas (lowest %.3f m)" % float(worst["arm"]))
	print("FLOOR failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
