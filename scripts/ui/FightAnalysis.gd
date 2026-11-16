extends Control
## FIGHTPAGE1 the FIGHT ANALYSIS page, film-night mode (their tape). The approved look: docs/mockups/s495/fight_analysis/
## fight_analysis_v3.png + .html (owner Q-S294-256 "Yes, build it"); map ops/research/FIGHTFILM1_MAP_V3_S495.md 2.1-2.2.
## Wood frame and slate cards: the header (names only here, owner S448), THE FILM (an empty FilmSlot the 3D film goes
## into, moments, speed, timeline, the rounds strip), MARK A PATTERN, THE PUNCHES (FightAnalysisList), THE REPORT
## (FightAnalysisReport). What a check costs and what filing does stay behind the callables the fight week wires.
##   var p = FightAnalysis.new(); p.for_tape(opp, films, night, on_check, on_file, on_done); parent.add_child(p)
## night = {checks_left, opp_checks_left, cost_words, marked}; on_check(claim, films_seen) -> {word, k, n, e, z};
## on_file(claim, word, films_seen_count); on_done(). No he/she anywhere but the coach's word (owner S412).

signal moment(line: Dictionary)

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const FilmPattern := preload("res://scripts/rules/FilmPattern.gd")
const PriorBouts := preload("res://scripts/rules/PriorBouts.gd")
const ListPanel := preload("res://scripts/ui/FightAnalysisList.gd")
const ReportPanel := preload("res://scripts/ui/FightAnalysisReport.gd")

const TXT := 16

var opp: Dictionary = {}
var films: Array = []
var night: Dictionary = {}
var marked: Array = []
var cur := 0
var speed := 1.0
var lines: Array = []
var last: Dictionary = {}     # the last check: {claim, words, res, filed}
var start_checks := 0
var list: VBoxContainer
var report: VBoxContainer
var film_slot: Panel
var header: Control
var coach_big: Label
var coach_sub: Label
var check_btn: Button
var file_btn: Button
var next_film_btn: Button
var _on_check: Callable
var _on_file: Callable
var _on_done: Callable
var _film_n: Label
var _checks_words: Label
var _pips: HBoxContainer
var _film_sub: Label
var _clock: Label
var _moment_n: Label
var _timeline: Control
var _strip: HBoxContainer
var _speeds: Dictionary = {}
var _when: OptionButton
var _then: OptionButton
var _coach_box: PanelContainer
var _marked_box: VBoxContainer
var _marked_head: Label

func for_tape(o: Dictionary, f: Array, n: Dictionary, on_check: Callable, on_file: Callable, on_done: Callable) -> void:
	opp = o
	films = f
	night = n
	marked = night.get("marked", [])
	night["marked"] = marked
	_on_check = on_check
	_on_file = on_file
	_on_done = on_done
	start_checks = int(night.get("checks_left", 0))

func checks_left() -> int:
	return int(night.get("checks_left", 0))

func _ready() -> void:
	name = "FightAnalysis"
	theme = UI.theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := ColorRect.new()
	bg.color = Palette.PAGE
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var pad := MarginContainer.new()
	pad.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in [["left", 24], ["right", 24], ["top", 14], ["bottom", 14]]:
		pad.add_theme_constant_override("margin_" + str(side[0]), int(side[1]))
	add_child(pad)
	var page := UI.vbox(14)
	pad.add_child(page)
	page.add_child(_header())
	var body := UI.hbox(14)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_child(body)
	var left := UI.vbox(14)
	left.custom_minimum_size.x = 760
	body.add_child(left)
	left.add_child(_film_panel())
	left.add_child(_pattern_panel())
	var mid: Array = _card("THE PUNCHES", "both corners, every punch, in order", 574)
	list = ListPanel.new()
	list.build()
	list.picked.connect(_on_picked)
	(mid[1] as VBoxContainer).add_child(list)
	body.add_child(mid[0])
	var right: Array = _card("THE REPORT", "", 510)
	(right[0] as Control).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	report = ReportPanel.new()
	report.build(check_claim, func(l: Dictionary): list.select_line(l))
	(right[1] as VBoxContainer).add_child(report)
	body.add_child(right[0])
	_load_film()

