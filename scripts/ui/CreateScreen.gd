extends CenterContainer
## New career in two steps (S397 rank 5, P12; ops/research/RANK5_FIRST_HOUR_S397.md section 3; operator Q-S294-121 "Yes"):
##   1. YOU - your name and one of four head coaches on photo cards (HeadCoach: one clear edge each, said as a result, with
##      the moment it is first felt). The photos are the corner's own MetaHumans (tools/bake_promo.gd stems=mh_staff_*).
##   2. YOUR CLUB - city, gym name and one of three starts (ClubStart: the start doubles as difficulty).
## Main.create holds the picks: {step, country, city, gym, name, coach, start}.

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Data := preload("res://scripts/state/Data.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")

const COUNTRIES := ["United Kingdom", "Ireland", "United States", "Mexico"]
const CITIES := {
	"United Kingdom": ["London", "Manchester", "Liverpool", "Glasgow"],
	"Ireland": ["Dublin", "Belfast", "Cork", "Limerick"],
	"United States": ["Philadelphia", "Las Vegas", "Detroit", "Brooklyn"],
	"Mexico": ["Guadalajara", "Mexico City", "Tijuana", "Monterrey"],
}
const COACH_CARD := Vector2(392, 0)
const START_CARD := Vector2(528, 0)
const PLAN_CARD := Vector2(392, 0)
const PLAN_PIC := Vector2(348, 142)   # 8 px less than the paper card: the slate frame is 22 px, the old pad was 18
const IsoGym := preload("res://scripts/ui/IsoGym.gd")
const GymPlan := preload("res://scripts/rules/GymPlan.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")

var _name_edit: LineEdit
var _gym_edit: LineEdit


func build(main: Node) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var s: Dictionary = main.create
	var step := int(s["step"])
	var v := UI.vbox(14)
	v.custom_minimum_size = Vector2(1640, 860)   # S397 round 1 (blind: "the bar sits at a different height on 02 and 03"): one fixed frame
	var board := PanelContainer.new()
	board.name = "CreateBoard"
	# The step sits on one framed slate. Pad is the 22 px frame, so the column grows by the frame only.
	board.add_theme_stylebox_override("panel", WoodKit.slate(22, 22))
	board.add_child(v)
	add_child(board)
	# S397 round 1 (blind: "the stepper sits at a different height on 02 and 03"): one labelled stepper, same place on both.
	var steps := UI.hbox(8)
	for i in 2:
		var cell := UI.vbox(4)
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var bar := ColorRect.new()
		bar.color = WoodKit.HEAD if i <= step else Color(WoodKit.SOFT, 0.35)
		bar.custom_minimum_size = Vector2(0, 5)
		cell.add_child(bar)
		cell.add_child(UI.label(["1  You, the head coach", "2  Your club and its start"][i], UI.SMALL, UI.GOLD if i == step else UI.MUTED, "semi"))
		steps.add_child(cell)
	v.add_child(steps)
	var nav := UI.hbox(10)
	if step == 0:
		_you(main, v, s)
		nav.add_child(UI.button("Back to title", "BtnQuiet", main.act.bind("title", "")))
		nav.add_child(UI.spacer())
		var next := UI.button("Next: your club", "BtnSolid", func(): _keep(main); main.act("cstep", "1"))
		next.name = "CreateNext"
		nav.add_child(next)
	else:
		_club(main, v, s)
		nav.add_child(UI.button("Back", "BtnQuiet", func(): _keep(main); main.act("cstep", "0")))
		nav.add_child(UI.spacer())
		var skip := CheckButton.new()   # S397 round 1: the veteran's switch moved here from the title
		skip.name = "SkipGuide"
		skip.text = "Skip the first-hour guide"
		skip.button_pressed = FirstWeek.skip_on()
		skip.toggled.connect(FirstWeek.set_skip)
		var skip_box := UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, 10, 4)
		for state in ["normal", "hover", "pressed", "disabled", "focus"]:
			skip.add_theme_stylebox_override(state, skip_box)
		for fc in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
			skip.add_theme_color_override(fc, WoodKit.INK)
		nav.add_child(skip)
		var go := UI.button("Open the gym", "BtnSolid", func(): _keep(main); main.act("cstart", str(main.create.get("gym", ""))))
		go.name = "CreateStart"
		nav.add_child(go)
	v.add_child(nav)


