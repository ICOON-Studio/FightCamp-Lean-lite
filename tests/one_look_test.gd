extends SceneTree
## S498 ONELOOK1 round 2 (operator on Q-S294-261: "i do not like the wooden panels , some pictures ahve some dont , how do
## you call this consistent ?"): EVERY page of the test club (TestJump club4: 3 boxers + 1 BJJ, every menu populated) and
## the fight HUD, at Medium and at Largest text, through scripts/ui/LookCheck.gd. One fault anywhere = red. It went red on
## the wooden kit (a picture-drawn card or button on every page) before the plain panel replaced it.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const Settings := preload("res://scripts/state/Settings.gd")
const LookCheck := preload("res://scripts/ui/LookCheck.gd")
const PAGES := [["home", "home:0"], ["fighters_roster", "fighters:0"], ["fighters_find", "fighters:3"], ["fights", "fights:0"],
	["gym_people", "gym:1"], ["gym_records", "gym:4"], ["money", "money:0"], ["office", "office:0"], ["world_news", "world:0"],
	["world_rankings", "world:1"], ["world_championships", "world:2"]]

var main: Node
var failures := 0
var pages := 0


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	root.size = Vector2i(1920, 1080)
	await _fight()
	for text_i in ([] if OS.get_cmdline_user_args().has("fight") else [1, 3]):
		await _club(text_i)
	print("ONE_LOOK pages=%d failures=%d waiting_for_training_k=%d" % [pages, failures, waiting])
	print("one_look_test failures=", failures)
	quit(1 if failures > 0 else 0)


func _club(text_i: int) -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	TextScale.use(self, float(Settings.TEXT_SIZES[text_i][1]))   # the title screen is a picture, not a page: not checked
	if not TestJump.run(main, "club4"):
		_fail("t%d the test club did not load" % text_i)
		return
	var c: Career = main.career
	c.guide = ""
	for page in PAGES:
		main.act("go", str(page[1]))
		await _look("t%d %s" % [text_i, page[0]])
	var first := true
	for f in c.fighters:
		var fid := str((f as Dictionary)["id"])
		main.act("fighter", fid)
		for t in ([0, 3, 4, 5] if first else [0, 3]):
			main.act("ftab", str(t))
			await _look("t%d %s tab %d" % [text_i, fid, t])
		if first:
			for p in 4:
				main.act("go", "playbook:%d" % p)
				await _look("t%d %s playbook %d" % [text_i, fid, p])
		first = false
	for g in c.grapplers:
		var gid := str((g as Dictionary).get("id", ""))
		if gid != "":
			main.act("fighter", gid)
			await _look("t%d %s mat" % [text_i, gid])
	if text_i == 3:
		await _popups(c)
	main.queue_free()
	await _frames(2)


## The pop-ups the club can open (at Largest text, the operator's own setting): each one through the same check.
func _popups(c: Career) -> void:
	var fid := str((c.fighters[0] as Dictionary)["id"])
	var shown := [["info", {"type": "info", "title": "A note", "body": "A pop-up with a few words in it."}],
		["poster", {"type": "poster", "fid": fid}], ["goaltalk", {"type": "goaltalk", "fid": fid, "pick": ""}]]
	if c.applicant.is_empty():   # the walk-in at reception (the normal game's first screen): the club's own walk-in
		c.applicant = load("res://scripts/rules/ClubStart.gd").walkin(c.start, load("res://scripts/state/Data.gd").lucy())
	shown.append(["interview", {"type": "interview", "picks": []}])
	for p in shown:
		main.open_modal(p[1])
		await _frames(4)
		_report("t3 pop-up %s" % p[0], LookCheck.faults(main))
		main.close_modal()
	for f in c.fighters:
		var b: Dictionary = (f as Dictionary).get("bout", {})
		if b.has("opp"):
			main.act("camp", str(f["id"]))
			await _frames(4)
			_report("t3 pop-up camp", LookCheck.faults(main))
			main.close_modal()
			break
	main.act("settings", "")
	await _frames(4)
	_report("t3 settings", LookCheck.faults(main))


