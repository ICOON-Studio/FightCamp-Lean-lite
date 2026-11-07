extends VBoxContainer
## S359 a book of moves (operator: "escapes has nothing, is that intentional?", "the playbook/moves is still confusing to
## me"): moves grouped by the situation they answer, each card says in one line what it does and whether she can use it
## yet (lit, or grey with what she must learn first); a click plays it in the Playbook's player. No map, no route.
## S360 (operator Q-S294-91: "visually and progressively rewarding"): with her combination pad time (`combos`) each card
## shows how far the move has come - a tier (RAW / USABLE / SHARP / SIGNATURE, MoveMastery) and a bar - each group how
## many of its moves are ready, and the book what to drill next.
##   MoveBook.make(groups, words, mastery, on_pick, combos = {}, progress = false, fighter = {}) -> MoveBook
##       groups = [[title, line, [move ids]]]; with `fighter` each card opens the hover card (MoveTip, S382)
##   signal picked(id)

const UI := preload("res://scripts/ui/UI.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const MoveTip := preload("res://scripts/ui/MoveTip.gd")

signal picked(id: String)

const CARD_W := 380.0
const CARD_H := 104.0
const TIER_COLOR := {"UNLEARNED": UI.MUTED, "RAW": UI.AMBER, "USABLE": UI.GREEN, "SHARP": UI.GOLD, "SIGNATURE": UI.PURPLE}

var _cards := {}   # id -> Button
var _combos := {}
var _progress_on := false
var _fighter := {}   # S382 MOVETIP1: with her, each card opens the hover card (MoveTip)
var _next_on := true   # S397: Escapes has no "Next on the pads" line (combinations are not escapes)


static func make(groups: Array, words: Dictionary, mastery: Dictionary, on_pick: Callable, combos := {}, progress := false,
		fighter := {}, next_line := true) -> Control:
	var b := new()
	b._next_on = next_line
	b.name = "MoveBook"
	b._combos = combos
	b._fighter = fighter
	b._progress_on = progress
	b.add_theme_constant_override("separation", 18)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.picked.connect(on_pick)
	if progress:
		b.add_child(b._book_head(groups, mastery))
	for g in groups:
		b._group(str(g[0]), str(g[1]), g[2], words, mastery)
	return b


## How far a move has come: [tier, 0..1]. A step or a defence is footwork: ready the day she can stand.
func _progress(m: Dictionary, mastery: Dictionary) -> Array:
	if str(m["kind"]) == "forced":
		return ["", 0.0]
	if SM.grey_reason(m, mastery) != "":
		return ["LOCKED", 0.0]
	if str(m["kind"]) != "combo":
		return ["READY", 1.0]
	var v := float(_combos.get(str(m["combo"]), 0.0))
	return [MoveMastery.tier(v) if v > 0.0 else "RAW", clampf(v / 100.0, 0.0, 1.0)]


## "18 of 26 ready" across the book, and the next combination worth her pad time.
func _book_head(groups: Array, mastery: Dictionary) -> Control:
	var ready := 0
	var total := 0
	for g in groups:
		for id in g[2]:
			var m := SM.move(str(id))
			if m.is_empty() or str(m["kind"]) == "forced":
				continue
			total += 1
			ready += int(_is_ready(m, mastery))
	var h := UI.hbox(14)
	h.name = "BookHead"
	h.add_child(UI.label("%d of %d moves ready" % [ready, total], 22, UI.FG, "bold"))
	h.add_child(Icons.pips(ready, total, "Ready: thrown with its pad time behind it."))
	var next := ""   # S397 blind round 5: "worth pad time next" disagreed with the Week's pads; the Week owns what is drilled
	if next != "":
		var nm := ""
		for m in SM.MOVES:
			if str(m["combo"]) == next:
				nm = str(m["name"])
				break
		h.add_child(UI.label("Worth pad time next: %s" % nm, UI.SMALL, UI.GOLD, "semi"))
	return h


func _ready_tier(t: String) -> bool:
	return t == "READY" or t == "USABLE" or t == "SHARP" or t == "SIGNATURE"


func _is_ready(m: Dictionary, mastery: Dictionary) -> bool:
	return _ready_tier(str(_progress(m, mastery)[0]))


func _group(title: String, line: String, ids: Array, words: Dictionary, mastery: Dictionary) -> void:
	var head := UI.vbox(2)
	var top := UI.hbox(10)
	top.add_child(UI.caps(title))
	if _progress_on:
		var n := 0
		var of := 0
		for id in ids:
			var m := SM.move(str(id))
			if m.is_empty() or str(m["kind"]) == "forced":
				continue
			of += 1
			n += int(_is_ready(m, mastery))
		top.add_child(UI.label("%d / %d ready" % [n, of], UI.TINY, UI.GREEN if n == of else UI.MUTED, "bold"))
	head.add_child(top)
	head.add_child(UI.muted(line, UI.SMALL, true))
	add_child(head)
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 10)
	flow.add_theme_constant_override("v_separation", 10)
	add_child(flow)
	for id in ids:
		var m := SM.move(str(id))
		if m.is_empty():
			continue
		var why := SM.grey_reason(m, mastery)
		var forced := str(m["kind"]) == "forced"
		var small := str(words.get(str(id), "")) + ("" if why == "" or forced else "\n" + why)
		# A forced move (the referee's break) still plays: it shows what is done to her.
		var card := UI.button2(str(m["name"]), small, "Choice", func(): select(str(id)), Vector2(CARD_W, CARD_H),
			UI.FG if why == "" or forced else UI.MUTED, UI.MUTED, false, UI.BODY, UI.SMALL)
		card.name = "Move_" + str(id).replace(" ", "_").replace("@", "_at_")
		card.tooltip_text = ""
		_wrap(card)
		if not _fighter.is_empty():
			MoveTip.attach(card, str(id), _fighter)
		if _progress_on:
			_mark(card, _progress(m, mastery))
		_cards[str(id)] = card
		flow.add_child(card)


## S360 (still: "a fence against a pr" cut at the card's edge): the card's small line wraps inside the card.
func _wrap(card: Button) -> void:
	var labels := card.find_children("*", "Label", true, false)
	for i in range(1, labels.size()):
		var l := labels[i] as Label
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size = Vector2(CARD_W - 40, 0)


## The tier word top right and the pad-time bar along the card's foot.
func _mark(card: Button, p: Array) -> void:
	var t := str(p[0])
	if t == "":
		return
	var col: Color = TIER_COLOR.get(t, UI.GREEN if t == "READY" else UI.MUTED)
	var tag := UI.label(t, UI.TINY - 2, col, "bold")
	tag.name = "Tier"
	tag.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	tag.offset_left = -96
	tag.offset_right = -10
	tag.offset_top = 6
	tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(tag)
	if t == "READY" or t == "LOCKED":
		return
	var bar := ColorRect.new()
	bar.name = "Bar"
	bar.color = col
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.anchor_left = 0.0
	bar.anchor_top = 1.0
	bar.anchor_bottom = 1.0
	bar.anchor_right = maxf(0.04, float(p[1]))
	bar.offset_left = 4
	bar.offset_top = -6
	bar.offset_bottom = -2
	card.add_child(bar)


## Plays the move and marks its card.
func select(id: String) -> void:
	for k in _cards:
		(_cards[k] as Button).theme_type_variation = "ChoiceOn" if k == id else "Choice"
	picked.emit(id)
