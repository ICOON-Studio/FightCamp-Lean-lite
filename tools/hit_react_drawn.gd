extends SceneTree
## S411: the head travel of a playing hit reaction, read as it is drawn: inside skeleton_updated, every modifier off, one clip frame
## per drawn frame. HITREACT1-2 read 0.109 m on hook_v5, HITREACT5 read 0.186 m from the track keys: this says which the screen gets.
##   <godot.exe> --headless --path . --audio-driver Dummy --fixed-fps 30 --script res://tools/hit_react_drawn.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const CLIPS := ["pro_hit_by_hook_v5", "pro_hit_by_jab_v5_short", "pro_hit_by_cross_v2_short", "pro_hit_by_hook_v3", "pro_hit_by_cross_v1",
	"pro_hit_by_hook_v6_short"]


func _initialize() -> void:
	Engine.max_fps = 30
	var stage: Node = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_01.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	for c in skel.get_children():
		if c is SkeletonModifier3D:
			(c as SkeletonModifier3D).active = false
	var head := skel.find_bone("Head")
	var chest := skel.find_bone("UpperChest")
	var reads: Array = []
	skel.skeleton_updated.connect(func(): reads.append(skel.get_bone_global_pose(head).origin - skel.get_bone_global_pose(chest).origin))
	for clip in CLIPS:
		if not ap.has_animation(clip):
			print("DRAWN %s missing" % clip)
			continue
		var n := int(ap.get_animation(clip).length * 30.0)
		var first := Vector3.INF
		var most := 0.0
		var peak := 0
		ap.play(clip)
		for f in n:
			ap.seek(float(f) / 30.0, true)
			ap.pause()
			reads.clear()
			await process_frame
			await process_frame
			if reads.is_empty():
				continue
			var v: Vector3 = reads.back()
			if first == Vector3.INF:
				first = v
			if v.distance_to(first) > most:
				most = v.distance_to(first)
				peak = f
		print("DRAWN %-28s frames=%d head_m=%.4f peak=%d" % [clip, n, most, peak])
	quit(0)
