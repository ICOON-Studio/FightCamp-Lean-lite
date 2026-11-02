extends RefCounted
## S353 BJJ ships with boxing (operator: "we will ship bjj with boxing since we have all clips and moves [...] a simple road
## to black belt in bjj for start"; "we only use no gi on the game"). The road: white, blue, purple, brown, black, four
## stripes on each coloured belt.
## THE FLOOR is the IBJJF's (General System of Graduation, June 2026, read S353):
##   minimum age - blue 16, purple 16, brown 18, black 19 (18 for an adult world champion at brown);
##   minimum time at a belt before the next - white none, blue 2 years, purple 1.5, brown 1; an adult world champion at that
##   belt skips it.
## ABOVE THE FLOOR the professor (the player) decides. Mat time and the belt's syllabus (the operator's S281 belt checklist,
## no-gi) make her READY; promoting before ready is the coach's call, but she starts the new belt behind (EARLY_DEBT).
## Mat time to ready: typical pace from belt guides (white -> blue 1-2 years, blue -> purple 2-3, purple -> brown 1.5-2,
## brown -> black 1-2) at a competitor's 4 classes a week (about 200 a year). Stripes are academy custom (the IBJJF does not
## regulate them): one per quarter of the way to ready.
## The match (IBJJF Rule Book v6.0, adult): 5 min at white, 6 blue, 7 purple, 8 brown, 10 black; mount or back 4, guard
## pass 3, takedown, sweep or knee on belly 2; a submission ends it.
## Pure static module - ZERO preloads.

const BELTS := ["white", "blue", "purple", "brown", "black"]
const MIN_AGE := {"white": 0, "blue": 16, "purple": 16, "brown": 18, "black": 19}
const CHAMP_BLACK_AGE := 18
const MIN_DAYS_AT := {"white": 0, "blue": 730, "purple": 548, "brown": 365}
const CLASSES_TO_NEXT := {"white": 200, "blue": 450, "purple": 350, "brown": 300}
const STRIPES := 4
const MATCH_MIN := {"white": 5, "blue": 6, "purple": 7, "brown": 8, "black": 10}
const POINTS := {"mount": 4, "back": 4, "pass": 3, "takedown": 2, "sweep": 2, "knee_on_belly": 2}
## A move is hers at the weapon level (MoveMastery: mastery 30 = a weapon in a fight).
const OWNED_AT := 30.0
## Promoted before ready: the share of the new belt's mat time she still owes (classes she must make up first).
const EARLY_DEBT := 0.25

## The belt's syllabus, no-gi: the moves she must own to be ready for the NEXT belt (operator's checklist bands; gi-only
## guards and collar chokes swapped for their no-gi counterparts).
const SYLLABUS := {
	"white": {"title": "The foundations", "groups": [
		["Escapes and survival", ["shrimp_bridge", "frame_recover_guard", "seatbelt_escape", "posture_closed_guard"]],
		["Passes and sweeps", ["bullfighter_pass", "knee_cut_pass", "scissor_sweep", "hip_bump_sweep"]],
		["Takedowns and submissions", ["double_leg", "armbar_guard", "kimura", "americana", "rear_naked_choke", "guillotine"]]]},
	"blue": {"title": "Her game", "groups": [
		["Guards", ["de_la_riva", "single_leg_x", "deep_half", "butterfly_sweep"]],
		["Passes and back takes", ["over_under_pass", "leg_drag", "arm_drag_back", "berimbolo"]],
		["Submissions", ["triangle", "straight_ankle_lock", "darce"]]]},
	"purple": {"title": "Her system", "groups": [
		["Open guard", ["k_guard", "waiter_sweep", "body_lock_pass"]],
		["Leg locks", ["outside_heel_hook", "kneebar", "toe_hold"]],
		["Chokes", ["anaconda", "north_south_choke", "back_triangle"]]]},
	"brown": {"title": "Mastery", "groups": [
		["Leg lock system", ["inside_heel_hook", "saddle_entry", "calf_slicer"]],
		["Top game", ["crucifix", "mounted_triangle", "counter_pass"]],
		["Scrambles", ["wrestle_up", "clock_choke"]]]},
}


static func rank(belt: String) -> int:
	return BELTS.find(belt)


