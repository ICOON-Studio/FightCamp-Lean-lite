extends RefCounted
## S430 the fight in numbers, drawn (rules/FightStats.gd; operator: "during the corner time i asked to see more match
## analysis stats", and on the result page: "you need to show stats to explain what happenned"). The same block on the
## corner card (the fight so far) and on the result page (the whole fight), in the dark TV look:
##   strip(st, names)   one chip a round in the winner's colour, with the punches landed
##   bars(st, names)    paired bars, ours growing left and the opponent's right
##   lists(st, names)   the opponent's games with how often we won against each, and our calls with a dot per use
##   build(rounds, names) -> all three      tabs(first, second, a, b) -> two blocks behind two buttons

const UI := preload("res://scripts/ui/TV.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")
const CornerStats := preload("res://scripts/ui/CornerStats.gd")

const BLUE := Color("#6f9cf0")
const TEXT := 20
const ROWS := 3


## `compact` (the corner card, which must stay inside the letterbox): the rounds, punches landed and exchanges won, and
## the two most used games and calls.
static func build(rounds: Array, names: Array, compact: bool = false) -> VBoxContainer:
	var st := FightStats.of(rounds)
	var v := UI.vbox(6)
	v.name = "MatchStats"
	v.add_child(strip(st, names))
	v.add_child(bars(st, names, "THE FIGHT", ["Punches landed", "Exchanges won"] if compact else []))
	v.add_child(lists(st, names, 2 if compact else ROWS))
	return v


static func strip(st: Dictionary, _names: Array) -> HBoxContainer:
	var h := UI.hbox(8)
	h.name = "RoundStrip"
	var tag := UI.caps("PUNCHES LANDED")   # DEFECTS1: the chips are punches landed, not scores
	tag.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(tag)
	for r in st["rounds"]:
		var won := bool(r["won"])
		var col: Color = UI.RED if won else BLUE
		var chip := PanelContainer.new()
		chip.name = "Round%d" % int(r["n"])
		chip.add_theme_stylebox_override("panel", UI.box(col.darkened(0.55), col, 6, 2, 10, 2))
		var l: Array = r["landed"]
		var t: Array = r["tank"]
		chip.tooltip_text = "Round %d: %s round. Landed %d to %d, exchanges %d to %d, energy left at the bell %d and %d." % [int(r["n"]),
			"your boxer's" if won else "the opponent's", int(l[0]), int(l[1]), int(r["xwon"][0]), int(r["xwon"][1]), int(round(float(t[0]))),
			int(round(float(t[1])))]
		chip.add_child(UI.label("%d   %d-%d" % [int(r["n"]), int(l[0]), int(l[1])], TEXT, UI.FG, "bold"))
		h.add_child(chip)
	return h


static func bars(st: Dictionary, names: Array, middle: String = "THE FIGHT", only: Array = []) -> GridContainer:
	var g := GridContainer.new()
	g.name = "FightBars"
	g.columns = 5
	g.add_theme_constant_override("h_separation", 10)
	g.add_theme_constant_override("v_separation", 3)
	g.add_child(_cell(str(names[0]).to_upper(), UI.RED, HORIZONTAL_ALIGNMENT_RIGHT, 96, "bold"))
	g.add_child(Control.new())
	g.add_child(_cell(middle, UI.MUTED, HORIZONTAL_ALIGNMENT_CENTER, 210, "bold"))
	g.add_child(Control.new())
	g.add_child(_cell(str(names[1]).to_upper(), BLUE, HORIZONTAL_ALIGNMENT_LEFT, 96, "bold"))
	for r in FightStats.rows(st):
		if not only.is_empty() and not only.has(str(r["label"])):
			continue
		var lead := int(r["lead"])
		var ca: Color = UI.RED if lead == 0 else UI.MUTED
		var cb: Color = BLUE if lead == 1 else UI.MUTED
		g.add_child(_cell(str(r["a"]), ca, HORIZONTAL_ALIGNMENT_RIGHT, 96))
		g.add_child(CornerStats._bar(float(r["fa"]), ca, true))
		g.add_child(_cell(str(r["label"]), UI.FG, HORIZONTAL_ALIGNMENT_CENTER, 210))
		g.add_child(CornerStats._bar(float(r["fb"]), cb, false))
		g.add_child(_cell(str(r["b"]), cb, HORIZONTAL_ALIGNMENT_LEFT, 96))
	return g


