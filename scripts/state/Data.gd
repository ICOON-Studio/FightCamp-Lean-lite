extends RefCounted
## The fixed content: the six areas, stat names, the walk-in, the coaches, the week cards, the opponents.

const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const STATS: Array[String] = ["power", "speed", "technique", "defense", "conditioning", "fight_iq", "chin"]
const LABEL := {
	"power": "Power", "speed": "Hand speed", "technique": "Technique", "defense": "Defence",
	"conditioning": "Conditioning", "fight_iq": "Ring IQ", "chin": "Chin",
}
const CARDS: Array[String] = ["Jab and move", "Body work", "Pad rounds", "Hill sprints", "Defence drills", "Film study"]

const AREAS: Array[Dictionary] = [
	{"id": "home", "name": "HOME", "job": "what needs me", "tabs": []},
	{"id": "fighters", "name": "FIGHTERS", "job": "develop them", "tabs": ["Roster", "Training", "Fight camps", "Scouting"]},
	# S348 the Playbook (Q-S294-71 "Yes, build it"): her moves, plans, combos and escapes on one whiteboard, each one plays.
	{"id": "playbook", "name": "PLAYBOOK", "job": "moves and plans", "tabs": ["Moves", "Plans", "Combos", "Escapes"]},
	{"id": "fights", "name": "FIGHTS", "job": "get them fights", "tabs": ["Offers", "Calendar", "Results"]},
	{"id": "gym", "name": "GYM", "job": "run the club", "tabs": ["Floor", "Staff", "Members", "Facilities"]},
	{"id": "money", "name": "MONEY", "job": "keep it alive", "tabs": ["Overview", "Income", "Bills", "Deals"]},
	{"id": "world", "name": "WORLD", "job": "the boxing world", "tabs": ["News", "Rankings", "Events", "Search", "Nationals"]},
]

## Decided: the first coach is sessional at $450 a week; $1,000 to sign either.
const COACHES: Array[Dictionary] = [
	{"id": "reid", "name": "Luke Reid", "kind": "Sessional coach", "salary": 450, "rating": 58, "spec": "Pad work",
		"note": "three evenings a week"},
	{"id": "hale", "name": "Marcus Hale", "kind": "Full-time head coach", "salary": 1090, "rating": 74, "spec": "Conditioning",
		"note": "every day, better gains"},
]


static func area(id: String) -> Dictionary:
	for a in AREAS:
		if a["id"] == id:
			return a
	return AREAS[0]


static func coach(id: String) -> Dictionary:
	for c in COACHES:
		if c["id"] == id:
			return c.duplicate(true)
	return {}


## The walk-in waiting at reception on day one. Decided: an amateur on the $250 club stipend.
static func lucy() -> Dictionary:
	return {
		"id": "lucy", "name": "Lucy Jackson", "first": "Lucy", "age": 21, "wc": "Lightweight", "limit": 61.2, "weight": 62.6,
		"stance": "orthodox", "style": "Out-boxer", "w": 3, "l": 1, "pot": 84, "cards": [], "focus": "conditioning", "div": "wlw",
		"diet": "hold", "fatigue": 8, "weekly_salary": 250, "booked_fight": false, "history": [],
		"stats": {"power": 58.4, "speed": 63.2, "technique": 60.1, "defense": 57.3, "conditioning": 61.6, "fight_iq": 59.0,
			"chin": 66.0},
		"goal": {},
	}


## The opponents offered in turn (an even, legal match each), and the unsafe mismatch that comes with each offer.
## rating = her strength on the night (BoutRules.fight_power scale); bouts = amateur bouts so far (the novice rule).
const OPPONENTS: Array[Dictionary] = [
	{"name": "Maria Ortega", "first": "Maria", "club": "Guadalajara Boxing Club", "age": 23, "stance": "southpaw",
		"style": "Pressure fighter", "w": 4, "l": 2, "height": 165, "reach": 166, "rating": 61.5,
		"threat": "Left hook to the body", "weak": "Fades after round 2"},
	{"name": "Priya Nair", "first": "Priya", "club": "Leicester ABC", "age": 22, "stance": "orthodox",
		"style": "Counter-puncher", "w": 5, "l": 1, "height": 170, "reach": 172, "rating": 63.5,
		"threat": "Right hand counter over the jab", "weak": "Slow to start"},
	{"name": "Erin Doyle", "first": "Erin", "club": "Belfast Golden Gloves", "age": 24, "stance": "orthodox",
		"style": "Volume puncher", "w": 7, "l": 2, "height": 167, "reach": 168, "rating": 65.5,
		"threat": "Never stops throwing", "weak": "Leaves the chin open"},
]
const MISMATCH := {"name": "Dana Whitfield", "first": "Dana", "club": "Repton Boxing Club", "age": 26, "stance": "orthodox",
	"style": "Boxer-puncher", "w": 14, "l": 2, "height": 169, "reach": 171, "rating": 72.0, "threat": "Everything",
	"weak": "None you can use yet"}

