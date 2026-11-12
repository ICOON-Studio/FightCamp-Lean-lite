extends SkeletonModifier3D
## POWER1 (owner S439: "the torso needs to follow the hands movemnt to show thepower behind the shot", "the punches do not
## feellike the y have power"). Every punch clip played in place (FightClips.hold_root_xz pins the hips at their first
## X/Z), so the arm moved and the body stood still: the plain jab lost the 7 cm its capture moves the hips forward, the
## crosses all of theirs, the rear uppercut 10 cm, a landed cross showed 0 cm of body travel against a real 28 cm
## (ops/research/CROSS_POWER_S439.md). Two layers put the body back into the punch, and neither moves her place on the
## canvas (bx.pos, the gap, every fight rule):
##   1. her OWN travel: while a punch clip plays, its hips get back the forward part of their captured path (the baked
##      file's keys before the pin, as offsets from its first key). The capture's legs were made for that path, and every
##      one of these clips brings the hips home by its end (0-3 cm). A clip whose hips go further than MAX_TRAVEL_M (the
##      kidney shot's 0.56 m lunge) stays thrown in place.
##      Runs FIRST in the stack, before the join smoother, so a join blends it like any pose.
##   2. a landed cross or hook CARRIES her body toward the target (carry_now, metres): shown only, through RingPlace's
##      punch lunge, so the body keep and the footwork rig's planted feet hold as for any lunge. It tops her own travel up
##      to CARRY_TO_M by the contact - inside a shipped game's band for its long-range and power takes, 0.07-0.16 m
##      (REFERENCE_DISTANCES_S439.md, Undisputed R2 0.07-0.16, power 0.09-0.13) - is still moving at the hit (80 % of it
##      there, the rest THRU_S after: the body goes through the target) and is given back by the clip's return to guard.
## `-- nopunchweight` = the control arm (today's pinned hips, no carry).
##   setup(skel, ap) -> bool   arm(clip)  (FightStage.play)   carry(clip, contact)  (FightStage.land)
##   tick(delta) -> metres (RingPlace, once a frame)   travel(clip) -> PackedVector3Array (probes)

const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

const WORDS := ["jab", "cross", "hook", "uppercut", "body_shot"]
const MAX_TRAVEL_M := 0.20
const RATE := 60.0
## The body's travel by the contact a landed punch is topped up to (metres): the middle of the shipped power band for the
## straight rear hand, its lower edge for a hook (a hook turns more than it travels).
const CARRY_TO_M := {"cross": 0.11, "hook": 0.09}
const IN_S := 0.20       # clip seconds before the contact the carry starts (the drive, not the load)
const THRU_S := 0.08     # ... and after it, the carry still going (the body through the target)
const MIN_BACK_S := 0.15 # the shortest give-back
const FADE_S := 0.20     # a carry whose clip was cut off falls to 0 over this

static var on: bool = not OS.get_cmdline_user_args().has("nopunchweight")
static var _stems := {}

var ap: AnimationPlayer
var carry_now := 0.0
var _skel: Skeleton3D
var _hips := -1
var _to_parent := Basis.IDENTITY   # skeleton space -> the hips' parent space
var _paths := {}                   # clip -> PackedVector3Array (the hips' X/Z offset, parent space, RATE a second)
var _clip := ""
var _path := PackedVector3Array()
var _carry_m := 0.0
var _contact := 0.0
var _end := 0.0
var _fade := -1.0                  # seconds into a fade, -1 = none
var _fade_from := 0.0


static func set_on(v: bool) -> void:
	on = v


func setup(skel: Skeleton3D, player: AnimationPlayer) -> bool:
	_skel = skel
	ap = player
	_hips = skel.find_bone("Hips")
	if _hips < 0:
		return false
	var p := skel.get_bone_parent(_hips)
	_to_parent = (skel.get_bone_global_rest(p).basis.orthonormalized() if p >= 0 else Basis.IDENTITY).inverse()
	return true


## A clip starts (FightStage.play): a punch clip gets its own hips travel back; anything else drops the carry.
func arm(clip: String) -> void:
	_drop()
	_carry_m = 0.0
	_clip = ""
	if not on or not is_punch(clip):
		return
	_path = travel(clip)
	if not _path.is_empty():
		_clip = clip


## The punch on the clip that is playing LANDS (FightStage.land): a cross or hook carries her body in by the contact.
func carry(clip: String, contact: float) -> void:
	if not on or clip != str(ap.assigned_animation):
		return
	var to := 0.0
	for w in CARRY_TO_M:
		if clip.contains(str(w)) and not clip.contains("body"):
			to = float(CARRY_TO_M[w])
	if to <= 0.0:
		return
	_carry_m = maxf(0.0, to - forward_at(contact))
	_contact = contact
	var length := ap.get_animation(clip).length
	var back := BeatClips.recovery(clip).y
	_end = minf(back if back > contact + THRU_S + MIN_BACK_S else length, length)
	_end = maxf(_end, contact + THRU_S + MIN_BACK_S)
	_clip = clip   # a clip with no travel of its own still carries


