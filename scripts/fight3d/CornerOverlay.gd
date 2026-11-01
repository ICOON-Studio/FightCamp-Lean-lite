extends Control
## S307 the corner minute's screen (docs/FIGHT_NIGHT_SCRIPT.md v2): letterbox bars (2.39:1 on the 16:9 frame), the rest
## clock, the coach's lines as captions in the lower bar, the corner card (what worked, what hurt, the coach's call) with
## the three calls to pick while the minute runs, and SKIP TO THE BELL.
##   build(card, names)  build_intro()  clock(left_s)  say(text)  show_card(on)  picked(call)   signals: chose(call), fixed(habit), skip

const UI := preload("res://scripts/ui/TV.gd")  # S333: fight graphics keep the dark TV look
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CallButtons := preload("res://scripts/ui/CallButtons.gd")

signal chose(call: String)
signal fixed(habit: String)
signal skip

const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")
var jobs := {}               # S310 the corner jobs picked (CornerJobsRow sel)
var _menu := {}
var _jobs_box: VBoxContainer = null
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
var _track := {}             # S323 her body track (BodyBurn.track) - the pit stop shows which part burns
var _map := {}               # S318 the bout's BodyMap (BodyLive.map, shared: the corner's jobs land on it)
var cutman := ""
var _cut_box: VBoxContainer = null
var _body_done := false

## Each bar's share of the frame height: (1 - (16/9) / 2.39) / 2.
const BAR := 0.128
## S350 C197: where the card starts across the frame (with her body column it needs a little more room).
const CARD_LEFT := 0.40
const CARD_LEFT_BODY := 0.33
var _fix_step := 0
const BAR_COLOUR := Color(0, 0, 0, 1)

var _clock: Label
var _caption: Label
var _card: PanelContainer
var _calls: Control
var _said: Label
var _fix_box: VBoxContainer
var _fixes: Array = []
var _names: Array = []
var fix := ""


