extends VBoxContainer
## FIGHTPAGE1 THE REPORT (mockup fight_analysis_v3.html, map FIGHTFILM1 v3 2.1): tabs Them / The other; thrown, landed and
## clean bars per punch (sort: count | clean rate) with head and body; landed by round; landed by range; their game as
## shares of exchanges (FilmBout.mode_counts); their combinations (two or more of their punches, each within 1.5 s of the
## last) with times that select the line; three sentences that state numbers only. Two "Check it (1)" buttons hand a
## report claim to the page (on_claim), which spends the check through its on_check like any claim.
##   var r = FightAnalysisReport.new(); r.build(on_claim, on_select); r.load_film(lines, film); r.set_checks(n)

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const FilmBout := preload("res://scripts/rules/FilmBout.gd")
const FilmPattern := preload("res://scripts/rules/FilmPattern.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const PunchList := preload("res://scripts/ui/FightAnalysisList.gd")

const TXT := 16
const COMBO_GAP := 1.5
const WORD_INK := {"pass": Palette.GOOD, "maybe": Palette.WARN, "not_enough": Palette.WARN, "nothing": Palette.MUTED,
	"watch": Palette.MUTED}
const RANGE_SAY := {"long": "at long range", "mid": "at mid range", "inside": "inside", "ropes": "on the ropes"}

var tab := "b"
var sort_by := "count"
var lines: Array = []
var film: Dictionary = {}
var checks_left := 0
var check_buttons: Array = []
var sentences: Array = []
var combos: Array = []
var _on_claim: Callable
var _on_select: Callable
var _tabs: Dictionary = {}
var _body: VBoxContainer
var _f := 1.0

func build(on_claim: Callable, on_select: Callable) -> void:
	name = "Report"
	_on_claim = on_claim
	_on_select = on_select
	_f = TextScale.factor()
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 8)
	var tabs := UI.hbox(6)
	for t in [["b", "Them", Palette.BLUE_CORNER], ["a", "The other", Palette.RED_CORNER]]:
		var key: String = str(t[0])
		var b := UI.button(str(t[1]), "Tab", set_tab.bind(key))
		b.name = "Tab_" + key
		b.icon = PunchList.dot_icon(t[2], 12)
		_tabs[key] = b
		tabs.add_child(b)
	add_child(tabs)
	var scroll := ScrollContainer.new()
	scroll.name = "ReportScroll"
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_body = UI.vbox(6)
	_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_body)
	add_child(scroll)

func load_film(film_lines: Array, bout: Dictionary) -> void:
	lines = film_lines
	film = bout
	_rebuild()

func set_tab(key: String) -> void:
	tab = key
	_rebuild()

func set_sort(key: String) -> void:
	sort_by = key
	_rebuild()

func set_checks(n: int) -> void:
	checks_left = n
	for b in check_buttons:
		if is_instance_valid(b):
			(b as Button).disabled = n <= 0

func _rebuild() -> void:
	for k in _tabs:
		(_tabs[k] as Button).theme_type_variation = "TabOn" if str(k) == tab else "Tab"
	UI.clear(_body)
	check_buttons = []
	var mine: Array = lines.filter(func(l): return str((l as Dictionary)["who"]) == tab)
	var fill: Color = Palette.BLUE_CORNER if tab == "b" else Palette.RED_CORNER
	_punch_section(mine, fill)
	_round_section(mine, fill)
	_range_section(mine, fill)
	if tab == "b":
		_game_section()
		_combo_section(mine)
	_say_section(mine)

# --- sections ----------------------------------------------------------------------------------------------------------

func _sec(title: String, right: Control = null) -> VBoxContainer:
	var v := UI.vbox(3)
	v.add_theme_constant_override("separation", 3)
	var h := HFlowContainer.new()
	h.add_theme_constant_override("h_separation", 8)
	var cap := UI.label(title.to_upper(), TXT, Palette.MUTED, "caps")
	cap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(cap)
	if right != null:
		h.add_child(right)
	v.add_child(h)
	_body.add_child(v)
	return v

static func _landed(r: String) -> bool:
	return r == "Landed" or r == "Clean"

