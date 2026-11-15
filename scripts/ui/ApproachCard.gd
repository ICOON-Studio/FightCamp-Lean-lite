extends RefCounted
## S487 R58 APPROACHWIRE1 (map ops/research/R58_MAP_S439.md section 7, "Fighter page > Overview"): the approach card at the
## top of the boxer's Overview while a rival club's approach waits.
## S494 (his Q-253 "Build it", mockup docs/mockups/s493/overview/overview_C2.png - option C made simpler): THREE answers
## (MATCH IT, HALF EACH, LET THEM GO), each saying what happens to the boxer, one loyalty bar (white mark = 50, where the
## boxer stops looking around) and what it costs; the talk is one button above them. MOVE and PROMISE stay in the rules
## (Approach.answers) but leave the card.
## Names only in the header (S448). A grey answer says why on screen, in the line under it.
## Also the Overview's "Let go" (map M7: Leaving.let_go_price's confirm) and the actions: approach (open the Overview),
## approachtalk, approachanswer (a confirm) -> approachdo, letgo (a confirm) -> letgodo.
## Fills a panel the caller makes (DarkOverview.panel): no preload of DarkOverview (it preloads this file).

const Palette := preload("res://scripts/ui/Palette.gd")   # S493 Q-251 the one palette
const UI := preload("res://scripts/ui/UI.gd")
const Approach := preload("res://scripts/rules/Approach.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const Leaving := preload("res://scripts/state/Leaving.gd")

const INK := Palette.TEXT
const SOFT := Palette.MUTED
const HEAD := Palette.HEADER
const RED := Palette.BAD
const AMBER := Palette.WARN
const GREEN := Palette.GOOD
const ON_CARD := ["match", "half", "let_go"]   # his Q-253: three answers


## The before -> after loyalty bar: what the boxer has (grey), what the answer adds (green), the white mark at 50.
class Gain extends Control:
	var from := 0.0
	var to := 0.0
	var mark := 0.5

	func _init() -> void:
		custom_minimum_size = Vector2(200, 20)
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var w: float = size.x
		var h: float = size.y
		draw_rect(Rect2(0, 0, w, h), Palette.PAGE)
		var a: float = clampf(minf(from, to), 0.0, 1.0) * w
		var b: float = clampf(maxf(from, to), 0.0, 1.0) * w
		draw_rect(Rect2(0, 0, a, h), Palette.MUTED)
		if b > a:
			draw_rect(Rect2(a, 0, b - a, h), Palette.GOOD_FILL if to >= from else Palette.BAD_FILL)
		var x: float = clampf(mark, 0.0, 1.0) * w
		draw_line(Vector2(x, -3), Vector2(x, h + 3), Palette.TEXT, 3.0)


static func _she(f: Dictionary) -> String:
	return "he" if Faces.sex(f) == "m" else "she"


static func _cap(s: String) -> String:
	return s.substr(0, 1).to_upper() + s.substr(1)


## The card's rows, in order (also what the tests read): {head, due, offer, talk, talk_button, cols: [{id, word, outcome,
## leaves, from, to, lines, available, why}]}.
static func view(c: Career, f: Dictionary) -> Dictionary:
	var a: Dictionary = f["approach"]
	var she := _she(f)
	var now := Loyalty.value(f)
	var cols: Array = []
	for col in ApproachWire.columns(c, f):
		var id := str(col["id"])
		if not ON_CARD.has(id):
			continue
		var leaves := id == "let_go"
		cols.append({"id": id, "word": str(Approach.BUTTON_WORDS[id]),
			"outcome": _cap(she) + (" leaves Monday" if leaves else " stays"), "leaves": leaves,
			"from": now, "to": now if leaves else int(col["loyalty_end"]), "lines": _lines(c, f, col),
			"available": bool(col["available"]), "why": str(col["why_not"])})
	var ends := int(a["ends"])
	var left := maxi(0, ends - c.day)
	return {"head": "%s WANTS %s" % [ApproachWire.CLUB.to_upper(), str(f["name"]).to_upper()],
		"due": "Answer by %s · %d day%s" % [Clock.fmt(ends), left, "" if left == 1 else "s"],
		"offer": "%s. No answer: %s leaves. The white mark on each bar is 50: at 50 %s stops looking around." % [a["line"], she, she],
		"talk": _talk_line(c, f), "talk_button": "Talk to %s first" % ("him" if she == "he" else "her"), "cols": cols}


static func _lines(c: Career, f: Dictionary, col: Dictionary) -> Array:
	var id := str(col["id"])
	var out: Array = []
	if id == "let_go":
		out.append({"t": "No cash", "bad": false})
		var rk := Leaving.ranked(c, f)
		out.append({"t": "Reputation %d" % (Leaving.REP_LEAVE_RANKED if rk else Leaving.REP_LEAVE), "bad": true})
		out.append({"t": "Team-mates under %d lose %d loyalty" % [Loyalty.SETTLED_AT, -int(Loyalty.MOVES["teammate_left"])], "bad": true})
		return out
	var cash := int(col["cash"])
	if cash == 0:
		out.append({"t": "No cash", "bad": false})
	else:
		out.append({"t": "%s a week for 12 weeks (%s)" % [UI.money(Approach.STIPEND), UI.money(-cash)], "bad": true})
	if id == "match" and int(col["locked_to"]) >= 0:
		out.append({"t": "Locked for 12 weeks", "bad": false})
	if id == "half" and int(col["holder_end"]) >= 0:
		var h := c.fighter_by_id(str(f["approach"].get("holder", "")))
		var hb := Loyalty.value(h) if not h.is_empty() else int(col["holder_end"])
		out.append({"t": "Team-mate's stipend halves: their loyalty %d → %d" % [hb, int(col["holder_end"])], "bad": true})
		out.append({"t": "Both train at %d%% for 12 weeks" % roundi(float(col["train"]) * 100.0), "bad": true})
	return out


static func _talk_line(c: Career, f: Dictionary) -> String:
	var talk := str(f["approach"]["talk"])
	if talk == "landed":
		return "The talk landed: HALF EACH counts in full (+%d)." % int(Approach.GAIN["half_landed"])
	if talk == "failed":
		return "The talk failed: loyalty %d and HALF EACH closed." % Approach.TALK_FAILED
	if not Loyalty.can_tell_straight(f, c.day):
		return "Talked in the last 8 weeks: no talk this time."
	var n := roundi(Approach.talk_chance(ApproachWire.coachability(f)) * 10.0)
	return "%d in 10 it lands: HALF EACH counts in full (+%d, not +%d). If it fails: %d and HALF EACH closes." % [
		n, int(Approach.GAIN["half_landed"]), int(Approach.GAIN["half"]), Approach.TALK_FAILED]


## Fills `card` ([panel, vbox] from DarkOverview.panel) and returns the panel.
static func fill(card: Array, main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var v := view(c, f)
	var box: VBoxContainer = card[1]
	card[0].name = "ApproachCard"
	var top := UI.hbox(12)
	var head := UI.label("⚠ " + str(v["head"]), 26, RED, "bold")
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(head)
	top.add_child(UI.label(str(v["due"]), UI.BODY, INK, "bold"))
	box.add_child(top)
	box.add_child(UI.label(str(v["offer"]), 16, SOFT, "body", true))
	var talk_row := UI.hbox(14)
	if str(f["approach"]["talk"]) == "" and Loyalty.can_tell_straight(f, c.day):
		var tb := UI.button(str(v["talk_button"]).to_upper(), "Btn", main.act.bind("approachtalk", str(f["id"])))
		tb.name = "Btn_approachtalk"
		talk_row.add_child(tb)
	var tl := UI.label(str(v["talk"]), UI.BODY, INK, "semi", true)
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	talk_row.add_child(tl)
	box.add_child(talk_row)
	var row := UI.hbox(14)
	for col in v["cols"]:
		row.add_child(_column(main, f, col))
	box.add_child(row)
	return card[0]


static func _column(main: Node, f: Dictionary, col: Dictionary) -> Control:
	var open := bool(col["available"])
	var tile := PanelContainer.new()
	tile.name = "Answer_" + str(col["id"])
	tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := StyleBoxFlat.new()
	sb.bg_color = Palette.TILE
	sb.set_corner_radius_all(6)
	sb.set_content_margin_all(14)
	tile.add_theme_stylebox_override("panel", sb)
	var cv := UI.vbox(6)
	tile.add_child(cv)
	var b := UI.button(str(col["word"]), "Btn", main.act.bind("approachanswer", "%s|%s" % [f["id"], col["id"]]), not open, str(col["why"]))
	b.name = "Btn_approach_" + str(col["id"])
	cv.add_child(b)
	var leaves := bool(col["leaves"])
	cv.add_child(UI.label(str(col["outcome"]), 24, (RED if leaves else GREEN) if open else SOFT, "bold"))
	if not leaves:
		var lr := UI.hbox(4)
		lr.add_child(UI.label("Loyalty %d → " % int(col["from"]), UI.BODY, INK if open else SOFT, "semi"))
		lr.add_child(UI.label("%d" % int(col["to"]), UI.BODY, GREEN if open else SOFT, "bold"))
		cv.add_child(lr)
		var g := Gain.new()
		g.from = float(col["from"]) / 100.0
		g.to = float(col["to"]) / 100.0
		g.mark = Loyalty.SETTLED_AT / 100.0
		g.modulate.a = 1.0 if open else 0.45
		cv.add_child(g)
	for line in col["lines"]:
		var bad := bool(line["bad"])
		cv.add_child(UI.label(("▼ " if bad else "") + str(line["t"]), 16, (RED if bad else INK) if open else SOFT, "semi", true))
	if not open:
		cv.add_child(UI.label("Not open: " + str(col["why"]), 16, AMBER, "semi", true))
	return tile


## The Overview's Let go button: greyed with its reason (Leaving.let_go_price).
static func let_go_button(main: Node, c: Career, f: Dictionary) -> Button:
	var p := Leaving.let_go_price(c, str(f["id"]))
	var b := UI.button("Let go", "Btn", main.act.bind("letgo", str(f["id"])), str(p["why_not"]) != "", str(p["why_not"]))
	b.name = "Btn_letgo"
	return b


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"approach":
			main.nav({"area": "fighters", "tab": 0, "fighter": arg, "ftab": 0})
		"approachtalk":
			var r := ApproachWire.talk(c, arg)
			main.toast(("The talk landed." if bool(r["landed"]) else "The talk failed: loyalty -4.") if bool(r["ok"]) else "No talk: %s." % r["why"])
			main.render()
		"approachanswer":
			var kv := arg.split("|")
			var f := c.fighter_by_id(kv[0])
			var body := "%s: %s?" % [Approach.BUTTON_WORDS.get(kv[1], kv[1]), _confirm_text(kv[1])]
			main.open_modal({"type": "info", "title": "%s's answer to %s" % [f.get("first", ""), ApproachWire.CLUB], "body": body,
				"buttons": [["Yes", "approachdo", arg], ["No", "close", ""]]})
		"approachdo":
			var kv2 := arg.split("|")
			main.close_modal()
			var why := ApproachWire.answer(c, kv2[0], kv2[1])
			main.toast("Done." if why == "" else "Not possible: %s." % why)
			main.render()
		"letgo":
			var p := Leaving.let_go_price(c, arg)
			if str(p["why_not"]) != "":
				main.toast("Not now: %s." % p["why_not"])
				return true
			var f2 := c.fighter_by_id(arg)
			main.open_modal({"type": "info", "title": "Let %s go?" % f2.get("first", ""),
				"body": "Free in cash; the place frees for a trial. Reputation %d. Team-mates under 50 loyalty lose 2." % int(p["rep"]),
				"buttons": [["Let go", "letgodo", arg], ["Keep", "close", ""]]})
		"letgodo":
			main.close_modal()
			var r2 := Leaving.let_go(c, arg)
			main.toast(str(r2.get("line", "Gone.")))
			main.nav({"area": "fighters", "tab": 0, "fighter": "", "bout": ""})
		_:
			return false
	return true


static func _confirm_text(id: String) -> String:
	match id:
		"match":
			return "pay what they offer, held for 12 weeks"
		"half":
			return "split the stipend in two for 12 weeks; both train a little less"
		"move":
			return "the stipend moves now; the team-mate takes a day job"
		"promise":
			return "book the club show now and put the boxer on top of it; a missed night and the boxer goes"
		"let_go":
			return "the boxer leaves next Monday"
	return ""
