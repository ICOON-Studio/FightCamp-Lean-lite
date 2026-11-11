extends RefCounted
## The ring's ropes and posts made see-through where they stand in the lens's way (split from RingCamera, CAMLINE2):
## RingCamera.clear_view hands the lens and the ring side (FightStage._ring_side) here every frame.
##   clear(lens, ring_side, a, b, delta)
## CAMLINE2 (operator S429: "the fading effect you have on the background ropes looks weird when fighters head are at
## the same drawing height"; the probe on main: in every read a rope faded that was not between the lens and a boxer,
## and one rope showed two alphas). The rule is per ROPE and by the side of that rope the lens stands on:
##  - a rope can only be in the way of a lens that stands OUTSIDE its side of the ring (the count's lens, a film shot).
##    The live lens stands inside the ropes (S347), so in a round no rope fades: not the one a boxer leans on (it was
##    flagged by the 0.3 m margin round her body), not the ones behind the heads, not the near ones in the corner of
##    the picture (the S320 ramp by distance, which also left one rope with two alphas);
##  - from outside, a rope fades when the line from the lens to a boxer (her middle and BODY_HALF_M to each side)
##    crosses it at least BODY_SHORT_M before it reaches her - and then it fades WHOLE (S320: faded piece by piece it
##    broke into floating stubs). A post goes by the same rule with the S311 margin.

## S311 clear view: a post within this of the line from the lens to a boxer (stopped SIGHT_SHORT_M short of her).
const SIGHT_MARGIN_M := 0.3
const SIGHT_SHORT_M := 0.25
const BODY_HALF_M := 0.2
const BODY_SHORT_M := 0.2
## S311 (operator: "make the ropes transparent when they block in the view"): a blocking rope or post fades to SEE_ALPHA
## over FADE_S instead of vanishing, and back to solid when the view clears.
const SEE_ALPHA := 0.18
const FADE_S := 0.2


static func clear(lens: Vector3, ring_side: Array, a: Vector3, b: Vector3, delta: float = 0.0) -> void:
	var cam := Vector2(lens.x, lens.z)
	var gone := {}    # rope id -> true: it stands between the lens and a boxer
	var posts := {}   # post -> true
	for n in ring_side:
		var node := n as Node3D
		var c := Vector2(node.global_position.x, node.global_position.z)
		if not node.has_meta("rope"):
			if absf(cam.x) > absf(c.x) or absf(cam.y) > absf(c.y):   # the lens stands outside one of the post's two sides
				for p in [a, b]:
					var to := Vector2(p.x, p.z)
					var end := to + (cam - to).normalized() * SIGHT_SHORT_M
					if Geometry2D.get_closest_point_to_segment(c, cam, end).distance_to(c) < SIGHT_MARGIN_M:
						posts[node] = true
			continue
		var id: Variant = node.get_meta("rope")
		if gone.has(id):
			continue
		# The piece lies along its rope: the rope's side of the ring is the other axis (x for an east or west rope).
		var along := node.global_transform.basis.y
		var half := Vector2(along.x, along.z) * float(((node as MeshInstance3D).mesh as CylinderMesh).height) * 0.5
		var ax := 0 if absf(half.y) > absf(half.x) else 1
		if cam[ax] * signf(c[ax]) <= absf(c[ax]):
			continue   # the lens stands on the ring's side of this rope: it is behind or beside the boxers, never between
		for p in [a, b]:
			var foot := Vector2(p.x, p.z)
			var across := (foot - cam).normalized().orthogonal() * BODY_HALF_M
			for off in [Vector2.ZERO, across, -across]:
				var to: Vector2 = foot + (off as Vector2)
				var end: Vector2 = to + (cam - to).normalized() * BODY_SHORT_M
				if end[ax] * signf(c[ax]) < absf(c[ax]) and Geometry2D.segment_intersects_segment(cam, end, c - half, c + half) != null:
					gone[id] = true
	for n in ring_side:
		var hide: bool = gone.has((n as Node).get_meta("rope")) if (n as Node).has_meta("rope") else posts.has(n)
		_fade(n as MeshInstance3D, SEE_ALPHA if hide else 1.0, delta)


## Eases a ring piece's own material toward `want` alpha (delta 0 = at once); solid pieces stay opaque.
static func _fade(m: MeshInstance3D, want: float, delta: float) -> void:
	var mat := m.material_override as StandardMaterial3D
	var c := mat.albedo_color
	c.a = want if delta <= 0.0 else move_toward(c.a, want, delta / FADE_S)
	mat.albedo_color = c
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA if c.a < 0.999 else BaseMaterial3D.TRANSPARENCY_DISABLED
