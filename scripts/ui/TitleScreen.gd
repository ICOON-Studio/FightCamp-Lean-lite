extends CenterContainer
## The title: resume the saved career, new career, quick start, load, settings, quit.
## S397 rank 5 round 1 (blind 5/10: "a web form, seven identical bars, no art"; the designer's 8/10 version,
## ops/research/RANK5_FIRST_HOUR_S397.md section 9): two columns - the name and a short stack on the left, a fight card of two
## of the game's own boxers on the right. With no save, New career is the one solid button and Resume/Load are not shown;
## with a save, Resume leads. The guide switch moved to the setup's last step; the build note is a small tag.

const UI := preload("res://scripts/ui/UI.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Data := preload("res://scripts/state/Data.gd")

const FACE := Vector2(300, 300)


func build(main: Node) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var row := UI.hbox(64)
	row.custom_minimum_size = Vector2(1560, 0)
	add_child(row)
	var v := UI.vbox(12)
	v.custom_minimum_size = Vector2(560, 0)
	row.add_child(v)
	v.add_child(UI.display("FIGHTCAMP", 132, UI.GOLD))
	v.add_child(UI.muted("Run a boxing gym. Build a fighter. Win on Saturday.", UI.BODY))
	v.add_child(_gap(14))
	var saved := SaveGame.summary(main.save_path)
	if saved != "":
		var resume := _tbtn("Resume career", saved, "TBtnPrimary", main.act.bind("load", ""))
		resume.name = "Resume"
		v.add_child(resume)
	var nc := _tbtn("New career", "your past, then your club", "TBtn" if saved != "" else "TBtnPrimary", main.act.bind("newcareer", ""))
	nc.name = "NewCareer"
	v.add_child(nc)
	v.add_child(_tbtn("Quick start", "a ready club in London", "TBtn", main.act.bind("quick", "")))
	if saved != "":
		v.add_child(_tbtn("Load career", "", "TBtn", main.act.bind("load", "")))
	v.add_child(_tbtn("Settings", "", "TBtn", main.act.bind("settings", "")))
	v.add_child(_tbtn("Credits", "", "TBtn", main.act.bind("credits", "")))
	v.add_child(_tbtn("Quit", "", "TBtn", main.act.bind("quit", "")))
	v.add_child(_gap(10))
	## S367 playtest: the line said "Week 3 build" at update 66 - it names no build now, so it cannot go stale.
	v.add_child(UI.muted("Early access", UI.TINY))
	row.add_child(_card())


## The right column: a club show's fight card, two of the region's boxers in their corners' colours.
func _card() -> Control:
	var p := PanelContainer.new()
	p.name = "TitleCard"
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var sb := StyleBoxFlat.new()
	sb.bg_color = UI.PANEL
	sb.border_color = UI.LINE
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(14)
	sb.shadow_color = Color(0, 0, 0, 0.08)
	sb.shadow_size = 14
	sb.set_content_margin_all(28)
	p.add_theme_stylebox_override("panel", sb)
	var v := UI.vbox(16)
	p.add_child(v)
	v.add_child(UI.caps("SATURDAY NIGHT - CLUB SHOW - LIGHTWEIGHTS"))
	var h := UI.hbox(26)
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_child(h)
	var red := Data.lucy()
	var blue: Dictionary = Data.OPPONENTS[0]
	h.add_child(_corner(red, UI.RED))
	var vs := UI.display("VS", 64, UI.FG)
	vs.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(vs)
	h.add_child(_corner(blue, UI.GOLD))
	v.add_child(UI.label("Your gym, your fighters, your corner. The plan you write is the fight they box.", UI.BODY, UI.MUTED, "body", true))
	return p


func _corner(f: Dictionary, colour: Color) -> Control:
	var v := UI.vbox(8)
	var bar := ColorRect.new()
	bar.color = colour
	bar.custom_minimum_size = Vector2(FACE.x, 6)
	v.add_child(bar)
	var pic := PromoShot.picture(Faces.stem(f), FACE)
	if pic != null:
		v.add_child(pic)
	var n := UI.label(str(f["name"]).to_upper(), 24, UI.FG, "bold")
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(n)
	return v


func _gap(h: int) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(0, h)
	return c


## Big words on the left, a small note on the right.
func _tbtn(big: String, small: String, variation: String, cb: Callable, disabled: bool = false, why: String = "") -> Button:
	var b := UI.button("", variation, cb if cb.is_valid() else func(): pass, disabled, why)
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
