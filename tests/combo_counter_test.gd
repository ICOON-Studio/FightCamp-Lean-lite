extends SceneTree
## S540 COMBOCOUNTER1: the combo counter (scripts/rules/ComboCounter.gd) - the rule's numbers as measured (REPEATBITE1 P2),
## then the wire: real bouts (a walk-down template that leans on its one jab, v the Counter-puncher of Data.RIVALS, 30 days)
## counter a repeated plan line, a countered exchange is lost by 10+, the feed says it, the result Plan tab shows it with
## the counter's tooltip, and the control arm (ComboCounter.on false) plays the game before (no counter recorded).

const ComboCounter := preload("res://scripts/rules/ComboCounter.gd")
const PlanReadShow := preload("res://scripts/rules/PlanReadShow.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")

var failures := 0


func _initialize() -> void:
	_rules()
	var cp: Dictionary = Data.RIVALS.filter(func(r): return str(r["style"]) == "Counter-puncher")[0]
	var plan := PlanTemplates.load(PlanTemplates.boxing("t_walk"), PlanBoard.TOP_COACH)
	var countered := 0
	var fired := 0
	var lost_ok := true
	var said_ok := true
	var unplanned_ok := true
	var first: Dictionary = {}
	for i in 30:
		var m := _bout(i, plan, cp)
		for r in m["rounds"]:
			for x in r["exchanges"]:
				var cc: Dictionary = x.get("cc", {})
				if cc.is_empty():
					continue
				fired += 1
				unplanned_ok = unplanned_ok and bool(x["planned"])
				if bool(cc["countered"]):
					countered += 1
					lost_ok = lost_ok and not bool(x["won"]) and float(x["margin"]) <= -ComboCounter.COUNTER_MARGIN
					said_ok = said_ok and str(x.get("read_line", "")).begins_with("They timed your")
					if first.is_empty():
						first = m
	_check(fired > 0 and countered > 0, "a leaning plan v a counter-puncher gets read and countered (%d throws into a read, %d countered, 30 bouts)" % [fired, countered])
	_check(unplanned_ok, "only the plan's own lines are counted")
	_check(lost_ok, "a countered exchange is lost by %d or more" % int(ComboCounter.COUNTER_MARGIN))
	_check(said_ok, "every counter is said in the feed")
	# The control arm: the game before.
	ComboCounter.on = false
	var none := true
	for i in 10:
		var m := _bout(i, plan, cp)
		for r in m["rounds"]:
			for x in r["exchanges"]:
				none = none and (x.get("cc", {}) as Dictionary).is_empty() and not str(x.get("read_line", "")).begins_with("They timed")
	_check(none, "ComboCounter.on false: no counter anywhere")
	ComboCounter.on = true
	if first.is_empty():
		print("COMBO_COUNTER failures=%d" % (failures + 1))
		quit(1)
		return
	# The result Plan tab: the countered line's row.
	var tab := ResultTabs.plan(first, ["Lucy", "Rival"])
	root.add_child(tab)
	await process_frame
	var lab: Label = tab.find_child("Countered", true, false)
	_check(lab != null and lab.text.contains("countered") and lab.tooltip_text == PlanReadShow.tip_counter(), "the Plan tab row says the counters, tooltip explains")
	print("COMBO_COUNTER failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _rules() -> void:
	_check(ComboCounter.READ_AT == 2 and is_equal_approx(ComboCounter.CHANCE, 0.35) and is_equal_approx(ComboCounter.COUNTER_STYLE, 1.75), "the numbers are REPEATBITE1 P2's")
	_check(ComboCounter.read_at(60.0) == 2 and ComboCounter.read_at(72.0) == 1, "read at 2 throws, 1 v a ring-smart opponent (65+)")
	_check(is_equal_approx(ComboCounter.chance("Slugger"), 0.35) and is_equal_approx(ComboCounter.chance("Counter-puncher"), 0.6125), "0.35 a throw into a read, a counter-puncher x1.75")
	_check(ComboCounter.bell({"1": 3, "2": 1}) == {"1": 2}, "each bell fades every count by one")
	_check(ComboCounter.film_start("1-2", 2) == {"1-2": 1} and ComboCounter.film_start("1-2", 1).is_empty() and ComboCounter.film_start("", 2).is_empty(), "the film: last bout's top line half-read")
	_check(ComboCounter.top({"1": 2, "1-2": 5, "slip": 1}) == "1-2", "the film takes the most-thrown line")
	var s := ComboCounter.countered({"won": true, "margin": 6.0, "landed": [3, 1]})
	_check(not bool(s["won"]) and float(s["margin"]) == -10.0, "a counter loses the exchange, margin -10")
	_check(float(ComboCounter.countered({"won": false, "margin": -14.0})["margin"]) == -14.0, "a worse margin stays")
	# The state on a fighter: a line thrown twice is read on the third throw; instinct is never counted.
	var f := {"bout": {"opp": {"rating": 60.0, "style": "Slugger"}}}
	ComboCounter.open_round(f, 1)
	_check(not bool(ComboCounter.throw(f, "", 0.0)["fired"]), "an instinct throw is not counted")
	ComboCounter.throw(f, "1-2", 0.0)
	ComboCounter.throw(f, "1-2", 0.0)
	var t3 := ComboCounter.throw(f, "1-2", 0.2)
	var t4 := ComboCounter.throw(f, "1-2", 0.5)
	_check(bool(t3["fired"]) and bool(t3["countered"]) and bool(t4["fired"]) and not bool(t4["countered"]), "the third throw meets the read; countered on a roll under 0.35")
	ComboCounter.open_round(f, 2)
	_check(int(f["bout"]["cc"]["1-2"]) == 3, "the count carries the bell, one less")
	_check(str(f["cc_film"]) == "1-2", "the bout's top line goes on film")
	f["bout"] = {"opp": {"rating": 60.0, "style": "Slugger"}}
	ComboCounter.open_round(f, 1)
	_check(f["bout"]["cc"] == {"1-2": 1}, "the next opponent starts with it half-read")
	var rows := ComboCounter.counters([{"n": 2, "exchanges": [{"arrow": "1-2", "cc": {"fired": true, "countered": false}}, {"arrow": "1-2", "cc": {"fired": true, "countered": true}}]}])
	_check(rows == {"1-2": {"n": 1, "fired": 2, "round": 2}}, "the bout's counters per line")
	_check(PlanReadShow.counter_text(rows["1-2"]) == "countered 1 of 2 throws into the read (first in round 2)", "the Plan tab's words")
	var tip := PlanReadShow.tip_counter()
	_check(tip.contains("After 2 throws") and tip.contains("(1 against") and tip.contains("about 35 in 100") and tip.contains("61 in 100"), "the tooltip's numbers are the rule's: " + tip)


func _bout(i: int, plan: Array, opp: Dictionary) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 30 + i
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0, "1-1-2": 50.0, "2-3": 40.0}
	f["arrows"] = plan.duplicate(true)
	f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
	OppFile.open_all(f["bout"]["opp"])
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	return m


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
