extends SceneTree
## Punch PRO fidelity gate. Compares every raw FBX reference row with the same
## motion baked on the MetaHuman. All measurements are on the unmodified clip.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const RAW := "res://assets/anim/baked/punch_pro_raw.json"
const BAKED := "res://assets/anim/baked"
const BODY := "res://assets/models/metahuman/mh_boxer_10.glb"
const PLANT_M := 0.03
const SNAP_DEG := 6.0
const FOOT_LINE_DEG := 20.0     # the world direction of the line through the ankles, against the raw take, every frame
const FOOT_LINE_MIN_M := 0.10   # a line shorter than this has no direction worth reading


func _initialize() -> void:
	var candidates := _arg("candidates", "")
	if not candidates.is_empty():
		quit(_choose(candidates.split(",", false), _arg("out", BAKED)))
		return
	var result := compare_all(_arg("raw", RAW), _arg("baked", BAKED), _arg("quiet", "0") != "1",
		_arg("clip", ""))
	print("RETARGET_FIDELITY failures=%d" % int(result["failures"]))
	quit(1 if int(result["failures"]) > 0 else 0)


func _arg(key: String, fallback: String) -> String:
	for value in OS.get_cmdline_user_args():
		if value.begins_with(key + "="):
			return value.substr(key.length() + 1)
	return fallback


static func _choose(dirs: PackedStringArray, out_dir: String) -> int:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))
	var choices := {}
	for dir in dirs:
		var result := compare_all(RAW, dir, false)
		for row in result["rows"]:
			var clip: String = row["clip"]
			if not choices.has(clip):
				choices[clip] = row
				choices[clip]["from"] = dir
				continue
			var old: Dictionary = choices[clip]
			if (not bool(row["failed"]) and bool(old["failed"])) \
				or (bool(row["failed"]) == bool(old["failed"]) and float(row["score"]) < float(old["score"])):
				choices[clip] = row
				choices[clip]["from"] = dir
	var failures := 0
	var picked := {}
	for clip in choices:
		var row: Dictionary = choices[clip]
		failures += 1 if row["failed"] else 0
		picked[clip] = str(row["from"]).get_file()
		var anim := load(str(row["path"])) as Animation
		if anim == null or ResourceSaver.save(anim.duplicate(true), out_dir.path_join(str(clip) + ".res")) != OK:
			print("RETARGET_CHOOSE failed to save ", clip)
			return 1
	var pick_file := FileAccess.open(out_dir.path_join("choice.json"), FileAccess.WRITE)
	if pick_file != null:
		pick_file.store_string(JSON.stringify(picked, "  ", true))
		pick_file.close()
	print("RETARGET_CHOOSE candidates=%d clips=%d failures=%d" % [dirs.size(), choices.size(), failures])
	return 0 if failures == 0 else 1


