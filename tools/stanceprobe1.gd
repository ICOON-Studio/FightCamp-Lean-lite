extends SceneTree
## S536 STANCEPROBE1 - the stance pad on a greybox (ops/research/TASK_STANCEPROBE1.md, DESIGN_STANCE1.md). Nothing here is in scripts/.
## (tools/stance_probe.gd is an older 3D ruler, S399: this probe takes the next free name.)
## 3 x 3 pad: width Narrow / Shoulder / Wide x angle Squared / Half / Bladed, as scratch changes on a local copy of the boxer's own
## attributes (f["attrs"], the dict RingDuel / Duels / Knockdowns / Combos read), re-set at every bell; each bout is the game's fight
## night (BoutNight: fight_step "start", then _open / _shout_out round by round = _box_out's own loop, so the probe can act at the bell).
## Real Data people, never two the same; 5 opponent styles x amateur / pro = 10 cells; 40 seeds a cell, the same dice for every stance.
## PASS (all): every effect moves the result; no stance best in more than 6 of 10 cells; 4 or more cells clear of the noise; the
## natural stance is not always best; the corner's lean moves a round's result.
##   python ops/Tools/godot_slot.py run --who stanceprobe1 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/stanceprobe1.gd [-- seeds=40 abl=20 own=20 cal=5 model=1|2 out=<file>]

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const PunchStart := preload("res://scripts/rules/PunchStart.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")

const BOXERS := ["kira", "samira", "tess", "danny", "josh"]
const STYLES := ["Out-boxer", "Pressure fighter", "Counter-puncher", "Volume puncher", "Slugger"]
const SCALES := [
	{"id": "am", "name": "amateur, 3 rounds", "pro": false, "rounds": 3},
	{"id": "pro", "name": "pro, 6 rounds", "pro": true, "rounds": 6},
]
const WIDTHS := ["Narrow", "Shoulder", "Wide"]      # w = -1, 0, +1
const ANGLES := ["Squared", "Half", "Bladed"]       # g = -1, 0, +1
## The scratch models, both set BEFORE their run (never fitted on the test's seeds). Tags: DESIGN_STANCE1.md section 3.
## M1 (round 1): one step on the pad = three attribute points on each tool (three focused camp weeks at the game's pace).
## M2 (round 2, the ONE resize): each side of a trade is sized to about one exchange point in the place it acts, summed from
## Duels.TOOLS' own weights for an average boxer (round 1 measured one such point as about 3 bouts in 100); chips that could not
## reach that alone are folded into the chip they act with (stays up -> base; body hidden + jab level -> long; rear power -> hooks).
const M1 := {"power_w": 3.0, "slip_w": 2.0, "chin_w": 3.0, "feet_w": 3.0, "drain_w": 1.5, "drift_at": 65.0, "drift_span": 30.0, "drift_body": 0.05, "drift_body_max": 0.5,
	"hook_g": 3.0, "inside_g": 3.0, "body_g": 4.0, "reach_g": 5.0, "jab_g": 0.0, "power_g": 2.0, "power_g_sym": false,
	"unowned_feet": 2.0, "unowned_energy": 2.0, "lean": 3.0, "lean_fwd": 10.0, "lean_back_slip": 2.0, "read_rating": 1.5}
const M2 := {"power_w": 5.0, "slip_w": 5.0, "chin_w": 5.0, "feet_w": 3.0, "drain_w": 1.5, "drift_at": 65.0, "drift_span": 30.0, "drift_body": 0.05, "drift_body_max": 0.5,
	"hook_g": 2.0, "inside_g": 1.0, "body_g": 8.0, "reach_g": 5.0, "jab_g": 4.0, "power_g": 2.0, "power_g_sym": true,
	"unowned_feet": 2.0, "unowned_energy": 2.0, "lean": 3.0, "lean_fwd": 10.0, "lean_back_slip": 2.0, "read_rating": 1.5}
## effect -> the two test cells [w, g] it is switched off on
const EFFECTS1 := {"power": [[1, 0], [-1, 0]], "slips": [[1, 0], [-1, 0]], "chin": [[1, 0], [-1, 0]], "steps": [[1, 0], [-1, 0]], "drain": [[1, 0], [-1, 0]],
	"drift": [[1, 0], [0, 0]], "hooks": [[0, -1], [0, 1]], "body": [[0, -1], [0, 1]], "reach": [[0, -1], [0, 1]], "rearpower": [[0, 1], [1, 1]]}
const EFFECTS2 := {"base": [[1, 0], [-1, 0]], "slips": [[1, 0], [-1, 0]], "steps": [[1, 0], [-1, 0]], "drain": [[1, 0], [-1, 0]],
	"drift": [[1, 0], [0, 0]], "hooks": [[0, -1], [0, 1]], "long": [[0, -1], [0, 1]]}