func _card(title: String, small: String, w: float) -> Array:
	var c: Array = UI.card()
	var p: PanelContainer = c[0]
	p.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	p.custom_minimum_size.x = w
	var v: VBoxContainer = c[1]
	var h := UI.hbox(10)
	var t := UI.label(title, 21, Palette.HEADER, "bold")
	t.name = "Title"
	h.add_child(t)
	if small != "":
		var s := UI.label(small, TXT, Palette.MUTED, "semi")
		s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		s.clip_text = true
		s.name = "Small"
		h.add_child(s)
	v.add_child(h)
	return c

# --- header ------------------------------------------------------------------------------------------------------------

func _row() -> Dictionary:
	if cur < films.size():
		return (films[cur] as Dictionary).get("row", {})
	return {}

func _surname(full: String) -> String:
	var parts: PackedStringArray = full.strip_edges().split(" ")
	return parts[parts.size() - 1] if parts.size() > 0 else full

## "club show, Feb 2026 - Holt won on points" from the RivalPast row (win = the boxer on film won).
func bout_words() -> String:
	var r: Dictionary = _row()
	var winner: String = _surname(str(opp.get("name", ""))) if bool(r.get("win", false)) else _surname(str(r.get("vs", "")))
	var how: String = str(str(r.get("how", "")).split(", ")[0])
	var won: String = ("%s won, %s" if how.begins_with("stopped") else "%s won %s") % [winner, how]
	return "club show, %s - %s" % [PriorBouts.month(int(r.get("d", 0))), won]

func _lab(text: String, px: int, ink: Color, kind: String) -> Label:
	var l := UI.label(text, px, ink, kind)
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return l

func _dot(ink: Color) -> Control:
	var d := UI.dot(ink)
	d.custom_minimum_size = Vector2(16, 16)
	return d

func _header() -> Control:
	var c: Array = UI.card()
	header = c[0]
	header.name = "Header"
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 16)
	flow.add_theme_constant_override("v_separation", 6)
	(c[1] as VBoxContainer).add_child(flow)
	var names := UI.hbox(10)
	names.name = "Names"
	flow.add_child(names)
	var chip := PanelContainer.new()
	chip.add_theme_stylebox_override("panel", UI.box(Palette.HOVER, Palette.WARN, 13, 1, 10, 2))
	chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	chip.add_child(UI.label(str(night.get("cost_words", "")), TXT, Palette.WARN, "bold"))
	chip.visible = str(night.get("cost_words", "")) != ""
	flow.add_child(chip)
	var g_film := UI.hbox(10)
	_film_n = _lab("", TXT, Palette.MUTED, "caps")
	g_film.add_child(_film_n)
	next_film_btn = UI.button("Next film", "Btn", next_film)
	next_film_btn.name = "NextFilm"
	g_film.add_child(next_film_btn)
	flow.add_child(g_film)
	var g_checks := UI.hbox(8)
	g_checks.add_child(_lab("CHECKS", TXT, Palette.TEXT, "caps"))
	_pips = UI.hbox(6)
	_pips.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	g_checks.add_child(_pips)
	_checks_words = _lab("", TXT, Palette.MUTED, "bold")
	_checks_words.name = "ChecksWords"
	g_checks.add_child(_checks_words)
	flow.add_child(g_checks)
	var done := UI.button("Done for tonight", "Btn", done_for_tonight)
	done.name = "Done"
	flow.add_child(done)
	return header

func _fill_header() -> void:
	var names: HBoxContainer = header.find_child("Names", true, false)
	UI.clear(names)
	names.add_child(_dot(Palette.BLUE_CORNER))
	names.add_child(_lab(str(opp.get("name", "")), 28, Palette.TEXT, "bold"))
	names.add_child(_lab("vs", 22, Palette.MUTED, "bold"))
	names.add_child(_dot(Palette.RED_CORNER))
	names.add_child(_lab(str(_row().get("vs", "")), 28, Palette.TEXT, "bold"))
	names.add_child(_lab("  " + bout_words(), 18, Palette.MUTED, "semi"))
	_film_n.text = "FILM %d OF %d" % [cur + 1, films.size()]
	next_film_btn.disabled = cur + 1 >= films.size()
	_fill_checks()