static func compare_all(raw_path: String = RAW, baked_dir: String = BAKED, print_rows: bool = false,
		only_clip: String = "") -> Dictionary:
	if not FileAccess.file_exists(raw_path):
		print("RETARGET_FIDELITY missing raw table: ", raw_path)
		return {"failures": 1, "rows": []}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(raw_path))
	if not parsed is Dictionary or not (parsed as Dictionary).has("clips"):
		print("RETARGET_FIDELITY invalid raw table: ", raw_path)
		return {"failures": 1, "rows": []}
	var body := MH.load_fighter(BODY)
	if body == null:
		print("RETARGET_FIDELITY could not load target body")
		return {"failures": 1, "rows": []}
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var target_leg := _leg_length(skel)
	var rows: Array = []
	var failures := 0
	var clips: Dictionary = (parsed as Dictionary)["clips"]
	for source_stem in clips:
		var raw: Dictionary = clips[source_stem]
		var stem := _baked_stem(str(source_stem))
		var path := baked_dir.path_join(stem + ".res")
		var row := {"clip": stem, "raw": raw, "path": path, "missing": false}
		if not ResourceLoader.exists(path):
			row["missing"] = true
			row["score"] = INF
			row["failed"] = true
		else:
			var anim := load(path) as Animation
			var ours := _measure(anim, skel)
			var scale := target_leg / maxf(float(raw.get("leg_length_m", 0.0)), 0.001)
			var slide_bar := float(raw["slide_m"]) * scale * 1.15 + 0.02
			var snap_bar := int(raw["snaps"])
			var jitter_bar := float(raw["knee_jitter"]) * 1.2
			var stance := _stance_error(raw.get("width_m", []), ours["width_m"], scale)
			var line := _foot_line_error(raw, ours)
			var frames_ok := int(ours["frames"]) >= int(raw["frames"]) - 1
			var slide_ratio := float(ours["slide_m"]) / maxf(slide_bar, 0.001)
			var snap_ratio := float(ours["snaps"]) / maxf(float(snap_bar), 1.0)
			var jitter_ratio := float(ours["knee_jitter"]) / maxf(jitter_bar, 0.001)
			var failed := float(ours["slide_m"]) > slide_bar + 0.00001 \
				or int(ours["snaps"]) > snap_bar or float(ours["knee_jitter"]) > jitter_bar + 0.00001 \
				or float(stance["err"]) > 0.15 or not frames_ok or bool(stance["missing"]) or float(line["deg"]) > FOOT_LINE_DEG
			row.merge({"ours": ours, "scale": scale, "slide_bar": slide_bar, "snap_bar": snap_bar,
				"jitter_bar": jitter_bar, "width_err": stance["err"], "width_at": stance["at"],
				"width_src": stance["src"], "width_got": stance["got"], "frames_ok": frames_ok,
				"line_deg": line["deg"], "line_at": line["at"],
				"score": maxf(float(line["deg"]) / FOOT_LINE_DEG, maxf(slide_ratio, maxf(snap_ratio, maxf(jitter_ratio, float(stance["err"]) / 0.15)))),
				"failed": failed})
		if bool(row["failed"]):
			failures += 1
		rows.append(row)
	rows.sort_custom(func(a: Dictionary, b: Dictionary): return float(a["score"]) > float(b["score"]))
	if print_rows:
		for row in rows:
			if not only_clip.is_empty() and not str(row["clip"]).contains(only_clip):
				continue
			if bool(row["missing"]):
				print("RETARGET_ROW %s MISSING" % row["clip"])
				continue
			var raw: Dictionary = row["raw"]
			var ours: Dictionary = row["ours"]
			print("RETARGET_ROW %-48s slide %.3f/%.3f (bar %.3f) snaps %d/%d jitter %.3f/%.3f frames %d/%d width_err %.1f%% @%d raw %.3f ours %.3f line %.0f deg @%d %s" % [
				row["clip"], float(raw["slide_m"]) * float(row["scale"]), float(ours["slide_m"]),
				float(row["slide_bar"]), int(raw["snaps"]), int(ours["snaps"]),
				float(raw["knee_jitter"]), float(ours["knee_jitter"]), int(raw["frames"]), int(ours["frames"]),
				float(row["width_err"]) * 100.0, int(row["width_at"]), float(row["width_src"]), float(row["width_got"]),
				float(row["line_deg"]), int(row["line_at"]),
				"FAIL" if row["failed"] else "PASS"])
	body.free()
	return {"failures": failures, "rows": rows}


