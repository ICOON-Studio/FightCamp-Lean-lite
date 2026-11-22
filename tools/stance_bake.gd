extends SceneTree
## FP2POSE3 (S537, owner C458): bakes the LONGER STANCE into every standing take v2 plays
## (scripts/fight3d/v2/Stance.gd says why and what). Run AFTER tools/cross_legs_bake.gd (the cross's rear leg is read
## as that bake left it and kept). Per take, at HZ pictures a second, in the take's own space (its hip travel kept):
## the lead ankle goes `lead` m forward and the rear ankle `rear` m back along the line to the other man, the hips
## `drop` m down (and further, eased, where a leg would be past REACH of its length), both legs solved again.
## It first prints what it measured (the table of docs/FP2POSE3_RESULT.md): per take, at its start and at its contact,
## the stance's length along the line and width across it (ankle to ankle), how far the chest is ahead of the hips and
## where the hips sit between the feet (0 = over the rear ankle, 1 = over the lead), before -> after.
## <godot> --headless --audio-driver Dummy --path . --script res://tools/stance_bake.gd -- [dry] [body=01] [lead=0.12 rear=0.04 drop=0.05] [hz=30] [only=<take>]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Stance := preload("res://scripts/fight3d/v2/Stance.gd")
const StepClips := preload("res://scripts/fight3d/v2/StepClips.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
var HZ := 30.0               # keys a second (hz=)
const REACH := 0.97           # a leg is never straighter than this share of its length (knee about 152 deg)
const SINK_F := 4             # the extra sink is eased over this many pictures each way
const LOOPS := ["st_wait", "st_wait_g", "pro_idle"]

var skel: Skeleton3D
var ap: AnimationPlayer
var fwd := Vector3.BACK       # the line to the other man, in the skeleton's space
var hips := -1
var ids: Array = []           # Stance.LEGS as bone numbers


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _seek(clip: String, t: float) -> void:
	ap.play(clip)
	ap.seek(t, true)


func _o(b: String) -> Vector3:
	return skel.get_bone_global_pose(skel.find_bone(b)).origin


## The stance now: [length along the line, width across it, chest ahead of the hips (cm), the hips between the feet 0..1].
func _read(lead: String, rear: String) -> Array:
	var side := Vector3.UP.cross(fwd)
	var d := _o(lead + "Foot") - _o(rear + "Foot")
	var len := fwd.dot(d)
	return [len * 100.0, absf(side.dot(d)) * 100.0, fwd.dot(_o("UpperChest") - _o("Hips")) * 100.0, fwd.dot(_o("Hips") - _o(rear + "Foot")) / maxf(len, 0.01)]


func _initialize() -> void:
	Stance.off = true
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("body", "01"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	Orbit.strip_modifiers(skel)
	hips = skel.find_bone("Hips")
	ids = Stance.LEGS.map(func(b): return skel.find_bone(str(b)))
	var f: Vector3 = skel.global_transform.basis.orthonormalized().inverse() * (bx["node"] as Node3D).global_transform.basis.z
	fwd = Vector3(f.x, 0.0, f.z).normalized()
	HZ = float(_arg("hz", str(HZ)))
	var lead_m := float(_arg("lead", str(Stance.LEAD_M)))
	var rear_m := float(_arg("rear", str(Stance.REAR_M)))
	var drop_m := float(_arg("drop", str(Stance.DROP_M)))
	var dry := OS.get_cmdline_user_args().has("dry")
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://assets/data/clip_db.json"))
	var rows: Dictionary = (parsed as Dictionary).get("rows", {}) if parsed is Dictionary else {}
	var names: Array = Stance.takes(rows, Array(ap.get_animation_list()), StepClips.REFIT.keys())
	if _arg("only", "") != "":
		names = names.filter(func(nm): return str(nm).begins_with(_arg("only", "")))
	DirAccess.make_dir_recursive_absolute(Stance.DIR)
	print("STANCE the line is %s in the skeleton's space; lead +%.0f cm, rear -%.0f cm, hips -%.0f cm; %d takes" % [str(fwd.snapped(Vector3.ONE * 0.01)), lead_m * 100.0, rear_m * 100.0, drop_m * 100.0, names.size()])
	var done := 0
	for name in names:
		var r: Dictionary = rows.get(str(name), {})
		var out := _bake(str(name), str(r.get("kind", "step")), float(r.get("contact_s", -1.0)), lead_m, rear_m, drop_m)
		out.set_meta(Stance.REST_META, skel.get_bone_rest(hips).origin.y)
		if not dry and ResourceSaver.save(out, Stance.DIR + str(name) + ".res") != OK:
			print("STANCE SAVE FAIL ", name)
			continue
		done += 1
	print("STANCE DONE %d of %d -> %s%s" % [done, names.size(), Stance.DIR, " (dry)" if dry else ""])
	quit(0 if done == names.size() else 1)


func _bake(clip: String, kind: String, contact_s: float, lead_m: float, rear_m: float, drop_m: float) -> Animation:
	var src := ap.get_animation(clip)
	var n := int(ceil(src.length * HZ - 0.001))
	var times: Array = []
	for k in n + 1:
		times.append(minf(float(k) / HZ, src.length))
	_seek(clip, 0.0)
	var lead := "Left" if fwd.dot(_o("LeftFoot") - _o("RightFoot")) >= 0.0 else "Right"
	var rear := "Right" if lead == "Left" else "Left"
	var move := {"Left": fwd * (lead_m if lead == "Left" else -rear_m), "Right": fwd * (lead_m if lead == "Right" else -rear_m)}
	var was0 := _read(lead, rear)
	var was_c: Array = []
	if contact_s >= 0.0:
		_seek(clip, contact_s)
		was_c = _read(lead, rear)
	# pass 1: how much further the hips must sink for both legs to reach
	var sink: Array = []
	for t in times:
		_seek(clip, float(t))
		var need := 0.0
		for s in 2:
			var a: Vector3 = skel.get_bone_global_pose(int(ids[s * 3])).origin + Vector3.DOWN * drop_m
			var b: Vector3 = skel.get_bone_global_pose(int(ids[s * 3 + 1])).origin + Vector3.DOWN * drop_m
			var c: Vector3 = skel.get_bone_global_pose(int(ids[s * 3 + 2])).origin
			var v: Vector3 = c + (move[["Left", "Right"][s]] as Vector3) - a
			var reach := ((b - a).length() + (c + Vector3.DOWN * drop_m - b).length()) * REACH
			var flat := Vector2(v.x, v.z).length()
			if v.length() > reach and reach > flat:
				need = maxf(need, -v.y - sqrt(reach * reach - flat * flat))
		sink.append(need)
	var loop := clip in LOOPS
	var eased: Array = []
	for pass_i in 2:
		eased = []
		for k in sink.size():
			var acc := 0.0
			for j in range(-SINK_F, SINK_F + 1):
				var q := posmod(k + j, sink.size() - 1) if loop else clampi(k + j, 0, sink.size() - 1)
				acc = maxf(acc, float(sink[q])) if pass_i == 0 else acc + float(sink[q]) / float(SINK_F * 2 + 1)
			eased.append(acc)
		sink = eased
	# pass 2: the legs again
	var out := Animation.new()
	out.length = src.length
	out.step = 1.0 / HZ
	var ht := out.add_track(Animation.TYPE_POSITION_3D)
	out.track_set_path(ht, NodePath("Hips"))
	var tr: Array = []
	for b in Stance.LEGS:
		var t := out.add_track(Animation.TYPE_ROTATION_3D)
		out.track_set_path(t, NodePath(str(b)))
		tr.append(t)
	var par := skel.get_bone_parent(hips)
	var most_sink := 0.0
	var short := 0.0
	var now0: Array = []
	var now_c: Array = []
	for k in times.size():
		var t := float(times[k])
		_seek(clip, t)
		_lower(par, drop_m + float(sink[k]), lead, rear, move, out, ht, tr, t)
		most_sink = maxf(most_sink, float(sink[k]))
		for s in 2:
			short = maxf(short, _short)
		if k == 0:
			now0 = _read(lead, rear)
	if contact_s >= 0.0:
		_seek(clip, contact_s)
		_lower(par, drop_m + float(sink[clampi(int(round(contact_s * HZ)), 0, sink.size() - 1)]), lead, rear, move, null, 0, [], 0.0)
		now_c = _read(lead, rear)
	var at_c := ""
	if not was_c.is_empty():
		at_c = " | at the contact %.2f s: %.0f -> %.0f long, %.0f -> %.0f wide, chest %+.0f cm ahead of the hips, hips at %.2f -> %.2f" % [contact_s, was_c[0], now_c[0], was_c[1], now_c[1], now_c[2], was_c[3], now_c[3]]
	print("STANCE %-30s %-8s %s lead | start: %.0f -> %.0f cm long, %.0f -> %.0f wide, chest %+.0f cm ahead of the hips, hips at %.2f -> %.2f between the feet%s | sinks %.1f cm more at most, a foot short of its place by %.1f mm at most" % [
		clip, kind, lead, was0[0], now0[0], was0[1], now0[1], now0[2], was0[3], now0[3], at_c, most_sink * 100.0, short * 1000.0])
	return out


var _short := 0.0


## The posed skeleton with the hips `down` m lower and each ankle on its moved place; keys written when `out` is given.
func _lower(par: int, down: float, lead: String, rear: String, move: Dictionary, out: Animation, ht: int, tr: Array, t: float) -> void:
	var want: Array = []
	var foot_q: Array = []
	for s in 2:
		var g := skel.get_bone_global_pose(int(ids[s * 3 + 2]))
		want.append(g.origin + (move[["Left", "Right"][s]] as Vector3))
		foot_q.append(g.basis.get_rotation_quaternion())
	var pb := skel.get_bone_global_pose(par).basis.orthonormalized() if par >= 0 else Basis.IDENTITY
	var delta: Vector3 = pb.inverse() * (Vector3.DOWN * down)
	skel.set_bone_pose_position(hips, skel.get_bone_pose_position(hips) + delta)
	_short = 0.0
	for s in 2:
		var leg: Array = [ids[s * 3], ids[s * 3 + 1], ids[s * 3 + 2]]
		_solve(leg, want[s])
		var shin := skel.get_bone_global_pose(int(leg[1])).basis.get_rotation_quaternion()
		skel.set_bone_pose_rotation(int(leg[2]), (shin.inverse() * (foot_q[s] as Quaternion)).normalized())
		_short = maxf(_short, (skel.get_bone_global_pose(int(leg[2])).origin - (want[s] as Vector3)).length())
	if out != null:
		out.position_track_insert_key(ht, t, delta)
		for i in 6:
			out.rotation_track_insert_key(int(tr[i]), t, skel.get_bone_pose_rotation(int(ids[i])))


## Two-bone IK in the skeleton's space (tools/step_bake.gd _solve): the ankle onto `t`, the knee in the plane it bends in.
func _solve(leg: Array, t: Vector3) -> void:
	var ga := skel.get_bone_global_pose(leg[0])
	var gb := skel.get_bone_global_pose(leg[1])
	var gc := skel.get_bone_global_pose(leg[2])
	var a := ga.origin
	var b := gb.origin
	var c := gc.origin
	var lab := (b - a).length()
	var lcb := (c - b).length()
	if lab < 1e-5 or lcb < 1e-5 or (c - a).length() < 1e-5 or (t - a).length() < 1e-5:
		return
	var lat := clampf((t - a).length(), absf(lab - lcb) + 1e-4, lab + lcb - 1e-4)
	var ac_ab_0 := acos(clampf((c - a).normalized().dot((b - a).normalized()), -1.0, 1.0))
	var ba_bc_0 := acos(clampf((a - b).normalized().dot((c - b).normalized()), -1.0, 1.0))
	var ac_at_0 := acos(clampf((c - a).normalized().dot((t - a).normalized()), -1.0, 1.0))
	var ac_ab_1 := acos(clampf((lcb * lcb - lab * lab - lat * lat) / (-2.0 * lab * lat), -1.0, 1.0))
	var ba_bc_1 := acos(clampf((lat * lat - lab * lab - lcb * lcb) / (-2.0 * lab * lcb), -1.0, 1.0))
	var axis0 := (c - a).cross(b - a)
	if axis0.length() < 1e-6:
		return
	axis0 = axis0.normalized()
	var r0 := Quaternion(axis0, ac_ab_1 - ac_ab_0)
	var r1 := Quaternion(axis0, ba_bc_1 - ba_bc_0)
	var axis1 := (c - a).cross(t - a)
	var r2 := Quaternion(axis1.normalized(), ac_at_0) if axis1.length() > 1e-6 else Quaternion.IDENTITY
	var qa1 := r2 * r0 * ga.basis.get_rotation_quaternion()
	var qb1 := r2 * r1 * r0 * gb.basis.get_rotation_quaternion()
	var par := skel.get_bone_parent(leg[0])
	var qp := skel.get_bone_global_pose(par).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
	skel.set_bone_pose_rotation(leg[0], (qp.inverse() * qa1).normalized())
	skel.set_bone_pose_rotation(leg[1], (qa1.inverse() * qb1).normalized())
