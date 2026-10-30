extends RefCounted
## The fight view's scorebug, caption box, banner and button row (moved out of FightView, S308, to keep it under 500
## lines). build(view) creates them on the view and sets its _bug_box / _bug / _clock / _buttons / _cap_box / _caption / _banner.

const UI := preload("res://scripts/ui/UI.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")


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
	_build_status(view, bv)
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


## S310 (operator: "the player needs more visual hints on what is going on, where is stamina, body damage, nothing is
## shown anywhere"): under the scorebug, a row per boxer - energy bar, body shots taken, HURT. Painted from what the
## watched exchanges left (LiveRound.state "after"), so it never runs ahead of the ring. Bars tween; a band change pulses.
const BAR_W := 170.0
const BANDS := [[60.0, Color("#6cc27a")], [35.0, Color("#f0a020")], [0.0, Color("#e0503c")]]


static func _build_status(view: Control, parent: VBoxContainer) -> void:
	var rows: Array = []
	for side in 2:
		var row := UI.hbox(8)
		var who := UI.label("", UI.TINY, Color(0.95, 0.4, 0.35) if side == 0 else Color(0.5, 0.65, 1.0), "bold")
		who.custom_minimum_size = Vector2(70, 0)
		row.add_child(who)
		var back := ColorRect.new()
		back.color = Color(1, 1, 1, 0.12)
		back.custom_minimum_size = Vector2(BAR_W, 10)
		back.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var fill := ColorRect.new()
		fill.size = Vector2(BAR_W, 10)
		back.add_child(fill)
		row.add_child(back)
		var energy := UI.mono("", UI.TINY, UI.FG)
		energy.custom_minimum_size = Vector2(92, 0)
		row.add_child(energy)
		var body := UI.mono("", UI.TINY, UI.MUTED)
		body.custom_minimum_size = Vector2(110, 0)
		row.add_child(body)
		var hurt := UI.label("HURT", UI.TINY, UI.RED, "bold")
		hurt.visible = false
		row.add_child(hurt)
		parent.add_child(row)
		rows.append({"who": who, "fill": fill, "energy": energy, "body": body, "hurt": hurt, "v": -1.0})
	view.set_meta("status_rows", rows)


static func _band(v: float) -> Color:
	for b in BANDS:
		if v >= float(b[0]):
			return b[1]
	return BANDS[-1][1]


## snap = LiveRound.state (energy a/b, body [hers, theirs], hurt [hers, theirs]); names = [hers, the opponent's].
static func paint(view: Control, snap: Dictionary, names: Array) -> void:
	if snap.is_empty() or not view.has_meta("status_rows"):
		return
	var rows: Array = view.get_meta("status_rows")
	for side in 2:
		var r: Dictionary = rows[side]
		var v := clampf(float(snap["a" if side == 0 else "b"]), 0.0, 100.0)
		(r["who"] as Label).text = str(names[side]).to_upper()
		(r["energy"] as Label).text = "ENERGY %d" % int(round(v))
		var taken := int((snap.get("body", [0, 0]) as Array)[side])
		(r["body"] as Label).text = "BODY HITS %d" % taken
		(r["body"] as Label).add_theme_color_override("font_color", UI.MUTED if taken < 6 else (UI.AMBER if taken < 12 else UI.RED))
		(r["hurt"] as Label).visible = bool((snap.get("hurt", [false, false]) as Array)[side])
		var fill: ColorRect = r["fill"]
		if absf(v - float(r["v"])) < 0.5:
			continue
		var old_color := fill.color
		fill.color = _band(v)
		var t := fill.create_tween()
		t.tween_property(fill, "size:x", BAR_W * v / 100.0, 0.6 if float(r["v"]) >= 0.0 else 0.0)
		if float(r["v"]) >= 0.0 and old_color != fill.color:
			var pulse := fill.create_tween()
			pulse.tween_property(fill, "modulate", Color(1.6, 1.6, 1.6), 0.15)
			pulse.tween_property(fill, "modulate", Color.WHITE, 0.35)
		r["v"] = v


## The fight display before this round's first exchange: the live round's start, or the closed round's.
static func round_start(view: Control) -> Dictionary:
	var main: Node = view.main
	if main == null:
		return {}
	var lv := LiveRound.live(main.modal)
	if not lv.is_empty():
		return lv.get("start", {})
	var rounds: Array = main.modal.get("rounds", [])
	var n := int(view.round_n)
	return (rounds[n - 1] as Dictionary).get("start", {}) if n >= 1 and rounds.size() >= n else {}
