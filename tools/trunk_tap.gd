extends SkeletonModifier3D
## S505 TRUNKTAP (debug only, `-- trunktap`): which layer of the stack moves the trunk on a head-jump frame.
## BoxerBuild.attach_taps() puts one tap before PopCapPre and one after every modifier from PopCapPre to PopCap. Each tap
## records head minus hips (skeleton space) as the stack has drawn it so far. A layer's contribution this frame is the
## offset it adds (after minus before); its share of a jump is how much that contribution CHANGED since last frame,
## along the jump. One line per boxer-frame whose final head-from-hips travel is over PRINT_M:
##   TRUNKTAP s=<film s> who=<i> clip=<anim> fin=<cm> in=<cm> <layer>=<cm> ...   (cm along the final jump; they sum to fin)

const PRINT_M := 0.04

var idx := 0
var label := ""
var who := 0
var rec: Dictionary   # shared by every tap of one skeleton
var ap: AnimationPlayer


static func attach_all(skel: Skeleton3D, anim: AnimationPlayer, boxer: int) -> void:
	var names: Array = []
	var on := false
	for c in skel.get_children():
		if c.name == "PopCapPre":
			on = true
		if on and c is SkeletonModifier3D:
			names.append(c.name)
		if c.name == "PopCap":
			break
	if names.is_empty():
		return
	var shared := {"frame": -1, "cur": {}, "prev": {}, "labels": ["in"] + names}
	var script: Script = load("res://tools/trunk_tap.gd")
	var first: Node = skel.get_node(NodePath(str(names[0])))
	var t0: SkeletonModifier3D = script.new()
	t0.setup(0, "in", boxer, shared, anim)
	skel.add_child(t0)
	skel.move_child(t0, first.get_index())
	for k in names.size():
		var after: Node = skel.get_node(NodePath(str(names[k])))
		var t: SkeletonModifier3D = script.new()
		t.setup(k + 1, str(names[k]), boxer, shared, anim)
		skel.add_child(t)
		skel.move_child(t, after.get_index() + 1)


func setup(i: int, l: String, b: int, shared: Dictionary, anim: AnimationPlayer) -> void:
	idx = i
	label = l
	who = b
	rec = shared
	ap = anim
	name = "TrunkTap_%d" % i


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	var head := skel.find_bone("Head")
	var hips := skel.find_bone("Hips")
	if head < 0 or hips < 0:
		return
	var f := Engine.get_process_frames()
	if idx == 0 and f != int(rec["frame"]):
		_report()
		rec["prev"] = rec["cur"]
		rec["cur"] = {}
		rec["frame"] = f
	(rec["cur"] as Dictionary)[idx] = skel.get_bone_global_pose(head).origin - skel.get_bone_global_pose(hips).origin


func _report() -> void:
	var cur: Dictionary = rec["cur"]
	var prev: Dictionary = rec["prev"]
	var labels: Array = rec["labels"]
	var last := labels.size() - 1
	if not (cur.has(0) and cur.has(last) and prev.has(0) and prev.has(last)):
		return
	var jump: Vector3 = (cur[last] as Vector3) - (prev[last] as Vector3)
	if jump.length() < PRINT_M:
		return
	var u := jump.normalized()
	var parts: Array = ["fin=%.1f" % (jump.length() * 100.0), "in=%.1f" % (((cur[0] as Vector3) - (prev[0] as Vector3)).dot(u) * 100.0)]
	for k in range(1, labels.size()):
		if not (cur.has(k) and cur.has(k - 1) and prev.has(k) and prev.has(k - 1)):
			continue
		var add_now: Vector3 = (cur[k] as Vector3) - (cur[k - 1] as Vector3)
		var add_was: Vector3 = (prev[k] as Vector3) - (prev[k - 1] as Vector3)
		var cm := (add_now - add_was).dot(u) * 100.0
		if absf(cm) >= 0.3:
			parts.append("%s=%.1f" % [labels[k], cm])
	print("TRUNKTAP s=%.3f who=%d clip=%s %s" % [Engine.get_frames_drawn() / 30.0, who, ap.current_animation if ap != null else "?", " ".join(parts)])
