extends SceneTree
## S443 FixLab on the result page's sample bout (tools/result_dump.gd seed 44, Lucy v Priya): the changes it measures,
## their wins, the verdict and the time it takes. Usage: --script res://tools/fixlab_probe.gd -- [seed=44] [nights=40]

const Dump := preload("res://tools/result_dump.gd")
const FixLab := preload("res://scripts/state/FixLab.gd")


func _initialize() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2:
			args[kv[0]] = kv[1]
	var cf := Dump._setup(int(args.get("seed", "44")))
	var m := Dump._fight(cf[0], cf[1], Dump.PLAN, true)
	print("FIXLAB bout %s %s, lab_from %s" % [m["outcome"], str(m["cards"]), str(m.has("lab_from"))])
	var t0 := Time.get_ticks_msec()
	var res := FixLab.run(cf[0], m, int(args.get("nights", str(FixLab.NIGHTS))))
	var ms := Time.get_ticks_msec() - t0
	print("FIXLAB written %d of %d, best %s (%d), verdict %s, %d ms" % [int(res.get("written", -1)), int(res.get("nights", 0)),
		str(res.get("best", "")), int(res.get("best_wins", -1)), str(res.get("verdict", "")), ms])
	for k in (res.get("changes", {}) as Dictionary):
		var r: Dictionary = res["changes"][k]
		print("FIXLAB %s wins %d: %s" % [k, int(r["wins"]), str(r["arrows"])])
	quit(0)
