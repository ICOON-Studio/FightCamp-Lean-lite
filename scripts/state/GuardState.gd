extends RefCounted
## S524 GUARDWEAR wiring steps 1-2 (ops/research/GUARDWEAR_WIRE_S524.md): each side's guard through the bout.
## f["bout"]["guard"] = {"a": {g, max, clinch}, "b": {...}} ("a" = our boxer). Every settled exchange: the punches each side
## threw that did not land are part blocked (BLOCK_SHARE); each block, by kind (BoutBurn.MIX), wears the defender's guard
## (GuardWear.wear, ctx: ropes, amateur, shoulders), scaled by WEAR_SCALE; a side the opponent barely threw at recovers
## (GuardWear.in_round). Between rounds the corner gives back GuardWear.corner([]).
## S525 step 2 damage: each blocked punch leaks GuardWear.transmission x its base (BASE) x K_THROUGH into the defender's
## m["damage"] (LiveRound adds "through" when damage_on). Sized by GUARDPROBE1 (docs/GUARDPROBE1_RESULT.md): no single
## WEAR_SCALE fits both amateur round 3 (yellow, red under 10%) and pro round 6 (orange) -> amateurs wear at AMATEUR_SCALE.
## NOT YET: the guard's feedback on the exchange (step 3's GUARD_EDGE / Leaking heavily).

