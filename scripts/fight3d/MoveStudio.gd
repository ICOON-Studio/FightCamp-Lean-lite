extends RefCounted
## S382 MOVETIP1 round 2 - the hover card's studio (MovePlayer with `studio` on). The operator recorded the reference card
## in his game (tmp/s382/rec/NOTES.md): her own body doing the move on a REAL partner who reacts, a plain off-white floor,
## the camera ~35 deg above at 3/4, soft shadows under the feet. So, in the studio:
##   - the partner is solid (his or her own body, the blue corner's trunks) - never the pale ghost of the Playbook's player;
##   - a jab is slipped or blocked (each jab the other, the defence at its deepest when the glove arrives) - it never lands;
##   - a cross / hook / uppercut lands: the take for that punch (BeatClips.REACT) and the fight's head snap (HitSnap);
##   - a body shot folds him (gutshot v3, the fold BeatClips names for it, and HitSnap's fold);
##   - the camera 35 deg above, turned `yaw_deg` toward her front, both bodies head to feet.
## The fight's HitImpact.hit is not called: its hit-stop freezes both AnimationPlayers, which the player's own timeline
## (MovePlayer._process) does not know about.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const HitImpact := preload("res://scripts/fight3d/HitImpact.gd")

const BG := Color("#f1eee8")
const FLOOR := Color("#ebe7df")
const PITCH_DEG := 35.0
const LOOK_Y := 0.24   # S410 measured over a whole pass of the clip: heads to feet read 63 to 315 of 300 px, 83 px a metre of aim; this centres them
const DIST_M := 4.7    # S405: 3.6 cut a partner's foot off the 300 px hover card mid-step; S408: 4.15 still reached the bottom edge on CI
## The cover-up (mc_to_block) has its gloves up this far in at 1x; a slip's deepest point is MovePlayer.DEF_PEAK_S.
const BLOCK_SET_S := 0.25
const DEF_LATE_S := 0.03   # the head is off the line a touch before the glove arrives
const BODY_FOLD := "pro_hit_by_gutshot_v3"


## S382 round 3: the heads keep this far apart, centre to centre, each centre riding with its head (GloveClear.ride; it
## leans both trunks out of it; the fight keeps 0.19 m, a touch, on a straight-up centre). The operator saw the folded
## partner's head pass into the puncher's on the body hook (movetip_r2.mp4 0:19.45); the bar is 0.25 m (move_tip_test),
## kept with room: each boxer reads the other's head a frame late.
const HEAD_TOUCH_M := 0.33


## The studio room: an off-white floor that fills the frame (the camera looks down, no horizon), a high soft key light.
## Both bodies of `stage` keep the studio's head distance.
static func room(world: Node3D, stage: Node3D) -> Camera3D:
	for bx in stage.boxers:
		if bx.get("gclear") != null:
			bx["gclear"].head_touch_m = HEAD_TOUCH_M
			bx["gclear"].ride = true
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = BG
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.86, 0.86, 0.88)
	e.ambient_light_energy = 0.75
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	world.add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-68, 40, 0)   # high: the shadow pools under the feet
	sun.light_energy = 1.15
	sun.shadow_enabled = true
	sun.shadow_blur = 2.5
	sun.directional_shadow_max_distance = 12.0
	world.add_child(sun)
	var floor_mi := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(60, 60)
	floor_mi.mesh = plane
	var m := StandardMaterial3D.new()
	m.albedo_color = FLOOR
	m.roughness = 0.95
	floor_mi.material_override = m
	floor_mi.position = Vector3(0, -0.005, 0)
	world.add_child(floor_mi)
	var cam := Camera3D.new()
	cam.fov = 35.0
	cam.current = true
	world.add_child(cam)
	return cam


## ~35 deg above, turned `yaw_deg` from side-on toward her front; both bodies head to feet.
static func aim(cam: Camera3D, mid_z: float, gap_m: float, yaw_deg: float) -> void:
	var look := Vector3(0, LOOK_Y, mid_z)
	var p := deg_to_rad(PITCH_DEG)
	var y := deg_to_rad(yaw_deg)
	var dist := maxf(DIST_M, gap_m * 2.2)
	cam.position = look + Vector3(cos(p) * cos(y), sin(p), cos(p) * sin(y)) * dist
	cam.look_at(look, Vector3.UP)


## Does the partner defend this punch (the jab) instead of taking it?
static func defends(kind: String) -> bool:
	return kind == "jab"


## The partner slips (odd jabs) or covers up (even jabs) so the defence is deepest as her glove arrives `contact_real`
## seconds from now. `still` says the move is still the one that threw it when the timer fires.
## HEADAIM2: also aims the un-landed jab's height at the target's face (punch_clip and punch_contact_s for the aim).
## BLOCKMEET2: blocked punches are carried onto the blocking glove (arm_block), not just aimed at face height.
static func defend(p: Node, stage: Node3D, n: int, contact_real: float, speed: float, still: Callable, punch_clip: String = "", punch_contact_s: float = 0.0) -> String:
	var has: Callable = stage.has_move
	var clip := BeatClips.defence("slip", "jab", true, false, has) if n % 2 == 1 else "block"
	if clip == "":
		return ""
	if clip == "block":   # BLOCKLOOK2: the fight's own block - her guard, and BlockCatch meets the jab with the rear glove
		if punch_clip != "":
			stage.arm_block(0, punch_clip, 0.0, punch_contact_s)
			preload("res://scripts/fight3d/BlockCatch.gd").block(stage, 0, punch_clip, "jab", punch_contact_s, speed, contact_real, still)
		return clip
	var rate := speed * BeatClips.OTHER_SPEED
	var deep := BLOCK_SET_S if clip.contains("block") else _peak(stage, clip)
	var start := contact_real - DEF_LATE_S - deep / rate
	var from_s := maxf(0.0, -start * rate)
	# HEADAIM2/BLOCKMEET2: aim the un-landed jab - blocked goes to glove, slipped/missed goes to face height
	if punch_clip != "":
		if clip.contains("block"):
			stage.arm_block(0, punch_clip, 0.0, punch_contact_s)
		else:
			stage.aim_height(0, punch_clip, 0.0, punch_contact_s)
	_later(p, maxf(0.0, start), func():
		if still.call():
			stage.play(1, clip, rate, from_s))
	return clip


