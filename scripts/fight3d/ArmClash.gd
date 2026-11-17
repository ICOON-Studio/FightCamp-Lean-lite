extends SkeletonModifier3D
## S468 (owner C394, "still clipping"): runs GloveClear's arm-against-arm clearance (clash_pass) as the LAST arm layer,
## after ElbowClear. GloveClear itself sits mid-stack for the heads; ElbowClear then moved her elbows 2-18 cm, and since
## the glove follows the forearm, gloves cleared before it were drawn back inside the other's (tools/clash_meter.gd).
##   attach(skel, gclear, after) -> the modifier, placed right after `after` (ElbowClear)
## S510 EASED (tools/hand_tap.gd on join_return_test: a guard wrist jumped 12-20 cm in ONE 60 fps frame whenever a punch
## passed it, every one of them this layer - the clearance leaves all of an overlap at once - and 28-45 cm a frame, back
## and forth, once the free glove was held lower at the chin (GuardTuck.FREE_DROP_M) and sat in a pinch the passes could
## not solve: join_return pro_right_cross 31.7 m/s). What the clearance moves a wrist by is now eased: it may change by
## at most STEP_MPS a second from the frame before and is never more than MAX_M in all. A glove may sit a little in the
## other's arm for a frame or two; it never pops. `-- noclashease` = the control arm.

const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")
const STEP_MPS := 2.4    # 4 cm a 60 fps frame, 8 cm a 30 fps frame (HeadClear's own rise speed)
const MAX_M := 0.16

static var eased: bool = not OS.get_cmdline_user_args().has("noclashease")

var gclear: Node = null
var _off := {}   # side -> the offset shown last frame (skeleton space)
var _frame := -1


static func attach(skel: Skeleton3D, gc: Node, after: Node) -> Node:
	if gc == null or after == null or after.get_parent() != skel:
		return null
	var ac: SkeletonModifier3D = (load("res://scripts/fight3d/ArmClash.gd") as GDScript).new()
	ac.name = "ArmClash"
	ac.set("gclear", gc)
	skel.add_child(ac)
	skel.move_child(ac, after.get_index() + 1)
	gc.set("clash_late", true)
	return ac


func _process_modification() -> void:
	if gclear == null or not is_instance_valid(gclear):
		return
	var skel := get_skeleton()
	var arms: Dictionary = gclear.get("_arms")
	if not eased or skel == null or arms.is_empty():
		gclear.call("clash_pass")
		return
	var before := {}
	for side in arms:
		before[side] = skel.get_bone_global_pose(int(arms[side][2])).origin
	gclear.call("clash_pass")
	var f := Engine.get_process_frames()
	var fresh := f != _frame   # a second pass of the stack in one frame shows the same offset again
	var k := maxf(skel.global_transform.basis.get_scale().x, 1e-4)
	var step := STEP_MPS * get_process_delta_time() / k
	for side in arms:
		var ids: Array = arms[side]
		var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
		var want: Vector3 = (g_hd.origin - (before[side] as Vector3)).limit_length(MAX_M / k)
		var prev: Vector3 = _off.get(side, Vector3.ZERO)
		var show: Vector3 = prev.move_toward(want, step) if fresh else prev
		_off[side] = show
		if show.distance_to(g_hd.origin - (before[side] as Vector3)) < 0.002 / k:
			continue
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		var l1 := s.distance_to(skel.get_bone_global_pose(int(ids[1])).origin)
		var l2 := skel.get_bone_global_pose(int(ids[1])).origin.distance_to(g_hd.origin)
		PunchReach.solve(skel, ids, s, (before[side] as Vector3) + show, l1, l2, g_hd.basis)
	_frame = f
