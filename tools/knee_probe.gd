extends SceneTree
## S370 KNEE probe (operator: "the knee joints do not feel right in the clips i watch on the board"). Loads the board's boxer
## body (mh_boxer_10, as tools/clip_orbit.gd) with every clip FightClips loads, and at 30 fps reads both legs off the
## skeleton - the clip itself, none of the fight's layers (the board's previews show the same). Per leg and frame:
##   flex   - the knee's bend (0 = straight)
##   track  - while flex > BENT_DEG, the angle between where the knee points (its offset from the hip-ankle line, flat on
##            the floor) and where the foot points (ankle -> toes, flat): 0 = knee over the toes; + = knee caves in
##            (valgus), - = knee bows out; |track| > 90 = the knee bends backwards
##   twist  - the shin's turn about its own length against the thigh, from the rest pose (a hinge turns ~0-20 deg)
## Clips with the boxer down (knockout / countdown / fall: the legs on the canvas, no foot to track) print but never gate.
## `layer=1` runs scripts/fight3d/KneeTrack.gd's `static func align(skel: Skeleton3D, weight: float) -> void` (the knee
## layer, TASK_KNEETRACK1) on every frame after the clip, as the fight's modifier stack would; missing = FAIL.
## Runs headless (bones only, no picture):
##   <godot.exe> --headless --path . --audio-driver Dummy --script res://tools/knee_probe.gd [-- ids=a,b glb=mh_boxer_10 layer=1]
## Prints KNEE <clip> lines, then KNEE_SUMMARY with PASS/FAIL against the bars below.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")