## The rest of the region's women's lightweight amateurs (fictional fighters, real club names). With OPPONENTS and MISMATCH
## they make the WORLD rankings; they fight each other at club shows.
const RIVALS: Array[Dictionary] = [
	{"name": "Chloe Bennett", "first": "Chloe", "club": "Dale Youth ABC", "age": 22, "stance": "orthodox",
		"style": "Boxer-puncher", "w": 6, "l": 3, "rating": 63.0, "threat": "Straight right", "weak": "Stands still after combinations"},
	{"name": "Aisha Rahman", "first": "Aisha", "club": "West Ham Boxing Club", "age": 20, "stance": "southpaw",
		"style": "Counter-puncher", "w": 3, "l": 1, "rating": 60.5, "threat": "Left cross over the jab", "weak": "Gives away round 1"},
	{"name": "Sophie Turner", "first": "Sophie", "club": "Fitzroy Lodge ABC", "age": 25, "stance": "orthodox",
		"style": "Volume puncher", "w": 8, "l": 4, "rating": 64.0, "threat": "Three-punch flurries", "weak": "Heavy legs late"},
	{"name": "Megan Hughes", "first": "Megan", "club": "All Stars ABC", "age": 21, "stance": "orthodox",
		"style": "Pressure fighter", "w": 2, "l": 2, "rating": 58.5, "threat": "Body hooks in close", "weak": "Walks in straight"},
	{"name": "Holly Price", "first": "Holly", "club": "Lynn AC", "age": 19, "stance": "orthodox",
		"style": "Out-boxer", "w": 2, "l": 1, "rating": 59.0, "threat": "Long jab, keeps you on the end of it", "weak": "Backs straight onto the ropes"},
	{"name": "Ellie Ward", "first": "Ellie", "club": "Earlsfield ABC", "age": 20, "stance": "southpaw",
		"style": "Pressure fighter", "w": 4, "l": 2, "rating": 61.0, "threat": "Right hook to the body off the jab", "weak": "Drops the right after the hook"},
	{"name": "Jade Cooper", "first": "Jade", "club": "Islington Boxing Club", "age": 19, "stance": "orthodox",
		"style": "Slugger", "w": 1, "l": 1, "rating": 57.0, "threat": "One big overhand right", "weak": "Slow feet, moves in straight lines"},
]

## Club shows on the calendar: every other Saturday from day 12, names in turn. Rivals fight at each.
const SHOW_NAMES: Array[String] = ["York Hall club show", "London ABC novices", "Repton open show", "Fitzroy Lodge home show"]
const SHOW_FIRST_DAY := 12
const SHOW_EVERY_DAYS := 14

## Sponsors: the first is on the table from the start; the second comes after her first win.
const DEALS: Array[Dictionary] = [
	{"id": "ironclad", "name": "Ironclad Supplements", "per": 250, "what": "banner on the gym wall", "after_win": false},
	{"id": "bowroad", "name": "Bow Road Physio", "per": 150, "what": "their logo on the shorts", "after_win": true},
]

## The gym's kit. A worn piece can be repaired once; members notice (+REPAIR_REPUTATION).
const FACILITIES: Array[Dictionary] = [
	{"id": "floor", "name": "Training floor", "state": "good", "repair": 0},
	{"id": "ring", "name": "Ring", "state": "good", "repair": 0},
	{"id": "bags", "name": "Heavy bags x4", "state": "worn", "repair": 120},
	{"id": "lockers", "name": "Locker room", "state": "good", "repair": 0},
	{"id": "office", "name": "Office", "state": "good", "repair": 0},
]
const REPAIR_REPUTATION := 2

const COACH_IDS: Array[String] = ["reid", "hale"]

