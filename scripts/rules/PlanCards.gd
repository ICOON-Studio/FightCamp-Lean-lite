extends RefCounted
## S382 PLANTRAY1 (TRAINING_SCREEN_S381.md sections 2-5, build order item 4): the Training tab's tray in camp mode. When a
## bout is booked the tray stops being LEARN and becomes "THE PLAN vs <opponent>": the drill cards the Game plan needs.
## - The cards, in the order the coach spreads them on the pad nights: the GO-TO combination (f["plan_combo"]), then every
##   combination line of the plan (f["arrows"], PlanLines ring order; its first any-time combination is the R1 OPENER, a
##   line in the situation a found tell names is an ANSWER), then the answers to found tells (FilmEdge.rows) no line
##   covers yet: the first book combination that beats that situation (PlanFight.fit "best"). A line's combination whose
##   punch she has not got (under Combos.LEARN_AT) is the punch's card - she drills the punch first.
## - Fight night: a card under 30 whose road to the fight (fight_paths: the camp's real weeks - film's week, the taper's
##   half pads, the coach re-laying the plan) does not cross 30 in a week that ends before the bout wears the red stamp
##   and the line "not usable by fight night". The week's drilling lands on Sunday night (Sim.end_week), so a crossing in
##   the fight's own week is too late. A combination's stamp is "UNDRILLED x0.8" (PlanBoard.UNDRILLED, the rate it plays
##   at); a punch's card is "NOT THROWN" (a line with a punch under 30 is greyed on the night - StrikeMap.grey_reason).
##   Only the plan's cards are stamped. In camp the Playbook's "Drill it" puts the combination on a night (drill_it).
## - The coach's camp week (PadWeek.defaults while active): the plan's drillable cards on the pad nights in that order,
##   one card a night, round again when there are more nights than cards.
## - After the fight (the bout done or gone) the tray is LEARN again and the coach's week is the old one.
## - Sparring nights name the outside partner the camp booked ("southpaw mate", BoutRules.partner_word; CampMatch).
##   active(f)  opp(f)  entries(f) -> [{card, tag, sub}]  cards(f)  tray(f, week, n)  card_for(f, sm_move_id)
##   usable_by(f, card, proj, monday, fight_day)  fight_paths(f, inp, day, fight_day)  dress(f, projs, monday, fight_day, paths)
##   coach_week(f, nights)  partner(f)  drill_it(f, combo_id)
## Pure static on the fighter dictionary.

const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

const GO_TO := "GO-TO"
const OPENER := "R1 OPENER"
const PLAN := "PLAN"
const ANSWER := "ANSWER"
## The stamp's words: PlanBoard.UNDRILLED, the rate an undrilled combination plays at on the night.
const STAMP := "UNDRILLED x0.8"
## A punch's card: the line it stands for is greyed on the night (not x0.8 - not thrown at all).
const STAMP_PUNCH := "NOT THROWN"
const LATE := "not usable by fight night"


## A bout booked and not yet fought: the tray is THE PLAN (the same test the board's weeks strip uses).
static func active(f: Dictionary) -> bool:
	var bout: Dictionary = f.get("bout", {})
	return not bout.is_empty() and not bool(bout.get("done", false))


static func opp(f: Dictionary) -> Dictionary:
	return (f.get("bout", {}) as Dictionary).get("opp", {}) if active(f) else {}


## The drill card a plan move stands for: a combination's book card, or the first punch it still lacks; "" for a step,
## a defence or a move the map does not know.
static func card_for(f: Dictionary, move_id: String) -> String:
	var row := StrikeMap.move(move_id)
	if str(row.get("kind", "")) != "combo" or Combos.row(str(row.get("combo", ""))).is_empty():
		return ""
	var missing := Combos.missing(str(row["combo"]), f.get("moves", {}))
	return "move:" + str(missing[0]) if not missing.is_empty() else "combo:" + str(row["combo"])


