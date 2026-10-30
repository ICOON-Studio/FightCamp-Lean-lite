extends RefCounted
## S310 (operator: "add a link on the board to launch the latest version, or the part I need to test only"): the build
## started with user args jumps straight to the part a weekly update asks him to test. The ops board's Play buttons pass
##   FightCamp.exe -- jump=fight          quick start -> Lucy booked -> camp WITH film study -> weigh-in -> fight night
##   FightCamp.exe -- jump=fight_nofilm   the same, camp WITHOUT film study (no coach's pick on the shout bar)
## The same button presses tools/fight3d_play.gd makes. It plays on its own save slot, never his career save.

const Bouts := preload("res://scripts/state/Bouts.gd")

const SAVE_PATH := "user://test_jump_save.json"
const JUMPS := ["fight", "fight_nofilm"]


## The jump the command line asks for ("" = none).
static func wanted(args: PackedStringArray) -> String:
	for a in args:
		if a.begins_with("jump=") and JUMPS.has(a.trim_prefix("jump=")):
			return a.trim_prefix("jump=")
	return ""


## Plays main to fight night. Returns false if a step did not reach its screen.
static func run(main: Node, jump: String) -> bool:
	main.save_path = SAVE_PATH
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		_tidy(main, c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			offer = o
	if offer.is_empty():
		return false
	main.act("accept", str(offer["id"]))
	main.act("camp", str(f["id"]))
	if jump == "fight_nofilm" and bool(main.modal.get("film", false)):
		main.act("cfilm", "")
	main.act("startcamp")
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		_tidy(main, c)
		main.run_to_stop()
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	main.act("fightnight")
	return str(main.modal.get("type", "")) == "fight"


static func _tidy(main: Node, c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")
