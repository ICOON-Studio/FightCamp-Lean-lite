extends SceneTree
## S414 the owner, on the gym builder modelled on Gym Equipment Rental's planner: "Yes, draw it first", then "strengthen the connection
## between equipment and fighters/members", "zoom it, plenty of dead space", "fit to the edges or add the extra rooms". A picture, not
## a feature: the real top bar, drawn gym (IsoGym), people (HubFigures), rules (GymPlan.problems), places (GymPlaces.fill) and upgrade
## prices (GymUpgrades), with the builder's panels laid over. Two stills: a piece being placed, and one the rules refuse.
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 --script res://tools/gym_builder_still.gd -- <out_dir>

const UI := preload("res://scripts/ui/UI.gd")
const Dark := preload("res://scripts/ui/DarkOverview.gd")
const IsoGym := preload("res://scripts/ui/IsoGym.gd")
const GymPlan := preload("res://scripts/rules/GymPlan.gd")
const GymPlaces := preload("res://scripts/rules/GymPlaces.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const GymPeople := preload("res://scripts/rules/GymPeople.gd")
const HubFigures := preload("res://scripts/ui/HubFigures.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

const W := 1920.0
const H := 1080.0
const BAR := 78.0
const STRIP := 62.0
const RAIL := 150.0
const SIDE := 306.0
const CAP := 47   # the bigger unit's places, FLOOR_PLACES_S411.md
const MEMBERS := 140   # a club at that unit's limit, so the floor is busy in the picture
const GOLD := Color("#ffd54a")
const GOOD := Color("#2fb56e")
const BAD := Color("#e2483d")
const BLUE := Color("#3f7fe0")
const BAG_SPOT := Vector2i(14, 2)
const BAG_FIGHTER := Vector2i(13, 2)
const RACK_REFUSED := Vector2i(18, 8)
const RACK_PICKED := Vector2i(21, 6)
const TRAINING := [["ring", "Ring"], ["bag", "Heavy bag"], ["rack", "Weights rack"], ["bench", "Bench"], ["mat", "Floor mat"]]
## S414 "add descriptions on each item and what it improves/cost". Costs are real kit prices (ops/research/GYM_PLANNER_SITES_S414.md);
## what each builds is a proposal: nothing in the game reads it yet.
const INFO := {
	"ring": {"cost": "$3,500", "builds": "Footwork, Ring IQ", "what": "Sparring and pad rounds, five pairs at once."},
	"bag": {"cost": "$570", "builds": "Power, Technique", "what": "One boxer at a time, working the shots."},
	"rack": {"cost": "$1,050", "builds": "Power, Conditioning", "what": "Dumbbells on a rack, four people lifting."},
	"bench": {"cost": "$400", "builds": "Power", "what": "Two people taking turns on the weights."},
	"mat": {"cost": "$390", "builds": "Conditioning, Defence", "what": "Stretching, floor work and drills for three."},
}
## One meter a zone (the owner: "remove the dots ... use one meter per zone"): item kind, name, the floor tile it stands on.
const METERS := [["ring", "Ring", 14.0, 9.0], ["bag", "Bags", 16.0, 3.7], ["rack", "Weights", 18.6, 6.5], ["mat", "Mats", 16.0, 13.3]]
## The rooms round the building: the real upgrades and the next premises (GymUpgrades.LIST, PREMISES). [x, y, w, h, name, line, tag x, tag y]
const PLOTS := [
	[25.0, 1.0, 12.0, 16.0, "Club building, two floors", "$25,000: room for 250 members", 25.5, 5.0],
	[2.0, -12.0, 10.0, 11.0, "Fitness studio", "$1,500: +$420 a week", 7.0, -6.0],
	[13.0, -12.0, 10.0, 11.0, "Strength corner", "$3,600: Power, Conditioning +10%", 14.0, -3.0],
	[-12.0, 1.0, 11.0, 16.0, "Youth section", "$1,800: 20 juniors' dues", -6.0, 9.0],
]

var main: Node
var out_dir := "user://builder_still"
var turned := false


## The owner: "if you rotate the camera a bit clockwise it can fit a bigger part of the gym". The floor and walls follow the turn;
## the equipment and people are pictures painted at the old angle, so here they do not turn.
class Rotated extends "res://scripts/ui/IsoGym.gd":
	const TURN := -20.0   # the owner: "i meant the other way"

	func _axes() -> Array:
		var phi: float = deg_to_rad(45.0 - TURN)
		var k: float = 32.0 * sqrt(2.0)
		return [Vector2(cos(phi), sin(phi) * 0.5) * k, Vector2(-sin(phi), cos(phi) * 0.5) * k]

	func _fit() -> void:
		if plan.is_empty():
			return
		var a: Array = _axes()
		var ex: Vector2 = a[0] * float(plan["w"])
		var ey: Vector2 = a[1] * float(plan["h"])
		var low := Vector2(minf(minf(0.0, ex.x), minf(ey.x, ex.x + ey.x)), minf(minf(0.0, ex.y), minf(ey.y, ex.y + ey.y)))
		var high := Vector2(maxf(maxf(0.0, ex.x), maxf(ey.x, ex.x + ey.x)), maxf(maxf(0.0, ex.y), maxf(ey.y, ex.y + ey.y)))
		var box := Vector2(high.x - low.x, high.y - low.y + WALL)
		_scale = minf(size.x / box.x, size.y / box.y) * 0.995
		_origin = Vector2((size.x - box.x * _scale) * 0.5 - low.x * _scale, (size.y - box.y * _scale) * 0.5 + WALL * _scale - low.y * _scale)

	func tile(p: Vector2) -> Vector2:
		var a: Array = _axes()
		return _origin + (a[0] * p.x + a[1] * p.y) * _scale


## Everything round the building: street, car park and the locked rooms, out to the edges of the screen.
class Surround extends Control:
	var iso: Control

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _poly(x: float, y: float, w: float, h: float, col: Color) -> void:
		draw_colored_polygon(iso._diamond(x, y, w, h), col)

	func _draw() -> void:
		draw_rect(Rect2(-400, -300, 3200, 2000), Color("#4b4842"))
		_poly(-60.0, 18.0, 140.0, 2.0, Color("#8d8880"))   # the pavement
		_poly(-60.0, 24.0, 140.0, 9.0, Color("#2b2c30"))   # the street
		_poly(-60.0, 20.0, 140.0, 4.0, Color("#35363a"))   # the car park
		var i := 6.0
		while i < 24.0:
			draw_line(iso.tile(Vector2(i, 20.3)), iso.tile(Vector2(i, 23.2)), Color(1, 1, 1, 0.65), 3.0)
			i += 2.5
		var x := -40.0
		while x < 70.0:
			draw_line(iso.tile(Vector2(x, 28.5)), iso.tile(Vector2(x + 2.0, 28.5)), Color("#e9c84a"), 4.0)
			x += 4.0
		for p in PLOTS:
			_plot(float(p[0]), float(p[1]), float(p[2]), float(p[3]))

	func _plot(x: float, y: float, w: float, h: float) -> void:
		_poly(x, y, w, h, Color("#3a3631"))
		var up := Vector2(0, -58.0 * iso._scale)
		for edge in [[Vector2(x, y), Vector2(x + w, y), Color("#6f6a61")], [Vector2(x, y), Vector2(x, y + h), Color("#5e5a52")]]:
			var a: Vector2 = iso.tile(edge[0])
			var b: Vector2 = iso.tile(edge[1])
			draw_colored_polygon(PackedVector2Array([a, b, b + up, a + up]), edge[2])
		var d: PackedVector2Array = iso._diamond(x, y, w, h)
		for k in 4:
			draw_dashed_line(d[k], d[(k + 1) % 4], GOLD, 3.0, 14.0, true)


## What the builder lays on the floor: the grid, the dots of each piece, the place a piece may go, the ghost, the turning ring.
class Marks extends Control:
	var iso: Control
	var plan: Dictionary
	var mode := ""
	var filled: Dictionary

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		if mode == "clean":
			return
		var w := int(plan["w"])
		var h := int(plan["h"])
		var line := Color(1, 1, 1, 0.12)
		for x in range(0, w + 1):
			draw_line(iso.tile(Vector2(x, 0)), iso.tile(Vector2(x, h)), line, 1.0)
		for y in range(0, h + 1):
			draw_line(iso.tile(Vector2(0, y)), iso.tile(Vector2(w, y)), line, 1.0)
		if mode == "place":
			for z in plan["zones"]:
				if str(z["kind"]) == "bags":
					_outline(float(z["x"]), float(z["y"]), float(z["w"]), float(z["h"]), GOLD, 4.0)
			_ghost("bag", float(BAG_SPOT.x), float(BAG_SPOT.y), 1.0, 1.0, GOOD)
			_turn_ring(float(RACK_PICKED.x) + 1.0, float(RACK_PICKED.y) + 0.5)
		else:
			_ghost("rack", float(RACK_REFUSED.x), float(RACK_REFUSED.y), 2.0, 1.0, BAD)

	func _outline(x: float, y: float, w: float, h: float, col: Color, thick: float) -> void:
		var d: PackedVector2Array = iso._diamond(x, y, w, h)
		d.append(d[0])
		draw_polyline(d, col, thick, true)

	func _ghost(kind: String, x: float, y: float, w: float, h: float, col: Color) -> void:
		draw_colored_polygon(iso._diamond(x, y, w, h), Color(col, 0.6))
		_outline(x, y, w, h, col, 3.0)
		var tex: Texture2D = load(IsoGym.ART % kind)
		var wide: float = (w + h) * IsoGym.TW * 0.5 * iso._scale * 1.06 * float(IsoGym.SIZE.get(kind, 1.0))
		var high: float = wide * float(tex.get_height()) / float(tex.get_width())
		var foot: Vector2 = iso.tile(Vector2(x + w, y + h))
		var mid: Vector2 = iso.tile(Vector2(x + w * 0.5, y + h * 0.5))
		draw_texture_rect(tex, Rect2(mid.x - wide * 0.5, foot.y - high, wide, high), false, Color(1, 1, 1, 0.92))

	func _turn_ring(x: float, y: float) -> void:
		var c: Vector2 = iso.tile(Vector2(x, y))
		var r: float = 70.0 * iso._scale
		draw_set_transform(c, 0.0, Vector2(1.0, 0.5))
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 72, Color.WHITE, 5.0, true)
		for i in 4:
			draw_circle(Vector2.from_angle(float(i) * PI * 0.5) * r, 10.0, GOLD)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(int(W), int(H))
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
	main.act("newcareer")
	main.act("quick")
	await _settle(6)
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	await _settle(8)
	var c: Career = main.career
	var plan: Dictionary = GymBonus.plan(c.gym_plan)
	await _shot(c, plan, "clean", "builder_clean")
	await _shot(c, plan, "place", "builder_place")
	await _shot(c, plan, "refused", "builder_refused")
	turned = true
	await _shot(c, plan, "place", "builder_turned")
	print("BUILDER_STILL DONE")
	quit(0)


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _with(plan: Dictionary, kind: String, at: Vector2i) -> Dictionary:
	var p: Dictionary = plan.duplicate(true)
	(p["items"] as Array).append({"kind": kind, "x": at.x, "y": at.y})
	return p


func _shot(c: Career, plan: Dictionary, mode: String, file: String) -> void:
	var placing: bool = mode == "place"
	var clean: bool = mode == "clean"
	var test: Dictionary = plan if clean else (_with(plan, "bag", BAG_SPOT) if placing else _with(plan, "rack", RACK_REFUSED))
	var problems: Array = GymPlan.problems(test)
	var f: Dictionary = c.fighters[0]
	var boxers: Array = [{"station_kind": "bag"}]
	var before: Dictionary = GymPlaces.fill(plan, MEMBERS, boxers)
	var shown_plan: Dictionary = test if problems.is_empty() else plan
	var after: Dictionary = GymPlaces.fill(shown_plan, MEMBERS, boxers)
	print("BUILDER_RULES mode=%s problems=%s before=%s after=%s" % [mode, str(problems), str(before), str(after)])
	var s := Control.new()
	s.theme = UI.theme()
	s.position = Vector2(0, BAR)
	s.size = Vector2(W, H - BAR)
	s.clip_contents = true
	root.add_child(s)
	var iso: Control = Rotated.new() if turned else IsoGym.new()
	iso.plan = shown_plan
	iso.position = Vector2.ZERO   # the whole window under the game's top bar; the controls float in the corners with no floor
	iso.size = Vector2(W, H - BAR)
	var around := Surround.new()
	around.iso = iso
	around.position = iso.position
	around.size = iso.size
	s.add_child(around)
	s.add_child(iso)
	iso._fit()
	print("BUILDER_SCALE turned=%s scale=%.3f" % [str(turned), iso._scale])
	var people := _figures(iso, shown_plan, Faces.stem(f))
	s.add_child(people)
	var marks := Marks.new()
	marks.iso = iso
	marks.plan = shown_plan
	marks.mode = mode
	marks.filled = after
	marks.position = iso.position
	marks.size = iso.size
	s.add_child(marks)
	if not clean:
		for m in METERS:
			_meter(s, iso, m, after)
	for p in PLOTS:
		if not (turned and str(p[4]).begins_with("Club")):   # the turned view has no free floor for it
			_plot_tag(s, iso, p)
	if clean:
		await _finish(s, file)
		return
	_fighter_tag(s, iso, f)
	if placing:
		_tag(s, iso, Vector2(BAG_SPOT) + Vector2(0.5, 0.5), "+1 place", GOOD, -175.0)
		var row := UI.hbox(8)
		row.position = iso.position + iso.tile(Vector2(RACK_PICKED) + Vector2(1.0, 0.5)) + Vector2(-98, -150.0)
		row.add_child(_quiet("Turn"))
		row.add_child(_quiet("Remove"))
		s.add_child(row)
	else:
		_tag(s, iso, Vector2(RACK_REFUSED) + Vector2(1.0, 0.5), str(problems[0]) if not problems.is_empty() else "", BAD, 40.0)
	_top_hud(s, problems.is_empty())
	s.add_child(_tray(placing))
	s.add_child(_gym_panel(after))
	s.add_child(_piece_panel(placing, f, before, after))
	await _finish(s, file)


func _finish(s: Control, file: String) -> void:
	await _settle(30)
	await RenderingServer.frame_post_draw
	var p2 := out_dir.path_join(file + ".png")
	root.get_texture().get_image().save_png(p2)
	print("wrote ", p2)
	s.queue_free()
	await _settle(2)


## The real figures at their stations; the club's boxer on the bag beside the new one.
func _figures(iso: Control, plan: Dictionary, stem: String) -> Control:
	var fig: Control = HubFigures.new()
	fig.position = iso.position
	fig.size = iso.size
	fig.setup(iso, plan, GymPeople.crowd(MEMBERS, [stem]), 7)
	for i in fig.people.size():
		var p: Dictionary = fig.people[i]
		if Vector2i(p["tile"]) == BAG_FIGHTER and i != 0:
			p["tile"] = fig.people[0]["tile"]
			p["clip"] = fig.people[0]["clip"]
			p["flip"] = fig.people[0]["flip"]
	var me: Dictionary = fig.people[0]
	me["tile"] = Vector2(BAG_FIGHTER)
	me["clip"] = "jab_back"
	me["flip"] = true
	return fig


func _quiet(text: String) -> Button:
	var b := UI.button(text, "Btn", func(): pass)
	return Dark._quiet(b)


func _tag(s: Control, iso: Control, tile: Vector2, text: String, col: Color, up: float) -> void:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(col.darkened(0.25), Color.WHITE, 6, 2, 14, 7))
	p.add_child(UI.label(text, 20, Color.WHITE, "bold"))
	s.add_child(p)
	p.reset_size()
	p.position = iso.position + iso.tile(tile) + Vector2(-p.size.x * 0.5, up)


