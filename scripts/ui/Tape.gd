extends RefCounted
## The tale of the tape: her card, VS, their card. Used by the bout page and fight night.

const UI := preload("res://scripts/ui/UI.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")

const PHOTO := Vector2(128, 160)


## rows: [[key, value], ...] for each side. stems: [left body, right body] puts each fighter's photo on the outer edge of the card, so
## the two faces look in from the ends of the row like a fight card (S387 operator on the bout page).
static func make(left_name: String, left_sub: String, left_rows: Array, right_name: String, right_sub: String,
		right_rows: Array, stems: Array = []) -> HBoxContainer:
	var h := UI.hbox(18)
	h.add_child(_side(left_name, left_sub, left_rows, str(stems[0]) if stems.size() == 2 else "", false))
	var vs := UI.display("VS", 44, UI.GOLD)
	vs.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(vs)
	h.add_child(_side(right_name, right_sub, right_rows, str(stems[1]) if stems.size() == 2 else "", true))
	return h


static func _side(name: String, sub: String, rows: Array, stem: String, photo_right: bool) -> PanelContainer:
	var c := UI.card()
	var body: Container = c[1]
	var photo := PromoShot.picture(stem, PHOTO) if stem != "" else null
	if photo != null:
		var row := UI.hbox(16)
		var words := UI.vbox(4)
		words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		c[1].add_child(row)
		row.add_child(words if photo_right else photo)
		row.add_child(photo if photo_right else words)
		body = words
	body.add_child(UI.display(name.to_upper(), 34))
	if sub != "":
		body.add_child(UI.muted(sub, UI.SMALL))
	var items: Array = []
	for r in rows:
		items.append(UI.kv(str(r[0]), str(r[1])))
	UI.add_rows(body, items)
	return c[0]