func build(card: Dictionary, names: Array) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for top in [true, false]:
		var bar := ColorRect.new()
		bar.color = BAR_COLOUR
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bar)
		_pin(bar, Vector4(0, 0 if top else 1.0 - BAR, 1, BAR if top else 1), Vector4.ZERO)
	_clock = UI.mono("", UI.SMALL, UI.MUTED)
	add_child(_clock)
	_pin(_clock, Vector4(0, 0, 0, 0), Vector4(32, 30, 420, 70))
	var sk := UI.button("Skip to the bell", "BtnQuiet", func(): skip.emit())
	sk.name = "SkipCorner"
	add_child(sk)
	_pin(sk, Vector4(1, 0, 1, 0), Vector4(-300, 22, -28, 70))
	_caption = UI.label("", 28, UI.FG, "body", true)
	_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(_caption)
	_pin(_caption, Vector4(0.08, 1.0 - BAR, 0.92, 1), Vector4.ZERO)
	_card = PanelContainer.new()
	_card.add_theme_stylebox_override("panel", UI.box(Color(0.05, 0.04, 0.04, 0.88), UI.LINE, 6, 1, 18, 14))
	add_child(_card)
	# S350 C197 ("doesnt look good, needs a lot of refining"): the card takes the right part of the frame between the bars,
	# full height, so the corner itself (her on the stool, the coach) stays in view on the left; the round first, then the
	# choices as numbered steps, the plan last (picking it sends her out).
	_pin(_card, Vector4(CARD_LEFT, BAR, 1, BAR), Vector4(0, 12, -24, 12))   # as tall as what it holds
	var hb := UI.hbox(18)
	_card.add_child(hb)
	_map = card.get("body_map", {})
	_track = card.get("body_track", {})
	if not _map.is_empty():
		_pin(_card, Vector4(CARD_LEFT_BODY, BAR, 1, BAR), Vector4(0, 12, -24, 12))
		hb.add_child(_body_column(str(names[0]), str(card.get("body_glb", ""))))
	var v := UI.vbox(5)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(v)
	var head := UI.label("IN THE CORNER: WHAT DO YOU TELL %s?" % str(names[0]).to_upper(), UI.BODY + 2, UI.GOLD, "bold")
	v.add_child(head)
	var evidence: Dictionary = card.get("evidence", {})
	var rows := [["WORKED", card["worked"], UI.GREEN], ["HURT", card["hurt"], UI.RED], ["COACH", "%s" % card["why"], UI.AMBER]]
	if str(card.get("fixed", "")) != "":
		rows.insert(1, ["FIXED", card["fixed"], UI.GREEN])   # S320 what last round's habit fix did
	for row in rows:
		var line := UI.hbox(10)
		var tag := UI.caps(str(row[0]))
		tag.custom_minimum_size = Vector2(84, 0)
		tag.add_theme_color_override("font_color", row[2])
		line.add_child(tag)
		var said := UI.label(str(row[1]), 20, UI.FG, "body", true)
		said.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.add_child(said)
		v.add_child(line)
	# S310: recover points, a combination set-up, the talk; S309: one fix for a habit (optional); S308: the call - last.
	_names = names
	_menu = card.get("jobs_menu", {})
	var n := 1
	if not _menu.is_empty():
		jobs = CornerJobsRow.defaults(_menu)
		v.add_child(_step(n, "THE MINUTE"))
		n += 1
		_jobs_box = UI.vbox(0)
		v.add_child(_jobs_box)
		_draw_jobs()
	_fixes = card.get("fixes", [])
	_fix_box = UI.vbox(4)
	v.add_child(_fix_box)
	if not _fixes.is_empty():
		_fix_step = n
		n += 1
	_draw_fixes()
	v.add_child(_step(n, "PICK THE PLAN - IT SENDS HER OUT"))
	# S350 "corner card has too much text": one line a call, four across (when / grade / numbers on the hover).
	_calls = CallButtons.corner_grid(card.get("grades", {}), str(card["call"]), names, func(k: String): chose.emit(k), evidence,
		4, true)
	v.add_child(_calls)
	_said = UI.muted("", UI.SMALL)
	_said.visible = false
	v.add_child(_said)
	_card.visible = false


## The intro's screen: the letterbox, the announcer's captions and SKIP TO THE BELL only.
func build_intro() -> void:
	build({"worked": "", "hurt": "", "why": "", "call": ""}, ["", ""])
	_clock.text = "FIGHT NIGHT"


func clock(left_s: float, round_next: int) -> void:
	_clock.text = "CORNER   0:%02d   ROUND %d NEXT" % [int(ceilf(maxf(0.0, left_s))), round_next]


func say(text: String) -> void:
	_caption.text = text


func show_card(on: bool) -> void:
	_card.visible = on


func card_up() -> bool:
	return _card != null and _card.visible


## Where across the frame the shot puts her face while the card is up (the middle of the open part on the left).
func subject_x() -> float:
	return (CARD_LEFT_BODY if not _map.is_empty() else CARD_LEFT) * 0.5


## The call is made: the buttons go, the call (and the fix) stay on the card.
func picked(call: String) -> void:
	_calls.visible = false
	_fix_box.visible = false
	if _jobs_box != null:
		_jobs_box.visible = false
	apply_body()
	_said.text = "Your call: \"%s\"" % BoutRules.CORNER[call]
	for h in _fixes:
		if str(h["id"]) == fix:
			_said.text += "   Fix: %s" % str(h["name"]).to_lower()
	_said.visible = true


func _draw_jobs() -> void:
	for ch in _jobs_box.get_children():
		ch.queue_free()
	_jobs_box.add_child(CornerJobsRow.build(_menu, jobs, _names, _draw_jobs, true))


## The corner action's job parts for the pick (Bouts.corner_jobs).
func jobs_suffix() -> String:
	return "" if _menu.is_empty() else CornerJobsRow.suffix(jobs)


