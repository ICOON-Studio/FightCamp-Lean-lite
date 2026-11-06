extends RefCounted
## S390 (blind reviewer: "there's no mat or arena, just a grey void"): the competition mat a belt match is fought on. A warm mat in
## a dark hall: red, blue and skin all read on it (operator S335: blue fighter on a blue mat), and the edge says where the mat ends.

const MAT_M := 8.0
const EDGE_M := 0.45
const HALL := Color("#2c3036")
const FLOOR := Color("#3b4047")
const MAT := Color("#857f70")   # reads mid-tone under the hall lights; #cfc8b4 burned out near white
const EDGE := Color("#8c3b34")


static func _slab(size: float, y: float, c: Color) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var p := PlaneMesh.new()
	p.size = Vector2(size, size)
	mi.mesh = p
	mi.position.y = y
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.roughness = 0.9
	mi.material_override = m
	return mi


## Floor, edge and mat, the mat's surface at y 0 where the bodies lie.
static func build(world: Node3D) -> void:
	world.add_child(_slab(40.0, -0.03, FLOOR))
	world.add_child(_slab(MAT_M + EDGE_M * 2.0, -0.01, EDGE))
	world.add_child(_slab(MAT_M, 0.0, MAT))
