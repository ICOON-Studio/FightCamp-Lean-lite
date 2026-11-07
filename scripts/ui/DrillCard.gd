extends Button
## S382 DRILLCARD1 (TRAINING_SCREEN_S381.md sections 3-5, the approved mockup): one drill card in the Training tab's tray -
## a move or a combination she is working on. Its ink picture, a tag (NEW MOVE / COMBO / OWN COMBO), the short name and its
## punches, mastery now -> the end of this week, a bar 0-100 with ticks at 30 / 60 / 85 and a hatched wall at her cap, and
## one line from PadEdit.eta ("usable Wed", "sharp in 3 weeks", "spar nights only: +3.1 a week"). A punch holding it under
## its next tier is a red chip with "+ drill it". A card that crosses 30 / 60 / 85 on a night this week shows its gold face
## (the tier word, the night that does it). Every number comes from PadWeek.project, the function the week runs.
## Drag it onto a PADS night, or click it then click the night (click-click); the night takes the drop (WeekDay.PmCard).
##   DrillCard.make(f, card, proj, picked, on_pick, on_drill_it) -> DrillCard "Drill_<card>"   payload() -> {drill: card}
##   DrillCard.picture(f, card) -> Texture2D   DrillCard.station(f, station) -> Texture2D (her body at that station)