## The plan's cards with their tags, in the coach's order; a card shows once (its first tag).
static func entries(f: Dictionary) -> Array:
	if not active(f):
		return []
	var out: Array = []
	var seen := {}
	var add := func(card: String, tag: String, sub: String) -> void:
		if card != "" and not seen.has(card) and PadWeek.drillable(f, card):
			seen[card] = true
			out.append({"card": card, "tag": tag, "sub": sub})
	var go := str(f.get("plan_combo", ""))
	if go != "" and not OwnCombos.entry(f, go).is_empty():
		add.call(go, GO_TO, "")
	var tells := FilmEdge.rows(f)
	var opener := false
	for l in PlanLines.lines(f.get("arrows", [])):
		var card := card_for(f, str(l["move"]))
		if card == "":
			continue
		var when := str(l["when"])
		var tag := PLAN
		var sub := ""
		for t in tells:
			if when != "" and str(t["sit"]) == when:
				tag = ANSWER
				sub = _answer_word(t)
				break
		if tag == PLAN and when == "" and not opener:
			opener = true
			tag = OPENER
		if sub == "" and PadWeek.kind(card) == "move":
			sub = "for the " + str(StrikeMap.move(str(l["move"])).get("name", "")).to_lower()
		add.call(card, tag, sub)
	for t in tells:
		if bool(t["answered"]) or str(t["sit"]) == "":
			continue
		for m in StrikeMap.MOVES:
			if str(m["kind"]) == "combo" and PlanFight.fit(str(m["id"]), str(t["sit"])) == "best":
				add.call(card_for(f, str(m["id"])), ANSWER, _answer_word(t))
				break
	return out


static func _answer_word(t: Dictionary) -> String:
	return "answer: " + str(t.get("value", t.get("what", ""))).to_lower()


static func cards(f: Dictionary) -> Array:
	return entries(f).map(func(e): return str(e["card"]))


## THE PLAN's tray: the plan cards the nights drill (plan order), any other card on a night (hers), the plan's other
## cards, then her pins; first n.
static func tray(f: Dictionary, week: Dictionary, n := 4) -> Array:
	var plan := cards(f)
	var on := PadWeek.cards_in(week)
	var want: Array = plan.filter(func(c): return on.has(c))
	want.append_array(on.filter(func(c): return not plan.has(c)))
	want.append_array(plan.filter(func(c): return not on.has(c)))
	want.append_array(f.get("tray", []))
	var out: Array = []
	for c in want:
		if out.size() < n and not out.has(str(c)) and PadWeek.drillable(f, str(c)):
			out.append(str(c))
	return out


## Whether the card is in her hands by fight night: usable now, or the path crosses 30 in a week whose drilling lands
## before the bout. Week w of the path starts on monday + 7 w and its nights land at its end (Sim.end_week on the next
## Monday, monday + 7 (w + 1)), which must be on or before the bout's day - the fight's own week counts for nothing.
static func usable_by(f: Dictionary, card: String, proj: Dictionary, monday: int, fight_day: int) -> bool:
	if PadWeek.mastery(f, card) >= Combos.LEARN_AT:
		return true
	for p in proj.get("path", []):
		if float(p[2]) >= Combos.LEARN_AT:
			return monday + 7 * (int(p[0]) + 1) <= fight_day
	return false


