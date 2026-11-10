extends HBoxContainer
## S382 G4 (gym idea 1, without Peak): the fight-night gauge row - three small ink dials in one row, one word each: LEGS
## (fatigue on the night), SCALE (the class window as a band, the needle the weigh-in forecast, a ghost tick for today), RISK
## (three pips cut / hand / head; her injury's pip solid red with the days left). The rules and bands are Gauges.gd; the
## numbers one CampForecast.run. Drawn in the camp modal's left column (CampSide) and the whiteboard's THIS CAMP column
## (WeekCamp); the numbers behind each dial are on its hover. A redraw moves each needle on from what the last draw showed,
## shows the change under the dial for a moment and pulses a word that changed band; preview() ghosts another forecast.
## S382 G5 (gym idea 2, hover ghosts): preview() is the hover of a camp card or a whiteboard morning - a pencil ghost needle
## sweeps from the needle to the dry run's number and a green / red +N / -N counts up under each dial, both in GHOST_S
## (animated meters); "same" when the pick moves nothing. The click commits (the redraw's own change under the dial).
##   GaugeRow.make(d, before, w) -> GaugeRow "Gauges"   d = GaugeRow.read(fc, f, day)   values() -> `before` for the next draw
##   preview(d2) / preview_off()   deltas: {legs|scale|risk: Label}   ghost_delta(id, was, to) -> {text, colour}

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Data := preload("res://scripts/state/Data.gd")
const Gauges := preload("res://scripts/rules/Gauges.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")

const DIAL_H := 58.0
const PULSE_S := 2.0
const IDS := ["legs", "scale", "risk"]
const TITLES := {"legs": "LEGS", "scale": "SCALE", "risk": "RISK"}
## How far a number moves before the dial shows the change.
const MOVED := {"legs": 0.5, "scale": 0.05, "risk": 0.005}
## S382 G5: how long a hover ghost takes to sweep in (the design's ~0.15 s).
const GHOST_S := 0.15

var deltas := {}
var _d: Dictionary = {}
var _dials := {}
var _tw := {}   # id -> the Tween on its delta label (the commit's flash, or a hover ghost's count)


static func read(fc: Dictionary, f: Dictionary, day: int) -> Dictionary:
	var d := Gauges.read(fc, f, day, limits_for(f))
	d["bout_day"] = int((f.get("bout", {}) as Dictionary).get("day", day))
	return d


## The class limits of the fighter's own sex (the window's floor is the next one down).
static func limits_for(f: Dictionary) -> Array:
	var out: Array = []
	for k in Data.DIVISIONS:
		if str(Data.DIVISIONS[k]["sex"]) == str(f.get("sex", "f")):
			out.append(float(Data.DIVISIONS[k]["limit"]))
	return out


static func band_colour(band: String) -> Color:
	return UI.GREEN if band == Gauges.GREEN else (UI.AMBER if band == Gauges.AMBER else WB.RED)


static func make(d: Dictionary, before: Dictionary, w: float) -> HBoxContainer:
	var r := new()
	r.name = "Gauges"
	r.add_theme_constant_override("separation", 8)
	r.custom_minimum_size = Vector2(w, 0)
	r._d = d
	var cw := floorf((w - 16.0) / 3.0)
	for id in IDS:
		r.add_child(r._column(id, cw, before))
	return r


## The numbers this draw shows (the next draw's `before`).
func values() -> Dictionary:
	return {"legs": float(_d["legs"]), "scale": float(_d["kg"]), "risk": float(_d["injury"]),
		"legs_band": str(_d["legs_band"]["band"]), "scale_band": str(_d["scale_band"]["band"]), "risk_band": str(_d["pips"])}


func _value(d: Dictionary, id: String) -> float:
	return float(d["legs"]) if id == "legs" else (float(d["kg"]) if id == "scale" else float(d["injury"]))


