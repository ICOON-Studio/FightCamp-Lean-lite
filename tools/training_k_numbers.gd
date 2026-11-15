extends SceneTree
## S484 TRAINGAME2: the game's real numbers for the Training K page (docs/mockups/s483/training_k.html). Plays nothing:
## the quick-start fighter (Lucy) with the real first coach, her coach's week as the game lays it (WeekPlan.days_of,
## Sim.week_ctx, PadWeek.nights_of / week_of / project) and FireLevel's game shares. Prints TK lines the page copies.
## Run: Godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/training_k_numbers.gd

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")


func _initialize() -> void:
	var c := Career.quick_start()
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	print("TK fighter %s weight %.1f limit %.1f fatigue %.1f coach %s pads %s" % [str(f.get("name", "?")), float(f["weight"]),
		float(f["limit"]), float(f.get("week_fatigue", 20.0)), str(c.coach.get("name", "?")), str(c.coach.get("areas", {}).get("pads", "?"))])
	# Mornings: the coach's week as the game runs it.
	var days: Array = WeekPlan.days_of(f)
	var ctx: Dictionary = Sim.week_ctx(c, f)
	var wk: Dictionary = WeekPlan.week(days, ctx)
	var names := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
	var i := 0
	for d in wk["days"]:
		var dd: Dictionary = d
		print("TK morning %s %s/%s stat=%s gain=%+.3f kg=%+.3f load=%.0f fatigue=%.1f" % [names[i], str(days[i][0]), str(days[i][1]),
			str(dd.get("stat", "")), float(dd.get("gain", 0.0)), float(dd.get("kg", 0.0)), float(dd.get("load", 0.0)), float(dd.get("fatigue", 0.0))])
		i += 1
	print("TK week gains=%s kg=%+.2f weight_end=%.2f fatigue_end=%.1f peak=%.1f" % [str(wk.get("gains", {})), float(wk.get("kg", 0.0)),
		float(wk.get("weight_end", 0.0)), float(wk.get("fatigue_end", 0.0)), float(wk.get("peak", 0.0))])
	# Evenings: the pad nights and what they do to each card's mastery.
	var nights: Dictionary = PadWeek.nights_of(f)
	var week: Dictionary = PadWeek.week_of(f, nights)
	print("TK nights pads=%s spar=%s film=%s" % [str(nights.get("pads", [])), str(nights.get("spar", [])), str(nights.get("film", ""))])
	for day in PadWeek.DAYS:
		if week.has(day) and not (week[day] as Array).is_empty():
			print("TK night %s %s" % [day, str(week[day])])
	var skill := float(c.coach.get("areas", {}).get("pads", 58))
	var projs: Dictionary = PadWeek.project(f, nights, week, skill, PadWeek.STATION_TIER, 8)
	for card in projs.keys():
		var p: Dictionary = projs[card]
		var path: Array = p.get("path", [])
		var first: Array = path.slice(0, mini(8, path.size()))
		print("TK card %s now=%.1f cap=%.1f day30=%s weeks30=%s weeks60=%s path(first)=%s" % [card, PadWeek.mastery(f, str(card)),
			float(p.get("cap", 0.0)), str(p.get("day30", "")), str(p.get("weeks30", "")), str(p.get("weeks60", "")), str(first)])
	# Fire shares by mastery tier (the game's, S450).
	for m in [29.0, 30.0, 45.0, 60.0, 85.0]:
		print("TK fire mastery=%.0f share=%.2f" % [m, FireLevel.share(FireLevel.GAME_SHARES, m)])
	_page_week(c, f)
	print("TK DONE")


## The Training K page's own week (Kwame, welter 70 kg, peak week): its mornings at its intensities and its pad nights at
## its minutes, from its starting masteries, through WeekPlan.full_day and PadWeek.drill (Lucy's record as the body).
func _page_week(c: Career, f0: Dictionary) -> void:
	var f: Dictionary = f0.duplicate(true)
	f["weight"] = 70.6
	f["limit"] = 70.0
	f["diet"] = "cut"
	f["phase"] = "peak"
	f["week_fatigue"] = 40.0
	f["moves"]["Check hook"] = 12.0
	f["moves"]["Body hook"] = 29.0
	var ctx: Dictionary = Sim.week_ctx(c, f)
	ctx["diet"] = "cut"
	var page := [["roadwork", "normal", "pads"], ["heavy_bag", "normal", "film"], ["intervals", "normal", "pads"],
		["speed_bag", "light", "sparring"], ["slip_rope", "hard", "pads"], ["shadow", "normal", "rest"], ["rest", "normal", "rest"]]
	var fat := 40.0
	for d in page:
		var r: Dictionary = WeekPlan.full_day(str(d[0]), str(d[1]), str(d[2]), ctx, fat)
		fat = float(r["fatigue"])
		print("TK page %s/%s +%s: stat=%s gain=%+.3f kg=%+.3f eve=%s gain2=%+.3f fatigue=%.1f" % [d[0], d[1], d[2], str(r.get("stat", "")),
			float(r.get("gain", 0.0)), float(r.get("kg", 0.0)), str(r.get("stat2", "")), float(r.get("gain2", 0.0)), fat])
	var skill := 58.0
	for n in [["move:Check hook", PadWeek.PAD_NIGHT_MINUTES], ["move:Body hook", PadWeek.PAD_NIGHT_MINUTES], ["move:Check hook", PadWeek.PAD_NIGHT_MINUTES]]:
		var before := PadWeek.mastery(f, str(n[0]))
		var after := PadWeek.drill(f, str(n[0]), float(n[1]), skill, PadWeek.STATION_TIER, PadWeek.PAD_STATION)
		print("TK page night %s %.0f min: %.1f -> %.1f fire=%.2f" % [n[0], n[1], before, after, FireLevel.share(FireLevel.GAME_SHARES, after)])
	quit(0)
