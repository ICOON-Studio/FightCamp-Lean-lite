extends RefCounted
## S397 menus round 3 (blind critic: "History is one row while the header says 4-1"): her History tab as a record book -
## a strip of totals, then every bout as a table row (when, opponent, result, method, rounds), club bouts first with
## what the camp and the plan did, then the ones she brought (PriorBouts).
##   BoutHistory.make(main, c, f) -> Control

const UI := preload("res://scripts/ui/UI.gd")
const PriorBouts := preload("res://scripts/rules/PriorBouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## Column widths: when, opponent, result, method, rounds (the note fills the rest).
const COLS := [150, 330, 110, 300]


static func make(main: Node, c: Career, f: Dictionary) -> Control:
	var v := UI.vbox(14)
	v.name = "BoutHistory"
	var mine := c.results.filter(func(r): return str(r.get("fid", f["id"])) == str(f["id"]))
	var am := mine.filter(func(r): return not bool(r.get("pro", false)))
	var before_w := int(f["w"]) - am.filter(func(r): return bool(r["win"])).size()
	var before_l := int(f["l"]) - am.filter(func(r): return not bool(r["win"])).size()
	var prior := PriorBouts.list(f, before_w, before_l, int(f.get("joined", 0)))
	var rows: Array = []
	for r in mine:
		rows.append(_club_row(r))
	for i in range(prior.size() - 1, -1, -1):
		var p: Dictionary = prior[i]
		rows.append({"when": p["when"], "opp": "%s (%s)" % [p["opp"], p["club"]], "win": p["win"], "draw": false, "method": p["method"],
			"rounds": _rounds_of(str(p["method"])), "note": "", "old": true})
	var title := "EVERY BOUT: %d-%d AMATEUR" % [f["w"], f["l"]]
	if bool(f.get("pro", false)):
		title += ", %d-%d-%d PRO" % [int(f.get("pro_w", 0)), int(f.get("pro_l", 0)), int(f.get("pro_d", 0))]
	var card := UI.card(title)
	# S398 (operator rule; the record was shown three times): the totals live on the table's hover, not a strip of their own
	card[0].tooltip_text = _totals_line(c, f, rows, mine.size())
	v.add_child(card[0])
	var t: VBoxContainer = card[1]
	if rows.is_empty():
		t.add_child(UI.muted("No bouts yet: the first one shows here.", UI.BODY))
		return v
	t.add_child(_line(["WHEN", "OPPONENT", "RESULT", "METHOD", "NOTE"], true))   # S398: the method says the rounds
	var divided := false
	for r in rows:
		if bool(r["old"]) and not divided:   # S397 blind round 4: one divider, not "before the club" on every row
			divided = true
			var d := UI.caps("BEFORE %s" % c.gym_name.to_upper())
			d.add_theme_color_override("font_color", UI.MUTED)
			t.add_child(d)
		t.add_child(_row(r))
	return v


## A club bout's row from its result: the method read off the cards ("29-28, 28-29, 29-28" or "RSC round 2").
static func _club_row(r: Dictionary) -> Dictionary:
	var cards := str(r.get("cards", ""))
	var method := ""
	if cards.contains("round"):
		method = "stopped in round %s" % cards.get_slice("round", 1).strip_edges()
	else:
		var mine := 0
		var all := cards.split(",", false)
		for s in all:
			var p := s.strip_edges().split("-")
			if p.size() == 2 and int(p[0]) > int(p[1]):
				mine += 1
		var won := bool(r["win"])
		method = "points, %s" % ("unanimous" if (mine == all.size() if won else mine == 0) else "split")
	var pr: Dictionary = r.get("plan_rec", {})
	var note := str(r.get("why", "")).get_slice(":", 0)
	if not pr.is_empty() and int(pr["used"]) > 0:
		note += ("; " if note != "" else "") + "plan won %d of %d" % [int(pr["worked"]), int(pr["used"])]
	return {"when": Clock.fmt(int(r["d"])), "opp": str(r["opp"]), "win": bool(r["win"]), "draw": str(r.get("outcome", "")) == "draw",
		"method": method, "rounds": _rounds_of(method), "note": note, "tip": "Cards: " + cards, "old": false}


static func _rounds_of(method: String) -> String:
	if method.begins_with("stopped"):
		return "%s of %d" % [method.get_slice("round", 1).strip_edges(), BoutRules.ROUNDS]
	return "%d of %d" % [BoutRules.ROUNDS, BoutRules.ROUNDS]


## Totals in one line (the table's hover): wins on points, wins inside, with the club.
static func _totals_line(c: Career, f: Dictionary, rows: Array, club_n: int) -> String:
	var won := rows.filter(func(r): return bool(r["win"]))
	var inside := won.filter(func(r): return str(r["method"]).begins_with("stopped")).size()
	var club_w := rows.filter(func(r): return not bool(r["old"]) and bool(r["win"])).size()
	return "Won on points %d, won inside %d; for %s %d-%d" % [won.size() - inside, inside, c.gym_name, club_w, club_n - club_w]


static func _totals(c: Career, f: Dictionary, rows: Array, club_n: int) -> Control:
	var h := UI.hbox(40)   # S397 blind round 4 ("four giant cards for 2 and 1-0"): one strip of totals
	var won := rows.filter(func(r): return bool(r["win"]))
	var inside := won.filter(func(r): return str(r["method"]).begins_with("stopped")).size()
	var club_w := rows.filter(func(r): return not bool(r["old"]) and bool(r["win"])).size()
	for t in [["RECORD", "%d-%d" % [f["w"], f["l"]]], ["WON ON POINTS", str(won.size() - inside)], ["WON INSIDE", str(inside)],
			["FOR %s" % c.gym_name.to_upper(), "%d-%d" % [club_w, club_n - club_w]]]:
		var cell := UI.hbox(10)
		cell.add_child(UI.caps(str(t[0])))
		cell.add_child(UI.label(str(t[1]), 24, UI.FG, "bold"))
		h.add_child(cell)
	var cd := UI.card()
	cd[1].add_child(h)
	return cd[0]


static func _row(r: Dictionary) -> Control:
	var res := "Draw" if bool(r.get("draw", false)) else ("Won" if bool(r["win"]) else "Lost")
	var l := _line([r["when"], r["opp"], res, r["method"], r["note"]], false, UI.GREEN if bool(r["win"]) else UI.RED)
	if r.has("tip"):
		l.tooltip_text = str(r["tip"])
	return l


static func _line(cells: Array, head: bool, res_col: Color = UI.FG) -> Control:
	var h := UI.hbox(12)
	h.mouse_filter = Control.MOUSE_FILTER_PASS
	for i in cells.size():
		var x: Label = UI.caps(str(cells[i])) if head else UI.label(str(cells[i]), UI.BODY if i < 5 else UI.SMALL,
			res_col if i == 2 else (UI.MUTED if i == 5 else UI.FG), "bold" if i == 2 else "body")
		if i < COLS.size():
			x.custom_minimum_size = Vector2(COLS[i], 0)
		else:
			x.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			x.clip_text = true
			x.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		h.add_child(x)
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(0, 0, 0, 0), UI.ROWLINE, 0, 0, 0, 6))
	p.add_child(h)
	return p
