extends RefCounted
## S501 (owner, on the fight's start: "when the fighters walk to the center their shoulders look weird"): the walk to the
## centre plays the captured Mixamo Standard Walk (CornerCrew.walk, rk_loc_walk) on a boxer in gloves. Seen on the film
## (E:/FightCamp/tmp/s501/walk, blueb #1-#12): the shoulders roll forward and down into a slouch, the head bowed, the arms
## swing out wide (the gloves held off the hips) and then cross in front of the hips, the gloves meeting.
## While she walks: the collarbones ease to their rest turn (CornerIK.loosen, not the neck), she looks at the other boxer,
## the trunk a little upright, and each
## glove follows the clip's own swing but is kept beside its own thigh - never further in than IN_M, never further out than
## OUT_M from the hips' middle, forward/back within SWING_M. Released on arrival, before the guard and the glove touch.
##   hold(a)   release(a)        `-- nowalkarms` = the walk as captured (the control arm).

const CornerShots := preload("res://scripts/fight3d/CornerShots.gd")

const LOOSE := 0.8           # of the way to the collarbones' and neck's rest turn
const UPRIGHT_DEG := 6.0     # the trunk tipped back out of the slouch
const IN_M := 0.21           # a glove's centre at least this far out from the hips' middle (beside the thigh, not in front)
const OUT_M := 0.27          # ... and no further (no flare)
const SWING_M := Vector2(-0.14, 0.20)   # back / forward of the hips, as the clip swings it
const DROP_M := 0.02         # the glove no higher than this below the hips bone's height...
const LOW_M := 0.30          # ... and no lower than this

static var on: bool = not OS.get_cmdline_user_args().has("nowalkarms")


static func hold(a: Dictionary, other: Dictionary = {}) -> void:
	var ik: Object = a.get("ik")
	if not on or ik == null:
		return
	if OS.get_cmdline_user_args().has("walkarmstrace"):
		var names := []
		for c in (a["skel"] as Skeleton3D).get_children():
			names.append("%s%s" % [c.name, "" if not (c is SkeletonModifier3D) else "(%s %.2f)" % [str((c as SkeletonModifier3D).active), (c as SkeletonModifier3D).influence]])
		print("WALKARMS chain ", names)
	ik.loosen(LOOSE, false)   # the collarbones only: the neck's rest turn bows her head
	ik.upright(UPRIGHT_DEG)
	if not other.is_empty():
		ik.look(func() -> Vector3: return CornerShots.bone(other, "Head"))   # boxers eye each other on the way in
	for hand in ["Left", "Right"]:
		ik.reach(hand, func() -> Vector3: return glove_at(a, hand))


static func release(a: Dictionary) -> void:
	var ik: Object = a.get("ik")
	if not on or ik == null:
		return
	for hand in ["Left", "Right"]:
		ik.reach(hand, null)
	ik.upright(0.0)
	ik.loosen(0.0)
	ik.look(null)


## Where her `hand` glove goes this frame: the clip's hand, kept in the band beside her own thigh.
static func glove_at(a: Dictionary, hand: String) -> Vector3:
	var s: float = (a["node"] as Node3D).scale.x
	var hips := CornerShots.bone(a, "Hips")
	var clip := CornerShots.bone(a, hand + "Hand")
	# The glove's side is its own shoulder's: a southpaw's body may be mirrored, so "Left" can hang on her right.
	var side := CornerShots.side(a)
	var out := 1.0 if (CornerShots.bone(a, hand + "UpperArm") - hips).dot(side) >= 0.0 else -1.0
	var got := clamp_beside(clip, hips, CornerShots.fwd(a), side, out, s)
	if OS.get_cmdline_user_args().has("walkarmstrace") and Engine.get_process_frames() % 6 == 0:
		var d := clip - hips
		print("WALKARMS %s out %+.0f anim %s hand side %+.3f fwd %+.3f y %+.3f -> target side %+.3f (scale %.2f)" % [hand, out,
			str((a["ap"] as AnimationPlayer).current_animation), d.dot(CornerShots.side(a)), d.dot(CornerShots.fwd(a)), d.y,
			(got - hips).dot(CornerShots.side(a)), s])
	return got


## Pure: `p` kept in the band beside the thigh on side `out` (+1 her left, -1 her right) of the hips at `hips`.
static func clamp_beside(p: Vector3, hips: Vector3, fwd: Vector3, side: Vector3, out: float, s: float) -> Vector3:
	var d := p - hips
	var f := clampf(d.dot(fwd), SWING_M.x * s, SWING_M.y * s)
	var o := clampf(d.dot(side) * out, IN_M * s, OUT_M * s)
	var y := clampf(d.y, -LOW_M * s, -DROP_M * s)
	return hips + fwd * f + side * (o * out) + Vector3.UP * y
