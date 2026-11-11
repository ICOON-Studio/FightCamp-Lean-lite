extends HBoxContainer
## S381 G2 (gym idea 3, operator "Yes, build both"): the WEEKS STRIP - the camp counted down to fight night in one row:
## "4 BUILD | 3 BUILD | 2 PEAK | 1 TAPER | <fight poster: the opponent's face + the date>". This week is gold, the weeks
## gone are pencil, a red tick stands after the last week with sparring (no hard spar after it), and glove pips under each
## cell are that week's sparring nights (WeekPhase.spar; this week's own count when the player changed it). Clicking a week
## still to come shows the coach's projected week for it, read-only (the seven days, morning and evening, one line each).
## Top of the FIGHT CAMP modal and the whiteboard header; it replaced the Build/Peak/Taper bar and "camp week 2 of 4".
## S382 G3 (gym idea 4): a sparring night used for a Playbook test (PlanTest, SparNights) darkens its glove pip to ink.
##   cells(bout_day, today, start, spar_now) -> [{to_go, phase, word, spar, now, past, future}]   last_spar(cells) -> index
##   week_lines(phase, focus, film = this week holds the camp's one film night, step, camp) -> 7 strings
##   make(f, opp, bout_day, today, start, focus, film, spar_now, proto = the camp modal's pick, -1 = f's own) -> WeekStrip

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FaceFrame := preload("res://scripts/ui/FaceFrame.gd")
const SparNights := preload("res://scripts/rules/SparNights.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")

const FACES := "res://assets/ui/face/studio"
const INK := Color("#1f2a44")
const PENCIL := Color("#8a929e")
const RED := Color("#c8312a")
const CELL := Vector2(92, 58)
const EVENING := {"pads": "pads", "sparring": "sparring", "rest": "rest", "film": "film"}

var _cells: Array = []
var _focus := ""
var _step := 1
var _camp := true
var _peek: PopupPanel


## The camp's weeks, counted back from fight night (to_go 1 = fight week). The camp runs from `start` (the day it was set,
## today before one is) and never has fewer weeks than are left. spar_now >= 0 is this week's own sparring count.
static func cells(bout_day: int, today: int, start: int, spar_now := -1) -> Array:
	var left := maxi(1, int(ceil((bout_day - today) / 7.0)))
	var total := maxi(left, int(ceil((bout_day - mini(start, today)) / 7.0)))
	var out: Array = []
	for k in total:
		var to_go := total - k
		var p := WeekPhase.phase({"day": bout_day}, bout_day - 7 * to_go)
		var n := WeekPhase.spar(p)
		if to_go == left and spar_now >= 0:
			n = spar_now
		out.append({"to_go": to_go, "phase": p, "word": "%d %s" % [to_go, p.to_upper()], "spar": n,
			"now": to_go == left, "past": to_go > left, "future": to_go < left})
	return out


## The last week with a sparring night (-1 with none): the red tick stands after it.
static func last_spar(cs: Array) -> int:
	var at := -1
	for i in cs.size():
		if int(cs[i]["spar"]) > 0:
			at = i
	return at


## The coach's week for a phase: "Mon  Normal roadwork - pads", one line a day (WeekPhase.week + the camp's nights at
## step 0 Light / 1 Standard / 2 Hard - S382 EVENINGS1: PadWeek.lay, the evenings she runs; the others read rest). camp =
## false: no camp protocol, her between-fights nights at that step (PadWeek.in_camp, as the sim reads it).
static func week_lines(p: String, focus: String, film: bool, step := 1, camp := true) -> Array:
	var days := WeekPhase.week(p, focus)
	var evs := PadWeek.evenings_from(PadWeek.lay(step, camp, p,
		WeekPlan.evenings_for(WeekPhase.spar(p), WeekPhase.pads(p), WeekPhase.film_night(p, {"film": film}))))
	var out: Array = []
	for i in 7:
		out.append("%s  %s - %s" % [Clock.DAYS[i], WeekPhase.card(days[i]), EVENING.get(str(evs[i]), str(evs[i]))])
	return out


static func make(f: Dictionary, opp: Dictionary, bout_day: int, today: int, start: int, focus: String, _film: bool,
		spar_now := -1, proto := -1) -> HBoxContainer:
	var s := new()
	s.name = "WeekStrip"
	s._focus = focus
	# S382 EVENINGS1 review: the nights the sim will run - the camp modal's pick (proto), else the camp's own protocol, else
	# (no camp) her between-fights load setting (PadWeek.step_of / in_camp, as Sim reads them)
	var g := f
	if proto >= 0:
		g = f.duplicate()
		g["camp"] = (f.get("camp", {}) as Dictionary).merged({"protocol": proto}, true)
	s._step = PadWeek.step_of(g)
	s._camp = PadWeek.in_camp(g)
	s._cells = cells(bout_day, today, start, spar_now)
	var used: Array = (f.get("bout", {}) as Dictionary).get("plan_test_nights", [])
	for c in s._cells:   # S382 G3: the spar nights a test took, in the cell they fall in
		c["used"] = mini(int(c["spar"]), SparNights.used_in(bout_day, used, int(c["to_go"])))
	s._build(f, opp, bout_day)
	return s


