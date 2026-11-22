extends SceneTree
## S537 WEIGHT3 - greybox probe of "the depth is reading the opponent's cut" (ops/research/TASK_WEIGHT3.md, owner "Yes,
## move it" on docs/WEIGHT2_PROBE5.md). Our boxer boxes his natural class (round 5's STAY); the field cuts and pays as in
## round 5 (tools/weight2_model.gd); every night is boxed once on each fight plan with the SAME dice, so any way of
## reading the cut is a choice of which of those bouts counts. This file plays the nights and writes one row a bout;
## tools/weight3_probe_sum.py turns the rows into docs/WEIGHT3_PROBE.md (arms, cells, bars). Nothing here is in scripts/.
##   pilot (which late line does the fight code pay against a drained man? pro scale, its own seeds):
##     python ops/Tools/godot_slot.py run --who weight3 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/weight3_probe.gd -- mode=pilot seeds=10 out=<csv>
##   main (fresh seeds, championship and pro; plans = a comma list of Rules.PLANS ids):
##     ... --script res://tools/weight3_probe.gd -- mode=main plans=FLAT,EARLY,S1P5,P3,LG3,B1P5,S1LG5,B1LG5 seeds=40 out=<csv>
##   the what-if arm (his cut off his tank; NOT round 5's model): the main line with mode=tank

const Rules := preload("res://tools/weight3_probe_rules.gd")
const Model := preload("res://tools/weight2_model.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	var opt := {"mode": "pilot", "seeds": "10", "bouts": "12", "plans": "FLAT,EARLY,S1P5", "out": "user://weight3_nights.csv", "only": ""}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2 and opt.has(kv[0]): opt[kv[0]] = kv[1]
	var pilot := str(opt["mode"]) == "pilot"
	var seeds := int(opt["seeds"]); var bouts := int(opt["bouts"])
	var seed0 := 1000 if pilot else 0          # the pilot never shares a night with the main run
	var tank := str(opt["mode"]) == "tank"
	var plans: Array = Rules.PILOT if pilot else Array(str(opt["plans"]).split(","))
	var R: Rules = Rules.new()
	var fa := FileAccess.open(str(opt["out"]), FileAccess.WRITE)
	if fa == null:
		print("WEIGHT3 probe: cannot write %s" % str(opt["out"]))
		quit(1)
		return
	fa.store_line("set,scale,boxer,seed,k,day,cut,fade,drop,gap,rating,seen15,seen30,plan,outcome,stop,rounds,e3b,ea")
	var rng := RandomNumberGenerator.new()
	for sc in Model.SCALES:
		var sid := str(sc["id"])
		if sid == "club" or (pilot and sid != "pro") or (str(opt["only"]) != "" and str(opt["only"]) != sid):
			continue   # a club-show opponent does not cut: nothing to read
		var days := int(sc["days"])
		var cuts: Array = sc["opp_cut"]
		for b in Model.BOXERS:
			var t := Model.person(str(b["who"]))
			var cell := {"b": b, "sc": sc, "id": "%s / %s" % [b["shape"], sid]}
			var stay := Model.plan_choice(cell, "STAY")
			var base := BoutRules.fight_power(t["stats"], {}, 0, "", false)
			var own := Model.limit0(t)
			for s in range(seed0, seed0 + seeds):
				var grown := 0.0
				for k in bouts:
					# the same draws, in the same order, as round 5's run (Model.run): the scale, the regain night, his cut
					rng.seed = hash([str(cell["id"]), s, k])
					rng.randf()
					var share := float(sc["share_big"] if rng.randf() < float(sc["big_odds"]) else sc["share"]) if bool(sc["pro"]) else -1.0
					var cut := float(cuts[mini(cuts.size() - 1, int(rng.randf() * float(cuts.size())))])
					var noise := rng.randf() * 2.0 - 1.0
					var day := k % days
					var ni: Dictionary = R.night(t, stay, sc, share, day, cut)
					grown += float(Model.MODEL["grow"]) * float(ni["keep"])
					var ta: Array = Rules.tank_arm(sc, cut, day)
					var drop := float(ta[1]) if tank else float(ni["drop"])
					var rating := base + float(Rules.FIT["opp_off"][sid]) + float(Model.MODEL["field_grow"]) * float(k) - float(Rules.FIT["size_rating"]) * float(ni["gap"]) - drop
					var seen: Array = []
					for wd in Rules.READ_WIDTHS:
						seen.append(int(Rules.reads_fade(sc, cut + noise * float(wd), day)))
					for pid in plans:
						var o: Dictionary = R.bout(t, sc, ni, rating, own, s, k, grown, Rules.PLANS[pid], float(ta[0]) if tank else -1.0)
						fa.store_line("%s,%s,%s,%d,%d,%d,%.0f,%d,%.2f,%.2f,%.2f,%d,%d,%s,%s,%d,%s,%.1f,%.1f" % [str(opt["mode"]), sid, b["shape"], s, k, day, cut,
							int(bool(ni["fade"])), drop, float(ni["gap"]), rating, seen[0], seen[1], pid, o["outcome"], int(bool(o["stop"])), o["rounds"], o["e3b"], o["ea"]])
				fa.flush()
			print("cell %s done, %d bouts, %.0f s" % [cell["id"], R.n_bouts, float(Time.get_ticks_msec() - t0) / 1000.0])
	fa.close()
	print("WEIGHT3 probe done (%s, %d bouts, %.0f s) -> %s" % [opt["mode"], R.n_bouts, float(Time.get_ticks_msec() - t0) / 1000.0, opt["out"]])
	quit(0)
