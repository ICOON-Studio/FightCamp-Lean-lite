extends SceneTree
## S537 AFRETARGET1 RETARGETMATCH (owner: "the animation looks fine on actionforge, the knee twisting is not there"):
## a clip of the plain cross against ActionForge's own retarget of the same bought take on the same body
## (assets/anim/af_retarget/box1_m3_right_cross_af.glb), the clip alone, picture by picture.
## Bars (the brief's): each knee within 2 cm of ActionForge's (off its hip-ankle line, on our leg), thigh and shin
## within 3 deg (each joint's own rotation). ActionForge's own one-picture pops are left out (tools/afretarget_lib.gd).
##   - the clip `-- afretarget` plays (assets/anim/af_retarget/mc_Box1_M3_Right_Cross.res: ActionForge's legs under
##     our bake's upper body) must pass;
##   - our bake of the take (assets/anim/baked/) is the control arm: it must READ worse (it copies the bought file's
##     joints; ActionForge re-poses the legs), so the ruler is known to see the difference.
## And the judge, where the bought file is on the machine (it is not in the repo): our bake keeps the actor's legs and
## palms (within 6 / 15 deg of the FILE); ActionForge's export does not (legs > 15 deg, palms > 90 deg off the file);
## the `afretarget` clip keeps our palms (within 15 deg of the file).

const MH := preload("res://scripts/fight3d/MHRig.gd")
const KR := preload("res://tools/kneeroot_lib.gd")
const AF := preload("res://tools/afretarget_lib.gd")
const KNEE_CM := 2.0
const TURN_DEG := 3.0
const LEG := ["LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg"]

var failures := 0


func _initialize() -> void:
	var body := MH.load_fighter("res://assets/models/metahuman/mh_boxer_01.glb")
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var af := AF.af_anim()
	_check(af != null, "ActionForge's export of the cross loads")
	if af == null:
		quit(1)
		return
	var skip := {}
	for m in AF.pops(af, false):
		skip[int(m[1])] = true
	var fixed := _read(skel, af, skip, "res://assets/anim/af_retarget/mc_Box1_M3_Right_Cross.res")
	var ours := _read(skel, af, skip, "res://assets/anim/baked/mc_Box1_M3_Right_Cross.res")
	print("RETARGETMATCH the clip `afretarget` plays: knee %.1f cm, thigh/shin %.1f deg (bars %.0f cm, %.0f deg; %d of ActionForge's pictures left out as its own pops)" % [fixed.x, fixed.y, KNEE_CM, TURN_DEG, skip.size()])
	print("RETARGETMATCH our bake of the bought file (control arm): knee %.1f cm, thigh/shin %.1f deg" % [ours.x, ours.y])
	_check(fixed.x <= KNEE_CM, "RETARGETMATCH knees within %.0f cm of ActionForge (%.1f)" % [KNEE_CM, fixed.x])
	_check(fixed.y <= TURN_DEG, "RETARGETMATCH thigh and shin within %.0f deg of ActionForge (%.1f)" % [TURN_DEG, fixed.y])
	_check(ours.x > KNEE_CM and ours.y > TURN_DEG, "the ruler reads our bake of the file as different (%.1f cm, %.1f deg)" % [ours.x, ours.y])
	var file := AF.file_frames()
	if file.is_empty():
		print("SKIP the bought file is not on this machine: the file checks did not run")
	else:
		var wa := _off_file(skel, file, af, false, skip)
		var wb := _off_file(skel, file, load("res://assets/anim/baked/mc_Box1_M3_Right_Cross.res"), true, skip)
		var wc := _off_file(skel, file, load("res://assets/anim/af_retarget/mc_Box1_M3_Right_Cross.res"), true, skip)
		print("RETARGETMATCH off the bought FILE (deg): our bake legs %.1f palms %.1f | ActionForge legs %.1f palms %.1f | `afretarget` clip legs %.1f palms %.1f" % [wb["leg"], wb["palm"], wa["leg"], wa["palm"], wc["leg"], wc["palm"]])
		_check(wb["leg"] <= 6.0 and wb["palm"] <= 15.0, "our bake keeps the file's legs and palms (%.1f / %.1f deg)" % [wb["leg"], wb["palm"]])
		_check(wa["leg"] > 15.0 and wa["palm"] > 90.0, "ActionForge's export does not: it re-poses the legs and turns the hands (%.1f / %.1f deg)" % [wa["leg"], wa["palm"]])
		_check(wc["palm"] <= 15.0, "the `afretarget` clip keeps our palms (%.1f deg off the file)" % wc["palm"])
	print("RETARGET_MATCH_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## -> (the worst knee difference in cm, the worst thigh / shin difference in deg) of `path` against ActionForge.
func _read(skel: Skeleton3D, af: Animation, skip: Dictionary, path: String) -> Vector2:
	var clip := load(path) as Animation if ResourceLoader.exists(path) else null
	_check(clip != null, "%s loads" % path.get_file())
	if clip == null:
		return Vector2(99, 99)
	var ta := AF.tracks(af)
	var tc := AF.tracks(clip)
	var leg := KR.leg_len(AF.pts(skel, AF.pose(skel, clip, tc, 0.0, true)))
	var worst := Vector2.ZERO
	for fi in int(round(minf(af.length, clip.length) * 30.0)) + 1:
		if skip.has(fi):
			continue
		var t := fi / 30.0
		var ra := KR.legs(AF.pts(skel, AF.pose(skel, af, ta, t, false)), leg, false)
		var rc := KR.legs(AF.pts(skel, AF.pose(skel, clip, tc, t, true)), leg, false)
		for w in ["lead", "rear"]:
			worst.x = maxf(worst.x, absf(float(ra[w]["valgus"]) - float(rc[w]["valgus"])))
		for nm in LEG:
			worst.y = maxf(worst.y, AF.local_diff(af, ta, clip, tc, nm, t).x)
	return worst


## The worst a clip is off the bought file over the take (AF.off's keys).
func _off_file(skel: Skeleton3D, file: Array, clip: Animation, delta_hips: bool, skip: Dictionary) -> Dictionary:
	var w := {"leg": 0.0, "flex": 0.0, "foot": 0.0, "palm": 0.0}
	var tr := AF.tracks(clip)
	for fi in file.size():
		if skip.has(fi):
			continue
		var o := AF.off(file[fi], AF.our_joints(skel, AF.pose(skel, clip, tr, minf(fi / 30.0, clip.length), delta_hips)))
		for k in o:
			w[k] = maxf(w[k], o[k])
	return w


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
