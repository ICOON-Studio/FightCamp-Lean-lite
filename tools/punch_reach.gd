extends SceneTree
## S302 probe (operator on the S301 film: "the punches ... target enemys hand rather than their head"): at the fight's gap,
## every punch clip frozen at its measured contact against the other boxer in her guard. Prints, in metres, how far the
## punching glove's front stops from her face (body for body shots) and from her nearest guard glove, how far the target
## sits beyond what the arm can reach from where the shoulder is, and the face-to-face gap in guard. Headless:
##   <godot.exe> --headless --path . --script res://tools/punch_reach.gd -- [prefix=pro_] [reach=1]
## `reach=1` turns the stage's landed-punch reach on (FightStage.land) so the same table reads after the fix; `write=1`
## (control run only) stores each clip's "short_m" (target beyond the straight arm + glove) in clip_contact.json, which
## FightStage.land reads to carry the body in.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot", "kidney_shot"]


func _initialize() -> void:
	var prefix := "pro_"
	var with_reach := false
	var write := false
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("prefix="):
			prefix = str(a).substr(7)
		if str(a) == "reach=1":
			with_reach = true
		if str(a) == "write=1":
			write = true
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var ap: AnimationPlayer = stage.boxers[0]["ap"]
	stage.pose(0, "pro_idle", 0.5)
	stage.pose(1, "pro_idle", 0.5)
	await _frames(2)
	var face_a: Vector3 = stage.target_point(0, false)
	var face_b: Vector3 = stage.target_point(1, false)
	print("GAP pelvis %.3f  face-to-face %.3f  (John: jab lands at ~0.60-0.75 m face to face, 169 cm woman)" % [stage.gap_m, face_a.distance_to(face_b)])
	var names: Array = []
	for n in ap.get_animation_list():
		var name := str(n)
		if name.begins_with(prefix) and not name.contains("hit_by") and not name.contains("combo") and PUNCH_WORDS.any(func(w): return name.contains(w)):
			names.append(name)
	names.sort()
	var worst := 0.0
	var sum := 0.0
	var shorts := {}
	for name in names:
		var body: bool = name.contains("body") or name.contains("kidney")
		var hand: String = "LeftHand" if name.contains("left_") or name.contains("kidney") else "RightHand"
		var t := BeatClips.contact(name, 0.3)
		stage.pose(1, "pro_idle", 0.5)
		stage.pose(0, name, t)
		if with_reach:
			stage.land(0, name, body)
			stage._compose(0.0)
		await _frames(2)
		var glove: Vector3 = stage.glove_front(0, hand)
		var target: Vector3 = stage.target_point(1, body)
		var guard := minf(glove.distance_to(stage.glove_front(1, "LeftHand")), glove.distance_to(stage.glove_front(1, "RightHand")))
		var miss := glove.distance_to(target)
		var short := _short(stage, hand, target)
		worst = maxf(worst, miss)
		sum += miss
		if write:
			shorts[name] = snappedf(short, 0.001)
		print("REACH %-28s t=%.3f %s glove->%s %.3f  glove->guard %.3f  target beyond arm %.3f" % [name, t, hand, "body" if body else "face", miss, guard, short])
	print("REACH DONE %d clips  mean miss %.3f  worst %.3f" % [names.size(), sum / maxf(1.0, names.size()), worst])
	if write:
		_store(shorts)
	_onsets(stage, names)
	_guard(stage)
	await _guard_shown(stage)
	quit(0)


## The guard as shown (after GuardTuck): both in pro_idle at several times; glove centres in front of the face, and the
## closest the two boxers' gloves come (the S300 film 3 rule: the guards must not touch).
func _guard_shown(stage: Node3D) -> void:
	var front := 0.0
	var n := 0
	var closest := 9.0
	for t in [0.1, 0.5, 0.9, 1.3, 1.7]:
		stage.pose(0, "pro_idle", t)
		stage.pose(1, "pro_idle", t + 0.3)
		await _frames(14)
		var fwd: Vector3 = (stage.boxers[0]["node"] as Node3D).global_transform.basis.z
		var face: Vector3 = stage.target_point(0, false)
		for hand in ["LeftHand", "RightHand"]:
			var c: Vector3 = (stage.glove_front(0, hand) + _wrist(stage, 0, hand)) * 0.5
			front += (c - face).dot(fwd)
			n += 1
			for other in ["LeftHand", "RightHand"]:
				closest = minf(closest, stage.glove_front(0, hand).distance_to(stage.glove_front(1, other)))
	print("GUARD SHOWN glove centres in front of the face %.3f m (John ~0.10-0.20); closest glove fronts between the two %.3f m; face-to-face %.3f" % [
		front / n, closest, stage.target_point(0, false).distance_to(stage.target_point(1, false))])


