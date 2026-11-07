extends SceneTree
## S397 blind rounds 5-6 ("the Week tab plans Mon 2 - Sun 8 Feb when today is Sat 7"): Saturday and Sunday plan NEXT week.
## Population: TestJump "nationals" (Sat 7 Feb, Lucy free to fight, her fight week just done).
## 1. On the Saturday her Week tab says NEXT WEEK with Monday's dates, not THIS WEEK.
## 2. A morning changed on the weekend waits in week_edits_next for that Monday; this week's exceptions are untouched.
## 3. The sim's Monday moves it in: Monday's week runs the card picked on Saturday (WeekPlan.days_of).
## 4. Monday's board is THIS WEEK again, and the picked card is still there.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")

var _fails := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	TestJump.run(main, "nationals")
	if not main.modal.is_empty():
		main.act("close")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var fid := str(f["id"])
	_check(WeekPhase.weekend(c.day), "the jump lands on a weekend (day %d, dow %d)" % [c.day, posmod(c.day, 7)])
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _frames(4)
	var text := _texts(main)
	var monday := c.day - posmod(c.day, 7) + 7
	_check(text.contains("NEXT WEEK") and not text.contains("THIS WEEK"), "1: the weekend board is NEXT WEEK")
	_check(text.contains(Clock.fmt(monday)), "1: with next Monday's date (%s)" % Clock.fmt(monday))
	# S397 Week critic round 2: rest nights are one-line strips; the coach's change is one click (CoachApply)
	var nights := main.find_child("Nights", true, false)
	var thin := 0
	for n in (nights.get_children() if nights != null else []):
		if str(n.get("kind")) == "rest":
			thin += 1 if (n as Control).size.y < 60.0 else 0
			_check((n as Control).size.y < 60.0, "rest night %s is a strip (%.0f px)" % [n.name, (n as Control).size.y])
	_check(thin > 0, "the week has rest nights drawn as strips")
	_check(not text.contains("holds the pads
") or text.count("holds the pads") == 1, "who holds the pads is said once")
	# the critic's "sparring 1 but no sparring night": next week's nights are next week's, not this week's run ones
	for d in (PadWeek.nights_of(WeekPhase.ahead_view(f, c.day))["spar"] as Array):
		var sn := main.find_child("Night_%d" % int(d), true, false)
		_check(sn != null and str(sn.get("kind")) == "sparring", "next week's sparring night %d is drawn SPARRING" % int(d))
	var apply := main.find_child("CoachApply", true, false) as Button
	if apply != null:
		apply.pressed.emit()
		await _frames(2)
		var ed: Dictionary = (f.get("week_edits_next", {}) as Dictionary).get("days", {})
		_check(not ed.is_empty() or str(f.get("diet", "")) == "cut", "Do it made the coach's change (%s)" % str(ed))
		f.erase("week_edits_next")
	var before: Dictionary = (f.get("week_edits", {}) as Dictionary).duplicate(true)
	main.act("wday", "%s|1|intervals|hard" % fid)   # Tuesday
	await _frames(2)
	var nx: Dictionary = f.get("week_edits_next", {})
	_check(int(nx.get("monday", -1)) == monday and (nx.get("days", {}) as Dictionary).has("1"), "2: the change waits for Monday %s" % str(nx))
	_check(f.get("week_edits", {}) == before, "2: this week's exceptions are untouched")
	main.run_to_stop(3)   # to the Monday week review
	_check(posmod(c.day, 7) == 0 and c.day == monday, "3: the clock reached that Monday (day %d)" % c.day)
	var days := WeekPlan.days_of(f)
	_check(days[1] == ["intervals", "hard"], "3: Monday's week runs the Saturday pick on Tuesday (%s)" % str(days[1]))
	_check(not f.has("week_edits_next"), "3: the next-week slot is spent")
	if not main.modal.is_empty():
		main.act("close")
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _frames(4)
	text = _texts(main)
	_check(text.contains("THIS WEEK") and not text.contains("NEXT WEEK"), "4: Monday's board is THIS WEEK")
	_end()


func _texts(n: Node) -> String:
	var out := ""
	for l in n.find_children("*", "Label", true, false):
		out += str((l as Label).text) + "\n"
	return out


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		_fails += 1
		print("FAIL ", label)


func _end() -> void:
	print("WEEKEND_PLAN %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(1 if _fails > 0 else 0)
