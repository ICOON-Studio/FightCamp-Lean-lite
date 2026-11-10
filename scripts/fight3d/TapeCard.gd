extends RefCounted
## S310 the tale of the tape on screen (TaleOfTape.rows): a narrow centre column between the two boxers in their
## corners - red values left, the label in the middle, blue values right, names on top. Fades in and out.
##   build(rows, names) -> Control     show(card, on)

const UI := preload("res://scripts/ui/TV.gd")  # S333: fight graphics keep the dark TV look
const TapeRows := preload("res://scripts/rules/TapeRows.gd")

const _ALIAS := {
	"RECORD": "Record", "AGE": "Age", "WEIGHT": "Weight", "HEIGHT": "Height",
	"REACH": "Reach", "STANCE": "Stance", "STYLE": "Style",
	"Record": "Record", "Age": "Age", "Weight": "Weight", "Height": "Height",
	"Reach": "Reach", "Stance": "Stance", "Style": "Style",
}

const RED := Color(0.95, 0.4, 0.35)
const BLUE := Color(0.5, 0.65, 1.0)


static func tape_rows(f: Dictionary, opp: Dictionary, her_cm: float = 0.0) -> Array:
	return TapeRows.rows(f, opp, her_cm)


## rows are TapeRows dicts, or the older [label, left, right] pairs (FightCast still sends those). Pairs are relabelled
## into TapeRows order; Club is dropped; Reach is dropped when either side is unknown.
static func build(rows: Array, names: Array) -> Control:
	var panel := PanelContainer.new()
	panel.name = "TaleOfTape"
	# S370 (operator: "tale of the tape got clipped quite a lot why?"): at 0.88 the ring's ropes and the near corner post
	# showed through the rows; the card is solid now.
	panel.add_theme_stylebox_override("panel", UI.box(Color(0.05, 0.04, 0.04, 0.97), UI.LINE, 8, 1, 22, 16))
	panel.anchor_left = 0.5
	panel.anchor_right = 0.5
	panel.anchor_top = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = -330
	panel.offset_right = 330
	panel.offset_top = -150
	panel.offset_bottom = 140
	var v := UI.vbox(6)
	panel.add_child(v)
	var title := UI.caps("TALE OF THE TAPE")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(title)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 18)
	grid.add_theme_constant_override("v_separation", 6)
	v.add_child(grid)
	_row(grid, str(names[0]).to_upper(), "", str(names[1]).to_upper(), UI.BODY + 3, true)
	var drawn: Array = rows if (not rows.is_empty() and rows[0] is Dictionary) else _from_pairs(rows)
	for r in drawn:
		var row: Dictionary = r
		_row(grid, str(row["left"]), str(row["label"]), str(row["right"]), UI.BODY, false)
	panel.modulate.a = 0.0
	return panel


static func _from_pairs(rows: Array) -> Array:
	var by := {}
	for r in rows:
		if not (r is Array) or (r as Array).size() < 3:
			continue
		var key := str(_ALIAS.get(str(r[0]), ""))
		if key == "":
			continue
		by[key] = r
	var out: Array = []
	for key in TapeRows.ORDER:
		if not by.has(key):
			continue
		var pair: Array = by[key]
		var left := str(pair[1])
		var right := str(pair[2])
		if key == "Reach" and (left == "-" or right == "-" or left == "" or right == "" or left == "?" or right == "?"):
			continue
		out.append({"label": key, "left": left, "right": right, "better": "", "why": ""})
	return out


static func _row(grid: GridContainer, red: String, label: String, blue: String, size: int, head: bool) -> void:
	var a := UI.label(red, size, RED if head else UI.FG, "bold" if head else "body")
	a.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	a.custom_minimum_size = Vector2(230, 0)
	var m := UI.mono(label, UI.TINY, UI.MUTED)
	m.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	m.custom_minimum_size = Vector2(110, 0)
	var b := UI.label(blue, size, BLUE if head else UI.FG, "bold" if head else "body")
	b.custom_minimum_size = Vector2(230, 0)
	for c in [a, m, b]:
		grid.add_child(c)


static func show(card: Control, on: bool) -> void:
	if card == null:
		return
	card.create_tween().tween_property(card, "modulate:a", 1.0 if on else 0.0, 0.4)