## One line per failing clip and bar: clip, bar, ours, raw (scaled to our legs), limit.
static func failure_lines(rows: Array) -> PackedStringArray:
	var out := PackedStringArray()
	for row in rows:
		if not bool(row["failed"]):
			continue
		if bool(row["missing"]):
			out.append("RETARGET_FAIL %s missing" % row["clip"])
			continue
		var raw: Dictionary = row["raw"]
		var ours: Dictionary = row["ours"]
		var clip: String = row["clip"]
		var scale := float(row["scale"])
		if float(ours["slide_m"]) > float(row["slide_bar"]) + 0.00001:
			out.append("RETARGET_FAIL %s slide ours=%.3f raw=%.3f limit=%.3f" % [clip, ours["slide_m"], float(raw["slide_m"]) * scale, row["slide_bar"]])
		if int(ours["snaps"]) > int(row["snap_bar"]):
			out.append("RETARGET_FAIL %s snaps ours=%d raw=%d limit=%d" % [clip, ours["snaps"], raw["snaps"], row["snap_bar"]])
		if float(ours["knee_jitter"]) > float(row["jitter_bar"]) + 0.00001:
			out.append("RETARGET_FAIL %s jitter ours=%.3f raw=%.3f limit=%.3f" % [clip, ours["knee_jitter"], raw["knee_jitter"], row["jitter_bar"]])
		if float(row["width_err"]) > 0.15:
			out.append("RETARGET_FAIL %s width ours=%.3f raw=%.3f limit=15%% err=%.1f%% frame=%d" % [clip, row["width_got"], row["width_src"], float(row["width_err"]) * 100.0, row["width_at"]])
		if float(row["line_deg"]) > FOOT_LINE_DEG:
			out.append("RETARGET_FAIL %s foot_line ours_off_by=%.0f deg limit=%.0f frame=%d" % [clip, row["line_deg"], FOOT_LINE_DEG, row["line_at"]])
		if not bool(row["frames_ok"]):
			out.append("RETARGET_FAIL %s frames ours=%d raw=%d limit=%d" % [clip, ours["frames"], raw["frames"], int(raw["frames"]) - 1])
	return out


static func _baked_stem(source: String) -> String:
	return "mc_" + source.replace("_ ", "_").replace(" ", "_")


static func _leg_length(skel: Skeleton3D) -> float:
	var total := 0.0
	for side in ["Left", "Right"]:
		var hip := skel.get_bone_global_rest(skel.find_bone(side + "UpperLeg")).origin
		var knee := skel.get_bone_global_rest(skel.find_bone(side + "LowerLeg")).origin
		var ankle := skel.get_bone_global_rest(skel.find_bone(side + "Foot")).origin
		total += hip.distance_to(knee) + knee.distance_to(ankle)
	return total * 0.5


static func _measure(anim: Animation, skel: Skeleton3D) -> Dictionary:
	var count := skel.get_bone_count()
	var parents: Array[int] = []
	var rest_pos: Array[Vector3] = []
	var rest_rot: Array[Quaternion] = []
	for bone in count:
		parents.append(skel.get_bone_parent(bone))
		rest_pos.append(skel.get_bone_rest(bone).origin)
		rest_rot.append(skel.get_bone_rest(bone).basis.get_rotation_quaternion())
	var tracks := {}
	for track in anim.get_track_count():
		tracks[track] = skel.find_bone(str(anim.track_get_path(track)))
	var fps := roundi(1.0 / maxf(anim.step, 1.0 / 30.0))
	var frames := maxi(2, int(round(anim.length * fps)) + 1)
	var foot_ids := [skel.find_bone("LeftFoot"), skel.find_bone("RightFoot")]
	var hip_ids := [skel.find_bone("LeftUpperLeg"), skel.find_bone("RightUpperLeg")]
	var leg_names := ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"]
	var leg_ids: Array[int] = []
	for name in leg_names:
		leg_ids.append(skel.find_bone(name))
	var calf_ids := [skel.find_bone("LeftLowerLeg"), skel.find_bone("RightLowerLeg")]
	var feet := [[], []]
	var hips := [[], []]
	var rotations := {}
	for bone in leg_ids:
		rotations[bone] = []
	for frame in frames:
		var at := minf(frame / float(fps), anim.length)
		var pos := rest_pos.duplicate()
		var rot := rest_rot.duplicate()
		for track in tracks:
			var bone: int = tracks[track]
			if bone < 0:
				continue
			if anim.track_get_type(track) == Animation.TYPE_ROTATION_3D:
				rot[bone] = anim.rotation_track_interpolate(track, at)
			elif anim.track_get_type(track) == Animation.TYPE_POSITION_3D:
				pos[bone] = rest_pos[bone] + anim.position_track_interpolate(track, at)
		var globals := _globals(parents, pos, rot)
		for side in 2:
			feet[side].append((globals[foot_ids[side]] as Transform3D).origin)
			hips[side].append((globals[hip_ids[side]] as Transform3D).origin)
		for bone in leg_ids:
			rotations[bone].append((globals[bone] as Transform3D).basis.get_rotation_quaternion())
	var slide := 0.0
	for side in 2:
		var samples: Array = feet[side]
		var floor := INF
		for point in samples:
			floor = minf(floor, (point as Vector3).y)
		for frame in range(1, samples.size()):
			var a: Vector3 = samples[frame - 1]
			var b: Vector3 = samples[frame]
			if a.y - floor < PLANT_M and b.y - floor < PLANT_M:
				slide += Vector2(b.x - a.x, b.z - a.z).length()
	var snaps := 0
	var calf_second: Array = []
	for bone in leg_ids:
		var samples: Array = rotations[bone]
		for frame in range(2, samples.size()):
			var before := (samples[frame - 2] as Quaternion).angle_to(samples[frame - 1] as Quaternion)
			var now := (samples[frame - 1] as Quaternion).angle_to(samples[frame] as Quaternion)
			var second := rad_to_deg(absf(now - before))
			if second > SNAP_DEG:
				snaps += 1
			if calf_ids.has(bone):
				calf_second.append(second)
	var jitter := 0.0
	for value in calf_second:
		jitter += float(value)
	jitter /= maxf(1.0, calf_second.size())
	return {"slide_m": slide, "snaps": snaps, "knee_jitter": jitter, "frames": frames,
		"width_m": _widths(hips, feet), "foot_d": _foot_deltas(feet)}


