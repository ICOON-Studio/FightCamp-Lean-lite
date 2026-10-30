extends RefCounted
## S308 deeper fight (operator: "clues to the player for what his best options or tactic should be", "rounds should be 3
## minutes and callouts from corner every 25-30 seconds that might impact the outcome"; plan approved "Build it, full 3:00",
## Godot/research/S308_FIGHT_TACTICS_PLAN.md in the old repo, Miro frames 6-11). A round is six 30-second exchanges, each
## settled on its own. The opponent fights one way at a time (MODES) and shows it in a clue line; each way has a best, an
## ok and a wrong call. A call's edge = how it fits x whether she can do it (the stats it needs) x whether she hears it
## (coachability; J55: real corners get two instructions through, so shouts past the second land at half).
## Pure static; zero preloads. Numbers are game-design values tuned by tools/exchange_balance.gd, not measurements.

const EXCHANGES := 6
const EX_SECONDS := 30.0
## Each side rolls +/- half of this an exchange. The mean margin of six exchanges then spreads like BoutRules.ROUND_SPREAD
## (27 x sqrt(6) ~ 66), so a round keeps the balance the old one-roll round had.
const EX_SPREAD := 66.0
## Power points a call is worth in one exchange, by how it fits the situation.
const EDGE := {"best": 15.0, "ok": 5.0, "none": 0.0, "wrong": -7.0}
const EDGE_WORD := {"best": "Big edge", "ok": "Small edge", "none": "No edge", "wrong": "Risky"}
## "She can": the mean of the values a call needs. Good from GOOD_AT, OK from OK_AT, else Poor (x mult on a positive edge).
const GOOD_AT := 62.0
const OK_AT := 50.0
const GRADE := {"Good": 1.0, "OK": 0.6, "Poor": 0.3}
## Shouts a round that land fully; each one after lands at LATE_SHOUT.
const FULL_SHOUTS := 2
const LATE_SHOUT := 0.5
## A clever fighter (fight_iq from IQ_FINDS) finds the ok answer herself when the same game carries on.
const IQ_FINDS := 65.0
## Her energy under which she is the problem (Combos.WEARY_AT 40 sits above it).
const SHE_TIRED := 35.0
## An exchange won by more than HURT_AT may leave the loser hurt for the next one.
const HURT_AT := 30.0
## The opponent tires into the "tiring" game under this energy.
const OPP_TIRED := 45.0
## Chance she keeps the same game into the next exchange (her coach shouts the rest of the time).
const KEEP := 0.6

## Eight real corner calls. long / body / calm keep their old ids (BoutRules.CORNER, RoundScript.CALL_BEATS, Combos).
## needs: the values she does it with (stats, footwork, personality). cost: energy per exchange on top of the round's.
const CALLS := {
	"long": {"label": "Jab and move", "shout": "Turn her! Jab and move!", "needs": ["footwork", "technique"], "cost": -0.5,
		"when": "Opponent presses", "expect": "Wins it at range, little energy"},
	"body": {"label": "Go to the body", "shout": "Downstairs! Go to the body!", "needs": ["power"], "cost": 1.5,
		"when": "Opponent boxes at range", "expect": "Slows her down later; shots coming in"},
	"lead": {"label": "Make her lead", "shout": "Feint! Make her lead!", "needs": ["fight_iq"], "cost": -0.5,
		"when": "Opponent waits to counter", "expect": "Her counters stop; a quiet exchange"},
	"hands": {"label": "Hands up, move your head", "shout": "Hands up! Move your head!", "needs": ["defense"], "cost": 0.0,
		"when": "Opponent loads up", "expect": "Big shots miss; fewer of her own"},
	"let_go": {"label": "Let your hands go", "shout": "Let your hands go!", "needs": ["conditioning", "speed"], "cost": 3.0,
		"when": "Opponent tires", "expect": "Her busiest 30 seconds; costs energy"},
	"calm": {"label": "Breathe, pick your shots", "shout": "Breathe! Pick your shots!", "needs": ["discipline"], "cost": -3.0,
		"when": "Your fighter is tired", "expect": "Energy back for later; gives a little now"},
	"tie": {"label": "Tie her up", "shout": "Hold! Tie her up!", "needs": ["heart"], "cost": -2.0,
		"when": "Your fighter is hurt", "expect": "Gets through the 30 seconds"},
	"finish": {"label": "Go get her", "shout": "She's hurt! Go get her!", "needs": ["power", "heart"], "cost": 3.0,
		"when": "Opponent is hurt", "expect": "A knockdown chance; open if tired"},
}