## A zone's meter: how full it is at the busy hour. Red when there is no place left.
func _meter(s: Control, iso: Control, m: Array, filled: Dictionary) -> void:
	var d: Dictionary = filled.get(str(m[0]), {})
	var taken: int = int(d.get("taken", 0))
	var places: int = int(d.get("places", 0))
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.04, 0.88), Color(0, 0, 0, 0), 6, 0, 10, 5))
	var h := UI.hbox(8)
	h.add_child(UI.label(str(m[1]), 18, Color.WHITE, "bold"))
	var bar := Dark.Bar.new()
	bar.frac = float(taken) / maxf(1.0, float(places))
	bar.colour = BAD if taken >= places else GOOD
	bar.custom_minimum_size = Vector2(96, 18)
	h.add_child(bar)
	h.add_child(UI.label("%d/%d" % [taken, places], 18, Color.WHITE, "bold"))
	p.add_child(h)
	s.add_child(p)
	p.reset_size()
	p.position = iso.position + iso.tile(Vector2(float(m[2]), float(m[3]))) - p.size * 0.5


func _plot_tag(s: Control, iso: Control, plot: Array) -> void:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(0.08, 0.06, 0.05, 0.88), GOLD, 6, 1, 12, 7))
	var v := UI.vbox(0)
	v.add_child(UI.label(str(plot[4]), 19, Color.WHITE, "bold"))
	v.add_child(UI.label(str(plot[5]), 15, GOLD, "semi"))
	p.add_child(v)
	s.add_child(p)
	p.reset_size()
	p.position = iso.position + iso.tile(Vector2(float(plot[6]), float(plot[7]))) - p.size * 0.5


