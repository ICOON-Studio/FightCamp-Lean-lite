extends SceneTree
## S307 corner minute numbers, measured on the bodies the scene uses (headless):
##   - walks: each foot's backward speed while it stands (the body must move this fast so the feet do not skate)
##   - sit / crouch: the hips height (the stool's seat goes under it)
##   - hands: where each hand is at the middle of the clip, in the body's frame (props, the bottle at her mouth)
##   <godot> --headless --path . --script res://tools/corner_probe.gd -- [glb=res://...] [clips=af_a,af_b]

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const CLIPS := ["af_walk", "af_walk_carry", "af_sit_enter", "af_sit_idle", "af_sit_talk", "af_sit_exit", "af_crouch_idle",
	"af_talk", "af_interact", "af_drink", "af_pickup", "af_idle", "af_idle_foldarms", "af_nod_yes", "af_push"]
const STEPS := 60


func _initialize() -> void:
	var glbs := ["res://assets/models/metahuman/mh_boxer_11.glb", "res://assets/models/metahuman/mh_staff_coach.glb"]
	var clips: Array = CLIPS
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("glb="):
			glbs = [str(a).substr(4)]
		if str(a).begins_with("clips="):
			clips = Array(str(a).substr(6).split(","))
	await process_frame
	for glb in glbs:
		var body := MH.load_fighter(glb)
		root.add_child(body)
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		FightClips.load_into(ap, skel)
		var bx := {"ap": ap, "skel": skel, "node": body}
		print("PROBE body %s height %.3f" % [glb.get_file(), IdleMatch.pose_point(bx, "af_idle", 0.0, "Head").y])
		for c in clips:
			if not ap.has_animation(c):
				print("PROBE %s missing" % c)
				continue
			_clip(bx, str(c))
		body.queue_free()
	quit(0)


func _clip(bx: Dictionary, c: String) -> void:
	var ap: AnimationPlayer = bx["ap"]
	var length := ap.get_animation(c).length
	var hips: Array = []
	var feet := [[], []]
	for k in STEPS + 1:
		var t := length * float(k) / float(STEPS)
		hips.append(IdleMatch.pose_point(bx, c, t, "Hips"))
		feet[0].append(IdleMatch.pose_point(bx, c, t, "LeftFoot"))
		feet[1].append(IdleMatch.pose_point(bx, c, t, "RightFoot"))
	var drift: Vector3 = hips[-1] - hips[0]
	var line := "PROBE %s len %.2f hips_y %.3f/%.3f/%.3f drift %.2f,%.2f hips_z0 %.3f feet_z0 %.3f,%.3f feet_z1 %.3f,%.3f" % [c, length,
		hips[0].y, hips[STEPS / 2].y, hips[-1].y, drift.x, drift.z, hips[0].z, feet[0][0].z, feet[1][0].z, feet[0][-1].z, feet[1][-1].z]
	# Stance speed: a foot within 2 cm of its lowest point stands; its speed along the body's z then is the ground speed.
	var speeds: Array = []
	for f in 2:
		var lo := 99.0
		for p in feet[f]:
			lo = minf(lo, (p as Vector3).y)
		var sum := 0.0
		var n := 0
		for k in STEPS:
			var p0: Vector3 = feet[f][k]
			var p1: Vector3 = feet[f][k + 1]
			if p0.y < lo + 0.02 and p1.y < lo + 0.02:
				sum += (p1.z - p0.z) / (length / float(STEPS))
				n += 1
		speeds.append(sum / maxf(1.0, float(n)))
		line += " foot%d lo %.3f stance_vz %.2f (%d)" % [f, lo, speeds[f], n]
	print(line)
	var mid := length * 0.5
	var head := IdleMatch.pose_point(bx, c, mid, "Head")
	var lh := IdleMatch.pose_point(bx, c, mid, "LeftHand")
	var rh := IdleMatch.pose_point(bx, c, mid, "RightHand")
	print("PROBE %s mid head %s lhand %s rhand %s" % [c, _v(head), _v(lh), _v(rh)])


func _v(p: Vector3) -> String:
	return "(%.2f %.2f %.2f)" % [p.x, p.y, p.z]
