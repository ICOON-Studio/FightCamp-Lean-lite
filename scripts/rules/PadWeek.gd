extends RefCounted
## S382 PADWEEK1 (operator S381 "Training screen first"; design ops/research/TRAINING_SCREEN_S381.md sections 5.2-5.5):
## the week's evenings as NIGHTS that carry drill cards. A pad night is PAD_NIGHT_MINUTES of drilling split over the cards
## on it; a sparring night gives every card already in her hands (>= Combos.LEARN_AT) a ring_sparring share. These replace
## the two fixed weekly lumps (new move 420, combo 240): the coach's default week (Standard, 3 pad nights: the new move on
## Mon + Wed, the combo on Fri) lands where the lumps did - a new move usable in week 2, the 1-1 in week 4 for Lucy.
## - Nights: Light / Standard / Hard (camp2 BoutRules.PROTOCOLS 1..3; between fights the TrainingLoad setting) set the
##   pad and sparring nights: between fights 2+1 / 3+1 / 4+1, in camp 2+1 / 2+2 / 3+2; film takes a pad night; the
##   taper week keeps its pads at half minutes and spars none.
## - A drilled combination counts as drilling its punches for MoveMastery.decay_week: no gain, just no fade.
## - run_week is the ONE function both the week (DrillWeek) and the card projections (project) call, night by night, so a
##   forecast is what the week will do.
## - blocks(): a morning card is 2 blocks, a pad night 1 pads block, a sparring night 1 sparring block - the default week
##   (6 mornings, 3 pads, 1 spar) is TrainingPlan.DEFAULT_TOTAL (16); intensity() is that sum.
## Card ids: "move:<Data.MOVES name>", "combo:<Combos.BOOK id>", "own:<n>" (OwnCombos); "habit:" / "answer:" are tray
## cards the nights do not drill. f keys: pad_week {"mon": [{card, share}], ...} = the nights the player set (the coach
## fills the rest every week), tray [card ids] (sparring shares), learning / combo_learning (what the coach drills).
##   nights_for(step, camp, film, taper)  nights_of(f, twist)  lay(step, camp, phase, evs)  evenings(f, twist)  ahead(f, day, weeks)
##   pad_share(f)  step_of(f)  defaults(f, nights)  week_of(f, nights)
##   minutes_for(card, week, nights)  pads_factor(nights)  run_week(f, nights, week, coach, tier, mults, carded)
##   project(f, nights, week, coach, tier, weeks, mults, carded) -> {card: {path, day30, weeks30, weeks60, held_by, sig_needs_t, cap}}
##   blocks(mornings, pads, spar) -> TrainingPlan plan   intensity(mornings, pads, spar) -> blocks
## Pure static: every function works on the dictionary it is given (project on a deep copy).

