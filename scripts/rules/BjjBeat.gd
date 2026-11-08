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
## happen, never how one is scored. BJJBEAT2: STRIPE_EDGE scales the mat step of a four-stripe against a fresh same belt
## (a belt-gap bout is two different belts, so it does not move). BROWN_TRY is how often a brown belt, rolling with
## another brown, acts on a submission it already chose - more attempts inside the beat, not a shorter beat.
## Pure static; preloads BjjWalk, BjjTree, BjjBody, BjjRef.

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
## Class shares this far apart are a four-stripe against a fresh athlete. An even field sits inside 0.5-0.9.
const STRIPE_GAP := 0.75


## The same arguments and result as BjjWalk.walk.
static func walk(ana: Dictionary, opp: Dictionary, plans: Array, minutes: int, rules: Dictionary, rng: RandomNumberGenerator,
		extra: Dictionary = {}) -> Dictionary:
	var ctx := BjjWalk._ctx(ana, opp, plans, rules, extra)
	_stripe(ctx)
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
			var pk := _choose(ctx, st, s, rng)
			picks[s] = pk
			# Nothing worth trying = framing and gripping (WORK, never a stall); only the late-lead hold is IDLE (critics R3:
			# "split a hold into working and idle"; S398 measured: idling every no-pick beat drew 2.4 penalties a white match).
			if (pk["e"] as Dictionary).is_empty():
				# A late hold is the only idle. T.IDLE_P below 1 breaks some of those holds into work, so a
				# lead that runs the clock does not always draw the 20-s count.
				var idle: bool = str(pk["why"]) == "late"
				if idle and float(BjjTree.T.get("IDLE_P", 1.0)) < 1.0 and rng.randf() >= float(BjjTree.T["IDLE_P"]):
					idle = false
				intent[s] = "idle" if idle else "work"
				continue
			intent[s] = "act" if rng.randf() < _brown_act(ctx, pk, act_p(ctx, st, s)) else "work"
		var hitter := -1
		var missed := -1
		var over := false
		for s in [first, 1 - first]:
			if intent[s] != "act":
				continue
			if str(st["at"]) != at_before:
				intent[s] = "void"
				continue
			if BjjWalk._leads(st, 1 - s):
				var cut := _trail_cut(ctx, st, s)
				if cut < 1.0:
					BjjTree.T["SUB_BEHIND"] = cut
			elif BjjWalk._leads(st, s) and float(BjjTree.T.get("LEAD_SUB", 1.0)) > 1.0:
				BjjTree.T["LEAD_FIN"] = float(BjjTree.T["LEAD_SUB"])
			if float(ctx["mat"][s]) - float(ctx["mat"][1 - s]) > float(BjjTree.T.get("FAV_AT", 99.0)):
				BjjTree.T["FAV_ON"] = float(BjjTree.T.get("FAV_ODD", 1.0))
			var hit := BjjWalk.attempt(ctx, st, s, picks[s], rng, vis)
			BjjTree.T.erase("SUB_BEHIND")
			BjjTree.T.erase("LEAD_FIN")
			BjjTree.T.erase("FAV_ON")
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
					if int(st["idle"][s]) >= int(round(float(BjjTree.T.get("STALL_N", STALL_BEATS)))):
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
		elif missed >= 0 and _miss_flips(rng):
			st["init"] = 1 - missed
		elif intent[1 - first] == "work" and intent[first] == "idle":
			st["init"] = 1 - first
		st["t"] = float(st["t"]) + beat_s
		st["beat"] = int(st["beat"]) + 1
	var w := BjjWalk.result(ctx, st, opp, minutes, rng)
	w["works"] = st["works"]
	# The referee's 20-s counts this bout (BjjRef.stall), so a bar can see that the count fired, not only a later penalty.
	w["stalls"] = [int(st["ref"]["stall"][0]), int(st["ref"]["stall"][1])]
	return w


## How hard a trailing side's score is cut. Even, or only a level behind: T.SUB_TRAIL, so a lead stands.
## Further behind than T.TRAIL_GAP (a lower belt chasing a much higher one): no cut, so a mismatch can still upset.
static func _trail_cut(ctx: Dictionary, st: Dictionary, s: int) -> float:
	var cut := float(BjjTree.T.get("SUB_TRAIL", 1.0))
	if cut >= 1.0 or not BjjWalk._leads(st, 1 - s):
		return 1.0
	var gap := float(ctx["mat"][s]) - float(ctx["mat"][1 - s])
	if gap < -float(BjjTree.T.get("TRAIL_GAP", 99.0)):
		return 1.0
	return cut


