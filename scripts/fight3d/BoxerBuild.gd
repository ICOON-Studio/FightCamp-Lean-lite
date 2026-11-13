extends RefCounted
## One boxer on the 3D ring (split from Fightstage.gd S307, 500-line rule): the MetaHuman body scaled to her height, her
## corner's kit and gloves, the clip library (mirrored for a southpaw) and the modifier stack in its order - join smoother,
## tired sag, footwork hips and torso, guard tuck, punch reach, head snap, elbows clear, knee track, planted feet, footwork
## legs. S316 control arms (tools/smooth_probe.gd): `noguard`, `noreach`, `nosnap`, `noglove`, `nojoin`, `noknee`, `nofeet`;
## S391 `nofootwork` (and `stepclips`) = no footwork rig (RingFeet.gd).
## Reads the kit colours off the stage (its TRUNKS / VESTS / CORNERS / CLOTH_ROUGHNESS).
##   build(stage, spec, index) -> {node, skel, ap, gloves, js, reach, snap, knee, feet, rig, south, front, pos, vel, move_left}

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const ElbowClear := preload("res://scripts/fight3d/ElbowClear.gd")
const JoinSmoother := preload("res://scripts/fight3d/JoinSmoother.gd")
const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")
const HitSnap := preload("res://scripts/fight3d/HitSnap.gd")
const GloveClear := preload("res://scripts/fight3d/GloveClear.gd")
const GuardTuck := preload("res://scripts/fight3d/GuardTuck.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const GuardLife := preload("res://scripts/fight3d/GuardLife.gd")
const KneeTrack := preload("res://scripts/fight3d/KneeTrack.gd")
const FootPlant := preload("res://scripts/fight3d/FootPlant.gd")
const GuardWeave := preload("res://scripts/fight3d/GuardWeave.gd")
const FloorClear := preload("res://scripts/fight3d/FloorClear.gd")
const TiredSag := preload("res://scripts/fight3d/TiredSag.gd")
const BoxerFootwork := preload("res://scripts/fight3d/BoxerFootwork.gd")
const BoxerFootworkRig := preload("res://scripts/fight3d/BoxerFootworkRig.gd")
const FighterLook := preload("res://scripts/rules/FighterLook.gd")
const FighterFace := preload("res://scripts/fight3d/FighterFace.gd")
const FighterLife := preload("res://scripts/fight3d/FighterLife.gd")
const RkJoinFeet := preload("res://scripts/fight3d/RkJoinFeet.gd")
const FloorStand := preload("res://scripts/fight3d/FloorStand.gd")
const FootLock := preload("res://scripts/fight3d/FootLock.gd")
const PunchWeight := preload("res://scripts/fight3d/PunchWeight.gd")


static func build(stage: Node3D, spec: Dictionary, index: int) -> Dictionary:
	var body := MH.load_fighter(str(spec["glb"]))
	stage.add_child(body)
	# S300 (operator: "the one fighter look enormous"): each body is scaled to the boxer's own height.
	body.scale = Vector3.ONE * float(spec.get("scale", 1.0))
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var corner := str(spec.get("corner", "red"))
	MH.colour_trunks(body, stage.TRUNKS[corner], stage.CLOTH_ROUGHNESS)
	FighterKit.colour_vest(body, stage.VESTS[corner], stage.CLOTH_ROUGHNESS)
	FighterKit.cloth_normals(body)
	FighterKit.dress(body, str(spec["glb"]), "boxing")
	# FIGHTERLOOK1: her own look from her data (`who`, else her body's name): skin, hair, trim, boots, scars, eyes.
	var look := {} if FighterFace.off() else FighterLook.look(spec.get("who", {"name": str(spec["glb"]).get_file().get_basename()}))
	var face := FighterFace.apply(body, skel, look, str(spec["glb"])) if not look.is_empty() else {"eyes": []}
	# Elbows outside her torso, before the twist bones read the arms.
	var ec := ElbowClear.new()
	ec.name = "ElbowClear"
	if ec.setup(skel):
		skel.add_child(ec)
		skel.move_child(ec, 0)
	else:
		ec.free()
	var gl := Gloves.new()
	gl.name = "Gloves"
	body.add_child(gl)
	gl.mount(body, stage.CORNERS[corner][0], stage.CORNERS[corner][1])
	var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(ap, skel)
	# S302: a southpaw plays every clip mirrored (lead = right).
	var south := str(spec.get("stance", "")) == "southpaw"
	if south:
		MirrorClip.mirror_library(ap, skel)
	# S301: every clip change goes through the join smoother (first in the stack, so the elbows and twists read its pose).
	var js := JoinSmoother.new()
	js.name = "JoinSmoother"
	# `nojoin` on the command line = the S300 crossfades (the control arm of the S301 joins report).
	if not OS.get_cmdline_user_args().has("nojoin") and js.setup(skel, track_bones(ap)):
		skel.add_child(js)
		skel.move_child(js, 0)
	else:
		js.free()
		js = null
	# POWER1: a punch's hips keep their captured travel (first in the stack, so the join smoother blends it like any pose).
	var pw := PunchWeight.new()
	pw.name = "PunchWeight"
	if pw.setup(skel, ap):
		skel.add_child(pw)
		skel.move_child(pw, 0)
	else:
		pw.free()
		pw = null
	# S399: a join into a captured clip keeps her feet planted through the blend (right after the join smoother).
	var jf := RkJoinFeet.new()
	jf.name = "RkJoinFeet"
	if jf.setup(skel):
		jf.js = js
		jf.ap = body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		skel.add_child(jf)
		skel.move_child(jf, (js.get_index() + 1) if js != null else 0)
	else:
		jf.free()
		jf = null
	# S323: a tired trunk folds, the head hangs, the shoulders heave (before the guard, so the gloves follow the face).
	var ts := TiredSag.new()
	ts.name = "TiredSag"
	if ts.setup(skel, ap, index * 17 + 3):
		skel.add_child(ts)
		skel.move_child(ts, (js.get_index() + 1) if js != null else 0)
	else:
		ts.free()
		ts = null
	# S391: she leans and dips off the line between punches (before the guard, so the gloves follow the face).
	var gw: GuardWeave = null
	if not OS.get_cmdline_user_args().has("noweave"):
		gw = GuardWeave.new()
		gw.name = "GuardWeave"
		if gw.setup(skel, ap, BeatClips.GUARD + GuardLife.FIDGETS + ["advance", "retreat", "strafe_left", "strafe_right"], index * 31 + 7):
			skel.add_child(gw)
			skel.move_child(gw, (ts.get_index() + 1) if ts != null else ((js.get_index() + 1) if js != null else 0))
		else:
			gw.free()
			gw = null
	# S302: her guard tucks in toward her face and pumps (after the join smoother).
	var gt := GuardTuck.new()
	gt.name = "GuardTuck"
	gt.lead = "RightHand" if south else "LeftHand"
	# S313: the step clips too (Footwork.STRIDE) - at rest they step most of the time, and the guard drops there (gap 5).
	if not OS.get_cmdline_user_args().has("noguard") and gt.setup(skel, ap, body, BeatClips.GUARD + GuardLife.FIDGETS + ["advance", "retreat", "strafe_left", "strafe_right"], index * 31 + 7):
		skel.add_child(gt)
		skel.move_child(gt, (gw.get_index() + 1) if gw != null else ((ts.get_index() + 1) if ts != null else ((js.get_index() + 1) if js != null else 0)))
	else:
		gt.free()
		gt = null
	# S302: a landed punch reaches the head past the guard (after the guard tuck, before the elbows clear).
	var pr := PunchReach.new()
	pr.name = "PunchReach"
	if not OS.get_cmdline_user_args().has("noreach") and pr.setup(skel, ap):
		skel.add_child(pr)
		skel.move_child(pr, (gt.get_index() + 1) if gt != null else ((js.get_index() + 1) if js != null else 0))
	else:
		pr.free()
		pr = null
	if pr != null and is_instance_valid(ec) and ec.is_inside_tree():
		ec.reach = pr   # S321: the landing arm keeps the reach's elbow (and so the glove's aim)
	var hs := HitSnap.new()
	hs.name = "HitSnap"
	if not OS.get_cmdline_user_args().has("nosnap") and hs.setup(skel):
		skel.add_child(hs)
		skel.move_child(hs, (pr.get_index() + 1) if pr != null else 0)
	else:
		hs.free()
		hs = null
	# S315: no glove inside the other's head (FightStage gives it the other boxer); `noglove` = the control arm.
	var gc: GloveClear = null
	if not OS.get_cmdline_user_args().has("noglove"):
		gc = GloveClear.new()
		gc.name = "GloveClear"
		if gc.setup(skel):
			gc.reach = pr   # S320: her landing glove is not pushed off the face
			skel.add_child(gc)
			skel.move_child(gc, (hs.get_index() + 1) if hs != null else 0)
		else:
			gc.free()
			gc = null
	# S370: knees point over the toes before FootPlant solves its IK (FootPlant keeps the knee's bend plane).
	var kt := KneeTrack.attach(skel, ap) if not OS.get_cmdline_user_args().has("noknee") else null
	# S306: her planted feet stay where they stand; a foot steps when her body has moved off it.
	# S314 `nostagger` = the clip's own stance spread (the control arm of gap 7).
	var fp := FootPlant.attach(skel, ap, kt, null if OS.get_cmdline_user_args().has("nostagger") else body) if not OS.get_cmdline_user_args().has("nofeet") else null
	# S376 (operator: "hands are below canvas wtf"): a boxer on the canvas lies ON it - body lifted, arms swung up out of it.
	# S391: the procedural footwork over FootPlant; its hips and torso run before the guard so the arms' IK reads them. It
	# starts let go (want 0): RingFeet.gd takes the legs when the fight or a director's walk runs.
	var rig: Node = null
	var args := OS.get_cmdline_user_args()
	if fp != null and not args.has("nofootwork") and not args.has("stepclips"):
		var plan := BoxerFootwork.new(Vector2.ZERO, 0.0, south, body.scale.x, index * 131 + 391)
		rig = BoxerFootworkRig.attach(skel, body, plan, fp, gw if gw != null else (gt if gt != null else pr))
		if rig != null:
			rig.want = 0.0
			rig.w = 0.0
	var fc := FloorClear.attach(skel) if not OS.get_cmdline_user_args().has("nofloor") else null
	# HUMANFIGHT1: a standing boxer always has a foot on the canvas and none under it - the last leg layer, on in pure takes too.
	# ... and a foot that stands on it stays where it stands, whoever has the legs (before the floor layer).
	var fl := FootLock.attach(skel, ap, stage, rig)
	var fs := FloorStand.attach(skel, ap, stage)
	# FIGHTERLOOK1: breath, weight shifts, her stance, head and eyes on a face, blinks - after the tired sag, before the guard.
	var life: Node = null
	if not look.is_empty():
		life = FighterLife.new()
		life.name = "FighterLife"
		if life.setup(skel, ap, stage, look, face["eyes"]):
			skel.add_child(life)
			var before: Node = gw if gw != null else (gt if gt != null else pr)
			if before != null:
				skel.move_child(life, before.get_index())
			if rig != null:   # S453 C369: her hips go leg to leg with this breath
				rig.get("plan").set("breath_of", life)
		else:
			life.free()
			life = null
	var tw := skel.find_child("MetaHumanTwist", false, false)
	if tw != null:
		skel.move_child(tw, skel.get_child_count() - 1)
	ap.animation_finished.connect(stage._on_finished.bind(index))
	return {"node": body, "skel": skel, "ap": ap, "gloves": gl, "joinfeet": jf, "weave": gw, "js": js, "reach": pr, "snap": hs, "gclear": gc, "tuck": gt, "sag": ts, "knee": kt, "feet": fp, "rig": rig, "floor": fc, "stand": fs, "lock": fl, "life": life, "weight": pw, "look": look, "south": south, "front": gl.front_m(),
		"pos": Vector3.ZERO, "vel": Vector3.ZERO, "move_left": 0.0,
		"aim_m": 0.0, "aim_dir": 0.0, "hold_m": 0.0}


## The bones the guard, footwork and a punch animate (every clip in the library drives the same set).
static func track_bones(ap: AnimationPlayer) -> Array:
	var out: Array = []
	for clip in ["pro_idle", "idle", "advance", "pro_left_jab", "jab"]:
		if not ap.has_animation(clip):
			continue
		var anim := ap.get_animation(clip)
		for i in anim.get_track_count():
			var bone := str(anim.track_get_path(i).get_concatenated_subnames())
			if bone != "" and not out.has(bone):
				out.append(bone)
	return out
