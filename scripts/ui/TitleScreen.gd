extends CenterContainer
## The title: resume the saved career, new career, quick start, load, settings, quit.

const UI := preload("res://scripts/ui/UI.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")


func build(main: Node) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var v := UI.vbox(12)
	v.custom_minimum_size = Vector2(560, 0)
	add_child(v)
	var logo := UI.display("FIGHTCAMP", 132, UI.GOLD)
	v.add_child(logo)
	var tag := UI.muted("Run a boxing gym. Build a fighter. Win on Saturday.", UI.BODY)
	v.add_child(tag)
	v.add_child(_gap(14))
	var saved := SaveGame.summary(main.save_path)
	var resume := _tbtn("Resume career", saved if saved != "" else "no save yet", "TBtn", main.act.bind("load", ""), saved == "")
	resume.name = "Resume"
	v.add_child(resume)
	v.add_child(_tbtn("New career", "country, city, gym name", "TBtn", main.act.bind("newcareer", "")))
	v.add_child(_tbtn("Quick start", "a built gym in London", "TBtnPrimary", main.act.bind("quick", "")))
	v.add_child(_tbtn("Load career", "", "TBtn", main.act.bind("load", "")))
	v.add_child(_tbtn("Settings", "", "TBtn", main.act.bind("settings", "")))
	v.add_child(_tbtn("Quit", "", "TBtn", main.act.bind("quit", "")))
	v.add_child(_gap(10))
	v.add_child(UI.muted("Week 3 build: the money, the gym and the boxing world are live; save from the Gear menu.", UI.SMALL, true))


func _gap(h: int) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(0, h)
	return c


## Big words on the left, a small note on the right.
func _tbtn(big: String, small: String, variation: String, cb: Callable, disabled: bool = false) -> Button:
	var b := UI.button("", variation, cb if cb.is_valid() else func(): pass, disabled)
	b.custom_minimum_size = Vector2(0, 62)
	var ink := UI.GOLD_INK if variation == "TBtnPrimary" else UI.FG
	var m := MarginContainer.new()
	m.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	m.add_theme_constant_override("margin_left", 20)
	m.add_theme_constant_override("margin_right", 20)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var h := UI.hbox(8)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	var l := UI.label(big, 21, ink, "semi")
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(l)
	h.add_child(UI.spacer())
	if small != "":
		var s := UI.label(small, UI.SMALL, UI.GOLD_INK if variation == "TBtnPrimary" else UI.MUTED)
		s.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(s)
	m.add_child(h)
	b.add_child(m)
	if disabled:
		b.modulate = Color(1, 1, 1, 0.45)
	return b