## Step 1: your name, then the four coaches.
func _you(main: Node, v: VBoxContainer, s: Dictionary) -> void:
	var head := UI.hbox(24)
	var title := UI.vbox(2)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_child(UI.display("1. YOU, THE HEAD COACH", 50))
	title.add_child(UI.muted("You run the club and stand in the corner on fight night. Your past gives you one edge for the whole career.", UI.BODY, true))
	head.add_child(title)
	var name_box := UI.vbox(4)
	name_box.add_child(UI.caps("YOUR NAME"))
	_name_edit = LineEdit.new()
	_name_edit.name = "CoachName"
	_name_edit.placeholder_text = HeadCoach.DEFAULT_NAME
	_name_edit.text = str(s.get("name", "")) if str(s.get("name", "")) != "" else HeadCoach.DEFAULT_NAME   # a real name, ready to keep
	_name_edit.select_all_on_focus = true
	_name_edit.max_length = 24
	_name_edit.custom_minimum_size = Vector2(360, 48)
	_dark_line(_name_edit)
	name_box.add_child(_name_edit)
	head.add_child(name_box)
	v.add_child(head)
	var row := UI.hbox(16)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	var pick := str(s.get("coach", HeadCoach.CARDS[0]["id"]))
	for cd in HeadCoach.CARDS:
		row.add_child(_coach_card(main, cd, str(cd["id"]) == pick))
	v.add_child(row)


## HeadCoach.free_tells + Bouts.read_on_booking: the ex-pro opens the best weapon (OppFile.tape's first hidden tell) the day a bout is booked.
func _chip_words(cd: Dictionary) -> String:
	if str(cd.get("id", "")) == "expro":
		return "Best weapon known at booking"
	return str(cd.get("chip", ""))


func _plain_words(cd: Dictionary) -> String:
	return str(cd.get("plain", "")).replace("on file", "on the scouting report")


func _coach_card(main: Node, cd: Dictionary, on: bool) -> Control:
	var box := _card_shell("Coach_" + str(cd["id"]), on, COACH_CARD)
	var col := UI.vbox(8)
	box.get_child(0).add_child(col)
	var pic := PromoShot.picture(str(cd["photo"]), Vector2(COACH_CARD.x - 44, 292))
	if pic != null:
		col.add_child(pic)
	var top := UI.hbox(8)
	top.add_child(UI.label(str(cd["title"]).to_upper(), 26, UI.FG, "bold"))
	top.add_child(UI.spacer())
	if on:
		top.add_child(UI.chip("✓ SELECTED", "gold"))
	elif bool(cd["first"]):
		top.add_child(UI.chip("BEST FIRST GAME", ""))
	col.add_child(top)   # (round 5: no extra badge row - every card's text starts at the same height)
	col.add_child(_wrap(str(cd["past"]), UI.SMALL, UI.FG, "italic"))
	col.add_child(_wrap(str(cd["edge"]), UI.BODY + 2, UI.GOLD, "bold"))
	col.add_child(UI.chip(_chip_words(cd).to_upper(), "gold" if on else ""))
	col.add_child(_wrap(_plain_words(cd), UI.SMALL, UI.FG, "body"))
	col.add_child(_wrap("First felt %s." % cd["felt"], UI.TINY, UI.MUTED, "body"))
	_overlay(box, func(): _keep(main); main.act("cpick", "coach|" + str(cd["id"])))
	return box


