extends SceneTree
## LOYALTY (R58LOYAL1, S440): Loyalty.gd, each fighter's loyalty made live (CLUBWEEK_MAP_V41_S432 3.8 and 3.1, RPG_LAYER_MAP_S432 3).
## Population: the five named prospects, deep copies of Data.PROSPECTS rows (Kira 60, Samira 82, Tess 66, Danny 58, Josh 70,
## each read from Data, never typed here), Ana (NoGi.athlete(), her own loyalty 60) and Lucy (Data.lucy(), no trait).
##   1. value(): the trait for a boxer, Ana's own f["loyalty"] over any trait, START with neither.
##   2. the bands at their edges; Trusts you needs Known 4.
##   3. short weeks: -3, -6 running, a Loyal fighter's first short in 28 days free - and two MUTANT copies of apply
##      (no free week, no short_running) must each fail those same asserts.
##   4. held pads 4 weeks running then 0; the clamps; morale never touched; StripeCall's prices read, never typed.
##   5. the forecast on a copy and its line; the word card, tell it straight, leaving, the professional's share, the log.

const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Data := preload("res://scripts/state/Data.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const StripeCall := preload("res://scripts/rules/StripeCall.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")

var _fails := 0


func _initialize() -> void:
	print("population: Kira, Samira, Tess, Danny, Josh (Data.PROSPECTS copies), Ana (NoGi.athlete), Lucy (Data.lucy)")
	_values()
	_bands()
	_short_asserts(0)
	_mutants()
	_pads_and_clamps()
	_forecast()
	_talks()
	_leaving()
	_pro_and_pads()
	_log()
	print("LOYALTY failures=%d" % _fails)
	quit(_fails)


## A deep copy of one Data.PROSPECTS row.
func _prospect(id: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			return p.duplicate(true)
	return {}


## The fighter's personality trait, as Data holds it.
func _trait(f: Dictionary) -> int:
	return int(round(float(f["personality"]["loyalty"])))


func _values() -> void:
	var ids := ["kira", "samira", "tess", "danny", "josh"]
	var seen := {}
	for id in ids:
		var f := _prospect(str(id))
		var want := _trait(f)
		seen[want] = id
		_check(not f.is_empty() and not f.has("loyalty") and Loyalty.value(f) == want,
			"%s: no loyalty key yet, value() reads the trait %d" % [str(f.get("first", id)), want])
	_check(seen.size() == ids.size(), "five different prospects, five different loyalties %s" % str(seen.keys()))
	var ana := NoGi.athlete()
	ana["personality"] = _prospect("samira")["personality"]
	_check(int(ana["loyalty"]) != _trait(ana) and Loyalty.value(ana) == int(ana["loyalty"]),
		"Ana: the loyalty already on the record (%d) wins over a trait of %d" % [int(ana["loyalty"]), _trait(ana)])
	var lucy := Data.lucy()
	_check(not lucy.has("personality") and Loyalty.value(lucy) == Loyalty.START and Loyalty.START == 50,
		"no key and no trait (Lucy as dealt): %d" % Loyalty.value(lucy))


func _bands() -> void:
	var edges := [24, 25, 49, 50, 69, 70, 84, 85]
	var want := ["Leaving", "Wavering", "Wavering", "Settled", "Settled", "Loyal", "Loyal", "Loyal"]
	for i in edges.size():
		var got := Loyalty.band(int(edges[i]))
		_check(got == str(want[i]), "%d reads %s with known 0 (%s)" % [int(edges[i]), str(want[i]), got])
	_check(Loyalty.band(85, 4) == "Trusts you" and Loyalty.band(85, 3) == "Loyal" and Loyalty.band(100, 4) == "Trusts you",
		"85 with known 4 reads Trusts you; known 3 still Loyal")


## Mode 0 is the real Loyalty.apply; 1 and 2 are MUTANT copies of apply (move_for inlined): 1 drops the Loyal free week,
## 2 never escalates to short_running.
func _apply(mode: int, f: Dictionary, cause: String, day: int) -> Dictionary:
	if mode == 0:
		return Loyalty.apply(f, cause, day)
	if not Loyalty.MOVES.has(cause):
		return {"before": Loyalty.value(f), "after": Loyalty.value(f), "delta": 0}
	var book := Loyalty.log_of(f)
	var n: int = int(Loyalty.MOVES[cause])
	var why := cause
	if cause == "short":
		if mode != 1 and Loyalty.value(f) >= Loyalty.LOYAL_AT and not Loyalty.logged(book, "short", day - Loyalty.FREE_DAYS + 1, day):
			n = 0
			why = Loyalty.FREE_WHY
		elif mode != 2 and Loyalty.logged(book, "short", day - Loyalty.RUN_DAYS, day):
			n = int(Loyalty.MOVES["short_running"])
			why = "short_running"
	elif cause == "held_pads" and Loyalty.pads_run(book, day) >= Loyalty.PADS_RUN:
		n = 0
		why = Loyalty.PADS_WHY
	return Loyalty.commit(f, n, why, day)


## The short-week asserts through apply (mode 0, counted) or a mutant (not counted). Returns how many failed.
func _short_asserts(mode: int) -> int:
	var real := mode == 0
	var bad := 0
	var short: int = int(Loyalty.MOVES["short"])
	var running: int = int(Loyalty.MOVES["short_running"])
	var tess := _prospect("tess")
	var r1 := _apply(mode, tess, "short", 0)
	bad += _soft(real, int(r1["delta"]) == short and str(Loyalty.log_of(tess).back()["why"]) == "short",
		"Tess (Settled) short a week: %d (%d)" % [short, int(r1["delta"])])
	var r2 := _apply(mode, tess, "short", 7)
	bad += _soft(real, int(r2["delta"]) == running and str(Loyalty.log_of(tess).back()["why"]) == "short_running",
		"short again 7 days later: %d, logged short_running (%d)" % [running, int(r2["delta"])])
	var r3 := _apply(mode, tess, "short", 21)
	bad += _soft(real, int(r3["delta"]) == short, "a short 14 days after the last: back to %d (%d)" % [short, int(r3["delta"])])
	var sam := _prospect("samira")
	var s1 := _apply(mode, sam, "short", 0)
	var last: Dictionary = Loyalty.log_of(sam).back()
	bad += _soft(real, int(s1["delta"]) == 0 and int(last["n"]) == 0 and str(last["why"]) == Loyalty.FREE_WHY,
		"Samira (Loyal): the first short in 28 days costs 0, logged as the free week (%d)" % int(s1["delta"]))
	var s2 := _apply(mode, sam, "short", 14)
	bad += _soft(real, int(s2["delta"]) == short or int(s2["delta"]) == running,
		"the second short inside 28 days costs %d or %d (%d)" % [short, running, int(s2["delta"])])
	var s3 := _apply(mode, sam, "short", 42)
	bad += _soft(real, int(s3["delta"]) == 0 and Loyalty.value(sam) >= Loyalty.LOYAL_AT,
		"28 days clear and still Loyal: the next short is free again (%d)" % int(s3["delta"]))
	return bad


func _mutants() -> void:
	var names := {1: "drops the Loyal free week", 2: "never escalates to short_running"}
	for mode in names.keys():
		var bad := _short_asserts(int(mode))
		if bad > 0:
			print("MUTANT caught: apply that %s fails %d short asserts" % [str(names[mode]), bad])
		_check(bad > 0, "the mutant that %s fails the same short asserts" % str(names[mode]))


func _pads_and_clamps() -> void:
	var josh := _prospect("josh")
	var pads: int = int(Loyalty.MOVES["held_pads"])
	var start := Loyalty.value(josh)
	for w in 4:
		var r := Loyalty.apply(josh, "held_pads", int(w) * 7)
		_check(int(r["delta"]) == pads, "Josh holds pads, week %d running: +%d (%d)" % [int(w) + 1, pads, int(r["after"])])
	var r5 := Loyalty.apply(josh, "held_pads", 28)
	_check(int(r5["delta"]) == 0 and int(Loyalty.log_of(josh).back()["n"]) == 0 and Loyalty.value(josh) == start + 4 * pads,
		"the fifth week running logs 0 (%d)" % Loyalty.value(josh))
	_check(int(Loyalty.apply(josh, "held_pads", 35)["delta"]) == 0, "the sixth week running: still 0")
	_check(int(Loyalty.apply(josh, "held_pads", 49)["delta"]) == pads, "a week off breaks the run: +%d again" % pads)
	_check(not josh.has("morale"), "loyalty is not mood: no morale written")
	var sam := _prospect("samira")
	sam["loyalty"] = 98
	var up := Loyalty.apply(sam, "sponsor_given", 0)
	_check(int(up["after"]) == 100 and int(up["delta"]) == 2 and int(Loyalty.log_of(sam).back()["n"]) == 2,
		"98 + sponsor_given clamps at 100, logs +2")
	var danny := _prospect("danny")
	danny["loyalty"] = 5
	var down := Loyalty.apply(danny, "promise_broken", 0)
	_check(int(down["after"]) == 0 and int(down["delta"]) == -5 and str(down["band_after"]) == "Leaving",
		"5 + promise_broken clamps at 0, logs -5")
	var kira := _prospect("kira")
	var none := Loyalty.apply(kira, "nonsense", 0)
	_check(int(none["delta"]) == 0 and not kira.has("loyalty") and not kira.has("loyalty_log"), "an unknown cause changes nothing")
	_check(int(Loyalty.MOVES["stripe_now"]) == StripeCall.NOW_LOYAL and int(Loyalty.MOVES["stripe_hold"]) == -StripeCall.HOLD_LOYAL,
		"the stripe call's prices are StripeCall's own (+%d, -%d)" % [StripeCall.NOW_LOYAL, StripeCall.HOLD_LOYAL])
	var ana := NoGi.athlete()
	var mood := int(ana["morale"])
	var was := int(ana["loyalty"])
	Loyalty.apply(ana, "stripe_hold", 0)
	_check(int(ana["morale"]) == mood and int(ana["loyalty"]) == was - StripeCall.HOLD_LOYAL,
		"Ana's hold through Loyalty: loyalty %d -> %d, morale untouched" % [was, int(ana["loyalty"])])


func _forecast() -> void:
	var full: int = int(Loyalty.MOVES["full_week"])
	var tess := _prospect("tess")
	var snap := str(tess)
	var fc := Loyalty.forecast(tess, ["full_week"], 4, 0)
	var want := _trait(tess) + 4 * full
	_check(fc.size() == 4 and int(fc[3]["v"]) == want and want == 70 and str(fc[3]["band"]) == "Loyal" and int(fc[3]["week"]) == 4,
		"Tess dealt in full every week: %d and Loyal at week 4" % want)
	_check(int(fc[2]["v"]) == want - full and str(fc[2]["band"]) == "Settled", "week 3: still Settled")
	_check(str(tess) == snap and not tess.has("loyalty") and not tess.has("loyalty_log"), "the forecast never touches Tess")
	var line := Loyalty.forecast_line(tess, ["full_week"], 0)
	_check(line == "%d now; as dealt %d in 4 weeks, Loyal in 4" % [_trait(tess), want], "the line: %s" % line)
	var short: int = int(Loyalty.MOVES["short"])
	var running: int = int(Loyalty.MOVES["short_running"])
	var low := _trait(tess) + short + 3 * running
	var sl := Loyalty.forecast_line(tess, ["short"], 0)
	_check(sl == "%d now; as dealt %d in 4 weeks, Wavering in 4" % [_trait(tess), low], "short every week, the band down: %s" % sl)
	var kira := _prospect("kira")
	var need: int = int(float(Loyalty.LOYAL_AT - _trait(kira)) / float(full))
	var kl := Loyalty.forecast_line(kira, ["full_week"], 0)
	_check(need <= Loyalty.FORECAST_WEEKS and kl.ends_with(", Loyal in %d" % need), "Kira reaches Loyal inside 12 weeks: %s" % kl)
	var danny := _prospect("danny")
	danny["loyalty"] = Loyalty.LOYAL_AT - Loyalty.FORECAST_WEEKS * full - 1
	var dv := int(danny["loyalty"])
	var dl := Loyalty.forecast_line(danny, ["full_week"], 0)
	_check(dl == "%d now; as dealt %d in 4 weeks" % [dv, dv + 4 * full], "not reached in 12 weeks: no band named (%s)" % dl)
	var josh := _prospect("josh")
	Loyalty.apply(josh, "talk_back", 0)
	var js := str(josh)
	var jn := Loyalty.log_of(josh).size()
	Loyalty.forecast(josh, ["held_pads", "short"], 6, 7)
	_check(str(josh) == js and Loyalty.log_of(josh).size() == jn, "a fighter with a log: f and the log unchanged after a forecast")


func _talks() -> void:
	var danny := _prospect("danny")
	danny["loyalty"] = Loyalty.SETTLED_AT - 1
	_check(Loyalty.wants_word(danny, 0), "Danny at 49 wants a word")
	var r := Loyalty.apply(danny, "word_card", 0)
	_check(int(r["delta"]) == 0 and str(Loyalty.log_of(danny).back()["why"]) == "word_card", "the word card is logged, moves nothing")
	_check(not Loyalty.wants_word(danny, 0) and not Loyalty.wants_word(danny, 27) and Loyalty.wants_word(danny, 28),
		"once in 28 days: not on day 0 or 27, again on day 28")
	var settled := _prospect("josh")
	settled["loyalty"] = Loyalty.SETTLED_AT
	_check(not Loyalty.wants_word(settled, 0), "at 50: no word card")
	var kira := _prospect("kira")
	_check(Loyalty.can_tell_straight(kira, 0), "Kira: tell it straight is open")
	Loyalty.apply(kira, "talk_straight_landed", 0)
	_check(not Loyalty.can_tell_straight(kira, 1) and not Loyalty.can_tell_straight(kira, 55) and Loyalty.can_tell_straight(kira, 56),
		"after a straight talk: closed to day 55, open on day 56")
	var sam := _prospect("samira")
	Loyalty.apply(sam, "talk_straight_failed", 10)
	_check(not Loyalty.can_tell_straight(sam, 65) and Loyalty.can_tell_straight(sam, 66), "a failed straight talk closes it 56 days too")


func _leaving() -> void:
	var one := _prospect("danny")
	one["loyalty"] = 20
	Loyalty.apply(one, "talk_back", 0)
	_check(Loyalty.value(one) == 24 and not Loyalty.leaves(one, 7), "Danny at 24 after one talk stays (%d)" % Loyalty.value(one))
	var two := _prospect("tess")
	two["loyalty"] = 16
	Loyalty.apply(two, "talk_back", 0)
	Loyalty.apply(two, "talk_back", 7)
	_check(Loyalty.value(two) == 24 and Loyalty.leaves(two, 14), "Tess at 24 after two talks leaves (%d)" % Loyalty.value(two))
	var early := _prospect("kira")
	early["loyalty"] = 33
	Loyalty.apply(early, "talk_straight_failed", 0)
	Loyalty.apply(early, "talk_straight_failed", 7)
	Loyalty.apply(early, "short", 14)
	_check(Loyalty.value(early) == 22 and not Loyalty.leaves(early, 21), "two talks before going under 25 do not count (%d)" % Loyalty.value(early))
	var josh := _prospect("josh")
	_check(not Loyalty.leaves(josh, 0), "Josh (Loyal) never leaves")


func _pro_and_pads() -> void:
	var sam := _prospect("samira")
	sam["loyalty"] = Loyalty.SETTLED_AT
	_check(is_equal_approx(Loyalty.pro_share(sam), ProDebut.MANAGER + ProDebut.TRAINER),
		"at 50 the club keeps manager + trainer (%.2f)" % Loyalty.pro_share(sam))
	var josh := _prospect("josh")
	josh["loyalty"] = Loyalty.SETTLED_AT - 1
	_check(is_equal_approx(Loyalty.pro_share(josh), ProDebut.TRAINER), "at 49 an outside manager: the trainer's share alone (%.2f)" % Loyalty.pro_share(josh))
	var loyal := _prospect("josh")
	var tess := _prospect("tess")
	_check(Loyalty.can_hold_pads(loyal, 6) and not Loyalty.can_hold_pads(loyal, 5), "Josh (70): holds pads at 6 bouts, not at 5")
	_check(not Loyalty.can_hold_pads(tess, 10), "Tess (66, Settled) cannot hold pads at 10 bouts")


func _log() -> void:
	var kira := _prospect("kira")
	var causes := ["full_week", "short", "talk_back", "sponsor_given", "held_pads"]
	for i in causes.size():
		Loyalty.apply(kira, str(causes[i]), int(i) * 7)
	var book := Loyalty.log_of(kira)
	var keyed := true
	for e in book:
		if not (e.has("d") and e.has("n") and e.has("why")):
			keyed = false
	_check(book.size() == causes.size() and keyed, "every log entry has d, n and why (%d entries)" % book.size())
	var rs := Loyalty.reasons(kira, 14)
	_check(rs.size() == 3 and int(rs[0]["d"]) == 28 and str(rs[0]["why"]) == "held_pads" and int(rs[1]["d"]) == 21 and int(rs[2]["d"]) == 14,
		"reasons since day 14: three, newest first")
	_check(rs.size() == 3 and (rs[0] as Dictionary).size() == 3 and rs[0].has("n"), "a reason is {d, n, why}")
	var samira := _prospect("samira")
	for j in 45:
		Loyalty.apply(samira, "full_week", int(j) * 7)
	var kept := Loyalty.log_of(samira)
	_check(kept.size() == Loyalty.LOG_KEEP and int(kept[0]["d"]) == 5 * 7, "the newest 40 kept (%d)" % kept.size())


## Counts a failure only for the real apply; returns 1 when the assert fails.
func _soft(real: bool, ok: bool, what: String) -> int:
	if real:
		_check(ok, what)
	return 0 if ok else 1


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
