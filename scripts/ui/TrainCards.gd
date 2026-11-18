extends RefCounted
## S496 TRAININGK1: the Training screen's fighter strip - one card per fighter (face, NAME, class, bout, the week's kind,
## the coach's minutes this week, the tiredness sparkline). A boxer's card is a button: it selects her week below. The
## grappler's card shows her mat week (the mat coach runs it; the boxing coach's evenings are not hers); a click opens her
## page, where the player picks what her classes drill (S505).
##   make(model, on_pick: Callable(fid)) -> HBoxContainer

const B := preload("res://scripts/ui/TrainBits.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")

const H := 88


static func make(model: Dictionary, on_pick: Callable) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "TrainCards"
	row.add_theme_constant_override("separation", 10)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for cd in model["cards"]:
		row.add_child(card(cd, str(cd["id"]) == str(model["sel"]), on_pick))
	return row


static func card(cd: Dictionary, on: bool, on_pick: Callable) -> Control:
	var boxer := str(cd["kind"]) == "boxer"
	var b := Pick.new()   # grows with the Largest text size (a Button keeps its fixed height)
	b.name = "Card_" + str(cd["id"])
	b.custom_minimum_size = Vector2(0, H)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_stylebox_override("panel", B.panel(Palette.HOVER if on else Palette.CARD, Palette.CHOSEN if on else Palette.LINE, 12, 6, 3 if on else 1))
	var fid := str(cd["id"])
	b.on_click = func(): on_pick.call(fid)   # S505 (operator: "it doesnt switch to ana"): a grappler's card opens her page
	if not on:   # S505 (operator: "why i cannot switch fighter in the training screen"): the card lights up under the mouse
		b.mouse_entered.connect(func(): b.add_theme_stylebox_override("panel", B.panel(Palette.HOVER, Palette.CHOSEN, 12, 6, 2)))
		b.mouse_exited.connect(func(): b.add_theme_stylebox_override("panel", B.panel(Palette.CARD, Palette.LINE, 12, 6, 1)))
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(h)
	h.add_child(B.face(str(cd["stem"]), 60, Palette.CHOSEN if on else Palette.WOOD))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(v)
	var nm := B.lab(str(cd["name"]).to_upper(), 19, Palette.TEXT, "caps")
	nm.name = "Name"
	nm.clip_text = true
	nm.tooltip_text = str(cd["name"])
	v.add_child(nm)
	for k in ["line1", "line2"]:
		var l := B.lab(str(cd[k]), 16, Palette.MUTED if k == "line1" else Palette.TEXT, "bold")
		l.clip_text = true
		l.tooltip_text = str(cd[k])
		v.add_child(l)
	var tags := HBoxContainer.new()
	tags.add_theme_constant_override("separation", 6)
	tags.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tags.add_child(_tag(str(cd["tag"]), str(cd["tag_kind"])))
	if boxer:
		var ic := KitIcon.icon("coach", 18, Palette.MUTED)
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		tags.add_child(ic)
	var note := B.lab(str(cd["note"]), 16, Palette.MUTED, "bold")
	note.name = "CoachMin"
	note.clip_text = true
	note.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	note.tooltip_text = ("Pads with your coach this week: %s (75 minutes a night)." % str(cd["note"])) if boxer else str(cd["note"])
	tags.add_child(note)
	v.add_child(tags)
	if not (cd["spark"] as Array).is_empty():
		var sv := VBoxContainer.new()
		sv.add_theme_constant_override("separation", 0)
		sv.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sv.alignment = BoxContainer.ALIGNMENT_CENTER
		var sp := B.Spark.new()
		sp.name = "Spark"
		sp.pts = cd["spark"]
		sp.custom_minimum_size = Vector2(60, 30)
		sv.add_child(sp)
		sv.add_child(B.lab("tiredness", 16, Palette.MUTED, "body"))
		h.add_child(sv)
	b.tooltip_text = ("Tiredness by the end of each day: %s" % ", ".join((cd["spark"] as Array).map(func(x): return "%d" % roundi(float(x))))
		+ ("" if on else "\nClick to plan this boxer's week.")) if boxer else "The mat coach runs the mat classes. Click to choose what they drill."
	return b


## The week's kind as a small filled tag: amber for a peak or fight week, the mat's purple, plain for a base week.
static func _tag(text: String, kind: String) -> PanelContainer:
	var fill: Color = {"peak": Palette.WARN, "fight": Palette.BAD_FILL, "taper": Palette.BAD_FILL, "build": Palette.WARN,
		"mat": Palette.ELITE}.get(kind, Palette.TILE)
	var p := PanelContainer.new()
	p.name = "WeekTag"
	p.add_theme_stylebox_override("panel", UI.box(fill, Palette.CLEAR, 4, 0, 5, 0))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(B.lab(text, 16, Palette.ON_LIGHT if kind != "base" else Palette.TEXT, "bold"))
	return p


## A card that is clicked (selects her week).
class Pick extends PanelContainer:
	var on_click := Callable()

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP

	func _gui_input(ev: InputEvent) -> void:
		var mb := ev as InputEventMouseButton
		if mb != null and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT and on_click.is_valid():
			on_click.call()
			accept_event()
