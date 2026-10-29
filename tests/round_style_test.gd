extends SceneTree
## RoundStyle (fight model step 3): the ring shows training. Over 200 seeds each:
##   1. an unlearned move is never thrown; once mastered it is, 2. the sim's landed counts do not move with profiles,
##   3. a high-defense boxer stops more of what is thrown at her (block/slip/weave/pull) than a low one,
##   4. low conditioning shows tired beats in round 3 and none in round 1; good conditioning never,
##   5. speed sets the longest combination, 6. two differently trained boxers throw different mixes,
##   7. the scout's words drive an opponent: "Fades after round 2" tires her, "Body hooks" is her punch.

const RS := preload("res://scripts/rules/RoundScript.gd")
const ST := preload("res://scripts/rules/RoundStyle.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0
const SEEDS := 200


func _initialize() -> void:
	var lucy: Dictionary = Data.fighter_state(Data.lucy(), 0)
	var a := ST.of_fighter(lucy)
	var opp := ST.from_opponent((Data.OPPONENTS[0] as Dictionary))
	# 1. Lucy has never drilled the uppercut (mastery 0): she never throws it; at mastery 45 she does.
	var ups := _count(a, opp, 2, func(b): return b["who"] == "a" and b["move"] == "rear_uppercut")
	_check(ups == 0, "no uppercut drilled -> none thrown in %d rounds (got %d)" % [SEEDS, ups])
	var drilled := a.duplicate(true)
	drilled["moves"]["Uppercut"] = 45.0
	var ups2 := _count(drilled, opp, 2, func(b): return b["who"] == "a" and b["move"] == "rear_uppercut")
	_check(ups2 >= 40, "uppercut at mastery 45 -> thrown (got %d in %d rounds)" % [ups2, SEEDS])
	# 2. Landed counts stay Kalli's.
	var ok := true
	for s in SEEDS:
		var sc: Dictionary = RS.build(_round(2, true, 66.0, 61.0), "Out-boxer", "Pressure fighter", 40.0, s, {"a": a, "b": opp})
		var got: Dictionary = RS.landed(sc)
		ok = ok and int(got["a"]) == 6 and int(got["b"]) == 1
	_check(ok, "a dominant round still lands 6-1 on every seed with profiles")
	# 3. Defense: what B throws and does not land is stopped more often by a 75-defense A than a 45-defense A.
	var hi := a.duplicate(true)
	hi["stats"]["defense"] = 75.0
	var lo := a.duplicate(true)
	lo["stats"]["defense"] = 45.0
	var is_def := func(b): return b["who"] == "b" and str(b["def"]) != ""
	var d_hi := _count(hi, opp, 2, is_def)
	var d_lo := _count(lo, opp, 2, is_def)
	_check(d_hi > d_lo * 1.4, "defense 75 stops more than defense 45 (%d vs %d)" % [d_hi, d_lo])
	var blocks_hi := _count(hi, opp, 2, func(b): return b["who"] == "b" and b["result"] == "blocked")
	var blocks_lo := _count(lo, opp, 2, func(b): return b["who"] == "b" and b["result"] == "blocked")
	_check(blocks_hi > blocks_lo, "defense 75 blocks more than defense 45 (%d vs %d)" % [blocks_hi, blocks_lo])
	# 4. Conditioning.
	var tired := a.duplicate(true)
	tired["stats"]["conditioning"] = 48.0
	var fresh := a.duplicate(true)
	fresh["stats"]["conditioning"] = 66.0
	var is_tired := func(b): return b["who"] == "a" and b["move"] == "tired"
	_check(_count(tired, opp, 1, is_tired) == 0, "no tired beats in round 1")
	_check(_count(tired, opp, 3, is_tired) >= SEEDS, "conditioning 48 shows tired beats in round 3 (got %d)" % _count(tired, opp, 3, is_tired))
	_check(_count(fresh, opp, 3, is_tired) == 0, "conditioning 66 never tires")
	# 5. Speed -> the longest combination.
	var slow := a.duplicate(true)
	slow["stats"]["speed"] = 50.0
	var quick := a.duplicate(true)
	quick["stats"]["speed"] = 70.0
	_check(ST.combo_cap(slow) == 1 and ST.combo_cap(quick) == 3 and ST.combo_cap({}) == 3, "combo cap 1 slow / 3 quick / 3 generic")
	# 6. Two differently trained boxers: a jabber vs a body puncher.
	var jabber := a.duplicate(true)
	jabber["moves"] = {"Jab": 60.0, "Cross": 20.0, "Lead hook": 0.0, "Body hook": 0.0, "Uppercut": 0.0, "Check hook": 0.0}
	var digger := a.duplicate(true)
	digger["moves"] = {"Jab": 20.0, "Cross": 30.0, "Lead hook": 40.0, "Body hook": 60.0, "Uppercut": 0.0, "Check hook": 0.0}
	var body_j := _count(jabber, opp, 2, func(b): return b["who"] == "a" and b["move"] == "body_hook")
	var body_d := _count(digger, opp, 2, func(b): return b["who"] == "a" and b["move"] == "body_hook")
	var jab_j := _count(jabber, opp, 2, func(b): return b["who"] == "a" and b["move"] == "jab")
	var jab_d := _count(digger, opp, 2, func(b): return b["who"] == "a" and b["move"] == "jab")
	_check(body_j == 0 and body_d > 200 and jab_j > jab_d * 2, "jabber vs digger: body hooks %d vs %d, jabs %d vs %d" % [body_j, body_d, jab_j, jab_d])
	# 7. The scout's words.
	var fader := ST.from_opponent({"rating": 62.0, "style": "Pressure fighter", "threat": "Left hook to the body", "weak": "Fades after round 2"})
	var steady := ST.from_opponent({"rating": 62.0, "style": "Boxer-puncher", "threat": "Straight right", "weak": "Stands still after combinations"})
	var b_tired := func(b): return b["who"] == "b" and b["move"] == "tired"
	_check(_count(a, fader, 3, b_tired) > 0 and _count(a, steady, 3, b_tired) == 0, "'Fades after round 2' tires her in round 3, a steady one does not")
	var b_body := func(b): return b["who"] == "b" and b["move"] == "body_hook"
	_check(_count(a, fader, 2, b_body) > _count(a, steady, 2, b_body) * 1.5, "'Left hook to the body' throws more body hooks")
	# 8. No profiles: the old script, every beat with an empty def.
	var old: Dictionary = RS.build(_round(2, true, 60.0, 59.0), "Out-boxer", "Pressure fighter", 40.0, 7)
	var empty := true
	for b in old["beats"]:
		empty = empty and str(b["def"]) == "" and str(b["move"]) != "tired"
	_check(empty, "no profiles -> no def, no tired beats")
	# S301: the scout's words become the opponent's ring habits (HabitBeats ids), at most two.
	var oh: Array = ST.opponent_habits({"weak": "Fades after round 2", "threat": "Left hook to the body"})
	_check(oh == ["fades_late", "digs_body_when_hurt"], "scout words -> habits fades_late + digs_body_when_hurt (got %s)" % [oh])
	_check(ST.opponent_habits({"weak": "Leaves her chin open", "threat": "Everything"}) == ["drops_right_after_jab"],
		"'Leaves her chin open' -> drops_right_after_jab")
	_check(ST.opponent_habits({"weak": "None you can use yet", "threat": "Never stops throwing"}).is_empty(),
		"no usable words -> no habits")
	_check(ST.opponent_habits({"weak": "Slow to start, fades, walks in straight"}).size() == 2, "never more than two")
	# S303: style shapes the mix (the words say "works both hands inside" -> the hooks land, not the jab).
	var press: Dictionary = ST.from_opponent({"rating": 64.0, "style": "Pressure fighter", "threat": "Never stops", "weak": "-"})["moves"]
	var outb: Dictionary = ST.from_opponent({"rating": 61.0, "style": "Out-boxer", "threat": "Long jab", "weak": "-"})["moves"]
	_check(float(press["Lead hook"]) > float(press["Jab"]) and float(press["Body hook"]) > float(press["Jab"]),
		"pressure fighter: hooks and body over the jab (%s)" % [press])
	_check(float(outb["Jab"]) > float(outb["Lead hook"]) * 1.5, "out-boxer: the jab leads (%s)" % [outb])
	print("ROUND_STYLE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _round(n: int, won: bool, mine: float, theirs: float) -> Dictionary:
	return {"n": n, "won": won, "mine": mine, "theirs": theirs, "corner": "", "lines": ["One.", "Two.", "Three."]}


## How many beats over SEEDS round-n scripts (A loses a close round, so B lands 4 and A defends a lot) match `pred`.
func _count(a: Dictionary, b: Dictionary, n: int, pred: Callable) -> int:
	var k := 0
	for s in SEEDS:
		var sc: Dictionary = RS.build(_round(n, false, 60.0, 61.0), "Out-boxer", "Pressure fighter", 40.0, s * 13 + 1, {"a": a, "b": b})
		for bt in sc["beats"]:
			if pred.call(bt):
				k += 1
	return k


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
