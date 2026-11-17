extends SkeletonModifier3D
## S510 HANDTAP (debug only, `-- handtap=RightHand` or `handtap=LeftHand`): which layer of the stack moves a wrist on a
## frame it jumps. One tap before the first modifier and one after every modifier; each records the wrist (world) as the
## stack has drawn it so far. A layer's contribution this frame is the offset it adds (after minus before); its share of a
## jump is how much that contribution CHANGED since last frame, along the jump. One line per boxer-frame whose final
## wrist travel is over PRINT_M (`handtapm=<m>`, default 0.08):
##   HANDTAP f=<frame> who=<i> clip=<anim> t=<s> fin=<cm> in=<cm> <layer>=<cm> ...   (cm along the jump; they sum to fin)

var idx := 0
var label := ""
var who := 0
var bone := "RightHand"
var print_m := 0.08
var rec: Dictionary   # shared by every tap of one skeleton
var ap: AnimationPlayer


static func attach_all(skel: Skeleton3D, anim: AnimationPlayer, boxer: int) -> void:
	var hand := ""
	var pm := 0.08
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("handtap="):
			hand = str(a).substr(8)
		elif str(a).begins_with("handtapm="):
			pm = float(str(a).substr(9))
	if hand == "":
		return
	var names: Array = []
	for c in skel.get_children():
		if c is SkeletonModifier3D:
			names.append(c.name)
	if names.is_empty():
		return
	var shared := {"frame": -1, "cur": {}, "prev": {}, "labels": ["in"] + names}
	var script: Script = load("res://tools/hand_tap.gd")
	var first: Node = skel.get_node(NodePath(str(names[0])))
	var t0: SkeletonModifier3D = script.new()
	t0.setup(0, "in", boxer, shared, anim, hand, pm)
	skel.add_child(t0)
	skel.move_child(t0, first.get_index())
	for k in names.size():
		var after: Node = skel.get_node(NodePath(str(names[k])))
		var t: SkeletonModifier3D = script.new()
		t.setup(k + 1, str(names[k]), boxer, shared, anim, hand, pm)
		skel.add_child(t)
		skel.move_child(t, after.get_index() + 1)


func setup(i: int, l: String, b: int, shared: Dictionary, anim: AnimationPlayer, hand: String, pm: float) -> void:
	idx = i
	label = l
	who = b
	rec = shared
	ap = anim
	bone = hand
	print_m = pm
	name = "HandTap_%d" % i


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	var b := skel.find_bone(bone)
	if b < 0:
		return
	var f := Engine.get_process_frames()
	if int(rec["frame"]) != f:
		rec["prev"] = (rec["cur"] as Dictionary).duplicate()
		rec["cur"] = {}
		rec["frame"] = f
	(rec["cur"] as Dictionary)[idx] = skel.global_transform * skel.get_bone_global_pose(b).origin
	var labels: Array = rec["labels"]
	if idx != labels.size() - 1:
		return
	var cur: Dictionary = rec["cur"]
	var prev: Dictionary = rec["prev"]
	if not prev.has(idx) or not cur.has(0) or not prev.has(0):
		return
	var jump: Vector3 = (cur[idx] as Vector3) - (prev[idx] as Vector3)
	if jump.length() < print_m:
		return
	var dir := jump.normalized()
	var line := "HANDTAP f=%d who=%d clip=%s t=%.3f fin=%.1f in=%.1f" % [f, who, str(ap.assigned_animation),
		ap.current_animation_position, jump.length() * 100.0, ((cur[0] as Vector3) - (prev[0] as Vector3)).dot(dir) * 100.0]
	for k in range(1, labels.size()):
		if not (cur.has(k) and cur.has(k - 1) and prev.has(k) and prev.has(k - 1)):
			continue
		var now: Vector3 = (cur[k] as Vector3) - (cur[k - 1] as Vector3)
		var was: Vector3 = (prev[k] as Vector3) - (prev[k - 1] as Vector3)
		var c := (now - was).dot(dir) * 100.0
		if absf(c) >= 0.3:
			line += " %s=%.1f" % [str(labels[k]), c]
	print(line)