## [[name, thrown, landed, clean, head, body] ...] grouped by `key_of`, in first-seen order.
func _tally(mine: Array, key_of: Callable) -> Array:
	var rows: Dictionary = {}
	var order: Array = []
	for l in mine:
		var ld: Dictionary = l
		var k: String = str(key_of.call(ld))
		if not rows.has(k):
			rows[k] = [k, 0, 0, 0, 0, 0]
			order.append(k)
		var row: Array = rows[k]
		row[1] = int(row[1]) + 1
		var res: String = str(ld["result"])
		if _landed(res):
			row[2] = int(row[2]) + 1
			if str(ld["target"]) == "body":
				row[5] = int(row[5]) + 1
			else:
				row[4] = int(row[4]) + 1
		if res == "Clean":
			row[3] = int(row[3]) + 1
	var out: Array = []
	for k in order:
		out.append(rows[k])
	return out

func _punch_section(mine: Array, fill: Color) -> void:
	var sorts := UI.hbox(4)
	sorts.add_child(UI.label("sort:", TXT, Palette.MUTED, "semi"))
	for s in [["count", "count"], ["clean", "clean rate"]]:
		var b := UI.button(str(s[1]), "PillOn" if sort_by == str(s[0]) else "Pill", set_sort.bind(str(s[0])))
		b.name = "Sort_" + str(s[0])
		sorts.add_child(b)
	var v := _sec("Thrown, landed, clean", sorts)
	var rows: Array = _tally(mine, func(l: Dictionary): return PunchList.report_name(l))
	if sort_by == "clean":
		rows.sort_custom(func(a, b): return _rate(a) > _rate(b))
	else:
		rows.sort_custom(func(a, b): return int(a[1]) > int(b[1]))
	var top := 1
	var head := 0
	var body := 0
	for r in rows:
		top = maxi(top, int(r[1]))
		head += int(r[4])
		body += int(r[5])
	for r in rows:
		var t: float = float(r[1]) / float(top)
		var la: float = float(r[2]) / float(top)
		var cl: float = float(r[3]) / float(top)
		v.add_child(_bar_row(str(r[0]), [[t, Color(fill, 0.35)], [la, fill], [cl, Palette.TEXT]],
			"%d/%d/%d" % [int(r[3]), int(r[2]), int(r[1])]))
	var legend := HFlowContainer.new()
	legend.add_theme_constant_override("h_separation", 14)
	for k in [["thrown", Color(fill, 0.35)], ["landed", fill], ["clean", Palette.TEXT]]:
		var h := UI.hbox(5)
		var sw := UI.dot(k[1])
		sw.custom_minimum_size = Vector2(12, 10)
		h.add_child(sw)
		h.add_child(UI.label(str(k[0]), TXT, Palette.MUTED, "semi"))
		legend.add_child(h)
	legend.add_child(UI.label("head %d - body %d" % [head, body], TXT, Palette.MUTED, "semi"))
	v.add_child(legend)
	if tab == "b":
		v.add_child(_check_row("Check it (1): best weapon", {"when": "report", "then": "weapon"}, "Their best weapon",
			"the punch that lands clean most"))

static func _rate(r: Array) -> float:
	return float(r[3]) / float(maxi(1, int(r[1])))

func _check_row(text: String, claim: Dictionary, words: String, note: String) -> Control:
	var h := HFlowContainer.new()
	h.add_theme_constant_override("h_separation", 10)
	var b := UI.button(text, "Btn", func(): _on_claim.call(claim, words))
	b.name = "Check_" + str(claim["then"])
	b.disabled = checks_left <= 0
	check_buttons.append(b)
	h.add_child(b)
	if note != "":
		var n := UI.label(note, TXT, Palette.MUTED, "semi")
		n.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(n)
	return h

func _round_section(mine: Array, fill: Color) -> void:
	var v := _sec("Landed by round")
	var rows: Array = _tally(mine, func(l: Dictionary): return "Round %d" % int(l["round"]))
	rows.sort_custom(func(a, b): return str(a[0]) < str(b[0]))
	_count_bars(v, rows, fill)

func _range_section(mine: Array, fill: Color) -> void:
	var v := _sec("Landed by range")
	var rows: Array = _tally(mine, func(l: Dictionary): return str(l["range"]))
	rows.sort_custom(func(a, b): return PunchList.RANGE_ORDER.find(a[0]) < PunchList.RANGE_ORDER.find(b[0]))
	for r in rows:
		r[0] = str(r[0]).capitalize()
	_count_bars(v, rows, fill)

