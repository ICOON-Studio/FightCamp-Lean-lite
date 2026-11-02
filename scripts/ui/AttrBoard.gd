extends RefCounted
## S340 C157 (operator on her Overview: "need something way more fancy, and also there are attributes missing there"): her
## attributes as a board - a radar of the eight fight attributes against her potential, and every value the bout reads in
## three groups. Footwork and her personality (heart, discipline, confidence, coachability, temper) were used by the fight
## (Exchanges' calls, Knockdowns, TheRead, the corner's fixes) but never shown. Each value is a tile coloured by its band,
## with this week's change beside it; hovering a row says what it does in a fight.
##   rows(f) -> [{title, rows: [{key, name, value, delta, band, why}]}]   glance(f) -> {best, work, fight_avg, pot, hot, ...}
##   build(f) -> card (PanelContainer)

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const AttrRadar := preload("res://scripts/ui/AttrRadar.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const StatBar := preload("res://scripts/ui/StatBar.gd")

const GROUPS := [
	{"title": "FIGHTING", "keys": ["power", "speed", "technique", "defense", "footwork"]},
	{"title": "BODY", "keys": ["conditioning", "chin"]},
	{"title": "MIND", "keys": ["fight_iq", "heart", "discipline", "confidence", "coachability", "temper"]},
]
const RADAR := ["power", "speed", "technique", "defense", "footwork", "conditioning", "chin", "fight_iq"]
const NAME := {"footwork": "Footwork", "heart": "Heart", "discipline": "Discipline", "confidence": "Confidence",
	"coachability": "Coachability", "temper": "Temper"}
const PERSONALITY := ["heart", "discipline", "confidence", "coachability", "temper"]
## What each value does in a bout (read from the rule that uses it).
const WHY := {
	"power": "How hard the punches land: hurting the opponent, knockdowns, the corner's \"Go for the finish\".",
	"speed": "Hand speed: who lands first and how long combinations run.",
	"technique": "Clean punches, and how fast a move comes on the pads.",
	"defense": "Slips and blocks: how much of the other woman's work gets through.",
	"footwork": "Jab and move: turning the opponent and keeping the range. Grows with speed and defence.",
	"conditioning": "When the tank runs low: energy over the rounds and between them.",
	"chin": "How much she takes before she is hurt or down.",
	"fight_iq": "Ring IQ: reading the other woman's game and making the corner's calls work.",
	"heart": "Getting up from a knockdown, holding on when hurt, going for the finish.",
	"discipline": "Sticking to the plan and the corner's \"Breathe, pick your shots\".",
	"confidence": "Lifts after a good round, sinks after a bad one.",
	"coachability": "How quickly a fix from the corner takes hold.",
	"temper": "High: she trades when she is hit (a gambler). Low: she stays patient.",
}
## Tile bands (amateur women's lightweights sit 55-65): the value is under the limit -> that band.
const BANDS := [[45.0, "weak"], [55.0, "fair"], [65.0, "solid"], [75.0, "strong"], [1000.0, "elite"]]
## S342 C158: the bands as colours that read at a glance (grey "solid" read as dead) - purple the elite end, as in games.
const BAND_COLOUR := {"weak": UI.RED, "fair": UI.AMBER, "solid": UI.GOLD, "strong": UI.GREEN, "elite": UI.PURPLE}
## One icon an attribute (Icons.gd, every one with the row's tooltip).
const ICON := {"power": "biceps-flexed", "speed": "zap", "technique": "target", "defense": "shield", "footwork": "footprints",
	"conditioning": "heart-pulse", "chin": "shield-alert", "fight_iq": "brain", "heart": "heart", "discipline": "clipboard-pen",
	"confidence": "trending-up", "coachability": "user-check", "temper": "flame"}
const NAME_W := 128


static func value(f: Dictionary, key: String) -> float:
	if key == "footwork":
		var st: Dictionary = f.get("stats", {})
		return float(f.get("footwork", (float(st.get("speed", 55.0)) + float(st.get("defense", 55.0))) * 0.5))
	if PERSONALITY.has(key):
		return float((f.get("personality", {}) as Dictionary).get(key, 55.0))
	return float((f.get("stats", {}) as Dictionary).get(key, 55.0))


## Temper reads the other way round: a hot temper is the weak end.
static func band(key: String, v: float) -> String:
	var x := 100.0 - v if key == "temper" else v
	for b in BANDS:
		if x < float(b[0]):
			return str(b[1])
	return "elite"


static func label_of(key: String) -> String:
	return str(Data.LABEL.get(key, NAME.get(key, key.capitalize())))


static func rows(f: Dictionary) -> Array:
	var start: Dictionary = f.get("week_start", {})
	var out: Array = []
	for g in GROUPS:
		var list: Array = []
		for key in g["keys"]:
			var v := value(f, str(key))
			var d := v - float(start[key]) if start.has(key) else 0.0
			list.append({"key": key, "name": label_of(str(key)), "value": v, "delta": d, "band": band(str(key), v), "why": WHY[key]})
		out.append({"title": g["title"], "rows": list})
	return out


## S342 C158: radar + the coach's note on the left, then every value as a bar against her potential (FIGHTING and BODY,
## then MIND); temper as a patient <-> trader scale. Hover a row: the number and what it does in a fight.
static func build(f: Dictionary) -> PanelContainer:
	var c := UI.card()
	var head := UI.hbox(10)
	head.add_child(UI.caps("ATTRIBUTES"))
	head.add_child(UI.spacer())
	var pot := float(f.get("pot", 0.0))
	var key := UI.hbox(6)
	key.add_child(_key_swatch())
	key.add_child(UI.muted("value", UI.TINY))
	if pot > 0.0:
		var tick := ColorRect.new()
		tick.color = UI.FG
		tick.custom_minimum_size = Vector2(3, 14)
		tick.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		key.add_child(tick)
		key.add_child(UI.muted("potential, %d    hover a row for what it does" % int(pot), UI.TINY))
	head.add_child(key)
	c[1].add_child(head)
	var body := UI.hbox(32)
	var left := UI.vbox(12)
	var radar: Control = AttrRadar.new()
	radar.values = RADAR.map(func(k): return {"name": label_of(str(k)), "value": value(f, str(k))})
	radar.pot = pot
	radar.numbers = false
	left.add_child(radar)
	body.add_child(left)
	var groups := rows(f)
	var mid := UI.vbox(8)
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_group(mid, groups[0], pot)
	_group(mid, groups[1], pot)
	body.add_child(mid)
	var right := UI.vbox(8)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_group(right, groups[2], pot)
	right.add_child(UI.spacer())
	right.add_child(_glance(glance(f)))
	body.add_child(right)
	c[1].add_child(body)
	return c[0]


static func _key_swatch() -> ColorRect:
	var r := ColorRect.new()
	r.color = UI.GOLD
	r.custom_minimum_size = Vector2(26, 10)
	r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return r


## The coach's read of the board: her two best values, the two to work on, a hot temper, how far she is from her potential.
static func glance(f: Dictionary) -> Dictionary:
	var all: Array = []
	for g in rows(f):
		all.append_array((g["rows"] as Array).filter(func(r): return str(r["key"]) != "temper"))
	all.sort_custom(func(a, b): return float(a["value"]) > float(b["value"]))
	var fight := 0.0
	for k in RADAR:
		fight += value(f, str(k))
	var temper := value(f, "temper")
	return {"best": all.slice(0, 2), "work": [all[all.size() - 1], all[all.size() - 2]], "fight_avg": fight / float(RADAR.size()),
		"pot": float(f.get("pot", 0.0)), "hot": band("temper", temper) == "weak", "temper": temper, "style": str(f.get("style", ""))}


static func _glance(g: Dictionary) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(UI.YELLOW, UI.YELLOW_EDGE, 4, 1, 16, 12))
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var v := UI.vbox(6)
	p.add_child(v)
	v.add_child(UI.label("AT A GLANCE", UI.SMALL, UI.FG, "handbold"))
	var pair := func(rs: Array) -> String: return ", ".join(rs.map(func(r): return "%s %d" % [r["name"], int(floorf(float(r["value"])))]))
	v.add_child(UI.label("Best: " + pair.call(g["best"]), UI.BODY, UI.FG, "hand", true))
	v.add_child(UI.label("Work on: " + pair.call(g["work"]), UI.BODY, UI.FG, "hand", true))
	if bool(g["hot"]):
		v.add_child(UI.label("Hot temper (%d): she trades when she is hit." % int(g["temper"]), UI.BODY, UI.RED, "hand", true))
	if float(g["pot"]) > 0.0:
		v.add_child(UI.label("Fight average %d of a potential %d: room for %d more." % [int(g["fight_avg"]), int(g["pot"]),
			maxi(0, int(g["pot"]) - int(g["fight_avg"]))], UI.BODY, UI.FG, "hand", true))
	if str(g["style"]) != "":
		v.add_child(UI.label("Style: " + str(g["style"]), UI.BODY, UI.MUTED, "hand", true))
	return p