## The opponent's six games, and our fighter's own two states (they come first: a tired or hurt boxer is the problem).
const MODES := {
	"press": {"label": "Pressing", "best": "long", "ok": "hands", "wrong": "let_go"},
	"range": {"label": "Boxing at range", "best": "body", "ok": "lead", "wrong": "long"},
	"counter": {"label": "Waiting to counter", "best": "lead", "ok": "long", "wrong": "let_go"},
	"loadup": {"label": "Loading up", "best": "hands", "ok": "long", "wrong": "body"},
	"tiring": {"label": "Tiring", "best": "let_go", "ok": "body", "wrong": "calm"},
	"hurt": {"label": "Hurt", "best": "finish", "ok": "let_go", "wrong": "calm"},
	"she_tired": {"label": "Your fighter is tired", "best": "calm", "ok": "hands", "wrong": "let_go"},
	"she_hurt": {"label": "Your fighter is hurt", "best": "tie", "ok": "hands", "wrong": "finish"},
}

## The clue lines ({opp} her name, {her} ours). Three each so a fight does not repeat itself.
const CLUES := {
	"press": ["{opp} walks through the jab and backs {her} to the ropes.", "{opp} keeps coming forward, chin down.",
		"{her} is on the back foot; {opp} cuts off the ring."],
	"range": ["{opp}'s jab lands and she steps back out before {her} can answer.", "{opp} stays on the end of her jab.",
		"{her} can't reach {opp}: she pokes and moves."],
	"counter": ["{opp} won't lead. Every time {her} misses, she answers.", "{opp} waits, hands high, for {her} to throw.",
		"{her} leads and eats a counter over the top."],
	"loadup": ["{opp} throws one big right at a time and winds it up.", "{opp} is sitting down on every punch.",
		"{opp} drops her shoulder before the big one."],
	"tiring": ["{opp}'s mouth is open; her hands come back slow.", "{opp} holds after she punches.",
		"{opp} has stopped throwing combinations."],
	"hurt": ["{opp}'s legs dipped. She grabs and covers up.", "{opp} is holding on: that one hurt her.",
		"{opp} wobbles back to the ropes."],
	"she_tired": ["{her}'s hands are dropping; no more combinations.", "{her} is breathing through her mouth.",
		"{her} is a step slow now."],
	"she_hurt": ["{her}'s legs dipped after that shot.", "{her} is holding on: she's hurt.", "{her} wobbles back to the ropes."],
}

## Games a style plays by weight (opponent style words as Data has them).
const STYLE_MODES := {
	"Pressure fighter": {"press": 0.55, "loadup": 0.2, "range": 0.1, "counter": 0.15},
	"Counter-puncher": {"counter": 0.55, "range": 0.25, "press": 0.1, "loadup": 0.1},
	"Volume puncher": {"press": 0.45, "range": 0.35, "counter": 0.1, "loadup": 0.1},
	"Boxer-puncher": {"range": 0.35, "loadup": 0.25, "counter": 0.2, "press": 0.2},
	"Out-boxer": {"range": 0.6, "counter": 0.25, "press": 0.05, "loadup": 0.1},
}