func _fill_checks() -> void:
	UI.clear(_pips)
	var left: int = checks_left()
	for i in maxi(start_checks, left):
		var pip := Panel.new()
		pip.custom_minimum_size = Vector2(16, 16)
		pip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pip.add_theme_stylebox_override("panel", UI.box(Palette.HEADER if i < left else Palette.CLEAR, Palette.HEADER, 8, 2, 0, 0))
		_pips.add_child(pip)
	_checks_words.text = "%d left - %d for this opponent" % [left, int(night.get("opp_checks_left", 0))]
	var can: bool = _can_check()
	if check_btn != null:
		check_btn.text = "Check it with the coach (%d left)" % left
		check_btn.disabled = not can
	if report != null:
		report.set_checks(left if can else 0)

func _can_check() -> bool:
	return checks_left() > 0 and int(night.get("opp_checks_left", 0)) > 0

# --- the film -----------------------------------------------------------------------------------------------------------

func _film_panel() -> Control:
	var c: Array = _card("THE FILM", "ringside camera", 760)
	var p: PanelContainer = c[0]
	p.name = "Film"
	var v: VBoxContainer = c[1]
	_film_sub = p.find_child("Small", true, false)
	film_slot = Panel.new()
	film_slot.name = "FilmSlot"
	film_slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
	film_slot.custom_minimum_size = Vector2(0, 120)
	film_slot.add_theme_stylebox_override("panel", UI.box(Palette.PAGE, Palette.LINE, 4, 1, 0, 0))
	v.add_child(film_slot)
	var ctl := HFlowContainer.new()
	ctl.add_theme_constant_override("h_separation", 10)
	ctl.add_theme_constant_override("v_separation", 6)
	for m in [["Previous moment", -1, "PrevMoment"], ["Next moment", 1, "NextMoment"]]:
		var mb := UI.button(str(m[0]), "Btn", step.bind(int(m[1])))
		mb.name = str(m[2])
		ctl.add_child(mb)
	for s in [0.5, 1.0, 2.0]:
		var sp: float = s
		var b := UI.button(("%.1fx" % sp) if sp < 1.0 else ("%dx" % int(sp)), "Pill", set_speed.bind(sp))
		b.name = "Speed"
		_speeds[sp] = b
		ctl.add_child(b)
	_clock = UI.label("", 22, Palette.TEXT, "bold")
	_clock.name = "Clock"
	ctl.add_child(_clock)
	_moment_n = _lab("", TXT, Palette.MUTED, "semi")
	ctl.add_child(_moment_n)
	v.add_child(ctl)
	_timeline = Control.new()
	_timeline.name = "Timeline"
	_timeline.custom_minimum_size = Vector2(0, 34)
	_timeline.draw.connect(func(): list.draw_timeline(_timeline, _rounds()))
	_timeline.gui_input.connect(func(ev: InputEvent): list.timeline_click(ev, _timeline, _rounds()))
	v.add_child(_timeline)
	_strip = UI.hbox(6)
	_strip.name = "RoundsStrip"
	v.add_child(_strip)
	set_speed(1.0)
	return p

func set_speed(s: float) -> void:
	speed = s
	for k in _speeds:
		(_speeds[k] as Button).theme_type_variation = "PillOn" if is_equal_approx(float(k), s) else "Pill"

## Previous / Next moment: the line before or after the selected one among the lines the filter shows.
func step(d: int) -> void:
	list.select(clampi(int(list.sel) + d, 0, (list.shown as Array).size() - 1))

func selected_line() -> Dictionary:
	var sh: Array = list.shown
	var i: int = list.sel
	return sh[i] if i >= 0 and i < sh.size() else {}

func _on_picked(i: int) -> void:
	var l: Dictionary = selected_line()
	var n: int = (list.shown as Array).size()
	_clock.text = ListPanel.clock_words(l) if not l.is_empty() else "-"
	_moment_n.text = "moment %d of %d" % [i + 1 if i >= 0 else 0, n]
	_film_sub.text = "ringside camera - Round %d" % int(l.get("round", 1)) if not l.is_empty() else "ringside camera"
	_timeline.queue_redraw()
	if not l.is_empty():
		moment.emit(l)

func _rounds() -> int:
	return maxi(1, int((films[cur] as Dictionary).get("rounds", 3))) if cur < films.size() else 3


# --- mark a pattern -------------------------------------------------------------------------------------------------------

