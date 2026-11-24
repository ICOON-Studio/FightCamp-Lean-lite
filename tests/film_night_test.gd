extends SceneTree
## S510 FIGHTFILM1 slice 1 (owner Q-S294-256 "Yes, build it"; map ops/research/FIGHTFILM1_MAP_V3_S495.md 3.1-3.6): the fight
## week's film evening watched by the player. The quick-start career books an even club-show bout; the opponent drops the
## right after the jab ("chin open"). Through the real actions:
##   1. FilmNight.films gives her past bouts as films; the night has checks (coach rating) under the 6-an-opponent cap.
##   2. The fight week screen shows LET THE COACH WATCH once the film night is on; fwfilmself switches to WATCH IT YOURSELF.
##   3. Locking with WATCH IT YOURSELF opens the FIGHT ANALYSIS page instead of locking.
##   4. The real claim (their jab -> right hand low), checked on her films and filed, opens that habit in her file; a noise
##      claim filed stays a false lead (not opened). A check spends one of her checks.
##   5. Done for tonight locks the week: fw_film_self, no free coach tell on top (only the filed habit is found).
## Boxing. godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/film_night_test.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const FilmNight := preload("res://scripts/state/FilmNight.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")
const FightPrep := preload("res://scripts/ui/FightPrep.gd")
const StaffDesk := preload("res://scripts/ui/StaffDesk.gd")   # S547 STAFFCARDS1: the coach card's hover says the film checks
const OppFileCard := preload("res://scripts/ui/OppFileCard.gd")
const PlanChart := preload("res://scripts/ui/PlanChart.gd")
const GamePlanRows := preload("res://scripts/ui/GamePlanRows.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const ResultPage := preload("res://scripts/ui/ResultPage.gd")
const BoutHistory := preload("res://scripts/ui/BoutHistory.gd")
const FightAnalysisOwn := preload("res://scripts/ui/FightAnalysisOwn.gd")
const FightAnalysisTape := preload("res://scripts/ui/FightAnalysisTape.gd")
const FilmPattern := preload("res://scripts/rules/FilmPattern.gd")


## A Game plan stand-in for GamePlanRows.film_fit: the fighter's booked bout.
class PlanStub:
	var f: Dictionary
	func _bout() -> Dictionary:
		return f.get("bout", {})

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
	var opp: Dictionary = f["bout"]["opp"]
	opp["weak"] = "Chin open after the jab"
	opp["w"] = 3
	opp["l"] = 1
	opp.erase("file_found")
	var real := "habit:drops_right_after_jab"
	_check(OppFile.hidden(opp).has(real), "her habit is hidden before the night")
	# 1. films and checks
	var films := FilmNight.films(c, f)
	_check(films.size() >= 2, "her past bouts give films (%d)" % films.size())
	var night := FilmNight.night(c, f, films.size())
	_check(int(night["checks_left"]) >= 2 and int(night["checks_left"]) <= FilmNight.OPP_CHECK_CAP, "tonight has checks (%d)" % int(night["checks_left"]))
	# 2. the screen's switch
	main.act("fightweek", str(f["id"]))
	main.modal["plan"]["nights"] = {}
	main.modal["plan"]["film"] = true
	main.redraw_modal()
	await process_frame
	_check(main.find_child("FilmSelfBtn", true, false) != null, "the film night offers who watches it")
	main.act("fwfilmself")
	_check(bool(main.modal["plan"].get("film_self", false)), "WATCH IT YOURSELF is on")
	# 3. lock opens the page
	main.act("fwlock")
	var page: Node = main.find_child("FightAnalysis", true, false)
	_check(page != null, "locking opens the FIGHT ANALYSIS page")
	_check(FightWeekPlan.is_open(f), "the week is not locked while the tape is watched")
	if page == null:
		_done()
		return
	await process_frame
	# 3b. S511 File it on the page, then Write the answer opens the Game plan over the film
	page.set_claim(FilmPattern.WHEN_IDS.find("jab"), FilmPattern.THEN_IDS.find("right_low"))
	page.check_claim(page.pattern_claim(), "")
	page.file_it()
	_check(str(page.file_btn.text) == "Write the answer" and not page.file_btn.disabled, "after File it the button reads Write the answer (%s)" % str(page.file_btn.text))
	page.file_it()
	await process_frame
	var over: Node = page.find_child("WriteAnswer", true, false)
	_check(over != null and over.find_child("GamePlan", true, false) != null and _has_text(over, "when the opponent boxes at range"), "Write the answer opens the Game plan on the range line")
	if over != null:
		over.queue_free()
	# 4. the real claim and a noise claim
	var claim := {"when": "jab", "then": "right_low", "words": "their jab -> right hand low"}
	var used0 := int(opp.get("film_checks_used", 0))
	var res := FilmNight.check(f, claim, films)
	_check(int(opp.get("film_checks_used", 0)) == used0 + 1, "a check spends one of her checks")
	_check(str(res.get("word", "")) == "pass", "the coach's count passes the real habit on %d films (%s k=%d n=%d)" % [films.size(), str(res.get("word", "")), int(res.get("k", 0)), int(res.get("n", 0))])
	var e := FilmNight.file(f, claim, str(res.get("word", "")), films.size())
	_check(str(e["tell"]) == real and int(e["pct"]) == 85, "filed: the real habit at 85%% (%s %d%%)" % [str(e["tell"]), int(e["pct"])])
	_check(OppFile.known(opp, real), "the filed habit opens in her file")
	var noise := FilmNight.file(f, {"when": "combo", "then": "lunged", "words": "noise"}, "pass", 1)
	_check(str(noise["tell"]) == "" and int(noise["pct"]) == 70, "a noise claim files as a false lead at 70%")
	_check((opp.get("filed", []) as Array).size() == 2, "two claims on her file")
	# 4b. S511 Playbook > Game plan: a line resting on a filed claim shows its figure and rates Works at best
	f["arrows"] = (f["arrows"] as Array) + [{"move": "slip 2-3", "when": "range"}, {"move": "3b-3", "when": "tiring"}]
	_check(FilmNight.sit_of(e) == "range" and FilmNight.sit_of(noise) == "tiring", "the claims rest on the range and tiring lines")
	var gp := PlanStub.new()
	gp.f = f
	_check(str(GamePlanRows.film_fit(gp, {"fit": "best"}, "range")["fit"]) == "ok", "an open film claim caps its line at Works")
	_check(str(GamePlanRows.film_fit(gp, {"fit": "best"}, "press")["fit"]) == "best", "a line with no film claim keeps Beats it")
	var plan := await _plan(f)
	_check(_has_text(plan, "Film 85%") and _has_text(plan, "Film 70%"), "the Game plan marks both lines with their figures")
	plan.queue_free()
	# 5. done locks the week
	var hidden_before := OppFile.hidden(opp).size()
	page.done_for_tonight()
	await process_frame
	_check(not FightWeekPlan.is_open(f), "Done for tonight locks the week")
	_check(bool(f["bout"].get("fw_film_self", false)), "the bout keeps that the player watched")
	_check(OppFile.hidden(opp).size() == hidden_before, "no free coach tell on top of the filings")
	# 6. Fight prep lists what the film filed, strongest first, with its figure
	var pr := FilmNight.prep_rows(f)
	_check(pr.size() == 2 and str(pr[0][1]).begins_with("85%"), "Fight prep rows: the 85%% claim first (%s)" % str(pr))
	var box: Node = FightPrep.make(main, c, f)
	root.add_child(box)
	await process_frame
	_check(_has_text(box, "From the film: their jab -> right hand low"), "the Fight prep card shows the filed claim")
	# 7. the corner minute: a round that came up confirms the real claim and clears the noise
	var rnd := {"exchanges": [{"mode": "range", "won": true, "body": false, "after": {"hurt": [false, false]}}]}
	var res1 := FilmNight.minute(f, rnd, 1)
	var states := {}
	for x in res1:
		states[str(x["words"])] = str(x["state"])
	_check(states.get("their jab -> right hand low", "") == "confirmed", "round 1's corner CONFIRMS the real habit (%s)" % str(states))
	_check(states.get("noise", "") == "cleared", "round 1's corner CLEARS the noise claim")
	_check(FilmNight.minute(f, rnd, 2).is_empty(), "a settled claim is not checked again")
	_check(str(FilmNight.prep_rows(f)[0][2]) == "confirmed", "Fight prep then reads CONFIRMED")
	_check(str(GamePlanRows.film_fit(gp, {"fit": "best"}, "range")["fit"]) == "best", "a CONFIRMED claim lets its line rate Beats it")
	_check(str(GamePlanRows.film_fit(gp, {"fit": "ok"}, "tiring")["fit"]) == "none", "a CLEARED claim's line answers nothing")
	var plan2 := await _plan(f)
	_check(_has_text(plan2, "Film: confirmed") and _has_text(plan2, "Cleared - change this line"), "the Game plan says CONFIRMED and change this line")
	plan2.queue_free()
	# 7b. Fight prep's Watch the tape (the retired Tape Room): her films and the report, no checks, Close
	var watch: Node = FightAnalysisTape.watch(main, c, f)
	await process_frame
	_check(watch != null and (watch.films as Array).size() >= 2 and watch.checks_left() == 0, "Watch the tape opens her films with no checks")
	_check(watch != null and str((watch.find_child("Done", true, false) as Button).text) == "Close" and watch.find_child("Marked", true, false) != null, "Watch the tape closes with Close and shows the filed claims")
	if watch != null:
		watch.done_for_tonight()
	var card: Node = OppFileCard.build(opp)
	root.add_child(card)
	_check(_has_text(card, "From the film: their jab -> right hand low") and _has_text(card, "CONFIRMED in the ring"), "her file card shows the filed claim and its state")
	_check(StaffDesk.means(85.0).contains("4 film checks") and StaffDesk.means(50.0).contains("2 film checks"), "the coach card says the film checks a night (top coach 4, new coach 2): %s" % StaffDesk.means(85.0))
	_check(not FilmNight.came_up("hurt", rnd) and FilmNight.came_up("hurt", {"exchanges": [{"after": {"hurt": [false, true]}}]}), "a hurt claim waits for the opponent to be hurt")
	await _own_bout(c, f)
	_done()


## 8. S511 your own bout (map 5): the bout is boxed; its results row keeps the tape and FightWhy's lines; the result page's
## PUNCH BY PUNCH opens the analysis page on it (You / The opponent, WHAT THE OTHER CORNER WILL SEE); History's Analysis
## opens it too; Fix it on the pads books the habit fix of a habit your boxer showed.
func _own_bout(c: Career, f: Dictionary) -> void:
	f["habits"] = ["drops_right_after_jab"]
	f.erase("habit_fix")
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	var m := {"fid": str(f["id"]), "step": "tape", "round": 0, "rounds": [], "total": 3, "type": "fight"}
	Bouts.fight_step(c, f, m, "start")
	Bouts.fight_step(c, f, m, "corner:lead")
	Bouts.fight_step(c, f, m, "round_out")
	# 7c. S511 the corner minute after round 1: The round so far opens the page on the rounds fought, read-only
	main.open_modal(m)
	await process_frame
	var sofar: Button = main.find_child("RoundSoFar", true, false)
	_check(sofar != null, "the corner minute offers The round so far (step %s, %d rounds)" % [str(m.get("step", "")), (m["rounds"] as Array).size()])
	if sofar != null:
		sofar.pressed.emit()
		await process_frame
		var pg: Node = null
		for ch in main.get_children():
			if ch.get_script() == FightAnalysisOwn:
				pg = ch
		_check(pg != null and _has_text(pg, "the rounds so far: 1"), "The round so far shows round 1's punches")
		if pg != null:
			pg.done_for_tonight()
	Bouts.fight_step(c, f, m, "rest")
	_check(str(m.get("step", "")) == "result", "the bout is boxed to its result (%s)" % str(m.get("step", "")))
	var row: Dictionary = c.results[0] if not c.results.is_empty() else {}
	_check(not (row.get("tape", []) as Array).is_empty() and (row.get("why3", []) as Array).size() == 3, "the results row keeps the tape and what decided it")
	var page: Node = ResultPage.punches(main, m)
	await process_frame
	_check(page != null and page.get_script() == FightAnalysisOwn, "PUNCH BY PUNCH opens the analysis page on the bout")
	if page == null:
		return
	_check(_has_text(page, str(f["name"])) and _has_text(page, "You") and _has_text(page, "The opponent"), "the page reads You / The opponent, names in the header only")
	_check((page.list.all as Array).size() >= 40, "every punch of the bout is listed (%d)" % (page.list.all as Array).size())
	_check(page.find_child("OtherCornerSees", true, false) != null and page.find_child("Pattern", true, false) == null, "WHAT THE OTHER CORNER WILL SEE replaces MARK A PATTERN")
	var facts: Array = FightAnalysisOwn.stand_out(FightAnalysisOwn.film_of(row))
	var jab := facts.filter(func(x): return str(x["claim"]["when"]) == "jab" and str(x["claim"]["then"]) == "right_low")
	_check(not jab.is_empty(), "the other corner would see the dropped right after the jab (%s)" % str(facts.map(func(x): return x["claim"]["words"])))
	_check(page.fix_on_pads("drops_right_after_jab") and str(f.get("habit_fix", {}).get("id", "")) == "drops_right_after_jab", "Fix it on the pads books the habit fix")
	_check(not page.fix_on_pads("drops_right_after_jab"), "one habit on the pads at a time")
	page.done_for_tonight()
	var hist: Node = BoutHistory.make(main, c, f)
	root.add_child(hist)
	await process_frame
	var btn: Button = hist.find_child("Analysis", true, false)
	_check(btn != null, "History's bout row offers Analysis")
	if btn != null:
		btn.pressed.emit()
		await process_frame
		_check(main.find_child("FightAnalysis", true, false) != null, "Analysis opens the page from History")


func _plan(f: Dictionary) -> Node:
	var g: Node = PlanChart.chart(main, f, func(_id): pass)
	root.add_child(g)
	await process_frame
	return g


func _has_text(n: Node, s: String) -> bool:
	if n is Label and (n as Label).text.contains(s):
		return true
	for ch in n.get_children():
		if _has_text(ch, s):
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
	print("FILM_NIGHT failures=%d" % failures)
	quit(1 if failures > 0 else 0)
