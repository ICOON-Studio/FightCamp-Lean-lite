extends SceneTree
## S410 HITREACT3: where does the head stop moving?
## Measures head travel (relative to UpperChest) and trunk angle after EVERY stage of the bake pipeline.
## Six clips: 3 WEAK (head travel drops), 3 CONTROL (head travel holds).
## Stages: raw JSON, retarget, hips correction, smooth+pin, fit, saved clip.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Plant := preload("res://tools/owned_mocap_plant.gd")
const Smooth := preload("res://tools/owned_mocap_smooth.gd")
const Fit := preload("res://tools/owned_mocap_fit.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const TEMPLATE := "res://assets/anim/baked/mc_Box1_M3_Idle.res"
const FPS := 30.0
const SRC_DIR := "E:/FightCamp/tmp/retarget2b/src"
const BAKED_DIR := "res://assets/anim/baked"
const TMP_DIR := "E:/FightCamp/tmp/hitreact3"

const AIM := {
	"Spine": "Chest", "Chest": "UpperChest", "UpperChest": "Neck", "Neck": "Head",
	"LeftShoulder": "LeftUpperArm", "LeftUpperArm": "LeftLowerArm", "LeftLowerArm": "LeftHand", "LeftHand": "LeftHandEnd",
	"RightShoulder": "RightUpperArm", "RightUpperArm": "RightLowerArm", "RightLowerArm": "RightHand", "RightHand": "RightHandEnd",
	"LeftUpperLeg": "LeftLowerLeg", "LeftLowerLeg": "LeftFoot", "LeftFoot": "LeftToes",
	"RightUpperLeg": "RightLowerLeg", "RightLowerLeg": "RightFoot", "RightFoot": "RightToes",
}
const OUR_END := {"LeftHandEnd": "LeftMiddleProximal", "RightHandEnd": "RightMiddleProximal"}
const MAPPED := ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head",
	"LeftShoulder", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightShoulder", "RightUpperArm", "RightLowerArm", "RightHand",
	"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]
const SPINE := ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head"]
const TRACKED := ["Hips", "LeftFoot", "RightFoot", "LeftToes", "RightToes", "Head", "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg"]

const CLIPS := [
	{"name": "pro_hit_by_hook_v5", "json": "Box1_M3_Hit_By_Hook_V5.json", "group": "WEAK", "res": "mc_Box1_M3_Hit_By_Hook_V5"},
	{"name": "pro_hit_by_jab_v5_short", "json": "Box1_M3_Hit_By_Jab_V5_Short.json", "group": "WEAK", "res": "mc_Box1_M3_Hit_By_Jab_V5_Short"},
	{"name": "pro_hit_by_cross_v2_short", "json": "Box1_M3_Hit_By_Cross_V2_Short.json", "group": "WEAK", "res": "mc_Box1_M3_Hit_By_Cross_V2_Short"},
	{"name": "pro_hit_by_hook_v3", "json": "Box1_M3_Hit_By_Hook_V3.json", "group": "CONTROL", "res": "mc_Box1_M3_Hit_By_Hook_V3"},
	{"name": "pro_hit_by_cross_v1", "json": "Box1_M3_Hit_By_Cross_V1.json", "group": "CONTROL", "res": "mc_Box1_M3_Hit_By_Cross_V1"},
	{"name": "pro_hit_by_hook_v6_short", "json": "Box1_M3_Hit_By_Hook_V6_Short.json", "group": "CONTROL", "res": "mc_Box1_M3_Hit_By_Hook_V6_Short"},
]

static func head_disp(head: Vector3, head0: Vector3, chest: Vector3, chest0: Vector3) -> float:
	return (head - chest).distance_to(head0 - chest0)

static func trunk_angle(hips: Vector3, neck: Vector3) -> float:
	var v := neck - hips
	if v.length() < 1e-5:
		return 0.0
	return rad_to_deg(v.angle_to(Vector3.UP))

static func _chain_xf(n: Node) -> Transform3D:
	var x := Transform3D.IDENTITY
	var cur := n
	while cur != null:
		if cur is Node3D:
			x = (cur as Node3D).transform * x
		cur = cur.get_parent()
	return x

static func _frame_basis(lateral: Vector3, up: Vector3) -> Basis:
	var u := up.normalized()
	var l := (lateral - u * lateral.dot(u)).normalized()
	return Basis(l, u, l.cross(u).normalized())

static func _yaw_about(up: Vector3, from: Vector3, to: Vector3) -> Quaternion:
	var a := (from - up * from.dot(up)).normalized()
	var b := (to - up * to.dot(up)).normalized()
	return Quaternion(up, a.signed_angle_to(b, up))

## Compute world positions from source JSON using FK chain formula:
## world_pos[bone] = world_pos[parent] + D[parent] * (rest[bone] - rest[parent])
static func _source_world_pos(frames: Array, rest: Dictionary) -> Array:
	var result := []
	for fi in frames.size():
		var f: Dictionary = frames[fi]
		var pos := {}
		var hips_arr: Array = f["P"]["Hips"]
		pos["Hips"] = Vector3(hips_arr[0], hips_arr[1], hips_arr[2])
		for i in range(1, SPINE.size()):
			var bone: String = SPINE[i]
			var parent: String = SPINE[i - 1]
			var d_arr: Array = f["D"][parent]
			var d_parent := Quaternion(d_arr[0], d_arr[1], d_arr[2], d_arr[3]).normalized()
			var rest_offset: Vector3 = (rest[bone] as Vector3) - (rest[parent] as Vector3)
			pos[bone] = (pos[parent] as Vector3) + d_parent * rest_offset
		result.append(pos)
	return result

static func _measure_series(positions: Array) -> Dictionary:
	if positions.is_empty():
		return {"head_m": 0.0, "trunk_deg": 0.0, "peak_head_f": 0, "peak_trunk_f": 0, "first_head": Vector3.ZERO, "first_chest": Vector3.ZERO}
	var head0: Vector3 = positions[0]["Head"]
	var chest0: Vector3 = positions[0]["UpperChest"]
	var hips0: Vector3 = positions[0]["Hips"]
	var neck0: Vector3 = positions[0]["Neck"]
	var base_ta := trunk_angle(hips0, neck0)
	var peak_head := 0.0
	var peak_trunk := 0.0
	var peak_head_f := 0
	var peak_trunk_f := 0
	for i in positions.size():
		var p: Dictionary = positions[i]
		var hd := head_disp(p["Head"], head0, p["UpperChest"], chest0)
		var ta := absf(trunk_angle(p["Hips"], p["Neck"]) - base_ta)
		if hd > peak_head:
			peak_head = hd
			peak_head_f = i
		if ta > peak_trunk:
			peak_trunk = ta
			peak_trunk_f = i
	return {"head_m": peak_head, "trunk_deg": peak_trunk, "peak_head_f": peak_head_f, "peak_trunk_f": peak_trunk_f,
		"first_head": head0, "first_chest": chest0, "hips_to_head": (head0 - hips0).length()}

const CLIP_SETTINGS := {
	"pro_hit_by_hook_v5": {"r": 0.02, "h": 0.03, "s": true, "st": true, "l": false},
	"pro_hit_by_jab_v5_short": {"r": 0.02, "h": 0.03, "s": true, "st": false, "l": false},
	"pro_hit_by_cross_v2_short": {"r": 0.02, "h": 0.03, "s": false, "st": false, "l": true},
	"pro_hit_by_hook_v3": {"r": 0.04, "h": 0.06, "s": true, "st": false, "l": false},
	"pro_hit_by_cross_v1": {"r": 0.02, "h": 0.03, "s": true, "st": false, "l": false},
	"pro_hit_by_hook_v6_short": {"r": 0.08, "h": 0.13, "s": true, "st": false, "l": false},
}

static func _measure_anim(anim: Animation, skel: Skeleton3D, n_frames: int) -> Dictionary:
	var tr := Plant._tracks(anim)
	var bones := ["Head", "Neck", "Hips", "UpperChest"]
	var positions := []
	for k in n_frames:
		var pos := {}
		for bname in bones:
			var bi := skel.find_bone(bname)
			var x := Transform3D.IDENTITY
			var cur := bi
			while cur >= 0:
				var nm := skel.get_bone_name(cur)
				var local := skel.get_bone_rest(cur)
				if tr.has(nm):
					local = Transform3D(Basis(anim.track_get_key_value(tr[nm], k) as Quaternion), local.origin)
				if tr.has(nm + "@pos"):
					local.origin += anim.track_get_key_value(tr[nm + "@pos"], k) as Vector3
				x = local * x
				cur = skel.get_bone_parent(cur)
			pos[bname] = x.origin
		positions.append(pos)
	return _measure_series(positions)

static func _read_saved_keys(anim: Animation, skel: Skeleton3D) -> Array:
	var tr := Plant._tracks(anim)
	var bones := ["Head", "Neck", "Hips", "UpperChest"]
	var n_keys: int = anim.track_get_key_count(tr["Head"]) if tr.has("Head") else 0
	var positions := []
	for k in n_keys:
		var pos := {}
		for bname in bones:
			var bi := skel.find_bone(bname)
			var x := Transform3D.IDENTITY
			var cur := bi
			while cur >= 0:
				var nm := skel.get_bone_name(cur)
				var local := skel.get_bone_rest(cur)
				if tr.has(nm):
					local = Transform3D(Basis(anim.track_get_key_value(tr[nm], k) as Quaternion), local.origin)
				if tr.has(nm + "@pos"):
					local.origin += anim.track_get_key_value(tr[nm + "@pos"], k) as Vector3
				x = local * x
				cur = skel.get_bone_parent(cur)
			pos[bname] = x.origin
		positions.append(pos)
	return positions

func _read_bones(skel: Skeleton3D) -> Dictionary:
	var xf := skel.global_transform
	var head_idx := skel.find_bone("Head")
	var neck_idx := skel.find_bone("Neck")
	var hips_idx := skel.find_bone("Hips")
	var chest_idx := skel.find_bone("UpperChest")
	if head_idx < 0 or neck_idx < 0 or hips_idx < 0 or chest_idx < 0:
		return {}
	return {
		"head": xf * skel.get_bone_global_pose(head_idx).origin,
		"neck": xf * skel.get_bone_global_pose(neck_idx).origin,
		"hips": xf * skel.get_bone_global_pose(hips_idx).origin,
		"chest": xf * skel.get_bone_global_pose(chest_idx).origin,
	}

func _measure_skel(skel: Skeleton3D, n_frames: int) -> Dictionary:
	var base := _read_bones(skel)
	if base.is_empty():
		return {"head_m": 0.0, "trunk_deg": 0.0, "peak_head_f": 0, "peak_trunk_f": 0, "first_head": Vector3.ZERO, "first_chest": Vector3.ZERO, "hips_to_head": 0.0}
	var base_head: Vector3 = base["head"]
	var base_chest: Vector3 = base["chest"]
	var base_ta := trunk_angle(base["hips"], base["neck"])
	var peak_head := 0.0
	var peak_trunk := 0.0
	var peak_head_f := 0
	var peak_trunk_f := 0
	for fr in range(1, n_frames):
		var bones := _read_bones_at_frame(skel, fr)
		if bones.is_empty():
			continue
		var hd := head_disp(bones["head"], base_head, bones["chest"], base_chest)
		var ta := absf(trunk_angle(bones["hips"], bones["neck"]) - base_ta)
		if hd > peak_head:
			peak_head = hd
			peak_head_f = fr
		if ta > peak_trunk:
			peak_trunk = ta
			peak_trunk_f = fr
	return {"head_m": peak_head, "trunk_deg": peak_trunk, "peak_head_f": peak_head_f, "peak_trunk_f": peak_trunk_f,
		"first_head": base_head, "first_chest": base_chest, "hips_to_head": (base_head - base["hips"]).length()}

func _read_bones_at_frame(skel: Skeleton3D, _fr: int) -> Dictionary:
	return _read_bones(skel)

var _fk_par: Array = []; var _fk_rot: Array = []; var _fk_pos: Array = []
func _g(i: int) -> Transform3D:
	var x := Transform3D(Basis(_fk_rot[i] as Quaternion), _fk_pos[i] as Vector3)
	var p: int = _fk_par[i]
	while p >= 0:
		x = Transform3D(Basis(_fk_rot[p] as Quaternion), _fk_pos[p] as Vector3) * x
		p = _fk_par[p]
	return x

func _initialize() -> void:
	Engine.max_fps = 30
	DirAccess.make_dir_recursive_absolute(TMP_DIR)
	var body := MH.load_fighter("res://assets/models/metahuman/mh_boxer_01.glb")
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var up_t := (_chain_xf(skel).basis.inverse() * Vector3.UP).normalized()
	var bi := {}
	for n in MAPPED:
		bi[n] = skel.find_bone(n)
	for e in OUR_END:
		bi[e] = skel.find_bone(OUR_END[e])
	var rest_t := {}
	for n in bi:
		rest_t[n] = skel.get_bone_global_rest(bi[n]).origin
	var mh_uc_to_head: float = (rest_t["Head"] - rest_t["UpperChest"]).length()
	print("HITREACT3_STAGES MetaHuman mh_boxer_01 UpperChest_to_Head=%.4f" % mh_uc_to_head)
	var all_results := []
	for clip in CLIPS:
		var stg: Dictionary = CLIP_SETTINGS.get(clip["name"], {"r": 0.02, "h": 0.03, "s": true, "st": true, "l": false})
		var stg_s: bool = stg["s"]; var stg_pin: bool = true
		Fit.room_soft = float(stg["r"]); Fit.room_hard = float(stg["h"]); Fit.lock_planted = bool(stg["l"]); Fit.still_plants = bool(stg["st"])
		var json_path := SRC_DIR.path_join(clip["json"])
		if not FileAccess.file_exists(json_path):
			print("HITREACT3 MISSING %s" % json_path)
			continue
		var d: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(json_path))
		var rest_s := {}
		for j in d["rest"]:
			var v: Array = d["rest"][j]
			rest_s[j] = Vector3(v[0], v[1], v[2])
		var frames: Array = d["frames"]
		var src_uc_to_head: float = (rest_s["Head"] - rest_s["UpperChest"]).length()
		print("HITREACT3_STAGES %s [%s] src_frames=%d src_uc_to_head=%.4f" % [clip["name"], clip["group"], frames.size(), src_uc_to_head])
		var src_positions := _source_world_pos(frames, rest_s)
		var raw := _measure_series(src_positions)
		print("  RAW head_m=%.4f trunk_deg=%.1f peak_head_f=%d peak_trunk_f=%d first_head=(%.3f,%.3f,%.3f) hips_to_head=%.3f" % [
			raw["head_m"], raw["trunk_deg"], raw["peak_head_f"], raw["peak_trunk_f"],
			(raw["first_head"] as Vector3).x, (raw["first_head"] as Vector3).y, (raw["first_head"] as Vector3).z, raw["hips_to_head"]])
		var leg_s := 0.0; var leg_tt := 0.0
		for side in ["Left", "Right"]:
			leg_s += (rest_s[side + "UpperLeg"] - rest_s[side + "LowerLeg"]).length() + (rest_s[side + "LowerLeg"] - rest_s[side + "Foot"]).length()
			leg_tt += (rest_t[side + "UpperLeg"] - rest_t[side + "LowerLeg"]).length() + (rest_t[side + "LowerLeg"] - rest_t[side + "Foot"]).length()
		var k := leg_tt / leg_s
		var bs := _frame_basis(rest_s["LeftUpperLeg"] - rest_s["RightUpperLeg"], Vector3.UP)
		var bt := _frame_basis(rest_t["LeftUpperLeg"] - rest_t["RightUpperLeg"], up_t)
		var Q := (bt * bs.inverse()).get_rotation_quaternion()
		var Qi := Q.inverse()
		var S := (Q * Quaternion.IDENTITY).normalized()
		var h0_v: Array = frames[0]["P"]["Hips"]
		var h0 := Vector3(h0_v[0], h0_v[1], h0_v[2])
		var hj_off_s: Vector3 = (rest_s["LeftUpperLeg"] + rest_s["RightUpperLeg"]) * 0.5 - rest_s["Hips"]
		var lows: Array = []
		for f in frames:
			var lt: Array = f["P"]["LeftToes"]; var rt: Array = f["P"]["RightToes"]
			lows.append(minf(float(lt[1]), float(rt[1])))
		lows.sort()
		var floor_s: float = lows[int(lows.size() * 0.1)]
		var toe_t: float = minf(rest_t["LeftToes"].dot(up_t), rest_t["RightToes"].dot(up_t))
		var hips_t: Vector3 = rest_t["Hips"]
		_fk_par.clear(); _fk_rot.clear(); _fk_pos.clear()
		for i in skel.get_bone_count():
			_fk_par.append(skel.get_bone_parent(i))
			_fk_rot.append(skel.get_bone_rest(i).basis.get_rotation_quaternion())
			_fk_pos.append(skel.get_bone_rest(i).origin)
		var order: Array = MAPPED.duplicate()
		order.sort_custom(func(a, b): return bi[a] < bi[b])
		for n in order:
			if not AIM.has(n) or not rest_s.has(AIM[n]):
				continue
			var b: int = bi[n]
			var want: Vector3 = Q * (rest_s[AIM[n]] - rest_s[n])
			var have: Vector3 = _g(bi[AIM[n]]).origin - _g(b).origin
			var swing := Quaternion(have.normalized(), want.normalized())
			var g := swing * _g(b).basis.get_rotation_quaternion()
			var par := skel.get_bone_parent(b)
			var pg := _g(par).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
			_fk_rot[b] = (pg.inverse() * g).normalized()
		var ref_local := []
		for i in skel.get_bone_count():
			ref_local.append(_fk_rot[i])
		var gref := {}
		for n in MAPPED:
			gref[n] = _g(bi[n]).basis.get_rotation_quaternion()
		var hps := []
		var corr := []
		var retarget_positions := []
		var all_rots := []
		# Fault 5 fix: reset FK to skeleton rest before AIM (clip 2+ had stale rotations from clip N-1)
		_fk_rot.clear()
		for i in skel.get_bone_count():
			_fk_rot.append(skel.get_bone_rest(i).basis.get_rotation_quaternion())
		for fi in frames.size():
			var f: Dictionary = frames[fi]
			for i in skel.get_bone_count():
				_fk_rot[i] = ref_local[i]
			for n in order:
				var b: int = bi[n]
				var d_arr: Array = f["D"][n]
				var d_q := Quaternion(d_arr[0], d_arr[1], d_arr[2], d_arr[3]).normalized()
				var g := (S * d_q * Qi) * (gref[n] as Quaternion)
				var par := skel.get_bone_parent(b)
				var pg := _g(par).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
				_fk_rot[b] = (pg.inverse() * g).normalized()
			all_rots.append(_fk_rot.duplicate())
			var hs_a: Array = f["P"]["Hips"]; var hs := Vector3(hs_a[0], hs_a[1], hs_a[2])
			var dxz := Vector3(hs.x - h0.x, 0.0, hs.z - h0.z)
			var dh_a: Array = f["D"]["Hips"]; var dh_q := Quaternion(dh_a[0], dh_a[1], dh_a[2], dh_a[3]).normalized()
			var hj_y: float = hs.y + (dh_q * hj_off_s).y
			var rise := (hj_y - floor_s) * k
			var off_t: Vector3 = (_g(bi["LeftUpperLeg"]).origin + _g(bi["RightUpperLeg"]).origin) * 0.5 - _g(bi["Hips"]).origin
			var hp: Vector3 = hips_t - up_t * hips_t.dot(up_t) + up_t * (toe_t + rise - off_t.dot(up_t)) + (S * dxz) * k
			hps.append(hp)
			var wsum := 0.0; var acc_c := Vector3.ZERO
			for side in ["L", "R"]:
				var nm := "Left" if side == "L" else "Right"
				var toe := _g(bi[nm + "Toes"]).origin
				var ps_a: Array = f["P"][nm + "Toes"]; var ps := Vector3(ps_a[0], ps_a[1], ps_a[2])
				var w := clampf(1.0 - (ps.y - floor_s) / 0.03, 0.0, 1.0)
				if w > 0.0:
					var want_xz: Vector3 = (S * Vector3(ps.x - h0.x, 0.0, ps.z - h0.z)) * k + (hips_t - up_t * hips_t.dot(up_t))
					var dt: Vector3 = want_xz - toe; dt -= up_t * dt.dot(up_t)
					acc_c += dt * w; wsum += w
			corr.append(acc_c / wsum if wsum > 0.05 else null)
			var uc_pos := _g(bi["UpperChest"]).origin
			var head_pos := _g(bi["Head"]).origin
			var neck_pos := _g(bi["Neck"]).origin
			var hips_pos := _g(bi["Hips"]).origin
			retarget_positions.append({"Head": head_pos, "UpperChest": uc_pos, "Neck": neck_pos, "Hips": hips_pos})
		var ret := _measure_series(retarget_positions)
		print("  RETARGET head_m=%.4f trunk_deg=%.1f peak_head_f=%d peak_trunk_f=%d first_head=(%.3f,%.3f,%.3f)" % [
			ret["head_m"], ret["trunk_deg"], ret["peak_head_f"], ret["peak_trunk_f"],
			(ret["first_head"] as Vector3).x, (ret["first_head"] as Vector3).y, (ret["first_head"] as Vector3).z])
		# --- Animation pipeline stages ---
		var hb: int = bi["Hips"]; var hpar: int = skel.get_bone_parent(hb)
		var hrest: Vector3 = skel.get_bone_rest(hb).origin
		var n_f: int = frames.size()
		var filled := []; filled.resize(n_f)
		var last_i := -1
		for i in n_f:
			if corr[i] != null:
				if last_i < 0:
					for j in i: filled[j] = corr[i]
				else:
					for j in range(last_i + 1, i): filled[j] = (corr[last_i] as Vector3).lerp(corr[i], float(j - last_i) / float(i - last_i))
				filled[i] = corr[i]; last_i = i
		for j in range(last_i + 1, n_f): filled[j] = corr[last_i] if last_i >= 0 else Vector3.ZERO
		var anim := Animation.new()
		anim.length = (n_f - 1) / FPS; anim.step = 1.0 / FPS
		var tmpl := load(TEMPLATE) as Animation
		var tr_map := {}
		for t in tmpl.get_track_count():
			var nt := anim.add_track(tmpl.track_get_type(t))
			anim.track_set_path(nt, tmpl.track_get_path(nt))
			anim.track_set_interpolation_type(nt, tmpl.track_get_interpolation_type(nt))
			tr_map[nt] = skel.find_bone(str(tmpl.track_get_path(t)))
		var hpos_track := -1
		for nt in tr_map:
			if anim.track_get_type(nt) == Animation.TYPE_POSITION_3D: hpos_track = nt
		for fi in n_f:
			var frame_rots: Array = all_rots[fi]
			for nt in tr_map:
				var b: int = tr_map[nt]
				if anim.track_get_type(nt) == Animation.TYPE_ROTATION_3D:
					anim.rotation_track_insert_key(nt, fi / FPS, frame_rots[b])
		for i in n_f:
			var sm := Vector3.ZERO; var cnt := 0
			for j in range(maxi(0, i - 3), mini(n_f, i + 4)): sm += filled[j]; cnt += 1
			anim.position_track_insert_key(hpos_track, i / FPS, (hps[i] as Vector3) + sm / cnt - hrest)
		var hip_corr := _measure_anim(anim, skel, n_f)
		print("  HIP_CORRECTED head_m=%.4f trunk_deg=%.1f" % [hip_corr["head_m"], hip_corr["trunk_deg"]])
		var punch: Dictionary = Plant.punch_exempt(anim, skel)
		if stg_s: Smooth.smooth(anim, [], punch)
		var smooth_m := _measure_anim(anim, skel, n_f)
		print("  SMOOTH head_m=%.4f trunk_deg=%.1f" % [smooth_m["head_m"], smooth_m["trunk_deg"]])
		var pinned: Dictionary = Plant.pin(anim, skel, up_t) if stg_pin else {}
		if stg_s and stg_pin:
			Smooth.smooth(anim, ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"], {}, 0.05)
			pinned = Plant.pin(anim, skel, up_t)
		var pin_m := _measure_anim(anim, skel, n_f)
		print("  PIN head_m=%.4f trunk_deg=%.1f" % [pin_m["head_m"], pin_m["trunk_deg"]])
		var fit_tr := Plant._tracks(anim)
		var fit_frames := []
		for f in frames:
			var nf := {"D": {}, "P": {}}
			for b in f["D"]: var qa: Array = f["D"][b]; nf["D"][b] = Quaternion(qa[0], qa[1], qa[2], qa[3]).normalized()
			for b in f["P"]: var pa: Array = f["P"][b]; nf["P"][b] = Vector3(pa[0], pa[1], pa[2])
			fit_frames.append(nf)
		var goals := Fit.targets(anim, skel, fit_tr, bi, fit_frames, S, k)
		for side in ["Left", "Right"]:
			var leg := [bi[side + "UpperLeg"], bi[side + "LowerLeg"], bi[side + "Foot"]]
			for fi in n_f:
				Plant._leg_ik(anim, skel, fit_tr, side, leg, fi, (goals["want"][side][fi] as Vector3) - Plant._glob(skel, anim, fit_tr, leg[2], fi).origin)
		if stg_s:
			for _pass in 4: Smooth.smooth(anim, ["Hips", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"], {}, 0.05)
			Plant.pin(anim, skel, up_t)
			var ht: int = fit_tr["Hips@pos"]
			var pb := skel.get_bone_global_rest(hpar).basis if hpar >= 0 else Basis.IDENTITY
			for fi in n_f:
				var correction := Vector3.ZERO; var count := 0
				for side in ["Left", "Right"]:
					var foot: int = bi[side + "Foot"]
					var delta: Vector3 = goals["want"][side][fi] - Plant._glob(skel, anim, fit_tr, foot, fi).origin
					correction.y += delta.y * 0.5
					if goals["on"][side][fi]: correction += Vector3(delta.x, 0.0, delta.z); count += 1
				if count > 0: correction = Vector3(correction.x / count, correction.y, correction.z / count)
				anim.track_set_key_value(ht, fi, (anim.track_get_key_value(ht, fi) as Vector3) + pb.inverse() * correction)
		Fit.finish(anim, skel, fit_tr, bi, fit_frames, k, goals["want"], goals["on"], 2, up_t)
		var fit_m := _measure_anim(anim, skel, n_f)
		print("  FIT head_m=%.4f trunk_deg=%.1f fit_frames=%d fit_length=%.3f" % [fit_m["head_m"], fit_m["trunk_deg"], n_f, anim.length])
		var fit_positions := []
		var fit_bones := ["Head", "Neck", "Hips", "UpperChest"]
		for fi in n_f:
			var pos := {}
			for bname in fit_bones:
				var bone_i := skel.find_bone(bname)
				var x := Transform3D.IDENTITY
				var cur := bone_i
				while cur >= 0:
					var nm := skel.get_bone_name(cur)
					var local := skel.get_bone_rest(cur)
					if fit_tr.has(nm):
						local = Transform3D(Basis(anim.track_get_key_value(fit_tr[nm], fi) as Quaternion), local.origin)
					if fit_tr.has(nm + "@pos"):
						local.origin += anim.track_get_key_value(fit_tr[nm + "@pos"], fi) as Vector3
					x = local * x
					cur = skel.get_bone_parent(cur)
				pos[bname] = x.origin
			fit_positions.append(pos)
		all_results.append({"clip": clip, "raw": raw, "retarget": ret, "src_uc_to_head": src_uc_to_head, "mh_uc_to_head": mh_uc_to_head, "frames": frames.size(),
			"src_positions": src_positions, "retarget_positions": retarget_positions, "fit_positions": fit_positions, "fit_n": n_f, "fit_length": anim.length})
	print("HITREACT3_STAGES_DONE clips=%d" % all_results.size())
	for r in all_results:
		var clip: Dictionary = r["clip"]
		var res_path := BAKED_DIR.path_join(clip["res"] + ".res")
		if not ResourceLoader.exists(res_path):
			print("HITREACT3 MISSING saved clip %s" % res_path)
			continue
		var saved_anim: Animation = load(res_path) as Animation
		var saved_positions := _read_saved_keys(saved_anim, skel)
		var saved_n: int = saved_positions.size()
		var saved_length: float = saved_anim.length
		print("  SAVED [%s] keys=%d length=%.3f fit_frames=%d fit_length=%.3f" % [clip["name"], saved_n, saved_length, r["fit_n"], r["fit_length"]])
		var saved_m := _measure_series(saved_positions)
		print("  SAVED_KEYS head_m=%.4f trunk_deg=%.1f peak_head_f=%d" % [saved_m["head_m"], saved_m["trunk_deg"], saved_m["peak_head_f"]])
		var fit_positions: Array = r["fit_positions"]
		var fit_n: int = r["fit_n"]
		var compare_n: int = mini(fit_n, saved_n)
		if compare_n > 0:
			var max_head_diff := 0.0
			var max_head_diff_f := 0
			for fi in compare_n:
				var fp: Dictionary = fit_positions[fi]
				var sp: Dictionary = saved_positions[fi]
				var fit_head_rel: Vector3 = (fp["Head"] as Vector3) - (fp["UpperChest"] as Vector3)
				var saved_head_rel: Vector3 = (sp["Head"] as Vector3) - (sp["UpperChest"] as Vector3)
				var d: float = fit_head_rel.distance_to(saved_head_rel)
				if d > max_head_diff:
					max_head_diff = d
					max_head_diff_f = fi
			print("  FIT_vs_SAVED head_rel max_diff=%.4f at_frame=%d" % [max_head_diff, max_head_diff_f])
	body.free()
	quit(0)
