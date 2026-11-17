extends RefCounted
## S481 FIGHTWEEK2: the player's moves on the fight week (Frame A) and the sparring partner screen (Frame B). The open
## modal is {type "fightweek", fid, plan {stop, nights {days_out: partner id}, eat_less, film}, view "week"|"partner",
## night days_out}; FightWeekPlan.read prices it, FightWeekPlan.lock writes it into the bout. Main.act hands names here.

const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const FilmNight := preload("res://scripts/state/FilmNight.gd")
const FightAnalysis := preload("res://scripts/ui/FightAnalysisTape.gd")   # S511: + Write the answer after File it


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"fightweek":
			var f := c.fighter_by_id(arg)
			if f.is_empty() or not FightWeekPlan.is_open(f):
				return true
			main.open_modal({"type": "fightweek", "fid": str(f["id"]), "plan": FightWeekPlan.draft(c, f), "view": "week",
				"night": 0})
		"fwstop":
			_plan(main)["stop"] = FightWeek.stop_of(arg)
			main.redraw_modal()
		"fwnight":   # a day cell: no night there -> place one and pick its partner; a night -> take it off
			var nights: Dictionary = _plan(main)["nights"]
			var d := int(arg)
			if nights.has(d):
				nights.erase(d)
			else:
				nights[d] = ""
				main.modal["view"] = "partner"
				main.modal["night"] = d
			main.redraw_modal()
		"fwpartnerof":   # open the partner screen for a placed night
			main.modal["view"] = "partner"
			main.modal["night"] = int(arg)
			main.redraw_modal()
		"fwpartner":
			(_plan(main)["nights"] as Dictionary)[int(main.modal.get("night", 0))] = arg
			main.modal["view"] = "week"
			main.redraw_modal()
		"fwback":
			main.modal["view"] = "week"
			main.redraw_modal()
		"fweat":
			_plan(main)["eat_less"] = not bool(_plan(main).get("eat_less", false))
			main.redraw_modal()
		"fwfilm":
			_plan(main)["film"] = not bool(_plan(main).get("film", false))
			main.redraw_modal()
		"fwfilmself":   # S510 FIGHTFILM1: watch the tape yourself (the analysis page) or let the coach watch
			_plan(main)["film_self"] = not bool(_plan(main).get("film_self", false))
			main.redraw_modal()
		"fwpick":
			var f := c.fighter_by_id(str(main.modal["fid"]))
			var pick := FightWeekPlan.draft(c, f)   # map v9 4.6: "Use the pick" applies the stops, never a partner
			_plan(main)["stop"] = pick["stop"]
			_plan(main)["eat_less"] = pick["eat_less"]
			main.redraw_modal()
		"fwlock":
			var f := c.fighter_by_id(str(main.modal["fid"]))
			var plan := _plan(main)
			if bool(plan.get("film", false)) and bool(plan.get("film_self", false)) and not bool(plan.get("film_done", false)):
				_film_night(main, c, f, plan)   # the night first; its Done locks the week
				return true
			var why := FightWeekPlan.lock(c, f, plan)
			if why != "":
				main.toast("Not yet: %s." % why)
				return true
			main.close_modal()
			main.toast("The fight week is set: %s." % str(FightWeek.STOP_NAMES[str(f["bout"]["load"])]).to_lower())
		_:
			return false
	return true


static func _plan(main: Node) -> Dictionary:
	return main.modal["plan"]


## S510 FIGHTFILM1: the film evening watched by the player - the FIGHT ANALYSIS page over her films (FilmNight); Done
## marks the night watched and locks the week.
static func _film_night(main: Node, c: Career, f: Dictionary, plan: Dictionary) -> void:
	var films := FilmNight.films(c, f)
	var page := FightAnalysis.new()
	page.name = "FightAnalysis"
	page.main_ref = main
	page.fighter = f
	var on_check := func(claim: Dictionary, seen: Array) -> Dictionary: return FilmNight.check(f, claim, seen)
	var on_file := func(claim: Dictionary, word: String, n: int) -> void: FilmNight.file(f, claim, word, n)
	var on_done := func() -> void:
		plan["film_done"] = true
		act(main, "fwlock", "")
	page.for_tape(f["bout"]["opp"], films, FilmNight.night(c, f, films.size()), on_check, on_file, on_done)
	main.add_child(page)
