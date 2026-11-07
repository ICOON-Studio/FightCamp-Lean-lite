extends SceneTree
## S398 (Money's harness crashed Godot with signal 11 in Fights._calendar: two boxers, 104 weeks, every screen built): the
## cause was the harness rebuilding pages hundreds of times inside ONE frame until the engine's deferred-call queue (32 MB)
## overflowed - the game itself runs one day a timer tick, a frame each. This test plays what a player does: two boxers for
## 104 weeks, a frame after every stop, the week review opened and closed, every bout offer taken, and the Fights, Week and
## Fight prep pages built along the way. Cash is topped up so the gym stays open (a UI test, not a money one).
## Population: the quick-start gym, Lucy signed at reception, a second boxer signed from scouting in week 13.
##   PASS: 104 weeks reached, 2 boxers on the roster, the pages built every 4th stop, no crash.

const Bouts := preload("res://scripts/state/Bouts.gd")

const WEEKS := 104

var _fails := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	main.save_path = "user://two_boxers_test.save"
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	await process_frame
	var stops := 0
	var built := 0
	while c.day < WEEKS * 7 and stops < 1500:
		stops += 1
		c.cash = maxi(c.cash, 20000)   # the gym stays open: this test is about the pages, not the money
		if c.review_pending:
			main.act("review")
			await process_frame
			main.act("close")
		if not (main.modal as Dictionary).is_empty():
			main.act("close")
		for f in c.fighters:
			for o in (f.get("offers", []) as Array).duplicate():
				if not bool(o.get("answered", false)) and not bool(o.get("mismatch", false)) and (f["bout"] as Dictionary).is_empty():
					main.act("accept", str(o["id"]))
					break
		if c.fighters.size() < 2 and c.day >= 7 * 13:
			for p in c.prospects:
				if str(p["state"]) == "scout":
					main.act("invite", str(p["id"]))
					break
		for p in c.prospects:
			if str(p["state"]) == "invited" and c.day >= int(p["trial_day"]):
				main.act("trial", str(p["id"]))
				main.act("signprospect")
		if not c.pro_offer.is_empty():
			main.act("prooffer", str(c.pro_offer["fid"]))
			main.act("turnpro")
		if not Bouts.fighting_today(c).is_empty():
			main.act("fightnight")
			main.act("close")
		main.run_to_stop(60)
		await process_frame   # what the game's timer gives every day: the engine flushes its UI work between frames
		if stops % 4 == 0:
			for r in [{"area": "fights", "tab": 0}, {"area": "fighters", "tab": 0, "fighter": str(c.fighters.back()["id"]), "ftab": 3},
					{"area": "fighters", "tab": 0, "fighter": str(c.fighters.back()["id"]), "ftab": 5}]:
				main.nav(r)
				await process_frame
			built += 1
	_check(c.day >= WEEKS * 7, "104 weeks played (day %d, %d stops)" % [c.day, stops])
	_check(c.fighters.size() >= 2, "two boxers on the roster (%d)" % c.fighters.size())
	_check(built >= 20, "the Fights, Week and Fight prep pages built along the way (%d times)" % built)
	print("TWO_BOXERS_TWO_YEARS %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print(("ok   " if ok else "FAIL ") + what)
