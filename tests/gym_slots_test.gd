extends SceneTree
## S415 "Yes, start small": a club opens small, buys pieces on the picture, and the floor limits its members.

const MAIN := preload("res://scenes/Main.tscn")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")

var failures := 0


func _initialize() -> void:
	_rules()
	_floor_limits_members()
	_old_save()
	await _flow()
	print("GYM_SLOTS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _rules() -> void:
	var rows: Array = GymSlots.start_rows()
	_check(GymSlots.places(rows, 0) == 22, "a new club has 22 places (%d)" % GymSlots.places(rows, 0))
	_check(GymSlots.member_room(rows, 0) == 66, "22 places hold 66 members")
	_check(GymSlots.item("cage").is_empty(), "the cage is not on sale in the boxing demo")
	var total := 0
	for s in GymSlots.all():
		total += int(s["places"])
		_check(ResourceLoader.exists("res://assets/ui/art/gym_slots/%s.png" % s["id"]), "%s has its picture" % s["id"])
		_check(int(s["x"]) >= 0 and int(s["y"]) >= 0 and int(s["x"]) + int(s["w"]) <= 1672 and int(s["y"]) + int(s["h"]) <= 941, "%s stands on the picture" % s["id"])
	var door := Rect2(700, 662, 235, 85)   # S415 operator: "these items are out of position at the entrance"
	for s in GymSlots.all():
		var at := Rect2(float(s["x"]), float(s["y"]), float(s["w"]), float(s["h"]))
		_check(not at.intersects(door), "%s stands clear of the doors (%s)" % [s["id"], at])
	_check(total == 127, "the whole gym has 127 places (%d)" % total)
	_check(GymSlots.blocked("ring", rows, 99999) == "already bought", "a piece is bought once")
	_check(GymSlots.blocked("bag_b1", rows, 100) == "$470 short of the price", "says how short (%s)" % GymSlots.blocked("bag_b1", rows, 100))
	_check(GymSlots.blocked("bag_b1", rows, 570) == "", "exactly enough buys it")
	rows.append({"id": "bag_b1", "day": 10})
	_check(GymSlots.places(rows, 16) == 22 and GymSlots.fitting(rows, 16) == ["bag_b1"], "not counted while the fitters are in")
	_check(GymSlots.places(rows, 17) == 23 and GymSlots.fitting(rows, 17).is_empty(), "counted once they are done")


func _floor_limits_members() -> void:
	var c := Career.quick_start()
	_check(c.gym_slots.size() == GymSlots.start_rows().size(), "a new career opens small")
	var big := GymSpend.GymUpgrades.premises(2)
	c.premises = 2
	c.extra_coaches = 20
	c.coach = {"name": "Test"}
	_check(int(big["cap"]) > 66 and GymSpend.member_cap(c) <= 66 + int(GymSpend.kit(c)["members"]), "the floor holds the members back (%d)" % GymSpend.member_cap(c))
	c.members = GymSpend.member_cap(c)
	_check(GymSpend.member_limit(c) == "equipment", "the limit is named as equipment (%s)" % GymSpend.member_limit(c))
	c.cash = 100000
	var before := GymSpend.member_cap(c)
	_check(GymSpend.buy_slot(c, "mat_blue") == "", "buys the mats")
	_check(c.cash == 100000 - 2340, "paid now (%d)" % c.cash)
	_check(GymSpend.member_cap(c) == before, "no more room while the fitters are in")
	c.day += GymSlots.FIT_DAYS
	_check(GymSpend.member_cap(c) == before + 54, "18 places bring 54 members (%d to %d)" % [before, GymSpend.member_cap(c)])
	_check(GymSpend.buy_slot(c, "mat_blue") != "", "the mats cannot be bought twice")


## A save from before the slots keeps its whole gym, and the rows survive a save and load.
func _old_save() -> void:
	var c := Career.new()
	_check(c.gym_slots.is_empty() and GymSlots.places(c.gym_slots, 0) == 127, "an old save has the whole gym")
	var n := Career.quick_start()
	n.gym_slots.append({"id": "bag_b2", "day": 3})
	var path := "user://gym_slots_test.sav"
	_check(SaveGame.save(n, path), "saved")
	var back: Career = SaveGame.load_career(path)
	_check(back != null and back.gym_slots.size() == n.gym_slots.size() and str(back.gym_slots[-1]["id"]) == "bag_b2", "the rows come back after a load")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _flow() -> void:
	var main := MAIN.instantiate()
	root.add_child(main)
	await process_frame
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	main.act("quick")
	await process_frame
	await process_frame
	var c: Career = main.career
	var hub := main.find_child("GymHub", true, false) as Control
	_check(hub.find_child("Piece_ring", true, false) != null, "the ring stands in a new club")
	_check(hub.find_child("Piece_mat_blue", true, false) == null, "the blue mats do not")
	var pin := hub.find_child("Place_equip", true, false) as Button
	_check(pin != null, "the weights area has a pin")
	pin.pressed.emit()
	await process_frame
	await process_frame
	hub = main.find_child("GymHub", true, false) as Control
	_check(hub.find_child("EquipBar", true, false) != null and hub.find_child("HomeShelf", true, false) == null, "Equip mode shows its strip and hides the shelf")
	_check(hub.find_child("Place_fights", true, false) == null, "the pins step aside")
	var ghosts := 0
	for n in hub.get_children():
		ghosts += 1 if str(n.name).begins_with("Ghost_") else 0
	_check(ghosts == GymSlots.all().size() - GymSlots.start_rows().size(), "every piece not owned is a ghost (%d)" % ghosts)
	var ghost := hub.find_child("Ghost_mat_blue", true, false) as Button
	_check(ghost != null and ghost.size.x > 200.0 and hub.get_global_rect().encloses(ghost.get_global_rect()), "the ghost stands on the picture")
	var cash := c.cash
	ghost.pressed.emit()
	await process_frame
	await process_frame
	_check(c.cash == cash - 2340, "the click pays for it")
	hub = main.find_child("GymHub", true, false) as Control
	_check(hub.find_child("Ghost_mat_blue", true, false) != null, "still a ghost while the fitters are in")
	c.day += GymSlots.FIT_DAYS
	main.render()
	await process_frame
	await process_frame
	hub = main.find_child("GymHub", true, false) as Control
	_check(hub.find_child("Piece_mat_blue", true, false) != null, "standing once they are done")
	(hub.find_child("EquipDone", true, false) as Button).pressed.emit()
	await process_frame
	await process_frame
	hub = main.find_child("GymHub", true, false) as Control
	_check(hub.find_child("Place_equip", true, false) != null and hub.find_child("HomeShelf", true, false) != null, "Done brings the pins back")
	main.free()


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
