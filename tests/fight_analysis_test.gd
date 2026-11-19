extends SceneTree
## FIGHTPAGE1 - the FIGHT ANALYSIS page in film-night mode (scripts/ui/FightAnalysis.gd + FightAnalysisList.gd +
## FightAnalysisReport.gd). Two past bouts of an opponent with drops_right_after_jab against two different boxers, and
## one bout of an opponent without it; a fake coach check. Boxing.
## godot --headless --audio-driver Dummy --path . --script res://tests/fight_analysis_test.gd

const FA := preload("res://scripts/ui/FightAnalysis.gd")
const FB := preload("res://scripts/rules/FilmBout.gd")
const FL := preload("res://scripts/rules/FightLog.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")

var failures := 0
var checked: Array = []
var filed: Array = []
var done_n := 0
var screen: Control   # the page's parent: a 1920 x 1080 screen (a headless window is 64 x 64 and stretches)


func _initialize() -> void:
	screen = Control.new()
	screen.size = Vector2(1920, 1080)
	root.add_child(screen)
	_run()


func _check(ok: bool, what: String) -> void:
	if ok:
		print("PASS ", what)
	else:
		failures += 1
		print("FAIL ", what)


# --- fixtures ------------------------------------------------------------------------------------------------------------

func _opp_habit() -> Dictionary:
	return {"id": "holt_1", "name": "Mia Holt", "sex": "f", "style": "Pressure fighter", "threat": "cross",
		"weak": "Fades after round 2", "habits": ["drops_right_after_jab"]}


func _opp_plain() -> Dictionary:
	return {"id": "cole_2", "name": "Sam Cole", "sex": "m", "style": "Counter-puncher", "threat": "lead_hook",
		"weak": "", "habits": []}


func _film(opp: Dictionary, row: Dictionary) -> Dictionary:
	var f: Dictionary = FB.build(opp, row)
	f["row"] = row
	return f


func _habit_films() -> Array:
	return [_film(_opp_habit(), {"d": -40, "vs": "Tess Rowe", "vs_club": "Repton ABC", "win": true, "how": "on points, 2-1"}),
		_film(_opp_habit(), {"d": -95, "vs": "Jess Hardy", "vs_club": "Fitzroy Lodge ABC", "win": false, "how": "on points, 3-0"})]


func _night(checks: int) -> Dictionary:
	return {"checks_left": checks, "opp_checks_left": 6, "cost_words": "Costs tonight: pads, one-two 27 -> 31",
		"marked": [{"when": "hurt", "then": "wild", "words": "they are hurt -> single wild right", "per_film": ["watch list"],
			"word": "watch"}]}


func _fake_check(claim: Dictionary, films_seen: Array) -> Dictionary:
	checked.append([claim, films_seen.size()])
	return {"word": "pass", "k": 7, "n": 31, "e": 2.1, "z": 3.4}


func _fake_file(claim: Dictionary, word: String, n: int) -> void:
	filed.append([claim, word, n])


func _fake_done() -> void:
	done_n += 1


## FightLog.lines over a whole bout, round by round (the test's own count, not the page's helper).
func _lines(film: Dictionary) -> Array:
	var out: Array = []
	for rn in range(1, int(film["rounds"]) + 1):
		var exs: Array = []
		for ex in film["exchanges"]:
			if int((ex as Dictionary)["round"]) == rn:
				exs.append(ex)
		out.append_array(FL.lines(exs, rn))
	return out


func _open(opp: Dictionary, films: Array, night: Dictionary) -> Control:
	var p: Control = FA.new()
	p.for_tape(opp, films, night, _fake_check, _fake_file, _fake_done)
	screen.add_child(p)
	return p


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _press(p: Node, node_name: String) -> void:
	var b: Button = p.find_child(node_name, true, false)
	if b == null:
		_check(false, "button %s exists" % node_name)
		return
	b.pressed.emit()


# --- the run ---------------------------------------------------------------------------------------------------------------

