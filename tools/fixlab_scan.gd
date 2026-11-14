extends SceneTree
## S468: per seed, what FixLab finds on the result page's sample bouts (tools/result_dump.gd): the worst line, the changes
## it measures and their wins. Run headless: --script res://tools/fixlab_scan.gd [-- from=44 to=63]
const Dump := preload("res://tools/result_dump.gd")
const FixLab := preload("res://scripts/state/FixLab.gd")

func _initialize() -> void:
	var a := 44
	var b := 63
	for arg in OS.get_cmdline_user_args():
		if str(arg).begins_with("from="): a = int(str(arg).trim_prefix("from="))
		if str(arg).begins_with("to="): b = int(str(arg).trim_prefix("to="))
	for sd in range(a, b + 1):
		var cf := Dump._setup(sd)
		var m := Dump._fight(cf[0], cf[1], Dump.PLAN, true)
		var from: Dictionary = m.get("lab_from", {})
		var fits := {}
		var planned := 0
		var total := 0
		for r in m["rounds"]:
			for x in r["exchanges"]:
				total += 1
				if bool(x.get("planned", false)):
					planned += 1
					var k := "%s:%s" % [str(x.get("arrow", "")), str(x.get("arrow_fit", ""))]
					fits[k] = int(fits.get(k, 0)) + 1
		var lab := FixLab.run(cf[0], m)
		var ch: Dictionary = lab.get("changes", {})
		var wins := {}
		for k in ch:
			wins[k] = int(ch[k]["wins"])
		print("SCAN seed %d outcome=%s exchanges=%d planned=%d fits=%s worst=%s open=%s written=%s wins=%s best='%s' verdict=%s" % [sd, str(m["outcome"]), total, planned,
			str(fits), str(FixLab.worst_line(from.get("arrows", []), m["rounds"])), str(FixLab.open_sit(from.get("arrows", []), m["rounds"])),
			str(lab.get("written", -1)), str(wins), str(lab.get("best", "")), str(lab.get("verdict", ""))])
	quit(0)