## The side's pick. A trailer rates every scoring edge at the trail cut and steps past a scoring plan step.
static func _choose(ctx: Dictionary, st: Dictionary, s: int, rng: RandomNumberGenerator) -> Dictionary:
	var cut := _trail_cut(ctx, st, s)
	var hunt := float(BjjTree.T.get("SUB_HUNT", 1.0))
	if hunt != 1.0:
		BjjTree.T["SUB_HUNT_ON"] = hunt
	if cut < 1.0:
		_skip_plan_score(ctx, st, s)
		BjjTree.T["SUB_BEHIND"] = cut
	var pk: Dictionary = BjjWalk.choose(ctx, st, s, rng)
	BjjTree.T.erase("SUB_BEHIND")
	BjjTree.T.erase("SUB_HUNT_ON")
	return pk


## Drop a scoring step that is the plan step from this node. The next step usually starts where that one lands,
## so the plan pauses and the score pick (scoring edges already cut) runs instead.
static func _skip_plan_score(ctx: Dictionary, st: Dictionary, s: int) -> void:
	var plan: Array = ctx["plans"][s]
	var i := int(st["plan_i"][s])
	var own: String = st["at"] if s == 0 else BjjTree.mirror(st["at"])
	while i < plan.size():
		var pe: Dictionary = BjjTree.edge(str(plan[i]))
		if str(pe.get("from", "")) != own or (float(pe.get("points", 0.0)) <= 0.0 and str(pe.get("odds", "")) != "submission"):
			break
		i += 1
	st["plan_i"][s] = i


## STRIPE_EDGE (1 = the full step) pulls the two mat-times together. Same belt only, and only across that stripe gap,
## so a belt-gap row and an even field keep the mat step they already have.
static func _stripe(ctx: Dictionary) -> void:
	var w := float(BjjTree.T.get("STRIPE_EDGE", 1.0))
	if w >= 0.999:
		return
	var a: Dictionary = ctx["f"][0]
	var b: Dictionary = ctx["f"][1]
	var belt := str(a.get("belt", ""))
	if belt == "" or belt != str(b.get("belt", "")):
		return
	var need := float(BjjTree.BeltRoad.CLASSES_TO_NEXT.get(belt, 300))
	if need <= 0.0:
		return
	var sa := _class_share(a, need)
	var sb := _class_share(b, need)
	if absf(sa - sb) < STRIPE_GAP:
		return
	var mid := (float(ctx["mat"][0]) + float(ctx["mat"][1])) * 0.5
	ctx["mat"][0] = mid + (float(ctx["mat"][0]) - mid) * w
	ctx["mat"][1] = mid + (float(ctx["mat"][1]) - mid) * w


static func _class_share(f: Dictionary, need: float) -> float:
	var cls := float(f.get("mat_classes", 0)) - float(f.get("mat_debt", 0))
	return clampf(cls / need, 0.0, 1.0)


## BROWN_TRY (1 = unchanged) raises the chance a brown belt acts on a submission it already picked, and only in a
## brown-against-brown bout, so a belt-gap win share is the same bout it was.
static func _brown_act(ctx: Dictionary, pk: Dictionary, p: float) -> float:
	var k := float(BjjTree.T.get("BROWN_TRY", 1.0))
	if is_equal_approx(k, 1.0):
		return p
	var belt0 := str((ctx["f"][0] as Dictionary).get("belt", ""))
	var belt1 := str((ctx["f"][1] as Dictionary).get("belt", ""))
	if belt0 != "brown" or belt1 != "brown":
		return p
	if str((pk.get("e", {}) as Dictionary).get("odds", "")) != "submission":
		return p
	return clampf(p * k, 0.05, 0.95)


## The chance that side s acts on its pick this beat (else it works the grips).
static func act_p(ctx: Dictionary, st: Dictionary, s: int) -> float:
	var T: Dictionary = BjjTree.T
	var p := float(T["ACT_P"]) + float(T["ACT_GRIP"]) * float(st["grip"][s])
	if int(st.get("init", -1)) == s:
		p += float(T.get("ACT_INIT", 0.0))
	p *= 1.0 + 0.5 * (float(ctx["body"][s]["aggression"]) - BjjBody.DEFAULT) / BjjBody.DEFAULT
	return clampf(p, 0.05, 0.95)


## A miss hands the initiative over when T.MISS_FLIP is 1 (the built rule). Lower keeps the attacker pressing.
static func _miss_flips(rng: RandomNumberGenerator) -> bool:
	var flip := float(BjjTree.T.get("MISS_FLIP", 1.0))
	if flip >= 1.0:
		return true
	return flip > 0.0 and rng.randf() < flip
