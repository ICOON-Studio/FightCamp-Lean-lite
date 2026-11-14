extends RefCounted
## LEARNPICK1 (S463, operator Q-S294-221 "Yes, greybox it"): the "what to learn next" pick, wired. The coach's three cards
## (LearnSlots.cards) go on the fighter page; picking a punch makes it the move her pad nights drill (f["learning"], the
## existing route); picking a step or defence puts it in her study slot (f["learning_slots"]), and each week her pad nights
## raise it. At Usable (30) it leaves the slot and the slot is free. Pure static; preloads LearnSlots, MoveTree, MoveMastery.
## Greybox numbers (SLOTS1's own): LearnSlots.DEFAULT_GAIN (6) a week on the usual 3 pad nights, times LearnSlots.speed(f),
## capped at her MoveMastery.cap. One slot until a pads assistant is wired (LearnSlots.slots(-1.0)).

const LearnSlots := preload("res://scripts/rules/LearnSlots.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")

const USUAL_PADS := 3.0
const USABLE := 30.0


## The style her booked opponent fights in; "" with no bout.
static func opp_style(f: Dictionary) -> String:
	var b: Dictionary = f.get("bout", {}) as Dictionary
	return str((b.get("opp", {}) as Dictionary).get("style", ""))


static func slot_count(_f: Dictionary) -> int:
	return LearnSlots.slots(-1.0)


## The coach's three cards for this fighter now.
static func cards(f: Dictionary) -> Array:
	return LearnSlots.cards(f, opp_style(f), {})


## Pick a card: a punch becomes the pad nights' move; a step/defence takes the study slot. False when it cannot.
static func pick(f: Dictionary, id: String) -> bool:
	if MoveTree.PUNCH_IDS.has(id):
		if MoveTree.state(f, id) != "open":
			return false
		f["learning"] = id
		return true
	if not f.has("steps"):
		f["steps"] = {}
	return LearnSlots.pick(f, id, slot_count(f))


## Mastery a week of `pad_nights` adds to a studied step.
static func gain(f: Dictionary, pad_nights: int) -> float:
	return LearnSlots.DEFAULT_GAIN * LearnSlots.speed(f) * float(pad_nights) / USUAL_PADS


## Weeks until a studied step reaches Usable on `pad_nights` a week; -1 with no pad nights.
static func weeks_left(f: Dictionary, id: String, pad_nights: int) -> int:
	var g := gain(f, pad_nights)
	if g <= 0.0:
		return -1
	return maxi(0, ceili((USABLE - MoveTree.mastery(f, id)) / g))


## The week's study: every step/defence in the slot gains; one at Usable leaves the slot. Mutates f.
## Returns [[id, before, after]] for the rows that moved.
static func week(f: Dictionary, pad_nights: int) -> Array:
	var out: Array = []
	var ls: Array = (f.get("learning_slots", []) as Array).duplicate()
	if ls.is_empty():
		return out
	if not f.has("steps"):
		f["steps"] = {}
	var st: Dictionary = f.get("stats", {}) as Dictionary
	var top := MoveMastery.cap(float(st.get("technique", 55.0)), float(st.get("fight_iq", 55.0)))
	var g := gain(f, pad_nights)
	for id in ls:
		var sid := str(id)
		if MoveTree.PUNCH_IDS.has(sid):
			continue
		var before := MoveTree.mastery(f, sid)
		var after := minf(top, before + g)
		f["steps"][sid] = after
		if after != before:
			out.append([sid, before, after])
		if after >= USABLE:
			LearnSlots.drop(f, sid)
	return out


## Plain words for a node id ("step_back" -> "Step back"; punches keep their name).
static func name_of(id: String) -> String:
	return str(StepMastery.NAMES.get(id, id))


## The slot row's words: "Step back: 12 of 30, about 3 weeks on 3 pad nights".
static func slot_line(f: Dictionary, id: String, pad_nights: int) -> String:
	var m := MoveTree.mastery(f, id)
	var w := weeks_left(f, id, pad_nights)
	var when := "needs pad nights" if w < 0 else ("about %d week%s" % [w, "" if w == 1 else "s"])
	return "%s: %d of 30, %s" % [name_of(id), int(m), when]
