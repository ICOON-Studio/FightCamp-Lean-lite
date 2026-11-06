extends SceneTree
## FOOTWORK1 probe (S381): the rig on a real boxer, headless.
## Round 3 (operator on r4c_side: "his ass is bouncing more than usual"): per-BOUNCE numbers on the final pose, as
## medians over the bounces (one bounce = one plan beat), in place (bouncing, no flat-footed spell) and on step pairs:
##   hips vertical p2p, hips fore-aft p2p (along her facing), pelvis pitch p2p (the Hips bone's up axis, sagittal),
##   head vertical p2p, the ratio hips / head, the backside point (12 cm behind / 8 cm under the hip joint, riding the
##   pelvis) vertical + fore-aft p2p, ankle rise p2p (= what the heels give), leg compression p2p (hip-to-ankle height
##   = what the knees give), knee inner angle p2p, plan heel p2p.
##   godot --headless --path . --script res://tools/footwork_probe.gd -- [glb=mh_boxer_01] [secs=8] [frames]
## `frames` also prints the r2 per-frame line (valgus, ball heights, lean).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Footwork := preload("res://scripts/fight3d/BoxerFootwork.gd")
const Rig := preload("res://scripts/fight3d/BoxerFootworkRig.gd")
const DT := 1.0 / 30.0
const GLUTE := Vector3(0.0, -0.08, -0.12)   # skeleton space (+Z forward): the backside from the hip joint


func _initialize() -> void:
	var who := "mh_boxer_01"
	var secs := 8.0
	var frames := false
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("glb="):
			who = s.substr(4)
		elif s.begins_with("secs="):
			secs = float(s.substr(5))
		elif s == "frames":
			frames = true
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % who, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var body: Node3D = bx["node"]
	var ap: AnimationPlayer = bx["ap"]
	if bx.get("feet") != null:
		(bx["feet"] as Node).free()
	var fw = Footwork.new(Vector2(body.global_position.x, body.global_position.z), body.global_rotation.y, false, body.scale.x)
	fw.auto_flat = false
	var rig: Node = bx["rig"]   # S391: every boxer carries it, let go until something takes her legs
	rig.plan = fw
	rig.want = 1.0
	rig.w = 1.0
	var reads: Array = []
	var hips_rest := skel.get_bone_global_rest(skel.find_bone("Hips")).basis
	skel.skeleton_updated.connect(func(): reads.append(sample(skel, rig, fw, hips_rest)))
	var clip_len := ap.get_animation("pro_idle").length
	var rows: Array = []   # [beat, busy, sample]
	var total := int(secs / DT)
	for f in total:
		if f == int(secs * 0.5 / DT):
			for d in ["fwd", "back", "fwd", "back", "left", "right"]:
				fw.step(d)
		fw.tick(DT)
		rig.drive()
		ap.play("pro_idle")
		ap.seek(fmod(f * DT, clip_len), true)
		ap.pause()
		reads.clear()
		await process_frame
		if reads.is_empty():
			continue
		var smp: Dictionary = reads.back()
		rows.append([fw.beats, fw.busy(), smp])
		if frames:
			print("t=%.2f %s" % [f * DT, smp["line"]])
	print("PROBE %s (scale %.3f)" % [who, body.scale.x])
	report("in place", rows, false)
	report("step pairs", rows, true)
	quit(0)


## Prints stats(): per bounce p2p medians and max, the hips/head ratio, the mean knee bend.
static func report(tag: String, rows: Array, busy: bool) -> void:
	var st := stats(rows, busy)
	var line := "%s (%d bounces):" % [tag, int(st["bounces"])]
	var unit := {"pitch": " deg", "knee_l": " deg", "knee_r": " deg"}
	for n in NAMES:
		var k := 1.0 if unit.has(n) else 100.0
		line += "  %s %.2f (max %.2f)%s" % [n, float(st[n][0]) * k, float(st[n][1]) * k, unit.get(n, " cm")]
	line += "  hip/head %.2f (max %.2f)  knee bend mean lead %.1f rear %.1f deg (inner angle)" % [st["ratio"][0],
		st["ratio"][1], st["knee_mean"][0], st["knee_mean"][1]]
	print(line)


const NAMES := ["hip_y", "hip_fa", "pitch", "head_y", "glute_y", "glute_fa", "ankle_y", "leg", "knee_l", "knee_r", "heel"]


