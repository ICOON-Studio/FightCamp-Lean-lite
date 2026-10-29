extends RefCounted
## A fighter's training, seen in the 3D round (fight model step 3, docs/FIGHT_MODEL.md "What each one shows"): which
## punches she throws (move mastery: an unlearned move never appears), how her punches are stopped (the other's defense
## and footwork against her technique), how long her combinations run (speed) and when she tires (conditioning).
## The simulation already settled who lands how many; this only picks WHAT is thrown and HOW it is stopped. PURE.
## profile = {"moves": {Data.MOVES name: mastery}, "stats": {rating: value}, "footwork": float, "combos": {id: mastery},
## "energy": 0..100 at the start of the round (S302, set by the caller)}; {} = the old generic mix.
## An opponent has no stored profile yet: from_opponent() reads her rating, style and scouting words ("Fades after
## round 2" = she tires; "Body hooks" = her best punch), so what the scout said is what the ring shows.

const Combos := preload("res://scripts/rules/Combos.gd")

## Data.MOVES name -> the beats the ring plays, with their shares. The hook and the uppercut are drilled as one move each
## but thrown off both hands (S300: the Punch Pro library has both); the check hook is a counter, thrown as the lead hook.
const MOVE_BEAT := {"Jab": {"jab": 1.0}, "Cross": {"cross": 1.0}, "Lead hook": {"lead_hook": 0.7, "rear_hook": 0.3},
	"Body hook": {"body_hook": 1.0}, "Uppercut": {"rear_uppercut": 0.6, "lead_uppercut": 0.4}, "Check hook": {"lead_hook": 1.0}}
## An amateur's punch mix at full mastery (the jab is about half of what is thrown).
const SHARE := {"Jab": 0.45, "Cross": 0.27, "Lead hook": 0.14, "Body hook": 0.08, "Uppercut": 0.06, "Check hook": 0.04}
## Below MIN_MASTERY a move is not thrown at all; at FULL_MASTERY it is thrown at its full share (up to 1.5x above).
const MIN_MASTERY := 15.0
const FULL_MASTERY := 40.0
## Combinations: 1 punch, 2 from FAST[0] speed, 3 from FAST[1].
const FAST := [58.0, 66.0]
## Conditioning under TIRED_BELOW shows tired beats from round 2, more each round.
const TIRED_BELOW := 58.0
## Footwork from FOOTWORK_STEP adds a step (holding her range) and turns some of her defence into stepping back.
const FOOTWORK_STEP := 62.0
## What a defended punch looks like: the receiver's response, weighted (pull = a step back out of range).
const DEFENCE := {"block": 0.5, "slip": 0.3, "weave": 0.2}


static func stat(p: Dictionary, key: String, fallback: float = 55.0) -> float:
	return float((p.get("stats", {}) as Dictionary).get(key, fallback))


static func footwork(p: Dictionary) -> float:
	return float(p.get("footwork", (stat(p, "speed") + stat(p, "defense")) * 0.5))


## Our fighter's profile from her career dict (moves, stats, and footwork once the fighter profile stores it).
static func of_fighter(f: Dictionary) -> Dictionary:
	var p := {"moves": (f.get("moves", {}) as Dictionary).duplicate(), "stats": (f.get("stats", {}) as Dictionary).duplicate(),
		"combos": (f.get("combos", {}) as Dictionary).duplicate()}
	if f.has("footwork"):
		p["footwork"] = float(f["footwork"])
	return p


## An opponent's profile from what the offer and the scout know: rating, style, threat and weakness words.
static func from_opponent(opp: Dictionary) -> Dictionary:
	var r := float(opp.get("rating", 60.0))
	var st := {"power": r, "speed": r, "technique": r, "defense": r, "conditioning": r, "fight_iq": r, "chin": r}
	var moves := {"Jab": r * 0.85, "Cross": r * 0.75, "Lead hook": r * 0.6, "Body hook": r * 0.45, "Uppercut": r * 0.3,
		"Check hook": 0.0}
	var threat := str(opp.get("threat", "")).to_lower()
	var weak := str(opp.get("weak", "")).to_lower()
	var style := str(opp.get("style", "")).to_lower()
	# S303: her style shapes her mix, so the round's words ("works both hands inside") match the punches that land and the
	# corner card's HURT line (ESTIMATE weights: inside fighters live on hooks and body shots, out-boxers on the jab).
	if style.contains("pressure"):
		moves["Lead hook"] = r * 0.85
		moves["Body hook"] = r * 0.75
		moves["Jab"] = r * 0.6
	elif style.contains("slugger"):
		moves["Cross"] = r * 0.9
		moves["Lead hook"] = r * 0.85
		moves["Jab"] = r * 0.6
	elif style.contains("out"):
		moves["Jab"] = r
		moves["Lead hook"] = r * 0.5
	if threat.contains("body"):
		moves["Body hook"] = r
	elif threat.contains("hook"):
		moves["Lead hook"] = r
	if threat.contains("right") or threat.contains("cross") or threat.contains("straight"):
		moves["Cross"] = r
	if threat.contains("flurr") or threat.contains("never stops") or style.contains("volume"):
		st["speed"] = r + 8.0
	if threat == "everything":
		for m in moves:
			moves[m] = r * 0.8
	if style.contains("counter"):
		moves["Check hook"] = r * 0.6
	if weak.contains("fades") or weak.contains("legs late"):
		st["conditioning"] = r - 10.0
	if weak.contains("chin open"):
		st["defense"] = r - 10.0
	var fw := r + (6.0 if style.contains("counter") or style.contains("out") else 0.0)
	if weak.contains("stands still") or weak.contains("walks in straight"):
		fw = r - 10.0
	return {"moves": moves, "stats": st, "footwork": fw, "combos": Combos.opponent_combos(opp)}


