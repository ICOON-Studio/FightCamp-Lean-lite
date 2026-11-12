extends RefCounted
## ASKPROBE1 / ASK2: ask for a fight (ops/research/ASKFIGHT_MAP_S441.md v2). Pure static module: plain Dictionaries and
## Arrays in, plain Dictionaries out; the caller reads the career. No state script is preloaded: the game's numbers that live
## in state scripts come in as arguments (after_fight = Bouts.AFTER_FIGHT, min_wins = Region.RANK_MIN_WINS, the date words =
## Clock.fmt as a Callable), so a re-tune there moves this too.
## fighter f {name, w, l, d, pro, discipline, booked, bout_day, offer_waiting, offer_expires, fit, healed_day, in_nationals,
##   nationals_end, last_bout_day, weight, limit, rank, nationals_need, nationals_by, pro_wins, pro_rank, pro_wins_any}
## division rows [{name, club, w, l, rating, style, ours}] (Region.rankings shape: our ranked fighters are in it, ours = true).
## Game text never says he, she, her or him.

const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## The ask is for the next club show at least this many days away (today's shortest lead, AmateurBooking LEAD_WEEKS_MIN
## weeks; the map: 7 once AMATEURWEEK1's fight week lands).
const MIN_LEAD_DAYS := AmateurBooking.LEAD_WEEKS_MIN * 7
## A picked name: up to this many places either side of the fighter on the ladder.
const PICK_REACH := 4
## Map v3 s3: the camp line follows the game's own phases (WeekPhase: BUILD 3+ weeks, PEAK two weeks, fight week TAPER) and
## BoutRules.CAMP_MIN_DAYS (Set camp needs 7 days). S445: a 14-day show is a PEAK camp, not "no camp" (Kalli + John S444).
const CAMP_WEEKS := 3
## Club shows run this often; the road says when the nationals' bouts cannot be made from the printed show (map v3 s3).
const SHOW_GAP_DAYS := 14


## Map s5: when the ask is open. {open, why, opens_day}; opens_day -1 = no day known (or never).
static func open(f: Dictionary, day: int, after_fight: int) -> Dictionary:
	var nm := str(f.get("name", "This fighter"))
	if bool(f.get("pro", false)):
		return _closed("%s is a pro: the promoters' offers stay the way to a bout." % nm, -1)
	if str(f.get("discipline", "boxing")) == "bjj":
		return _closed("%s fights on the mats: BJJ nights are not club shows." % nm, -1)
	if bool(f.get("in_nationals", false)):
		return _closed("%s is entered in the nationals." % nm, int(f.get("nationals_end", -1)))
	if int(f.get("w", 0)) + int(f.get("l", 0)) + int(f.get("d", 0)) == 0 and int(f.get("last_bout_day", -1)) < 0 			and not bool(f.get("booked", false)):
		return _closed("%s's first bout comes from the sheet; asking opens after it is fought." % nm, -1)
	if bool(f.get("booked", false)):
		var bd := int(f.get("bout_day", -1))
		return _closed("%s already has a bout booked." % nm, bd + after_fight if bd >= 0 else -1)
	if bool(f.get("offer_waiting", false)):
		var ex := int(f.get("offer_expires", -1))
		return _closed("A bout offer for %s still waits for an answer." % nm, ex + 1 if ex >= 0 else -1)
	if not bool(f.get("fit", true)):
		var heal := int(f.get("healed_day", -1))
		if heal < 0:
			return _closed("%s is not fit, and no heal day is known yet." % nm, -1)
		return _closed("%s is not fit: injured or suspended." % nm, heal)
	var due := int(f.get("last_bout_day", -9999)) + after_fight
	if day < due:
		return _closed("Too soon after the last bout: %d days must pass." % after_fight, due)
	return {"open": true, "why": "", "opens_day": -1}


static func _closed(why: String, opens_day: int) -> Dictionary:
	return {"open": false, "why": why, "opens_day": opens_day}


## Map s3: the next show at least MIN_LEAD_DAYS away that none of ours holds. taken_by_ours [{name, day}];
## fmt = Clock.fmt. {day, days_away, why}: why names the fighter and the night held, "" when the first show was free.
static func show_day(day: int, show_days: Array, taken_by_ours: Array, fmt: Callable) -> Dictionary:
	var days: Array = show_days.duplicate()
	days.sort()
	var why := ""
	for sd in days:
		var d := int(sd)
		if d - day < MIN_LEAD_DAYS:
			continue
		var holder := _holder(d, taken_by_ours)
		if holder != "":
			if why == "":
				why = "%s is already on %s." % [holder, str(fmt.call(d))]
			continue
		return {"day": d, "days_away": d - day, "why": why}
	return {"day": -1, "days_away": -1, "why": why if why != "" else "No club show is on the calendar yet."}