func _word(d: Dictionary, id: String) -> Array:
	if id == "legs":
		return [str(d["legs_band"]["word"]), band_colour(str(d["legs_band"]["band"])), str(d["legs_band"]["band"])]
	if id == "scale":
		return [str(d["scale_band"]["word"]), band_colour(str(d["scale_band"]["band"])), str(d["scale_band"]["band"])]
	if str(d["out"]) != "":
		return ["out %d d" % int(d["out_days"]), WB.RED, "out"]
	var n := int(d["pips"])
	return ["%d%%" % int(round(float(d["injury"]) * 100.0)), UI.GREEN if n == 1 else (UI.AMBER if n == 2 else WB.RED), str(n)]


func _column(id: String, cw: float, before: Dictionary) -> VBoxContainer:
	var col := UI.vbox(0)
	col.name = "Gauge_" + id
	col.custom_minimum_size = Vector2(cw, 0)
	col.tooltip_text = _tip(id)
	col.mouse_filter = Control.MOUSE_FILTER_PASS
	var t := UI.label(str(TITLES[id]), 13, UI.MUTED, "caps")
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(t)
	var dial := Dial.new()
	dial.name = "Dial"
	dial.custom_minimum_size = Vector2(cw, DIAL_H)
	dial.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_setup(dial, id)
	col.add_child(dial)
	_dials[id] = dial
	var wd: Array = _word(_d, id)
	var word := UI.label(str(wd[0]), 17, wd[1], "handbold")
	word.name = "Word_" + id
	word.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	word.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(word)
	var dl := UI.label("", 14, WB.PENCIL, "handbold")
	dl.name = "Delta_" + id
	dl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(dl)
	deltas[id] = dl
	var to := _value(_d, id)
	if before.has(id):
		var was := float(before[id])
		if id != "risk":
			dial.v = was
			dial.ready.connect(func() -> void:
				dial.create_tween().tween_property(dial, "v", to, CampCard.TWEEN_S).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT),
				CONNECT_ONE_SHOT)
		if absf(to - was) >= float(MOVED[id]):
			_flash(dl, id, was, to)
		if str(before.get(id + "_band", wd[2])) != str(wd[2]):
			CampCard.pulse(word)
	return col


func _setup(dial: Dial, id: String) -> void:
	dial.kind = "pips" if id == "risk" else "arc"
	if id == "legs":
		dial.lo = 0.0
		dial.hi = 100.0
		dial.zones = [[0.0, Gauges.LEGS_HEAVY, UI.GREEN], [Gauges.LEGS_HEAVY, Gauges.LEGS_OVER, UI.AMBER], [Gauges.LEGS_OVER, 100.0, WB.RED]]
		dial.today = float(_d["legs_now"])
		dial.v = float(_d["legs"])
	elif id == "scale":
		var lim := float(_d["limit"])
		var fl := float(_d["floor"])
		dial.lo = minf(fl - 0.5, minf(float(_d["kg"]), float(_d["kg_now"])) - 0.2)
		dial.hi = maxf(lim + 1.5, maxf(float(_d["kg"]), float(_d["kg_now"])) + 0.2)
		dial.zones = [[fl, lim + Gauges.SCALE_OK, UI.GREEN], [lim + Gauges.SCALE_OK, lim + Gauges.SCALE_NEAR, UI.AMBER],
			[lim + Gauges.SCALE_NEAR, dial.hi, WB.RED]]
		dial.today = float(_d["kg_now"])
		dial.v = float(_d["kg"])
	else:
		dial.lit = int(_d["pips"])
		dial.out = str(_d["out"])
		dial.out_days = int(_d["out_days"])


## Better = lower for all three (fatigue, kilos, injury chance).
static func _delta_text(id: String, x: float) -> String:
	return "%d" % int(round(x)) if id == "legs" else ("%.1f kg" % x if id == "scale" else "%d%%" % int(round(x * 100.0)))


func _flash(dl: Label, id: String, was: float, to: float) -> void:
	dl.text = ("+" if to > was else "-") + _delta_text(id, absf(to - was))
	dl.add_theme_color_override("font_color", UI.GREEN if to < was else WB.RED)
	dl.ready.connect(func() -> void:
		var tw := dl.create_tween()
		_tw[id] = tw
		tw.tween_interval(PULSE_S)
		tw.tween_property(dl, "modulate:a", 0.0, 0.3)
		tw.tween_callback(func() -> void:
			dl.text = ""
			dl.modulate.a = 1.0), CONNECT_ONE_SHOT)


