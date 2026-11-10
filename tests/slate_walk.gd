extends RefCounted
## S418 the wood and slate look, checked the same way on every page (first written for the Training week page, S417).
## A page on slate has no light plate of its own and no word in the wrong ink for the surface behind it.
##   SlateWalk.faults(page) -> Array of plain sentences, empty when the page is clean. Call it after `WoodKit.ink(page)`
##   and a few settled frames, with root.size 1920x1080.
## What counts:
##   - a PanelContainer or Button whose own stylebox is a StyleBoxFlat with alpha >= 0.5 and luminance >= 0.45 is a light
##     plate, unless its theme variation is TabOn, ChoiceOn, PillOn, Go, Sticky* or Chip* (the look's own light pieces);
##   - a visible Label or RichTextLabel in a paper ink (UI.FG / MUTED / GOLD) on a surface WoodKit.on_dark calls dark,
##     or in a chalk ink (WoodKit.INK / SOFT / BLUE) on a light one;
##   - any visible Control wider than 1920 or ending past x 1920.

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")

const PAPER := [UI.FG, UI.MUTED, UI.GOLD]
const CHALK := [WoodKit.INK, WoodKit.SOFT, WoodKit.BLUE]
const LIGHT_OK := ["TabOn", "ChoiceOn", "PillOn", "Go"]


static func faults(page: Node) -> Array:
	var out: Array = []
	_walk(page, out)
	return out


static func _walk(n: Node, out: Array) -> void:
	if n is Control and not (n as Control).is_visible_in_tree():
		return
	if n is Control and (n as Control).size.x > 1.0:
		var r := (n as Control).get_global_rect()
		if r.size.x > 1920.0 or r.end.x > 1920.5:
			out.append("%s is wider than 1920 (%.0f at x %.0f)" % [n.name, r.size.x, r.end.x])
	if (n is PanelContainer or n is Button) and not _allowed(n as Control) and _light_plate(n as Control):
		var sb := (n as Control).get_theme_stylebox("panel" if n is PanelContainer else "normal") as StyleBoxFlat
		out.append("%s is a light plate (%s a=%.2f lum=%.2f)" % [n.name, sb.bg_color.to_html(true), sb.bg_color.a, sb.bg_color.get_luminance()])
	if n is Label or n is RichTextLabel:
		_ink(n as Control, out)
	for c in n.get_children():
		_walk(c, out)


static func _ink(c: Control, out: Array) -> void:
	var text: String = (c as Label).text if c is Label else (c as RichTextLabel).text
	var col: Color = c.get_theme_color("font_color" if c is Label else "default_color")
	if text.strip_edges() == "":
		return
	var dark := WoodKit.on_dark(c)
	if dark and PAPER.has(col):
		out.append("%s keeps a paper ink on a dark surface (%s): \"%s\"" % [c.name, col.to_html(false), text.left(30)])
	elif not dark and CHALK.has(col):
		out.append("%s uses a chalk ink on a light surface (%s): \"%s\"" % [c.name, col.to_html(false), text.left(30)])


static func _allowed(c: Control) -> bool:
	var v := str(c.theme_type_variation)
	return LIGHT_OK.has(v) or v.begins_with("Sticky") or v.begins_with("Chip")


static func _light_plate(c: Control) -> bool:
	var sb := c.get_theme_stylebox("panel" if c is PanelContainer else "normal")
	if not (sb is StyleBoxFlat):
		return false
	var bg: Color = (sb as StyleBoxFlat).bg_color
	return bg.a >= 0.5 and bg.get_luminance() >= 0.45
