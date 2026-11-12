extends RefCounted
## S443 C323 (operator on the corner card's RECOVER row "Water and breathing ●●● (+3 energy each) + / Ice on the ribs":
## "this doesnt seemlike an option for the player needs improvement tso player understands what is the difference on each ,
## real time changes should be shown with graphics or somehow"): the second's points as a choice. Points left as pips; each
## job a small card with its picture, what one point does in plain words, its - / + and dots, and what the points put in
## change now ("+6 energy", "-3 body hits"). The numbers come from CornerJobs.recover, never typed here. The live preview on
## the energy bar and her body is CornerOverlay's (it calls CornerStats.preview and eases the ribs on her figure).
##   build(mn, sel, on_change, ink, mute, tv) -> HBoxContainer   now_words(id, mn, n) -> String   tip(id) -> String

const UI := preload("res://scripts/ui/UI.gd")
const TV := preload("res://scripts/ui/TV.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")


## What `n` points on job `id` change, from CornerJobs.recover on the menu's own numbers: "+6 energy", "-3 body hits",
## "Clear-headed"; "" for none.
static func now_words(id: String, mn: Dictionary, n: int) -> String:
	if n <= 0:
		return ""
	var did := CornerJobs.recover({id: n}, float(mn.get("energy", 100.0)), int(mn.get("body", 0)), bool(mn.get("hurt", false)))
	match id:
		"water":
			return "+%d energy" % roundi(float(did["energy"]))
		"ice":
			return "-%d body hits" % int(did["body"])
		"head":
			return "Clear-headed" if not bool(did["hurt"]) else ""
	return ""


## The hover: what is different about each job.
static func tip(id: String) -> String:
	match id:
		"water":
			return "Energy back for the next round: %d a point, %d a point when the bell finds the energy under %d." % [
				int(CornerJobs.WATER_FRESH), int(CornerJobs.WATER_TIRED), int(CornerJobs.WEARY_AT)]
		"ice":
			return "Takes back %d body hits a point. Every body hit costs %.1f energy for the rest of the fight, so ice pays back now and later; the sorer side of the ribs eases." % [
				CornerJobs.ICE_HITS, Exchanges.BODY_COST]
		"head":
			return "Starts the next round clear-headed instead of hurt (1 point)."
	return ""


static func build(mn: Dictionary, sel: Dictionary, on_change: Callable, ink: Color, mute: Color, tv: bool,
		vertical: bool = false) -> BoxContainer:
	var rec: Dictionary = sel["rec"]
	var used := int(rec.get("water", 0)) + int(rec.get("ice", 0)) + int(rec.get("head", 0))
	var row: BoxContainer = null
	var head: BoxContainer = null
	if vertical:
		row = VBoxContainer.new()
		head = HBoxContainer.new()
	else:
		row = HBoxContainer.new()
		head = VBoxContainer.new()
		head.custom_minimum_size = Vector2(120, 0)
	row.add_theme_constant_override("separation", 6 if vertical else 8)
	head.add_theme_constant_override("separation", 8 if vertical else 2)
	row.name = "RecoverRow"
	var tag := UI.caps("RECOVER")
	tag.add_theme_color_override("font_color", UI.GREEN if not tv else TV.GREEN)
	head.add_child(tag)
	var left := _Pips.new()
	left.name = "PointsLeft"
	left.total = CornerJobs.RECOVER_POINTS
	left.left = CornerJobs.RECOVER_POINTS - used
	left.fill = TV.GOLD if tv else UI.GOLD
	left.tooltip_text = "%d of %d points left for the second" % [CornerJobs.RECOVER_POINTS - used, CornerJobs.RECOVER_POINTS]
	var pl := UI.hbox(6)
	pl.add_child(left)
	pl.add_child(UI.label("left", UI.TINY, mute))
	head.add_child(pl)
	row.add_child(head)
	for o in mn["recover"]:
		row.add_child(_card(o, mn, rec, used, on_change, ink, mute, tv))
	return row


