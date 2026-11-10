extends Control
## Live-round side panels. Left: our boxer. Right: the opponent, numbers the corner can see.
const TV := preload("res://scripts/ui/TV.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const FightMeters := preload("res://scripts/rules/FightMeters.gd")
const BodyLoad := preload("res://scripts/rules/BodyLoad.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const CornerTrust := preload("res://scripts/rules/CornerTrust.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const EnergyForecast := preload("res://scripts/rules/EnergyForecast.gd")
const Drawn := preload("res://scripts/fight3d/BodyPanels.gd")
const RED := Color("#e2483d")
const GREEN := Color("#5ac76a")
const BAND_RANK := {"doctor": 0, "critical": 1, "hurt": 2, "fine": 3}
const SHORT := {"head": "HEAD", "left_eye": "EYE", "right_eye": "EYE", "nose": "NOSE", "left_ribs": "RIBS", "right_ribs": "RIBS"}
const WIDE := 16.0
const NARROW := 6.0
var view: Control
var side := 0
var host: Node
var figure_pos := Vector2(8, 100)
var figure_size := Vector2(118, 240)
var _name: Label
var _chip: Label
var _tag: Label
var _energy: Label
var _legs: Label
var _guard: Label
var _tanks: Array = []
var _round_bg: Array = []
var _rounds: Array = []
var _pips: Array = []
var _ear: Drawn.Ear
var _habit_card: Panel
var _habit_n: Label
var _heard: Label
var _flash := 0.0
var _seen := -1
var shown_stamina := -1.0
static func attach(v: Control) -> Node:
	var host := Host.new()
	host.name = "SideHost"
	host.view = v
	v.add_child(host)
	for s in 2:
		var p := new()
		p.name = "SidePanel%d" % s
		p.view = v
		p.side = s
		p.host = host
		p._mount()
		v.add_child(p)
		host.panels.append(p)
	host.blocks = host.panels.duplicate()
	return host
static func worst_place(values: Dictionary) -> String:
	var best := ""
	var rank := 99
	var low := 101.0
	for p in BodyMap.PLACES:
		var v := float(values.get(p, 100.0))
		var r := int(BAND_RANK.get(BodyMap.band(v), 3))
		if best == "" or r < rank or (r == rank and v < low):
			best = str(p)
			rank = r
			low = v
	return best
static func tag_text(place: String, band: String) -> String:
	var word := str(SHORT.get(place, place.to_upper()))
	if word == "EYE" and band in ["critical", "doctor"]:
		return "EYE x"
	return word
## One line under the name. His boxer: the plan in game words, never "Plan: Own game".
static func own_line(lv: Dictionary) -> String:
	var id := str(lv.get("plan", ""))
	var label := str((Exchanges.CALLS.get(id, {}) as Dictionary).get("label", ""))
	if label != "":
		return label
	var aim := PaceAim.aim_word(str(lv.get("aim", "")))
	return aim if aim != "" else "Her own game"


## The opponent: her record, or the game her tape shows once it has been studied.
static func opp_line(opp: Dictionary, film: int) -> String:
	if film >= BoutRules.FILM_DEPTH_WITH_STUDY:
		var fav := Exchanges.favourite(str(opp.get("style", "")))
		return str((Exchanges.MODES.get(fav, {}) as Dictionary).get("label", "On tape"))
	var w := int(opp.get("w", 0))
	var l := int(opp.get("l", 0))
	var wins := "1 win" if w == 1 else "%d wins" % w
	var losses := "1 loss" if l == 1 else "%d losses" % l
	return "%s, %s" % [wins, losses]


static func energy_range(truth: float, scouted: bool) -> String:
	var half := (NARROW if scouted else WIDE) * 0.5
	var lo := int(round(clampf(truth - half, 0.0, 100.0)))
	var hi := int(round(clampf(truth + half, 0.0, 100.0)))
	return "%d-%d" % [lo, hi]
static func meter_src(v: Control, who_side: int, energy: float) -> Dictionary:
	var who := "a" if who_side == 0 else "b"
	var src := {"energy": energy, "energy_start": energy, "body_taken": 0, "guard_known": true, "heart_known": true}
	var main: Node = v.get("main")
	if main != null and who_side == 1:
		var opp: Dictionary = _opp(v)
		src["guard_known"] = FightMeters.guard_known(opp)
		src["heart_known"] = FightMeters.heart_known(opp)
	var live: Node = v.get("body")
	if live != null:
		var places := {}
		for p in BodyMap.PLACES:
			places[p] = BodyMap.value(live.map, who, p)
		src["places"] = places
	var burn: Node = v.get("burn")
	if burn != null:
		_burn_into(src, (burn.get("_shown") as Array)[who_side])
	return src
static func _burn_into(src: Dictionary, shown: Dictionary) -> void:
	var parts := {}
	for part in BodyLoad.PARTS:
		parts[part] = float(shown.get("b_" + part, 0.0))
	src["burn"] = parts
	src["drop"] = {"lead": float(shown.get("lead", 0.0)), "rear": float(shown.get("rear", 0.0))}
static func _opp(v: Control) -> Dictionary:
	var main: Node = v.get("main")
	if main == null:
		return {}
	var f: Dictionary = main.career.fighter_by_id(str(v.get("fid")))
	return (f.get("bout", {}) as Dictionary).get("opp", {})
func _mount() -> void:
	if side == 1:
		figure_pos = Vector2(270, 100)
		figure_size = Vector2(90, 240)
	mouse_filter = Control.MOUSE_FILTER_STOP
	if side == 0:
		anchor_left = 0.0
		anchor_right = 0.0
		offset_left = 16.0
		offset_right = 384.0
	else:
		anchor_left = 1.0
		anchor_right = 1.0
		offset_left = -384.0
		offset_right = -16.0
	anchor_top = 0.0
	anchor_bottom = 0.0
	offset_top = 120.0
	offset_bottom = 890.0
	var wood := Panel.new()
	wood.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wood.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	wood.add_theme_stylebox_override("panel", WoodKit.slate(8, 8))
	add_child(wood)
	var lip := ColorRect.new()
	lip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lip.color = RED if side == 0 else WoodKit.BLUE
	_at(lip, 10, 8, 348, 6)
	_name = _lab("", 34, WoodKit.INK, "Name")
	_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_at(_name, 10, 18, 348, 46)
	_chip = _lab("", 22, WoodKit.INK, "PlanChip" if side == 0 else "HabitChip")
	_chip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_at(_chip, 10, 64, 348, 32)
	_tag = _lab("", 22, WoodKit.INK, "WorstTag")
	_tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_at(_tag, 70 if side == 0 else 230, 96, 120, 34)
	var cols: Array = _columns()
	var colours: Array = [WoodKit.HEAD, GREEN, WoodKit.BLUE]
	var words: Array = ["energy", "legs", "guard"]
	var nums: Array = []
	for i in 3:
		var col: Array = cols[i]
		var tank := Drawn.Tank.new()
		tank.col = colours[i]
		tank.name = words[i].capitalize() + "Bar"
		_at(tank, float(col[0]) + (float(col[1]) - 36.0) * 0.5, 140, 36, 200)
		_tanks.append(tank)
		var num := _lab("", 30, WoodKit.INK, ["EnergyNum", "LegsNum", "GuardNum"][i])
		num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_at(num, float(col[0]), 346, float(col[1]), 40)
		nums.append(num)
		var word := _lab(words[i], 20, WoodKit.SOFT, words[i].capitalize() + "Word")
		word.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_at(word, float(col[0]), 386, float(col[1]), 28)
	_energy = nums[0]
	_legs = nums[1]
	_guard = nums[2]
	if side == 0:
		_own_extra()
	else:
		_opp_extra()
func _columns() -> Array:
	if side == 0:
		return [[132, 88], [224, 70], [296, 68]]
	return [[8, 104], [116, 72], [192, 74]]
func _own_extra() -> void:
	var bands: Array = [["fine", BodyFigure.BAND_COLOURS["fine"]], ["hurt", BodyFigure.BAND_COLOURS["hurt"]],
		["critical", BodyFigure.BAND_COLOURS["critical"]]]
	for i in bands.size():
		var sq := ColorRect.new()
		sq.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sq.color = bands[i][1]
		_at(sq, 12, 428 + i * 32, 22, 22)
		var lab := _lab(str(bands[i][0]), 20, WoodKit.SOFT, "Key" + str(bands[i][0]).capitalize())
		_at(lab, 40, 424 + i * 32, 110, 28)
	var cap := _lab("lasts to", 20, WoodKit.SOFT, "LastsTo")
	_at(cap, 12, 524, 160, 28)
	for i in 3:
		var bg := ColorRect.new()
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg.color = Color("#2a241e")
		_at(bg, 12 + i * 114, 558, 104, 36)
		var lab := _lab("R%d" % (i + 1), 20, WoodKit.INK, "LastsR%d" % (i + 1))
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_at(lab, 12 + i * 114, 560, 104, 32)
		_round_bg.append(bg)
		_rounds.append(lab)
	_ear = Drawn.Ear.new()
	_ear.name = "Ear"
	_at(_ear, 12, 612, 40, 40)
	_ear.mouse_filter = Control.MOUSE_FILTER_PASS
	for i in 3:
		var pip := Drawn.Pip.new()
		pip.name = "Pip%d" % i
		_at(pip, 60 + i * 28, 620, 22, 22)
		pip.mouse_filter = Control.MOUSE_FILTER_PASS
		_pips.append(pip)
	_heard = _lab("Heard 0 of 3", 20, WoodKit.SOFT, "Heard")
	_at(_heard, 150, 616, 200, 28)
func _opp_extra() -> void:
	_habit_card = Panel.new()
	_habit_card.name = "HabitCard"
	_habit_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("#241b14")
	sb.border_color = WoodKit.HEAD
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(10)
	_habit_card.add_theme_stylebox_override("panel", sb)
	_at(_habit_card, 8, 520, 352, 72)
	_habit_n = _lab("", 20, WoodKit.INK, "HabitCount")
	_habit_n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_habit_n.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_at(_habit_n, 8, 12, 336, 48, _habit_card)
func _process(delta: float) -> void:
	var bug: Node = view.get("_bug_box")
	visible = bug != null and bool(bug.get("visible")) and bool(view.get("playing"))
	if _flash > 0.0:
		_flash = maxf(0.0, _flash - delta)
	if _habit_card != null:
		_habit_card.modulate.a = 0.55 + 0.45 * absf(sin(_flash * 14.0)) if _flash > 0.0 else 1.0
func refresh() -> void:
	if host != null and bool(host.get("held")):
		return
	var main: Node = view.get("main")
	if main == null:
		return
	var lv: Dictionary = LiveRound.live(main.modal)
	if lv.is_empty():
		return
	var f: Dictionary = main.career.fighter_by_id(str(view.fid))
	_name.text = str(view.get("_names")[side]).to_upper()
	var exs: Array = lv.get("ex", [])
	var idx := mini(int(float(view.t) / Exchanges.EX_SECONDS), exs.size())
	var scouted := side == 0 or _film(f)
	var bars := FightMeters.bars(meter_src(view, side, _tank(lv, idx)))
	_paint_bars(lv, idx, bars, scouted)
	_paint_tag()
	if side == 0:
		_chip.text = own_line(lv)
		_paint_forecast(lv, f)
		_paint_ear(f)
	else:
		var mode := _mode_of(lv)
		_chip.text = opp_line(_opp(view), int((f.get("bout", {}) as Dictionary).get("film", 0)))
		_paint_habit(mode)
func _tank(lv: Dictionary, idx: int) -> float:
	if side == 0:
		return LiveRound.her_energy(lv, idx)
	return LiveRound.opp_energy(lv, idx)
func _paint_bars(lv: Dictionary, idx: int, bars: Dictionary, scouted: bool) -> void:
	var energy := _tank(lv, idx)
	var legs := int(round(float(bars["legs"]["fill"]) * 100.0))
	var guard := int(round(float(bars["guard"]["fill"]) * 100.0))
	shown_stamina = float(bars["stamina"]["fill"]) * 100.0
	if side == 0:
		_energy.text = str(int(round(energy)))
		(_tanks[0] as Drawn.Tank).set_fill(energy / 100.0, _mark(lv, energy))
		_legs.text = str(legs)
		_guard.text = str(guard)
		(_tanks[1] as Drawn.Tank).set_fill(float(bars["legs"]["fill"]), -1.0)
		(_tanks[2] as Drawn.Tank).set_fill(float(bars["guard"]["fill"]), -1.0)
	else:
		_energy.text = energy_range(energy, scouted)
		(_tanks[0] as Drawn.Tank).set_range(energy, scouted)
		_legs.text = str(legs) if scouted else "?"
		_guard.text = str(guard) if scouted else "?"
		(_tanks[1] as Drawn.Tank).set_known(float(bars["legs"]["fill"]), scouted)
		(_tanks[2] as Drawn.Tank).set_known(float(bars["guard"]["fill"]), scouted)
	for t in _tanks:
		(t as Drawn.Tank).queue_redraw()
func _mark(lv: Dictionary, energy: float) -> float:
	var id := ""
	for item in (lv.get("ex", []) as Array):
		var c := str((item as Dictionary).get("call", ""))
		if c != "":
			id = c
	if id == "" or not Exchanges.CALLS.has(id):
		return -1.0
	return clampf(energy - float(Exchanges.CALLS[id]["cost"]), 0.0, 100.0) / 100.0
func _paint_tag() -> void:
	var live: Node = view.get("body")
	if live == null:
		return
	var who := "a" if side == 0 else "b"
	var vals := {}
	for p in BodyMap.PLACES:
		vals[p] = BodyMap.value(live.map, who, p)
	var place := worst_place(vals)
	var band := BodyMap.band(float(vals.get(place, 100.0)))
	_tag.text = tag_text(place, band)
	_tag.add_theme_color_override("font_color", RED if band in ["critical", "doctor"] else WoodKit.INK)
func _paint_forecast(lv: Dictionary, _f: Dictionary) -> void:
	var exs: Array = lv.get("ex", [])
	var idx := mini(int(float(view.t) / Exchanges.EX_SECONDS), exs.size())
	var energy := LiveRound.her_energy(lv, idx)
	var total := int(view.get("total"))
	var now := int(view.get("round_n"))
	var fc: Dictionary = EnergyForecast.rounds_left(energy, _drains(lv), str(lv.get("pace", "steady")),
		maxi(0, Exchanges.EXCHANGES - exs.size()), maxi(0, total - now))
	var out := int(fc.get("out_round", 0))
	var by: Array = fc.get("by_round", [])
	for i in _rounds.size():
		var n := i + 1
		var bg := Color("#2a241e")
		var fg := WoodKit.SOFT
		if n < now or (n >= now and n - now < by.size() and float(by[n - now]) >= EnergyForecast.OUT and not (out > 0 and n == now + out - 1)):
			bg = WoodKit.HEAD
			fg = WoodKit.DARK_INK
		if out > 0 and n == now + out - 1:
			bg = RED
			fg = WoodKit.INK
		(_round_bg[i] as ColorRect).color = bg
		(_rounds[i] as Label).add_theme_color_override("font_color", fg)
func _paint_ear(f: Dictionary) -> void:
	if _ear != null:
		_ear.lit = CornerTrust.lands(f)
		_ear.tooltip_text = "She takes the corner's word" if _ear.lit else "She has stopped listening"
		_ear.queue_redraw()
	var got := _shouts()
	var heard := 0
	for i in _pips.size():
		var on := i < got.size() and bool(got[i])
		var pip := _pips[i] as Drawn.Pip
		pip.on = on
		pip.queue_redraw()
		if on:
			heard += 1
	if _heard != null:
		_heard.text = "Heard %d of %d" % [heard, _pips.size()]
		for p in _pips:
			(p as Control).tooltip_text = _heard.text
func _paint_habit(mode: String) -> void:
	var n := _count_mode(mode)
	if _seen >= 0 and n > _seen:
		_flash = 1.0
	_seen = n
	if _habit_n != null:
		var word := str((Exchanges.MODES.get(mode, {}) as Dictionary).get("label", mode))
		_habit_n.text = "%s, %d %s" % [word, n, "time" if n == 1 else "times"]
func _mode_of(lv: Dictionary) -> String:
	var exs: Array = lv.get("ex", [])
	if exs.is_empty():
		return str(lv.get("mode", "press"))
	return str((exs[-1] as Dictionary).get("mode", lv.get("mode", "press")))
func _drains(lv: Dictionary) -> Array:
	var prev := float((lv.get("start", {}) as Dictionary).get("a", 100.0))
	var out: Array = []
	for item in (lv.get("ex", []) as Array):
		var after := float(((item as Dictionary).get("after", {}) as Dictionary).get("a", prev))
		out.append({"drain": prev - after, "pace": str((item as Dictionary).get("pace", "steady"))})
		prev = after
	return out
func _shouts() -> Array:
	var got: Array = []
	for item in _all_ex():
		if str((item as Dictionary).get("call", "")) != "":
			got.append(bool((item as Dictionary).get("shout", false)))
	return got.slice(maxi(0, got.size() - 3))
func _count_mode(mode: String) -> int:
	var n := 0
	for item in _all_ex():
		if str((item as Dictionary).get("mode", "")) == mode:
			n += 1
	return n
func _all_ex() -> Array:
	var out: Array = []
	var main: Node = view.get("main")
	if main == null:
		return out
	var rounds: Array = main.modal.get("rounds", [])
	for i in mini(rounds.size(), int(view.get("round_n")) - 1):
		out.append_array((rounds[i] as Dictionary).get("exchanges", []))
	var lv: Dictionary = LiveRound.live(main.modal)
	if not lv.is_empty():
		out.append_array(lv.get("ex", []))
	return out
func _film(f: Dictionary) -> bool:
	return int((f.get("bout", {}) as Dictionary).get("film", 0)) >= BoutRules.FILM_DEPTH_WITH_STUDY
func recovered_for(who_side: int, tank: float) -> Dictionary:
	var src := meter_src(view, who_side, tank)
	var now := FightMeters.bars(src)
	var burn: Node = view.get("burn")
	if burn != null:
		_burn_into(src, (burn.get("_to") as Array)[who_side])
	var after := FightMeters.bars(src)
	var out := {"legs": [float(now["legs"]["fill"]) * 100.0, float(after["legs"]["fill"]) * 100.0]}
	if bool(src.get("guard_known", true)):
		out["guard"] = [float(now["guard"]["fill"]) * 100.0, float(after["guard"]["fill"]) * 100.0]
	return out
func _lab(text: String, px: int, col: Color, named: String) -> Label:
	var l := TV.label(text, px, col, "bold")
	l.name = named
	l.clip_text = false
	return l
func _at(c: Control, x: float, y: float, w: float, h: float, parent: Control = null) -> void:
	(self if parent == null else parent).add_child(c)
	c.anchor_left = 0.0
	c.anchor_top = 0.0
	c.anchor_right = 0.0
	c.anchor_bottom = 0.0
	c.offset_left = x
	c.offset_top = y
	c.offset_right = x + w
	c.offset_bottom = y + h
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
class Host extends Node:
	var view: Control
	var panels: Array = []
	var blocks: Array = []
	var held := false
	func paint(_snap: Dictionary, _scored: Array, _start: Dictionary) -> void:
		if held:
			return
		for p in panels:
			p.call("refresh")
	func fresh_round() -> void:
		held = false
		for p in panels:
			p.call("refresh")
	func hit(_s: int, _lost: Dictionary, _big: bool) -> void:
		pass
	func stamina(side: int) -> float:
		if side < 0 or side >= panels.size():
			return -1.0
		return float(panels[side].get("shown_stamina"))
	func recovered(who_side: int, tank: float) -> Dictionary:
		if panels.is_empty():
			return {}
		return panels[0].call("recovered_for", who_side, tank)
