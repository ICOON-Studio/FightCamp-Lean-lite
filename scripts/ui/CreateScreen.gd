extends CenterContainer
## New career in three steps: country, city, gym name.

const UI := preload("res://scripts/ui/UI.gd")

const COUNTRIES := ["United Kingdom", "Ireland", "United States", "Mexico"]
const CITIES := {
	"United Kingdom": ["London", "Manchester", "Liverpool", "Glasgow"],
	"Ireland": ["Dublin", "Belfast", "Cork", "Limerick"],
	"United States": ["Philadelphia", "Las Vegas", "Detroit", "Brooklyn"],
	"Mexico": ["Guadalajara", "Mexico City", "Tijuana", "Monterrey"],
}

var _name_edit: LineEdit


func build(main: Node) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var s: Dictionary = main.create
	var step := int(s["step"])
	var v := UI.vbox(12)
	v.custom_minimum_size = Vector2(700, 0)
	add_child(v)
	var steps := UI.hbox(8)
	for i in 3:
		var bar := ColorRect.new()
		bar.color = UI.GOLD if i <= step else UI.LINE
		bar.custom_minimum_size = Vector2(0, 5)
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		steps.add_child(bar)
	v.add_child(steps)
	var nav := UI.hbox(10)
	if step == 0:
		v.add_child(UI.display("1. COUNTRY", 50))
		v.add_child(UI.muted("Where your gym stands decides its rules and its rivals.", UI.BODY))
		v.add_child(_choices(main, COUNTRIES, "country", str(s["country"])))
		nav.add_child(UI.spacer())
		nav.add_child(UI.button("Next", "BtnSolid", main.act.bind("cstep", "1")))
	elif step == 1:
		v.add_child(UI.display("2. CITY", 50))
		v.add_child(UI.muted("A bigger city has more fighters and more competition.", UI.BODY))
		v.add_child(_choices(main, CITIES[s["country"]], "city", str(s["city"])))
		nav.add_child(UI.button("Back", "BtnQuiet", main.act.bind("cstep", "0")))
		nav.add_child(UI.spacer())
		nav.add_child(UI.button("Next", "BtnSolid", main.act.bind("cstep", "2"), str(s["city"]) == "",
			"Pick a city from the list first"))
	else:
		v.add_child(UI.display("3. YOUR GYM", 50))
		v.add_child(UI.label("Gym name"))
		_name_edit = LineEdit.new()
		_name_edit.placeholder_text = "Anvil Street Gym"
		_name_edit.max_length = 28
		v.add_child(_name_edit)
		nav.add_child(UI.button("Back", "BtnQuiet", main.act.bind("cstep", "1")))
		nav.add_child(UI.spacer())
		nav.add_child(UI.button("Open the gym", "BtnSolid", func(): main.act("cstart", _name_edit.text.strip_edges())))
	v.add_child(nav)
	var back := UI.button("Back to title", "BtnQuiet", main.act.bind("title", ""))
	back.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(back)
	if _name_edit != null:
		_name_edit.call_deferred("grab_focus")


func _choices(main: Node, items: Array, key: String, current: String) -> GridContainer:
	var g := GridContainer.new()
	g.columns = 4
	g.add_theme_constant_override("h_separation", 10)
	g.add_theme_constant_override("v_separation", 10)
	for item in items:
		var b := UI.button(item, "ChoiceOn" if item == current else "Choice", main.act.bind("cpick", "%s|%s" % [key, item]))
		b.custom_minimum_size = Vector2(160, 56)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		g.add_child(b)
	return g
