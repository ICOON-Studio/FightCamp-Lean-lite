extends RefCounted
## SPECIALTY1 - the weekly hold: what the coach keeps sharp, what fades, and when nothing moves.
## Pure static; preloads MoveTree and MoveMastery only. S457 wired: PadWeek.run_week calls apply() on Sunday (60+ moves only).

const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const HOLD_SHARP := 20.0
const HOLD_SIGNATURE := 40.0
const FADE := 1.5
const SHARP_FLOOR := 50.0
const SIGNATURE_FLOOR := 70.0
const SPAR_UNITS := 180.0


## S457 wiring (PadWeek.run_week's Sunday): a move on the week's cards is drilled on the bag for this many units.
const CARD_UNITS := 120.0
## Moves at or above this are this module's; under it MoveMastery.decay_week keeps fading them as before.
const HOLD_FROM := 60.0


## S457 the Sunday hold inside PadWeek.run_week: on_pads {card: pad-night minutes}, carded (moves on the week cards, CARD_UNITS
## each on the bag), spar_cards (the cards the sparring nights shared), spar_nights (how many). Frozen in TAPER (fight week) and
## while injured (f["injury"] not empty). Writes f["moves"] (and f["steps"] when f has them); returns {held, faded}.
static func apply(f: Dictionary, on_pads: Dictionary, carded: Array, spar_cards: Array, spar_nights: int) -> Dictionary:
	var bag: Dictionary = {}
	for mv in carded:
		bag["move:" + str(mv)] = CARD_UNITS
	var got := units(on_pads, bag, spar_cards, SPAR_UNITS * float(spar_nights))
	var injured := not (f.get("injury", {}) as Dictionary).is_empty()
	var r := week(f, got, frozen(str(f.get("phase", "")), false, injured))
	f["moves"] = r["moves"]
	if f.has("steps"):
		f["steps"] = r["steps"]
	return {"held": r["held"], "faded": r["faded"]}


## Drill units a week the move needs to hold: 40 at 85+, 20 at 60+, 0 under 60.
static func line_for(m: float) -> float:
	if m >= 85.0:
		return HOLD_SIGNATURE
	if m >= 60.0:
		return HOLD_SHARP
	return 0.0


## Drill units each MOVE got this week from pads, bag and sparring.
## pads/bag: {card: units} where card is "move:<id>" or "combo:<key>".
## spar_cards: array of card strings; expanded to distinct moves, spar_units split evenly.
static func units(pads: Dictionary, bag: Dictionary, spar_cards: Array, spar_units: float = SPAR_UNITS) -> Dictionary:
	var out: Dictionary = {}
	_add_card_units(out, pads)
	_add_card_units(out, bag)
	_add_spar_units(out, spar_cards, spar_units)
	return out


static func _add_card_units(out: Dictionary, cards: Dictionary) -> void:
	for card in cards:
		_distribute_card(out, str(card), float(cards[card]))


static func _distribute_card(out: Dictionary, card: String, u: float) -> void:
	if card.begins_with("move:"):
		var id: String = card.substr(5)
		out[id] = out.get(id, 0.0) + u
	elif card.begins_with("combo:"):
		var key: String = card.substr(6)
		if MoveTree.COMBO_PUNCHES.has(key):
			var punches: Array = MoveTree.COMBO_PUNCHES[key]
			var share: float = u / float(punches.size())
			for p in punches:
				var pid: String = str(p)
				out[pid] = out.get(pid, 0.0) + share


static func _add_spar_units(out: Dictionary, spar_cards: Array, spar_units: float) -> void:
	var distinct: Dictionary = {}
	for card in spar_cards:
		var c: String = str(card)
		if c.begins_with("move:"):
			distinct[c.substr(5)] = true
		elif c.begins_with("combo:"):
			var key: String = c.substr(6)
			if MoveTree.COMBO_PUNCHES.has(key):
				for p in MoveTree.COMBO_PUNCHES[key]:
					distinct[str(p)] = true
	var n: int = distinct.size()
	if n == 0:
		return
	var share: float = spar_units / float(n)
	for id in distinct:
		out[id] = out.get(id, 0.0) + share


