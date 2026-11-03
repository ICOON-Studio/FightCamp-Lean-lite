extends SceneTree
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
	main.career.seed = 1
	await _shot("HOME - what needs you", "The day, your cash and the big button: NEEDS YOU while a decision waits, CONTINUE runs the days.")
	main.act("go_btn")
	await _shot("A boxer walks in", "The interview: read the boxer, then pick three training cards from the gym.")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	await _shot("Three cards picked", "Sign: the boxer joins on the club stipend with a first goal.")
	_press(_modal_button("Sign"))
	main.act("go", "fighters:0")
	await _shot("FIGHTERS > Roster", "Every boxer on one card: form, weight, goal and next bout.")
	main.act("go", "gym:1")
	main.act("hire", "reid")
	await _shot("GYM > Staff - hire a coach", "Luke Reid, sessional: $1,000 to sign, $450 a week. A coach runs the training days.")
	main.act("go", "fighters:1")
	await _shot("FIGHTERS > Training - the week", "The week on the whiteboard: what each day trains and how hard.")
	main.act("fighter", "lucy")
	await _shot("The fighter page", "Numbers, body and goal. Every name in the game opens this page.")
	for i in range(1, 4):
		main.act("ftab", str(i))
		await _shot("The fighter page - tab %d" % (i + 1), "")
	main.act("go", "home:0")
	main.run_to_stop()
	if main.career.review_pending:
		main.act("review")
		await _shot("The week review", "Every Sunday: what was gained, what it cost and what comes next.")
		main.act("close")
	main.run_to_stop()
	await _shot("An offer arrives", "Offers block time: the button now reads NEEDS YOU.")
	main.act("go_btn")
	await _shot("FIGHTS > the bout page", "The opponent, the odds, the purse and the date. Accept or let it go.")
	_press(_shell_button("Accept"))
	await _shot("Booked", "A fight night is set; SET CAMP waits on the top bar.")
	main.act("camp")
	await _shot("Set the camp", "The camp's focus, sparring and film: what the weeks before the fight are for.")
	_press(_modal_button("StartCamp"))
	main.act("go", "fighters:2")
	await _shot("FIGHTERS > Fight camps", "The camp's weeks and what the tape has found on the opponent so far.")
	var kids := main.get_child_count()
	main.act("taperoom", str(main.career.fighter()["id"]))
	await create_timer(3.0).timeout
	await _shot("The tape room", "Watch the opponent's fights: each session finds one more thing.")
	# The tape room is a layer over the whole game (RosterActs "taperoom"), not a modal: take it off again.
	while main.get_child_count() > kids:
		var room := main.get_child(main.get_child_count() - 1)
		main.remove_child(room)
		room.queue_free()
	for i in 4:
		main.act("go", "playbook:%d" % i)
		await _shot(["PLAYBOOK > Moves", "PLAYBOOK > Game plan", "PLAYBOOK > Combos", "PLAYBOOK > Escapes"][i],
			["The move book: what the boxer can throw and how well.", "The plan for this fight, written as lines: at range X, do Y.",
			"Build combos and test them on a partner.", "How to get out of trouble: ropes, corners, clinch."][i])
	main.act("go", "home:0")
	var c: Career = main.career
	for i in 12:
		if Bouts.weigh_in_today(c, c.fighter()):
			break
		main.run_to_stop()
		if c.review_pending:
			main.act("review")
			main.act("close")
	main.act("go_btn")
	await _shot("The weigh-in", "The day before: make the weight or pay for it.")
	_press(_modal_button("Scale"))
	await _shot("On the scale", "")
	if c.fighter()["bout"].is_empty():
		return
	if not main.modal.is_empty():
		main.act("close")
	main.run_to_stop()
	main.act("go_btn")
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
	await _shot("The scorecards", "")
	_press(_any("Scorecards"))
	await create_timer(1.5).timeout
	await _shot("The result", "Who won, on what, and what decided it; the body report says what to train next.")
	_press(_any("BackHome"))
	main.act("goaltalk")
	await _shot("The office - the next goal", "Talk it through and set the next goal: the loop starts again.")


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
