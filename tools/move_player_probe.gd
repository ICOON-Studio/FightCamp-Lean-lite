extends SceneTree
## S359 (operator: "is the player working, i think it plays only 1 animation"): the Playbook's MovePlayer asked to show
## every move on the map in turn; per move, the clips MoveClips names, which of them her body has, and the animations
## each body actually played over the move's run. Headless is enough (the AnimationPlayer runs without a picture).
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/move_player_probe.gd

const SM := preload("res://scripts/rules/StrikeMap.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")

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
	if mp == null:
		print("MOVEPLAYER not found")
		quit(1)
		return
	var stage: Node = mp.get("_stage")
	var ids: Array = SM.MOVES.map(func(m): return str(m["id"]))
	var none := 0
	var missing_total := 0
	var same_as_first := 0
	var first_seen := ""
	for id in ids:
		var want: Array = MoveClips.clips(str(id))
		var ap: AnimationPlayer = stage.boxers[0]["ap"]
		var miss: Array = want.filter(func(c): return not ap.has_animation(str(c)))
		mp.show_move(str(id))
		var skel: Skeleton3D = stage.boxers[1 if str(SM.move(str(id)).get("kind", "")) == "forced" else 0]["skel"]
		var hip0 := _bone(skel, "Hips")
		var travel := 0.0
		var foot_top := 0.0
		var floor_y := minf(_bone(skel, "LeftFoot").y, _bone(skel, "RightFoot").y)
		var seen := []
		var seen_b := {}
		var last := ""
		var restarts := 0
		var last_pos := 0.0
		for k in 120:
			await process_frame
			var cur := str(ap.current_animation)
			if cur != "" and (cur != last or ap.current_animation_position < last_pos - 0.05):
				seen.append(cur)
			if cur != "":
				last = cur
				last_pos = ap.current_animation_position
			var hp := _bone(skel, "Hips")
			travel = maxf(travel, Vector2(hp.x - hip0.x, hp.z - hip0.z).length())
			foot_top = maxf(foot_top, maxf(_bone(skel, "LeftFoot").y, _bone(skel, "RightFoot").y) - floor_y)
			var cb := str((stage.boxers[1]["ap"] as AnimationPlayer).current_animation)
			if cb != "":
				seen_b[cb] = true
		var played := ">".join(seen)
		if want.is_empty():
			none += 1
		missing_total += miss.size()
		if first_seen == "":
			first_seen = played
		elif played == first_seen:
			same_as_first += 1
		print("MOVEPLAYER %-14s travel %.2f m, foot up %.2f m | wants [%s] missing [%s] | her body played [%s] | partner [%s]" % [str(id), travel, foot_top, ",".join(want),
			",".join(miss), played, ",".join(seen_b.keys())])
	print("MOVEPLAYER moves %d | no clips named %d | clips missing on her body %d | played the same as the first move %d" % [
		ids.size(), none, missing_total, same_as_first])
	quit(0)


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _bone(skel: Skeleton3D, b: String) -> Vector3:
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(b)).origin
