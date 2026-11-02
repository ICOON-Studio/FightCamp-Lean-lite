extends SceneTree
## S354 the RPG recruit (Recruit) and the perk road (PerkRoad): class, potential stars, ceilings, traits, signature, the
## one starting focus at signing, the habit trained out in 4 weeks, perks opening with training.
## Population: the quick start's walk-in (Career.quick_start applicant) and two hand-made fighters that differ in style,
## stats and personality.

const R := preload("res://scripts/rules/Recruit.gd")
const P := preload("res://scripts/rules/PerkRoad.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Roster := preload("res://scripts/state/Roster.gd")

var _fails := 0


func _fighter(style: String, stats: Dictionary, pot: int, pers: Dictionary) -> Dictionary:
	return {"first": "Ana", "style": style, "stats": stats, "pot": pot, "personality": pers, "w": 3, "l": 1,
		"moves": {"Jab": 34.0, "Cross": 22.0, "Body hook": 28.0}, "habits": ["slow_starter", "drops_right_after_jab"]}


func _initialize() -> void:
	var st := {"power": 58.0, "speed": 63.0, "technique": 60.0, "defense": 57.0, "conditioning": 61.0, "fight_iq": 59.0, "chin": 66.0}
	var ob := _fighter("Out-boxer", st, 80, {"heart": 82.0, "temper": 75.0, "confidence": 55.0, "discipline": 50.0, "coachability": 60.0, "loyalty": 40.0})
	var pf := _fighter("Pressure fighter", {"power": 66.0, "speed": 55.0, "technique": 52.0, "defense": 50.0, "conditioning": 68.0,
		"fight_iq": 54.0, "chin": 71.0}, 76, {"heart": 50.0, "temper": 30.0, "confidence": 35.0, "discipline": 78.0, "coachability": 55.0, "loyalty": 60.0})
	print("population: an out-boxer (pot 80, heart 82, temper 75) and a pressure fighter (pot 76, discipline 78, confidence 35)")
	_check(R.class_of("Out-boxer")[0] == "wins at range" and R.class_of("nonsense") == R.CLASSES["Boxer-puncher"], "class from the style, a default for others")
	var s80 := R.stars(80)
	_check(float(s80[1]) - float(s80[0]) == 1.0 and float(s80[0]) >= 1.0 and float(s80[1]) <= 5.0, "potential 80 = a one-star range (%s)" % str(s80))
	_check(float(R.stars(95)[1]) == 5.0 and float(R.stars(50)[0]) == 1.0 and R.stars(80, true)[0] == R.stars(80, true)[1], "stars clamp to 1-5; known = exact")
	_check(R.ceiling(ob, "speed") == 86.0 and R.ceiling(ob, "power") == 74.0 and R.ceiling(ob, "chin") == 80.0, "ceilings: +6 on the class's strength, -6 on its gap")
	_check(R.ceiling(pf, "chin") >= 73.0, "a ceiling is never under now + 2")
	var t1 := R.traits(ob["personality"])
	var t2 := R.traits(pf["personality"])
	_check(str(t1[0][0]) == "Big heart" and str(t1[1][0]) == "Short fuse", "out-boxer: Big heart + Short fuse (%s)" % str(t1))
	_check(str(t2[0][0]) == "Disciplined" and str(t2[1][0]) == "Fragile", "pressure fighter: Disciplined + Fragile (%s)" % str(t2))
	_check(R.signature(ob) == "Jab", "the signature is the sharpest move (Jab 34)")
	var a := ob.duplicate(true)
	R.apply_focus(a, "signature", 0)
	_check(float(a["moves"]["Jab"]) == 44.0, "Sharpen the signature: the jab +10")
	var b := ob.duplicate(true)
	R.apply_focus(b, "habit", 10)
	_check(str(b["habit_fix"]["id"]) == "slow_starter" and int(b["habit_fix"]["until"]) == 38, "Fix the habit: the first habit, 4 weeks")
	var c := ob.duplicate(true)
	R.apply_focus(c, "ceiling", 0)
	_check(int(c["pot"]) == 85, "Raise the ceiling: potential +5")
	_check(R.default_cards("Counter-puncher").has("Defence drills") and R.default_cards("Out-boxer").size() == 3, "the class keeps three week cards for move sharpness")
	# The perk road.
	var road := P.status(pf)
	var by := {}
	for r in road:
		by[r["id"]] = r
	_check(bool(by["iron_chin"]["open"]) and not bool(by["finisher"]["open"]) and bool(by["finisher"]["near"]), "chin 71 opens Iron chin; power 66 is near Finisher (70)")
	_check(not bool(by["body_snatcher"]["open"]) and str(by["body_snatcher"]["need"]).contains("body hook 30"), "a move perk names its move: %s" % str(by["body_snatcher"]["need"]))
	var fresh := P.newly_open(pf, 5)
	_check(fresh.has("Iron chin") and P.newly_open(pf, 6).is_empty(), "a perk opens once (news once)")
	# Signing with a focus through the real career, then 4 weeks of training.
	var career := Career.quick_start()
	var app: Dictionary = career.applicant
	var before_pot := int(Data.fighter_state(app.duplicate(true), career.day)["pot"])
	var f := Roster.sign_fighter(career, app, ["habit"])
	_check(str(f["start_focus"]) == "habit" and (f["cards"] as Array).size() == 3 and f.has("habit_fix"), "signing with a focus: focus kept, class cards, the habit fix booked")
	_check(int(f["pot"]) == before_pot, "Fix the habit leaves the potential alone")
	var habit := str(f["habit_fix"]["id"])
	for d in 29:
		Sim.step_day(career)
	_check(not (f.get("habits", []) as Array).has(habit) and not f.has("habit_fix"), "four weeks later the habit is gone (%s)" % habit)
	var old := Roster.sign_fighter(Career.quick_start(), Career.quick_start().applicant, ["Jab and move", "Pad rounds", "Hill sprints"])
	_check(old["cards"] == ["Jab and move", "Pad rounds", "Hill sprints"] and not old.has("start_focus"), "the old three cards still sign (old saves, tests)")
	print("RECRUIT %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])
