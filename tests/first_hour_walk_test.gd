extends SceneTree
## S397 rank 5: the first hour played through the real scenes, timed by an estimate (ops/research/RANK5_FIRST_HOUR_S397.md
## section 6; design bar docs/STRUCTURE_DESIGN_S395.md section 8: the fight by minute 25, the Why by minute 35).
## Title -> New career -> YOU (a coach card) -> YOUR CLUB (a start) -> Home's job card -> the walk-in -> an assistant ->
## week 1 (the coach line's change taken: the cut starts now) -> Monday week 2: the show's offer -> Fight prep: the camp ->
## the Playbook: one line of the player's own -> the weigh-in (made) -> fight night (two corner calls) -> the result and the
## Why ("Your plan") -> Monday: the second walk-in -> sign -> the club tasks.
## THE CLOCK (an estimate, not a stranger - Gate 1 times real people): every screen landed on is read at READ_WPM (the
## onboarding critic's slower rate), capped at READ_CAP words a screen (nobody reads a whole page on a first look); every
## decision costs DECIDE_S; CONTINUE's days tick at the default speed (Clock.TICK_MS); fight night is FIGHT_S (three watched
## rounds and two corner minutes, the Week 5 decided numbers). A page seen before in the same layout (the weekly review, a
## Monday in camp) is skimmed: SKIM_WORDS read, not the cap - the second review is read for what changed. Prints a
## minute-by-minute log.

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")

const READ_WPM := 180.0
const READ_CAP := 250
const DECIDE_S := 6.0
const SKIM_WORDS := 60
const FIGHT_S := 3 * 40.0 + 2 * 45.0 + 30.0
const FIGHT_BY_MIN := 25.0
const WHY_BY_MIN := 35.0

var failures := 0
var main: Node
var secs := 0.0
var log_lines: Array = []
var seen := {}


func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.quiet_moments = true
	_play()
	for l in log_lines:
		print("  " + str(l))
	print("FIRST_HOUR_WALK failures=%d minutes=%.1f" % [failures, secs / 60.0])
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


## The player lands on a screen: reads it (capped) and makes `decisions` choices there.
func _screen(what: String, decisions: int) -> void:
	main.render()
	var words := 0
	for n in main.find_children("*", "Label", true, false):
		var l := n as Label
		if l.is_visible_in_tree():
			words += l.text.split(" ", false).size()
	var cap := READ_CAP if not seen.has(what) else SKIM_WORDS
	seen[what] = true
	var read := minf(float(words), float(cap)) / READ_WPM * 60.0
	secs += read + DECIDE_S * decisions
	log_lines.append("%5.1f min  %s (%d words, %d decision%s)" % [secs / 60.0, what, words, decisions, "" if decisions == 1 else "s"])


func _days(n: int) -> void:
	secs += float(n) * float(Clock.TICK_MS[main.speed - 1]) / 1000.0


func _button(root_node: Node, name: String) -> Button:
	return null if root_node == null else root_node.find_child(name, true, false) as Button


func _press(b: Button, label: String) -> void:
	_check(b != null and not b.disabled and b.is_visible_in_tree(), label)
	if b != null and not b.disabled:
		b.emit_signal("pressed")


func _run_to_stop() -> void:
	_days(main.run_to_stop())
	var c: Career = main.career
	if c.review_pending:
		main.act("review")
		_screen("the week's review", 1)
		main.act("close")


