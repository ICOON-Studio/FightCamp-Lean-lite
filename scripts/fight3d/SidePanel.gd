extends Control
## Live-round readouts. One strip each side of the scoreboard: name, mode, three horizontal bars.
## The heard pips and the opponent habit card dock into the bottom bar. The figures stand free of these strips.
const TV := preload("res://scripts/ui/TV.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
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
const BAND_RANK := {"doctor": 0, "critical": 1, "hurt": 2, "fine": 3}
const SHORT := {"head": "HEAD", "left_eye": "EYE", "right_eye": "EYE", "nose": "NOSE", "left_ribs": "RIBS", "right_ribs": "RIBS"}
const WIDE := 16.0
const NARROW := 6.0
const WORDS := ["energy", "legs", "guard"]
const NUMS := ["EnergyNum", "LegsNum", "GuardNum"]
var view: Control
var side := 0
var host: Node
var _name: Label
var _chip: Label
var _tag: Label
var _energy: Label
var _legs: Label
var _guard: Label
var _lasts: Label
var _tanks: Array = []
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
## One line under the name. Our boxer: the plan in game words, never "Plan: Own game".
static func own_line(lv: Dictionary) -> String:
	var id := str(lv.get("plan", ""))
	var label := str((Exchanges.CALLS.get(id, {}) as Dictionary).get("label", ""))
	if label != "":
		return label
	var aim := PaceAim.aim_word(str(lv.get("aim", "")))
	return aim if aim != "" else "Own game"
## The opponent: the record, or the game the tape shows once it has been studied.
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
## Short forecast for the energy row. A full tank at round 1 reads "lasts to R3".
static func forecast_line(out_round: int, now: int) -> String:
	if out_round <= 0:
		return "lasts to R%d" % maxi(now, 3)
	return "lasts to R%d" % (now + out_round - 1)
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
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	anchor_left = 0.0
	anchor_right = 0.0
	anchor_top = 0.0
	anchor_bottom = 0.0
	offset_top = 20.0
	offset_bottom = 200.0
	if side == 0:
		offset_left = 20.0
		offset_right = 620.0
	else:
		offset_left = 1300.0
		offset_right = 1900.0
	_name = _lab("", 30, WoodKit.INK, "Name")
	_at(_name, 8, 4, 420, 36)
	_tag = _lab("", 22, WoodKit.INK, "WorstTag")
	_tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_at(_tag, 436, 8, 150, 32)
	_chip = _lab("", 22, WoodKit.INK, "PlanChip" if side == 0 else "HabitChip")
	_at(_chip, 8, 42, 560, 28)
	var colours: Array = [WoodKit.HEAD, Color("#5ac76a"), WoodKit.BLUE]
	var nums: Array = []
	for i in 3:
		var y := 78.0 + float(i) * 34.0
		var word := _lab(WORDS[i], 22, WoodKit.SOFT, WORDS[i].capitalize() + "Word")
		_at(word, 8, y, 84, 28)
		var num := _lab("", 22, WoodKit.INK, NUMS[i])
		_at(num, 96, y, 88, 28)
		var tank := Drawn.Tank.new()
		tank.col = colours[i]
		tank.name = WORDS[i].capitalize() + "Bar"
		_at(tank, 190, y + 3.0, 210.0 if side == 0 else 380.0, 22)
		_tanks.append(tank)
		nums.append(num)
	_energy = nums[0]
	_legs = nums[1]
	_guard = nums[2]
	if side == 0:
		_lasts = _lab("lasts to R3", 22, WoodKit.SOFT, "LastsTo")
		_at(_lasts, 408, 78, 180, 28)
		_own_bottom()
	else:
		_opp_bottom()
func _own_bottom() -> void:
	_ear = Drawn.Ear.new()
	_ear.name = "Ear"
	_ear.mouse_filter = Control.MOUSE_FILTER_PASS
	for i in 3:
		var pip := Drawn.Pip.new()
		pip.name = "Pip%d" % i
		pip.mouse_filter = Control.MOUSE_FILTER_PASS
		_pips.append(pip)
	_heard = _lab("Heard 0 of 3", 22, WoodKit.SOFT, "Heard")
func _opp_bottom() -> void:
	_habit_card = Panel.new()
	_habit_card.name = "HabitCard"
	_habit_card.mouse_filter = Control.MOUSE_FILTER_PASS
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("#241b14")
	sb.border_color = WoodKit.HEAD
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(10)
	_habit_card.add_theme_stylebox_override("panel", sb)
	_habit_n = _lab("", 22, WoodKit.INK, "HabitCount")
	_habit_n.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_habit_n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_habit_n.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_at(_habit_n, 8, 4, 200, 64, _habit_card)
func _process(delta: float) -> void:
	var bug: Node = view.get("_bug_box")
	visible = bug != null and bool(bug.get("visible")) and bool(view.get("playing"))
	if _flash > 0.0:
		_flash = maxf(0.0, _flash - delta)
	if _habit_card != null:
		_habit_card.modulate.a = 0.55 + 0.45 * absf(sin(_flash * 14.0)) if _flash > 0.0 else 1.0
	_dock()
func _dock() -> void:
	var bar := view.find_child("CornerBar", true, false) as Control
	if bar == null:
		return
	if side == 0:
		_park(_ear, bar)
		for p in _pips:
			_park(p, bar)
		_park(_heard, bar)
		_place_heard(bar)
	else:
		_park(_habit_card, bar)
		_place_habit(bar)
func _place_heard(bar: Control) -> void:
	var gap := _gap(bar)
	if gap.size.x < 40.0:
		return
	var y := gap.position.y + 8.0
	_box(_ear, gap.position.x, y, 28, 28)
	for i in _pips.size():
		_box(_pips[i], gap.position.x + 32.0 + float(i) * 24.0, y + 4.0, 20, 20)
	_box(_heard, gap.position.x, y + 34.0, 148, 28)
func _place_habit(bar: Control) -> void:
	var gap := _gap(bar)
	if gap.size.x < 80.0:
		return
	var x := gap.position.x + 160.0
	var w := maxf(80.0, gap.end.x - x)
	var h := minf(72.0, maxf(48.0, gap.size.y - 6.0))
	_box(_habit_card, x, gap.position.y + 4.0, w, h)
	if _habit_n != null:
		_habit_n.offset_right = w - 8.0
		_habit_n.offset_bottom = h - 4.0
func _gap(bar: Control) -> Rect2:
	var origin := bar.get_global_rect().position
	var last := bar.find_child("Effects", true, false) as Control
	if last == null:
		return Rect2()
	var lr := last.get_global_rect()
	var x := lr.end.x - origin.x + 8.0
	var right := bar.size.x - 8.0
	var board := bar.find_child("RoundBoard", true, false) as Control
	if board != null:
		right = board.get_global_rect().position.x - origin.x - 8.0
	return Rect2(x, lr.position.y - origin.y, maxf(0.0, right - x), lr.size.y)
func _park(c: Control, bar: Control) -> void:
	if c == null or c.get_parent() == bar:
		return
	if c.get_parent() != null:
		c.get_parent().remove_child(c)
	bar.add_child(c)
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
		_paint_forecast(lv)
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
func _paint_forecast(lv: Dictionary) -> void:
	if _lasts == null:
		return
	var exs: Array = lv.get("ex", [])
	var idx := mini(int(float(view.t) / Exchanges.EX_SECONDS), exs.size())
	var energy := LiveRound.her_energy(lv, idx)
	var total := int(view.get("total"))
	var now := int(view.get("round_n"))
	var fc: Dictionary = EnergyForecast.rounds_left(energy, _drains(lv), str(lv.get("pace", "steady")),
		maxi(0, Exchanges.EXCHANGES - exs.size()), maxi(0, total - now))
	var out := int(fc.get("out_round", 0))
	_lasts.text = forecast_line(out, now)
	var by: Array = fc.get("by_round", [])
	var bits: PackedStringArray = []
	for i in mini(3, by.size()):
		var n := now + i
		var low := out > 0 and i == out - 1
		bits.append("R%d %s" % [n, "runs out" if low else "holding"])
	_lasts.tooltip_text = " ".join(bits)
func _paint_ear(f: Dictionary) -> void:
	if _ear != null:
		_ear.lit = CornerTrust.lands(f)
		_ear.tooltip_text = "Takes the corner's word" if _ear.lit else "Has stopped listening"
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
		_habit_card.tooltip_text = _habit_n.text
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
	_box(c, x, y, w, h)
func _box(c: Control, x: float, y: float, w: float, h: float) -> void:
	if c == null:
		return
	c.anchor_left = 0.0
	c.anchor_top = 0.0
	c.anchor_right = 0.0
	c.anchor_bottom = 0.0
	c.offset_left = x
	c.offset_top = y
	c.offset_right = x + w
	c.offset_bottom = y + h
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
	func stamina(who: int) -> float:
		if who < 0 or who >= panels.size():
			return -1.0
		return float(panels[who].get("shown_stamina"))
	func recovered(who_side: int, tank: float) -> Dictionary:
		if panels.is_empty():
			return {}
		return panels[0].call("recovered_for", who_side, tank)
