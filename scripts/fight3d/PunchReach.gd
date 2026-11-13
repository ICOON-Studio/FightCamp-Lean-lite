extends SkeletonModifier3D
## S302 (operator on the S301 film: "the punches feel like they have no power and target enemys hand rather than their
## head"). The Pro punch clips were authored against a bag at their own range; at the fight's gap their gloves stop short
## and meet the other boxer's raised guard (tools/punch_reach.gd). A LANDED punch is armed here: around its contact the
## punching arm is re-solved as a two-bone chain whose glove front lands on the target (her face, her ribs for a body shot),
## weight easing in before contact and out after it. What the arm cannot reach, the chest leans in (a boxer turns her
## shoulder through the punch). The hand keeps its global rotation, so the glove meets the target the way the clip threw it.
## Blocked and missed punches are never armed: they stay on the gloves. Runs after JoinSmoother, before ElbowClear.
##   setup(skel, ap)  arm(clip, hand_bone, contact_s, target: Callable -> world Vector3, glove_front_m)  disarm()

## Clip seconds (the clip's own time, so it follows any playback speed): weight 0 -> 1 over IN_S before contact, held
## HOLD_S, 1 -> 0 over OUT_S.
const IN_S := 0.14
const HOLD_S := 0.05
const OUT_S := 0.16
## The most the chest may lean toward the target (radians) to cover what the arm cannot.
const LEAN_MAX := 0.30
## When the next clip cuts in (a combo, a hit), the reach and the carry let go over this long instead of at once (S302
## joins report: an instant release jolted the hook hand 12 m/s in one frame; JoinSmoother runs before this modifier).
const FADE_S := 0.20   # S386: 0.12 (4 frames) still read as a snap off the target
## The glove's long axis leans this share from the hand onto the forearm (Gloves.WRIST_STRAIGHT; `-- bentwrist` = 0 there).
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
## Solves per frame for the full-weight wrist (the glove axis moves with the forearm); `-- onepass` = the S302 single step.
## POWER1 step 2: 4 -> 8. With 4 the glove front sat 1.5-2 cm off its aim (hit_frame_test, pro_left_jab_b: 0.015 m off the
## face at the hit, the carry 2 cm past its aim); 10 passes put it 0.001 m off. A pass is one two-bone solve.
static var SOLVE_PASSES: int = 1 if OS.get_cmdline_user_args().has("onepass") else 8
static var STRAIGHT: float = 0.0 if OS.get_cmdline_user_args().has("bentwrist") else Gloves.WRIST_STRAIGHT
## POWER1 step 2 (owner S439: "the punches do not feellike the y have power"; CROSS_POWER_S439.md: the glove reached the
## face at 0.3-0.8 m/s after peaking at 5-7 m/s, then rested on it). The weight still eases in, but what it eases onto is a
## point DRIVING into the face: before contact it sits behind the face on the glove's line, closing at the glove's own top
## speed (the clip's, read frame by frame since arming, DRIVE_V clamps it), never behind the clip's own glove; at contact it
## is the face; after it, on a LANDED punch, it carries THROUGH_M on along the same line (eased out, from that speed) and
## stays there until the weight lets the glove go back with the clip. A blocked punch arrives the same way and stops on the
## block. `-- nodrive` = the control arm (the S302 reach: the glove eased onto the face and rested there).
const THROUGH_M := 0.08            # real crosses carry ~11 cm past contact (G75); a shipped game 0.08-0.5 s of travel
const DRIVE_V := Vector2(2.5, 9.0) # m/s, clip time
## Review round 1 (S442 blind review: "a landed jab's glove pops right after contact", 8-17 cm in two frames in the played
## fight; tests/hit_carry_test.gd with the whole stage running). The carry ran over 2 * THROUGH_M / v of clip time - 14-32
## ms, one frame at the game's pace once the hit-stop let go - and then the release blended toward the clip's glove, which
## is still travelling out there, so it went out, back and out again. Now the carry eases out over CARRY_S of clip time
## (its first frame at most ~4 cm at 1.7x), the reach holds the glove on it to the end (weight 1 until contact + CARRY_S),
## and on the way back the glove never goes further along the punch line than it already is.
const CARRY_S := 0.10
const RELEASE_M := Vector2(0.06, 0.30)   # clip glove this far from the carry: the reach holds fully / lets go by time
const LATCH_S := 0.011            # the hit frame: HitImpact.hit leaves the clip up to 0.01 s short of its contact
const PEAK_DT_MAX := 0.04          # clip seconds: a longer step between two reads is a seek (the hit), not the glove's speed
static var DRIVE: bool = not OS.get_cmdline_user_args().has("nodrive")
## Step 3 review round 2 (ReachDrive): the drive's end speed (clip m/s, 0 = none) and time, from PunchPace.arm [clip, v, t].
const ReachDrive := preload("res://scripts/fight3d/ReachDrive.gd")
const ReachLimit := preload("res://scripts/fight3d/ReachLimit.gd")   # POWER1 step 4: the 0.30 m cap, the uppercut's elbow
var drive_for := []
var drive_v := 0.0
var drive_t := 0.0
var _path := {}
var _shown_t := Vector2(-1.0, -1.0)   # the clip times of _shown_prev, _shown_cur

