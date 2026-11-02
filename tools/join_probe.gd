extends SceneTree
## S361 TASK_ZIVAFOOT1: how hard the Playbook move player snaps when one clip hands over to the next.
## Plays each of the operator's ten moves on the Playbook player's own body (MovePlayer.show_move, the same body and the same
## code path the Moves / Game plan tabs use) and samples EVERY frame (--fixed-fps 30), printing per move:
##   JOIN <id> max_jump_deg=<the largest single-frame rotation change of any of: pelvis, spine_03, neck_01, head, both
##        upperarms, both thighs, both calves> at_t=<s> foot_lift_m=<max ankle height above the floor>
##        travel_m=<how far the pelvis went>
## and a last line JOIN_SUMMARY worst=<deg> mean=<deg>.
## The window is the MOVE: show_move -> her hand-over to the guard, plus one frame (the first step of that blend, where a
## cut would show). The 0.8 s guard hold after it is NOT measured: the guard's own life (GuardLife) cuts into a fidget there
## by design ("a Punch Pro fidget cut to a short window"), and a fidget is not one of the ten moves' hand-overs. The frames
## of the window are 30/s, so 20 deg is 600 deg/s. The frame show_move re-places the pair is the probe's baseline, not a
## join (a teleport, not a blend).
##
## The bones the brief names are UE5's; MHRig.UE5_TO_OURS renames them on load (pelvis -> Hips, spine_03 -> Chest,
## neck_01 -> Neck, upperarm_l -> LeftUpperArm, thigh_l -> LeftUpperLeg, calf_l -> LeftLowerLeg).
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/join_probe.gd

const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")

## The ten moves TASK_ZIVAFOOT1 names (Playbook ids, as the Moves / Game plan tabs pick them).
const MOVES := ["step_in", "step_out", "step_back", "pivot_out", "roll_out", "slip 2-3", "slip 2-3@own_ropes",
	"feint", "push_off", "cut_off"]
## pelvis, spine_03, neck_01, head, both upperarms, both thighs, both calves - in this rig's names.
const BONES := ["Hips", "Chest", "Neck", "Head", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg",
	"LeftLowerLeg", "RightLowerLeg"]
const ANKLES := ["LeftFoot", "RightFoot"]
const FLOOR_Y := 0.0        # the player's floor disc: its top face sits at the origin
const FPS := 30.0
## Frames of guard before a move (the pool it starts from and where it returns), and the cap on a move's window.
const SETTLE := 8
const MAX_FRAMES := 480
## The guard return is the move's last join: one frame past it is measured (the first step of the blend out of the last
## clip), and then the probe stops, before the guard's own hold (a fidget cut) can enter the numbers.
const AFTER_GUARD := 1

var _player: Node


func _initialize() -> void:
	_player = MovePlayer.new()
	root.add_child(_player)
	await _player.ready
	for i in 10:
		await process_frame
	var worst := 0.0
	var sum := 0.0
	for id in MOVES:
		var r: Dictionary = await _probe_move(str(id))
		print("JOIN %s max_jump_deg=%.1f at_t=%.2f foot_lift_m=%.3f travel_m=%.3f" % [
			id, float(r["jump"]), float(r["at"]), float(r["foot"]), float(r["travel"])])
		worst = maxf(worst, float(r["jump"]))
		sum += float(r["jump"])
	print("JOIN_SUMMARY worst=%.1f mean=%.1f" % [worst, sum / MOVES.size()])
	quit(0)


## One move from the guard back to the guard: every frame's pose, the biggest one-frame turn, the ankles' highest point
## and how far the pelvis went.
func _probe_move(id: String) -> Dictionary:
	var stage: Node = _player.get("_stage")
	_player.stop()
	stage.guard(0)
	stage.guard(1)
	for i in SETTLE:
		await process_frame
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var idx: Array = []
	for b in BONES:
		idx.append(skel.find_bone(str(b)))
	var ankles: Array = []
	for a in ANKLES:
		ankles.append(skel.find_bone(str(a)))
	_player.show_move(id)
	var prev: Array = []
	var pelvis0 := Vector3.ZERO
	var pelvis := Vector3.ZERO
	var jump := 0.0
	var at := 0.0
	var worst_bone := ""
	var worst_clip := ""
	var foot := -999.0
	var rise := -999.0
	var stand := [0.0, 0.0]
	var travel := 0.0
	var frames := 0
	var returned := -1
	var ap: AnimationPlayer = bx["ap"]
	var last_clip := ""
	var last_pos := 0.0
	while frames < MAX_FRAMES:
		await process_frame
		frames += 1
		var t := float(frames) / FPS
		var clip := str(ap.current_animation)
		var now: Array = []
		for i in idx:
			var w: Transform3D = skel.global_transform * skel.get_bone_global_pose(int(i))
			now.append(w.basis.orthonormalized().get_rotation_quaternion())
		pelvis = (skel.global_transform * skel.get_bone_global_pose(int(idx[0]))).origin
		if frames == 1:
			pelvis0 = pelvis
			for k in ankles.size():
				stand[k] = (skel.global_transform * skel.get_bone_global_pose(int(ankles[k]))).origin.y - FLOOR_Y
		elif not prev.is_empty():
			for i in now.size():
				var d := rad_to_deg((prev[i] as Quaternion).angle_to(now[i] as Quaternion))
				if d > jump:
					jump = d
					at = t
					worst_bone = str(BONES[i])
					worst_clip = "%s@%.2f -> %s@%.2f" % [last_clip, last_pos, clip, float(ap.current_animation_position)]
		prev = now
		last_clip = clip
		last_pos = float(ap.current_animation_position)
		travel = maxf(travel, Vector2(pelvis.x - pelvis0.x, pelvis.z - pelvis0.z).length())
		for k in ankles.size():
			if int(ankles[k]) >= 0:
				var h: float = (skel.global_transform * skel.get_bone_global_pose(int(ankles[k]))).origin.y - FLOOR_Y
				foot = maxf(foot, h)
				rise = maxf(rise, h - float(stand[k]))
		if bool(_player.get("_looping")):
			if returned < 0:
				returned = frames
			elif frames - returned >= AFTER_GUARD:
				break
	print("JOIN_AT %s bone=%s clip=%s stand_m=%.3f/%.3f rise_m=%.3f" % [id, worst_bone, worst_clip, float(stand[0]), float(stand[1]), rise])
	return {"jump": jump, "at": at, "foot": maxf(foot, 0.0), "rise": rise, "travel": travel}
