extends SceneTree
## S382 EVENINGS1 (designer: "the strip is the truth"): the evenings the sim runs are PadWeek's nights - a REST evening on
## the strip is rest in the sim (no load, no hours, no award session), the GOAL / LEGS lines and the week review read the
## same evenings.
##   1. PadWeek.evenings: between fights Light / Standard / Hard = 2 / 3 / 4 pad nights + the phase's sparring, the rest REST;
##   2. a camp's Build week with film: the film takes a pad night only in the week that holds it; the taper keeps its pads
##      at half (WeekPlan.full_day load, hours);
##   3. PadWeek.ahead lays every week to come the same way;
##   4. Sim: a week stepped counts exactly the strip's coached nights as award sessions, and a REST evening adds no fatigue.
##   5. (review) the twist cards' evenings hold on the nights: "sparring nights become pads" is a pad night, not REST;
##      the strip's week peek shows the nights of the protocol the sim runs (the camp modal's pick; between fights, the
##      load setting's).
##   6. (S385 skeptic) camp week 2's Monday board is drawn BEFORE the sim's Monday sync: it shows this week's phase (no
##      film night left over from week 1), the nights the sim then runs, and an edit made on it survives Monday's step.

const Data := preload("res://scripts/state/Data.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekStrip := preload("res://scripts/ui/WeekStrip.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")

var failures := 0


func _initialize() -> void:
	_between_fights()
	_camp()
	_ahead()
	_sim_week()
	_twists()
	_strip()
	_monday_board()
	print("EVENINGS failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _lucy() -> Dictionary:
	var f := Data.fighter_state(Data.lucy(), 1)
	f["phase"] = "base"
	return f


func _between_fights() -> void:
	var want := {"light": ["pads", "rest", "pads", "sparring", "rest", "rest", "rest"],
		"normal": ["pads", "rest", "pads", "sparring", "pads", "rest", "rest"],
		"hard": ["pads", "pads", "pads", "sparring", "pads", "rest", "rest"]}
	for load in want:
		var f := _lucy()
		f["load_setting"] = load
		var evs := PadWeek.evenings(f)
		_check(evs == want[load], "%s between fights: %s" % [load, evs])
		var n := PadWeek.nights_of(f)
		_check(evs.count("pads") == (n["pads"] as Array).size() and evs.count("sparring") == (n["spar"] as Array).size(),
			"%s: the evenings are the strip's nights (%s)" % [load, n])
	# The rest evenings are rest: no evening load on top of the morning.
	var ctx := {"stats": _lucy()["stats"], "pot": 70, "weight": 60.0}
	var plain := WeekPlan.day("roadwork", "normal", ctx, 40.0)
	var rested := WeekPlan.full_day("roadwork", "normal", "rest", ctx, 40.0)
	var padded := WeekPlan.full_day("roadwork", "normal", "pads", ctx, 40.0)
	_check(is_equal_approx(float(rested["fatigue"]), float(plain["fatigue"])) and float(padded["fatigue"]) > float(rested["fatigue"]) + 8.0,
		"a REST evening adds nothing (%.1f), a pad night ~8.5 (%.1f)" % [float(rested["fatigue"]), float(padded["fatigue"])])
	# The coach's Standard week keeps its ~8 h (6 mornings + 3 pad nights of 75 min + 1 spar).
	var h := WeekPlan.hours(WeekPhase.week("base", ""), PadWeek.evenings(_lucy()))
	_check(absf(h - 8.0) < 0.3, "the coach's week: %.2f h (~8)" % h)


func _camp() -> void:
	var f := _lucy()
	f["camp"] = {"protocol": 2, "focus": "technique", "film": true, "start": 0}
	f["phase"] = "build"
	f["phase_day"] = 0
	var evs := PadWeek.evenings(f)
	_check(evs.count("film") == 1 and evs.count("pads") == 1 and evs.count("sparring") == 1,
		"Standard camp, Build week with film: 1 pad night, film, 1 spar (%s)" % [evs])
	f["phase_day"] = 7
	var evs2 := PadWeek.evenings(f)
	_check(evs2.count("film") == 0 and evs2.count("pads") == 2, "the camp's second Build week keeps both pad nights (%s)" % [evs2])
	f["camp"]["protocol"] = 3
	_check(PadWeek.evenings(f).count("pads") == 3, "Hard camp: 3 pad nights")
	f["camp"]["protocol"] = 2
	f["phase"] = "taper"
	var tp := PadWeek.evenings(f)
	_check(tp.count("sparring") == 0 and tp.count("pads") == 2 and is_equal_approx(PadWeek.pad_share(f), 0.5),
		"taper: no sparring, 2 pad nights at half (%s)" % [tp])
	var ctx := {"stats": f["stats"], "pot": 70, "weight": 60.0, "phase": "taper", "camp_on": true}
	var rest := float(WeekPlan.full_day("rest", "normal", "rest", ctx, 0.0)["fatigue"])
	var half := float(WeekPlan.full_day("rest", "normal", "pads", ctx, 0.0)["fatigue"]) - rest
	ctx["phase"] = "peak"
	var full := float(WeekPlan.full_day("rest", "normal", "pads", ctx, 0.0)["fatigue"]) - rest
	_check(absf(half - full * 0.5) < 0.001 and full > 0.0, "a taper pad night is half a night's load (%.2f of %.2f)" % [half, full])
	var hrs := WeekPlan.hours([], ["pads"], 1.0, 0.5)
	_check(is_equal_approx(hrs, 75.0 * 0.5 / 60.0), "and half its hours (%.3f)" % hrs)


func _ahead() -> void:
	var f := _lucy()
	f["camp"] = {"protocol": 3, "focus": "power", "film": true, "start": 0}
	f["bout"] = {"day": 28, "done": false}
	WeekPhase.sync(f, 0)
	var weeks := PadWeek.ahead(f, 0, 4)
	_check(weeks.size() == 3, "3 weeks to come")
	for wk in weeks:
		var p := str(wk[2])
		var want := PadWeek.evenings_from(PadWeek.lay(2, true, p, WeekPlan.evenings_for(WeekPhase.spar(p), WeekPhase.pads(p))))
		_check(wk[1] == want and not (wk[1] as Array).has("film") and (wk[1] as Array).count("pads") == 3
			and (wk[1] as Array).count("sparring") == WeekPhase.spar(p), "Hard camp, %s week to come: %s" % [p, wk[1]])


func _sim_week() -> void:
	var c := Career.quick_start()
	c.fighters.clear()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	while posmod(c.day, 7) != 0:
		Sim.step_day(c)
	f["award_sessions"] = 0
	Sim.step_day(c)   # Monday: the phase and the twist card are set
	var evs := PadWeek.evenings(f)
	var want := 0
	for d in 7:
		if SkillAwards.COACHED.has(str(evs[d])):
			want += 1
	for i in 6:
		Sim.step_day(c)
	var got := int(f.get("award_sessions", 0))
	var injured := not (f.get("injury", {}) as Dictionary).is_empty()
	_check(injured or got == mini(want, SkillAwards.SESSIONS), "a week stepped: %d coached nights counted, the strip has %d (%s)" % [got, want, evs])
	_check(evs.count("pads") <= 4, "never more pad evenings than Hard's nights (%s)" % [evs])


func _twists() -> void:
	var f := _lucy()
	WeekTwist.deal(f, WeekTwist.card("partner_ill"))
	var evs := PadWeek.evenings(f)
	_check(evs == ["pads", "rest", "pads", "pads", "pads", "rest", "rest"],
		"partner off ill: Thursday's sparring night is a pad night, not REST (%s)" % [evs])
	_check((PadWeek.nights_of(f)["pads"] as Array) == [0, 2, 3, 4], "and the pad board drills it (%s)" % [PadWeek.nights_of(f)])
	WeekTwist.deal(f, WeekTwist.card("head_cold"))
	evs = PadWeek.evenings(f)
	_check(str(evs[2]) == "rest", "a head cold: Wednesday evening rests (%s)" % [evs])
	WeekTwist.deal(f, WeekTwist.card("visiting_pro"))
	evs = PadWeek.evenings(f)
	_check(str(evs[5]) == "sparring" and evs.count("pads") == 3, "a visiting pro: Saturday is an extra sparring night (%s)" % [evs])


func _strip() -> void:
	# Between fights (no camp protocol) the peek reads her load setting's nights, the same the sim runs.
	var f := _lucy()
	f["load_setting"] = "hard"
	var lines := WeekStrip.week_lines("base", "", false, PadWeek.step_of(f), PadWeek.in_camp(f))
	var shown: Array = lines.map(func(l): return str(l).get_slice(" - ", 1))
	_check(shown == PadWeek.evenings(f), "between fights, Hard: the peek shows the sim's nights (%s vs %s)" % [shown, PadWeek.evenings(f)])
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	f["bout"] = {"opp": opp, "day": 25, "done": false}
	var s = WeekStrip.make(f, opp, 25, 0, 0, "power", false)
	_check(s._step == 2 and not s._camp, "no camp yet: the strip reads her Hard load setting, between-fights nights")
	s.free()
	s = WeekStrip.make(f, opp, 25, 0, 0, "power", false, -1, 3)
	_check(s._step == 2 and s._camp, "the camp modal on Hard: the strip reads the Hard camp's nights")
	s.free()
	s = WeekStrip.make(f, opp, 25, 0, 0, "power", false, -1, 1)
	_check(s._step == 0 and s._camp, "the camp modal on Light: Light's nights")
	s.free()
	var peak := WeekStrip.week_lines("peak", "power", false, 2, true)
	_check(peak.filter(func(l): return str(l).ends_with("pads")).size() == 3, "a Hard camp's Peak week: 3 pad nights in the peek")


func _monday_board() -> void:
	var c := Career.quick_start()
	c.fighters.clear()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	while posmod(c.day, 7) != 0:
		Sim.step_day(c)
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	f["bout"] = {"opp": opp, "day": c.day + 40, "done": false}
	f["camp"] = {"protocol": 2, "focus": "technique", "film": true, "start": c.day}
	WeekPhase.sync(f, c.day)
	_check(PadWeek.evenings(f).count("film") == 1, "camp week 1 (Build) holds the film night (%s)" % [PadWeek.evenings(f)])
	for i in 7:
		Sim.step_day(c)
	_check(posmod(c.day, 7) == 0, "week 2's Monday, not stepped yet (day %d)" % c.day)
	var stale: Dictionary = f.duplicate(true)
	_check(PadWeek.evenings(stale).count("film") == 1, "(the bug) last week's phase still reads a film night before the sync")
	var drawn: Array = WeekBoard.plan_of(c, f)["evs"]
	_check(not drawn.has("film") and int(f["phase_day"]) == c.day, "the Monday board draws this week: no film (%s)" % [drawn])
	var phase := str(f["phase"])
	var want_spar := 2 if WeekPhase.spar(phase) != 2 else 1   # a real exception, not the phase's own count
	WeekPhase.edit_spar(f, want_spar)
	Sim.step_day(c)   # Monday runs
	var ran := PadWeek.evenings(f)
	_check(str(f["phase"]) == phase and not ran.has("film"), "Monday's step keeps the board's phase (%s), no film run (%s)" % [phase, ran])
	_check(int(WeekPhase.edits(f).get("spar", -1)) == want_spar, "the sparring edit made on the Monday board survives the step")
	_check(drawn.count("pads") == ran.count("pads") or not str(f.get("twist", "")).is_empty(),
		"the pad nights drawn are the nights run (%s vs %s, twist '%s')" % [drawn, ran, f.get("twist", "")])


func _check(ok: bool, label: String) -> void:
	if ok:
		print("  PASS  ", label)
	else:
		failures += 1
		print("  FAIL  ", label)
