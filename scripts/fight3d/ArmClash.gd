extends SkeletonModifier3D
## S468 (owner C394, "still clipping"): runs GloveClear's arm-against-arm clearance (clash_pass) as the LAST arm layer,
## after ElbowClear. GloveClear itself sits mid-stack for the heads; ElbowClear then moved her elbows 2-18 cm, and since
## the glove follows the forearm, gloves cleared before it were drawn back inside the other's (tools/clash_meter.gd).
##   attach(skel, gclear, after) -> the modifier, placed right after `after` (ElbowClear)

var gclear: Node = null


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
	if gclear != null and is_instance_valid(gclear):
		gclear.call("clash_pass")
