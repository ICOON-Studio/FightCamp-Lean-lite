extends RefCounted
## OFFICEV2 (S538, owner Q-S294-302: "the office needs a something like a goals tab to see what is pending what each fighter
## wants , probably fit it in the dashboard"; mockup ops/previews/s538_look/office_goals.png; C475 "tooltip on goals give
## some tips"). The dashboard's GOALS panel: the reads are pure (nothing changes the career), panel() draws them.
##   pending(c)  the club's dated things, soonest first: [{kind, icon, t, sub, day, days, done, tip, act, arg}]
##   wants(c)    one row a fighter: [{id, name, sub, face, want, target, share (-1 = no bar), status, tone, by, by_day,
##               by_sub, miss, met, tip {title, what, rows, do}, act, arg}] - the tip's `do` is what to do this week
##   panel(main, c)  the card "GoalsPanel": rows "Pending_<i>" and "Want_<fighter id>"
## Only what the game tracks: a mood has one number (no list of reasons) and a belt has no by-date, so neither is drawn.

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const Tip := preload("res://scripts/ui/Tip.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const Promises := preload("res://scripts/rules/Promises.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")
const CashForecast := preload("res://scripts/rules/CashForecast.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const MAX_PENDING := 5
const MAX_WANTS := 4
const STATUS := {"MET": ["MET", "g"], "ON_TRACK": ["ON TRACK", "g"], "AT_RISK": ["AT RISK", "a"], "OFF_TRACK": ["OFF TRACK", "r"],
	"MISSED": ["MISSED", "r"]}
const TONE := {"r": Palette.BAD_FILL, "a": Palette.WARN, "g": Palette.GOOD_FILL, "b": Palette.ACCENT, "m": Palette.TILE}
const W_WHO := 190
const W_FAR := 132
const W_BY := 90
const W_MISS := 132


static func pending(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		var cls := "the %s" % str(f["wc"]).to_lower()
		for o in f["offers"]:
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				out.append(_item("offer", "offer", "Bout offer ends", "%s · %s" % [Clock.fmt(int(o["expires"])), cls], int(o["expires"]),
					c.day, "Answer it before the day ends: See the offer.", "openBout", str(o["id"])))
		var fb: Dictionary = f["bout"]
		if fb.has("day") and not bool(fb.get("done", false)):
			var bd := int(fb["day"])
			out.append(_item("bout", "hands", "Bout, %s" % cls, "%s · fight week from %s" % [Clock.fmt(bd), Clock.fmt(bd - 7)], bd, c.day,
				"Set the week before it on the Training page.", "fighter", str(f["id"])))
	var split: Dictionary = CashForecast.bill_split(CashForecast.project(c, 8))
	out.append(_item("bills", "money", "Bills due", "%s · month bill %s" % [Clock.fmt(GameMoney.next_bill_day(c.day)),
		GameMoney.text(int(split["amount"]))], GameMoney.next_bill_day(c.day), c.day, "Keep that much in the tin: Finance shows the weeks.",
		"go", "money:0"))
	for e in Champs.calendar(c):
		if str(e["t"]) == "Nationals entries close":
			var n := c.fighters.filter(func(x): return Champs.active(x)).size()
			out.append(_item("champs", "champion", "Nationals entries close", "%s · %s" % [Clock.fmt(int(e["d"])),
				"nobody entered" if n == 0 else "%d entered" % n], int(e["d"]), c.day,
				"Right-click a boxer on the Fighters sheet to enter.", "go", "world:2"))
			break
	for g in c.grapplers:
		for d in g.get("entered", []):
			var it := _item("open", "mat", "No-gi open", "%s · the grappler is entered" % Clock.fmt(int(d)), int(d), c.day,
				"Nothing to answer: the entry is in.", "fighter", str(g["id"]))
			it["done"] = true
			out.append(it)
	if int(c.show.get("day", -1)) >= 0:
		out.append(_item("show", "members", "Our club show", "%s · the gym hosts the bouts" % Clock.fmt(int(c.show["day"])), int(c.show["day"]),
			c.day, "Fill the card before the night: the Fights page.", "go", "fights:0"))
	out = out.filter(func(x): return int(x["day"]) >= c.day)
	out.sort_custom(func(a, b): return int(a["day"]) < int(b["day"]))
	return out.slice(0, MAX_PENDING)


static func _item(kind: String, icon: String, t: String, sub: String, day: int, today: int, todo: String, act: String, arg: String) -> Dictionary:
	return {"kind": kind, "icon": icon, "t": t, "sub": sub, "day": day, "days": day - today, "done": false, "tip": todo, "act": act, "arg": arg}


static func wants(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		out.append(_boxer(c, f))
	for g in c.grapplers:
		out.append(_grappler(c, g))
	return out


static func _boxer(c: Career, f: Dictionary) -> Dictionary:
	var id := str(f["id"])
	var pro := bool(f.get("pro", false))
	var row := {"id": id, "name": str(f["name"]), "face": Faces.stem(f), "act": "fighter", "arg": id, "share": -1.0, "by_day": -1,
		"sub": "%s %d kg · %d-%d" % [str(f["wc"]).replace("weight", ""), roundi(float(f["limit"])),
			int(f.get("pro_w" if pro else "w", 0)), int(f.get("pro_l" if pro else "l", 0))]}
	var g: Dictionary = Sim.goal_read(c, f)
	var open: Array = Promises.open_for(c.promises, id)
	var talk := bool(f.get("goal_talk", false))
	if not g.is_empty():
		var st: Array = STATUS.get(str(g["code"]), ["OFF TRACK", "r"])
		var parts: Array = []
		for t in g["targets"]:
			if str(t["key"]) == "booked_fight":
				parts.append("bout booked" if bool(t["met"]) else "no bout")
			else:
				parts.append(str(t["line"]).to_lower())
		for pr in open:
			parts.append("promised: %s" % _low(Promises.line(pr, Clock.fmt(int(pr.get("by_day", 0))))))
		row.merge({"want": str(g["title"]), "target": " · ".join(parts), "share": clampf(float(g["share"]), 0.0, 1.0),
			"status": str(st[0]), "tone": str(st[1]), "by_day": c.day + int(g["days_left"]),
			"miss": "mood %d" % FighterGoal.FAILURE_MORALE_DELTA, "met": "met: mood +%d" % FighterGoal.SUCCESS_MORALE_DELTA,
			"tip": _goal_tip(c, f, g)}, true)   # true: by_day and share overwrite the row's defaults
	elif not open.is_empty():
		var p: Dictionary = open[0]
		var kind := str(p.get("kind", ""))
		var dated := kind != Promises.TURN_PRO
		var when := Clock.fmt(int(p.get("by_day", 0)))
		var todo := "Take the pro offer when it comes: Needs you shows it."
		if kind == Promises.SHOW_TOP:
			todo = "Book the club show before %s: the Finance page." % when
		elif kind == Promises.NO_SIGNING:
			todo = "Sign nobody in this class before %s." % when
		row.merge({"want": "Promised: %s" % _low(Promises.line(p, when)).get_slice(" on ", 0).get_slice(" before ", 0),
			"target": "no goal set: goal talk waiting" if talk else "no goal set", "status": "OPEN PROMISE", "tone": "a",
			"by_day": int(p["by_day"]) if dated else -1, "miss": "loyalty %d" % Promises.BROKEN, "met": "kept: loyalty +%d" % Promises.KEPT,
			"tip": {"title": "A promise you made", "what": "Your word to this boxer, still open.",
				"rows": [["Kept", "loyalty +%d" % Promises.KEPT, "", "good"], ["Broken", "loyalty %d" % Promises.BROKEN, "", "bad"]], "do": todo}}, true)
	else:
		row.merge({"want": "No goal set", "target": "goal talk waiting in the office" if talk else "nothing asked of the club yet",
			"status": "GOAL TALK" if talk else "NO GOAL", "tone": "a" if talk else "m", "miss": "nothing lost", "met": "",
			"tip": {"title": "No goal yet", "what": "A goal gives the boxer something to train for.",
				"do": "Hold the goal talk today: click this row." if talk else "Wait for the talk: Needs you shows it when it is due."}})
	if talk and g.is_empty():
		row["act"] = "goaltalk"
	row["by"] = _days(int(row["by_day"]) - c.day) if int(row["by_day"]) >= 0 else "no date"
	row["by_sub"] = Clock.fmt(int(row["by_day"])) if int(row["by_day"]) >= 0 else ""
	return row


## C475: the goal's tip - its targets as rows, and the one thing to do this week for the target furthest behind.
static func _goal_tip(c: Career, f: Dictionary, g: Dictionary) -> Dictionary:
	var left := int(g["days_left"])
	var by := Clock.fmt(c.day + left)
	var rows: Array = []
	var todo := ""
	var weak := false
	for t in g["targets"]:
		var key := str(t["key"])
		var met := bool(t["met"])
		var behind := str(t.get("status", "")) != "ON_TRACK" and not met
		var mine := ""
		if key == "booked_fight":
			rows.append(["Bout booked", "yes" if met else "not yet", "", "good" if met else "bad"])
			var offer: Dictionary = RosterRow._open_offer(f)
			mine = "Ask for a bout before %s: the Fights page." % by if offer.is_empty() \
				else "Answer the open offer before %s: the Fights page." % Clock.fmt(int(offer["expires"]))
		else:
			var word := str(t["label"])
			var week := float((g["rate"] as Dictionary).get(key, 0.0)) * 7.0
			rows.append([word, "%.1f of %.1f" % [float(t["current"]), float(t["target"])], "+%.1f a week" % week, "good" if not behind else "bad"])
			mine = "Put more of the week on %s: the Training page." % word.to_lower() if behind \
				else "Keep this week's training: %s gets there by %s." % [word.to_lower(), by]
		if not met and (todo == "" or (behind and not weak)):
			todo = mine
			weak = behind
	if todo == "":
		todo = "Hold the course: every target is met."
	return {"title": str(g["title"]), "what": "What this boxer asked the club for.", "rows": rows.slice(0, Tip.MAX_ROWS), "do": todo}


static func _grappler(c: Career, g: Dictionary) -> Dictionary:
	var id := str(g["id"])
	var nxt := BeltRoad.next_belt(str(g.get("belt", "white")))
	var r: Dictionary = BeltRoad.readiness(g, g.get("bjj", {}), c.day)
	var mat: Array = r["mat"]
	var moves: Array = r["moves"]
	var row := {"id": id, "name": str(g["name"]), "face": Faces.stem(g), "act": "fighter", "arg": id, "by_day": -1, "by": "no date", "by_sub": "",
		"sub": "No-gi %s · %d-%d" % [str(g["wc"]).get_slice(" ", 0).replace("weight", "").to_lower(), int(g.get("w", 0)), int(g.get("l", 0))],
		"miss": "nothing lost", "met": "", "tone": "b"}
	if nxt == "":
		row.merge({"want": "Top belt", "target": "no belt left to earn", "share": 1.0, "status": "DONE",
			"tip": {"title": "Top belt", "what": "The last belt on the road is earned.", "do": "Enter the opens: the wins are what count now."}})
		return row
	var mat_short := float(mat[0]) / maxf(1.0, float(mat[1])) <= float(moves[0]) / maxf(1.0, float(moves[1]))
	var todo := "Keep the mat classes in the week: they are the short side." if mat_short else "Drill the belt's moves on the mat: the Playbook."
	if bool(r["ready"]):
		todo = "Hold the grading: the belt is ready on the fighter page."
	var rows: Array = [["Mat classes", "%d of %d" % [int(mat[0]), int(mat[1])], "", "good" if not mat_short else "bad"],
		["Moves owned", "%d of %d" % [int(moves[0]), int(moves[1])], "", "good" if mat_short else "bad"]]
	if int(r["days_left"]) > 0:
		rows.append(["Time at this belt", "%d days more" % int(r["days_left"]), "", ""])
	row.merge({"want": "%s belt" % nxt.capitalize(), "target": "mat classes %d / %d · moves %d / %d" % [int(mat[0]), int(mat[1]),
		int(moves[0]), int(moves[1])], "share": clampf(float(r["share"]), 0.0, 1.0), "status": "READY" if bool(r["ready"]) else "BUILDING",
		"tip": {"title": "%s belt" % nxt.capitalize(), "what": "The next belt: mat classes and owned moves.", "rows": rows, "do": todo}})
	return row


static func _days(n: int) -> String:
	return "today" if n <= 0 else "%d day%s" % [n, "" if n == 1 else "s"]


static func _low(s: String) -> String:
	return s.left(1).to_lower() + s.substr(1)


## ---------- the panel ----------

static func panel(main: Node, c: Career) -> Control:
	var p := PanelContainer.new()
	p.name = "GoalsPanel"
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(Palette.CARD, Palette.HEADER, 10, 2, 16, 12))
	var v := UI.vbox(8)
	p.add_child(v)
	var head := UI.hbox(10)
	head.add_child(UI.label("GOALS", 20, Palette.HEADER, "caps"))
	head.add_child(UI.label("what is pending, and what each fighter wants", 16, Palette.MUTED, "semi"))
	v.add_child(head)
	var h := UI.hbox(22)
	v.add_child(h)
	var left := UI.vbox(4)
	left.custom_minimum_size = Vector2(336, 0)
	left.add_child(UI.label("THE CLUB, PENDING", 16, Palette.MUTED, "caps"))
	var pend := pending(c)
	for i in pend.size():
		left.add_child(_pending_row(main, pend[i], i))
	h.add_child(left)
	var right := UI.vbox(4)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(right)
	var cols := UI.hbox(10)
	for col in [["FIGHTER", W_WHO], ["WANTS", 0], ["HOW FAR", W_FAR], ["BY", W_BY], ["IF IT IS MISSED", W_MISS]]:
		var hl := UI.label(str(col[0]), 16, Palette.MUTED, "caps")
		_w(hl, int(col[1]))
		cols.add_child(hl)
	right.add_child(cols)
	var all := wants(c)
	if all.is_empty():
		right.add_child(UI.label("No fighters yet: a goal comes with the first boxer signed.", 16, Palette.MUTED))
	for w in all.slice(0, MAX_WANTS):
		right.add_child(_want_row(main, w))
	if all.size() > MAX_WANTS:
		right.add_child(UI.label("and %d more: the Fighters icon opens the whole sheet" % (all.size() - MAX_WANTS), 16, Palette.MUTED))
	return p


static func _pending_row(main: Node, x: Dictionary, i: int) -> Control:
	var p := _row("Pending_%d" % i, main, str(x["act"]), str(x["arg"]))
	var h := UI.hbox(10)
	p.add_child(h)
	var done := bool(x["done"])
	h.add_child(KitIcon.icon(str(x["icon"]), 22, Palette.GOOD if done else Palette.HEADER))
	var tx := UI.vbox(0)
	tx.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tx.add_child(_clip(UI.label(str(x["t"]), 16, Palette.TEXT, "bold")))
	tx.add_child(_clip(UI.label(str(x["sub"]), 16, Palette.MUTED)))
	h.add_child(tx)
	var days := int(x["days"])
	var tone := "g" if done else ("r" if str(x["kind"]) == "bout" else ("a" if days <= 7 else "m"))
	h.add_child(_chip(_days(days), tone))
	Tip.short(p, str(x["t"]), "%s, %s." % [_days(days).capitalize() if days <= 0 else "In " + _days(days), Clock.fmt(int(x["day"]))], str(x["tip"]))
	return p


static func _want_row(main: Node, w: Dictionary) -> Control:
	var p := _row("Want_" + str(w["id"]), main, str(w["act"]), str(w["arg"]))
	var h := UI.hbox(10)
	p.add_child(h)
	var who := UI.hbox(8)
	_w(who, W_WHO)
	var pic: Control = PromoShot.picture(str(w["face"]), Vector2(40, 46))
	if pic != null:
		who.add_child(pic)
	who.add_child(_two(str(w["name"]), str(w["sub"]), Palette.TEXT))
	h.add_child(who)
	h.add_child(_two(str(w["want"]), str(w["target"]), Palette.TEXT))
	var far := UI.vbox(3)
	_w(far, W_FAR)
	far.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var tone: Color = TONE.get(str(w["tone"]), Palette.TILE)
	if float(w["share"]) >= 0.0:
		var line := UI.hbox(8)
		var bar := Bar.new()
		bar.custom_minimum_size = Vector2(88, 10)
		bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		bar.track = Palette.PAGE
		bar.fill = tone
		bar.frac = float(w["share"])
		line.add_child(bar)
		line.add_child(UI.label("%d%%" % roundi(float(w["share"]) * 100.0), 16, Palette.TEXT, "mono"))
		far.add_child(line)
	var chip := _chip(str(w["status"]), str(w["tone"]))
	chip.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	far.add_child(chip)
	h.add_child(far)
	var by := _two(str(w["by"]), str(w["by_sub"]), Palette.TEXT if int(w["by_day"]) >= 0 else Palette.MUTED)
	_w(by, W_BY)
	h.add_child(by)
	var lost := str(w["miss"]) != "nothing lost"
	var miss := _two(str(w["miss"]), str(w["met"]), Palette.BAD if lost else Palette.MUTED)
	_w(miss, W_MISS)
	h.add_child(miss)
	Tip.explain(p, w["tip"])
	return p


## A clickable row: a hairline under it, the hand, a click runs the act the game already has.
static func _row(node_name: String, main: Node, act: String, arg: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = node_name
	var sb := UI.box(Palette.CLEAR, Palette.LINE, 0, 0, 2, 3)
	sb.border_width_top = 1
	p.add_theme_stylebox_override("panel", sb)
	p.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	p.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed and (ev as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
			main.act(act, arg))
	return p


static func _two(top: String, under: String, ink: Color) -> VBoxContainer:
	var v := UI.vbox(0)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	v.add_child(_clip(UI.label(top, 17, ink, "bold")))
	if under != "":
		v.add_child(_clip(UI.label(under, 16, Palette.MUTED)))
	return v


static func _chip(text: String, tone: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Chip"
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_theme_stylebox_override("panel", UI.box(TONE.get(tone, Palette.TILE), Palette.CLEAR, 4, 0, 7, 0))
	p.add_child(UI.label(text, 16, Palette.PAGE if tone in ["a", "b"] else Palette.TEXT, "bold"))
	return p


static func _w(n: Control, w: int) -> void:
	if w > 0:
		n.custom_minimum_size.x = float(w)
		n.size_flags_horizontal = Control.SIZE_FILL
	else:
		n.size_flags_horizontal = Control.SIZE_EXPAND_FILL


static func _clip(l: Label) -> Label:
	l.clip_text = true
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	return l
