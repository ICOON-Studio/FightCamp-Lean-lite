extends SceneTree
## S416 boxers on the gym picture: one spot per owned bag, mat, rack, bench or cardio, people on those spots, pins still click.

const MAIN := preload("res://scenes/Main.tscn")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymFloorSpots := preload("res://scripts/rules/GymFloorSpots.gd")
const GymPeople := preload("res://scripts/rules/GymPeople.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Floor := preload("res://scripts/ui/GymFloorPeople.gd")

const PIC := Vector2(1672, 941)
const MARGIN := 20.0
const KINDS := ["bag", "mat", "rack", "bench", "cardio"]

var failures := 0


func _initialize() -> void:
	_rules()
	_node()
	await _page()
	print("GYM_FLOOR_PEOPLE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _rules() -> void:
	var rows: Array = GymSlots.start_rows()
	var spots: Array = GymFloorSpots.spots(rows, 0)
	var want: Array = _oracle(rows, 0)
	var n: int = spots.size()
	_check(n == want.size(), "a spot for each owned piece of those kinds (%d vs %d)" % [n, want.size()])
	_check(_id_set(spots) == _id_set(want), "the spots are those pieces")
	_check(_has(spots, "bag_floor") and _has(spots, "bag_f1") and _has(spots, "tread_1") and _has(spots, "tread_2"), "the opening floor has its mat, a bag and both treadmills")
	_check(not _has(spots, "bag_b1") and not _has(spots, "mat_blue") and not _has(spots, "scales") and not _has(spots, "timer") and not _has(spots, "ring"), "no spot for an unowned piece, the scales, the timer or the ring")
	_geometry(spots)
	_check(_at(spots, "bag_floor").is_equal_approx(Vector2(813, 668)), "bag floor feet at (813, 668), got %s" % _at(spots, "bag_floor"))
	_check(_at(spots, "bag_f1").is_equal_approx(Vector2(602, 530)), "front bag feet at (602, 530), got %s" % _at(spots, "bag_f1"))
	_check(_at(spots, "tread_1").distance_to(Vector2(1181, 731.34)) < 0.5, "treadmill feet on the belt at (1181, 731.3), got %s" % _at(spots, "tread_1"))   # S419: was (1181, 760), the floor in front
	_check(_job_of(spots, "bag_f1") == "jab_back" and _job_of(spots, "bag_floor") == "idle" and _job_of(spots, "tread_1") == "stand", "bag jabs, mat idles, cardio stands")
	rows.append({"id": "bag_b1", "day": 0})
	var early: Array = GymFloorSpots.spots(rows, 6)
	_check(early.size() == n and not _has(early, "bag_b1"), "unfitted pieces give no spot")
	var done: Array = GymFloorSpots.spots(rows, 7)
	_check(done.size() == n + 1 and _has(done, "bag_b1") and _job_of(done, "bag_b1") == "jab_back", "a bought piece gives a new spot after 7 days")
	var old: Array = GymFloorSpots.spots([], 0)
	var all_floor: Array = _oracle([], 0)
	_check(old.size() == all_floor.size() and old.size() > n, "an old save has the whole floor (%d)" % old.size())
	_check(not _has(old, "scales") and not _has(old, "timer") and not _has(old, "ring"), "an old save still skips scales, timer and ring")
	_geometry(old)
	var rack := ""
	var bench := ""
	for s in old:
		if str(s["kind"]) == "rack" and rack == "":
			rack = str(s["job"])
		if str(s["kind"]) == "bench" and bench == "":
			bench = str(s["job"])
	_check(rack == "stand" and bench == "stand", "a rack and a bench are stood at")


func _geometry(spots: Array) -> void:
	var prev := -1.0
	for s in spots:
		var at: Vector2 = s["at"]
		var id := str(s["id"])
		_check(at.x >= MARGIN and at.y >= MARGIN and at.x <= PIC.x - MARGIN and at.y <= PIC.y - MARGIN, "%s is inside the picture (%s)" % [id, at])
		_check(at.y + 0.001 >= prev, "%s is sorted by y" % id)
		prev = at.y
		var kind := str(s["kind"])
		_check(KINDS.has(kind), "%s is a floor kind (%s)" % [id, kind])
		var job := "jab_back" if kind == "bag" else ("idle" if kind == "mat" else "stand")
		_check(str(s["job"]) == job, "%s plays %s" % [id, job])
		var item: Dictionary = GymSlots.item(id)
		var x: float = float(item["x"]) + float(item["w"]) * 0.5
		var y: float = float(item["y"]) + float(item["h"]) + 6.0
		if kind == "cardio":   # S419: on the belt, not on the floor in front
			y = float(item["y"]) + float(item["h"]) * GymFloorSpots.ON_BELT
		var want := Vector2(clampf(x, MARGIN, PIC.x - MARGIN), clampf(y, MARGIN, PIC.y - MARGIN))
		_check(at.is_equal_approx(want), "%s feet match the piece (%s vs %s)" % [id, at, want])


func _node() -> void:
	var c := Career.quick_start()
	var a = Floor.new()
	var b = Floor.new()
	a.setup(c, [])
	b.setup(c, [])
	_check(_placed(a.people) == _placed(b.people) and a.people.size() >= 2, "the same floor picks the same people (%d)" % a.people.size())
	_check(_unique(a.people), "no two people on one spot")
	_check(a.people.size() == mini(GymPeople.crowd(c.members, [], c.premises).size(), a.spots.size()), "quick start places the crowd, one to a spot")
	var old := Career.new()
	var node = Floor.new()
	node.setup(old, [])
	var cap: int = GymPeople.crowd(old.members, [], old.premises).size()
	_check(old.gym_slots.is_empty() and node.spots.size() > cap, "an old save has more kit than people")
	_check(node.people.size() == cap and node.people.size() <= GymPeople.MAX_PEOPLE, "an old save does not grow the crowd past what the club allows (%d)" % node.people.size())
	_check(_unique(node.people), "an old save still puts one person on a spot")
	_check(node.mouse_filter == Control.MOUSE_FILTER_IGNORE, "the node ignores the mouse")
	a.free()
	b.free()
	node.free()


func _page() -> void:
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
	_check(hub != null, "Home shows the gym")
	if hub == null:
		main.free()
		return
	var folks := hub.find_child("GymFloorPeople", true, false)
	if folks == null:
		_check(false, "the floor has its people")
		main.free()
		return
	_floor_ok(folks, c)
	_stack(hub)
	var walkers := hub.find_child("HubFigures", true, false)
	var iso := hub.find_child("IsoGym", true, false)
	_check(walkers != null and not walkers.visible and walkers.process_mode == Node.PROCESS_MODE_DISABLED, "the old walkers stay hidden")
	_check(iso != null and not iso.visible, "the drawn gym stays hidden")
	var sig := _placed(folks.people)
	main.render()
	await process_frame
	await process_frame
	hub = main.find_child("GymHub", true, false) as Control
	folks = hub.find_child("GymFloorPeople", true, false)
	_check(folks != null and _placed(folks.people) == sig, "a redraw does not reshuffle them")
	var pin := hub.find_child("Place_fights", true, false) as Button
	_check(pin != null, "the fights pin is still there")
	if pin != null:
		pin.pressed.emit()
		await process_frame
		_check(str(main.route["area"]) == "fights", "the pin still clicks")
	main.nav({"area": "home", "tab": 0})
	await process_frame
	await process_frame
	c.cash = 100000
	_check(GymSpend.buy_slot(c, "bag_b1") == "", "buys a heavy bag")
	main.render()
	await process_frame
	await process_frame
	hub = main.find_child("GymHub", true, false) as Control
	folks = hub.find_child("GymFloorPeople", true, false)
	_check(folks != null and not _has(folks.spots, "bag_b1"), "the page gives no spot while the fitters are in")
	c.day += GymSlots.FIT_DAYS
	main.render()
	await process_frame
	await process_frame
	hub = main.find_child("GymHub", true, false) as Control
	folks = hub.find_child("GymFloorPeople", true, false)
	_check(folks != null and _has(folks.spots, "bag_b1") and _job_of(folks.spots, "bag_b1") == "jab_back", "the page shows the new bag after 7 days")
	_floor_ok(folks, c)
	main.free()


func _floor_ok(folks, c: Career) -> void:
	_check(folks != null, "the floor has its people")
	if folks == null:
		return
	var stems: Array = []
	for f in c.fighters:
		stems.append(Faces.stem(f))
	var cap: int = GymPeople.crowd(c.members, stems, c.premises).size()
	var live: Array = GymFloorSpots.spots(c.gym_slots, c.day)
	_check(folks.people.size() >= 2, "the page shows at least 2 people (%d)" % folks.people.size())
	_check(folks.people.size() == mini(cap, folks.spots.size()), "one person to a spot, up to the crowd (%d people, %d spots)" % [folks.people.size(), folks.spots.size()])
	_check(_unique(folks.people), "no two people on one spot")
	_check(_ids(folks.spots) == _ids(live), "the page reads the career's day")
	_check(folks.mouse_filter == Control.MOUSE_FILTER_IGNORE, "the node ignores the mouse")
	_check(not folks.is_processing(), "a test draws once and does not process")


func _stack(hub: Node) -> void:
	var piece := -1
	var folks := -1
	var pin := -1
	var i := 0
	for n in hub.get_children():
		var nm := str(n.name)
		if piece < 0 and nm.begins_with("Piece_"):
			piece = i
		if nm == "GymFloorPeople":
			folks = i
		if pin < 0 and nm.begins_with("Place_"):
			pin = i
		i += 1
	_check(piece >= 0 and folks > piece and pin > folks, "people stand above the pieces and below the pins")


func _oracle(rows: Array, day: int) -> Array:
	var out: Array = []
	for id in GymSlots.owned(rows, day):
		var item: Dictionary = GymSlots.item(str(id))
		if KINDS.has(str(item.get("kind", ""))):
			out.append(item)
	return out


func _at(spots: Array, id: String) -> Vector2:
	for s in spots:
		if str(s["id"]) == id:
			return s["at"]
	return Vector2(-1, -1)


func _job_of(spots: Array, id: String) -> String:
	for s in spots:
		if str(s["id"]) == id:
			return str(s["job"])
	return ""


func _has(list: Array, id: String) -> bool:
	for item in list:
		if str(item["id"]) == id:
			return true
	return false


func _id_set(list: Array) -> String:
	var ids: Array = []
	for item in list:
		ids.append(str(item["id"]))
	ids.sort()
	var text := ""
	for id in ids:
		text += str(id)
		text += ","
	return text


func _ids(list: Array) -> String:
	var text := ""
	for item in list:
		text += str(item["id"])
		text += ","
	return text


func _placed(list: Array) -> String:
	var text := ""
	for item in list:
		text += "%s@%s;" % [str(item["stem"]), str(item["id"])]
	return text


func _unique(list: Array) -> bool:
	var seen := {}
	for item in list:
		var id := str(item["id"])
		if seen.has(id):
			return false
		seen[id] = true
	return true


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
