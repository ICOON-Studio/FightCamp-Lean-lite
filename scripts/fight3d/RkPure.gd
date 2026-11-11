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
##   HUMANFIGHT1 the second exception: the fight CARRIES her place under a captured punch or guard (PunchRange.close_in:
##          a landed jab from out of range moved her 0.65 m in a quarter second at 3 m/s, plus the reach's lunge - with no
##          leg layer both feet were dragged along the canvas, 0.7-0.9 m of slide for every second of rk_jab / rk_cross,
##          tools/human_fight_film.gd). The rig never steps in a captured clip (RingFeet lets go there), so the first
##          exception never fired for these. While her place is carried, and CARRY_HOLD_S after (FootPlant's step must
##          land), the leg layers are back: FootPlant holds each foot and steps it after the body. A step clip (rk_loc_*)
##          is not a carry: its own hips move her.
##   HUMANFIGHT1 the CONTACT layers stay on too (two blind critics, 3/10: "gloves go past or through heads and stay
##          there", "nobody feels a punch"): PunchReach aims a landed glove at its target, GloveClear and ElbowClear keep a
##          glove out of the other's head and an elbow out of her own ribs, HitSnap moves a head that is hit. They act
##          only at a contact - between contacts the take is untouched - and switched off with the rest a captured jab
##          went through the head it hit and the head did not move.
## FightStage._process calls tick() for each boxer every frame; bx["rk_pure"] = 0..1 (1 = the take alone).

const RkClips := preload("res://scripts/fight3d/RkClips.gd")

const FADE_S := 0.15
const LEGS_BACK_S := 0.05    # the leg layers come back this fast (a carry is over in a quarter second)
const CARRY_V := 0.3         # her place moving this fast (m/s) under a captured clip is a carry
const CARRY_HOLD_S := 0.4    # the legs stay this long after it (FootPlant.SWING_S 0.26 + its landing)
## PoseRecorder is no layer: it keeps what was shown, and KnockdownReplay cuts in on its clock. Faded out with the rest, the
## standing boxer's recorder stopped in his captured guard, no replay began and the count waited on it for ever (the KO hang).
const KEEP := ["MetaHumanTwist", "JoinSmoother", "RkJoinFeet", "PoseRecorder", "FloorStand", "FootLock",
	"PunchReach", "GloveClear", "ElbowClear", "HitSnap"]   # RkJoinFeet: the feet through a join (acts only then); FloorStand / FootLock: a foot on the canvas, and still on it, always (HUMANFIGHT1)
const LEGS := ["BoxerFootworkRig", "BoxerFootworkUpper", "FootPlant", "KneeTrack", "FloorClear"]


static func tick(bx: Dictionary, delta: float, stepping: bool) -> void:
	var ap: AnimationPlayer = bx["ap"]
	var skel: Skeleton3D = bx["skel"]
	var clip := str(ap.current_animation)
	var rk := RkClips.on() and RkClips.is_rk(clip)
	var carried := float(bx.get("move_left", 0.0)) > 0.0 and (bx.get("vel", Vector3.ZERO) as Vector3).length() > CARRY_V 		and not clip.begins_with("rk_loc_") and not OS.get_cmdline_user_args().has("nocarrylegs")
	bx["rk_carry"] = CARRY_HOLD_S if carried else maxf(0.0, float(bx.get("rk_carry", 0.0)) - delta)
	var p := _ease(bx, "rk_p", 1.0 if rk else 0.0, delta)
	var legs_want := 1.0 if rk and not stepping and float(bx["rk_carry"]) <= 0.0 else 0.0
	if OS.get_cmdline_user_args().has("legson") and not clip.begins_with("rk_loc_"):
		legs_want = 0.0   # probe arm: the leg layers stay on in every captured clip but the step clips
	var legs := _ease(bx, "rk_legs", legs_want, delta, LEGS_BACK_S if legs_want <= 0.0 else FADE_S)
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


static func _ease(bx: Dictionary, key: String, want: float, delta: float, over_s: float = FADE_S) -> float:
	var v := float(bx.get(key, 0.0))
	v = move_toward(v, want, delta / over_s) if delta > 0.0 else want
	bx[key] = v
	return v


static func _smooth(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return x * x * x * (x * (x * 6.0 - 15.0) + 10.0)