static func _foot_deltas(feet: Array) -> Array:
	var out: Array = []
	for i in (feet[0] as Array).size():
		var d := (feet[0][i] as Vector3) - (feet[1][i] as Vector3)
		out.append(Vector2(d.x, d.z))
	return out


## How far the line through OUR ankles points from the actor's line, worst frame. Width across the hips cannot see a stance
## turned as a whole: the hips turn with it (RETARGET2B: the jab rotated 28 deg side-on, measured within 2.4 % of raw).
static func _foot_line_error(raw: Dictionary, ours: Dictionary) -> Dictionary:
	var dx: Array = raw.get("foot_dx", [])
	var dz: Array = raw.get("foot_dz", [])
	var got: Array = ours["foot_d"]
	if dx.is_empty():
		return {"deg": 0.0, "at": -1}
	var worst := 0.0
	var at := -1
	for i in mini(dx.size(), got.size()):
		var src := Vector2(float(dx[i]), float(dz[i]))
		var have: Vector2 = got[i]
		if src.length() < FOOT_LINE_MIN_M or have.length() < FOOT_LINE_MIN_M:
			continue
		var off := rad_to_deg(absf(src.angle_to(have)))
		if off > worst:
			worst = off
			at = i
	return {"deg": worst, "at": at}


static func _widths(hips: Array, feet: Array) -> Array:
	var out: Array = []
	for i in (feet[0] as Array).size():
		var lat := (hips[0][i] as Vector3) - (hips[1][i] as Vector3)
		lat.y = 0.0
		var d := (feet[0][i] as Vector3) - (feet[1][i] as Vector3)
		if lat.length() < 1e-5:
			out.append(0.0)
			continue
		lat = lat.normalized()
		out.append(absf(d.x * lat.x + d.z * lat.z))
	return out


static func _stance_error(raw_w: Array, ours_w: Array, scale: float) -> Dictionary:
	if raw_w.is_empty() or ours_w.is_empty():
		return {"err": 1.0, "missing": true, "at": -1, "src": 0.0, "got": 0.0}
	var err := 0.0
	var at := 0
	var src_at := 0.0
	var got_at := 0.0
	var n := maxi(raw_w.size(), ours_w.size())
	for i in n:
		var src := float(raw_w[mini(i, raw_w.size() - 1)]) * scale
		var got := float(ours_w[mini(i, ours_w.size() - 1)])
		var e := absf(got - src) / maxf(src, 0.02)
		if e > err:
			err = e
			at = i
			src_at = src
			got_at = got
	return {"err": err, "missing": false, "at": at, "src": src_at, "got": got_at}


static func _globals(parents: Array[int], positions: Array[Vector3], rotations: Array[Quaternion]) -> Array:
	var result: Array = []
	result.resize(parents.size())
	for bone in parents.size():
		var local := Transform3D(Basis(rotations[bone]), positions[bone])
		var parent := parents[bone]
		result[bone] = (result[parent] as Transform3D) * local if parent >= 0 else local
	return result
