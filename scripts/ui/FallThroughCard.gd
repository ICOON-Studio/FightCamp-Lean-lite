extends RefCounted
## S490 FIGHTWEEK3 piece 1 (map ops/research/FIGHTWEEK_SCREEN_V1_CRITIC_DOLA.md section 6): the fall-through card at the top
## of the boxer's Overview while the bout's opponent has pulled out (PullOutWire.is_open) - the host and the show in the
## header, then the three answers side by side, each with what it costs or gives drawn as a small meter: the replacement's
## step up and the x2 reputation, go home's mood, the favour spent with the host. Names only in the header (S448): the rows
## say "your boxer", "the opponent", "the host". A refused answer is greyed with its why on screen.
## The actions: fellthrough (open the Overview), fellanswer (a confirm) -> felldo (PullOutWire.answer).
## Colours are ApproachCard's (the Overview's dark-card palette), never a new set.

const UI := preload("res://scripts/ui/UI.gd")
const ApproachCard := preload("res://scripts/ui/ApproachCard.gd")
const PullOutWire := preload("res://scripts/state/PullOutWire.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")

const PIP := 16.0
const BAR_W := 120.0


## The card's rows (also what the test reads): {head, sub, cols: [{id, word, ok, why, rows: [{text, kind, on, of}]}]}.
## kind: "pips" (on of `of` filled), "bar" (on of `of`, a red bar), "" (words only).
static func view(c: Career, f: Dictionary) -> Dictionary:
	var b: Dictionary = f["bout"]
	var host := str(b["fell"]["host"])
	var cols: Array = []
	for col in PullOutWire.columns(c, f):
		var rows: Array = []
		match str(col["id"]):
			"take_replacement":
				rows.append({"text": "The opponent: +%d rating" % roundi(float(col["rating_up"])), "kind": "bar",
					"on": roundi(float(col["rating_up"])), "of": 10})
				rows.append({"text": "Reputation on a win x%d" % int(col["rep_x"]), "kind": "pips", "on": int(col["rep_x"]), "of": int(col["rep_x"])})
				rows.append({"text": "Same night, the fight week stays", "kind": "", "on": 0, "of": 0})
			"go_home":
				rows.append({"text": "Your boxer's mood %d" % int(col["mood"]), "kind": "bar", "on": -int(col["mood"]), "of": 10})
				rows.append({"text": "Fatigue carries; no bout", "kind": "", "on": 0, "of": 0})
			"next_month":
				var now := int(col["favours_now"])
				rows.append({"text": "Favours with the host: %d -> %d" % [now, now + int(col["favours"])], "kind": "pips",
					"on": now + int(col["favours"]), "of": FightWeekEvents.FAVOURS_MAX})
				rows.append({"text": "Same opponent, %s" % Clock.fmt(int(col["new_day"])), "kind": "", "on": 0, "of": 0})
		cols.append({"id": str(col["id"]), "word": str(col["word"]), "ok": bool(col["ok"]), "why": str(col["why"]), "rows": rows})
	return {"head": "%s'S BOUT AT %s FELL THROUGH" % [str(f["name"]).to_upper(), host.to_upper()],
		"sub": "The opponent pulled out on Monday; the show is %s. Answer before the clock runs on." % Clock.fmt(int(b["day"])),
		"cols": cols}


## Fills `card` ([panel, vbox] from DarkOverview.panel) and returns the panel.
static func fill(card: Array, main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var v := view(c, f)
	var box: VBoxContainer = card[1]
	card[0].name = "FallThroughCard"
	box.add_child(UI.label(str(v["head"]), 24, ApproachCard.RED, "bold"))
	box.add_child(UI.label(str(v["sub"]), UI.BODY, ApproachCard.INK, "semi", true))
	var row := UI.hbox(10)
	for col in v["cols"]:
		var ok := bool(col["ok"])
		var cv := UI.vbox(6)
		cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var bt := UI.button(str(col["word"]), "Btn", main.act.bind("fellanswer", "%s|%s" % [f["id"], col["id"]]), not ok, str(col["why"]))
		bt.name = "Btn_fell_" + str(col["id"])
		cv.add_child(bt)
		for r in col["rows"]:
			var line := UI.hbox(8)
			var l := UI.label(str(r["text"]), 16, ApproachCard.INK if ok else ApproachCard.SOFT, "body", true)
			line.add_child(l)
			if str(r["kind"]) == "pips":
				line.add_child(_pips(int(r["on"]), int(r["of"]), ApproachCard.HEAD if ok else ApproachCard.SOFT))
			elif str(r["kind"]) == "bar":
				line.add_child(_bar(float(r["on"]) / maxf(1.0, float(r["of"])), ApproachCard.RED if ok else ApproachCard.SOFT))
			cv.add_child(line)
		if not ok:
			cv.add_child(UI.label("Not open: " + str(col["why"]), 16, ApproachCard.AMBER, "semi", true))
		row.add_child(cv)
	box.add_child(row)
	return card[0]


static func _pips(on: int, of: int, color: Color) -> HBoxContainer:
	var h := UI.hbox(4)
	h.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	for i in of:
		var p := ColorRect.new()
		p.custom_minimum_size = Vector2(PIP, PIP)
		p.color = color if i < on else Color(color, 0.25)
		p.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(p)
	return h


static func _bar(frac: float, color: Color) -> HBoxContainer:
	var h := UI.hbox(0)
	h.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var fill_w := roundf(BAR_W * clampf(frac, 0.0, 1.0))
	for part in [[fill_w, color], [BAR_W - fill_w, Color(color, 0.25)]]:
		if float(part[0]) <= 0.0:
			continue
		var r := ColorRect.new()
		r.custom_minimum_size = Vector2(float(part[0]), 10.0)
		r.color = part[1]
		r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(r)
	return h


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"fellthrough":
			main.nav({"area": "fighters", "tab": 0, "fighter": arg, "ftab": 0})
		"fellanswer":
			var kv := arg.split("|")
			var f := c.fighter_by_id(kv[0])
			main.open_modal({"type": "info", "title": "%s's bout at %s" % [f.get("first", ""), f["bout"]["fell"]["host"]],
				"body": "%s: %s?" % [PullOutWire.WORDS.get(kv[1], kv[1]), _confirm_text(kv[1])],
				"buttons": [["Yes", "felldo", arg], ["No", "close", ""]]})
		"felldo":
			var kv2 := arg.split("|")
			main.close_modal()
			var why := PullOutWire.answer(c, kv2[0], kv2[1])
			main.toast("Done." if why == "" else "Not possible: %s." % why)
			main.render()
		_:
			return false
	return true


static func _confirm_text(id: String) -> String:
	match id:
		"take_replacement":
			return "a tougher opponent on the same night, twice the reputation on a win"
		"go_home":
			return "no bout this week; your boxer's mood drops and the fatigue carries"
		"next_month":
			return "spend a favour with the host for the same show a month on"
	return ""
