extends RefCounted
## Price tags on the books: what the gym can afford and what earns, then the cheaper buys, grey ones after, the
## unbuilt cage last. rank() is pure. draw() only places the rows ClubSpend already built.

const UI := preload("res://scripts/ui/UI.gd")
const WarmKit := preload("res://scripts/ui/WarmKit.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")


static func rank(items: Array) -> Array:
	var copy: Array = []
	for it in items:
		copy.append(it)
	copy.sort_custom(func(a, b): return before(a, b))
	return copy


static func before(a: Variant, b: Variant) -> bool:
	var da: Dictionary = a
	var db: Dictionary = b
	var ba := _band(da)
	var bb := _band(db)
	if ba != bb:
		return ba < bb
	var pa := int(da.get("price", 0))
	var pb := int(db.get("price", 0))
	if pa != pb:
		return pa < pb
	return str(da.get("id", "")) < str(db.get("id", ""))


static func draw(parent: Node, items: Array) -> Control:
	var grid := GridContainer.new()
	grid.name = "PriceTags"
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 2)
	parent.add_child(grid)
	for it in items:
		grid.add_child(_tag(it))
	return grid


static func _band(it: Dictionary) -> int:
	if bool(it.get("unbuilt", false)):
		return 4
	if bool(it.get("owned", false)) or bool(it.get("held", false)):
		return 2
	if bool(it.get("grey", false)) or not bool(it.get("affordable", false)):
		return 3
	if int(it.get("earn", 0)) > 0:
		return 0
	return 1


static func _tag(it: Dictionary) -> Control:
	var tag := Control.new()
	tag.name = "Tag_" + str(it.get("id", ""))
	tag.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tag.custom_minimum_size = Vector2(0, 118)
	tag.clip_contents = true
	tag.set_meta("affordable", bool(it.get("affordable", false)))
	tag.set_meta("grey", bool(it.get("grey", false)))
	tag.set_meta("reason", str(it.get("reason", "")))
	tag.tooltip_text = str(it.get("effect", ""))
	var paper := PanelContainer.new()
	paper.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var skin := UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, 16, 8)
	skin.content_margin_bottom = 6
	paper.add_theme_stylebox_override("panel", skin)
	if bool(it.get("grey", false)):
		paper.modulate = Color(1, 1, 1, 0.6)
		tag.tooltip_text = str(it.get("reason", ""))
	tag.add_child(paper)
	var row := UI.hbox(6)
	paper.add_child(row)
	var icon := str(it.get("icon", "money"))
	if KitIcon.has_icon(icon):
		row.add_child(KitIcon.icon(icon, 28, WoodKit.INK))
	var text := UI.vbox(0)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text)
	var title := UI.label(str(it.get("title", "")), 14, UI.FG, "handbold")
	title.clip_text = true
	title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	title.max_lines_visible = 1
	text.add_child(title)
	var price_row := UI.hbox(4)
	var owned := bool(it.get("owned", false)) or bool(it.get("held", false))
	var price := UI.label(str(it.get("price_text", "")), 16, UI.GREEN if owned else WoodKit.INK, "marker")
	# S420: the price is never cut ("$12,00", "$280 a" on S419's page); the week line gives way instead.
	price_row.add_child(price)
	var from_net := int(it.get("net_from", 0))
	var to_net := int(it.get("net_to", from_net))
	if to_net != from_net:
		# S442 UX audit: "Week -$309 to -$..." lost the number that matters to the ellipsis; the week's net after buying,
		# with the change, fits (the full line is on the hover).
		var net := UI.label("%s a week" % UI.signed(to_net), 16, UI.GREEN if to_net > from_net else UI.RED, "bold")
		net.name = "TagNet"
		net.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		net.clip_text = true
		net.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		net.tooltip_text = "What is left over each week: %s now, %s after this" % [UI.signed(from_net), UI.signed(to_net)]
		net.mouse_filter = Control.MOUSE_FILTER_PASS
		price_row.add_child(net)
	else:
		var gap := Control.new()   # S420: keeps the button at the right edge when there is no week line
		gap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
		price_row.add_child(gap)
	for b in it.get("buttons", []):
		if b != null:
			if bool(it.get("affordable", false)):
				(b as Button).theme_type_variation = "Go"
			_short_button(b)
			price_row.add_child(b)
	text.add_child(price_row)
	# S442 UX audit: at the 16 px floor the handwritten face (tall lines) cut the second line in half inside the 118 px tag;
	# the plain face keeps two whole lines.
	var body := UI.label(str(it.get("effect", "")), 16, UI.FG, "body", true)
	body.max_lines_visible = 2
	body.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS   # S420: a cut line shows it ("room for 10" read whole)
	text.add_child(body)
	var foot := UI.hbox(4)
	foot.add_child(KitIcon.icon("runway", 14, WoodKit.INK))
	var runway := UI.label(str(it.get("runway", "")), 12, UI.FG, "body")
	runway.clip_text = true
	runway.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	runway.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	foot.add_child(runway)
	if str(it.get("payback", "")) != "":
		foot.add_child(UI.label(str(it["payback"]), 12, UI.FG, "bold"))
	if bool(it.get("unbuilt", false)):
		var mark := KitIcon.icon("warn", 14, Color("C9770F"), "Not built yet")
		mark.name = "UnbuiltMark"
		foot.add_child(mark)
	text.add_child(foot)
	if not bool(it.get("grey", false)):
		var pin := WarmKit.magnet(16)
		pin.name = "Pin"
		pin.position = Vector2(12, 2)
		pin.z_index = 3
		if bool(it.get("owned", false)) or bool(it.get("held", false)):
			pin.modulate = Color("2A8F5E")
		elif bool(it.get("unbuilt", false)):
			pin.modulate = Color(0.62, 0.61, 0.58)
		tag.add_child(pin)
	return tag


static func _short_button(b: Button) -> void:
	b.add_theme_font_size_override("font_size", 16)
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	# The theme is only reachable once the button is in the tree: before that this read Godot's default dark box.
	b.ready.connect(func(): _tighten(b), CONNECT_ONE_SHOT)


static func _tighten(b: Button) -> void:
	for state in ["normal", "hover", "pressed", "disabled"]:
		var sb := b.get_theme_stylebox(state)
		if sb is StyleBoxFlat:
			var copy := (sb as StyleBoxFlat).duplicate() as StyleBoxFlat
			copy.content_margin_top = 1
			copy.content_margin_bottom = 1
			copy.content_margin_left = 6
			copy.content_margin_right = 6
			b.add_theme_stylebox_override(state, copy)