static func is_punch(clip: String) -> bool:
	if not clip.begins_with("pro_") or clip.contains("hit_by"):
		return false
	for w in WORDS:
		if clip.contains(str(w)):
			return true
	return false


## The carry toward the target now, metres (RingPlace adds it to the punch lunge). Once a frame.
func tick(delta: float) -> float:
	var fading := 0.0
	if _fade >= 0.0:
		_fade += delta
		var u := clampf(_fade / FADE_S, 0.0, 1.0)
		fading = _fade_from * (1.0 - u * u * (3.0 - 2.0 * u))
		if u >= 1.0:
			_fade = -1.0
	var live := 0.0
	if _carry_m > 0.0 and _clip != "":
		if str(ap.assigned_animation) == _clip:
			live = _carry_m * curve(ap.current_animation_position, _contact, _end)
		else:   # her clip was cut off (a hit, the clinch, the next move): what is left falls away
			_drop()
			fading = carry_now
			_carry_m = 0.0
			_clip = ""
	carry_now = maxf(fading, live)
	return carry_now


## 0..1 at clip time t: in over IN_S + THRU_S around the contact (still rising at it), back to 0 by `end`.
static func curve(t: float, contact: float, end: float) -> float:
	var a := contact - IN_S
	var p := contact + THRU_S
	if t <= a or t >= end:
		return 0.0
	var u := (t - a) / (p - a) if t < p else 1.0 - (t - p) / maxf(end - p, 0.01)
	u = clampf(u, 0.0, 1.0)
	return u * u * (3.0 - 2.0 * u)


## The hips' own forward travel at clip time t (metres, her front, at her body's scale).
func forward_at(t: float) -> float:
	if _clip == "" or _path.is_empty():
		return 0.0
	return (_to_parent.inverse() * _at(t)).z * _skel.global_transform.basis.get_scale().x


func _drop() -> void:
	if carry_now > 0.0:
		_fade_from = carry_now
		_fade = 0.0
	else:
		_fade = -1.0


func _process_modification() -> void:
	if not on or _clip == "" or _path.is_empty() or _hips < 0:
		return
	if str(ap.assigned_animation) != _clip:
		return
	var skel := get_skeleton()
	if skel == null:
		return
	skel.set_bone_pose_position(_hips, skel.get_bone_pose_position(_hips) + _at(ap.current_animation_position))


func _at(t: float) -> Vector3:
	var f := clampf(t * RATE, 0.0, float(_path.size() - 1))
	var i := mini(int(f), _path.size() - 2) if _path.size() > 1 else 0
	if _path.size() < 2:
		return _path[0] if _path.size() == 1 else Vector3.ZERO
	return _path[i].lerp(_path[i + 1], f - float(i))


## The hips' captured travel toward her front for a Pro clip on this body: offsets from its first key, in the hips' parent
## space (the space of the clip's position keys). Only the forward part: the brief is the body following the hand to the
## target, and a sideways shift moves the shoulder off the line the reach aims from (a blocked jab with the jab's 9 cm
## sideways shift met the block 8 cm short in 2 of 4 block_meet runs). Forward is the same mirrored, so a southpaw needs no
## mirror. Empty when the clip has no hips keys or travels further than MAX_TRAVEL_M.
func travel(clip: String) -> PackedVector3Array:
	if _paths.has(clip):
		return _paths[clip]
	var out := PackedVector3Array()
	_paths[clip] = out
	if _stems.is_empty():
		for s in FightClips.pro_stems():
			_stems[FightClips.pro_name(str(s))] = str(s)
	if not _stems.has(clip):
		return out
	var anim := load(FightClips.BAKED_DIR + str(_stems[clip]) + ".res") as Animation
	var tr := -1
	if anim != null:
		for t in anim.get_track_count():
			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D and str(anim.track_get_path(t)).get_slice(":", 1) == "Hips":
				tr = t
	if tr < 0:
		return out
	var to_skel := _to_parent.inverse()
	var first: Vector3 = anim.position_track_interpolate(tr, 0.0)
	var n := maxi(2, int(anim.length * RATE) + 1)
	var far := 0.0
	for s in n:
		var d: Vector3 = anim.position_track_interpolate(tr, minf(float(s) / RATE, anim.length)) - first
		var fwd := (to_skel * d).z   # skeleton +Z = her front
		far = maxf(far, absf(fwd))
		out.append(_to_parent * Vector3(0.0, 0.0, fwd))
	if far > MAX_TRAVEL_M:
		out = PackedVector3Array()
	_paths[clip] = out
	return out