## The partner takes the punch: its own take, the head snapped back along her punch (a body shot: the fold).
static func take(p: Node, stage: Node3D, kind: String, contact_real: float, speed: float, n: int, still: Callable) -> String:
	var has: Callable = stage.has_move
	var body := kind == "body_hook"
	var clip := BODY_FOLD if body and has.call(BODY_FOLD) else BeatClips.react(kind, false, has, fposmod(n * 0.37, 1.0))
	if clip == "":
		return ""
	_later(p, contact_real, func():
		if not still.call():
			return
		stage.play(1, clip, BeatClips.react_fast(clip, speed))
		var snap: Node = stage.boxers[1].get("snap")
		if snap == null:
			return
		if body:
			snap.fold(stage.hand_of(0, "LeftHand") == "RightHand")
			_give_ground(p, stage, speed, still)
			return
		var deg := 9.0
		for key in HitImpact.SNAP_DEG:
			if kind.contains(key):
				deg = float(HitImpact.SNAP_DEG[key])
		var hand: String = stage.hand_of(0, "LeftHand" if kind in ["jab", "lead_hook", "lead_uppercut"] else "RightHand")
		var skel: Skeleton3D = stage.boxers[0]["skel"]
		var shoulder := skel.global_transform * skel.get_bone_global_pose(skel.find_bone(hand.trim_suffix("Hand") + "UpperArm")).origin
		snap.snap(stage.target_point(1, false) - shoulder, deg))
	return clip


## S382 round 3 (movetip_r2.mp4 0:19.45: on the body hook his head went inside Danny's - the fold drops his head forward
## and over the hit side while the puncher's head dips to the same side, heads 0.20-0.22 m apart centre to centre,
## tools/movetip_heads_probe.gd): folding, he gives ground - a small step back and off the line, to the side his head is
## already on from the puncher's (the trace: both heads went to the fist's side, his further out), then, the fold let go,
## the same step back in, so the pair starts the next loop where it began. The step is mostly sideways: it parts the heads
## but hardly opens the pelvis gap (+0.06 m, inside the pocket's band Footwork.BAND_M 0.08), so nobody steps in after him.
const GIVE_BACK_M := 0.05
const GIVE_SIDE_M := 0.14
const GIVE_S := 0.2
const GIVE_RETURN_S := 0.85   # after the hit: the fold's hold is over (HitSnap: 0.06 rise + 0.45 hold)


static func _give_ground(p: Node, stage: Node3D, speed: float, still: Callable) -> void:
	var line: Vector3 = (stage.boxers[1]["pos"] as Vector3) - (stage.boxers[0]["pos"] as Vector3)
	line.y = 0.0
	if line.length() < 0.01:
		return
	line = line.normalized()
	var side := Vector3.UP.cross(line)
	var off := 1.0
	var h0: Vector3 = stage.boxers[0]["gclear"].shown_head if stage.boxers[0].get("gclear") != null else Vector3.INF
	var h1: Vector3 = stage.boxers[1]["gclear"].shown_head if stage.boxers[1].get("gclear") != null else Vector3.INF
	if h0.is_finite() and h1.is_finite() and absf((h1 - h0).dot(side)) > 0.005:
		off = signf((h1 - h0).dot(side))
	var step := line * GIVE_BACK_M + side * off * GIVE_SIDE_M
	var secs := GIVE_S / speed
	_glide(stage, step, secs)
	_later(p, GIVE_RETURN_S / speed, func():
		if still.call():
			_glide(stage, -step, secs))


## Ends any glide under way (the player places the pair again).
static func settle(stage: Node3D) -> void:
	for bx in stage.boxers:
		bx["vel"] = Vector3.ZERO
		bx["move_left"] = 0.0


## Boxer 1's body moves by `by` over `secs` (RingPlace's glide: no aim, no held gap, no step clip; FootPlant steps the feet).
static func _glide(stage: Node3D, by: Vector3, secs: float) -> void:
	var bx: Dictionary = stage.boxers[1]
	bx["vel"] = by / secs
	bx["move_left"] = secs
	bx["move_total"] = secs
	bx["aim_m"] = 0.0
	bx["aim_dir"] = 0.0
	bx["hold_m"] = 0.0


static func _peak(stage: Node3D, clip: String) -> float:
	var ap: AnimationPlayer = stage.boxers[1]["ap"]
	var length := ap.get_animation(clip).length if ap.has_animation(clip) else 0.0
	return minf(length, float(load("res://scripts/fight3d/MovePlayer.gd").DEF_PEAK_S.get(clip, length * 0.37)))


static func _later(p: Node, s: float, f: Callable) -> void:
	if s <= 0.0:
		f.call()
	elif p.is_inside_tree():
		var alive: WeakRef = weakref(p)   # the card may rebuild its player before the timer fires
		p.get_tree().create_timer(s).timeout.connect(func():
			if alive.get_ref() != null:
				f.call())
