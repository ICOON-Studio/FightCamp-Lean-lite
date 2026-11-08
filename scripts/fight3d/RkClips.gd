extends RefCounted
## S399 ROKOKO2 - the Rokoko captured jab, cross and guard back in the fight (operator S399: "these animations are good why
## you removed them and changed them with crap"). The old repo's FightClipRokoko (S271 ROKOKO1, S274 ROKOKOMOVES1): each
## move is one WINDOW of a long take (assets/anim/rokoko_combat, CREDITS.md), built on the boxer's own skeleton at fight
## start (RkRetarget = the old MixamoMotion -> FightClipRetarget route), then TURNED about the hips so the punch drives at
## the opponent (the actor did not face +Z). Played pure (RkPure): every synthetic layer fades out while one plays.
## THE ACTOR FIGHTS SOUTHPAW (S399, tools/rokoko_feet_probe.gd mode=find/clip, his reference renders): the right foot and the
## right shoulder lead in FightingIdle, ShadowBoxing and Boxing 0-6 s; he switches to orthodox in Boxing ~9-14 s. So the
## old "jab" at Boxing 2.40 s (old FightClipRokoko boxing_jab, S270 punch_labels "Jab (lead)") is his REAR left straight.
## Our boxers fight orthodox like every Punch PRO clip they join to, so a southpaw window is MIRRORED (`mirror`) and comes
## out orthodox; a southpaw boxer's library mirror (MirrorClip, BoxerBuild) then turns it back to his own stance.
## Punch windows are cut HOME TO HOME (tools/rokoko_feet_probe.gd mode=find RKCUT: from the last frame the punching fist sits
## within 0.28 m of the head before its peak to the first frame it is back), so a clip never ends mid-punch - the S399 blind
## critic caught the first cut (a fixed 0.67 s) popping back to guard in one frame and holding the arm out. yaw_deg = the
## arm's line at the peak, the old rokoko_window_probe way (it reproduces the old 34.8 / 32.5 to 0.1 / 1.8 deg).
## S399 TRIED AND REVERTED (blind critic: "every punch ends in a snap-back to guard"): running the punch windows on past the
## fist's return (jab to 6.50 s, cross to 10.80 s; at 6.53 the actor drags his rear foot 3 m/s) - slide and snaps stayed at
## raw, but two blind critics preferred the shipped cut (4 vs 6.5, 6.5 vs 7.0: "the extended cross returns 0.2 s later and
## ends with a wide stance"). rk_cross_b left the pool (its window ends inside the next jab). The guard windows are the longest the take holds a guard
## (rokoko_feet_probe mode=guards: fists within 0.49 m of the head, hips in place): FightingIdle 9.23-18.17 and 35.70-45.00 (9.0-24.0 measured: from 18 s she turns square, 1.27 m of slide).
##   rk_jab     Boxing 5.80-6.37 s        mirrored: one lead jab, peak 6.07, reach 0.61 m, home to home (the only clean single
##              jab: Boxing 9.2-10.5 is jab-jab-cross - the double jab is still out when the cross starts, so no cut is a jab)
##   rk_cross   Boxing 9.93-10.53 s       orthodox: the old boxing_cross re-cut home to home (reference rk_Boxing@10.00-10.53)
##   rk_cross_b Boxing 5.43-6.10 s        mirrored: reference rk_Boxing@5.63-5.90 (critic 7, "real hip and shoulder rotation")
## Dropped: ShadowBoxing 8.40-9.37 (a clean rear straight, but 0.102 m of planted slide after the join against the raw's
## 0.047 + 0.05 bar); and after the blind critic (S399): Boxing 2.50-3.17 mirrored ("starts low, loops like a hook", 4.5), the two
## ShadowBoxing jabs that never come home in the window, and Boxing 2.10-2.77 (the old "jab": it ends with the arm out).
##   rk_guard   FightingIdle 9.23-18.17 s |  rk_guard_b  FightingIdle 35.70-45.00 s   both mirrored (old GUARD_VARIANTS, S274:
##     fists within 0.50 m of the head every frame, head over hips steady to 5 mm, one posture and facing)
## Switch: on by default; `-- norokoko` on the command line = the Punch PRO jab, cross and guard (the control arm).

