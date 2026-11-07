extends SceneTree
## S399 WALK1 (operator: "you cant even make walking look normal"): the stance as PLANNED (BoxerFootwork.pose feet balls),
## as the RIG aims it (BoxerFootworkRig.last balls), and as SHOWN (the toe bones after every modifier), at rest in guard.
## Length = along her facing, width = across it, ball to ball, in metres. Prints STANCE rows per layer setting.
##   <godot.exe> --headless --path . --script res://tools/stance_probe.gd [-- glb=<res path>] [nohipfloor] [noinguard]
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const DT := 1.0 / 30.0


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


func _lw(a: Vector3, b: Vector3, yaw: float) -> Vector2:
	var left := Vector3(cos(yaw), 0.0, -sin(yaw))
	var fwd := Vector3(sin(yaw), 0.0, cos(yaw))
	var d := a - b
	return Vector2(absf(d.dot(fwd)), absf(d.dot(left)))


func _initialize() -> void:
	var glb := _arg("glb", "res://assets/models/metahuman/mh_boxer_13.glb")
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	var st := _arg("stance", "orthodox")
	stage.setup({"glb": glb, "corner": "red", "stance": st}, {"glb": glb, "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Dictionary = stage.boxers[0]
	var rig: Node = bx["rig"]
	var skel: Skeleton3D = bx["skel"]
	var order := []
	for c in skel.get_children():
		order.append("%s%s" % [c.name, "" if not (c is SkeletonModifier3D) else (" (on)" if (c as SkeletonModifier3D).active else " (off)")])
	print("STANCE modifiers in order: ", ", ".join(order))
	var off := _arg("off", "")
	for c in skel.get_children():
		if off != "" and c is SkeletonModifier3D and str(c.name).to_lower().contains(off.to_lower()):
			(c as SkeletonModifier3D).active = false
			print("STANCE switched off: ", c.name)
	var drawn := {"toes": [], "ank": []}
	skel.skeleton_updated.connect(func():   # the pose as drawn: modifiers applied (read only inside this signal)
		var x := skel.global_transform
		drawn["toes"] = []
		drawn["ank"] = []
		drawn["knee"] = []
		drawn["hip"] = []
		for i in 2:
			var ids: Array = rig._legs[i]["ids"]
			drawn["toes"].append(x * skel.get_bone_global_pose(ids[3]).origin)
			drawn["ank"].append(x * skel.get_bone_global_pose(ids[2]).origin)
			drawn["knee"].append(x * skel.get_bone_global_pose(ids[1]).origin)
			drawn["hip"].append(x * skel.get_bone_global_pose(ids[0]).origin))
	var sums := {"drawn": Vector2.ZERO, "drawn_ankle": Vector2.ZERO, "plan": Vector2.ZERO, "rig": Vector2.ZERO, "shown": Vector2.ZERO, "shown_ankle": Vector2.ZERO}
	var n := 0
	var valg := [-INF, -INF]
	var heel_min := INF
	var heel_max := -INF
	if not OS.get_cmdline_user_args().has("natural"):
		for b in stage.boxers:
			b["rig"].want = 1.0
			b["rig"].w = 1.0
	var wsum := 0.0
	var wlow := 0
	for f in 120:
		stage.aim({"phase": _arg("phase", "rest"), "who": -1, "move": "jab"})
		stage._process(DT)
		await process_frame
		if f < 30:
			continue
		var yaw := float(rig.plan.yaw)
		wsum += float(rig.w)
		wlow += 1 if float(rig.w) < 0.5 else 0
		var p: Dictionary = rig.plan.pose()
		var pb: Array = [p["feet"][0]["ball"], p["feet"][1]["ball"]]
		sums["plan"] += _lw(pb[0], pb[1], yaw)
		if rig.last.size() == 2 and rig.last[0] is Dictionary and rig.last[0].has("ball"):
			sums["rig"] += _lw(rig.last[0]["ball"], rig.last[1]["ball"], yaw)
		var xf := skel.global_transform
		var toes: Array = []
		var ank: Array = []
		for i in 2:
			var ids: Array = rig._legs[i]["ids"]
			toes.append(xf * skel.get_bone_global_pose(ids[3]).origin)
			ank.append(xf * skel.get_bone_global_pose(ids[2]).origin)
		sums["shown"] += _lw(toes[0], toes[1], yaw)
		if (drawn["toes"] as Array).size() == 2:
			sums["drawn"] += _lw(drawn["toes"][0], drawn["toes"][1], yaw)
			sums["drawn_ankle"] += _lw(drawn["ank"][0], drawn["ank"][1], yaw)
			for i in 2:   # valgus: the knee inside the hip->ankle line in her frontal plane, + = toward her midline
				var h: Vector3 = drawn["hip"][i]
				var k: Vector3 = drawn["knee"][i]
				var a: Vector3 = drawn["ank"][i]
				var lft := Vector3(cos(yaw), 0.0, -sin(yaw))
				var hx := h.dot(lft)
				var ax := a.dot(lft)
				var t := clampf((h.y - k.y) / maxf(h.y - a.y, 1e-3), 0.0, 1.0)
				var line_x := lerpf(hx, ax, t)
				var mid_x: float = ((drawn["hip"][0] as Vector3).dot(lft) + (drawn["hip"][1] as Vector3).dot(lft)) * 0.5
				var inward := (k.dot(lft) - line_x) * signf(mid_x - hx)
				valg[i] = maxf(valg[i], inward)
			var dh: float = (drawn["ank"][1] as Vector3).y - (drawn["toes"][1] as Vector3).y
			heel_min = minf(heel_min, dh)
			heel_max = maxf(heel_max, dh)
		sums["shown_ankle"] += _lw(ank[0], ank[1], yaw)
		n += 1
	var s := float((bx["node"] as Node3D).scale.x)
	print("STANCE scale=%.3f plan_target=%.3f x %.3f (BoxerFootwork STANCE_LEN/WID x scale)" % [s,
		rig.plan.STANCE_LEN * s, rig.plan.STANCE_WID * s])
	for k in ["plan", "rig", "drawn", "drawn_ankle", "shown", "shown_ankle"]:
		var v: Vector2 = sums[k] / maxf(n, 1)
		print("STANCE %-12s length=%.3f width=%.3f" % [k, v.x, v.y])
	print("STANCE rig weight mean %.2f, frames under 0.5: %d of %d" % [wsum / maxf(n, 1), wlow, n])
	print("STANCE drawn knee valgus max (m inside the hip->ankle line, + = knock-kneed): lead %.3f rear %.3f" % [valg[0], valg[1]])
	print("STANCE drawn rear ankle over rear toe (heel proxy) %.3f-%.3f m  args=%s" % [heel_min, heel_max, str(OS.get_cmdline_user_args())])
	quit(0)
