extends SceneTree
## THE BODY CROSS, AUTHORED OFFLINE (BODYCROSS1 S542, re-authored BODYCROSS2 S545 - ops/research/TASK_BODYCROSS2.md step 3).
## Owner C500 on the S542 film: "the punch in the stomach does not reach opponent and the motion reads more like he is
## trying to touch hime rather than punch him and hurt him": the glove arrived at 0.05 m/s, the contact was the arm's FURTHEST
## key (CROSS_POWER_S439). This bakes ONE take, in its own keys, no runtime layer. take=jab (S556): the lead hand = THE BODY JAB.
##   S542 (kept)  the hips sink DROP_M with both feet where the take has them (a two-bone leg solve per key, knees over
##     the toes), the trunk hinges LEAN_DEG, the face stays up, the punching arm's line is pitched from the shoulder so
##     the glove front is at the other man's rib height on the contact key.
##   S545  THE CONTACT KEY IS EARLIER ON THE ARM'S TRAVEL: the bought cross at SRC_CONTACT_S, where its elbow is 143
##     deg (K52: amateurs 137 +/- 12 at impact; the old contact was 168, near lock-out). The rest of the extension (to the
##     bought take's reach, SRC_REACH_S) happens after it: INTO him (G75: Atha's follow-through 110 mm).
##   S545  THE DRIVE IS FAST AND STILL FAST AT THE CONTACT: the take's clock is re-timed, key by key at 60 a second - the
##     load takes what a body falling needs, the drive speeds up to DRIVE_RATE x the bought take's pace on the contact
##     key, the follow-through slows back to its own pace. Glove on the census body: top and contact speeds are printed
##     (G75: contact 5.9-8.2 m/s of peaks 6.6-12.5, fastest 8-21 ms before the contact; cross band 6-11.5).
##   S545  THE SINK IS A FALL: it speeds up for SINK_FALL of the way at under 1 g and the legs brake the rest (printed).
##   S545  IT LANDS IN THE STOMACH, NOT ON THE BELT: the contact is AIM_UP_M over the census rib point (on the four film
##     bodies that point is 1-11 cm over the hit man's hip joints; B&C's body straight ends 0.30-0.40 m under its head
##     form, ours now 0.32).
##   S545  THE WEIGHT GOES FORWARD FWD_M more (hips; Undisputed's body straight carries 0.055-0.061 m, B&C's plain cross
##     0.04) and THE REAR HEEL COMES UP HEEL_M more, pivoting on the ball of the foot (our captured rear uppercut 6.1 cm;
##     no published figure, K46 line 19). The hip and shoulder turn are the bought cross's own keys: nothing is twisted.
##   S546 BODYCROSS3 (owner C502 on BODYCROSS2's own sheet: "there is no elbow bent"): A BENT ARM YOU CAN SEE, AND A STEP.
##     tools/bodycross3_ruler.gd on the S545 take: the elbow AS SEEN from the side camera is 158.6 deg on the touch
##     (the bought cross flares its elbow out, toward the camera: 142.7 in 3D) and 169 one picture later. Now:
##     - the contact is earlier still on the arm's travel (key=, the bought take's elbow there is printed);
##     - past that key the arm's shoulder-to-wrist span is capped softly (BEND_MAX_DEG at the very most): the rest of
##       the drive is the bought take's own hip and shoulder turn and the weight, the arm never locks out;
##     - the elbow comes DOWN under the punch's line through the drive (_bend), the upper arm rolled so its hinge is
##       square to the bend, the fist kept as the bought take turns it: the bend is in the plane the side camera sees;
##     - the sink is 0.13 m, was 0.18: with the step the 0.18 crouch put the rear knee a hand off the canvas on the
##       women's pair (a kneeling lunge on the sheet); the trunk hinges 5 deg at the waist, was 10 (a bent arm brings
##       the heads 8-10 cm nearer: bend the knees, not the waist); the arm's line from the shoulder is pitched down the rest;
##     - the range the shorter arm leaves is closed by a STEP of the lead foot (STEP_M forward, lifted LIFT_M, planted
##       PLANT_BEFORE_S before the contact; K46: coaching step-in 5-8 cm, lead foot planted at impact) and the hips
##       going with it; he steps back out as he comes up. Feet on the floor, never slid.
## Base: the plain cross the game shows (the ActionForge-legged Punch PRO cross, assets/anim/af_retarget). Saved as
## mc_Box1_M3_Body_Cross.res (FightClips: pro_body_cross; ClipCensus family body_cross: only the pictures use it).
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/pics2d_bodycross_bake.gd -- [dry] [drop=0.13] [lean=5] [rate=1.7] [tc=0.30] [key=0.225] [step=0.06] [bendmax=130]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
var SRC := "res://assets/anim/af_retarget/mc_Box1_M3_Right_Cross.res"
var SRC_NAME := "pro_right_cross"
var OUT := "res://assets/anim/baked/mc_Box1_M3_Body_Cross.res"
var arm := "Right"            # the punching arm; take=jab: the lead hand (BODYJAB1 S556)
const JAB := {"arm": "Left", "SRC": "res://assets/anim/baked/mc_Box1_M3_Left_Jab.res", "SRC_NAME": "pro_left_jab", "OUT": "res://assets/anim/baked/mc_Box1_M3_Body_Jab.res",
	"SRC_LOAD_S": 0.267, "SRC_REACH_S": 0.483, "HEEL_M": 0.0, "FWD_M": 0.035}   # the floats: src_load_s= src_reach_s= heel_m= fwd_m= on the command line
