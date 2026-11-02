extends SceneTree
## S354 CORE3 step 1 WeekPlan: seven mornings {session, intensity} -> gains, kg, fatigue, and where the camp lands vs the
## goal. Population: one amateur lightweight (61.0 kg, conditioning 58, power 55, potential 80, coach 60), diet hold / cut.

const WP := preload("res://scripts/rules/WeekPlan.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")

var _fails := 0


func _ctx(diet: String = "hold", fatigue: float = 20.0) -> Dictionary:
	return {"stats": {"power": 55.0, "speed": 57.0, "technique": 60.0, "defense": 52.0, "conditioning": 58.0, "fight_iq": 50.0,
		"chin": 62.0}, "pot": 80, "coach": 60.0, "weight": 61.0, "diet": diet, "fatigue": fatigue}


func _initialize() -> void:
	print("population: 61.0 kg amateur lightweight, conditioning 58, potential 80, coach 60")
	for id in WP.ORDER:
		_check(WP.SESSIONS.has(id), "session %s exists" % id)
	var rest := WP.day("rest", "normal", _ctx(), 20.0)
	_check(float(rest["gain"]) == 0.0 and float(rest["kcal"]) == 0.0 and float(rest["fatigue"]) < 20.0,
		"rest: no gain, no burn, fatigue drains (%.1f)" % float(rest["fatigue"]))
	var road := WP.day("roadwork", "normal", _ctx(), 20.0)
	_check(absf(float(road["kcal"]) - 9.8 * 61.0 * 0.75) < 1.0, "roadwork at 61 kg burns MET x kg x h = %.0f kcal" % float(road["kcal"]))
	var light := WP.day("roadwork", "light", _ctx(), 20.0)
	var hard := WP.day("roadwork", "hard", _ctx(), 20.0)
	_check(float(hard["gain"]) > float(road["gain"]) and float(road["gain"]) > float(light["gain"]), "gain: hard > normal > light")
	_check(float(hard["kg"]) < float(road["kg"]) and float(road["kg"]) < float(light["kg"]), "weight: hard burns most")
	_check(float(hard["fatigue"]) > float(road["fatigue"]) and float(road["fatigue"]) > float(light["fatigue"]), "fatigue: hard costs most")
	var tired := WP.day("roadwork", "normal", _ctx(), 85.0)
	_check(absf(float(tired["gain"]) - float(road["gain"]) * WP.TIRED_GAIN) < 1e-6, "a morning started at 80+ fatigue trains at 0.6")
	# Five normal conditioning mornings ~ a focused conditioning week (one gain rule for the planner and the sim).
	var five := [["roadwork", "normal"], ["roadwork", "normal"], ["roadwork", "normal"], ["roadwork", "normal"],
		["roadwork", "normal"], ["rest", "normal"], ["rest", "normal"]]
	var focused := float(TrainingPreview.plan_gain(_ctx()["stats"], 80, "conditioning", 60.0)["conditioning"])
	var got := float(WP.week(five, _ctx())["gains"].get("conditioning", 0.0))
	_check(absf(got - focused) / focused < 0.15, "5 roadwork mornings = a focused week within 15%% (%.2f vs %.2f)" % [got, focused])
	# The diet: hold keeps her weight, cut loses 0.5-1 % of body weight a week (0.3-0.65 kg at 61 kg).
	var hold := WP.week(WP.COACH_WEEK, _ctx("hold"))
	var cut := WP.week(WP.COACH_WEEK, _ctx("cut"))
	_check(absf(float(hold["kg"])) < 0.3, "hold + the coach's week: weight steady (%+.2f kg)" % float(hold["kg"]))
	_check(float(cut["kg"]) <= -0.3 and float(cut["kg"]) >= -0.65, "cut + the coach's week: %.2f kg (0.5-1 %% of 61 kg)" % float(cut["kg"]))
	# Fatigue: the coach's week stays under 80; six hard mornings overreach, and hard after hard is a red day.
	_check(float(hold["peak"]) < WP.OVERREACHED and (hold["red"] as Array).is_empty(), "coach's week peaks at %.0f, no red day" % float(hold["peak"]))
	var greedy := [["intervals", "hard"], ["roadwork", "hard"], ["heavy_bag", "hard"], ["intervals", "hard"],
		["roadwork", "hard"], ["strength", "hard"], ["rest", "normal"]]
	var g := WP.week(greedy, _ctx())
	_check(float(g["peak"]) >= WP.OVERREACHED and (g["red"] as Array).size() == 5, "six hard mornings overreach (peak %.0f), five red days" % float(g["peak"]))
	# The goal: the camp lands where the dials say, and turning two mornings to hard moves the lines.
	var goal := {"limit": 59.4, "stat": "conditioning", "target": 61.0}
	var lines := WP.goal_lines(goal, WP.COACH_WEEK, _ctx("cut"), 4)
	_check(lines.size() == 3 and str(lines[0]["id"]) == "weight" and str(lines[2]["id"]) == "fatigue", "three goal lines: weight, stat, fatigue")
	var p := WP.project(WP.COACH_WEEK, _ctx("cut"), 4)
	_check(absf(float(lines[0]["end"]) - float(p["weight"])) < 1e-6 and float(lines[0]["week"]) < 61.0, "the weight line: week 1 %.2f, weigh-in %.2f" % [float(lines[0]["week"]), float(lines[0]["end"])])
	var harder: Array = WP.COACH_WEEK.duplicate(true)
	harder[0] = ["roadwork", "hard"]
	harder[2] = ["intervals", "hard"]
	var lines2 := WP.goal_lines(goal, harder, _ctx("cut"), 4)
	_check(float(lines2[1]["end"]) > float(lines[1]["end"]) and float(lines2[0]["end"]) < float(lines[0]["end"]),
		"two hard mornings: conditioning %.2f -> %.2f, weigh-in %.2f -> %.2f kg" % [float(lines[1]["end"]), float(lines2[1]["end"]),
		float(lines[0]["end"]), float(lines2[0]["end"])])
	var c := _ctx()
	WP.week(WP.COACH_WEEK, c)
	_check(float(c["stats"]["conditioning"]) == 58.0 and float(c["weight"]) == 61.0, "the plan never changes the fighter it reads")
	print("WEEK_PLAN %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])
