extends SceneTree
## S537 WEIGHTCUT1 (owner, on six failed weight probes: "cut the weight choices and keep weight as plain facts"): the diet is
## the game's, never the player's.
## 1. The rule (WeekPlan.diet_for / diet_of): CUT only with a bout booked and the scale above the limit less the margin;
##    the old stored choice (f["diet"]) moves nothing.
## 2. The sim's week (Sim.week_ctx) follows the booking, and the old "diet" act changes nothing.
## 3. The line the screens show says the fact in words; its tooltip explains and never repeats it.
## 4. The Training screen (TestJump club4: three boxers + the grappler) shows the DIET box as a line, with no control;
##    the two older week views (WeekBoard, WeekCamp) bind no diet act either.
## Population: Lucy-like lightweight dicts (limit 60.0; 61.0 / 59.9 / 59.5 kg) + the test club's boxers.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")
const ClubWeek := preload("res://scripts/state/ClubWeek.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var _fails := 0


func _initialize() -> void:
	# 1. the rule
	_check(WeekPlan.diet_for(61.0, 60.0, true) == "cut", "1: booked and over the limit: cut")
	_check(WeekPlan.diet_for(59.9, 60.0, true) == "cut", "1: booked and inside the margin (59.9 for 60): still cut")
	_check(WeekPlan.diet_for(59.5, 60.0, true) == "hold", "1: booked and well inside: hold")
	_check(WeekPlan.diet_for(63.0, 60.0, false) == "hold", "1: no bout: hold, however heavy")
	var f := {"weight": 61.0, "limit": 60.0, "diet": "cut", "bout": {}, "camp": {}}
	_check(WeekPlan.diet_of(f) == "hold", "1: the old stored choice (diet cut, no bout) moves nothing")
	f["diet"] = "hold"
	f["bout"] = {"day": 12, "done": false}
	_check(WeekPlan.diet_of(f) == "cut", "1: a booked bout below the walking weight: cut, with the old choice on hold")
	f["bout"] = {"day": 12, "done": true}
	_check(WeekPlan.diet_of(f) == "hold", "1: the bout is over: hold again")
	# 3. the line and its tooltip
	f["bout"] = {"day": 12, "done": false}   # day 12 = a Saturday (day 0 is a Monday)
	var fact: Dictionary = WeekPlan.diet_fact(f, 8)
	_check(str(fact["line"]) == "Making 60 kg for Saturday: eating light this week", "3: the cut in words (%s)" % str(fact["line"]))
	_check(str(WeekPlan.diet_fact(f, 1)["line"]).begins_with("Making 60 kg for the bout on "), "3: a bout past this week is named by its date (%s)" % str(WeekPlan.diet_fact(f, 1)["line"]))
	f["weight"] = 59.5
	_check(str(WeekPlan.diet_fact(f, 8)["line"]) == "Inside 60 kg for Saturday: eating as normal", "3: inside the limit (%s)" % str(WeekPlan.diet_fact(f, 8)["line"]))
	f["bout"] = {}
	_check(str(WeekPlan.diet_fact(f, 8)["line"]) == "No bout booked: eating as normal", "3: no bout (%s)" % str(WeekPlan.diet_fact(f, 8)["line"]))
	for w in [61.0, 59.5]:
		for b in [{}, {"day": 12, "done": false}]:
			var g := {"weight": w, "limit": 60.0, "bout": b, "camp": {}}
			var fa: Dictionary = WeekPlan.diet_fact(g, 8)
			_check(str(fa["tip"]) != "" and not str(fa["tip"]).contains(str(fa["line"]).get_slice(":", 0)), "3: the tooltip explains, never repeats (%s)" % str(fa["tip"]))
	# the coach no longer hands the player a diet switch
	var easy := [["shadow", "light"], ["rest", "normal"], ["shadow", "light"], ["rest", "normal"], ["shadow", "light"], ["rest", "normal"], ["rest", "normal"]]
	var ctx := {"stats": {"conditioning": 58.0, "power": 55.0}, "pot": 80, "coach": 60.0, "weight": 61.0, "diet": "hold", "fatigue": 20.0}
	var ad: Dictionary = WeekCoach.advice(easy, WeekPlan.week(easy, ctx), [{"id": "weight", "ok": false, "short": 0.4}], "hold")
	_check(not (ad["fix"] as Dictionary).has("diet") and not str(ad["say"]).to_lower().contains("switch the diet"), "3: the coach's line asks for no diet switch (%s)" % str(ad["say"]))
	# 2 + 4. the game
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	TestJump.run(main, "club4")
	if not main.modal.is_empty():
		main.act("close")
	var c: Career = main.career
	var bx: Dictionary = c.fighters[0]
	for x in c.fighters:
		if (x.get("bout", {}) as Dictionary).is_empty() and (x.get("camp", {}) as Dictionary).is_empty():
			bx = x
	var fid := str(bx["id"])
	var keep_bout: Dictionary = bx.get("bout", {})
	var keep_camp: Dictionary = bx.get("camp", {})
	var keep_kg := float(bx["weight"])
	bx["bout"] = {}
	bx["camp"] = {}
	bx["weight"] = float(bx["limit"]) + 1.0
	main.act("diet", "%s|cut" % fid)
	bx["diet"] = "cut"
	_check(str(Sim.week_ctx(c, bx)["diet"]) == "hold", "2: no bout: the week holds, whatever was once chosen")
	_check(not Sim.twist_needs(bx, c).has("cut"), "2: no bout: no cut for the twist cards")
	bx["diet"] = "hold"
	main.act("diet", "%s|cut" % fid)
	_check(str(bx["diet"]) == "hold", "2: the old diet act sets nothing")
	bx["bout"] = {"day": c.day + 9, "done": false}
	_check(str(Sim.week_ctx(c, bx)["diet"]) == "cut", "2: booked a kilo over: the week cuts on its own")
	bx["weight"] = float(bx["limit"]) - 0.5
	_check(str(Sim.week_ctx(c, bx)["diet"]) == "hold", "2: booked and inside the limit: the week holds")
	bx["bout"] = keep_bout
	bx["camp"] = keep_camp
	bx["weight"] = keep_kg
	main.nav({"area": "training", "fighter": fid})
	await _frames(4)
	var page := main.find_child("Training", true, false)
	_check(page != null, "4: TRAINING opens")
	if page != null:
		var box := page.find_child("Diet", true, false) as Control
		_check(box != null, "4: the DIET box is on the screen")
		for n in ["Diet_hold", "Diet_cut", "HoldBtn", "CutBtn"]:
			_check(main.find_child(n, true, false) == null, "4: no %s control" % n)
		if box != null:
			_check(_buttons(box) == 0, "4: nothing to press in the DIET box (%d buttons)" % _buttons(box))
			var line := box.find_child("DietLine", true, false) as Label
			var want := str(WeekPlan.diet_fact(c.fighter_by_id(str((page.get("model") as Dictionary)["sel"])), c.day)["line"])
			_check(line != null and line.text == want, "4: the line is the rule's (%s)" % (line.text if line != null else "none"))
			_check(box.tooltip_text != "" and (line == null or not box.tooltip_text.contains(line.text)), "4: the box's tooltip explains (%s)" % box.tooltip_text)
			var m: Dictionary = page.get("model")
			_check(str((m["diet"] as Dictionary)["diet"]) == WeekPlan.diet_of(c.fighter_by_id(str(m["sel"]))), "4: the model's diet is the rule's")
	for path in ["res://scripts/ui/WeekBoard.gd", "res://scripts/ui/WeekCamp.gd", "res://scripts/ui/TrainTired.gd", "res://scripts/ui/areas/Training.gd"]:
		var src := FileAccess.get_file_as_string(path)
		_check(src != "" and not src.contains("act.bind(\"diet\"") and not src.contains("act(\"diet\""), "4: %s binds no diet act" % path.get_file())
	print("WEIGHT_FACTS %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(1 if _fails > 0 else 0)


func _buttons(n: Node) -> int:
	var k := 1 if n is BaseButton else 0
	for ch in n.get_children():
		k += _buttons(ch)
	return k


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		_fails += 1
		print("FAIL ", label)