const KNEE_REF := ["pro_body_shot", 0.45]   # a take and a time with both knees well bent: the knees' hinge axes are read there
var SRC_LOAD_S := 0.1333    # the bought take's load, before its drive
var SRC_REACH_S := 0.30     # ... its furthest reach (the old contact)
const HZ := 60.0
const HOME_RATE := 1.0        # after the follow-through the take plays at its own pace
const SINK_FALL := 0.567      # the share of the way down the hips speed up; the legs brake the rest
const HOLD_S := 0.07
const OUT_S := 0.38
const AIM_UP_M := 0.06        # the contact this far over the census rib point (the game's body target sits at the belt line: see docs/BODYCROSS2_RESULT.md)
var FWD_M := 0.035
var HEEL_M := 0.03
const LEAN_SHARE := {"Hips": 0.4, "Spine": 0.3, "Chest": 0.3}
const FACE_BACK := {"Neck": -0.4, "Head": -0.4}
const ARM_MAX_DEG := 30.0
const LIFT_M := 0.03          # the stepping foot's lift
const PLANT_BEFORE_S := 0.067 # the lead foot is down this long before the contact
const STEP_FROM_S := 0.033

var skel: Skeleton3D
var ap: AnimationPlayer
var fwd := Vector3.BACK      # skeleton space
var side := Vector3.RIGHT
var front := 0.15
var scale := 1.0
var drop_m := 0.13
var lean_deg := 5.0
var rate := 1.7              # the drive's pace on the contact key, against the bought take's
var tc := 0.30               # the contact, seconds into the new take
var SRC_CONTACT_S := 0.24    # the bought take's time that becomes the contact (its elbow 143 deg there; key=)
var tl := 0.0                # the load's end
var tf := 0.0                # the follow-through's length
var hinge := {}              # "Left" / "Right" -> the knee's hinge axis in the thigh bone's own frame
var arm_hinge := Vector3.ZERO  # the elbow's hinge axis in the upper arm's own frame
var step_m := 0.06           # BODYCROSS3: the lead foot's step in
var bend_from := 128.0       # the elbow angle (3D) on the contact key: past it the arm's span is capped
var bend_max := 130.0        # ... never past this
var now_t := 0.0             # the new take's time of the key being posed (the step and the bend read it)


func _arg(key: String, def: float) -> float:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return float(str(a).substr(key.length() + 1))
	return def