static func lists(st: Dictionary, names: Array, rows: int = ROWS) -> HBoxContainer:
	var h := UI.hbox(28)
	h.name = "FightLists"
	var games := UI.vbox(2)
	games.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	games.add_child(_head("%s'S GAME" % str(names[1]).to_upper(), "What the opponent did most, and how many of those exchanges your boxer won. The answer is the call that beats it."))
	var shown := 0
	for row in st["games"]:
		var word := FightStats.game_word(str(row["sit"]))
		if word == "" or str(row["sit"]).begins_with("she_") or shown >= rows:   # she_tired / she_hurt are our boxer's state
			continue
		shown += 1
		var ans := FightStats.answer(str(row["sit"]))
		games.add_child(_row(word, int(row["won"]), int(row["n"]), "beat it with %s" % ans if ans != "" and int(row["won"]) * 2 < int(row["n"]) else ""))
	h.add_child(games)
	var calls := UI.vbox(2)
	calls.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	calls.add_child(_head("YOUR CALLS", "Each call in force, with a dot for every exchange it ran: green won, red lost."))
	for row in (st["calls"] as Array).slice(0, rows):
		var word := FightStats.call_word(str(row["id"]))
		if word != "":
			calls.add_child(_row(word, int(row["won"]), int(row["n"]), ""))
	h.add_child(calls)
	return h


## Two blocks behind two buttons (the corner card: THIS ROUND / THE FIGHT). `second_first` opens on the second.
static func tabs(first: Control, second: Control, a: String, b: String, second_first: bool = false) -> VBoxContainer:
	var v := UI.vbox(4)
	v.name = "StatTabs"
	var bar := UI.hbox(8)
	var ba := Button.new()
	var bb := Button.new()
	var show := func(on_second: bool) -> void:
		first.visible = not on_second
		second.visible = on_second
		ba.theme_type_variation = "BtnQuiet" if on_second else "Btn"
		bb.theme_type_variation = "Btn" if on_second else "BtnQuiet"
	for pair in [[ba, a, "TabFirst", false], [bb, b, "TabSecond", true]]:
		var btn: Button = pair[0]
		btn.text = str(pair[1])
		btn.name = str(pair[2])
		btn.focus_mode = Control.FOCUS_NONE
		btn.add_theme_font_size_override("font_size", TEXT)
		btn.pressed.connect(show.bind(bool(pair[3])))
		bar.add_child(btn)
	v.add_child(bar)
	v.add_child(first)
	v.add_child(second)
	show.call(second_first)
	return v


static func _head(text: String, tip: String) -> Label:
	var l := UI.label(text, TEXT, UI.GOLD, "bold")
	l.mouse_filter = Control.MOUSE_FILTER_PASS
	l.tooltip_text = tip
	return l


## "Pressing  ●●●○○  2 of 5   beat it with Jab and move"
static func _row(word: String, won: int, n: int, hint: String) -> HBoxContainer:
	var h := UI.hbox(10)
	var name := UI.label(word, TEXT, UI.FG)
	name.custom_minimum_size = Vector2(250, 0)
	h.add_child(name)
	var p := _Pips.new()
	p.won = won
	p.n = n
	h.add_child(p)
	h.add_child(UI.label("%d of %d" % [won, n], TEXT, UI.GREEN if won * 2 > n else (UI.RED if won * 2 < n else UI.MUTED), "bold"))
	if hint != "":
		h.add_child(UI.label(hint, TEXT, UI.GOLD))
	return h


static func _cell(text: String, col: Color, align: HorizontalAlignment, wide: float, kind: String = "body") -> Label:
	var l := UI.label(text, TEXT, col, kind)
	l.horizontal_alignment = align
	l.custom_minimum_size = Vector2(wide, 0)
	return l


## A dot for every exchange: the won ones green, then the lost ones red.
class _Pips extends Control:
	var won := 0
	var n := 0

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		size_flags_vertical = Control.SIZE_SHRINK_CENTER

	func _ready() -> void:
		custom_minimum_size = Vector2(maxi(n, 1) * 16.0, 16.0)

	func _draw() -> void:
		for i in n:
			draw_circle(Vector2(8.0 + i * 16.0, 8.0), 6.0, Color("#6cc27a") if i < won else Color("#e0503c"))
