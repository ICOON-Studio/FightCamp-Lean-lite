extends RefCounted
## FIGHT VIDEO DATASET (S495): the exchanges of one synthetic clip, as the same "beats" the game's rounds are made of
## (BeatFire reads them), so every punch is thrown, defended and landed by the game's own code and its label is exact.
## Not the sim: the mix is chosen for a balanced training set (all six punch types, three results), not for realism of
## who wins. Pure: no scene, no clock - only the rng.
##   build(rng, seconds) -> Array of {t, who "a"|"b", move, result "lands"|"blocked"|"misses", def, big, knockback, caption}

const FIRST := {"jab": 30, "cross": 16, "lead_hook": 14, "rear_hook": 10, "lead_uppercut": 9, "rear_uppercut": 10, "body_hook": 11}
## A follow-up changes hands most of the time (real combinations alternate): the pool after a lead-hand / rear-hand punch.
const AFTER_LEAD := {"cross": 34, "rear_hook": 18, "rear_uppercut": 18, "jab": 14, "lead_hook": 8, "body_hook": 8}
const AFTER_REAR := {"lead_hook": 30, "jab": 22, "lead_uppercut": 18, "body_hook": 14, "cross": 10, "rear_hook": 6}
const LEAD := ["jab", "lead_hook", "lead_uppercut", "body_hook"]
const COMBO_LEN := {1: 38, 2: 32, 3: 21, 4: 9}
const RESULT := {"lands": 40, "blocked": 30, "misses": 30}
## How a missed head punch is avoided ("" = BeatFire rolls a slip or a step back itself).
const DEF_STRAIGHT := {"slip": 50, "pull": 30, "": 20}
const DEF_ROUND := {"weave": 45, "pull": 30, "slip": 15, "": 10}
const START_S := 1.0
const TAIL_S := 1.6          # nothing starts this close to the clip's end (the last punch must land and come back)
const BURST_GAP_S := Vector2(0.38, 0.56)
const REST_S := Vector2(0.8, 1.9)
const COUNTER_CHANCE := 0.22
const COUNTER_S := Vector2(0.5, 0.75)
const BIG_CHANCE := 0.06


static func pick(rng: RandomNumberGenerator, table: Dictionary) -> Variant:
	var total := 0.0
	for k in table:
		total += float(table[k])
	var roll := rng.randf() * total
	for k in table:
		roll -= float(table[k])
		if roll <= 0.0:
			return k
	return table.keys()[-1]


static func build(rng: RandomNumberGenerator, seconds: float) -> Array:
	var beats: Array = []
	var t := START_S + rng.randf() * 0.6
	var who := rng.randi() % 2
	while t < seconds - TAIL_S:
		var n := int(pick(rng, COMBO_LEN))
		var move := ""
		var last_result := ""
		for k in n:
			if t >= seconds - TAIL_S:
				break
			move = str(pick(rng, FIRST if move == "" else (AFTER_LEAD if move in LEAD else AFTER_REAR)))
			last_result = str(pick(rng, RESULT))
			beats.append(_beat(rng, t, who, move, last_result))
			t += rng.randf_range(BURST_GAP_S.x, BURST_GAP_S.y)
		# The boxer who made her miss or blocked it sometimes answers at once (a counter); a boxer who was hit never does
		# (the game locks her in the hit reaction and would refuse the punch).
		if last_result != "lands" and rng.randf() < COUNTER_CHANCE and t < seconds - TAIL_S:
			t += rng.randf_range(COUNTER_S.x, COUNTER_S.y) - BURST_GAP_S.x
			beats.append(_beat(rng, t, 1 - who, str(pick(rng, FIRST)), str(pick(rng, RESULT))))
			t += BURST_GAP_S.y
		t += rng.randf_range(REST_S.x, REST_S.y)
		who = rng.randi() % 2
	return beats


static func _beat(rng: RandomNumberGenerator, t: float, who: int, move: String, result: String) -> Dictionary:
	var def := ""
	if result == "blocked":
		def = "block"
	elif result == "misses" and move != "body_hook":
		def = str(pick(rng, DEF_ROUND if move.contains("hook") or move.contains("uppercut") else DEF_STRAIGHT))
	return {"t": t, "who": "a" if who == 0 else "b", "move": move, "result": result, "def": def,
		"big": result == "lands" and rng.randf() < BIG_CHANCE, "knockback": false, "caption": ""}


## The label words of a beat: the six punch types by hand, target, result.
static func type_of(move: String, lead_hand: bool) -> String:
	var side := "lead" if lead_hand else "rear"
	if move == "jab" or move == "cross":
		return move
	if move.contains("uppercut"):
		return side + " uppercut"
	return side + " hook"   # lead_hook, rear_hook and the body hook (its hand read off the clip)


static func result_of(result: String) -> String:
	return {"lands": "landed", "blocked": "blocked", "misses": "missed"}.get(result, result)
