extends PanelContainer
## S382 CARDFLIP1 (TRAINING_SCREEN_S381.md 5.6, the approved mockup's gold card): one drill card in the week review's PADS
## row (PadReview row). The face: her picture, the kind tag, the card's short name and punches, mastery before -> after
## counting on with its bar (ticks 30 / 60 / 85, the hatched wall at her cap) and the nights it got. A card that crossed
## 30 / 60 / 85 this week turns over (FLIP_S, a half-turn squeeze and back) to its gold back: the tier word, the card, the
## night that did it ("Mon pads: 25.2 -> 30.4"), the gold bar - which pulses as it lands. No coach line (flavour text).
## Both sides are always laid out (the back starts at alpha 0), so the turn never changes the card's size.
##   FlipCard.make(f, row) -> "PadCard_<card>"   grow() bar + number   flip() the turn   settle() all at once (skip)

const UI := preload("res://scripts/ui/UI.gd")
const DrillCard := preload("res://scripts/ui/DrillCard.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const PadReview := preload("res://scripts/rules/PadReview.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

## Four cards across the review's 940 px body (PadReview.ROW_MAX, 12 px apart).
const CARD_W := 226.0
const CARD_H := 200.0
const PIC := 64.0
## The whole turn (the spec's 0.35 s): squeeze to the edge, swap sides, open out.
const FLIP_S := 0.35
const GROW_S := 0.6
const PULSE_S := 0.3
const GOLD_FILL := Color("#a77a00")
const GOLD_GAIN := Color("#e9a800")
const GOLD_TRACK := Color("#fff6d0")

var row := {}
## True once the gold back faces out (the test and the film read it).
var gold := false
var face: PanelContainer
var back: PanelContainer
var bar: Control
var gold_bar: Control
var num: Label
var _turn: Tween
var _grow: Tween
var _pulse_t: Tween   # the gold bar's pulse - settle() stops it too (a click mid-pulse left it scaling after the skip)


static func make(f: Dictionary, r: Dictionary) -> PanelContainer:
	var card := new()
	card.row = r
	var id := str(r["card"])
	card.name = "PadCard_" + id.replace(":", "_").replace(" ", "_")
	card.custom_minimum_size = Vector2(CARD_W, CARD_H)   # a card's shape whether the row holds 1 card or 4
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	var capv := PadWeek.cap(f, id) if not f.is_empty() else 100.0
	card.face = card._side("Face", UI.box(UI.PANEL, UI.LINE, 10, 2, 10, 8))
	card._face_body(f, id, capv)
	if not (r.get("cross", {}) as Dictionary).is_empty():
		card.back = card._side("Back", UI.box(DrillCard.GOLD_BG, DrillCard.GOLD_EDGE, 10, 2, 10, 8))
		card.back.modulate.a = 0.0
		card._back_body(f, id, capv)
	return card


func _side(nm: String, style: StyleBox) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = nm
	p.add_theme_stylebox_override("panel", style)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.clip_contents = true
	add_child(p)
	return p


func _face_body(f: Dictionary, id: String, capv: float) -> void:
	var v := _vb(face)
	var top := UI.hbox(10)
	v.add_child(top)
	var pic := TextureRect.new()
	pic.custom_minimum_size = Vector2(PIC, PIC)
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	pic.texture = DrillCard.picture(f, id)
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top.add_child(pic)
	var words := UI.vbox(0)
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(words)
	var tag := PanelContainer.new()
	tag.add_theme_stylebox_override("panel", UI.box(Color("#e8efff"), Color(0, 0, 0, 0), 4, 0, 6, 1))
	tag.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tag.add_child(UI.label(PadEdit.kind_word(f, id) if not f.is_empty() else "DRILL", 11, UI.GOLD, "bold"))
	words.add_child(tag)
	words.add_child(_clip(UI.label(PadEdit.title(f, id), 24, UI.FG, "marker")))
	# A move's front names the tier she started the week on: the gold back is where "usable" is said (no spoiler).
	var front := MoveMastery.tier(float(row["before"])).to_lower() if PadWeek.kind(id) == "move" else _sub(f, id)
	var sub := UI.label(front, 13, UI.MUTED, "body")
	sub.name = "Sub"
	words.add_child(_clip(sub))
	var before := float(row["before"])
	var after := float(row["after"])
	num = UI.label(_nums(before), 20, UI.FG, "bold")
	num.name = "Nums"
	v.add_child(num)
	bar = _bar(capv, before, before, false)
	v.add_child(bar)
	var nl := UI.label(PadReview.nights_text(row), 14, UI.MUTED, "semi")
	nl.name = "Nights"
	v.add_child(_clip(nl))
	if after <= before + 0.05:
		num.text = "%.1f" % after


func _back_body(f: Dictionary, id: String, capv: float) -> void:
	var cr: Dictionary = row["cross"]
	var v := _vb(back)
	var top := UI.hbox(6)
	v.add_child(top)
	var tw := UI.label(str(cr["tier"]).to_upper(), 40, DrillCard.GOLD_INK, "marker")
	tw.name = "Tier"
	top.add_child(tw)
	top.add_child(UI.spacer())
	top.add_child(UI.label("★", 30, DrillCard.GOLD_EDGE, "bold"))
	var nr := UI.hbox(8)
	var nm := UI.label(PadEdit.title(f, id), 22, UI.FG, "marker")   # unclipped: a clipped label in a row shrinks to nothing
	nm.name = "Name"
	nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nr.add_child(nm)
	var s := UI.label("" if PadWeek.kind(id) == "move" else _sub(f, id), 13, UI.FG, "body")
	s.size_flags_vertical = Control.SIZE_SHRINK_END
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nr.add_child(_clip(s))
	v.add_child(nr)
	var when := UI.label("%s %s: %.1f -> %.1f" % [PadReview.DAY_WORDS[int(cr["dow"])], str(cr["station"]), float(cr["before"]),
		float(cr["after"])], 16, UI.FG, "bold")
	when.name = "When"
	v.add_child(_clip(when))
	gold_bar = _bar(capv, float(row["before"]), float(row["after"]), true)
	v.add_child(gold_bar)
	v.add_child(_clip(UI.label(PadReview.nights_text(row), 14, DrillCard.GOLD_INK, "semi")))


func _vb(side: PanelContainer) -> VBoxContainer:
	var v := UI.vbox(5)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	side.add_child(v)
	return v


func _bar(capv: float, now: float, end: float, golden: bool) -> Control:
	var b := DrillCard.TierBar.new()
	b.name = "GoldBar" if golden else "Bar"
	b.now = now
	b.cap = capv
	b.end = end
	if golden:
		b.track = GOLD_TRACK
		b.fill = GOLD_FILL
		b.gain = GOLD_GAIN
	return b


static func _clip(l: Control) -> Control:
	if l is Label:
		(l as Label).clip_text = true
		(l as Label).text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


static func _sub(f: Dictionary, id: String) -> String:
	return PadEdit.sub(f, id) if not f.is_empty() else ""


func _nums(x: float) -> String:
	return "%.1f -> %.1f" % [float(row["before"]), x]


## The bar grows from before to after and the number counts on with it (animated meters).
func grow() -> void:
	var before := float(row["before"])
	var after := float(row["after"])
	if after <= before + 0.05:
		return
	_grow = create_tween().set_parallel(true)
	_grow.tween_property(bar, "end", after, GROW_S).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_grow.tween_method(func(x: float) -> void: num.text = _nums(x), before, after, GROW_S) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


## The turn: squeeze to the edge (a slight lift), the gold back swaps in at the edge, open out; then the gold bar pulses.
func flip() -> void:
	if back == null or gold:
		return
	pivot_offset = size * 0.5
	_turn = create_tween()
	_turn.tween_property(self, "scale", Vector2(0.0, 1.04), FLIP_S * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	_turn.tween_callback(_swap)
	_turn.tween_property(self, "scale", Vector2.ONE, FLIP_S * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_turn.tween_callback(_pulse)


func _swap() -> void:
	face.modulate.a = 0.0
	back.modulate.a = 1.0
	gold = true


func _pulse() -> void:
	gold_bar.pivot_offset = gold_bar.size * 0.5
	_pulse_t = gold_bar.create_tween()
	_pulse_t.tween_property(gold_bar, "scale", Vector2(1.0, 1.3), PULSE_S * 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_pulse_t.tween_property(gold_bar, "scale", Vector2.ONE, PULSE_S * 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


## Everything at once (a click skips the review's reveal): the bar full, the number final, the gold back out.
func settle() -> void:
	for t in [_grow, _turn, _pulse_t]:
		if t != null:
			(t as Tween).kill()
	bar.set("end", float(row["after"]))
	num.text = _nums(float(row["after"])) if float(row["after"]) > float(row["before"]) + 0.05 else "%.1f" % float(row["after"])
	scale = Vector2.ONE
	if back != null:
		_swap()
		gold_bar.scale = Vector2.ONE
