extends VBoxContainer
## WORLD: News (Mail opens it), Rankings (the region's women's lightweights; hers once she has 4 wins), Events (club shows
## and her bout), Search (every fighter, coach, prospect and gym the game knows), Nationals (S328 update 30: the road to the
## National Amateur Championships; S329 pictures in NationalsView: her road, the entry rings, Enter, the brackets).

const NameLinks := preload("res://scripts/ui/NameLinks.gd")
const MatOpens := preload("res://scripts/ui/MatOpens.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Region := preload("res://scripts/state/Region.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const NationalsView := preload("res://scripts/ui/NationalsView.gd")

var _hits: VBoxContainer
var _career: Career


var _main: Node


func build(main: Node) -> void:
	_main = main
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	_career = c
	AreaHead.add(self, main, "world")
	match int(main.route["tab"]):
		0:
			# S396 blind review (News repeated Club > Records word for word): the world's news here, the club's in Records.
			var card := UI.card("AROUND THE REGION")
			var rows: Array = []
			for x in c.news:
				if bool(x.get("own", true)):
					continue
				var line := UI.hbox(12)   # S396 every name is a link
				line.add_child(NameLinks.label(main, c, str(x["t"])))
				line.add_child(UI.muted(Clock.fmt(int(x["d"])), UI.SMALL))
				rows.append(line)
			if rows.is_empty():
				rows.append(UI.muted("Nothing from the other clubs yet.", UI.BODY))
			rows.append(UI.muted("Your results, signings and money news are in Club, Records.", UI.SMALL))
			UI.add_rows(card[1], rows)
			# S397 blind round 4 ("News: eight lines, two-thirds empty"; "the calendar repeats on Championships"): what has
			# happened beside what is coming - the region's events move here from Championships.
			var cols := UI.hbox(16)
			cols.name = "NewsCols"
			card[0].size_flags_stretch_ratio = 3.0
			cols.add_child(card[0])
			add_child(cols)
			_events(c, cols)
		1:
			_rankings(c)
		2:
			# S396 screen cut: Championships = the road to the nationals (S397: the events moved to News).
			NationalsView.build(self, main, c)
		3:
			_search()
		4:
			NationalsView.build(self, main, c)


## One table per division the gym has a fighter in (the women's lightweights before anyone signs).
func _rankings(c: Career) -> void:
	var divs: Array = []
	for f in c.fighters:
		if not divs.has(str(f["div"])):
			divs.append(str(f["div"]))
	if divs.is_empty():
		divs.append("wlw")
	for div in divs:
		_ranking_table(c, div)
	for g in c.grapplers:   # S396: no-gi has no ranking table in the game; her belt is the ladder, said plainly
		add_child(MatOpens.link(_main, c, g, "No-gi has no ranking table: the belt is the ladder."))


func _ranking_table(c: Career, div: String) -> void:
	var card := UI.card("%s, THE REGION'S CLUB SHOWS" % str(Data.DIVISIONS[div]["name"]).to_upper())   # S396: not only London clubs
	add_child(card[0])
	var grid := GridContainer.new()
	grid.name = "Rankings_" + div
	grid.columns = 6   # S397: style and last bout fill the table's width (it sat in the left 40%)
	grid.add_theme_constant_override("h_separation", 40)
	grid.add_theme_constant_override("v_separation", 10)
	for head in ["#", "FIGHTER", "GYM", "RECORD", "STYLE", "LAST BOUT"]:
		grid.add_child(UI.caps(head))
	var rows := Region.rankings(c, div)
	for i in mini(rows.size(), Region.RANK_ROWS):
		var r: Dictionary = rows[i]
		var col := UI.GOLD if bool(r["ours"]) else UI.FG
		grid.add_child(UI.mono(str(i + 1), UI.BODY, col))
		if bool(r["ours"]):   # S396 blind round 2: hers is a link too, to her page
			grid.add_child(UI.button(str(r["name"]), "Link", _main.act.bind("fighter", str(r["fid"]))))
		else:
			# S341 her name opens her file: what the gym has found of her and every bout with us.
			var b := UI.button(str(r["name"]), "Link", _main.act.bind("rivalfile", str(r["name"])))
			b.name = "File_" + str(r["name"]).replace(" ", "_")
			b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			grid.add_child(b)
		grid.add_child(UI.label(r["club"], UI.BODY, col))
		grid.add_child(UI.mono("%d-%d" % [r["w"], r["l"]], UI.BODY, col))
		var who: Dictionary = c.fighter_by_id(str(r["fid"])) if bool(r["ours"]) else c.rival(str(r["name"]))
		grid.add_child(UI.label(str(who.get("style", "")), UI.BODY, col))
		grid.add_child(UI.label(_last_bout(c, r, who), UI.SMALL, UI.MUTED))
	card[1].add_child(grid)
	var notes: Array = []
	for f in c.fighters:
		if str(f["div"]) != div:
			continue
		if bool(f.get("pro", false)):
			notes.append("%s is a pro now: out of the amateur rankings." % f["first"])
		elif int(f.get("rank", 0)) > 0:
			notes.append("%s is number %d." % [f["name"], int(f["rank"])])
		else:
			notes.append("%s enters at %d wins (%d so far)." % [f["first"], Region.RANK_MIN_WINS, f["w"]])
	notes.append("Rivals fight at club shows every other Saturday.")
	card[1].add_child(UI.muted(" ".join(notes), UI.SMALL, true))


## "beat Maria Ortega, on points" - her newest bout, from her record (RivalPast) or our results.
func _last_bout(c: Career, r: Dictionary, who: Dictionary) -> String:
	if bool(r["ours"]):
		for res in c.results:
			if str(res.get("fid", "")) == str(r["fid"]):
				return "%s %s, %s" % ["beat" if bool(res["win"]) else "lost to", res["opp"], Clock.fmt(int(res["d"]))]
		return ""
	var last := RivalPast.shown(who, 1)
	if last.is_empty():
		return ""
	return "%s %s, %s" % ["beat" if bool(last[0]["win"]) else "lost to", last[0]["vs"], str(last[0]["how"]).get_slice(",", 0)]


func _events(c: Career, parent: Container) -> void:
	var card := UI.card("COMING UP")
	card[0].size_flags_stretch_ratio = 2.0
	card[0].size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	parent.add_child(card[0])
	var ev: Array = []
	for e in Champs.calendar(c):
		ev.append({"d": int(e["d"]), "t": e["t"], "ours": true})
	for d in Region.next_shows(c.day, 4):
		ev.append({"d": d, "t": "%s, %d rival bouts" % [Region.show_name(d), Region.SHOW_BOUTS], "ours": false})
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if not fb.is_empty():
			ev.append({"d": int(fb["day"]), "t": "%s vs %s: your bout%s" % [f["first"], fb["opp"]["name"], " (pro debut)" if bool(fb.get("pro", false)) else ""], "ours": true})
	ev.sort_custom(func(a, b): return int(a["d"]) < int(b["d"]))
	var rows: Array = []
	for e in ev:
		rows.append(UI.kv(Clock.fmt(int(e["d"])), e["t"], UI.GOLD if bool(e["ours"]) else UI.FG))
	UI.add_rows(card[1], rows)


func _search() -> void:
	var card := UI.card("SEARCH")
	add_child(card[0])
	var box := LineEdit.new()
	box.name = "SearchBox"
	box.placeholder_text = "Type a name: a fighter, a coach, a gym"
	box.text_changed.connect(_on_search)
	card[1].add_child(box)
	_hits = UI.vbox(6)
	_hits.name = "Hits"
	card[1].add_child(_hits)
	_on_search("")


## Everything the game knows by name: [text].
func everyone() -> Array:
	var all: Array = []
	for r in _career.rivals:
		all.append("%s, %s, %d-%d amateur" % [r["name"], r["club"], r["w"], r["l"]])
	for f in _career.fighters:
		all.append("%s, %s, %d-%d AM (yours)" % [f["name"], _career.gym_name, f["w"], f["l"]])
	for c in Data.COACHES:
		all.append("%s, %s" % [c["name"], str(c["kind"]).to_lower()])
	for p in Data.PROSPECTS:
		all.append("%s, prospect: %s" % [p["name"], p["note"]])
	return all


func _on_search(q: String) -> void:
	UI.clear(_hits)
	var needle := q.strip_edges().to_lower()
	if needle == "":
		_hits.add_child(UI.muted("Every fighter, coach and gym the game knows (%d names)." % everyone().size(), UI.BODY))
		return
	var found := everyone().filter(func(x): return str(x).to_lower().contains(needle))
	if found.is_empty():
		_hits.add_child(UI.muted("Nobody by that name.", UI.BODY))
	for x in found:
		_hits.add_child(UI.label(x, UI.BODY))
