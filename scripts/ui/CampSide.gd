extends RefCounted
## S379 CAMPCARDS: the FIGHT CAMP modal's left column - the fighter: face, first name and record, weight class and mood, the
## six stats with the camp's stat outlined and its fight-night forecast, fatigue now and where the camp peaks (the
## overreach line at WeekPlan.OVERREACHED), the weight against the limit and the weigh-in forecast. Numbers count on from
## what the last draw showed (`before`, Camp.gd).
##   make(f, focus, fc, before) -> PanelContainer "CampSide"   (fc = CampForecast.run for the chosen focus)

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const HomeBoard := preload("res://scripts/ui/HomeBoard.gd")
const FighterCard := preload("res://scripts/ui/FighterCard.gd")
const FighterTile := preload("res://scripts/ui/FighterTile.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

const W := 330.0
const FACE := Vector2(298, 300)   # S380 bigger: the promo shot (tools/bake_promo.gd) head to folded arms
const FACE_Y := 0.0   # where the crop sits down the face shot: from its top (the head, the arms below)
const STATS := ["conditioning", "power", "technique", "defense", "speed", "chin"]
const PAPER := Color("#fbfaf7")
const INK2 := Color("#374151")


static func make(f: Dictionary, focus: String, fc: Dictionary, before: Dictionary) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "CampSide"
	p.custom_minimum_size = Vector2(W, 0)
	p.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	p.add_theme_stylebox_override("panel", UI.box(PAPER, UI.LINE, 12, 1, 16, 16))
	var v := UI.vbox(3)
	p.add_child(v)
	v.add_child(_face(f))
	var name := UI.label("%s %s" % [f["first"], FighterCard.record(f)], 30, UI.FG, "marker", true)
	name.name = "Who"
	v.add_child(name)
	v.add_child(UI.label("%s - %s" % [f["wc"], FighterTile.mood_word(f).to_lower()], 21, INK2, "hand", true))
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 4)
	v.add_child(gap)
	var shown: Dictionary = before.get("cards", {})
	for k in STATS:
		var now := float(f["stats"].get(k, 0.0))
		var end := float((fc["stats"] as Dictionary).get(k, now))
		v.add_child(_stat(k, now, end if k == focus else -1.0, float(shown.get(k, now))))
	v.add_child(_fatigue(fc, before))
	v.add_child(_weight(f, fc, before))
	return p


## The face shot cropped to the frame (HomeBoard's portrait; a render of the model when there is no shot).
static func _face(f: Dictionary) -> TextureRect:
	var r := TextureRect.new()
	r.name = "Face"
	r.custom_minimum_size = FACE
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex := HomeBoard.portrait(f)
	if tex != null and not tex is AtlasTexture:
		var s := tex.get_size()
		var h := minf(s.y, s.x * FACE.y / FACE.x)
		var a := AtlasTexture.new()
		a.atlas = tex
		a.region = Rect2(0.0, (s.y - h) * FACE_Y, s.x, h)
		tex = a
	r.texture = tex
	return r


## One stat row; the camp's stat (end >= 0) outlined in blue with "now -> fight night" in green.
static func _stat(k: String, now: float, end: float, from: float) -> PanelContainer:
	var on := end >= 0.0
	var row := PanelContainer.new()
	row.name = "Stat_" + k
	row.add_theme_stylebox_override("panel", UI.box(CampCard.BLUE_SOFT if on else Color(0, 0, 0, 0),
		UI.GOLD if on else Color(0, 0, 0, 0), 6, 2, 8, 3))
	var h := UI.hbox(6)
	row.add_child(h)
	h.add_child(UI.label(str(Data.LABEL.get(k, k)), 18, UI.FG, "body"))
	h.add_child(UI.spacer())
	if on:
		h.add_child(UI.label("%.1f" % now, 19, UI.FG, "bold"))
		var fc := UI.label("", 19, UI.GREEN, "bold")
		fc.name = "Forecast"
		CampCard.count(fc, from, end, func(x: float) -> String: return "-> %.1f" % x)
		h.add_child(fc)
	else:
		h.add_child(UI.label(str(int(floorf(now))), 19, UI.FG, "bold"))
	return row


## Fatigue now and the camp's peak on a pip meter with the overreach line marked; the band word pulses when it changes.
static func _fatigue(fc: Dictionary, before: Dictionary) -> VBoxContainer:
	var box := UI.vbox(4)
	box.name = "Fatigue"
	var now := float(fc["fatigue_now"])
	var peak := float(fc["peak"])
	var wn: Array = WB.fatigue_word(now, false)
	var wp: Array = WB.fatigue_word(peak, false)
	var t := UI.label("", 16, INK2, "body", true)
	t.name = "FatigueLine"
	CampCard.count(t, float(before.get("peak", now)), peak, func(x: float) -> String:
		var st := float(fc.get("stale", 0.0))   # S380 heavy legs (BoutRules.stale_energy)
		return "Fatigue now: %s (%d) - this camp peaks near %d, fight night %d%s" % [str(wn[0]).to_lower(), int(round(now)),
			int(round(x)), int(round(float(fc["fatigue_end"]))), (" - heavy legs: -%d energy at the first bell" % int(round(st))) if st > 0.0 else ""])
	box.add_child(t)
	var line := UI.hbox(10)
	var bar := UI.meter(peak / 100.0, wp[2], [WeekPlan.OVERREACHED / 100.0], 200.0)
	bar.name = "FatigueBar"
	var from := float(before.get("peak", now)) / 100.0
	bar.frac = from
	bar.ready.connect(func() -> void:
		bar.create_tween().tween_property(bar, "frac", peak / 100.0, CampCard.TWEEN_S).set_ease(Tween.EASE_OUT), CONNECT_ONE_SHOT)
	line.add_child(bar)
	var word := UI.label(str(wp[0]), 14, wp[2], "caps")
	word.name = "PeakWord"
	word.tooltip_text = str(wp[1])
	word.mouse_filter = Control.MOUSE_FILTER_PASS
	line.add_child(word)
	box.add_child(line)
	if before.has("band") and str(before["band"]) != str(wp[0]):
		CampCard.pulse(word)
	return box


## The scale today against the limit, and the weigh-in morning's forecast for this camp (the cut runs while over).
static func _weight(f: Dictionary, fc: Dictionary, before: Dictionary) -> VBoxContainer:
	var box := UI.vbox(0)
	box.name = "Weight"
	var w := float(f["weight"])
	var lim := float(fc["limit"])
	var over := w - lim
	box.add_child(UI.label("%.1f kg / limit %.1f - %s" % [w, lim, "%.1f over" % over if over > 0.05 else "on weight"], 19,
		UI.AMBER if over > 0.05 else UI.GREEN, "hand", true))
	var kg := float(fc["kg"])
	var ok := bool(fc["weigh_ok"])
	var l := UI.label("", 17, UI.GREEN if ok else UI.RED, "hand", true)
	l.name = "WeighIn"
	CampCard.count(l, float(before.get("kg", w)), kg, func(x: float) -> String:
		return "weigh-in forecast %.1f kg - %s" % [x, "makes it" if ok else "%.1f over" % (kg - lim)])
	box.add_child(l)
	return box
