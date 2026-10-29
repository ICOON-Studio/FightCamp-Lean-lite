extends VBoxContainer
## WORLD: News (Mail opens it), Rankings (the region's women's lightweights; hers once she has 4 wins), Events (club shows
## and her bout), Search (every fighter, coach, prospect and gym the game knows).

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Region := preload("res://scripts/state/Region.gd")

var _hits: VBoxContainer
var _career: Career


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	_career = c
	AreaHead.add(self, main, "world")
	match int(main.route["tab"]):
		0:
			var card := UI.card("NEWS")
			var rows: Array = []
			for x in c.news:
				rows.append(UI.row(x["t"], Clock.fmt(int(x["d"]))))
			UI.add_rows(card[1], rows)
			add_child(card[0])
		1:
			_rankings(c)
		2:
			_events(c)
		3:
			_search()


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


func _ranking_table(c: Career, div: String) -> void:
	var card := UI.card("%s, LONDON REGION" % str(Data.DIVISIONS[div]["name"]).to_upper())
	add_child(card[0])
	var grid := GridContainer.new()
	grid.name = "Rankings_" + div
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 40)
	grid.add_theme_constant_override("v_separation", 10)
	for head in ["#", "FIGHTER", "GYM", "RECORD"]:
		grid.add_child(UI.caps(head))
	var rows := Region.rankings(c, div)
	for i in mini(rows.size(), Region.RANK_ROWS):
		var r: Dictionary = rows[i]
		var col := UI.GOLD if bool(r["ours"]) else UI.FG
		grid.add_child(UI.mono(str(i + 1), UI.BODY, col))
		grid.add_child(UI.label(r["name"], UI.BODY, col, "bold" if bool(r["ours"]) else "body"))
		grid.add_child(UI.label(r["club"], UI.BODY, col))
		grid.add_child(UI.mono("%d-%d" % [r["w"], r["l"]], UI.BODY, col))
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
			notes.append("%s enters at %d wins (she has %d)." % [f["first"], Region.RANK_MIN_WINS, f["w"]])
	notes.append("Rivals fight at club shows every other Saturday.")
	card[1].add_child(UI.muted(" ".join(notes), UI.SMALL, true))


func _events(c: Career) -> void:
	var card := UI.card("EVENTS")
	add_child(card[0])
	var ev: Array = []
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
		all.append("%s, %s, %d-%d AM" % [r["name"], r["club"], r["w"], r["l"]])
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
