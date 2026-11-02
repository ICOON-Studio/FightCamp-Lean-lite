extends SceneTree
## S359 where each defence clip is deepest (the head furthest from where it started, against the hips) as a share of the
## clip - the moment a counter is thrown from (MovePlayer.DEF_DEEPEST). Played pure on the Playbook player's own body.
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/defence_peak_probe.gd

const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")

var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("go", "playbook:0")
	await _settle(20)
	var mp := main.find_child("MovePlayer", true, false)
	var stage: Node = mp.get("_stage")
	mp.stop()
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	var skel: Skeleton3D = bx["skel"]
	var shares: Array = []
	for clip in ap.get_animation_list():
		var c := str(clip)
		if not MovePlayer._is_defence_clip(c):
			continue
		stage.guard(0)
		await _settle(10)
		var h0 := _head(skel)
		ap.play(c, 0.0)
		var length := ap.get_animation(c).length
		var best := 0.0
		var best_t := 0.0
		var t := 0.0
		while t < length:
			await process_frame
			t = ap.current_animation_position if str(ap.current_animation) == c else length
			var d := _head(skel).distance_to(h0)
			if d > best:
				best = d
				best_t = t
		shares.append(best_t / maxf(length, 0.001))
		print("DEFPEAK %-22s length %.2f s, deepest at %.2f s (%.0f %%), head moved %.2f m" % [c, length, best_t, 100.0 * best_t / maxf(length, 0.001), best])
	shares.sort()
	if not shares.is_empty():
		print("DEFPEAK median share %.2f of %d clips (min %.2f, max %.2f)" % [shares[shares.size() / 2], shares.size(), shares[0], shares[-1]])
	quit(0)


## The head in the hips' frame (a step does not count as depth).
func _head(skel: Skeleton3D) -> Vector3:
	var h := skel.get_bone_global_pose(skel.find_bone("Head")).origin
	var p := skel.get_bone_global_pose(skel.find_bone("Hips")).origin
	return Vector3(h.x - p.x, h.y, h.z - p.z)


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame
