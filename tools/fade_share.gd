extends SceneTree
## S434 FADESHARE (TRAINING_MAP F3 / section 10, inside CARDIO1): the share of our fighters who fade in round 3, under
## main's rule (the old conditioning, the mean of Stamina and Recovery, under 64 = a fade of 1.0) and under the split rule
## (Stamina alone, the slope OWN_FADE x clamp(0.25 x (line - Stamina), 0, 2)) for each line from 64 down to 55.
## POPULATION (named in the output): Data.PROSPECTS (5), Lucy (Data.lucy), and 200 generated recruits - AttrGen.generate
## (the game's own generator, the world's boxers) on a level drawn N(59, 3) clamped 50..68 (the named six average 59.1),
## kept as the old seven (Attrs.legacy), then signed the way our fighters are (Roster.sign_fighter -> Attrs.of ->
## Attrs.from_stats, whose Stamina starts 5 under the old mean). Seed 4340.
## Also the "Stamina for five rounds" goal (FighterGoal ENGINE_STAMINA_DELTA in ENGINE_DAYS) for each signing on the quick
## start's coach and the fighter's own week (Sim.daily_gain(goal_keys): Stamina's own pace): reached on pace, and
## whether its target reaches the line.
## Round 2 (the S434 skeptic: "measured on signing day, not on bouts"): _fight_time trains every signing through
## Sim.step_day and samples a bout on days 28..56; that table set BoutRules.FADE_STAMINA (60) and FighterGoal's reach.
## Run: godot --headless --path . --script res://tools/fade_share.gd

const Data := preload("res://scripts/state/Data.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

const N_GEN := 200
const SEED := 4340
const MAIN_LINE := 64.0
const BATCH := 52
const BOUT_DAYS: Array[int] = [28, 35, 42, 49, 56]


func _initialize() -> void:
	var c := Career.quick_start()
	var named: Array = []
	for p in Data.PROSPECTS:
		named.append(_sign(c, (p as Dictionary).duplicate(true)))
	named.append(_sign(c, Data.lucy()))
	var gen: Array = []
	var rng := RandomNumberGenerator.new()
	rng.seed = SEED
	for i in N_GEN:
		gen.append(_sign(c, _recruit(rng, i)))
	print("FADESHARE population: Data.PROSPECTS 5 + Lucy + %d AttrGen recruits (level N(59,3) 50..68, seed %d), signed via Roster.sign_fighter" % [N_GEN, SEED])
	for row in named:
		print("  %-14s conditioning %.1f  Stamina %.1f  Recovery %.1f  main fade %.2f  slope@64 %.2f  slope@line %.2f  28 days: Stamina %+.2f, conditioning %+.2f" % [
			row["name"], row["cond"], row["st"], row["rc"], 1.0 if float(row["cond"]) < MAIN_LINE else 0.0, _slope(float(row["st"]), 64.0),
			_slope(float(row["st"]), BoutRules.FADE_STAMINA), float(row["rate"]) * 28.0, float(row["crate"]) * 28.0])
	for grp in [["named six", named], ["generated 200", gen], ["all 206", named + gen]]:
		var pop: Array = grp[1]
		var main_share := _share(pop, func(r): return float(r["cond"]) < MAIN_LINE)
		var main_size := _mean(pop, func(r): return 1.0 if float(r["cond"]) < MAIN_LINE else 0.0)
		print("%s: MAIN (conditioning < 64, fade 1.0): fades %.1f%%, mean fade %.3f; mean conditioning %.2f, mean Stamina %.2f" % [
			grp[0], main_share * 100.0, main_size, _mean(pop, func(r): return float(r["cond"])), _mean(pop, func(r): return float(r["st"]))])
		for line in [64.0, 63.0, 62.0, 61.0, 60.0, 59.0, 58.0, 57.0, 56.0, 55.0]:
			var sh := _share(pop, func(r): return float(r["st"]) < line)
			print("   line %.0f: fades %.1f%% (%+.1f points on main), mean fade %.3f, mean fade of those who fade %.3f" % [line, sh * 100.0,
				(sh - main_share) * 100.0, _mean(pop, func(r): return _slope(float(r["st"]), line)),
				_mean(pop.filter(func(r): return float(r["st"]) < line), func(r): return _slope(float(r["st"]), line))])
	var live := BoutRules.FADE_STAMINA
	for grp in [["named six", named], ["generated 200", gen]]:
		var pop: Array = grp[1]
		var on_pace := _share(pop, func(r): return float(r["rate"]) * FighterGoal.ENGINE_DAYS >= float(r["goal"]) - float(r["st"]) - 0.0001)
		var crosses := _share(pop, func(r): return float(r["st"]) < live and float(r["goal"]) >= live)
		var fading := _share(pop, func(r): return float(r["st"]) < live)
		var old_pace := _share(pop, func(r): return float(r["crate"]) * FighterGoal.ENGINE_DAYS >= FighterGoal.ENGINE_STAMINA_DELTA)
		print("%s: main's goal on conditioning (+%.1f) on pace %.1f%%, conditioning pace mean %.3f a day" % [grp[0],
			FighterGoal.ENGINE_STAMINA_DELTA, old_pace * 100.0, _mean(pop, func(r): return float(r["crate"]))])
		print("%s, 'Stamina for five rounds' (FighterGoal.goal_for: +%.1f, or the line when 3 or fewer away, in %d days), the game's line %.0f: Stamina pace mean %.3f a day (28 days: %+.2f), on pace %.1f%%; of the %.1f%% who fade, the target reaches the line for %.1f%% of all" % [
			grp[0], FighterGoal.ENGINE_STAMINA_DELTA, FighterGoal.ENGINE_DAYS, live, _mean(pop, func(r): return float(r["rate"])),
			_mean(pop, func(r): return float(r["rate"])) * FighterGoal.ENGINE_DAYS, on_pace * 100.0, fading * 100.0, crosses * 100.0])
	seed(SEED)
	var raws: Array = []
	for p in Data.PROSPECTS:
		raws.append((p as Dictionary).duplicate(true))
	raws.append(Data.lucy())
	rng.seed = SEED
	for i in N_GEN:
		raws.append(_recruit(rng, i))
	for focus in ["", "conditioning"]:
		_fight_time(raws, focus)
	print("FADESHARE done")
	quit(0)


## FADESHARE AT FIGHT TIME (the S434 skeptic: "measured on signing day, not on bouts"): every signing trains through the
## game's own day (Sim.step_day: twists, injuries, the phase weeks, no camp = the amateur fight week) for BOUT_DAYS[-1]
## days, BATCH to a career; a bout is sampled on each of BOUT_DAYS (weeks 4 to 8 of its own week). focus "" = the
## fighter's own plan, "conditioning" = the Stamina week (the player answers a Stamina goal: Tue intervals, Thu roadwork). Shares and sizes per bout.
func _fight_time(raws: Array, focus: String) -> void:
	var bouts: Array = []   # {named, cond, st}
	var goals: Array = []   # {named, five, five_at, debut, debut_at}
	var i := 0
	while i < raws.size():
		var c := Career.quick_start()
		c.fighters.clear()
		var batch: Array = []
		for j in range(i, mini(i + BATCH, raws.size())):
			var f := Roster.sign_fighter(c, raws[j], [])
			if focus != "":   # the player's answer to a Stamina goal: Tuesday's heavy bag and Thursday's speed bag become intervals and roadwork
				WeekPhase.sync(f, c.day)
				WeekPhase.edit(f, 1, ["intervals", "normal"], WeekPlan.coach_of(f))
				WeekPhase.edit(f, 3, ["roadwork", "normal"], WeekPlan.coach_of(f))
			var st0 := float(Attrs.of(f)["stamina"])
			batch.append({"f": f, "named": j < 6, "st0": st0, "c0": (st0 + float(Attrs.of(f)["recovery"])) / 2.0,
				"five": float((FighterGoal.goal_for(f, "five_round_engine", c.day)["targets"] as Dictionary)["stamina"]),
				"debut": float((FighterGoal.goal_for(f, "debut_inside_a_month", c.day)["targets"] as Dictionary)["stamina"])})
		var d0 := c.day
		while c.day - d0 < int(BOUT_DAYS[-1]):
			c.cash = 1000000
			Sim.step_day(c)
			var t := c.day - d0
			for row in batch:
				var a := Attrs.of(row["f"])
				if t == FighterGoal.ENGINE_DAYS:
					goals.append({"named": row["named"], "five": float(a["stamina"]) >= float(row["five"]) - 0.0001,
						"main": (float(a["stamina"]) + float(a["recovery"])) / 2.0 >= float(row["c0"]) + FighterGoal.ENGINE_STAMINA_DELTA - 0.0001,
						"debut": float(a["stamina"]) >= float(row["debut"]) - 0.0001, "gain": float(a["stamina"]) - float(row["st0"])})
				if BOUT_DAYS.has(t):
					bouts.append({"named": row["named"], "st": float(a["stamina"]), "cond": (float(a["stamina"]) + float(a["recovery"])) / 2.0})
		i += BATCH
	var tag := "own week" if focus == "" else "Stamina week"
	print("FIGHT TIME (%s): %d bouts = the 206 signings x days %s of Sim.step_day (no camp)" % [tag, bouts.size(), str(BOUT_DAYS)])
	for grp in [["named six", bouts.filter(func(r): return r["named"])], ["all 206", bouts]]:
		var pop: Array = grp[1]
		var ms := _share(pop, func(r): return float(r["cond"]) < MAIN_LINE)
		print("  %s: MAIN (conditioning < 64, 1.0): fading bouts %.1f%%, mean fade a bout %.3f; mean Stamina %.2f, conditioning %.2f" % [
			grp[0], ms * 100.0, ms, _mean(pop, func(r): return float(r["st"])), _mean(pop, func(r): return float(r["cond"]))])
		for line in [64.0, 62.0, 61.0, 60.0, 59.0, 58.0, 57.0]:
			var sh := _share(pop, func(r): return float(r["st"]) < line)
			print("     line %.0f: fading bouts %.1f%% (%+.1f points on main), mean fade a bout %.3f, of a fading bout %.3f" % [line,
				sh * 100.0, (sh - ms) * 100.0, _mean(pop, func(r): return _slope(float(r["st"]), line)),
				_mean(pop.filter(func(r): return float(r["st"]) < line), func(r): return _slope(float(r["st"]), line))])
	var gains: Array = goals.map(func(r): return float(r["gain"]))
	gains.sort()
	for grp in [["named six", goals.filter(func(r): return r["named"])], ["all 206", goals]]:
		var pop: Array = grp[1]
		print("  %s goals after %d days: 'Stamina for five rounds' met %.1f%% (main's, conditioning +%.1f: %.1f%%), 'Debut inside a month' (+%.1f) met %.1f%%" % [grp[0],
			FighterGoal.ENGINE_DAYS, _share(pop, func(r): return r["five"]) * 100.0, FighterGoal.ENGINE_STAMINA_DELTA, _share(pop, func(r): return r["main"]) * 100.0,
			FighterGoal.DEBUT_STAMINA_DELTA, _share(pop, func(r): return r["debut"]) * 100.0])
	print("  Stamina gained in %d days (all 206): mean %.2f, 30th percentile %.2f, median %.2f" % [FighterGoal.ENGINE_DAYS,
		_mean(goals, func(r): return float(r["gain"])), float(gains[int(gains.size() * 0.3)]), float(gains[gains.size() / 2])])


## A generated recruit as our scouting would hold it: the old seven from AttrGen's attributes, a style word, a heart.
func _recruit(rng: RandomNumberGenerator, i: int) -> Dictionary:
	var prof := AttrGen.generate(rng)
	var lvl := clampf(rng.randfn(59.0, 3.0), 50.0, 68.0)
	var a := {}
	for k in Attrs.ABILITIES:
		a[k] = clampf(lvl + float((prof["shape"] as Dictionary).get(k, 0.0)), Attrs.LO, Attrs.HI)
	var sex := "f" if i % 2 == 0 else "m"
	return {"id": "gen%d" % i, "name": "Gen %d" % i, "first": "Gen", "sex": sex, "age": 20, "wc": "Lightweight",
		"div": "wlw" if sex == "f" else "mlw", "weight": 60.5, "stance": "orthodox", "style": AttrGen.style_word(prof), "w": 0, "l": 0,
		"pot": 80, "stats": Attrs.legacy(a), "personality": {"heart": float(prof["heart"])}}


func _sign(c: Career, raw: Dictionary) -> Dictionary:
	var f := Roster.sign_fighter(c, raw, [])
	var a := Attrs.of(f)
	var rate := float(Sim.daily_gain(c, f, true).get("stamina", 0.0))
	var crate := float(Sim.daily_gain(c, f).get("conditioning", 0.0))
	var goal := float((FighterGoal.goal_for(f, "five_round_engine", c.day)["targets"] as Dictionary)["stamina"])
	c.fighters.erase(f)
	return {"name": str(f["name"]), "cond": (float(a["stamina"]) + float(a["recovery"])) / 2.0, "st": float(a["stamina"]),
		"rc": float(a["recovery"]), "rate": rate, "crate": crate, "goal": goal}


func _slope(st: float, line: float) -> float:
	return BoutRules.OWN_FADE * clampf(0.25 * (line - st), 0.0, 2.0)


func _share(pop: Array, pred: Callable) -> float:
	return float(pop.filter(pred).size()) / float(maxi(1, pop.size()))


func _mean(pop: Array, val: Callable) -> float:
	var s := 0.0
	for r in pop:
		s += float(val.call(r))
	return s / float(maxi(1, pop.size()))
