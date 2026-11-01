extends RefCounted
## S341 situation templates from real fight plans (operator: "can you find real fight plans to compare them or add them as
## situation templates"; research Game Godot/research/REALPLANS_S341.md, 14 boxing plans + 9 wrestling items with sources).
## Each is a plan the coach can load on her board. A template for an opponent's game ("vs a presser") is the fight's
## default: its core arrows are any-time, its exceptions carry `when`; a situation template ("she's hurt but still
## dangerous") is all `when` arrows, an add-on. Listed in the order a coach keeps them when his board holds fewer.
## Trimmed to one arrow per card and situation (PlanBoard's rule); only our map's moves. S341 measured (plan_templates_test):
## the Holyfield plan reads worse than the starter in our bout - our answer table gives push_off nothing against a
## presser; that disagreement is on the operator's table (REALPLANS_S341.md section 3), not fixed here. Ali's rope-a-dope is left out: disputed as a plan, his own corner
## hated it, and our ropes are a place she is forced into, not one she picks.
##   BOXING / WRESTLING: [{id, name, from, idea, arrows}]   load(t, limit, plan, map) -> plan   for_game(game) -> boxing ids

const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")

const BOXING := [
	{"id": "t_turn", "name": "Vs a presser: make her miss and turn her", "from": "Leonard-Hagler 1987, Joshua-Ruiz II 2019, Taylor-Serrano I 2022",
		"idea": "Jab and leave; never stand where she is punching; if she gets close, hold.", "games": ["press"],
		"arrows": [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"},
			{"move": "slip 2-3", "when": "loadup"}, {"move": "step_out", "when": "she_tired"}]},
	{"id": "t_ground", "name": "Vs a presser: stand your ground and push her back", "from": "Holyfield-Tyson I 1996",
		"idea": "Don't go backwards: hold, shove her onto her heels, then hit first. Strong, durable boxers only.", "games": ["press"],
		"arrows": [{"move": "tie_up"}, {"move": "push_off"}, {"move": "slip 2-3", "when": "loadup"},
			{"move": "3b-3", "when": "tiring"}, {"move": "cut_off", "when": "hurt"}, {"move": "herd", "when": "hurt"},
			{"move": "1-6-3@corner", "when": "hurt"}]},
	{"id": "t_hook", "name": "Vs a rusher: hook her as she comes in", "from": "Pacquiao-Hatton 2009",
		"idea": "She cocks before she throws: slip, cross, hook her on the way in.", "games": ["press", "loadup"],
		"arrows": [{"move": "slip 2-3"}, {"move": "slip 2-3@own_ropes"}, {"move": "1-2-3-2", "when": "hurt"}, {"move": "herd", "when": "hurt"}]},
	{"id": "t_walk", "name": "Vs a long boxer: walk her down behind the jab", "from": "Fury-Wilder II 2020, Hagler-Hearns 1985, Inoue-Fulton 2023",
		"idea": "Take her distance away: jab your way in, cut the ring, finish on the ropes.", "games": ["range"],
		"arrows": [{"move": "1-1-2"}, {"move": "cut_off"}, {"move": "1-2@opp_ropes"},
			{"move": "3b-3@opp_ropes", "when": "tiring"}, {"move": "herd", "when": "hurt"}, {"move": "1-6-3@corner", "when": "hurt"}]},
	{"id": "t_body", "name": "Ambush a speed boxer: pressure and the body", "from": "Cameron-Taylor I 2023",
		"idea": "Get her out of her comfort zone: close, dig the body, make every round a fight on the inside.", "games": ["range", "counter"],
		"arrows": [{"move": "step_in"}, {"move": "1-2-3b"}, {"move": "3b-3"},
			{"move": "1-1-2", "when": "counter"}, {"move": "3b-3@opp_ropes", "when": "tiring"}]},
	{"id": "t_outwork", "name": "Vs a waiter: outwork her early", "from": "Lopez-Lomachenko 2020, Taylor-Ochigava 2012",
		"idea": "She gives you the early rounds: bank them with the jab, never throw the big combination she waits for.", "games": ["counter"],
		"arrows": [{"move": "1-1"}, {"move": "1-1-2"}, {"move": "3b-3"},
			{"move": "tie_up", "when": "she_tired"}]},
	{"id": "t_exits", "name": "She's hurt but still dangerous: close the exits", "from": "Joshua-Ruiz I lesson (McCracken), Inoue-Fulton 2023, Fury-Wilder II 2020",
		"idea": "Hurt is not finished: walk her to the corner with straight shots; wide swings get you countered.", "games": ["hurt"],
		"arrows": [{"move": "1-2", "when": "hurt"}, {"move": "1-2@opp_ropes", "when": "hurt"}, {"move": "1-6-3@corner", "when": "hurt"},
			{"move": "herd", "when": "tiring"}, {"move": "3b-3@corner", "when": "tiring"}]},
	{"id": "t_survive", "name": "Survive the bad round: punch, hold, get off the ropes", "from": "Taylor-Serrano I 2022 rd 5-7, Taylor-Cameron II 2023 rd 9",
		"idea": "Never stay in the exchange when your legs go: punch, hold, turn her, reset.", "games": ["she_hurt", "she_tired"],
		"arrows": [{"move": "tie_up@own_ropes", "when": "she_hurt"}, {"move": "roll_out", "when": "she_hurt"}, {"move": "tie_up", "when": "she_tired"},
			{"move": "push_off", "when": "she_tired"}, {"move": "step_back", "when": "she_tired"}, {"move": "1-1", "when": "she_tired"}]},
]