## The boxer's name and stamina over the figure, as the owner asked in S411 ("a bar showing stamina next to each fighter").
func _fighter_tag(s: Control, iso: Control, f: Dictionary) -> void:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(0.08, 0.06, 0.05, 0.9), GOOD, 5, 1, 8, 4))
	var v := UI.vbox(2)
	v.add_child(UI.label(str(f["first"]), 16, Color.WHITE, "bold"))
	v.add_child(_stamina(f, 76.0))
	p.add_child(v)
	s.add_child(p)
	p.reset_size()
	p.position = iso.position + iso.tile(Vector2(BAG_FIGHTER) + Vector2(0.5, 0.5)) + Vector2(-p.size.x - 10.0, -96.0)


func _stamina(f: Dictionary, w: float) -> Control:
	var bar := Dark.Bar.new()
	bar.frac = 1.0 - FighterProfile.fatigue(f) / 100.0
	bar.colour = GOOD
	bar.custom_minimum_size = Vector2(w, 12)
	return bar


func _top_hud(s: Control, ok: bool) -> void:
	var left := UI.vbox(6)
	left.position = Vector2(16, 8)
	left.add_child(UI.display("Build your gym", 32, Color.WHITE))
	var steps := UI.hbox(6)
	for step in [["1  Building", "Tab"], ["2  Zones", "Tab"], ["3  Pieces", "TabOn"]]:
		steps.add_child(UI.button(step[0], step[1], func(): pass))
	left.add_child(steps)
	s.add_child(left)
	var h := UI.hbox(8)
	h.add_child(UI.button("3/4 view", "TabOn", func(): pass))
	h.add_child(UI.button("Floor plan", "Tab", func(): pass))
	h.add_child(_quiet("Undo"))
	h.add_child(_quiet("Cancel"))
	if ok:
		var done := UI.button("Open the gym", "BtnSolid", func(): pass)
		Dark.main_style(done)
		done.custom_minimum_size.y = 46.0
		done.add_theme_font_size_override("font_size", 20)
		h.add_child(done)
	else:
		var fix := PanelContainer.new()
		fix.add_theme_stylebox_override("panel", UI.box(BAD.darkened(0.25), Color(0, 0, 0, 0), 6, 0, 16, 9))
		fix.add_child(UI.label("Fix the red piece first", 20, Color.WHITE, "bold"))
		fix.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(fix)
	s.add_child(h)
	h.reset_size()
	h.position = Vector2(W - h.size.x - 12.0, 8)