static func _group(parent: VBoxContainer, g: Dictionary, pot := 0.0) -> void:
	parent.add_child(UI.label(str(g["title"]), UI.SMALL, UI.FG, "handbold"))
	for r in g["rows"]:
		parent.add_child(_row(r, pot))


## Icon, name, the bar (her value, the potential tick), the number, this week's change.
static func _row(r: Dictionary, pot := 0.0) -> Control:
	var key := str(r["key"])
	var v := float(r["value"])
	var h := UI.hbox(10)
	h.tooltip_text = "%s %.1f\n%s" % [r["name"], v, r["why"]]
	h.mouse_filter = Control.MOUSE_FILTER_PASS
	var col: Color = BAND_COLOUR[r["band"]]
	h.add_child(Icons.icon(str(ICON.get(key, "info")), 18, UI.MUTED))
	var lab := UI.label(str(r["name"]), UI.BODY)
	lab.custom_minimum_size.x = NAME_W
	h.add_child(lab)
	var bar: Control = StatBar.new()
	bar.value = v
	bar.colour = col
	if key == "temper":
		bar.scale_mode = true
	elif not PERSONALITY.has(key):
		bar.pot = pot
	h.add_child(bar)
	var shown := str(int(floorf(v)))
	if key == "temper":
		shown = "Trader" if v >= 60.0 else ("Patient" if v <= 40.0 else "Even")
	var n := UI.label(shown, UI.BODY, col, "bold")
	n.custom_minimum_size.x = 64 if key == "temper" else 34
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(n)
	var d := float(r["delta"])
	var change := UI.mono("" if absf(d) < 0.05 else ("+%.1f" % d if d > 0.0 else "%.1f" % d), UI.TINY, UI.GREEN if d > 0.0 else UI.RED)
	change.custom_minimum_size = Vector2(40, 0)
	change.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	change.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(change)
	return h