var ap: AnimationPlayer
var _arms := {}          # "LeftHand" -> [upper, lower, hand]
var _chest := -1
var _clip := ""
var _hand := ""
var _contact := 0.0
var _target: Callable
var _front := 0.15
var last_weight := 0.0   # for probes
var lunge_m := 0.0       # how far her body carries in at full weight (FightStage reads lunge())
var _w_now := 0.0
var _armed_t := 0.0      # S386: seconds since arm(): a punch started mid-clip (BeatFire's skip) eases its reach in
var _fades := {}         # hand -> {w, target, front, lunge, height_only, aim_y}: a reach whose clip was cut off, falling to 0 over FADE_S
## HEADAIM2: height-only mode for un-landed head punches. The glove front's Y is replaced by the latched target Y;
## depth and sideways are untouched (a blocked glove must not be carried onto the face).
## HEADAIM2B: each reach carries its own mode (stored in _fades at disarm, passed into _reach as arguments).
var _height_only := false
var _aim_target_y := 0.0   # latched at arming time (a slipping head ducks; the fist goes where the head was)
## POWER1 step 2 (the drive): how far a landed glove carries through, the clip glove's top speed so far (clip time), the
## last clip glove read (skeleton space) and its clip time, the line it arrives on and the face point it met (world, both
## latched on the contact frame), and the point aimed at this frame (world; settle() and a fade keep it).
var _thru := 0.0
var _peak_v := 0.0
var _prev_g := Vector3.INF
var _prev_t := -1.0
var _hit_w := Vector3.INF
var hit_g := Vector3.INF   # POWER1 step 4: the clip's own glove (world) on the hit frame, before the reach moved it
var hit_face := Vector3.INF   # ... and the point on her it latched (face, chin, ribs): _hit_w is re-based on the glove
var hit_s := Vector3.INF   # ... and her shoulder then (world)
var _dir_w := Vector3.ZERO
var _aim_w := Vector3.INF
var _shown_prev := Vector3.INF   # the glove front as shown last frame (world): the hit's line is the way it arrived
var _shown_cur := Vector3.INF
var _shown_f := -1
var _hit_f := -1
var _t_now := 0.0
var _real_c := 0.0               # S445 fix: real seconds since the contact (the hit-stop freezes clip time, not the carry)
var _key := 0                    # the drawn frame this solve belongs to (reach_at: each call is a frame of its own)
var _probe_n := 0
var _dir_pending := false
var _back_along := INF           # on the way back: how far along the punch line the glove was last frame (never further)
var _last_at := Vector3.INF      # the point and weight _apply aimed the driven glove at this frame (settle() keeps them)
var _last_w := 0.0
var _poles := {}                 # hand -> the elbow's last clear side (skeleton space)
const POLE_M := 0.06


func setup(skel: Skeleton3D, player: AnimationPlayer) -> bool:
	ap = player
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand"),
			skel.find_bone(side + "MiddleProximal")]
		if ids.has(-1):
			return false
		_arms[side + "Hand"] = ids
	_chest = skel.find_bone("Chest")
	return true


