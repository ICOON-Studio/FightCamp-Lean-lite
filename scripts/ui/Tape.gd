extends RefCounted
## The tale of the tape: her card, VS, their card. Used by the bout page and fight night.

const UI := preload("res://scripts/ui/UI.gd")


## rows: [[key, value], ...] for each side.
static func make(left_name: String, left_sub: String, left_rows: Array, right_name: String, right_sub: String,
		right_rows: Array) -> HBoxContainer:
	var h := UI.hbox(18)
	h.add_child(_side(left_name, left_sub, left_rows))
	var vs := UI.display("VS", 44, UI.GOLD)
	vs.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(vs)
	h.add_child(_side(right_name, right_sub, right_rows))
	return h


static func _side(name: String, sub: String, rows: Array) -> PanelContainer:
	var c := UI.card()
	c[1].add_child(UI.display(name.to_upper(), 34))
	if sub != "":
		c[1].add_child(UI.muted(sub, UI.SMALL))
	var items: Array = []
	for r in rows:
		items.append(UI.kv(str(r[0]), str(r[1])))
	UI.add_rows(c[1], items)
	return c[0]