## rows: [plan beat, busy, sample()]. Per bounce (one plan beat; the first and the last, partial ones, skipped) the p2p of
## each measure -> {name: [median, max], ratio: [median, max] of hips/head, knee_mean: [lead, rear], bounces}.
static func stats(rows: Array, busy: bool) -> Dictionary:
	var by: Dictionary = {}
	for r in rows:
		if bool(r[1]) != busy:
			continue
		var k := int(r[0])
		if not by.has(k):
			by[k] = []
		(by[k] as Array).append(r[2])
	var keys: Array = by.keys()
	keys.sort()
	if keys.size() > 2:
		keys = keys.slice(1, keys.size() - 1)
	var per: Dictionary = {}
	for n in NAMES:
		per[n] = []
	var ratios: Array = []
	var knees := Vector2.ZERO
	var count := 0
	for k in keys:
		var smps: Array = by[k]
		if smps.size() < 8:
			continue
		var p2: Dictionary = {}
		for n in NAMES:
			var lo := INF
			var hi := -INF
			for s in smps:
				lo = minf(lo, float(s[n]))
				hi = maxf(hi, float(s[n]))
			p2[n] = hi - lo
			(per[n] as Array).append(hi - lo)
		for s in smps:
			knees += Vector2(float(s["knee_l"]), float(s["knee_r"]))
			count += 1
		ratios.append(float(p2["hip_y"]) / maxf(float(p2["head_y"]), 1e-4))
	var out := {"bounces": ratios.size(), "ratio": [_median(ratios), _max(ratios)],
		"knee_mean": [knees.x / maxf(count, 1), knees.y / maxf(count, 1)]}
	for n in NAMES:
		out[n] = [_median(per[n]), _max(per[n])]
	return out


static func _median(xs: Array) -> float:
	if xs.is_empty():
		return 0.0
	var s := xs.duplicate()
	s.sort()
	return float(s[s.size() / 2])


static func _max(xs: Array) -> float:
	var m := 0.0
	for x in xs:
		m = maxf(m, float(x))
	return m


static func sample(skel: Skeleton3D, rig: Node, fw, hips_rest: Basis) -> Dictionary:
	var xf := skel.global_transform
	var p: Dictionary = fw.pose()
	var yaw := float(p["yaw"])
	var left := Vector3(cos(yaw), 0, -sin(yaw))
	var fwd := Vector3(sin(yaw), 0, cos(yaw))
	var hb := skel.get_bone_global_pose(skel.find_bone("Hips"))
	var hips := xf * hb.origin
	var head := xf * skel.get_bone_global_pose(skel.find_bone("Head")).origin
	var neck := xf * skel.get_bone_global_pose(skel.find_bone("Neck")).origin
	var glute := xf * (hb.origin + (hb.basis * hips_rest.inverse()) * GLUTE)
	var up := (xf.basis * hb.basis * hips_rest.inverse() * Vector3.UP).normalized()
	var pitch := rad_to_deg(atan2(up.dot(fwd), up.y))
	var out := {"hip_y": hips.y, "hip_fa": (hips - xf.origin).dot(fwd), "pitch": pitch, "head_y": head.y, "glute_y": glute.y,
		"glute_fa": (glute - xf.origin).dot(fwd)}
	var ank_y := 0.0
	var line := ""
	var ank: Array = []
	for i in 2:
		var ids: Array = rig._legs[i]["ids"]
		var h := xf * skel.get_bone_global_pose(ids[0]).origin
		var k := xf * skel.get_bone_global_pose(ids[1]).origin
		var a := xf * skel.get_bone_global_pose(ids[2]).origin
		var t := xf * skel.get_bone_global_pose(ids[3]).origin
		ank.append(a)
		ank_y += a.y * 0.5
		out["knee_l" if i == 0 else "knee_r"] = rad_to_deg((h - k).angle_to(a - k))
		var ff := Vector3(t.x - a.x, 0, t.z - a.z).normalized()
		var lat := ff.cross(Vector3.UP)
		var mid_side := signf((h - a).dot(lat))
		var shin := Vector2((k - a).dot(lat), (k - a).y)
		var valg := rad_to_deg(atan2(shin.x * mid_side, shin.y))
		line += "[%s knee %+.1f deg, ball y %.1f cm, planted %s] " % ["lead" if i == 0 else "rear", valg,
			(t.y - xf.origin.y) * 100.0, p["feet"][i]["planted"]]
	out["ankle_y"] = ank_y
	out["heel"] = maxf(float(p["feet"][0]["heel"]), float(p["feet"][1]["heel"]))
	out["leg"] = hips.y - ank_y
	var d: Vector3 = ank[0] - ank[1]
	var tor := neck - hips
	line += "ankles lat %.1f along %.1f cm; lean %.1f deg; hips y %.1f" % [absf(d.dot(left)) * 100.0, absf(d.dot(fwd)) * 100.0,
		rad_to_deg(atan2(tor.dot(fwd), tor.y)), hips.y * 100.0]
	out["line"] = line
	return out
