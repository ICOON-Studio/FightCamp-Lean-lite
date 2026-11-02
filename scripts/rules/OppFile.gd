extends RefCounted
## S341 scouting in stages (operator Q-S294-65 "Yes, build it in that order"; Game Godot/research/SCOUTING_S340.md steps 1-2):
## every opponent is a file to decode. Her record, look and style word are free at booking; her best weapon, each habit the
## ring plays (RoundStyle.opponent_habits) and her weakness are hidden until found. Tape study in camp opens one a session,
## every TAPE_EVERY camp days, best weapon first and the weakness last (a coach looks for what hurts first, what he can use
## after). Each tell names its counter: a plan branch (`when`, PlanFight's situations), a corner call (BoutRules.CORNER key)
## or a camp drill. The film depth the fight reads (BoutRules.FILM_EDGE_PER_DEPTH) follows the share found, so a full camp
## still ends at depth 3 and the balance is unchanged; a short camp or no tape leaves her a stranger on the night.
## S341 (operator: "the records should always keep all information available for the other opponents (history)"): what is
## found is written to the career's record of her (remember), so a rematch starts with it; a bout against her opens her
## whole file (open_all: three rounds show everything); history() lists every bout our gym has had with her.
##   tells(opp) -> [{id, what, value, counter, call, when, how}]   known(opp, id)   hidden(opp)   found(opp)
##   tape(opp) -> id found ("" when the file is open)   sessions_due(start, day)   film_depth(opp)   main_game(opp)
##   remember(record, opp)   open_all(opp)   history(results, name) -> results with her, newest first
## Pure static; preloads the style table (Exchanges), the habit words (RoundStyle) and the WHEN words (FightFlow). State: opp["file_found"] (tell ids).

const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")

const TAPE_EVERY := 2
const DEPTH_NONE := 1
const DEPTH_ALL := 3
## Her style word's main game in the coach's words (Exchanges.STYLE_MODES, the game she plays most).
const GAME_WORDS := {"press": "walks you down", "range": "boxes at range", "counter": "waits to counter",
	"loadup": "loads up big shots"}

## [words in her threat, the answer, corner call, plan situation]: the first match is her counter (real coaching cues).
const WEAPON_ANSWERS := [
	["over the jab", "Never a lazy jab: feint first and draw the lead", "lead", "counter"],
	["counter", "Never a lazy jab: feint first and draw the lead", "lead", "counter"],
	["long jab", "Get under the jab: slip it and go to the body", "body", "range"],
	["body", "Elbows tight on the ribs; step off at an angle, never square in front", "hands", "press"],
	["hooks in close", "Stay at the end of your jab; tie up on the way in", "long", "press"],
	["overhand", "Hands up, chin down: roll under it and come back", "hands", "loadup"],
	["heavy right", "Hands up, chin down: roll under it and come back", "hands", "loadup"],
	["straight", "Move off the centre line: slip outside it and counter", "hands", "range"],
	["down the middle", "Move off the centre line: slip outside it and counter", "hands", "range"],
	["never stops", "Tie up, force a reset, counter between the flurries", "tie", "press"],
	["flurries", "Tie up, force a reset, counter between the flurries", "tie", "press"],
	["everything", "Nothing to single out: box your own fight", "", ""],
]
const WEAKNESS_ANSWERS := [
	["fades", "Make it a busy start; let your hands go on the fade", "let_go", "tiring"],
	["legs late", "Make it a busy start; let your hands go on the fade", "let_go", "tiring"],
	["slow to start", "Start fast and bank round 1 before she warms up", "let_go", ""],
	["gives away round 1", "Start fast and bank round 1 before she warms up", "let_go", ""],
	["chin", "The chin is there: the straight right over the jab", "", ""],
	["drops the right", "The chin is there after the hook: counter with the left", "", ""],
	["walks in straight", "Angles: pivot off as she comes, she cannot follow", "long", "press"],
	["straight lines", "Angles: pivot off as she comes, she cannot follow", "long", "press"],
	["backs straight", "Cut the ring off: she backs onto the ropes", "finish", "range"],
	["backed up", "Cut the ring off: she backs onto the ropes", "finish", "range"],
	["stands still after", "Counter when she stops: slip and come back", "", ""],
	["none", "Nothing yet: the fight will show it", "", ""],
]
## What the coach writes for a habit (the ring plays it; THE READ finds it in the fight).
const HABIT_WORDS := {"fades_late": "Hands drop late in a round", "slow_starter": "Takes a round to get going",
	"drops_right_after_jab": "Drops the right after the jab", "lunges_with_jab": "Lunges in behind the jab",
	"admires_her_work": "Stands and admires after a combination", "digs_body_when_hurt": "Goes to the body when she is hurt",
	"loads_up_when_hurt": "Loads up wild when she is hurt"}


