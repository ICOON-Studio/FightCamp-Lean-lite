extends RefCounted
## S461 INTEGRATE1 #4: the towel card's strip on the corner minute (2D FightNight and the 3D CornerOverlay). It comes only
## when TowelWire's card does: the reasons, the risk in 100s against the line, and three answers. on_pick(kind) gets
## "pull" | "box_safe" | "one_more"; the caller sends "|towel=<kind>" with the corner call (BoutNight.corner_jobs).

const UI := preload("res://scripts/ui/UI.gd")

const ANSWERS := [["pull", "Pull out", "A loss on the stool; 14 days out; no injury roll", "BtnSolid"],
	["box_safe", "Box safe", "Next round on Hands up at Save pace: fewer rounds won, softer ones lost", "Btn"],
	["one_more", "One more round", "The call as picked; a stoppage costs the full suspension", "Btn"]]


## ui = the look: UI (2D menus) or TV (the 3D view's dark fight graphics); both give the same helpers.
static func build(tc: Dictionary, on_pick: Callable, ui: GDScript = UI) -> Control:
	var v: VBoxContainer = ui.vbox(4)
	var why := PackedStringArray(tc.get("reasons", []).map(func(r): return str(r["words"])))
	v.add_child(ui.label("THE TOWEL - " + ", ".join(why), 20, ui.AMBER, "body", true))
	v.add_child(ui.muted(str(tc.get("words", "")) + (" Your coach would pull out now." if bool(tc.get("coach_pulls", false)) else ""),
		ui.SMALL, true))
	var row: HBoxContainer = ui.hbox(10)
	for a in ANSWERS:
		var b: Button = ui.button(str(a[1]), str(a[3]), on_pick.bind(str(a[0])))
		b.tooltip_text = str(a[2])
		b.name = "Towel_" + str(a[0])
		row.add_child(b)
	v.add_child(row)
	return v