## The bars. Never loosen one to make a line pass.
const BENT_DEG := 20.0          # below this bend the knee's direction is noise
const TRACK_MAX_DEG := 35.0     # knee within this of the toes' line
const TWIST_MAX_DEG := 25.0     # shin turn against the thigh
const SHARE_MAX := 0.05         # share of a clip's bent frames allowed past a bar
const LEGS := [["L", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes", "RightUpperLeg"],
	["R", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes", "LeftUpperLeg"]]
const FPS := 30.0
const DOWN := ["knockout", "countdown", "fall"]
const LAYER_PATH := "res://scripts/fight3d/KneeTrack.gd"

var _layer: GDScript = null


func _initialize() -> void:
	var ids: Array = []
	var who := "mh_boxer_10"
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("ids="):
			ids = Array(s.substr(4).split(",", false))
		elif s.begins_with("glb="):
			who = s.substr(4)
		elif s == "layer=1":
			if not ResourceLoader.exists(LAYER_PATH):
				print("KNEE_SUMMARY layer=1 but %s is missing -> FAIL" % LAYER_PATH)
				quit(1)
				return
			_layer = load(LAYER_PATH)
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % who)
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(ap, skel)
	await process_frame   # the player binds its tracks on the first frame; a seek before it moves nothing
	var legs: Array = []
	for leg in LEGS:
		var b: Array = [leg[0]]
		for i in range(1, 6):
			b.append(skel.find_bone(str(leg[i])))
		legs.append(b)
	var names: Array = ids if not ids.is_empty() else Array(ap.get_animation_list())
	names.sort()
	var fails: Array = []
	var worst_all: Array = []
	var clips := 0
	for n in names:
		var name := str(n)
		if not ap.has_animation(name) or name == "RESET":
			continue
		clips += 1
		var r := _clip(ap, skel, legs, name)
		print("KNEE %s frames=%d bent=%d track_bad=%.2f twist_bad=%.2f backward=%d worst_track=%.0f@%.2fs%s worst_twist=%.0f@%.2fs%s max_flex=%.0f -> %s" % [
			name, r["frames"], r["bent"], r["track_share"], r["twist_share"], r["backward"], r["track"], r["track_t"],
			r["track_leg"], r["twist"], r["twist_t"], r["twist_leg"], r["max_flex"], "PASS" if r["pass"] else "FAIL"])
		if DOWN.any(func(w: String) -> bool: return name.contains(w)):
			continue   # printed, never gated
		if not r["pass"]:
			fails.append(name)
		worst_all.append([maxf(r["track_share"], r["twist_share"]), name])
	worst_all.sort()
	worst_all.reverse()
	print("KNEE_WORST ", worst_all.slice(0, 15).map(func(p: Array) -> String: return "%s %.2f" % [p[1], p[0]]))
	print("KNEE_SUMMARY clips=%d fail=%d layer=%s -> %s" % [clips, fails.size(), "on" if _layer != null else "off",
		"PASS" if fails.is_empty() else "FAIL"])
	print("KNEE_FAILS ", fails)
	quit(0)


func _clip(ap: AnimationPlayer, skel: Skeleton3D, legs: Array, name: String) -> Dictionary:
	var anim := ap.get_animation(name)
	var frames := int(anim.length * FPS) + 1
	ap.play(name)
	var r := {"frames": frames, "bent": 0, "track_n": 0, "twist_n": 0, "backward": 0, "track": 0.0, "track_t": 0.0,
		"track_leg": "", "twist": 0.0, "twist_t": 0.0, "twist_leg": "", "max_flex": 0.0}
	for f in frames:
		var t := minf(f / FPS, anim.length)
		ap.seek(t, true)
		if _layer != null:
			_layer.call("align", skel, 1.0)
		for leg in legs:
			var m := _leg(skel, leg)
			r["max_flex"] = maxf(r["max_flex"], m["flex"])
			if m["flex"] < BENT_DEG:
				continue
			r["bent"] += 1
			var tr: float = m["track"]
			if absf(tr) > 90.0:
				r["backward"] += 1
			if absf(tr) > TRACK_MAX_DEG:
				r["track_n"] += 1
			if absf(tr) > absf(r["track"]):
				r["track"] = tr
				r["track_t"] = t
				r["track_leg"] = leg[0]
			var tw: float = m["twist"]
			if absf(tw) > TWIST_MAX_DEG:
				r["twist_n"] += 1
			if absf(tw) > absf(r["twist"]):
				r["twist"] = tw
				r["twist_t"] = t
				r["twist_leg"] = leg[0]
	ap.stop()
	var bent := maxi(int(r["bent"]), 1)
	r["track_share"] = float(r["track_n"]) / bent
	r["twist_share"] = float(r["twist_n"]) / bent
	r["pass"] = r["track_share"] <= SHARE_MAX and r["twist_share"] <= SHARE_MAX and int(r["backward"]) == 0
	return r


## leg = [side, upper, lower, foot, toes, other hip] bone indices -> {flex, track, twist}
func _leg(skel: Skeleton3D, leg: Array) -> Dictionary:
	var gu := skel.get_bone_global_pose(leg[1])
	var gl := skel.get_bone_global_pose(leg[2])
	var gf := skel.get_bone_global_pose(leg[3])
	var gt := skel.get_bone_global_pose(leg[4])
	var go := skel.get_bone_global_pose(leg[5])
	var hip := gu.origin
	var knee := gl.origin
	var ankle := gf.origin
	var flex := 180.0 - rad_to_deg((hip - knee).angle_to(ankle - knee))
	# Where the knee points: its offset from the hip-ankle line, flat on the floor.
	var axis := (ankle - hip).normalized()
	var off := (knee - hip) - axis * (knee - hip).dot(axis)
	var foot := gt.origin - ankle
	foot.y = 0.0
	off.y = 0.0
	var track := 0.0
	if foot.length() > 0.01 and off.length() > 0.005:
		var fwd := foot.normalized()
		var side := Vector3.UP.cross(fwd)
		var medial := go.origin - hip
		if side.dot(medial) < 0.0:
			side = -side
		track = rad_to_deg(atan2(off.dot(side), off.dot(fwd)))
	# The shin's turn about its length against the thigh, measured from the rest pose.
	var ru := _rest_global(skel, leg[1])
	var rl := _rest_global(skel, leg[2])
	var rest_rel := (ru.basis.inverse() * rl.basis).get_rotation_quaternion()
	var now_rel := (gu.basis.inverse() * gl.basis).get_rotation_quaternion()
	var delta := rest_rel.inverse() * now_rel
	var along := (rl.basis.inverse() * (_rest_global(skel, leg[3]).origin - rl.origin)).normalized()
	var v := Vector3(delta.x, delta.y, delta.z)
	var p := along * v.dot(along)
	var tw := Quaternion(p.x, p.y, p.z, delta.w)
	var twist := 0.0
	if tw.length() > 0.0001:
		tw = tw.normalized()
		twist = rad_to_deg(2.0 * acos(clampf(absf(tw.w), 0.0, 1.0))) * signf(Vector3(tw.x, tw.y, tw.z).dot(along) * tw.w)
	return {"flex": flex, "track": track, "twist": twist}


var _rest_cache := {}


func _rest_global(skel: Skeleton3D, bone: int) -> Transform3D:
	if not _rest_cache.has(bone):
		_rest_cache[bone] = skel.get_bone_global_rest(bone)
	return _rest_cache[bone]