func _count_bars(v: VBoxContainer, rows: Array, fill: Color) -> void:
	var top := 1
	for r in rows:
		top = maxi(top, int(r[1]))
	for r in rows:
		v.add_child(_bar_row(str(r[0]), [[float(r[1]) / float(top), Color(fill, 0.35)], [float(r[2]) / float(top), fill]],
			"%d/%d" % [int(r[2]), int(r[1])]))

func _bar_row(words: String, fills: Array, value: String) -> Control:
	var h := UI.hbox(8)
	var px: int = TextScale.scaled(TXT, _f)
	var n := UI.label(words, TXT, Palette.TEXT, "semi")
	n.custom_minimum_size.x = PunchList.text_w("Body cross", "semi", px) + 6.0
	n.clip_text = true
	h.add_child(n)
	var bar := Control.new()
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.custom_minimum_size = Vector2(60, 14)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.draw.connect(func():
		var w: float = bar.size.x
		bar.draw_rect(Rect2(Vector2.ZERO, bar.size), Palette.PAGE)
		for fr in fills:
			bar.draw_rect(Rect2(0, 0, w * clampf(float(fr[0]), 0.0, 1.0), bar.size.y), fr[1])
		bar.draw_rect(Rect2(Vector2.ZERO, bar.size), Palette.LINE, false, 1.0))
	h.add_child(bar)
	var val := UI.label(value, TXT, Palette.TEXT, "bold")
	val.custom_minimum_size.x = PunchList.text_w("88/88/88", "bold", px) + 4.0
	val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(val)
	return h

func _game_section() -> void:
	var v := _sec("Their game, share of exchanges")
	var counts: Dictionary = FilmBout.mode_counts(film)
	var games: Array = counts.keys()
	games.sort_custom(func(a, b): return int(counts[a]) > int(counts[b]))
	var total := 0
	for g in games:
		total += int(counts[g])
	var shades: Array = [1.0, 0.65, 0.42, 0.25, 0.15, 0.1]
	var split := Control.new()
	split.custom_minimum_size = Vector2(60, 18)
	split.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	split.mouse_filter = Control.MOUSE_FILTER_IGNORE
	split.draw.connect(func():
		var x := 0.0
		for i in games.size():
			var w: float = split.size.x * float(counts[games[i]]) / float(maxi(1, total))
			split.draw_rect(Rect2(x, 0, maxf(w - 3.0, 1.0), split.size.y), Color(Palette.BLUE_CORNER, float(shades[mini(i, 5)])))
			x += w)
	v.add_child(split)
	var legend := HFlowContainer.new()
	legend.add_theme_constant_override("h_separation", 14)
	for g in games:
		legend.add_child(UI.label("%s %d" % [PunchList.game_word(str(g)).capitalize(), int(counts[g])], TXT, Palette.TEXT, "semi"))
	v.add_child(legend)
	v.add_child(_check_row("Check it (1): their game", {"when": "report", "then": "game"}, "Their game", ""))

## Their combinations: runs of two or more of their punches in one round, each within COMBO_GAP s of the one before.
static func combinations(mine: Array) -> Array:
	var runs: Array = []
	var run: Array = []
	for l in mine:
		var ld: Dictionary = l
		if not run.is_empty():
			var prev: Dictionary = run[run.size() - 1]
			if int(prev["round"]) != int(ld["round"]) or float(ld["t"]) - float(prev["t"]) > COMBO_GAP:
				if run.size() >= 2:
					runs.append(run)
				run = []
		run.append(ld)
	if run.size() >= 2:
		runs.append(run)
	var by: Dictionary = {}
	var order: Array = []
	for r in runs:
		var names := PackedStringArray()
		for l in r:
			names.append(PunchList.report_name(l).to_lower())
		var key: String = ", ".join(names)
		key = key.substr(0, 1).to_upper() + key.substr(1)
		if not by.has(key):
			by[key] = []
			order.append(key)
		(by[key] as Array).append((r as Array)[0])
	var out: Array = []
	for k in order:
		out.append({"words": k, "at": by[k]})
	out.sort_custom(func(a, b): return (a["at"] as Array).size() > (b["at"] as Array).size())
	return out