static func _holder(d: int, taken_by_ours: Array) -> String:
	for t in taken_by_ours:
		if t is Dictionary and int((t as Dictionary).get("day", -1)) == d:
			return str((t as Dictionary).get("name", ""))
	return ""


## Map s2: the answers, each {kind: "sheet"|"step_up"|"name", names, gate}. A kind with no legal name is ABSENT.
static func answers(f: Dictionary, rows: Array, next_in_turn: String, min_wins: int) -> Array:
	var out: Array = []
	var own_bouts := AmateurBooking.bouts_of(int(f.get("w", 0)), int(f.get("l", 0)), int(f.get("d", 0)))
	var me := str(f.get("name", ""))
	var sheet := ""
	if next_in_turn != "" and next_in_turn != me and _legal(_row(rows, next_in_turn), own_bouts):
		sheet = next_in_turn
		out.append({"kind": "sheet", "names": [sheet], "gate": false})
	var step := step_up(f, rows, min_wins)
	if step != "" and step != sheet:
		out.append({"kind": "step_up", "names": [step], "gate": false})
	var picked := picks(f, rows, min_wins, [sheet, step])
	if not picked.is_empty():
		out.append({"kind": "name", "names": picked, "gate": true})
	return out


## A row by name, {} when absent.
static func _row(rows: Array, name: String) -> Dictionary:
	for r in rows:
		if str((r as Dictionary).get("name", "")) == name:
			return r
	return {}


## An opponent we may be offered: in the table, not ours, inside the novice rule.
static func _legal(r: Dictionary, own_bouts: int) -> bool:
	if r.is_empty() or bool(r.get("ours", false)):
		return false
	return AmateurBooking.experience_match_ok(own_bouts, AmateurBooking.bouts_of(int(r.get("w", 0)), int(r.get("l", 0))))


## The fighter's place on the ladder by NAME (RankLine's order), 0 when unranked or absent from the rows.
static func place_of(rows: Array, name: String, min_wins: int) -> int:
	return RankLine._rank_of(RankLine._ranked(rows, min_wins), name)


## A STEP UP. Ranked: the nearest legal name ABOVE on the ladder (ours and illegal names are passed over). Unranked: the
## nearest better record inside the novice rule (smallest net wins above our own, then fewest wins, then lowest rating).
## "" when there is none, or when a ranked fighter's own row is missing.
static func step_up(f: Dictionary, rows: Array, min_wins: int) -> String:
	var w := int(f.get("w", 0))
	var l := int(f.get("l", 0))
	var own_bouts := AmateurBooking.bouts_of(w, l, int(f.get("d", 0)))
	var me := str(f.get("name", ""))
	if w >= min_wins:
		var table := RankLine._ranked(rows, min_wins)
		var at := RankLine._rank_of(table, me) - 1
		if at < 0:
			return ""
		for i in range(at - 1, -1, -1):
			if _legal(table[i], own_bouts):
				return str(table[i]["name"])
		return ""
	var best: Dictionary = {}
	for r in rows:
		var rd: Dictionary = r
		if str(rd.get("name", "")) == me or not _legal(rd, own_bouts):
			continue
		var net := int(rd.get("w", 0)) - int(rd.get("l", 0))
		if net <= w - l:
			continue
		if best.is_empty() or _nearer(rd, best):
			best = rd
	return str(best.get("name", ""))


static func _nearer(x: Dictionary, y: Dictionary) -> bool:
	var nx := int(x["w"]) - int(x["l"])
	var ny := int(y["w"]) - int(y["l"])
	if nx != ny:
		return nx < ny
	if int(x["w"]) != int(y["w"]):
		return int(x["w"]) < int(y["w"])
	return float(x.get("rating", 0.0)) < float(y.get("rating", 0.0))


## A NAME YOU PICK: legal names up to PICK_REACH places ABOVE, never ours, never one of `not_these` (the sheet and step-up
## names). Only for a fighter on the ladder (found by name). S443 operator Q-S294-204 "Only above or level": a pick from below
## won 6 of 7 cases in the season probe (docs/ASKPROBE1_RESULT.md); above only, the plan's pick wins 4 of 7.
static func picks(f: Dictionary, rows: Array, min_wins: int, not_these: Array) -> Array:
	var table := RankLine._ranked(rows, min_wins)
	var at := RankLine._rank_of(table, str(f.get("name", ""))) - 1
	if at < 0:
		return []
	var own_bouts := AmateurBooking.bouts_of(int(f.get("w", 0)), int(f.get("l", 0)), int(f.get("d", 0)))
	var out: Array = []
	for i in range(maxi(0, at - PICK_REACH), at):
		var nm := str(table[i]["name"])
		if i == at or not_these.has(nm) or not _legal(table[i], own_bouts):
			continue
		out.append(nm)
	return out


