extends SceneTree
## S536 WEIGHT2R5 - WEIGHT2 greybox probe, ROUND 5 (ops/research/TASK_WEIGHT2R5.md; the code-checked critic's items 1 to 4,
## ops/research/DESIGN_WEIGHT2_V2_CRITIC_FABLE.md section 7). Rounds 1-4: 875376421, ddc061494, docs/WEIGHT2_PROBE3.md,
## docs/WEIGHT2_PROBE4.md. The model is tools/weight2_model.gd; round 5's own questions are tools/weight2_round5.gd (the same
## kilos by DIET / WATER / MIX / UP, frame, the field's cut, the three scales). This file: the fit (step 0) and round 4's
## tables on 15 cells = 5 boxers x 3 scales, 4 class choices, N bouts on a 20-rung ladder. Nothing here is in scripts/.
## PASS = round 4's bars (as shares of the cells) AND item 1's bar AND item 2's bar; all bars are written before the run.
##   python ops/Tools/godot_slot.py run --who weight2r5 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd [-- seeds=40 bouts=12 abl=3 cal=6 pol=16 read=20]

const Model := preload("res://tools/weight2_model.gd")
const Round5 := preload("res://tools/weight2_round5.gd")
const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

var M: Model = Model.new()

func _initialize() -> void:
	M.t0 = Time.get_ticks_msec()
	var opt := {"seeds": 40, "bouts": 12, "abl": 3, "cal": 6, "pol": 16, "read": 20}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2 and opt.has(kv[0]): opt[kv[0]] = int(kv[1])
	var seeds := int(opt["seeds"]); var bouts := int(opt["bouts"]); var cal := int(opt["cal"]); var abl := mini(int(opt["abl"]), seeds)
	M.say(["# WEIGHT2 probe, ROUND 5 - the same kilos by diet, by water or carried up; frame on; the field cuts; the design's three scales (S536 WEIGHT2R5)", "",
		"Round 4 (docs/WEIGHT2_PROBE4.md) passed its bars and two critics stopped at 6: the probe never ran the one trade the design is about, erased height and reach,",
		"let the field ring heavy for nothing and boxed a scale the design does not have. Round 5 changes the scratch model for exactly those four things:",
		"1. Water comes off first up to the free 2 %, and section 5 runs the SAME kilos (3 / 4 / 5 / 6 % over the line) by DIET, by WATER, MIXED, or carried UP.",
		"2. Frame is on: the opponent's height and reach are drawn from the class boxed at (AttrGen.body), from that division's own sheet; the fit takes the average worth of a class of frame back out of a move, so size is not counted twice.",
		"3. The field cuts and pays John's table (a pro opponent 6 to 10 %, mean 8 % = his 7.2 % regain); the hard cutters fade late on the game's own word; the field is refitted after.",
		"4. Three scales: club show (one hour, the gap rule, no walkover), championship (three hours, +1.9 %, a walkover, weighed on each of three boxing days), pro. The amateur hybrid is gone.", "",
		"Run: " + "python ops/Tools/godot_slot.py run --who weight2r5 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd -- seeds=%d bouts=%d abl=%d cal=%d pol=%d read=%d" % [seeds, bouts, abl, cal, int(opt["pol"]), int(opt["read"])], "",
		"What is real: the five boxers (Data.PROSPECTS) with their own height and reach (BodyFacts), each class's opponents (Data's division sheets), the club-show gap (WeighGap) and every bout (BoutNight, the game's fight night). What is scratch: the weight model (tools/weight2_model.gd).",
		"Each run = %d bout slots on a 20-rung ladder; %d seeds a cell; every choice of a seed fights the same nights (same dice). A championship is three boxing days in a row: a loss or a walkover ends it, so its runs box fewer bouts." % [bouts, seeds], "",
		"Scales: " + str(Model.SCALES), "", "Model: " + str(Model.MODEL), "",
		"## The bars, written before the run", "",
		"- Round 4's, as shares of the 15 cells: every one of round 4's six levers moves the result; no choice best in more than 9 cells (6 of 10); 6 or more cells clear of the noise (4 of 10);",
		"  CUT harder in the leading group of at most 6 in 10 of the cells where it is a choice; one amateur cell or more where CUT is clearly worse than STAY. A boxer for whom CUT is the same plan as STAY has no CUT (the critic's item 14).",
		"- Item 1: inside ONE scale the best policy changes with how far over he is AND with the boxer. A change = each cell's best is outside the other cell's leading group (best plus everything inside two standard errors of it).",
		"- Item 2: moving DOWN best or tied in one cell or more of a boxer who works off the jab (Out-boxer or Boxer-puncher); moving UP best or tied in one cell or more of the chin with no reach (Chin 64 or more, the least reach against the class).", ""])
	var cells: Array = []
	for b in Model.BOXERS:
		for sc in Model.SCALES:
			var cell := {"b": b, "sc": sc, "id": "%s / %s" % [b["shape"], sc["id"]]}
			var same := is_equal_approx(float(Model.plan_choice(cell, "CUT")["walk"]), float(Model.plan_choice(cell, "STAY")["walk"]))
			cell["keys"] = ["STAY", "UP", "DOWN"] if same else Model.CHOICES
			cells.append(cell)
	_fit(cells, cal, bouts)
	var main := {}      # cell id -> choice -> Array of run results (one a seed)
	for cell in cells:
		main[cell["id"]] = {}
		for ch in cell["keys"]:
			var runs: Array = []
			var pl := M.plans_choice(cell, ch, "")
			for s in seeds:
				runs.append(M.run(cell, pl, s, bouts, ""))
			main[cell["id"]][ch] = runs
		print("cell %s done, %d bouts, %.0f s" % [cell["id"], M.n_bouts, M.secs()])
	M.say(["## 1. Who they are", "", "Height and reach are the game's own (BodyFacts, seeded by the name); the class columns are the mean frame of the class below, their own and the class above (AttrGen.body: 1 cm a kg).", "",
		"| Boxer (shape) | Style | Class | Walks | Power | Speed | Stamina | Chin | Discipline | Confidence | Loyalty | Height | Reach | Reach of the class below / own / above |", "| :--- | :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
	for b in Model.BOXERS:
		var t := Model.person(str(b["who"]))
		var f := Data.fighter_state(t.duplicate(true), Model.DAY0)
		var sx := str(t["sex"])
		M.say("| %s (%s) | %s | %.0f kg | %.1f kg | %.0f | %.0f | %.0f | %.0f | %.0f | %.0f | %.0f | %d cm | %d cm | %.0f / %.0f / %.0f cm |" % [t["name"], b["shape"], t["style"], Model.limit0(t), float(t["weight"]) + float(b["over"]),
			t["stats"]["power"], t["stats"]["speed"], t["stats"]["conditioning"], t["stats"]["chin"], t["personality"]["discipline"], t["personality"]["confidence"], t["personality"]["loyalty"],
			int(f["height"]), int(f["reach"]), Model.class_frame(sx, Model.class_step(t, -1))[1], Model.class_frame(sx, Model.limit0(t))[1], Model.class_frame(sx, Model.class_step(t, 1))[1]])
	M.say(["", "## 2. The cell table (round 4's four class choices, on the three scales)", "",
		"Diet = % of walking weight held off by the diet, its weeks at 0.7 % a week and the share of training gain kept while he holds it; by water = the rest (the first 2 % is free and comes off first);",
		"dry = % still missing at the bell (a pro: on the average night); Stamina = % of his Stamina and tank the cut costs on the first boxing day; size gap = his ring weight against the field's mean ring weight;",
		"refuses = the chance he says no; win, stopped (won inside / lost inside) = shares of the bouts fought; late = last third of the rounds won; missed = scales missed a run; no bout = bouts lost to the scale a run",
		"(club show: called off, nothing on the record; championship: a walkover loss); moved = runs where two misses moved him up; bouts = bouts boxed a run; place = ladder rung at the end (1 is the top; start 10, a class move 11) +- its standard error over the %d seeds." % seeds, ""])
	var zero := {"STAY": 0, "CUT": 0, "UP": 0, "DOWN": 0}
	var best_count := zero.duplicate(); var clear_count := zero.duplicate(); var in_count := zero.duplicate()
	var n_clear := 0; var n_cut := 0
	var summary: Array = ["| Cell | STAY | CUT | UP | DOWN | Best | Inside the noise of it | CUT against STAY (rungs; + is worse) |", "| :--- | ---: | ---: | ---: | ---: | :--- | :--- | ---: |"]
	var cut_worse: Array = []   # amateur cells where CUT is clearly worse than STAY
	var up_ko := [0.0, 0.0, 0.0, 0.0]; var up_st := [0.0, 0.0, 0.0, 0.0]
	var lead := {}      # cell id -> the leading group (best first)
	var aggs := {}
	for cell in cells:
		var id := str(cell["id"])
		var keys: Array = cell["keys"]
		var t := Model.person(str(cell["b"]["who"]))
		M.say(["### %s (%s)" % [id, cell["sc"]["name"]], "",
			"| Choice | Class | Walks | Diet | Weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | No bout | Moved | Bouts | Place |",
			"| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
		var agg := {}
		for ch in keys:
			agg[ch] = Model.agg(main[id][ch])
			var su: Dictionary = M.night(t, Model.plan_choice(cell, ch), cell["sc"], "")
			M.say("| %s | %.0f | %.1f kg | %.1f %% | %.1f | %.0f %% | %.1f %% | %.1f %% | -%.1f %% | %+.1f %% | %.0f %% | %.0f %% | %.0f / %.0f %% | %.0f %% | %.2f | %.2f | %.0f %% | %.1f | %.2f +- %.2f |" % [ch, su["limit"], su["walk"], su["diet"], su["weeks"], float(su["keep"]) * 100.0, su["water"],
				su["dry"], su["cond_pct"], su["gap"], M.p_refuse(cell, ch, "") * 100.0, agg[ch]["win"] * 100.0, agg[ch]["stop_w"] * 100.0, agg[ch]["stop_l"] * 100.0,
				agg[ch]["late"] * 100.0, agg[ch]["missed"], agg[ch]["void"], agg[ch]["forced"] * 100.0, agg[ch]["fought"], agg[ch]["rung"], agg[ch]["se"]])
		aggs[id] = agg
		for pair in [["STAY", 0], ["UP", 2]]:
			var g: Dictionary = agg[pair[0]]
			var o := int(pair[1])
			up_ko[o] += float(g["n_stop_w"]); up_ko[o + 1] += float(g["n_win"])
			up_st[o] += float(g["n_stop_l"]); up_st[o + 1] += float(g["n_fought"])
		var best := Model.best(agg, keys)
		best_count[best] += 1
		var ties: Array = Model.ties(main[id], best, keys)
		lead[id] = [best] + ties
		for ch in lead[id]:
			in_count[ch] += 1
		if ties.is_empty():
			clear_count[best] += 1
			n_clear += 1
		M.say(["", "Best: **%s**%s%s" % [best, "" if ties.is_empty() else " - a tie with %s (inside two standard errors of the paired difference)" % ", ".join(ties),
			"" if keys.has("CUT") else ". CUT harder is not a choice here: this boxer already walks that heavy, it is the same plan as STAY."], ""])
		var row := "| %s | %.2f +- %.2f | " % [id, agg["STAY"]["rung"], agg["STAY"]["se"]]
		var tail := "-"
		if keys.has("CUT"):
			n_cut += 1
			var cs: Array = Model.diff(main[id]["CUT"], main[id]["STAY"])
			var worse := float(cs[0]) > 2.0 * float(cs[1])
			if worse and not bool(cell["sc"]["pro"]):
				cut_worse.append(id)
			row += "%.2f +- %.2f" % [agg["CUT"]["rung"], agg["CUT"]["se"]]
			tail = "%+.2f +- %.2f%s" % [cs[0], cs[1], " (clearly worse)" if worse else (" (clearly better)" if float(cs[0]) < -2.0 * float(cs[1]) else "")]
		else:
			row += "= STAY"
		summary.append(row + " | %.2f +- %.2f | %.2f +- %.2f | %s | %s | %s |" % [agg["UP"]["rung"], agg["UP"]["se"], agg["DOWN"]["rung"], agg["DOWN"]["se"], best, "-" if ties.is_empty() else ", ".join(ties), tail])
	M.say(["## 3. Ladder place at the end, every cell (lower is better; +- one standard error)", ""])
	M.say(summary)
	var top := 0
	for ch in Model.CHOICES:
		top = maxi(top, int(best_count[ch]))
	var top_bar := int(floor(0.6 * float(cells.size()))); var clear_bar := int(ceil(0.4 * float(cells.size()))); var cut_bar := int(floor(0.6 * float(n_cut)))
	M.say(["", "Best counts (the lowest place, round 2's rule): %s. The most any one choice wins: %d of %d cells (bar: %d or fewer)." % [str(best_count), top, cells.size(), top_bar],
		"Clear bests (no other choice inside the noise): %s - %d of %d cells are clear (bar: %d or more)." % [str(clear_count), n_clear, cells.size(), clear_bar],
		"Best or tied for best: %s. CUT harder is in the leading group of %d of the %d cells where it is a choice (bar: %d or fewer)." % [str(in_count), int(in_count["CUT"]), n_cut, cut_bar],
		"Amateur cells where CUT harder is clearly worse than STAY (two standard errors, seed by seed): %d (%s) (bar: 1 or more)." % [cut_worse.size(), ", ".join(cut_worse) if not cut_worse.is_empty() else "none"], "",
		"Moving up, all cells pooled: knockout share of the wins %.0f %% staying, %.0f %% up (x %.2f); stopped %.1f in 100 bouts staying, %.1f up (x %.2f)." % [
			up_ko[0] / maxf(1.0, up_ko[1]) * 100.0, up_ko[2] / maxf(1.0, up_ko[3]) * 100.0, (up_ko[2] / maxf(1.0, up_ko[3])) / maxf(0.001, up_ko[0] / maxf(1.0, up_ko[1])),
			up_st[0] / maxf(1.0, up_st[1]) * 100.0, up_st[2] / maxf(1.0, up_st[3]) * 100.0, (up_st[2] / maxf(1.0, up_st[3])) / maxf(0.001, up_st[0] / maxf(1.0, up_st[1]))],
		"John E (ESTIMATE, half his biased count, for TWO classes up): knockout share x 0.88, stopped x 1.5.", ""])
	M.say(["## 4. Does each lever move the result? (lever off, %d seeds, against the same seeds with it on)" % abl, "",
		"frame off = the opponent's height and reach erased, as in round 4; field off = the field's cut costs it nothing, as in round 4 (it still rings as heavy).", "",
		"| Lever off | Mean change in win share | Biggest change in ladder place | Cells whose best choice changes | Moves it |", "| :--- | ---: | ---: | ---: | :--- |"])
	var old_move := true
	var slope_num := 0.0; var slope_den := 0.0
	for lv in Model.LEVERS:
		var dwin := 0.0; var n := 0; var drung := 0.0; var flips := 0
		for cell in cells:
			var id := str(cell["id"])
			var keys: Array = cell["keys"]
			var t := Model.person(str(cell["b"]["who"]))
			var on := {}; var off := {}
			for ch in keys:
				var runs: Array = []
				var pl := M.plans_choice(cell, ch, lv)
				for s in abl:
					runs.append(M.run(cell, pl, s, bouts, lv))
				off[ch] = Model.agg(runs)
				on[ch] = Model.agg((main[id][ch] as Array).slice(0, abl))
				dwin += absf(float(off[ch]["win"]) - float(on[ch]["win"]))
				n += 1
				drung = maxf(drung, absf(float(off[ch]["rung"]) - float(on[ch]["rung"])))
				if lv == "size":
					var gp := float(M.night(t, Model.plan_choice(cell, ch), cell["sc"], "")["gap"])
					slope_num += (float(on[ch]["win"]) - float(off[ch]["win"])) * gp
					slope_den += gp * gp
			if Model.best(on, keys) != Model.best(off, keys):
				flips += 1
		var moves := dwin / float(n) >= 0.015 or drung >= 0.3 or flips >= 1
		if lv != "frame" and lv != "field":
			old_move = old_move and moves
		M.say("| %s | %.1f points | %.2f rungs | %d of %d | %s |" % [lv, dwin / float(n) * 100.0, drung, flips, cells.size(), "yes" if moves else "NO"])
		print("lever %s done, %d bouts, %.0f s" % [lv, M.n_bouts, M.secs()])
	M.say(["", "Size as it lands on the ladder (lever on against off, over the size gaps of the cell choices): %.1f wins in 100 per 1 %% of ring weight." % (slope_num / maxf(0.001, slope_den) * 100.0),
		"The fit of step 0 aims at John's 3.0 with the opponents held still; on the ladder a winner meets better men, which shrinks it.", ""])
	var r4 := [old_move, top <= top_bar, n_clear >= clear_bar, int(in_count["CUT"]) <= cut_bar, not cut_worse.is_empty()]
	var ok4 := not r4.has(false)
	var ok1: bool = Round5.policy(M, int(opt["pol"]), bouts)
	var ok2: bool = Round5.frame(M, cells, main, lead, aggs)
	Round5.field(M, cells, main, mini(int(opt["read"]), seeds), bouts)
	Round5.scales(M, cells, main, lead)
	var broke: Array = []
	if not ok4: broke.append("round 4's bars")
	if not ok1: broke.append("item 1 (the policy table)")
	if not ok2: broke.append("item 2 (frame)")
	M.say(["## 9. The result", "", "%d bouts played in %.0f s." % [M.n_bouts, M.secs()], "",
		"Round 4's bars: %s (levers %s; top choice best in %d of %d cells; %d clear of the noise; CUT in the leading group of %d of %d; CUT clearly worse than STAY in %d amateur cells)." % ["hold" if ok4 else "DO NOT hold",
			"all move" if old_move else "NOT all move", top, cells.size(), n_clear, int(in_count["CUT"]), n_cut, cut_worse.size()],
		"Item 1 (the same kilos by diet, water, mix or up): %s. Item 2 (frame): %s." % ["holds" if ok1 else "DOES NOT hold", "holds" if ok2 else "DOES NOT hold"], "",
		"RESULT: tools/weight2_probe.gd -> %s%s" % ["PASS" if broke.is_empty() else "FAIL", "" if broke.is_empty() else " (broke: %s)" % ", ".join(broke)]])
	var fa := FileAccess.open("res://docs/WEIGHT2_PROBE5.md", FileAccess.WRITE)
	if fa != null:
		fa.store_string("\n".join(M.L) + "\n"); fa.close()
	print("WEIGHT2 probe done (%.0f s)" % M.secs())
	quit(0)

## Step 0, the fit. Plain bouts (no cut of ours, no ladder; the field at the boxer's own paper strength plus its offset, WITH its own cut and with frame on)
## measure in wins: a rating point, the size split of the stats, and a class of frame (the opponent's body drawn from the class above / below).
## size_rating is set so 1 % of ring weight is worth John's size_win; frame_rate is what a cm of class frame is worth on average; the field so that STAY starts at about half.
func _fit(cells: Array, cal: int, bouts: int) -> void:
	if cal <= 0:
		M.say(["## 0. The fit: skipped (cal=0), size_rating %.2f, frame_rate %.2f, field %s" % [M.size_rating, M.frame_rate, str(M.opp_off)], ""])
		return
	var g := 4.0; var r := 2.0   # % of ring weight and rating points, either way
	var cap := float(Model.MODEL["size_cap"])
	var plus := {"power": clampf(float(Model.MODEL["size_power"]) * g, -cap, cap), "chin": clampf(float(Model.MODEL["size_chin"]) * g, -cap, cap), "speed": -clampf(float(Model.MODEL["size_speed"]) * g, -cap, cap)}
	var minus := {"power": -float(plus["power"]), "chin": -float(plus["chin"]), "speed": -float(plus["speed"])}
	var win := {}; var n := {}
	for sc in Model.SCALES:
		win[sc["id"]] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]; n[sc["id"]] = 0.0
	var step_cm := 0.0
	var rng := RandomNumberGenerator.new()
	for cell in cells:
		var t := Model.person(str(cell["b"]["who"]))
		var sc: Dictionary = cell["sc"]
		var sid := str(sc["id"])
		var base := BoutRules.fight_power(t["stats"], {}, 0, "", false)
		var own := Model.limit0(t)
		step_cm += (Model.class_step(t, 1) - Model.class_step(t, -1)) / 2.0 / float(cells.size())
		var stay := Model.plan_choice(cell, "STAY")
		var cfg := [[{}, 0.0, own], [plus, 0.0, own], [minus, 0.0, own], [{}, -r, own], [{}, r, own], [{}, 0.0, Model.class_step(t, 1)], [{}, 0.0, Model.class_step(t, -1)]]
		var cuts: Array = sc["opp_cut"]
		for s in cal:
			for k in bouts:
				n[sid] = float(n[sid]) + 1.0
				rng.seed = hash(["fit", str(cell["id"]), s, k])
				var fld: Dictionary = M.night(t, stay, sc, "", -1.0, 0, float(cuts[mini(cuts.size() - 1, int(rng.randf() * float(cuts.size())))]))
				for i in cfg.size():
					var rating := base + float(M.opp_off[sid]) + float(cfg[i][1]) - float(fld["drop"])
					var o := M.bout(t, sc, {"add": cfg[i][0], "fade": fld["fade"]}, rating, own, float(cfg[i][2]), s, k, 0.0)
					if str(o["outcome"]) == "win":
						win[sid][i] = float(win[sid][i]) + 1.0
		print("fit %s done, %d bouts, %.0f s" % [cell["id"], M.n_bouts, M.secs()])
	var tot := [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]; var tn := 0.0
	for sc in Model.SCALES:
		tn += float(n[sc["id"]])
		for i in 7:
			tot[i] += float(win[sc["id"]][i])
	var s_stat: float = (tot[1] - tot[2]) / tn / (2.0 * g) * 100.0     # wins in 100 per 1 % from the stats alone
	var s_rate: float = (tot[3] - tot[4]) / tn / (2.0 * r) * 100.0     # wins in 100 per rating point
	var s_frame: float = (tot[6] - tot[5]) / tn / (2.0 * step_cm) * 100.0   # wins in 100 per cm of class frame (the class step is 1 cm a kg)
	M.size_rating = clampf((float(Model.MODEL["size_win"]) - s_stat) / maxf(0.5, s_rate), 0.0, 3.0)
	M.frame_rate = clampf(s_frame / maxf(0.5, s_rate), 0.0, 1.0)
	M.say(["## 0. The fit (%d seeds x %d bouts a cell and setting, no cut of ours, no ladder; the field with its own cut, frame on; %d bouts)" % [cal, bouts, int(tn) * 7], "",
		"| Scale | plain | 4 % bigger (stats only) | 4 % smaller | field 2 points weaker | field 2 points stronger | opponent's frame from the class above | from the class below |", "| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
	for sc in Model.SCALES:
		var w: Array = win[sc["id"]]
		var m := float(n[sc["id"]])
		M.say("| %s | %.0f %% | %.0f %% | %.0f %% | %.0f %% | %.0f %% | %.0f %% | %.0f %% |" % [sc["id"], w[0] / m * 100.0, w[1] / m * 100.0, w[2] / m * 100.0, w[3] / m * 100.0, w[4] / m * 100.0, w[5] / m * 100.0, w[6] / m * 100.0])
	M.say(["", "Measured: the size split of punch, chin and hand speed is worth %.2f wins in 100 per 1 %% of ring weight; a rating point %.2f wins in 100; a cm of class frame (height and reach together, the class step is %.1f cm) %.2f wins in 100." % [s_stat, s_rate, step_cm, s_frame],
		"John (DERIVED, Baribeau 2023): about %.1f wins in 100 per 1 %% heavier. So the rest goes in the exchanges: size_rating = %.2f rating points per 1 %%." % [float(Model.MODEL["size_win"]), M.size_rating],
		"Frame and mass together (Kalli's point 6): a class move's size term already pays for being the bigger or smaller man, so the AVERAGE worth of the frame that comes with the class, %.2f rating points a cm, is taken back out of a move. What is left of frame is the boxer's own: more than average for one who lives on the long jab, less for one who does not." % M.frame_rate])
	for sc in Model.SCALES:
		var sid := str(sc["id"])
		var gap := 0.0; var m := 0.0
		for cell in cells:
			if str(cell["sc"]["id"]) == sid:
				gap += float(M.night(Model.person(str(cell["b"]["who"])), Model.plan_choice(cell, "STAY"), sc, "")["gap"])
				m += 1.0
		gap /= maxf(1.0, m)
		var plain := float(win[sid][0]) / float(n[sid]) * 100.0
		var expect := plain + float(Model.MODEL["size_win"]) * gap
		var was := float(M.opp_off[sid])
		M.opp_off[sid] = clampf(was + (expect - 50.0) / maxf(0.5, s_rate), -14.0, 6.0)
		M.say("Field, %s: STAY's mean size gap %+.1f %% -> about %.0f %% wins at offset %.1f; the offset becomes %.1f (STAY at about half)." % [sid, gap, expect, was, float(M.opp_off[sid])])
	M.say(["Round 4's offsets were -5.3 (its amateur hybrid) and -10.9 (pro, a field that rang 7.2 % over and paid nothing).", ""])
