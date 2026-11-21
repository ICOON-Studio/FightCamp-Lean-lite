extends SceneTree
## S536 WEIGHT2R4 - WEIGHT2 greybox probe, ROUND 4 (ops/research/TASK_WEIGHT2R4.md, DESIGN_WEIGHT2_V2.md section 4). Rounds 1-3: 875376421,
## ddc061494, docs/WEIGHT2_PROBE3.md. Round 4 re-sizes: CUT is a SHARE of body (4 % left as water at the class line), a pro gets back a SHARE of
## the water he took off, the diet prints its weeks, 40 seeds a cell. Nothing here is in scripts/. Real Data people, each bout through
## BoutNight.play_out on a scratch Career (the dice are the fight DAY's; every choice of one seed fights the same days). 10 cells = 5 boxers x
## 2 scales; 4 choices: STAY, CUT harder, UP a class, DOWN a class; a run = N bouts on a 20-rung ladder. Step 0 fits size to John's "+3 wins in
## 100 per 1 % heavier" and the field to "STAY wins half". PASS (all): each lever moves; no choice best in more than 6 of 10 cells; 4 or more
## cells CLEAR of the noise; CUT in the leading group of at most 6; one amateur cell or more where CUT is clearly worse than STAY.
##   python ops/Tools/godot_slot.py run --who weight2r4 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd [-- seeds=40 bouts=12 abl=3 cal=10]

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## The scratch class table (kg): the design's proposed one, so every boxer has a class above and below (men's 65 = Q-292).
const LIMITS := {"f": [54.0, 57.0, 60.0, 65.0, 70.0, 75.0, 81.0], "m": [55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 86.0]}
## who = Data id; over = kilos added to the Data walking weight (the cutter has grown out of her class).
const BOXERS := [
	{"shape": "puncher", "who": "samira", "over": 0.0}, {"shape": "volume", "who": "josh", "over": 0.0}, {"shape": "big chin", "who": "tess", "over": 0.0},
	{"shape": "drained cutter", "who": "kira", "over": 2.5}, {"shape": "boxer-puncher", "who": "danny", "over": 0.0},
]
## John's numbers by scale (tags in DESIGN_WEIGHT2_V2.md section 2). Amateur regain = % of body mass back by the bell.
## Pro: he gets back a SHARE of the water he took off: 0.9 on average = John's 7.2 % mean regain over his 8 % cut cap
## (DERIVED by me: the 399 boxers' own cuts are not in his note, so the divisor is the guidance cap), as four nights in
## five 0.8125 and one in five 1.25 (John: one in five regains 10 % or more; 10 / 8). opp_regain = the field's. free =
## the cut that costs nothing; cond / power / read = % of the stat lost per 1 % cut past it (cond2 / power2: the extra
## past the knee); water_ok = the safe line; cap = past it he cannot make the scale; miss_base = the miss rate on a safe
## cut; walkover = a missed amateur scale is a walkover loss, a pro who misses boxes on (and is fined).
const SCALES := [
	{"id": "am", "name": "amateur, weighed an hour before, 3 rounds", "pro": false, "rounds": 3, "regain": 0.5, "opp_regain": 0.5,
		"free": 2.0, "cond": 4.0, "power": 1.5, "read": 1.0, "knee": 99.0, "cond2": 0.0, "power2": 0.0,
		"water_ok": 3.0, "cap": 5.0, "miss_base": 0.01, "walkover": true, "opp_off": -3.0},
	{"id": "pro", "name": "pro, weighed the day before, 6 rounds", "pro": true, "rounds": 6, "share": 0.8125, "share_big": 1.25, "big_odds": 0.2, "share_mean": 0.9, "opp_regain": 7.2,
		"free": 2.0, "cond": 1.5, "power": 0.0, "read": 0.5, "knee": 5.0, "cond2": 1.5, "power2": 1.0,
		"water_ok": 8.0, "cap": 8.0, "miss_base": 0.02, "walkover": false, "opp_off": -6.0},
]
const CHOICES := ["STAY", "CUT", "UP", "DOWN"]
const LEVERS := ["drain", "size", "diet", "miss", "rank", "refuse"]
const MODEL := {
	"cut_water": 0.04,         # CUT harder: he walks big enough that 4 % of body is left for water at his own class line (task WEIGHT2R4; John: free to 2 %, same-day safe line 3 %, cap 5 %)
	"up_fill": 0.015,          # UP: eats freely, fills out this share of body (ESTIMATE; round 3's 1 kg as a share)
	"diet_hold": 0.025,        # share of walking weight held off by diet (ESTIMATE), 0.05 when moving DOWN
	"diet_hold_down": 0.05,
	"diet_pace": 0.7,          # % of body a week that keeps lean mass (SOURCED, Garthe 2011); the game's 0.45 kg a week is 0.6 to 0.8 %
	"size_power": 1.2, "size_chin": 1.0, "size_speed": 0.4, "size_cap": 8.0,          # points per 1 % ring-weight gap (ESTIMATE split; the total is fitted)
	"size_win": 3.0,           # John B (DERIVED, Baribeau 2023, 1,392 boxers: odds x 1.13 per 1 %): wins in 100 per 1 % heavier at even odds
	"tank_max": 25.0,          # CODE: BoutRules.TANK_MAX
	"grow": 0.33, "diet_cost": 0.12, "grow_min": 0.4,                                 # stat points a bout cycle; x (1 - cost x % held) = 0.084 off per diet week (ESTIMATE: John found no number)
	"miss_slope": 0.20, "miss_max": 0.7,                                               # a % of water past the safe line, x (1.5 - discipline / 100) (ESTIMATE)
	"miss_push": 2,            # John C: two misses and he is moved up a class
	"rung0": 10.0, "rung_move": 11.0, "rung_gap": 1.2, "rung_max": 20.0, "field_grow": 0.15,   # round 2: a move costs ONE rung
	"refuse_up": 0.30, "refuse_down": 0.50, "refuse_conf": 0.005, "refuse_loyal": 0.006, "refuse_wish": 0.25, "refuse_wait": 3,   # Q-293 (design numbers)
}
const PLANS := [
	{"arrows": [{"move": "1-2"}, {"move": "step_in"}, {"move": "cut_off"}, {"move": "tie_up"}], "combos": {"1-2": 60.0, "1-1": 45.0}},
	{"arrows": [{"move": "2-3"}, {"move": "feint"}, {"move": "pivot_out"}, {"move": "1-2"}], "combos": {"2-3": 60.0, "1-2": 50.0}},
]
const DAY0 := 50000