const UI := preload("res://scripts/ui/UI.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const CARD_H := 206.0
const PIC := 112.0
const TWEEN_S := 0.45
const GOLD_BG := Color("#fde58a")
const GOLD_EDGE := Color("#e2a50c")
const GOLD_INK := Color("#6b4a00")
const SLATE := Color("#4b5563")
const TRACK := Color("#e5e9ee")
const HATCH := Color("#b7bec7")
const SOFT_RED := Color("#fde4e2")
const MOVES := "res://assets/ui/moves/"
const STATIONS := "res://assets/ui/training/"
const FALLBACK := "mh_boxer_10"
## Move pictures by Data.MOVES name (assets/ui/moves, MOVEPICS1); a card without one shows her on the pads.
const MOVE_PIC := {"Uppercut": "rear_uppercut", "Check hook": "lead_hook"}

## "fid|card id" -> the end-of-week mastery the bar showed last (the bar tweens on from it: animated meters). Per fighter:
## two fighters drilling the same move never tween from each other's number.
static var _seen := {}

var card := ""


static func make(f: Dictionary, card_id: String, proj: Dictionary, picked: bool, on_pick: Callable, on_drill_it: Callable) -> Button:
	var b := new()
	b.card = card_id
	b.name = "Drill_" + card_id.replace(":", "_").replace(" ", "_")
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.custom_minimum_size = Vector2(0, CARD_H)
	var m := PadWeek.mastery(f, card_id)
	var cross := PadEdit.crossing(f, card_id, proj)
	var gold := not cross.is_empty()
	for st in ["normal", "hover", "pressed", "disabled", "focus"]:
		var s := UI.box(GOLD_BG if gold else UI.PANEL, UI.GOLD if picked else (GOLD_EDGE if gold else (UI.MUTED if st == "hover" else UI.LINE)),
			10, 3 if picked else 2, 0, 0)
		b.add_theme_stylebox_override(st, s)
	b.tooltip_text = "Drag onto a PADS night, or click it and then the night."
	b.pressed.connect(func(): on_pick.call(card_id))
	var pad := MarginContainer.new()
	pad.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		pad.add_theme_constant_override("margin_" + side, 10)
	pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(pad)
	var v := UI.vbox(6)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pad.add_child(v)
	var end := m
	var rows: Dictionary = PadEdit.night_rows(f, {card_id: proj}).get(card_id, {})
	for dow in rows:
		end = maxf(end, float(rows[dow][1]))
	if gold:
		b._gold(v, f, card_id, cross, proj.get("pads", []))
	else:
		b._face(v, f, card_id, m, end, proj)
	var bar := TierBar.new()
	bar.name = "Bar"
	bar.now = m
	bar.cap = float(proj.get("cap", 100.0))
	bar.end = float(_seen.get(_key(f, card_id), end))
	_seen[_key(f, card_id)] = end
	v.add_child(bar)
	if not is_equal_approx(bar.end, end):
		var grow := func() -> void:
			bar.create_tween().tween_property(bar, "end", end, TWEEN_S).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		bar.ready.connect(grow, CONNECT_ONE_SHOT)
	if gold:
		return b
	var line: Dictionary = proj.get("eta", {})
	var eta := UI.label(str(line.get("text", "")), 16, UI.GREEN if str(line.get("tone", "")) == "good"
		else (UI.RED if str(line.get("tone", "")) == "bad" else UI.FG), "bold")
	eta.name = "Eta"
	eta.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(eta)
	var held: Array = proj.get("held_by", [])
	if not held.is_empty():
		var chip := PanelContainer.new()
		chip.name = "Held"
		chip.add_theme_stylebox_override("panel", UI.box(SOFT_RED, Color(UI.RED, 0.5), 6, 1, 8, 3))
		chip.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		var h := UI.hbox(8)
		chip.add_child(h)
		h.add_child(UI.label("held back by the %s" % str(held[0]).to_lower(), 15, UI.RED, "semi"))   # S397: no raw number
		var go := UI.button("+ drill it", "BtnSolid", func(): on_drill_it.call("move:" + str(held[0])))
		go.name = "DrillIt"
		go.focus_mode = Control.FOCUS_NONE
		for st in ["normal", "hover", "pressed"]:
			go.add_theme_stylebox_override(st, UI.box(UI.RED if st == "normal" else UI.RED.darkened(0.15), Color(0, 0, 0, 0), 5, 0, 7, 1))
		go.add_theme_color_override("font_color", Color.WHITE)
		go.add_theme_font_size_override("font_size", 13)
		go.tooltip_text = "Puts the %s on the next pad night you have not set" % str(held[0]).to_lower()
		h.add_child(go)
		v.add_child(chip)
	elif float(proj.get("sig_needs_t", 0.0)) > 0.0 and not str(line.get("text", "")).begins_with("signature"):
		# Her cap is under the signature line: what it takes (the hatched wall on the bar).
		var sig := UI.label("signature needs Technique %d" % ceili(float(proj["sig_needs_t"])), 14, UI.MUTED, "semi")
		sig.name = "SigNeeds"
		v.add_child(sig)
	return b


## The face: picture, tag, name and punches, mastery now -> the end of this week. A plan card (PlanCards.dress) brings its
## own tag (R1 OPENER / ANSWER / GO-TO / PLAN), its line ("answer: lunges in behind the jab") and the red UNDRILLED stamp.
func _face(v: VBoxContainer, f: Dictionary, card_id: String, m: float, end: float, proj := {}) -> void:
	var top := UI.hbox(12)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(top)
	var pic := TextureRect.new()
	pic.name = "Pic"
	pic.custom_minimum_size = Vector2(PIC, PIC)
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	pic.texture = picture(f, card_id)
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top.add_child(pic)
	if str(proj.get("stamp", "")) != "":
		pic.add_child(_stamp(str(proj["stamp"])))
	var words := UI.vbox(1)
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	words.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top.add_child(words)
	var tag := PanelContainer.new()
	tag.add_theme_stylebox_override("panel", UI.box(Color("#e8efff"), Color(0, 0, 0, 0), 4, 0, 6, 1))
	tag.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tw := UI.label(str(proj.get("tag", PadEdit.kind_word(f, card_id))), 12, UI.GOLD, "bold")
	tw.name = "Tag"
	tag.add_child(tw)
	words.add_child(tag)
	var t := UI.label(PadEdit.title(f, card_id), 26, UI.FG, "bold")   # S397: names in the plain face ("1-1" read ")-)")
	t.name = "Title"
	t.clip_text = true
	words.add_child(t)
	var s := UI.label(str(proj.get("sub", PadEdit.sub(f, card_id))), 15, UI.MUTED, "body")
	s.name = "Sub"
	s.clip_text = true
	s.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS   # "answer: hands drop la..." - never a letter cut in half
	s.tooltip_text = s.text
	words.add_child(s)
	# S397 blind round 3 ("24.9 -> 27.7"): the tier in words on the card, the pad level on hover.
	tooltip_text = "Pad level %.1f now, %.1f by Sunday.\n%s" % [m, end, tooltip_text]
	var nums := UI.hbox(6)
	nums.add_child(UI.label(MoveMastery.tier(m).capitalize() if m > 0.0 else "New", 22, UI.FG, "bold"))
	if end > m + 0.05:
		var up := MoveMastery.tier(end) != MoveMastery.tier(m)
		var to := UI.label("-> " + MoveMastery.tier(end).capitalize() if up else "climbing", 22 if up else 18, UI.GREEN, "bold")
		to.name = "End"
		nums.add_child(to)
	words.add_child(nums)
	for n in [t, s, nums]:
		(n as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE


## The gold face: the tier it reaches this week, the card, the night that does it.
func _gold(v: VBoxContainer, f: Dictionary, card_id: String, cross: Dictionary, proj_pads: Array) -> void:
	var top := UI.hbox(8)
	top.name = "Gold"
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# S397 blind Week critic ("USABLE is louder than the move"): the move leads, the tier is its badge.
	var name_row := UI.hbox(10)
	name_row.add_child(UI.label(PadEdit.title(f, card_id), 34, UI.FG, "bold"))
	var s := UI.label("" if PadWeek.kind(card_id) == "move" else PadEdit.sub(f, card_id), 16, UI.FG, "body")   # a move's old tier is moot here
	s.size_flags_vertical = Control.SIZE_SHRINK_END
	name_row.add_child(s)
	v.add_child(name_row)
	top.add_child(UI.label("★ %s" % str(cross["tier"]).to_upper(), 18, GOLD_INK, "bold"))
	v.add_child(top)
	var station := "pads" if (proj_pads as Array).has(int(cross["dow"])) else "sparring"
	var when := UI.label("%s %s takes it there" % [PadEdit.DAY_WORDS[int(cross["dow"])], station], 20, UI.FG, "bold")
	tooltip_text = "Pad level %.1f -> %.1f.
%s" % [float(cross["before"]), float(cross["after"]), tooltip_text]   # S397
	when.name = "When"
	v.add_child(when)
	for n in [name_row, s, when]:
		(n as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE


## The red rubber stamp across the picture's foot: "UNDRILLED x0.8" (a plan card not in her hands by fight night).
static func _stamp(words: String) -> PanelContainer:
	var st := PanelContainer.new()
	st.name = "Stamp"
	st.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.92), UI.RED, 3, 2, 5, 1))
	st.mouse_filter = Control.MOUSE_FILTER_IGNORE
	st.rotation_degrees = -8.0
	st.position = Vector2(4, PIC - 34)
	st.add_child(UI.label(words, 13, UI.RED, "bold"))
	return st


