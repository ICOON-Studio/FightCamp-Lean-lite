extends RefCounted
## DUESWIRE1's step of the golden path (moved out at the S434 collect: golden_path_test.gd is over its 500-line cap).
## The player opens Dues, picks another price, plays on through the game's own day step until the month turns, sees the
## new price on the books, then plays on to an intake week and opens that week's review: the youth card is on it.
## Setup only: the youth section is bought with the club's money and dated 200 days back (the section's own 13-week wait
## is not what this step walks).

const GymSpend := preload("res://scripts/state/GymSpend.gd")
const HomeJuniors := preload("res://scripts/state/HomeJuniors.gd")
const Sim := preload("res://scripts/state/Sim.gd")


static func run(tree: SceneTree, main: Node, check: Callable) -> void:
	var c: Career = main.career
	check.call(c != null and not c.closed, "the dues step still has the gym")
	if c == null or c.closed:
		return
	main.act("close")
	if not GymSpend.youth_on(c):
		if c.cash < 1800:
			c.cash += 1800
		main.act("buyup", "youth")
	_age_youth(c)
	check.call(GymSpend.youth_on(c), "the youth section is open for the intake")
	var pick := "premium" if c.dues_band == "cheap" else "cheap"
	main.act("go", "money:0")
	await _frames(tree, 4)
	var tab := main.find_child("DuesTab", true, false) as Button
	check.call(tab != null, "the Dues tab is on the money page")
	if tab != null:
		tab.emit_signal("pressed")
	await _frames(tree, 3)
	var board := main.find_child("Dues_" + pick, true, false) as Button
	check.call(board != null, "the %s dues board is there" % pick)
	if board != null:
		board.emit_signal("pressed")
	await _frames(tree, 2)
	var yes := main.find_child("Btn_dues", true, false) as Button
	check.call(yes != null, "the dues change asks")
	if yes != null:
		yes.emit_signal("pressed")
	await _frames(tree, 3)
	main.act("close")
	# The game's own clock, a day at a time, until the new price is in force (it starts with the next month).
	for _d in 45:
		if c.dues_band_next == "" or c.closed:
			break
		Sim.step_day(c)
	check.call(c.dues_band == pick and c.dues_band_next == "", "the dues change is in force (%s / %s)" % [c.dues_band, c.dues_band_next])
	main.act("close")
	main.act("go", "money:0")
	await _frames(tree, 4)
	var month := main.find_child("DuesMonth", true, false) as Label
	var name := str(c.dues_band).capitalize()
	check.call(month != null and month.text.findn(name) >= 0, "the books say the new price is in force (%s)" % ("none" if month == null else month.text))
	# Play on to the end of an intake week: its review carries the youth card.
	var seen := false
	for _d in 400:
		if c.closed:
			break
		_age_youth(c)
		# Sim.end_week runs when the day steps onto a Monday: the intake rolls on the Monday that opens an intake week.
		var intake := posmod(c.day, 7) == 6 and HomeJuniors.INTAKE_WEEKS.has(HomeJuniors.week_of_year(c.day + 1))
		Sim.step_day(c)
		if intake:
			seen = true
			break
	check.call(seen, "an intake week came round (day %d)" % c.day)
	main.act("close")
	main.act("review")
	await _frames(tree, 3)
	check.call(main.find_child("YouthIntake", true, false) != null, "the intake week review shows the youth card")
	main.act("close")


static func _age_youth(c: Career) -> void:
	for o in c.upgrades:
		if str(o["id"]) == "youth" and c.day - int(o.get("day", c.day)) < 200:
			o["day"] = c.day - 200


static func _frames(tree: SceneTree, n: int) -> void:
	for _i in n:
		await tree.process_frame