func _small_panel(pos: Vector2, size: Vector2) -> Array:
	var p := PanelContainer.new()
	var sb := UI.box(Dark.PANEL_BG, Color(0, 0, 0, 0), 8, 0, 12, 9)
	sb.border_color = Dark.EDGE
	sb.border_width_top = 3
	p.add_theme_stylebox_override("panel", sb)
	p.position = pos
	p.size = size
	p.custom_minimum_size = size
	var v := UI.vbox(6)
	p.add_child(v)
	return [p, v]


## The pieces: a tray in the bottom-left corner, on the street.
func _tray(placing: bool) -> Control:
	var c: Array = _small_panel(Vector2(10, H - BAR - 190.0), Vector2(786, 182))
	var row := UI.hbox(6)
	var tabs := UI.vbox(6)
	tabs.add_child(UI.button("Train", "TabOn", func(): pass))
	tabs.add_child(UI.button("Rooms", "Tab", func(): pass))
	row.add_child(tabs)
	for it in TRAINING:
		row.add_child(_tile(str(it[0]), str(it[1]), str(it[0]) == ("bag" if placing else "rack")))
	c[1].add_child(row)
	return c[0]


func _tile(kind: String, name_: String, on: bool) -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Dark.INSET, GOLD if on else Dark.SIDE, 6, 3 if on else 1, 6, 3))
	p.custom_minimum_size = Vector2(130, 160)
	var v := UI.vbox(0)
	var pic := TextureRect.new()
	pic.texture = load(IsoGym.ART % kind)
	pic.custom_minimum_size = Vector2(0, 54)
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	v.add_child(pic)
	v.add_child(UI.label(name_, 15, Dark.INK, "bold"))
	var places: int = int(GymPlaces.PLACES_OF.get(kind, 0))
	v.add_child(UI.label(str(INFO[kind]["builds"]), 15, Color("#9cc2ff"), "semi", true))
	var money := UI.hbox(6)
	money.add_child(UI.label("+%d" % places, 15, GOLD, "bold"))
	money.add_child(UI.spacer())
	money.add_child(UI.label(str(INFO[kind]["cost"]), 15, Color.WHITE, "bold"))
	v.add_child(money)
	p.add_child(v)
	return p


