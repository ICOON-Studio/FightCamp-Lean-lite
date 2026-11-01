extends SceneTree
## S341 scouting in stages (operator Q-S294-65 "Yes, build it in that order"): the opponent's file. Free at booking: her
## record, look and style word; hidden: best weapon, her habits, weakness - tape study opens one a session (weapon first,
## weakness last), each with its answer; the fight's film depth follows the share found.
## Population: Maria Ortega (pressure fighter, Data.OPPONENTS[0]) and Priya Nair (counter-puncher, [1]) - two different
## opponents; content coverage over every opponent, rival and national-field style in the data.

const Data := preload("res://scripts/state/Data.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const NationalField := preload("res://scripts/state/NationalField.gd")

var failures := 0


func _initialize() -> void:
	# 1. Maria's file: two tells free, four hidden in tape order.
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var ids: Array = OppFile.tells(maria).map(func(t): return str(t["id"]))
	_check(ids == ["look", "style", "weapon", "habit:fades_late", "habit:digs_body_when_hurt", "weakness"], "Maria's file: %s" % str(ids))
	_check(OppFile.known(maria, "look") and OppFile.known(maria, "style") and not OppFile.known(maria, "weapon"), "free at booking: record and style; her weapon is hidden")
	_check(OppFile.main_game(maria) == "press" and str(OppFile.tells(maria)[1]["counter"]) == "Plan an arrow for 'If she presses'", "her game: she presses -> plan a branch for it")
	_check(OppFile.film_depth(maria) == 1, "nothing found: film depth 1")
	var order: Array = []
	for i in 5:
		order.append(OppFile.tape(maria))
	_check(order == ["weapon", "habit:fades_late", "habit:digs_body_when_hurt", "weakness", ""], "tape opens weapon, habits, weakness, then nothing (%s)" % str(order))
	_check(OppFile.film_depth(maria) == 3 and OppFile.hidden(maria).is_empty(), "the whole file open: film depth 3")
	_check((maria.get("notes_seen", []) as Array) == ["habit:fades_late", "habit:digs_body_when_hurt"], "her habits reach the coach's notes (the ring and THE READ use them)")
	var weak: Dictionary = OppFile.tells(maria)[-1]
	_check(str(weak["call"]) == "let_go" and str(weak["when"]) == "tiring", "fades after round 2 -> 'Let your hands go' when she tires")
	var priya: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	var pw: Dictionary = OppFile.tells(priya)[2]
	_check(OppFile.main_game(priya) == "counter" and str(pw["call"]) == "lead" and str(pw["counter"]).begins_with("Never a lazy jab"),
		"Priya: a counter-puncher; the right hand over the jab -> feint, make her lead")
	var half := (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	OppFile.tape(half)
	_check(OppFile.film_depth(half) == 2, "one of her %d hidden tells found: depth 2" % (OppFile.hidden(half).size() + 1))

	# 2. Every threat and weakness in the data has an answer the coach can act on.
	var all: Array = []
	all.append_array(Data.OPPONENTS)
	all.append_array(Data.RIVALS)
	for st in NationalField.STYLES:
		all.append({"style": st[0], "threat": st[1], "weak": st[2], "w": 3, "l": 1})
	var missing: Array = []
	for o in all:
		for t in OppFile.tells(o):
			if str(t["how"]) == "tape" and str(t["counter"]) == "":
				missing.append("%s: %s" % [t["what"], t["value"]])
	_check(missing.is_empty(), "every weapon and weakness of %d fighters has an answer (missing: %s)" % [all.size(), str(missing)])

	# 3. In a real camp: one session on its first day, then one every 2 days; no tape, no file.
	var c := _career()
	var f: Dictionary = c.fighter()
	Bouts.start_camp(c, f, "conditioning", 2, true)
	var opp: Dictionary = f["bout"]["opp"]
	_check(OppFile.found(opp) == ["weapon"] and int(f["bout"]["film"]) == 2, "camp day 1: the tape shows her best weapon (film %d)" % int(f["bout"]["film"]))
	_check(c.news.any(func(n): return str(n).contains("Tape on Maria: best weapon")), "the news says what the tape found and the answer")
	var by_day: Array = []
	for d in 6:
		Sim.step_day(c)
		by_day.append(OppFile.found(opp).size())
	_check(by_day == [1, 2, 2, 3, 3, 4], "a tell every 2 days: %s" % str(by_day))
	_check(int(f["bout"]["film"]) == 3, "a week of tape: the whole file, film depth 3 (as film study gave before)")
	var c2 := _career()
	var f2: Dictionary = c2.fighter()
	Bouts.start_camp(c2, f2, "conditioning", 2, false)
	for d in 6:
		Sim.step_day(c2)
	_check(OppFile.found(f2["bout"]["opp"]).is_empty() and int(f2["bout"]["film"]) == 1, "no tape study: her file stays shut, film depth 1")

	# 4. S341 (operator: "the records should always keep all information available for the other opponents (history)"): what
	# is found stays on the career's record of her; a rematch offer starts with it; a bout opens her whole file; history lists it.
	var c3 := _career()
	var f3: Dictionary = c3.fighter()
	f3["bout"]["opp"] = c3.rival("Maria Ortega").duplicate(true)
	Bouts.start_camp(c3, f3, "conditioning", 2, true)
	Sim.step_day(c3)
	Sim.step_day(c3)
	var rec: Dictionary = c3.rival("Maria Ortega")
	_check((rec.get("file_found", []) as Array) == ["weapon", "habit:fades_late"], "the career's record of Maria keeps what the tape found (%s)" % str(rec.get("file_found", [])))
	var rematch: Dictionary = rec.duplicate(true)
	_check(OppFile.known(rematch, "weapon") and not OppFile.known(rematch, "weakness"), "a rematch offer starts with her weapon known, her weakness still hidden")
	f3["bout"]["day"] = c3.day
	f3["bout"]["weighed"] = true
	f3["bout"]["made"] = true
	var m3 := {"fid": f3["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c3, f3, m3, "sim")
	_check(OppFile.hidden(c3.rival("Maria Ortega")).is_empty(), "after the bout her whole file is open on her record")
	var hist := OppFile.history(c3.results, "Maria Ortega")
	_check(hist.size() == 1 and str(hist[0]["who"]) == "Lucy", "her history with us: %s" % str(hist))

	var top: Dictionary = (c3.rival("Maria Ortega").get("bouts", []) as Array)[0]
	_check(bool(top["ours"]) and str(top["vs"]) == "Lucy Jackson" and bool(top["win"]), "her record's newest bout is the one against our gym: %s" % str(top))

	# 5. S341 her past, bout by bout (RivalPast): every rival starts with W + L bouts that match her record.
	var c4 := Career.quick_start()
	var bad: Array = []
	for r in c4.rivals:
		var bouts: Array = r.get("bouts", [])
		var wins := bouts.filter(func(b): return bool(b["win"])).size()
		if bouts.size() != int(r["w"]) + int(r["l"]) or wins != int(r["w"]) or bouts.any(func(b): return int(b["d"]) >= c4.day or str(b["vs"]) == str(r["name"])):
			bad.append(r["name"])
	_check(bad.is_empty() and not c4.rivals.is_empty(), "%d rivals: each record's bouts add up to her W-L, all before day 0, never against herself (bad: %s)" % [c4.rivals.size(), str(bad)])
	print("  Maria's past: %s" % str((c4.rival("Maria Ortega")["bouts"] as Array).map(func(b): return "%s %s %s" % ["W" if b["win"] else "L", b["vs"], b["how"]])))

	print("OPP_FILE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _career() -> Career:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day + 21, "weighed": false, "made": false,
		"done": false, "film": 1}
	f["booked_fight"] = true
	return c


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
