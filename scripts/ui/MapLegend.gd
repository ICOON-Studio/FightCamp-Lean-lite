extends RefCounted
## S342 the move map's key (operator C161 on the plan board: "can we have more explaining on this"): what each line colour
## means, the loop, "8 out 6 in", and in plan mode the three steps that build a plan. Sits in the map's empty bottom-left.
##   build(plan_mode) -> PanelContainer

const UI := preload("res://scripts/ui/UI.gd")


static func build(plan_mode: bool) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(UI.PANEL, 0.92), UI.LINE, 8, 1, 14, 10))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := UI.vbox(5)
	p.add_child(v)
	v.add_child(UI.caps("HOW TO READ IT"))
	# Two columns, so the key fits the strip under the bottom cards.
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 28)
	grid.add_theme_constant_override("v_separation", 4)
	v.add_child(grid)
	_key(grid, _line(UI.GREEN, 5.0), "The plan: this move from that card")
	_key(grid, _line(UI.GOLD, 3.0), "Moves from the card you picked")
	_key(grid, _line(Color(UI.GREEN, 0.55), 3.0), "The plan, only in its WHEN (tired...)")
	_key(grid, _line(Color(UI.MUTED, 0.35), 1.5), "Every other move (grey: done TO your fighter)")
	_key(grid, _loop(), "She stays on the card (a feint, a combo)")
	_key(grid, UI.label("3 out 2 in", UI.TINY, UI.MUTED), "Moves that leave / arrive at a card")
	if plan_mode:
		v.add_child(UI.sep())
		var h := UI.hbox(14)
		h.add_child(UI.label("Build it:  1  pick a card    2  pick WHEN    3  take a move out", UI.SMALL, UI.FG, "semi"))
		h.add_child(UI.muted("She follows your arrows from wherever she is; where she has none, she improvises.", UI.TINY))
		v.add_child(h)
	return p


static func _key(v: Container, swatch: Control, words: String) -> void:
	var h := UI.hbox(10)
	swatch.custom_minimum_size = Vector2(56, 16)
	h.add_child(swatch)
	h.add_child(UI.label(words, UI.TINY, UI.FG))
	v.add_child(h)


static func _line(col: Color, w: float) -> Control:
	var c := Control.new()
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func():
		var y := c.size.y * 0.5
		c.draw_line(Vector2(2, y), Vector2(c.size.x - 12, y), col, w, true)
		c.draw_colored_polygon(PackedVector2Array([Vector2(c.size.x - 2, y), Vector2(c.size.x - 13, y - 6), Vector2(c.size.x - 13, y + 6)]), col))
	return c


static func _loop() -> Control:
	var c := Control.new()
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func():
		var o := Vector2(16, c.size.y * 0.5)
		c.draw_arc(o, 7.0, PI * 0.15, PI * 1.85, 16, UI.GREEN, 3.0, true)
		var tip := o + Vector2(cos(PI * 0.15), sin(PI * 0.15)) * 7.0
		c.draw_colored_polygon(PackedVector2Array([tip + Vector2(0, 5), tip + Vector2(-5, -2), tip + Vector2(5, -2)]), UI.GREEN))
	return c