func _gym_panel(after: Dictionary) -> Control:
	var c: Array = _small_panel(Vector2(W - SIDE - 12.0, 66.0), Vector2(SIDE, 104))
	var body: VBoxContainer = c[1]
	var total := 0
	for k in after:
		if k != "waiting":
			total += int((after[k] as Dictionary).get("places", 0))
	var big := UI.hbox(6)
	big.add_child(UI.label(str(total), 44, Color.WHITE, "bold"))
	var of := UI.label("/ %d places" % CAP, 22, Dark.SOFT, "bold")
	of.size_flags_vertical = Control.SIZE_SHRINK_END
	big.add_child(of)
	body.add_child(big)
	var waiting: int = int(after.get("waiting", 0))
	body.add_child(UI.label("%d members, %d with no place" % [MEMBERS, waiting], 17, BAD if waiting > 0 else GOOD, "bold", true))
	return c[0]


## Who uses the piece in hand: the link from the equipment to the boxers and the members.
func _piece_panel(placing: bool, f: Dictionary, before: Dictionary, after: Dictionary) -> Control:
	var c: Array = _small_panel(Vector2(W - 392.0 - 12.0, H - BAR - 204.0), Vector2(392, 196))
	var body: VBoxContainer = c[1]
	var trains := UI.hbox(8)
	trains.add_child(UI.label("HEAVY BAG" if placing else "WEIGHTS RACK", 21, GOLD, "bold"))
	var info: Dictionary = INFO["bag" if placing else "rack"]
	for word in str(info["builds"]).split(", "):
		var chip := PanelContainer.new()
		chip.add_theme_stylebox_override("panel", UI.box(BLUE, Color(0, 0, 0, 0), 4, 0, 8, 2))
		chip.add_child(UI.label(word, 16, Color.WHITE, "bold"))
		trains.add_child(chip)
	trains.add_child(UI.spacer())
	trains.add_child(UI.label(str(info["cost"]), 22, Color.WHITE, "bold"))
	body.add_child(trains)
	body.add_child(UI.label(str(info["what"]), 16, Dark.SOFT, "body", true))
	var who := UI.hbox(10)
	var face: Control = PromoShot.picture(Faces.stem(f), Vector2(50, 60))
	if face != null:
		who.add_child(face)
	var v := UI.vbox(3)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.label(str(f["name"]), 18, Color.WHITE, "bold"))
	v.add_child(UI.label("Trains here this week", 15, Dark.SOFT))
	v.add_child(_stamina(f, 150.0))
	who.add_child(v)
	if placing:   # the boxer in the drawing trains on the bags, not the racks
		body.add_child(who)
	var key: String = "bag" if placing else "rack"
	var d: Dictionary = after.get(key, {})
	body.add_child(UI.label("Members here at the busy hour: %d" % int(d.get("taken", 0)), 16, Dark.INK, "semi", true))
	var w0: int = int(before.get("waiting", 0))
	var w1: int = int(after.get("waiting", 0))
	if placing:
		var freed: int = w0 - w1
		body.add_child(UI.label("This bag: %d %s no longer wait%s" % [freed, "person" if freed == 1 else "people", "s" if freed == 1 else ""], 18, GOOD, "bold", true))
	else:
		body.add_child(UI.label("Racks go in the weights zone", 18, BAD, "bold", true))
	return c[0]
