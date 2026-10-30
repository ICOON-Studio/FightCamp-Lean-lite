extends SceneTree
## S318: where each glove sits in the baked two-person clinch (clinch_att / clinch_vic), placed as Clinch.gd plays them
## (PAIR_GAP_M apart, facing). Per sample over PAIR_SPAN: each hand's height over its own head, and the nearest bone of
## the other body it rests on. A glove above its own head = the "hand over the top" (S317 still, 14 s).
##   godot --headless --audio-driver Dummy --path . --script res://tools/clinch_probe.gd

const MH := preload("res://scripts/fight3d/MHRig.gd")
const CL := preload("res://scripts/fight3d/Clinch.gd")
const BODIES := {"Att": "res://assets/models/metahuman/mh_boxer_11.glb", "Vic": "res://assets/models/metahuman/mh_boxer_10.glb"}
const CLIPS := {"Att": "res://assets/anim/baked/clinch_att.res", "Vic": "res://assets/anim/baked/clinch_vic.res"}
const NEAR := ["Head", "Neck", "Chest", "Spine", "LeftShoulder", "RightShoulder", "LeftUpperArm", "RightUpperArm",
	"LeftLowerArm", "RightLowerArm"]


func _initialize() -> void:
	var skel := {}
	var players := {}
	for role in ["Att", "Vic"]:
		var body: Node3D = MH.load_fighter(BODIES[role])
		root.add_child(body)
		var sk: Skeleton3D = body.find_children("*", "Skeleton3D", true, false)[0]
		body.position = Vector3(0, 0, -CL.PAIR_GAP_M * 0.5) if role == "Att" else Vector3(0, 0, CL.PAIR_GAP_M * 0.5)
		body.rotation.y = 0.0 if role == "Att" else PI
		var p := AnimationPlayer.new()
		body.add_child(p)
		var anim: Animation = load(CLIPS[role]).duplicate(true)
		var prefix := str(p.get_node(p.root_node).get_path_to(sk))
		var hips := sk.find_bone("Hips")
		for t in anim.get_track_count():
			anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				for kk in anim.track_get_key_count(t):
					anim.track_set_key_value(t, kk, sk.get_bone_rest(hips).origin + (anim.track_get_key_value(t, kk) as Vector3))
		var lib := AnimationLibrary.new()
		lib.add_animation("pair", anim)
		p.add_animation_library("", lib)
		p.play("pair")
		p.pause()
		skel[role] = sk
		players[role] = p
	await process_frame
	var over := {}
	var x: float = CL.PAIR_SPAN.x
	while x <= CL.PAIR_SPAN.y + 0.001:
		for role in players:
			(players[role] as AnimationPlayer).seek(x, true)
		var line := "t=%.1f" % x
		for role in ["Att", "Vic"]:
			var other: String = "Vic" if role == "Att" else "Att"
			var head := _at(skel[role], "Head")
			for side in ["Left", "Right"]:
				var h := _at(skel[role], side + "Hand")
				var best := ""
				var bd := 99.0
				for b in NEAR:
					var d := h.distance_to(_at(skel[other], b))
					if d < bd:
						bd = d
						best = b
				var up := h.y - head.y
				if up > 0.0:
					over[role + side] = int(over.get(role + side, 0)) + 1
				line += "  %s%s up%+.2f on %s %.2f" % [role, side[0], up, best, bd]
		# S318: where Clinch.gd's two IK hands go (same formulas), their height under the own head and the reach needed.
		var tg := {"Att": _overhook(skel["Vic"], "Right"), "Vic": _elbow(skel["Att"], "Right")}
		for role in tg:
			var arm: float = _at(skel[role], "LeftUpperArm").distance_to(_at(skel[role], "LeftLowerArm")) \
				+ _at(skel[role], "LeftLowerArm").distance_to(_at(skel[role], "LeftHand"))
			var need: float = _at(skel[role], "LeftUpperArm").distance_to(tg[role])
			line += "  IK %sL up%+.2f reach %.2f/%.2f" % [role, (tg[role] as Vector3).y - _at(skel[role], "Head").y, need, arm]
		print(line)
		x += 0.2
	print("CLINCH_PROBE above-head samples: ", over)
	quit(0)


func _overhook(sk: Skeleton3D, side: String) -> Vector3:
	var f := _body_fwd(sk)
	var left := Vector3.UP.cross(f).normalized()
	var out := left if side == "Left" else -left
	return _at(sk, side + "LowerArm") + out * CL.OVERHOOK_OUT_M - f * CL.OVERHOOK_BACK_M + Vector3.UP * CL.OVERHOOK_UP_M


func _elbow(sk: Skeleton3D, side: String) -> Vector3:
	var f := _body_fwd(sk)
	var left := Vector3.UP.cross(f).normalized()
	var out := left if side == "Left" else -left
	return _at(sk, side + "LowerArm") + out * CL.ELBOW_OUT_M + Vector3.DOWN * CL.ELBOW_DOWN_M


func _flank(sk: Skeleton3D, sgn: float) -> Vector3:
	var f := _body_fwd(sk)
	var left := Vector3.UP.cross(f).normalized()
	return _at(sk, "Spine") + left * CL.FLANK_M * sgn - f * 0.04 + Vector3.UP * 0.08


## The fighter root's +Z (Clinch._fwd reads the stage's body node the same way).
func _body_fwd(sk: Skeleton3D) -> Vector3:
	var n: Node = sk
	while n.get_parent() != root:
		n = n.get_parent()
	return (n as Node3D).global_transform.basis.z.normalized()


func _at(sk: Skeleton3D, bone: String) -> Vector3:
	return sk.global_transform * sk.get_bone_global_pose(sk.find_bone(bone)).origin
