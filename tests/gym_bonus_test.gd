extends SceneTree
## S409 each building's edge is real: the rule it promises moves by about what the card says, and nothing else moves.

const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const GymPlan := preload("res://scripts/rules/GymPlan.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const MAIN := preload("res://scenes/Main.tscn")

var failures := 0


func _initialize() -> void:
	_factors()
	_members()
	_career_hooks()
	await _setup_card()
	print("GYM_BONUS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _factors() -> void:
	var ids := {"front_of_house": [1.05, 1.0, 1.0, 1.0], "two_rings": [1.0, 1.05, 1.0, 1.0], "bag_wall": [1.0, 1.0, 1.03, 1.0], "conditioning": [1.0, 1.0, 1.0, 0.9]}
	for id in ids:
		var want: Array = ids[id]
		_near(GymBonus.members(id), want[0], id + " members")
		_near(GymBonus.show(id), want[1], id + " show")
		_near(GymBonus.training(id, "power"), want[2], id + " power training")
		_near(GymBonus.days_out(id), want[3], id + " days out")
	_near(GymBonus.training("bag_wall", "speed"), 1.0, "the bag wall does not train speed")
	_check(str(GymBonus.plan("")["id"]) == "front_of_house", "no choice is the first building")
	_check(str(GymBonus.plan("nonsense")["id"]) == "front_of_house", "an unknown id is the first building")


func _members() -> void:
	var plain: Dictionary = Membership.settle_week(100, 60, 500)
	var more: Dictionary = Membership.settle_week(100, 60, 500, "standard", 1.05)
	_check(int(more["target"]) > int(plain["target"]), "the building draws more members (%d to %d)" % [plain["target"], more["target"]])
	_check(absf(float(more["target"]) / float(plain["target"]) - 1.05) < 0.02, "about 5%% more (%d to %d)" % [plain["target"], more["target"]])
	var capped: Dictionary = Membership.settle_week(100, 60, int(plain["target"]), "standard", 1.05)
	_check(int(capped["target"]) == int(plain["target"]), "the room's cap still holds")


func _career_hooks() -> void:
	var plain := _club("front_of_house")
	var wall := _club("bag_wall")
	var rehab := _club("conditioning")
	var rings := _club("two_rings")
	_near(GymSpend.gain(wall, "power") / GymSpend.gain(plain, "power"), 1.03, "the bag wall trains power 3% better")
	_near(GymSpend.gain(wall, "conditioning") / GymSpend.gain(plain, "conditioning"), 1.0, "and leaves conditioning alone")
	_near(GymSpend.days_out(rehab) / GymSpend.days_out(plain), 0.9, "the conditioning floor cuts days out 10%")
	var a: Dictionary = GymSpend.show_preview(plain)
	var b: Dictionary = GymSpend.show_preview(rings)
	_check(int(b["hi"]) > int(a["hi"]), "two rings sell more show tickets (%d to %d)" % [a["hi"], b["hi"]])


func _club(id: String) -> Career:
	var c := Career.from_create({"gym_plan": id, "start": "fresh", "name": "", "coach": ""}, "Test Gym", "London")
	c.members = 200
	c.reputation = 60
	_check(c.gym_plan == id, "the career keeps its building " + id)
	return c


## The setup page shows the four buildings and a click picks one.
func _setup_card() -> void:
	var main := MAIN.instantiate()
	root.add_child(main)
	await process_frame
	root.size = Vector2i(1920, 1080)
	main.act("newcareer")
	main.act("cstep", "1")
	await process_frame
	for p in GymPlan.load_all():
		_check(main.find_child("Plan_" + str(p["id"]), true, false) != null, "setup offers " + str(p["name"]))
	main.act("cpick", "gym_plan|bag_wall")
	await process_frame
	_check(str(main.create.get("gym_plan", "")) == "bag_wall", "picking a building holds it")
	main.act("cstart", "Test Gym")
	await process_frame
	_check(main.career != null and main.career.gym_plan == "bag_wall", "the career starts in that building")
	main.queue_free()
	await process_frame


func _near(got: float, want: float, what: String) -> void:
	_check(absf(got - want) < 0.001, "%s: %.3f, want %.3f" % [what, got, want])


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
