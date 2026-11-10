extends SkeletonModifier3D
## FIGHTERLOOK1 (operator 2026-11-07: "the poses ... they all look the same"): a boxer who is alive between the clips.
## Over whatever clip plays (guard, fidget, stool, walk) she breathes, her weight drifts between her feet through four rest
## poses of her own (FighterLook posture: forward / upright / loose / guarded, each with her numbers), her head turns to the
## face she is looking at - the coach knelt in front of her, else the opponent - and her eyes look, hold, glance away and blink
## (mh_eye.gdshader). Punches and hits keep their clip: the layer fades to a fifth while one plays.
## Runs right after TiredSag and before the guard (so the gloves follow the face). `-- nolook` = not attached (control arm).
##   setup(skel, ap, stage, look, eyes) -> bool    calm (0..1, eased)

## Clips that carry the whole body: the rest pose and the head look give way to them.
const BUSY := ["jab", "cross", "hook", "upper", "punch", "hit", "react", "knock", "clinch", "block", "slip", "fall", "down",
	"stagger", "roll", "duck", "weave", "body_"]
const KnockdownLayers := preload("res://scripts/fight3d/KnockdownLayers.gd")
## The four rest poses a boxer drifts between: weight (-1 left .. 1 right), head tilt and chin added, shoulders, lean.
const POSES := [
	{"weight": 0.0, "tilt": 0.0, "chin": 0.0, "hunch": 0.0, "lean": 0.0},
	{"weight": -1.0, "tilt": 3.0, "chin": -1.5, "hunch": 1.5, "lean": 1.0},
	{"weight": 0.6, "tilt": -2.0, "chin": 2.0, "hunch": -2.0, "lean": -1.0},
	{"weight": 1.0, "tilt": 1.5, "chin": 1.0, "hunch": 2.5, "lean": 2.0},
]
const POSE_S := Vector2(3.5, 8.0)       # how long she stays in one rest pose
const HEAD_YAW := deg_to_rad(42.0)      # how far her head turns to a face (the eyes do the rest)
const HEAD_PITCH := deg_to_rad(22.0)
## Round 1 (both blind critics: eyes rolled into the whites): the iris is 0.30 UV across, so the eyes take little of a look
## and the head carries the rest.
const EYE_YAW := deg_to_rad(20.0)
const EYE_PITCH := deg_to_rad(9.0)
const LOOK_M := 2.6                     # a face further than this is not looked at
const EYE_BIND := Vector3(0.0, 1.587, 0.086)   # between her eyes, body rest space (mh_boxer_11; each body sets meta eye_at)

var stage: Node = null
var look: Dictionary = {}
var eyes: Array = []                    # mh_eye ShaderMaterials
var ap: AnimationPlayer = null
var calm := 1.0
## The corner team: eyes, blinks, breath and the head turn only - their stance and hands stay the clip's (CornerIK holds props).
var crew := false
var _b := {}
var _t := 0.0
var _rng := RandomNumberGenerator.new()
var _pose_i := 0
var _pose_left := 0.0
var _cur := {"weight": 0.0, "tilt": 0.0, "chin": 0.0, "hunch": 0.0, "lean": 0.0}
var _target: Skeleton3D = null
var _scan_left := 0.0
var _hold_left := 0.0
var _away := Vector2.ZERO               # a glance off the face (radians), zero while she looks at it
var _jitter := Vector2.ZERO
var _head := Vector2.ZERO               # the head's own turn now (yaw, pitch), eased
var _gaze := Vector2.ZERO
var _blink_left := 2.0
var _blink_t := -1.0
var _head_rest_inv := Transform3D.IDENTITY
var _stand_hips := 1.0
var _eye := EYE_BIND
var _still := 0.0                       # 1 = her head is the clip's (a prop at her face)
var _prop_near := false
var _bp := 0.0                          # breath phase (accumulated: the rate changes on the stool)


