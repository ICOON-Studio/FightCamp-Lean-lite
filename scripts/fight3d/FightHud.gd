extends RefCounted
## The fight view's scorebug, caption box, banner and button row (moved out of FightView, S308, to keep it under 500
## lines). build(view) creates them on the view and sets its _bug_box / _bug / _clock / _buttons / _cap_box / _caption / _banner.

const UI := preload("res://scripts/ui/UI.gd")


static func build(view: Control) -> void:
	var bug := PanelContainer.new()
	bug.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.86), UI.LINE, 6, 1, 14, 10))
	bug.position = Vector2(28, 24)
	view.add_child(bug)
	view._bug_box = bug
	var bv := UI.vbox(2)
	bug.add_child(bv)
	view._bug = UI.label("", UI.BODY, UI.FG, "bold")
	bv.add_child(view._bug)
	view._clock = UI.mono("", UI.SMALL, UI.MUTED)
	bv.add_child(view._clock)
	view._buttons = UI.hbox(8)
	view._buttons.alignment = BoxContainer.ALIGNMENT_END
	view.add_child(view._buttons)
	pin(view._buttons, Vector4(1, 0, 1, 0), Vector4(-640, 24, -28, 68))
	view._cap_box = PanelContainer.new()
	view._cap_box.add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.03, 0.03, 0.78), Color(0, 0, 0, 0), 6, 0, 22, 10))
	view._cap_box.visible = false
	view.add_child(view._cap_box)
	pin(view._cap_box, Vector4(0.5, 1, 0.5, 1), Vector4(-620, -78, 620, -22))
	view._caption = UI.label("", 26, UI.FG, "body", true)
	view._caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	view._caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	view._cap_box.add_child(view._caption)
	view._banner = UI.display("", 64)
	view._banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	view._banner.add_theme_constant_override("outline_size", 10)
	view._banner.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	view.add_child(view._banner)
	pin(view._banner, Vector4(0.5, 0, 0.5, 0), Vector4(-640, 150, 640, 250))


## Anchors (left, top, right, bottom) and offsets in pixels from them.
static func pin(c: Control, anchors: Vector4, offsets: Vector4) -> void:
	c.anchor_left = anchors.x
	c.anchor_top = anchors.y
	c.anchor_right = anchors.z
	c.anchor_bottom = anchors.w
	c.offset_left = offsets.x
	c.offset_top = offsets.y
	c.offset_right = offsets.z
	c.offset_bottom = offsets.w