## Week 4: the divisions the gym's fighters box in (women only in this build: every line of text says "she").
## opponents = offered in turn (even matches); mismatch = the open fighter the novice rule keeps away.
const DIVISIONS := {
	"wlw": {"name": "Lightweight, women's amateur", "short": "lightweight", "limit": 61.2,
		"opponents": ["Maria Ortega", "Priya Nair", "Erin Doyle"], "mismatch": "Dana Whitfield"},
	"wfw": {"name": "Featherweight, women's amateur", "short": "featherweight", "limit": 57.0,
		"opponents": ["Holly Marsh", "Grace Adeyemi", "Nina Kowalski"], "mismatch": "Bethany Cole"},
	"www": {"name": "Welterweight, women's amateur", "short": "welterweight", "limit": 66.0,
		"opponents": ["Jade Okoro", "Laura Finch", "Rosa Delgado"], "mismatch": "Kerry Walsh"},
	"wmw": {"name": "Middleweight, women's amateur", "short": "middleweight", "limit": 75.0,
		"opponents": ["Amy Croft", "Siobhan Byrne", "Leah Morgan"], "mismatch": "Victoria Hale"},
}

## The other divisions' amateurs (fictional fighters, real club names).
const DIVISION_RIVALS: Array[Dictionary] = [
	{"div": "wfw", "name": "Holly Marsh", "first": "Holly", "club": "Fisher ABC", "age": 19, "stance": "orthodox", "style": "Pressure fighter", "w": 1, "l": 1, "rating": 58.0, "threat": "Wide hooks in close", "weak": "Fades after round 2"},
	{"div": "wfw", "name": "Grace Adeyemi", "first": "Grace", "club": "Lynn AC", "age": 21, "stance": "southpaw", "style": "Counter-puncher", "w": 3, "l": 1, "rating": 61.0, "threat": "Straight left down the middle", "weak": "Slow to start"},
	{"div": "wfw", "name": "Nina Kowalski", "first": "Nina", "club": "Double Jab ABC", "age": 22, "stance": "orthodox", "style": "Volume puncher", "w": 5, "l": 2, "rating": 63.0, "threat": "Never stops throwing", "weak": "Leaves the chin open"},
	{"div": "wfw", "name": "Bethany Cole", "first": "Bethany", "club": "Repton Boxing Club", "age": 25, "stance": "orthodox", "style": "Boxer-puncher", "w": 15, "l": 3, "rating": 70.0, "threat": "Everything", "weak": "None you can use yet"},
	{"div": "wfw", "name": "Megan Price", "first": "Megan", "club": "Stonebridge ABC", "age": 20, "stance": "orthodox", "style": "Pressure fighter", "w": 2, "l": 2, "rating": 58.5, "threat": "Body hooks", "weak": "Walks in straight"},
	{"div": "www", "name": "Jade Okoro", "first": "Jade", "club": "Haringey Police CC", "age": 22, "stance": "orthodox", "style": "Boxer-puncher", "w": 2, "l": 1, "rating": 59.5, "threat": "Straight right", "weak": "Stands still after combinations"},
	{"div": "www", "name": "Laura Finch", "first": "Laura", "club": "Islington BC", "age": 24, "stance": "orthodox", "style": "Pressure fighter", "w": 4, "l": 2, "rating": 62.0, "threat": "Left hook to the body", "weak": "Fades after round 2"},
	{"div": "www", "name": "Rosa Delgado", "first": "Rosa", "club": "Earlsfield ABC", "age": 23, "stance": "southpaw", "style": "Counter-puncher", "w": 6, "l": 2, "rating": 64.5, "threat": "Left cross over the jab", "weak": "Gives away round 1"},
	{"div": "www", "name": "Kerry Walsh", "first": "Kerry", "club": "St Pancras ABC", "age": 27, "stance": "orthodox", "style": "Boxer-puncher", "w": 14, "l": 4, "rating": 71.0, "threat": "Everything", "weak": "None you can use yet"},
	{"div": "www", "name": "Tia Benson", "first": "Tia", "club": "Lion ABC", "age": 21, "stance": "orthodox", "style": "Volume puncher", "w": 3, "l": 3, "rating": 60.0, "threat": "Three-punch flurries", "weak": "Heavy legs late"},
	{"div": "wmw", "name": "Amy Croft", "first": "Amy", "club": "Dale Youth ABC", "age": 23, "stance": "orthodox", "style": "Pressure fighter", "w": 4, "l": 3, "rating": 61.0, "threat": "Overhand right", "weak": "Fades after round 2"},
	{"div": "wmw", "name": "Siobhan Byrne", "first": "Siobhan", "club": "West Ham Boxing Club", "age": 25, "stance": "orthodox", "style": "Boxer-puncher", "w": 5, "l": 2, "rating": 63.0, "threat": "Jab-cross down the middle", "weak": "Slow to start"},
	{"div": "wmw", "name": "Leah Morgan", "first": "Leah", "club": "Fitzroy Lodge ABC", "age": 26, "stance": "southpaw", "style": "Counter-puncher", "w": 7, "l": 3, "rating": 65.0, "threat": "Counter left hook", "weak": "Leaves the chin open"},
	{"div": "wmw", "name": "Victoria Hale", "first": "Victoria", "club": "Repton Boxing Club", "age": 28, "stance": "orthodox", "style": "Boxer-puncher", "w": 16, "l": 2, "rating": 72.5, "threat": "Everything", "weak": "None you can use yet"},
	{"div": "wmw", "name": "Chantelle Reid", "first": "Chantelle", "club": "All Stars ABC", "age": 24, "stance": "orthodox", "style": "Volume puncher", "w": 3, "l": 4, "rating": 59.0, "threat": "Never stops throwing", "weak": "Walks in straight"},
]

