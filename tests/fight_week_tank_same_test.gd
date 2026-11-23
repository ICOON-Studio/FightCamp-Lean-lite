extends SceneTree
## S543 (DEPTHPRICE1 code-checked critic, claim 1d): the tank the FIGHT WEEK screen shows is the tank the bout uses.
## The screen read FightWeek.tank's own tiredness layer (1 a point over 50, cap 25, no last-bout part); the bout reads
## BoutRules.tank_parts_for (2 a point, cap 20, +8 for a bout inside 7 days, capped at 25) plus the week's choices.
## For every load, at four start tirednesses, with and without a bout six days before:
##   FightWeekPlan.read(...).tank.off == BoutRules.tank_parts_for on the bout as the week would lock it, and the rows
##   shown add up to it. The ON FIGHT NIGHT panel no longer promises "Fatigue after the bell" (shown, never applied).

const TestJump := preload("res://scripts/ui/TestJump.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
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
	var plan: Dictionary = FightWeekPlan.draft(c, f)
	plan["nights"] = {}
	plan["eat_less"] = false
	var differs := 0
	for last in [-1, 6]:
		if last >= 0:
			f["last_bout_day"] = int(b["day"]) - last
		for tired in [40.0, 55.0, 64.0, 75.0]:
			f["week_fatigue"] = tired
			for stop in FightWeek.STOPS:
				var p: Dictionary = plan.duplicate(true)
				p["stop"] = stop
				var shown: Dictionary = FightWeekPlan.read(c, f, p)["tank"]
				var fx := f.duplicate()
				var bx: Dictionary = b.duplicate()
				bx["load"] = stop
				bx["spar_days"] = []
				bx["eat_less"] = false
				fx["bout"] = bx
				var fought := float(BoutRules.tank_parts_for(c.results, fx, tired, int(b["day"]))["off"])
				var sum := 0
				for row in shown["parts"]:
					sum += int(row[1])
				var same := absf(float(shown["off"]) - fought) < 0.6 and sum == int(shown["off"])
				if not same:
					differs += 1
					print("  differs: last bout %d days, tiredness %d, %s: the screen %d (rows %d), the bout %.1f"
						% [last, int(tired), stop, int(shown["off"]), sum, fought])
	_check(differs == 0, "the screen's tank is the bout's tank in all 24 cases (%d differ)" % differs)
	main.act("fightweek", str(f["id"]))
	_check(str(main.modal.get("type", "")) == "fightweek", "the fight week screen opens")
	_check(not _says(main, "Fatigue after the bell"), "the screen does not promise a fatigue after the bell that the game never applies")
	_done()


func _says(n: Node, words: String) -> bool:
	if n is Label and (n as Label).is_visible_in_tree() and (n as Label).text.contains(words):
		return true
	for k in n.get_children():
		if _says(k, words):
			return true
	return false


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
	print("FIGHT_WEEK_TANK_SAME checks failures=%d" % failures)
	quit(1 if failures > 0 else 0)
