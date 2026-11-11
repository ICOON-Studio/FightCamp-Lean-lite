extends RefCounted
## S430 the result page's row "what the fight did to her" (rules/Aftermath.gd tiles; operator: "after each fight it should
## show a summary of the damage on the fighter what he learned, morale effected etc"): one tile a subject, a big value in
## the colour of its news, one short line under it, the rest on the hover.
##   build(tiles, first) -> VBoxContainer

const UI := preload("res://scripts/ui/TV.gd")

const TONE := {"good": Color("#6cc27a"), "bad": Color("#e0503c"), "flat": Color("#f3ece2")}


static func build(tiles: Array, first: String) -> VBoxContainer:
	var v := UI.vbox(6)
	v.name = "Aftermath"
	var head := UI.caps("WHAT THE FIGHT DID TO %s" % first.to_upper())
	head.add_theme_color_override("font_color", UI.GOLD)
	v.add_child(head)
	var row := UI.hbox(10)
	for t in tiles:
		row.add_child(tile(t))
	v.add_child(row)
	return v


static func tile(t: Dictionary) -> PanelContainer:
	var col: Color = TONE.get(str(t.get("tone", "flat")), UI.FG)
	var p := PanelContainer.new()
	p.name = "After_" + str(t["id"])
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.custom_minimum_size = Vector2(0, 118)
	var sb := UI.box(Color(1, 1, 1, 0.05), Color(0, 0, 0, 0), 6, 0, 12, 8)
	sb.border_color = col if str(t.get("tone", "flat")) != "flat" else UI.LINE
	sb.border_width_top = 3
	p.add_theme_stylebox_override("panel", sb)
	p.tooltip_text = "\n".join(PackedStringArray(t.get("lines", [])))
	var v := UI.vbox(2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(v)
	v.add_child(UI.caps(str(t["title"])))
	var big := UI.label(str(t["big"]), 28, col, "bold")
	big.name = "Big"
	v.add_child(big)
	var small := UI.label(str(t["small"]), 20, UI.MUTED, "body", true)
	small.name = "Small"
	small.max_lines_visible = 2
	small.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(small)
	return p
