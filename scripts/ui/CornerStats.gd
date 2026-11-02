extends RefCounted
## S354 C205 (operator on the corner card: "try to communicate the options better and clearer, player needs to see some
## stats to take decisions"): the round in numbers at the top of the corner card, the way a TV broadcast shows it between
## rounds (CompuBox: landed of thrown per punch kind) - her numbers left in her red, the opponent's right in blue, a bar
## each way so the gap reads at a glance; then energy at the bell and each one's worst place on the body map.
##   rows(st, names) -> [{label, a, b, fa, fb, ca, cb}]   head(st, names) -> String   build(st, names) -> VBoxContainer
## st = {round, won, score: [a, b], counts, tally (BodyMap.tally), energy: {a, b}, map (BodyMap, may be empty)}

const UI := preload("res://scripts/ui/TV.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")

const BLUE := Color("#6f9cf0")
const PLACE_WORDS := {"head": "Head", "left_eye": "Left eye", "right_eye": "Right eye", "nose": "Nose",
	"left_ribs": "Left ribs", "right_ribs": "Right ribs"}
const POWER := ["straight", "hook", "uppercut"]


## "ROUND 1: LUCY'S ROUND  -  10-9 ON YOUR CARD  -  ROUNDS 1-0" (a standing count makes it 10-8).
static func head(st: Dictionary, names: Array) -> String:
	var won := bool(st.get("won", false))
	var sc: Array = st.get("score", [0, 0])
	var who := str(names[0] if won else names[1]).to_upper()
	var low := 8 if int(st.get("counts", 0)) > 0 else 9
	return "ROUND %d: %s'S ROUND   -   10-%d ON YOUR CARD   -   ROUNDS %d-%d" % [int(st.get("round", 1)), who, low,
		int(sc[0]), int(sc[1])]


static func rows(st: Dictionary, names: Array) -> Array:
	var t: Dictionary = st.get("tally", {})
	var out: Array = []
	out.append(_count("Punches landed", _n(t, "a", "landed", ["total"]), _n(t, "a", "thrown", ["total"]),
		_n(t, "b", "landed", ["total"]), _n(t, "b", "thrown", ["total"])))
	out.append(_count("Jabs", _n(t, "a", "landed", ["jab"]), _n(t, "a", "thrown", ["jab"]),
		_n(t, "b", "landed", ["jab"]), _n(t, "b", "thrown", ["jab"])))
	out.append(_count("Power punches", _n(t, "a", "landed", POWER), _n(t, "a", "thrown", POWER),
		_n(t, "b", "landed", POWER), _n(t, "b", "thrown", POWER)))
	out.append(_count("To the body", _n(t, "a", "landed", ["body"]), _n(t, "a", "thrown", ["body"]),
		_n(t, "b", "landed", ["body"]), _n(t, "b", "thrown", ["body"])))
	var e: Dictionary = st.get("energy", {})
	var ea := clampf(float(e.get("a", 100.0)), 0.0, 100.0)
	var eb := clampf(float(e.get("b", 100.0)), 0.0, 100.0)
	out.append({"label": "Energy at the bell", "a": "%d" % int(round(ea)), "b": "%d" % int(round(eb)), "fa": ea / 100.0,
		"fb": eb / 100.0, "ca": _level(ea, 60.0, 40.0), "cb": _level(eb, 60.0, 40.0)})
	var map: Dictionary = st.get("map", {})
	if not map.is_empty():
		var wa := _worst(map, "a")
		var wb := _worst(map, "b")
		out.append({"label": "Worst spot", "a": "%s %d" % [PLACE_WORDS[wa[0]], int(wa[1])], "b": "%s %d" % [PLACE_WORDS[wb[0]],
			int(wb[1])], "fa": float(wa[1]) / 100.0, "fb": float(wb[1]) / 100.0,
			"ca": _level(float(wa[1]), BodyMap.HURT, BodyMap.CRITICAL), "cb": _level(float(wb[1]), BodyMap.HURT, BodyMap.CRITICAL)})
	return out


