extends SceneTree
## S533 TIPFIX3 (owner Q-S294-283 "Shorter cards"; "If yes I convert the other screens the same way"): the tooltip standard
## (ops/research/GUIDETIPS1_STANDARD.md section 2, Tip.faults at the TIPFIX2 limits) on the screens
## tests/tooltip_standard_test.gd does not walk:
##   the week review | the gym floor (the hub's picture, its Equip mode) | the Office desktop and its calendar | Money |
##   Records | Mail (World > News) and the hub's World room (Rankings, Championships) | Fights (offers, the calendar, results) |
##   Find a fighter | Fights with offers waiting | a booked bout's Fight prep page and its FIGHT WEEK screen (the week, the partner pick), then the
##   Office calendar, Fights and Mail with that bout on them.
## Each tooltip is counted once (title + prose); the ones breaking a rule may only go down (FAULTS_AT_MOST). `-- list` prints
## each one with its page. The 3D gym and fight night need a picture: they are not walked here.
##   godot --headless --audio-driver Dummy --path . --script res://tests/tooltip_rest_test.gd [-- list]

const Tip := preload("res://scripts/ui/Tip.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")

const FAULTS_AT_MOST := 0   # S534: 1 -> 0 (MMA chip rewritten). lower it as cards are rewritten, never raise it (S533 TIPFIX3: 64 of 140 on main -> 1: the MMA chip, pinned)

var _fails := 0
var main: Node
var _seen := {}
var _total := 0
var _broken := 0
var _list := false


func _initialize() -> void:
	_list = OS.get_cmdline_user_args().has("list")
	load("res://scripts/ui/MenuFx.gd").instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	main.size = Vector2(1920, 1080)
	await _review()
	await _club()
	await _fight_week()
	print("TOOLTIP_REST tooltips=%d broken=%d (at most %d)" % [_total, _broken, FAULTS_AT_MOST])
	_check(_total >= 40, "the rest of the screens were walked: %d tooltips seen" % _total)
	_check(_broken <= FAULTS_AT_MOST, "the broken tooltips on these screens only go down: %d <= %d" % [_broken, FAULTS_AT_MOST])
	print("TOOLTIP_REST %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


## The quick start's first week, played to its review.
func _review() -> void:
	main.act("newcareer")
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	for i in 14:
		if c.review_pending:
			break
		main.run_to_stop()
	_check(c.review_pending, "the first week reaches its review")
	main.act("review")
	_check(str(main.modal.get("type", "")) == "review", "the week review opens")
	await _page("week_review")
	main.act("close")


## The four-fighter test club: the gym floor, the office, the books, the records, the world, the fights, the scout.
func _club() -> void:
	_check(TestJump.run(main, "club4"), "the test club is set up")
	if not main.modal.is_empty():
		main.act("close")
	main.act("area", "home")
	await _page("gym_floor")
	main.act("equipgym", "on")
	await _page("gym_equip")
	main.act("equipgym", "off")
	main.nav({"area": "office", "tab": 0})
	await _page("office")
	_check(main.find_child("CalendarPanel", true, false) != null, "the office desktop shows its calendar")
	main.act("go", "money:0")
	await _page("money")
	main.act("go", "gym:4")
	await _page("records")
	main.act("mail")
	await _page("mail")
	main.nav({"area": "world", "tab": 1})
	await _page("world_rankings")
	main.nav({"area": "world", "tab": 2})
	await _page("world_championships")
	main.act("go", "fights:0")
	await _page("fights_calendar")
	main.nav({"area": "fighters", "tab": 3})
	await _page("find_a_fighter")


## A booked club-show bout: its Fight prep page and the FIGHT WEEK screen (the week, then a night's partner pick).
func _fight_week() -> void:
	var f: Dictionary = await _book()
	_check(not f.is_empty(), "an even club-show bout is booked")
	if f.is_empty():
		return
	var fid := str(f["id"])
	main.nav({"area": "fighters", "tab": 0, "fighter": fid, "ftab": 5})
	await _page("fight_prep")
	main.act("fightweek", fid)
	_check(str(main.modal.get("type", "")) == "fightweek", "the fight week screen opens")
	await _page("fight_week")
	main.modal["plan"]["nights"] = {}
	main.act("fwnight", "6")
	await _page("fight_week_partner")
	main.act("fwback")
	main.act("close")
	main.nav({"area": "office", "tab": 0})   # the booked bout on the desk's calendar, the fixture list and the mail
	await _page("office_booked")
	main.act("go", "fights:0")
	await _page("fights_booked")
	main.act("mail")
	await _page("mail_booked")


## The quick start's fighter takes the first even offer (the pattern of fight_week_screen_test).
func _book() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	TestJump._tidy(main, c)
	if not main.modal.is_empty():
		main.act("close")
	main.act("go", "fights:0")   # the offers waiting (OfferCard)
	await _page("fights_offers")
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			f["arrows"] = PlanTemplates.load(PlanTemplates.BOXING[0], 6)
			main.act("accept", str(o["id"]))
			return f
	return {}


func _page(page: String) -> void:
	await _settle(6)
	var names := _names()
	var n_before := _total
	for n in main.find_children("*", "Control", true, false):
		var c := n as Control
		if not c.is_visible_in_tree():
			continue
		var s := Tip.of(c)
		if s.is_empty():
			continue
		var key := str(s.get("title", "")) + "|" + " ".join(Tip.prose(s))
		if _seen.has(key):
			continue
		_seen[key] = true
		_total += 1
		var f := Tip.faults(s, _label_of(c), names)
		if not f.is_empty():
			_broken += 1
			if _list:
				print("TIPFAULT %s [%s] label=\"%s\" tip=\"%s\"" % [page, ",".join(f), _label_of(c).left(40).replace("\n", " "), key.left(170).replace("\n", " / ")])
	if _list:
		print("PAGE %s new_tooltips=%d" % [page, _total - n_before])


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _names() -> Array:
	var out: Array = []
	var c: Career = main.career
	if c == null:
		return out
	for f in c.fighters:
		for k in ["first", "name"]:
			if str(f.get(k, "")).length() > 2:
				out.append(str(f[k]))
	if str(c.coach.get("name", "")).length() > 2:
		out.append_array(str(c.coach["name"]).split(" "))
	return out


func _label_of(c: Control) -> String:
	if c is Button or c is Label:
		return str(c.get("text"))
	var words: Array = []
	for l in c.find_children("*", "Label", true, false):
		words.append(str((l as Label).text))
	return " ".join(words)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
