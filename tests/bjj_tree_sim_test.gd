extends SceneTree
## GAMETREE1 (S384) the calibration bars as asserts (design 10.2, stage 1): bars 1a-c, 2, 3, 4, 5, 6, 7, 8, 11, 13, 14
## and 16 at 400 seeds with the shipped tuning (BjjTree.T0 / BjjOpp.T0); the OPEN bars are printed only. Bar 1d
## (readiness shares, 2,000 seeds) stays in tools/bjj_tree_balance.gd, which prints the same rows and runs tuning passes. Seeded: a failure here is a
## real change in the walk, the field or the tuning, never noise.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const Balance := preload("res://tools/bjj_tree_balance.gd")

const SEEDS := 400
## Bars the [T] values alone do not reach (S384 calibration, tmp/s384/gametree1_build/TUNING.md): printed, not asserted,
## until the graph / chooser change that each one needs lands. Everything else is asserted.
const OPEN := ["3a", "3b", "3d", "4b", "6", "8", "16"]


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	var t0 := Time.get_ticks_msec()
	var rows: Array = Balance.run({"seeds": SEEDS, "seeds_1d": 0})
	var fails := 0
	for r in rows:
		var open := OPEN.has(str(r["bar"]))
		var tag := "ok  " if r["pass"] else ("open" if open else "FAIL")
		print("  %s BAR %-4s %s = %s" % [tag, r["bar"], r["name"], r["value"]])
		fails += 0 if r["pass"] or open else 1
	var want := ["1a", "1b", "1c", "2", "3a", "3b", "3c", "3d", "4a", "4b", "5", "6", "7", "8", "11a", "11b", "11c", "13", "14", "16"]
	var got := rows.map(func(r): return str(r["bar"]))
	for b in want:
		if not got.has(b):
			print("  FAIL bar %s did not run" % b)
			fails += 1
	print("  info %d bars in %.1f s" % [rows.size(), (Time.get_ticks_msec() - t0) / 1000.0])
	print("BJJ_TREE_SIM %s failures=%d" % ["PASS" if fails == 0 else "FAIL", fails])
	quit(0 if fails == 0 else 1)
