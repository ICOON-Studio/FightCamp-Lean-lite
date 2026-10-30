extends Node3D
## S311 (operator: "add kinetics to the ropes"): the ring's 12 ropes (4 sides x 3 heights) as springy chains. Each rope is
## SEGMENTS short cylinders between its two posts; its points carry a displacement from the straight line, pulled back by
## the rope's tension (each point toward its neighbours) and its own spring, with light damping - a taut rope that bows
## where a body leans on it and wobbles back a few times when let go. Bodies only push a rope OUTWARD (a boxer backed
## onto the ropes, a hit that drives her into them), never through it, from spheres on the boxer's bones.
##   build(half, heights, mat_of)  tick(delta, skeletons)  segments = every piece (the camera fades the ones in the way)

const SEGMENTS := 10
## Per unit mass: the pull back to the line (~3.5 Hz alone), the neighbour coupling (rope tension), damping per substep.
const K_REST := 480.0
const K_TENSION := 900.0
const DAMP := 0.012
const SUBSTEP_S := 1.0 / 240.0
## Body spheres: bone, radius in metres on the unscaled body (gloves up, so the hands are the widest point of the guard).
const BODY := [["Hips", 0.17], ["Chest", 0.19], ["Head", 0.12], ["LeftHand", 0.09], ["RightHand", 0.09],
	["LeftLowerLeg", 0.08], ["RightLowerLeg", 0.08]]
const RADIUS_M := 0.018
## S312: the furthest a ring rope gives under a body (a real ring rope bows ~0.1-0.4 m). S311's film bowed one 0.71 m.
const MAX_BOW_M := 0.35

var segments: Array = []      # MeshInstance3D, SEGMENTS per rope
var _ropes: Array = []        # [{a, b, n (outward), u: PackedVector3Array, prev: PackedVector3Array, segs: Array}]
var _left := 0.0
## The deepest push a body part wanted past MAX_BOW_M (it went through the rope): metres past the line, "<boxer> <bone>".
var through_m := 0.0
var through_who := ""


## `half` = posts at (+-half, +-half); one rope per side at each of `heights`; `mat_of.call(h)` a new material for a piece.
func build(half: float, heights: Array, mat_of: Callable) -> void:
	var posts := [Vector3(-half, 0, -half), Vector3(half, 0, -half), Vector3(half, 0, half), Vector3(-half, 0, half)]
	for h in heights:
		for i in 4:
			var a: Vector3 = posts[i] + Vector3(0, float(h), 0)
			var b: Vector3 = posts[(i + 1) % 4] + Vector3(0, float(h), 0)
			var mid := (a + b) * 0.5
			var rope := {"a": a, "b": b, "n": Vector3(mid.x, 0, mid.z).normalized(), "segs": [],
				"u": PackedVector3Array(), "prev": PackedVector3Array()}
			rope["u"].resize(SEGMENTS + 1)
			rope["prev"].resize(SEGMENTS + 1)
			for k in SEGMENTS:
				var m := MeshInstance3D.new()
				var cm := CylinderMesh.new()
				cm.top_radius = RADIUS_M
				cm.bottom_radius = RADIUS_M
				cm.height = a.distance_to(b) / SEGMENTS
				cm.radial_segments = 8
				cm.rings = 1
				m.mesh = cm
				m.material_override = mat_of.call(float(h))
				add_child(m)
				(rope["segs"] as Array).append(m)
				segments.append(m)
			_ropes.append(rope)
			_place(rope)


## Steps the ropes by `delta` against the bodies of `skels` (the boxers' Skeleton3D nodes).
func tick(delta: float, skels: Array) -> void:
	var spheres := _spheres(skels)
	_left = minf(_left + delta, 0.1)
	while _left >= SUBSTEP_S:
		_left -= SUBSTEP_S
		for rope in _ropes:
			_step(rope, spheres)
	for rope in _ropes:
		_place(rope)


func _step(rope: Dictionary, spheres: Array) -> void:
	var u: PackedVector3Array = rope["u"]
	var prev: PackedVector3Array = rope["prev"]
	var a: Vector3 = rope["a"]
	var b: Vector3 = rope["b"]
	var n: Vector3 = rope["n"]
	var dt2 := SUBSTEP_S * SUBSTEP_S
	var next := u.duplicate()
	for k in range(1, SEGMENTS):
		var acc := -K_REST * u[k] + K_TENSION * (u[k - 1] + u[k + 1] - 2.0 * u[k])
		next[k] = u[k] + (u[k] - prev[k]) * (1.0 - DAMP) + acc * dt2
		# A body leaning on the rope pushes this point outward, never through.
		var rest := a.lerp(b, float(k) / SEGMENTS)
		for s in spheres:
			var c: Vector3 = s[0]
			var r: float = s[1]
			var p := rest + next[k]
			var d := p - c
			var off := d - n * d.dot(n)
			if off.length_squared() >= r * r:
				continue
			var need := c.dot(n) + sqrt(r * r - off.length_squared())
			if p.dot(n) < need:
				next[k] += n * (need - p.dot(n))
				var want := need - rest.dot(n)
				if want > MAX_BOW_M and want > through_m:
					through_m = want
					through_who = str(s[2])
		if next[k].length() > MAX_BOW_M:
			next[k] = next[k].normalized() * MAX_BOW_M
	rope["prev"] = u
	rope["u"] = next


## Each segment between its two points (rest line + displacement), stretched to fit.
func _place(rope: Dictionary) -> void:
	var u: PackedVector3Array = rope["u"]
	var a: Vector3 = rope["a"]
	var b: Vector3 = rope["b"]
	var rest_len := a.distance_to(b) / SEGMENTS
	for k in SEGMENTS:
		var p0 := a.lerp(b, float(k) / SEGMENTS) + u[k]
		var p1 := a.lerp(b, float(k + 1) / SEGMENTS) + u[k + 1]
		var m: MeshInstance3D = rope["segs"][k]
		var dir := p1 - p0
		var up := dir.normalized()
		var side := up.cross(Vector3.UP if absf(up.y) < 0.9 else Vector3.RIGHT).normalized()
		m.transform = Transform3D(Basis(side, up * (dir.length() / rest_len), side.cross(up)), (p0 + p1) * 0.5)


## The furthest any rope point sits off its straight line now, metres (tools/range_probe.gd).
func max_bow() -> float:
	var most := 0.0
	for rope in _ropes:
		for v in (rope["u"] as PackedVector3Array):
			most = maxf(most, v.length())
	return most


## The body spheres of every boxer, in world space: [centre, radius, "<boxer index> <bone>"].
func _spheres(skels: Array) -> Array:
	var out: Array = []
	for j in skels.size():
		var sk := skels[j] as Skeleton3D
		var s := sk.global_transform.basis.get_scale().x
		for row in BODY:
			var i := sk.find_bone(str(row[0]))
			if i >= 0:
				out.append([sk.global_transform * sk.get_bone_global_pose(i).origin, float(row[1]) * s, "%d %s" % [j, row[0]]])
	return out