static func build(st: Dictionary, names: Array) -> VBoxContainer:
	var v := UI.vbox(3)
	var h := UI.label(head(st, names), UI.SMALL, UI.GOLD, "bold")
	h.name = "CornerRoundHead"
	v.add_child(h)
	var g := GridContainer.new()
	g.name = "CornerStats"
	g.columns = 5
	g.add_theme_constant_override("h_separation", 10)
	g.add_theme_constant_override("v_separation", 3)
	g.add_child(_cell(str(names[0]).to_upper(), UI.RED, HORIZONTAL_ALIGNMENT_RIGHT, "bold"))
	g.add_child(Control.new())
	g.add_child(_cell("THIS ROUND", UI.MUTED, HORIZONTAL_ALIGNMENT_CENTER, "caps"))
	g.add_child(Control.new())
	g.add_child(_cell(str(names[1]).to_upper(), BLUE, HORIZONTAL_ALIGNMENT_LEFT, "bold"))
	for r in rows(st, names):
		g.add_child(_cell(str(r["a"]), r["ca"], HORIZONTAL_ALIGNMENT_RIGHT))
		g.add_child(_bar(float(r["fa"]), r["ca"], true))
		g.add_child(_cell(str(r["label"]), UI.FG, HORIZONTAL_ALIGNMENT_CENTER))
		g.add_child(_bar(float(r["fb"]), r["cb"], false))
		g.add_child(_cell(str(r["b"]), r["cb"], HORIZONTAL_ALIGNMENT_LEFT))
	v.add_child(g)
	return v


## A landed-of-thrown row; the longer bar is whoever landed more (both empty when nobody landed).
static func _count(label: String, la: int, ta: int, lb: int, tb: int) -> Dictionary:
	var top := float(maxi(1, maxi(la, lb)))
	return {"label": label, "a": "%d of %d" % [la, ta], "b": "%d of %d" % [lb, tb], "fa": la / top, "fb": lb / top,
		"ca": UI.RED if la > lb else UI.MUTED, "cb": BLUE if lb > la else UI.MUTED}


static func _n(t: Dictionary, who: String, key: String, kinds: Array) -> int:
	var d: Dictionary = (t.get(who, {}) as Dictionary).get(key, {})
	var s := 0
	for k in kinds:
		s += int(d.get(k, 0))
	return s


## [place, value] of the lowest place on her map.
static func _worst(map: Dictionary, who: String) -> Array:
	var best := "head"
	var bv := 101.0
	for p in BodyMap.PLACES:
		var val := BodyMap.value(map, who, p)
		if val < bv:
			bv = val
			best = p
	return [best, bv]


static func _level(v: float, ok_at: float, bad_at: float) -> Color:
	return UI.GREEN if v > ok_at else (UI.AMBER if v > bad_at else UI.RED)


static func _cell(text: String, col: Color, align: HorizontalAlignment, kind: String = "body") -> Label:
	var l := UI.caps(text) if kind == "caps" else UI.label(text, UI.SMALL, col, kind)
	if kind == "caps":
		l.add_theme_color_override("font_color", col)
	l.horizontal_alignment = align
	l.custom_minimum_size = Vector2(160 if align == HORIZONTAL_ALIGNMENT_CENTER else 96, 0)
	return l


static func _bar(frac: float, col: Color, leftward: bool) -> Control:
	var b := _Mirror.new()
	b.frac = clampf(frac, 0.0, 1.0)
	b.fill = col
	b.leftward = leftward
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return b


## A thin bar that fills from the table's middle outwards (hers grows left, the opponent's right).
class _Mirror extends Control:
	var frac := 0.0
	var fill := Color.WHITE
	var leftward := false

	func _init() -> void:
		# S354 C206/C207 ("huge distance between index and text"): a fixed width, so each number sits by its label.
		custom_minimum_size = Vector2(170, 10)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0.08))
		var w := size.x * frac
		if w > 0.0:
			draw_rect(Rect2(Vector2(size.x - w if leftward else 0.0, 0.0), Vector2(w, size.y)), fill)