## `through_m` > 0 on a LANDED punch (FightStage.land: THROUGH_M): the glove carries on that far past the face.
func arm(clip: String, hand_bone: String, contact_s: float, target: Callable, glove_front_m: float, through_m: float = 0.0) -> void:
	disarm()   # S386: the punch on screen fades out (arming over it dropped its reach in one frame)
	_clip = clip
	_armed_t = 0.0
	_hand = hand_bone
	_contact = contact_s
	_target = target
	_front = glove_front_m
	_height_only = false   # HEADAIM2: full aim by default
	_thru = through_m
	_peak_v = 0.0
	_prev_g = Vector3.INF
	_prev_t = -1.0
	_hit_w = Vector3.INF
	hit_face = Vector3.INF
	_aim_w = Vector3.INF
	_shown_prev = Vector3.INF
	_dir_pending = false
	_back_along = INF
	_last_w = 0.0
	_shown_cur = Vector3.INF
	_hit_f = -1; _real_c = 0.0
	_path = {}
	drive_v = float(drive_for[1]) if drive_for.size() == 3 and str(drive_for[0]) == clip else 0.0
	drive_t = float(drive_for[2]) if drive_v > 0.0 else 0.0


## HEADAIM2: height-only mode for un-landed head punches. The glove front's Y is replaced by the latched target Y;
## depth and sideways are untouched. The target height is LATCHED at arming (a slipping head ducks; the fist must
## go where the head was, not chase it down).
func aim_height(clip: String, hand_bone: String, contact_s: float, target_y_world: float, glove_front_m: float) -> void:
	disarm()
	_clip = clip
	_armed_t = 0.0
	_hand = hand_bone
	_contact = contact_s
	_front = glove_front_m
	_height_only = true
	_aim_target_y = target_y_world
	_target = Callable()   # not used in height-only mode
	_aim_w = Vector3.INF


func disarm() -> void:
	if _clip != "" and _w_now > 0.0:
		# POWER1: a driven reach fades from the point it last aimed at (where the glove is), not from the bare face.
		var tgt: Callable = _target
		var w0 := _w_now
		if _aim_w.is_finite() and not _height_only:
			# Review round 1: from where the glove was last put (on the way back that is not the carry's end at _w_now).
			var at := _last_at if _last_w > 0.0 else _aim_w
			w0 = _last_w if _last_w > 0.0 else _w_now
			tgt = func() -> Vector3: return at
		_fades[_hand] = {"w": w0, "w0": w0, "t": 0.0, "target": tgt, "front": _front, "lunge": lunge_m,
			"height_only": _height_only, "aim_y": _aim_target_y}
	_clip = ""
	_w_now = 0.0
	lunge_m = 0.0


## The body's carry toward the target now, metres (0 when nothing is armed or fading).
func lunge() -> float:
	var out := 0.0
	for f in _fades.values():
		out = maxf(out, float(f["lunge"]) * float(f["w"]))
	if _clip == "" or lunge_m <= 0.0 or ap == null or str(ap.assigned_animation) != _clip:
		return out
	return maxf(out, lunge_m * weight(ap.current_animation_position, _contact, _hold()))


## How long the reach holds at full weight after contact: through the carry on a landed drive.
func _hold() -> float:
	return maxf(HOLD_S, CARRY_S) if DRIVE and _thru > 0.0 and not _height_only else HOLD_S


## 0..1 at clip time t (`hold`: how long it stays 1 after contact; a landed drive holds through its carry, _hold()).
static func weight(t: float, contact: float, hold: float = HOLD_S) -> float:
	var u := 0.0
	if t < contact - IN_S:
		return 0.0
	elif t < contact:
		u = (t - (contact - IN_S)) / IN_S
	elif t <= contact + hold:
		return 1.0
	elif t < contact + hold + OUT_S:
		u = 1.0 - (t - contact - hold) / OUT_S
	else:
		return 0.0
	return u * u * (3.0 - 2.0 * u)


