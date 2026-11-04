extends RefCounted
## S379 CAMPCARDS: the FIGHT CAMP modal's left column - the fighter: face, first name and record, weight class and mood, the
## six stats with the camp's stat outlined and its fight-night forecast; S382 G4 the fight-night gauge row under them
## (GaugeRow: LEGS, SCALE, RISK - it replaced the fatigue sentence and its meter and the agreed-weight line). Numbers count
## on from what the last draw showed (`before`, Camp.gd; the dials' own numbers under before["gauges"]).
##   make(f, focus, fc, before, day) -> PanelContainer "CampSide"   (fc = CampForecast.run for the chosen focus)

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const HomeBoard := preload("res://scripts/ui/HomeBoard.gd")
const FighterCard := preload("res://scripts/ui/FighterCard.gd")
const FighterTile := preload("res://scripts/ui/FighterTile.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")
const GaugeRow := preload("res://scripts/ui/GaugeRow.gd")

const W := 330.0
const FACE := Vector2(298, 300)   # S380 bigger: the promo shot (tools/bake_promo.gd) head to folded arms
const FACE_Y := 0.0   # where the crop sits down the face shot: from its top (the head, the arms below)
const STATS := ["conditioning", "power", "technique", "defense", "speed", "chin"]
const PAPER := Color("#fbfaf7")
const INK2 := Color("#374151")


static func make(f: Dictionary, focus: String, fc: Dictionary, before: Dictionary, day: int) -> PanelContainer:
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
	var gap2 := Control.new()
	gap2.custom_minimum_size = Vector2(0, 8)
	v.add_child(gap2)
	v.add_child(GaugeRow.make(GaugeRow.read(fc, f, day), before.get("gauges", {}), W - 32.0))
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