func _play() -> void:
	_screen("title", 1)
	main.act("newcareer")
	_check(main.screen == "create", "New career opens YOU")
	_screen("YOU: four coaches", 2)
	for id in HeadCoach.ids():
		_check(main.find_child("Coach_" + id, true, false) != null, "the %s card is on screen" % id)
	main.act("cpick", "coach|expro")
	_press(_button(main, "CreateNext"), "Next: your club")
	_screen("YOUR CLUB: three starts", 2)
	main.act("cpick", "start|fresh")
	_press(_button(main, "CreateStart"), "Open the gym")
	var c: Career = main.career
	c.seed = 1
	_check(main.screen == "career" and HeadCoach.of(c.head) == "expro" and c.start == "fresh", "the career carries the picks")
	_check(main.find_child("FirstHourCard", true, false) != null, "Home opens with the job and the show's clock")
	_screen("Home: the job", 1)

	main.on_go()
	_check(str(main.modal.get("type", "")) == "interview", "the walk-in")
	_screen("the walk-in's card", 2)
	main.act("pickcard", "habit")
	_press(_button(main.modal_node(), "Sign"), "sign the walk-in")
	main.on_go()
	_screen("Club > People: two assistants", 1)
	main.act("hire", "reid")
	main.on_go()
	_check(main.on_week_tab(), "the week")
	_screen("the coach's draft week", 2)
	var lucy := c.fighter()
	_check(str(lucy["diet"]) != "cut", "no fight yet: nothing asks for a cut in week 1 (S416)")
	main.on_go()
	_check(c.guide == "go", "week 1 locked")
	main.act("area", "home")
	_run_to_stop()
	_screen("Monday, week 2", 1)

	_check(c.day == FirstHour.OFFER_DAY and c.guide == "offer", "Monday of week 2: the show's offer (day %d, guide %s)" % [c.day, c.guide])
	main.on_go()
	_check(str(main.route.get("bout", "")) != "", "the bout page")
	_screen("the show's bout page", 2)
	_press(_button(main, "Accept"), "accept the show")
	_check(int(lucy["bout"].get("day", -1)) == FirstHour.SHOW_DAY, "booked for Sat 24 Jan")
	main.act("camp")
	_screen("the camp", 2)
	_press(_button(main.modal_node(), "StartCamp"), "start the camp")
	main.nav({"area": "fighters", "tab": 0, "fighter": str(lucy["id"]), "ftab": 7, "ptab": 1})
	_screen("the Playbook", 1)
	var write := main.find_children("*", "Button", true, false).filter(func(b): return (b as Button).text == "Write a line" and (b as Button).is_visible_in_tree())
	_check(not write.is_empty(), "the Playbook offers a line to write")
	if not write.is_empty():
		(write[0] as Button).emit_signal("pressed")
		await_frame()
		var opts := main.find_children("Opt_*", "Button", true, false).filter(func(b): return not (b as Button).disabled)
		_check(not opts.is_empty(), "the line offers moves")
		if not opts.is_empty():
			(opts[0] as Button).emit_signal("pressed")
		_screen("the line written", 2)
		var said := main.find_children("*", "Label", true, false).filter(func(l): return (l as Label).is_visible_in_tree() and (l as Label).text.contains("Write one line"))
		_check(said.is_empty(), "the guide moves on the moment a line is written (S416)")
	_check(not (lucy.get("arrows", []) as Array).is_empty(), "the plan has a line of the player's own")
	main.act("area", "home")

	for i in 4:
		if Bouts.weigh_in_today(c, lucy):
			break
		_run_to_stop()
		if not Bouts.weigh_in_today(c, lucy):
			_screen("a Monday in camp", 1)
	_check(Bouts.weigh_in_today(c, lucy), "the weigh-in")
	main.act("go_btn")
	_screen("the weigh-in", 1)
	_press(_button(main.modal_node(), "Scale"), "step on the scale")
	_check(bool(lucy["bout"].get("made", false)), "made weight: %.2f kg for %.1f" % [float(lucy["weight"]), float(lucy["limit"])])
	if lucy["bout"].is_empty():
		return
	_days(main.run_to_stop())
	main.act("go_btn")
	_check(main.modal.get("type", "") == "fight", "fight night")
	var fight_min := secs / 60.0
	_press(_button(main.modal_node(), "Begin"), "begin")
	_round()
	_press(_button(main.modal_node(), "Corner_long"), "corner call after round 1")
	_round()
	_press(_button(main.modal_node(), "Corner_body"), "corner call after round 2")
	_round()
	secs += FIGHT_S
	log_lines.append("%5.1f min  fight night (%.0f s)" % [secs / 60.0, FIGHT_S])
	_press(_button(main.modal_node(), "Scorecards"), "to the scorecards")
	_screen("the result and the Why", 2)
	var why_min := secs / 60.0
	var opp_first := str((lucy["bout"].get("opp", {}) as Dictionary).get("first", ""))
	var why := FightWhy.read(main.modal.get("rounds", []), str(lucy["first"]), opp_first)
	print("  the Why's plan line: %s" % str(why.get("plan", "")))
	_check(str(why.get("plan", "")).begins_with("Your plan"), "the Why credits the player's own plan")
	_check(fight_min <= FIGHT_BY_MIN, "the fight starts by minute %.0f (estimate %.1f)" % [FIGHT_BY_MIN, fight_min])
	_check(why_min <= WHY_BY_MIN, "the Why by minute %.0f (estimate %.1f)" % [WHY_BY_MIN, why_min])
	_press(_button(main.modal_node(), "BackHome"), "back home")
	_check(c.guide == "club", "the guide moves to the club tasks (%s)" % c.guide)

	_run_to_stop()
	_check(str(c.applicant.get("id", "")) == FirstHour.SECOND_WALKIN, "Monday: the second walk-in")
	main.act("interview")
	_screen("the second walk-in", 2)
	main.act("pickcard", "habit")
	_press(_button(main.modal_node(), "Sign"), "sign the second boxer")
	_check(c.fighters.size() == 2 and bool(FirstHour.tasks(c)["second"]), "task: a second boxer")
	_check(c.grapplers.is_empty(), "no grappler in the first hour")
	log_lines.append("%5.1f min  the first hour's core is done" % (secs / 60.0))


func _round() -> void:
	var i := 0
	while not LiveRound.live(main.modal).is_empty() and i < 6:
		var fv: Dictionary = main.career.fighter_by_id(str(main.modal["fid"]))
		var pv := LiveRound.preview(fv, main.modal)
		var b := _button(main.modal_node(), "Shout_" + str(pv["coach"]))
		if b == null:
			b = _button(main.modal_node(), "SayNothing")
		if b == null:
			break
		b.emit_signal("pressed")
		i += 1


func await_frame() -> void:
	main.render()
