extends SceneTree
## S368: the feet as the board's clip previews SHOW them (tools/clip_orbit.gd's stage, its boxer with every fight modifier
## on, IdleMatch.freeze per frame) - tools/clip_feet_probe.gd poses the bare clip and never sees what the modifiers add.
## A pose tap after the modifiers reads both feet in world space each frame; slide_m / max_mps as clip_feet_probe.gd.
##   <godot.exe> --headless --path . --script res://tools/orbit_feet_probe.gd -- ids=<a,b,...>
## Prints ORBITFEET lines.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const PoseTap := preload("res://tools/pose_tap.gd")
const FPS := 30
const PLANT_M := 0.03


func _initialize() -> void:
	var ids: Array = []
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("ids="):
			ids = Array(str(a).substr(4).split(",", false))
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var tap: SkeletonModifier3D = PoseTap.new()
	tap.setup(skel, ["LeftFoot", "RightFoot"])
	skel.add_child(tap)
	for id in ids:
		var name := str(id)
		if not ap.has_animation(name):
			print("ORBITFEET MISSING ", name)
			continue
		var length: float = ap.get_animation(name).length
		var at := {"LeftFoot": [], "RightFoot": []}
		for f in int(ceil(length * FPS)) + 1:
			Stage.IdleMatch.freeze(bx, name, minf(f / float(FPS), length))
			await process_frame
			await process_frame
			for k in at:
				at[k].append(skel.global_transform * (tap.shown.get(k, Vector3.ZERO) as Vector3))
		var slide := 0.0
		var max_mps := 0.0
		var travel := 0.0   # every frame, lifted or not: does a foot move at all?
		for k in at:
			var arr0: Array = at[k]
			for i in range(1, arr0.size()):
				travel += Vector2((arr0[i] as Vector3).x - (arr0[i - 1] as Vector3).x, (arr0[i] as Vector3).z - (arr0[i - 1] as Vector3).z).length()
		for k in at:
			var arr: Array = at[k]
			var low := INF
			for v in arr:
				low = minf(low, (v as Vector3).y)
			for i in range(1, arr.size()):
				var a: Vector3 = arr[i - 1]
				var b: Vector3 = arr[i]
				if a.y <= low + PLANT_M and b.y <= low + PLANT_M:
					var d := Vector2(b.x - a.x, b.z - a.z).length()
					slide += d
					max_mps = maxf(max_mps, d * FPS)
		print("ORBITFEET %s slide_m=%.3f max_mps=%.2f travel_m=%.3f frames=%d" % [name, slide, max_mps, travel, (at["LeftFoot"] as Array).size()])
	quit(0)
