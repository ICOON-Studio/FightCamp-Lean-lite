extends RefCounted
## S340 C157 (operator on her Overview: "need something way more fancy, and also there are attributes missing there"): her
## attributes as a board - a radar of the eight fight attributes against her potential, and every value the bout reads in
## three groups. Footwork and her personality (heart, discipline, confidence, coachability, temper) were used by the fight
## (Exchanges' calls, Knockdowns, TheRead, the corner's fixes) but never shown. Each value is a tile coloured by its band,
## with this week's change beside it; hovering a row says what it does in a fight.
##   rows(f) -> [{title, rows: [{key, name, value, delta, band, why}]}]   glance(f) -> {best, work, fight_avg, pot, hot, ...}
##   build(f) -> card (PanelContainer)

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const StatBar := preload("res://scripts/ui/StatBar.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## S398 the fighter model (FIGHTER_MODEL_S397.md v2): every attribute the fight reads, in three groups, the radar on six
## keys (the places and the body: where the fighter wins), the signature line and where the fighter wants the fight.
const GROUPS := [
	{"title": "PHYSICAL", "keys": ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility", "durability"]},
	{"title": "SKILL", "keys": ["accuracy", "timing", "defence", "footwork", "inside"]},
	{"title": "MIND", "keys": ["fight_iq", "composure", "heart", "discipline", "confidence", "coachability", "temper"]},
]
const NAME := {"discipline": "Discipline", "confidence": "Confidence", "coachability": "Coachability", "temper": "Temper"}
const PERSONALITY := ["heart", "discipline", "confidence", "coachability", "temper"]
## What each value does in a bout (read from the rule that uses it: Duels, Knockdowns, Exchanges, TheRead).
const WHY := {
	"strength": "Leaning, framing and tying up inside; breaking free off the ropes.",
	"explosiveness": "The first shot of an exchange, and the punch that drops someone.",
	"speed": "Hands and feet: combinations, the counter, and taking the fight where it should be.",
	"stamina": "The tank: how long the work lasts before the legs and guard go.",
	"recovery": "Energy back between rounds, and how fast a hard week clears.",
	"flexibility": "Range and joints: fewer strains in the gym and in the bout.",
	"durability": "How much it takes to hurt or drop the fighter. A stoppage lowers the ceiling.",
	"fight_iq": "Choosing the right place to fight; reading counters and habits.",
	"composure": "The plan holds when hurt or pinned on the ropes.",
	"heart": "Getting up, holding on, and going for the finish.",
	"accuracy": "Landing what is thrown: power shots, finishing, beating the counter-puncher.",
	"timing": "When the punch leaves. Counters, and the counter on the way in.",
	"defence": "Fewer clean punches land: slips, rolls, the guard.",
	"footwork": "Range control and cutting the ring off: who decides where the fight is.",
	"inside": "Short work up close and answering it; the clinch.",
	"discipline": "Sticking to the plan and the corner's \"Breathe, pick your shots\".",
	"confidence": "Lifts after a good round, sinks after a bad one.",
	"coachability": "How quickly a fix from the corner takes hold.",
	"temper": "High: trades when hit (a gambler). Low: stays patient.",
}
## Tile bands (amateur women's lightweights sit 55-65): the value is under the limit -> that band.
const BANDS := [[45.0, "weak"], [55.0, "fair"], [65.0, "solid"], [75.0, "strong"], [1000.0, "elite"]]
## S342 C158: the bands as colours that read at a glance (grey "solid" read as dead) - purple the elite end, as in games.
const BAND_COLOUR := {"weak": UI.RED, "fair": UI.AMBER, "solid": UI.GOLD, "strong": UI.GREEN, "elite": UI.PURPLE}
## One icon an attribute (Icons.gd, every one with the row's tooltip).
const ICON := {"strength": "hand-fist", "explosiveness": "zap", "speed": "zap", "stamina": "heart-pulse",
	"recovery": "refresh-cw", "flexibility": "user", "durability": "shield", "accuracy": "target", "timing": "zap",
	"defence": "shield", "footwork": "footprints", "inside": "user", "fight_iq": "brain", "composure": "shield",
	"heart": "heart", "discipline": "clipboard-pen", "confidence": "trending-up", "coachability": "user-check",
	"temper": "flame"}
const NAME_W := 128


static func value(f: Dictionary, key: String) -> float:
	if PERSONALITY.has(key):
		return float((f.get("personality", {}) as Dictionary).get(key, 55.0))
	return float(Attrs.of(f).get(key, 55.0))


## Temper reads the other way round: a hot temper is the weak end.
static func band(key: String, v: float) -> String:
	var x := 100.0 - v if key == "temper" else v
	for b in BANDS:
		if x < float(b[0]):
			return str(b[1])
	return "elite"


static func label_of(key: String) -> String:
	return str(Attrs.LABEL.get(key, NAME.get(key, key.capitalize())))


static func rows(f: Dictionary) -> Array:
	var start: Dictionary = f.get("attrs_week", {})
	var out: Array = []
	for g in GROUPS:
		var list: Array = []
		for key in g["keys"]:
			var v := value(f, str(key))
			var d := v - float(start[key]) if start.has(key) else 0.0
			# S434 CARDIO1 (TRAINING_MAP T17): the Stamina row carries its own line (BoutRules.fade_words), "tires from round 3, every stat 0.50 lower; no fade from Stamina 60".
			var why := str(WHY[key]) + ("\nIn a bout: " + BoutRules.fade_words(v) if key == "stamina" else "")
			# S439 (T17 "Printed on the row"): the line in a few words under the row itself, the sentence stays on hover
			var line := BoutRules.fade_row(v) if key == "stamina" else ""
			list.append({"key": key, "name": label_of(str(key)), "value": v, "delta": d, "band": band(str(key), v), "why": why, "line": line})
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
	# S398 (menus round 6 + the operator's rule): the bars carry the numbers; the radar drew the same ones again - cut.
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
	var a := Attrs.of(f)
	var temper := value(f, "temper")
	return {"best": all.slice(0, 2), "work": [all[all.size() - 1], all[all.size() - 2]], "fight_avg": Attrs.overall(a),
		"pot": float(f.get("pot", 0.0)), "hot": band("temper", temper) == "weak", "temper": temper,
		"style": AttrGen.style_word({"attrs": a, "pace": a.get("pace", 55.0), "forward": a.get("forward", 50.0)}),
		"signature": Attrs.signature(a), "wants": Attrs.wants_words(a)}


static func _glance(g: Dictionary) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(UI.YELLOW, UI.YELLOW_EDGE, 4, 1, 16, 12))
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var v := UI.vbox(6)
	p.add_child(v)
	v.add_child(UI.label("AT A GLANCE", UI.SMALL, UI.FG, "handbold"))
	# S397 blind round 4 ("the same values three times"): the note names them; the bars beside it carry the numbers.
	var pair := func(rs: Array) -> String: return " and ".join(rs.map(func(r): return str(r["name"])))
	if str(g.get("signature", "")) != "":
		v.add_child(UI.label(str(g["signature"]) + ".", UI.BODY, UI.FG, "handbold", true))
	v.add_child(UI.label("In the ring: " + str(g.get("wants", "")) + ".", UI.BODY, UI.FG, "hand", true))
	v.add_child(UI.label("Best: " + pair.call(g["best"]), UI.BODY, UI.FG, "hand", true))
	v.add_child(UI.label("Work on: " + pair.call(g["work"]), UI.BODY, UI.FG, "hand", true))
	if bool(g["hot"]):
		v.add_child(UI.label("Hot temper: trades when hit.", UI.BODY, UI.RED, "hand", true))
	if float(g["pot"]) > 0.0:
		var room := int(g["pot"]) - int(g["fight_avg"])
		v.add_child(UI.label("Room to grow: %s." % ("a lot" if room >= 20 else ("some" if room >= 8 else "close to the ceiling")), UI.BODY, UI.FG, "hand", true))
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
		shown = "Trades" if v >= 60.0 else ("Patient" if v <= 40.0 else "Even")
	var n := UI.label(shown, UI.BODY, col, "bold")
	n.custom_minimum_size.x = 64 if key == "temper" else 34
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(n)
	var d := float(r["delta"])
	var change := UI.mono("" if absf(d) < 0.05 else ("+%.1f wk" % d if d > 0.0 else "%.1f wk" % d), UI.TINY, UI.GREEN if d > 0.0 else UI.RED)
	change.custom_minimum_size = Vector2(58, 0)
	change.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	change.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(change)
	return with_line(h, r, UI.MUTED)


## S439 T17: a row with a line ("From round 3: fights 0.61 weaker; Stamina 60 stops it") carries it in small words under the row, the same tooltip.
static func with_line(h: Control, r: Dictionary, ink: Color) -> Control:
	if str(r.get("line", "")) == "":
		return h
	var box := UI.vbox(0)
	box.tooltip_text = h.tooltip_text
	box.mouse_filter = Control.MOUSE_FILTER_PASS
	box.add_child(h)
	var cap := UI.label(str(r["line"]), UI.TINY, ink)
	cap.name = "RowLine"
	cap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART   # the plain-words line wraps under its row, never widens the board
	cap.mouse_filter = Control.MOUSE_FILTER_PASS
	box.add_child(cap)
	return box
