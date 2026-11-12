extends RefCounted
## Side by side on the World rankings page (MENUWORLD1): today's seven stats, the rival as a range until scouted,
## Ask (grey, with the reason, when the promoter or a booking says no) and Scout with its price.
## The numbers are BoutRead's. This file only draws them.

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Bars := preload("res://scripts/ui/WorldBars.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const Rules := preload("res://scripts/rules/WorldLadderRules.gd")
const Data := preload("res://scripts/state/Data.gd")
const StatBlock := preload("res://scripts/rules/StatBlock.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Region := preload("res://scripts/state/Region.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const NameLinks := preload("res://scripts/ui/NameLinks.gd")

const LO := 35.0
const HI := 95.0
const FACE := Vector2(40, 46)

static func build(main: Node, c: Career, f: Dictionary, row: Dictionary) -> Control:
	var paper := _slate("SideBySide")
	var v := UI.vbox(6)
	paper.add_child(v)
	v.add_child(UI.caps("SIDE BY SIDE"))
	if row.is_empty() or bool(row.get("ours", false)):
		v.add_child(UI.muted("Pick a rival on the ladder.", UI.SMALL, true))
		return paper
	v.add_child(_who(f, row))
	v.add_child(_chance(row))
	v.add_child(UI.muted("Blue mark: the gym fighter now. Hatched: the range while not fully scouted.", UI.TINY, true))
	var ranges: Dictionary = {}
	var opp: Dictionary = row.get("opp", {})
	if not opp.is_empty():
		ranges = BoutRead.stat_ranges(opp, c.seed)
	var stats: Dictionary = f.get("stats", {})
	var attrs: Dictionary = StatBlock.Attrs.of(f)
	for k in Data.STATS:
		# S443 one number a word: Stamina and Fight IQ are the gym fighter's own attributes, as on the fighter page
		var mine := float(attrs.get(StatBlock.SHOWN_AS[k], 0.0)) if StatBlock.SHOWN_AS.has(k) else float(stats.get(k, 0.0))
		var span: Array = ranges.get(k, [mine, mine])
		v.add_child(_stat(str(Data.LABEL.get(k, k)), mine, float(span[0]), float(span[1])))
	v.add_child(UI.label(_known(row), UI.SMALL, UI.FG, "body", true))
	v.add_child(_acts(main, c, f, row))
	return paper


static func _who(f: Dictionary, row: Dictionary) -> Control:
	var h := UI.hbox(8)
	var mine := PromoShot.picture(Faces.stem(f), FACE)
	if mine != null:
		h.add_child(mine)
	var left := UI.vbox(1)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(UI.label(str(f["name"]), UI.SMALL, UI.GOLD, "bold"))
	left.add_child(UI.muted(_own_record(f), UI.TINY))
	h.add_child(left)
	h.add_child(UI.label("v", 22, UI.FG, "display"))
	var right := UI.vbox(1)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var rn := UI.label(str(row["name"]), UI.SMALL, UI.RED, "bold")
	rn.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	right.add_child(rn)
	var place := "#%d" % int(row["rank"]) if int(row.get("rank", 0)) > 0 else "Unranked"
	var sub := UI.muted("%s, %s, %s" % [_record(int(row["w"]), int(row["l"]), int(row.get("d", 0))), place, str(row.get("style", ""))], UI.TINY)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	right.add_child(sub)
	h.add_child(right)
	var opp: Dictionary = row.get("opp", {})
	if opp.is_empty():
		opp = row
	var theirs := PromoShot.picture(Faces.stem(opp, Faces.sex(f)), FACE)
	if theirs != null:
		h.add_child(theirs)
	return h


static func _own_record(f: Dictionary) -> String:
	if bool(f.get("pro", false)):
		return _record(int(f.get("pro_w", 0)), int(f.get("pro_l", 0)), int(f.get("pro_d", 0)))
	return _record(int(f.get("w", 0)), int(f.get("l", 0)), 0)


static func _record(w: int, l: int, d: int) -> String:
	return "%d-%d-%d" % [w, l, d] if d > 0 else "%d-%d" % [w, l]


static func _chance(row: Dictionary) -> Control:
	var h := UI.hbox(8)
	h.add_child(UI.caps("YOUR CHANCE"))
	var band: Dictionary = row.get("band", {})
	if not band.is_empty():
		var lo := float(band["lo"])
		var hi := float(band["hi"])
		var bar := Bars.RangeMark.new()
		bar.lo = lo
		bar.hi = hi
		bar.mark = (lo + hi) / 2.0
		bar.custom_minimum_size = Vector2(90, 12)
		h.add_child(bar)
		h.add_child(UI.label("%d-%d%%" % [roundi(lo * 100.0), roundi(hi * 100.0)], UI.SMALL, UI.FG, "bold"))
	return h


static func _stat(label: String, mine: float, lo: float, hi: float) -> Control:
	var h := UI.hbox(6)
	var n := UI.label(label, UI.TINY, UI.FG)
	n.custom_minimum_size = Vector2(108, 0)
	h.add_child(n)
	var num := UI.label(str(int(round(mine))), UI.SMALL, UI.GOLD, "bold")
	num.custom_minimum_size = Vector2(32, 0)
	num.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(num)
	var bar := Bars.RangeMark.new()
	bar.lo = _frac(lo)
	bar.hi = _frac(hi)
	bar.mark = _frac(mine)
	h.add_child(bar)
	var span := UI.label("%d-%d" % [roundi(lo), roundi(hi)], UI.TINY, UI.RED, "bold")
	span.custom_minimum_size = Vector2(64, 0)
	h.add_child(span)
	return h


static func _frac(v: float) -> float:
	return clampf((v - LO) / (HI - LO), 0.0, 1.0)


static func _known(row: Dictionary) -> String:
	if bool(row.get("scouted", false)):
		return "Scouted: the weakness is open and the range is narrower."
	if bool(row.get("partial", false)):
		return "The weapon is public. A scout opens the weakness and narrows the range."
	return "Not scouted: the range stays wide until a scout."


static func _acts(main: Node, c: Career, f: Dictionary, row: Dictionary) -> Control:
	var v := UI.vbox(4)
	var ask: Dictionary = row.get("ask", {})
	var on := bool(ask.get("on", false))
	var why := str(ask.get("why", ""))
	var pro := bool(row.get("pro", false))
	var ask_call := _noop()
	if pro and on:
		ask_call = main.act.bind("probook", "%s:%d:a" % [str(f["id"]), int(row.get("oid", 0))])
	var ab := UI.button("Ask for this fight", "Btn", ask_call, not on, why)
	ab.name = "SideAsk"
	v.add_child(ab)
	var scout_on := pro and not bool(row.get("scouted", false)) and c.cash >= MM.SCOUT_COST
	var scout_why := ""
	if not pro:
		scout_why = "The pro debut comes first."
	elif bool(row.get("scouted", false)):
		scout_why = "Already scouted"
	elif c.cash < MM.SCOUT_COST:
		scout_why = "Not enough cash"
	var scout_call := _noop()
	if scout_on:
		scout_call = main.act.bind("proscout", "%s:%d" % [str(f["id"]), int(row.get("oid", 0))])
	var sb := UI.button("Scout %s" % UI.money(MM.SCOUT_COST), "BtnSolid" if scout_on else "Btn", scout_call, not scout_on, scout_why)
	sb.name = "ScoutBtn"
	v.add_child(sb)
	var note := why if why != "" else scout_why
	if note == "" and not bool(row.get("scouted", false)):
		note = "Scout opens the weakness and narrows the range."
	if note != "":
		var line := UI.muted(note, UI.TINY, true)
		line.name = "AskWhy"
		v.add_child(line)
	return v


static func _noop() -> Callable:
	return func() -> void: pass


static func icon(id: String, px: int, colour: Color, why: String = "") -> TextureRect:
	var r := KitIcon.icon(id, px, colour, why)
	r.set_meta("icon", id)
	return r


static func sports() -> Control:
	var h := UI.hbox(8)
	h.name = "SportChips"
	var live := _panel(true)
	live.name = "ChipBoxing"
	live.add_child(UI.label("Boxing", UI.SMALL, UI.GOLD, "bold"))
	h.add_child(live)
	var mma := _panel(false)
	mma.name = "ChipMma"
	mma.tooltip_text = "Not built yet"
	mma.mouse_filter = Control.MOUSE_FILTER_STOP
	var row := UI.hbox(6)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(UI.label("MMA", UI.SMALL, UI.FG, "bold"))
	var warn := icon("warn", 16, Color("ffd54a"), "Not built yet")
	warn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(warn)
	mma.add_child(row)
	h.add_child(mma)
	return h


static func faces(main: Node, c: Career, selected: String, on_pick: Callable) -> Control:
	var sc := ScrollContainer.new()
	sc.name = "FighterRow"
	sc.custom_minimum_size = Vector2(0, 0)
	sc.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var h := UI.hbox(8)
	for f in c.fighters:
		h.add_child(_face(main, c, f, selected, on_pick))
	sc.add_child(h)
	return sc


static func _face(main: Node, c: Career, f: Dictionary, selected: String, on_pick: Callable) -> Control:
	var chip := _panel(str(f["id"]) == selected)
	chip.gui_input.connect(func(ev: InputEvent) -> void:
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed and (ev as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
			on_pick.call(main, str(f["id"])))
	var h := UI.hbox(6)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shot := PromoShot.picture(Faces.stem(f), Vector2(36, 42))
	if shot != null:
		h.add_child(shot)
	var text := UI.vbox(0)
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var name := UI.button(str(f["name"]), "Link", main.act.bind("fighter", str(f["id"])))
	name.name = "Fighter_" + str(f["id"])
	text.add_child(name)
	text.add_child(UI.muted(_place(c, f), UI.TINY))
	h.add_child(text)
	h.add_child(icon(Rules.chip_state(_flags(c, f)), 18, WoodKit.INK))
	chip.add_child(h)
	return chip


static func _place(c: Career, f: Dictionary) -> String:
	var rank := 0
	var label := ""
	if ProLadder.on_ladder(c, f):
		rank = int(ProLadder.entry(c, f).get("rank", 0))
		label = ProLadder.weight_of(ProLadder.division_for(f, c.world))
	else:
		rank = Region.our_rank(c, f)
		label = str(Data.DIVISIONS[str(f["div"])]["short"])
	return "%s #%d" % [label, rank] if rank > 0 else "%s, unranked" % label


static func _flags(c: Career, f: Dictionary) -> Dictionary:
	var bout: Dictionary = f.get("bout", {})
	var offer := false
	for o in f.get("offers", []):
		if not bool(o.get("answered", false)) and not bool(o.get("mismatch", false)):
			offer = true
	if not (f.get("pro_offers", []) as Array).is_empty() or str(c.pro_offer.get("fid", "")) == str(f["id"]):
		offer = true
	return {"injured": Injuries.out(c, f), "talks": not (f.get("talks", {}) as Dictionary).is_empty(),
		"camp": not (f.get("camp", {}) as Dictionary).is_empty(), "booked": bout.has("opp"), "offer": offer}


static func route_panel(route: Dictionary) -> Control:
	var paper := _ghost("TitleRoute")
	var v := UI.vbox(4)
	paper.add_child(v)
	v.add_child(UI.caps("TITLE ROUTE"))
	var h := UI.hbox(8)
	for step in route["steps"]:
		var s: Dictionary = step
		var col := UI.GOLD if bool(s["now"]) else (UI.GREEN if bool(s["done"]) else UI.MUTED)
		var cell := UI.hbox(3)
		if str(s["label"]) == "#1":
			cell.add_child(icon("champion", 14, UI.GOLD))
		cell.add_child(UI.label(str(s["label"]), UI.SMALL, col, "bold" if bool(s["now"]) else "body"))
		h.add_child(cell)
	v.add_child(h)
	var line := UI.label(str(route["line"]), UI.SMALL, UI.FG, "body", true)
	line.name = "RouteLine"
	v.add_child(line)
	return paper


static func key_panel() -> Control:
	var paper := _ghost("Key")
	var v := UI.vbox(4)
	paper.add_child(v)
	v.add_child(UI.caps("KEY"))
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 12)
	flow.add_theme_constant_override("v_separation", 4)
	flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	flow.custom_minimum_size = Vector2(480, 0)
	for it in [["champion", "Champion", UI.GOLD], ["challenger", "Challenger", UI.RED], ["next_opp", "Next opponent", UI.RED],
			["booked", "Booked", UI.GOLD], ["camp", "In camp", WoodKit.INK], ["injured", "Injured", UI.RED], ["offer", "Offer waiting", UI.AMBER],
			["contract", "Contract talks", WoodKit.INK], ["free", "Free", WoodKit.SOFT], ["leaving", "Leaving", UI.AMBER], ["retiring", "Retiring", WoodKit.SOFT], ["new_face", "New face", UI.GREEN],
			["scouted", "Scouted", UI.GREEN], ["unscouted", "Not scouted", WoodKit.SOFT], ["up", "Rising", UI.GREEN], ["down", "Falling", UI.RED],
			["hands", "Stoppages", WoodKit.INK], ["warn", "Not built yet", Color("ffd54a")]]:
		var cell := UI.hbox(4)
		cell.name = "Key_" + str(it[0])
		cell.add_child(icon(str(it[0]), 14, it[2] as Color))
		cell.add_child(UI.muted(str(it[1]), UI.TINY))
		flow.add_child(cell)
	v.add_child(flow)
	var steady := UI.hbox(4)
	steady.add_child(UI.label("-", UI.TINY, UI.MUTED, "bold"))
	steady.add_child(UI.muted("Steady", UI.TINY))
	v.add_child(steady)
	v.add_child(UI.muted("Wide band: not scouted. Narrower once scouted. Faded rows are out of reach.", UI.TINY, true))
	return paper


static func news_box(main: Node, c: Career) -> Control:
	var paper := _slate("NewsBox")
	var v := UI.vbox(4)
	paper.add_child(v)
	v.add_child(UI.caps("NEWS"))
	var n := 0
	for x in c.news:
		if bool(x.get("own", true)):
			continue
		if n >= 4:
			break
		var line := UI.hbox(8)
		line.add_child(NameLinks.label(main, c, str(x["t"]), UI.TINY))
		line.add_child(UI.muted(Clock.fmt(int(x["d"])), UI.TINY))
		v.add_child(line)
		n += 1
	if n == 0:
		v.add_child(UI.muted("Nothing from the other clubs yet.", UI.SMALL, true))
	return paper


static func region_files(main: Node, c: Career, divs: Array) -> Control:
	var paper := _slate("RegionFiles")
	var v := UI.vbox(4)
	paper.add_child(v)
	v.add_child(UI.caps("REGIONAL FILES"))
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 8)
	flow.add_theme_constant_override("v_separation", 2)
	flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	flow.custom_minimum_size = Vector2(640, 0)
	for r in c.rivals:
		if not divs.has(str(r["div"])):
			continue
		var b := UI.button(str(r["name"]), "Link", main.act.bind("rivalfile", str(r["name"])))
		b.name = "File_" + str(r["name"]).replace(" ", "_")
		flow.add_child(b)
	var sc := ScrollContainer.new()
	sc.custom_minimum_size = Vector2(0, 32)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(flow)
	v.add_child(sc)
	return paper


static func _panel(on: bool) -> PanelContainer:
	var p := PanelContainer.new()
	var edge := WoodKit.HEAD if on else Color(WoodKit.SOFT, 0.35)
	p.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.04), edge, 4, 2 if on else 1, 6, 6))
	return p


