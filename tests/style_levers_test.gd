extends SceneTree
## S488 STYLE5 - the points lever and real counters.
## (a) points() pure: each style in situation returns pts, outside returns 0, unnamed returns 0.
## (b) 3 bouts with a named Slugger: COUNTS reads > 0 and applied > 0.
## (c) 3 bouts with same fighter unnamed: no count moved.

const StyleLevers := preload("res://scripts/rules/StyleLevers.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Career := preload("res://scripts/state/Career.gd")

var failures := 0
var cur_plan: Array = []


func _initialize() -> void:
	_check_pure()
	StyleLevers.reset_counts()
	_check_bouts_named()
	StyleLevers.reset_counts()
	_check_bouts_unnamed()
	print("STYLE_LEVERS PASS fails=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check_pure() -> void:
	var f_out := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}, "named_style": "Out-boxer"}
	_check(is_equal_approx(StyleLevers.points(f_out, Duels.LONG, "range", "steady", ""), 1.5), "Out-boxer at LONG")
	_check(is_equal_approx(StyleLevers.points(f_out, Duels.POCKET, "range", "steady", ""), 0.0), "Out-boxer POCKET 0")
	var f_vp := {"moves": {"Jab": 60.0, "Cross": 60.0}, "steps": {"pivot_out": 60.0}, "named_style": "Volume puncher"}
	_check(is_equal_approx(StyleLevers.points(f_vp, Duels.LONG, "range", "push", ""), 0.2), "Volume vs range mode")
	_check(is_equal_approx(StyleLevers.points(f_vp, Duels.LONG, "range", "steady", ""), 0.0), "Volume at steady pace 0")
	var f_bp := {"moves": {"Cross": 61.0, "Uppercut": 60.0}, "steps": {"step_in": 60.0}, "named_style": "Boxer-puncher"}
	_check(is_equal_approx(StyleLevers.points(f_bp, Duels.POCKET, "range", "steady", ""), 2.1), "BP at POCKET")
	_check(is_equal_approx(StyleLevers.points(f_bp, Duels.LONG, "range", "steady", ""), 0.0), "BP at LONG 0")
	var f_pf := {"moves": {"Body hook": 60.0}, "steps": {"step_in": 60.0, "tie_up": 60.0}, "named_style": "Pressure fighter"}
	_check(is_equal_approx(StyleLevers.points(f_pf, Duels.INSIDE, "range", "steady", ""), 2.6), "PF at INSIDE")
	_check(is_equal_approx(StyleLevers.points(f_pf, Duels.POCKET, "range", "steady", ""), 0.0), "PF at POCKET 0")
	_check(is_equal_approx(StyleLevers.points(f_pf, Duels.LONG, "range", "steady", ""), 0.0), "PF at LONG 0")
	var f_sl := {"moves": {"Body hook": 60.0, "Lead hook": 60.0}, "steps": {"roll_out": 60.0}, "named_style": "Slugger"}
	_check(is_equal_approx(StyleLevers.points(f_sl, Duels.POCKET, "range", "steady", "Lead hook"), 5.0), "Slugger POCKET+hook")
	_check(is_equal_approx(StyleLevers.points(f_sl, Duels.POCKET, "range", "steady", ""), 5.0), "Slugger POCKET no arrow")
	_check(is_equal_approx(StyleLevers.points(f_sl, Duels.LONG, "range", "steady", "Lead hook"), 0.0), "Slugger LONG 0")
	_check(is_equal_approx(StyleLevers.points(f_sl, Duels.POCKET, "range", "steady", "Jab"), 0.0), "Slugger POCKET non-power 0")
	var f_cp := {"moves": {"Lead hook": 60.0, "Check hook": 60.0}, "steps": {"step_out": 60.0}, "named_style": "Counter-puncher"}
	_check(is_equal_approx(StyleLevers.points(f_cp, Duels.LONG, "press", "steady", ""), 2.0), "CP vs press")
	_check(is_equal_approx(StyleLevers.points(f_cp, Duels.LONG, "loadup", "steady", ""), 2.0), "CP vs loadup")
	_check(is_equal_approx(StyleLevers.points(f_cp, Duels.LONG, "range", "steady", ""), 0.0), "CP vs range 0")
	var f_none := {"moves": {}, "steps": {}}
	_check(is_equal_approx(StyleLevers.points(f_none, Duels.LONG, "press", "push", "Lead hook"), 0.0), "unnamed 0")


func _check_bouts_named() -> void:
	_build_plan()
	for _bi in 6:
		_run_bout(9000 + _bi, "Pressure fighter", true)
	var sl: Variant = StyleLevers.COUNTS.get("Slugger", [0, 0])
	_check(int(sl[0]) > 0, "named Slugger reads > 0 (%d)" % int(sl[0]))
	_check(int(sl[1]) > 0, "named Slugger applied > 0 (%d)" % int(sl[1]))


