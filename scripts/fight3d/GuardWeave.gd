extends SkeletonModifier3D
## S391 (operator: "i do not see leaning sidestepping and all these movements fighters do when they are not throwing"): the
## trunk never left the line between punches. Each boxer now keeps a weave position (x = to her own left, y = dipped forward):
## it wanders on its own between punches. The round's slips and pulls stay BeatFire's defence clips (every punch that does not
## land already gets one, and one that lands must not see her head leave it), so this layer never reacts to a punch.
## Structure benchmarked on Undisputed's names only (a weave position, a minimum time between changes of direction, a limit);
## the values below are ours. Runs after TiredSag, before GuardTuck, so the guard follows the
## face. Off (eased) while she punches, is hit, falls or clinches: only `free_clips` let it run. `-- noweave` = the control arm.
##   setup(skel, ap, free_clips, seed)   pos   step(dt, free)

const SPOTS := [0.0, 0.25, -0.25, 0.5, -0.5]   # where a passive move settles, across the line
const DIPS := [0.0, 0.0, 0.25, 0.45]           # and how far she sinks
const HOLD_S := Vector2(0.35, 1.1)             # the least time between changes of direction
const PASSIVE_TAU_S := 0.16
## S391 blind judge: "rises out of a lean or duck are too fast". Coming up takes longer than going down, in both ways out.
const RISE_TAU_S := 0.32
const EASE_S := 0.22
const EASE_OFF_S := 0.4
## At pos 1: the trunk's side bend (half on the spine, half on the chest), the head's share taken back so her eyes stay level,
## the forward dip and the hips' sideways and downward shift.
const LEAN_DEG := 17.0
const DIP_DEG := 15.0
const GAZE := 0.55
const HIPS_SIDE_M := 0.06
const HIPS_DOWN_M := 0.12

var ap: AnimationPlayer = null
var free_clips: Array = []
var pos := Vector2.ZERO
var weight := 0.0
var rng := RandomNumberGenerator.new()
var _target := Vector2.ZERO
var _hold := 0.0
var _b := {}


func setup(skel: Skeleton3D, player: AnimationPlayer, clips: Array, seed: int) -> bool:
	ap = player
	free_clips = clips
	rng.seed = seed
	_hold = rng.randf_range(HOLD_S.x, HOLD_S.y)
	for n in ["Hips", "Spine", "Chest", "Neck", "Head", "LeftUpperArm", "RightUpperArm"]:
		_b[n] = skel.find_bone(n)
		if int(_b[n]) < 0:
			return false
	return true


## One frame of the weave. Pure: no bones. `free` = she stands in a clip the weave may run over.
func step(dt: float, free: bool) -> void:
	weight = move_toward(weight, 1.0 if free else 0.0, dt / (EASE_S if free else EASE_OFF_S))
	_hold -= dt
	if _hold <= 0.0:
		_hold = rng.randf_range(HOLD_S.x, HOLD_S.y)
		_target = Vector2(SPOTS[rng.randi() % SPOTS.size()], DIPS[rng.randi() % DIPS.size()])
	pos = pos.lerp(_target, 1.0 - exp(-dt / (RISE_TAU_S if _target.y < pos.y else PASSIVE_TAU_S)))


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or ap == null:
		return
	var clip := str(ap.assigned_animation)
	step(get_process_delta_time(), free_clips.has(clip))
	if weight <= 0.001:
		return
	var w := weight * weight * (3.0 - 2.0 * weight)
	var at := func(n: String) -> Vector3: return skel.get_bone_global_pose(int(_b[n])).origin
	var up: Vector3 = (at.call("Chest") - at.call("Hips")).normalized()
	var left: Vector3 = (at.call("LeftUpperArm") - at.call("RightUpperArm")).normalized()
	var fwd := left.cross(up).normalized()
	var hips := int(_b["Hips"])
	var parent := skel.get_bone_parent(hips)
	var to_parent: Basis = skel.get_bone_global_pose(parent).basis.inverse() if parent >= 0 else Basis.IDENTITY
	var shift: Vector3 = left * (pos.x * HIPS_SIDE_M * w) - up * (pos.y * HIPS_DOWN_M * w)
	skel.set_bone_pose_position(hips, skel.get_bone_pose_position(hips) + to_parent * shift)
	var bend := deg_to_rad(LEAN_DEG) * pos.x * w
	var dip := deg_to_rad(DIP_DEG) * pos.y * w
	for n in ["Spine", "Chest"]:
		_turn(skel, int(_b[n]), fwd, -bend * 0.5)
		_turn(skel, int(_b[n]), left, dip * 0.5)
	_turn(skel, int(_b["Neck"]), fwd, bend * GAZE)
	_turn(skel, int(_b["Neck"]), left, -dip * GAZE)


## Turns `bone` about its own origin by `angle` around `axis` (skeleton space).
func _turn(skel: Skeleton3D, bone: int, axis: Vector3, angle: float) -> void:
	var g: Transform3D = skel.get_bone_global_pose(bone)
	skel.set_bone_global_pose(bone, Transform3D(Basis(Quaternion(axis, angle)) * g.basis, g.origin))
