extends SceneTree
## Fight model step 2 in the real bout (Bouts.fight_step + Knockdowns): over 400 nights of Lucy against two opponents,
##   1. some bouts have a standing count and a few are stopped, inside bounds (never an exact count),
##   2. a stopped bout has no rounds after the stoppage and the boxer counted last loses it,
##   3. a stopped bout's result reads "inside the distance" and its card is "RSC|KO round n",
##   4. "Leaves her chin open" gets her counted more often than a sound chin.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var failures := 0
const NIGHTS := 400


func _initialize() -> void:
	var open_chin := {}
	for opp_i in [2, 1]:   # Nina "Leaves her chin open" / Grace "Slow to start" (Data.OPPONENTS)
		var counted := 0
		var opp_down := 0
		var stopped := 0
		var consistent := true
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))   # the walk-in, signed
		for i in NIGHTS:
			c.day = 20 + i
			c.news.clear()
			var f: Dictionary = c.fighter()
			var opp: Dictionary = (Data.OPPONENTS[opp_i] as Dictionary).duplicate(true)
			f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
			f["camp"] = {}
			var m := {"fid": f["id"], "step": "tape", "total": 3}
			Bouts.fight_step(c, f, m, "sim")
			var rounds: Array = m["rounds"]
			var any := rounds.any(func(r): return int(r.get("counts", 0)) > 0)
			counted += int(any)
			opp_down += int(rounds.any(func(r): return str(r.get("down", "")) == "b"))
			var stop := str(m.get("stopped", ""))
			if stop != "":
				stopped += 1
				var last: Dictionary = rounds[-1]
				var ok := str(last["stopped"]) == stop and rounds.size() <= 3
				ok = ok and str(m["outcome"]) == ("loss" if str(last["down"]) == "a" else "win")
				ok = ok and str(c.results[0]["cards"]) == "%s round %d" % [stop, rounds.size()]
				ok = ok and c.news.any(func(x): return str(x["t"]).contains("inside the distance"))
				if not ok and consistent:
					print("  inconsistent stop: %s rounds=%d outcome=%s card=%s" % [stop, rounds.size(), m["outcome"], c.results[0]["cards"]])
				consistent = consistent and ok
			else:
				consistent = consistent and rounds.size() == 3
		var name := str((Data.OPPONENTS[opp_i] as Dictionary)["first"])
		open_chin[opp_i] = opp_down
		print("  vs %s: bouts with a count %d / %d, stopped %d" % [name, counted, NIGHTS, stopped])
		_check(counted >= NIGHTS * 0.03 and counted <= NIGHTS * 0.6, "vs %s: counts in some bouts, not most (%d)" % [name, counted])
		_check(stopped >= 1 and stopped <= NIGHTS * 0.2, "vs %s: a few stoppages (%d)" % [name, stopped])
		_check(consistent, "vs %s: every stopped bout ends there, the counted boxer loses, the card and news say so" % name)
	# 4. Two opponents Lucy can beat, alike but for the scout's chin note.
	var downs := []
	for weak in ["Leaves her chin open", "Slow to start"]:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		var down := 0
		for i in NIGHTS:
			c.day = 20 + i
			c.news.clear()
			var f: Dictionary = c.fighter()
			var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
			opp["rating"] = 54.0
			opp["weak"] = weak
			f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
			f["camp"] = {}
			var m := {"fid": f["id"], "step": "tape", "total": 3}
			Bouts.fight_step(c, f, m, "sim")
			down += int((m["rounds"] as Array).any(func(r): return str(r.get("down", "")) == "b"))
		downs.append(down)
	_check(int(downs[0]) > int(downs[1]), "'Leaves her chin open': the opponent is counted more than a sound chin (%d vs %d of %d)" % [downs[0], downs[1], NIGHTS])
	print("BOUT_STOPPAGE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