func _wrist(stage: Node3D, i: int, hand: String) -> Vector3:
	var g: Node3D = (stage.boxers[i]["gloves"] as Node).gloves.get("l" if hand.begins_with("Left") else "r")
	return g.global_position


func _store(shorts: Dictionary) -> void:
	var path := BeatClips.CONTACT_PATH
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	for name in shorts:
		if data.has(name):
			data[name]["short_m"] = shorts[name]
	var f := FileAccess.open(path, FileAccess.WRITE)
	f.store_string(JSON.stringify(data, "	", true))
	f.close()
	print("REACH wrote short_m for %d clips -> %s" % [shorts.size(), path])


## First visible movement -> contact, in game seconds (the clip at its beat speed): the punching hand's first 3 cm away
## from where the clip starts it (John J-GUARDPACE1: jab/cross 357 ms, hook 477 ms start -> contact).
func _onsets(stage: Node3D, names: Array) -> void:
	var bx: Dictionary = stage.boxers[0]
	for name in names:
		var hand: String = "LeftHand" if name.contains("left_") or name.contains("kidney") else "RightHand"
		var move: String = _move_of(name)
		var sp := BeatClips.speed(name, move)
		var contact := BeatClips.contact(name, 0.3)
		var p0: Vector3 = stage._pose_point(bx, name, 0.0, hand)
		var onset := 0.0
		var t := 0.0
		while t < contact:
			if (stage._pose_point(bx, name, t, hand) as Vector3).distance_to(p0) > 0.03:
				onset = t
				break
			t += 1.0 / 60.0
		print("PACE %-28s %s speed %.2f  clip start->contact %.3f s  first move->contact %.3f s" % [name, move, sp, contact / sp, (contact - onset) / sp])


func _move_of(name: String) -> String:
	for stem in BeatClips.PUNCH:
		if name.begins_with("pro_" + str(BeatClips.PUNCH[stem][0])):
			return stem
	return "body_hook" if name.contains("kidney") else ""


## The guard (pro_idle) against John's numbers: bob height and rate, gloves in front of the face, glove height against the
## chin, elbows, stance width against height.
func _guard(stage: Node3D) -> void:
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	var length: float = ap.get_animation("pro_idle").length
	var ys: Array = []
	var front := 0.0
	var below := 0.0
	var n := 0
	var t := 0.0
	var head_top := 0.0
	while t < length:
		var hips: Vector3 = stage._pose_point(bx, "pro_idle", t, "Hips")
		ys.append(hips.y)
		var head: Vector3 = stage._pose_point(bx, "pro_idle", t, "Head")
		head_top = maxf(head_top, head.y)
		for hand in ["LeftHand", "RightHand"]:
			var h: Vector3 = stage._pose_point(bx, "pro_idle", t, hand)
			front += h.z - (head.z + Stage.FACE_FWD_M)
			below += (head.y + Stage.FACE_UP_M - 0.10) - h.y
			n += 1
		t += 1.0 / 60.0
	var lo: float = ys.min()
	var hi: float = ys.max()
	var mins := 0
	for i in range(1, ys.size() - 1):
		if float(ys[i]) < float(ys[i - 1]) and float(ys[i]) <= float(ys[i + 1]) and float(ys[i]) < lo + (hi - lo) * 0.4:
			mins += 1
	var lf: Vector3 = stage._pose_point(bx, "pro_idle", 0.0, "LeftFoot")
	var rf: Vector3 = stage._pose_point(bx, "pro_idle", 0.0, "RightFoot")
	print("GUARD pro_idle %.2f s: hips bob %.3f m, %.2f dips/s (John ~1 Hz, 2-5 cm)" % [length, hi - lo, mins / length])
	print("GUARD wrists in front of the face %.3f m (John gloves ~0.10-0.20), wrists below the chin %.3f m" % [front / n, below / n])
	print("GUARD feet apart %.3f m = %.2f x height (John ~0.25)" % [lf.distance_to(rf), lf.distance_to(rf) / maxf(0.5, head_top + 0.12)])


## How far `target` sits beyond the straight arm plus glove, from the shoulder as the clip holds it (raw pose).
func _short(stage: Node3D, hand: String, target: Vector3) -> float:
	var skel: Skeleton3D = stage.boxers[0]["skel"]
	var side := hand.trim_suffix("Hand")
	var pts: Array = []
	for b in ["UpperArm", "LowerArm", "Hand"]:
		pts.append(skel.global_transform * skel.get_bone_global_pose(skel.find_bone(side + b)).origin)
	var arm: float = (pts[0] as Vector3).distance_to(pts[1]) + (pts[1] as Vector3).distance_to(pts[2]) + float(stage.boxers[0]["front"]) * stage._scale(0)
	return (pts[0] as Vector3).distance_to(target) - arm


func _frames(n: int) -> void:
	for i in n:
		await process_frame