const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const TrainingPlan := preload("res://scripts/rules/TrainingPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const PLAN_CARDS := "res://scripts/rules/PlanCards.gd"

## Drill minutes a pad night (game units, the scale of the old lumps: 2 nights = 480 vs LEARN_MINUTES 420, 1 = COMBO 240).
const PAD_NIGHT_MINUTES := 240.0
## A sparring night's drill minutes, split over the cards already usable (3 cards: ~+1.5 each at m 10 of cap 51).
const SPAR_NIGHT_MINUTES := 180.0
const PAD_STATION := "pads"
const SPAR_STATION := "ring_sparring"
const STATION_TIER := 2.0
## A move on a week card gets bag time when no pad night drills it (the old CARD_MINUTES).
const CARD_STATION := "heavy_bag"
const CARD_MINUTES := 120.0
const DAYS := ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
## Sparring nights by count (WeekPlan.SPAR_DAYS: Thursday, then Tuesday too); pad nights fill Mon / Wed / Fri first.
const SPAR_DAYS := [[], [3], [1, 3]]
const PAD_ORDER := [0, 2, 4, 1, 5, 3]
## The pad night film takes (WeekPlan.FILM_DAYS order).
const FILM_DAYS := [1, 2, 4, 0, 5, 3]
## [pad nights, sparring nights] for Light / Standard / Hard.
const NIGHTS := {"between": [[2, 1], [3, 1], [4, 1]], "camp": [[2, 1], [2, 2], [3, 2]]}
const STEPS := ["light", "normal", "hard"]
const TAPER_SHARE := WeekPlan.TAPER_PADS
## Pad nights the old weekly lump stood for: pads_factor = pad nights / USUAL_PADS.
const USUAL_PADS := 3.0
const MORNING_BLOCKS := 2
## Morning sessions -> the TrainingPlan session that builds the same stat.
const MORNING_PLAN := {"roadwork": "roadwork", "intervals": "roadwork", "heavy_bag": "heavy_bag", "strength": "heavy_bag",
	"speed_bag": "speed_bag", "slip_rope": "slip_rope", "shadow": "shadow", "neck": "neck", "sparring": "sparring", "pads": "pads"}


## 0 Light, 1 Standard, 2 Hard: the camp's protocol in camp, else her TrainingLoad setting.
static func step_of(f: Dictionary) -> int:
	if in_camp(f):
		return clampi(int((f["camp"] as Dictionary).get("protocol", 2)) - 1, 0, 2)
	var s := STEPS.find(str(f.get("load_setting", "normal")))
	return s if s >= 0 else 1


static func in_camp(f: Dictionary) -> bool:
	var camp: Dictionary = f.get("camp", {})
	return not camp.is_empty() and int(camp.get("protocol", 0)) >= 1


## {pads: [dow], spar: [dow], film: dow or -1, minutes: a pad night's minutes}; dow 0 = Monday.
static func nights_for(step: int, camp: bool, film := false, taper := false) -> Dictionary:
	var n: Array = (NIGHTS["camp" if camp else "between"] as Array)[clampi(step, 0, 2)]
	var spar: Array = [] if taper else (SPAR_DAYS[clampi(int(n[1]), 0, 2)] as Array).duplicate()
	var pads: Array = []
	for d in PAD_ORDER:
		if pads.size() < int(n[0]) and not spar.has(d):
			pads.append(d)
	var film_day := -1
	if film:
		for d in FILM_DAYS:
			if pads.has(d):
				film_day = d
				pads.erase(d)
				break
	pads.sort()
	return {"pads": pads, "spar": spar, "film": film_day, "minutes": PAD_NIGHT_MINUTES * (TAPER_SHARE if taper else 1.0)}


## Her nights this week: the step's pad-night count and minutes (nights_for), laid on the evenings her phase gives
## (WeekPlan.evenings_of with the twist card unless twist = false): sparring on her real sparring evenings (the board's spar
## pills, the phase, a twist), film on her film evening, the pad nights on the first evenings still "pads" in PAD_ORDER.
static func nights_of(f: Dictionary, twist := true) -> Dictionary:
	return with_evenings(coach_nights(f, twist), WeekPhase.edits(f).get("eve", {}))


## S398 Week redesign (approved rule change, no new mechanic): the evenings the player set on the Week page (WeekPhase
## edits "eve" {dow: rest|pads|sparring}) replace the coach's kind on those nights; the pad-night count follows them
## instead of the Light / Standard / Hard step. A film night stays film. No edits = the coach's nights unchanged.
static func with_evenings(n: Dictionary, eve: Dictionary) -> Dictionary:
	if eve.is_empty():
		return n
	var evs := evenings_from(n)
	for k in eve:
		var d := int(k)
		if d >= 0 and d < 7 and str(evs[d]) != "film":
			evs[d] = str(eve[k])
	var out := n.duplicate(true)
	out["pads"] = range(7).filter(func(d): return str(evs[d]) == "pads")
	out["spar"] = range(7).filter(func(d): return str(evs[d]) == "sparring")
	return out


## The coach's nights for this week: the step's laid nights before any evening the player set.
static func coach_nights(f: Dictionary, twist := true) -> Dictionary:
	var tpl: Array = WeekPlan.evenings_of(f)
	var evs := tpl
	if twist:
		evs = WeekTwist.evenings(WeekTwist.active(f), tpl)
	var n := lay(step_of(f), in_camp(f), str(f.get("phase", "base")), evs)
	# S382 EVENINGS1 review: a card that turns her sparring nights into pads (partner_ill) keeps them pad nights - the
	# laying alone would draw them REST, and since the sim runs these nights the card's word would not hold
	for d in 7:
		if str(tpl[d]) == "sparring" and str(evs[d]) == "pads" and not (n["pads"] as Array).has(d):
			(n["pads"] as Array).append(d)
	(n["pads"] as Array).sort()
	return n


## The step's nights on a week's evenings (evs: WeekPlan.evenings_for / evenings_of); film takes its pad night only in the
## week that holds it (a camp's second Build week keeps its pads).
static func lay(step: int, camp: bool, phase: String, evs: Array) -> Dictionary:
	var n := nights_for(step, camp, evs.has("film"), camp and phase == "taper")
	var pads: Array = []
	for d in PAD_ORDER:
		if pads.size() < (n["pads"] as Array).size() and str(evs[d]) == "pads":
			pads.append(d)
	pads.sort()
	n["pads"] = pads
	n["spar"] = range(7).filter(func(d): return str(evs[d]) == "sparring")
	n["film"] = evs.find("film")
	return n


## S382 EVENINGS1 (designer: "the strip is the truth"): the seven evenings the sim runs ARE the strip's nights - a pad
## night "pads", a sparring night "sparring", film "film", every other evening "rest". Sim, CampForecast, the board's
## GOAL / LEGS lines and Injuries' hours all read this, so an evening drawn REST trains, tires and counts nothing.
static func evenings(f: Dictionary, twist := true) -> Array:
	return evenings_from(nights_of(f, twist))


static func evenings_from(n: Dictionary) -> Array:
	var out: Array = ["rest", "rest", "rest", "rest", "rest", "rest", "rest"]
	for d in n.get("pads", []):
		out[int(d)] = "pads"
	for d in n.get("spar", []):
		out[int(d)] = "sparring"
	if int(n.get("film", -1)) >= 0:
		out[int(n["film"])] = "film"
	return out


## WeekPlan.ahead with each week's evenings laid as its nights will be (the same step; the taper's pads at half).
static func ahead(f: Dictionary, day: int, weeks: int) -> Array:
	var out: Array = []
	for wk in WeekPlan.ahead(f, day, weeks):
		out.append([wk[0], evenings_from(lay(step_of(f), in_camp(f), str(wk[2]), wk[1])), wk[2]])
	return out


## A pad night's share of a full one: the taper's half nights (WeekPlan.full_day / hours scale a pads evening by it).
static func pad_share(f: Dictionary) -> float:
	return TAPER_SHARE if in_camp(f) and str(f.get("phase", "base")) == "taper" else 1.0


static func pads_factor(nights: Dictionary) -> float:
	return float((nights.get("pads", []) as Array).size()) / USUAL_PADS


static func kind(card: String) -> String:
	return card.get_slice(":", 0)


static func key(card: String) -> String:
	return card.substr(kind(card).length() + 1)


static func mastery(f: Dictionary, card: String) -> float:
	match kind(card):
		"move":
			return float((f.get("moves", {}) as Dictionary).get(key(card), 0.0))
		"combo":
			return float((f.get("combos", {}) as Dictionary).get(key(card), 0.0))
		"own":
			return OwnCombos.mastery(f, card)
	return -1.0


static func cap(f: Dictionary, card: String) -> float:
	var st: Dictionary = f.get("stats", {})
	var t := float(st.get("technique", 55.0))
	var iq := float(st.get("fight_iq", 55.0))
	match kind(card):
		"combo":
			return Combos.cap(key(card), f.get("moves", {}), t, iq)
		"own":
			return OwnCombos.cap(f, OwnCombos.entry(f, card))
	return MoveMastery.cap(t, iq)


## The moves a card puts in her hands (a combination: its punches).
static func moves_of(f: Dictionary, card: String) -> Array:
	match kind(card):
		"move":
			return [key(card)]
		"combo":
			return (Combos.row(key(card)).get("moves", []) as Array).duplicate()
		"own":
			var e := OwnCombos.entry(f, card)
			return [] if e.is_empty() else (OwnCombos.row(e)["moves"] as Array).duplicate()
	return []


## A night can drill it: a known move, a book combination whose punches are all weapons, an own one with none missing.
static func drillable(f: Dictionary, card: String) -> bool:
	match kind(card):
		"move":
			return (f.get("moves", {}) as Dictionary).has(key(card))
		"combo":
			return Combos.unlocked(f.get("moves", {})).has(key(card))
		"own":
			var e := OwnCombos.entry(f, card)
			return not e.is_empty() and OwnCombos.missing(f, e) == ""
	return false


## The coach's card for the combination she drills: her own while she can, else the book's (the next to learn when none).
static func combo_card(f: Dictionary) -> String:
	var cl := str(f.get("combo_learning", ""))
	if cl.begins_with("own:") and drillable(f, cl):
		return cl
	if cl != "" and not cl.begins_with("own:") and drillable(f, "combo:" + cl):
		return "combo:" + cl
	var nx := Combos.next_to_learn(f.get("moves", {}), f.get("combos", {}))
	return "" if nx == "" else "combo:" + nx


## The coach's week (also the save migration: learning on the first nights, combo_learning on the last). S382 PLANTRAY1:
## with a bout booked the coach drills the Game plan's cards instead (PlanCards.coach_week; loaded, PlanCards preloads this).
static func defaults(f: Dictionary, nights: Dictionary) -> Dictionary:
	var plan: Dictionary = load(PLAN_CARDS).coach_week(f, nights)
	if not plan.is_empty():
		return plan
	var days: Array = nights.get("pads", [])
	var mv := str(f.get("learning", ""))
	var move := "move:" + mv if mv != "" and drillable(f, "move:" + mv) else ""
	var combo := combo_card(f)
	var out := {}
	var k := days.size()
	if k == 0 or (move == "" and combo == ""):
		return out
	if move != "" and combo != "" and k == 1:
		out[DAYS[days[0]]] = [{"card": move, "share": 0.5}, {"card": combo, "share": 0.5}]
		return out
	# The new move keeps its 2 nights (1 on Light); every night past them goes to the combination - the balance check: with
	# the 4th night on the move, Hard landed nothing a week sooner; on the combo, the 1-1 lands 2 weeks sooner.
	var combo_nights := 0 if combo == "" else (k if move == "" else k - mini(2, k - 1))
	for i in k:
		out[DAYS[days[i]]] = [{"card": combo if i >= k - combo_nights else move, "share": 1.0}]
	return out


## The week she runs: the nights the player set (f["pad_week"]), the coach's on the rest; non-pad days are ignored.
static func week_of(f: Dictionary, nights: Dictionary) -> Dictionary:
	var out := defaults(f, nights)
	var own: Dictionary = f.get("pad_week", {})
	for d in nights.get("pads", []):
		if not own.has(DAYS[d]):
			continue
		var list: Array = own[DAYS[d]]
		var kept: Array = list.filter(func(e): return str(e.get("card", "")) != "" and float(e.get("share", 0.0)) > 0.0)
		if kept.is_empty():
			out.erase(DAYS[d])   # S382 DRILLCARD1: a night she cleared stays empty (right-click on the night)
		else:
			out[DAYS[d]] = kept
	return out


static func cards_in(week: Dictionary) -> Array:
	var out: Array = []
	for d in DAYS:
		for e in week.get(d, []):
			if not out.has(str(e["card"])):
				out.append(str(e["card"]))
	return out


## The cards a sparring night shares out (the ones >= LEARN_AT among them) and project draws: the week's night cards, her
## tray pins, and in camp every card of the Game plan (S382 PLANTRAY1 review, spec 5.3 "every plan card already >= 30").
static func spar_pool(f: Dictionary, week: Dictionary) -> Array:
	var out := cards_in(week)
	for c in (f.get("tray", []) as Array) + load(PLAN_CARDS).cards(f):
		if not out.has(str(c)):
			out.append(str(c))
	return out


## A pad night's minutes: the week's, or the night's own when it ran under other nights (DrillWeek.note: per {dow: min}).
static func night_minutes(nights: Dictionary, d: int) -> float:
	return float((nights.get("per", {}) as Dictionary).get(d, nights.get("minutes", PAD_NIGHT_MINUTES)))


## Pad minutes the card gets this week.
static func minutes_for(card: String, week: Dictionary, nights: Dictionary) -> float:
	var total := 0.0
	for d in nights.get("pads", []):
		for e in week.get(DAYS[d], []):
			if str(e["card"]) == card:
				total += night_minutes(nights, int(d)) * float(e["share"])
	return total


## One drill of a card at a station; writes the new mastery into f and returns it.
static func drill(f: Dictionary, card: String, minutes: float, coach: float, tier: float, station: String) -> float:
	var m := mastery(f, card)
	match kind(card):
		"move":
			m = MoveMastery.gain(m, station, minutes, coach, tier, 1.0, cap(f, card))
			f["moves"][key(card)] = m
		"combo":
			if not f.has("combos"):
				f["combos"] = {}
			m = Combos.drill(m, key(card), minutes, coach, tier, cap(f, card), station)
			f["combos"][key(card)] = m
		"own":
			m = OwnCombos.drill_week(f, card, minutes, coach, tier, station)
	return m


## The week night by night (Mon..Sun), then the bag for carded moves and the fades. mults: {move, combo} (the twist card);
## carded = moves on her week cards. Mutates f. Returns {log: [[dow, card, before, after]], drilled: {card: minutes},
## pads: {card: pad minutes} (drilled without the sparring shares)}.
static func run_week(f: Dictionary, nights: Dictionary, week: Dictionary, coach: float, tier: float, mults := {}, carded := []) -> Dictionary:
	var night_log: Array = []
	var drilled := {}
	var on_pads := {}
	var pool := spar_pool(f, week)
	for d in 7:
		if (nights.get("pads", []) as Array).has(d):
			for e in week.get(DAYS[d], []):
				var card := str(e["card"])
				var mins := night_minutes(nights, d) * float(e["share"]) * float(mults.get("move" if kind(card) == "move" else "combo", 1.0))
				if mins <= 0.0 or not drillable(f, card):
					continue
				var before := mastery(f, card)
				night_log.append([d, card, before, drill(f, card, mins, coach, tier, PAD_STATION)])
				drilled[card] = float(drilled.get(card, 0.0)) + mins
				on_pads[card] = float(on_pads.get(card, 0.0)) + mins
		if (nights.get("spar", []) as Array).has(d):
			var hands: Array = []
			for card in pool:
				if not hands.has(card) and drillable(f, str(card)) and mastery(f, str(card)) >= Combos.LEARN_AT:
					hands.append(str(card))
			for card in hands:
				var mins := SPAR_NIGHT_MINUTES / float(hands.size())
				var before := mastery(f, card)
				night_log.append([d, card, before, drill(f, card, mins, coach, tier, SPAR_STATION)])
				drilled[card] = float(drilled.get(card, 0.0)) + mins
	var kept := {}
	for card in drilled:
		for mv in moves_of(f, str(card)):
			kept[mv] = true
	var moves: Dictionary = f.get("moves", {})
	for mv in carded:
		if moves.has(mv) and not drilled.has("move:" + str(mv)):
			moves[mv] = MoveMastery.gain(float(moves[mv]), CARD_STATION, CARD_MINUTES, coach, tier, 1.0, cap(f, "move:" + str(mv)))
		kept[mv] = true
	for mv in moves.keys():
		if not kept.has(mv):
			moves[mv] = MoveMastery.decay_week(float(moves[mv]), false)
	var combos: Dictionary = f.get("combos", {})
	for id in combos.keys():
		if not drilled.has("combo:" + str(id)):
			combos[id] = Combos.fade(float(combos[id]), false)
	var own: Dictionary = f.get("own_combos", {})
	for id in own.keys():
		if not drilled.has(str(id)):
			own[id] = Combos.fade(float(own[id]), false)
	return {"log": night_log, "drilled": drilled, "pads": on_pads}


## The card projections, from run_week on a copy with the same nights each week: per card its path [[week, dow, m]], the
## night it turns usable this week (day30, -1), the week it turns usable / sharp (1 = this week, 0 = already, -1 = not in
## `weeks`), the punch that holds it under its next tier (held_by [move, m] or []), the technique a signature needs when
## her cap is under it (sig_needs_t, 0 when not), and her cap for it.
static func project(f: Dictionary, nights: Dictionary, week: Dictionary, coach: float, tier: float, weeks := 8, mults := {}, carded := []) -> Dictionary:
	var copy := f.duplicate(true)
	var out := {}
	for card in spar_pool(f, week):
		var c := str(card)
		if out.has(c) or mastery(f, c) < 0.0:
			continue
		var m := mastery(f, c)
		var st: Dictionary = f.get("stats", {})
		var iq := float(st.get("fight_iq", 55.0))
		out[c] = {"path": [], "day30": -1, "weeks30": 0 if m >= 30.0 else -1, "weeks60": 0 if m >= 60.0 else -1,
			"held_by": _held(f, c, m), "cap": cap(f, c),
			"sig_needs_t": MoveMastery.technique_for(85.0, iq) if MoveMastery.cap(float(st.get("technique", 55.0)), iq) < 85.0 else 0.0}
	for w in weeks:
		var r := run_week(copy, nights, week, coach, tier, mults, carded)
		for row in r["log"]:
			var c := str(row[1])
			if not out.has(c):
				continue
			var p: Dictionary = out[c]
			(p["path"] as Array).append([w, int(row[0]), float(row[3])])
			if float(row[2]) < 30.0 and float(row[3]) >= 30.0 and int(p["weeks30"]) < 0:
				p["weeks30"] = w + 1
				if w == 0:
					p["day30"] = int(row[0])
			if float(row[2]) < 60.0 and float(row[3]) >= 60.0 and int(p["weeks60"]) < 0:
				p["weeks60"] = w + 1
	return out


## The punch under the card's next tier that holds a combination there; [] for a move or when none does. A drillable
## combination's punches are all weapons (>= 30), so the first tier a punch can hold back is SHARP (60): Lucy's
## Jab-Jab-Step-Lead hook is "held at 37: Lead hook" while it is still raw.
static func _held(f: Dictionary, card: String, m: float) -> Array:
	if kind(card) == "move" or m >= 85.0:
		return []
	var next := 60.0 if m < 60.0 else 85.0
	var h := Combos.held_by(f.get("moves", {}), moves_of(f, card))
	return h if not h.is_empty() and float(h[1]) < next else []


## The strip as a TrainingPlan week: a morning card 2 blocks of its session, a pad night 1 pads, a sparring night 1 sparring.
static func blocks(mornings: Array, pads: int, spar: int) -> Dictionary:
	var out := {}
	for id in TrainingPlan.IDS:
		out[id] = 0
	for m in mornings:
		var id := str(MORNING_PLAN.get(str(m[0]) if m is Array else str(m), ""))
		if id != "":
			out[id] = int(out[id]) + MORNING_BLOCKS
	out["pads"] = int(out["pads"]) + pads
	out["sparring"] = int(out["sparring"]) + spar
	return out


## The week's blocks (the strip's INTENSITY "14 / 16"; TrainingPlan.DEFAULT_TOTAL is the coach's week).
static func intensity(mornings: Array, pads: int, spar: int) -> int:
	var n := 0
	var b := blocks(mornings, pads, spar)
	for id in b:
		n += int(b[id])
	return n