const RkRetarget := preload("res://scripts/fight3d/RkRetarget.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const RkLoco := preload("res://scripts/fight3d/RkLoco.gd")
const DIR := "res://assets/anim/rokoko_combat/"
const PREFIX := "rk_"
const CLIPS := {
	"rk_jab": {"take": "Boxing", "start_s": 5.80, "end_s": 6.37, "yaw_deg": -36.6, "hand": "LeftHand", "contact_s": 0.27, "mirror": true},
	"rk_cross": {"take": "Boxing", "start_s": 9.93, "end_s": 10.53, "yaw_deg": 34.6, "hand": "RightHand", "contact_s": 0.40},
	"rk_cross_b": {"take": "Boxing", "start_s": 5.43, "end_s": 6.10, "yaw_deg": -46.2, "hand": "RightHand", "contact_s": 0.30, "mirror": true},
	"rk_guard": {"take": "FightingIdle", "start_s": 9.23, "end_s": 18.17, "yaw_deg": 3.0, "mirror": true},
	"rk_guard_b": {"take": "FightingIdle", "start_s": 35.70, "end_s": 45.00, "yaw_deg": -2.7, "mirror": true},
	## S399 the actor's own captured steps in guard (tools/rokoko_feet_probe.gd mode=steps: hips travel, both fists within
	## 0.36 m of the head every frame, both feet step): a real boxer's advance and retreat.
	"rk_step_in": {"take": "Boxing", "start_s": 0.20, "end_s": 1.80, "yaw_deg": -28.2, "mirror": true},
	"rk_step_back": {"take": "Boxing", "start_s": 6.20, "end_s": 7.70, "yaw_deg": -20.3, "mirror": true},
	"rk_step_back_b": {"take": "Boxing", "start_s": 10.40, "end_s": 11.90, "yaw_deg": 62.7},
	## S399 LOCOMOTION (RkLoco): every move across the canvas is one of these, its own hip travel moving the body.
	"rk_loc_in": {"take": "Boxing", "start_s": 0.20, "end_s": 1.80, "yaw_deg": -28.2, "mirror": true, "loco": true},
	"rk_loc_back": {"file": "res://assets/anim/mixamo_walk/Walking_Backwards.fbx", "start_s": 0.0, "end_s": 0.85, "yaw_deg": 15.4, "cycles": 3, "loco": true},
	"rk_loc_left": {"file": "res://assets/anim/mixamo_walk/Boxing_Left_Side_Step_Walk.fbx", "start_s": 0.0, "end_s": 1.033, "yaw_deg": 18.8, "cycles": 3, "loco": true},
	"rk_loc_right": {"file": "res://assets/anim/mixamo_walk/Boxing_Side_Step_Walk.fbx", "start_s": 0.0, "end_s": 1.033, "yaw_deg": 11.6, "cycles": 3, "loco": true},
	"rk_loc_walk": {"file": "res://assets/anim/mixamo_walk/Standard_Walk.fbx", "start_s": 0.0, "end_s": 999.0, "yaw_deg": 0.0, "cycles": 8, "loco": true, "face_travel": true},
	## S399 operator: "can i see a proper walking animation". Mixamo boxing side steps and a walk back (assets/anim/mixamo_walk,
	## CREDITS.md), the same route; one loop of each, chained `cycles` times with the hips carried on (no snap back).
	"rk_walk_right": {"file": "res://assets/anim/mixamo_walk/Boxing_Side_Step_Walk.fbx", "start_s": 0.0, "end_s": 1.033, "yaw_deg": 11.6, "cycles": 4},
	"rk_walk_left": {"file": "res://assets/anim/mixamo_walk/Boxing_Left_Side_Step_Walk.fbx", "start_s": 0.0, "end_s": 1.033, "yaw_deg": 18.8, "cycles": 4},
	"rk_walk_back": {"file": "res://assets/anim/mixamo_walk/Walking_Backwards.fbx", "start_s": 0.0, "end_s": 0.85, "yaw_deg": 15.4, "cycles": 5},
}
const GUARDS := ["rk_guard", "rk_guard_b"]
## S405 proguard flip: the re-baked Punch PRO idle (RETARGET2B) is her guard under the Rokoko punches, its fidgets come
## back (GuardLife), and both play pure like a captured clip. `-- noproguard` goes back to the Rokoko guard windows.
const PRO_GUARDS := ["pro_idle"]
const PRO_FIDGETS := ["pro_idle_fidget_v1", "pro_idle_fidget_v2", "pro_idle_fidget_v3", "pro_idle_fidget_v6", "pro_idle_fidget_v7",
	"pro_idle_fidget_v8"]
static var pro_guard := not OS.get_cmdline_user_args().has("noproguard")
const WALKS := ["rk_walk_right", "rk_walk_left", "rk_walk_back"]
## Which captured takes a beat's punch plays (BeatClips.punch): the plain jab and cross; a big shot, a miss, a tired punch
## keep their Punch PRO takes (no Rokoko take shows those).
const PUNCH := {"jab": ["rk_jab"], "cross": ["rk_cross"]}
## The hips carry the take's own floor travel (RkRetarget.build carry_xz); `-- rkhold` = the old route (height only).
static var carry_xz := not OS.get_cmdline_user_args().has("rkhold")


## A test of another layer may run on the Punch PRO set (tests/ring_feet_test.gd: the footwork rig on the Pro guard).
static var enabled := not OS.get_cmdline_user_args().has("norokoko")


static func on() -> bool:
	return enabled


## The Punch PRO guard only runs with the captured route: a test of the footwork rig sets `enabled` off and needs the rig on pro_idle.
static func pro_on() -> bool:
	return enabled and pro_guard


## The clips that count as her guard right now.
static func guards() -> Array:
	return PRO_GUARDS if pro_on() else GUARDS


## One of THESE captured clips. Not a prefix test: the corner warm-up's owned bakes are named rk_boxing / rk_shadowboxing_*
## (tools/owned_mocap_bake.gd, the broken S381 route) - played "pure" they showed their twisted, extended legs raw (operator
## S399 on the corner wide: "right leg looks wierd why it is extended and twisted?").
static func is_rk(clip: String) -> bool:
	return CLIPS.has(clip) or (pro_on() and (clip in PRO_GUARDS or clip in PRO_FIDGETS))


## Adds every window to `lib` on `skel` (tracks prefixed `prefix:`). Returns the names added.
static func load_into(lib: AnimationLibrary, skel: Skeleton3D, prefix: String, body: Node3D = null) -> Array:
	var added: Array = []
	if not on():
		return added
	for name in CLIPS:
		var anim := build(skel, str(name))
		if anim == null:
			continue
		if bool((CLIPS[name] as Dictionary).get("loco", false)) and body != null:
			RkLoco.register(str(name), anim, skel, body, int((CLIPS[name] as Dictionary).get("cycles", 1)))
		for t in anim.get_track_count():
			anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
		lib.add_animation(name, anim)
		added.append(name)
	return added


## One window on `skel`, turned to face +Z (track paths are bare bone names). `yaw_override`: a probe's own turn.
static func build(skel: Skeleton3D, name: String, yaw_override: float = INF) -> Animation:
	var w: Dictionary = CLIPS[name]
	var anim := RkRetarget.build(skel, str(w.get("file", DIR + str(w.get("take", "")) + "_mixamo.fbx")), float(w["start_s"]), float(w["end_s"]), carry_xz)
	if anim == null:
		push_error("RkClips: %s did not build" % name)
		return null
	if bool(w.get("mirror", false)):
		anim = mirrored(anim, skel)
	var yaw := float(w["yaw_deg"]) if yaw_override == INF else yaw_override
	if bool(w.get("face_travel", false)) and yaw_override == INF:
		yaw = travel_yaw(anim, skel)   # a plain walk: she faces the way she walks
	turn(anim, skel, yaw)
	if int(w.get("cycles", 1)) > 1:
		anim = chain(anim, int(w["cycles"]))
	anim.loop_mode = Animation.LOOP_NONE   # S274: a guard window never loops (a wrap restarts the actor's rhythm)
	anim.set_meta("rokoko_clip", true)
	return anim


## The turn (deg) that points the clip's hip floor travel along +Z.
static func travel_yaw(anim: Animation, skel: Skeleton3D) -> float:
	for t in anim.get_track_count():
		if anim.track_get_type(t) == Animation.TYPE_POSITION_3D and str(anim.track_get_path(t)) == "Hips":
			var hips := skel.find_bone("Hips")
			var parent := skel.get_bone_parent(hips)
			var pb: Basis = skel.get_bone_global_rest(parent).basis if parent >= 0 else Basis.IDENTITY
			var d: Vector3 = pb * ((anim.track_get_key_value(t, anim.track_get_key_count(t) - 1) as Vector3) - (anim.track_get_key_value(t, 0) as Vector3))
			return -rad_to_deg(atan2(d.x, d.z))
	return 0.0


## Old FightClipRokoko.turn: the Hips rotation and position keys turned about +Y, in the Hips' parent space.
static func turn(anim: Animation, skel: Skeleton3D, yaw_deg: float) -> void:
	if absf(yaw_deg) < 0.01:
		return
	var hips := skel.find_bone("Hips")
	var parent := skel.get_bone_parent(hips)
	var to_parent: Basis = skel.get_bone_global_rest(parent).basis if parent >= 0 else Basis.IDENTITY
	var r: Basis = to_parent.inverse() * Basis(Vector3.UP, deg_to_rad(yaw_deg)) * to_parent
	var rq := r.get_rotation_quaternion()
	for t in anim.get_track_count():
		if str(anim.track_get_path(t)) != "Hips":   # called before the tracks get the skeleton prefix
			continue
		for k in anim.track_get_key_count(t):
			if anim.track_get_type(t) == Animation.TYPE_ROTATION_3D:
				anim.track_set_key_value(t, k, (rq * (anim.track_get_key_value(t, k) as Quaternion)).normalized())
			elif anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				anim.track_set_key_value(t, k, r * (anim.track_get_key_value(t, k) as Vector3))


## A loop played `n` times end to end: each pass starts where the last left the hips on the floor (its last key is the
## next pass's first, so that key is not doubled).
static func chain(one: Animation, n: int) -> Animation:
	var out := Animation.new()
	var span := one.length
	out.length = span * n
	out.step = one.step
	for t in one.get_track_count():
		var nt := out.add_track(one.track_get_type(t))
		out.track_set_path(nt, one.track_get_path(t))
		var is_pos := one.track_get_type(t) == Animation.TYPE_POSITION_3D
		var travel := Vector3.ZERO
		if is_pos and one.track_get_key_count(t) > 1:
			var d: Vector3 = one.position_track_interpolate(t, span) - (one.track_get_key_value(t, 0) as Vector3)
			travel = Vector3(d.x, 0.0, d.z)
		for c in n:
			for k in one.track_get_key_count(t):
				var at := one.track_get_key_time(t, k)
				if c > 0 and at <= 0.0001:
					continue
				var v: Variant = one.track_get_key_value(t, k)
				if is_pos:
					v = (v as Vector3) + travel * c
				out.track_insert_key(nt, at + span * c, v)
	for k in one.get_meta_list():
		out.set_meta(k, one.get_meta(k))
	return out


## The take mirrored left for right on `skel` (MirrorClip; tracks keep bare bone names).
static func mirrored(anim: Animation, skel: Skeleton3D) -> Animation:
	for t in anim.get_track_count():
		anim.track_set_path(t, NodePath("S:" + str(anim.track_get_path(t))))
	var m := MirrorClip.mirror(anim, skel, MirrorClip._plane(skel))
	for a in [anim, m]:
		for t in (a as Animation).get_track_count():
			(a as Animation).track_set_path(t, NodePath(str((a as Animation).track_get_path(t)).get_slice(":", 1)))
	m.length = anim.length
	m.step = anim.step
	for k in anim.get_meta_list():
		m.set_meta(k, anim.get_meta(k))
	return m


## BeatClips rows for a captured punch: {"contact_s", "hand"}; {} for a guard or another clip.
static func row(clip: String) -> Dictionary:
	var w: Dictionary = CLIPS.get(clip, {})
	return {"contact_s": float(w["contact_s"]), "hand": str(w["hand"])} if w.has("contact_s") else {}


## A captured punch for beat `move` (one of PUNCH by `roll` 0..1), or "" when there is none / it is not loaded.
static func punch(move: String, roll: float, has: Callable) -> String:
	var pool: Array = PUNCH.get(move, []).filter(func(n): return has.call(str(n)))
	return "" if pool.is_empty() else str(pool[clampi(int(roll * pool.size()), 0, pool.size() - 1)])