## S382 G5: what a hover shows under a dial - "+N" / "-N" from the needle to the dry run, green when lower (all three are
## better lower: fatigue, kilos, injury chance), red when higher; "same" in pencil under the dial's MOVED.
static func ghost_delta(id: String, was: float, to: float) -> Dictionary:
	if absf(to - was) < float(MOVED[id]):
		return {"text": "same", "colour": WB.PENCIL}
	return {"text": ("+" if to > was else "-") + _delta_text(id, absf(to - was)), "colour": UI.GREEN if to < was else WB.RED}


## Another forecast ghosted on the dials (a camp card, a whiteboard morning or a twist answer under the cursor): the pencil
## ghost needle sweeps there from where it is (the needle when none shows) and "+N" / "-N" counts up from 0, in GHOST_S.
func preview(d2: Dictionary) -> void:
	for id in IDS:
		var was := _value(_d, id)
		var to := _value(d2, id)
		var gd := ghost_delta(id, was, to)
		var dl: Label = deltas[id]
		_stop(id)
		dl.add_theme_color_override("font_color", gd["colour"])
		var dial: Dial = _dials[id]
		dial.ghost_col = gd["colour"]   # the ghost needle in the change's colour: it reads at a glance beside the ink needle
		if id == "risk":
			dial.ghost_lit = int(d2["pips"])
			dial.queue_redraw()
		else:
			var from := dial.v if is_nan(dial.ghost) else dial.ghost
			dial.ghost = from
			if dl.is_inside_tree():
				_tw["g_" + id] = dial.create_tween()
				(_tw["g_" + id] as Tween).tween_property(dial, "ghost", to, GHOST_S).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			else:
				dial.ghost = to
		dl.text = str(gd["text"])
		if str(gd["text"]) == "same" or not dl.is_inside_tree():
			dl.modulate.a = 1.0
			continue
		var sg := str(gd["text"]).left(1)
		var amount := absf(to - was)
		dl.text = sg + _delta_text(id, 0.0)
		dl.modulate.a = 0.0
		var tw := dl.create_tween().set_parallel()
		tw.tween_property(dl, "modulate:a", 1.0, GHOST_S)
		tw.tween_method(func(x: float) -> void: dl.text = sg + _delta_text(id, x), 0.0, amount, GHOST_S) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		_tw[id] = tw


func preview_off() -> void:
	for id in IDS:
		_stop(id)
		var dl: Label = deltas[id]
		dl.text = ""
		dl.modulate.a = 1.0
		var dial: Dial = _dials[id]
		dial.ghost = NAN
		dial.ghost_lit = 0
		dial.queue_redraw()


## Ends the delta label's running tween (a commit's flash must not wipe a hover's number two seconds later) and the ghost
## needle's (a sweep still running would draw the ghost back after the cursor left).
func _stop(id: String) -> void:
	for k in [id, "g_" + id]:
		var tw: Tween = _tw.get(k)
		if tw != null and tw.is_valid():
			tw.kill()
		_tw.erase(k)


func _tip(id: String) -> String:
	if id == "legs":
		return "Fight night fatigue %d of 100 (%s) - today %d, the camp peaks near %d. Over %d costs energy at the first bell (-%d now); %d+ is overreached." % [
			int(round(float(_d["legs"]))), str(_d["legs_band"]["word"]), int(round(float(_d["legs_now"]))), int(round(float(_d["peak"]))),
			int(Gauges.LEGS_HEAVY), int(round(float(_d["stale"]))), int(Gauges.LEGS_OVER)]
	if id == "scale":
		return "Weigh-in forecast %.1f kg against the agreed %.1f kg (the class window %.1f-%.1f) - today %.1f kg. Weigh-in %s, 1 h before; diet only." % [
			float(_d["kg"]), float(_d["limit"]), float(_d["floor"]), float(_d["limit"]), float(_d["kg_now"]), Clock.fmt(int(_d["bout_day"]))]
	if str(_d["out"]) != "":
		return "Injured (%s): %d days left." % [str(_d["out"]), int(_d["out_days"])]
	return "Camp injury risk %d%% (cut, hand, head) - the training weeks to fight night. 1 pip under %d%%, 2 to %d%%, 3 from %d%%." % [
		int(round(float(_d["injury"]) * 100.0)), int(Gauges.RISK_TWO * 100.0), int(Gauges.RISK_THREE * 100.0), int(Gauges.RISK_THREE * 100.0)]


