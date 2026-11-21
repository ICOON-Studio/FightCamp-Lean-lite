extends SceneTree
## S533 STEPPAY2 phase 4: what the place is worth on an average exchange of a played bout, for the win read (BoutRead walks
## the duel in expectation and has no card). Per style x plan (TREEVALUE's plan with its pivot-out line, and without it):
## the mean of rec["place_edge"] over the exchanges after a round's first, beside the simple forecast
## -ROPES x (her pressing + loading share) x (share of exchanges your boxer loses). ratio = measured / forecast.
## Population: TREEVALUE1's 60 generated boxers vs one shipped opponent per style at the TREEVALUE3 rating; n bouts a cell.
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/place_read_probe.gd -- [n=150]
const TV := preload("res://tools/treevalue_probe.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PlaceEdge := preload("res://scripts/rules/PlaceEdge.gd")
const StepValue := preload("res://scripts/rules/StepValue.gd")
const RATING := {"Maria Ortega": 52.89, "Jade Cooper": 55.95, "Holly Price": 54.24, "Priya Nair": 53.29,
	"Erin Doyle": 53.02, "Dana Whitfield": 52.64}


func _initialize() -> void:
	var n := 150
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("n="):
			n = int(str(a).substr(2))
	var tv: Object = TV.new()
	var base: Dictionary = tv.call("_base_dict")
	print("PLACE_READ: %d bouts a cell; exchanges after a round's first" % n)
	for with_pivot in [true, false]:
		var plan: Array = (TV.PLAN as Array).filter(func(a): return bool(with_pivot) or str(a["move"]) != "pivot_out")
		for style in StepValue.STYLES:
			var opp: Dictionary = tv.call("_find_opp", str(TV.STYLE_OPP[str(style)]))
			opp["rating"] = float(RATING[str(opp["name"])])
			var mix: Dictionary = Exchanges.STYLE_MODES.get(str(style), Exchanges.STYLE_MODES["Boxer-puncher"])
			var q := float(mix.get("press", 0.0)) + float(mix.get("loadup", 0.0))
			var sum := 0.0
			var cnt := 0
			var lost := 0
			var own := 0
			var theirs := 0
			for k in n:
				var c := Career.quick_start()
				c.fighters.append(tv.call("_make_fighter", int(TV.SEED_START) + (k % int(TV.N_FIGHTERS))))
				c.day = 40 + k
				var f: Dictionary = c.fighter()
				f["camp"] = {}
				f["morale"] = 60.0
				f["moves"] = (base["moves"] as Dictionary).duplicate()
				f["steps"] = (base["steps"] as Dictionary).duplicate()
				f["combos"] = (base["combos"] as Dictionary).duplicate()
				f["arrows"] = plan.duplicate(true)
				c.coach = {}
				f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
				var m := {"fid": f["id"], "step": "tape", "total": 3}
				Bouts.fight_step(c, f, m, "sim")
				for r in m["rounds"]:
					for x in (r as Dictionary)["exchanges"]:
						var xd: Dictionary = x
						if int(xd["i"]) == 0:
							continue
						cnt += 1
						sum += float(xd.get("place_edge", 0.0))
						lost += 0 if bool(xd["won"]) else 1
						own += 1 if str(xd.get("at", "")) == "own_ropes" else 0
						theirs += 1 if str(xd.get("at", "")) in ["opp_ropes", "corner"] else 0
			var fc := float(maxi(1, cnt))
			var forecast := -PlaceEdge.ROPES * q * float(lost) / fc
			print("READ pivot_line=%s style=%s mean_place_edge=%+.3f own_ropes=%.1f%% opp_ropes_corner=%.1f%% lost=%.1f%% press_loadup=%.2f forecast=%+.3f ratio=%.2f" % [
				"yes" if bool(with_pivot) else "no", str(style), sum / fc, 100.0 * float(own) / fc, 100.0 * float(theirs) / fc,
				100.0 * float(lost) / fc, q, forecast, (sum / fc) / forecast if forecast != 0.0 else 0.0])
	tv.free()
	print("PLACE_READ done")
	quit(0)