func _run() -> void:
	var films: Array = _habit_films()
	var night: Dictionary = _night(2)
	var t0: int = Time.get_ticks_msec()
	var p: Control = _open(_opp_habit(), films, night)
	await _frames(4)
	var build_ms: int = Time.get_ticks_msec() - t0
	_check(p.list != null and p.report != null and p.header != null, "the page builds (header, punches, report)")
	var slot: Control = p.find_child("FilmSlot", true, false)
	_check(slot != null and slot.get_child_count() == 0, "an empty FilmSlot for the 3D film")
	var all1: Array = _lines(films[0])
	_check(all1.size() > 100, "film 1 has a bout's worth of lines (got %d)" % all1.size())
	_check(int(p.list.line_rows()) == all1.size() and (p.list.all as Array).size() == all1.size(),
		"list rows = FightLog.lines over film 1 (%d of %d)" % [int(p.list.line_rows()), all1.size()])
	var pool_n: int = p.list._pool.size()
	_check(pool_n < all1.size() and build_ms < 5000, "the list builds lazily (%d row nodes for %d lines, %d ms)" % [pool_n, all1.size(), build_ms])
	_check(str(p.list.count_label.text) == FL.count_line(all1, all1), "count line with no filter: " + str(p.list.count_label.text))
	# SHOW ME Them + Punch jab
	_press(p, "Corner_b")
	_check(bool(p.list.set_pick("punch", "jab")), "Punch picker offers jab")
	var want: Array = FL.filter(all1, {"corner": "b", "punch": "jab"})
	_check(str(p.list.count_label.text) == FL.count_line(want, all1), "Them + jab count line: " + str(p.list.count_label.text))
	_check((p.list.shown as Array).size() == want.size(), "Them + jab shows %d lines" % want.size())
	# Next moment
	var first: Dictionary = p.selected_line()
	_press(p, "NextMoment")
	_check(int(p.list.sel) == 1 and p.selected_line() == (p.list.shown as Array)[1] and p.selected_line() != first,
		"Next moment selects the next shown line")
	var clock: Label = p.find_child("Clock", true, false)
	_check(clock.text == "R%d %s" % [int(want[1]["round"]), FL.clock(float(want[1]["t"]))], "the clock shows the selected line: " + clock.text)
	_press(p, "PrevMoment")
	_check(int(p.list.sel) == 0, "Previous moment goes back")
	# After right low -> the camera line
	_check(bool(p.list.set_pick("after", "right low")), "After picker offers right low")
	var seen: Array = all1.filter(func(l): return str(l["who"]) == "b" and str(l["after"]) != "")
	var sc: Dictionary = FL.seen_count(seen, "jab", "right low")
	var jabs: int = all1.filter(func(l): return str(l["who"]) == "b" and str(l["punch"]) == "jab").size()
	var cam: String = "seen on camera: right low after %d of %d jabs - %d not seen" % [int(sc["k"]), int(sc["n"]), jabs - int(sc["n"])]
	_check(p.list.camera_label.visible and str(p.list.camera_label.text) == cam, "camera line = seen_count: " + str(p.list.camera_label.text))
	_check(int(sc["k"]) > 0, "the habit shows on camera (%d)" % int(sc["k"]))
	var shown_after: Array = FL.filter(all1, {"corner": "b", "punch": "jab", "after": "right low"})
	_check(str(p.list.count_label.text) == FL.count_line(shown_after, all1), "count line follows the After pick")
	# a combination time selects its line
	var chip: Button = p.report.find_child("ComboAt", true, false)
	if chip != null:
		chip.pressed.emit()
		var cl: Dictionary = p.selected_line()
		_check(not cl.is_empty() and "R%d %s" % [int(cl["round"]), FL.clock(float(cl["t"]))] == chip.text, "a combination time selects its line (%s)" % chip.text)
	# Check it with the coach -> one check, "That's it", File it at 70%
	p.set_claim(0, 0)
	_press(p, "CheckIt")
	_check(int(night["checks_left"]) == 1 and int(night["opp_checks_left"]) == 5, "Check it spends one check (%d left, %d for the opponent)" % [int(night["checks_left"]), int(night["opp_checks_left"])])
	_check(checked.size() == 1 and str(checked[0][0]["when"]) == "jab" and str(checked[0][0]["then"]) == "right_low" and int(checked[0][1]) == 1,
		"on_check gets the jab -> right hand low claim and one film seen")
	_check(str(p.coach_big.text).contains("That's it"), "coach line: " + str(p.coach_big.text))
	_check(str(p.file_btn.text) == "File it at 70%" and not p.file_btn.disabled, "File it shows 70%: " + str(p.file_btn.text))
	_check(str(p.find_child("ChecksWords", true, false).text) == "1 left - 5 for this opponent", "checks line: " + str(p.find_child("ChecksWords", true, false).text))
	_press(p, "FileIt")
	_check(filed.size() == 1 and str(filed[0][1]) == "pass" and int(filed[0][2]) == 1, "File it calls on_file(claim, pass, 1)")
	var marked: Array = night["marked"]
	_check(marked.size() == 2 and (marked[1]["per_film"] as Array)[0] == "7 of 31", "MARKED TONIGHT holds the earlier claim and the new one")
	var rows_before: int = p.find_child("Marked", true, false).get_child_count()
	# Next film
	_press(p, "NextFilm")
	await _frames(2)
	var all2: Array = _lines(films[1])
	_check(int(p.cur) == 1 and (p.list.all as Array).size() == all2.size() and int(p.list.line_rows()) == all2.size(),
		"Next film loads film 2 (%d lines)" % all2.size())
	_check(p.find_child("Marked", true, false).get_child_count() == rows_before and (night["marked"] as Array).size() == 2,
		"Next film keeps MARKED TONIGHT (%d rows)" % rows_before)
	_check(p.next_film_btn.disabled, "Next film is off on the last film")
	_check(p.find_child("Names", true, false).find_children("*", "Label", true, false).any(func(l): return (l as Label).text == "Jess Hardy"),
		"the header names film 2's other boxer")
	# the report check, then checks at 0
	_press(p, "Check_weapon")
	_check(checked.size() == 2 and str(checked[1][0]["when"]) == "report" and str(checked[1][0]["then"]) == "weapon" and int(checked[1][1]) == 2,
		"Check it (1): best weapon goes through on_check with two films seen")
	_check(int(night["checks_left"]) == 0 and p.check_btn.disabled, "checks at 0 disable Check it")
	var rep_btn: Button = p.find_child("Check_weapon", true, false)
	_check(rep_btn != null and rep_btn.disabled, "checks at 0 disable the report's Check it")
	_press(p, "CheckIt")
	_check(checked.size() == 2 and int(night["checks_left"]) == 0, "a disabled check spends nothing")
	# no he/she, no names outside the header (both report tabs)
	_words_check(p, ["Mia Holt", "Holt", "Tess Rowe", "Rowe", "Jess Hardy", "Hardy"], "them tab")
	p.report.set_tab("a")
	await _frames(1)
	_words_check(p, ["Mia Holt", "Holt", "Tess Rowe", "Rowe", "Jess Hardy", "Hardy"], "the other tab")
	_check(TextScale.overflow(p).is_empty(), "Normal text: nothing outside its box %s" % str(TextScale.overflow(p).slice(0, 3)))
	_fits(p, "Normal")
	_press(p, "Done")
	_check(done_n == 1 and p.is_queued_for_deletion(), "Done for tonight calls on_done and closes the page")
	await _frames(1)
	# the opponent without the habit (a man): "That's it"
	var plain: Dictionary = _film(_opp_plain(), {"d": -60, "vs": "Leo Grant", "vs_club": "Lynn AC", "win": true, "how": "stopped in round 2"})
	var q: Control = _open(_opp_plain(), [plain], _night(1))
	await _frames(3)
	_check(int(q.list.line_rows()) == _lines(plain).size(), "opponent without the habit: list rows = FightLog.lines")
	_check(q.next_film_btn.disabled, "one film: Next film off")
	_press(q, "CheckIt")
	_check(str(q.coach_big.text).contains("That's it"), "coach word for a man: " + str(q.coach_big.text))
	_words_check(q, ["Sam Cole", "Cole", "Leo Grant", "Grant"], "plain opponent")
	q.queue_free()
	await _frames(1)
	# Largest text: built again after TextScale.use(tree, 1.3)
	TextScale.use(self, 1.3)
	var big: Control = _open(_opp_habit(), _habit_films(), _night(3))
	await _frames(6)
	big.list.set_corner("b")
	big.list.set_pick("after", "right low")
	await _frames(3)
	var over: Array = TextScale.overflow(big)
	_check(over.is_empty(), "Largest text: TextScale.overflow(page) is empty %s" % str(over.slice(0, 4)))
	_fits(big, "Largest")
	big.queue_free()
	TextScale.use(self, 1.0)
	# S530: a round divider names whose game it is (the exchange's mode is the opponent's: Exchanges.next_mode), by role
	var dv: String = load("res://scripts/ui/FightAnalysisList.gd").divider(2, "press")
	_check(dv == "Round 2 - the opponent pressing forward", "divider has a subject, no name: '%s'" % dv)
	print("FIGHT_ANALYSIS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## No Label or Button says he / she (whole words), and no boxer's name appears outside the header.
func _words_check(p: Control, names: Array, what: String) -> void:
	var re := RegEx.new()
	re.compile("(?i)\\b(he|she)\\b")
	var bad_pronoun: Array = []
	var bad_name: Array = []
	var header: Control = p.header
	for n in p.find_children("*", "Control", true, false):
		if not (n is Label or n is Button):
			continue
		var text: String = str(n.get("text"))
		if re.search(text) != null:
			bad_pronoun.append(text)
		if header.is_ancestor_of(n):
			continue
		for nm in names:
			if text.contains(str(nm)):
				bad_name.append(text)
	_check(bad_pronoun.is_empty(), "%s: no he/she in any text %s" % [what, str(bad_pronoun.slice(0, 3))])
	_check(bad_name.is_empty(), "%s: no name outside the header %s" % [what, str(bad_name.slice(0, 3))])


## Every card stays inside the 1920 x 1080 screen.
func _fits(p: Control, what: String) -> void:
	var screen := Rect2(Vector2.ZERO, Vector2(1920, 1080))
	var out: Array = []
	for n in p.find_children("*", "PanelContainer", true, false):
		var c: Control = n
		if c.theme_type_variation == "Card" and not screen.encloses(c.get_global_rect().grow(-1.0)):
			out.append("%s %s" % [c.name, str(c.get_global_rect())])
	_check(out.is_empty(), "%s text: every card inside 1920x1080 %s" % [what, str(out)])
