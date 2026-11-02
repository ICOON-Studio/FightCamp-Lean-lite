extends SceneTree
## The golden path, played through the real scenes. Week 1: quick start -> the walk-in (CONTINUE says NEEDS YOU and opens
## her) -> three cards -> sign -> GYM > Staff -> hire Luke Reid -> a week of CONTINUE that stops at the review. Week 2: two
## offers arrive (one legal, one unsafe that cannot be accepted) -> accept -> SET CAMP -> the weeks run to the weigh-in ->
## she makes weight -> GO TO FIGHT NIGHT -> three rounds with two corner calls -> the result books record, cash, members ->
## NEW GOAL -> the office -> her next goal -> the next offer comes. Week 3: sponsors, a repair, the MONEY tabs, save from
## the Gear menu mid-camp and load it back, a second bout, twelve weeks that hold together, the rankings.
## Then a second career where she misses weight.
## Every area and tab draws, mid-camp and at the end.

const Data := preload("res://scripts/state/Data.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Region := preload("res://scripts/state/Region.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const UI := preload("res://scripts/ui/UI.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	_play()
	print("GOLDEN_PATH failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


func _play() -> void:
	_check(main.screen == "title", "the game opens on the title")
	main.act("quick")
	var c: Career = main.career
	# S327: the golden path plays one known career - Career.seed is randi() per new career, so the injury dice could hurt
	# her in the debut camp on some runs (the gate went red once). A fixed seed keeps the path the same every run.
	c.seed = 1
	_check(main.screen == "career" and c != null, "quick start opens the career")
	_check(c.members == 30 and c.cash == 14600, "quick start: 30 members, $14,600 (3 months of costs, S324) - got %d" % c.cash)
	_check(Needs.go_state(c, false)["t"] == "NEEDS YOU (1)", "CONTINUE reads NEEDS YOU while the walk-in waits")

	main.act("go_btn")
	_check(main.modal.get("type", "") == "interview", "pressing NEEDS YOU opens the interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	_press(_modal_button("Sign"), "three cards picked: the Sign button is live")
	_check(c.fighters.size() == 1 and c.applicant.is_empty(), "Lucy signed")
	_check(main.modal.is_empty(), "the interview closed")
	# S352: Lucy walks in 3-1, so her signing goal is her next bout, never a 'debut'.
	_check(str(c.fighter()["goal"].get("id", "")) == "next_bout_inside_a_month", "her signing goal is her next bout inside a month")
	_check(Needs.go_state(c, false)["t"] == "CONTINUE", "with nobody waiting, the button reads CONTINUE")

	main.act("go", "gym:1")
	_check(main.route["area"] == "gym" and int(main.route["tab"]) == 1, "GYM > Staff is open")
	main.act("hire", "reid")
	_check(str(c.coach.get("name", "")) == "Luke Reid" and c.cash == 13600, "Luke Reid hired, $1,000 paid (14,600 - 1,000)")
	var debut := str(Sim.goal_read(c, c.fighter())["status"])
	_check(["ON TRACK", "AT RISK"].has(debut), "with a coach her debut goal is within reach: %s" % debut)
	main.act("back")
	_check(main.route["area"] == "home", "Back returns to HOME")

	_week_two(c)
	_week_three(c)
	_week_four(main.career)
	_draw_everything()
	_missed_weight()
	main.act("settings")
	_check(main.modal.get("type", "") == "info", "Settings opens")
	main.act("close")
	main.act("title")
	_check(main.screen == "title" and main.career == null, "Quit to title returns to the title")


func _shell_button(name: String) -> Button:
	return main._shell.find_child(name, true, false) as Button


func _modal_button(name: String) -> Button:
	var m: Node = main.modal_node()
	return null if m == null else m.find_child(name, true, false) as Button


## S308: fights the open round from the shout bar: the coach's read, once Say nothing; checks the clock moved on.
func _shout_round() -> void:
	var i := 0
	while not LiveRound.live(main.modal).is_empty() and i < 6:
		var pv := LiveRound.preview(c_fighter(), main.modal)
		_press(_modal_button("SayNothing" if i == 2 else "Shout_" + str(pv["coach"])), "shout at %d:%02d" % [int(pv["at"]) / 60, int(pv["at"]) % 60])
		i += 1
	_check(LiveRound.live(main.modal).is_empty(), "the round's five shouts fought it to the bell")


func c_fighter() -> Dictionary:
	return main.career.fighter_by_id(str(main.modal["fid"]))


func _press(b: Button, label: String) -> void:
	_check(b != null and not b.disabled, label)
	if b != null and not b.disabled:
		b.emit_signal("pressed")


func _draw_everything() -> void:
	for a in Data.AREAS:
		for i in maxi(1, (a["tabs"] as Array).size()):
			main.act("go", "%s:%d" % [a["id"], i])
	main.act("fighter", "lucy")
	for i in 7:   # S354 + Training
		main.act("ftab", str(i))
	main.act("go", "home:0")


## Runs CONTINUE, opening and closing each week review on the way, until `until` is true.
func _run_until(until: Callable, label: String) -> bool:
	for i in 12:
		if until.call():
			return true
		main.run_to_stop()
		if main.career.review_pending and not until.call():
			main.act("review")
			main.act("close")
	_check(until.call(), label)
	return until.call()


func _week_two(c: Career) -> void:
	var days: int = main.run_to_stop()
	_check(days == 7 and c.review_pending, "week 1: CONTINUE ran 7 days and stopped at the review")
	main.act("review")
	var review: Node = main.modal_node()
	_check(review != null and main.modal.get("type", "") == "review", "week 1: the review opened (%d stats crossed a point)" % (
		0 if review == null else int(review.crossed)))
	# S352: the review shows the week's running costs (Home's figure) beside the cash paid out, and names what was paid.
	var money: Dictionary = c.last_report["money"]
	_check(int(money.get("costs", 0)) > 0 and (money.get("paid", []) as Array).has("Signing fee: Luke Reid"),
		"week 1 review: running costs %d beside paid out %d (%s)" % [int(money.get("costs", 0)), int(money["out"]), money.get("paid", [])])
	main.act("close")

	# Offers: Tuesday of week 2.
	main.run_to_stop()
	_check(c.day == 8 and c.fighter()["offers"].size() == 2, "day 8: two bout offers arrived (day %d, %d offers)" % [c.day, c.fighter()["offers"].size()])
	_check(Needs.go_state(c, false)["t"] == "NEEDS YOU (1)", "the legal offer blocks time; the unsafe one does not")
	main.act("go_btn")
	_check(str(main.route.get("bout", "")) == "lucy:o8", "NEEDS YOU opens the bout page")
	main.act("openBout", "lucy:m8")
	var unsafe := _shell_button("Accept")
	_check(unsafe != null and unsafe.disabled, "the mismatch (4 bouts vs 16) cannot be accepted")
	_check(not Bouts.accept(c, "lucy:m8"), "the rules refuse it too")
	main.act("openBout", "lucy:o8")
	_press(_shell_button("Accept"), "the even match's Accept is live")
	_check(not c.fighter()["bout"].is_empty() and bool(c.fighter()["booked_fight"]), "bout booked: %s on %s" % [
		c.fighter()["bout"].get("opp", {}).get("name", "?"), Clock.fmt(int(c.fighter()["bout"].get("day", 0)))])
	var lead := int(c.fighter()["bout"].get("day", 0)) - c.day
	_check(lead >= 14 and lead <= 32 and posmod(int(c.fighter()["bout"].get("day", 0)), 7) == 5, "fight night is a Saturday 2-4 weeks out (%d days)" % lead)
	_check(Needs.flags(c).any(func(x): return x["t"] == "SET CAMP"), "SET CAMP waits on the top bar")
	_check(str(Sim.goal_read(c, c.fighter())["row"]).contains("booked fight 1"), "the debut goal counts the booking: %s" % Sim.goal_read(c, c.fighter())["row"])

	# The camp.
	var cash_before := c.cash
	main.act("camp")
	_check(main.modal.get("type", "") == "camp", "SET CAMP opens the camp")
	_press(_modal_button("StartCamp"), "Start the camp is live")
	_check(not c.fighter()["camp"].is_empty() and c.cash == cash_before - 450, "standard camp + film: $450 paid")
	# S341 scouting in stages: the camp's first tape session opens her best weapon; the rest come a session at a time.
	var opp_file: Dictionary = c.fighter()["bout"]["opp"]
	_check(OppFile.found(opp_file) == ["weapon"] and int(c.fighter()["bout"]["film"]) == 2,
		"tape study day 1: her best weapon found, film depth %d of 3" % int(c.fighter()["bout"]["film"]))
	_draw_everything()

	# To the weigh-in.
	if not _run_until(func(): return Bouts.weigh_in_today(c, c.fighter()), "CONTINUE reaches the weigh-in"):
		return
	var opp_seen: Array = opp_file.get("notes_seen", [])
	_check(OppFile.hidden(opp_file).is_empty() and int(c.fighter()["bout"]["film"]) == 3 and opp_seen.all(func(x): return str(x).begins_with("habit:")),
		"by the weigh-in the tape has opened her whole file (film depth 3); the coach's notes hold her habits (%d), never her character" % opp_seen.size())
	_check(c.day == int(c.fighter()["bout"]["day"]) - 1, "the weigh-in is the day before")
	_check(str(Needs.go_state(c, false)["t"]).begins_with("NEEDS YOU"), "the weigh-in blocks time")
	main.act("go_btn")
	_check(main.modal.get("type", "") == "weighin", "NEEDS YOU opens the weigh-in")
	var weight := float(c.fighter()["weight"])
	_press(_modal_button("Scale"), "Step on the scale")
	_check(bool(c.fighter()["bout"].get("made", false)), "the camp cut her to the limit: %.2f kg for %.1f" % [weight, c.fighter()["limit"]])
	if c.fighter()["bout"].is_empty():
		return

	# Fight night.
	main.run_to_stop()
	_check(Bouts.fight_day(c, c.fighter()), "the next stop is fight night")
	_check(Needs.go_state(c, false)["t"] == "GO TO FIGHT NIGHT", "the button reads GO TO FIGHT NIGHT")
	var cash_fight := c.cash
	var members_fight := c.members
	main.act("go_btn")
	_check(main.modal.get("type", "") == "fight" and main.modal["step"] == "tape", "fight night opens on the tale of the tape")
	_press(_modal_button("Begin"), "Begin fight")
	_check(main.modal_node() != null and main.modal_node().find_child("Shout_*", true, false) != null, "S308: round 1 opens on the shout bar")
	_shout_round()
	_check(int(main.modal.get("round", 0)) == 1 and (main.modal["rounds"][0]["lines"] as Array).size() >= 3, "round 1 told in words, exchanges counted")
	_press(_modal_button("Corner_long"), "corner call after round 1")
	_shout_round()
	_press(_modal_button("Corner_body"), "corner call after round 2")
	_shout_round()
	_check(int(main.modal["round"]) == 3 and main.modal["rounds"][2]["corner"] == "body", "round 3 carries the call")
	var told: Array = []
	for r in main.modal["rounds"]:
		told.append_array(r["lines"])
	_check(told.size() >= 9 and told.all(func(l): return not str(l).contains("{")), "three rounds in words, every name filled: %s" % str(told[4]))
	_check(FileAccess.file_exists("res://assets/data/fight_words.json"), "the fight-words bank is in the game")
	_press(_modal_button("Scorecards"), "To the scorecards")
	_check(main.modal.get("step", "") == "result" and (main.modal.get("cards", []) as Array).size() == 3, "the result shows three scorecards")
	var win := bool(main.modal.get("win", false))
	print("  bout: %s, rounds %s, why %s" % ["WIN" if win else "LOSS",
		str((main.modal["rounds"] as Array).map(func(r): return r["won"])), str(main.modal.get("why", []))])
	var f := c.fighter()
	# S327 update 29 part B: the body report on the result page; its button sets next week's focus.
	var rep: Dictionary = main.modal.get("body_report", {})
	_check(str(rep.get("line", "")).begins_with(str(f["first"])) and f.get("last_body_report", {}) == rep, "the body report: %s" % str(rep.get("line", "")))
	if str(rep.get("focus", "")) != "":
		_press(_modal_button("BodyFocus"), "Train it next week")
		_check(str(f["focus"]) == str(rep["focus"]) and main.modal.get("step", "") == "result", "the body report's button sets her focus: %s" % str(f["focus"]))
	_check(int(f["w"]) + int(f["l"]) == 5, "her record moved to %d-%d" % [f["w"], f["l"]])
	_check(c.cash == cash_fight + 450, "the club's $450 ticket cut is in")
	_check(c.members == members_fight + (8 if win else 0), "members after the news: %d" % c.members)
	_check(c.results.size() == 1 and (f["history"] as Array).size() == 1, "the result and her finished goal are on the books: %s" % str(f["history"]))
	# Fight model step 1: the booking, the result and the goal moved her stored morale; the reason names the last one.
	_check(float(f["morale"]) != 60.0 and (str(f["mood_reason"]).ends_with("met") or str(f["mood_reason"]).ends_with("missed")),
		"her morale moved: %.1f (%s)" % [float(f["morale"]), f["mood_reason"]])
	_press(_modal_button("BackHome"), "Back home")
	_check(c.fighter()["bout"].is_empty() and Needs.flags(c).any(func(x): return x["t"] == "NEW GOAL"), "NEW GOAL waits on the top bar")

	# The office.
	main.act("goaltalk")
	var set_b := _modal_button("SetGoal")
	_check(set_b != null and set_b.disabled, "Set goal waits for a pick")
	_press(_modal_button("Goal_southpaw_answer"), "pick Southpaw answer")
	_press(_modal_button("SetGoal"), "Set goal")
	_check(str(f["goal"].get("title", "")) == "Southpaw answer" and not c.fighter()["goal_talk"], "her next goal is set")
	_run_until(func(): return not c.fighter()["offers"].is_empty() and str(c.fighter()["offers"][0]["id"]) != "lucy:o8", "after the bout the next offer arrives on its own")
	if not c.fighter()["offers"].is_empty():
		_check(str(c.fighter()["offers"][0]["opp"]["name"]) == "Priya Nair", "the next opponent is the next on the list: %s" % c.fighter()["offers"][0]["opp"]["name"])


## A second career: she is booked but never cut, so she misses weight and the bout is off.
func _missed_weight() -> void:
	var c := Career.quick_start()
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	Sim.hire(c, "reid")
	while c.fighter()["offers"].is_empty():
		Sim.step_day(c)
	_check(Bouts.accept(c, str(c.fighter()["offers"][0]["id"])), "second career: bout accepted, no camp, holding weight")
	while not Bouts.weigh_in_today(c, c.fighter()):
		Sim.step_day(c)
	var cash := c.cash
	_check(not Bouts.weigh(c, c.fighter()), "without a cut she misses weight (%.1f for %.1f)" % [c.fighter()["weight"], c.fighter()["limit"]])
	_check(c.fighter()["bout"].is_empty() and c.cash == cash - 300, "the bout is off and the club pays $300 for the empty slot")
	_check(str(c.news[0]["t"]).contains("missed weight"), "the news says so")


## Answers whatever stops the clock the way a steady player would: reviews closed, offers declined, office talks settled.
func _settle_stop(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		for o in f["offers"]:
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				main.act("declineOffer", str(o["id"]))
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")
	for p in c.prospects:
		if str(p["state"]) == "invited" and int(p["trial_day"]) <= c.day:
			main.act("trial", p["id"])
			main.act("passprospect")
	if not c.pro_offer.is_empty():
		main.act("prooffer")
		main.act("declinepro")


func _week_three(c: Career) -> void:
	main.save_path = "user://golden_path.save"
	# Sponsors: Ironclad from the start; Bow Road after her first win.
	main.act("go", "money:3")
	_press(_shell_button("Deal_ironclad"), "MONEY > Deals: sign Ironclad")
	var bow: Dictionary = c.deals.filter(func(d): return d["id"] == "bowroad")[0]
	var won_first := int(c.fighter()["w"]) >= 4
	_check(str(bow["state"]) == ("offer" if won_first else "locked"), "Bow Road is on the table only after a win (%s)" % bow["state"])
	if str(bow["state"]) == "offer":
		_press(_shell_button("Deal_bowroad"), "sign Bow Road")
	var sponsors := 250 + (150 if won_first else 0)
	_check(int(Sim.weekly_income(c)["sponsors"]) == sponsors, "sponsors pay %d a week" % sponsors)
	# The worn bags.
	main.act("go", "gym:3")
	var rep := c.reputation
	var cash := c.cash
	_press(_shell_button("Repair_bags"), "GYM > Facilities: repair the worn bags")
	_check(c.cash == cash - 120 and c.reputation == rep + 2, "repair: $120 paid, reputation +2")
	main.act("go", "money:2")
	_check(str(c.ledger[0]["t"]).begins_with("Repair") and int(c.ledger[0]["amount"]) == -120, "the repair is on the bills ledger")
	_check(c.ledger.any(func(e): return str(e["t"]).begins_with("Ticket cut")), "the first bout's ticket cut is on the ledger")
	main.act("go", "money:0")
	_check(_shell_button("Deal_ironclad") == null and main._shell.find_child("CashChart", true, false) != null, "MONEY > Overview draws the cash chart")

	# The second offer: Priya Nair. Accept, set a camp, save mid-camp.
	var priya := ""
	for o in c.fighter()["offers"]:
		if not bool(o["mismatch"]) and not bool(o["answered"]):
			priya = str(o["id"])
	_check(priya != "", "the second offer is open")
	if priya == "":
		return
	main.act("openBout", priya)
	_press(_shell_button("Accept"), "accept Priya Nair")
	main.act("camp")
	main.act("cfocus", "technique")
	main.act("cproto", "3")
	_press(_modal_button("StartCamp"), "a hard technique camp")
	_check(int(c.fighter()["camp"].get("protocol", 0)) == 3 and str(c.fighter()["camp"].get("focus", "")) == "technique", "the camp is hard, on technique")
	main.run_to_stop()
	_settle_stop(c)
	var saved_day := c.day
	var saved_cash := c.cash
	main.act("save")
	_check(SaveGame.exists(main.save_path), "Gear > Save wrote the slot")
	main.run_to_stop()
	_settle_stop(c)
	_check(c.day > saved_day, "time moved on after the save (day %d)" % c.day)
	main.act("title")
	var resume: Button = main._screen_holder.find_child("Resume", true, false) as Button
	_check(resume != null and not resume.disabled, "the title offers Resume career")
	if resume != null:
		resume.emit_signal("pressed")
	c = main.career
	_check(main.screen == "career" and c.day == saved_day and c.cash == saved_cash and not c.fighter()["camp"].is_empty(),
		"Resume career is back on day %d, mid-camp, cash %d" % [c.day, c.cash])

	# The second bout, simmed to the result.
	if not _run_until(func(): return Bouts.weigh_in_today(c, c.fighter()), "CONTINUE reaches the second weigh-in"):
		return
	main.act("go_btn")
	_press(_modal_button("Scale"), "the second weigh-in")
	_check(bool(c.fighter()["bout"].get("made", false)), "she made weight again")
	main.run_to_stop()
	_check(Bouts.fight_day(c, c.fighter()), "the second fight night")
	main.act("go_btn")
	main.act("fightstep", "sim")
	_check(main.modal.get("step", "") == "result", "Sim to result plays all three rounds")
	var en: Array = (main.modal["rounds"] as Array).map(func(r): return r.get("energy", {}))
	_check(en.size() >= 2 and float(en[0].get("a", 0.0)) == 100.0 and float(en[-1].get("a", 100.0)) < 100.0
		and float(en[-1].get("a_end", 100.0)) < float(en[-1].get("a", 0.0)),
		"S302 energy: she starts full, each round spends, the break gives some back (%s)" % JSON.stringify(en.map(func(e): return [snappedf(float(e.get("a", 0)), 0.1), snappedf(float(e.get("a_end", 0)), 0.1)])))
	print("  bout 2: %s vs Priya Nair, %s" % ["WIN" if bool(main.modal.get("win", false)) else "LOSS", ", ".join(main.modal.get("cards", []))])
	main.act("afterfight")
	_check(c.results.size() == 2 and int(c.fighter()["w"]) + int(c.fighter()["l"]) == 6, "two bouts on her record: %d-%d" % [c.fighter()["w"], c.fighter()["l"]])
	var fc: Dictionary = c.fighter().get("combos", {})
	_check(not fc.is_empty() and fc.values().any(func(v): return float(v) > 0.0) and str(c.fighter().get("combo_learning", "")) != "",
		"S302 combos: weeks of pad time built her combos (%s), drilling %s" % [JSON.stringify(fc), c.fighter().get("combo_learning", "")])
	_check((c.fighter().get("notes_seen", []) as Array).size() >= 2, "S302: two fights taught the coach two things about her (%d)" % (c.fighter().get("notes_seen", []) as Array).size())
	var priya_r := c.rival("Priya Nair")
	_check(int(priya_r["w"]) + int(priya_r["l"]) >= 7, "Priya's own record took the result: %d-%d" % [priya_r["w"], priya_r["l"]])

	# Twelve weeks hold together.
	for i in 30:
		if c.day >= 84:
			break
		main.run_to_stop()
		_settle_stop(c)
	_check(c.day >= 84, "twelve weeks played (day %d)" % c.day)
	var unfilled := c.news.filter(func(x): return str(x["t"]).contains("{"))
	_check(unfilled.is_empty(), "every news line has its names filled (%d of %d not: %s)" % [unfilled.size(), c.news.size(), str(unfilled.slice(0, 1))])
	_check(c.unread < 40, "Mail counts mail, not every rival result (%d unread)" % c.unread)
	_check(c.cash_history.size() >= 13, "MONEY has a cash bar for every week (%d)" % c.cash_history.size())
	_check(c.cash > 8000 and not c.closed, "the gym's money holds over twelve weeks (S324: the real bills bite; was > 15,000 on a $25,000 start): %s" % GameMoney_text(c.cash))
	_check(c.ledger.filter(func(e): return str(e["t"]).begins_with("Month-end bill")).size() == 3, "three month-end bills paid (days 28, 56, 84)")
	var f := c.fighter()
	_check(int(f["rank"]) == Region.our_rank(c, f) and (int(f["rank"]) > 0) == (int(f["w"]) >= Region.RANK_MIN_WINS),
		"rankings: %s, %d-%d, rank %d" % [f["name"], f["w"], f["l"], int(f["rank"])])
	main.act("go", "world:1")
	_check(main._shell.find_child("Rankings_wlw", true, false) != null, "WORLD > Rankings draws")
	main.act("go", "world:3")
	var box: LineEdit = main._shell.find_child("SearchBox", true, false) as LineEdit
	if box != null:
		box.text_changed.emit("priya")
	var hits: Node = main._shell.find_child("Hits", true, false)
	_check(hits != null and hits.get_child_count() == 1, "WORLD > Search finds Priya")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(main.save_path))


func GameMoney_text(n: int) -> String:
	return "$%d" % n


## A steady player for everything but trials and pro offers: reviews closed, offers declined, office talks settled,
## weigh-ins stepped, fight nights simmed. Runs CONTINUE until until() is true.
func _play_until(until: Callable, label: String, max_stops: int = 40) -> bool:
	var c: Career = main.career
	for i in max_stops:
		if until.call():
			return true
		if c.review_pending:
			main.act("review")
			main.act("close")
		for f in c.fighters:
			for o in f["offers"]:
				if not bool(o["answered"]) and not bool(o["mismatch"]):
					main.act("declineOffer", str(o["id"]))
			if Bouts.weigh_in_today(c, f):
				main.act("weighin", f["id"])
				main.act("doWeigh")
			if Bouts.fight_day(c, f):
				main.act("fightnight")
				main.act("fightstep", "sim")
				main.act("afterfight")
			if bool(f["goal_talk"]):
				main.act("goaltalk", f["id"])
				main.act("pickgoal", "five_round_engine")
				main.act("setgoal")
		if until.call():
			return true
		main.run_to_stop()
	_check(until.call(), label)
	return until.call()


func _week_four(c: Career) -> void:
	var lucy := c.fighter()
	_check(BoutRules.weapons(lucy["moves"]).size() >= 5, "twelve weeks of drilling: Lucy has %d weapons (%s)" % [
		BoutRules.weapons(lucy["moves"]).size(), ", ".join(BoutRules.weapons(lucy["moves"]))])
	_check(c.news.any(func(x): return str(x["t"]).contains("new weapon")), "a new weapon made the news")
	# Scouting: Kira Mensah, featherweight.
	main.act("go", "fighters:3")
	_press(_shell_button("Invite_kira"), "FIGHTERS > Scouting: invite Kira to a trial")
	var kira_p: Dictionary = c.prospects.filter(func(p): return p["id"] == "kira")[0]
	_check(str(kira_p["state"]) == "invited" and posmod(int(kira_p["trial_day"]), 7) == 0, "her trial is on a Monday (%s)" % Clock.fmt(int(kira_p["trial_day"])))
	_play_until(func(): return int(kira_p["trial_day"]) <= c.day, "CONTINUE reaches the trial")
	_check(str(Needs.go_state(c, false)["s"]).begins_with("Trial today"), "the trial stops time: %s" % Needs.go_state(c, false)["s"])
	main.act("go_btn")
	_check(main.modal.get("type", "") == "trial", "NEEDS YOU opens the trial")
	for card in ["Jab and move", "Body work", "Pad rounds"]:
		main.act("trialcard", card)
	_press(_modal_button("SignProspect"), "sign Kira")
	_check(c.fighters.size() == 2 and str(kira_p["state"]) == "signed", "two fighters on the roster")
	var kira := c.fighter_by_id("kira")
	_check(str(kira["div"]) == "wfw" and float(kira["limit"]) == 57.0 and str(kira["learning"]) == "Uppercut",
		"Kira: featherweight, 57 kg, learning the uppercut")
	_check(int(Sim.weekly_costs(c)["fighters"]) == 500, "two club stipends: $500 a week")
	main.act("go", "fighters:0")
	var roster: Node = main._shell.find_child("Roster", true, false)
	# S330: the roster is a tile per fighter (rings: weight, condition, goal, next bout).
	_check(roster != null and roster.find_child("Tile_lucy", true, false) != null and roster.find_child("Tile_kira", true, false) != null,
		"the roster shows both as tiles")
	var mood_chip: Node = roster.find_child("Mood_kira", true, false) if roster != null else null
	var mood: Label = mood_chip.get_child(0) as Label if mood_chip != null else null
	_check(mood != null and mood.text in ["FIRED UP", "STEADY", "FLAT", "LOW"], "her mood word shows: %s" % (mood.text if mood else "none"))
	# Her new weapon: two weeks of pads with a coach.
	var up_start := float(kira["moves"]["Uppercut"])
	var weeks_start := c.cash_history.size()
	_play_until(func(): return c.cash_history.size() >= weeks_start + 2, "two weeks pass")
	_check(float(kira["moves"]["Uppercut"]) >= BoutRules.WEAPON_MASTERY, "two weeks of pads: Kira's uppercut %.0f -> %.0f, a weapon" % [up_start, float(kira["moves"]["Uppercut"])])
	_check(str(kira["learning"]) != "Uppercut", "she moves on to the next move: %s" % kira["learning"])
	# Her own bout: the featherweights.
	_play_until(func(): return not (kira["offers"] as Array).is_empty() and not bool(kira["offers"][0]["answered"]), "Kira's first offers arrive")
	if (kira["offers"] as Array).is_empty():
		return
	var kid := str(kira["offers"][0]["id"])
	_check(kid.begins_with("kira:") and str(kira["offers"][0]["opp"]["name"]) == "Holly Marsh", "her offer: %s vs Holly Marsh" % kid)
	_check(bool(kira["offers"][1]["mismatch"]), "and an unsafe one (Bethany Cole, 18 bouts)")
	main.act("accept", kid)
	main.act("camp", "kira")
	_press(_modal_button("StartCamp"), "Kira's camp")
	var holly_before := int(c.rival("Holly Marsh")["w"]) + int(c.rival("Holly Marsh")["l"])
	_play_until(func(): return (kira["bout"] as Dictionary).is_empty() and c.results.any(func(r): return r.get("fid", "") == "kira"), "Kira's bout is fought")
	_check(int(kira["w"]) + int(kira["l"]) == 2, "Kira's record moved: %d-%d" % [kira["w"], kira["l"]])
	_check(int(c.rival("Holly Marsh")["w"]) + int(c.rival("Holly Marsh")["l"]) == holly_before + 1, "Holly's record took the result")
	main.act("go", "world:1")
	_check(main._shell.find_child("Rankings_wfw", true, false) != null, "WORLD > Rankings shows the featherweights too")

	# Turning pro. The test puts Lucy at the line (9 wins) instead of playing 4 more bouts.
	lucy["w"] = 9
	_play_until(func(): return not c.pro_offer.is_empty(), "a promoter calls at the line")
	_check(str(c.pro_offer.get("fid", "")) == "lucy" and int(c.pro_offer.get("purse", 0)) == 1500, "the offer: %s, $1,500 debut" % c.pro_offer.get("promoter", "?"))
	_check(str(Needs.go_state(c, false)["s"]).contains("promoter"), "the offer stops time")
	main.act("go_btn")
	_check(main.modal.get("type", "") == "prooffer", "NEEDS YOU opens the offer")
	var stipends := int(Sim.weekly_costs(c)["fighters"])
	# S329 update 31: the offer shows the debut's tickets and what the gym pays now; signing pays it.
	var offer_node: Node = main.modal_node()
	_check(offer_node != null and offer_node.find_child("Tickets", true, false) != null and offer_node.find_child("PaysNow", true, false) != null,
		"the offer shows her debut tickets and what the gym pays now")
	var sheet := Roster.debut_sheet(c, lucy, 1.0)
	var before_sign := c.cash
	_press(_modal_button("TurnPro"), "Turn Lucy pro")
	_check(c.cash == before_sign - int(sheet["costs"]) and int(sheet["costs"]) >= ProDebut.LICENCE + ProDebut.MEDICALS,
		"signing pays her licence and brain scans: %s" % UI.money(int(sheet["costs"])))
	_check(bool(lucy.get("licensed", false)) and Roster.trainer_licensed(c), "she and her trainer hold BBBofC licences")
	_check(bool(lucy.get("pro", false)) and int(Sim.weekly_costs(c)["fighters"]) == stipends - 250, "she is a pro: her stipend stops")
	_check(int(lucy["bout"].get("rounds", 0)) == 4 and bool(lucy["bout"].get("pro", false)), "her debut is booked: 4 rounds, %s" % Clock.fmt(int(lucy["bout"].get("day", 0))))
	_check(Region.our_rank(c, lucy) == 0, "a pro leaves the amateur rankings")
	var cash := c.cash
	main.act("camp", "lucy")
	_press(_modal_button("StartCamp"), "her debut camp")
	_play_until(func(): return Bouts.weigh_in_today(c, lucy), "her debut weigh-in comes")
	main.act("weighin", "lucy")
	main.act("doWeigh")
	_check(bool(lucy["bout"].get("made", false)), "she made weight for her debut")
	_play_until(func(): return Bouts.fight_day(c, lucy), "her debut night comes")
	main.act("go", "home:0")
	main.act("go_btn")
	_check(main.modal.get("type", "") == "fight" and int(main.modal.get("total", 0)) == 4, "fight night: four rounds")
	var debut_gym := int(ProDebut.night(ProDebut.tickets_sold(c.members, int(lucy["w"]), Roster.titles(lucy)), 1.0)["gym"])
	_press(_modal_button("Begin"), "Begin the debut")
	_shout_round()
	for k in ["long", "body", "calm"]:
		_press(_modal_button("Corner_" + k), "corner call: " + k)
		_shout_round()
	_check(int(main.modal.get("round", 0)) == 4, "four rounds played")
	_press(_modal_button("Scorecards"), "To the scorecards")
	print("  pro debut: %s, %s" % [main.modal.get("outcome", "?"), ", ".join(main.modal.get("cards", []))])
	_check(int(lucy.get("pro_w", 0)) + int(lucy.get("pro_l", 0)) + int(lucy.get("pro_d", 0)) == 1 and int(lucy["w"]) == 9,
		"a pro record of one bout; the amateur record stays 9-%d" % lucy["l"])
	_check(c.ledger.any(func(e): return str(e["t"]).begins_with("Debut tickets") and int(e["amount"]) == debut_gym),
		"the debut pays from her tickets: the gym's 25%% of her share, %s" % UI.money(debut_gym))
	_check(not c.ledger.any(func(e): return str(e["t"]).begins_with("Purse share")), "no flat purse on the debut")
	_press(_modal_button("BackHome"), "Back home")
	_check(c.news.any(func(x): return str(x["t"]).contains("turns pro")), "the news: she turns pro")
	_check(c.cash > cash - 5000, "the money holds through week 4 (%d)" % c.cash)
