extends SkeletonModifier3D
## S301 joins probe: the LAST modifier on a boxer's skeleton records the pose the viewer is shown this frame (the skeleton
## restores the raw animation pose after its modifiers, so reading bones from outside the stack never sees the join
## smoother, the elbow clear or the twists). fight3d_film.gd `joins=` reads `shown`.

var bones: PackedInt32Array = []
var shown: Dictionary = {}     # bone name -> Vector3, in the skeleton's space
var names: Array = []


func setup(skel: Skeleton3D, bone_names: Array) -> void:
	names = bone_names
	for n in bone_names:
		bones.append(skel.find_bone(str(n)))


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	for i in bones.size():
		shown[names[i]] = skel.get_bone_global_pose(bones[i]).origin