## Step 2: where, the gym's name, then the three starts.
func _club(main: Node, v: VBoxContainer, s: Dictionary) -> void:
	v.add_child(UI.display("2. YOUR CLUB", 50))
	if str(s["city"]) == "":   # a new country: its first city until the player picks one
		s["city"] = CITIES[s["country"]][0]
	var where := UI.hbox(30)
	var place := UI.vbox(6)
	place.add_child(UI.caps("COUNTRY"))
	place.add_child(_choices(main, COUNTRIES, "country", str(s["country"])))
	place.add_child(UI.caps("CITY"))
	place.add_child(_choices(main, CITIES[s["country"]], "city", str(s["city"])))
	where.add_child(place)
	var gym := UI.vbox(6)
	gym.add_child(UI.caps("GYM NAME"))
	_gym_edit = LineEdit.new()
	_gym_edit.name = "GymName"
	_gym_edit.placeholder_text = "Anvil Street Gym"
	_gym_edit.text = str(s.get("gym", "")) if str(s.get("gym", "")) != "" else "Anvil Street Gym"   # a filled value (round 4)
	_gym_edit.select_all_on_focus = true
	_gym_edit.max_length = 28
	_gym_edit.custom_minimum_size = Vector2(420, 48)
	_dark_line(_gym_edit)
	gym.add_child(_gym_edit)
	gym.add_child(UI.muted("The city is your club's home: it is on the posters, the news and the prospects' list.", UI.SMALL, true))
	where.add_child(gym)
	v.add_child(where)
	v.add_child(UI.caps("YOUR BUILDING - EACH GIVES THE CLUB ONE SMALL EDGE FOR THE WHOLE CAREER"))
	var plans := UI.hbox(16)
	plans.alignment = BoxContainer.ALIGNMENT_CENTER
	var chosen := str(GymBonus.plan(str(s.get("gym_plan", "")))["id"])
	for p in GymPlan.load_all():
		plans.add_child(_plan_card(main, p, str(p["id"]) == chosen))
	v.add_child(plans)
	v.add_child(UI.caps("HOW THE CLUB STARTS - IT IS ALSO HOW HARD THE FIRST YEAR IS"))
	var row := UI.hbox(16)
	var pick := ClubStart.valid(str(s.get("start", "fresh")))
	for cd in ClubStart.CARDS:
		row.add_child(_start_card(main, cd, str(cd["id"]) == pick))
	v.add_child(row)


## One building: its floor plan, drawn from the same data the game plays on, and the one edge it gives.
func _plan_card(main: Node, p: Dictionary, on: bool) -> Control:
	var box := _card_shell("Plan_" + str(p["id"]), on, PLAN_CARD)
	var col := UI.vbox(6)
	box.get_child(0).add_child(col)
	var pic: Control = IsoGym.new()
	pic.custom_minimum_size = PLAN_PIC
	pic.plan = p
	col.add_child(pic)
	var top := UI.hbox(8)
	top.add_child(UI.label(str(p["name"]).to_upper(), 22, UI.FG, "bold"))
	top.add_child(UI.spacer())
	if on:
		top.add_child(UI.chip("✓", "gold"))
	col.add_child(top)
	col.add_child(_wrap(str(p["bonus"]["words"]), UI.SMALL, UI.GOLD, "bold"))
	_overlay(box, func(): _keep(main); main.act("cpick", "gym_plan|" + str(p["id"])))
	return box


func _start_card(main: Node, cd: Dictionary, on: bool) -> Control:
	var box := _card_shell("Start_" + str(cd["id"]), on, START_CARD, false)
	var col := UI.vbox(8)
	box.get_child(0).add_child(col)
	var top := UI.hbox(8)
	top.add_child(UI.label(str(cd["title"]).to_upper(), 24, UI.FG, "bold"))
	top.add_child(UI.spacer())
	top.add_child(UI.chip(str(cd["level"]).to_upper(), {"fresh": "green", "debt": "red"}.get(str(cd["id"]), "amber")))
	col.add_child(top)
	if on:
		top.add_child(UI.chip("✓", "gold"))
	col.add_child(_wrap(str(cd["line"]), UI.SMALL, UI.FG, "body"))
	# S397 round 1 (designer's 8/10): the start in the rules' own numbers, and the walk-in it brings.
	var id := str(cd["id"])
	var bills: Dictionary = GymBills.week({"members": int(cd["members"]), "rent_mult": float(cd["rent"])})
	var nums := UI.hbox(18)
	for kv in [["BANK", UI.money(Career.start_cash(id))], ["MEMBERS", "%d" % int(cd["members"])],
			["DUES", "%s/wk" % UI.money(Membership.weekly_dues(int(cd["members"])))], ["RENT", "%s/wk" % UI.money(int(bills["rent"]))]] + 			([["LOAN", "-%s/wk" % UI.money(int(ClubStart.loan(id)[0]))]] if int(ClubStart.loan(id)[0]) > 0 else []):
		var cell := UI.vbox(0)
		cell.add_child(UI.label(str(kv[0]), UI.TINY, UI.MUTED, "semi"))
		cell.add_child(UI.label(str(kv[1]), UI.BODY, UI.FG, "bold"))
		nums.add_child(cell)
	col.add_child(nums)
	var w := ClubStart.walkin(id, Data.lucy())
	var who := UI.hbox(12)
	var pic := PromoShot.picture(Faces.stem(w), Vector2(64, 64))
	if pic != null:
		who.add_child(pic)
	# S398 round 3 (blind: "all three starts show the same walk-in row"): the row says what differs.
	var extra := ", every attribute +%d" % int(ClubStart.DEBT_STAT_BONUS) if id == "debt" else ""
	var wl := _wrap("Walk-in: %s, %d-%d%s, %.1f kg for the %.1f kg limit (%.1f over)" % [w["name"], int(w["w"]), int(w["l"]), extra,
		float(w["weight"]), float(w["limit"]), float(w["weight"]) - float(w["limit"])], UI.SMALL, UI.FG, "semi" if id == "debt" else "body")
	wl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	who.add_child(wl)
	col.add_child(who)
	col.add_child(_wrap(str(cd["bite"]), UI.SMALL, UI.RED if id != "fresh" else UI.GOLD, "bold"))
	_overlay(box, func(): _keep(main); main.act("cpick", "start|" + str(cd["id"])))
	return box


