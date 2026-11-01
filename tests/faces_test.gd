extends SceneTree
## S332 every boxer her own face (Faces): each woman in the region has a body nobody else wears, the body exists with its
## portraits, its height is the body's own, and the two corners never share a body (a new walk-in included).

const Faces := preload("res://scripts/rules/Faces.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	var cast: Array = [Data.lucy()]
	cast.append_array(Data.OPPONENTS)
	cast.append(Data.MISMATCH)
	cast.append_array(Data.RIVALS)
	var seen := {}
	for f in cast:
		seen[Faces.stem(f)] = str(f["name"])
	var own := cast.filter(func(f): return Faces.CAST.has(str(f["name"])))
	_check(own.size() >= 8 and seen.size() >= own.size(), "%d boxers with their own body, %d different bodies" % [own.size(), seen.size()])
	var files_ok := true
	var cm_ok := true
	for s in Faces.CM.keys():
		for p in [Faces.glb(s), "res://assets/ui/body/%s_red.png" % s, "res://assets/ui/body/%s_blue.png" % s]:
			if not ResourceLoader.exists(p):
				files_ok = false
				print("  missing ", p)
		var side: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://assets/models/metahuman/%s.json" % s))
		if not (side is Dictionary) or absf(float((side as Dictionary).get("height_cm", 0.0)) - Faces.cm(s)) > 0.5:
			cm_ok = false
			print("  height of %s: %s vs %.0f" % [s, str((side as Dictionary).get("height_cm") if side is Dictionary else null), Faces.cm(s)])
	_check(files_ok, "every body has its model and both corner portraits")
	_check(cm_ok, "every body's height is its own measured height")
	var apart := true
	for f in cast:
		for o in cast:
			var p := Faces.pair(f, o)
			if p[0] == p[1] or p[0] != Faces.stem(f):
				apart = false
	var walk_in := {"name": "Jade Morris"}
	var p2 := Faces.pair(walk_in, {"name": "Jade Morris"})
	_check(apart and p2[0] != p2[1], "the two corners never share a body, a walk-in against her own name included")
	_check(Faces.stem(walk_in) == Faces.stem({"name": "Jade Morris"}) and Faces.CM.has(Faces.stem(walk_in)), "a walk-in keeps one body")
	print("FACES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
