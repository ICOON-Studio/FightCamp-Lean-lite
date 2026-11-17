extends SceneTree
## S510 (blind r11 + r12, both critics: "blue's free glove shoots straight up above his head after punches"; r12 log: the
## lead wrist rides 8-14 cm over the head bone in rear crosses, GuardTuck's free hold aims it 4 cm UNDER it). Plays one
## rear cross on blue (who 1) from the guard, alone or with red's cross 0.2 s before (the r12 ex1 #40-47 exchange), and
## prints blue's free (lead) glove front and wrist height over his head bone, every frame, as drawn after every layer.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/free_glove_probe.gd -- [clip=pro_right_cross_b] [solo] [show] [noclash]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

var st: Node3D


func _arg(k: String, d: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(k + "="):
			return str(a).substr(k.length() + 1)
	return d


func _head_y(who: int) -> float:
	var sk: Skeleton3D = st.boxers[who]["skel"]
	return (sk.global_transform * sk.get_bone_global_pose(sk.find_bone("Head")).origin).y


func _bone_y(who: int, bone: String) -> float:
	var sk: Skeleton3D = st.boxers[who]["skel"]
	return (sk.global_transform * sk.get_bone_global_pose(sk.find_bone(bone)).origin).y


func _initialize() -> void:
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_07.glb", "corner": "blue"})
	for i in 60:
		await process_frame
	var clip := _arg("clip", "pro_right_cross_b")
	var red := _arg("red", "pro_right_cross")
	var solo := OS.get_cmdline_user_args().has("solo")
	var show := OS.get_cmdline_user_args().has("show")
	var worst_front := -9.0
	var worst_wrist := -9.0
	var over := 0
	var free := "LeftHand"
	if not solo:
		st.play(0, red, BeatClips.speed(red, ""), 0.0)
		for i in 12:
			await process_frame
	st.play(1, clip, BeatClips.speed(clip, ""), 0.0)
	for i in 60:
		await process_frame
		var hy := _head_y(1)
		var front: float = (st.glove_front(1, free) as Vector3).y - hy
		var wrist := _bone_y(1, free) - hy
		worst_front = maxf(worst_front, front)
		worst_wrist = maxf(worst_wrist, wrist)
		if front > 0.22:
			over += 1
		if show:
			print("FREE_GLOVE f%02d %s t=%.2f front %+.3f wrist %+.3f" % [i, str(st.boxers[1]["ap"].assigned_animation),
				float(st.boxers[1]["ap"].current_animation_position), front, wrist])
	print("FREE_GLOVE clip=%s solo=%s worst_front=%+.3f worst_wrist=%+.3f frames_front_over_0.22=%d" % [clip, str(solo),
		worst_front, worst_wrist, over])
	quit(0)
