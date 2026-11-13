extends PanelContainer
## The walk-in at reception. S408 operator: "there is not even a picture of the fighter you are signing, there is not even a single
## icon or graphics and tone of text with unreadable small letters": the coach's office fills the screen, the fighter's photo
## is pinned up large, and the card says who they are in big words (the detail is on hover).

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Data := preload("res://scripts/state/Data.gd")
const RecruitPanel := preload("res://scripts/ui/RecruitPanel.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")


func build(main: Node, m: Dictionary) -> void:
	custom_minimum_size = main.get_viewport_rect().size
	var office := StyleBoxTexture.new()
	office.texture = load("res://assets/ui/art/sign_office.jpg")
	office.set_content_margin_all(0)
	add_theme_stylebox_override("panel", office)
	var a: Dictionary = main.career.applicant
	var picks: Array = m["picks"]
	var middle := CenterContainer.new()
	add_child(middle)
	var row := UI.hbox(34)
	middle.add_child(row)
	var photo := _photo(a)
	row.add_child(photo)
	var card := PanelContainer.new()
	card.name = "WalkInCard"
	# The old card padded 30. slate() is 30 across and 26 down, so the frame sits in that pad and the card does not grow.
	card.add_theme_stylebox_override("panel", WoodKit.slate())
	row.add_child(card)
	var v := UI.vbox(12)
	card.add_child(v)
	v.add_child(UI.caps("AT RECEPTION"))
	v.add_child(UI.display(str(a["name"]).to_upper(), 58))
	v.add_child(UI.label("%d, %s, %s, amateur %d-%d, %s" % [a["age"], str(a["wc"]).to_lower(), a["stance"], a["w"], a["l"],
		str(a["style"]).to_lower()], UI.BODY + 2, UI.MUTED))
	# S397 rank 5: each walk-in speaks for themself (FirstHour.walkin's quote); the first one's line stays.
	v.add_child(UI.label(str(a.get("quote", "\"I've had four fights at a church hall. I want a proper gym and a proper coach.\"")), UI.BODY + 2, UI.FG, "italic", true))
	# S354 the reception as an RPG recruit (operator: "get it more rpg elements to this"): RecruitPanel.
	v.add_child(RecruitPanel.build(main, main.career, a, picks, "pickcard"))
	var foot := UI.hbox(12)
	foot.add_child(UI.label("Club stipend, $250 a week", UI.BODY + 2, UI.FG, "bold"))
	foot.add_child(UI.spacer())
	# S397 a later walk-in can be turned away (the first one is the club's only boxer: Pass keeps them waiting).
	var first: bool = main.career.fighters.is_empty()
	var pass_b := UI.button("Pass", "BtnQuiet", main.act.bind("decline" if first else "passwalkin", ""))
	pass_b.name = "Pass"
	foot.add_child(pass_b)
	var focus := RecruitPanel.focus_of(picks)
	var ready := focus != "" or picks.size() == 3
	var sign := UI.button("Sign - %s" % str(Recruit.FOCUS[focus]["name"]).to_lower() if focus != "" else
		("Sign" if ready else "Sign: choose a starting focus"), "BtnSolid",
		main.act.bind("sign", ""), not ready, "Choose one starting focus first" if not ready else "")
	sign.name = "Sign"
	sign.custom_minimum_size = Vector2(0, 52)
	if ready:
		MenuFx.hover_grow(sign)
	foot.add_child(sign)
	v.add_child(foot)
	if not m.get("shown", false):   # a pick rebuilds this modal: the entrance plays once
		m["shown"] = true
		MenuFx.pop(photo, 0.05)
		MenuFx.arrive([card], 0.12)


## The fighter's photo, pinned up slightly crooked, with the name written under it.
func _photo(a: Dictionary) -> Control:
	var p := PanelContainer.new()
	p.name = "WalkInPhoto"
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("#fbfaf6")
	sb.shadow_color = Color(0.05, 0.1, 0.2, 0.45)
	sb.shadow_size = 20
	sb.shadow_offset = Vector2(4, 10)
	sb.set_content_margin_all(14)
	sb.content_margin_bottom = 18
	p.add_theme_stylebox_override("panel", sb)
	var v := UI.vbox(10)
	p.add_child(v)
	var shot := PromoShot.picture(Faces.stem(a), Vector2(320, 360))
	if shot != null:
		v.add_child(shot)
	var n := UI.label(str(a["first"]), 40, UI.FG, "marker")
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(n)
	p.rotation_degrees = -3.0
	p.resized.connect(func(): p.pivot_offset = p.size * 0.5)
	return p
