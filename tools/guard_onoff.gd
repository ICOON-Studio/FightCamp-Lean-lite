extends SceneTree
## S525 GUARD v4 damage-through check: the same seeded bouts with GuardState.damage_on OFF (control) and ON, six cells
## (tools/guard_probe.gd's population and _play, reused). Prints per cell: stoppages, our wins, the bout's total damage
## (both sides), the mean guard share at the last bell (a / b). Targets (design s4 / GUARDWEAR_WIRE_S524): damage +7..11%,
## stoppages within +-3 points of the control, amateur last bell yellow (0.50-0.75), pro6 last bell orange (0.25-0.50).
##   godot --headless --audio-driver Dummy --path . --script res://tools/guard_onoff.gd [-- n=100]

const GP := preload("res://tools/guard_probe.gd")
const GuardState := preload("res://scripts/state/GuardState.gd")


func _initialize() -> void:
	var n := 100
	for a in OS.get_cmdline_user_args():
		if a.begins_with("n="):
			n = int(a.substr(2))
	print("GUARD_ONOFF n=%d a cell, seeds %d.., WEAR_SCALE %.2f AMATEUR_SCALE %.2f K_THROUGH %.3f" % [n, GP.SEED0, GuardState.WEAR_SCALE, GuardState.AMATEUR_SCALE, GuardState.K_THROUGH])
	print("| cell | arm | stopped | our wins | damage a+b | guard a | guard b |")
	var worst_stop := 0.0
	var dmg_lo := 1e9
	var dmg_hi := -1e9
	for cell in GP.CELLS:
		var res := {}
		for on in [false, true]:
			GuardState.damage_on = on
			var stops := 0
			var wins := 0
			var dmg := 0.0
			var ga := 0.0
			var gb := 0.0
			for i in n:
				var r: Dictionary = GP._play(cell, GP.SEED0 + i)
				stops += 1 if str(r["stopped"]) != "" else 0
				wins += 1 if str(r["loser"]) == "b" else 0
				dmg += float(r["damage"].get("a", 0.0)) + float(r["damage"].get("b", 0.0))
				var last: Array = r["shipped"][-1] if not (r["shipped"] as Array).is_empty() else [0.0, 0.0]
				ga += float(last[0]) / maxf(1.0, float(r["max"]))
				gb += float(last[1]) / maxf(1.0, float(r["max"]))
			res[on] = [stops, wins, dmg]
			print("| %s | %s | %d | %d | %.0f | %.2f | %.2f |" % [cell["id"], "ON" if on else "off", stops, wins, dmg, ga / n, gb / n])
		var add := (float(res[true][2]) / maxf(1.0, float(res[false][2])) - 1.0) * 100.0
		var dstop := (float(res[true][0]) - float(res[false][0])) * 100.0 / n
		print("  %s: damage %+.1f%%, stoppages %+.1f points, our wins %+d" % [cell["id"], add, dstop, int(res[true][1]) - int(res[false][1])])
		worst_stop = maxf(worst_stop, absf(dstop))
		dmg_lo = minf(dmg_lo, add)
		dmg_hi = maxf(dmg_hi, add)
	GuardState.damage_on = true
	print("RESULT: tools/guard_onoff.gd -> damage_plus=%.1f..%.1f%% worst_stop_shift=%.1f points" % [dmg_lo, dmg_hi, worst_stop])
	print("GUARD_ONOFF done")
	quit(0)