func _process_modification() -> void:
	last_weight = 0.0
	var skel := get_skeleton()
	if skel == null or ap == null:
		return
	if _clip != "" and str(ap.assigned_animation) != _clip:
		disarm()
	var dt := get_process_delta_time()
	for hand in _fades.keys():
		var f: Dictionary = _fades[hand]
		# S350 (SMOOTH3): eased to zero (smoothstep's complement, flat at both ends), not a straight line.
		f["t"] = float(f["t"]) + dt
		var u := clampf(float(f["t"]) / FADE_S, 0.0, 1.0)
		f["w"] = float(f["w0"]) * (1.0 - u * u * (3.0 - 2.0 * u))
		# S386 (operator: "the 2nd punch starts from a default clip and doesn't blend"; drawn JOLT 6-11 m/s at punch -> punch):
		# a new punch on the same hand erased the old reach at once - the glove snapped off the target to the raw clip. It
		# fades on; the new reach solves on top of it.
		if float(f["w"]) <= 0.0:
			_fades.erase(hand)
		else:
			_reach(skel, str(hand), float(f["w"]), f["target"], float(f["front"]),
				bool(f.get("height_only", false)), float(f.get("aim_y", 0.0)))
	if _clip != "" and _arms.has(_hand):
		_key = Engine.get_process_frames()
		_armed_t += dt
		_real_c += dt if _hit_f >= 0 and _key != _hit_f else 0.0   # from the frame after the hit
		var ramp := clampf(_armed_t / IN_S, 0.0, 1.0)
		_apply(skel, ap.current_animation_position, ramp * ramp * (3.0 - 2.0 * ramp))


## The armed punch at clip time t (the pose on the skeleton must be the clip's at t): what the modifier does each frame,
## without the arming ramp (probes and tests: tests/hit_frame_test.gd).
func reach_at(t: float) -> void:
	var skel := get_skeleton()
	if skel != null and _clip != "" and _arms.has(_hand):
		_probe_n += 1
		_key = -_probe_n
		_apply(skel, t, 1.0)


func _apply(skel: Skeleton3D, t: float, ramp: float) -> void:
	set_meta("cg_pass", int(get_meta("cg_pass", 0)) + 1)   # review round 1: one pass of the stack (ReachLimit.clip_glove)
	_w_now = weight(t, _contact, _hold()) * ramp
	var drive := DRIVE and not _height_only and _target.is_valid()
	if drive:
		var dv := _drive(skel, t)
		_aim_w = ReachLimit.cap(_prev_g, dv) if ReachLimit.capping(self) else dv   # _drive just read this frame's clip glove
		if drive_v > 0.0 and t <= _contact + 1e-4:
			_w_now = ramp   # ReachDrive sets where the glove goes (far out: the clip's own glove)
	last_weight = _w_now
	_last_w = 0.0
	if drive and _hit_w.is_finite() and t > _contact and _prev_g.is_finite() and _aim_w.is_finite():
		# Review round 2 (hit_carry_test only=pro_right_cross: the clip's glove is still 0.3-0.5 m past her face when the
		# weight goes; let go there, the glove jumped 0.29 m through her head). It lets go as the clip's glove comes back.
		_w_now = maxf(_w_now, clampf((_prev_g.distance_to(_aim_w) - RELEASE_M.x) / (RELEASE_M.y - RELEASE_M.x), 0.0, 1.0))
	if _w_now <= 0.0:
		return
	if drive and _hit_w.is_finite() and t > _contact + 1e-4 and _w_now < 1.0 and _prev_g.is_finite():
		# Letting go after the hit: the glove goes back toward the clip's, but never further along the punch line than the
		# carry, nor further than it was last frame (review round 1: the clip's own glove is still travelling out there, and
		# following it the glove went out, back and out again).
		var p := _aim_w + (_prev_g - _aim_w) * (1.0 - _w_now)
		var along := (p - _hit_w).dot(_dir_w)
		var cap := minf((_aim_w - _hit_w).dot(_dir_w), _back_along)
		if along > cap:
			p -= _dir_w * (along - cap)
			along = cap
		_back_along = along
		_aim_at(skel, p, 1.0)
	elif drive:
		_aim_at(skel, _aim_w, _w_now)
	else:
		_reach(skel, _hand, _w_now, _target, _front, _height_only, _aim_target_y)
	if drive:
		_t_now = t
		_note_shown(skel)


