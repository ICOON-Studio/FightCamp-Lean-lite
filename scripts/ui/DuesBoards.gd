extends RefCounted
## Three dues boards on Club > Money's Dues tab. The painting keeps its own shape.
## Under it, big and few: the fee, then members, the month's money, home-grown boxers.

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")

const PAINT := "res://assets/ui/dues/dues_%s_cut.png"   # S427 cut out of their dark squares (Ludo), drawn with Halo.cutout
const WHO := {
	"cheap": "Juniors and the neighbourhood",
	"standard": "The middle of the club",
	"premium": "Adults who come for fitness",
}
const GOLD := Color("#f2c14e")
const BRASS := Color("#5c4314")
const FEE_PX := 48
const NUM_PX := 32
const WORD_PX := 24


static func build(main: Node, c: Career) -> Control:
	var board := PanelContainer.new()
	board.name = "DuesBoard"
	board.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	board.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.04), Color(0, 0, 0, 0), 0, 0, 0, 0))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 24)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board.add_child(row)
	var cap := GymSpend.member_cap(c)
	var mult := GymBonus.members(c.gym_plan)
	var youth := GymSpend.youth_on(c)
	var full := c.members >= cap
	var now: Dictionary = Membership.band_preview(c.reputation, cap, c.dues_band, mult, youth)
	for band in Membership.DUES_ORDER:
		row.add_child(_board(main, c, str(band), Membership.band_preview(c.reputation, cap, str(band), mult, youth), now, youth, full))
	return board


static func _board(main: Node, c: Career, band: String, preview: Dictionary, now: Dictionary, youth: bool, full: bool) -> Button:
	var on := band == c.dues_band
	var b := Button.new()
	b.name = "Dues_" + band
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.size_flags_vertical = Control.SIZE_EXPAND_FILL
	b.custom_minimum_size = Vector2(400, 600)
	b.tooltip_text = _tip(band, preview, now, c.dues_band)
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		b.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	b.pressed.connect(_press.bind(main, band))
	var wood := PanelContainer.new()
	wood.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wood.add_theme_stylebox_override("panel", WoodKit.slate(24, 24))
	_fill(wood)
	b.add_child(wood)
	if on:
		Halo.ring(b, GOLD, 8.0)
	else:
		Halo.hover(b, WoodKit.INK, 8.0)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.z_index = 2
	_fill(col)
	col.offset_left = 28
	col.offset_top = 28
	col.offset_right = -28
	col.offset_bottom = -28
	b.add_child(col)
	col.add_child(_picture(band))
	var fee := _word("%s a month" % UI.money(Membership.fee(band)), GOLD, FEE_PX)
	fee.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fee.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(fee)
	if band == "cheap" and full:
		col.add_child(_stat("members", "", "the place is full", UI.RED))
	else:
		col.add_child(_stat("members", str(int(preview["members"])), "members", _tone(float(preview["members"]), float(now["members"]))))
	var money_col := _tone(float(preview["month"]), float(now["month"]))
	col.add_child(_stat("money", UI.money(int(preview["month"])), "a month", money_col))
	if youth:
		col.add_child(_stat("hands", "%.1f" % float(preview["home_5y"]), "5 years", _tone(float(preview["home_5y"]), float(now["home_5y"]))))
	else:
		col.add_child(_stat("hands", "", "needs a youth section", WoodKit.SOFT))
	if on:
		col.add_child(_plate())
	if c.dues_band_next == band:
		_tag(b, c.day)
	return b


static func _picture(band: String) -> TextureRect:
	var pic := TextureRect.new()
	pic.name = "Painting"
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	pic.custom_minimum_size = Vector2(64, 64)
	pic.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pic.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pic.texture = _paint(band)
	Halo.cutout(pic)
	return pic


## An imported painting loads like any texture; a fresh checkout that has not imported it yet reads the file.
static func _paint(band: String) -> Texture2D:
	if ResourceLoader.exists(PAINT % band):
		return load(PAINT % band) as Texture2D
	var img := Image.new()
	if img.load(ProjectSettings.globalize_path(PAINT % band)) != OK:
		return null
	return ImageTexture.create_from_image(img)


