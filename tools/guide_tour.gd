extends SceneTree
## S375: the boxer followed is Danny (scouted, trialled, signed), and the tour ends on Ana's mat page.
## S370 the playthrough guide (operator: "a gif animated guide explaining your playthrough each step would be nice"; "work
## more on the player experience, through the menus"). Plays one quick-start career along the Miro fighter's path (frame 4:
## walk-in, sign, the first goal, training weeks, the week review, an offer, the bout page, camp, tape, the plan, weigh-in,
## fight night, result, next goal) with the golden path's own presses (tests/golden_path_test.gd, seed 1), and saves the
## screen at every step. Captions are NOT drawn on the picture: each step prints a TOUR line (file | title | what it is for)
## and tools/guide_gif.py lays them under the frames. Render on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/guide_tour.gd -- <out_dir>

const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")

var main: Node
var out_dir := "user://guide_tour"
var n := 0


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	await _tour()
	print("TOUR_DONE steps=%d" % n)
	quit(0)


func _tour() -> void:
	await _shot("The title screen", "Quick start opens a built gym in London: 30 members and three months of cash.")
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	await _shot("HOME - what needs you", "The day, your cash and the big button: NEEDS YOU while a decision waits, CONTINUE runs the days.")
	main.act("go_btn")
	await _shot("A boxer walks in", "The interview: read the boxer, then pick three training cards from the gym.")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	_press(_modal_button("Sign"))
	main.act("go", "gym:1")
	main.act("hire", "reid")
	await _shot("GYM > Staff - hire a coach", "Luke Reid, sessional: $1,000 to sign, $450 a week. A coach runs the training days.")
	# S375 (operator S370: every playthrough = a male boxer + Ana): the boxer we follow is Danny, found through scouting.
	main.act("go", "fighters:3")
	await _shot("FIGHTERS > Scouting", "The fighters scouting knows: each number is a range until a trial shows the truth.")
	main.act("invite", "danny")
	await _shot("Danny invited for a trial", "A trial date goes on the calendar; the days run up to it.")
	for i in 20:
		if str(Roster.prospect(c, "danny")["state"]) != "invited" or int(Roster.prospect(c, "danny")["trial_day"]) <= c.day:
			break
		_tidy(c)
		main.run_to_stop()
	main.act("trial", "danny")
	await _shot("Danny's trial", "Pads and sparring show his real numbers. Sign him, or pass.")
	main.act("trialcard", "signature")
	await _shot("A starting focus", "One choice for his first weeks: sharpen the signature, fix the habit or raise the ceiling.")
	main.act("signprospect")
	var f := c.fighter_by_id("danny")
	if f.is_empty():
		print("TOUR_MISS Danny did not sign")
		return
	var fid := "danny"
	main.act("go", "fighters:0")
	await _shot("FIGHTERS > Roster", "Every boxer on one card: form, weight, goal and next bout.")
	main.act("fighter", fid)
	await _shot("The fighter page", "Numbers, body and goal. Every name in the game opens this page.")
	for i in range(1, 4):
		main.act("ftab", str(i))
		await _shot("The fighter page - tab %d" % (i + 1), "")
	main.act("go", "home:0")
	var reviewed := false
	for i in 60:
		if not (f["offers"] as Array).filter(func(o): return not bool(o["mismatch"]) and not bool(o["answered"])).is_empty():
			break
		if c.review_pending and not reviewed:
			main.act("review")
			await create_timer(4.0).timeout   # S375: the review lands its bars one by one; shoot it landed
			await _shot("The week review", "Every Sunday: what was gained, what it cost and what comes next.")
			main.act("close")
			reviewed = true
		_tidy(c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]) and not bool(o["answered"]):
			offer = o
	if offer.is_empty():
		print("TOUR_MISS no offer for Danny")
		return
	main.act("go", "fights:0")
	await _shot("FIGHTS > the offers", "The opponent, the odds, the purse and the date - dated where his camp makes the weight.")
	main.act("accept", str(offer["id"]))
	main.act("camp", fid)
	await _shot("Set the camp", "The camp's focus, sparring and film: what the weeks before the fight are for.")
	main.act("startcamp")
	main.act("go", "fighters:2")
	await _shot("FIGHTERS > Fight camps", "The camp's weeks and what the tape has found on the opponent so far.")
	var kids := main.get_child_count()
	main.act("taperoom", fid)
	await create_timer(3.0).timeout
	await _shot("The tape room", "Watch the opponent's fights: each session finds one more thing.")
	# The tape room is a layer over the whole game (RosterActs "taperoom"), not a modal: take it off again.
	while main.get_child_count() > kids:
		var room := main.get_child(main.get_child_count() - 1)
		main.remove_child(room)
		room.queue_free()
	Playbook.pick = fid
	for i in 4:
		main.act("go", "playbook:%d" % i)
		await _shot(["PLAYBOOK > Moves", "PLAYBOOK > Game plan", "PLAYBOOK > Combos", "PLAYBOOK > Escapes"][i],
			["The move book: what the boxer can throw and how well.", "The plan for this fight, written as lines: at range X, do Y.",
			"Build combos and test them on a partner.", "How to get out of trouble: ropes, corners, clinch."][i])
	main.act("go", "home:0")
	for i in 60:
		if Bouts.weigh_in_today(c, f) or (f["bout"] as Dictionary).is_empty():
			break
		_tidy(c)
		main.run_to_stop()
	main.act("weighin", fid)
	await _shot("The weigh-in", "The day before: make the weight or pay for it.")
	main.act("doWeigh")
	await _shot("On the scale", "")
	if (f["bout"] as Dictionary).is_empty():
		return
	if not main.modal.is_empty():
		main.act("close")
	main.run_to_stop()
	main.act("fightnight")
	await _shot("Fight night", "The tale of the tape and your plan. Begin to watch it live.")
	_press(_modal_button("Begin"))
	# With a picture the bout opens on the walk-in and the tale of the tape (FightIntro, ~20 s), then the round plays live.
	await create_timer(6.0).timeout
	await _shot("The walk-in", "Both boxers walk to their corners; the crowd, the corner teams, the ring announcer.")
	await create_timer(6.5).timeout
	await _shot("The tale of the tape", "Between the corners before the bell: age, height, reach, weight, record, stance, style.")
	await create_timer(14.0).timeout
	await _shot("The live round", "Watch it live: the clock, both boxers' energy rings and body maps, your calls on the bar.")
	_press(_any("SkipBout"))
	await create_timer(3.0).timeout
	# S375: Skip bout now lands on the result itself; a Scorecards step is shot only while the game still has one.
	if _any("Scorecards") != null:
		await _shot("The scorecards", "")
		_press(_any("Scorecards"))
		await create_timer(1.5).timeout
	await _shot("The result", "Who won, on what, and what decided it; the body report says what to train next.")
	_press(_any("BackHome"))
	main.act("goaltalk", fid)
	await _shot("The office - the next goal", "Talk it through and set the next goal: the loop starts again.")
	if not main.modal.is_empty():
		main.act("close")
	# Ana, the no-gi athlete on the mat: the road to black belt.
	main.act("fighter", "ana")
	await _shot("Ana - the road to black belt", "Her belts and stripes, mat time, the syllabus move by move, the coach's call and her record in opens.")


## The game's own housekeeping between days (TestJump._tidy): close the week review, answer goal talks.
func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for x in c.fighters:
		if bool(x["goal_talk"]):
			main.act("goaltalk", x["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")


func _shot(title: String, what: String) -> void:
	main.clear_toast()
	main.render()
	await create_timer(0.7).timeout
	await RenderingServer.frame_post_draw
	n += 1
	var name := "step_%02d.png" % n
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("TOUR %s | %s | %s | screen=%s modal=%s route=%s" % [name, title, what, main.screen, main.modal.get("type", ""),
		main.route])


func _press(b: Button) -> void:
	if b != null and not b.disabled:
		b.emit_signal("pressed")
	else:
		print("TOUR_MISS a button was missing or grey at step %d" % n)


func _shell_button(name: String) -> Button:
	return main._shell.find_child(name, true, false) as Button


func _modal_button(name: String) -> Button:
	var m: Node = main.modal_node()
	return null if m == null else m.find_child(name, true, false) as Button


## A button anywhere in the game (the 3D fight's bar and corner live in the fight view's own overlay, not the modal).
func _any(name: String) -> Button:
	var b := _modal_button(name)
	return b if b != null else root.find_child(name, true, false) as Button


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
