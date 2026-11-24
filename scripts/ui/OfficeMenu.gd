extends RefCounted
## OFFICEV2 (S538, owner Q-S294-302: "when plqayer right clicks on a name can do various actions"; mockup
## ops/previews/s538_look/office_sheets_menu.png). The right-click menu of the office sheets. Every line is an act the game
## already has, run the way its own screen runs it (Main.act, or the same Main.nav); a line that cannot be done now is grey
## and says why. Nothing here is a new rule. Not in this build (no such act in the game): releasing a fighter, letting the
## club coach go.
##   fighter_items(c, id) / staff_items(c, row) -> [{t, sub, act, arg, nav, why ("" = can be done), opens}]
##       opens = what running it shows: "route:<area>", "modal:<type>", "board" (the plan board over the game), "state"
##   open(main, at, title, items) -> the menu "OfficeMenu" over the game; a click outside closes it     run(main, item)
##   layer(main, at, node_name) -> [layer, box]: the same floating card, for the sheet's column chooser

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const FIGHT_PREP_TAB := 5   # FighterPage.TABS: "Fight prep"
const WIDTH := 470


static func fighter_items(c: Career, id: String) -> Array:
	var out: Array = []
	var f := c.fighter_by_id(id)
	if f.is_empty():   # the no-gi athlete: her page is what the game has for her
		out.append(_item("Open the fighter page", "opens Fighter", "fighter", id, "route:fighters"))
		return out
	var offer: Dictionary = RosterRow._open_offer(f)
	if not offer.is_empty():
		out.append(_item("See the bout offer", "opens Fights: the offer", "openBout", str(offer["id"]), "route:fights"))
	out.append(_item("Open the fighter page", "opens Fighter", "fighter", id, "route:fighters"))
	out.append(_item("Fight plan", "opens the plan board", "plan", id, "board"))
	var week := _item("This week's training", "opens Training: the week", "", "", "route:training")
	week["nav"] = {"area": "training", "tab": 0, "fighter": id}
	out.append(week)
	var no_goal := (f.get("goal", {}) as Dictionary).is_empty()
	var g: Dictionary = {} if no_goal else Sim.goal_read(c, f)
	out.append(_item("Goal talk", "opens the goal talk", "goaltalk", id, "modal:goaltalk",
		"" if bool(f.get("goal_talk", false)) else ("no talk waiting yet" if no_goal else "the goal runs to %s" % Clock.fmt(c.day + int(g["days_left"])))))
	var booked: bool = (f.get("bout", {}) as Dictionary).has("day")
	out.append(_item("Watch the tape", "opens Fight analysis", "taperoom", id, "board", "" if booked else "no bout booked yet"))
	out.append(_item("Enter the nationals", "enters now: the draw is on World", "enterchamp", id, "state", _low(Champs.cannot_enter(c, f))))
	out.append(_item("Change the stipend", "opens Finance: stipends", "go", "money:0", "route:money", "a pro lives on purses" if bool(f.get("pro", false)) else ""))
	var study := _item("Study the opponent", "opens Fight prep", "", "", "route:fighters", "" if booked else "no bout booked yet")
	study["nav"] = {"area": "fighters", "tab": 0, "fighter": id, "ftab": FIGHT_PREP_TAB}
	out.append(study)
	var mine := not c.pro_offer.is_empty() and str(c.pro_offer.get("fid", "")) == id
	out.append(_item("Hear the pro offer", "opens the pro offer", "prooffer", id, "modal:prooffer", "" if mine else ("already a pro" if bool(f.get("pro", false))
		else "needs %d wins and a top %d rank" % [Roster.PRO_WINS, Roster.PRO_RANK])))
	return out


## row = one of OfficeDesk.staff_sheet's rows ({id, kind}).
static func staff_items(c: Career, row: Dictionary) -> Array:
	var out: Array = []
	var id := str(row["id"])
	match str(row["kind"]):
		"hire":
			out.append(_item("Hire", "%s to sign" % GameMoney.text(GameMoney.COACH_SIGNING_FEE), "hire", id, "state",
				"" if c.coach.is_empty() else "the gym coach's place is taken"))
		"open":
			var r: Dictionary = StaffRoles.role(id)
			out.append(_item("Hire", "%s a pro night" % GameMoney.text(int(r["per_bout"])) if int(r["per_bout"]) > 0 else "%s a week" % GameMoney.text(int(r["wage"])),
				"hirerole", id, "state"))
		"role":
			var notice := StaffRoles.notice(id)
			out.append(_item("Let go", "a week's notice: %s" % GameMoney.text(notice) if notice > 0 else "the pay stops", "letgorole", id, "state"))
		"evening":
			out.append(_item("Add an evening coach", "%s a week" % GameMoney.text(StaffRoles.EVENING_WAGE),
				"eveningcoach", "add", "state"))
			out.append(_item("Let one go", "a week's notice: %s" % GameMoney.text(StaffRoles.EVENING_WAGE), "eveningcoach", "cut", "state",
				"" if c.extra_coaches > 0 else "no evening coach to let go"))
	out.append(_item("Open the staff page", "opens Staff: the cards", "go", "gym:1", "route:gym"))
	return out