func _check_bouts_unnamed() -> void:
	_build_plan()
	for _bi in 6:
		_run_bout(9000 + _bi, "Pressure fighter", false)
	for style in StyleLevers.COUNTS:
		var c: Array = StyleLevers.COUNTS[style]
		_check(int(c[0]) == 0 and int(c[1]) == 0, "unnamed: %s zero" % style)


func _build_plan() -> void:
	cur_plan = [{"move": "Lead hook"}, {"move": "Body hook"}, {"move": "1-1-2", "when": "press"},
		{"move": "2-3", "when": "range"}, {"move": "1-2-3b", "when": "range"}, {"move": "slip 2-3", "when": "loadup"}]


func _run_bout(seed_offset: int, opp_style: String, use_named: bool) -> void:
	var c := Career.quick_start()
	var f := _make_person(7200 + (seed_offset % 20), false)
	f["camp"] = {}; f["morale"] = 60.0; f["arrows"] = cur_plan.duplicate(true)
	var mv_d: Dictionary = (f["moves"] as Dictionary).duplicate()
	var st_d: Dictionary = (f["steps"] as Dictionary).duplicate()
	for mv in MoveTree.STYLES["Slugger"]:
		if MoveTree.PUNCH_IDS.has(str(mv)): mv_d[str(mv)] = 60.0
		else: st_d[str(mv)] = 60.0
	f["moves"] = mv_d; f["steps"] = st_d
	var co_d: Dictionary = {}
	for k in MoveTree.COMBO_PUNCHES: co_d[k] = 45.0
	for mv in MoveTree.STYLES["Slugger"]:
		if MoveTree.PUNCH_IDS.has(str(mv)):
			for cid in MoveTree.COMBO_PUNCHES:
				if (MoveTree.COMBO_PUNCHES[cid] as Array).has(str(mv)): co_d[cid] = 60.0
	f["combos"] = co_d
	if use_named:
		f["named_style"] = "Slugger"
	c.coach = {}
	f["bout"] = {"opp": _make_person(0, true, opp_style), "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "": break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")


func _make_person(seed_val: int, is_opp: bool, opp_style: String = "") -> Dictionary:
	var rng_local := RandomNumberGenerator.new()
	rng_local.seed = seed_val if not is_opp else opp_style.hash()
	var prof := AttrGen.generate(rng_local)
	var first: String = ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Maria", "Priya", "Erin", "Dana", "Kalli"][rng_local.randi_range(0, 5)] if not is_opp else ["Maria", "Priya", "Erin", "Dana", "Kalli", "Jade"][["Out-boxer", "Volume puncher", "Boxer-puncher", "Pressure fighter", "Slugger", "Counter-puncher"].find(opp_style)]
	var last: String = ["Smith", "Jones", "Brown", "Wilson", "Taylor", "Davies"][rng_local.randi_range(0, 5)]
	var tech := clampf(50.0 + prof["shape"].get("accuracy", 0.0) * 0.5, 30.0, 80.0)
	var fiq := clampf(50.0 + prof["shape"].get("fight_iq", 0.0) * 0.5, 30.0, 80.0)
	var fw := clampf(50.0 + prof["shape"].get("footwork", 0.0) * 0.5, 30.0, 80.0)
	var f := {"id": "p_%d" % seed_val, "name": "%s %s" % [first, last], "first": first, "sex": "f",
		"age": 22, "wc": "Lightweight", "limit": 60.0, "weight": 60.0, "stance": "orthodox",
		"style": AttrGen.style_word(prof), "w": 3, "l": 1, "pot": 70, "cards": [], "focus": "conditioning",
		"div": "wlw", "diet": "hold", "fatigue": 8, "weekly_salary": 250, "booked_fight": false, "history": [],
		"stats": {"power": 55.0, "speed": 55.0, "technique": tech, "defense": 55.0, "conditioning": 55.0, "fight_iq": fiq, "chin": 55.0},
		"goal": {}, "shape": prof["shape"], "pace": float(prof["pace"]), "forward": float(prof["forward"]),
		"heart": float(prof["heart"]), "footwork": fw}
	if is_opp:
		f["rating"] = 65.0; f["threat"] = "Everything"; f["weak"] = "None"
	return Data.fighter_state(f, 100 if is_opp else 40 + (seed_val - 7200))


func _check(cond: bool, label: String) -> void:
	if cond: print("PASS ", label)
	else: failures += 1; print("FAIL ", label)
