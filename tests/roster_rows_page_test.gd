extends SceneTree
## PAGES2B: Fighters > Roster as painted rows, the Roster's default view. Main at 1920x1080: one row a fighter; each
## column shows the value the game's own reads give (fatigue, morale, weight, the offer's own days and answer-by, Coach's
## check, the goal read, the first need); the face pin is a round 120 disc; every word is a visible Label (no hidden
## placeholders); nothing past x 1920; no font under 16; SlateWalk clean; a click through the viewport on a row's words
## opens her page; the DO NEXT pin of the fighter with an open offer opens that offer.
## S440 round 3: every column of every row holds a visible word or number; every row's DO NEXT is one real button and a
## click through the viewport opens its place (the offer, the week planner, the Fights page's open entry, her page);
## "No bout" says when the next offers come (NextOffer.day).
##   python ops/Tools/godot_slot.py run --who claude -- <godot.exe> --headless --audio-driver Dummy --path .
##       --script res://tests/roster_rows_page_test.gd
## Still (windowed, on the hidden desktop): add `-- <dir or file.png>`.

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const NextOffer := preload("res://scripts/rules/NextOffer.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const FighterPage := preload("res://scripts/ui/areas/FighterPage.gd")

const COLS := ["fighter", "overall", "tiredness", "weight", "mood", "coach", "next_fight", "do_next"]

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = MAIN.instantiate()
	root.add_child(main)
	await _settle(4)
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	FirstWeek.ana_joins(c)
	# A second boxer (a scouted prospect signed, as a trial does), so the roster has a best of each group (the gold dot).
	var p2: Dictionary = c.prospects[0]
	Roster.sign_fighter(c, p2, ["Jab and move", "Body work", "Pad rounds"])
	p2["state"] = "signed"
	# An open offer on Lucy: the bout 21 days out, to be answered within 5.
	var lucy: Dictionary = c.fighters[0]
	var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var offer := Bouts._offer("lucy:rows", opp, c.day + 21, c.day + 5, 4)
	offer["mismatch"] = false
	lucy["offers"] = [offer]
	main.act("go", "fighters:0")   # no view forced: the rows are the Roster's default
	await _settle(6)
	root.size = Vector2i(1920, 1080)
	var page := main.find_child("Fighters", true, false) as Control
	_check(page != null, "Fighters draws")
	if page == null:
		_done()
		return
	_check(page.find_child("RowHeaders", true, false) != null and page.find_child("CardLine", true, false) == null, "the Roster opens on the painted rows")
	_check(page.find_children("Sort_*", "", true, false).is_empty(), "no header pretends to sort")
	WoodKit.ink(page)
	await _settle(3)

	var ids: Array = []
	for f in c.fighters:
		ids.append(str(f["id"]))
	for g in c.grapplers:
		ids.append(str(g["id"]))
	_check(ids.size() >= 2, "career has boxers and the no-gi athlete (%d)" % ids.size())
	for id in ids:
		_row_checks(c, page, id)
	_lucy_checks(c, page, offer)
	_gold_dots(c, page)
	_ana_checks(c, page)
	var first := page.find_child("Row_" + str(ids[0]), true, false) as Control
	_check(first != null and absf(first.get_global_rect().position.y - 190.0) <= 16.0,
		"the first row sits near the painting's y 190 (%.0f)" % (first.get_global_rect().position.y if first != null else -1.0))
	var key := page.find_child("KeyLine", true, false)
	_check(key != null and _texts(key).contains("best of the roster") and _texts(key).contains("needs you"), "the key line under the rows")
	var past := _past_edge(page)
	_check(past == "", "no visible Control ends past x 1920 (%s)" % past)

	_check(_min_font(page) >= 16, "no font under 16 (min %d)" % _min_font(page))
	for fault in SlateWalk.faults(page):
		_check(false, "slate: " + str(fault))

	# A click through the viewport on Lucy's name plate (a word, not the pin) opens her page.
	var plate := page.find_child("Row_lucy", true, false).find_child("NamePlate", true, false) as Control
	await _click(plate.get_global_rect().get_center())
	await _settle(4)
	_check(str(main.route.get("fighter", "")) == "lucy", "clicking a row's words opens that fighter's page (route=%s)" % main.route)
	# Every row's DO NEXT, clicked through the viewport, opens its own place.
	for id in ids:
		await _press_do_next(c, str(id), offer)

	var args := OS.get_cmdline_user_args()
	if not args.is_empty() and DisplayServer.get_name() != "headless":
		await _still(str(args[0]))
	_done()


## Every column of one row holds the game's own value, in visible Labels.
func _row_checks(c: Career, page: Control, id: String) -> void:
	var row := page.find_child("Row_" + id, true, false) as Control
	_check(row != null, "row for %s" % id)
	if row == null:
		return
	_check(row.get_global_rect().end.x <= 1920.5, "%s ends at x %.0f" % [row.name, row.get_global_rect().end.x])
	for col in COLS:
		var cell := row.find_child("Col_" + col, true, false)
		_check(cell != null and _filled(cell), "%s Col_%s holds a visible word or number" % [id, col])
	var hidden := 0
	for l in row.find_children("*", "Label", true, false):
		if not (l as Label).is_visible_in_tree() or str(l.name).begins_with("Cell_"):
			hidden += 1
	_check(hidden == 0, "%s carries no hidden placeholder Label (%d)" % [id, hidden])
	var f: Dictionary = c.fighter_by_id(id)
	if f.is_empty():
		f = c.grappler_by_id(id)
	var data: Dictionary = RosterRow.row(c, id)
	var pin := row.find_child("FacePin", true, false) as Control
	_check(pin != null and absf(pin.size.x - 120.0) < 1.0 and absf(pin.size.y - 120.0) < 1.0,
		"%s face pin is a round 120 disc (%s)" % [id, str(pin.size) if pin != null else "none"])
	_check(_text(row, "Name") == str(f["name"]), "%s name plate reads %s" % [id, f["name"]])
	_check(_text(row, "Record") == "%d-%d%s" % [int(f.get("w", 0)), int(f.get("l", 0)), " pro" if bool(f.get("pro", false)) else ""],
		"%s record reads %s" % [id, _text(row, "Record")])
	var groups: Dictionary = data["overall"]["groups"]
	for g in groups:
		var bar := row.find_child("Bar_" + str(g), true, false)
		_check(bar != null and _text(bar, "Word") == str(g) and _text(bar, "Num") == str(int(floorf(float(groups[g])))),
			"%s bar %s is named and reads %d" % [id, g, int(floorf(float(groups[g])))])   # S443: whole numbers as the fighter page prints them
	var ring := row.find_child("OverallRing", true, false)
	if str(f.get("sport", "")) != "bjj":
		_check(ring != null and str(ring.get("big")) == str(int(floorf(Attrs.weighted(Attrs.of(f))))), "%s ring is the measured level, as the fighter page prints it" % id)
	var tired := row.find_child("Col_tiredness", true, false)
	_check(_text(tired, "Big") == str(int(round(FighterProfile.fatigue(f)))), "%s tiredness reads the fatigue (%s)" % [id, _text(tired, "Big")])
	_check(_text(tired, "Word") == str(data["tiredness"]["word"]), "%s tiredness word" % id)
	var mood := row.find_child("Col_mood", true, false)
	var morale := float(f.get("morale", FighterProfile.MORALE_START))
	_check(_text(mood, "Big") == str(int(round(morale))) and _text(mood, "Word") == FighterProfile.mood(morale), "%s mood reads the morale" % id)
	var weight := row.find_child("Col_weight", true, false)
	if str(data["weight"]["tone"]) == "muted":
		_check(_text(weight, "Word") == str(f.get("wc", "")).replace(" (no-gi)", "") and weight.find_child("Big", true, false) == null,
			"%s weight cell names her class, no kg (%s)" % [id, _text(weight, "Word")])
	else:
		_check(_text(weight, "Big") == "%.1f" % float(f["weight"]), "%s weight reads %.1f kg" % [id, float(f["weight"])])
	var coach := row.find_child("Col_coach", true, false)
	_check(_text(coach, "Said") == str(data["coach"]["word"]) and _text(coach, "Said") != "", "%s Coach says '%s'" % [id, _text(coach, "Said")])
	var tag := _text(coach, "TagWord")
	_check(["", "FIX", "REST", "DRILL"].has(tag), "%s coach tag is FIX, REST or DRILL ('%s')" % [id, tag])
	var goal: Dictionary = Sim.goal_read(c, f) if str(f.get("sport", "")) != "bjj" else {}
	if not goal.is_empty():
		var gr := coach.find_child("GoalRing", true, false)
		_check(gr != null and absf(float(gr.get("value")) - clampf(float(goal["share"]), 0.0, 1.0)) < 0.001,
			"%s goal ring is the goal read's share" % id)
		_check(_text(coach, "GoalTitle").contains(str(goal["title"])) and _text(coach, "GoalLeft") == "%d days left" % int(goal["left"]),
			"%s goal line: title and days left" % id)


## Lucy's offer: days to the bout large, the answer-by its own line, DO NEXT in its own words.
func _lucy_checks(c: Career, page: Control, offer: Dictionary) -> void:
	var row := page.find_child("Row_lucy", true, false) as Control
	if row == null:
		return
	var nf := row.find_child("Col_next_fight", true, false)
	_check(_text(nf, "Big") == str(int(offer["day"]) - c.day), "the offer's big number is the days to the bout (%s)" % _text(nf, "Big"))
	_check(_text(nf, "TagWord") == "OFFER", "the offer carries the OFFER tag")
	_check(_text(nf, "Opp").begins_with(str(offer["opp"]["name"])), "the opponent is named")
	_check(_text(nf, "Date") == Clock.fmt(int(offer["day"])), "the bout's date")
	_check(_text(nf, "AnswerBy") == "answer by " + Clock.fmt(int(offer["expires"])), "the answer-by line (%s)" % _text(nf, "AnswerBy"))
	var pin := row.find_child("DoNext", true, false) as Button
	_check(pin != null and pin.text == "Answer offer", "DO NEXT says what the press does (%s)" % (pin.text if pin != null else "none"))
	var ana := page.find_child("Row_ana", true, false)
	if ana != null:
		var anf := ana.find_child("Col_next_fight", true, false)
		_check(_text(anf, "Word") == "No open entered" and anf.find_child("Tag", true, false) == null, "no OPEN tag without an entered open")
	_check(row.find_child("NeedBadge", true, false) != null, "the need badge sits on the face pin")


func _text(n: Node, child: String) -> String:
	if n == null:
		return ""
	var l := n.find_child(child, true, false) as Label
	return l.text if l != null else ""


func _min_font(n: Node) -> int:
	var m := 99
	if n is Control and (n as Control).is_visible_in_tree() and (n is Label or n is Button):
		var text := (n as Label).text if n is Label else (n as Button).text
		if str(text).strip_edges() != "":
			m = (n as Control).get_theme_font_size("font_size")
	for c in n.get_children():
		m = mini(m, _min_font(c))
	return m


## A real left click (press, release) through the viewport, so the GUI's own hit test routes it.
func _click(pos: Vector2) -> void:
	var move := InputEventMouseMotion.new()
	move.position = pos
	move.global_position = pos
	root.push_input(move)
	for down in [true, false]:
		var ev := InputEventMouseButton.new()
		ev.button_index = MOUSE_BUTTON_LEFT
		ev.pressed = down
		ev.position = pos
		ev.global_position = pos
		root.push_input(ev)
		await process_frame


func _still(where: String) -> void:
	main.act("guideskip")
	main.close_modal()
	main.act("go", "fighters:0")
	await _settle(8)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path := where if where.ends_with(".png") else where.path_join("fighters_real.png")
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	root.get_texture().get_image().save_png(path)
	print("ROSTER_ROWS_PAGE wrote ", path)


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: " + what)
	else:
		failures += 1
		print("  FAIL: " + what)


func _done() -> void:
	print("ROSTER_ROWS_PAGE failures=%d" % failures)
	print("PASS roster_rows_page_test" if failures == 0 else "FAIL roster_rows_page_test")
	quit(1 if failures > 0 else 0)



## The gold dot: on each group's bar of the boxer RosterRow.best_of names, on no other boxer's bar.
func _gold_dots(c: Career, page: Control) -> void:
	var best: Dictionary = RosterRow.best_of(c)
	_check(not best.is_empty(), "two boxers: the roster has a best per group")
	var drawn := 0
	for f in c.fighters:
		var row := page.find_child("Row_" + str(f["id"]), true, false)
		for g in best:
			var bar := row.find_child("Bar_" + str(g), true, false) if row != null else null
			var want: bool = str(best[g]) == str(f["id"])
			_check(bar != null and bool(bar.get("gold_dot")) == want, "%s %s: gold dot %s" % [f["id"], g, "on" if want else "off"])
			if bar != null and bool(bar.get("gold_dot")):
				drawn += 1
	_check(drawn == best.size(), "one gold dot per group (%d of %d)" % [drawn, best.size()])


## The no-gi athlete: Coach drills the move her classes drill, the ring is the way to her next belt, and with no open
## entered NEXT FIGHT names the next open she can enter, untagged.
func _ana_checks(c: Career, page: Control) -> void:
	var g: Dictionary = c.grappler_by_id("ana")
	var row := page.find_child("Row_ana", true, false)
	if row == null or g.is_empty():
		_check(false, "Ana's row")
		return
	var coach := row.find_child("Col_coach", true, false)
	var m: String = NoGi.drilling(g, c.day)
	_check(_text(coach, "Said") == "Drill the %s" % NoGi.move_name(m).to_lower(), "Ana: Coach drills %s (%s)" % [m, _text(coach, "Said")])
	_check(_text(coach, "Sub").begins_with(NoGi.move_name(m)), "Ana: the drilled move's mastery under it (%s)" % _text(coach, "Sub"))
	var gr := coach.find_child("GoalRing", true, false)
	var share := float(BeltRoad.readiness(g, g.get("bjj", {}), c.day)["share"])
	_check(gr != null and absf(float(gr.get("value")) - share) < 0.001, "Ana: the ring is the way to her next belt")
	var nf := row.find_child("Col_next_fight", true, false)
	var nx: Dictionary = NoGi.opens_after(c.day + 1, 1)[0]
	_check(_text(nf, "Big") == str(int(nx["d"]) - c.day) and _text(nf, "Opp").begins_with(str(nx["name"])),
		"Ana: the next open she can enter, %s in %d days (%s)" % [nx["name"], int(nx["d"]) - c.day, _text(nf, "Big")])


func _texts(n: Node) -> String:
	var out := ""
	for l in n.find_children("*", "Label", true, false):
		out += (l as Label).text + " "
	return out


## The first visible Control under the page whose rect ends past x 1920, or "".
func _past_edge(n: Node) -> String:
	if n is Control and (n as Control).is_visible_in_tree() and (n as Control).get_global_rect().end.x > 1920.5:
		return "%s ends at %.0f" % [n.get_path(), (n as Control).get_global_rect().end.x]
	for ch in n.get_children():
		var hit := _past_edge(ch)
		if hit != "":
			return hit
	return ""


## A visible Label or Button with words under `n`.
func _filled(n: Node) -> bool:
	for x in n.find_children("*", "", true, false):
		if (x is Label or x is Button) and (x as Control).is_visible_in_tree():
			if str((x as Label).text if x is Label else (x as Button).text).strip_edges() != "":
				return true
	return false


## Is one of Needs' lines this fighter's (the row's own owner rule)?
func _has_need(c: Career, f: Dictionary) -> bool:
	for n in Needs.needs(c):
		if RosterRow._need_for(c, f, n):
			return true
	return false


## One row's DO NEXT: its words, then a real click through the viewport, then the place it opened.
func _press_do_next(c: Career, id: String, offer: Dictionary) -> void:
	main.close_modal()
	main.act("go", "fighters:0")
	await _settle(4)
	var page := main.find_child("Fighters", true, false) as Control
	var row: Node = page.find_child("Row_" + id, true, false) if page != null else null
	var pin: Button = row.find_child("DoNext", true, false) as Button if row != null else null
	_check(pin != null and pin.text != "" and not pin.disabled, "%s: DO NEXT is a real button (%s)" % [id, pin.text if pin != null else "none"])
	if pin == null:
		return
	var f: Dictionary = c.fighter_by_id(id)
	if f.is_empty():
		f = c.grappler_by_id(id)
	var d: Dictionary = RosterRow.row(c, id)["do_next"]
	var bjj: bool = str(f.get("sport", "")) == "bjj"
	if id == "lucy":
		_check(str(d["act"]) == "openBout" and str(d["arg"]) == str(offer["id"]), "lucy: the offer is the thing to do")
	elif not _has_need(c, f) and bjj and (f.get("entered", []) as Array).is_empty():
		_check(pin.text == "Enter the open", "%s: an open not entered -> Enter the open (%s)" % [id, pin.text])
	elif not _has_need(c, f) and not bjj and (f.get("bout", {}) as Dictionary).is_empty():
		_check(pin.text == "Plan the week", "%s: no bout, no offer -> Plan the week (%s)" % [id, pin.text])
		var nf := row.find_child("Col_next_fight", true, false)
		var nd: int = NextOffer.day(c, f)
		_check(nd > c.day and _text(nf, "Word") == "No bout" and _text(nf, "NextOffers") == "next offers " + Clock.fmt(nd),
			"%s: No bout, next offers %s (%s)" % [id, Clock.fmt(nd), _text(nf, "NextOffers")])
	var words: String = pin.text   # the page redraws on the click: the pin is gone after it
	var before: Dictionary = main.route.duplicate()
	await _click(pin.get_global_rect().get_center())
	await _settle(5)
	var r: Dictionary = main.route
	match str(d["act"]):
		"openBout":
			_check(str(r.get("area", "")) == "fights" and str(r.get("bout", "")) == str(d["arg"]), "%s: DO NEXT opens the offer (route=%s)" % [id, r])
		"planweek":
			_check(str(r.get("fighter", "")) == id and int(r.get("ftab", -1)) == FighterPage.TRAINING_TAB,
				"%s: DO NEXT opens the week planner on her (route=%s)" % [id, r])
		"fighter":
			_check(str(r.get("fighter", "")) == str(d["arg"]), "%s: DO NEXT opens her page (route=%s)" % [id, r])
		"go":
			var want := str(d["arg"]).get_slice(":", 0)
			_check(str(r.get("area", "")) == want, "%s: DO NEXT opens %s (route=%s)" % [id, want, r])
			if bjj and words == "Enter the open":
				var ent := main.find_children("Enter_%s_*" % id, "Button", true, false)
				_check(not ent.is_empty() and (ent[0] as Control).is_visible_in_tree(), "%s: the open's Enter button is on the page it opened" % id)
		_:
			_check(r != before or not main.modal.is_empty(), "%s: DO NEXT %s opened something (route=%s)" % [id, d["act"], r])