func _initialize() -> void:
	var dry := OS.get_cmdline_user_args().has("dry")
	drop_m = _arg("drop", drop_m)
	lean_deg = _arg("lean", lean_deg)
	rate = _arg("rate", rate)
	tc = _arg("tc", tc)
	for k in (JAB if OS.get_cmdline_user_args().has("take=jab") else {}):   # THE BODY JAB: the jab the game shows, the lead hand, no rear heel (docs/BODYJAB1_RESULT.md)
		set(str(k), _arg(str(k).to_lower(), JAB[k]) if JAB[k] is float else JAB[k])
	SRC_CONTACT_S = _arg("key", 0.333 if arm == "Left" else 0.225)
	step_m = _arg("step", step_m)
	bend_max = _arg("bendmax", bend_max)
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	scale = (bx["node"] as Node3D).scale.x
	front = float(bx.get("front", 0.15))
	Orbit.strip_modifiers(skel)
	var inv := skel.global_transform.basis.orthonormalized().inverse()
	fwd = (inv * (bx["node"] as Node3D).global_transform.basis.z).normalized()
	side = Vector3.UP.cross(fwd).normalized()
	# the other man's rib height (the census's rule), in the thrower's skeleton space
	var d: Dictionary = st.boxers[1]
	var ds: Skeleton3D = d["skel"]
	Orbit.strip_modifiers(ds)
	var dap: AnimationPlayer = d["ap"]
	dap.play(BeatClips.first(BeatClips.GUARD, dap.has_animation))
	dap.seek(0.0, true)
	var ribs_world: float = (ds.global_transform * ds.get_bone_global_pose(ds.find_bone("Chest")).origin).y - 0.14 * float((d["node"] as Node3D).scale.x)
	var ribs_y: float = (ribs_world - skel.global_transform.origin.y) / skel.global_transform.basis.get_scale().y
	_hinges()
	ap.play(SRC_NAME)
	ap.seek(SRC_CONTACT_S, true)
	bend_from = _ang(_g(arm + "UpperArm").origin, _g(arm + "LowerArm").origin, _g(arm + "Hand").origin)
	print("BODYCROSS_BAKE the bought take's elbow on the contact key %.3f s: %.1f deg in 3D, %.1f as the side camera sees it" % [SRC_CONTACT_S, bend_from, _seen(_g(arm + "UpperArm").origin, _g(arm + "LowerArm").origin, _g(arm + "Hand").origin)])
	var src := load(SRC) as Animation
	var out := src.duplicate(true) as Animation
	# the clock: the load's length is what leaves the contact on tc with the drive ending at 'rate'
	var lo_t := 0.02
	var hi_t := tc - 0.02
	for it in 40:
		tl = (lo_t + hi_t) * 0.5
		if tl + 2.0 * (SRC_CONTACT_S - SRC_LOAD_S) / (SRC_LOAD_S / tl + rate) > tc:
			hi_t = tl
		else:
			lo_t = tl
	tf = 2.0 * (SRC_REACH_S - SRC_CONTACT_S) / (rate + HOME_RATE)
	out.length = snappedf(tc + tf + (src.length - SRC_REACH_S), 1.0 / HZ)
	# the arm's pitch on the contact key, solved so the glove front is at rib height there
	var lo := -ARM_MAX_DEG
	var hi := ARM_MAX_DEG
	for it in 24:
		var mid := (lo + hi) * 0.5
		now_t = tc
		_edit(SRC_CONTACT_S, 1.0, mid, FWD_M * _drive(tc), HEEL_M * _drive(tc))
		if _glove(arm).y > ribs_y + AIM_UP_M:
			lo = mid
		else:
			hi = mid
	var arm_deg := (lo + hi) * 0.5
	print("BODYCROSS_BAKE drop %.3f m, lean %.1f deg, arm pitched down %.1f deg (ribs %.3f m); load to %.3f s (%.2f x slower), contact %.3f s (the bought key %.3f), follow-through %.3f s, length %.3f -> %.3f s" % [
		drop_m, lean_deg, arm_deg, ribs_y, tl, tl / SRC_LOAD_S, tc, SRC_CONTACT_S, tf, src.length, out.length])
	print("BODYCROSS_BAKE the sink: fastest fall %.2f m/s2 (1 g = 9.81), the legs brake at %.2f m/s2" % [2.0 * drop_m / (SINK_FALL * tc * tc), 2.0 * drop_m / ((1.0 - SINK_FALL) * tc * tc)])
	var bones: Array = []
	var pos_track := -1
	for t in out.get_track_count():
		if out.track_get_type(t) == Animation.TYPE_POSITION_3D:
			pos_track = t
		bones.append(str(out.track_get_path(t)))
		while out.track_get_key_count(t) > 0:
			out.track_remove_key(t, 0)
	var hips := skel.find_bone("Hips")
	var foot_err := 0.0
	var rows: Array = []
	var n := int(round(out.length * HZ))
	var prev := Vector3.ZERO
	var ci := int(round(tc * HZ))
	var top := 0.0
	var top_k := 0
	var at := 0.0
	for k in n + 1:
		var to := float(k) / HZ
		var ts := minf(_src(to), src.length)
		var w := _env(to)
		ap.play(SRC_NAME)
		ap.seek(ts, true)
		var before := _read()
		now_t = to
		var err := _edit(ts, w, arm_deg, FWD_M * _drive(to), HEEL_M * _drive(to))
		foot_err = maxf(foot_err, err)
		for t in out.get_track_count():
			var b := skel.find_bone(str(bones[t]))
			if t == pos_track:
				out.position_track_insert_key(t, to, skel.get_bone_pose_position(hips) - skel.get_bone_rest(hips).origin)
			else:
				out.rotation_track_insert_key(t, to, skel.get_bone_pose_rotation(b))
		var after := _read()
		var sp: float = 0.0 if k == 0 else ((after["glove"] as Vector3) - prev).length() * HZ
		prev = after["glove"]
		if k <= ci + 2 and sp > top:
			top = sp
			top_k = k
		if k == ci:
			at = sp
		rows.append({"t": snappedf(to, 0.001), "src": snappedf(ts, 0.001), "w": snappedf(w, 0.01), "speed": snappedf(sp, 0.01), "glove_fwd": snappedf((after["glove"] as Vector3).dot(fwd), 0.001),
			"glove_y": [snappedf(before["glove"].y, 0.001), snappedf(after["glove"].y, 0.001)],
			"hips_y": [snappedf(before["hips"].y, 0.001), snappedf(after["hips"].y, 0.001)], "hips_fwd": snappedf((after["hips"] as Vector3).dot(fwd), 0.001), "head_y": snappedf(after["head"].y, 0.001),
			"heel_y": snappedf(_g("RightFoot").origin.y, 0.001), "knee_l": snappedf(after["kl"], 0.1), "knee_r": snappedf(after["kr"], 0.1),
			"lean": snappedf(after["lean"], 0.1), "lead_glove_to_head": snappedf(after["lead"], 0.001), "elbow": snappedf(after["elbow"], 0.1), "elbow_seen": snappedf(after["seen"], 0.1),
			"lead_foot": [snappedf(_g("LeftFoot").origin.dot(fwd), 0.001), snappedf(_g("LeftFoot").origin.y, 0.001)], "turn": [snappedf(after["hipturn"], 0.1), snappedf(after["shturn"], 0.1)]})
	for r in rows:
		print("BODYCROSS_KEY %s" % JSON.stringify(r))
	var c: Dictionary = rows[ci]
	var deep: Dictionary = rows[mini(int(round((tc + tf) * HZ)) + 1, n)]
	print("BODYCROSS_BAKE on the census body: glove %.2f m/s on the contact key (%d %% of its top %.2f m/s, %d ms before); elbow %.1f deg there; the glove goes %.3f m further after it (elbow %.1f deg); glove %.3f m up against ribs %.3f" % [
		at, int(round(100.0 * at / maxf(top, 0.01))), top, int(round(1000.0 * (ci - top_k) / HZ)), c["elbow"], float(deep["glove_fwd"]) - float(c["glove_fwd"]), deep["elbow"], c["glove_y"][1], ribs_y])
	print("BODYCROSS_BAKE feet off their recorded spots by at most %.4f m (the rear foot pivots on its ball: its ankle is meant to rise)" % foot_err)
	if not dry:
		out.set_meta("bodycross3", {"step_m": step_m, "lift_m": LIFT_M, "bend_from_deg": snappedf(bend_from, 0.1), "bend_max_deg": bend_max})
		out.set_meta("bodycross2", {"from": SRC, "drop_m": drop_m, "lean_deg": lean_deg, "arm_deg": snappedf(arm_deg, 0.1), "contact_s": snappedf(tc, 0.001),
			"src_contact_s": SRC_CONTACT_S, "drive_rate": rate, "reach_s": snappedf(tc + tf, 0.001), "fwd_m": FWD_M, "heel_m": HEEL_M, "aim_up_m": AIM_UP_M})
		var e := ResourceSaver.save(out, OUT)
		print("BODYCROSS_BAKE saved %s (err %d)" % [OUT, e])
	print("BODYCROSS_BAKE DONE")
	quit(0)


