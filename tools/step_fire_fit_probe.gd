extends SceneTree
## S533 STEPPAY2 phase 3: in WHICH situation does each swept step fire in TREEVALUE's plan? For each step x style: the
## planned fires (and rides) of the step by the fight's own grading of it that exchange (PlanFight.fit vs psit), over n
## bouts of the treevalue with-arm (same fighters, plan surgery and opponents; ratings = TREEVALUE3's).
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/step_fire_fit_probe.gd -- [n=200] [only=cut_off] [when=best]
const TV := preload("res://tools/treevalue_probe.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StepValue := preload("res://scripts/rules/StepValue.gd")
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
	var tv: Object = TV.new()
	tv.set("when_best", OS.get_cmdline_user_args().has("when=best"))
	if OS.get_cmdline_user_args().has("ride=off"):
		TV.StepWire.ride_on = false
	var base: Dictionary = tv.call("_base_dict")
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
				for r in m["rounds"]:
					for x in (r as Dictionary)["exchanges"]:
						var xd: Dictionary = x
						var psit := str(xd.get("psit", ""))
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
			print("FIT step=%s style=%s fires/bout=%.2f best=%.0f%% ok=%.0f%% none=%.0f%% wrong=%.0f%% rides=%.0f%% best_taken_by_another_line/bout=%.2f" % [
				sid, str(style), float(fires) / float(n), 100.0 * float(t["best"]) / ft, 100.0 * float(t["ok"]) / ft,
				100.0 * float(t["none"]) / ft, 100.0 * float(t["wrong"]) / ft, 100.0 * float(rides) / ft, float(lost_best) / float(n)])
	tv.free()
	print("STEP_FIRE_FIT done")
	quit(0)