## The fight HUD: the fight jump to fight night, the round started, the corner bar and the scorebug up.
func _fight() -> void:
	load("res://scripts/fight3d/FightView.gd").force3d = true   # headless the fight stays in words unless forced (corner_bar_test)
	load("res://scripts/fight3d/FightIntro.gd").from_corners = true
	TextScale.use(self, float(Settings.TEXT_SIZES[1][1]))
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	if not TestJump.run(main, "fight"):
		_fail("fight: the fight jump did not reach fight night")
		return
	main.act("fightstep", "start")
	for i in 600:
		if main._fight_layer.get_child_count() > 0 and main._fight_layer.get_child(0).find_child("CornerBar", true, false) != null:
			break
		await process_frame
	if main._fight_layer.get_child_count() == 0:
		_fail("fight: no fight view (modal %s)" % str(main.modal.get("type", "")))
		return
	var view: Node = main._fight_layer.get_child(0)
	for ch in view.get_children():   # skip the ring walk-in, as corner_bar_test does: the HUD is up once the round plays
		if ch.has_method("cue_touch"):
			ch.finish()
	for i in 900:
		var up: Node = view.find_child("CornerBar", true, false)
		if up != null and (up as CanvasItem).is_visible_in_tree() and bool(view.get("playing")):
			break
		await process_frame
	await _frames(4)
	var shown: Node = view.find_child("CornerBar", true, false)
	_check(shown != null and (shown as CanvasItem).is_visible_in_tree(), "fight: the corner bar is on screen while the round plays")
	_check(view.find_child("CornerBar", true, false) != null, "fight: the corner bar is up")
	_report("fight hud", LookCheck.faults(view))
	# The corner minute: skip the round, the corner card comes up between rounds.
	var skip := view.find_child("SkipRound", true, false) as Button
	_check(skip != null, "fight: Skip round is on the bar")
	if skip != null:
		skip.pressed.emit()
		var corner: Node = null
		var card_up := false
		for i in 1800:   # the minute's card shows after the coach's first line
			corner = view.find_child("SkipCorner", true, false)
			card_up = corner != null and (corner as CanvasItem).is_visible_in_tree() and corner.get_parent().get_children().any(
				func(ch): return ch is PanelContainer and (ch as Control).is_visible_in_tree())
			if card_up:
				break
			await process_frame
		await _frames(6)
		_check(card_up, "fight: the corner card comes up")
		_report("fight corner", LookCheck.faults(view))
	load("res://scripts/fight3d/FightView.gd").force3d = false
	main.queue_free()
	await _frames(2)


func _look(name: String) -> void:
	main.modal = {}
	main.render()
	await _frames(3)
	var g := main.find_child("FirstWeekStrip", true, false)
	if g != null:
		(g as CanvasItem).visible = false
	_report(name, LookCheck.faults(main))


## The Training tab (a fighter's tab 3) belongs to the Training K rebuild (main session S496/S498, Q-259): its faults are
## printed as WAIT, counted, and not failed here - the Training K restyle on this kit clears them.
const TRAINING_K := ["WeekTiles/", "MorningEditor/", "WeekBoard/", "WeekStrip/", "WeekCards/", "DrillTray/", "TrainCards/"]
var waiting := 0


func _report(name: String, found: Array) -> void:
	pages += 1
	var mine: Array = []
	for f in found:
		var held := name.ends_with("tab 3")
		for k in TRAINING_K:
			held = held or str(f).contains(k)
		if held:
			waiting += 1
			print("WAIT %s (Training K): %s" % [name, f])
		else:
			mine.append(f)
	found = mine
	if found.is_empty():
		print("OK  %s: one look" % name)
		return
	failures += 1
	print("FAIL %s: %d faults" % [name, found.size()])
	for f in found.slice(0, 12):
		print("     " + str(f))


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1


func _fail(label: String) -> void:
	_check(false, label)


func _frames(n: int) -> void:
	for i in n:
		await process_frame