func _draw_fixes() -> void:
	for ch in _fix_box.get_children():
		ch.queue_free()
	if _fixes.is_empty():
		return
	_fix_box.add_child(_step(_fix_step, "FIX ONE HABIT (OPTIONAL)"))
	_fix_box.add_child(CallButtons.fix_row(_fixes, _names, fix, _fix))


func _fix(id: String) -> void:
	fix = id
	fixed.emit(id)
	_draw_fixes()


## S318 her figure on the card and the cutman's one job (S316 plan: "one pair of hands per job"): enswell an eye that is
## hurt or worse, close a cut that is open, or nothing. The cutman's own pick (the worst place) is lit to start.
func _body_column(her: String, glb: String = "") -> VBoxContainer:
	var col := UI.vbox(4)
	col.custom_minimum_size = Vector2(200, 0)
	var fig: Control = BodyFigure.new()
	fig.custom_minimum_size = Vector2(190, 268)   # S324 C149 bigger (was 160 x 226)
	fig.set_portrait(BodyFigure.portrait_for(glb, "red"))   # S320 C146: her own body, not a drawn figure
	fig.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(fig)
	var vals := {}
	for p in BodyMap.PLACES:
		vals[p] = BodyMap.value(_map, "a", p)
	fig.set_values(vals)
	if not _track.is_empty():
		fig.set_track(_track)
	var opts := _cutman_jobs(vals)
	if opts.size() > 1:
		cutman = str(opts[0][0])
		col.add_child(UI.caps("CUTMAN"))
		_cut_box = UI.vbox(4)
		col.add_child(_cut_box)
		_draw_cutman(opts)
	else:
		col.add_child(UI.muted("%s is clean: the cutman waits." % her, UI.TINY))
	return col


## [[job, label], ...] worst first, "Nothing" last.
func _cutman_jobs(vals: Dictionary) -> Array:
	var out: Array = []
	var cuts: Dictionary = (_map.get("a", {}) as Dictionary).get("cuts", {})
	if not cuts.is_empty():
		out.append(["cut", "Close the cut"])
	var eyes := [["enswell_left", "left_eye", "Enswell the left eye"], ["enswell_right", "right_eye", "Enswell the right eye"]]
	eyes.sort_custom(func(x, y): return float(vals[x[1]]) < float(vals[y[1]]))
	for e in eyes:
		if float(vals[e[1]]) <= BodyMap.HURT:
			out.append([e[0], e[2]])
	out.append(["", "Nothing"])
	return out


func _draw_cutman(opts: Array) -> void:
	for ch in _cut_box.get_children():
		ch.queue_free()
	for o in opts:
		var b := UI.button(str(o[1]), "Choice" if str(o[0]) == cutman else "BtnQuiet", func():
			cutman = str(o[0])
			_draw_cutman(opts))
		_cut_box.add_child(b)


## The cutman's job and the second's ice go on her map for the next round (BodyMap.corner; end_round lifts them).
func apply_body() -> void:
	if _map.is_empty() or _body_done:
		return
	_body_done = true
	var second := ""
	if int(((jobs.get("rec", {}) as Dictionary).get("ice", 0))) > 0:
		second = "ice_left" if BodyMap.value(_map, "a", "left_ribs") <= BodyMap.value(_map, "a", "right_ribs") else "ice_right"
	BodyMap.corner(_map, "a", cutman, second)


## A numbered step's heading: the order the minute is decided in.
func _step(n: int, text: String) -> Label:
	var l := UI.caps("%d   %s" % [n, text])
	l.add_theme_color_override("font_color", UI.GOLD)
	return l


func _pin(c: Control, anchors: Vector4, offsets: Vector4) -> void:
	c.anchor_left = anchors.x
	c.anchor_top = anchors.y
	c.anchor_right = anchors.z
	c.anchor_bottom = anchors.w
	c.offset_left = offsets.x
	c.offset_top = offsets.y
	c.offset_right = offsets.z
	c.offset_bottom = offsets.w
