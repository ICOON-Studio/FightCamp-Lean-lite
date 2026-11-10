extends RefCounted
## Rankings on the World page (MENUWORLD1). Draws the game's ladder: the promoter's band, BoutRead's chance,
## the kit's icons. It does not roll dice and it does not build the world.

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Bars := preload("res://scripts/ui/WorldBars.gd")
const Rules := preload("res://scripts/rules/WorldLadderRules.gd")
const Compare := preload("res://scripts/ui/WorldCompare.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const Region := preload("res://scripts/state/Region.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Data := preload("res://scripts/state/Data.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")

static var pick_fid := ""
static var pick_opp := ""

static func build(main: Node, c: Career) -> Control:
	if pick_fid != "" and c.fighter_by_id(pick_fid).is_empty():
		pick_fid = ""
		pick_opp = ""
	var page := UI.vbox(4)
	page.name = "RankingsPage"
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var top := UI.hbox(8)
	top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(Compare.sports())
	var chips := Compare.faces(main, c, _sel(c), _choose_fighter)
	chips.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(chips)
	page.add_child(Compare.bed(top))
	var f := _fighter(c)
	if f.is_empty():
		page.add_child(UI.muted("No fighter on the books.", UI.BODY))
		return page
	var rows: Array = _rows_for(c, f)
	var chosen := _chosen(rows)
	pick_opp = chosen
	var route: Dictionary = _route_of(c, f)
	var body := UI.hbox(12)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var left := UI.vbox(4)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for div in _gym_divs(c):
		var who := _fighter_in(c, div)
		var on: bool = str(f["div"]) == str(div)
		var use: Dictionary = f if on else who
		var use_rows: Array = rows if on else _rows_for(c, use)
		var ladder := _ladder(main, c, use, use_rows, chosen if on else _chosen(use_rows), route if on else _route_of(c, use))
		ladder.visible = on
		left.add_child(ladder)
	var foot := UI.hbox(8)
	foot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var route_p := Compare.route_panel(route)
	route_p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	route_p.size_flags_stretch_ratio = 1.15
	var key_p := Compare.key_panel()
	key_p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	key_p.size_flags_stretch_ratio = 2.0
	foot.add_child(route_p)
	foot.add_child(key_p)
	left.add_child(Compare.bed(foot))
	left.add_child(Compare.region_files(main, c, _gym_divs(c)))
	body.add_child(left)
	var right := UI.vbox(8)
	right.custom_minimum_size = Vector2(400, 0)
	right.add_child(Compare.build(main, c, f, _row_by_id(rows, chosen)))
	right.add_child(Compare.news_box(main, c))
	body.add_child(right)
	page.add_child(body)
	return page

static func _ladder(main: Node, c: Career, f: Dictionary, rows: Array, chosen: String, route: Dictionary) -> Control:
	var board := PanelContainer.new()
	board.name = "Rankings_" + str(f["div"])
	board.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	board.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# The whiteboard padded 60. The frame is 22, so the pad is 38 and the board does not grow.
	board.add_theme_stylebox_override("panel", WoodKit.slate(38, 38))
	var v := UI.vbox(2)
	board.add_child(v)
	v.add_child(UI.caps(_caption(c, f)))
	# S408 (S398 rule: nothing the player cannot act on): the amateur tables have no rank history or stoppage count, so a column no row fills is left out.
	var trend := rows.any(func(r): return str(r.get("trend", "")) != "")
	var ko := rows.any(func(r): return bool(r.get("has_ko", false)) and int(r["w"]) > 0)
	var head := _header(trend, ko)
	head.name = "LadderHead"
	v.add_child(head)
	var list := UI.vbox(1)
	list.name = "LadderRows"
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var line := str(route["line"])
	for i in rows.size():
		var row: Dictionary = rows[i]
		list.add_child(_row(main, f, row, chosen, line if bool(row["ours"]) and int(row["rank"]) <= 0 else "", trend, ko, i))
	v.add_child(list)
	board.resized.connect(func(): Compare.align_columns(head, list))
	return board

static func _caption(c: Career, f: Dictionary) -> String:
	if ProLadder.on_ladder(c, f):
		return "BOXING, %s, PRO" % _weight(ProLadder.division_for(f)).to_upper()
	return "BOXING, %s" % str(Data.DIVISIONS[str(f["div"])]["name"]).to_upper()

static func _header(trend: bool, ko: bool) -> HBoxContainer:
	var h := UI.hbox(4)
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# Compare.align_columns sets each column to its text, then shares the board's spare width by the third number.
	var specs := [["#", 40, 0], ["Fighter", 220, 2], ["Record", 64, 1], ["Age", 40, 0], ["Win chance", 240, 5], ["Scout", 52, 1], ["Trend", 52, 1], ["Finishes", 80, 1], ["Style", 150, 1], ["", 150, 2]]
	for pair in specs:
		if (pair[0] == "Trend" and not trend) or (pair[0] == "Finishes" and not ko):
			continue
		var lab := UI.caps(str(pair[0]))
		lab.custom_minimum_size = Vector2(int(pair[1]), 0)
		lab.set_meta("grow", int(pair[2]))
		h.add_child(lab)
	return h

static func _row(main: Node, f: Dictionary, row: Dictionary, chosen: String, line: String, trend: bool, ko: bool, stripe: int) -> Control:
	var p := PanelContainer.new()
	p.name = "LadderRow_" + str(row["id"]).replace(" ", "_")
	var mine := bool(row["ours"])
	p.set_meta("rank", int(row["rank"]))
	p.set_meta("mine", mine)
	p.set_meta("reach", bool(row.get("reach", false)))
	p.set_meta("oid", int(row.get("oid", 0)))
	p.set_meta("booked_opp", bool(row.get("booked_opp", false)))
	var fade := bool(row.get("pro", false)) and not mine and not bool(row.get("reach", false))
	if mine:
		_tint(p, Color(0, 0, 0, 0), WoodKit.HEAD, 2)
	elif str(row["id"]) == chosen:
		_tint(p, Color(0, 0, 0, 0), WoodKit.BLUE, 2)
	elif stripe % 2 == 1:
		_tint(p, Color(1, 1, 1, 0.03))
	else:
		_tint(p, Color(0, 0, 0, 0))
	if fade:
		p.modulate = Color(1, 1, 1, 0.55)
	var h := UI.hbox(4)
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var rk := "#%d" % int(row["rank"]) if int(row["rank"]) > 0 else "-"
	h.add_child(_w(UI.mono(rk, UI.SMALL, UI.GOLD if mine else UI.FG), 40))
	h.add_child(_name(main, f, row))
	h.add_child(_w(UI.mono(_rec(int(row["w"]), int(row["l"]), int(row["d"])), UI.SMALL), 64))
	h.add_child(_w(UI.label(str(int(row["age"])), UI.SMALL), 40))
	var chance := _chance(row, line)
	if fade:
		chance.modulate = Color(1, 1, 1, 1.0 / 0.55)
	h.add_child(chance)
	h.add_child(_scout(row))
	if trend:
		h.add_child(_trend(row))
	if ko:
		h.add_child(_finishes(row))
	var style := UI.label(str(row.get("style", "")), UI.SMALL)
	style.name = "Style"
	style.clip_text = false
	h.add_child(_w(style, 150))
	h.add_child(_action(main, f, row))
	p.add_child(h)
	return p

static func _name(main: Node, f: Dictionary, row: Dictionary) -> Control:
	var h := UI.hbox(4)
	h.custom_minimum_size = Vector2(220, 0)
	var who: Dictionary = f if bool(row["ours"]) else row.get("opp", {})
	if who.is_empty():
		who = row
	var shot := PromoShot.picture(Faces.stem(who, Faces.sex(f)), Vector2(22, 26))
	if shot != null:
		h.add_child(shot)
	var call: Callable = main.act.bind("fighter", str(f["id"])) if bool(row["ours"]) else _choose.bind(main, str(row["id"]))
	var b := UI.button(str(row["name"]), "Link", call)
	b.tooltip_text = str(row.get("tip", ""))
	Compare.wide_button(b, 120.0)
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.size_flags_horizontal = Control.SIZE_FILL   # the marks sit right after the name
	h.add_child(b)
	for m in row.get("marks", []):
		h.add_child(Compare.icon(str(m), 14, _mark_col(str(m))))
	return h

static func _chance(row: Dictionary, line: String) -> Control:
	var h := UI.hbox(4)
	h.custom_minimum_size = Vector2(240, 0)
	var band: Dictionary = row.get("band", {})
	if band.is_empty():
		h.add_child(UI.muted(line if line != "" else "-", UI.TINY, true))
		return h
	var lo := float(band["lo"])
	var hi := float(band["hi"])
	var bar := Bars.ChanceBar.new()
	bar.name = "WinBand"
	bar.lo = lo
	bar.hi = hi
	bar.scouted = 2 if bool(row.get("scouted", false)) else (1 if bool(row.get("partial", false)) else 0)
	bar.set_meta("span", hi - lo)
	bar.tooltip_text = "%d-%d%%" % [roundi(lo * 100.0), roundi(hi * 100.0)]
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(bar)
	h.add_child(_w(UI.label("%d-%d%%" % [roundi(lo * 100.0), roundi(hi * 100.0)], UI.SMALL, UI.FG, "bold"), 76))
	return h

static func _scout(row: Dictionary) -> Control:
	var h := UI.hbox(2)
	h.custom_minimum_size = Vector2(52, 0)
	if bool(row["ours"]):
		h.add_child(UI.muted("-", UI.TINY))
	elif bool(row.get("scouted", false)):
		h.add_child(Compare.icon("scouted", 16, UI.GREEN))
	elif bool(row.get("partial", false)):
		h.add_child(Compare.icon("scouted", 16, UI.AMBER))
	else:
		h.add_child(Compare.icon("unscouted", 16, WoodKit.SOFT))
	return h

static func _trend(row: Dictionary) -> Control:
	var h := UI.hbox(2)
	h.custom_minimum_size = Vector2(52, 0)
	var t := str(row.get("trend", ""))
	if t == "up":
		h.add_child(Compare.icon("up", 14, UI.GREEN))
	elif t == "down":
		h.add_child(Compare.icon("down", 14, UI.RED))
	else:
		h.add_child(UI.muted("-", UI.TINY))
	return h

static func _finishes(row: Dictionary) -> Control:
	var h := UI.hbox(3)
	h.custom_minimum_size = Vector2(80, 0)
	if not bool(row.get("has_ko", false)) or int(row["w"]) <= 0:
		h.add_child(UI.muted("-", UI.TINY))
		return h
	h.add_child(UI.label("%d%%" % int(round(100.0 * float(row["ko"]) / float(int(row["w"])))), UI.SMALL, UI.FG, "bold"))
	h.add_child(Compare.icon("hands", 14, WoodKit.INK))
	return h

static func _action(main: Node, f: Dictionary, row: Dictionary) -> Control:
	var v := UI.vbox(1)
	v.custom_minimum_size = Vector2(120, 0)
	var day := _booked_day(f)
	if day > 0 and (bool(row["ours"]) or bool(row.get("booked_opp", false))):
		v.add_child(UI.label(Clock.fmt(day), UI.TINY, UI.GOLD, "bold"))
	var ask: Dictionary = row.get("ask", {})
	if not bool(row["ours"]) and bool(ask.get("show", false)):
		var on := bool(ask.get("on", false))
		var why := str(ask.get("why", ""))
		var call := _noop()
		if on and bool(row.get("pro", false)):
			call = main.act.bind("probook", "%s:%d:a" % [str(f["id"]), int(row["oid"])])
		var b := UI.button(why if not on and why != "" else "Ask for this fight", "Btn", call, not on, why)
		b.name = "Ask_" + str(row["id"])
		Compare.wide_button(b, 0.0)
		v.add_child(b)
	return v

static func _rows_for(c: Career, f: Dictionary) -> Array:
	if f.is_empty():
		return []
	if ProLadder.on_ladder(c, f):
		return _pro_rows(c, f)
	return _amateur_rows(c, f)

static func _pro_rows(c: Career, f: Dictionary) -> Array:
	var entry := ProLadder.entry(c, f)
	var table := ProLadder.table(c, f)
	var light: Array = []
	for b in table:
		if bool(b.get("retired", false)):
			continue
		if bool(b.get("player", false)):
			if str(b.get("fid", "")) == str(f["id"]):
				light.append(_ours(f, int(b.get("rank", 0)), true))
			continue
		if int(b.get("rank", 0)) > 0:
			light.append(_boxer(b))
	if _ours_missing(light):
		light.append(_ours(f, int(entry.get("rank", 0)), true))
	var champ := WR.champion_of(table, "world")
	var chall: Dictionary = WR.mandatory_challenger(table, champ) if not champ.is_empty() else {}
	var chall_id := int(chall.get("id", -1)) if not chall.is_empty() else -1
	var bout: Dictionary = f.get("bout", {})
	var booked := bout.has("opp")
	var next_name := str(bout["opp"]["name"]) if booked else ""
	var out: Array = []
	for r in Rules.pick(light, 10):
		var row: Dictionary = r
		if bool(row["ours"]):
			out.append(row)
			continue
		var box: Dictionary = row["boxer"]
		var file: Dictionary = ProLadder.file_of(f, int(box["id"]))
		var bo := ProLadder.bout_opp(f, box, file.get("file_found", []))
		var band: Dictionary = ProLadder.read(c, f, bo)
		var ask: Dictionary = Rules.row_ask(entry, box, booked)
		if str(ask["why"]) == "Booked" and bout.has("day"):
			ask["why"] = "Booked for %s" % Clock.fmt(int(bout["day"]))
		row["band"] = band
		row["ask"] = ask
		row["reach"] = Rules.in_reach(entry, box)
		row["scouted"] = OppFile.known(bo, "weakness")
		row["partial"] = OppFile.known(bo, "weapon") and not bool(row["scouted"])
		row["marks"] = Rules.marks(box, chall_id, next_name)
		row["trend"] = Rules.trend(box)
		row["booked_opp"] = booked and str(box.get("name", "")) == next_name
		row["opp"] = bo
		row["tip"] = str(box.get("club", ""))
		out.append(row)
	return out

static func _amateur_rows(c: Career, f: Dictionary) -> Array:
	var ranked := Region.rankings(c, str(f["div"]))
	var light: Array = []
	var seen := false
	for i in ranked.size():
		var src: Dictionary = ranked[i]
		if bool(src["ours"]):
			if str(src["fid"]) == str(f["id"]):
				seen = true
				light.append(_ours(f, i + 1, false))
			continue
		light.append(_rival(c, src, i + 1))
	if not seen:
		light.append(_ours(f, 0, false))
	var bout: Dictionary = f.get("bout", {})
	var booked := bout.has("opp")
	var next_name := str(bout["opp"]["name"]) if booked else ""
	var days := int(bout["day"]) - c.day if bout.has("day") else 0
	var camp := BoutRead.camp_for(f, days)
	var coach := float(c.coach.get("rating", 0.0))
	var out: Array = []
	for r in Rules.pick(light, 10):
		var row: Dictionary = r
		if bool(row["ours"]):
			out.append(row)
			continue
		var who: Dictionary = row["boxer"]
		var band: Dictionary = BoutRead.band(f, who, camp, c.seed, coach)
		row["band"] = {"lo": float(band["lo"]), "hi": float(band["hi"])}
		row["ask"] = {"show": false, "on": false, "why": "The pro debut comes first."}
		row["reach"] = false
		row["scouted"] = OppFile.known(who, "weakness")
		row["partial"] = OppFile.known(who, "weapon") and not bool(row["scouted"])
		row["marks"] = Rules.marks(who, -1, next_name)
		row["booked_opp"] = booked and str(who.get("name", "")) == next_name
		row["opp"] = who
		row["tip"] = _tip(who, str(row.get("club", "")))
		out.append(row)
	return out

static func _ours(f: Dictionary, rank: int, pro: bool) -> Dictionary:
	var w := int(f.get("pro_w", 0)) if pro else int(f.get("w", 0))
	var l := int(f.get("pro_l", 0)) if pro else int(f.get("l", 0))
	var d := int(f.get("pro_d", 0)) if pro else 0
	return {"id": "you", "oid": 0, "name": str(f["name"]), "ours": true, "rank": rank, "w": w, "l": l, "d": d,
		"age": int(f.get("age", 0)), "style": str(f.get("style", "")), "ko": 0, "has_ko": false, "pro": pro,
		"reach": false, "booked_opp": false, "marks": [], "trend": "", "band": {}, "ask": {}, "scouted": false,
		"partial": false, "opp": {}, "tip": "", "boxer": {}}

static func _boxer(b: Dictionary) -> Dictionary:
	return {"id": str(int(b["id"])), "oid": int(b["id"]), "name": str(b["name"]), "ours": false, "rank": int(b.get("rank", 0)),
		"w": int(b.get("w", 0)), "l": int(b.get("l", 0)), "d": int(b.get("d", 0)), "age": int(b.get("age", 0)),
		"style": str(b.get("style", "")), "ko": int(b.get("ko", 0)), "has_ko": b.has("ko"), "pro": true, "reach": false,
		"booked_opp": false, "marks": [], "trend": "", "band": {}, "ask": {}, "scouted": false, "partial": false,
		"opp": {}, "tip": "", "boxer": b}

static func _rival(c: Career, r: Dictionary, rank: int) -> Dictionary:
	var who := c.rival(str(r["name"]))
	if who.is_empty():
		who = r
	return {"id": str(r["name"]), "oid": 0, "name": str(r["name"]), "ours": false, "rank": rank, "w": int(r["w"]),
		"l": int(r["l"]), "d": 0, "age": int(who.get("age", 0)), "style": str(who.get("style", "")), "ko": 0,
		"has_ko": false, "pro": false, "reach": false, "booked_opp": false, "marks": [], "trend": "", "band": {},
		"ask": {}, "scouted": false, "partial": false, "opp": {}, "tip": "", "boxer": who, "club": str(r.get("club", ""))}

static func _route_of(c: Career, f: Dictionary) -> Dictionary:
	if ProLadder.on_ladder(c, f):
		return Rules.title_route(int(ProLadder.entry(c, f).get("rank", 0)))
	return Rules.amateur_route(int(f.get("w", 0)), Region.RANK_MIN_WINS, Region.our_rank(c, f))

static func _chosen(rows: Array) -> String:
	var ids: Array = []
	for r in rows:
		ids.append(str((r as Dictionary)["id"]))
	if ids.has(pick_opp):
		return pick_opp
	var booked := ""
	var reach := ""
	var first := ""
	for r in rows:
		var row: Dictionary = r
		if bool(row["ours"]):
			continue
		if first == "":
			first = str(row["id"])
		if booked == "" and bool(row.get("booked_opp", false)):
			booked = str(row["id"])
		if reach == "" and bool(row.get("reach", false)):
			reach = str(row["id"])
	if booked != "":
		return booked
	if reach != "":
		return reach
	return first

static func _row_by_id(rows: Array, id: String) -> Dictionary:
	for r in rows:
		var row: Dictionary = r
		if str(row["id"]) == id:
			return row
	return {}

static func _ours_missing(rows: Array) -> bool:
	for r in rows:
		if bool((r as Dictionary).get("ours", false)):
			return false
	return true

static func _tip(who: Dictionary, club: String) -> String:
	var last: Array = RivalPast.shown(who, 1)
	if last.is_empty():
		return club
	var bit := "%s %s" % ["beat" if bool(last[0]["win"]) else "lost to", str(last[0]["vs"])]
	return bit if club == "" else "%s. %s" % [club, bit]

static func _booked_day(f: Dictionary) -> int:
	var bout: Dictionary = f.get("bout", {})
	return int(bout["day"]) if bout.has("opp") and bout.has("day") else 0

static func _fighter(c: Career) -> Dictionary:
	if pick_fid != "":
		var f := c.fighter_by_id(pick_fid)
		if not f.is_empty():
			return f
	return c.fighter()

static func _sel(c: Career) -> String:
	var f := _fighter(c)
	return "" if f.is_empty() else str(f["id"])

static func _fighter_in(c: Career, div: String) -> Dictionary:
	for f in c.fighters:
		if str(f["div"]) == div:
			return f
	return {}

static func _gym_divs(c: Career) -> Array:
	var divs: Array = []
	for f in c.fighters:
		if not divs.has(str(f["div"])):
			divs.append(str(f["div"]))
	if divs.is_empty():
		divs.append("wlw")
	return divs

static func _weight(id: String) -> String:
	return "welterweight" if id.ends_with("wr") else "lightweight"

static func _choose(main: Node, id: String) -> void:
	pick_opp = id
	main.render()

static func _choose_fighter(main: Node, id: String) -> void:
	pick_fid = id
	pick_opp = ""
	main.render()

static func _noop() -> Callable:
	return func() -> void: pass

static func _rec(w: int, l: int, d: int) -> String:
	return "%d-%d-%d" % [w, l, d] if d > 0 else "%d-%d" % [w, l]

static func _w(n: Control, width: int) -> Control:
	n.custom_minimum_size.x = width
	return n

static func _mark_col(id: String) -> Color:
	if id == "champion":
		return UI.GOLD
	if id == "up":
		return UI.GREEN
	return UI.RED

static func _tint(p: PanelContainer, bg: Color, edge: Color = Color(0, 0, 0, 0), w: int = 0) -> void:
	p.add_theme_stylebox_override("panel", UI.box(bg, edge, 4, w, 0, 1))
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
