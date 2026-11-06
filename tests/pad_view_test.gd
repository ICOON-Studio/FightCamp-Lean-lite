extends SceneTree
## PadView: SubViewport builds PadWork, combo runs, Close frees everything.

const PadView := preload("res://scripts/ui/PadView.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	await process_frame
	var f: Dictionary = main.career.fighters[0]
	var combo_id := "1-2-3"
	_check(Combos.row(combo_id).size() > 0, "known combo %s in book" % combo_id)
	PadView.open(main, f, combo_id)
	# S393: the stage builds over several frames and a bake pass before play; two frames was never enough.
	for i in 600:
		await process_frame
		var building := main.find_child("PadWork", true, false)
		if building != null and (bool(building.get("_playing")) or _pw_has_started(building)):
			break
	var pv := main.find_child("PadView", true, false)
	var pw := main.find_child("PadWork", true, false)
	var vp := main.find_child("PadViewport", true, false) as SubViewport
	_check(pv != null and pw != null and vp != null, "PadView stage built (viewport + PadWork)")
	if pw != null:
		_check(bool(pw.get("_playing")) or _pw_has_started(pw), "combo started or playing")
		_check(pw.get_parent() == vp, "PadWork lives in SubViewport")
	if vp != null:
		_check(vp.render_target_update_mode == SubViewport.UPDATE_ALWAYS, "viewport draws while open")
	# S393: the film showed an empty floor while every check above passed. Both bodies must be on the lens.
	var cam := main.find_child("PadFramingCam", true, false) as Camera3D
	_check(cam != null, "framing camera built")
	if cam != null and pw != null:
		_check(cam.is_inside_tree() and cam.current, "framing camera is the live lens")
		for who in ["boxer", "coach"]:
			var skel: Skeleton3D = (pw.get(who) as Dictionary)["skel"]
			for bone in ["Head", "LeftFoot", "RightFoot"]:
				var at: Vector3 = skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin
				_check(cam.is_position_in_frustum(at), "%s %s in frame" % [who, bone])
	var close_b := main.find_child("PadViewClose", true, false) as Button
	_check(close_b != null, "Close button present")
	if close_b != null:
		# S393: the film showed "Clos" cut off at the screen's edge.
		var screen := root.get_visible_rect()
		print("PAD_VIEW sizes screen=%s main=%s close=%s" % [screen.size, (main as Control).size, close_b.get_global_rect()])
		_check(screen.encloses(close_b.get_global_rect()), "Close is whole on the screen")
	if close_b != null:
		close_b.pressed.emit()
	await process_frame
	await process_frame
	_check(main.find_child("PadView", true, false) == null, "PadView closed")
	_check(main.find_child("PadWork", true, false) == null, "PadWork freed")
	_check(main.find_child("PadViewport", true, false) == null, "SubViewport freed")
	print("PAD_VIEW failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _pw_has_started(pw: Node) -> bool:
	var punches: Array = pw.get("_punches")
	if punches.is_empty():
		return false
	for p in punches:
		if bool((p as Dictionary).get("started", false)):
			return true
	return false


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