## The carry goes on along the line the glove ARRIVED on (as shown, the frame before the hit to the hit), so a hook carries
## on round and a straight carries on straight. Called after each solve of a frame (_apply, then settle(): the last call of
## a frame is the glove as drawn).
func _note_shown(skel: Skeleton3D) -> void:
	var ids: Array = _arms[_hand]
	var shown: Vector3 = skel.global_transform * (skel.get_bone_global_pose(int(ids[2])).origin + _along(skel, ids) * _front)
	# One "last frame" per drawn frame: on the hit frame HitImpact runs the stack's solve once by hand on the bare clip pose
	# (no hips travel yet) before the stack's own pass; the line and the carry's start are taken again on every later solve.
	var f := _key
	if f != _shown_f:
		_shown_prev = _shown_cur
		_shown_t.x = _shown_t.y
		_shown_f = f
	_shown_cur = shown
	_shown_t.y = _t_now
	if _dir_pending or f == _hit_f:
		if _shown_prev.is_finite() and shown.distance_to(_shown_prev) > 1e-3:
			_dir_w = (shown - _shown_prev).normalized()
		if _thru > 0.0:
			# Review round 1: the carry goes THROUGH_M on from where the glove IS on the hit frame (1-3 cm short of her
			# face point, or past it), not from the face point: the base is the glove now less the carry already run.
			_hit_w = shown - _dir_w * _carried(_t_now)
		_hit_f = f
	_dir_pending = false


## The driven glove onto world point `at` by weight w, remembered so settle() lands it on the same point.
func _aim_at(skel: Skeleton3D, at: Vector3, w: float) -> void:
	_last_at = at
	_last_w = w
	_reach(skel, _hand, w, func() -> Vector3: return at, _front)


## POWER1 step 2: the point the armed glove is aimed at, at clip time t (world). See THROUGH_M.
func _drive(skel: Skeleton3D, t: float) -> Vector3:
	var ids: Array = _arms[_hand]
	var to_w := skel.global_transform
	var g: Vector3 = to_w * (skel.get_bone_global_pose(int(ids[2])).origin + _along(skel, ids) * _front)
	if _prev_t >= 0.0 and t > _prev_t + 1e-4 and t - _prev_t <= PEAK_DT_MAX and t <= _contact + 1e-4 and _prev_g.is_finite():
		_peak_v = maxf(_peak_v, g.distance_to(_prev_g) / (t - _prev_t))
	_prev_g = g
	_prev_t = t
	var v := clampf(_peak_v, DRIVE_V.x, DRIVE_V.y)
	if t < _contact - LATCH_S and not _hit_w.is_finite():
		var face: Vector3 = _target.call()
		var dv := ReachDrive.aim(self, g, t, face)
		if dv.is_finite():
			return dv
		var to_face := face - g
		var gap := to_face.length()
		if gap < 1e-4:
			return face
		_dir_w = to_face / gap
		return face - _dir_w * minf(v * (_contact - t), gap)
	if _hit_w.is_finite() and _hit_f == _key:
		hit_g = g   # review round 1: the stack's own pass on the hit frame (HitImpact's pass by hand has no hips travel yet)
	if not _hit_w.is_finite():
		_hit_w = _target.call()
		hit_g = g
		hit_face = _hit_w
		_dir_pending = true
		if _dir_w.length() < 0.5:
			_dir_w = (_hit_w - g).normalized()
	if _thru <= 0.0:
		return _hit_w
	return _hit_w + _dir_w * _carried(t)


## How far the carry has gone on at clip time t: THROUGH_M eased out over CARRY_S (review round 1: over 2 * _thru / v it
## was one frame at the game's pace).
func _carried(t: float) -> float:
	var u := clampf(maxf(t - _contact, _real_c) / CARRY_S, 0.0, 1.0)   # S445: on real time through the hit-stop
	return _thru * (1.0 - (1.0 - u) * (1.0 - u))


## S331 (INSIDEMISS1): re-lands the armed glove after later modifiers moved her trunk (GloveClear's head lean, HitSnap):
## an inside jab's glove rode the lean 0.25 m to the side of the face (hit_gap_probe). `-- nosettle` = the control arm.
static var SETTLE: bool = not OS.get_cmdline_user_args().has("nosettle")
func settle() -> void:
	var skel := get_skeleton()
	if SETTLE and skel != null and _clip != "" and _w_now > 0.0:
		if _last_w > 0.0 and not _height_only:
			# Review round 1: on the point _apply aimed at this frame and at its weight (on the way back that is not _aim_w at
			# _w_now: re-solving there pulled the glove back out to the carry, and the next frame let it go again).
			var at := _last_at
			_reach(skel, _hand, _last_w, func() -> Vector3: return at, _front)
			_note_shown(skel)
		else:
			_reach(skel, _hand, _w_now, _target, _front, _height_only, _aim_target_y)


