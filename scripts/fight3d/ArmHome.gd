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

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

const AHEAD := 1.5
const PARTS := ["Shoulder", "UpperArm", "LowerArm", "Hand"]

static var on: bool = not OS.get_cmdline_user_args().has("noarmhome")

var ap: AnimationPlayer
var reach: Node
var _tracks := {}        # clip -> {bone index: track index}
var ahead_s := 0.0       # probes: how far ahead of the body the arm is now, clip seconds


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


func _process_modification() -> void:
	ahead_s = 0.0
	var skel := get_skeleton()
	if skel == null or ap == null or reach == null:
		return
	var clip := str(reach.get("_clip"))
	if clip == "" or str(ap.assigned_animation) != clip or not ap.has_animation(clip):
		return
	var anim := ap.get_animation(clip)
	var t := ap.current_animation_position
	var contact := float(reach.get("_contact"))
	var back := BeatClips.recovery(clip).y
	var ta := arm_time(t, contact, back if back > contact else anim.length, AHEAD)
	if ta <= t + 1e-4:
		return
	ahead_s = ta - t
	var side := str(reach.get("_hand")).trim_suffix("Hand")
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
