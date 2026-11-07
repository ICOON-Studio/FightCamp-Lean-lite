extends RefCounted
## S382 DRILLCARD1 (TRAINING_SCREEN_S381.md sections 3-6, build order item 2): the player's hand on the week's pad nights and
## the words each drill card says. PadWeek runs the nights; this is what a drop, a click, a right-click change, and what
## the card reads from PadWeek.project.
## - place: a card dropped on a PADS night. An empty night takes it whole; a night with one card splits 50/50; a night
##   with two swaps its second card. The night is then hers (f["pad_week"]) and the coach leaves it alone.
## - cycle: a split night's shares go 50/50 -> 70/30 -> 30/70 -> 50/50.
## - remove / clear: one card off a night (the other gets it whole) / the night emptied (it stays empty, PadWeek.week_of).
## - pin: the tray keeps the cards she pinned (TRAY_MAX, oldest out); a pinned card gets sparring shares once usable.
## - drill_it: "+ drill it" on a held card: the punch goes in the tray and on the next pad night she has not set.
## - tray: the cards the tray shows - this week's nights first, then her pins, the coach's new move, her own combinations.
## - eta: the card's one line - "usable Wed", "sharp in 3 weeks", "spar nights only: +3.1 a week", "not on a night - fades".
## - night_rows: per card and night, [before, after] of this week's projection (the PM card's "+5.2").
##   place(f, nights, dow, card)  cycle(f, nights, dow)  remove(f, nights, dow, card)  clear(f, nights, dow)  pin(f, card)
##   drill_it(f, nights, card) -> dow   tray(f, week, n) -> [card]   eta(f, card, proj, week, spar) -> {text, tone}
##   night_rows(f, projs) -> {card: {dow: [before, after]}}   crossing(f, card, proj) -> {tier, dow, before, after}
##   title(f, card) -> "1-1, in, 3"   sub(f, card) -> "jab, jab, step in, lead hook"   kind_word(f, card) -> "NEW MOVE"
## Pure static on the fighter dictionary.

const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const TRAY_MAX := 5
const SPLITS := [[0.5, 0.5], [0.7, 0.3], [0.3, 0.7]]
const TIERS := [[30.0, "usable"], [60.0, "sharp"], [85.0, "signature"]]
const DAY_WORDS := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
## Boxing's numbers for the punches in an own combination's short name ("1-1, in, 3").
const NUMBER := {"jab": "1", "cross": "2", "lead_hook": "3", "body_hook": "3b", "rear_hook": "4", "lead_uppercut": "5",
	"rear_uppercut": "6"}
const SHORT := {"step_in": "in", "step_out": "out", "step_back": "back", "pivot_out": "pivot", "slip": "slip", "roll": "roll",
	"feint": "feint"}


static func _night(f: Dictionary, nights: Dictionary, dow: int) -> Array:
	return ((PadWeek.week_of(f, nights).get(PadWeek.DAYS[dow], []) as Array)).duplicate(true)


static func _write(f: Dictionary, dow: int, list: Array) -> void:
	if not f.has("pad_week"):
		f["pad_week"] = {}
	f["pad_week"][PadWeek.DAYS[dow]] = list


## A card dropped on a pad night; false when the night is not a pad night, the card cannot be drilled, or it is there.
static func place(f: Dictionary, nights: Dictionary, dow: int, card: String) -> bool:
	if not (nights.get("pads", []) as Array).has(dow) or not PadWeek.drillable(f, card):
		return false
	var list := _night(f, nights, dow)
	for e in list:
		if str(e["card"]) == card:
			return false
	if list.is_empty():
		list = [{"card": card, "share": 1.0}]
	elif list.size() == 1:
		list = [{"card": str(list[0]["card"]), "share": 0.5}, {"card": card, "share": 0.5}]
	else:
		list[list.size() - 1]["card"] = card
	_write(f, dow, list)
	pin(f, card)
	return true