## A card on the slate. Coach and building cards are a framed slate with a 2 px gold rim when picked.
## The start cards use the see-through chalk outline: a second wooden frame on that dense row is too tight.
## Stylebox pad is 0 so the click covers the whole card; the margin child (still child 0) clears the frame.
func _card_shell(id: String, on: bool, size: Vector2, framed: bool = true) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = id
	p.custom_minimum_size = size
	var pad := 22 if framed else 18
	if framed:
		p.add_theme_stylebox_override("panel", WoodKit.slate(0, 0))
	else:
		var edge := Color(WoodKit.HEAD) if on else Color(WoodKit.SOFT, 0.35)
		p.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.04), edge, 4, 2 if on else 1, 0, 0))
	var m := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, pad)
	p.add_child(m)
	if framed and on:
		var rim := Panel.new()
		rim.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rim.add_theme_stylebox_override("panel", UI.box(Color(0, 0, 0, 0), WoodKit.HEAD, 4, 2, 0, 0))
		p.add_child(rim)
	return p


## A name box on the slate: dark fill, chalk letters, in every LineEdit state.
func _dark_line(edit: LineEdit) -> void:
	for state in ["normal", "read_only"]:
		edit.add_theme_stylebox_override(state, UI.box(Color(0, 0, 0, 0.35), Color(WoodKit.SOFT, 0.5), 4, 1, 12, 10))
	edit.add_theme_stylebox_override("focus", UI.box(Color(0, 0, 0, 0.35), WoodKit.HEAD, 4, 1, 12, 10))
	edit.add_theme_color_override("font_color", WoodKit.INK)
	edit.add_theme_color_override("font_selected_color", WoodKit.DARK_INK)
	edit.add_theme_color_override("font_placeholder_color", WoodKit.SOFT)
	edit.add_theme_color_override("font_uneditable_color", WoodKit.SOFT)
	edit.add_theme_color_override("caret_color", WoodKit.INK)
	edit.add_theme_color_override("selection_color", WoodKit.HEAD)


## The whole card is the button.
func _overlay(box: Control, cb: Callable) -> void:
	var b := UI.button("", "BtnQuiet", cb)
	b.flat = true
	b.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	b.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	b.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	b.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	box.add_child(b)


func _wrap(text: String, size: int, colour: Color, kind: String) -> Label:
	var l := UI.label(text, size, colour, kind, true)
	l.custom_minimum_size = Vector2(120, 0)
	return l


## The typed names survive a redraw (a card click redraws the screen).
func _keep(main: Node) -> void:
	if _name_edit != null:
		main.create["name"] = _name_edit.text.strip_edges()
	if _gym_edit != null:
		main.create["gym"] = _gym_edit.text.strip_edges()


func _choices(main: Node, items: Array, key: String, current: String) -> GridContainer:
	var g := GridContainer.new()
	g.columns = 4
	g.add_theme_constant_override("h_separation", 10)
	g.add_theme_constant_override("v_separation", 10)
	for item in items:
		var b := UI.button(item, "ChoiceOn" if item == current else "Choice", func(): _keep(main); main.act("cpick", "%s|%s" % [key, item]))
		b.custom_minimum_size = Vector2(196, 50)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		g.add_child(b)
	return g
