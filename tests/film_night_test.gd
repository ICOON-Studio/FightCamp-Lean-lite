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
const StaffCard := preload("res://scripts/ui/StaffCard.gd")
const OppFileCard := preload("res://scripts/ui/OppFileCard.gd")

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
	var card: Node = OppFileCard.build(opp)
	root.add_child(card)
	_check(_has_text(card, "From the film: their jab -> right hand low") and _has_text(card, "CONFIRMED in the ring"), "her file card shows the filed claim and its state")
	var tiles: Node = StaffCard._facts({"rating": 85.0, "salary": 450}, false)
	root.add_child(tiles)
	_check(_has_text(tiles, "4 checks") and _has_text(StaffCard._facts({"rating": 50.0}, false), "2 checks"), "the coach card says the film checks a night (top coach 4, new coach 2)")
	_check(not FilmNight.came_up("hurt", rnd) and FilmNight.came_up("hurt", {"exchanges": [{"after": {"hurt": [false, true]}}]}), "a hurt claim waits for the opponent to be hurt")
	_done()


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