const PLANS := [
	{"arrows": [{"move": "1-2"}, {"move": "step_in"}, {"move": "cut_off"}, {"move": "tie_up"}], "combos": {"1-2": 60.0, "1-1": 45.0}},
	{"arrows": [{"move": "2-3"}, {"move": "feint"}, {"move": "pivot_out"}, {"move": "1-2"}], "combos": {"2-3": 60.0, "1-2": 50.0}},
]
const DAY0 := 60000

var L: Array = []
var t0 := 0
var n_bouts := 0
var n_dirty := 0
var opp_off := {"am": -5.0, "pro": -8.0}
var M: Dictionary = M1
var EFFECTS: Dictionary = EFFECTS1
var out_path := "res://docs/STANCEPROBE1_RAW.md"
var people := {}     # id -> {t, nat: [w, g]}

func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	var opt := {"seeds": 40, "abl": 8, "own": 10, "cal": 5, "model": 1}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2 and opt.has(kv[0]): opt[kv[0]] = int(kv[1])
		if kv.size() == 2 and kv[0] == "out": out_path = kv[1]
	if int(opt["model"]) == 2:
		M = M2; EFFECTS = EFFECTS2
	var seeds := int(opt["seeds"]); var abl := mini(int(opt["abl"]), seeds); var own := mini(int(opt["own"]), seeds)
	for id in BOXERS:
		var t := _person(str(id))
		var st := Data.fighter_state(t.duplicate(true), DAY0)
		people[id] = {"t": t, "nat": _natural(st), "height": float(st["height"]), "reach": float(st["reach"])}
	_say(["# STANCEPROBE1 - the stance pad on a greybox (S536)", "",
		"Run: python ops/Tools/godot_slot.py run --who stanceprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/stanceprobe1.gd -- seeds=%d abl=%d own=%d cal=%d model=%d" % [seeds, abl, own, int(opt["cal"]), int(opt["model"])], "",
		"What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex) and every bout (the game's fight night, BoutNight).",
		"What is scratch: the stance model below, written onto a local copy of the boxer's attributes at every bell. Every stance of a seed fights the same night (same dice).",
		"A stance is measured against the boxer's NATURAL cell: in his natural cell nothing changes; a step away adds the model's difference.", "",
		"Model %d (set before the run, not fitted): " % int(opt["model"]) + str(M), ""])
	_selfcheck()
	_fit(int(opt["cal"]))
	# ---- main: 9 owned stances x 5 boxers x 10 cells x seeds
	var main := {}    # cell id -> stance index (0..8) -> Array of unit results (boxer-major, seed-minor)
	var ctrl := {}    # cell id -> Array (today's game, no stance model at all), first 'abl' seeds
	var cells: Array = []
	for si in STYLES.size():
		for ci in SCALES.size():
			cells.append({"si": si, "ci": ci, "id": "%s / %s" % [STYLES[si], SCALES[ci]["id"]]})
	for cell in cells:
		var id := str(cell["id"])
		main[id] = {}
		for k in 9:
			var arr: Array = []
			for bi in BOXERS.size():
				for s in seeds:
					arr.append(_bout(bi, cell, s, {"w": k / 3 - 1, "g": k % 3 - 1, "owned": true}))
			main[id][k] = arr
		var ca: Array = []
		for bi in BOXERS.size():
			for s in abl:
				ca.append(_bout(bi, cell, s, {"none": true}))
		ctrl[id] = ca
		print("cell %s done, %d bouts, %.0f s" % [id, n_bouts, _secs()])
	_say(["## 1. Who they are", "", "| Boxer | Style | Height | Reach | Power | Speed | Natural stance | Why |", "| :--- | :--- | ---: | ---: | ---: | ---: | :--- | :--- |"])
	for id in BOXERS:
		var p: Dictionary = people[id]
		var t: Dictionary = p["t"]
		_say("| %s | %s | %.0f cm | %.0f cm | %.0f | %.0f | %s | %s |" % [t["name"], t["style"], p["height"], p["reach"], t["stats"]["power"], t["stats"]["speed"], _cname(p["nat"]), p["nat"][2]])
	_say(["", "Natural width: (Power - Speed) / 4 at +2 or more = Wide, -2 or less = Narrow. Natural angle: the style (Out-boxer bladed; Pressure fighter, Slugger, Volume puncher squared) plus one step bladed for a reach 3 cm over the height, one squared for 3 cm under. (ESTIMATE rule: the game has no stance width today.)", "",
		"Opponents by style and sex (rating under 68, re-rated to the boxer's own strength %+.1f amateur / %+.1f pro so today's game wins about half): %s" % [float(opp_off["am"]), float(opp_off["pro"]), _pool_words()], "",
		"## 2. Every cell: wins in 100 bouts by stance (a draw is half; +- one standard error; %d bouts a stance = 5 boxers x %d seeds)" % [BOXERS.size() * seeds, seeds], ""])
	var best_count := {}; var clear_count := {}; var n_clear := 0
	var sum_rows: Array = ["| Cell | Best | Wins | Inside the noise of it | Each boxer's natural | Today's game (%d seeds) |" % abl, "| :--- | :--- | ---: | :--- | ---: | ---: |"]
	for cell in cells:
		var id := str(cell["id"])
		_say(["### %s" % id, "", "| | Squared | Half | Bladed |", "| :--- | ---: | ---: | ---: |"])
		for wi in 3:
			var row := "| %s |" % WIDTHS[wi]
			for gi in 3:
				var ag := _agg(main[id][wi * 3 + gi])
				row += " %.1f +- %.1f |" % [ag["win"] * 100.0, ag["se"] * 100.0]
			_say(row)
		var best := _best(main[id])
		var ties: Array = _ties(main[id], best)
		best_count[best] = int(best_count.get(best, 0)) + 1
		if ties.is_empty():
			clear_count[best] = int(clear_count.get(best, 0)) + 1
			n_clear += 1
		var nat := _agg(_natural_arm(main[id], seeds))
		var stop := _agg(main[id][best])
		_say(["", "Best: **%s** (%.1f)%s. Stopped inside: won %.0f, lost %.0f in 100." % [_kname(best), _agg(main[id][best])["win"] * 100.0,
			"" if ties.is_empty() else "; inside two standard errors of it: " + ", ".join(ties.map(func(k): return _kname(k))), stop["stop_w"] * 100.0, stop["stop_l"] * 100.0], ""])
		sum_rows.append("| %s | %s | %.1f | %s | %.1f | %.1f |" % [id, _kname(best), _agg(main[id][best])["win"] * 100.0,
			"-" if ties.is_empty() else ", ".join(ties.map(func(k): return _kname(k))), nat["win"] * 100.0, _agg(ctrl[id])["win"] * 100.0])
	_say(["## 3. The summary", ""]); _say(sum_rows)
	var top := 0
	for k in best_count: top = maxi(top, int(best_count[k]))
	var bc: Array = []
	for k in best_count: bc.append("%s %d" % [_kname(k), int(best_count[k])])
	_say(["", "Best counts: %s. The most any one stance wins: %d of %d cells (bar: 6 or fewer)." % [", ".join(bc), top, cells.size()],
		"Cells with a clear best (no other stance inside two standard errors, seed by seed): %d of %d (bar: 4 or more)." % [n_clear, cells.size()], ""])
	# ---- the natural stance: by boxer (all ten cells pooled) and by boxer x cell
	_say(["### Is the natural stance always best?", "", "| Boxer | Natural | Wins | Best owned stance (10 cells pooled, %d bouts) | Wins | Best against natural | Clear |" % (cells.size() * seeds), "| :--- | :--- | ---: | :--- | ---: | ---: | :--- |"])
	var beaten := 0; var nat_best := 0; var units := 0
	for bi in BOXERS.size():
		var pooled := {}
		for k in 9:
			pooled[k] = []
			for cell in cells:
				(pooled[k] as Array).append_array((main[str(cell["id"])][k] as Array).slice(bi * seeds, (bi + 1) * seeds))
		var nk := _kof(people[BOXERS[bi]]["nat"])
		var bk := _best(pooled)
		var d: Array = _diff(pooled[bk], pooled[nk])
		var clear := bk != nk and float(d[0]) > 2.0 * float(d[1])
		beaten += int(clear)
		_say("| %s | %s | %.1f | %s | %.1f | %+.1f +- %.1f | %s |" % [people[BOXERS[bi]]["t"]["first"], _kname(nk), _agg(pooled[nk])["win"] * 100.0, _kname(bk), _agg(pooled[bk])["win"] * 100.0, float(d[0]) * 100.0, float(d[1]) * 100.0, "yes" if clear else "no"])
		for cell in cells:
			var one := {}
			for k in 9: one[k] = (main[str(cell["id"])][k] as Array).slice(bi * seeds, (bi + 1) * seeds)
			units += 1
			nat_best += int(_best(one) == nk)
	var bar_nat := beaten >= 2 and nat_best * 10 < units * 6
	_say(["", "Boxers whose natural stance is clearly beaten by another owned stance: %d of %d (bar: 2 or more). Boxer x cell units (%d bouts each, a weak read) where the natural stance has the most wins: %d of %d (bar: under 6 in 10)." % [beaten, BOXERS.size(), seeds, nat_best, units], ""])
	# ---- each effect switched off
	_say(["## 4. Does each effect move the result? (effect off on its two test stances, %d seeds, the same dice as with it on)" % abl, "",
		"| Effect off | Test stances | Bouts whose result changed, in 100 | Mean change in wins in 100 (a cell) | Moves it (2 in 100 or more) |", "| :--- | :--- | ---: | ---: | :--- |"])
	var all_move := true
	for ef in EFFECTS:
		var changed := 0.0; var total := 0.0; var dwin := 0.0; var groups := 0.0
		for tc in EFFECTS[ef]:
			var k := (int(tc[0]) + 1) * 3 + int(tc[1]) + 1
			for cell in cells:
				var id := str(cell["id"])
				var won_on := 0.0; var won_off := 0.0
				for bi in BOXERS.size():
					for s in abl:
						var off := _bout(bi, cell, s, {"w": int(tc[0]), "g": int(tc[1]), "owned": true, "off": ef})
						var on: Dictionary = main[id][k][bi * seeds + s]
						total += 1.0
						changed += float(absf(float(off["win"]) - float(on["win"])) > 0.01)
						won_on += float(on["win"]); won_off += float(off["win"])
				dwin += absf(won_on - won_off) / float(BOXERS.size() * abl); groups += 1.0
		var share := changed / maxf(1.0, total) * 100.0
		var moves := share >= 2.0
		all_move = all_move and moves
		_say("| %s | %s | %.1f | %.1f | %s |" % [ef, ", ".join((EFFECTS[ef] as Array).map(func(c): return _cname(c))), share, dwin / maxf(1.0, groups) * 100.0, "yes" if moves else "NO"])
		print("effect %s done, %d bouts, %.0f s" % [ef, n_bouts, _secs()])
	# ---- a cell he does not own yet
	var un_on := 0.0; var un_off := 0.0; var un_n := 0.0; var un_changed := 0.0; var worth := 0; var worth_n := 0
	for bi in BOXERS.size():
		var nk := _kof(people[BOXERS[bi]]["nat"])
		for cell in cells:
			var id := str(cell["id"])
			var best_un := -1.0; var nat_w := 0.0
			for s in own: nat_w += float(main[id][nk][bi * seeds + s]["win"])
			for k in 9:
				if k == nk: continue
				var w_un := 0.0
				for s in own:
					var r := _bout(bi, cell, s, {"w": k / 3 - 1, "g": k % 3 - 1, "owned": false})
					var on: Dictionary = main[id][k][bi * seeds + s]
					un_n += 1.0; un_off += float(r["win"]); un_on += float(on["win"]); w_un += float(r["win"])
					un_changed += float(absf(float(r["win"]) - float(on["win"])) > 0.01)
				best_un = maxf(best_un, w_un)
			worth_n += 1; worth += int(best_un > nat_w)
	var un_moves := un_changed / maxf(1.0, un_n) * 100.0 >= 2.0
	all_move = all_move and un_moves
	_say("| not owned yet | the 8 cells that are not his natural | %.1f | %.1f | %s |" % [un_changed / maxf(1.0, un_n) * 100.0, absf(un_on - un_off) / maxf(1.0, un_n) * 100.0, "yes" if un_moves else "NO"])
	_say(["", "A stance he does not own yet wins %.1f in 100 against %.1f once owned (%d seeds). Boxer x cell units where some not-yet-owned stance still out-wins the natural one: %d of %d (a weak read, %d bouts each)." % [un_off / maxf(1.0, un_n) * 100.0, un_on / maxf(1.0, un_n) * 100.0, own, worth, worth_n, own], ""])
	print("unowned done, %d bouts, %.0f s" % [n_bouts, _secs()])
	# ---- the corner's lean, from round 2, on the natural stance
	_say(["## 5. The corner's lean (Front / Back from round 2 on, the natural stance, %d seeds; rounds 2 and later)" % seeds, "",
		"| Opponent | Centred: rounds won in 100 | Front | Back | Bout wins: Centred | Front | Back | Best lean |", "| :--- | ---: | ---: | ---: | ---: | ---: | ---: | :--- |"])
	var lean_all := {"centred": [], "front": [], "back": []}
	var lean_bests := {}
	for si in STYLES.size():
		var by := {"centred": [], "front": [], "back": []}
		for ci in SCALES.size():
			var cell: Dictionary = cells[si * SCALES.size() + ci]
			(by["centred"] as Array).append_array(_natural_arm(main[str(cell["id"])], seeds))
			for ln in ["front", "back"]:
				for bi in BOXERS.size():
					var nat: Array = people[BOXERS[bi]]["nat"]
					for s in seeds:
						(by[ln] as Array).append(_bout(bi, cell, s, {"w": int(nat[0]), "g": int(nat[1]), "owned": true, "lean": ln}))
		var bl := "centred"
		for ln in by:
			(lean_all[ln] as Array).append_array(by[ln])
			if _late(by[ln]) > _late(by[bl]): bl = ln
		lean_bests[bl] = int(lean_bests.get(bl, 0)) + 1
		_say("| %s | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %s |" % [STYLES[si], _late(by["centred"]) * 100.0, _late(by["front"]) * 100.0, _late(by["back"]) * 100.0,
			_agg(by["centred"])["win"] * 100.0, _agg(by["front"])["win"] * 100.0, _agg(by["back"])["win"] * 100.0, bl])
		print("lean %s done, %d bouts, %.0f s" % [STYLES[si], n_bouts, _secs()])
	var lf: Array = _diff_late(lean_all["front"], lean_all["centred"]); var lb: Array = _diff_late(lean_all["back"], lean_all["centred"])
	var lean_moves := absf(float(lf[0])) > 2.0 * float(lf[1]) or absf(float(lb[0])) > 2.0 * float(lb[1])
	_say(["", "All opponents pooled, rounds 2 and later won in 100, against Centred: Front %+.1f +- %.1f, Back %+.1f +- %.1f. Best lean by opponent: %s." % [float(lf[0]) * 100.0, float(lf[1]) * 100.0, float(lb[0]) * 100.0, float(lb[1]) * 100.0, str(lean_bests)],
		"The lean moves a round's result (one lean more than two standard errors from Centred): %s." % ("yes" if lean_moves else "NO"), ""])
	# ---- read on tape
	var rd_on: Array = []; var rd_off: Array = []; var second := 0; var second_n := 0
	for cell in cells:
		var id := str(cell["id"])
		for bi in BOXERS.size():
			var nat: Array = people[BOXERS[bi]]["nat"]
			var nk := _kof(nat)
			var read_w := 0.0
			for s in abl:
				var r := _bout(bi, cell, s, {"w": int(nat[0]), "g": int(nat[1]), "owned": true, "read": true})
				rd_on.append(r); rd_off.append(main[id][nk][bi * seeds + s]); read_w += float(r["win"])
			var other := -1.0
			for k in 9:
				if k == nk: continue
				var w2 := 0.0
				for s in abl: w2 += float(main[id][k][bi * seeds + s]["win"])
				other = maxf(other, w2)
			second_n += 1; second += int(other > read_w)
	var rdd: Array = _diff(rd_on, rd_off)
	var read_moves := absf(float(rdd[0])) > 2.0 * float(rdd[1])
	all_move = all_move and read_moves
	_say(["## 6. A stance the rival has read on tape (%d seeds)" % abl, "",
		"The natural stance against a rival who has read it: %+.1f +- %.1f wins in 100. Boxer x cell units where a second owned stance (not read) then out-wins the read natural one: %d of %d (a weak read, %d bouts each). Moves it: %s." % [float(rdd[0]) * 100.0, float(rdd[1]) * 100.0, second, second_n, abl, "yes" if read_moves else "NO"], ""])
	var bars := [all_move, top <= 6, n_clear >= 4, bar_nat, lean_moves]
	var ok := not bars.has(false)
	_say(["%d bouts played in %.0f s. Attribute copies the game would have rebuilt (must be 0): %d." % [n_bouts, _secs(), n_dirty], "",
		"RESULT: tools/stanceprobe1.gd -> %s (effects %s; top stance best in %d of %d cells; %d of %d cells clear; natural clearly beaten for %d of %d boxers and best in %d of %d units; lean %s)" % ["PASS" if ok and n_dirty == 0 else "FAIL",
			"all move" if all_move else "NOT all move", top, cells.size(), n_clear, cells.size(), beaten, BOXERS.size(), nat_best, units, "moves a round" if lean_moves else "does NOT move a round"]])
	var fa := FileAccess.open(out_path, FileAccess.WRITE)
	if fa != null:
		fa.store_string("\n".join(L) + "\n"); fa.close()
	print("STANCEPROBE1 done (%.0f s)" % _secs())
	quit(0)

