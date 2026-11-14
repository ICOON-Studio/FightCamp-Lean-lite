extends SceneTree
## S442 RESULTDEFECTS1: one bout, one story. The seed-44 bout of tools/result_dump.gd (Lucy v Priya, the plan with line C a
## wrong answer, shouts on the 3rd and 5th exchange) showed seven places where two parts of the game said two things about
## the same fight. Each check below reads the bout's records (the one truth the sim fought on) against what a screen reads.
##   6. the habit line never says the opponent "made X pay" on an exchange X won
##   7. the corner tile counts the same shouts the round lines count
##   2. FightWhy's "Try ..." is a move the Playbook offers at the replaced line's own place
##   1. the stat row's tank at the last bell is the energy the sim fought on (the last exchange's after)

const Dump := preload("res://tools/result_dump.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const Aftermath := preload("res://scripts/rules/Aftermath.gd")
const CornerTrust := preload("res://scripts/rules/CornerTrust.gd")

var failures := 0


func _initialize() -> void:
	var cf := Dump._setup(44)
	var f: Dictionary = cf[1]
	var m := Dump._fight(cf[0], f, Dump.PLAN, true)
	var rounds: Array = m["rounds"]
	var names := [str(f["first"]), str(f["bout"]["opp"]["first"])]
	print("  bout: %s, cards %s" % [str(m["outcome"]), str(m["cards"])])
	_habit_line(rounds)
	_corner_tile(m, rounds)
	_why_next_any(f, rounds, names)
	_tank(rounds)
	_head(f, m)
	_units()
	print("RESULT_DEFECTS failures=%d" % failures)
	print("PASS result_defects_test" if failures == 0 else "FAIL result_defects_test")
	quit(1 if failures > 0 else 0)


## 6. A habit that cost an edge on an exchange our fighter still won is not "made X pay".
func _habit_line(rounds: Array) -> void:
	var won_paid := 0
	var bad := 0
	for r in rounds:
		for x in r["exchanges"]:
			if str(x.get("habit", "")) == "" or not bool(x["won"]):
				continue
			won_paid += 1
			if str(x["habit_line"]).contains("pay for a habit"):
				bad += 1
				print("    R%d-%d won, line: %s" % [int(r["n"]), int(x["i"]) + 1, str(x["habit_line"])])
	_check(won_paid > 0, "6. the bout has a habit shown on an exchange won (%d)" % won_paid)
	_check(bad == 0, "6. no 'made ... pay for a habit' on an exchange won (%d wrong)" % bad)


## 7. The corner tile's "N of M" = the round lines' worked / shouts, summed.
func _corner_tile(m: Dictionary, rounds: Array) -> void:
	var worked := 0
	var calls := 0
	for r in rounds:
		worked += int(r.get("worked", 0))
		calls += int(r.get("calls", 0))
	var tile := {}
	for t in m.get("aftermath", []):
		if str(t["id"]) == "corner":
			tile = t
	var want := "%d of %d" % [worked, calls]
	_check(str(tile.get("big", "")) == want, "7. corner tile says '%s', the round lines '%s'" % [str(tile.get("big", "")), want])


## S467: since the S466 card fix the seed-44 bout no longer reaches line C's situation, so check 2 takes the first bout of
## seeds 44-63 that fought a wrong answer (the check is about the "Try" move, not about which seed shows it).
func _why_next_any(f: Dictionary, rounds: Array, names: Array) -> void:
	for sd in range(44, 64):
		var r: Array = rounds
		var fx: Dictionary = f
		var nm: Array = names
		if sd != 44:
			var cf := Dump._setup(sd)
			fx = cf[1]
			r = Dump._fight(cf[0], fx, Dump.PLAN, true)["rounds"]
			nm = [str(fx["first"]), str(fx["bout"]["opp"]["first"])]
		if str(FightWhy.read(r, str(nm[0]), str(nm[1]))["next"]).begins_with("Against "):
			print("    check 2 on seed %d" % sd)
			_why_next(fx, r, nm)
			return
	_why_next(f, rounds, names)   # none of 20 fought a wrong answer: fails, says so


## 2. "Against X, replace A. Try B.": B must be a move PlanLines.options offers at A's own place (PlanLines.set_line
## refuses any other).
func _why_next(f: Dictionary, rounds: Array, names: Array) -> void:
	var why := FightWhy.read(rounds, str(names[0]), str(names[1]))
	var next := str(why["next"])
	print("    next: %s" % next)
	var at := next.find(" Try ")
	_check(next.begins_with("Against ") and at > 0, "2. the bout's Why replaces a line (it fought a wrong answer)")
	if at < 0:
		return
	var tried := next.substr(at + 5).trim_suffix(".")
	var replaced := next.substr(next.find("replace ") + 8, at - next.find("replace ") - 9)
	var place := ""
	for row in _moves():
		if str(row["name"]) == replaced:
			place = str(row["from"])
	var offered: Array = []
	for o in PlanLines.options(place, "counter", f.get("moves", {}), f.get("combos", {})):
		offered.append(str(o["name"]))
	_check(place != "" and offered.has(tried), "2. '%s' is offered at %s where '%s' sits (offered: %s)" % [tried, place, replaced, str(offered)])


func _moves() -> Array:
	var out: Array = []
	for p in PlanLines.PLACES:
		out.append_array(StrikeMap.outs(p))
	return out


## 1. The tank at the last bell, per round and for the bout, is the energy the last exchange left (rec "after").
func _tank(rounds: Array) -> void:
	var st := FightStats.of(rounds)
	var ok := true
	for i in rounds.size():
		var exs: Array = rounds[i]["exchanges"]
		var aft: Dictionary = exs[-1].get("after", {})
		var t: Array = st["rounds"][i]["tank"]
		var same := absf(float(t[0]) - float(aft["a"])) < 0.01 and absf(float(t[1]) - float(aft["b"])) < 0.01
		print("    R%d tank %.1f v %.1f, after the last exchange %.1f v %.1f" % [i + 1, float(t[0]), float(t[1]), float(aft["a"]), float(aft["b"])])
		ok = ok and same
	_check(ok, "1. the stat row's tank is the energy the sim fought on, every round")


## 4. The damage tile reads the head the stand-down reads: never "Nothing lasting" beside days without sparring.
func _head(f: Dictionary, m: Dictionary) -> void:
	var sd: Dictionary = f.get("stand_down", {})
	var tile := {}
	for t in m.get("aftermath", []):
		if str(t["id"]) == "damage":
			tile = t
	var joined := " ".join(PackedStringArray(tile.get("lines", [])))
	print("    stand-down %s (head %.0f, damage %s); tile '%s' / '%s'" % [str(sd.get("band", "-")), float(sd.get("head", -1.0)),
		str(sd.get("damage", "-")), str(tile.get("big", "")), str(tile.get("small", ""))])
	# S443 (Q-S294-201, 0.8 a point): this distance bout now leaves a FINE head, as the eased rule means; the check is that the
	# tile and the stand-down agree in either band (the hurt / critical words are checked on the made-up rows below).
	_check(not sd.is_empty(), "4. the bout left a stand-down record (%s)" % str(sd.get("band", "none")))
	var hurt: bool = str(sd.get("band", "fine")) != "fine"
	var says_hurt: bool = str(tile.get("big", "")) != "Nothing lasting" and str(tile.get("big", "")).begins_with("Head") and joined.contains("No sparring until")
	_check(hurt == says_hurt, "4. the damage tile says what the stand-down says (%s: %s)" % [str(sd.get("band", "-")), joined])


## The same rules on hand-made inputs, so each holds outside this one bout.
func _units() -> void:
	var lost := HabitFix.line("Slow starter", ["Lucy", "Priya"], false, false)
	var won := HabitFix.line("Slow starter", ["Lucy", "Priya"], false, true)
	_check(lost.contains("The opponent made your boxer pay") and not won.contains("pay") and won.contains("still took the exchange"),
		"6. lost: '%s' / won: '%s'" % [lost, won])
	_check(HabitFix.line("Slow starter", ["Lucy", "Priya"], true, true).begins_with("The fix held"), "6. a held fix still says so")
	_check(FightWhy.best_answer("counter", "long") == "Double jab" and FightWhy.best_answer("counter") == "Feint and draw"
		and FightWhy.best_answer("tiring", "inside") == "", "2. best_answer keeps to the line's place (long: Double jab; none inside for tiring)")
	var tile := Aftermath.corner({"calls": {"right": 2, "wrong": 0, "ignored": 0, "worked": 2, "said": 6, "wrong_all": 0}})
	_check(str(tile["big"]) == "2 of 6" and str(tile["small"]).begins_with("2 of 6 calls worked"), "7. corner tile: %s / %s" % [tile["big"], tile["small"]])
	var places := {"head": 63.0, "left_eye": 100.0, "right_eye": 80.0, "nose": 90.0, "left_ribs": 100.0, "right_ribs": 90.0}
	var crit := Aftermath.damage({}, {}, {"first": "Lucy", "took": 70, "took_body": 9, "places": places,
		"stand_down": {"head": 0.0, "band": "critical", "days": 21, "words": "no sparring until Sat 28 Mar: the head took 46 damage"}})
	_check(str(crit["big"]) == "Head badly hurt" and str(crit["small"]).contains("No sparring for 21 days"), "4. critical stand-down: %s / %s" % [crit["big"], crit["small"]])
	var fine := Aftermath.damage({}, {}, {"first": "Lucy", "took": 20, "took_body": 2, "places": places,
		"stand_down": {"head": 56.0, "band": "fine", "days": 5, "words": "no sparring until Thu 12 Mar: the head took 20 damage"}})
	_check(str(fine["big"]) == "Nothing lasting", "4. a fine stand-down leaves the tile as it was (%s)" % fine["big"])
	var edge := Aftermath.damage({}, {}, {"first": "Lucy", "took": 20, "took_body": 2, "places": places,
		"stand_down": {"head": 55.0, "band": "fine", "days": 5, "words": "x"}})
	_check(str(edge["big"]) == "Nothing lasting", "4. head 55 is fine on both (StandDown's own band) (%s)" % edge["big"])
	var b := {}
	CornerTrust.tally(b, [{"shout": true, "fit": "best", "won": false}, {"shout": true, "fit": "best", "won": true}, {"shout": false, "fit": "wrong", "won": false}])
	_check(int(b.get("calls_said", 0)) == 2 and int(b.get("calls_right", 0)) == 1, "7. tally counts every shout taken in (%s)" % str(b))


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
