extends SceneTree
## S336 GrappleGrip on a real MetaHuman: a closed hand folds its fingers to the palm (the thumb's side) and not backwards,
## the fingertips come back toward the wrist; a hand on the other body closes and a hand a metre away opens; over the hold
## keyframes (mount, side control, back, guard) some hands grip and some stay open (a grip everywhere would be as wrong as
## none). The backwards curl is the control arm: the instrument must read it worse.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Grip := preload("res://scripts/grapple/GrappleGrip.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")

var failures := 0


func _initialize() -> void:
	var body := MH.load_fighter("res://assets/models/metahuman/mh_boxer_11.glb")
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var g = Grip.attach(skel, null, null)
	_check(g != null, "GrappleGrip attaches to a MetaHuman")
	if g == null:
		quit(1)
		return
	for side in Grip.SIDES:
		_check((g.hand_pose(side, 1.0) as Dictionary).size() == 15, "%s hand: %d finger bones curl" % [side, (g.hand_pose(side, 1.0) as Dictionary).size()])
		var open := _tips(skel, g, side, 0.0)
		var closed := _tips(skel, g, side, 1.0)
		var back := _tips(skel, g, side, -1.0)
		print("  %s tips to thumb base: open %.3f closed %.3f backwards %.3f | to wrist: open %.3f closed %.3f" % [side,
			open.x, closed.x, back.x, open.y, closed.y])
		_check(closed.x < back.x - 0.02, "%s fingers fold to the palm, not backwards" % side)
		_check(closed.y < open.y - 0.02, "%s fingertips come back toward the wrist" % side)
	skel.reset_bone_poses()
	var db: Array = DB.load_db()
	var mount: Array = (DB.find(db, "mount")["frames"] as Array)[0]
	var a: PackedVector3Array = mount[0]
	var b: PackedVector3Array = mount[1]
	var on := a.duplicate()
	for side in Grip.SIDES:
		on[DB.joint(side + "Hand")] = b[DB.joint("Core")] + Vector3(0, 0.13, 0)
		on[DB.joint(side + "Fingers")] = on[DB.joint(side + "Hand")]
	var far := PackedVector3Array()
	for p in b:
		far.append(p + Vector3(3.0, 0, 0))
	var t_on: Vector2 = Grip.targets(on, b)
	var t_far: Vector2 = Grip.targets(a, far)
	_check(t_on.x > 0.95 and t_on.y > 0.95, "hands on her chest close (%.2f, %.2f)" % [t_on.x, t_on.y])
	_check(t_far.x < 0.01 and t_far.y < 0.01, "hands 3 m away open (%.2f, %.2f)" % [t_far.x, t_far.y])
	var hands := 0
	var gripping := 0
	for tag in ["mount", "side_control", "back", "full_guard"]:
		for seq in DB.tagged(db, [tag]):
			for f in seq["frames"]:
				for m in 2:
					var t: Vector2 = Grip.targets(f[m], f[1 - m])
					hands += 2
					gripping += int(t.x > 0.5) + int(t.y > 0.5)
	var share := float(gripping) / maxf(1.0, hands)
	print("  holds: %d of %d hands grip (%.0f%%)" % [gripping, hands, share * 100.0])
	_check(hands > 200 and share > 0.15 and share < 0.85, "in the holds some hands grip, not all")
	print("FAIL %d" % failures if failures else "PASS grapple_grip_test")
	quit(1 if failures else 0)


## Mean fingertip (Distal) distance to the thumb's base (x) and to the wrist (y) with the hand closed by `amount`. The
## chain is walked here from the rest pose and the grip's rotations (a bone read from outside the modifiers is stale, S307).
func _tips(skel: Skeleton3D, g: Node, side: String, amount: float) -> Vector2:
	var pose: Dictionary = g.hand_pose(side, amount)
	var glob := {}
	var thumb := _fk(skel, skel.find_bone(side + "ThumbProximal"), pose, glob).origin
	var wrist := _fk(skel, skel.find_bone(side + "Hand"), pose, glob).origin
	var out := Vector2.ZERO
	for f in Grip.FINGERS:
		var i := skel.find_bone(side + f + "Distal")
		var gp := _fk(skel, i, pose, glob)
		var parent := _fk(skel, skel.get_bone_parent(i), pose, glob)
		# The tip: past the distal joint along the distal bone, as long as the middle bone.
		var rest_dir := skel.get_bone_global_rest(i).origin - skel.get_bone_global_rest(skel.get_bone_parent(i)).origin
		var dir := gp.basis * (skel.get_bone_global_rest(i).basis.inverse() * rest_dir)
		var tip := gp.origin + dir.normalized() * parent.origin.distance_to(gp.origin)
		out += Vector2(tip.distance_to(thumb), tip.distance_to(wrist))
	return out / Grip.FINGERS.size()


## A bone's pose in skeleton space: its rest, with the grip's local rotation where it sets one.
func _fk(skel: Skeleton3D, i: int, pose: Dictionary, glob: Dictionary) -> Transform3D:
	if glob.has(i):
		return glob[i]
	var parent := skel.get_bone_parent(i)
	var local := skel.get_bone_rest(i)
	if pose.has(i):
		local.basis = Basis(pose[i] as Quaternion)
	var t := local if parent < 0 else _fk(skel, parent, pose, glob) * local
	glob[i] = t
	return t


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
