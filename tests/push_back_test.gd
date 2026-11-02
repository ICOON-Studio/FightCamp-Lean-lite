extends SceneTree
## S361 she pushes back (PushBack + WeekTwist.ASKS + FighterProfile trust):
##   1. her reasons come from who she is: low discipline + a Hard morning -> ease off; a pressure fighter -> the bag;
##      fades late -> running; 75+ fatigue peak last week -> a day off (and that one comes first); no Hard morning, no
##      "ease off" (an ask that changes nothing is never asked),
##   2. a fighter who takes orders badly asks more often than one who takes them well (bounded shares over 300 weeks),
##      never last week's card twice,
##   3. her way changes the week (rest day, Hard -> Normal, extra sparring); the card speaks in her name,
##   4. overruled costs morale, more for low coachability; heard gains it,
##   5. morale is trust: Fired up 1.05 / Steady 1.0 / Flat 0.85 / Low 0.7 of the corner's word,
##   6. control arm: WeekTwist.draw never deals an ask by itself (only PushBack does).
## Population: Lucy Jackson (Data.lucy, out-boxer) and Maria Ortega (a pressure fighter, set by hand below).

const Data := preload("res://scripts/state/Data.gd")
const PushBack := preload("res://scripts/rules/PushBack.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

var _fails := 0


func _initialize() -> void:
	var lucy := Data.fighter_state(Data.lucy(), 0)
	var maria := {"id": "maria_ortega", "first": "Maria", "name": "Maria Ortega"}
	lucy["personality"] = {"discipline": 40.0, "confidence": 50.0, "temper": 40.0, "coachability": 30.0, "heart": 60.0}
	lucy["habits"] = ["fades_late", "low_lead_hand"]
	maria["personality"] = {"discipline": 70.0, "confidence": 50.0, "temper": 50.0, "coachability": 85.0, "heart": 60.0}
	maria["habits"] = ["head_down_inside", "wide_hook_tell"]
	maria["style"] = "Pressure fighter"
	var days := [["roadwork", "normal"], ["heavy_bag", "hard"], ["intervals", "normal"], ["speed_bag", "light"],
		["shadow", "normal"], ["slip_rope", "light"], ["rest", "normal"]]
	var evs := WeekPlan.evenings_for(1)
	# 1. reasons
	var r := PushBack.reasons(lucy, days, evs, 50.0)
	_check(r.has("ask_easy") and r.has("ask_road") and not r.has("ask_bag") and not r.has("ask_rest"), "Lucy (discipline 40, fades late): %s" % [r])
	var m := PushBack.reasons(maria, days, evs, 50.0)
	_check(m == ["ask_bag"], "Maria (pressure fighter, disciplined): %s" % [m])
	_check(PushBack.reasons(maria, days, evs, 80.0).has("ask_rest"), "a 80 fatigue peak last week: a day off")
	var soft: Array = days.map(func(d): return [d[0], "normal" if d[1] == "hard" else d[1]])
	_check(not PushBack.reasons(lucy, soft, evs, 50.0).has("ask_easy"), "no Hard morning: no 'ease off'")
	var tired := 0
	for w in 300:
		var p := PushBack.pick(lucy, w, days, evs, 80.0)
		if p != "":
			tired += 1
			if p != "ask_rest":
				_check(false, "week %d: worn out, yet the ask is %s" % [w, p])
				break
	_check(tired > 0, "worn out: the day off comes first (%d asks)" % tired)
	# 2. how often
	var low := 0
	var high := 0
	for w in 300:
		low += 1 if PushBack.pick(lucy, w, days, evs, 50.0) != "" else 0
		high += 1 if PushBack.pick(maria, w, days, evs, 50.0) != "" else 0
		if PushBack.pick(lucy, w, days, evs, 50.0, "ask_road") == "ask_road":
			_check(false, "week %d: last week's card again" % w)
			break
	_check(low > 120 and low < 190 and high > 40 and high < 110 and low > high,
		"coachability 30 asks %d of 300 weeks, coachability 85 asks %d" % [low, high])
	# 3. her way changes the week
	lucy["twist"] = "ask_rest"
	lucy["first"] = "Lucy"
	WeekTwist.pick(lucy, "a")
	var a := WeekTwist.active(lucy)
	_check(str(a["name"]) == "Lucy asks for a day off" and WeekTwist.days(a, days)[5][0] == "rest" and WeekTwist.evenings(a, evs)[5] == "rest",
		"her way: Saturday off (%s)" % a["name"])
	lucy["twist"] = "ask_easy"
	WeekTwist.pick(lucy, "a")
	_check(not WeekTwist.days(WeekTwist.active(lucy), days).any(func(d): return d[1] == "hard"), "ease off: no Hard morning left")
	lucy.erase("twist_pick")
	_check(WeekTwist.answer(lucy) == "b" and WeekTwist.days(WeekTwist.active(lucy), days) == days, "no answer: the plan stands (overruled)")
	lucy["twist"] = "ask_spar"
	WeekTwist.pick(lucy, "a")
	_check(WeekTwist.evenings(WeekTwist.active(lucy), evs)[4] == "sparring", "spar Friday: Friday evening is sparring")
	# 4. morale
	lucy["morale"] = 60.0
	maria["morale"] = 60.0
	var dl := float(FighterProfile.apply_morale(lucy, "overruled", "x")["delta"])
	var dm := float(FighterProfile.apply_morale(maria, "overruled", "x")["delta"])
	_check(dl < dm and dm < 0.0, "overruled: coachability 30 loses %.1f, coachability 85 loses %.1f" % [dl, dm])
	_check(float(FighterProfile.apply_morale(lucy, "heard", "x")["delta"]) > 0.0, "heard: morale up")
	# 5. trust
	var tr := []
	for mo in [80.0, 60.0, 40.0, 20.0]:
		lucy["morale"] = mo
		tr.append(FighterProfile.trust(lucy))
	_check(tr == [1.05, 1.0, 0.85, 0.7], "trust by mood: %s" % [tr])
	# 6. control arm
	var dealt := false
	for w in 400:
		if bool(WeekTwist.draw(w, "", false, ["bout", "cut", "combo", "southpaw", "swap"]).get("ask", false)):
			dealt = true
	_check(not dealt, "WeekTwist.draw alone never deals an ask")
	print("PUSH_BACK %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
