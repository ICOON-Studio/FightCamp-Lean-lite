extends SceneTree
## S533 STEPPAY2 phase 3: in WHICH situation does each swept step fire in TREEVALUE's plan? For each step x style: the
## planned fires (and rides) of the step by the fight's own grading of it that exchange (PlanFight.fit vs psit), over n
## bouts of the treevalue with-arm (same fighters, plan surgery and opponents; ratings = TREEVALUE3's).
## S537 STEPPAY3: the grading read is the record's own (arrow_fit: the moment's row when StepMoment dealt one), and each line
## adds how often the step's moment was dealt a bout. `moments=off` = the control arm (the game before STEPPAY3);
## `rate=short:0.2,drift:0.3` = another rate for a moment (measurement only).
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/step_fire_fit_probe.gd -- [n=200] [only=cut_off] [when=best]
const TV := preload("res://tools/treevalue_probe.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StepValue := preload("res://scripts/rules/StepValue.gd")
const StepMoment := preload("res://scripts/rules/StepMoment.gd")
const RATING := {"Maria Ortega": 52.89, "Jade Cooper": 55.95, "Holly Price": 54.24, "Priya Nair": 53.29,
	"Erin Doyle": 53.02, "Dana Whitfield": 52.64}


func _initialize() -> void:
	var n := 200
	var only: Array = StepValue.STEPS
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("n="):
			n = int(str(a).substr(2))
		if str(a).begins_with("only="):
			only = Array(str(a).substr(5).split(","))
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("legs="):   # no bout is played: reads a gate run and a fit run
			_legs(str(a).substr(5))
			print("STEP_FIRE_FIT done")
			quit(0)
			return
	var tv: Object = TV.new()
	tv.set("when_best", OS.get_cmdline_user_args().has("when=best"))
	if OS.get_cmdline_user_args().has("ride=off"):
		TV.StepWire.ride_on = false
	if OS.get_cmdline_user_args().has("moments=off"):
		StepMoment.on = false
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("rate="):
			for kv in str(a).substr(5).split(","):
				StepMoment.probe_rate[str(kv).get_slice(":", 0)] = float(str(kv).get_slice(":", 1))
	print("StepMoment: on=%s rates=%s" % [str(StepMoment.on), str(StepMoment.STEP.keys().map(func(k): return "%s %.2f" % [str(k), StepMoment.rate(str(k))]))])
	var base: Dictionary = tv.call("_base_dict")
	if OS.get_cmdline_user_args().has("delta"):
		_delta(tv, base, only)
		tv.free()
		print("STEP_FIRE_FIT done")
		quit(0)
		return
	print("STEP_FIRE_FIT: %d bouts a cell, the treevalue with-arm plan; fires by the fight's grading of the step that exchange" % n)
	for step in only:
		var sid := str(step)
		var plan: Array = tv.call("_plan_for", sid)
		for style in StepValue.STYLES:
			var opp: Dictionary = tv.call("_find_opp", str(TV.STYLE_OPP[str(style)]))
			opp["rating"] = float(RATING[str(opp["name"])])
			var t := {"best": 0, "ok": 0, "none": 0, "wrong": 0}
			var rides := 0
			var fires := 0
			var lost_best := 0   # exchanges on the step's card, in a best situation, where another line was the plan's pick
			var dealt := 0       # exchanges where this step's moment was dealt (StepMoment)
			var wins := 0
			for k in n:
				var c := Career.quick_start()
				c.fighters.append(tv.call("_make_fighter", int(TV.SEED_START) + (k % int(TV.N_FIGHTERS))))
				c.day = 40 + k
				var f: Dictionary = c.fighter()
				f["camp"] = {}
				f["morale"] = 60.0
				f["moves"] = (base["moves"] as Dictionary).duplicate()
				var steps: Dictionary = (base["steps"] as Dictionary).duplicate()
				steps[sid] = float(TV.SHARP)
				f["steps"] = steps
				f["combos"] = (base["combos"] as Dictionary).duplicate()
				f["arrows"] = plan.duplicate(true)
				c.coach = {}
				f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
				var m := {"fid": f["id"], "step": "tape", "total": 3}
				Bouts.fight_step(c, f, m, "sim")
				wins += 1 if str(m.get("outcome", "")) == "win" else 0
				for r in m["rounds"]:
					for x in (r as Dictionary)["exchanges"]:
						var xd: Dictionary = x
						var psit := str(xd.get("moment", ""))
						if psit == "":
							psit = str(xd.get("psit", ""))
						if str(StepMoment.STEP.get(str(xd.get("moment", "")), "")) == sid:
							dealt += 1
						if PlanFight.base_id(str(xd.get("rode", ""))) == sid:
							rides += 1
						if PlanFight.base_id(str(xd.get("arrow", ""))) == sid and bool(xd.get("planned", false)):
							fires += 1
							var k2 := PlanFight.fit(sid, psit)
							t[k2] = int(t[k2]) + 1
						elif PlanFight.fit(sid, psit) == "best" and PlanFight.base_id(str(xd.get("want", ""))) != sid \
								and str(xd.get("at", "")) == str(PlanFight.StrikeMap.move(sid).get("from", "")):
							lost_best += 1
			var ft := float(maxi(1, fires))
			print("FIT step=%s style=%s fires/bout=%.2f best=%.0f%% ok=%.0f%% none=%.0f%% wrong=%.0f%% rides=%.0f%% best_taken_by_another_line/bout=%.2f moment/bout=%.2f best_fires/bout=%.2f wins=%.0f%%" % [
				sid, str(style), float(fires) / float(n), 100.0 * float(t["best"]) / ft, 100.0 * float(t["ok"]) / ft,
				100.0 * float(t["none"]) / ft, 100.0 * float(t["wrong"]) / ft, 100.0 * float(rides) / ft, float(lost_best) / float(n), float(dealt) / float(n), float(t["best"]) / float(n), 100.0 * float(wins) / float(n)])
	tv.free()
	print("STEP_FIRE_FIT done")
	quit(0)


## S537 STEPPAY3 THE GATE'S LEGS, the third BY SITUATION (docs/STEPPAY2_PHASE4.md "what is left" 3: "others 0..+1" cannot pass
## for a step whose moment several styles share - the fight grades by the situation, not the style).
## `legs=<gate output>,<fit output>`: the gate's CELL lines (tools/treevalue_probe.gd when=best) and this probe's FIT lines
## for all ten steps (best fires a bout by style). Per step:
##   best leg   - the style it is FOR reads 1.5..5 (unchanged)
##   wrong leg  - the style that punishes it reads below 0 (unchanged; no such style = passes)
##   others BY SITUATION - worth = the FOR cell / the FOR style's best fires a bout (what one fire in its moment is worth).
##     Every other style must read within SIT_TOL of worth x ITS best fires a bout, and never above the band's top (5):
##     the step pays against a style as often as that style plays its situation - no more, no less.
## SIT_TOL = 2.0: a cell is 1,200 paired bouts, about +-1.1 in 100.
const SIT_TOL := 2.0
const BAND := [1.5, 5.0]
func _legs(paths: String) -> void:
	var cell := {}
	var best := {}
	var re_cell := RegEx.create_from_string("^CELL step=(\\S+) style=(.+?) with=\\d+ without=\\d+ delta=([+-][0-9.]+) fires/bout=([0-9.]+)")
	var re_fit := RegEx.create_from_string("^FIT step=(\\S+) style=(.+?) fires/bout=([0-9.]+) .*best_fires/bout=([0-9.]+)")
	for path in paths.split(","):
		var fa := FileAccess.open(str(path), FileAccess.READ)
		if fa == null:
			print("LEGS: cannot read %s" % str(path))
			continue
		while not fa.eof_reached():
			var line := fa.get_line().strip_edges()
			var mc := re_cell.search(line)
			if mc != null:
				cell["%s|%s" % [mc.get_string(1), mc.get_string(2)]] = float(mc.get_string(3))
			var mf := re_fit.search(line)
			if mf != null:
				best["%s|%s" % [mf.get_string(1), mf.get_string(2)]] = float(mf.get_string(4))
	print("LEGS: best 1.5..5 | wrong < 0 | others by situation (within %.1f of worth x best fires a bout, never above %.1f)" % [SIT_TOL, float(BAND[1])])
	var passed := 0
	var in_band := 0
	for step in StepValue.STEPS:
		var sid := str(step)
		var bs := StepValue.best_style(sid)
		var ws := StepValue.wrong_style(sid)
		if not cell.has("%s|%s" % [sid, bs]) or not best.has("%s|%s" % [sid, bs]):
			print("LEG step=%s: no cell or no fit line" % sid)
			continue
		var bv := float(cell["%s|%s" % [sid, bs]])
		var bf := float(best["%s|%s" % [sid, bs]])
		var worth := bv / bf if bf > 0.0 else 0.0
		var best_ok := bv >= float(BAND[0]) and bv <= float(BAND[1])
		var wrong_ok := ws == "" or float(cell.get("%s|%s" % [sid, ws], 0.0)) < 0.0
		var others_ok := bf > 0.0
		var parts: Array = []
		for style in StepValue.STYLES:
			var s := str(style)
			var v := float(cell.get("%s|%s" % [sid, s], 0.0))
			var f := float(best.get("%s|%s" % [sid, s], 0.0))
			var mark := "FOR" if s == bs else ("WRONG" if s == ws else "")
			if mark == "":
				var ok := v <= float(BAND[1]) and absf(v - worth * f) <= SIT_TOL
				others_ok = others_ok and ok
				mark = "ok" if ok else "OUT"
			parts.append("%s %+.2f (%.2f best fires, by situation %+.2f) %s" % [s, v, f, worth * f, mark])
		passed += int(best_ok and wrong_ok and others_ok)
		in_band += int(best_ok)
		print("LEG step=%s best=%s wrong=%s others=%s -> %s | worth of one best fire a bout %+.2f | %s" % [sid, "yes" if best_ok else "NO",
			("yes" if wrong_ok else "NO") if ws != "" else "none", "yes" if others_ok else "NO", "PASS" if best_ok and wrong_ok and others_ok else "FAIL", worth, " | ".join(parts)])
	print("LEGS: FOR leg in the band %d of 10; all three legs %d of 10" % [in_band, passed])


## S537 `delta`: the gate's cell for a step against the style it is FOR (or `styles=all`): wins in 100 with the step's
## lines minus the same plan without them, 400 bouts x 3 seed sets, same seeds in both arms (treevalue_probe's own cell).
## Ratings are TREEVALUE3's (RATING), not re-calibrated: a quick read while sizing; the gate itself is treevalue_probe.
func _delta(tv: Object, base: Dictionary, only: Array) -> void:
	var all_styles := OS.get_cmdline_user_args().has("styles=all")
	for step in only:
		var sid := str(step)
		var with_plan: Array = tv.call("_plan_for", sid)
		var without_plan: Array = with_plan.filter(func(a): return str(a["move"]) != sid)
		for style in (StepValue.STYLES if all_styles else [StepValue.best_style(sid)]):
			var opp: Dictionary = tv.call("_find_opp", str(TV.STYLE_OPP[str(style)]))
			opp["rating"] = float(RATING[str(opp["name"])])
			var w := 0
			var wo := 0
			var fires := 0
			var rides := 0
			for sb in TV.SEED_SETS:
				var cw: Dictionary = tv.call("_cell", with_plan, opp, base, sid, int(sb), int(TV.N_BOUTS))
				var co: Dictionary = tv.call("_cell", without_plan, opp, base, sid, int(sb), int(TV.N_BOUTS))
				w += int(cw["wins"])
				wo += int(co["wins"])
				fires += int(cw["fires"])
				rides += int(cw["rides"])
			var nt := float(int(TV.N_BOUTS) * TV.SEED_SETS.size())
			print("DELTA step=%s style=%s delta=%+.2f with=%.1f%% without=%.1f%% fires/bout=%.2f rides/bout=%.2f" % [
				sid, str(style), 100.0 * float(w - wo) / nt, 100.0 * float(w) / nt, 100.0 * float(wo) / nt, float(fires) / nt, float(rides) / nt])