## One ink dial: "arc" = a half-circle with coloured zones, the needle, a pencil tick for today and the hover's ghost needle
## (S382 G5: green / red as its change, pencil when the same);
## "pips" = three circles cut / hand / head, `lit` filled, her injury's pip solid red with the days left.
class Dial extends Control:
	var kind := "arc"
	var lo := 0.0
	var hi := 100.0
	var zones: Array = []
	var today := NAN
	var ghost := NAN:
		set(x):
			ghost = x
			queue_redraw()
	var lit := 1
	var ghost_lit := 0
	var ghost_col := WB.PENCIL
	var out := ""
	var out_days := 0
	var v := 0.0:
		set(x):
			v = x
			queue_redraw()

	## S419: chalk on the slate, the navy marker on a light board (the needle was dark on dark).
	func _ink() -> Color:
		return WoodKit.INK if WoodKit.on_dark(self) else WB.INK

	func _ang(x: float) -> float:
		return PI + PI * clampf((x - lo) / maxf(0.001, hi - lo), 0.0, 1.0)

	func _draw() -> void:
		if kind == "pips":
			_pips()
			return
		var r := minf(size.x * 0.5 - 8.0, size.y - 14.0)
		var c := Vector2(size.x * 0.5, size.y - 6.0)
		draw_arc(c, r + 5.0, PI, TAU, 40, Color(_ink(), 0.55), 1.5, true)
		for z in zones:
			if float(z[1]) > float(z[0]):
				draw_arc(c, r, _ang(float(z[0])), _ang(float(z[1])), 20, Color(z[2], 0.75), 6.0, true)
		if not is_nan(today):
			var a := Vector2.from_angle(_ang(today))
			draw_line(c + a * (r - 9.0), c + a * (r + 8.0), WB.PENCIL, 2.0, true)
		if not is_nan(ghost):
			draw_line(c, c + Vector2.from_angle(_ang(ghost)) * (r - 3.0), Color(ghost_col, 0.85), 3.0, true)
		draw_line(c, c + Vector2.from_angle(_ang(v)) * (r - 3.0), _ink(), 3.0, true)
		draw_circle(c, 4.0, _ink())

	func _pips() -> void:
		var font := UI.font("bold")
		var gap := minf(size.x * 0.34, 46.0)   # the three words fit under a 94-px column (the camp modal)
		var rad := minf(13.0, gap * 0.36)
		var col := UI.GREEN if lit == 1 else (UI.AMBER if lit == 2 else WB.RED)
		for i in 3:
			var p := Vector2(size.x * 0.5 + (i - 1) * gap, rad + 6.0)
			var slot := str(Gauges.SLOTS[i])
			if slot == out:
				draw_circle(p, rad, WB.RED)
				var s := str(out_days)
				var sw := font.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x
				draw_string(font, p + Vector2(-sw * 0.5, 4.5), s, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color.WHITE)
			elif i < lit and out == "":
				draw_circle(p, rad, col)
			else:
				draw_arc(p, rad, 0.0, TAU, 24, Color(_ink(), 0.6), 1.5, true)
			if ghost_lit > 0 and out == "" and (i < ghost_lit) != (i < lit):
				draw_arc(p, rad + 3.0, 0.0, TAU, 24, ghost_col, 2.0, true)
			var tw := font.get_string_size(slot.to_upper(), HORIZONTAL_ALIGNMENT_LEFT, -1, 11).x
			draw_string(font, Vector2(p.x - tw * 0.5, p.y + rad + 15.0), slot.to_upper(), HORIZONTAL_ALIGNMENT_LEFT, -1, 11, _ink())
