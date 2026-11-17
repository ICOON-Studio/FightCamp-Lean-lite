extends SkeletonModifier3D
## S497 FIGHT MOTION WEEK - the punching arm comes home ahead of the body. Both blind critics on the r0 film: "arms parked
## at full extension ... blue's jab goes out and stays out about 9 frames ... red's straight right sits on blue's gloves
## for ~14 frames ... A real jab is out and back in a quarter of a second." tools/fight_motion_rulers.py: the arm stays
## out 6 frames after contact (median), 14 worst. The clips are bag work: the glove travels on up to 0.13 s past the
## contact, and the recovery plays at most RECOVER_MAX 1.5x because faster the WHOLE body played at the hand's speed (S376).
## So only the arm runs ahead: after the punch's contact the shoulder, upper arm, forearm and hand take the clip's own pose
## from AHEAD times as far past the contact as the body is, never past the moment the clip is back in guard (there the arm
## waits for the body). It is the clip's own way home, sooner. Applied as the clip's change between the two times on top
## of the pose as it stands, so a layer that already moved the arm keeps its move. Before PunchReach in the stack: the
## reach reads this arm as "the clip's glove" and lets the landed glove go when it comes back.
## `-- noarmhome` = the control arm.
##   setup(skel, ap, reach) -> bool      arm_time(t, contact, back, ahead) -> seconds (pure)
## S510 ANIMATION LOOP (blind r12, both critics' first change: "arm home within 3-4 frames, never held over 2"; the ruler's
## worst 29 frames, median 5): two holes. (1) Only a punch PunchReach armed came home early: a missed or blocked punch
## played the bag clip's own hold (r12 red's cross ex1 #40-47: hand 0.51-0.55 m from the shoulder for 9 frames). Now every
## punch clip does - the reach's contact when it is armed on it, else the clip's measured contact. (2) AHEAD x the clip's
## own way still kept the clip's hold: the cross's hand stays out from 0.18 s to ~0.6 s of the clip, so 1.5x was ~7 frames
## out. Now the arm runs on its OWN clock from the contact (real seconds while the clip plays): to the clip's peak in OUT_S,
## then the clip's way home over RETURN_S (Undisputed: hands back 0.11-0.17 s after impact; BeatClips S301 note).
## `-- oldarmhome` = the S497 rule (control arm).
##   arm_time_real(t, r, contact, peak, back) -> seconds (pure)

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

const AHEAD := 1.5
const OUT_S := 0.05      # contact -> the clip's furthest point (the carry through), real seconds
const RETURN_S := 0.13   # the furthest point -> back in guard, real seconds
const GuardTuck := preload("res://scripts/fight3d/GuardTuck.gd")
static var old_rule: bool = OS.get_cmdline_user_args().has("oldarmhome")
const PARTS := ["Shoulder", "UpperArm", "LowerArm", "Hand"]

static var on: bool = not OS.get_cmdline_user_args().has("noarmhome")

var ap: AnimationPlayer
var reach: Node
var _tracks := {}        # clip -> {bone index: track index}
var ahead_s := 0.0       # probes: how far ahead of the body the arm is now, clip seconds
var lead := "LeftHand"   # BoxerBuild: her lead hand (a southpaw's clips are mirrored: the punching hand flips)
var _seen := ""          # the clip the clock below belongs to
var _last_t := -1.0
var _real := -1.0        # real seconds the clip has played past its contact (-1 = not yet)


func setup(skel: Skeleton3D, player: AnimationPlayer, punch_reach: Node) -> bool:
	ap = player
	reach = punch_reach
	return on and ap != null and reach != null and skel.find_bone("LeftUpperArm") >= 0


## The clip time the punching arm is shown at when the body is at `t`: `t` up to the contact; past it, AHEAD times as far
## on, never past `back` (the clip back in guard); from `back` on, `t` again.
static func arm_time(t: float, contact: float, back: float, ahead: float) -> float:
	if t <= contact or back <= contact or t >= back:
		return t
	return minf(contact + (t - contact) * ahead, back)


