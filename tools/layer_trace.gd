extends RefCounted
## S469 CLASH3: which layer moves a boxer's hands AFTER the arm-against-arm clearance (ArmClash)? clash_meter's `drift`
## read wrists 0.3 m from where the clearance left them on the frames that still clip. Every SkeletonModifier3D emits
## `modification_processed` when it has run: the wrists' world place is noted after each, and report() names every layer
## from `from_layer` on that moved a wrist more than MIN_M this frame.
##   LayerTrace.attach(stage)            once, when the stage exists
##   LayerTrace.report(stage) -> String  "0: FootLock L 0.212 R 0.198 | 1: -"

const MIN_M := 0.01
const HANDS := ["LeftHand", "RightHand"]

static var _log := {}   # skeleton instance id -> Array of [layer name, Vector3 left, Vector3 right], in run order this frame
static var _frame := {}


static func attach(stage: Node) -> void:
	for i in 2:
		var skel: Skeleton3D = stage.boxers[i]["skel"]
		var ids := [skel.find_bone(HANDS[0]), skel.find_bone(HANDS[1])]
		for ch in skel.get_children():
			if ch is SkeletonModifier3D:
				(ch as SkeletonModifier3D).modification_processed.connect(_note.bind(skel, ids, str(ch.name)))


static func _note(skel: Skeleton3D, ids: Array, layer: String) -> void:
	var key := skel.get_instance_id()
	var f := Engine.get_process_frames()
	if int(_frame.get(key, -1)) != f:
		_frame[key] = f
		_log[key] = []
	var xf := skel.global_transform
	(_log[key] as Array).append([layer, xf * skel.get_bone_global_pose(int(ids[0])).origin, xf * skel.get_bone_global_pose(int(ids[1])).origin])


static func report(stage: Node, from_layer: String = "ArmClash") -> String:
	var parts := []
	for i in 2:
		var rows: Array = _log.get((stage.boxers[i]["skel"] as Skeleton3D).get_instance_id(), [])
		var seen := false
		var moved := []
		for k in rows.size():
			var name := str(rows[k][0])
			if name == from_layer:
				seen = true
				continue
			if not seen or k == 0:
				continue
			var dl := (rows[k][1] as Vector3).distance_to(rows[k - 1][1])
			var dr := (rows[k][2] as Vector3).distance_to(rows[k - 1][2])
			if maxf(dl, dr) > MIN_M:
				moved.append("%s L %.3f R %.3f" % [name, dl, dr])
		parts.append("%d: %s" % [i, ", ".join(moved) if not moved.is_empty() else ("-" if seen else "no " + from_layer)])
	return " | ".join(parts)