## 50/50 -> 70/30 -> 30/70 -> 50/50 on a split night; false on a night with one card or none.
static func cycle(f: Dictionary, nights: Dictionary, dow: int) -> bool:
	var list := _night(f, nights, dow)
	if list.size() != 2:
		return false
	var at := 0
	for i in SPLITS.size():
		if absf(float(list[0]["share"]) - float(SPLITS[i][0])) < 0.01:
			at = i
	var nx: Array = SPLITS[(at + 1) % SPLITS.size()]
	list[0]["share"] = nx[0]
	list[1]["share"] = nx[1]
	_write(f, dow, list)
	return true


static func remove(f: Dictionary, nights: Dictionary, dow: int, card: String) -> bool:
	var list := _night(f, nights, dow)
	var kept := list.filter(func(e): return str(e["card"]) != card)
	if kept.size() == list.size():
		return false
	for e in kept:
		e["share"] = 1.0
	_write(f, dow, kept)
	return true


static func clear(f: Dictionary, nights: Dictionary, dow: int) -> bool:
	if not (nights.get("pads", []) as Array).has(dow):
		return false
	_write(f, dow, [])
	return true


static func pin(f: Dictionary, card: String) -> void:
	var t: Array = f.get("tray", [])
	if t.has(card):
		return
	t.append(card)
	while t.size() > TRAY_MAX:
		t.pop_front()
	f["tray"] = t


## "+ drill it": the punch into the tray and onto the first pad night she has not set (else the last pad night); the dow, or -1.
static func drill_it(f: Dictionary, nights: Dictionary, card: String) -> int:
	var pads: Array = nights.get("pads", [])
	if pads.is_empty() or not PadWeek.drillable(f, card):
		return -1
	var own: Dictionary = f.get("pad_week", {})
	var dow := int(pads[-1])
	for d in pads:
		if not own.has(PadWeek.DAYS[d]):
			dow = int(d)
			break
	place(f, nights, dow, card)
	pin(f, card)
	return dow


## The tray's cards: this week's nights in day order, her pins, the coach's new move while under usable, her own combinations
## she can drill; first n, no card twice, only cards she has (a move she knows, a combination open to her).
static func tray(f: Dictionary, week: Dictionary, n := 4) -> Array:
	var want: Array = PadWeek.cards_in(week)
	want.append_array(f.get("tray", []))
	var mv := str(f.get("learning", ""))
	if mv != "" and float((f.get("moves", {}) as Dictionary).get(mv, 100.0)) < Combos.LEARN_AT:
		want.append("move:" + mv)
	for e in OwnCombos.entries(f):
		want.append(str(e["id"]))
	var nx := Combos.next_to_learn(f.get("moves", {}), f.get("combos", {}))
	if nx != "":
		want.append("combo:" + nx)
	for id in Combos.unlocked(f.get("moves", {})):   # then the book's other open combinations, to fill the tray
		want.append("combo:" + str(id))
	var out: Array = []
	for c in want:
		if out.size() < n and not out.has(str(c)) and PadWeek.drillable(f, str(c)):
			out.append(str(c))
	return out


## Per card: {dow: [before, after]} for this week (week 0 of the projection's path; a night drilled twice sums).
static func night_rows(f: Dictionary, projs: Dictionary) -> Dictionary:
	var out := {}
	for card in projs:
		var m := PadWeek.mastery(f, str(card))
		var rows := {}
		for p in (projs[card] as Dictionary).get("path", []):
			if int(p[0]) != 0:
				break
			var dow := int(p[1])
			var before := float(rows[dow][0]) if rows.has(dow) else m
			rows[dow] = [before, float(p[2])]
			m = float(p[2])
		out[card] = rows
	return out


## A tray card no night drills (not on a pad night, not pinned for sparring): PadWeek.project's shape with an empty path.
static func idle(f: Dictionary, card: String) -> Dictionary:
	var st: Dictionary = f.get("stats", {})
	var iq := float(st.get("fight_iq", 55.0))
	return {"path": [], "day30": -1, "weeks30": -1, "weeks60": -1, "held_by": PadWeek._held(f, card, PadWeek.mastery(f, card)),
		"cap": PadWeek.cap(f, card),
		"sig_needs_t": MoveMastery.technique_for(85.0, iq) if MoveMastery.cap(float(st.get("technique", 55.0)), iq) < 85.0 else 0.0}