func setup(skel: Skeleton3D, player: AnimationPlayer, owner_stage: Node, fighter_look: Dictionary, eye_mats: Array) -> bool:
	for n in ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head", "LeftShoulder", "RightShoulder", "LeftUpperArm",
			"RightUpperArm"]:
		_b[n] = skel.find_bone(n)
		if int(_b[n]) < 0:
			return false
	stage = owner_stage
	ap = player
	look = fighter_look
	eyes = eye_mats
	_rng.seed = absi(hash(str(look.get("name", "")))) + 17
	_t = _rng.randf() * 10.0
	_pose_i = _rng.randi() % POSES.size()
	_pose_left = _rng.randf_range(POSE_S.x, POSE_S.y)
	_blink_left = _rng.randf_range(0.5, 3.0)
	_head_rest_inv = skel.get_bone_global_rest(int(_b["Head"])).affine_inverse()
	_eye = skel.get_meta("eye_at", EYE_BIND)
	_stand_hips = skel.get_bone_global_rest(int(_b["Hips"])).origin.y
	return true


func _busy() -> bool:
	if ap == null or not is_instance_valid(ap):
		return false
	var clip := str(ap.current_animation).to_lower()
	if clip.contains("idle") or clip.contains("fidget"):
		return false
	for w in BUSY:
		if clip.contains(w):
			return true
	return false


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or look.is_empty():
		return
	var dt := get_process_delta_time()
	if dt <= 0.0:
		return
	_t += dt
	# KDFIX4: a finished knockdown clears current_animation and the life layer was coming back on the held pose.
	# clip_of keeps the held clip, so calm stays 0 for the rest of the time on the canvas. Once it is there, stop writing.
	var down := KnockdownLayers.is_down(KnockdownLayers.clip_of(ap))
	# Standing ease stays the old 0.25 s. Only the drop to zero, while down, uses the short ease.
	calm = move_toward(calm, 0.0 if down else (0.2 if _busy() else 1.0), dt / (0.15 if down else 0.25))
	if down and calm <= 0.001:
		return
	var pose: Dictionary = look["pose"]
	var hips_now: Vector3 = skel.get_bone_global_pose(int(_b["Hips"])).origin
	var seated := hips_now.y < _stand_hips * 0.72
	_drift(dt)
	var axes := _axes(skel)
	var fwd: Vector3 = axes[0]
	var up: Vector3 = axes[1]
	var left: Vector3 = axes[2]
	var fold := up.cross(fwd).normalized()   # turning about this tips `up` toward `fwd`
	# The breath: in quick, out long; the chest lifts and the shoulders rise a little on every breath.
	# Blind round 2 (both critics: "no breathing in the shoulders"): on the stool after three minutes she HEAVES - real
	# recovery breathing runs ~28-34 a minute, deep, the shoulders and head riding each breath; standing, a calm breath.
	var heave := 1.0 if seated and not crew else 0.0
	# KDFIX3: stop breathing accumulation when down - only forward chest rise stays, and only when not down.
	if not down:
		_bp += dt * float(pose["breath_hz"]) * lerpf(1.0, 1.9, heave)
	var breath := pow(0.5 + 0.5 * sin(TAU * _bp), 1.5) if not down else 0.0
	var deep := lerpf(1.0, 2.3, heave)
	_rot(skel, "Chest", fold, -deg_to_rad(1.6) * breath * deep)
	_rot(skel, "UpperChest", fold, -deg_to_rad(0.9) * breath * deep)
	for side in ["Left", "Right"]:
		var c: Vector3 = skel.get_bone_global_pose(int(_b[side + "Shoulder"])).origin
		var a: Vector3 = (skel.get_bone_global_pose(int(_b[side + "UpperArm"])).origin - c).normalized()
		var ax := a.cross(up)
		if ax.length() > 1e-4:
			var hunch := 0.0 if crew else deg_to_rad(float(pose["hunch"]) + float(_cur["hunch"])) * calm
			_rot(skel, side + "Shoulder", ax.normalized(), deg_to_rad(1.4) * breath * deep + hunch)
			# Wider shoulders on a puncher: the clavicle carries the arm out a little (rest space, scaled with her).
			var sw: float = float(pose.get("shoulders_m", 0.0))
			if sw > 0.0 and not crew:
				var bi: int = int(_b[side + "Shoulder"])
				var g := skel.get_bone_global_pose(bi)
				var out_dir := left if side == "Left" else -left
				skel.set_bone_global_pose(bi, Transform3D(g.basis, g.origin + out_dir * sw))
	# Her stance: the trunk over (or behind) the hips, the weight drifting between her feet.
	var lean := 0.0 if crew else deg_to_rad(float(pose["lean"]) + float(_cur["lean"])) * calm
	_rot(skel, "Spine", fold, lean * 0.5)
	_rot(skel, "Chest", fold, lean * 0.5)
	if not seated and not crew:
		var sway: float = float(pose["sway_m"]) * (sin(TAU * _t * float(pose["sway_hz"])) * 0.6 \
			+ (float(pose["weight"]) + float(_cur["weight"])) * 0.7) * calm
		var hb: int = int(_b["Hips"])
		var hg := skel.get_bone_global_pose(hb)
		# The hips go over one foot, the trunk tips back over the other a little (the counter-balance).
		# Mostly front foot <-> back foot (a boxer rocks along her stance); a sideways push would close a stance's width.
		skel.set_bone_global_pose(hb, Transform3D(Basis(fwd, -sway * 1.2) * hg.basis, hg.origin + (fwd * 0.8 + left * 0.25) * sway))
		_rot(skel, "Spine", fwd, sway * 1.5)
	# Head and eyes: turn to the face she is looking at (the head part of the way, the eyes the rest); chin and tilt are hers.
	_scan(skel, dt)
	var want := Vector2.ZERO
	var their := Vector3.INF
	if _target != null and is_instance_valid(_target):
		var tb := _target.find_bone("Head")
		if tb >= 0:
			var their_pose: Transform3D = _target.get_bone_global_pose(tb) * _target.get_bone_global_rest(tb).affine_inverse()
			their = skel.global_transform.affine_inverse() * (_target.global_transform * their_pose * (_target.get_meta("eye_at", EYE_BIND) as Vector3))
	if their != Vector3.INF:
		var a := _angles(skel, their)
		want = Vector2(clampf(a.x, -HEAD_YAW, HEAD_YAW), clampf(a.y, -HEAD_PITCH, HEAD_PITCH)) * (0.8 if seated or crew else 0.4)
	# Blind round 3: the turn pulled her mouth off the water bottle (CornerMinute aims it at the clip's mouth): while a held
	# prop is at her face, the head is the clip's and only the eyes move.
	_still = move_toward(_still, 1.0 if _prop_near else 0.0, dt / 0.3)
	_head = _head.lerp(want * calm * (1.0 - _still), clampf(dt * 4.0, 0.0, 1.0))
	var chin := 0.0 if crew else deg_to_rad(float(pose["chin"]) + float(_cur["chin"])) * calm * (1.0 - _still)
	var tilt := 0.0 if crew else deg_to_rad(float(pose["tilt"]) + float(_cur["tilt"])) * calm * (1.0 - _still)
	var hf := _head_frame(skel)
	var h_up: Vector3 = hf.basis * Vector3.UP
	var h_left: Vector3 = hf.basis * Vector3.RIGHT
	var h_fwd: Vector3 = hf.basis * Vector3.BACK
	_rot(skel, "Neck", h_up, _head.x * 0.4)
	_rot(skel, "Head", h_up, _head.x * 0.6)
	_rot(skel, "Neck", h_left, -_head.y * 0.4 + chin * 0.6)
	_rot(skel, "Head", h_left, -_head.y * 0.6 + chin * 0.4)
	_rot(skel, "Head", h_fwd, tilt)
	_rot(skel, "Head", h_left, -deg_to_rad(1.2) * breath * heave * (1.0 - _still))   # the head rides the in-breath
	# The eyes, in the head's frame after its turn: the rest of the way to the face, a glance away, a tiny tremor.
	var eye_to := _away + _jitter
	if their != Vector3.INF:
		eye_to += _angles(skel, their)
	else:
		eye_to += Vector2(0.0, chin)   # nobody to look at: eyes level with the horizon
	eye_to = Vector2(clampf(eye_to.x, -EYE_YAW, EYE_YAW), clampf(eye_to.y, -EYE_PITCH, EYE_PITCH))
	_gaze = _gaze.lerp(eye_to, clampf(dt * 18.0, 0.0, 1.0))   # saccades are fast
	var b := _blink(dt)
	for em in eyes:
		(em as ShaderMaterial).set_shader_parameter("gaze", _gaze)
		(em as ShaderMaterial).set_shader_parameter("blink", b)


