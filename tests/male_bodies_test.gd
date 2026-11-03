extends SceneTree
## S372 (operator "Yes, build them"): men box in men's bodies. Five male MetaHumans (Faces.MEN_CM, built S152/MH4,
## bare-chested - operator S372 "male boxers donot wear tops") - Danny Osei and Josh Harper cast by name, the region's
## men by name from the men's pool, the women untouched; the Playbook's partner is a man for a man. Each body loads with
## the women's skeleton and its trunks, and no top.

const Faces := preload("res://scripts/rules/Faces.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	_cast()
	_pairs()
	await _bodies()
	print("MALE_BODIES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _cast() -> void:
	var danny: Dictionary = Data.PROSPECTS.filter(func(p): return str(p["id"]) == "danny")[0]
	var josh: Dictionary = Data.PROSPECTS.filter(func(p): return str(p["id"]) == "josh")[0]
	_check(Faces.stem(danny) == "mh_boxer_02" and Faces.stem(josh) == "mh_boxer_01", "Danny wears Isaiah (02), Josh wears Victor (01)")
	var men: Array = Data.DIVISION_RIVALS.filter(func(o): return str(o.get("div", "")).begins_with("m"))
	_check(men.size() >= 8, "the region has its men (%d)" % men.size())
	var all_men := men.all(func(o): return Faces.MEN_CM.has(Faces.stem(o)))
	_check(all_men, "every man in the region draws a man's body")
	var women: Array = Data.OPPONENTS + Data.DIVISION_RIVALS.filter(func(o): return not str(o.get("div", "wlw")).begins_with("m"))
	_check(women.all(func(o): return Faces.CM.has(Faces.stem(o))), "every woman keeps a woman's body")
	_check(Faces.stem(Data.lucy()) == "mh_boxer_11", "Lucy is still Lucy (11)")
	_check(is_equal_approx(Faces.cm("mh_boxer_08"), 186.0) and is_equal_approx(Faces.cm("mh_boxer_01"), 183.0), "men's standing heights")


func _pairs() -> void:
	var a := {"name": "Some Walk-in", "sex": "m"}
	var b := {"name": "Some Walk-in", "div": "mlw"}
	var p := Faces.pair(a, b)
	_check(p[0] != p[1] and Faces.MEN_CM.has(p[0]) and Faces.MEN_CM.has(p[1]), "two men never share a body (%s)" % str(p))
	var tape := Faces.pair({"name": "Unknown Name"}, {"name": "Callum Stokes", "div": "mfw"})
	_check(Faces.MEN_CM.has(tape[0]), "a name-only tape row against a man is a man (%s)" % tape[0])
	_check(Faces.sex(Faces.partner({"sex": "m"})) == "m" and Faces.MEN_CM.has(Faces.pair({"name": "X", "sex": "m"}, Faces.partner({"sex": "m"}))[1]),
		"a man spars with a man in the Playbook")
	_check(str(Faces.partner(Data.lucy())["name"]) == "Maria Ortega", "a woman still spars with Maria")


func _bodies() -> void:
	var lucy_bones := _bones("mh_boxer_11")
	for s in Faces.MEN_CM.keys():
		var scene: PackedScene = load(Faces.glb(s))
		_check(scene != null, "%s loads" % s)
		if scene == null:
			continue
		var node := scene.instantiate()
		var mats: Array = []
		for m in node.find_children("*", "MeshInstance3D", true, false):
			for i in (m as MeshInstance3D).mesh.get_surface_count():
				var mat := (m as MeshInstance3D).mesh.surface_get_material(i)
				if mat != null:
					mats.append(mat.resource_name)
		_check(mats.has("MH_Trunks") and not mats.has("MH_Top"), "%s: trunks, no top" % s)
		_check(_bones(s) == lucy_bones, "%s has the women's skeleton (%d bones)" % [s, lucy_bones])
		node.free()
		await process_frame


func _bones(s: String) -> int:
	var node := (load(Faces.glb(s)) as PackedScene).instantiate()
	var skels := node.find_children("*", "Skeleton3D", true, false)
	var n := (skels[0] as Skeleton3D).get_bone_count() if not skels.is_empty() else -1
	node.free()
	return n