## A framed slate. Paper padded 24; the frame is 22, so the pad stays 22 and the card does not grow.
static func _slate(node_name: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = node_name
	p.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	p.add_theme_stylebox_override("panel", WoodKit.slate(22, 22))
	return p


## A small card: see-through, thin chalk outline. The selected chip uses _panel.
static func _ghost(node_name: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = node_name
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	p.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, 14, 8))
	return p


## See-through chips and strips sit on this so the ink pass turns their words to chalk. No extra padding, so nothing grows.
static func bed(child: Control) -> PanelContainer:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(Color(UI.DARK, 0.72), Color(0, 0, 0, 0), 0, 0, 0, 0))
	p.add_child(child)
	return p


static func wide_button(b: Button, floor_w: float) -> void:
	var link := b.theme_type_variation == "Link"
	var tw := UI.font("bold").get_string_size(b.text, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.BODY if link else UI.SMALL).x
	b.clip_text = false
	b.custom_minimum_size.x = maxf(floor_w, tw + (0.0 if link else 30.0))
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL

static var _aligning := false
static func align_columns(head: HBoxContainer, list: VBoxContainer) -> void:
	if _aligning:
		return
	var width := head.size.x
	if width < 200.0 or head.get_child_count() == 0:
		return
	_aligning = true
	var n := head.get_child_count()
	var sep := float(head.get_theme_constant("separation"))
	var mins: Array[float] = []
	var grow := 0.0
	for i in n:
		var m := _col_nat(head.get_child(i) as Control)
		for row in list.get_children():
			var cells := row.get_child(0) as HBoxContainer
			if cells != null and cells.get_child_count() > i:
				m = maxf(m, _col_nat(cells.get_child(i) as Control))
		mins.append(ceilf(m))
		grow += float((head.get_child(i) as Control).get_meta("grow", 0))
	var used := sep * float(n - 1)
	for bit in mins:
		used += bit
	var extra := maxf(0.0, width - used)
	var widths: Array[float] = []
	for j in n:
		var g := float((head.get_child(j) as Control).get_meta("grow", 0))
		widths.append(mins[j] + (0.0 if grow <= 0.0 else floorf(extra * g / grow)))   # whole pixels: a container rounds each up
	_stamp(head, widths)
	for row2 in list.get_children():
		var cells2 := row2.get_child(0) as HBoxContainer
		if cells2 != null:
			_stamp(cells2, widths)
	_aligning = false


static func _col_nat(n: Control) -> float:
	var saved := n.custom_minimum_size.x
	n.custom_minimum_size.x = 0.0
	var m := n.get_combined_minimum_size().x
	n.custom_minimum_size.x = saved
	return m


static func _stamp(box: HBoxContainer, widths: Array[float]) -> void:
	for i in mini(box.get_child_count(), widths.size()):
		var cell := box.get_child(i) as Control
		if absf(cell.custom_minimum_size.x - widths[i]) > 0.5:
			cell.custom_minimum_size.x = widths[i]
