extends RefCounted
## One boxer on the 3D ring (split from Fightstage.gd S307, 500-line rule): the MetaHuman body scaled to her height, her
## corner's kit and gloves, the clip library (mirrored for a southpaw) and the modifier stack in its order - join smoother,
## guard tuck, punch reach, head snap, elbows clear, planted feet.
## Reads the kit colours off the stage (its TRUNKS / VESTS / CORNERS / CLOTH_ROUGHNESS).
##   build(stage, spec, index) -> {node, skel, ap, gloves, js, reach, snap, feet, south, front, pos, vel, move_left}

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const ElbowClear := preload("res://scripts/fight3d/ElbowClear.gd")
const JoinSmoother := preload("res://scripts/fight3d/JoinSmoother.gd")
const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")
const HitSnap := preload("res://scripts/fight3d/HitSnap.gd")
const GuardTuck := preload("res://scripts/fight3d/GuardTuck.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const GuardLife := preload("res://scripts/fight3d/GuardLife.gd")
const FootPlant := preload("res://scripts/fight3d/FootPlant.gd")


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
	# S302: her guard tucks in toward her face and pumps (after the join smoother).
	var gt := GuardTuck.new()
	gt.name = "GuardTuck"
	gt.lead = "RightHand" if south else "LeftHand"
	if gt.setup(skel, ap, body, BeatClips.GUARD + GuardLife.FIDGETS, index * 31 + 7):
		skel.add_child(gt)
		skel.move_child(gt, (js.get_index() + 1) if js != null else 0)
	else:
		gt.free()
		gt = null
	# S302: a landed punch reaches the head past the guard (after the guard tuck, before the elbows clear).
	var pr := PunchReach.new()
	pr.name = "PunchReach"
	if pr.setup(skel, ap):
		skel.add_child(pr)
		skel.move_child(pr, (gt.get_index() + 1) if gt != null else ((js.get_index() + 1) if js != null else 0))
	else:
		pr.free()
		pr = null
	var hs := HitSnap.new()
	hs.name = "HitSnap"
	if hs.setup(skel):
		skel.add_child(hs)
		skel.move_child(hs, (pr.get_index() + 1) if pr != null else 0)
	else:
		hs.free()
		hs = null
	# S306: her planted feet stay where they stand; a foot steps when her body has moved off it.
	var fp := FootPlant.attach(skel, ap, null) if not OS.get_cmdline_user_args().has("nofeet") else null
	ap.animation_finished.connect(stage._on_finished.bind(index))
	return {"node": body, "skel": skel, "ap": ap, "gloves": gl, "js": js, "reach": pr, "snap": hs, "feet": fp, "south": south, "front": gl.front_m(),
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