func _build(f: Dictionary, opp: Dictionary, bout_day: int) -> void:
	add_theme_constant_override("separation", 0)
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var tick := last_spar(_cells)
	for i in _cells.size():
		add_child(_cell(i, _cells[i]))
		add_child(_Gap.new(i == tick))
	add_child(_poster(f, opp, bout_day))
	_peek = PopupPanel.new()
	_peek.name = "WeekPeek"
	_peek.add_theme_stylebox_override("panel", WoodKit.slate(26, 18))
	add_child(_peek)


func _cell(i: int, c: Dictionary) -> Button:
	var b := Button.new()
	b.name = "Week_%d" % int(c["to_go"])
	b.custom_minimum_size = CELL
	b.focus_mode = Control.FOCUS_NONE
	b.disabled = not bool(c["future"])
	var now := bool(c["now"])
	var bg := UI.YELLOW if now else Color(0, 0, 0, 0)
	var edge := UI.YELLOW_EDGE if now else Color(WoodKit.SOFT, 0.55)
	for k in ["normal", "hover", "pressed", "disabled", "focus"]:
		var on_hover: bool = k == "hover" and not b.disabled
		b.add_theme_stylebox_override(k, UI.box(Color(WoodKit.INK, 0.12) if on_hover else bg, edge, 6, 2, 6, 4))
	if bool(c["future"]):
		b.tooltip_text = "Week %d to go: the coach's %s week" % [int(c["to_go"]), str(c["phase"])]
		b.pressed.connect(peek.bind(i))
	else:   # a disabled control always says why (grey_reason_test)
		var n := int(c["spar"])
		b.tooltip_text = ("This week: %d sparring night%s" % [n, "" if n == 1 else "s"]) if now else "Gone: the %s week" % str(c["phase"])
	var v := UI.vbox(2)
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var t := UI.label(str(c["word"]), UI.SMALL - 1, UI.MUTED if bool(c["past"]) else UI.FG, "caps")
	t.name = "Word"
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(t)
	var pips := _Pips.new(int(c["spar"]), bool(c["past"]), int(c.get("used", 0)))
	pips.name = "Pips"
	v.add_child(pips)
	b.add_child(v)
	return b


## The fight poster closing the strip: the opponent's face over the date.
func _poster(f: Dictionary, opp: Dictionary, bout_day: int) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Poster"
	p.add_theme_stylebox_override("panel", UI.box(INK, RED, 6, 2, 6, 4))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var h := UI.hbox(8)
	p.add_child(h)
	var path := FACES.path_join(str(Faces.pair(f, opp)[1]) + ".jpg")
	if not opp.is_empty() and ResourceLoader.exists(path):
		var face := TextureRect.new()
		face.name = "Face"
		face.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var tex: Texture2D = load(path)
		face.texture = tex
		FaceFrame.fit(face, FaceFrame.box_for(tex), Vector2(44, CELL.y - 8))
		h.add_child(face)
	var d := UI.label(Clock.fmt(bout_day).to_upper(), UI.SMALL - 2, UI.FG, "caps")
	d.name = "Date"
	d.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(d)
	return p


## A week still to come: the coach's projected week, read-only, under its cell.
func peek(i: int) -> void:
	var c: Dictionary = _cells[i]
	for k in _peek.get_children():
		_peek.remove_child(k)
		k.queue_free()
	var v := UI.vbox(4)
	v.name = "Lines"
	_peek.add_child(v)
	v.add_child(UI.label("%s - THE COACH'S WEEK" % str(c["word"]), UI.SMALL, WoodKit.INK, "caps"))
	# S382: a week to come never holds the film night - the camp's one film night is in the week it opens (WeekPhase.film_night)
	for line in week_lines(str(c["phase"]), _focus, false, _step, _camp):
		v.add_child(UI.label(line, UI.SMALL, WoodKit.SOFT, "body"))
	var b := get_child(i * 2) as Control
	var at := Vector2i(b.get_screen_position() + Vector2(0, b.size.y + 6)) if b.is_inside_tree() else Vector2i.ZERO
	_peek.popup(Rect2i(at, Vector2i(320, 0)))


## The space between two cells; after the last sparring week it is the red tick.
class _Gap extends Control:
	var red := false

	func _init(r: bool) -> void:
		red = r
		name = "LastSpar" if r else "Gap"
		custom_minimum_size = Vector2(8, 0)
		mouse_filter = Control.MOUSE_FILTER_PASS if r else Control.MOUSE_FILTER_IGNORE
		if r:
			tooltip_text = "Last hard spar: none after this week"

	func _draw() -> void:
		if red:
			draw_line(Vector2(size.x * 0.5, -6), Vector2(size.x * 0.5, size.y + 6), RED, 3.0)


## A row of small gloves, one a sparring night; the first `used` are ink (a Playbook test took that night).
class _Pips extends Control:
	var n := 0
	var faded := false
	var used := 0

	func _init(count: int, past: bool, tested := 0) -> void:
		n = count
		faded = past
		used = tested
		custom_minimum_size = Vector2(0, 14)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var col := Color(RED, 0.45) if faded else RED
		var x0 := size.x * 0.5 - (n * 14 - 4) * 0.5
		for k in n:
			var cx := x0 + k * 14 + 5
			var c := WoodKit.fg(self) if k < used else col
			draw_circle(Vector2(cx, 5), 5.0, c)
			draw_rect(Rect2(cx - 3, 9, 6, 4), c)