## True when nothing fades: taper, fight week, or injured.
static func frozen(phase: String, fight_week: bool, injured: bool) -> bool:
	return phase == "taper" or fight_week or injured


## The Sunday check over every move at 60+. Returns new dicts (never mutates f).
## frozen_week -> nothing changes, every 60+ move in held.
## got[id] >= line_for(m) -> held, unchanged.
## Else Signature falls FADE (floor SIGNATURE_FLOOR), Sharp falls FADE (floor SHARP_FLOOR); goes in faded.
## Moves under 60 copied unchanged, in neither list.
static func week(f: Dictionary, got: Dictionary, frozen_week: bool) -> Dictionary:
	var new_moves: Dictionary = (f.get("moves", {}) as Dictionary).duplicate()
	var new_steps: Dictionary = (f.get("steps", {}) as Dictionary).duplicate()
	var held: Array = []
	var faded: Array = []
	for id in MoveTree.PUNCH_IDS:
		_process_move(f, got, id, new_moves, held, faded, frozen_week)
	for id in MoveTree.STEP_IDS:
		_process_move(f, got, id, new_steps, held, faded, frozen_week)
	for id in MoveTree.DEFENCE_IDS:
		_process_move(f, got, id, new_steps, held, faded, frozen_week)
	return {"moves": new_moves, "steps": new_steps, "held": held, "faded": faded}


static func _process_move(f: Dictionary, got: Dictionary, id: String, out: Dictionary, held: Array, faded: Array, frozen_week: bool) -> void:
	var m: float = MoveTree.mastery(f, id)
	if m < 60.0:
		return
	if frozen_week:
		held.append(id)
		return
	var needed: float = line_for(m)
	var g: float = float(got.get(id, 0.0))
	if g >= needed:
		held.append(id)
	else:
		var new_m: float
		if m >= 85.0:
			new_m = maxf(m - FADE, SIGNATURE_FLOOR)
		else:
			new_m = maxf(m - FADE, SHARP_FLOOR)
		out[id] = new_m
		faded.append(id)


## The coach's default hold list: plan moves at 60+ plus all Signatures (85+), in MoveTree order.
static func coach_holds(f: Dictionary, plan_moves: Array) -> Array:
	var hold_set: Dictionary = {}
	for mv in plan_moves:
		if MoveTree.mastery(f, str(mv)) >= 60.0:
			hold_set[str(mv)] = true
	var all_ids: Array = MoveTree.PUNCH_IDS + MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS
	for id in all_ids:
		if MoveTree.mastery(f, id) >= 85.0:
			hold_set[id] = true
	var out: Array = []
	for id in all_ids:
		if hold_set.has(id):
			out.append(id)
	return out


## The 60+ moves NOT in coach_holds (what Monday shows as dropped).
static func dropped(f: Dictionary, plan_moves: Array) -> Array:
	var ch_set: Dictionary = {}
	for id in coach_holds(f, plan_moves):
		ch_set[str(id)] = true
	var all_ids: Array = MoveTree.PUNCH_IDS + MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS
	var out: Array = []
	for id in all_ids:
		if MoveTree.mastery(f, id) >= 60.0 and not ch_set.has(id):
			out.append(id)
	return out


## Signature moves that will fade this week and are NOT in holds; empty in a frozen week.
static func needs_flag(f: Dictionary, got: Dictionary, holds: Array, frozen_week: bool) -> Array:
	if frozen_week:
		return []
	var holds_set: Dictionary = {}
	for h in holds:
		holds_set[str(h)] = true
	var all_ids: Array = MoveTree.PUNCH_IDS + MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS
	var out: Array = []
	for id in all_ids:
		var m: float = MoveTree.mastery(f, id)
		if m >= 85.0 and not holds_set.has(id):
			if float(got.get(id, 0.0)) < line_for(m):
				out.append(id)
	return out
