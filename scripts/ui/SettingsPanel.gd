extends RefCounted
## S396 truth pass (P15; mock-up docs/STRUCTURE_MOCKUPS_S395.html#handbook): the Settings page inside the info modal.
## Every change applies at once and is kept (Settings.write). Only options that work are offered.

const UI := preload("res://scripts/ui/UI.gd")
const Settings := preload("res://scripts/state/Settings.gd")
const AutoSave := preload("res://scripts/state/AutoSave.gd")


static func build(main: Node) -> VBoxContainer:
	var d := Settings.read()
	var v := UI.vbox(10)
	v.name = "SettingsPanel"
	var tree := main.get_tree()
	var keep := func(): Settings.write(d); Settings.apply(d, tree)
	v.add_child(_row("Text size", _pick(Settings.TEXT_SIZES, int(d["text"]), func(i): d["text"] = i; keep.call())))
	v.add_child(_row("Window", _pick(Settings.WINDOWS, int(d["window"]), func(i): d["window"] = i; keep.call())))
	for b in Settings.SOUND:
		var key := "vol_" + str(b[0])
		v.add_child(_row(str(b[1]), _slider(float(d[key]), func(x): d[key] = x; keep.call())))
	var auto := CheckButton.new()
	auto.name = "Autosave"
	auto.text = "Every Monday, the last %d weeks kept" % AutoSave.KEEP
	auto.button_pressed = bool(d["autosave"])
	auto.focus_mode = Control.FOCUS_NONE
	auto.toggled.connect(func(on): d["autosave"] = on; keep.call())
	v.add_child(_row("Autosave", auto))
	var last := AutoSave.last(str(main.save_path))
	v.add_child(UI.label(last if last != "" else "No save yet: the first is made on the next Monday.", UI.SMALL, UI.MUTED))
	return v


static func _row(what: String, control: Control) -> HBoxContainer:
	var h := UI.hbox(16)
	var l := UI.label(what, UI.BODY, UI.FG, "bold")
	l.custom_minimum_size = Vector2(230, 0)
	h.add_child(l)
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(control)
	return h


static func _pick(options: Array, at: int, on_pick: Callable) -> OptionButton:
	var o := OptionButton.new()
	for i in options.size():
		o.add_item(str(options[i][0]), i)
	o.select(at)
	o.focus_mode = Control.FOCUS_NONE
	o.item_selected.connect(on_pick)
	return o


## A 0-100 slider with its number beside it.
static func _slider(at: float, on_set: Callable) -> HBoxContainer:
	var h := UI.hbox(12)
	var s := HSlider.new()
	s.min_value = 0
	s.max_value = 100
	s.step = 5
	s.value = at
	s.custom_minimum_size = Vector2(320, 28)
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	s.focus_mode = Control.FOCUS_NONE
	var n := UI.label("%d" % int(at), UI.BODY, UI.FG, "bold")
	n.custom_minimum_size = Vector2(44, 0)
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	s.value_changed.connect(func(x): n.text = "%d" % int(x); on_set.call(x))
	h.add_child(s)
	h.add_child(n)
	return h
