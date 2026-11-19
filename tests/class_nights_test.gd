extends SceneTree
## S519 club week v11 3.2 (his Q-S294-272 "Yes, build it"; pads stay FULL, his Q-S294-260): an extra class night.
## Pure: toggle a weekday (never Sat/Sun, never without a coach), $117 a night, a member every 16 class nights.
## Wired on the test club (Lucy, Kira, Josh - three different boxers): the week's income carries the class money on its own
## line and the coach's $350 is untouched; a boxer on pads that evening drills half the minutes (and less mastery); the
## Training model's coach cell reads "class"; the act toggles it; members grow over weeks.
## Prints CLASS_NIGHTS failures=N.

const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const ClubWeek := preload("res://scripts/state/ClubWeek.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")

var _fails := 0


func _initialize() -> void:
	var coach := {"name": "x"}
	_check(ClubClasses.toggle(coach, 2) == [2], "Wednesday on")
	_check(ClubClasses.toggle(coach, 5) == [2], "Saturday never takes a class")
	_check(ClubClasses.toggle(coach, 0) == [0, 2] and ClubClasses.cash(coach) == 234, "two nights = $234: %d" % ClubClasses.cash(coach))
	_check(ClubClasses.toggle(coach, 2) == [0], "Wednesday off again")
	_check(ClubClasses.toggle({}, 1).is_empty() and ClubClasses.cash({}) == 0, "no coach, no class")
	var carry := 0.0
	var joined := 0
	for w in 16:
		var r := ClubClasses.members(carry, 1)
		carry = float(r["carry"])
		joined += int(r["joined"])
	_check(joined == 1, "one class night for 16 weeks = one member: %d" % joined)
	# --- wired
	var c := Career.quick_start()
	c.seed = 7
	TestClub.make(c)
	_check(not c.coach.is_empty(), "the test club has a coach")
	var f: Dictionary = c.fighters[0]
	var pads: Array = PadWeek.nights_of(f).get("pads", [])
	var d := -1
	for x in pads:
		if int(x) <= 4:
			d = int(x)
			break
	_check(d >= 0, "a weekday pad night: %s" % [pads])
	var inc0 := Sim.weekly_income(c)
	var m0 := DrillWeek.week_moves(c, f, DrillWeek.pad_skill(c))
	var full := PadWeek.night_minutes(DrillWeek.inputs(c, f)["nights"], d)
	ClubClasses.toggle(c.coach, d)
	var inc1 := Sim.weekly_income(c)
	_check(int(inc1["total"]) - int(inc0["total"]) == 117 and int(inc1.get("class_nights", 0)) == 117, "the week earns +$117 on its own line: %s" % inc1)
	_check(int(inc1["classes"]) == GameMoney.CLASSES_WITH_COACH, "the coach's usual $350 class money is untouched")
	var half := PadWeek.night_minutes(DrillWeek.inputs(c, f)["nights"], d)
	_check(is_equal_approx(half, full * 0.5), "the class evening drills half: %.0f -> %.0f min" % [full, half])
	var m1 := DrillWeek.week_moves(c, f, DrillWeek.pad_skill(c))
	_check(m1 < m0, "less mastery that week: %.2f -> %.2f" % [m0, m1])
	var cell := ClubWeek.coach_cell(c, d, -1)
	_check(str(cell["kind"]) == "class", "the coach row reads CLASS NIGHT: %s" % cell["kind"])
	# S525 MONEYFOUR2: a class on a weekday no boxer has pads earns nothing (it costs nothing); control: the pad night pays.
	var free := -1
	for x in [0, 1, 2, 3, 4]:
		if not c.fighters.any(func(g): return (PadWeek.nights_of(g).get("pads", []) as Array).has(x)):
			free = x
			break
	if free >= 0:
		ClubClasses.toggle(c.coach, free)
		_check(int(Sim.weekly_income(c).get("class_nights", 0)) == 117 and GymSpend.paying_classes(c) == 1,
			"a class on a no-pads evening earns nothing (%d paying of %d)" % [GymSpend.paying_classes(c), ClubClasses.nights(c.coach).size()])
		ClubClasses.toggle(c.coach, free)
	var mem0 := c.members
	for w in 16:
		c.coach["class_carry"] = float(c.coach.get("class_carry", 0.0))
		GymSpend._class_members(c)
	_check(c.members >= mem0 + 1, "a paying class night for 16 weeks brings a member: %d -> %d" % [mem0, c.members])
	_done()


func _done() -> void:
	print("CLASS_NIGHTS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