## Every tell in her file, free ones first, then the hidden ones in the order tape study opens them.
static func tells(opp: Dictionary) -> Array:
	var out: Array = []
	out.append({"id": "look", "what": "Record and look", "how": "booking", "call": "", "when": "", "counter": "",
		"value": "%d-%d, %s, %s cm, reach %s" % [int(opp.get("w", 0)), int(opp.get("l", 0)), str(opp.get("stance", "?")),
			str(opp.get("height", "?")), str(opp.get("reach", "?"))]})
	var game := main_game(opp)
	out.append({"id": "style", "what": "Game", "how": "booking", "call": "", "when": game,
		"value": "%s: %s" % [str(opp.get("style", "?")), str(GAME_WORDS.get(game, "own way"))],
		"counter": "Plan an arrow for 'If %s'" % str(FightFlow.WHEN_WORDS.get(game, "she presses")) if game != "" else ""})
	var w := _answer(str(opp.get("threat", "")), WEAPON_ANSWERS)
	out.append({"id": "weapon", "what": "Best weapon", "how": "tape", "value": str(opp.get("threat", "?")),
		"counter": w[0], "call": w[1], "when": w[2]})
	for h in RoundStyle.opponent_habits(opp):
		out.append({"id": "habit:" + str(h), "what": "Habit", "how": "tape", "value": str(HABIT_WORDS.get(h, h)),
			"counter": "THE READ: the corner shouts the counter when she does it", "call": "", "when": ""})
	var k := _answer(str(opp.get("weak", "")), WEAKNESS_ANSWERS)
	out.append({"id": "weakness", "what": "Weakness", "how": "tape", "value": str(opp.get("weak", "?")),
		"counter": k[0], "call": k[1], "when": k[2]})
	return out


## The game her style plays most (Exchanges.STYLE_MODES); "" for a style the table does not know.
static func main_game(opp: Dictionary) -> String:
	var mix: Dictionary = Exchanges.STYLE_MODES.get(str(opp.get("style", "")), {})
	var best := ""
	for g in mix:
		if best == "" or float(mix[g]) > float(mix[best]):
			best = str(g)
	return best


static func known(opp: Dictionary, id: String) -> bool:
	return id == "look" or id == "style" or (opp.get("file_found", []) as Array).has(id)


## The tells still hidden, in the order tape study opens them.
static func hidden(opp: Dictionary) -> Array:
	return tells(opp).filter(func(t): return not known(opp, str(t["id"]))).map(func(t): return str(t["id"]))


## The hidden tells found so far (free ones not counted).
static func found(opp: Dictionary) -> Array:
	return tells(opp).filter(func(t): return str(t["how"]) != "booking" and known(opp, str(t["id"]))).map(func(t): return str(t["id"]))


## One tape session: opens the next hidden tell. A habit also goes in her CoachNotes (the FILM ON HER lines, the ring).
static func tape(opp: Dictionary) -> String:
	var left := hidden(opp)
	if left.is_empty():
		return ""
	var id := str(left[0])
	open(opp, id)
	return id


## S343 opens one tell (the tape room: watching her film finds what it shows). False when it was already known.
static func open(opp: Dictionary, id: String) -> bool:
	if known(opp, id):
		return false
	if not opp.has("file_found"):
		opp["file_found"] = []
	(opp["file_found"] as Array).append(id)
	if id.begins_with("habit:"):
		if not opp.has("notes_seen"):
			opp["notes_seen"] = []
		if not (opp["notes_seen"] as Array).has(id):
			(opp["notes_seen"] as Array).append(id)
	return true


## Writes what is found of her (her file and the coach's notes on her habits) into `record` (the career's rival entry):
## a union, so nothing found is ever lost.
static func remember(record: Dictionary, opp: Dictionary) -> void:
	if record.is_empty():
		return
	for key in ["file_found", "notes_seen"]:
		var have: Array = record.get(key, [])
		for id in opp.get(key, []):
			if not have.has(id):
				have.append(id)
		record[key] = have


## The fight shows everything: after a bout against her, her whole file is open.
static func open_all(opp: Dictionary) -> void:
	while tape(opp) != "":
		pass


## Every bout our gym has had with her (Career.results rows: d, who, win, outcome, cards), newest first.
static func history(results: Array, name: String) -> Array:
	return results.filter(func(r): return str(r.get("opp", "")) == name)


## Tape sessions a camp that began on `start` has had by `day`: one on its first day, then one every TAPE_EVERY days.
static func sessions_due(start: int, day: int) -> int:
	return 0 if day < start else 1 + int((day - start) / TAPE_EVERY)


## The film depth the fight reads: 1 with nothing found, 3 with the whole file open.
static func film_depth(opp: Dictionary) -> int:
	var all := tells(opp).filter(func(t): return str(t["how"]) != "booking").size()
	if all == 0:
		return DEPTH_ALL
	return DEPTH_NONE + roundi(float(DEPTH_ALL - DEPTH_NONE) * float(found(opp).size()) / float(all))


## [answer, call, when] for the first row whose words her text holds.
static func _answer(text: String, rows: Array) -> Array:
	var low := text.to_lower()
	for r in rows:
		if low.contains(str(r[0])):
			return [str(r[1]), str(r[2]), str(r[3])]
	return ["", "", ""]
