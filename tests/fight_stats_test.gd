extends SceneTree
## S430 the fight in numbers (rules/FightStats.gd) and what the fight did to the boxer (rules/Aftermath.gd): the corner
## card's "fight so far" and the result page's stats and tiles read these.

const FS := preload("res://scripts/rules/FightStats.gd")
const AM := preload("res://scripts/rules/Aftermath.gd")

var _fails := 0


func _initialize() -> void:
	# Round 1: she wins 2 of 3 exchanges; round 2: she loses both. Every pair is [ours, theirs].
	var r1 := {"n": 1, "won": true, "energy": {"a_end": 82.0, "b_end": 74.0}, "exchanges": [
		_x("long", "press", true, [4, 2], [1, 0], "steady"), _x("long", "press", true, [3, 1], [0, 1], "push"),
		_x("body", "range", false, [1, 3], [1, 2], "push")]}
	var r2 := {"n": 2, "won": false, "counts": 1, "energy": {"a_end": 61.0, "b_end": 66.0}, "exchanges": [
		_x("long", "press", false, [2, 5], [0, 2], "save"), _x("hands", "loadup", false, [1, 4], [0, 1], "save")]}
	var st := FS.of([r1, r2])
	_check(st["landed"] == [11, 15] and st["body"] == [2, 6] and st["head"] == [9, 9], "totals: landed %s body %s head %s" % [st["landed"], st["body"], st["head"]])
	_check(st["xwon"] == [2, 3], "exchanges won 2 to 3 (%s)" % [st["xwon"]])
	_check((st["rounds"] as Array).size() == 2 and st["rounds"][0]["landed"] == [8, 6] and st["rounds"][1]["counts"] == 1,
		"each round keeps its own numbers")
	_check(st["tank"] == [61.0, 66.0], "the tank is the last bell's (%s)" % [st["tank"]])
	_check(str(st["calls"][0]["id"]) == "long" and int(st["calls"][0]["n"]) == 3 and int(st["calls"][0]["won"]) == 2,
		"calls: the most used first, with its wins (%s)" % [st["calls"]])
	_check(str(st["games"][0]["sit"]) == "press" and int(st["games"][0]["n"]) == 3, "her games: pressing came up most")
	_check(int(st["pace"]["push"]["n"]) == 2 and int(st["pace"]["save"]["won"]) == 0, "pace: two pushed exchanges, none won on save")
	var by := {}
	for r in FS.rows(st):
		by[str(r["label"])] = r
	_check(by.size() == 5 and str(by["Punches landed"]["a"]) == "11" and int(by["Punches landed"]["lead"]) == 1,
		"five paired bars; the opponent leads on punches landed")
	_check(float(by["To the body"]["fb"]) == 1.0 and int(by["To the head"]["lead"]) == -1, "the longer bar is full; a tie has no leader")
	_check(str(by["Tank at the last bell"]["a"]) == "61", "the tank row reads 61")
	_check(FS.call_word("long") != "" and FS.game_word("press") == "Pressing" and FS.answer("press") == FS.call_word("long"),
		"words: a call, a game, and the call that beats it")
	_check((FS.of([])["rounds"] as Array).is_empty() and FS.rows(FS.of([])).size() == 5, "no rounds: empty, never an error")
	# What a fight leaves in the legs.
	_check(is_equal_approx(AM.toll(20.0, 100.0, false), 45.0) and is_equal_approx(AM.toll(20.0, 60.0, false), 65.0)
		and is_equal_approx(AM.toll(20.0, 30.0, true), 90.0), "the toll: 45 on a full tank, 65 with 60 left, 90 stopped with 30 left")
	_check(is_equal_approx(AM.toll(88.0, 100.0, false), 88.0) and AM.toll(20.0, 0.0, true) <= 95.0, "never under what she walked in with, never over 95")
	_check(AM.rest_days(45.0) == 0 and AM.rest_days(65.0) == 2 and AM.rest_days(80.0) == 4, "rest days to fresh: 0, 2, 4 (%d %d %d)" % [
		AM.rest_days(45.0), AM.rest_days(65.0), AM.rest_days(80.0)])
	# The tiles.
	var before := {"morale": 60.0, "mood": "Steady", "rank": 0, "cap": 99.0}
	var after := {"morale": 48.0, "mood": "Flat", "rank": 0, "cap": 97.0, "fatigue": 80.0}
	var facts := {"first": "Lucy", "opp": "Erin", "outcome": "loss", "stopped": "TKO", "took": 15, "took_body": 6, "counts": 1,
		"worst": {"place": "left_ribs", "value": 30.0}, "injury": "", "calls": {"right": 1, "wrong": 2, "ignored": 0},
		"learned": ["Coach's note: drops the right."], "rank_words": "Unranked: 2 wins from entering."}
	var tiles := AM.tiles(before, after, facts)
	var t := {}
	for row in tiles:
		t[str(row["id"])] = row
	_check(tiles.size() == 6 and t.has("damage") and t.has("tired") and t.has("learned") and t.has("morale") and t.has("corner") and t.has("rank"),
		"six tiles: damage, tiredness, learned, morale, corner, rank")
	_check(str(t["damage"]["big"]) == "Left ribs badly hurt" and str(t["damage"]["tone"]) == "bad" and (t["damage"]["lines"] as Array).size() == 5,
		"damage: the worst place, the punches taken, the count, the heal line, the stoppage's mark (%s)" % [t["damage"]["lines"]])
	_check(str(t["tired"]["big"]) == "80 of 100" and str(t["tired"]["small"]).contains("4 rest days"), "tiredness: 80 of 100, about 4 rest days")
	_check(str(t["morale"]["big"]) == "-12" and str(t["morale"]["small"]).contains("Steady to Flat") and str(t["morale"]["tone"]) == "bad",
		"morale: -12, Steady to Flat (%s)" % t["morale"]["small"])
	_check(str(t["corner"]["big"]) == "1 of 3" and str(t["corner"]["tone"]) == "bad", "the corner: 1 of 3 calls worked")
	_check(str(t["rank"]["big"]) == "Unranked" and str(t["rank"]["small"]).begins_with("Unranked: 2 wins"), "rank: the line the fight earned")
	_check(str(t["learned"]["big"]) == "1 new", "learned: one new thing")
	var quiet := AM.tiles({"morale": 60.0, "mood": "Steady", "rank": 5, "cap": 99.0}, {"morale": 68.0, "mood": "Steady", "rank": 4,
		"cap": 99.0, "fatigue": 45.0}, {"first": "Lucy", "opp": "Erin", "outcome": "win", "took": 3, "took_body": 0,
		"places": {"head": 90.0, "left_eye": 100.0, "right_eye": 100.0, "nose": 80.0, "left_ribs": 100.0, "right_ribs": 100.0}})
	_check(str(quiet[0]["big"]) == "Nothing lasting" and str(quiet[1]["tone"]) == "good" and str(quiet[2]["big"]) == "Nothing new"
		and str(quiet[3]["big"]) == "+8" and str(quiet[4]["big"]) == "Said nothing" and str(quiet[5]["big"]) == "No. 4" and str(quiet[5]["tone"]) == "good",
		"a clean win: no marks, fresh, +8, up to No. 4")
	# S439 DAMAGESHOW1: the tile tells the truth about sore places.
	var nomap: Dictionary = AM.damage({}, {}, {"first": "Lucy", "took": 31, "took_body": 4})
	_check(str(nomap["big"]) == "31 punches taken" and str(nomap["tone"]) == "flat", "no body map: never 'Nothing lasting' (%s)" % nomap["big"])
	var edge: Dictionary = AM.damage({}, {}, {"first": "Lucy", "took": 9, "took_body": 1, "places": {"nose": 55.0, "head": 100.0}})
	_check(str(edge["big"]) == "Nose sore", "a place at exactly 55 is sore, as its band says (%s)" % edge["big"])
	var many: Dictionary = AM.damage({}, {}, {"first": "Lucy", "took": 40, "took_body": 9, "cuts": ["left_eye"],
		"places": {"head": 70.0, "left_eye": 30.0, "right_eye": 50.0, "nose": 100.0, "left_ribs": 100.0, "right_ribs": 41.0}})
	_check(str(many["big"]) == "Left eye badly hurt" and str(many["tone"]) == "bad" and int(many["sore"]) == 3 and int(many["cuts"]) == 1,
		"three sore places, worst first (%s)" % many["big"])
	_check(str(many["small"]) == "Cut: left eye. Sore too: liver, right eye.", "the short line names the rest and the cut (%s)" % many["small"])
	var joined := " ".join(PackedStringArray(many["lines"]))
	_check(joined.contains("Liver: 41 of 100") and joined.contains("Right eye: 50 of 100") and joined.contains("heal on their own"),
		"the hover lists each sore place and says the marks heal (%s)" % joined)
	var cut_only: Dictionary = AM.damage({}, {}, {"first": "Lucy", "took": 5, "took_body": 0, "cuts": ["nose"], "places": {"nose": 60.0}})
	_check(str(cut_only["big"]) == "Cut" and str(cut_only["small"]) == "Cut: nose.", "a cut alone is named (%s / %s)" % [cut_only["big"], cut_only["small"]])
	print("FIGHT_STATS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _x(call: String, sit: String, won: bool, landed: Array, body: Array, pace: String) -> Dictionary:
	return {"call": call, "sit": sit, "won": won, "landed": landed, "body": body, "pace": pace}


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		_fails += 1