## The bought take's time at new-take time t: the load slowed, the drive speeding up to 'rate' on the contact, the
## follow-through slowing to the take's own pace, the rest as recorded.
func _src(t: float) -> float:
	var r0 := SRC_LOAD_S / tl
	if t <= tl:
		return r0 * t
	if t <= tc:
		var u := t - tl
		return SRC_LOAD_S + r0 * u + (rate - r0) * u * u / (2.0 * (tc - tl))
	if t <= tc + tf:
		var v := t - tc
		return SRC_CONTACT_S + rate * v + (HOME_RATE - rate) * v * v / (2.0 * tf)
	return SRC_REACH_S + (t - tc - tf) * HOME_RATE


## How much of the level change is on at new-take time t: a fall to the contact (speeding up, then braked), held
## through the follow-through, eased out.
func _env(t: float) -> float:
	if t <= tc:
		var t1 := SINK_FALL * tc
		return t * t / (t1 * tc) if t <= t1 else 1.0 - (tc - t) * (tc - t) / ((tc - t1) * tc)
	if t <= tc + tf + HOLD_S:
		return 1.0
	return 1.0 - _smooth((t - tc - tf - HOLD_S) / OUT_S)


## How much of the drive's own additions (the weight forward, the rear heel) is on: in with the drive, whole at the
## end of the follow-through, out with the level change.
func _drive(t: float) -> float:
	var from := tl * 0.4
	if t <= tc + tf:
		return _smooth((t - from) / (tc + tf - from))
	if t <= tc + tf + HOLD_S:
		return 1.0
	return 1.0 - _smooth((t - tc - tf - HOLD_S) / OUT_S)