## Each plan card's road to fight night ({card: {path: [[week, dow, m]]}}, usable_by's path) over the camp's real weeks:
## this week as the board lays it (inp = DrillWeek.inputs), then every later week whose drilling lands before the bout
## with the nights its phase lays (WeekPlan.ahead: film's week, the taper's half pads and no sparring) and the coach's
## cards re-laid on her mastery that week (PadWeek.week_of; her own nights stay hers) - what the sim runs if nothing
## changes. PadWeek.project repeats this week's nights, which over- or under-states a camp.
static func fight_paths(f: Dictionary, inp: Dictionary, day: int, fight_day: int) -> Dictionary:
	var out := {}
	for c in cards(f):
		out[c] = {"path": []}
	var monday := day - posmod(day, 7)
	var weeks := maxi(0, (fight_day - monday) / 7)
	if weeks == 0 or out.is_empty():
		return out
	var copy := f.duplicate(true)
	var later := WeekPlan.ahead(f, day, weeks)
	var nights: Dictionary = inp["nights"]
	var week: Dictionary = inp["week"]
	var mults: Dictionary = inp.get("mults", {})
	for w in weeks:
		if w > 0:   # a later week: its phase's nights, no twist card yet
			var a: Array = later[w - 1]
			nights = PadWeek.lay(PadWeek.step_of(f), PadWeek.in_camp(f), str(a[2]), a[1])
			week = PadWeek.week_of(copy, nights)
			mults = {}
		var r := PadWeek.run_week(copy, nights, week, float(inp["skill"]), PadWeek.STATION_TIER, mults, inp.get("carded", []))
		for row in r["log"]:
			if out.has(str(row[1])):
				(out[str(row[1])]["path"] as Array).append([w, int(row[0]), float(row[3])])
	return out


## The projections the tray draws, dressed for camp: each plan card's tag and line; on a plan card that will not be in her
## hands by the fight the stamp (STAMP, a punch's card STAMP_PUNCH) and "not usable by fight night"; a card under 30 the
## camp's later weeks get to 30 reads the week they do ("usable in 3 weeks", PadEdit.eta's words). paths =
## fight_paths (else each proj's own path). Mutates projs (WeekBoard's {card: proj with eta}); other cards are left alone.
static func dress(f: Dictionary, projs: Dictionary, monday: int, fight_day: int, paths := {}) -> void:
	var tags := {}
	for e in entries(f):
		tags[str(e["card"])] = e
	for card in projs:
		if not tags.has(card):
			continue
		var p: Dictionary = projs[card]
		p["tag"] = str(tags[card]["tag"])
		if str(tags[card]["sub"]) != "":
			p["sub"] = str(tags[card]["sub"])
		if not usable_by(f, str(card), paths.get(card, p), monday, fight_day):
			p["stamp"] = STAMP_PUNCH if PadWeek.kind(str(card)) == "move" else STAMP
			p["eta"] = {"text": LATE, "tone": "bad"}
		elif PadWeek.mastery(f, str(card)) < Combos.LEARN_AT and paths.has(card):
			for q in (paths[card] as Dictionary).get("path", []):
				if float(q[2]) >= Combos.LEARN_AT:
					if int(q[0]) > 0:   # week 0 is the board's own projection: its "usable Wed" stands
						p["eta"] = {"text": "usable in %d weeks" % (int(q[0]) + 1), "tone": ""}
					break


## The coach's camp nights: the plan's cards on the pad nights in order, one a night ({} when the plan has none, and the
## coach keeps the week PadWeek lays between fights).
static func coach_week(f: Dictionary, nights: Dictionary) -> Dictionary:
	var plan := cards(f)
	var days: Array = nights.get("pads", [])
	var out := {}
	if plan.is_empty() or days.is_empty():
		return out
	for i in days.size():
		out[PadWeek.DAYS[days[i]]] = [{"card": plan[i % plan.size()], "share": 1.0}]
	return out


## The sparring nights' partner chip: the outside mate the camp booked, else "".
static func partner(f: Dictionary) -> String:
	if not active(f) or not bool((f.get("camp", {}) as Dictionary).get("partner", false)):
		return ""
	return BoutRules.partner_word(opp(f))


## The Playbook's "Drill it" in camp: the coach's camp nights drill the plan (coach_week), so the old slot (combo_learning)
## alone would drill nothing - the combination goes on her first pad night she has not set and into the tray
## (PadEdit.drill_it). id: a book id ("1-2") or her own ("own:1"). The dow, or -1 (no bout, no pad night, not drillable).
static func drill_it(f: Dictionary, id: String) -> int:
	if not active(f) or id == "":
		return -1
	return PadEdit.drill_it(f, PadWeek.nights_of(f), id if id.begins_with("own:") else "combo:" + id)