func _combo_section(mine: Array) -> void:
	var v := _sec("Their combinations")
	combos = combinations(mine)
	if combos.is_empty():
		v.add_child(UI.label("none in this film", TXT, Palette.MUTED, "semi"))
	for c in combos.slice(0, 2):
		var cd: Dictionary = c
		var at: Array = cd["at"]
		var h := HFlowContainer.new()
		h.add_theme_constant_override("h_separation", 8)
		h.add_child(UI.label("x%d" % at.size(), TXT, Palette.HEADER, "bold"))
		h.add_child(UI.label(str(cd["words"]), TXT, Palette.TEXT, "semi"))
		for l in at.slice(0, 3):
			var ld: Dictionary = l
			var b := UI.button(PunchList.clock_words(ld), "Pill", func(): _on_select.call(ld))
			b.name = "ComboAt"
			h.add_child(b)
		if at.size() > 3:
			h.add_child(UI.label("+%d" % (at.size() - 3), TXT, Palette.MUTED, "semi"))
		v.add_child(h)

# --- what the numbers say ------------------------------------------------------------------------------------------------

func _say_section(mine: Array) -> void:
	var v := _sec("What the numbers say")
	var box := PanelContainer.new()
	box.add_theme_stylebox_override("panel", UI.box(Palette.dim(), Palette.CLEAR, 4, 0, 12, 9))
	var inner := UI.vbox(6)
	box.add_child(inner)
	sentences = say(mine)
	for s in sentences:
		var l := UI.label(str(s), TXT, Palette.TEXT, "body", true)
		l.custom_minimum_size.x = 240
		inner.add_child(l)
	v.add_child(box)

## Three sentences, numbers only: the most thrown and the cleanest punch; the last round against round 1; two ranges.
static func say(mine: Array) -> Array:
	if mine.is_empty():
		return ["No punches on this film."]
	var thrown: Dictionary = {}
	var clean: Dictionary = {}
	var rounds: Dictionary = {}
	var ranges: Dictionary = {}
	for l in mine:
		var ld: Dictionary = l
		var nm: String = PunchList.report_name(ld).to_lower()
		thrown[nm] = int(thrown.get(nm, 0)) + 1
		var hit: int = 1 if _landed(str(ld["result"])) else 0
		if str(ld["result"]) == "Clean":
			clean[nm] = int(clean.get(nm, 0)) + 1
		var rn: int = int(ld["round"])
		var rr: Array = rounds.get(rn, [0, 0])
		rounds[rn] = [int(rr[0]) + hit, int(rr[1]) + 1]
		var rg: String = str(ld["range"])
		var gg: Array = ranges.get(rg, [0, 0])
		ranges[rg] = [int(gg[0]) + hit, int(gg[1]) + 1]
	var most: String = _top(thrown)
	var best: String = _top(clean)
	var out: Array = []
	if best == "":
		out.append("The %s is thrown most; nothing lands clean." % most)
	elif best == most:
		out.append("The %s is thrown most and lands clean most, %d times." % [most, int(clean[best])])
	else:
		out.append("The %s is thrown most; the %s lands clean most, %d times." % [most, best, int(clean[best])])
	var rns: Array = rounds.keys()
	rns.sort()
	var first: Array = rounds[rns[0]]
	var last: Array = rounds[rns[rns.size() - 1]]
	if rns.size() == 1:
		out.append("Round %d: %d landed of %d." % [int(rns[0]), int(first[0]), int(first[1])])
	else:
		out.append("Round %d: %d landed of %d, against %d of %d in round %d." % [int(rns[rns.size() - 1]), int(last[0]),
			int(last[1]), int(first[0]), int(first[1]), int(rns[0])])
	var busiest: String = ""
	var sharpest: String = ""
	for rg in ranges:
		var g: Array = ranges[rg]
		if busiest == "" or int(g[1]) > int((ranges[busiest] as Array)[1]):
			busiest = str(rg)
	for rg in ranges:
		var g: Array = ranges[rg]
		if str(rg) != busiest and (sharpest == "" or float(g[0]) / float(g[1]) > float((ranges[sharpest] as Array)[0]) / float((ranges[sharpest] as Array)[1])):
			sharpest = str(rg)
	var b_n: Array = ranges[busiest]
	var b_say: String = str(RANGE_SAY.get(busiest, busiest))
	if sharpest == "":
		out.append("%s%s, %d landed of %d." % [b_say.substr(0, 1).to_upper(), b_say.substr(1), int(b_n[0]), int(b_n[1])])
	else:
		var s_n: Array = ranges[sharpest]
		var s_say: String = str(RANGE_SAY.get(sharpest, sharpest))
		out.append("%s%s, %d landed of %d; %s, %d of %d." % [s_say.substr(0, 1).to_upper(), s_say.substr(1), int(s_n[0]),
			int(s_n[1]), b_say, int(b_n[0]), int(b_n[1])])
	return out

