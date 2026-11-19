extends RefCounted
## S524 GUARDWEAR wiring steps 1-2 (ops/research/GUARDWEAR_WIRE_S524.md): each side's guard through the bout.
## f["bout"]["guard"] = {"a": {g, max, clinch}, "b": {...}} ("a" = our boxer). Every settled exchange: the punches each side
## threw that did not land are part blocked (BLOCK_SHARE); each block, by kind (BoutBurn.MIX), wears the defender's guard
## (GuardWear.wear, ctx: ropes, amateur, shoulders), scaled by WEAR_SCALE; a side the opponent barely threw at recovers
## (GuardWear.in_round). Between rounds the corner gives back GuardWear.corner([]).
## NOT YET: damage through the guard and the guard's feedback on the exchange (step 3) - both wait for GUARDPROBE1, which
## sizes WEAR_SCALE and BLOCK_SHARE. Until then the guard is read and shown, never changes a result.

const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const BoutBurn := preload("res://scripts/rules/BoutBurn.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

const BLOCK_SHARE := 0.6   ## ESTIMATE - of the punches that do not land, the share caught on the guard (the rest miss)
const WEAR_SCALE := 0.28   ## ESTIMATE - ~28 blocks a round here; 0.28 leaves an amateur yellow after round 3 (S524 render: 0.45 emptied both)
const COMBO_SHARE := 0.25  ## ESTIMATE - of the blocks, the share that are the 3rd punch on of a combination (x1.5)
const LIGHT_UPTO := 64.0   # class by the weight limit: up to 64 kg light, up to 81 kg middle, then heavy
const MIDDLE_UPTO := 81.0

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
			s["g"] = GuardWear.clamp_guard(float(s["g"]) + GuardWear.corner([], false, false), float(s["max"]))
			s["clinch"] = false
	return f["bout"]["guard"]


## Blocks from a side's landed count: thrown (BoutBurn's rule) less landed, times BLOCK_SHARE.
static func blocked_of(landed: int) -> int:
	var thrown := ceili(float(landed) / BoutBurn.LAND_RATE)
	return roundi(float(maxi(0, thrown - landed)) * BLOCK_SHARE)


## Guard points `blocks` cost the defender, the blocks split by BoutBurn.MIX.
static func wear_of(blocks: int, ctx: Dictionary) -> float:
	var total := 0.0
	for mx in BoutBurn.MIX:
		var n := float(blocks) * float(mx[1])
		var kind: String = KIND.get(str(mx[0]), "power")
		total += n * (1.0 - COMBO_SHARE) * GuardWear.wear(kind, 1, ctx) + n * COMBO_SHARE * GuardWear.wear(kind, 3, ctx)
	return total * WEAR_SCALE


## After LiveRound settles an exchange: landed [ours, theirs]; at = lv["at"] (StepWire's ropes); opp_attrs from RingDuel.opp.
## Returns {"g": [ours, theirs], "blocked": [by ours on theirs.. i.e. blocks WE made, blocks THEY made]}.
static func after(f: Dictionary, landed: Array, at: String, opp_attrs: Dictionary) -> Dictionary:
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
	var keys := ["a", "b"]
	for k in 2:
		var s: Dictionary = gs[keys[k]]
		var thrown_at := ceili(float(int(landed[1 - k])) / BoutBurn.LAND_RATE)
		var g := float(s["g"]) - wear_of(int(blocks[k]), ctxs[k]) + GuardWear.in_round(thrown_at, amateur)
		s["g"] = GuardWear.clamp_guard(g, float(s["max"]))
	return {"g": [float(gs["a"]["g"]), float(gs["b"]["g"])], "blocked": blocks,
		"share": [float(gs["a"]["g"]) / maxf(1.0, float(gs["a"]["max"])), float(gs["b"]["g"]) / maxf(1.0, float(gs["b"]["max"]))]}


## 0..1 for the HUD's guard bar ("a" ours, "b" theirs); -1 when the bout has no guard yet (old saves, before the bell).
static func share(f: Dictionary, side: String) -> float:
	var gs: Dictionary = (f.get("bout", {}) as Dictionary).get("guard", {})
	if not gs.has(side):
		return -1.0
	return float(gs[side]["g"]) / maxf(1.0, float(gs[side]["max"]))
