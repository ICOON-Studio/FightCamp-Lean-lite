extends SceneTree
## S429 (operator: "poster isnot centered correctly"): the fight poster is never wider than the width it was asked for,
## whatever the names and styles, so nothing is cut and the two sides sit centred.
const FightPoster := preload("res://scripts/ui/FightPoster.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	var c: Career = Career.quick_start()
	var cases := [
		["Lucy Jackson", "Out-boxer", "Erin Doyle", "Volume puncher"],
		["Samira Khan", "Slugger", "Victoria Hale", "Boxer-puncher"],
		["Tess Reilly", "Pressure fighter", "Chantelle Reid", "Counter-puncher"],
	]
	for w in [380.0, 520.0]:
		for cs in cases:
			var f: Dictionary = Data.lucy()
			f["name"] = cs[0]
			f["style"] = cs[1]
			f["bout"] = {"opp": {"name": cs[2], "first": str(cs[2]).split(" ")[0], "style": cs[3], "w": 7, "l": 2}, "day": 20, "rounds": 3}
			var p: Control = FightPoster.build(c, f, w)
			_check(p != null, "a poster is built for %s v %s" % [cs[0], cs[2]])
			if p == null:
				continue
			root.add_child(p)
			await process_frame
			var need := p.get_combined_minimum_size().x
			_check(need <= w + 1.0, "%s v %s at %d wide needs %d (never wider than asked)" % [cs[0], cs[2], int(w), int(need)])
			p.queue_free()
	print("FIGHT_POSTER failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		failures += 1