## The probe's walk with no stance model = the game's own play_out (the instrument's control).
func _selfcheck() -> void:
	var same := 0; var n := 0
	for bi in BOXERS.size():
		for ci in SCALES.size():
			for s in 4:
				var cell := {"si": (bi + s) % STYLES.size(), "ci": ci, "id": "check"}
				var a := _bout(bi, cell, s, {"none": true})
				var b := _bout(bi, cell, s, {"none": true, "play_out": true})
				n += 1; same += int(str(a["sig"]) == str(b["sig"]))
	_say(["Self-check: the probe's round-by-round walk with the stance model off gives the same bout as BoutNight.play_out in %d of %d bouts (outcome, rounds, punches landed)." % [same, n], ""])

## The field: opponents re-rated so today's game wins about half (three offsets, a straight line through them).
func _fit(cal: int) -> void:
	if cal <= 0: return
	for ci in SCALES.size():
		var sid := str(SCALES[ci]["id"])
		var xs := [-3.0, -7.0, -11.0]; var ys: Array = []
		for x in xs:
			opp_off[sid] = x
			var w := 0.0; var n := 0.0
			for bi in BOXERS.size():
				for si in STYLES.size():
					for s in cal:
						w += float(_bout(bi, {"si": si, "ci": ci, "id": "fit"}, 900 + s, {"none": true})["win"]); n += 1.0
			ys.append(w / n)
		var slope := (float(ys[2]) - float(ys[0])) / (float(xs[2]) - float(xs[0]))
		opp_off[sid] = clampf(float(xs[1]) + (0.5 - float(ys[1])) / slope, -14.0, 0.0) if absf(slope) > 0.001 else float(xs[1])
		_say("Field, %s: today's game wins %.0f / %.0f / %.0f in 100 at opponent offsets -3 / -7 / -11 (seeds 900+, not the test's) -> offset %.1f." % [sid, float(ys[0]) * 100.0, float(ys[1]) * 100.0, float(ys[2]) * 100.0, float(opp_off[sid])])
	_say("")