## The first tier the projection crosses this week: {tier: "usable", at: 30, dow, before, after}; {} when none.
static func crossing(f: Dictionary, card: String, proj: Dictionary) -> Dictionary:
	var m := PadWeek.mastery(f, card)
	var before := m
	for p in proj.get("path", []):
		if int(p[0]) != 0:
			break
		for t in TIERS:
			if before < float(t[0]) and float(p[2]) >= float(t[0]):
				return {"tier": str(t[1]), "at": float(t[0]), "dow": int(p[1]), "before": before, "after": float(p[2])}
		before = float(p[2])
	return {}


## The card's one line: {text, tone} - tone "good" (lands this week), "" (on its way), "bad" (fades, or blocked).
static func eta(f: Dictionary, card: String, proj: Dictionary, week: Dictionary, spar: Array) -> Dictionary:
	var m := PadWeek.mastery(f, card)
	var next := []
	for t in TIERS:
		if m < float(t[0]):
			next = t
			break
	if next.is_empty():
		return {"text": "signature", "tone": "good"}
	var on_pads := PadWeek.cards_in(week).has(card)
	for p in proj.get("path", []) if on_pads else []:
		if float(p[2]) >= float(next[0]):
			var w := int(p[0])
			if w == 0:
				return {"text": "%s %s" % [next[1], DAY_WORDS[int(p[1])]], "tone": "good"}
			return {"text": "%s in %d weeks" % [next[1], w + 1], "tone": ""}
	if float(next[0]) >= 85.0 and float(proj.get("sig_needs_t", 0.0)) > 0.0:
		return {"text": "signature needs Technique %d" % ceili(float(proj["sig_needs_t"])), "tone": "bad"}
	if not on_pads:
		var gain := 0.0
		var path: Array = proj.get("path", [])
		for p in path:
			if int(p[0]) == 0:
				gain = float(p[2]) - m
		if gain > 0.0 and not spar.is_empty():
			return {"text": "spar nights only: grows slowly", "tone": ""}
		if m <= 0.0:   # never drilled: nothing there to fade (decay_week never goes below 0)
			return {"text": "not on a night", "tone": ""}
		return {"text": "not on a night - it fades", "tone": "bad"}
	return {"text": "%s in 8+ weeks" % next[1], "tone": ""}


## The card's short name: a move's name, a book combination's id, her own combination in numbers ("1-1, in, 3").
static func title(f: Dictionary, card: String) -> String:
	match PadWeek.kind(card):
		"own":
			var e := OwnCombos.entry(f, card)
			if e.is_empty():
				return card
			var parts: Array = []
			var run := ""
			for step in e.get("chain", []):
				var s := str(step)
				if NUMBER.has(s):
					run = NUMBER[s] if run == "" else run + "-" + NUMBER[s]
				else:
					if run != "":
						parts.append(run)
						run = ""
					parts.append(str(SHORT.get(s, s.replace("_", " "))))
			if run != "":
				parts.append(run)
			return ", ".join(parts)
	return PadWeek.key(card)


## The line under the name: the punches in words for a combination, the tier for a move.
static func sub(f: Dictionary, card: String) -> String:
	match PadWeek.kind(card):
		"own":
			return str(OwnCombos.entry(f, card).get("name", ""))
		"combo":
			return ", ".join((Combos.row(PadWeek.key(card)).get("moves", []) as Array).map(func(x): return str(x).to_lower()))
	return MoveMastery.tier(PadWeek.mastery(f, card)).to_lower()


static func kind_word(f: Dictionary, card: String) -> String:
	match PadWeek.kind(card):
		"own":
			return "OWN COMBO"
		"combo":
			return "COMBO"
	return "NEW MOVE" if PadWeek.mastery(f, card) < Combos.LEARN_AT else "MOVE"
