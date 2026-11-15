extends SceneTree
## S481 FIGHTWEEK2 golden path (his S473 "Yes, build it", Q-238, C402): the quick-start career books its first even club-show
## bout and walks the FIGHT WEEK end to end through the real actions and screens:
##   1. The booking makes it a fight week (no camp): bout.fight_week, a host club, Home asks FIGHT WEEK, not SET CAMP.
##   2. A line written after the booking is UNSPARRED (the v9 rule); the screen opens (Frame A drawn).
##   3. A sparring night placed with no partner opens the partner screen (Frame B drawn); the week will not lock until
##      every night has a partner.
##   4. The best-match partner picked, Tick over chosen, the week locks: bout.load, spar_days, r1_edge = the partner's edge,
##      the readied line is sparred and off bout.unsparred, the tank's choice layer is Tick over 6 + the night 3.
##   5. The week runs to the weigh-in and fight night; the bout is fought and recorded.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const PartnerMatch := preload("res://scripts/rules/PartnerMatch.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var f := _book()
	_check(not f.is_empty(), "an even club-show bout is booked")
	if f.is_empty():
		_done()
		return
	var c: Career = main.career
	var b: Dictionary = f["bout"]
	var fid := str(f["id"])
	# 1. no camp, a fight week
	_check(bool(b.get("fight_week", false)) and str(b.get("host", "")) != "", "the bout is a fight week at %s" % str(b.get("host", "")))
	_check(not Bouts.camp_due(c, f), "no camp is asked for")
	var acts: Array = _need_acts(c)
	_check(acts.has("fightweek") and not acts.has("camp"), "the to-do asks FIGHT WEEK, not SET CAMP (%s)" % str(acts))
	# 2. a line written after the booking is unsparred
	var arrows: Array = f["arrows"]
	_check(not arrows.is_empty(), "the plan has lines")
	var fresh: Dictionary = (arrows[0] as Dictionary).duplicate()
	fresh["when"] = "press" if str(fresh.get("when", "")) != "press" else "tiring"
	arrows.append(fresh)
	var unsp: Array = FightWeekPlan.lines(f).filter(func(x): return bool(x["unsparred"]))
	_check(unsp.size() == 1, "exactly the new line is unsparred (%d)" % unsp.size())
	main.act("fightweek", fid)
	_check(str(main.modal.get("type", "")) == "fightweek", "the fight week screen opens")
	_check(_drawn(), "Frame A is drawn")
	# 3. a night with no partner
	main.modal["plan"]["nights"] = {}
	main.act("fwnight", "6")
	_check(str(main.modal.get("view", "")) == "partner" and int(main.modal.get("night", 0)) == 6, "placing a night opens the partner screen")
	_check(_drawn(), "Frame B is drawn")
	main.act("fwback")
	main.act("fwlock")
	_check(FightWeekPlan.is_open(f), "the week does not lock with a night that has no partner")
	# 4. pick the best match, Tick over, lock
	var best: Dictionary = FightWeekPlan.partners(c, f)[0]
	var m := PartnerMatch.night(best, FightWeekPlan.opp_known(f), int(Champs.rating_of(f)), 3)
	main.act("fwpartnerof", "6")
	main.act("fwpartner", str(best["id"]))
	_check(str(main.modal.get("view", "")) == "week", "picking a partner returns to the week")
	main.act("fwstop", "tick_over")
	main.modal["plan"]["eat_less"] = false
	main.modal["plan"]["film"] = false
	var cash_before := c.cash
	var fav_before := FightWeekPlan.favours(c, str(best["club"]))
	main.act("fwlock")
	_check(not FightWeekPlan.is_open(f) and main.modal.is_empty(), "the week locks and the screen closes")
	_check(str(b.get("load", "")) == "tick_over" and (b.get("spar_days", []) as Array) == [6], "bout: Tick over, one night 6 days out")
	_check(absf(float(b.get("r1_edge", -9.0)) - float(m["edge"])) < 0.001,
		"round-1 edge = the partner's %s edge %.1f (got %.1f)" % [str(m["word"]), float(m["edge"]), float(b.get("r1_edge", -9.0))])
	var readied := int(m["lines"]) > 0
	_check((b.get("unsparred", []) as Array).is_empty() == readied, "the night readied the new line: unsparred %s" % str(b.get("unsparred", [])))
	_check((f["sparred"] as Array).has(FightWeekPlan.key_of(fresh)) == readied, "the readied line is filed as sparred")
	var paid := cash_before - c.cash
	var fav_now := FightWeekPlan.favours(c, str(best["club"]))
	_check((paid == 0) if bool(best["ours"]) else (paid == PartnerMatch.OUTSIDE_FEE or fav_now == fav_before - 1),
		"the partner's cost: %s, cash %d -> %d, favours %d -> %d" % ["our club, free" if bool(best["ours"]) else "outside",
		cash_before, c.cash, fav_before, fav_now])
	var tp := BoutRules.tank_parts_for(c.results, f, float(f.get("week_fatigue", 20.0)), c.day)
	_check(int(tp.get("week", -1)) == 9, "the tank's week layer is Tick over 6 + a 6-day night 3 (got %s)" % str(tp.get("week")))
	acts = _need_acts(c)
	_check(not acts.has("fightweek"), "the to-do no longer asks for the fight week")
	# 5. run to fight night and box it
	var fought := false
	for i in 30:
		TestJump._tidy(main, c)
		if Bouts.weigh_in_today(c, f):
			main.act("weighin", fid)
			main.act("doWeigh")
			_check(bool(f["bout"].get("made", false)) or (f["bout"] as Dictionary).is_empty(), "weigh-in done")
		if Bouts.fight_day(c, f):
			main.act("fightnight")
			main.act("fightstep", "sim")
			main.act("afterfight")
			fought = true
			break
		if not main.modal.is_empty():
			main.act("close")
		main.run_to_stop()
	_check(fought, "fight night came and the bout was boxed")
	_check(not c.results.is_empty(), "the bout is in the results")
	_done()


func _need_acts(c: Career) -> Array:
	var out: Array = []
	for n in Needs.needs(c) + Needs.flags(c):
		out.append(str(n["act"]))
	return out


func _drawn() -> bool:
	var n: Node = main._modal_layer
	return n.get_child_count() >= 2


func _book() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			# the coach writes her plan before the booking, as a player with a plan has one: the booking files it as sparred
			f["arrows"] = PlanTemplates.load(PlanTemplates.BOXING[0], 6)
			main.act("accept", str(o["id"]))
			return f
	return {}


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", label)
	else:
		print("ok   ", label)


func _done() -> void:
	print("FIGHT_WEEK_SCREEN checks failures=%d" % failures)
	quit(1 if failures > 0 else 0)
