extends RefCounted
## S394 HOME's right column: what happened since Monday and why, the club's week in money and members, what is coming.

const UI := preload("res://scripts/ui/UI.gd")
const HomeLook := preload("res://scripts/ui/HomeLook.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Champs := preload("res://scripts/state/Champs.gd")

const SINCE_SHOWN := 4
const NEWS_SCAN := 12
const BAD_NEWS := ["missed weight", "pulled out", "The bout is off"]
const BIG_NEWS := ["pro debut", "on debut", "turns pro", "medal", "champion", "Booked:"]
const COMING_SHOWN := 4


static func fill(col: Container, main: Node, c: Career, events: Array) -> void:
	var soon := _coming(c, events)
	if soon != null:
		col.add_child(soon)


## [{t, s, col}]: each fighter's biggest gain with its cause, injuries, rank moves; the news when no week has been read yet.
static func since_lines(c: Career) -> Array:
	var out: Array = []
	var since := since_day(c)
	var recent: Array = c.news.slice(0, NEWS_SCAN).filter(func(x): return int(x["d"]) >= since)
	for x in recent:   # a bout lost this week outranks a stat point
		if BAD_NEWS.any(func(w): return str(x["t"]).contains(w)):
			out.append({"t": str(x["t"]), "s": Clock.fmt(int(x["d"])), "col": UI.AMBER})
	var gains: Array = []
	for r in c.last_report.get("fighters", []):
		var first := str(r["name"]).get_slice(" ", 0)
		var hurt := str(r.get("injury", ""))
		if hurt != "":
			out.append({"t": "%s picked up an injury" % first, "s": hurt, "col": UI.AMBER})
		var rank: Dictionary = r.get("rank", {})
		if int(rank.get("move", 0)) != 0:
			var line := str(rank.get("text", ""))
			out.append({"t": "%s: %s%s" % [first, line.substr(0, 1).to_lower(), line.substr(1)], "s": "", "col": UI.MUTED})
		var best: Dictionary = {}
		for x in r["rows"]:
			if best.is_empty() or float(x["after"]) - float(x["before"]) > float(best["after"]) - float(best["before"]):
				best = x
		if not best.is_empty() and float(best["after"]) > float(best["before"]):
			gains.append({"t": _gain(first, best), "s": str((best.get("read", {}) as Dictionary).get("why", "")), "col": UI.GREEN})
	for x in recent:
		if BIG_NEWS.any(func(w): return str(x["t"]).contains(w)):
			out.append({"t": str(x["t"]), "s": Clock.fmt(int(x["d"])), "col": UI.GOLD})
	out += gains
	if out.size() < SINCE_SHOWN:
		for x in c.news.slice(0, SINCE_SHOWN):
			if int(x["d"]) >= since_day(c) and not out.any(func(o): return str(o["t"]) == str(x["t"])):
				out.append({"t": str(x["t"]), "s": Clock.fmt(int(x["d"])), "col": UI.MUTED})
	return out.slice(0, SINCE_SHOWN)


## The Monday the column starts from: this week's, or the one before on a Monday itself.
static func since_day(c: Career) -> int:
	var past := posmod(posmod(c.day, 7) - Clock.DAYS.find("Mon"), 7)
	return c.day - (past if past > 0 else 7)


static func _gain(first: String, x: Dictionary) -> String:
	var word := str(Sim.Data.LABEL.get(x["st"], x["st"])).to_lower()
	var a := float(x["before"])
	var b := float(x["after"])
	if int(round(a)) == int(round(b)):
		return "%s's %s went from %.1f to %.1f" % [first, word, a, b]
	return "%s's %s went from %d to %d" % [first, word, int(round(a)), int(round(b))]


static func _since(main: Node, c: Career) -> Control:
	var card := UI.card("SINCE LAST MONDAY")
	var v: VBoxContainer = card[1]
	card[0].name = "Since"
	var lines := since_lines(c)
	if lines.is_empty():
		v.add_child(UI.label("Nothing yet. Your first week is ahead of you.", 17, UI.MUTED, "body", true))
	for x in lines:
		v.add_child(_item(str(x["t"]), str(x["s"]), x["col"]))
	var all := UI.button("All news and mail (%d new)" % c.unread if c.unread > 0 else "All news and mail", "Ghost", main.act.bind("mail", ""))
	all.name = "AllNews"
	all.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(all)
	return card[0]


static func _item(t: String, s: String, col: Color) -> Control:
	var h := UI.hbox(10)
	var dot := Panel.new()
	dot.add_theme_stylebox_override("panel", UI.box(col, Color(0, 0, 0, 0), 5, 0, 0, 0))
	dot.custom_minimum_size = Vector2(10, 10)
	dot.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var drop := MarginContainer.new()
	drop.add_theme_constant_override("margin_top", 8)
	drop.add_child(dot)
	h.add_child(drop)
	var v := UI.vbox(0)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.label(t, 18, UI.FG, "semi", true))
	if s != "":
		v.add_child(UI.label(s, 16, UI.MUTED, "body", true))
	h.add_child(v)
	return h


static func _kv(k: String, value: String) -> Control:
	var h := UI.hbox(8)
	h.add_child(UI.label(k, 17, UI.MUTED))
	h.add_child(UI.spacer())
	h.add_child(UI.label(value, 18, UI.FG, "semi"))
	return h


static func _club(c: Career) -> Control:
	var card := UI.card("THE CLUB THIS WEEK")
	var v: VBoxContainer = card[1]
	card[0].name = "ClubWeek"
	v.add_child(_kv("Money in", UI.money(int(Sim.weekly_income(c)["total"]))))
	v.add_child(HomeLook.rule())
	v.add_child(_kv("Costs", UI.money(int(Sim.weekly_costs(c)["total"]))))
	v.add_child(HomeLook.rule())
	var delta := int(c.last_report.get("members_delta", 0))
	var move := "" if delta == 0 else (", up %d" % delta if delta > 0 else ", down %d" % -delta)
	v.add_child(_kv("Members", "%d%s" % [c.members, move]))
	v.add_child(HomeLook.rule())
	v.add_child(_kv("Coach", str(c.coach["name"]) if not c.coach.is_empty() else "None hired"))   # S394 operator: hired coaches show here too
	return card[0]


static func _coming(c: Career, events: Array) -> Control:
	var in_it := c.fighters.any(func(f): return Champs.active(f) or Champs.cannot_enter(c, f) == "")
	var soon := events.filter(func(e): return int(e["d"]) >= c.day and (in_it or str(e["kind"]) != "champ"))
	soon.sort_custom(func(a, b): return int(a["d"]) < int(b["d"]))
	if soon.is_empty():
		return null
	var card := UI.card("COMING UP")
	var v: VBoxContainer = card[1]
	card[0].name = "Coming"
	for e in soon.slice(0, COMING_SHOWN):
		var days := int(e["d"]) - c.day
		var when := "today" if days == 0 else ("tomorrow" if days == 1 else "in %d days" % days)
		var t := str(e["t"])
		v.add_child(_item(t.substr(0, 1).to_upper() + t.substr(1), "%s, %s" % [Clock.fmt(int(e["d"])), when], UI.MUTED))
	return card[0]