static func _item(t: String, sub: String, act: String, arg: String, opens: String, why: String = "") -> Dictionary:
	return {"t": t, "sub": sub, "act": act, "arg": arg, "nav": {}, "why": why, "opens": opens}


static func _low(s: String) -> String:
	return s.left(1).to_lower() + s.substr(1)


## Runs a line the way the game runs it. false = it was grey.
static func run(main: Node, item: Dictionary) -> bool:
	if str(item.get("why", "")) != "":
		return false
	close(main)
	if not (item.get("nav", {}) as Dictionary).is_empty():
		main.nav(item["nav"])
	else:
		main.act(str(item["act"]), str(item["arg"]))
	return true


static func close(main: Node) -> void:
	for n in main.get_children():
		if n.has_meta("office_layer"):
			main.remove_child(n)
			n.queue_free()


## A floating card over the whole game at `at` (kept on screen); a click anywhere outside it closes it.
static func layer(main: Node, at: Vector2, node_name: String) -> Array:
	close(main)
	var back := Control.new()
	back.name = node_name
	back.set_meta("office_layer", true)
	back.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	back.mouse_filter = Control.MOUSE_FILTER_STOP
	back.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed:
			close(main))
	var card := PanelContainer.new()
	card.name = "Card"
	card.add_theme_stylebox_override("panel", UI.box(Palette.HOVER, Palette.HEADER, 8, 1, 6, 8))
	back.add_child(card)
	var box := UI.vbox(2)
	card.add_child(box)
	main.add_child(back)
	var place := func():
		var room: Vector2 = main.get_viewport_rect().size
		card.position = Vector2(clampf(at.x, 8.0, maxf(8.0, room.x - card.size.x - 8.0)), clampf(at.y, 8.0, maxf(8.0, room.y - card.size.y - 8.0)))
	card.resized.connect(place)
	place.call_deferred()
	return [back, box]


static func open(main: Node, at: Vector2, title: String, items: Array) -> Control:
	var made := layer(main, at, "OfficeMenu")
	var box: VBoxContainer = made[1]
	box.custom_minimum_size = Vector2(WIDTH, 0)
	var head := MarginContainer.new()
	head.add_theme_constant_override("margin_left", 10)
	head.add_theme_constant_override("margin_bottom", 4)
	head.add_child(UI.label(title.to_upper(), 16, Palette.HEADER, "caps"))
	box.add_child(head)
	for i in items.size():
		box.add_child(_line(main, items[i], i))
	return made[0]


static func _line(main: Node, item: Dictionary, i: int) -> Button:
	var grey := str(item["why"]) != ""
	var b := Button.new()
	b.name = "Item_%d" % i
	b.focus_mode = Control.FOCUS_NONE
	b.disabled = grey
	b.custom_minimum_size = Vector2(0, 34)
	b.mouse_default_cursor_shape = Control.CURSOR_ARROW if grey else Control.CURSOR_POINTING_HAND
	for st in ["normal", "hover", "pressed", "disabled"]:
		b.add_theme_stylebox_override(st, UI.box(Palette.TILE if st in ["hover", "pressed"] else Palette.CLEAR, Palette.CLEAR, 5, 0, 10, 2))
	var h := UI.hbox(16)
	h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(UI.label(str(item["t"]), 17, Palette.MUTED if grey else Palette.TEXT, "body" if grey else "bold"))
	var sub := UI.label(str(item["why"]) if grey else str(item["sub"]), 16, Palette.MUTED)
	sub.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	sub.clip_text = true
	sub.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	h.add_child(sub)
	b.tooltip_text = str(item["why"]).capitalize() + "." if grey and str(item["why"]).length() > 34 else ""
	b.add_child(h)
	if grey:
		h.modulate = Palette.fade(0.7)
	b.pressed.connect(func(): run(main, item))
	return b