static func _stat(icon: String, number: String, caption: String, col: Color) -> Control:
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 10)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line.alignment = BoxContainer.ALIGNMENT_CENTER
	var mark := KitIcon.icon(icon, 32, col)
	mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mark.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	line.add_child(mark)
	if number != "":
		line.add_child(_word(number, col, NUM_PX))
	if caption != "":
		line.add_child(_word(caption, col, WORD_PX))
	return line


static func _word(text: String, col: Color, size: int) -> Label:
	var lab := UI.label(text, size, col, "bold")
	lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return lab


static func _plate() -> Control:
	var hold := CenterContainer.new()
	hold.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hold.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var plate := PanelContainer.new()
	plate.name = "InForce"
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var brass := StyleBoxFlat.new()
	brass.bg_color = BRASS
	brass.set_content_margin_all(8)
	brass.content_margin_left = 16
	brass.content_margin_right = 16
	brass.set_corner_radius_all(8)
	plate.add_theme_stylebox_override("panel", brass)
	plate.add_child(_word("IN FORCE", GOLD, WORD_PX))
	hold.add_child(plate)
	return hold


static func _tag(host: Control, day: int) -> void:
	var lab := _word("from %s" % _from_month(day), WoodKit.INK, WORD_PX)
	var tag := PanelContainer.new()
	tag.name = "NextTag"
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tag.z_index = 4
	var paper := StyleBoxFlat.new()
	paper.bg_color = Color(0.95, 0.88, 0.72, 0.42)
	paper.set_content_margin_all(8)
	tag.add_theme_stylebox_override("panel", paper)
	tag.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	tag.add_child(lab)
	tag.ready.connect(_fit_tag.bind(tag, lab), CONNECT_ONE_SHOT)
	host.add_child(tag)


static func _fit_tag(tag: Control, lab: Label) -> void:
	var need := lab.get_minimum_size()
	var w := maxf(need.x + 24.0, 148.0)
	var h := maxf(need.y + 20.0, 44.0)
	tag.offset_top = 16
	tag.offset_right = -16
	tag.offset_left = -16.0 - w
	tag.offset_bottom = 16.0 + h


## The first week whose date sits in the next calendar month: the week the change takes effect.
static func _from_month(day: int) -> String:
	var now := Clock._date(day)
	var here := int(now["year"]) * 12 + int(now["month"])
	var at := day
	for _step in 6:
		at += 7
		var nxt := Clock._date(at)
		if int(nxt["year"]) * 12 + int(nxt["month"]) != here:
			return Clock.MONTHS[int(nxt["month"]) - 1]
	return Clock.MONTHS[int(now["month"]) % 12]


static func _fill(node: Control) -> void:
	node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE


static func _tone(mine: float, force: float) -> Color:
	if is_equal_approx(mine, force):
		return WoodKit.INK
	return UI.GREEN if mine > force else UI.RED


static func _tip(band: String, preview: Dictionary, now: Dictionary, now_band: String) -> String:
	var delta := int(preview["month"]) - int(now["month"])
	var sign := "+" if delta >= 0 else "-"
	return "%s: %s. %s%s a month, 1 in %d junior trials pass (now 1 in %d). From next month; members leave over 4 weeks." % [
		str(Membership.DUES[band]["name"]), str(WHO[band]), sign, UI.money(absi(delta)),
		_one_in(Membership.intake_chance(band)), _one_in(Membership.intake_chance(now_band))]


static func _one_in(chance: float) -> int:
	return roundi(1.0 / chance) if chance > 0.0 else 0


static func _press(main: Node, band: String) -> void:
	var c: Career = main.career
	if c.dues_band == band:
		main.act("dues", band)
		return
	var name := str(Membership.DUES[band]["name"])
	main.open_modal({"type": "info", "title": "Dues", "body": "Change dues to %s from next month?" % name,
		"buttons": [["Yes", "dues", band], ["No", "close", ""]]})
	var yes := main.find_child("Btn_dues", true, false) as Button
	if yes != null:
		yes.pressed.connect(func(): main.close_modal())