## Carries `hand`'s glove front onto the target by weight w.
## HEADAIM2B: height_only and aim_y are passed per-call (each reach carries its own mode, no member flag read).
func _reach(skel: Skeleton3D, hand: String, w: float, target_fn: Callable, glove_front: float,
		height_only: bool = false, aim_y: float = 0.0) -> void:
	if not _arms.has(hand):
		return
	var ids: Array = _arms[hand]
	var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
	var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
	var l1 := s.distance_to(skel.get_bone_global_pose(int(ids[1])).origin)
	var l2 := skel.get_bone_global_pose(int(ids[1])).origin.distance_to(g_hd.origin)
	# POWER1 step 2: the elbow's side. The solve keeps the elbow on the side the clip has it; with the clip's arm nearly
	# straight (the hit now lands before the clip's furthest point, so the reach is still on while the clip arm locks out)
	# that side is noise and the carried glove jumped 5-9 cm frame to frame (hit_frame_test, pro_left_jab). Under POLE_M
	# off the shoulder-wrist line the last clear side is kept, fully at a straight arm.
	var pole := Vector3.ZERO
	var pole_w := 0.0
	if DRIVE:
		var line := (g_hd.origin - s).normalized()
		var off: Vector3 = skel.get_bone_global_pose(int(ids[1])).origin - s
		off -= line * off.dot(line)
		if off.length() >= POLE_M:
			_poles[hand] = off.normalized()
		elif _poles.has(hand):
			pole = _poles[hand]
			pole_w = 1.0 - off.length() / POLE_M
	# HEADAIM2B: height-only mode - replace glove front Y with latched target Y, keep X/Z from clip.
	# The glove front's X/Z may drift slightly (3-8cm) from the IK geometry change when solving for
	# a different height; this is inherent to the two-bone solver.
	var target: Vector3
	if height_only:
		var current_gf: Vector3 = g_hd.origin + _along(skel, ids) * glove_front
		var to_skel := skel.global_transform.affine_inverse()
		var latched_skel_y: float = (to_skel * Vector3(0, aim_y, 0)).y
		target = Vector3(current_gf.x, latched_skel_y, current_gf.z)
	else:
		if not target_fn.is_valid():
			return
		target = skel.global_transform.affine_inverse() * (target_fn.call() as Vector3)
	# Where the wrist must go for the glove front to sit on the target. S321: the glove's axis follows the forearm, and
	# moving the wrist turns the forearm, so one step left the front 0.13-0.28 m off (hit_gap_probe, inside punches): the
	# full-weight wrist is found by re-solving from the moved arm, then the pose is put back and eased in by the weight.
	var keep := [skel.get_bone_global_pose(int(ids[0])), skel.get_bone_global_pose(int(ids[1])), g_hd]
	var full := g_hd.origin
	for k in SOLVE_PASSES:
		var hd_now: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
		full = hd_now + (target - (hd_now + _along(skel, ids) * glove_front))
		solve(skel, ids, s, full, l1, l2, g_hd.basis, pole, pole_w)
	for k in 3:
		skel.set_bone_global_pose(int(ids[k]), keep[k])
	var want: Vector3 = g_hd.origin + (full - g_hd.origin) * w
	var clip_glove := ReachLimit.clip_glove(self, skel, ids, glove_front, hand == _hand and _clip != "")   # the cap's centre (solve_capped)
	var reach := ReachLimit.reach(_clip if hand == _hand else "", l1, l2)
	if hand == _hand and _hit_f == _key:
		hit_s = skel.global_transform * s   # review round 1: her shoulder on the hit frame before any lean (RangeLive)
	var lean_to := ReachLimit.lean_to(_clip if hand == _hand and DRIVE and _thru > 0.0 else "", s.distance_to(want), reach, l1, l2)
	if _chest >= 0 and lean_to > 0.0:
		ReachLimit.lean(skel, _chest, s, want, lean_to, w, LEAN_MAX)
		s = skel.get_bone_global_pose(int(ids[0])).origin
		if DRIVE:
			# POWER1: the lean moved the shoulder, so the glove's axis (it follows the forearm) lands it elsewhere: re-solve
			# from the leaned shoulder (hit_frame_test read the straight-arm reaches 2-3 cm past their aim before this).
			var keep2 := [skel.get_bone_global_pose(int(ids[0])), skel.get_bone_global_pose(int(ids[1])), skel.get_bone_global_pose(int(ids[2]))]
			var full2 := full
			for k in SOLVE_PASSES:
				solve(skel, ids, s, full2, l1, l2, g_hd.basis, pole, pole_w)
				var hd2: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
				full2 = hd2 + (target - (hd2 + _along(skel, ids) * glove_front))
			for k in 3:
				skel.set_bone_global_pose(int(ids[k]), keep2[k])
			want += (full2 - full) * w
	if reach < l1 + l2 - 0.005:
		want = s + (want - s).limit_length(reach)   # POWER1 step 4: an uppercut's elbow stays bent; short is short
	ReachLimit.solve_capped(self, skel, ids, s, want, l1, l2, g_hd.basis, pole, pole_w, clip_glove, glove_front, hand == _hand and DRIVE and ReachLimit.capping(self))


