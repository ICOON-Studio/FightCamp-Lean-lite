extends SceneTree
## FIGHTPLAYER2 (S528, C434): bakes the captured boxing steps (scripts/fight3d/v2/StepClips.gd SOURCES, raw Mixamo FBX in
## a folder OUTSIDE the repo) onto our body: RkRetarget (the route the side-step walks used: the take's own floor travel
## on the hips, planted feet held), then TURNED about the hips so the take's feet stand on the guard's own line on its
## first frame (the Mixamo actor stands more side-on than the Punch PRO guard; a step that starts on another line would
## turn the feet at every join). Saved as bare bone tracks, the hips as travel from the body's rest.
## Headless: <godot> --headless --audio-driver Dummy --path . --script res://tools/step_bake.gd -- <src dir> [dry]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const RkRetarget := preload("res://scripts/fight3d/RkRetarget.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const StepClips := preload("res://scripts/fight3d/v2/StepClips.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const GUARD := "pro_idle"

var skel: Skeleton3D
var ap: AnimationPlayer


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var src := str(args[0]) if args.size() > 0 else "E:/FightCamp/packs/mixamo_steps"
	var dry := args.has("dry")
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	Orbit.strip_modifiers(skel)
	var lib: AnimationLibrary = ap.get_animation_library("")
	var prefix := str(ap.get_node(ap.root_node).get_path_to(skel))
	var rest: Vector3 = skel.get_bone_rest(skel.find_bone("Hips")).origin
	var want := _feet_line(GUARD)
	var want_face := _facing(GUARD)
	DirAccess.make_dir_recursive_absolute(StepClips.DIR)
	var done := 0
	for stem in StepClips.SOURCES:
		var name := str(StepClips.SOURCES[stem])
		var path := src.path_join(str(stem) + ".fbx")
		var anim := RkRetarget.build(skel, path, 0.0, 999.0, true)
		if anim == null:
			print("STEPBAKE MISSING ", path)
			continue
		# measure the take's own feet line on our body, then turn it onto the guard's
		var probe := anim.duplicate(true) as Animation
		for t in probe.get_track_count():
			probe.track_set_path(t, NodePath("%s:%s" % [prefix, str(probe.track_get_path(t))]))
		lib.add_animation("_probe", probe)
		var yaw := rad_to_deg(angle_difference(_feet_line("_probe"), want))
		var face_off := rad_to_deg(angle_difference(_facing("_probe"), want_face))
		lib.remove_animation("_probe")
		RkClips.turn(anim, skel, yaw)
		for t in anim.get_track_count():
			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				for k in anim.track_get_key_count(t):
					anim.track_set_key_value(t, k, (anim.track_get_key_value(t, k) as Vector3) - rest)
		anim.loop_mode = Animation.LOOP_NONE
		anim.set_meta("step_yaw_deg", yaw)
		print("STEPBAKE %s <- %s  %.2f s  turned %.1f deg (the hips then face %.1f deg off the guard's)" % [name, stem, anim.length, yaw, face_off - yaw])
		if not dry:
			var err := ResourceSaver.save(anim, StepClips.DIR + name + ".res")
			if err != OK:
				print("STEPBAKE SAVE FAIL ", name, " ", err)
				continue
		done += 1
	print("STEPBAKE DONE %d of %d -> %s" % [done, StepClips.SOURCES.size(), StepClips.DIR])
	quit(0 if done == StepClips.SOURCES.size() else 1)


## The line from the rear (right) ankle to the lead (left) ankle on the take's first frame, as an angle about +Y.
func _feet_line(clip: String) -> float:
	ap.play(clip)
	ap.seek(0.0, true)
	var w := skel.global_transform
	var d: Vector3 = w * skel.get_bone_global_pose(skel.find_bone("LeftFoot")).origin - w * skel.get_bone_global_pose(skel.find_bone("RightFoot")).origin
	return atan2(d.x, d.z)


func _facing(clip: String) -> float:
	ap.play(clip)
	ap.seek(0.0, true)
	var b := (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips"))).basis.orthonormalized()
	return atan2(b.z.x, b.z.z)