static func _person(id: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			return (p as Dictionary).duplicate(true)
	return Data.lucy()

## [w, g, why] from the frame and the style (ESTIMATE rule).
static func _natural(st: Dictionary) -> Array:
	var lean := (float(st["stats"]["power"]) - float(st["stats"]["speed"])) / 4.0
	var w := 1 if lean >= 2.0 else (-1 if lean <= -2.0 else 0)
	var style := str(st.get("style", ""))
	var g := 1 if style == "Out-boxer" else (-1 if style in ["Pressure fighter", "Slugger", "Volume puncher", "Swarmer"] else 0)
	var ape := float(st["reach"]) - float(st["height"])
	g = clampi(g + (1 if ape >= 3.0 else (-1 if ape <= -3.0 else 0)), -1, 1)
	return [w, g, "power - speed %+.0f, %s, reach - height %+.0f cm" % [float(st["stats"]["power"]) - float(st["stats"]["speed"]), style, ape]]

static func _cname(c: Array) -> String: return "%s / %s" % [WIDTHS[int(c[0]) + 1], ANGLES[int(c[1]) + 1]]
static func _kname(k: int) -> String: return "%s / %s" % [WIDTHS[k / 3], ANGLES[k % 3]]
static func _kof(c: Array) -> int: return (int(c[0]) + 1) * 3 + int(c[1]) + 1

static func _pool(sex: String, style: String) -> Array:
	var out: Array = []
	var all: Array = Data.OPPONENTS + Data.RIVALS + Data.DIVISION_RIVALS
	for o in all:
		var d := str((o as Dictionary).get("div", "wlw"))
		if str(Data.DIVISIONS[d]["sex"]) == sex and float(o["rating"]) < 68.0 and str(o["style"]) == style:
			out.append(o)
	return out

static func _pool_words() -> String:
	var parts: Array = []
	for st in STYLES:
		parts.append("%s %d women, %d men" % [st, _pool("f", str(st)).size(), _pool("m", str(st)).size()])
	return "; ".join(parts) + "."

## Sets the boxer's attributes for round n from the stance (arm) on the base copy S. Called before every bell.
func _apply(f: Dictionary, S: Dictionary, arm: Dictionary, n: int) -> void:
	if arm.has("none"): return
	var fb: Dictionary = f["bout"]
	var off := str(arm.get("off", ""))
	var nat: Array = S["nat"]
	var drift := 0.0
	if n > 1 and off != "drift":
		var e := float((fb.get("energy", {}) as Dictionary).get("a", 100.0))
		drift = clampf((float(M["drift_at"]) - e) / float(M["drift_span"]), 0.0, 1.0) + minf(float(M["drift_body_max"]), float((fb.get("body", {}) as Dictionary).get("a", 0)) * float(M["drift_body"]))
	var dw := maxf(-1.0, float(arm["w"]) - drift) - float(nat[0])
	var dg := float(arm["g"]) - float(nat[1])
	var unowned := not bool(arm.get("owned", true)) and (int(arm["w"]) != int(nat[0]) or int(arm["g"]) != int(nat[1]))
	var lean := str(arm.get("lean", "")) if n >= 2 else ""
	var d := {"power": 0.0, "head_movement": 0.0, "chin": 0.0, "foot_speed": 0.0, "footwork": 0.0, "hooks": 0.0, "inside": 0.0, "body": 0.0, "timing": 0.0, "forward": 0.0, "jab": 0.0}
	var sym := bool(M["power_g_sym"])   # round 2: the rear hand goes with the hooks chip, both ways
	if off != "power" and off != "base": d["power"] += float(M["power_w"]) * dw
	if off != ("hooks" if sym else "rearpower"): d["power"] -= float(M["power_g"]) * (dg if sym else maxf(0.0, float(arm["g"])) - maxf(0.0, float(nat[1])))
	if off != "slips": d["head_movement"] += float(M["slip_w"]) * dw
	if off != "chin" and off != "base": d["chin"] += float(M["chin_w"]) * dw
	if off != "long": d["jab"] += float(M["jab_g"]) * dg
	if off != "steps":
		d["foot_speed"] -= float(M["feet_w"]) * dw; d["footwork"] -= float(M["feet_w"]) * dw
	if off != "hooks":
		d["hooks"] -= float(M["hook_g"]) * dg; d["inside"] -= float(M["inside_g"]) * dg
	if off != "body" and off != "long": d["body"] += float(M["body_g"]) * dg
	if unowned:
		d["foot_speed"] -= float(M["unowned_feet"]); d["footwork"] -= float(M["unowned_feet"])
	if lean == "front":
		d["power"] += float(M["lean"]); d["head_movement"] -= float(M["lean"]); d["forward"] += float(M["lean_fwd"])
	elif lean == "back":
		d["power"] -= float(M["lean"]); d["timing"] += float(M["lean"]); d["head_movement"] += float(M["lean_back_slip"]); d["forward"] -= float(M["lean_fwd"])
	var a: Dictionary = (S["a0"] as Dictionary).duplicate()
	for k in d:
		a[k] = clampf(float(a.get(k, 55.0)) + float(d[k]), Attrs.LO, Attrs.HI)
	# a punch under its move's mastery would be rebuilt by Attrs.of: the two hook moves come down with it, never under the raw floor
	var moves: Dictionary = (S["moves0"] as Dictionary).duplicate()
	for pm in [["hooks", ["Lead hook", "Body hook"]], ["jab", ["Jab"]]]:
		if float(d[pm[0]]) < 0.0:
			for mv in pm[1]:
				if moves.has(mv): moves[mv] = maxf(0.0, float(moves[mv]) + float(d[pm[0]]))
	var lv: Dictionary = PunchStart.from_moves(moves, float(f["stats"]["technique"]), PunchStart.raw_floor(a))   # the game's own floor of each punch (Timing moves it)
	for pk in Attrs.PUNCHES:
		a[pk] = maxf(float(a.get(pk, 0.0)), clampf(float(lv[pk]), Attrs.LO, Attrs.HI))
	f["moves"] = moves
	f["attrs"] = a
	var dials: Dictionary = f.get("style_dials", {})
	if dials.has("pressure"): dials["pressure"] = float(a["forward"])
	f["reach"] = float(S["reach0"]) + (float(M["reach_g"]) * dg if off != "reach" and off != "long" else 0.0)
	# the legs: the round just fought, paid at this bell
	if n >= 2 and fb.has("energy"):
		var cost := (float(M["drain_w"]) * dw if off != "drain" else 0.0) + (float(M["unowned_energy"]) if unowned else 0.0)
		fb["energy"]["a"] = clampf(float(fb["energy"]["a"]) - cost, 0.0, 100.0)
	if not Attrs._clean(f): n_dirty += 1

## One bout on fight night's own code. Returns {win (1 / 0.5 / 0), stop_w, stop_l, late_w, late_n (rounds 2 on), sig}.
func _bout(bi: int, cell: Dictionary, seed_i: int, arm: Dictionary) -> Dictionary:
	var p: Dictionary = people[BOXERS[bi]]
	var t: Dictionary = p["t"]
	var sc: Dictionary = SCALES[int(cell["ci"])]
	var day := DAY0 + seed_i * 211 + bi * 37 + int(cell["si"]) * 1009 + int(cell["ci"]) * 5003
	var f := Data.fighter_state(t.duplicate(true), day)
	var pl: Dictionary = PLANS[1 if bool(sc["pro"]) else 0]
	f = f.merged({"pro": bool(sc["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [],
		"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
	f.erase("last_bout_day")
	var pool := _pool(str(t["sex"]), str(STYLES[int(cell["si"])]))
	var opp: Dictionary = (pool[seed_i % pool.size()] as Dictionary).duplicate(true)
	opp["rating"] = BoutRules.fight_power(t["stats"], {}, 0, "", false) + float(opp_off[str(sc["id"])]) + (float(M["read_rating"]) if arm.has("read") else 0.0)
	opp["height"] = float(f["height"]); opp["reach"] = float(f["reach"])   # frames level: the stance's reach is the only reach gap
	f["bout"] = {"opp": opp, "day": day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": int(sc["rounds"]), "stale": 0.0}
	var c := Career.new()
	c.day = day; c.seed = seed_i + 1; c.coach = {"rating": 60.0}; c.fighters = [f]
	var m := {"type": "fight", "fid": f["id"], "step": "tape", "round": 0, "rounds": [], "total": int(sc["rounds"])}
	if arm.has("play_out"):
		BoutNight.play_out(c, f, m)
	else:
		var S := {"a0": Attrs.of(f).duplicate(), "moves0": (f["moves"] as Dictionary).duplicate(), "reach0": float(f["reach"]), "nat": p["nat"]}
		_apply(f, S, arm, 1)
		BoutNight.fight_step(c, f, m, "start")
		BoutNight._shout_out(c, f, m)
		while int(m["round"]) < BoutNight.rounds_of(f) and BoutNight.stopped(m) == "" and not TowelWire.coach_pull(c, f, m) and not CrackWire.bell(c, f, m, BoutNight.rounds_of(f)):
			_apply(f, S, arm, int(m["round"]) + 1)
			BoutNight._open(c, f, m, BoutRules.auto_corner(f["stats"]))
			BoutNight._shout_out(c, f, m)
	n_bouts += 1
	var out := str(BoutNight.outcome_of(f, m))
	var stop := BoutNight.stopped(m) != ""
	var res := {"win": 1.0 if out == "win" else (0.5 if out == "draw" else 0.0), "stop_w": int(stop and out == "win"), "stop_l": int(stop and out == "loss"), "late_w": 0, "late_n": 0, "sig": out}
	for r in m["rounds"]:
		res["sig"] = str(res["sig"]) + "|%d%s%d-%d" % [int(r["n"]), "W" if bool(r["won"]) else "L", int(r["landed"][0]), int(r["landed"][1])]
		if int(r["n"]) >= 2:
			res["late_n"] = int(res["late_n"]) + 1; res["late_w"] = int(res["late_w"]) + int(bool(r["won"]))
	return res

## Each unit's result in ITS boxer's natural cell (the arm a player who never touches the pad plays).
func _natural_arm(by_k: Dictionary, seeds: int) -> Array:
	var out: Array = []
	for bi in BOXERS.size():
		out.append_array((by_k[_kof(people[BOXERS[bi]]["nat"])] as Array).slice(bi * seeds, (bi + 1) * seeds))
	return out

static func _agg(runs: Array) -> Dictionary:
	var w := 0.0; var w2 := 0.0; var sw := 0.0; var sl := 0.0
	for r in runs:
		w += float(r["win"]); w2 += float(r["win"]) * float(r["win"]); sw += float(r["stop_w"]); sl += float(r["stop_l"])
	var n := maxf(1.0, float(runs.size()))
	var sd := sqrt(maxf(0.0, w2 / n - (w / n) * (w / n)) * n / maxf(1.0, n - 1.0))
	return {"win": w / n, "se": sd / sqrt(n), "stop_w": sw / n, "stop_l": sl / n}

static func _late(runs: Array) -> float:
	var w := 0.0; var n := 0.0
	for r in runs:
		w += float(r["late_w"]); n += float(r["late_n"])
	return w / maxf(1.0, n)

static func _best(by_k: Dictionary) -> int:
	var best := -1; var top := -1.0
	for k in by_k:
		var w := float(_agg(by_k[k])["win"])
		if w > top + 0.000001:
			top = w; best = int(k)
	return best

## Wins of a against b, bout by bout (the same bouts on the same dice): [mean difference, its standard error].
static func _diff(a: Array, b: Array) -> Array:
	var n := float(mini(a.size(), b.size()))
	var s := 0.0; var s2 := 0.0
	for i in int(n):
		var d := float(a[i]["win"]) - float(b[i]["win"])
		s += d; s2 += d * d
	var mean := s / n
	return [mean, sqrt(maxf(0.0, s2 / n - mean * mean) * n / maxf(1.0, n - 1.0)) / sqrt(n)]

## The same for the share of rounds 2 and later won.
static func _diff_late(a: Array, b: Array) -> Array:
	var n := 0.0; var s := 0.0; var s2 := 0.0
	for i in mini(a.size(), b.size()):
		if int(a[i]["late_n"]) == 0 or int(b[i]["late_n"]) == 0: continue
		var d := float(a[i]["late_w"]) / float(a[i]["late_n"]) - float(b[i]["late_w"]) / float(b[i]["late_n"])
		s += d; s2 += d * d; n += 1.0
	n = maxf(2.0, n)
	var mean := s / n
	return [mean, sqrt(maxf(0.0, s2 / n - mean * mean) * n / (n - 1.0)) / sqrt(n)]

static func _ties(by_k: Dictionary, best: int) -> Array:
	var out: Array = []
	for k in by_k:
		if int(k) == best: continue
		var d: Array = _diff(by_k[best], by_k[k])
		if float(d[0]) <= 2.0 * float(d[1]):
			out.append(int(k))
	return out

func _secs() -> float: return float(Time.get_ticks_msec() - t0) / 1000.0

func _say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s); L.append(s)
