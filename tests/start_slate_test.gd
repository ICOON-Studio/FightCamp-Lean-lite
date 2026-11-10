extends SceneTree
## S418 the new-game screens and the reception interview on the wood and slate look. Cream cards are gone:
## framed slates, chalk words on the dark surface, the photograph at reception staying a light print.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/start_slate_test.gd

const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const GymPlan := preload("res://scripts/rules/GymPlan.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	main.act("newcareer")
	await _settle(4)
	var step1 := main.find_child("Create", true, false) as Control
	await _walk(step1, "new game, you")
	var coaches: Array = []
	for cd in HeadCoach.CARDS:
		coaches.append("Coach_" + str(cd["id"]))
	_named(coaches, "coach card")
	main.act("cstep", "1")
	await _settle(4)
	var step2 := main.find_child("Create", true, false) as Control
	await _walk(step2, "new game, your club")
	var plans: Array = []
	for p in GymPlan.load_all():
		plans.append("Plan_" + str(p["id"]))
	_named(plans, "building card")
	var starts: Array = []
	for st in ClubStart.CARDS:
		starts.append("Start_" + str(st["id"]))
	_named(starts, "start card")
	# A fresh game, then the reception card (tools/layout_snapshot.gd plays these same steps).
	main.act("quick")
	await _settle(4)
	main.act("interview")
	await _settle(4)
	var card := main.find_child("WalkInCard", true, false) as Control
	await _walk(card, "the reception card")
	_named(["Sign"], "sign button")
	var pid := ""
	if main.career != null and not (main.career.prospects as Array).is_empty():
		pid = str((main.career.prospects[0] as Dictionary).get("id", ""))
	_check(pid != "", "a prospect is on the books to trial")
	if pid != "":
		main.act("trial", pid)
		await _settle(4)
		var trial := main.modal_node() as Control
		await _walk(trial, "the trial card")
	_done()


func _walk(page: Control, where: String) -> void:
	_check(page != null, where + " is on screen")
	if page == null:
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(page)
	await _settle(3)
	for fault in SlateWalk.faults(page):
		_check(false, where + ": " + str(fault))
	var edge := _max_end(page)
	print("START_SLATE %s ends at x %.0f (line 1920), y %.0f" % [where, edge.x, edge.y])
	_check(edge.x <= 1920.0, where + " stays inside x 1920 (%.0f)" % edge.x)
	_check(edge.y <= 1080.0, where + " stays inside y 1080 (%.0f)" % edge.y)


func _named(names: Array, kind: String) -> void:
	_check(names.size() > 0, "there is a %s to find" % kind)
	for n in names:
		var node := main.find_child(str(n), true, false)
		_check(node != null, "the %s %s is still there" % [kind, str(n)])


func _max_end(n: Control) -> Vector2:
	var e := Vector2.ZERO
	if n.is_visible_in_tree() and n.size.x > 1.0:
		var r := n.get_global_rect()
		e = Vector2(r.end.x, r.end.y)
	for c in n.get_children():
		if c is Control:
			var sub := _max_end(c as Control)
			e = Vector2(maxf(e.x, sub.x), maxf(e.y, sub.y))
	return e


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _done() -> void:
	print("START_SLATE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