## The situation an exchange is fought in: our fighter's own state first, else the opponent's game.
static func situation(mode: String, her_energy: float, her_hurt: bool) -> String:
	if her_hurt:
		return "she_hurt"
	if her_energy < SHE_TIRED:
		return "she_tired"
	return mode if MODES.has(mode) else "press"


## "best" / "ok" / "wrong" / "none" for a call in a situation ("" = no call).
static func fit(call: String, sit: String) -> String:
	var row: Dictionary = MODES.get(sit, {})
	for k in ["best", "ok", "wrong"]:
		if str(row.get(k, "")) == call and call != "":
			return k
	return "none"


## {word, mult}: whether she can do the call. vals = her stats merged with footwork and personality.
static func grade(call: String, vals: Dictionary) -> Dictionary:
	var needs: Array = (CALLS.get(call, {}) as Dictionary).get("needs", [])
	if needs.is_empty():
		return {"word": "Good", "mult": 1.0}
	var sum := 0.0
	for k in needs:
		sum += float(vals.get(k, 55.0))
	var mean := sum / float(needs.size())
	var word := "Good" if mean >= GOOD_AT else ("OK" if mean >= OK_AT else "Poor")
	return {"word": word, "mult": float(GRADE[word])}


## How much of a shout reaches her: coachability 0..100 -> 0.7..1.0, halved after the round's first FULL_SHOUTS.
static func uptake(coachability: float, shouts_before: int) -> float:
	var u := 0.7 + 0.3 * clampf(coachability, 0.0, 100.0) / 100.0
	return u * (1.0 if shouts_before < FULL_SHOUTS else LATE_SHOUT)


## Power points the active call is worth this exchange. finds = her fight IQ finds the ok answer herself.
static func call_edge(call: String, sit: String, vals: Dictionary, heard: float, finds: bool = false) -> float:
	var k := fit(call, sit)
	var e := float(EDGE[k])
	if e > 0.0:
		e *= float(grade(call, vals)["mult"]) * heard
	elif e < 0.0:
		e *= heard
	if finds:
		var own := MODES[sit] as Dictionary
		e = maxf(e, float(EDGE["ok"]) * float(grade(str(own["ok"]), vals)["mult"]))
	return e


## The opponent's game for the next exchange. ex = exchange index 0..5, n = round, energy = hers now.
static func next_mode(style: String, weak: String, n: int, ex: int, prev: String, energy: float, hurt: bool,
		rng: RandomNumberGenerator) -> String:
	if hurt:
		return "hurt"
	if energy < OPP_TIRED and rng.randf() < 0.75:
		return "tiring"
	var w := weak.to_lower()
	if w.contains("fades") and n >= 3 and rng.randf() < 0.5:
		return "tiring"
	if w.contains("slow to start") and n == 1 and ex < 2:
		return "counter"
	if prev != "" and prev != "hurt" and prev != "tiring" and rng.randf() < KEEP:
		return prev
	var weights: Dictionary = STYLE_MODES.get(style, STYLE_MODES["Boxer-puncher"])
	if w.contains("walks in"):
		weights = weights.duplicate()
		weights["press"] = float(weights.get("press", 0.0)) + 0.3
	var total := 0.0
	for k in weights.keys():
		total += float(weights[k])
	var roll := rng.randf() * total
	for k in weights.keys():
		roll -= float(weights[k])
		if roll <= 0.0:
			return str(k)
	return str(weights.keys()[0])


## One clue line for a situation, filled with the two names.
static func clue(sit: String, names: Array, pick: int) -> String:
	var pool: Array = CLUES.get(sit, CLUES["press"])
	return str(pool[absi(pick) % pool.size()]).replace("{her}", str(names[0])).replace("{opp}", str(names[1]))


## The three calls the shout bar offers for a situation (its best, ok and wrong, in CALLS order so the order gives
## nothing away).
static func offers(sit: String) -> Array:
	var row: Dictionary = MODES.get(sit, MODES["press"])
	var want := [str(row["best"]), str(row["ok"]), str(row["wrong"])]
	var out: Array = []
	for k in CALLS.keys():
		if want.has(k):
			out.append(k)
	return out


