extends SceneTree
## S391: during the ring entry the ropes stay on their line and the side she climbs through fades, then comes back.
const RingRopes := preload("res://scripts/fight3d/RingRopes.gd")

var _fails := 0


func _initialize() -> void:
	var ropes := RingRopes.new()
	root.add_child(ropes)
	ropes.build(3.0, [0.45, 0.85, 1.25], func(_h: float) -> StandardMaterial3D: return StandardMaterial3D.new())
	ropes.calm = true
	ropes.part(0, Vector3(-1.0, 0.85, -3.0), 1.0)
	for f in 60:
		ropes.tick(1.0 / 30.0, [])
	_check(ropes.max_bow() < 0.001, "no rope bends in the entry (%.3f)" % ropes.max_bow())
	var faded := 0
	var solid := 0
	for rope in ropes._ropes:
		var a := ((rope["segs"][0] as MeshInstance3D).material_override as StandardMaterial3D).albedo_color.a
		if a < 0.5:
			faded += 1
		else:
			solid += 1
	print("faded %d solid %d" % [faded, solid])
	_check(faded == 3 and solid == 9, "only the three ropes of her side fade")
	ropes.part(0, Vector3.ZERO, 0.0)
	for f in 30:
		ropes.tick(1.0 / 30.0, [])
	var back := ((ropes._ropes[0]["segs"][0] as MeshInstance3D).material_override as StandardMaterial3D)
	_check(back.albedo_color.a == 1.0 and back.transparency == BaseMaterial3D.TRANSPARENCY_DISABLED, "they come back solid")
	print("ring_ropes_entry_test: %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
