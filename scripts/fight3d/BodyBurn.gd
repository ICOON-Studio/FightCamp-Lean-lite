extends Node
## S322 "the body is the track" step 2 (Q-S294-38 "Build it"; Game Godot/research/BODY_TRACK_PLAN_S321.md): the bout's
## BodyLoad (per-part Burn, both boxers) fed one exchange at a time as FightView queues it, and what it shows in the 3D:
## each burning shoulder drops its own glove (GuardTuck.tired, lead / rear), burning legs shorten and slow her steps (boxer
## "legs", Footwork), a spent body folds and heaves (TiredSag, S323), a burning arm takes the snap off that hand's punches (boxer "power", HitImpact). The minute's rest refills part of it; the
## second works the most burning part (the corner works itself - Q-S294-36, Kalli SQ23).
## Off (`-- noburn`) = the control arm: no effect in the 3D.
##   attach(view) -> BodyBurn   exchange(beats, sit)   bell()   load (the body view reads it)

const BodyLoad := preload("res://scripts/rules/BodyLoad.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const BodyRates := preload("res://scripts/rules/BodyRates.gd")
const BodyTrack := preload("res://scripts/rules/BodyTrack.gd")

## An exchange is queued at its start with all its work: the body moves from the effects before it to the effects after
## it across the exchange's 30 s, eased over SHOW_S.
const SHOW_S := 1.5
const EX_SECONDS := 30.0

var view: Control
var load: Dictionary = BodyLoad.fresh()
var off := OS.get_cmdline_user_args().has("noburn")
var _tank := {"a": 100.0, "b": 100.0}   # her energy at the last exchange's start (the HUD's ENERGY)
var _shown := [_fx("a"), _fx("b")]
var _from := [_fx("a"), _fx("b")]
var _to := [_fx("a"), _fx("b")]
var _t0 := 0.0
## S323: an empty tank shows on the whole body, not only on the parts that worked: from TANK_FROM energy down to TANK_ALL
## the fold and both gloves come in fully (the HUD read ENERGY 22 on a boxer who stood straight).
const TANK_FROM := 60.0
const TANK_ALL := 15.0
const TANK_GUARD := 0.7


static func attach(v: Control) -> Node:
	var bb := new()
	bb.name = "BodyBurn"
	bb.view = v
	v.add_child(bb)
	return bb


## Exchange beats FightView just queued; her energy (tank) at its start comes from the round's profiles, her parts' burn
## rates from her stats and style (BodyRates: the gym's training shows here). after = the HUD's state at the exchange's end
## (LiveRound.state: ENERGY a/b with the calls' spend and the body shots) - the tank the body shows (S323).
func exchange(beats: Array, sit: String, after: Dictionary = {}, pace: String = "steady") -> void:
	var p: Dictionary = view.get("_profiles")
	var ctx: Dictionary = view.get("_ctx")
	var rates := {"a": BodyRates.of(p.get("a", {}).get("stats", {}), str(ctx.get("a_style", ""))),
		"b": BodyRates.of(p.get("b", {}).get("stats", {}), str(ctx.get("b_style", "")))}
	_from = [_now(0), _now(1)]
	_t0 = float(view.get("_ex_done")) * EX_SECONDS
	for side in ["a", "b"]:
		_tank[side] = float(after.get(side, p.get(side, {}).get("energy", 100.0)))
	BodyLoad.add_exchange(load, beats, {"sit": sit, "pace": {"a": pace}, "tank": {"a": float(p.get("a", {}).get("energy", 100.0)),
		"b": float(p.get("b", {}).get("energy", 100.0))}, "rates": rates})
	_to = [_fx("a"), _fx("b")]


## The minute's rest: conditioning sets the refill (Combos.refill's 0.8..1.2), hurt ribs slow it, the second works the
## most burning part.
func bell() -> void:
	var p: Dictionary = view.get("_profiles")
	var cond := {}
	var ribs := {}
	var second := {}
	var map: Dictionary = view.body.map if view.get("body") != null else {}
	for side in ["a", "b"]:
		cond[side] = 0.8 + 0.4 * clampf(RoundStyle.stat(p.get(side, {}), "conditioning"), 0.0, 100.0) / 100.0
		ribs[side] = not map.is_empty() and minf(BodyMap.value(map, side, "left_ribs"), BodyMap.value(map, side, "right_ribs")) <= BodyMap.HURT
		second[side] = BodyLoad.worst_part(load, side)
	BodyLoad.rest(load, cond, ribs, second)
	_to = [_fx("a"), _fx("b")]
	_from = _to.duplicate(true)


func _fx(side: String) -> Dictionary:
	if off:
		return _with_burn(side, {"lead": 0.0, "rear": 0.0, "legs": 1.0, "power_lead": 1.0, "power_rear": 1.0, "sag": 0.0})
	var empty := _empty(side)
	return _with_burn(side, {"lead": maxf(BodyLoad.part_effect(load, side, "lead_shoulder"), TANK_GUARD * empty) * BodyLoad.GUARD_DROP_MAX,
		"rear": maxf(BodyLoad.part_effect(load, side, "rear_shoulder"), TANK_GUARD * empty) * BodyLoad.GUARD_DROP_MAX,
		"sag": _sag(side),
		"legs": BodyLoad.step_scale(load, side),
		"power_lead": lerpf(1.0, BodyLoad.POWER_MIN, BodyLoad.part_effect(load, side, "lead_arm")),
		"power_rear": lerpf(1.0, BodyLoad.POWER_MIN, BodyLoad.part_effect(load, side, "rear_arm"))})


## S323 the body view: each part's Burn rides along with the effects (eased across the exchange the same way), "b_<part>".
func _with_burn(side: String, fx: Dictionary) -> Dictionary:
	for part in BodyLoad.PARTS:
		fx["b_" + part] = BodyLoad.burn(load, side, part)
	return fx


## S323 TiredSag (fold, hanging head, heaving shoulders): her most spent of trunk, legs, the two shoulders together and
## her tank.
func _sag(side: String) -> float:
	var sh := (BodyLoad.part_effect(load, side, "lead_shoulder") + BodyLoad.part_effect(load, side, "rear_shoulder")) / 2.0
	return maxf(maxf(sh, _empty(side)), maxf(BodyLoad.part_effect(load, side, "core"), BodyLoad.part_effect(load, side, "legs")))


## 0..1: how empty her tank is (0 at TANK_FROM energy and above, 1 at TANK_ALL and below).
func _empty(side: String) -> float:
	return clampf((TANK_FROM - float(_tank[side])) / (TANK_FROM - TANK_ALL), 0.0, 1.0)


## Where the body is between _from and _to right now (before the next exchange is added).
func _now(i: int) -> Dictionary:
	var f := clampf((float(view.get("t")) - _t0) / EX_SECONDS, 0.0, 1.0)
	var out := {}
	for key in _to[i]:
		out[key] = lerpf(float(_from[i][key]), float(_to[i][key]), f)
	return out


func _process(delta: float) -> void:
	var stage: Node = view.get("stage")
	if stage == null or stage.boxers.size() < 2:
		return
	var k := 1.0 - exp(-delta / SHOW_S)
	for i in 2:
		var s: Dictionary = _shown[i]
		var want := _now(i)
		for key in want:
			s[key] = lerpf(float(s[key]), float(want[key]), k)
		var bx: Dictionary = stage.boxers[i]
		if bx.get("tuck") != null:
			bx["tuck"].tired = {"lead": float(s["lead"]), "rear": float(s["rear"])}
		if bx.get("sag") != null:
			bx["sag"].tired = float(s["sag"])
		bx["legs"] = float(s["legs"])
		bx["power"] = {"lead": float(s["power_lead"]), "rear": float(s["power_rear"])}
	_paint_view(stage, delta)


## S323 body view (plan step 3): the side panels' figures show each part's Burn on her own body, a few times a second.
var _paint_t := 0.0
const PAINT_S := 0.25


func _paint_view(stage: Node, delta: float) -> void:
	_paint_t -= delta
	var live: Node = view.get("body")
	if _paint_t > 0.0 or live == null:
		return
	_paint_t = PAINT_S
	var figs: Array = live.get("figures")
	for i in mini(2, figs.size()):
		var south := bool(stage.boxers[i].get("south", false))
		var burns := {}
		for part in BodyLoad.PARTS:
			burns[BodyTrack.body_place(part, south)] = float(_shown[i]["b_" + part])
		if figs[i].has_method("set_track"):
			figs[i].set_track(burns)
