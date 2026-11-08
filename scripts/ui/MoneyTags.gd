extends RefCounted
## Price tags on the books: what the gym can afford and what earns, then the cheaper buys, grey ones after, the
## unbuilt cage last. rank() is pure. draw() only places the rows ClubSpend already built.

const UI := preload("res://scripts/ui/UI.gd")
const WarmKit := preload("res://scripts/ui/WarmKit.gd")
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
	grid.add_theme_constant_override("v_separation", 6)
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
	var paper := WarmKit.panel("paper")
	paper.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_inset(paper, 8, 6, 16)
	if bool(it.get("grey", false)):
		paper.modulate = Color(1, 1, 1, 0.6)
		tag.tooltip_text = str(it.get("reason", ""))
	tag.add_child(paper)
	var row := UI.hbox(6)
	paper.add_child(row)
	var icon := str(it.get("icon", "money"))
	if KitIcon.has_icon(icon):
		row.add_child(KitIcon.icon(icon, 28, UI.FG))
	var text := UI.vbox(0)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text)
	var title := UI.label(str(it.get("title", "")), 14, UI.FG, "handbold")
	title.clip_text = true
	title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	title.max_lines_visible = 1
	text.add_child(title)
	var price_row := UI.hbox(4)
	var price := UI.label(str(it.get("price_text", "")), 16, UI.GREEN if bool(it.get("owned", false)) or bool(it.get("held", false)) else UI.GOLD, "marker")
	price.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	price.clip_text = true
	price.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	price_row.add_child(price)
	var from_net := int(it.get("net_from", 0))
	var to_net := int(it.get("net_to", from_net))
	if to_net != from_net:
		var net := UI.label("Net %s to %s" % [UI.signed(from_net), UI.signed(to_net)], 12, UI.GREEN if to_net > from_net else UI.RED, "bold")
		net.name = "TagNet"
		net.tooltip_text = "What is left over each week now, and after this"
		price_row.add_child(net)
	for b in it.get("buttons", []):
		if b != null:
			if bool(it.get("affordable", false)):
				(b as Button).theme_type_variation = "BtnSolid"
			_short_button(b)
			price_row.add_child(b)
	text.add_child(price_row)
	var body := UI.label(str(it.get("effect", "")), 12, UI.FG, "hand", true)
	body.max_lines_visible = 2
	text.add_child(body)
	var foot := UI.hbox(4)
	foot.add_child(KitIcon.icon("runway", 14, UI.FG))
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


static func _inset(panel: PanelContainer, top: float, bottom: float, side: float) -> void:
	var src := panel.get_theme_stylebox("panel")
	if not (src is StyleBoxTexture):
		return
	var copy := (src as StyleBoxTexture).duplicate() as StyleBoxTexture
	copy.content_margin_top = top
	copy.content_margin_bottom = bottom
	copy.content_margin_left = side
	copy.content_margin_right = side
	panel.add_theme_stylebox_override("panel", copy)


static func _short_button(b: Button) -> void:
	b.add_theme_font_size_override("font_size", 12)
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
