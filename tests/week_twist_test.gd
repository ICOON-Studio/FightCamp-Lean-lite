extends SceneTree
## S356 the twist card as a choice (WeekTwist CHOICES; operator Q-S294-83 "Yes, build it", the Miro draft):
##   1. the draw: about 1 week in 4 a small no-choice card, a card that needs something (a cut, a bout, a southpaw) only
##      when her week holds it, never the same card twice running,
##   2. the answer: the coach's call until one is picked, changeable until Monday locks it, a new card starts unanswered,
##   3. each answer's price reaches the game: the week it leaves (rest, Light, a sparring night), the money and morale on
##      Monday, the weight and fatigue in the week's numbers, the injury roll, the pads, and on the night the lefty's edge.
## Population: Lucy Jackson (Data.lucy) vs Maria Ortega (Data.OPPONENTS[0], southpaw) and Priya Nair (OPPONENTS[1], orthodox).

const Data := preload("res://scripts/state/Data.gd")
const WT := preload("res://scripts/rules/WeekTwist.gd")
const WP := preload("res://scripts/rules/WeekPlan.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

var _fails := 0


func _initialize() -> void:
	_draw()
	_answer()
	_week()
	_monday()
	_risk()
	_night()
	print("WEEK_TWIST %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _draw() -> void:
	var quiet := 0
	var needy := false
	var all := {}
	for w in 400:
		var t := WT.draw(w)
		quiet += int(not t.has("a"))
		needy = needy or t.has("needs")
		all[WT.draw(w, "", false, ["bout", "cut", "combo", "southpaw", "swap"])["id"]] = true
	_check(quiet > 60 and quiet < 140, "a small no-choice card about 1 week in 4 (%d of 400)" % quiet)
	# S357 the short-notice swap is rare: only when a swap can happen, about RARE_SHARE of those weeks.
	var swaps := 0
	for w in 400:
		swaps += int(str(WT.draw(w, "", false, ["bout", "swap"])["id"]) == "short_notice")
	_check(swaps > 25 and swaps < 75, "the short-notice swap is rare: %d of 400 weeks that allow one" % swaps)
	_check(not needy, "nothing in her week: no card that needs a cut, a bout, a combo or a southpaw")
	_check(WT.CHOICES.all(func(t): return all.has(t["id"])), "with all of them, every choice card comes up")


func _answer() -> void:
	var f := {"twist": "tight_knee"}
	_check(WT.answer(f) == "a" and str(WT.active(f)["label"]) == "Rest it", "no answer: the coach's call (rest the knee)")
	_check(WT.pick(f, "b") and WT.answer(f) == "b" and int(WT.active(f)["risk"]) == 2, "picked: push through, twice the risk")
	var once := WT.lock(f)
	_check(bool(f["twist_locked"]) and not WT.pick(f, "a") and WT.answer(f) == "b", "Monday locks it")
	WT.deal(f, WT.card("heating"))
	_check(not bool(f["twist_locked"]) and not f.has("twist_pick") and WT.answer(f) == "a", "a new card starts unanswered")
	_check(WT.answer({"twist": "rain"}) == "" and WT.lock({"twist": "rain"}).is_empty(), "a no-choice card has no answer")


func _week() -> void:
	var days := [["roadwork", "normal"], ["heavy_bag", "hard"], ["intervals", "hard"], ["speed_bag", "light"], ["roadwork", "normal"],
		["strength", "normal"], ["rest", "normal"]]
	var evs := ["pads", "pads", "pads", "sparring", "pads", "pads", "rest"]
	var knee := WT.days(WT.active({"twist": "tight_knee"}), days)
	_check(knee[1] == ["rest", "normal"] and knee[2] == ["intervals", "hard"], "rest the knee: the first Hard morning is a rest day")
	var cold := WT.days(WT.active({"twist": "heating", "twist_pick": "b"}), days)
	_check(cold.all(func(d): return str(d[0]) == "rest" or str(d[1]) == "light"), "the heating waits: every morning Light")
	var lefty := WT.active({"twist": "southpaw"})
	_check(WT.days(lefty, days)[2] == ["rest", "normal"] and WT.evenings(lefty, evs)[2] == "sparring", "the lefty: Wednesday morning off, a sparring night")
	_check(WT.evenings(WT.active({"twist": "photoshoot"}), evs)[3] == "rest", "the photoshoot takes Thursday evening")
	var night := WT.active({"twist": "night_off"})
	_check(WT.days(night, days)[5] == ["rest", "normal"] and WT.evenings(night, evs)[5] == "rest", "her night off: Saturday rests")
	# The scale: cut harder vs trust the process, through the sim's own week numbers.
	var c := _career()
	var f: Dictionary = c.fighter()
	f["diet"] = "cut"
	f["twist"] = "scale_stuck"
	var harder := WP.week(days, Sim.week_ctx(c, f), evs)
	f["twist_pick"] = "b"
	var trust := WP.week(days, Sim.week_ctx(c, f), evs)
	var gap := float(trust["weight_end"]) - float(harder["weight_end"])
	_check(gap > 0.4 and gap < 0.6 and float(harder["peak"]) > float(trust["peak"]), "cut harder: %.2f kg lighter by Sunday, more tired" % gap)


func _monday() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	var cash := c.cash
	f["twist"] = "heating"
	Sim.twist_monday(c, f)
	_check(c.cash == cash - 600, "fix the heating: $600 on Monday")
	var c2 := _career()
	var f2: Dictionary = c2.fighter()
	var m0 := float(f2.get("morale", 60.0))
	f2["twist"] = "night_off"
	WT.pick(f2, "b")
	Sim.twist_monday(c2, f2)
	_check(float(f2["morale"]) < m0, "say no to the night off: morale %.0f -> %.0f" % [m0, float(f2["morale"])])
	var c3 := _career()
	var f3: Dictionary = c3.fighter()
	_book(c3, f3, 0)
	var members := c3.members
	f3["twist"] = "trash_talk"
	WT.pick(f3, "a")
	Sim.twist_monday(c3, f3)
	_check(c3.members == members + 3 and bool(f3["bout"].get("hot", false)), "fire back: +3 members, a hot head on the night")
	_swap()


## S357 the short-notice swap (the last card of the Miro draft): only 2+ weeks out; take it = a tougher opponent on the same
## night, the tape study from today, twice the reputation on a win; withdraw = the bout and the camp end.
func _swap() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	_book(c, f, 0)
	f["bout"]["day"] = c.day + 21
	f["camp"] = {"focus": "boxing", "protocol": 1, "film": true, "start": c.day - 7, "tapes": 2}
	_check(Sim.twist_needs(f, c).has("swap"), "Maria 3 weeks out: a swap can come up")
	var near := c.day + 10
	var day0 := int(f["bout"]["day"])
	f["bout"]["day"] = near
	_check(not Sim.twist_needs(f, c).has("swap"), "10 days out: no swap card")
	f["bout"]["day"] = day0
	f["twist"] = "short_notice"
	Sim.twist_monday(c, f)   # no answer: the coach takes the fight
	var opp: Dictionary = f["bout"]["opp"]
	_check(str(opp["name"]) == "Priya Nair" and float(opp["rating"]) > float(Data.OPPONENTS[0]["rating"]),
		"take it: Maria (%.1f) out, Priya (%.1f) in - the next step up" % [float(Data.OPPONENTS[0]["rating"]), float(opp["rating"])])
	_check(int(f["bout"]["day"]) == day0 and int(f["camp"]["tape_start"]) == c.day and int(f["camp"]["start"]) == c.day - 7 and int(f["camp"]["tapes"]) == 0,
		"the same night; the tape study starts again today, the camp keeps its week count")
	var won := false
	for s in 40:
		var cw := _career()
		cw.seed = 9000 + s
		# The bout rolls on the day. Forty seeds on day 28 are one night; forty days are forty nights.
		cw.day = 28 + s
		var fw: Dictionary = cw.fighter()
		_book(cw, fw, 1)
		fw["bout"]["short_notice"] = true
		var r0 := cw.reputation
		var mw := BoutNight.fight_modal(fw)
		BoutNight.fight_step(cw, fw, mw, "sim")
		if str(mw.get("outcome", "")) == "win":
			_check(cw.reputation - r0 == 2 * BoutRules.WIN_REPUTATION, "a short-notice win: +%d reputation (twice %d)" % [cw.reputation - r0, BoutRules.WIN_REPUTATION])
			won = true
			break
	_check(won, "a short-notice win reached in 40 nights")
	var c2 := _career()
	var f2: Dictionary = c2.fighter()
	_book(c2, f2, 0)
	f2["bout"]["day"] = c2.day + 21
	f2["camp"] = {"focus": "boxing", "protocol": 1, "film": false, "start": c2.day - 7}
	f2["twist"] = "short_notice"
	WT.pick(f2, "b")
	Sim.twist_monday(c2, f2)
	_check((f2["bout"] as Dictionary).is_empty() and (f2["camp"] as Dictionary).is_empty() and int(f2["next_offer_day"]) > c2.day,
		"withdraw: the bout and the camp end, offers come again later")


func _risk() -> void:
	# Control: a quiet week, the same 600 careers (scrambled seeds - the career seed's own dice). Odds about 3 % a roll here.
	var hurt := [0, 0]
	for k in 2:
		for s in 600:
			var c := _career()
			c.seed = absi(hash("knee%d" % s))
			var f: Dictionary = c.fighter()
			f["twist"] = "quiet" if k == 0 else "tight_knee"
			f["twist_pick"] = "b"
			f["chronic"] = 4.0   # a week well over her usual: the roll has something to bite on
			Injuries.end_week(c)
			hurt[k] += int(not (f.get("injury", {}) as Dictionary).is_empty())
	var x := float(hurt[1]) / float(maxi(hurt[0], 1))
	_check(hurt[0] > 5 and x > 1.4 and x < 2.8, "push through: injuries %d vs %d in a quiet week, 600 weeks (x%.2f, about twice)" % [hurt[1], hurt[0], x])


func _night() -> void:
	var base := []
	for lefty in [false, true]:
		for opp in [0, 1]:
			var c := _career()
			var f: Dictionary = c.fighter()
			var m := _book(c, f, opp)
			f["bout"]["lefty"] = lefty
			BoutNight.fight_step(c, f, m, "start")
			base.append(float(LiveRound.live(m)["base"]))
	# S381 C229 stage 3: round 1 without a southpaw in camp also costs BoutRules.NEVER_FACED; the lefty week clears it.
	_check(is_equal_approx(base[2] - base[0], WT.LEFTY_EDGE + BoutRules.NEVER_FACED) and is_equal_approx(base[3], base[1]),
		"the lefty week: +%.1f in round 1 vs southpaw Maria (its edge + 'never faced a southpaw' gone), nothing vs orthodox Priya"
		% (base[2] - base[0]))


func _career() -> Career:
	var c := Career.quick_start()
	c.seed = 356
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 28
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	return c


func _book(c: Career, f: Dictionary, opp: int) -> Dictionary:
	f["bout"] = {"opp": (Data.OPPONENTS[opp] as Dictionary).duplicate(true), "day": c.day + 14, "weighed": true, "made": true, "done": false, "film": 1}
	return {"fid": f["id"], "step": "tape", "total": 3}


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
