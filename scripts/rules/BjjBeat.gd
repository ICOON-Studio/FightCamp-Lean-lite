extends RefCounted
## S398 BJJREAL step 3 (ops/research/BJJ_REALISM_S397.md 7): the two-sided beat. A beat is ~11 s (T.BEAT2_S: 27 at white,
## 55 at black) and BOTH sides choose: ACT (an arrow, BjjWalk.attempt - the same odds, levers, gate and landing as the
## 33-s walk), WORK (grip fighting or framing: no roll, a grip stack that adds T.GRIP_W on the logit to the side's next
## attempt, minus the other's) or IDLE (a breath; two idle beats in a row off a pin = the referee's 20-s count, a stall).
## The initiative decides whose action resolves first: if it lands, or slides the position, the other's move was from a
## position that is gone and is void; on a reset the other's move still runs. After the beat the initiative goes to the side
## that landed, else away from a side that missed, else to the side that worked while the other idled.
## Whether a side acts or works: T.ACT_P a beat, + T.ACT_GRIP a grip stack it holds, bent by aggression (a hunter acts
## more); a plan step is acted at the same rate (the plan says what, the beat says when).
## The walk's helpers do everything else (BjjWalk.start / choose / attempt / ended / result), so a beat changes WHEN moves
## happen, never how one is scored. Pure static; preloads BjjWalk, BjjTree, BjjBody, BjjRef.

const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjBody := preload("res://scripts/rules/BjjBody.gd")
const BjjRef := preload("res://scripts/rules/BjjRef.gd")

## The 33-s beat the per-beat amounts (breath, the referee's top time) were sized on.
const OLD_BEAT := 33.0
const GRIP_MAX := 2.0
const WORK_GAS := 0.01
## Idle beats in a row off a pin that make one stall (2 x 11 s = the IBJJF 20-s count).
const STALL_BEATS := 2


## The same arguments and result as BjjWalk.walk.
static func walk(ana: Dictionary, opp: Dictionary, plans: Array, minutes: int, rules: Dictionary, rng: RandomNumberGenerator,
		extra: Dictionary = {}) -> Dictionary:
	var ctx := BjjWalk._ctx(ana, opp, plans, rules, extra)
	var T: Dictionary = BjjTree.T
	var beat_s := float(T["BEAT2_S"])
	var k := beat_s / OLD_BEAT
	var st := BjjWalk.start(ana, minutes, rules, rng, extra)
	st["idle"] = [0, 0]
	st["works"] = [0, 0]
	while float(st["t"]) < float(st["end"]):
		var first := int(st["init"])
		var at_before: String = st["at"]
		var vis := BjjWalk.visit(st)
		var picks: Array = [{}, {}]
		var intent: Array = ["idle", "idle"]
		for s in [first, 1 - first]:
			var pk := BjjWalk.choose(ctx, st, s, rng)
			picks[s] = pk
			# Nothing worth trying = framing and gripping (WORK, never a stall); only the late-lead hold is IDLE (critics R3:
			# "split a hold into working and idle"; S398 measured: idling every no-pick beat drew 2.4 penalties a white match).
			if (pk["e"] as Dictionary).is_empty():
				intent[s] = "idle" if pk["why"] == "late" else "work"
				continue
			intent[s] = "act" if rng.randf() < act_p(ctx, st, s) else "work"
		var hitter := -1
		var missed := -1
		var over := false
		for s in [first, 1 - first]:
			if intent[s] != "act":
				continue
			if str(st["at"]) != at_before:
				intent[s] = "void"
				continue
			var hit := BjjWalk.attempt(ctx, st, s, picks[s], rng, vis)
			st["grip"][s] = 0.0
			if BjjWalk.ended(st, str(picks[s]["e"]["move"]), rng, beat_s, vis):
				over = true
				break
			if hit:
				hitter = s
			else:
				missed = s
		if over:
			break
		for s in 2:
			match str(intent[s]):
				"idle":
					BjjWalk.hold(ctx, st, s, picks[s], at_before, BjjBody.BREATHE * k)
					st["grip"][s] = maxf(0.0, float(st["grip"][s]) - 1.0)
					st["idle"][s] = int(st["idle"][s]) + 1
					if int(st["idle"][s]) >= STALL_BEATS:
						st["idle"][s] = 0
						var own: String = at_before if s == 0 else BjjTree.mirror(at_before)
						if not BjjRef.is_pin(own):
							BjjWalk._stall(ctx, st, s, own)
				"work":
					st["grip"][s] = minf(GRIP_MAX, float(st["grip"][s]) + 1.0)
					st["gas"][s] = maxf(0.0, float(st["gas"][s]) - WORK_GAS * k * BjjBody.drain(float(ctx["body"][s]["cardio"])))
					st["idle"][s] = 0
					st["works"][s] = int(st["works"][s]) + 1
				_:
					st["idle"][s] = 0
		BjjWalk._top(st, k)
		if hitter >= 0:
			st["init"] = hitter
		elif missed >= 0:
			st["init"] = 1 - missed
		elif intent[1 - first] == "work" and intent[first] == "idle":
			st["init"] = 1 - first
		st["t"] = float(st["t"]) + beat_s
		st["beat"] = int(st["beat"]) + 1
	var w := BjjWalk.result(ctx, st, opp, minutes, rng)
	w["works"] = st["works"]
	return w


## The chance that side s acts on its pick this beat (else it works the grips).
static func act_p(ctx: Dictionary, st: Dictionary, s: int) -> float:
	var T: Dictionary = BjjTree.T
	var p := float(T["ACT_P"]) + float(T["ACT_GRIP"]) * float(st["grip"][s])
	p *= 1.0 + 0.5 * (float(ctx["body"][s]["aggression"]) - BjjBody.DEFAULT) / BjjBody.DEFAULT
	return clampf(p, 0.05, 0.95)
