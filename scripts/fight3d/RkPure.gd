extends RefCounted
## S399 ROKOKO2 - "mocap plays pure" (old repo S272 rule, operator S272 on the Rokoko renders vs the fight: what he approved
## was the take itself): while a captured Rokoko clip (RkClips, rk_*) plays, every synthetic layer on the skeleton fades
## out over FADE_S (a quintic, as the old alive-breath fade) and fades back in after it. Done through each modifier's
## `influence` (Skeleton3D blends a modifier's output by it), so no layer's own file changes.
##   faded: TiredSag, GuardWeave, GuardTuck, PunchReach, HitSnap, GloveClear, ElbowClear, KneeTrack, FootPlant,
##          BoxerFootworkRig + BoxerFootworkUpper, FloorClear, FighterLife (and any modifier added later)
##   kept (the old rule kept them): MetaHumanTwist - the MetaHuman's skinning helpers (twist bones follow the hand / foot
##          roll; the old renders had it); JoinSmoother - the join itself (the old route's crossfade), it adds nothing
##          once the join is over (dead blending, 0.3-0.45 s). The fight still places the root and keeps the pair spacing.
##   the one exception inside a clip: while the footwork rig is mid-step (her place moved and the feet are carrying her
##          there, RingFeet), the LEG layers come back, so a travelling body is never a skating one; the upper body stays
##          the take's.
## FightStage._process calls tick() for each boxer every frame; bx["rk_pure"] = 0..1 (1 = the take alone).

const RkClips := preload("res://scripts/fight3d/RkClips.gd")

const FADE_S := 0.15
const KEEP := ["MetaHumanTwist", "JoinSmoother"]
const LEGS := ["BoxerFootworkRig", "BoxerFootworkUpper", "FootPlant", "KneeTrack", "FloorClear"]


static func tick(bx: Dictionary, delta: float, stepping: bool) -> void:
	var ap: AnimationPlayer = bx["ap"]
	var skel: Skeleton3D = bx["skel"]
	var rk := RkClips.on() and RkClips.is_rk(str(ap.current_animation))
	var p := _ease(bx, "rk_p", 1.0 if rk else 0.0, delta)
	var legs := _ease(bx, "rk_legs", 1.0 if rk and not stepping else 0.0, delta)
	bx["rk_pure"] = legs if rk else p
	var up := _smooth(p)
	var lo := _smooth(legs)
	# Outside a captured clip, once faded back, the stack is left alone (a tool that switched layers off keeps them off).
	var idle := p <= 0.0 and legs <= 0.0
	if idle and bool(bx.get("rk_idle", true)):
		return
	bx["rk_idle"] = idle
	for c in skel.get_children():
		if not (c is SkeletonModifier3D) or KEEP.has(str(c.name)):
			continue
		var f := 1.0 - (lo if LEGS.has(str(c.name)) else up)
		(c as SkeletonModifier3D).influence = f
		(c as SkeletonModifier3D).active = f > 0.0


static func _ease(bx: Dictionary, key: String, want: float, delta: float) -> float:
	var v := float(bx.get(key, 0.0))
	v = move_toward(v, want, delta / FADE_S) if delta > 0.0 else want
	bx[key] = v
	return v


static func _smooth(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return x * x * x * (x * (x * 6.0 - 15.0) + 10.0)
