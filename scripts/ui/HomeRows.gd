extends RefCounted
## S394 HOME's roster: one row per fighter, read across: form, rank, next fight, weight, condition, this week.

const UI := preload("res://scripts/ui/UI.gd")
const HomeLook := preload("res://scripts/ui/HomeLook.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

const FACE := Vector2(84, 84)
const FORM_SHOWN := 5
const FORM_MIN := 3
const WEIGHT_WATCH_DAYS := 14   # over the limit only matters this close to the scales
const W := {"fighter": 276.0, "form": 138.0, "rank": 58.0, "next": 204.0, "weight": 92.0, "cond": 130.0}


static func build(main: Node, c: Career) -> Control:
	var card := UI.card("YOUR FIGHTERS")
	var v: VBoxContainer = card[1]
	card[0].name = "Fighters"
	if c.fighters.is_empty() and c.grapplers.is_empty():
		v.add_child(_header())
		v.add_child(HomeLook.rule())
		v.add_child(UI.label("Your signed boxers show here: their record, next fight, weight and week.", UI.BODY, UI.MUTED))
		return card[0]
	v.add_child(_header())
	v.add_child(HomeLook.rule())
	for f in c.fighters:
		v.add_child(_row(main, c, f))
		v.add_child(HomeLook.rule())
	for g in c.grapplers:
		v.add_child(_mat_row(main, c, g))
		v.add_child(HomeLook.rule())
	return card[0]


static func _cell(key: String, child: Control) -> Control:
	child.custom_minimum_size.x = W[key]
	child.size_flags_horizontal = Control.SIZE_FILL   # a wrapping label asks to expand, which pulls the row off the header
	child.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return child


static func _header() -> HBoxContainer:
	var h := UI.hbox(12)
	for x in [["fighter", "Fighter"], ["form", "Record"], ["rank", "Rank"], ["next", "Next"], ["weight", "Weight"], ["cond", "Freshness"]]:
		h.add_child(_cell(str(x[0]), UI.label(str(x[1]), 17, UI.MUTED)))
	h.add_child(UI.label("This week", 17, UI.MUTED))
	return h


static func _who(main: Node, f: Dictionary, line: String) -> Control:
	var h := UI.hbox(14)
	var face := HomeLook.face(Faces.stem(f), FACE)
	if face != null:
		h.add_child(face)
	var v := UI.vbox(0)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	var name := UI.button(str(f["name"]), "Link", main.act.bind("fighter", str(f["id"])))
	name.alignment = HORIZONTAL_ALIGNMENT_LEFT
	v.add_child(name)
	v.add_child(UI.label(line, 16, UI.MUTED))
	h.add_child(v)
	return h


static func _row(main: Node, c: Career, f: Dictionary) -> Control:
	var h := UI.hbox(12)
	h.name = "Row_" + str(f["id"])
	var camp := "" if (f["camp"] as Dictionary).is_empty() else ", in camp"
	h.add_child(_cell("fighter", _who(main, f, "%s%s" % [str(f["wc"]), camp])))
	h.add_child(_cell("form", _form(c, f)))
	var rank := int(f.get("rank", 0))
	h.add_child(_cell("rank", UI.label(ordinal(rank) if rank > 0 else "-", UI.BODY, UI.FG if rank > 0 else UI.MUTED, "semi")))
	h.add_child(_cell("next", UI.label(next_text(c, f), 18, UI.FG, "semi", true)))
	h.add_child(_cell("weight", _weight(c, f)))
	h.add_child(_cell("cond", _condition(c, f)))
	var week := UI.label(week_text(f), 18, UI.FG, "body", true)
	week.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	week.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(week)
	return h


## A no-gi athlete has belts and opens, not ranks and bouts: the row says what is true for her.
static func _mat_row(main: Node, c: Career, g: Dictionary) -> Control:
	var h := UI.hbox(12)
	h.name = "Row_" + str(g["id"])
	h.add_child(_cell("fighter", _who(main, g, "No-gi")))
	h.add_child(_cell("form", UI.label("%s belt" % str(g.get("belt", "white")).capitalize(), 18, UI.FG, "semi")))
	h.add_child(_cell("rank", UI.label("-", 18, UI.MUTED)))
	var opens := NoGi.opens_after(c.day, 1)
	var next := "No open"
	if not opens.is_empty():
		var d := int(opens[0]["d"])
		next = "%s, %s" % [str(opens[0]["name"]), "today" if d == c.day else Clock.fmt(d)]
	h.add_child(_cell("next", UI.label(next, 18, UI.FG, "semi", true)))
	h.add_child(_cell("weight", UI.label("-", 18, UI.MUTED)))
	h.add_child(_cell("cond", UI.label("-", 18, UI.MUTED)))
	var week := UI.label("Mat work", 18, UI.FG)
	week.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(week)
	return h


static func ordinal(n: int) -> String:
	var tail := n % 100
	if tail >= 11 and tail <= 13:
		return "%dth" % n
	return "%d%s" % [n, {1: "st", 2: "nd", 3: "rd"}.get(n % 10, "th")]


static func next_text(c: Career, f: Dictionary) -> String:
	if Injuries.out(c, f):
		return "Out injured"
	var fb: Dictionary = f["bout"]
	if fb.has("opp") and fb.has("day"):
		var days := int(fb["day"]) - c.day
		return "%s, %s" % [str(fb["opp"]["name"]), "%d days" % days if days > 1 else ("tomorrow" if days == 1 else "tonight")]
	var open := open_offers(f)
	if not open.is_empty():
		return "1 offer waiting" if open.size() == 1 else "%d offers waiting" % open.size()
	return "No fight booked"


## The offers Needs asks about (a mismatch is not one: it waits on the Fights page), so HOME's counts agree.
static func open_offers(f: Dictionary) -> Array:
	return (f["offers"] as Array).filter(func(o): return not bool(o["answered"]) and not bool(o["mismatch"]))


## The sessions on most days of this week's real plan, the same days the news line reads from.
static func week_text(f: Dictionary) -> String:
	var count := {}
	for d in WeekPlan.days_of(f):
		var id := str((d as Array)[0])
		if id != "rest":
			count[id] = int(count.get(id, 0)) + 1
	var ids: Array = count.keys()
	ids.sort_custom(func(a, b): return int(count[a]) > int(count[b]))
	if ids.is_empty():
		return "Rest"
	var words: Array = []
	for id in ids.slice(0, 3):
		words.append(str(WeekPlan.session(id).get("name", id)).to_lower())
	var line := ", ".join(PackedStringArray(words))
	return line.substr(0, 1).to_upper() + line.substr(1)


static func _form(c: Career, f: Dictionary) -> Control:
	var v := UI.vbox(3)
	v.add_child(UI.label(past_record(f), 18, UI.FG, "semi"))
	var h := UI.hbox(3)
	var mine: Array = c.results.filter(func(r): return str(r.get("fid", "")) == str(f["id"])).slice(0, FORM_SHOWN)
	if mine.size() < FORM_MIN:   # one or two chips say nothing the record does not
		return v
	v.add_child(h)
	mine.reverse()   # results are newest first; the form reads left to right, latest last
	for r in mine:
		var win := bool(r["win"])
		var chip := PanelContainer.new()
		chip.add_theme_stylebox_override("panel", UI.box(UI.GREEN if win else UI.RED, Color(0, 0, 0, 0), 3, 0, 0, 0))
		chip.custom_minimum_size = Vector2(22, 22)
		var l := UI.label("W" if win else "L", 13, Color.WHITE if win else Color.WHITE, "bold")
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		chip.add_child(l)
		h.add_child(chip)
	return v


static func past_record(f: Dictionary) -> String:
	var pro := bool(f.get("pro", false)) and int(f.get("pro_w", 0)) + int(f.get("pro_l", 0)) > 0   # before the debut: the amateur record
	var w := int(f.get("pro_w" if pro else "w", 0))
	var l := int(f.get("pro_l" if pro else "l", 0))
	if w + l == 0:
		return "No fights"
	return "%d and %d" % [w, l] if pro or not bool(f.get("pro", false)) else "%d and %d amateur" % [w, l]


static func _weight(c: Career, f: Dictionary) -> Control:
	var v := UI.vbox(0)
	var over := float(f["weight"]) - float(f["limit"])
	var fb: Dictionary = f["bout"]
	var near: bool = fb.has("day") and int(fb["day"]) - c.day <= WEIGHT_WATCH_DAYS
	v.add_child(UI.label("%.1f kg" % float(f["weight"]), 18, UI.AMBER if over > 0.0 and near else UI.FG, "semi"))
	v.add_child(UI.label("%.1f to lose" % over if over > 0.0 else "On weight", 15, UI.MUTED))
	return v


static func _condition(c: Career, f: Dictionary) -> Control:
	var v := UI.vbox(3)
	var fit := 100 - int(FighterProfile.fatigue(f))
	var col: Color = UI.GREEN if fit >= 50 else (UI.AMBER if fit >= 25 else UI.RED)
	v.add_child(UI.label(str(fit), 18, UI.FG, "semi"))
	var bar: Control = UI.meter(fit / 100.0, col, [], 96.0)
	v.add_child(bar)
	if Injuries.out(c, f) or Injuries.pending(f):
		var l := UI.label(Injuries.line(c, f), 15, UI.AMBER, "semi", true)
		l.max_lines_visible = 2
		l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		v.add_child(l)
	return v