## The head now in the body's rest space terms (face down +Z, left +X).
func _head_frame(skel: Skeleton3D) -> Transform3D:
	return skel.get_bone_global_pose(int(_b["Head"])) * _head_rest_inv


## Yaw (to her left +) and pitch (up +) from between her eyes to a point (skeleton space), in her head's frame.
func _angles(skel: Skeleton3D, at: Vector3) -> Vector2:
	var hf := _head_frame(skel)
	var d := hf.affine_inverse() * at - _eye
	return Vector2(atan2(d.x, d.z), atan2(d.y, Vector2(d.x, d.z).length()))


## Her own frame from the pose: forward (out of her chest), up (hips to chest), left.
func _axes(skel: Skeleton3D) -> Array:
	var hips: Vector3 = skel.get_bone_global_pose(int(_b["Hips"])).origin
	var chest: Vector3 = skel.get_bone_global_pose(int(_b["Chest"])).origin
	var up := (chest - hips).normalized()
	var left := (skel.get_bone_global_pose(int(_b["LeftUpperArm"])).origin - skel.get_bone_global_pose(int(_b["RightUpperArm"])).origin).normalized()
	var fwd := left.cross(up).normalized()
	left = up.cross(fwd).normalized()
	return [fwd, up, left]


## The rest poses: hold one a few seconds, then ease to the next (never the same twice running).
func _drift(dt: float) -> void:
	_pose_left -= dt
	if _pose_left <= 0.0:
		var nxt := _rng.randi() % (POSES.size() - 1)
		_pose_i = nxt if nxt < _pose_i else nxt + 1
		_pose_left = _rng.randf_range(POSE_S.x, POSE_S.y)
	var to: Dictionary = POSES[_pose_i]
	var k := clampf(dt * 0.9, 0.0, 1.0)
	for key in _cur:
		_cur[key] = lerpf(float(_cur[key]), float(to[key]), k)


