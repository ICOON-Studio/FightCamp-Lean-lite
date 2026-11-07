extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1, STRUCTURE_DESIGN_S395 5.3b "members are the talent pipeline"):
## the youth section's intakes. Twice a year, at the January and September term starts, a junior may turn 18 and ask for
## a trial: two weeks before, the juniors' coach says how it looks; on the day it is a roll (INTAKE_CHANCE, more with a
## second club coach). A home-grown prospect has a few more points of potential than the scouted ones and is on half the
## stipend for the first year - "the best prospects cost nothing if you built the club that grew them".
## Round 1 (club owner): ~80% a year was generous; two intakes at 35% is ~58% a year. GAME values.

const GameMoney := preload("res://scripts/rules/GameMoney.gd")

const INTAKE_WEEKS := [1, 35]
const PREVIEW_WEEKS := 2
const INTAKE_CHANCE := 0.35
const ASSISTANT_CHANCE := 0.10
## The section must have run this long (a term) before its juniors are ready.
const MIN_DAYS := 91
const POT_BONUS := 3
const HALF_STIPEND_DAYS := 364
const HALF := 0.5
## Who comes up, in order (each once). Real faces come from Faces' pool by name; stats sit inside the scouted range.
const JUNIORS: Array[Dictionary] = [
	{"id": "home_mia", "name": "Mia Doyle", "first": "Mia", "sex": "f", "age": 18, "wc": "Featherweight", "div": "wfw", "weight": 57.6,
		"stance": "orthodox", "style": "Boxer-puncher", "w": 4, "l": 1, "pot": 84, "note": "home-grown: came up through the juniors",
		"stats": {"power": 56.0, "speed": 61.0, "technique": 60.5, "defense": 56.0, "conditioning": 59.0, "fight_iq": 58.0, "chin": 58.0},
		"personality": {"heart": 72.0, "discipline": 68.0, "confidence": 50.0, "coachability": 78.0, "loyalty": 88.0, "temper": 38.0}},
	{"id": "home_kofi", "name": "Kofi Asante", "first": "Kofi", "sex": "m", "age": 18, "wc": "Lightweight", "div": "mlw", "weight": 60.8,
		"stance": "southpaw", "style": "Counter-puncher", "w": 5, "l": 2, "pot": 83, "note": "home-grown: came up through the juniors",
		"stats": {"power": 57.0, "speed": 60.0, "technique": 59.0, "defense": 60.5, "conditioning": 56.0, "fight_iq": 61.0, "chin": 57.0},
		"personality": {"heart": 58.0, "discipline": 74.0, "confidence": 62.0, "coachability": 70.0, "loyalty": 84.0, "temper": 44.0}},
	{"id": "home_ellie", "name": "Ellie Shaw", "first": "Ellie", "sex": "f", "age": 18, "wc": "Welterweight", "div": "www", "weight": 65.9,
		"stance": "orthodox", "style": "Pressure fighter", "w": 3, "l": 2, "pot": 81, "note": "home-grown: came up through the juniors",
		"stats": {"power": 61.0, "speed": 56.0, "technique": 56.5, "defense": 54.0, "conditioning": 62.0, "fight_iq": 55.0, "chin": 61.0},
		"personality": {"heart": 80.0, "discipline": 56.0, "confidence": 64.0, "coachability": 60.0, "loyalty": 86.0, "temper": 52.0}},
	{"id": "home_jamal", "name": "Jamal Reid", "first": "Jamal", "sex": "m", "age": 18, "wc": "Welterweight", "div": "mww", "weight": 70.8,
		"stance": "orthodox", "style": "Out-boxer", "w": 6, "l": 1, "pot": 85, "note": "home-grown: came up through the juniors",
		"stats": {"power": 58.0, "speed": 62.5, "technique": 61.0, "defense": 57.0, "conditioning": 58.0, "fight_iq": 59.0, "chin": 56.0},
		"personality": {"heart": 62.0, "discipline": 66.0, "confidence": 74.0, "coachability": 64.0, "loyalty": 80.0, "temper": 40.0}},
]


static func week_of_year(day: int) -> int:
	return posmod(int(floor(day / 7.0)), 52) + 1


## The section's age in days (-1 when there is none).
static func section_days(c: Career) -> int:
	for o in c.upgrades:
		if str(o["id"]) == "youth":
			return c.day - int(o["day"])
	return -1


static func next_junior(c: Career) -> Dictionary:
	var known: Array = c.prospects.map(func(p): return str(p["id"]))
	for j in JUNIORS:
		if not known.has(str(j["id"])):
			return j
	return {}


static func chance(assistant: bool) -> float:
	return INTAKE_CHANCE + (ASSISTANT_CHANCE if assistant else 0.0)


## Called at each week's end (GymSpend.end_week).
static func end_week(c: Career, youth_on: bool, assistant: bool) -> void:
	if youth_on and section_days(c) >= MIN_DAYS - PREVIEW_WEEKS * 7:
		var w := week_of_year(c.day)
		var j := next_junior(c)
		if not j.is_empty() and INTAKE_WEEKS.has(posmod(w + PREVIEW_WEEKS - 1, 52) + 1):
			c.add_news("The juniors' coach: %s turns 18 this term. About a %d%% chance of asking for a trial, and the potential looks %d-%d." % [
				j["first"], roundi(chance(assistant) * 100), int(j["pot"]) + POT_BONUS - 5, int(j["pot"]) + POT_BONUS + 5])
		if not j.is_empty() and INTAKE_WEEKS.has(w) and section_days(c) >= MIN_DAYS:
			var rng := RandomNumberGenerator.new()
			rng.seed = c.seed * 17 + c.day
			if rng.randf() < chance(assistant):
				var p: Dictionary = j.duplicate(true)
				p["pot"] = int(p["pot"]) + POT_BONUS
				p["home"] = true
				p["state"] = "scout"
				p["trial_day"] = -1
				c.prospects.append(p)
				c.add_news("Home-grown: %s from the juniors asks for a trial (Fighters > Find a fighter). Half the stipend for a year." % j["name"])
			else:
				c.add_news("No junior is ready this term. The next intake is in the new term.")
	# Half the stipend for a home-grown signing's first year.
	for f in c.fighters:
		if bool(f.get("home", false)) and int(f.get("home_until", 0)) > 0 and c.day >= int(f["home_until"]) and not bool(f.get("pro", false)):
			f["weekly_salary"] = 0 if bool(f.get("day_job", false)) else GameMoney.FIGHTER_STIPEND
			f["home_until"] = 0
			c.add_news("%s's first year is up: the full club stipend from now on." % f["first"])


## Roster.sign_prospect's hook: a home-grown signing starts on half the stipend.
static func on_sign(c: Career, raw: Dictionary, f: Dictionary) -> void:
	if bool(raw.get("home", false)):
		f["home"] = true
		f["weekly_salary"] = roundi(float(f["weekly_salary"]) * HALF)
		f["home_until"] = c.day + HALF_STIPEND_DAYS