## Wrestling: tie-up answers (WrestleChains rows, id "tie:reaction").
const WRESTLING := [
	{"id": "w_backwards", "name": "Make the champion wrestle backwards", "from": "Maroulis-Yoshida, Rio 2016; Kevin Jackson's snapdowns (USA Wrestling 2001)",
		"idea": "Attack first; be heavy on her head and hands.",
		"arrows": [{"move": "collar_tie:leans in on the tie"}, {"move": "front_headlock:digs for a leg"}, {"move": "front_headlock:turtles"}]},
	{"id": "w_collar", "name": "Beat the heavy collar tie", "from": "USA Wrestling, 'See the tie-up, react and attack' (2002)",
		"idea": "Her pressure is your opening.",
		"arrows": [{"move": "collar_tie:leans in on the tie"}, {"move": "collar_tie:carries her head high"}, {"move": "collar_tie:pushes hard"},
			{"move": "collar_tie:steps back"}]},
	{"id": "w_two_on_one", "name": "Two-on-one chain", "from": "USA Wrestling, '2 on 1 to a double' (2004)",
		"idea": "Own the arm; shoot the moment she fights for it.",
		"arrows": [{"move": "wrist_control:pulls her wrist back"}, {"move": "wrist_control:straightens her arm"}, {"move": "two_on_one:pulls her arm free"}]},
	{"id": "w_carry", "name": "Underhook to the carry", "from": "standard teaching (no single match on record)",
		"idea": "Use her weight, never fight it.",
		"arrows": [{"move": "underhook:pressures into it"}, {"move": "underhook:reaches for the far arm"}, {"move": "underhook:stays heavy"},
			{"move": "russian_tie:keeps her head on the far side"}]},
]


## Her plan with the template loaded: the template's arrows first (as many as the coach holds), then her own arrows on the
## places it leaves free, up to `limit`. `map` = the move map (StrikeMap.MOVES / the tie-up map).
static func load(t: Dictionary, limit: int, plan: Array = [], map: Array = []) -> Array:
	var out: Array = (t["arrows"] as Array).slice(0, maxi(0, limit)).duplicate(true)
	var taken := {}
	for a in out:
		taken[_place(a, map)] = true
	for a in plan:
		if out.size() >= limit:
			break
		var k := _place(a, map)
		if not taken.has(k):
			taken[k] = true
			out.append((a as Dictionary).duplicate())
	return out


static func _place(a: Dictionary, map: Array) -> String:
	var r := PlanBoard.row(map, str(a["move"]))
	return str(r.get("from", a["move"])) + ":" + PlanBoard.when_of(a, r)


## The boxing templates made for this game of hers (OppFile.main_game: "press", "range", ...).
static func for_game(game: String) -> Array:
	return BOXING.filter(func(t): return (t["games"] as Array).has(game)).map(func(t): return str(t["id"]))


static func boxing(id: String) -> Dictionary:
	for t in BOXING:
		if str(t["id"]) == id:
			return t
	return {}