static func _smooth(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return x * x * (3.0 - 2.0 * x)


func _g(bone: String) -> Transform3D:
	return skel.get_bone_global_pose(skel.find_bone(bone))


## Turns a bone about its own joint by R (skeleton space); its children follow.
func _turn(bone: String, r: Basis) -> void:
	var b := skel.find_bone(bone)
	var g := skel.get_bone_global_pose(b)
	g.basis = r * g.basis
	skel.set_bone_global_pose(b, g)


func _glove(s: String) -> Vector3:
	var hand: Vector3 = _g(s + "Hand").origin
	var axis: Vector3 = (_g(s + "MiddleProximal").origin - hand).normalized()
	var fore: Vector3 = (hand - _g(s + "LowerArm").origin).normalized()
	if PR.STRAIGHT > 0.0 and axis.angle_to(fore) > 1e-3:
		axis = axis.slerp(fore, PR.STRAIGHT).normalized()
	return hand + axis * front * scale / skel.global_transform.basis.get_scale().y


static func _ang(a: Vector3, k: Vector3, b: Vector3) -> float:
	return rad_to_deg((a - k).angle_to(b - k))


func _read() -> Dictionary:
	var hips: Vector3 = _g("Hips").origin
	var head: Vector3 = _g("Head").origin
	var gl := _glove(arm)
	return {"glove": gl, "hips": hips, "head": head, "lean": rad_to_deg((head - hips).angle_to(Vector3.UP)), "reach": (gl - hips).dot(fwd),
		"kl": _ang(_g("LeftUpperLeg").origin, _g("LeftLowerLeg").origin, _g("LeftFoot").origin),
		"kr": _ang(_g("RightUpperLeg").origin, _g("RightLowerLeg").origin, _g("RightFoot").origin),
		"lead": _glove("Left" if arm == "Right" else "Right").distance_to(head), "elbow": _ang(_g(arm + "UpperArm").origin, _g(arm + "LowerArm").origin, _g(arm + "Hand").origin),
		"seen": _seen(_g(arm + "UpperArm").origin, _g(arm + "LowerArm").origin, _g(arm + "Hand").origin),
		"hipturn": _yaw(_g("RightUpperLeg").origin - _g("LeftUpperLeg").origin), "shturn": _yaw(_g("RightUpperArm").origin - _g("LeftUpperArm").origin)}


## The angle at k as the side camera sees it (the part along its line of sight, the take's side axis, dropped).
func _seen(a: Vector3, k: Vector3, b: Vector3) -> float:
	var u := a - k
	var v := b - k
	return rad_to_deg((u - side * u.dot(side)).angle_to(v - side * v.dot(side)))


## How far a left-to-right line is turned from square to the punch's line (deg).
func _yaw(line: Vector3) -> float:
	return rad_to_deg(atan2(line.dot(fwd), line.dot(side)))


## BODYCROSS3: how much of the elbow-down bend is on at new-take time t: in through the drive, whole from just before
## the contact to the end of the hold, out as he comes up.
func _bend(t: float) -> float:
	if t <= tc + tf + HOLD_S:
		return _smooth((t - tl * 0.5) / maxf(tc - 0.02 - tl * 0.5, 0.01))
	return 1.0 - _smooth((t - tc - tf - HOLD_S) / OUT_S)


## BODYCROSS3: the lead foot's step at new-take time t: [forward m, up m]. In during the load, planted PLANT_BEFORE_S
## before the contact, there through the drive and the hold, back out as he comes up.
func _step(t: float) -> Array:
	var land := tc - PLANT_BEFORE_S
	var x := 0.0
	var going := 0.0
	if t <= land:
		going = clampf((t - STEP_FROM_S) / (land - STEP_FROM_S), 0.0, 1.0)
		x = _smooth(going)
	elif t <= tc + tf + HOLD_S:
		x = 1.0
	else:
		going = clampf((t - tc - tf - HOLD_S) / OUT_S, 0.0, 1.0)
		x = 1.0 - _smooth(going)
	return [step_m * x, LIFT_M * sin(PI * going) if going > 0.0 and going < 1.0 else 0.0]


## BODYCROSS3: the punching arm re-solved. Its shoulder-to-wrist span is the bought take's up to the span of an elbow
## at bend_from deg, capped softly after it (bend_max at the most); the elbow goes under the shoulder-wrist line by
## weight bend, the upper arm rolled so the elbow's hinge is square to the bend, the fist kept as the take turns it.
func _arm(bend: float) -> void:
	var s: Vector3 = _g(arm + "UpperArm").origin
	var e0: Vector3 = _g(arm + "LowerArm").origin
	var w0: Vector3 = _g(arm + "Hand").origin
	var hand: Basis = _g(arm + "Hand").basis
	var l1 := (e0 - s).length()
	var l2 := (w0 - e0).length()
	var d := (w0 - s).length()
	var dc := sqrt(l1 * l1 + l2 * l2 - 2.0 * l1 * l2 * cos(deg_to_rad(bend_from)))
	var dm := sqrt(l1 * l1 + l2 * l2 - 2.0 * l1 * l2 * cos(deg_to_rad(bend_max)))
	var d1 := d if d <= dc else dc + (dm - dc) * (1.0 - exp(-(d - dc) / maxf(dm - dc, 0.001)))
	if bend <= 0.0 and d1 >= d - 1e-5:
		return
	var u := (w0 - s) / d
	var own := (e0 - s) - u * (e0 - s).dot(u)
	var down := (Vector3.DOWN - u * Vector3.DOWN.dot(u)).normalized()
	var pole := down if own.length() < 0.01 else own.normalized().slerp(down, clampf(bend, 0.0, 1.0)).normalized()
	var a := (l1 * l1 - l2 * l2 + d1 * d1) / (2.0 * d1)
	var e1 := s + u * a + pole * sqrt(maxf(0.0, l1 * l1 - a * a))
	var w1 := s + u * d1
	_turn(arm + "UpperArm", Basis(Quaternion((e0 - s).normalized(), (e1 - s).normalized())))
	var axis := (e1 - s).normalized()
	var want := axis.cross(w1 - e1)
	if want.length() > 0.02:
		var have: Vector3 = _g(arm + "UpperArm").basis.orthonormalized() * arm_hinge
		have = (have - axis * have.dot(axis)).normalized()
		_turn(arm + "UpperArm", Basis(axis, have.signed_angle_to(want.normalized(), axis) * clampf(bend, 0.0, 1.0)))
	var e2: Vector3 = _g(arm + "LowerArm").origin
	var f0: Vector3 = (_g(arm + "Hand").origin - e2).normalized()
	_turn(arm + "LowerArm", Basis(Quaternion(f0, (w1 - e2).normalized())))
	var hi := skel.find_bone(arm + "Hand")
	var hg := skel.get_bone_global_pose(hi)
	hg.basis = Basis(Quaternion((w0 - e0).normalized(), (w1 - e2).normalized())) * hand
	skel.set_bone_global_pose(hi, hg)


## Each knee's hinge axis in its thigh's own frame, read where the knees are well bent.
func _hinges() -> void:
	ap.play(str(KNEE_REF[0]))
	ap.seek(float(KNEE_REF[1]), true)
	for s in ["Left", "Right"]:
		var u := _g(s + "UpperLeg")
		var k: Vector3 = _g(s + "LowerLeg").origin
		var n: Vector3 = (k - u.origin).cross(_g(s + "Foot").origin - k).normalized()
		hinge[s] = u.basis.orthonormalized().inverse() * n
		print("BODYCROSS_BAKE %s knee hinge read at %.0f deg" % [s, _ang(u.origin, k, _g(s + "Foot").origin)])
	ap.play(SRC_NAME)
	ap.seek(0.0, true)
	var ua := _g(arm + "UpperArm")
	var el: Vector3 = _g(arm + "LowerArm").origin
	arm_hinge = ua.basis.orthonormalized().inverse() * (el - ua.origin).cross(_g(arm + "Hand").origin - el).normalized()
	print("BODYCROSS_BAKE elbow hinge read at %.0f deg (the guard)" % _ang(ua.origin, el, _g(arm + "Hand").origin))


## Poses the source take at ts, then puts the level change on at weight w, the hips fwd_m forward and the rear heel
## heel_m up. Leaves the skeleton posed (read it after). Returns how far the lead foot ended from where the take has it.
func _edit(ts: float, w: float, arm_deg: float, fwd_m: float = 0.0, heel_m: float = 0.0) -> float:
	ap.play(SRC_NAME)
	ap.seek(ts, true)
	var feet := {}
	var toes := {}
	var knees := {}
	for s in ["Left", "Right"]:
		feet[s] = _g(s + "Foot")
		toes[s] = _g(s + "Toes")
		knees[s] = [_g(s + "UpperLeg").origin, _g(s + "LowerLeg").origin]
	var stp := _step(now_t)
	var bend := _bend(now_t)
	fwd_m += step_m * _drive(now_t)
	if float(stp[0]) > 0.0 or float(stp[1]) > 0.0:   # the lead foot where the step has it
		var mv: Vector3 = fwd * float(stp[0]) + Vector3.UP * float(stp[1])
		feet["Left"] = Transform3D((feet["Left"] as Transform3D).basis, (feet["Left"] as Transform3D).origin + mv)
		toes["Left"] = Transform3D((toes["Left"] as Transform3D).basis, (toes["Left"] as Transform3D).origin + mv)
	if w <= 0.0 and fwd_m <= 0.0 and heel_m <= 0.0 and bend <= 0.0:
		return 0.0
	# 1. the hips sink and go forward
	var hips := skel.find_bone("Hips")
	var par := skel.get_bone_parent(hips)
	var pb: Basis = skel.get_bone_global_pose(par).basis.orthonormalized() if par >= 0 else Basis.IDENTITY
	skel.set_bone_pose_position(hips, skel.get_bone_pose_position(hips) + pb.inverse() * (Vector3.DOWN * drop_m * w + fwd * fwd_m))
	# 2. the trunk hinges forward, the face stays up
	for b in LEAN_SHARE:
		_turn(str(b), Basis(side, deg_to_rad(lean_deg * w * float(LEAN_SHARE[b]))))
	for b in FACE_BACK:
		_turn(str(b), Basis(side, deg_to_rad(lean_deg * w * float(FACE_BACK[b]))))
	# 3. the punching arm's line down from the shoulder
	var sh: Vector3 = _g(arm + "UpperArm").origin
	var dir: Vector3 = (_glove(arm) - sh) * Vector3(1, 0, 1)
	if dir.length() > 0.05:
		_turn(arm + "UpperArm", Basis(dir.normalized().cross(Vector3.UP).normalized(), -deg_to_rad(arm_deg * w)))
	_arm(bend)
	# 4. the rear heel: the foot pivots on its ball (the toes' joint stays on its spot, the toes stay flat)
	var rear: Transform3D = feet["Right"]
	var ball: Vector3 = (toes["Right"] as Transform3D).origin
	if heel_m > 0.0:
		var back: Vector3 = rear.origin - ball
		var flat := (back * Vector3(1, 0, 1)).length()
		if flat > 0.03:
			var ax := (back * Vector3(1, 0, 1)).normalized().cross(Vector3.UP).normalized()
			var rot := Basis(ax, asin(clampf(heel_m / flat, 0.0, 0.6)))
			if (rot * back).y < back.y:
				rot = Basis(ax, -asin(clampf(heel_m / flat, 0.0, 0.6)))
			rear = Transform3D(rot * rear.basis, ball + rot * back)
	# 5. the legs: the lead foot back where the take has it, the rear one on its ball
	var err := _leg("Left", feet["Left"], (toes["Left"] as Transform3D).origin, knees["Left"], w)
	_leg("Right", rear, ball, knees["Right"], w)
	if heel_m > 0.0:
		var ti := skel.find_bone("RightToes")
		var tg := skel.get_bone_global_pose(ti)
		tg.basis = (toes["Right"] as Transform3D).basis
		skel.set_bone_global_pose(ti, tg)
	return err


func _leg(s: String, foot: Transform3D, toe: Vector3, was: Array, w: float) -> float:
	var ui := skel.find_bone(s + "UpperLeg")
	var li := skel.find_bone(s + "LowerLeg")
	var fi := skel.find_bone(s + "Foot")
	var h: Vector3 = skel.get_bone_global_pose(ui).origin
	var k0: Vector3 = skel.get_bone_global_pose(li).origin
	var a0: Vector3 = skel.get_bone_global_pose(fi).origin
	var t: Vector3 = foot.origin
	var l1 := (k0 - h).length()
	var l2 := (a0 - k0).length()
	var d := clampf((t - h).length(), 0.05, (l1 + l2) * 0.9995)
	var dir := (t - h).normalized()
	# the knee's side of the hip-ankle line: the take's own, turned over the toes as the sink comes on
	var over: Vector3 = ((toe - foot.origin) * Vector3(1, 0, 1)).normalized()
	var own: Vector3 = (was[1] as Vector3) - (was[0] as Vector3)
	var line: Vector3 = (foot.origin - (was[0] as Vector3)).normalized()
	own -= line * own.dot(line)
	var pole: Vector3 = over if own.length() < 0.03 else own.normalized().lerp(over, w).normalized()
	pole = (pole - dir * pole.dot(dir)).normalized()
	var a := (l1 * l1 - l2 * l2 + d * d) / (2.0 * d)
	var k1 := h + dir * a + pole * sqrt(maxf(0.0, l1 * l1 - a * a))
	_turn(s + "UpperLeg", Basis(Quaternion((k0 - h).normalized(), (k1 - h).normalized())))
	# the thigh's twist: the knee's hinge square to the plane the leg bends in
	var axis := (k1 - h).normalized()
	var want := axis.cross(t - k1)
	if want.length() > 0.02:
		var have: Vector3 = skel.get_bone_global_pose(ui).basis.orthonormalized() * (hinge[s] as Vector3)
		have = (have - axis * have.dot(axis)).normalized()
		want = want.normalized()
		_turn(s + "UpperLeg", Basis(axis, have.signed_angle_to(want, axis)))
	k1 = skel.get_bone_global_pose(li).origin
	_turn(s + "LowerLeg", Basis(Quaternion((skel.get_bone_global_pose(fi).origin - k1).normalized(), (t - k1).normalized())))
	var g := skel.get_bone_global_pose(fi)
	g.basis = foot.basis
	skel.set_bone_global_pose(fi, g)
	return skel.get_bone_global_pose(fi).origin.distance_to(t)
