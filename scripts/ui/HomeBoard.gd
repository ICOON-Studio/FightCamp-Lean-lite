extends RefCounted
## S333 look B (operator S332 Q-S294-52 "B Gym whiteboard"): HOME's pieces as gym things - the coach's whiteboard (her
## polaroid, marker notes, the next 4 weeks), the needs as sticky notes, the money as a cash tin.
## Mockup: E:/FightCamp/Game/Godot/research/S331_looks/b_whiteboard.png.

const UI := preload("res://scripts/ui/UI.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const FighterTile := preload("res://scripts/ui/FighterTile.gd")

## S334 (operator C152 on the A-pose bust: "looks kind silly"): the polaroid is her ring photo (tools/bake_headshots.gd,
## one glove raised after a win); the old crop of the baked body portrait is only the fallback for a face never shot.
const FACES := "res://assets/ui/face"
const CROP := Rect2(0.25, 0.0, 0.5, 0.42)
const POLAROID := Vector2(330, 460)


## The fighter the board is about: the one with the soonest bout, else the first.
static func hero(c: Career) -> Dictionary:
	var best: Dictionary = {}
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if not fb.is_empty() and (best.is_empty() or best["bout"].is_empty() or int(fb["day"]) < int(best["bout"]["day"])):
			best = f
	if best.is_empty() and not c.fighters.is_empty():
		best = c.fighters[0]
	return best


static func board(main: Node, c: Career, events: Array) -> PanelContainer:
	var p := PanelContainer.new()
	p.theme_type_variation = "Board"
	p.name = "Board"
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(14)
	p.add_child(v)
	var f := hero(c)
	if f.is_empty():
		v.add_child(UI.label(c.gym_name, 46, UI.GOLD, "marker"))
		v.add_child(UI.label("No fighters yet - someone is waiting at reception.", 30, UI.FG, "hand", true))
	else:
		var title := UI.label(headline(c, f), 44, UI.GOLD, "marker", true)
		title.name = "Headline"
		v.add_child(title)
		var h := UI.hbox(40)
		h.add_child(polaroid(main, f))
		h.add_child(notes(c, f))
		v.add_child(h)
	var rule := ColorRect.new()
	rule.color = UI.FG
	rule.custom_minimum_size = Vector2(0, 3)
	v.add_child(rule)
	v.add_child(UI.label("Next 4 weeks", 28, UI.FG, "marker"))
	v.add_child(weeks(c.day, events))
	return p


## The next four weeks as marker columns on the board: each Monday's date, then a magnet per thing that happens that week
## (her bout red, weigh-in blue, the championships green, the month's bills purple).
static func weeks(today: int, events: Array) -> HBoxContainer:
	var h := UI.hbox(0)
	h.name = "Weeks"
	var monday := today - posmod(today, 7)
	for k in 4:
		var from := monday + k * 7
		var col := UI.vbox(8)
		col.name = "Week_%d" % k
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.custom_minimum_size = Vector2(0, 150)
		var edge := HBoxContainer.new()
		edge.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var bar := ColorRect.new()
		bar.color = UI.LINE
		bar.custom_minimum_size = Vector2(3, 0)
		edge.add_child(bar)
		var m := MarginContainer.new()
		m.add_theme_constant_override("margin_left", 14)
		m.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		m.add_child(col)
		edge.add_child(m)
		h.add_child(edge)
		col.add_child(UI.label(("today, " if k == 0 else "") + Clock.fmt(maxi(from, today) if k == 0 else from), 20, UI.MUTED, "hand"))
		var any := false
		for e in events:
			var d := int(e["d"])
			if d >= maxi(from, today) and d < from + 7:
				col.add_child(magnet(e))
				any = true
		if not any:
			col.add_child(UI.label("training", 24, Color(UI.FG, 0.55), "hand"))
	return h


const MAGNETS := {"bout": "#e2483d", "weigh": "#2f6fdb", "champ": "#23935d", "bill": "#8a5cf0", "review": "#5e6773"}


static func magnet(e: Dictionary) -> PanelContainer:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	var sb := UI.box(Color(str(MAGNETS.get(str(e["kind"]), "#5e6773"))), Color(0, 0, 0, 0), 999, 0, 12, 4)
	sb.shadow_color = Color(0, 0, 0, 0.2)
	sb.shadow_size = 2
	sb.shadow_offset = Vector2(0, 2)
	p.add_theme_stylebox_override("panel", sb)
	var t := str(e["t"])
	if str(e["kind"]) in ["bout", "weigh"]:
		t = "%s %s" % [t, Clock.fmt(int(e["d"])).get_slice(" ", 0)]
	p.add_child(UI.label(t, UI.SMALL, Color.WHITE, "bold"))
	p.tooltip_text = Clock.fmt(int(e["d"]))
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	return p


static func headline(c: Career, f: Dictionary) -> String:
	var fb: Dictionary = f["bout"]
	if Injuries.out(c, f):
		return "%s - out hurt" % f["first"]
	if fb.is_empty():
		return "%s - no bout booked" % f["first"]
	var days := int(fb["day"]) - c.day
	if days <= 0:
		return "%s - fight day vs %s" % [f["first"], fb["opp"]["name"]]
	return "%s - %d day%s to %s" % [f["first"], days, "" if days == 1 else "s", fb["opp"]["name"]]


## Her picture pinned to the board: her ring photo (portrait), tilted, with tape on top.
static func polaroid(main: Node, f: Dictionary) -> Control:
	var holder := Control.new()
	holder.custom_minimum_size = POLAROID + Vector2(20, 20)
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var card := PanelContainer.new()
	card.theme_type_variation = "Polaroid"
	card.name = "Polaroid"
	card.position = Vector2(10, 14)
	card.size = POLAROID
	card.pivot_offset = POLAROID * 0.5
	card.rotation = deg_to_rad(-1.8)
	var v := UI.vbox(6)
	card.add_child(v)
	var shot := Panel.new()
	shot.custom_minimum_size = Vector2(POLAROID.x - 28, POLAROID.y - 92)
	var bg := StyleBoxFlat.new()
	bg.bg_color = UI.PANEL2
	shot.add_theme_stylebox_override("panel", bg)
	v.add_child(shot)
	var pic := portrait(f)
	if pic != null:
		var tr := TextureRect.new()
		tr.texture = pic
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		shot.add_child(tr)
	var pro := bool(f.get("pro", false))
	var rec := "%d-%d" % [int(f.get("pro_w", 0)), int(f.get("pro_l", 0))] if pro else "%d-%d" % [f["w"], f["l"]]
	var cap := UI.button("%s %s" % [f["first"], rec], "Link", main.act.bind("fighter", f["id"]))
	cap.add_theme_font_override("font", UI.font("marker"))
	cap.add_theme_font_size_override("font_size", 28)
	cap.add_theme_color_override("font_color", UI.FG)
	cap.add_theme_color_override("font_hover_color", UI.GOLD)
	v.add_child(cap)
	holder.add_child(card)
	var tape := ColorRect.new()
	tape.color = Color(UI.YELLOW, 0.85)
	tape.size = Vector2(110, 30)
	tape.position = Vector2(POLAROID.x * 0.5 - 45, 0)
	tape.rotation = deg_to_rad(-1.8)
	tape.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(tape)
	return holder


static func portrait(f: Dictionary) -> Texture2D:
	var shot := FACES.path_join(Faces.stem(f) + ".jpg")
	if ResourceLoader.exists(shot):
		return load(shot)
	var p := BodyFigure.portrait_for(Faces.glb(Faces.stem(f)), "red")
	var tex := p.get("tex") as Texture2D
	if tex == null:
		return null
	var s := tex.get_size()
	var a := AtlasTexture.new()
	a.atlas = tex
	a.region = Rect2(CROP.position * s, CROP.size * s)
	return a


## The coach's marker notes beside her picture: rank and mood, weight, condition, goal, the season road.
static func notes(c: Career, f: Dictionary) -> VBoxContainer:
	var v := UI.vbox(2)
	v.name = "Notes"
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var rank := int(f.get("rank", 0))
	var who := ("No. %d %s" % [rank, str(f["wc"]).to_lower()]) if rank > 0 else str(f["wc"])
	v.add_child(_note("%s - %s" % [who, FighterTile.mood_word(f).to_lower()], UI.FG))
	var w := float(f["weight"])
	var lim := float(f["limit"])
	v.add_child(_note("Weight %.1f kg / limit %.1f %s" % [w, lim, "✓" if w <= lim else "- %.1f over" % (w - lim)],
		UI.GREEN if w <= lim else (UI.AMBER if w - lim < 1.5 else UI.RED)))
	var fat := int(f["fatigue"])
	v.add_child(_note("Condition %d - %s" % [100 - fat, "fresh" if fat < 30 else ("tired" if fat < 60 else "worn out")],
		UI.GREEN if fat < 30 else (UI.AMBER if fat < 60 else UI.RED)))
	if Injuries.out(c, f):
		v.add_child(_note(Injuries.line(c, f), UI.RED))
	var g := Sim.goal_read(c, f)
	if not g.is_empty():
		var gc := {"green": UI.GREEN, "amber": UI.AMBER, "red": UI.RED}
		v.add_child(_note("Goal: %s - %d days left" % [str(g["title"]).to_lower(), int(g["left"])], gc.get(str(g["cls"]), UI.FG)))
	var season := Champs.home_line(c, f)
	if season != "":
		v.add_child(_note(season, UI.GOLD if Champs.active(f) else UI.FG))
	return v


static func _note(text: String, col: Color) -> Label:
	return UI.label(text, 30, col, "hand", true)


## One need as a sticky note: what, why, and its button. Red needs on a pink note, the rest yellow.
static func sticky(main: Node, x: Dictionary, i: int) -> PanelContainer:
	var p := PanelContainer.new()
	p.theme_type_variation = "StickyRed" if bool(x["red"]) else ["Sticky", "StickyGreen", "StickyBlue"][i % 3]
	p.name = "Sticky_%d" % i
	p.rotation = deg_to_rad([-0.6, 0.5, -0.3, 0.7][i % 4])
	var h := UI.hbox(14)
	p.add_child(h)
	var t := UI.vbox(2)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.add_child(UI.label(str(x["t"]), 24, UI.FG, "hand", true))
	if str(x["s"]) != "":
		t.add_child(UI.label(str(x["s"]), UI.TINY + 1, Color(UI.FG, 0.75), "body", true))
	h.add_child(t)
	var b := UI.button(str(x["label"]), "Ink", main.act.bind(x["act"], x["arg"]))
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(b)
	return p


## The cash tin: the cash big, then this week in and out and what the next bill holds.
static func cash_tin(c: Career) -> PanelContainer:
	var p := PanelContainer.new()
	p.theme_type_variation = "Tin"
	p.name = "CashTin"
	var v := UI.vbox(4)
	p.add_child(v)
	v.add_child(UI.label("Cash tin", 28, UI.GOLD, "marker"))
	var col := UI.GREEN if c.cash >= 0 else UI.RED
	var big := UI.label(UI.money(c.cash), 72, col, "bold")
	big.name = "Cash"
	v.add_child(big)
	var inc: Dictionary = Sim.weekly_income(c)
	var cost: Dictionary = Sim.weekly_costs(c)
	UI.add_rows(v, [
		UI.kv("In this week", UI.signed(int(inc["total"])), UI.GREEN, "bold"),
		UI.kv("Costs this week", UI.signed(-int(cost["total"])), UI.FG, "bold"),
		UI.kv("Owed, billed %s" % Clock.fmt(GameMoney.next_bill_day(c.day)), UI.money(c.accrued), UI.FG, "bold"),
	])
	return p