static func _top(d: Dictionary) -> String:
	var best := ""
	for k in d:
		if best == "" or int(d[k]) > int(d[best]):
			best = str(k)
	return best

## THE FILM's rounds strip: per round the corner that won more of its exchanges (FilmBout `won` = the other corner won).
static func rounds_strip(bout: Dictionary, rounds: int, side_words: Array = ["Them", "The other"]) -> HBoxContainer:
	var strip := UI.hbox(6)
	for r in rounds:
		var other := 0
		var them := 0
		for ex in bout.get("exchanges", []):
			var exd: Dictionary = ex
			if int(exd.get("round", 0)) == r + 1:
				other += 1 if bool(exd.get("won", false)) else 0
				them += 0 if bool(exd.get("won", false)) else 1
		var cell := PanelContainer.new()
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cell.add_theme_stylebox_override("panel", UI.box(Palette.PAGE, Palette.LINE, 3, 1, 8, 4))
		var v := UI.vbox(3)
		cell.add_child(v)
		v.add_child(UI.label("ROUND %d" % (r + 1), TXT, Palette.MUTED, "caps"))
		var words: String = "not boxed"
		var ink: Color = Palette.MUTED
		if them > other:
			words = "%s %d-%d" % [side_words[0], them, other]
			ink = Palette.BLUE_CORNER
		elif other > them:
			words = "%s %d-%d" % [side_words[1], other, them]
			ink = Palette.RED_CORNER
		elif them > 0:
			words = "Even %d-%d" % [them, other]
		var card := PanelContainer.new()
		card.name = "RoundWon"
		card.add_theme_stylebox_override("panel", UI.box(Color(ink, 0.22), Color(ink, 0.6), 2, 1, 6, 1))
		var wl := UI.label(words, TXT, Palette.TEXT, "bold")
		wl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card.add_child(wl)
		v.add_child(card)
		strip.add_child(cell)
	return strip

## MARK A PATTERN's MARKED TONIGHT rows: the coach's word, the counts per film side by side, the claim.
static func marked_rows(box: VBoxContainer, marked: Array, films_n: int, pronoun: String) -> void:
	UI.clear(box)
	var f: float = TextScale.factor()
	for m in marked:
		var md: Dictionary = m
		var h := UI.hbox(10)
		h.name = "MarkedRow"
		var word: String = str(md.get("word", ""))
		var wtext: String = "Watch list" if word == "watch" else FilmPattern.word_text(word, pronoun)
		var cells := PackedStringArray()
		var per: Array = md.get("per_film", [])
		for i in maxi(per.size(), films_n):
			var s: String = str(per[i]) if i < per.size() else ""
			cells.append(s if s != "" else "-")
		var ws: String = str(md.get("words", ""))
		for cell in [[wtext, WORD_INK.get(word, Palette.MUTED), "bold", 150.0 * f], [" | ".join(cells), Palette.MUTED, "semi", 170.0 * f],
				[ws.substr(0, 1).to_upper() + ws.substr(1), Palette.TEXT, "semi", 640.0 - 340.0 * f]]:
			var l := UI.label(str(cell[0]), TXT, cell[1], str(cell[2]))
			l.custom_minimum_size.x = float(cell[3])
			h.add_child(l)
			TextScale.fit(l, float(cell[3]), TXT, 12)
		box.add_child(h)

## Adds or updates a claim in MARKED TONIGHT: its counts on film `cur` and its latest word (a watch keeps a checked word).
static func mark(marked: Array, claim: Dictionary, word: String, counts: String, cur: int) -> void:
	var entry: Dictionary = {}
	for m in marked:
		var md: Dictionary = m
		if str(md.get("when", "")) == str(claim.get("when", "")) and str(md.get("then", "")) == str(claim.get("then", "")):
			entry = md
	if entry.is_empty():
		entry = {"when": str(claim.get("when", "")), "then": str(claim.get("then", "")), "words": str(claim.get("words", "")),
			"per_film": [], "word": word}
		marked.append(entry)
	var per: Array = entry.get("per_film", [])
	while per.size() <= cur:
		per.append("")
	per[cur] = counts
	entry["per_film"] = per
	if word != "watch" or str(entry.get("word", "")) == "":
		entry["word"] = word
