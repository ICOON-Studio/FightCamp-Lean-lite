extends RefCounted
## S390 (judge: "Liam lies through the corner post, his head past the canvas"): a fall near the ropes carried the body out of the ring;
## nothing kept a downed boxer inside. Every frame of a knockdown the bones are measured and the body slides back in, on the canvas.

const INSIDE_M := 0.35   # the bones stay this far inside the ring's edge
const EASE_S := 0.12
const CLEAR_M := 0.75   # the standing boxer's middle stays this far from any bone of the man on the canvas
const CLEAR_EASE_S := 0.18
const BONES := ["Head", "Hips", "LeftHand", "RightHand", "LeftFoot", "RightFoot"]


## How far `skel`'s bones stand past `half` metres from the ring's middle, as the flat move that brings them back.
static func back_in(skel: Skeleton3D, half: float) -> Vector3:
	var lim := half - INSIDE_M
	var out := Vector3.ZERO
	for b in BONES:
		var i := skel.find_bone(b)
		if i < 0:
			continue
		var p := skel.global_transform * skel.get_bone_global_pose(i).origin
		out.x = minf(out.x, lim - p.x) if p.x > lim else (maxf(out.x, -lim - p.x) if p.x < -lim else out.x)
		out.z = minf(out.z, lim - p.z) if p.z > lim else (maxf(out.z, -lim - p.z) if p.z < -lim else out.z)
	return out


static func keep(node: Node3D, skel: Skeleton3D, half: float, delta: float) -> void:
	node.position += back_in(skel, half) * (1.0 - exp(-delta / EASE_S))


## S390 (three judges: "Danny stands inside the fallen Liam", his shin through Danny's thigh): he falls toward the man who hit him, and a
## route only goes round a body that has landed. While a man is down the other is kept CLEAR_M from every bone of him, in the ring.
static func away(down: Skeleton3D, stander: Vector3) -> Vector3:
	var out := Vector3.ZERO
	for b in BONES:
		var i := down.find_bone(b)
		if i < 0:
			continue
		var p := down.global_transform * down.get_bone_global_pose(i).origin
		var d := Vector3(stander.x - p.x, 0.0, stander.z - p.z)
		var gap := d.length()
		if gap < CLEAR_M:
			var dir := d.normalized() if gap > 0.01 else Vector3.RIGHT
			var need := dir * (CLEAR_M - gap)
			out = need if need.length() > out.length() else out
	return out


static func clear(node: Node3D, down: Skeleton3D, half: float, delta: float) -> void:
	var to := node.position + away(down, node.global_position) * (1.0 - exp(-delta / CLEAR_EASE_S))
	var lim := half - INSIDE_M
	node.position = Vector3(clampf(to.x, -lim, lim), to.y, clampf(to.z, -lim, lim))
