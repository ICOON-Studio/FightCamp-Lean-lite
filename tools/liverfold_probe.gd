extends SceneTree
## S467 LIVERRIBS1: how often the liver fold happens in played bouts (tools/result_dump.gd's game path, seeds 100-199),
## against all counts. LIVERPROBE1's bar: body knockdowns 10-20 % of all knockdowns (ESTIMATE). Prints one line a run.

const Dump := preload("res://tools/result_dump.gd")
const LiverRibs := preload("res://scripts/rules/LiverRibs.gd")
const LiverFold := preload("res://scripts/state/LiverFold.gd")


func _initialize() -> void:
	var pts := float(OS.get_cmdline_user_args()[0]) if OS.get_cmdline_user_args().size() > 0 else LiverFold.shot_points
	LiverFold.shot_points = pts
	if OS.get_cmdline_user_args().size() > 1:
		LiverFold.fold_scale = float(OS.get_cmdline_user_args()[1])
	print("shot_points=%.1f fold_scale=%.2f" % [pts, LiverFold.fold_scale])
	var bouts := 0
	var counts := 0
	var folds := 0
	var liver_max := 0
	var liver_sum := 0
	for sd in range(100, 200):
		var cf := Dump._setup(sd)
		var f: Dictionary = cf[1]
		var m := Dump._fight(cf[0], f, Dump.PLAN, true)
		bouts += 1
		for r in m["rounds"]:
			counts += int((r as Dictionary).get("counts", 0))
			folds += int(bool((r as Dictionary).get("liver_fold", false)))
		var tally: Dictionary = (f["bout"] as Dictionary).get("sides", {})
		for who in ["a", "b"]:
			var lv := int(LiverRibs.counts(tally.get(who, {}))["liver"])
			liver_max = maxi(liver_max, lv)
			liver_sum += lv
	print("LIVERFOLD_PROBE bouts=%d counts=%d liver_folds=%d share=%.2f liver_shots_mean=%.1f max=%d" % [bouts, counts, folds,
		float(folds) / maxf(1.0, float(counts)), float(liver_sum) / float(bouts * 2), liver_max])
	quit(0)