## Who she looks at: the nearest face in front of her within LOOK_M (the coach knelt at the stool, else the opponent),
## held for her hold time; now and then a glance away (down at her gloves, aside) and back.
func _scan(skel: Skeleton3D, dt: float) -> void:
	_hold_left -= dt
	_scan_left -= dt
	if _scan_left <= 0.0:
		_scan_left = 0.4
		var was := _target
		_target = _nearest_face(skel)
		_prop_near = _prop_at_face(skel)
		if _target != was and _blink_t < 0.0:
			_blink_left = minf(_blink_left, 0.05)   # a look to a new face starts with a blink (as real eyes do)
	if _hold_left <= 0.0:
		var e: Dictionary = look["eyes"]
		_hold_left = float(e["hold_s"]) * _rng.randf_range(0.6, 1.5)
		if _rng.randf() < float(e["glance"]):
			_away = Vector2(_rng.randf_range(-0.35, 0.35), _rng.randf_range(-0.35, -0.12))
			_hold_left *= 0.45
		else:
			_away = Vector2.ZERO
		_jitter = Vector2(_rng.randf_range(-0.03, 0.03), _rng.randf_range(-0.02, 0.02))


func _nearest_face(skel: Skeleton3D) -> Skeleton3D:
	if stage == null or not is_instance_valid(stage):
		return null
	var me_head: Vector3 = skel.global_transform * skel.get_bone_global_pose(int(_b["Head"])).origin
	var axes := _axes(skel)
	var fwd_w: Vector3 = (skel.global_transform.basis * (axes[0] as Vector3)).normalized()
	var best: Skeleton3D = null
	var best_d := LOOK_M * 2.0
	# Blind round 2 ("her gaze never lands on the second beside her"; "nobody looks at the one talking"): on the stool and in
	# the corner team a face at her side counts, and whoever is TALKING (a *talk* clip) wins over a nearer silent one.
	var front_min := -0.25 if crew or _seated(skel) else 0.15
	for n in stage.find_children("*", "Skeleton3D", true, false):
		var s := n as Skeleton3D
		if s == skel or not s.is_visible_in_tree():
			continue
		var hb := s.find_bone("Head")
		if hb < 0:
			continue
		var at: Vector3 = s.global_transform * s.get_bone_global_pose(hb).origin
		var to := at - me_head
		var d := to.length()
		if d < 0.15 or d > LOOK_M or fwd_w.dot(to / d) < front_min:
			continue
		var score := d - (1.5 if _talking(s) else 0.0)
		if score < best_d:
			best = s
			best_d = score
	return best


