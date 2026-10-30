extends SceneTree
## S315 inside guard instrument (John J_INSIDE2: up close the elbows are glued to the ribs, the gloves at the cheeks/
## temples). Plays the build to fight night, watches round 1 and, from the pose AS SHOWN (tools/pose_tap.gd, the last
## modifier), logs every frame both boxers stand in their guard clip: per hand, the wrist from the head (forward / out to
## her own side / up) and the elbow's daylight from the ribs (horizontal distance to the chest-hips line), inside spells vs
## the pocket. Stops after STOP_S of round time. `-- noinguard` = the control arm (the old guard up close).
##   python tools/hidden_desktop.py run --timeout=600 --log=<log> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/inside_guard_probe.gd [-- noinguard]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const STOP_S := 90.0
const BONES := ["Head", "Chest", "Hips", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand"]

var main: Node
var view: Node
var taps: Array = []
var rows := {"inside": [], "pocket": []}   # [fwd, side, up, daylight] per hand-frame
var deep_clips := {}   # clip -> frames it put a glove deep in a head
var deep := {"inside": [0, 0], "pocket": [0, 0]}   # [frames, frames with a glove centre < DEEP_M from the other's head centre]
const DEEP_M := 0.09


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("INGUARD reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	for i in 2:
		var skel: Skeleton3D = view.stage.boxers[i]["skel"]
		var tap: SkeletonModifier3D = load("res://tools/pose_tap.gd").new()
		tap.setup(skel, BONES)
		skel.add_child(tap)
		taps.append(tap)
	process_frame.connect(_log)
	await _until(func(): return not bool(view.playing) or float(view.t) > STOP_S, 420.0)
	_report()
	quit(0)


func _log() -> void:
	if not is_instance_valid(view) or view.stage == null or not bool(view.playing) or bool(view.stage.scene):
		return
	var ph: String = view.stage.feet.phase()
	if not ph in ["inside", "pocket"] or (ph == "inside" and float(view.stage.feet.inside_w) < 0.95):
		return
	# Any clip: a glove centre (8 cm past the wrist along the forearm) deep inside the other's head (centre 8 cm up the
	# head bone; head ~0.09 m + glove ~0.06 m radius touch at ~0.15 m).
	deep[ph][0] += 1
	var hit := false
	for i in 2:
		var me: Dictionary = taps[i].shown
		var them: Dictionary = taps[1 - i].shown
		if me.size() < BONES.size() or them.size() < BONES.size():
			return
		var sk: Transform3D = (view.stage.boxers[i]["skel"] as Skeleton3D).global_transform
		var so: Transform3D = (view.stage.boxers[1 - i]["skel"] as Skeleton3D).global_transform
		var hc: Vector3 = so * (them["Head"] as Vector3) + Vector3.UP * 0.08
		for hand in ["Left", "Right"]:
			var wr: Vector3 = sk * (me[hand + "Hand"] as Vector3)
			var gc := wr + (wr - sk * (me[hand + "LowerArm"] as Vector3)).normalized() * 0.08
			if gc.distance_to(hc) < DEEP_M:
				hit = true
				var c := str((view.stage.boxers[i]["ap"] as AnimationPlayer).current_animation)
				deep_clips[c] = int(deep_clips.get(c, 0)) + 1
	if hit:
		deep[ph][1] += 1
	for i in 2:
		var bx: Dictionary = view.stage.boxers[i]
		if not str((bx["ap"] as AnimationPlayer).current_animation) in BeatClips.GUARD:
			continue
		var sh: Dictionary = taps[i].shown
		if sh.size() < BONES.size():
			continue
		var skel: Skeleton3D = bx["skel"]
		var fwd: Vector3 = skel.global_transform.basis.inverse() * (bx["node"] as Node3D).global_transform.basis.z
		fwd.y = 0.0
		fwd = fwd.normalized()
		var left: Vector3 = sh["LeftUpperArm"] - sh["RightUpperArm"]
		left.y = 0.0
		left = left.normalized()
		var axis: Vector3 = (sh["Chest"] - sh["Hips"]).normalized()
		for hand in ["Left", "Right"]:
			var out: Vector3 = left if hand == "Left" else -left
			var w: Vector3 = sh[hand + "Hand"] - sh["Head"]
			var el: Vector3 = sh[hand + "LowerArm"] - sh["Hips"]
			var off := el - axis * el.dot(axis)
			rows[ph].append([w.dot(fwd), w.dot(out), w.y, off.dot(out), off.dot(fwd)])


func _report() -> void:
	for ph in deep:
		print("INGUARD %s glove deep in a head: %d of %d frames" % [ph, deep[ph][1], deep[ph][0]])
	print("INGUARD deep by clip: ", deep_clips)
	for i in 2:
		var gcl = view.stage.boxers[i].get("gclear")
		print("INGUARD GloveClear pushes boxer %d: %s" % [i, str(gcl.pushes) if gcl != null else "off"])
	for ph in rows:
		var r: Array = rows[ph]
		if r.is_empty():
			print("INGUARD %s no frames" % ph)
			continue
		var cols := []
		for c in 5:
			var v := r.map(func(x): return float(x[c]))
			v.sort()
			cols.append("%.3f (p10 %.3f p90 %.3f)" % [v[v.size() / 2], v[v.size() / 10], v[v.size() * 9 / 10]])
		print("INGUARD %s hand-frames %d | wrist fwd of head %s | out to her side %s | up from head %s | elbow out from torso axis %s | elbow in front %s" % [
			ph, r.size(), cols[0], cols[1], cols[2], cols[3], cols[4]])


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0