static func _key(f: Dictionary, card_id: String) -> String:
	return "%s|%s" % [str(f.get("id", "")), card_id]


## Drag it: the card id for the night's drop.
func payload() -> Dictionary:
	return {"drill": card}


func _get_drag_data(_at: Vector2) -> Variant:
	var tag := PanelContainer.new()
	tag.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD, 8, 3, 12, 6))
	tag.add_child(UI.label(PadEdit.title({}, card) if PadWeek.kind(card) != "own" else "combination", 22, UI.FG, "bold"))
	set_drag_preview(tag)
	return payload()


## The card's picture: the move's ink card (assets/ui/moves), else her body on the pads.
static func picture(f: Dictionary, card_id: String) -> Texture2D:
	var slug := ""
	match PadWeek.kind(card_id):
		"move":
			slug = str(MOVE_PIC.get(PadWeek.key(card_id), PadWeek.key(card_id).to_lower().replace(" ", "_")))
		"combo":
			slug = PadWeek.key(card_id).replace(" ", "_")
		"own":
			for step in OwnCombos.entry(f, card_id).get("chain", []):
				if not PadEdit.NUMBER.has(str(step)):
					slug = str(step)
					break
	if slug != "" and ResourceLoader.exists(MOVES + slug + ".png"):
		return load(MOVES + slug + ".png")
	return station(f, "pads")


## Her own body at a training station (tools/bake_session_pics.gd); another boxer's when hers is missing.
static func station(f: Dictionary, st: String) -> Texture2D:
	for s in [Faces.stem(f), FALLBACK]:
		var path := "%s%s_%s.png" % [STATIONS, s, st]
		if ResourceLoader.exists(path):
			return load(path)
	return null


## The mastery bar: 0-100, today's part slate, this week's gain green, ticks at 30 / 60 / 85 (85 gold), hatched past her cap.
class TierBar extends Control:
	var now := 0.0
	var cap := 100.0
	## The gold back's bar (FlipCard, S382 CARDFLIP1) draws in golds.
	var track := TRACK
	var fill := SLATE
	var gain := UI.GREEN
	var end := 0.0:
		set(value):
			end = value
			queue_redraw()

	func _init() -> void:
		custom_minimum_size = Vector2(0, 18)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var w := size.x
		var y := 4.0
		var h := 10.0
		draw_rect(Rect2(0, y, w, h), track)
		draw_rect(Rect2(0, y, w * clampf(now, 0.0, 100.0) / 100.0, h), fill)
		if end > now:
			draw_rect(Rect2(w * now / 100.0, y, w * (minf(end, 100.0) - now) / 100.0, h), gain)
		if cap < 100.0:
			var x0 := w * cap / 100.0
			draw_rect(Rect2(x0, y, w - x0, h), Color(track, 1.0))
			var x := x0
			while x < w:
				var x1 := minf(x + h, w)
				draw_line(Vector2(x, y + h), Vector2(x1, y + h - (x1 - x)), HATCH, 2.0)
				x += 7.0
		for t in [30.0, 60.0, 85.0]:
			var col := (GOLD_EDGE if cap >= 85.0 else HATCH) if t == 85.0 else UI.FG
			draw_line(Vector2(w * t / 100.0, 0), Vector2(w * t / 100.0, size.y), col, 2.0)