const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const BoutBurn := preload("res://scripts/rules/BoutBurn.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

const BLOCK_SHARE := 0.6   ## ESTIMATE - of the punches that do not land, the share caught on the guard (the rest miss)
const WEAR_SCALE := 0.40   ## pro: GUARDPROBE1 sweep - pro6 last round 0.546 at 0.35, 0.265 at 0.45 -> ~0.40 mid-orange, red mostly the mismatch's loser
const AMATEUR_SCALE := 0.28   ## amateur: sweep 0.25 -> round 3 at 0.646, red 1.3%; 0.35 -> 0.362, red 65% -> 0.28 yellow, red rare
const K_THROUGH := 0.038   ## GUARDPROBE1: k 0.035-0.040 puts the leak at +7..11% of a bout's damage in every cell
const BASE := {"jab": 1.0, "power": 2.5, "heavy": 4.0}   ## design s1.1 punch bases (what a clean punch of the kind is worth)
static var damage_on: bool = true   ## tests turn it off for the control arm (the guard still wears and shows)
const COMBO_SHARE := 0.25  ## ESTIMATE - of the blocks, the share that are the 3rd punch on of a combination (x1.5)
const LIGHT_UPTO := 64.0   # class by the weight limit: up to 64 kg light, up to 81 kg middle, then heavy
const MIDDLE_UPTO := 81.0

const GUARD_HABITS := ["slow_starter", "fades_late", "chases_stoppage"]   ## the habits GuardWear reads (design s1.3)
const KIND := {"jab": "jab", "cross": "power", "lead_hook": "power", "body_hook": "power", "rear_uppercut": "heavy"}


static func wclass(limit_kg: float) -> String:
	if limit_kg <= LIGHT_UPTO:
		return "light"
	return "middle" if limit_kg <= MIDDLE_UPTO else "heavy"


## Round n's start: the first bell fills both guards; later bells add the corner's minute and reset the clinch.
static func open(f: Dictionary, n: int) -> Dictionary:
	var amateur := not bool(f.get("pro", false))
	var mx := GuardWear.max_guard(wclass(float(f.get("limit", 60.0))), amateur)
	if n == 1 or not f["bout"].has("guard"):
		f["bout"]["guard"] = {"a": {"g": mx, "max": mx, "clinch": false}, "b": {"g": mx, "max": mx, "clinch": false}}
	else:
		for k in ["a", "b"]:
			var s: Dictionary = f["bout"]["guard"][k]
			var calls: Array = ["hands_up"] if bool(s.get("hands_next", false)) else []   # design s2: Hands up +5 at the corner
			s["g"] = GuardWear.clamp_guard(float(s["g"]) + GuardWear.corner(calls, false, false), float(s["max"]))
			s["clinch"] = false
			s["hands_next"] = false
	return f["bout"]["guard"]


## Blocks from a side's landed count: thrown (BoutBurn's rule) less landed, times BLOCK_SHARE.
static func blocked_of(landed: int) -> int:
	var thrown := ceili(float(landed) / BoutBurn.LAND_RATE)
	return roundi(float(maxi(0, thrown - landed)) * BLOCK_SHARE)


## Guard points `blocks` cost the defender, the blocks split by BoutBurn.MIX.
static func wear_of(blocks: int, ctx: Dictionary) -> float:
	return float(wear_through(blocks, 0.0, 0.0, "middle", ctx)[0])


## [guard points, damage through] for `blocks` arriving one by one on a guard g of max mx (class wc): each block wears the
## guard by kind (x the amateur or pro scale) and leaks transmission(kind, guard as it arrives) x BASE x K_THROUGH.
static func wear_through(blocks: int, g: float, mx: float, wc: String, ctx: Dictionary) -> Array:
	var scale := AMATEUR_SCALE if bool(ctx.get("amateur", false)) else WEAR_SCALE
	var wear := 0.0
	var through := 0.0
	for mi in BoutBurn.MIX:
		var kind: String = KIND.get(str(mi[0]), "power")
		var n := float(blocks) * float(mi[1])
		for grp in [[n * (1.0 - COMBO_SHARE), 1], [n * COMBO_SHARE, 3]]:
			var left := float(grp[0])
			var w := GuardWear.wear(kind, int(grp[1]), ctx) * scale
			while left > 0.0:
				var step := minf(1.0, left)
				if mx > 0.0:
					through += step * GuardWear.transmission(kind, maxf(0.0, g - wear), mx, wc, int(grp[1])) * float(BASE[kind])
				wear += step * w
				left -= step
	return [wear, through * K_THROUGH]


## After LiveRound settles an exchange: landed [ours, theirs]; at = lv["at"] (StepWire's ropes); opp_attrs from RingDuel.opp.
## Returns {"g": [ours, theirs], "blocked": [by ours on theirs.. i.e. blocks WE made, blocks THEY made]}.
## call = the exchange's shout (Exchanges.CALLS id): "tie" is the design's clinch (+10 under half guard, once a round,
## GuardWear.clinch), "hands" earns the corner's Hands up (+5 at the next minute).
## S525 n = the round, opp_habits = RoundStyle.opponent_habits(opp): a guard habit (GUARD_HABITS) changes the wear
## (GuardWear.trait_wear_pct: slow starter) and the in-round recovery (trait_recovery_pct: fades late, chases the
## stoppage; our morale under 40 too). n 0 = no round known (old callers): habits ignored.
static func after(f: Dictionary, landed: Array, at: String, opp_attrs: Dictionary, call := "", n := 0, opp_habits: Array = []) -> Dictionary:
	if not f["bout"].has("guard"):
		open(f, 1)
	var gs: Dictionary = f["bout"]["guard"]
	var amateur := not bool(f.get("pro", false))
	var own := Attrs.of(f)
	var blocks := [blocked_of(int(landed[1])), blocked_of(int(landed[0]))]   # [we block their punches, they block ours]
	var ctxs := [
		{"ropes": at == "own_ropes", "amateur": amateur,
			"shoulder": GuardWear.shoulder(float(own.get("stamina", 55.0)), float(own.get("strength", 55.0)))},
		{"ropes": at == "opp_ropes", "amateur": amateur,
			"shoulder": GuardWear.shoulder(float(opp_attrs.get("stamina", 55.0)), float(opp_attrs.get("strength", 55.0)))}]
	var habits := [guard_habit(f.get("habits", [])), guard_habit(opp_habits)]
	var morale := [float(f.get("morale", 60.0)), 60.0]
	if n > 0:
		for k in 2:
			if habits[k] != "":
				ctxs[k]["trait"] = habits[k]
				ctxs[k]["round_n"] = n
	var keys := ["a", "b"]
	var wc := wclass(float(f.get("limit", 60.0)))
	var through := [0.0, 0.0]   # damage into [ours, theirs] through the guard
	for k in 2:
		var s: Dictionary = gs[keys[k]]
		var thrown_at := ceili(float(int(landed[1 - k])) / BoutBurn.LAND_RATE)
		var wt := wear_through(int(blocks[k]), float(s["g"]), float(s["max"]), wc, ctxs[k])
		through[k] = float(wt[1])
		var rec := GuardWear.in_round(thrown_at, amateur)
		if n > 0:
			rec *= maxf(0.0, 1.0 + GuardWear.trait_recovery_pct(str(habits[k]), n, float(morale[k])))
		var g := float(s["g"]) - float(wt[0]) + rec
		s["g"] = GuardWear.clamp_guard(g, float(s["max"]))
	var ours: Dictionary = gs["a"]
	var clinch := {}
	if call == "tie":
		clinch = GuardWear.clinch(false, float(ours["g"]), float(ours["max"]), bool(ours.get("clinch", false)))
		if bool(clinch["ok"]):
			ours["g"] = GuardWear.clamp_guard(float(ours["g"]) + float(clinch["guard"]), float(ours["max"]))
			ours["clinch"] = true
	elif call == "hands":
		ours["hands_next"] = true
	return {"g": [float(gs["a"]["g"]), float(gs["b"]["g"])], "blocked": blocks, "clinch": bool(clinch.get("ok", false)), "through": through,
		"share": [float(gs["a"]["g"]) / maxf(1.0, float(gs["a"]["max"])), float(gs["b"]["g"]) / maxf(1.0, float(gs["b"]["max"]))]}


## The first guard habit a boxer has (FighterProfile habits / RoundStyle.opponent_habits), "" when none.
static func guard_habit(habits: Array) -> String:
	for h in GUARD_HABITS:
		if habits.has(h):
			return h
	return ""


## 0..1 for the HUD's guard bar ("a" ours, "b" theirs); -1 when the bout has no guard yet (old saves, before the bell).
static func share(f: Dictionary, side: String) -> float:
	var gs: Dictionary = (f.get("bout", {}) as Dictionary).get("guard", {})
	if not gs.has(side):
		return -1.0
	return float(gs[side]["g"]) / maxf(1.0, float(gs[side]["max"]))