## The glove's long axis, as Gloves.gd mounts it: the wrist-to-knuckle direction turned WRIST_STRAIGHT of the way onto the
## forearm (S316 taped wrist). S321: this aimed along the bare hand alone, so wherever a clip bends the wrist (hooks, short
## inside punches) the glove's real striking face landed 0.13-0.28 m short and to the side of the face (hit_gap_probe).
func _along(skel: Skeleton3D, ids: Array) -> Vector3:
	var wrist: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = skel.get_bone_global_pose(int(ids[3])).origin - wrist
	if a.length() < 1e-5:
		return Vector3.FORWARD
	a = a.normalized()
	var arm: Vector3 = wrist - skel.get_bone_global_pose(int(ids[1])).origin
	if STRAIGHT > 0.0 and arm.length() > 1e-5 and a.angle_to(arm) > 1e-3:
		a = a.slerp(arm.normalized(), STRAIGHT).normalized()
	return a


## Two-bone solve: shoulder fixed, wrist on `want` (clamped to the arm's reach), elbow kept on its current side; the hand
## keeps `hand_basis`. ids = [upper arm, lower arm, hand, ...] (GuardTuck uses it too). S315: `pole_w` > 0 turns the elbow's
## side that far toward `pole` (skeleton space; GuardTuck's inside guard drops the elbows onto the ribs).
static func solve(skel: Skeleton3D, ids: Array, s: Vector3, want: Vector3, l1: float, l2: float, hand_basis: Basis, pole := Vector3.ZERO, pole_w := 0.0) -> void:
	var ua: int = ids[0]
	var la: int = ids[1]
	var hd: int = ids[2]
	var g_ua: Transform3D = skel.get_bone_global_pose(ua)
	var e: Vector3 = skel.get_bone_global_pose(la).origin
	var d := clampf(s.distance_to(want), absf(l1 - l2) + 0.01, l1 + l2 - 0.004)
	var axis := want - s
	if axis.length() < 1e-4:
		return
	axis = axis.normalized()
	var h := s + axis * d
	var a := (l1 * l1 - l2 * l2 + d * d) / (2.0 * d)
	var r := sqrt(maxf(0.0, l1 * l1 - a * a))
	var c := s + axis * a
	var bend := (e - c) - axis * (e - c).dot(axis)
	bend = bend.normalized() if bend.length() > 1e-4 else Vector3.DOWN
	if pole_w > 0.0:
		var pp := pole - axis * pole.dot(axis)
		if pp.length() > 1e-4:
			bend = bend.slerp(pp.normalized(), clampf(pole_w, 0.0, 1.0)).normalized()
	var e2 := c + bend * r
	var rot_ua := Quaternion((e - s).normalized(), (e2 - s).normalized())
	skel.set_bone_global_pose(ua, Transform3D(Basis(rot_ua) * g_ua.basis, s))
	var g_la: Transform3D = skel.get_bone_global_pose(la)
	var h_now: Vector3 = skel.get_bone_global_pose(hd).origin
	var rot_la := Quaternion((h_now - e2).normalized(), (h - e2).normalized())
	skel.set_bone_global_pose(la, Transform3D(Basis(rot_la) * g_la.basis, e2))
	skel.set_bone_global_pose(hd, Transform3D(hand_basis, h))