## Map s3: the top strip. show = show_day()'s answer; forecast = Sim.weigh_forecast's {day, limit, ok}; fmt = Clock.fmt.
static func strip(f: Dictionary, show: Dictionary, forecast: Dictionary, fmt: Callable) -> Dictionary:
	var away := int(show.get("days_away", -1))
	var camp := away >= BoutRules.CAMP_MIN_DAYS
	var risk := not bool(forecast.get("ok", true))
	return {"days_away": away, "camp": camp, "camp_words": camp_words(away),
		"weight": "%.1f kg now, limit %.1f kg, %.1f kg forecast on the scale." % [float(f.get("weight", 0.0)),
			float(forecast.get("limit", f.get("limit", 0.0))), float(forecast.get("day", f.get("weight", 0.0)))],
		"weight_risk": risk, "risk_words": "Weight at risk" if risk else "",
		# Map v3 s3: a scale miss never leaves Ask armed on that date: the panel offers Wait and the show after.
		"ask_ok": not risk, "road": road(f, fmt, int(show.get("day", -1)))}


## The camp line in the phase words the camp screen uses. away < 0 (no show) = "".
static func camp_words(away: int) -> String:
	if away < 0:
		return ""
	if away >= CAMP_WEEKS * 7:
		return "Camp can be set: BUILD, PEAK and fight week."
	if away > 7:
		return "Two weeks: a PEAK camp, no BUILD."
	if away >= BoutRules.CAMP_MIN_DAYS:
		return "Fight week only: a light camp, no sparring."
	return "No camp: under a week to fight night."


## The live road in one chip: the nationals first while bouts are still needed, then the pro offer. What is STILL needed.
static func road(f: Dictionary, fmt: Callable, show_day: int = -1) -> String:
	var need := int(f.get("nationals_need", 0))
	if need > 0:
		var by := int(f.get("nationals_by", 0))
		if show_day >= 0 and need > (1 + int(floor(float(by - show_day) / SHOW_GAP_DAYS)) if show_day <= by else 0):
			return "The nationals' %d bout%s by %s cannot be made from this show." % [need, "" if need == 1 else "s",
				str(fmt.call(by))]
		return "%d bout%s still needed for the nationals by %s." % [need, "" if need == 1 else "s",
			str(fmt.call(int(f.get("nationals_by", 0))))]
	var w := int(f.get("w", 0))
	var any_need := maxi(0, int(f.get("pro_wins_any", 9)) - w)
	if any_need == 0:
		return "The pro offer is due: the wins are there."
	var rank := int(f.get("rank", 0))
	if rank <= 0:
		return "%d more win%s for the pro offer." % [any_need, "" if any_need == 1 else "s"]
	var win_need := maxi(0, int(f.get("pro_wins", 7)) - w)
	var top := int(f.get("pro_rank", 3))
	var place := "a top-%d place (now number %d)" % [top, rank] if rank > top else ""
	if win_need == 0 and place == "":
		return "The pro offer is due: the wins and the place are there."
	if win_need == 0:
		return "%s for the pro offer, or %d more win%s." % [place.substr(0, 1).to_upper() + place.substr(1), any_need, "" if any_need == 1 else "s"]
	var wins := "%d more win%s" % [win_need, "" if win_need == 1 else "s"]
	return "%s%s for the pro offer." % [wins, " and " + place if place != "" else " in the top %d" % top]


## Map s4: one card, raw facts only, every value words (no number the player can sort by). The two words (FightLearn.word,
## FightLearn.stop_word) come from the caller; the place from RankLine.
## label: map v3 s2 - "A step up" only when it is one by place; for an unranked fighter the card is "Nearest better record".
static func card(opp: Dictionary, kind: String, rows: Array, min_wins: int, teach_words: String = "", stop_words: String = "",
		fighter_ranked: bool = true) -> Dictionary:
	var nm := str(opp.get("name", ""))
	return {"label": label(kind, fighter_ranked), "name": nm, "club": str(opp.get("club", "")), "record": "%d-%d" % [int(opp.get("w", 0)), int(opp.get("l", 0))],
		"place": str(RankLine.before(rows, nm, min_wins)["words"]), "style": str(opp.get("style", "")),
		"teaches": teach_words, "stoppage": stop_words,
		"gate": "The host keeps the gate: $0 for the club." if kind == "name" else
			"The club keeps the $%d ticket cut." % BoutRules.TICKET_CUT}


static func label(kind: String, fighter_ranked: bool) -> String:
	match kind:
		"sheet":
			return "The name the sheet would send"
		"step_up":
			return "A step up" if fighter_ranked else "Nearest better record"
		"name":
			return "A name you pick"
	return ""