static func next_belt(belt: String) -> String:
	var i := rank(belt)
	return BELTS[i + 1] if i >= 0 and i < BELTS.size() - 1 else ""


## Every move the belt's syllabus asks for, in order.
static func moves_for(belt: String) -> Array:
	var out: Array = []
	for g in (SYLLABUS.get(belt, {}) as Dictionary).get("groups", []):
		out.append_array(g[1])
	return out


## Days she still has to wait at her belt under the IBJJF floor (0 = none; a world champion at her belt waits none).
static func days_left(f: Dictionary, today: int) -> int:
	var belt := str(f.get("belt", "white"))
	if bool(f.get("world_champ", false)):
		return 0
	return maxi(0, int(MIN_DAYS_AT.get(belt, 0)) - (today - int(f.get("belt_day", today))))


## True when her age allows the next belt (black at 18 only for an adult world champion at brown).
static func age_ok(f: Dictionary) -> bool:
	var nxt := next_belt(str(f.get("belt", "white")))
	if nxt == "":
		return false
	var need := int(MIN_AGE[nxt])
	if nxt == "black" and bool(f.get("world_champ", false)):
		need = CHAMP_BLACK_AGE
	return int(f.get("age", 0)) >= need


## How close she is to the next belt: {"mat": [classes, needed], "moves": [owned, needed], "share": 0..1 (the lower of the
## two), "days_left", "age_ok", "floor_ok" (IBJJF), "ready" (floor and share 1), "stripes" (earned on this belt)}.
## mastery: move id -> MoveMastery value.
static func readiness(f: Dictionary, mastery: Dictionary, today: int) -> Dictionary:
	var belt := str(f.get("belt", "white"))
	if next_belt(belt) == "":
		return {"mat": [0, 0], "moves": [0, 0], "share": 1.0, "days_left": 0, "age_ok": false, "floor_ok": false,
			"ready": false, "stripes": 0}
	var need_cls := int(CLASSES_TO_NEXT[belt])
	var cls := maxi(0, int(f.get("mat_classes", 0)) - int(f.get("mat_debt", 0)))
	var moves := moves_for(belt)
	var owned := 0
	for m in moves:
		if float(mastery.get(m, 0.0)) >= OWNED_AT:
			owned += 1
	var share := minf(minf(float(cls) / need_cls, 1.0), float(owned) / maxf(1.0, moves.size()))
	var dl := days_left(f, today)
	var aok := age_ok(f)
	return {"mat": [cls, need_cls], "moves": [owned, moves.size()], "share": share, "days_left": dl, "age_ok": aok,
		"floor_ok": dl == 0 and aok, "ready": dl == 0 and aok and share >= 1.0, "stripes": stripes_for(share)}


## Stripes earned on a coloured belt: one per quarter of the way to ready (4 = ready).
static func stripes_for(share: float) -> int:
	return clampi(int(floorf(share * STRIPES + 0.0001)), 0, STRIPES)


## The professor's call. Refused under the IBJJF floor ({"ok": false, "why"}); allowed before ready, then she owes
## EARLY_DEBT of the new belt's mat time ({"early": true}). Returns the fighter with the new belt, day and counters.
static func promote(f: Dictionary, mastery: Dictionary, today: int) -> Dictionary:
	var belt := str(f.get("belt", "white"))
	var nxt := next_belt(belt)
	if nxt == "":
		return {"ok": false, "why": "She is a black belt."}
	var r := readiness(f, mastery, today)
	if not r["age_ok"]:
		return {"ok": false, "why": "Too young for %s: the IBJJF minimum is %d." % [nxt, MIN_AGE[nxt]]}
	if int(r["days_left"]) > 0:
		return {"ok": false, "why": "%d more days at %s (the IBJJF minimum)." % [r["days_left"], belt]}
	var out := f.duplicate()
	out["belt"] = nxt
	out["belt_day"] = today
	out["mat_classes"] = 0
	out["world_champ"] = false
	var early := not bool(r["ready"])
	out["mat_debt"] = int(roundf(EARLY_DEBT * int(CLASSES_TO_NEXT.get(nxt, 0)))) if early else 0
	return {"ok": true, "early": early, "fighter": out}


## Match length in minutes at her belt (adult).
static func match_minutes(belt: String) -> int:
	return int(MATCH_MIN.get(belt, 5))