## The prospects scouting can bring in for a trial. Before a trial only a range is known (stat +/- SCOUT_SPREAD).
## S334 (operator Q-S294-55 "make some younger too 16-18 yo"): Kira and Samira are 18, with their own young faces
## (Faces.CAST); under 19 they cannot enter the Elite Nationals yet (SeasonPath.AGE_MIN) - a girl to bring up.
const SCOUT_SPREAD := 5
const PROSPECTS: Array[Dictionary] = [
	{"id": "kira", "name": "Kira Mensah", "first": "Kira", "age": 18, "wc": "Featherweight", "div": "wfw", "weight": 58.3,
		"stance": "orthodox", "style": "Out-boxer", "w": 1, "l": 0, "pot": 86, "note": "fast hands, thin chin",
		"stats": {"power": 54.0, "speed": 66.5, "technique": 59.0, "defense": 57.5, "conditioning": 58.0, "fight_iq": 57.0, "chin": 52.0}},
	{"id": "samira", "name": "Samira Khan", "first": "Samira", "age": 18, "wc": "Welterweight", "div": "www", "weight": 67.4,
		"stance": "orthodox", "style": "Slugger", "w": 2, "l": 1, "pot": 82, "note": "raw power, no defence",
		"stats": {"power": 66.0, "speed": 57.0, "technique": 54.5, "defense": 50.5, "conditioning": 60.0, "fight_iq": 54.0, "chin": 63.0}},
	{"id": "tess", "name": "Tess Reilly", "first": "Tess", "age": 23, "wc": "Middleweight", "div": "wmw", "weight": 76.1,
		"stance": "southpaw", "style": "Pressure fighter", "w": 6, "l": 4, "pot": 76, "note": "tough, slow feet",
		"stats": {"power": 62.0, "speed": 55.0, "technique": 58.5, "defense": 58.0, "conditioning": 64.0, "fight_iq": 59.5, "chin": 67.0}},
]

## Move mastery: the punches the gym teaches, which week card drills which, and where a fighter starts.
const MOVES: Array[String] = ["Jab", "Cross", "Lead hook", "Body hook", "Uppercut", "Check hook"]
const CARD_MOVES := {"Jab and move": "Jab", "Body work": "Body hook", "Pad rounds": "Cross", "Defence drills": "Check hook"}
## Starting mastery as a share of her technique: the jab is her best, the last two she has never drilled.
const START_MOVE_SHARE := {"Jab": 0.85, "Cross": 0.75, "Lead hook": 0.62, "Body hook": 0.5, "Uppercut": 0.0, "Check hook": 0.0}


## The per-fighter career state every signed fighter carries (week 4: bouts, camps and talks are per fighter).
static func fighter_state(f: Dictionary, day: int) -> Dictionary:
	var moves := {}
	for m in MOVES:
		moves[m] = snappedf(float(f["stats"]["technique"]) * float(START_MOVE_SHARE[m]), 0.1)
	var div := str(f.get("div", "wlw"))
	# Fight model step 1: footwork, style dials, personality, habits and morale (old saves get theirs here too).
	return FighterProfile.ensure(f.merged({
		"div": div, "limit": float(DIVISIONS[div]["limit"]), "offers": [], "bout": {}, "camp": {}, "goal_talk": false,
		"next_offer_day": day + 8, "opp_index": 0, "rank": 0, "week_start": (f["stats"] as Dictionary).duplicate(),
		"moves": moves, "learning": "Uppercut", "booked_fight": false, "history": [], "goal": {}, "cards": f.get("cards", []),
		"focus": f.get("focus", "conditioning"), "diet": "hold", "fatigue": 8, "weekly_salary": 250, "pro": false,
	}, false))
