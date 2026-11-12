extends RefCounted
## What you can buy now (S443 proposal B, his Q-S294-198): one column, the buys the gym can make first, each a line with
## its price, what it does, the week's net after it and its button; NOT YET under them, one short line each with the
## reason. Rows that are not built (the cage, the other sports' coaches) are not on the page until they exist.
## rank() is pure. draw() only places the rows ClubSpend already built.

const UI := preload("res://scripts/ui/UI.gd")
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
	var list := VBoxContainer.new()
	list.name = "PriceTags"
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 0)
	parent.add_child(list)
	var later := false
	for it in items:
		if _band(it) >= 3 and not later:
			later = true
			var head := UI.label("NOT YET", UI.SMALL, UI.GOLD, "bold")
			head.name = "NotYetHead"
			list.add_child(head)
		list.add_child(_later(it) if later else _tag(it))
	return list


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


static func _row(it: Dictionary) -> PanelContainer:
	var tag := PanelContainer.new()
	tag.name = "Tag_" + str(it.get("id", ""))
	tag.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tag.set_meta("affordable", bool(it.get("affordable", false)))
	tag.set_meta("grey", bool(it.get("grey", false)))
	tag.set_meta("reason", str(it.get("reason", "")))
	var tip := str(it.get("effect", ""))
	for bit in [str(it.get("runway", "")), str(it.get("payback", ""))]:
		if bit != "":
			tip += "\n" + bit.substr(0, 1).to_upper() + bit.substr(1)
	tag.tooltip_text = tip
	# See-through, one chalk line under each row: the list reads as a list, not a wall of cards.
	var skin := UI.box(Color(1, 1, 1, 0), Color(0, 0, 0, 0), 0, 0, 2, 5)
	skin.border_width_bottom = 1
	skin.border_color = Color(WoodKit.SOFT, 0.25)
	tag.add_theme_stylebox_override("panel", skin)
	return tag


static func _tag(it: Dictionary) -> Control:
	var tag := _row(it)
	var row := UI.hbox(10)
	tag.add_child(row)
	var icon := str(it.get("icon", "money"))
	if KitIcon.has_icon(icon):
		var mark := KitIcon.icon(icon, 26, WoodKit.INK)
		mark.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(mark)
	var text := UI.vbox(0)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text)
	var owned := bool(it.get("owned", false)) or bool(it.get("held", false))
	var name := str(it.get("title", "")) if owned else "%s, %s" % [it.get("title", ""), it.get("price_text", "")]
	var title := UI.label(name, 18, UI.FG, "bold")
	title.clip_text = true
	title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	text.add_child(title)
	var body := UI.label(str(it.get("effect", "")), 16, UI.MUTED, "body", true)
	body.max_lines_visible = 2
	body.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS   # S420: a cut line shows it
	text.add_child(body)
	var from_net := int(it.get("net_from", 0))
	var to_net := int(it.get("net_to", from_net))
	var net := UI.label("", 16, UI.GREEN, "bold")
	net.name = "TagNet"
	net.custom_minimum_size = Vector2(132, 0)
	net.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	net.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if owned:
		net.text = str(it.get("price_text", ""))
	elif to_net != from_net:
		# S442 UX audit: the week's net after buying, whole; the before and after are on the hover.
		net.text = "%s a week" % UI.signed(to_net)
		net.add_theme_color_override("font_color", UI.GREEN if to_net > from_net else UI.RED)
		net.tooltip_text = "What is left over each week: %s now, %s after this" % [UI.signed(from_net), UI.signed(to_net)]
		net.mouse_filter = Control.MOUSE_FILTER_PASS
	row.add_child(net)
	for b in it.get("buttons", []):
		if b != null:
			if bool(it.get("affordable", false)):
				(b as Button).theme_type_variation = "Go"
			_short_button(b)
			(b as Button).custom_minimum_size = Vector2(96, 0)
			row.add_child(b)
	return tag


## A NOT YET line: the name and why not, on one line each; the whole reason is on the hover.
static func _later(it: Dictionary) -> Control:
	var tag := _row(it)
	if str(it.get("reason", "")) != "":
		tag.tooltip_text = str(it.get("reason", ""))
	var row := UI.hbox(10)
	tag.add_child(row)
	var text := UI.vbox(0)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text)
	var title := UI.label("%s, %s" % [it.get("title", ""), it.get("price_text", "")], 16, UI.FG, "bold")
	title.modulate = Color(1, 1, 1, 0.75)
	title.clip_text = true
	title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	text.add_child(title)
	var why := str(it.get("reason", "")) if str(it.get("reason", "")) != "" else str(it.get("effect", ""))
	var reason := UI.label(why, 16, UI.MUTED, "body")
	reason.clip_text = true
	reason.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS
	text.add_child(reason)
	for b in it.get("buttons", []):
		if b != null:
			_short_button(b)
			(b as Button).custom_minimum_size = Vector2(96, 0)
			row.add_child(b)
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