## Landed punches (winner, loser) by band: RoundScript.LANDED, so the 3D exchange shows what the words count.
const LANDED := {"close": [4, 3], "clear": [5, 2], "dominant": [6, 1]}


## "close" under a quarter of the spread, "dominant" from 0.6 of it, else "clear".
static func band(margin: float) -> String:
	var a := absf(margin)
	return "close" if a < 0.25 * EX_SPREAD else ("dominant" if a >= 0.6 * EX_SPREAD else "clear")


## Settles one exchange. d = her edge in power points (strength gap + call edge + energy); rolls in [0, 1).
## Returns {won, margin, landed: [hers, theirs]}.
static func settle(d: float, roll_a: float, roll_b: float) -> Dictionary:
	var margin := d + (roll_a - 0.5) * EX_SPREAD - (roll_b - 0.5) * EX_SPREAD
	var landed: Array = (LANDED[band(margin)] as Array).duplicate()
	if margin < 0.0:
		landed = [landed[1], landed[0]]
	return {"won": margin >= 0.0, "margin": margin, "landed": landed}


## The round from its exchanges: most won takes it; a 3-3 split goes to the bigger total margin.
## Returns {won, won_n, mine, theirs, landed: [a, b]} (mine - theirs = the mean margin, as BoutRules' round reads).
static func round_of(exs: Array) -> Dictionary:
	var won_n := 0
	var sum := 0.0
	var la := 0
	var lb := 0
	for e in exs:
		won_n += 1 if bool(e["won"]) else 0
		sum += float(e["margin"])
		la += int(e["landed"][0])
		lb += int(e["landed"][1])
	var lost_n := exs.size() - won_n
	var won := won_n > lost_n or (won_n == lost_n and sum >= 0.0)
	var mean := sum / maxf(1.0, float(exs.size()))
	return {"won": won, "won_n": won_n, "mine": mean, "theirs": 0.0, "landed": [la, lb]}


## The line after an exchange: did the call work? call "" = no call.
static func verdict(call: String, sit: String, won: bool, names: Array) -> String:
	var k := fit(call, sit)
	var her := str(names[0])
	if call == "":
		return "%s %s that exchange on her own." % [her, "won" if won else "lost"]
	var label := str(CALLS[call]["label"])
	if won and (k == "best" or k == "ok"):
		return "It worked: \"%s\" won the exchange." % label
	if won:
		return "%s won it, but not because of \"%s\"." % [her, label]
	if k == "wrong":
		return "Wrong call: \"%s\" played into her hands." % label
	if k == "best" or k == "ok":
		return "Right idea, \"%s\", but she lost the exchange." % label
	return "\"%s\" changed nothing: exchange lost." % label


## The corner's read of a finished round for the next round's plan: the game of the last three exchanges (the latest wins a
## tie), its best call and why. names = [hers, the opponent's]. Returns {sit, call, why}.
static func read(exs: Array, names: Array) -> Dictionary:
	var tally := {}
	var last := ""
	for x in exs.slice(maxi(0, exs.size() - 3)):
		last = str(x["sit"])
		tally[last] = int(tally.get(last, 0)) + 1
	var sit := last
	for k in tally.keys():
		if int(tally[k]) > int(tally.get(sit, 0)):
			sit = str(k)
	if sit == "":
		sit = "press"
	var call := str(MODES[sit]["best"])
	var c: Dictionary = CALLS[call]
	var state := str(names[0]) + (" was tired" if sit == "she_tired" else " was hurt") if sit.begins_with("she_") 		else "%s was %s" % [str(names[1]), str(MODES[sit]["label"]).to_lower()]
	var why := "%s at the end of that round. %s: %s." % [state, c["label"], str(c["expect"]).to_lower()]
	return {"sit": sit, "call": call, "why": why}
