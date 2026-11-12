extends SceneTree
## ROSTERROW1: one fighter's row on the Fighters page - values and words, no nodes.
## Each cell asserts against the function the fighter page or Home already calls
## for the same fighter, never against a typed number.

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")
const CoachCheck := preload("res://scripts/rules/CoachCheck.gd")
const NextStep := preload("res://scripts/rules/NextStep.gd")
const FIGHTER_PAGE := preload("res://scripts/ui/areas/FighterPage.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

var failures := 0
var main: Node


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)


func _initialize() -> void:
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	FirstWeek.ana_joins(c)
	await process_frame

	_test_quick_start_row(c)
	_test_tired_fighter(c)
	_test_overweight_fighter(c)
	_test_no_gi_athlete(c)
	_test_best_of(c)
	_test_offer_and_coach(c)
	_test_goal_words(c)
	_test_need_owner(c)
	_test_no_gi_coach_and_open(c)

	print("ROSTER_ROW failures=%d" % failures)
	print("PASS roster_row_test" if failures == 0 else "FAIL roster_row_test")
	quit(failures)


## Test the row for the first signed fighter (Lucy) on a quick-start career.
func _test_quick_start_row(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var fid: String = str(f["id"])
	var r: Dictionary = RosterRow.row(c, fid)
	_check(not r.is_empty(), "row returns a non-empty dict for the first fighter")

	# FIGHTER column: name matches
	_check(str(r["fighter"]["name"]) == str(f["name"]), "fighter name matches f['name']")
	_check(int(r["fighter"]["age"]) == int(f.get("age", 0)), "fighter age matches f['age']")
	_check(str(r["fighter"]["wc"]) == str(f.get("wc", "")), "fighter wc matches f['wc']")

	# Record matches
	var w: int = int(f.get("w", 0))
	var l: int = int(f.get("l", 0))
	_check(int(r["fighter"]["record"]["w"]) == w, "record w matches f['w']")
	_check(int(r["fighter"]["record"]["l"]) == l, "record l matches f['l']")

	# Road matches NextStep
	var road: Dictionary = NextStep.road(FIGHTER_PAGE._road_input(c, f), c.day)
	var lit: int = int(road["lit"])
	_check(int(r["fighter"]["road_lit"]) == lit, "road_lit matches NextStep.road lit")

	# TIREDNESS column: matches FighterProfile.fatigue and WB_KIT.fatigue_word
	var fatigue_val: float = FighterProfile.fatigue(f)
	_check(absf(float(r["tiredness"]["value"]) - fatigue_val) < 0.01, "tiredness value matches FighterProfile.fatigue")
	var word_arr: Array = WB_KIT.fatigue_word(fatigue_val, false)
	var expected_word: String = str(word_arr[0]).to_lower().capitalize()
	_check(str(r["tiredness"]["word"]) == expected_word, "tiredness word matches WB_KIT.fatigue_word")

	# MOOD column: matches FighterProfile.mood
	var morale: float = float(f.get("morale", FighterProfile.MORALE_START))
	var expected_mood: String = FighterProfile.mood(morale)
	_check(str(r["mood"]["word"]) == expected_mood, "mood word matches FighterProfile.mood")
	_check(absf(float(r["mood"]["value"]) - morale) < 0.01, "mood value matches morale")

	# WEIGHT column: for a boxer with no bout, shows "On weight" or limit
	var weight_over: float = float(f["weight"]) - float(f["limit"])
	_check(absf(float(r["weight"]["over"]) - weight_over) < 0.01, "weight over matches weight - limit")

	# COACH column: matches CoachCheck
	var checks: Array = CoachCheck.rows(c, f)
	var has_bad: bool = false
	for ch in checks:
		if str(ch["state"]) == "bad":
			has_bad = true
			break
	# The coach column should reflect the checks
	_check(r["coach"].has("word"), "coach column has a word")

	# DO NEXT column: the first need whose arg is hers (her id or one of her offers) is the pin
	var offer_ids: Array = (f["offers"] as Array).map(func(o): return str(o["id"]))
	for n in Needs.needs(c):
		var arg: String = str(n.get("arg", ""))
		if arg == fid or offer_ids.has(arg):
			_check(str(r["do_next"]["act"]) == str(n.get("act", "")), "do_next act matches first need for this fighter")
			break
	# S440 round 2: Coach never says the bare "Drill the goal" (nothing a player can act on)
	_check(str(r["coach"]["word"]) != "Drill the goal", "quick start: Coach names the change (%s)" % r["coach"]["word"])


## Test a tired fighter (fatigue >= 80).
func _test_tired_fighter(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var fid: String = str(f["id"])
	# Set fatigue high
	f["week_fatigue"] = 85.0
	var r: Dictionary = RosterRow.row(c, fid)
	var fatigue_val: float = FighterProfile.fatigue(f)
	_check(absf(float(r["tiredness"]["value"]) - fatigue_val) < 0.01, "tired fighter: tiredness value matches fatigue")
	_check(str(r["tiredness"]["tone"]) == "bad", "tired fighter: tiredness tone is bad (overcooked)")
	# Clean up
	f["week_fatigue"] = 20.0


## Test an overweight fighter with no weigh-in coming.
func _test_overweight_fighter(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var fid: String = str(f["id"])
	var orig_weight: float = float(f["weight"])
	# Set weight over limit
	f["weight"] = float(f["limit"]) + 2.0
	var r: Dictionary = RosterRow.row(c, fid)
	# Without a bout, no weigh-in: should NOT show "kg over"
	_check(not bool(r["weight"]["weigh_in"]), "overweight no bout: weigh_in is false")
	_check(str(r["weight"]["tone"]) == "ok", "overweight no bout: tone is ok (no weigh-in warning)")
	# Clean up
	f["weight"] = orig_weight


## Test the no-gi athlete (Ana).
func _test_no_gi_athlete(c: Career) -> void:
	if c.grapplers.is_empty():
		_check(false, "no-gi athlete present")
		return
	var g: Dictionary = c.grapplers[0]
	var gid: String = str(g["id"])
	var r: Dictionary = RosterRow.row(c, gid)
	_check(not r.is_empty(), "row returns non-empty for no-gi athlete")
	_check(str(r["fighter"]["sport"]) == "bjj", "fighter sport is bjj for grappler")
	# Weight column should be muted for grappler
	_check(str(r["weight"]["tone"]) == "muted", "weight tone is muted for grappler")
	# Overall should have bjj groups
	_check(r["overall"].has("groups"), "overall has groups for grappler")
	var groups: Dictionary = r["overall"]["groups"]
	_check(groups.has("Guard") or groups.has("Pass") or groups.has("Sweep"), "grappler has bjj skill groups")
	# Tiredness still works
	var fatigue_val: float = FighterProfile.fatigue(g)
	_check(absf(float(r["tiredness"]["value"]) - fatigue_val) < 0.01, "grappler tiredness matches FighterProfile.fatigue")
	# Mood still works
	var morale: float = float(g.get("morale", FighterProfile.MORALE_START))
	var expected_mood: String = FighterProfile.mood(morale)
	_check(str(r["mood"]["word"]) == expected_mood, "grappler mood matches FighterProfile.mood")


## Test best_of returns a Dictionary (even if empty for now).
func _test_best_of(c: Career) -> void:
	var bo: Dictionary = RosterRow.best_of(c)
	_check(bo is Dictionary, "best_of returns a Dictionary")
	# S438 (Claude at collect): the painted groups come from Attrs, the ring is the measured level, the best is the real best.
	var A = load("res://scripts/rules/Attrs.gd")
	var f0: Dictionary = c.fighters[0]
	var r0: Dictionary = RosterRow.row(c, str(f0["id"]))
	var a0: Dictionary = A.of(f0)
	_check(absf(float(r0["overall"]["groups"]["Guard"]) - (float(a0["defence"]) + float(a0["durability"])) / 2.0) < 0.01, "Guard is the mean of Defence and Durability")
	_check(absf(float(r0["overall"]["groups"]["Cardio"]) - (float(a0["stamina"]) + float(a0["recovery"])) / 2.0) < 0.01, "Cardio is the mean of Stamina and Recovery")
	_check(int(r0["overall"]["ring"]) == int(round(A.weighted(a0))), "the ring is the measured level")
	_check(str(r0["fighter"]["stance"]) == str(f0.get("stance", "")), "stance is the fighter's own")
	if c.fighters.size() >= 2:
		var top := ""
		var best := -1.0
		for f in c.fighters:
			var v: float = (float(A.of(f)["speed"]) + float(A.of(f)["footwork"]) + float(A.of(f)["flexibility"])) / 3.0
			if v > best:
				best = v
				top = str(f["id"])
		_check(str(bo.get("Legs", "")) == top, "best_of names the roster's best Legs")
	else:
		_check(bo.is_empty(), "best_of is empty with one boxer")


## S440 (PAGES2B review): an offer's days are to the bout and the answer-by is its own value; Coach's tag is never a goal
## colour; the goal read rides on the coach column; no OPEN tag without an entered open; DO NEXT says what the press does.
func _test_offer_and_coach(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var fid: String = str(f["id"])
	var before: Array = f["offers"]
	var r0: Dictionary = RosterRow.row(c, fid)
	_check(str(r0["next_fight"]["tag"]) == "" and int(r0["next_fight"]["days"]) < 0, "no bout and no offer: no tag, no days")
	var g: Dictionary = Sim.goal_read(c, f)
	_check(r0["coach"]["goal"] == g, "the coach column carries the fighter page's goal read")
	_check(["", "FIX", "REST", "DRILL"].has(str(r0["coach"]["tag"])), "Coach's tag is FIX, REST or DRILL (%s)" % r0["coach"]["tag"])
	var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var o: Dictionary = Bouts._offer("%s:rowtest" % fid, opp, c.day + 19, c.day + 4, 4)
	o["mismatch"] = false
	f["offers"] = [o]
	var r: Dictionary = RosterRow.row(c, fid)
	_check(int(r["next_fight"]["days"]) == int(o["day"]) - c.day, "offer: the days are to the bout (%d)" % int(r["next_fight"]["days"]))
	_check(str(r["next_fight"]["answer_by"]) == Clock.fmt(int(o["expires"])), "offer: answer by the offer's own expiry day")
	_check(str(r["next_fight"]["tag"]) == "OFFER", "offer: tagged OFFER")
	var first: Dictionary = {}
	for n in Needs.needs(c):
		if str(n.get("arg", "")) == str(o["id"]):
			first = n
			break
	_check(not first.is_empty() and str(r["do_next"]["act"]) == str(first["act"]) and str(r["do_next"]["words"]) == "Answer offer",
		"offer: DO NEXT is the offer's need, in words (%s)" % r["do_next"].get("words", ""))
	f["offers"] = before
	var a: Dictionary = c.grapplers[0]
	var ra: Dictionary = RosterRow.row(c, str(a["id"]))
	_check(str(ra["next_fight"]["tag"]) == "" and str(ra["next_fight"]["word"]) == "No open entered", "no-gi, nothing entered: no OPEN tag")



## S440 round 2 (PAGES2B review): the goal check is worded from the goal read's own targets. A bout target with an open
## offer: Answer the offer; without one: Find a bout; a stat target: Drill <the game's word for that stat>.
func _test_goal_words(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var fid: String = str(f["id"])
	var keep_goal: Dictionary = (f["goal"] as Dictionary).duplicate(true)
	var keep_stats: Dictionary = (f["stats"] as Dictionary).duplicate(true)
	var keep_offers: Array = f["offers"]
	var keep_booked: bool = bool(f.get("booked_fight", false))
	_check(not keep_goal.is_empty(), "the quick-start boxer signs with a goal")
	var g0: Dictionary = Sim.goal_read(c, f)
	var stat_key := ""
	for t in g0.get("targets", []):
		if str(t["key"]) != "booked_fight":
			stat_key = str(t["key"])
			f["stats"][stat_key] = float(t["target"]) + 0.5   # every stat target met: only the bout is left
	# A: the bout is due tomorrow (the goal at risk) and an offer is open.
	f["goal"]["deadline_day"] = c.day + 1
	var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var o: Dictionary = Bouts._offer("%s:goaltest" % fid, opp, c.day + 14, c.day + 3, 4)
	o["mismatch"] = false
	f["offers"] = [o]
	var gr: Dictionary = Sim.goal_read(c, f)
	_check(str(gr["cls"]) != "green", "A: the goal is held back by the bout (%s)" % gr["status"])
	var r: Dictionary = RosterRow.row(c, fid)
	_check(str(r["coach"]["word"]) == "Answer the offer" and str(r["coach"]["tag"]) == "FIX" and str(r["coach"]["act"]) == "openBout"
		and str(r["coach"]["arg"]) == str(o["id"]), "A: bout target + open offer -> Answer the offer, FIX, opens it (%s)" % r["coach"]["word"])
	# B: no offer.
	f["offers"] = []
	r = RosterRow.row(c, fid)
	_check(str(r["coach"]["word"]) == "Find a bout" and str(r["coach"]["tag"]) == "FIX", "B: bout target, no offer -> Find a bout (%s)" % r["coach"]["word"])
	# C: booked, the stat far short with two days left.
	f["booked_fight"] = true
	f["goal"]["deadline_day"] = c.day + 2
	if stat_key != "":
		f["stats"][stat_key] = float(keep_stats.get(stat_key, 50.0)) - 6.0
		gr = Sim.goal_read(c, f)
		r = RosterRow.row(c, fid)
		var want := "Drill %s" % str(Data.LABEL.get(stat_key, stat_key)).to_lower()
		_check(str(gr["cls"]) != "green" and str(r["coach"]["word"]) == want and str(r["coach"]["tag"]) == "DRILL",
			"C: a stat target held back -> %s, DRILL (%s, %s)" % [want, r["coach"]["word"], gr["status"]])
	f["goal"] = keep_goal
	f["stats"] = keep_stats
	f["offers"] = keep_offers
	f["booked_fight"] = keep_booked


## S440 round 2: a need is a fighter's by its arg (her id or her offer), else her first name as a whole word; never a part
## of another name, never an empty name.
func _test_need_owner(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var a: Dictionary = c.grapplers[0]
	var keep_offers: Array = f["offers"]
	var keep_first: String = str(a.get("first", ""))
	var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var o: Dictionary = Bouts._offer("%s:owner" % f["id"], opp, c.day + 14, c.day + 3, 4)
	o["mismatch"] = false
	f["offers"] = [o]
	for first in [str(f["first"]).left(2), ""]:
		a["first"] = first
		var ra: Dictionary = RosterRow.row(c, str(a["id"]))
		_check(str(ra["do_next"].get("arg", "")) != str(o["id"]) and not bool(ra["needs_you"]),
			"another fighter's offer never lands on a row whose first name is '%s'" % first)
	a["first"] = keep_first
	# S440 round 3: the whole-word branch. A need with no fighter or offer in its arg (none, or a page) is hers only when her
	# first name stands in its words as a word: a longer name that holds hers ("Luc" in "Lucy's") never lands on her row.
	var longer: String = str(f["first"])
	var short_first: String = longer.left(longer.length() - 1)
	for arg in ["", "fights:0"]:
		var need: Dictionary = {"t": "Answer %s's bout offer" % longer, "arg": arg, "act": "go"}
		a["first"] = short_first
		_check(not RosterRow._need_for(c, a, need), "whole word (arg '%s'): '%s' is not '%s'" % [arg, short_first, longer])
		a["first"] = keep_first
		var own: Dictionary = {"t": "New goal: %s's office talk" % keep_first, "arg": arg, "act": "go"}
		_check(RosterRow._need_for(c, a, own), "whole word (arg '%s'): her own first name in the words is hers" % arg)
	a["first"] = keep_first
	var rf: Dictionary = RosterRow.row(c, str(f["id"]))
	_check(str(rf["do_next"].get("arg", "")) == str(o["id"]) and bool(rf["needs_you"]), "the offer lands on its own fighter's row")
	f["offers"] = keep_offers


## S440 round 2: the no-gi athlete's coach line is the move her classes drill, the ring the way to her next belt; with no
## open entered NEXT FIGHT names the next open she can enter, untagged.
func _test_no_gi_coach_and_open(c: Career) -> void:
	var a: Dictionary = c.grapplers[0]
	var r: Dictionary = RosterRow.row(c, str(a["id"]))
	var m: String = NoGi.drilling(a, c.day)
	_check(m != "" and str(r["coach"]["word"]) == "Drill the %s" % NoGi.move_name(m).to_lower() and str(r["coach"]["tag"]) == "DRILL",
		"no-gi: Coach drills the move her classes drill (%s)" % r["coach"]["word"])
	_check(str(r["coach"].get("sub", "")).begins_with(NoGi.move_name(m)), "no-gi: the second line names the move and its mastery")
	var rd: Dictionary = BeltRoad.readiness(a, a.get("bjj", {}), c.day)
	_check(absf(float(r["coach"]["goal"]["share"]) - float(rd["share"])) < 0.0001, "no-gi: the ring is the way to the next belt")
	var nx: Dictionary = NoGi.opens_after(c.day + 1, 1)[0]
	_check(int(r["next_fight"]["days"]) == int(nx["d"]) - c.day and str(r["next_fight"]["opp_name"]) == str(nx["name"])
		and str(r["next_fight"]["date"]) == Clock.fmt(int(nx["d"])), "no-gi, nothing entered: the next open she can enter (%s)" % nx["name"])
