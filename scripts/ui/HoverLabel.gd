extends RefCounted
## S443 (his Q-S294-197 "Yes, build it", the Hades idea): a small secondary button with no word of its own (a back
## arrow, the fight's speed toggle) shows its word in a small dark tag under it while the mouse is on it, or it has
## keyboard focus. Main actions and the corner's calls keep their words always: this is only for small chrome.
##   HoverLabel.attach(button, "Back")   (again on the same button only changes the word)
##   HoverLabel.attach(button, "Speed (Space)", "left")   a button in a column of buttons: the tag goes beside it
## The tag is top_level, so it is never clipped by the bar it sits in, and it ignores the mouse, so it never steals the
## hover from the button. It sits under the button, above it when the window's bottom is too close, and inside the window.

const UI := preload("res://scripts/ui/UI.gd")

const TAG := "HoverTag"
const GAP := 4.0       # between the button and its tag
const EDGE := 4.0      # kept from the window's edges
const FADE_S := 0.08   # quick: Hades shows it at once; a short fade only stops a flash
const WORD_PX := 16


static func attach(target: Control, word: String, side: String = "below") -> PanelContainer:
	target.set_meta("hover_side", side)
	var tag := target.get_node_or_null(TAG) as PanelContainer
	if tag != null:
		(tag.get_child(0) as Label).text = word.to_upper()
		return tag
	tag = PanelContainer.new()
	tag.name = TAG
	tag.top_level = true
	tag.z_as_relative = false
	tag.z_index = 100
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tag.visible = false
	tag.add_theme_stylebox_override("panel", UI.box(Color(0.05, 0.04, 0.035, 0.94), Color(UI.GOLD, 0.7), 4, 1, 8, 3))
	var lab := UI.label(word.to_upper(), WORD_PX, Color.WHITE, "bold")
	lab.name = "Word"
	lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tag.add_child(lab)
	target.add_child(tag)
	target.tooltip_text = ""   # the tag is the word: a tooltip half a second later would say it twice
	target.mouse_entered.connect(open.bind(target))
	target.mouse_exited.connect(close.bind(target))
	target.focus_entered.connect(open.bind(target))
	target.focus_exited.connect(close.bind(target))
	target.visibility_changed.connect(func() -> void:
		if not target.is_visible_in_tree():
			close(target))
	return tag


static func word(target: Control) -> String:
	var tag := target.get_node_or_null(TAG)
	return (tag.get_child(0) as Label).text if tag != null else ""


static func open(target: Control) -> void:
	var tag := target.get_node_or_null(TAG) as Control
	if tag == null or not target.is_inside_tree() or not target.is_visible_in_tree():
		return
	_place(tag, target)
	_fade(tag, 1.0)
	tag.visible = true


static func close(target: Control) -> void:
	var tag := target.get_node_or_null(TAG) as Control
	if tag == null:
		return
	_fade(tag, -1.0)
	tag.visible = false


static func _fade(tag: Control, to: float) -> void:
	var old: Variant = tag.get_meta("fade") if tag.has_meta("fade") else null
	if old is Tween and (old as Tween).is_valid():
		(old as Tween).kill()
	if to < 0.0:
		return
	tag.modulate.a = 0.0
	var tw := tag.create_tween()
	tw.tween_property(tag, "modulate:a", to, FADE_S)
	tag.set_meta("fade", tw)


static func _place(tag: Control, target: Control) -> void:
	tag.reset_size()
	var s := tag.get_combined_minimum_size()
	tag.size = s
	var r := target.get_global_rect()
	var view := target.get_viewport_rect()
	var pos := Vector2(r.get_center().x - s.x * 0.5, r.end.y + GAP)
	if str(target.get_meta("hover_side", "below")) == "left":
		pos = Vector2(r.position.x - GAP - s.x, r.get_center().y - s.y * 0.5)
		if pos.x < view.position.x + EDGE:
			pos.x = r.end.x + GAP
	elif pos.y + s.y > view.end.y - EDGE:
		pos.y = r.position.y - GAP - s.y
	pos.x = clampf(pos.x, view.position.x + EDGE, maxf(view.position.x + EDGE, view.end.x - EDGE - s.x))
	tag.global_position = pos
