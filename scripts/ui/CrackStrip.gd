extends RefCounted
## S470 LIVERRIBS1 step 4: the crack card's strip on the corner minute (2D FightNight and the 3D CornerOverlay). It comes
## only when CrackWire.card does (your boxer's rib cracked, not answered yet): three answers with their full price, none
## picked. on_pick(kind) gets "pull" | "defend" | "fight"; the caller sends "|crack=<kind>" with the corner call.

const UI := preload("res://scripts/ui/UI.gd")


## ui = the look: UI (2D menus) or TV (the 3D view's dark fight graphics); both give the same helpers. picked = the
## answer already chosen this minute ("" = none): its button reads as taken.
static func build(card: Dictionary, on_pick: Callable, ui: GDScript = UI, picked: String = "") -> Control:
	# One row: the tag at the left like the minute's other rows (RECOVER, TALK), then the three answers, each with its
	# price on ONE line under it (S470: a heading line plus two-line prices pushed the 3D corner card 36 px off the frame).
	var row: HBoxContainer = ui.hbox(10)
	var tag: Label = ui.caps("CRACKED RIB
LEFT SIDE")
	tag.custom_minimum_size = Vector2(116, 0)
	tag.add_theme_color_override("font_color", ui.AMBER)
	row.add_child(tag)
	for a in card.get("rows", []):
		var kind := str(a["kind"])
		var col: VBoxContainer = ui.vbox(2)
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var b: Button = ui.button(str(a["label"]) + ("  (chosen)" if picked == kind else ""), "Btn", on_pick.bind(kind))
		b.name = "Crack_" + kind
		b.tooltip_text = str(a.get("more", ""))
		col.add_child(b)
		col.add_child(ui.muted(str(a["words"]), ui.SMALL, false))
		row.add_child(col)
	return row
