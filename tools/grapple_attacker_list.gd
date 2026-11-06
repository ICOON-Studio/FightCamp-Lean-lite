extends SceneTree
## S390: who GrappleFinish.attacker names on every submission position, beside who is higher: a list to check by eye.
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Fin := preload("res://scripts/grapple/GrappleFinish.gd")


func _initialize() -> void:
	var db: Array = DB.load_db()
	for i in db.size():
		var e: Dictionary = db[i]
		if (e["frames"] as Array).size() != 1:
			continue
		var f: Array = e["frames"][0]
		var a := Fin.attacker(e.get("tags", []), f)
		if a < 0:
			continue
		var c0: float = (f[0] as PackedVector3Array)[DB.joint("Core")].y
		var c1: float = (f[1] as PackedVector3Array)[DB.joint("Core")].y
		print("ATK %d man%d %s top=man%d %s" % [i, a, "UNDER" if (a == 0) != (c0 >= c1) else "over", 0 if c0 >= c1 else 1, str(e["title"]).left(34)])
	quit(0)
