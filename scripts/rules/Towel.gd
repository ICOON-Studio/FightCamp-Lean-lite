extends RefCounted
## R26 THE TOWEL: when the card comes in the corner minute, the risk it shows, and what each answer costs.
## Pure static module; preloads Knockdowns, BodyMap, InjuryRoll, Attrs. Our fighter is always side "a".
## The line numbers (LINES) are the map's ESTIMATES; TOWEL1 is their probe (ops/research/TASK_R26TOWEL1.md).

const KD := preload("res://scripts/rules/Knockdowns.gd")
const BM := preload("res://scripts/rules/BodyMap.gd")
const IR := preload("res://scripts/rules/InjuryRoll.gd")
const AT := preload("res://scripts/rules/Attrs.gd")

const LINES := {"careful": 0.12, "normal": 0.20, "brave": 0.33}
const LINE_WORDS := ["Careful", "Normal", "Brave"]
const PULL_DAYS := 14
const PULL_MORALE := -4


## The chance our fighter is stopped next round, as Box safe would make it, and the chance of losing the round each way.
## state = {sides: {a: {power, chin, heart, stop_mult}, b: {...}}, damage: {a, b}, counts: {a, b},
##          p_lose: float, p_lose_safe: float, margins: {close, clear, dominant} (shares, sum 1)}.
## Run n seeded trials; draw lose with p_lose; on a loss draw the margin and call KD.round_counts; on a win call KD.puncher_chance.
## BOX SAFE runs the same with p_lose_safe and every margin one band lower (softer).
## The internal RNG for Knockdowns is separate so both paths get the same internal draws (only margin differs).
static func risk(state: Dictionary, n: int = 200, seed: int = 1) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var sides: Dictionary = state["sides"]
	var damage: Dictionary = state["damage"]
	var counts: Dictionary = state["counts"]
	var p_lose: float = float(state["p_lose"])
	var p_lose_safe: float = float(state["p_lose_safe"])
	var margins: Dictionary = state["margins"]
	var stop := 0
	var stop_safe := 0
	var lose := 0
	var lose_safe := 0
	for _i in range(n):
		var u := rng.randf()   # S441 at collect: ONE draw for both arms, so the two numbers differ by the answer, not by luck
		var lost := u < p_lose
		var lost_safe := u < p_lose_safe
		var margin := _draw_margin(margins, rng)
		var internal_seed := rng.randi()
		var internal_rng := RandomNumberGenerator.new()
		internal_rng.seed = internal_seed
		if lost:
			lose += 1
			var res := KD.round_counts(margin, "a", sides, damage, counts, internal_rng)
			if bool(res["stopped"]):
				stop += 1
		else:
			var res := KD.puncher_chance("a", sides, damage, counts, internal_rng)
			if bool(res["stopped"]):
				stop += 1
		internal_rng.seed = internal_seed
		if lost_safe:
			lose_safe += 1
			var res := KD.round_counts(softer(margin), "a", sides, damage, counts, internal_rng)
			if bool(res["stopped"]):
				stop_safe += 1
		else:
			var res := KD.puncher_chance("a", sides, damage, counts, internal_rng)
			if bool(res["stopped"]):
				stop_safe += 1
	return {"stop": float(stop) / float(n), "stop_safe": float(stop_safe) / float(n),
		"lose": float(lose) / float(n), "lose_safe": float(lose_safe) / float(n)}


## Draw a margin from the shares {close, clear, dominant}.
static func _draw_margin(margins: Dictionary, rng: RandomNumberGenerator) -> String:
	var roll := rng.randf()
	var accum := 0.0
	for key in ["close", "clear", "dominant"]:
		accum += float(margins.get(key, 0.0))
		if roll < accum:
			return key
	return "close"


## Softer: dominant -> clear -> close, close stays close.
static func softer(margin: String) -> String:
	if margin == "dominant":
		return "clear"
	if margin == "clear":
		return "close"
	return "close"


## Reasons for the card: "count" (counts_last_round > 0), "head" (head_v at or under CRITICAL),
## "eye" (eye_closing true), "line" (risk_now.stop at or over LINES[line]).
static func reasons(state: Dictionary, line: String, risk_now: Dictionary) -> Array:
	var out: Array = []
	if int(state.get("counts_last_round", 0)) > 0:
		out.append({"id": "count", "words": "a count in the round just gone"})
	var head_v: float = float(state.get("head_v", 100.0))
	if head_v <= BM.CRITICAL:
		out.append({"id": "head", "words": "head damage past the critical band"})
	if bool(state.get("eye_closing", false)):
		out.append({"id": "eye", "words": "the eye is closing"})
	var line_threshold: float = float(LINES.get(line, 0.20))
	if float(risk_now.get("stop", 0.0)) >= line_threshold:
		out.append({"id": "line", "words": "the risk is at or over your line"})
	return out


## True when reasons is not empty.
static func comes(state: Dictionary, line: String, risk_now: Dictionary) -> bool:
	return reasons(state, line, risk_now).size() > 0


## Coach pulls at the line by itself (stop at or over LINES[line]).
static func coach_pulls(risk_now: Dictionary, line: String) -> bool:
	var line_threshold: float = float(LINES.get(line, 0.20))
	return float(risk_now.get("stop", 0.0)) >= line_threshold


## The lasting price of each answer, NOT applied (the caller applies it).
## ctx = {band: loyalty band word, day, last_stop_day (-1 when none)}.
static func answer(kind: String, ctx: Dictionary) -> Dictionary:
	var band: String = str(ctx.get("band", "Settled"))
	var day: int = int(ctx.get("day", 0))
	var last_stop_day: int = int(ctx.get("last_stop_day", -1))
	if kind == "pull":
		var loyalty: int = 2
		if band == "Wavering" or band == "Leaving":
			loyalty = -6
		return {"result": "retired", "next_round": false, "wear": false, "injury_roll": false,
			"days_out": PULL_DAYS, "morale": PULL_MORALE, "loyalty": loyalty, "mark": "pulled me out"}
	if kind == "one_more":
		var days_out: int = IR.KO_DAYS
		if last_stop_day >= 0 and day - last_stop_day <= IR.KO_SECOND_WINDOW:
			days_out = IR.KO_SECOND_DAYS
		return {"next_round": true, "if_stopped": {"wear": true, "durability_drop": AT.STOP_DROP,
			"days_out": days_out}, "if_won_bout": {"mark": "sent me out"}}
	if kind == "box_safe":
		return {"next_round": true, "pace": "save", "call": "hands", "gloves_high": true, "margin": "softer"}
	return {}


## "Stopped next round: 14 in 100 (Box safe: 6 in 100). Your line: 20." (rounded in 100s).
static func words(risk_now: Dictionary, line: String) -> String:
	var stop_pct: int = roundi(float(risk_now.get("stop", 0.0)) * 100.0)
	var safe_pct: int = roundi(float(risk_now.get("stop_safe", 0.0)) * 100.0)
	var line_pct: int = roundi(float(LINES.get(line, 0.20)) * 100.0)
	return "Stopped next round: %d in 100 (Box safe: %d in 100). Your line: %d." % [stop_pct, safe_pct, line_pct]