func _pattern_panel() -> Control:
	var c: Array = _card("MARK A PATTERN", "finding is free, filing costs a check", 760)
	var p: PanelContainer = c[0]
	p.name = "Pattern"
	p.size_flags_vertical = Control.SIZE_SHRINK_END
	var v: VBoxContainer = c[1]
	_when = _pick_row(v, "WHEN", FilmPattern.WHEN_WORDS, "%d choices" % FilmPattern.WHEN_WORDS.size())
	_then = _pick_row(v, "THEN", FilmPattern.THEN_WORDS, "%d choices - within 2 s" % FilmPattern.THEN_WORDS.size())
	_coach_box = PanelContainer.new()
	var cv := UI.vbox(3)
	_coach_box.add_child(cv)
	coach_big = UI.label("", 22, Palette.TEXT, "bold", true)
	coach_big.name = "CoachLine"
	coach_big.custom_minimum_size.x = 300
	cv.add_child(coach_big)
	coach_sub = UI.label("", TXT, Palette.MUTED, "semi", true)
	coach_sub.custom_minimum_size.x = 300
	cv.add_child(coach_sub)
	v.add_child(_coach_box)
	var btns := HFlowContainer.new()
	btns.add_theme_constant_override("h_separation", 10)
	btns.add_theme_constant_override("v_separation", 6)
	check_btn = UI.button("", "Btn", func(): check_claim(pattern_claim(), ""))
	check_btn.name = "CheckIt"
	btns.add_child(check_btn)
	file_btn = UI.button("File it", "BtnSolid", file_it)
	file_btn.name = "FileIt"
	btns.add_child(file_btn)
	var watch := UI.button("Watch list", "Btn", watch_list)
	watch.name = "WatchList"
	btns.add_child(watch)
	v.add_child(btns)
	_marked_head = UI.label("", TXT, Palette.MUTED, "caps")
	v.add_child(_marked_head)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.custom_minimum_size.y = 48
	_marked_box = UI.vbox(2)
	_marked_box.name = "Marked"
	_marked_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_marked_box)
	v.add_child(scroll)
	_coach_idle()
	return p

func _pick_row(v: VBoxContainer, word: String, items: Array, hint: String) -> OptionButton:
	var h := UI.hbox(10)
	var lab := UI.label(word, TXT, Palette.MUTED, "caps")
	lab.custom_minimum_size.x = 62
	h.add_child(lab)
	var o := OptionButton.new()
	o.name = "Pick" + word
	o.fit_to_longest_item = false
	o.clip_text = true
	o.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	o.focus_mode = Control.FOCUS_NONE
	o.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	o.custom_minimum_size.x = 160
	o.add_theme_font_override("font", UI.font("bold"))
	o.add_theme_font_size_override("font_size", 18)
	for st in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		o.add_theme_color_override(st, Palette.TEXT)
	for st in ["normal", "hover", "pressed", "focus"]:
		o.add_theme_stylebox_override(st, UI.box(Palette.TILE, Palette.CHOSEN, 4, 2, 14, 4))
	for w in items:
		var s: String = str(w)
		o.add_item(s.substr(0, 1).to_upper() + s.substr(1))
	o.item_selected.connect(func(i: int): o.tooltip_text = o.get_item_text(i))
	o.tooltip_text = o.get_item_text(0)
	h.add_child(o)
	h.add_child(UI.label(hint, TXT, Palette.MUTED, "semi"))
	v.add_child(h)
	return o

## The WHEN x THEN claim the pickers show, as FilmPattern.claims() builds it.
func pattern_claim() -> Dictionary:
	var w: int = maxi(0, _when.selected)
	var t: int = maxi(0, _then.selected)
	return {"when": FilmPattern.WHEN_IDS[w], "then": FilmPattern.THEN_IDS[t],
		"words": "%s -> %s" % [FilmPattern.WHEN_WORDS[w], FilmPattern.THEN_WORDS[t]]}

func set_claim(when_i: int, then_i: int) -> void:
	_when.select(when_i)
	_then.select(then_i)

func _pronoun() -> String:
	return "her" if str(opp.get("sex", "f")) == "f" else "him"

func _pct(word: String, n_films: int) -> String:
	return str(int(round(FilmPattern.figure(word, n_films, false) * 100.0))) + "%"

func _coach_idle() -> void:
	last = {}
	coach_big.text = "Pick a moment and what follows it; the coach counts every punch."
	coach_sub.text = ""
	_coach_box.add_theme_stylebox_override("panel", UI.box(Palette.dim(), Palette.LINE, 4, 0, 14, 8))
	file_btn.text = "File it"
	file_btn.disabled = true