## S301: the opponent's two ring habits (HabitBeats ids) from the scout's weakness and threat words, so what the scout wrote
## is what the ring shows ("Fades after round 2" -> she fades late; "Leaves her chin open" -> her right drops after the jab).
const OPP_HABIT_WORDS := [["fades", "fades_late"], ["legs late", "fades_late"], ["slow to start", "slow_starter"],
	["gives away round 1", "slow_starter"], ["chin open", "drops_right_after_jab"], ["walks in straight", "lunges_with_jab"],
	["stands still after", "admires_her_work"], ["body", "digs_body_when_hurt"], ["wide hooks", "loads_up_when_hurt"],
	["overhand", "loads_up_when_hurt"], ["heavy right", "loads_up_when_hurt"]]


static func opponent_habits(opp: Dictionary) -> Array:
	var words := (str(opp.get("weak", "")) + " | " + str(opp.get("threat", ""))).to_lower()
	var out: Array = []
	for pair in OPP_HABIT_WORDS:
		if words.contains(str(pair[0])) and not out.has(pair[1]) and out.size() < 2:
			out.append(pair[1])
	return out


## Beat move -> weight, from mastery. Empty mastery (an old save) throws the generic mix.
static func punch_weights(p: Dictionary) -> Dictionary:
	var moves: Dictionary = p.get("moves", {})
	var out := {}
	for m in SHARE:
		var mastery := float(moves.get(m, FULL_MASTERY if moves.is_empty() else 0.0))
		if mastery < MIN_MASTERY or m == "Check hook":
			continue
		var split: Dictionary = MOVE_BEAT[m]
		for beat in split:
			out[beat] = float(out.get(beat, 0.0)) + float(SHARE[m]) * float(split[beat]) * clampf(mastery / FULL_MASTERY, 0.0, 1.5)
	if out.is_empty():
		out["jab"] = 1.0
	return out


static func punch(p: Dictionary, rng: RandomNumberGenerator) -> String:
	var w := punch_weights(p)
	var total := 0.0
	for k in w:
		total += float(w[k])
	var roll := rng.randf() * total
	for k in w:
		roll -= float(w[k])
		if roll <= 0.0:
			return str(k)
	return str(w.keys()[-1])


## How the receiver stops a punch that did not land: "block", "slip", "weave", "pull" (a step back), or "" (a wide miss,
## no defence needed). Her defense makes it active more often; the thrower's technique leaves fewer wide misses.
static func defend(receiver: Dictionary, thrower: Dictionary, rng: RandomNumberGenerator) -> String:
	var active := clampf(0.3 + (stat(receiver, "defense") - 50.0) / 40.0 + (stat(thrower, "technique") - 50.0) / 80.0, 0.1, 0.92)
	if rng.randf() >= active:
		return ""
	var w := DEFENCE.duplicate()
	w["pull"] = 0.35 * clampf((footwork(receiver) - 50.0) / 20.0, 0.0, 1.5)
	var total := 0.0
	for k in w:
		total += float(w[k])
	var roll := rng.randf() * total
	for k in w:
		roll -= float(w[k])
		if roll <= 0.0:
			return str(k)
	return "block"


## The longest combination she throws: 1-3 punches from her speed ({} = 3, the old mix).
static func combo_cap(p: Dictionary) -> int:
	if p.is_empty():
		return 3
	var s := stat(p, "speed")
	return 1 + int(s >= float(FAST[0])) + int(s >= float(FAST[1]))


## Tired beats she shows in round n: none in round 1; then up to 2 per round past the first, the lower her conditioning.
static func tired_beats(p: Dictionary, n: int) -> int:
	if p.is_empty() or n < 2:
		return 0
	var short := TIRED_BELOW - stat(p, "conditioning")
	if short <= 0.0:
		return 0
	return mini(4, (n - 1) * (1 + int(short >= 6.0)))


## Extra footwork beats in a round: one when her footwork holds her range.
static func extra_steps(p: Dictionary) -> int:
	return 0 if p.is_empty() else int(footwork(p) >= FOOTWORK_STEP)