## S510: the clip time the punching arm is shown at, `r` real seconds after the contact (body at clip time `t`): the clip's
## contact -> its peak over OUT_S, then the peak -> back over RETURN_S; never behind the body, never past `back`; before
## the contact, and from `back` on, `t`.
static func arm_time_real(t: float, r: float, contact: float, peak: float, back: float) -> float:
	if t <= contact or back <= contact or t >= back or r < 0.0:
		return t
	var ta := 0.0
	if peak <= contact or peak >= back:   # no further point (or a landed punch: the reach carries it through): straight home
		ta = contact + (back - contact) * minf(r / RETURN_S, 1.0)
	elif r <= OUT_S:
		ta = contact + (peak - contact) * r / OUT_S
	else:
		ta = peak + (back - peak) * minf((r - OUT_S) / RETURN_S, 1.0)
	return clampf(ta, t, back)


## The punching hand of `clip` and its contact (clip seconds): the reach's when it is armed on it, else the clip's own.
func _punch(clip: String) -> Array:
	if str(reach.get("_clip")) == clip:   # third: it LANDS - the reach carries the glove through, the arm goes straight home
		return [str(reach.get("_hand")), float(reach.get("_contact")), float(reach.get("_thru")) > 0.0 and not bool(reach.get("_height_only"))]
	var free := GuardTuck.free_of(clip, lead)
	var c := BeatClips.recovery(clip).x
	if free == "" or c <= 0.0:
		return []
	return ["RightHand" if free == "LeftHand" else "LeftHand", c, false]


func _process_modification() -> void:
	ahead_s = 0.0
	var skel := get_skeleton()
	if skel == null or ap == null or reach == null:
		return
	var clip := str(ap.assigned_animation)
	if old_rule:
		clip = str(reach.get("_clip"))
		if clip == "" or str(ap.assigned_animation) != clip or not ap.has_animation(clip):
			return
	if clip == "" or not ap.has_animation(clip):
		_seen = ""
		return
	var pu := [str(reach.get("_hand")), float(reach.get("_contact")), false] if old_rule else _punch(clip)
	if pu.is_empty():
		_seen = ""
		return
	var anim := ap.get_animation(clip)
	var t := ap.current_animation_position
	var contact := float(pu[1])
	var back := BeatClips.recovery(clip).y
	if back <= contact:
		back = anim.length
	var ta := t
	if old_rule:
		ta = arm_time(t, contact, back, AHEAD)
	else:
		# Her own clock: restarts with a new clip (or the same clip played again), runs only while the clip plays (a
		# hit-stop or HitImpact's held contact holds it too).
		if clip != _seen or t < _last_t - 1e-4:
			_seen = clip
			_real = -1.0
		if t > contact:
			if _real < 0.0:
				_real = (t - contact) / maxf(absf(ap.get_playing_speed()), 0.1)
			elif t > _last_t + 1e-5:
				_real += get_process_delta_time()
		_last_t = t
		ta = arm_time_real(t, _real, contact, -1.0 if bool(pu[2]) else BeatClips.peak(clip), back)
	if ta <= t + 1e-4:
		return
	ahead_s = ta - t
	var side := str(pu[0]).trim_suffix("Hand")
	var tr: Dictionary = _for(skel, anim, clip)
	for part in PARTS:
		var b := skel.find_bone(side + part)
		if b < 0 or not tr.has(b):
			continue
		var was: Quaternion = anim.rotation_track_interpolate(int(tr[b]), t)
		var will: Quaternion = anim.rotation_track_interpolate(int(tr[b]), ta)
		skel.set_bone_pose_rotation(b, skel.get_bone_pose_rotation(b) * (was.inverse() * will))


## The rotation track of each bone in `clip` (found once a clip).
func _for(skel: Skeleton3D, anim: Animation, clip: String) -> Dictionary:
	if _tracks.has(clip):
		return _tracks[clip]
	var out := {}
	for i in anim.get_track_count():
		if anim.track_get_type(i) != Animation.TYPE_ROTATION_3D:
			continue
		var path := anim.track_get_path(i)
		if path.get_subname_count() == 0:
			continue
		var b := skel.find_bone(str(path.get_subname(0)))
		if b >= 0:
			out[b] = i
	_tracks[clip] = out
	return out