var L: Array = []
var t0 := 0
var n_bouts := 0
var size_rating := 0.35                 # fitted in step 0: rating points the opponent is worth per 1 % he outweighs us
var opp_off := {"am": -3.0, "pro": -6.0}   # fitted in step 0: the field, so that STAY wins about half

func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	var opt := {"seeds": 40, "bouts": 12, "abl": 3, "cal": 10}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2 and opt.has(kv[0]): opt[kv[0]] = int(kv[1])
	var seeds := int(opt["seeds"]); var bouts := int(opt["bouts"]); var cal := int(opt["cal"]); var abl := mini(int(opt["abl"]), seeds)
	_say(["# WEIGHT2 probe, ROUND 4 - the cut as a share of body, a pro's regain as a share of the cut, the diet shown (S536 WEIGHT2R4)", "",
		"Round 3 (docs/WEIGHT2_PROBE3.md) passed weakly: no cell clear of the noise and CUT harder in the leading group of all ten. Round 4 re-sizes the scratch model:",
		"CUT harder = walk big enough that 4 % of body is left as water at his own class line (was a flat 2 kg); a pro gets back a share of the water he took off (0.9 on average;",
		"four nights in five 0.81, one in five 1.25), not a flat 7.2 %; the diet prints its weeks at 0.7 % a week and the training it keeps; 40 seeds a cell; three more bars (section 3).", "",
		"Run: " + "python ops/Tools/godot_slot.py run --who weight2r4 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd -- seeds=%d bouts=%d abl=%d cal=%d" % [seeds, bouts, abl, cal], "",
		"What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets), and every bout (BoutNight.play_out, the game's fight night). What is scratch: the weight model below.",
		"Each run = %d bouts on a 20-rung ladder; %d seeds a cell; every choice of a seed fights the same nights (same dice)." % [bouts, seeds], "",
		"Scales: " + str(SCALES), "", "Model: " + str(MODEL), ""])
	var cells: Array = []
	for b in BOXERS:
		for sc in SCALES:
			cells.append({"b": b, "sc": sc, "id": "%s / %s" % [b["shape"], sc["id"]]})
	_fit(cells, cal, bouts)
	var main := {}      # cell id -> choice -> Array of run results (one a seed)
	for cell in cells:
		main[cell["id"]] = {}
		for ch in CHOICES:
			var runs: Array = []
			for s in seeds:
				runs.append(_run(cell, ch, s, bouts, ""))
			main[cell["id"]][ch] = runs
		print("cell %s done, %d bouts, %.0f s" % [cell["id"], n_bouts, _secs()])
	_say(["## 1. Who they are", "", "| Boxer (shape) | Class | Walks | Power | Speed | Stamina (cond.) | Chin | Discipline | Confidence | Loyalty |", "| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
	for b in BOXERS:
		var t := _person(str(b["who"]))
		_say("| %s (%s) | %.0f kg | %.1f kg | %.0f | %.0f | %.0f | %.0f | %.0f | %.0f | %.0f |" % [t["name"], b["shape"], _limit0(t), float(t["weight"]) + float(b["over"]), t["stats"]["power"], t["stats"]["speed"], t["stats"]["conditioning"], t["stats"]["chin"], t["personality"]["discipline"], t["personality"]["confidence"], t["personality"]["loyalty"]])
	_say(["", "## 2. The cell table", "",
		"Cut = kilos over the class; diet = weeks of dieting at 0.7 % of body a week to hold the rest off (SOURCED pace, Garthe 2011) and the share of",
		"training gain he keeps while holding it; by water = the part left for fight week (% of body weight); dry = % still missing at the bell (a pro: on the average night);",
		"Stamina = % of his Stamina and tank the cut costs; size gap = his ring weight against the opponent's; refuses = the chance he says no;",
		"win and stopped (won inside / lost inside) are shares of the bouts fought; late = last third of the rounds won; missed = scales missed a run;",
		"moved = runs where two misses moved him up a class; place = ladder rung at the end (1 is the top; start 10, a class move 11) with its standard error over the %d seeds." % seeds, ""])
	var best_count := {"STAY": 0, "CUT": 0, "UP": 0, "DOWN": 0}
	var clear_count := best_count.duplicate()
	var in_count := best_count.duplicate()
	var n_clear := 0
	var summary: Array = ["| Cell | STAY | CUT | UP | DOWN | Best | Inside the noise of it | CUT against STAY (rungs; + is worse) |", "| :--- | ---: | ---: | ---: | ---: | :--- | :--- | ---: |"]
	var cut_worse: Array = []   # amateur cells where CUT is clearly worse than STAY
	var up_ko := [0.0, 0.0, 0.0, 0.0]   # STAY wins inside / wins, UP wins inside / wins
	var up_st := [0.0, 0.0, 0.0, 0.0]   # STAY stopped / fought, UP stopped / fought
	for cell in cells:
		var id := str(cell["id"])
		_say(["### %s (%s)" % [id, cell["sc"]["name"]], "",
			"| Choice | Class | Walks | Cut | Diet weeks | Training kept | By water | Dry at the bell | Stamina | Size gap | Refuses | Win | Stopped W / L | Late | Missed | Moved | Place |",
			"| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
		var agg := {}
		for ch in CHOICES:
			agg[ch] = _agg(main[id][ch])
			var su: Dictionary = _setup(cell, ch, "")
			_say("| %s | %.0f | %.1f kg | %.1f kg | %.1f | %.0f %% | %.1f %% | %.1f %% | -%.1f %% | %+.1f %% | %.0f %% | %.0f %% | %.0f / %.0f %% | %.0f %% | %.2f | %.0f %% | %.2f +- %.2f |" % [ch, su["limit"], su["walk"], su["over"], su["weeks"], float(su["keep"]) * 100.0, su["water_pct"],
				su["dry"], su["cond_pct"], su["gap"], float(su["p_refuse"]) * 100.0, agg[ch]["win"] * 100.0, agg[ch]["stop_w"] * 100.0, agg[ch]["stop_l"] * 100.0,
				agg[ch]["late"] * 100.0, agg[ch]["missed"], agg[ch]["forced"] * 100.0, agg[ch]["rung"], agg[ch]["se"]])
		for pair in [["STAY", 0], ["UP", 2]]:
			var g: Dictionary = agg[pair[0]]
			var o := int(pair[1])
			up_ko[o] += float(g["n_stop_w"]); up_ko[o + 1] += float(g["n_win"])
			up_st[o] += float(g["n_stop_l"]); up_st[o + 1] += float(g["n_fought"])
		var best := _best(agg)
		best_count[best] += 1
		var ties: Array = _ties(main[id], best)
		in_count[best] += 1
		for ch in ties:
			in_count[ch] += 1
		if ties.is_empty():
			clear_count[best] += 1
			n_clear += 1
		_say(["", "Best: **%s**%s" % [best, "" if ties.is_empty() else " - a tie with %s (inside two standard errors of the paired difference)" % ", ".join(ties)], ""])
		var cs: Array = _diff(main[id]["CUT"], main[id]["STAY"])
		var worse := float(cs[0]) > 2.0 * float(cs[1])
		if worse and not bool(cell["sc"]["pro"]):
			cut_worse.append(id)
		summary.append("| %s | %.2f +- %.2f | %.2f +- %.2f | %.2f +- %.2f | %.2f +- %.2f | %s | %s | %+.2f +- %.2f%s |" % [id, agg["STAY"]["rung"], agg["STAY"]["se"], agg["CUT"]["rung"], agg["CUT"]["se"],
			agg["UP"]["rung"], agg["UP"]["se"], agg["DOWN"]["rung"], agg["DOWN"]["se"], best, "-" if ties.is_empty() else ", ".join(ties),
			cs[0], cs[1], " (clearly worse)" if worse else (" (clearly better)" if float(cs[0]) < -2.0 * float(cs[1]) else "")])
	_say(["## 3. Ladder place at the end, every cell (lower is better; +- one standard error)", ""])
	_say(summary)
	var top := 0; var top_in := 0
	for ch in CHOICES:
		top = maxi(top, int(best_count[ch]))
		top_in = maxi(top_in, int(in_count[ch]))
	_say(["", "Best counts (the lowest place, round 2's rule): %s. The most any one choice wins: %d of %d cells (bar: 6 or fewer)." % [str(best_count), top, cells.size()],
		"Clear bests (no other choice inside the noise): %s - %d of %d cells are clear." % [str(clear_count), n_clear, cells.size()],
		"Best or tied for best: %s - the most any one choice is in the leading group: %d of %d cells; CUT harder in %d (bar: 6 or fewer)." % [str(in_count), top_in, cells.size(), int(in_count["CUT"])],
		"Amateur cells where CUT harder is clearly worse than STAY (two standard errors, seed by seed): %d (%s) (bar: 1 or more)." % [cut_worse.size(), ", ".join(cut_worse) if not cut_worse.is_empty() else "none"], "",
		"Moving up, all ten cells pooled: knockout share of the wins %.0f %% staying, %.0f %% up (x %.2f); stopped %.1f in 100 bouts staying, %.1f up (x %.2f)." % [
			up_ko[0] / maxf(1.0, up_ko[1]) * 100.0, up_ko[2] / maxf(1.0, up_ko[3]) * 100.0, (up_ko[2] / maxf(1.0, up_ko[3])) / maxf(0.001, up_ko[0] / maxf(1.0, up_ko[1])),
			up_st[0] / maxf(1.0, up_st[1]) * 100.0, up_st[2] / maxf(1.0, up_st[3]) * 100.0, (up_st[2] / maxf(1.0, up_st[3])) / maxf(0.001, up_st[0] / maxf(1.0, up_st[1]))],
		"John E (ESTIMATE, half his biased count, for TWO classes up): knockout share x 0.88, stopped x 1.5.", ""])
	_say(["## 4. Does each lever move the result? (lever off, %d seeds, against the same seeds with it on)" % abl, "",
		"| Lever off | Mean change in win share | Biggest change in ladder place | Cells whose best choice changes | Moves it |", "| :--- | ---: | ---: | ---: | :--- |"])
	var all_move := true
	var slope_num := 0.0; var slope_den := 0.0
	for lv in LEVERS:
		var dwin := 0.0; var n := 0; var drung := 0.0; var flips := 0
		for cell in cells:
			var id := str(cell["id"])
			var on := {}
			var off := {}
			for ch in CHOICES:
				var runs: Array = []
				for s in abl:
					runs.append(_run(cell, ch, s, bouts, lv))
				off[ch] = _agg(runs)
				on[ch] = _agg((main[id][ch] as Array).slice(0, abl))
				dwin += absf(float(off[ch]["win"]) - float(on[ch]["win"]))
				n += 1
				drung = maxf(drung, absf(float(off[ch]["rung"]) - float(on[ch]["rung"])))
				if lv == "size":
					var gp := float(_setup(cell, ch, "")["gap"])
					slope_num += (float(on[ch]["win"]) - float(off[ch]["win"])) * gp
					slope_den += gp * gp
			if _best(on) != _best(off):
				flips += 1
		var moves := dwin / float(n) >= 0.015 or drung >= 0.3 or flips >= 1
		all_move = all_move and moves
		_say("| %s | %.1f points | %.2f rungs | %d of %d | %s |" % [lv, dwin / float(n) * 100.0, drung, flips, cells.size(), "yes" if moves else "NO"])
		print("lever %s done, %d bouts, %.0f s" % [lv, n_bouts, _secs()])
	_say(["", "Size as it lands on the ladder (lever on against off, over the size gaps of the 40 cell choices): %.1f wins in 100 per 1 %% of ring weight." % (slope_num / maxf(0.001, slope_den) * 100.0),
		"The fit of step 0 aims at John's 3.0 with the opponents held still; on the ladder a winner meets better men, which shrinks it."])
	var bars := [all_move, top <= 6, n_clear >= 4, int(in_count["CUT"]) <= 6, not cut_worse.is_empty()]
	var ok := not bars.has(false)
	_say(["", "%d bouts played in %.0f s." % [n_bouts, _secs()], "",
		"RESULT: tools/weight2_probe.gd -> %s (levers %s; top choice best in %d of %d cells; %d of %d cells clear of the noise; CUT in the leading group of %d; CUT clearly worse than STAY in %d amateur cells)" % ["PASS" if ok else "FAIL",
			"all move" if all_move else "NOT all move", top, cells.size(), n_clear, cells.size(), int(in_count["CUT"]), cut_worse.size()]])
	var fa := FileAccess.open("res://docs/WEIGHT2_PROBE4.md", FileAccess.WRITE)
	if fa != null:
		fa.store_string("\n".join(L) + "\n"); fa.close()
	print("WEIGHT2 probe done (%.0f s)" % _secs())
	quit(0)

## Step 0, the fit. Plain bouts (no cut, no ladder; opponents at the boxer's own paper strength plus the field's offset) measure a rating point and the
## size split of the stats in wins; size_rating is set so 1 % of ring weight is worth John's size_win, the field so that STAY starts at about half.
func _fit(cells: Array, cal: int, bouts: int) -> void:
	if cal <= 0:
		_say(["## 0. The fit: skipped (cal=0), size_rating %.2f, field %s" % [size_rating, str(opp_off)], ""])
		return
	var g := 4.0; var r := 2.0   # % of ring weight and rating points, either way
	var cap := float(MODEL["size_cap"])
	var plus := {"power": clampf(float(MODEL["size_power"]) * g, -cap, cap), "chin": clampf(float(MODEL["size_chin"]) * g, -cap, cap), "speed": -clampf(float(MODEL["size_speed"]) * g, -cap, cap)}
	var minus := {"power": -float(plus["power"]), "chin": -float(plus["chin"]), "speed": -float(plus["speed"])}
	var win := {"am": [0.0, 0.0, 0.0, 0.0, 0.0], "pro": [0.0, 0.0, 0.0, 0.0, 0.0]}   # scale id -> wins a setting
	var n := {"am": 0.0, "pro": 0.0}
	for cell in cells:
		var t := _person(str(cell["b"]["who"]))
		var sc: Dictionary = cell["sc"]
		var sid := str(sc["id"])
		var base := BoutRules.fight_power(t["stats"], {}, 0, "", false)
		var pool := _pool(str(t["sex"]))
		var cfg := [[{}, 0.0], [plus, 0.0], [minus, 0.0], [{}, -r], [{}, r]]
		for s in cal:
			for k in bouts:
				n[sid] = float(n[sid]) + 1.0
				for i in cfg.size():
					var rating := base + float(opp_off[sid]) + float(cfg[i][1])
					var o := _bout(t, sc, cfg[i][0], {}, 0.0, rating, float(_limit0(t)), pool, s, k, 0.0)
					if str(o["outcome"]) == "win":
						win[sid][i] = float(win[sid][i]) + 1.0
		print("fit %s done, %d bouts, %.0f s" % [cell["id"], n_bouts, _secs()])
	var tot := [0.0, 0.0, 0.0, 0.0, 0.0]; var tn := 0.0
	for sc in SCALES:
		tn += float(n[sc["id"]])
		for i in 5:
			tot[i] += float(win[sc["id"]][i])
	var s_stat: float = (tot[1] - tot[2]) / tn / (2.0 * g) * 100.0     # wins in 100 per 1 % from the stats alone
	var s_rate: float = (tot[3] - tot[4]) / tn / (2.0 * r) * 100.0     # wins in 100 per rating point
	size_rating = clampf((float(MODEL["size_win"]) - s_stat) / maxf(0.5, s_rate), 0.0, 3.0)
	_say(["## 0. The fit (%d seeds x %d bouts a cell and setting, no cut, no ladder; %d bouts)" % [cal, bouts, int(tn) * 5], "",
		"| Scale | plain | 4 % bigger (stats only) | 4 % smaller | field 2 points weaker | field 2 points stronger |", "| :--- | ---: | ---: | ---: | ---: | ---: |"])
	for sc in SCALES:
		var w: Array = win[sc["id"]]
		var m := float(n[sc["id"]])
		_say("| %s | %.0f %% | %.0f %% | %.0f %% | %.0f %% | %.0f %% |" % [sc["id"], w[0] / m * 100.0, w[1] / m * 100.0, w[2] / m * 100.0, w[3] / m * 100.0, w[4] / m * 100.0])
	_say(["", "Measured: the size split of punch, chin and hand speed is worth %.2f wins in 100 per 1 %% of ring weight; a rating point %.2f wins in 100." % [s_stat, s_rate],
		"John (DERIVED, Baribeau 2023): about %.1f wins in 100 per 1 %% heavier. So the rest goes in the exchanges: size_rating = %.2f rating points per 1 %%." % [float(MODEL["size_win"]), size_rating]])
	for sc in SCALES:
		var sid := str(sc["id"])
		var gap := 0.0; var m := 0.0
		for cell in cells:
			if str(cell["sc"]["id"]) == sid:
				gap += float(_setup(cell, "STAY", "")["gap"])
				m += 1.0
		gap /= maxf(1.0, m)
		var plain := float(win[sid][0]) / float(n[sid]) * 100.0
		var expect := plain + float(MODEL["size_win"]) * gap
		var was := float(opp_off[sid])
		opp_off[sid] = clampf(was + (expect - 50.0) / maxf(0.5, s_rate), -14.0, 6.0)
		_say("Field, %s: STAY's mean size gap %+.1f %% -> about %.0f %% wins at offset %.1f; the offset becomes %.1f (STAY at about half)." % [sid, gap, expect, was, float(opp_off[sid])])
	_say("")

static func _person(id: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			return (p as Dictionary).duplicate(true)
	return Data.lucy()

static func _limit0(t: Dictionary) -> float: return float(Data.DIVISIONS[str(t["div"])]["limit"])

## The class limit a choice boxes at: the scratch table's step up or down from the boxer's own limit.
static func _class(t: Dictionary, ch: String) -> float:
	var own := _limit0(t)
	var row: Array = LIMITS[str(t["sex"])]
	var i := 0
	for k in row.size():
		if absf(float(row[k]) - own) < absf(float(row[i]) - own):
			i = k
	if ch == "UP":
		i = mini(row.size() - 1, i + 1)
	elif ch == "DOWN":
		i = maxi(0, i - 1)
	return float(row[i])

## The walking weight of a choice: his own; CUT harder = big enough that cut_water of body is left for fight week at his
## own class line after the diet's share (never smaller than he is); UP = filled out by up_fill.
static func _walk(cell: Dictionary, t: Dictionary, ch: String) -> float:
	var walk := float(t["weight"]) + float(cell["b"]["over"])
	if ch == "CUT":
		return maxf(walk, _class(t, ch) / (1.0 - float(MODEL["diet_hold"]) - float(MODEL["cut_water"])))
	return walk * (1.0 + (float(MODEL["up_fill"]) if ch == "UP" else 0.0))

## The fight-week water (% of body weight) a choice leaves, before any lever: used for the boxer's own wish.
static func _water_pct(cell: Dictionary, ch: String) -> float:
	var t := _person(str(cell["b"]["who"]))
	var walk := _walk(cell, t, ch)
	var over := maxf(0.0, walk - _class(t, ch))
	var hold := float(MODEL["diet_hold_down"]) if ch == "DOWN" else float(MODEL["diet_hold"])
	return (over - minf(over, hold * walk)) / walk * 100.0

## The weight sums of one choice. off = the lever switched off ("" none); share = the night's regain share of a pro
## (under 0: the average night, for the tables).
## {limit, walk, over (kg to lose), diet_kg, water_kg, water_pct, dry (% missing at the bell), gap (% ring-weight gap),
##  weeks (of diet), keep (share of training gain kept), held (% held off by diet), p_miss, p_refuse, add, mult, cond_pct, tank}
static func _setup(cell: Dictionary, ch: String, off: String, share: float = -1.0) -> Dictionary:
	var t := _person(str(cell["b"]["who"]))
	var sc: Dictionary = cell["sc"]
	var limit := _class(t, ch)
	var walk := _walk(cell, t, ch)
	var over := maxf(0.0, walk - limit)
	var diet_kg := minf(over, (float(MODEL["diet_hold_down"]) if ch == "DOWN" else float(MODEL["diet_hold"])) * walk)
	var water_kg := over - diet_kg
	var water_pct := water_kg / walk * 100.0
	var regain_kg := minf(water_kg, float(sc.get("regain", 0.0)) / 100.0 * limit)
	if bool(sc["pro"]):
		regain_kg = water_kg * (share if share >= 0.0 else float(sc["share_mean"]))
	var ring := (limit + regain_kg) if over > 0.0 else walk
	var opp_ring := limit * (1.0 + float(sc["opp_regain"]) / 100.0)
	var gap := (ring - opp_ring) / opp_ring * 100.0
	var dry := (water_kg - regain_kg) / walk * 100.0
	var x := maxf(0.0, water_pct - float(sc["free"]))
	var x2 := maxf(0.0, water_pct - float(sc["knee"]))
	var cond_pct := float(sc["cond"]) * x + float(sc["cond2"]) * x2
	var power_pct := float(sc["power"]) * x + float(sc["power2"]) * x2
	var read_pct := float(sc["read"]) * x
	if off == "drain":
		cond_pct = 0.0; power_pct = 0.0; read_pct = 0.0
	if off == "size":
		gap = 0.0
	var cap := float(MODEL["size_cap"])
	var add := {
		"power": clampf(float(MODEL["size_power"]) * gap, -cap, cap),
		"chin": clampf(float(MODEL["size_chin"]) * gap, -cap, cap),
		"speed": -clampf(float(MODEL["size_speed"]) * gap, -cap, cap),
	}
	var mult := {"conditioning": 1.0 - cond_pct / 100.0, "power": 1.0 - power_pct / 100.0, "defense": 1.0 - read_pct / 100.0, "fight_iq": 1.0 - read_pct / 100.0}
	var held := 0.0 if off == "diet" else diet_kg / walk * 100.0
	var pers: Dictionary = t["personality"]
	var disc := float(pers["discipline"])
	var p_miss := 1.0
	if water_pct <= float(sc["cap"]):
		p_miss = clampf(float(sc["miss_base"]) + maxf(0.0, water_pct - float(sc["water_ok"])) * float(MODEL["miss_slope"]) * (1.5 - disc / 100.0), 0.0, float(MODEL["miss_max"]))
	if water_pct <= 0.0 or off == "miss":
		p_miss = 0.0
	var p_refuse := 0.0
	if (ch == "UP" or ch == "DOWN") and off != "refuse":
		var wants_up := _water_pct(cell, "STAY") > float(sc["water_ok"])
		p_refuse = float(MODEL["refuse_up"] if ch == "UP" else MODEL["refuse_down"]) + (float(pers["confidence"]) - 60.0) * float(MODEL["refuse_conf"]) - (float(pers["loyalty"]) - 50.0) * float(MODEL["refuse_loyal"])
		if wants_up:
			p_refuse = 0.05 if ch == "UP" else p_refuse + float(MODEL["refuse_wish"])
		p_refuse = clampf(p_refuse, 0.05, 0.9)
	return {"limit": limit, "walk": walk, "over": over, "diet_kg": diet_kg, "water_kg": water_kg, "water_pct": water_pct, "dry": dry, "gap": gap,
		"weeks": diet_kg / walk * 100.0 / float(MODEL["diet_pace"]), "keep": clampf(1.0 - float(MODEL["diet_cost"]) * held, float(MODEL["grow_min"]), 1.0),
		"held": held, "p_miss": p_miss, "p_refuse": p_refuse, "add": add, "mult": mult, "cond_pct": cond_pct,
		"tank": minf(float(MODEL["tank_max"]), cond_pct)}

## The opponents a boxer of this sex can meet: Data's region sheets, the 70+ mismatches left out.
static func _pool(sex: String) -> Array:
	var out: Array = []
	var all: Array = Data.OPPONENTS + Data.RIVALS + Data.DIVISION_RIVALS
	for o in all:
		var d := str((o as Dictionary).get("div", "wlw"))
		if str(Data.DIVISIONS[d]["sex"]) == sex and float(o["rating"]) < 68.0:
			out.append(o)
	return out

## One bout on fight night's own code. add / mult = the stat changes of the weight model, tank = points off the tank at
## the first bell, rating = the opponent's. Returns {outcome, stop, late_w, late_n}.
func _bout(t: Dictionary, sc: Dictionary, add: Dictionary, mult: Dictionary, tank: float, rating: float, limit: float, pool: Array, seed_i: int, k: int, grown: float) -> Dictionary:
	var day := DAY0 + seed_i * 211 + k * 7
	var f := Data.fighter_state(t.duplicate(true), day)
	for st in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		f["stats"][st] = float(f["stats"][st]) + grown
	for st in mult:
		f["stats"][st] = float(f["stats"][st]) * float(mult[st])
	for st in add:
		f["stats"][st] = float(f["stats"][st]) + float(add[st])
	for st in ["power", "speed", "chin", "conditioning", "defense", "fight_iq"]:
		f["stats"][st] = clampf(float(f["stats"][st]), 20.0, 95.0)
	var pl: Dictionary = PLANS[1 if bool(sc["pro"]) else 0]
	f = f.merged({"pro": bool(sc["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [], "limit": limit,
		"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
	f.erase("last_bout_day")
	var opp: Dictionary = (pool[(seed_i * 7 + k * 3 + int(day)) % pool.size()] as Dictionary).duplicate(true)
	opp["rating"] = rating
	opp.erase("height"); opp.erase("reach")
	f["bout"] = {"opp": opp, "day": day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": int(sc["rounds"]), "stale": tank}
	var c := Career.new()
	c.day = day; c.seed = seed_i + 1; c.coach = {"rating": 60.0}; c.fighters = [f]
	var m := {"type": "fight", "fid": f["id"], "step": "tape", "round": 0, "rounds": [], "total": int(sc["rounds"])}
	BoutNight.play_out(c, f, m)
	n_bouts += 1
	var res := {"outcome": BoutNight.outcome_of(f, m), "stop": BoutNight.stopped(m) != "", "late_w": 0, "late_n": 0}
	var late_from := int(ceil(float(sc["rounds"]) * 2.0 / 3.0)) + 1
	for r in m["rounds"]:
		if int(r["n"]) >= late_from:
			res["late_n"] = int(res["late_n"]) + 1
			res["late_w"] = int(res["late_w"]) + int(bool(r["won"]))
	return res

## One run: N bout slots for one boxer on one choice. Returns the counts.
func _run(cell: Dictionary, ch: String, seed_i: int, bouts: int, off: String) -> Dictionary:
	var t := _person(str(cell["b"]["who"]))
	var sc: Dictionary = cell["sc"]
	var sid := str(sc["id"])
	var pool := _pool(str(t["sex"]))
	var base := BoutRules.fight_power(t["stats"], {}, 0, "", false)
	var rng := RandomNumberGenerator.new()
	var cur := ch; var wait := -1
	rng.seed = hash([str(cell["id"]), seed_i, ch, "refuse"])
	if (ch == "UP" or ch == "DOWN") and rng.randf() < float(_setup(cell, ch, off)["p_refuse"]):
		cur = "STAY"; wait = int(MODEL["refuse_wait"])
	var su := _setup(cell, cur, off)
	var step := (float(MODEL["rung_move"]) - float(MODEL["rung0"])) if off != "rank" else 0.0
	var rung := float(MODEL["rung0"]) + (step if cur != "STAY" and cur != "CUT" else 0.0)
	var grown := 0.0; var misses := 0
	var res := {"wins": 0, "fought": 0, "stop_w": 0, "stop_l": 0, "late_w": 0, "late_n": 0, "missed": 0, "forced": 0, "refused": int(wait >= 0),
		"weeks": float(su["weeks"]), "rung": rung}
	for k in bouts:
		if k == wait:
			cur = ch; su = _setup(cell, cur, off); rung = minf(float(MODEL["rung_max"]), rung + step)
		rng.seed = hash([str(cell["id"]), seed_i, k])
		var u := rng.randf()
		var night: Dictionary = su   # a pro's regain is the night's: one in five he comes back big
		if bool(sc["pro"]):
			night = _setup(cell, cur, off, float(sc["share_big"] if rng.randf() < float(sc["big_odds"]) else sc["share"]))
		grown += float(MODEL["grow"]) * float(su["keep"])
		var missed := u < float(su["p_miss"])
		if missed:
			res["missed"] = int(res["missed"]) + 1; misses += 1
		if missed and bool(sc["walkover"]):
			rung = minf(float(MODEL["rung_max"]), rung + 1.0)   # a walkover loss (England Boxing, World Boxing)
		else:
			var rating := base + float(opp_off[sid]) + float(MODEL["field_grow"]) * float(k) + (float(MODEL["rung0"]) - rung) * float(MODEL["rung_gap"]) - size_rating * float(night["gap"])
			var o := _bout(t, sc, night["add"], night["mult"], float(night["tank"]), rating, float(night["limit"]), pool, seed_i, k, grown)
			var stop := bool(o["stop"])
			res["fought"] = int(res["fought"]) + 1
			res["late_w"] = int(res["late_w"]) + int(o["late_w"])
			res["late_n"] = int(res["late_n"]) + int(o["late_n"])
			if str(o["outcome"]) == "win":
				res["wins"] = int(res["wins"]) + 1
				rung = maxf(1.0, rung - (1.5 if stop else 1.0))
				if stop: res["stop_w"] = int(res["stop_w"]) + 1
			elif str(o["outcome"]) == "loss":
				rung = minf(float(MODEL["rung_max"]), rung + 1.0)
				if stop: res["stop_l"] = int(res["stop_l"]) + 1
		if missed and misses >= int(MODEL["miss_push"]) and cur != "UP":
			cur = "STAY" if cur == "DOWN" else "UP"
			su = _setup(cell, cur, off); rung = minf(float(MODEL["rung_max"]), rung + step)
			misses = 0; wait = -1; res["forced"] = 1
	res["rung"] = rung
	return res

static func _agg(runs: Array) -> Dictionary:
	var w := 0.0; var fo := 0.0; var sw := 0.0; var sl := 0.0; var lw := 0.0; var ln := 0.0
	var mi := 0.0; var wk := 0.0; var ru := 0.0; var r2 := 0.0; var fc := 0.0; var rf := 0.0
	for r in runs:
		w += float(r["wins"]); fo += float(r["fought"]); sw += float(r["stop_w"]); sl += float(r["stop_l"])
		lw += float(r["late_w"]); ln += float(r["late_n"]); mi += float(r["missed"]); wk += float(r["weeks"]); ru += float(r["rung"])
		r2 += float(r["rung"]) * float(r["rung"]); fc += float(r["forced"]); rf += float(r["refused"])
	var n := maxf(1.0, float(runs.size()))
	var sd := sqrt(maxf(0.0, r2 / n - (ru / n) * (ru / n)) * n / maxf(1.0, n - 1.0))
	return {"win": w / maxf(1.0, fo), "stop_w": sw / maxf(1.0, fo), "stop_l": sl / maxf(1.0, fo), "late": lw / maxf(1.0, ln),
		"missed": mi / n, "weeks": wk / n, "rung": ru / n, "se": sd / sqrt(n), "forced": fc / n, "refused": rf / n,
		"n_win": w, "n_fought": fo, "n_stop_w": sw, "n_stop_l": sl}

## The best choice of a cell: the lowest ladder place; inside 0.1 of a rung, the higher win share (round 2's rule).
static func _best(agg: Dictionary) -> String:
	var best := str(CHOICES[0])
	for ch in CHOICES:
		var d := float(agg[ch]["rung"]) - float(agg[best]["rung"])
		if d < -0.1 or (absf(d) <= 0.1 and float(agg[ch]["win"]) > float(agg[best]["win"])):
			best = ch
	return best

## Ladder place of a against b, seed by seed (the same seeds fought the same nights): [mean difference, its standard error].
static func _diff(a: Array, b: Array) -> Array:
	var n := float(mini(a.size(), b.size()))
	var s := 0.0; var s2 := 0.0
	for i in int(n):
		var d := float(a[i]["rung"]) - float(b[i]["rung"])
		s += d; s2 += d * d
	var mean := s / n
	return [mean, sqrt(maxf(0.0, s2 / n - mean * mean) * n / maxf(1.0, n - 1.0)) / sqrt(n)]

## The choices inside the noise of the best: a mean difference to the best under two standard errors of it is a tie.
static func _ties(by_choice: Dictionary, best: String) -> Array:
	var out: Array = []
	for ch in CHOICES:
		var d: Array = _diff(by_choice[ch], by_choice[best])
		if ch != best and float(d[0]) <= 2.0 * float(d[1]):
			out.append(ch)
	return out

func _secs() -> float: return float(Time.get_ticks_msec() - t0) / 1000.0

func _say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s); L.append(s)