## A corner prop (the bottle, the ice, the swab) shown within 0.35 m of her head.
func _prop_at_face(skel: Skeleton3D) -> bool:
	if stage == null or crew:
		return false
	var c: Node = stage.find_child("CornerCrew", false, false)
	if c == null or not ("props" in c):
		return false
	var head: Vector3 = skel.global_transform * skel.get_bone_global_pose(int(_b["Head"])).origin
	for k in (c.get("props") as Dictionary):
		var p: Variant = (c.get("props") as Dictionary)[k]
		if p is Node3D and (p as Node3D).is_visible_in_tree() and not str(k).contains("stool") and not str(k).contains("bucket") 				and (p as Node3D).global_position.distance_to(head) < 0.35:
			return true
	return false


func _seated(skel: Skeleton3D) -> bool:
	return skel.get_bone_global_pose(int(_b["Hips"])).origin.y < _stand_hips * 0.72


static func _talking(s: Skeleton3D) -> bool:
	var root: Node = s.get_parent()
	if root == null:
		return false
	var aps := root.find_children("*", "AnimationPlayer", false, false)
	if aps.is_empty() and root.get_parent() != null:
		aps = root.get_parent().find_children("*", "AnimationPlayer", false, false)
	return not aps.is_empty() and str((aps[0] as AnimationPlayer).current_animation).contains("talk")


## A blink: a quick close (70 ms), a slower open (110 ms), every 60 / blinks-a-minute seconds on average.
func _blink(dt: float) -> float:
	if _blink_t >= 0.0:
		_blink_t += dt
		if _blink_t < 0.07:
			return _blink_t / 0.07
		if _blink_t < 0.18:
			return 1.0 - (_blink_t - 0.07) / 0.11
		_blink_t = -1.0
	_blink_left -= dt
	if _blink_left <= 0.0:
		_blink_t = 0.0
		var mean := 60.0 / float((look["eyes"] as Dictionary)["blinks"])
		_blink_left = clampf(-log(maxf(_rng.randf(), 0.02)) * mean, 0.6, mean * 3.0)
		if _rng.randf() < 0.12:
			_blink_left = 0.25   # now and then a double blink
	return 0.0


func _rot(skel: Skeleton3D, bone: String, axis: Vector3, angle: float) -> void:
	if absf(angle) < 1e-5:
		return
	var i: int = int(_b[bone])
	var g: Transform3D = skel.get_bone_global_pose(i)
	skel.set_bone_global_pose(i, Transform3D(Basis(Quaternion(axis.normalized(), angle)) * g.basis, g.origin))
