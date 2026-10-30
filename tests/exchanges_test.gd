extends SceneTree
## S308 deeper fight: the rules of a 30-second exchange (Exchanges) and the round fought exchange by exchange in the real
## bout (Bouts.fight_step + LiveRound). Bounds, never exact counts.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const X := preload("res://scripts/rules/Exchanges.gd")
const XB := preload("res://tools/exchange_balance.gd")
const CallButtons := preload("res://scripts/ui/CallButtons.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const FightWords := preload("res://scripts/state/FightWords.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")

var failures := 0


func _initialize() -> void:
	# 1. Every game has three different answers, all real calls, and the shout bar offers all three.
	var table_ok := true
	for k in X.MODES.keys():
		var row: Dictionary = X.MODES[k]
		var three := [str(row["best"]), str(row["ok"]), str(row["wrong"])]
		table_ok = table_ok and three[0] != three[1] and three[1] != three[2] and three[0] != three[2]
		table_ok = table_ok and three.all(func(c): return X.CALLS.has(c)) and X.CLUES.has(k)
		table_ok = table_ok and X.offers(str(k)).size() == 3 and X.offers(str(k)).has(three[0])
	_check(table_ok, "every game: best / ok / wrong differ, are calls, have clues, and the shout bar offers all three")
	# 1b. S309 "fix the wording": two women in the ring, so every button line and verdict names whom it means, with no
	# placeholder left over.
	var nm := ["Lucy", "Maria"]
	var words_ok := true
	for k in X.CALLS.keys():
		for field in ["when", "expect", "tell"]:
			var line := X.named(str(X.CALLS[k][field]), nm)
			words_ok = words_ok and not line.contains("{") and (field == "tell" or line.contains("Lucy") or line.contains("Maria"))
		for sit in X.MODES.keys():
			for won in [true, false]:
				var v := X.verdict(str(k), str(sit), won, nm)
				words_ok = words_ok and (v.contains("Lucy") or v.contains("Maria"))
	_check(words_ok and X.verdict("", "press", true, nm).contains("Lucy"), "every call line and verdict names a boxer")
	# 1c. S310: the rest of the fight's words - call captions, the words bank, the result's reasons, the corner card - never
	# open a sentence with a bare She/Her (whose?).
	var bare := RegEx.create_from_string("(^|[.:;!?] +)(She|Her)[ ']")
	var fight_lines: Array = []
	var captions_named := true
	for k in RoundScript.CALL_CAPTION.keys():
		var beats := [{}, {}, {}]
		RoundScript._captions(beats, [], str(k), "Lucy")
		fight_lines.append(str(beats[0]["caption"]))
		captions_named = captions_named and str(beats[0]["caption"]).contains("Lucy")
	_check(captions_named, "the corner call's caption names her (\"Stay long: Lucy starts behind the jab.\")")
	var subs := {"her": "Lucy", "opp": "Maria", "threat": "left hook", "round": 2, "focus": "speed"}
	_collect(FightWords.bank(), subs, fight_lines)
	_collect(FightWords.FALLBACK, subs, fight_lines)
	fight_lines.append_array(BoutRules.why([], true, 2, "Speed", BoutRules.FILM_DEPTH_WITH_STUDY, "left hook", "Lucy"))
	var whole_card := CornerCard.card({"a": {"landed": {"jab": 3}, "whole": ["1-2"]}, "b": {"landed": {"lead_hook": 2}}}, 80.0, nm)
	fight_lines.append(str(whole_card["worked"]))
	var bare_lines := fight_lines.filter(func(l): return bare.search(str(l)) != null or str(l).contains("{"))
	_check(fight_lines.size() > 20 and bare_lines.is_empty(), "fight words name the boxer, never a bare She/Her (%d lines, bad: %s)" % [fight_lines.size(), str(bare_lines.slice(0, 3))])
	# 2. The fit orders the edge for a fighter who can do every call.
	var able := {"power": 70.0, "speed": 70.0, "technique": 70.0, "defense": 70.0, "conditioning": 70.0, "fight_iq": 70.0,
		"footwork": 70.0, "discipline": 70.0, "heart": 70.0}
	var e_best := X.call_edge("long", "press", able, 1.0)
	var e_ok := X.call_edge("hands", "press", able, 1.0)
	var e_none := X.call_edge("calm", "press", able, 1.0)
	var e_wrong := X.call_edge("let_go", "press", able, 1.0)
	_check(e_best > e_ok and e_ok > e_none and e_none > e_wrong, "pressing: jab and move > hands up > breathe > let your hands go (%.1f %.1f %.1f %.1f)" % [e_best, e_ok, e_none, e_wrong])
	# 3. She can or cannot: a call she lacks the stat for is worth less.
	var slow := able.duplicate()
	slow["footwork"] = 40.0
	slow["technique"] = 40.0
	_check(str(X.grade("long", able)["word"]) == "Good" and str(X.grade("long", slow)["word"]) == "Poor", "grade: Good with the stats, Poor without")
	_check(X.call_edge("long", "press", slow, 1.0) < e_best * 0.5, "a Poor fighter gets under half the edge of the right call")
	# 4. The third shout of a round lands at half.
	_check(is_equal_approx(X.uptake(60.0, 2), X.uptake(60.0, 0) * X.LATE_SHOUT) and X.uptake(90.0, 0) > X.uptake(20.0, 0),
		"shouts: the third lands at half; a coachable fighter hears more")
	# 5. settle and round_of agree with themselves.
	var s1 := X.settle(10.0, 0.5, 0.5)
	var s2 := X.settle(-40.0, 0.5, 0.5)
	_check(bool(s1["won"]) and not bool(s2["won"]) and int(s2["landed"][1]) > int(s2["landed"][0]), "settle: the edge wins, the winner lands more")
	var split := [{"won": true, "margin": 30.0, "landed": [4, 2]}, {"won": true, "margin": 5.0, "landed": [3, 2]},
		{"won": true, "margin": 5.0, "landed": [3, 2]}, {"won": false, "margin": -5.0, "landed": [2, 3]},
		{"won": false, "margin": -5.0, "landed": [2, 3]}, {"won": false, "margin": -5.0, "landed": [2, 3]}]
	var ro := X.round_of(split)
	_check(bool(ro["won"]) and int(ro["won_n"]) == 3, "a 3-3 round goes to the bigger margin")
	# 6. Styles show in the games they play; a hurt boxer is hurt.
	var rng := RandomNumberGenerator.new()
	rng.seed = 308
	var counters := 0
	for i in 500:
		counters += 1 if X.next_mode("Counter-puncher", "", 2, 3, "", 90.0, false, rng) == "counter" else 0
	_check(counters > 200 and counters < 450, "a counter-puncher waits to counter in most exchanges (%d of 500)" % counters)
	_check(X.next_mode("Pressure fighter", "", 1, 1, "press", 90.0, true, rng) == "hurt", "hurt comes first")
	# 7. One live round in the real bout: six exchanges, a clue and three offers before each shout.
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["bout"] = {"opp": (Data.OPPONENTS[1] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	var pv := LiveRound.preview(f, m)
	_check(str(pv.get("clue", "")).contains("Priya") or str(pv.get("clue", "")).contains(str(f["first"])), "the clue names a boxer: \"%s\"" % pv.get("clue", ""))
	_check((pv.get("offers", []) as Array).size() == 3 and int(pv.get("at", 0)) == 30, "after 0:30 the shout bar offers three calls")
	# S310: without film study the shout bar marks no "coach's pick" - the player reads the clue.
	_check(str(pv.get("mark", "?")) == "" and str(pv.get("coach", "")) != "", "film 1: no coach's pick on the shout bar")
	var row := CallButtons.shout_row(pv["offers"], pv["grades"], str(pv["mark"]), pv["names"], func(_k): pass)
	var row_text := ""
	for b in row.get_children():
		row_text += str(b.find_children("*", "Label", true, false).map(func(l): return l.text))
	_check(not row_text.contains("coach's pick") and row_text.contains("Use when"), "film 1: the shout buttons say when to use each call, no pick mark")
	row.free()
	var shouts := 0
	while not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:" + str(LiveRound.preview(f, m)["coach"]))
		shouts += 1
	var r1: Dictionary = (m["rounds"] as Array)[0]
	_check(shouts == 5 and (r1["exchanges"] as Array).size() == 6 and int(r1["calls"]) == 5, "a round: five shouts, six exchanges")
	_check((r1["lines"] as Array).any(func(l): return str(l).begins_with("Exchanges")), "the round's words count the exchanges")
	Bouts.fight_step(c, f, m, "corner:long")
	_check(int(m["round"]) == 2 and (LiveRound.live(m)["ex"] as Array).size() == 1 and str(LiveRound.live(m)["plan"]) == "long",
		"the corner's plan opens round 2 and fights its first 30 seconds")
	# 8. Film study: the corner reads her next game, not the last one.
	var lv := LiveRound.live(m)
	f["bout"]["film"] = 3
	var next_seen := str(LiveRound.preview(f, m)["sit"])
	_check(next_seen == X.situation(str(lv["mode"]), LiveRound.her_energy(lv, 1), bool(lv["her_hurt"])), "film 3: the clue is her next game")
	var fav_best := str(X.MODES[X.situation(X.favourite(str(f["bout"]["opp"]["style"])), LiveRound.her_energy(lv, 1), bool(lv["her_hurt"]))]["best"])
	_check(str(LiveRound.preview(f, m)["mark"]) == fav_best, "film 3: the coach marks the answer to her favourite game on tape (%s)" % fav_best)
	# 9. The calls change the fight (bounded): the right call wins more than none, the wrong one loses more.
	var none := XB.share(0.0, "none", 1)
	var seen := XB.share(0.0, "seen", 1)
	var wrong := XB.share(0.0, "wrong", 1)
	var behind := XB.share(-10.0, "oracle", 1)
	print("  even fight: none %.2f, the corner's read %.2f, wrong %.2f; 10 points behind with perfect calls %.2f" % [none, seen, wrong, behind])
	_check(seen >= none + 0.05, "shouting the read wins more than saying nothing")
	_check(wrong <= none - 0.15, "wrong calls lose clearly more")
	_check(behind < 0.4, "no call beats a fighter 10 points better")
	# 10. S310: with film study, reading the clue beats following the coach's pick blindly; the pick still helps.
	var f_none := XB.share(0.0, "none", 3)
	var f_seen := XB.share(0.0, "seen", 3)
	var f_mark := XB.share(0.0, "mark", 3)
	print("  film 3: none %.2f, follow the pick %.2f, read the clue %.2f" % [f_none, f_mark, f_seen])
	_check(f_seen >= f_mark + 0.03 and f_mark >= f_none + 0.02, "film 3: reading the clue > following the coach's pick > saying nothing")
	print("EXCHANGES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## Every string in a words bank, filled.
func _collect(x: Variant, subs: Dictionary, out: Array) -> void:
	if x is String:
		out.append(FightWords.fill(x, subs))
	elif x is Dictionary:
		for v in (x as Dictionary).values():
			_collect(v, subs, out)
	elif x is Array:
		for v in x:
			_collect(v, subs, out)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