## A job's card: its picture and name, what one point does, then - dots + and what the points put in change now.
static func _card(o: Dictionary, mn: Dictionary, rec: Dictionary, used: int, on_change: Callable, ink: Color, mute: Color,
		tv: bool) -> PanelContainer:
	var id := str(o["id"])
	var n := int(rec.get(id, 0))
	var on := n > 0
	var green: Color = TV.GREEN if tv else UI.GREEN
	var p := PanelContainer.new()
	p.name = "RecCard_" + id
	var bg := Color(1, 1, 1, 0.05) if tv else Color(0, 0, 0, 0.04)
	var edge: Color = green if on else (TV.LINE if tv else UI.LINE)
	p.add_theme_stylebox_override("panel", UI.box(bg, edge, 6, 2 if on else 1, 8, 3))
	p.tooltip_text = tip(id)
	var col := UI.vbox(0)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(col)
	var top := UI.hbox(6)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var icon := _Icon.new()
	icon.kind = id
	top.add_child(icon)
	var words := UI.vbox(0)
	words.mouse_filter = Control.MOUSE_FILTER_IGNORE
	words.add_child(UI.label(str(o["label"]), UI.SMALL, ink, "bold"))
	words.add_child(UI.label(str(o["line"]).replace(" a point", " each point"), UI.TINY, mute))
	top.add_child(words)
	col.add_child(top)
	var pick := UI.hbox(4)
	var minus := UI.button("-", "BtnQuiet", func():
		rec[id] = maxi(0, int(rec.get(id, 0)) - 1)
		on_change.call(), n == 0)
	minus.name = "Rec_minus_" + id
	pick.add_child(minus)
	var dots := _Pips.new()
	dots.name = "Dots_" + id
	dots.total = int(o["max"])
	dots.left = n
	dots.fill = green
	pick.add_child(dots)
	var plus := UI.button("+", "BtnQuiet", func():
		rec[id] = int(rec.get(id, 0)) + 1
		on_change.call(), used >= CornerJobs.RECOVER_POINTS or n >= int(o["max"]))
	plus.name = "Rec_plus_" + id
	pick.add_child(plus)
	var now := UI.label(now_words(id, mn, n), UI.SMALL, green, "bold")
	now.name = "RecNow_" + id
	pick.add_child(now)
	col.add_child(pick)
	return p


## Filled / hollow circles: `left` of `total` filled.
class _Pips extends Control:
	var total := 3
	var left := 3
	var fill := Color.WHITE
	const R := 6.0

	func _init() -> void:
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		custom_minimum_size = Vector2(3 * (R * 2.0 + 5.0), R * 2.0 + 2.0)

	func _draw() -> void:
		for i in total:
			var c := Vector2(R + 1.0 + i * (R * 2.0 + 5.0), size.y * 0.5)
			if i < left:
				draw_circle(c, R, fill)
			else:
				draw_arc(c, R - 0.5, 0.0, TAU, 20, Color(fill, 0.6), 1.5, true)


## The job's picture, drawn: a water drop, an ice cube, a head.
class _Icon extends Control:
	var kind := "water"

	func _init() -> void:
		custom_minimum_size = Vector2(28, 30)
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var col: Color = {"water": Color("#5fb4f0"), "ice": Color("#bfe6f5")}.get(kind, Color("#e9b84a"))
		var m := size * 0.5
		match kind:
			"water":
				draw_circle(m + Vector2(0, 5), 8.0, col)
				draw_colored_polygon(PackedVector2Array([m + Vector2(-7.5, 2), m + Vector2(0, -13), m + Vector2(7.5, 2)]), col)
			"ice":
				draw_rect(Rect2(m - Vector2(10, 10), Vector2(20, 20)), col)
				draw_rect(Rect2(m - Vector2(10, 10), Vector2(20, 20)), Color.WHITE, false, 1.5)
				draw_line(m + Vector2(-6, -4), m + Vector2(-1, -8), Color(1, 1, 1, 0.9), 2.0)
			_:
				draw_circle(m + Vector2(0, -3), 8.0, col)
				draw_rect(Rect2(m + Vector2(-9, 6), Vector2(18, 7)), col)