## Spends one check through on_check (a WHEN x THEN claim or a report claim), shows the coach's word, marks the claim.
func check_claim(claim: Dictionary, words: String) -> void:
	if not _can_check():
		return
	var c: Dictionary = claim.duplicate()
	if words != "":
		c["words"] = words
	var res: Dictionary = _on_check.call(c, films.slice(0, cur + 1))
	night["checks_left"] = checks_left() - 1
	night["opp_checks_left"] = int(night.get("opp_checks_left", 0)) - 1
	last = {"claim": c, "res": res, "filed": false}
	_mark(c, str(res.get("word", "nothing")), "%d of %d" % [int(res.get("k", 0)), int(res.get("n", 0))])
	_show_coach()
	_fill_checks()

func _show_coach() -> void:
	var res: Dictionary = last["res"]
	var word: String = str(res.get("word", "nothing"))
	var claim: Dictionary = last["claim"]
	var noun: String = str({"jab": " jabs", "cross": " crosses", "hook": " hooks"}.get(str(claim.get("when", "")), ""))
	coach_big.text = "Coach: \"%s.\"  All of them: %d of %d%s" % [FilmPattern.word_text(word, _pronoun()),
		int(res.get("k", 0)), int(res.get("n", 0)), noun]
	var sub: String = "" if str(claim.get("when", "")) == "report" else "Expected by chance: %.1f. " % float(res.get("e", 0.0))
	if word != "pass" and word != "maybe":
		sub += "Nothing to file."
	elif cur == 0:
		sub += "One film: " + _pct(word, 1) + "; pooled with a second: " + _pct(word, 2) + "."
	else:
		sub += "Pooled over %d films: " % (cur + 1) + _pct(word, cur + 1) + "."
	coach_sub.text = sub
	var edge: Color = ReportPanel.WORD_INK.get(word, Palette.MUTED)
	var sb := UI.box(Palette.dim(), edge, 4, 0, 14, 8)
	sb.border_width_left = 4
	_coach_box.add_theme_stylebox_override("panel", sb)
	var can_file: bool = (word == "pass" or word == "maybe") and not bool(last.get("filed", false))
	file_btn.disabled = not can_file
	file_btn.text = ("File it at " if not bool(last.get("filed", false)) else "Filed at ") + _pct(word, cur + 1) if word == "pass" or word == "maybe" else "File it"

func file_it() -> void:
	var word: String = str((last.get("res", {}) as Dictionary).get("word", "nothing"))
	if last.is_empty() or bool(last.get("filed", false)) or (word != "pass" and word != "maybe"):
		return
	_on_file.call(last["claim"], word, cur + 1)
	last["filed"] = true
	_show_coach()

## Keeps the picked claim for the next film (no check spent).
func watch_list() -> void:
	var c: Dictionary = pattern_claim()
	for m in marked:
		var md: Dictionary = m
		if str(md.get("when", "")) == str(c["when"]) and str(md.get("then", "")) == str(c["then"]):
			return
	_mark(c, "watch", "watch list")

func _mark(claim: Dictionary, word: String, counts: String) -> void:
	ReportPanel.mark(marked, claim, word, counts, cur)
	_fill_marked()

func _fill_marked() -> void:
	var heads := PackedStringArray()
	for i in films.size():
		heads.append("film %d" % (i + 1))
	_marked_head.text = ("Marked tonight  -  " + " | ".join(heads)).to_upper()
	ReportPanel.marked_rows(_marked_box, marked, films.size(), _pronoun())

# --- films ----------------------------------------------------------------------------------------------------------------

func _load_film() -> void:
	if films.is_empty():
		return
	lines = ListPanel.film_lines(films[cur])
	_fill_header()
	UI.clear(_strip)
	_strip.add_child(ReportPanel.rounds_strip(films[cur], _rounds()))
	_coach_idle()
	_fill_marked()
	report.load_film(lines, films[cur])
	_fill_checks()
	list.load_lines(lines)

## Loads the next past bout; checks and MARKED TONIGHT carry over.
func next_film() -> void:
	if cur + 1 >= films.size():
		return
	cur += 1
	_load_film()

func done_for_tonight() -> void:
	if _on_done.is_valid():
		_on_done.call()
	queue_free()
