extends RefCounted
## S310 (operator: "add a link on the board to launch the latest version, or the part I need to test only"): the build
## started with user args jumps straight to the part a weekly update asks him to test. The ops board's Play buttons pass
##   FightCamp.exe -- jump=fight          quick start -> Lucy booked -> camp WITH film study -> weigh-in -> fight night
##   FightCamp.exe -- jump=fight_nofilm   the same, camp WITHOUT film study (no coach's pick on the shout bar)
##   FightCamp.exe -- jump=round3         S323 (Ziva's playtest could not reach round 3 inside its 27 s runs): jump=fight,
##                                        then the bout starts and rounds 1-2 are skipped (corner calls "lead") - round 3
##                                        plays live, where the tired look shows
##   FightCamp.exe -- jump=corner         jump=fight with two combinations drilled on the pads (1-2, 1-2-3), so the
##                                        corner minute's set-up has something to set up (S310)
##   FightCamp.exe -- jump=injury         S325 update 28: Lucy booked and in camp, then a hand injury in training pulls her
##                                        out of the bout (the club pays the empty slot); opens on her fighter page
##   FightCamp.exe -- jump=nationals      S328 update 30: a known career played through its first bouts (offers accepted,
##                                        bouts boxed) until Lucy can enter the nationals; opens on WORLD > Nationals
##   FightCamp.exe -- jump=pro            S329 update 31: quick start, Lucy put at the line (9-1 amateur) - the promoter's
##                                        offer opens: her debut tickets, what the gym pays now; sign and play to the debut
## The same button presses tools/fight3d_play.gd makes. It plays on its own save slot, never his career save.

const Bouts := preload("res://scripts/state/Bouts.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Roster := preload("res://scripts/state/Roster.gd")

const SAVE_PATH := "user://test_jump_save.json"
const JUMPS := ["fight", "fight_nofilm", "corner", "round3", "injury", "nationals", "pro", "taperoom"]
## What two weeks of pad time on the 1-2 and the 1-2-3 leave her with (Combos.LEARN_AT is 30).
const DRILLED := {"1-2": 62.0, "1-2-3": 48.0}


## S323 jump=round3: from fight night, start the bout and skip rounds 1 and 2 (the corner takes "lead"); round 3 then
## plays live. A coroutine - Main fires it after run().
static func to_round3(main: Node) -> void:
	var tree := main.get_tree()
	main.act("fightstep", "start")
	for k in 4:
		await tree.process_frame
	var view: Node = main.get("_fight_layer").get_child(0)
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	for n in [1, 2]:
		while not (bool(view.playing) and int(view.round_n) == n):
			await tree.process_frame
		view.skip_round()
		var cm: Node = null
		for k in 120:
			await tree.process_frame
			for ch in view.get_children():
				if ch.has_method("cue_walk_out"):
					cm = ch
			if cm != null and cm.get("ui") != null and cm.ui._card.visible:
				break
		if cm != null:
			cm._pick("lead")
			cm.finish()
	print("TESTJUMP round3 reached: round ", view.round_n)


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
	if jump == "nationals":
		return _to_nationals(main, c, f)
	if jump == "pro":
		f["w"] = 9
		f["l"] = 1
		Roster.check_pro(c)
		main.act("prooffer")
		return str(main.modal.get("type", "")) == "prooffer"
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
	if jump == "injury":
		Injuries._hurt(c, f, {"type": "hand", "days_out": 35}, "in training")
		main.act("fighter", str(f["id"]))
		# S327 (Q-S294-46): the injury runs past her bout, so the player decides - the jump lands on that choice.
		main.act("injurychoice", str(f["id"]))
		return Injuries.pending(f) and str(main.modal.get("title", "")).contains("hurt before the bout")
	if jump == "taperoom":
		# S343: her camp with film study opens the tape room on her opponent (Q-S294-68).
		main.act("fighter", str(f["id"]))
		main.act("taperoom", str(f["id"]))
		return main.get_node_or_null("TapeRoom") != null
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		_tidy(main, c)
		main.run_to_stop()
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	if jump == "corner":
		f["combos"] = DRILLED.duplicate()
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


## S328 jump=nationals: one known career (fixed dice) plays on - every even offer taken with a camp, every bout boxed, a hurt bout
## pulled out - until she can enter (5 bouts, 3 months registered, entries open); lands on WORLD > Nationals.
static func _to_nationals(main: Node, c: Career, f: Dictionary) -> bool:
	c.seed = 1
	for i in 400:
		if Champs.cannot_enter(c, f) == "" or c.closed:
			break
		_tidy(main, c)
		for o in f["offers"]:
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				main.act("accept", str(o["id"]))
		if Bouts.camp_due(c, f):
			main.act("camp", str(f["id"]))   # the camp cuts her weight: without it she misses the limit
			main.act("startcamp")
		if Injuries.pending(f):
			main.act("pullout", str(f["id"]))
		if Bouts.weigh_in_today(c, f):
			main.act("weighin", str(f["id"]))
			main.act("doWeigh")
		if Bouts.fight_day(c, f):
			main.act("fightnight")
			main.act("fightstep", "sim")
			main.act("afterfight")
			continue
		if not main.modal.is_empty():
			main.act("close")
		main.run_to_stop()
	main.act("go", "world:4")
	return Champs.cannot_enter(c, f) == ""
