extends PanelContainer
## S481 FIGHTWEEK2: the FIGHT WEEK screen (Frame A, docs/mockups/s480/fight_week_v2.png, map v9) and, on view "partner",
## the sparring partner screen (Frame B, docs/mockups/s479/sparring_partner_v1.png, his C402 "ok": FightWeekPartner).
## Left: the weight and the film night. Middle: the fight week's days (place 0-2 sparring nights; each opens Frame B for its
## partner), the three load stops, the plan lines (READY / UNSPARRED). Right: on fight night - the tank at the first bell
## and its parts, round 1, each night's partner, the lines still unsparred, the scale. Footer: the assistant's pick,
## Use the pick, Lock the week (grey with its reason on screen until every night has a partner).
## Every number is FightWeekPlan.read's; the picks go through FightWeekActs. Names only in the header (S448).

const UI := preload("res://scripts/ui/UI.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const FightWeekPartner := preload("res://scripts/ui/FightWeekPartner.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")

const W := 1640.0
const DOW := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
const WORD_COL := {"CLOSE": UI.GREEN, "PART": UI.AMBER, "LOOSE": UI.RED}


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(W, 0)
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var plan: Dictionary = m["plan"]
	var r := FightWeekPlan.read(c, f, plan)
	if str(m.get("view", "week")) == "partner":
		add_child(FightWeekPartner.make(main, c, f, m, r))
		return
	var v := UI.vbox(14)
	add_child(v)
	v.add_child(_header(c, f, r))
	v.add_child(_week_before(main, c, f, m, r))
	var cols := UI.hbox(26)
	v.add_child(cols)
	cols.add_child(_left(main, f, plan, r))
	cols.add_child(_middle(main, c, f, plan, r))
	cols.add_child(_right(r, FightWeekPlan.band(c, f, r)))
	v.add_child(UI.sep())
	v.add_child(_footer(main, plan, r))


func _header(c: Career, f: Dictionary, r: Dictionary) -> Control:
	var b: Dictionary = f["bout"]
	var o: Dictionary = b["opp"]
	var top := UI.hbox(14)
	var head := UI.vbox(0)
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(head)
	head.add_child(UI.display("FIGHT WEEK", 44))
	head.add_child(UI.label("%s %d-%d v %s %d-%d  ·  %d kg" % [str(f["first"]), int(f.get("w", 0)), int(f.get("l", 0)),
		str(o["name"]), int(o.get("w", 0)), int(o.get("l", 0)), roundi(float(f.get("limit", 60.0)))], 19, UI.MUTED))
	var host := str(b.get("host", ""))
	top.add_child(UI.chip("AWAY at %s" % host, "gold"))
	var toward := FightWeekEvents.BOUTS_PER_FAVOUR - int(c.host_bouts.get(host, 0))   # S515 FAVOURS2: this bout counts toward the next
	var next_word := "this bout earns one" if toward <= 1 else "one more every %d bouts here (%d to go)" % [FightWeekEvents.BOUTS_PER_FAVOUR, toward]
	top.add_child(UI.chip("Favours with the host %s · %s" % [_dots(FightWeekPlan.favours(c, host)), next_word], ""))
	var w: Dictionary = r["weight"]
	top.add_child(UI.chip("Scale: %.1f now · %s the %.1f kg gap by %.1f" % [float(w["now"]), "inside" if bool(w["in_gap"]) else "outside",
		float(w["gap"]), absf(float(w["margin"]))], "green" if bool(w["in_gap"]) else "red"))
	top.add_child(UI.chip("%d days to the bell" % (int(b["day"]) - c.day), "amber"))
	return top


static func _dots(n: int) -> String:
	var s := ""
	for i in 3:
		s += "●" if i < n else "○"
	return s


func _week_before(main: Node, c: Career, f: Dictionary, m: Dictionary, r: Dictionary) -> Control:
	var b: Dictionary = f["bout"]
	var plan: Dictionary = m["plan"]
	var row := UI.hbox(18)
	row.add_child(UI.label("THE WEEK BEFORE", 18, UI.MUTED, "caps"))
	var days := int(b["day"]) - c.day
	var nights: Dictionary = plan["nights"]
	var wb := FightWeekPlan.WEEK_BEFORE
	if days < wb:
		row.add_child(UI.label("No week-before night: the bout is %d days out." % days, 17, UI.MUTED))
	elif nights.has(wb):
		row.add_child(UI.button(_night_word(r, wb), "Btn", main.act.bind("fwpartnerof", str(wb))))
		row.add_child(UI.button("Take it off", "BtnQuiet", main.act.bind("fwnight", str(wb))))
		row.add_child(UI.label("costs one pad night, never the tank", 16, UI.MUTED))
	else:
		row.add_child(UI.button("Add a week-before sparring night", "BtnQuiet", main.act.bind("fwnight", str(wb))))
		row.add_child(UI.label("costs one pad night, a partner of its own; readies two lines", 16, UI.MUTED))
	var sp := UI.spacer()
	row.add_child(sp)
	var opp: Dictionary = b["opp"]
	var can_film := OppFile.has_tape(opp) and not OppFile.hidden(opp).is_empty()
	var film_on := bool(plan.get("film", false))
	row.add_child(UI.button("FILM NIGHT: %s" % ("ON" if film_on else "OFF"), "BtnSolid" if film_on else "BtnQuiet",
		main.act.bind("fwfilm", ""), not can_film, "no film of the opponent left to watch"))
	var alone := FightWeekPlan.film_line(c, f) if can_film else ""
	var film_word := alone if alone != "" else ("opens one new tell, costs one pad night" if can_film else "no film of the opponent left to watch")
	var self_on := film_on and bool(plan.get("film_self", false))
	if self_on:   # S510 FIGHTFILM1 map 3.1: watched yourself, the whole evening on the analysis page
		film_word = "you watch the tape when the week locks: mark what you see, the coach checks it, file what holds"
	var fl := UI.label(film_word, 16, UI.AMBER if alone != "" and not self_on else UI.MUTED)
	fl.name = "FilmSeatLine"
	if film_on:
		var sb := UI.button("WATCH IT YOURSELF" if self_on else "LET THE COACH WATCH", "BtnSolid" if self_on else "BtnQuiet",
			main.act.bind("fwfilmself", ""))
		sb.name = "FilmSelfBtn"
		row.add_child(sb)
	row.add_child(fl)
	return row


static func _night_word(r: Dictionary, days: int) -> String:
	for row in r["nights"]:
		if int(row["days"]) == days:
			var mt: Dictionary = row["match"]
			if mt.is_empty():
				return "Pick a partner"
			return "%s · %s" % [str((row["partner"] as Dictionary)["name"]), str(mt["word"])]
	return "Pick a partner"


func _left(main: Node, f: Dictionary, plan: Dictionary, r: Dictionary) -> Control:
	var col := UI.vbox(10)
	col.custom_minimum_size = Vector2(400, 0)
	col.add_child(UI.label("THE WEIGHT", 18, UI.MUTED, "caps"))
	var w: Dictionary = r["weight"]
	col.add_child(UI.kv("Scale now", "%.1f kg" % float(w["now"])))
	col.add_child(UI.kv("The opponent", "%.1f kg" % float(w["opp"])))
	col.add_child(UI.kv("The gap allowed", "%.1f kg" % float(w["gap"])))
	col.add_child(UI.kv("On the day", ("inside the gap by %.1f" if bool(w["in_gap"]) else "outside the gap by %.1f") % absf(float(w["margin"])),
		UI.GREEN if bool(w["in_gap"]) else UI.RED))
	var eat := bool(plan.get("eat_less", false))
	col.add_child(UI.button("Eat less: %s  (%d off the tank)" % ["ON" if eat else "OFF", FightWeek.EAT_LESS_TANK],
		"BtnSolid" if eat else "BtnQuiet", main.act.bind("fweat", "")))
	var ways: Array = r["ways"]
	var off := bool(plan.get("train_off", false))
	col.add_child(UI.button("Train it off: %s  (%.1f kg for +%d fatigue)" % ["ON" if off else "OFF", float(ways[1]["kg"]), int(ways[1]["tired"])],
		"BtnSolid" if off else "BtnQuiet", main.act.bind("fwtrainoff", "")))
	var kilo := bool(plan.get("ask_kilo", false))
	var kb := UI.button("Ask for a kilo: %s  (1 favour with the host)" % ("ON" if kilo else "OFF"), "BtnSolid" if kilo else "BtnQuiet",
		main.act.bind("fwkilo", ""))
	kb.name = "AskKilo"
	if not bool(ways[2]["ok"]) and not kilo:
		kb.disabled = true
		kb.tooltip_text = "Not now: %s." % str(ways[2]["why"])
	col.add_child(kb)
	col.add_child(UI.label("Your boxer's fatigue now: %d" % FightWeekPlan.tired(f), 17, UI.MUTED))
	return col


func _middle(main: Node, c: Career, f: Dictionary, plan: Dictionary, r: Dictionary) -> Control:
	var col := UI.vbox(10)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(UI.label("FIGHT WEEK  ·  click an evening to spar there", 18, UI.MUTED, "caps"))
	var days_row := UI.hbox(8)
	col.add_child(days_row)
	var bout_day := int(f["bout"]["day"])
	var nights: Dictionary = plan["nights"]
	for d in range(6, -1, -1):
		var day := bout_day - d
		var cell := UI.vbox(4)
		cell.custom_minimum_size = Vector2(108, 0)
		cell.add_child(UI.label(str(DOW[posmod(day, 7)]), 17, UI.FG, "bold"))
		if d == 0:
			cell.add_child(UI.chip("FIGHT NIGHT", "red"))
		elif d == 1:
			cell.add_child(UI.label("weigh-in", 16, UI.MUTED))
		elif day <= c.day:
			cell.add_child(UI.label("gone", 16, UI.MUTED))
		elif nights.has(d):
			cell.add_child(UI.button("SPAR", "BtnSolid", main.act.bind("fwpartnerof", str(d))))
			cell.add_child(UI.label("%s · -%d tank" % [_night_word(r, d).split(" · ")[-1], FightWeek.night_tank(d)], 15, UI.RED))
			cell.add_child(UI.button("off", "BtnQuiet", main.act.bind("fwnight", str(d))))
		elif _fw_nights(nights) < 2:
			cell.add_child(UI.button("+ spar", "BtnQuiet", main.act.bind("fwnight", str(d))))
			cell.add_child(UI.label("-%d tank%s" % [FightWeek.night_tank(d), ", late" if d <= FightWeek.SPAR_LATE_MAX_DAYS else ""], 15, UI.MUTED))
		else:
			cell.add_child(UI.label("pads", 16, UI.MUTED))
		days_row.add_child(cell)
	col.add_child(UI.label("THE WEEK'S LOAD", 18, UI.MUTED, "caps"))
	col.add_child(_load_line(f, plan, str(r["stop"])))
	col.add_child(UI.label("PLAN LINES", 18, UI.MUTED, "caps"))
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 8)
	flow.add_theme_constant_override("v_separation", 6)
	col.add_child(flow)
	var left: Array = r["unsparred"]
	for ln in r["lines"]:
		var bad := left.has(str(ln["id"]))
		flow.add_child(UI.chip("%s · %s" % [str(ln["text"]), "UNSPARRED" if bad else "READY"], "red" if bad else "green"))
	col.add_child(UI.label("A line written or changed since the last sparring is UNSPARRED: it fires a level down in rounds 1-2. "
		+ "A sparring night readies lines by how closely the partner matches the opponent.", 16, UI.MUTED, "body", true))
	return col


static func _fw_nights(nights: Dictionary) -> int:
	var n := 0
	for d in nights:
		if int(d) < FightWeekPlan.WEEK_BEFORE:
			n += 1
	return n


## S543 (owner: "cut the fight week load choice"; docs/FWLOAD2_RESULT.md: the pick was worth under 1 win in 100 and the
## assistant already played it): the load is set by the assistant and shown as one line - which load, and why.
const LOAD_WHY := {"tired": "the boxer is tired", "weight": "there is weight to lose", "near_usable": "a move is close to usable",
	"rating_gap": "the opponent is well below the boxer", "opp_round1": "the opponent starts fast", "default": "a plain week"}


func _load_line(f: Dictionary, plan: Dictionary, s: String) -> Control:
	var r1 := FightWeek.round_one(FightWeekPlan.tired(f), s)
	var l := UI.label("%s, set by your assistant: %s." % [str(FightWeek.STOP_NAMES[s]), str(LOAD_WHY.get(str(plan.get("fact", "default")), LOAD_WHY["default"]))],
		19, UI.FG, "body", true)
	l.name = "FwLoad"
	l.mouse_filter = Control.MOUSE_FILTER_STOP
	# S544: a card (Tip.explain), not one long line with three numbers in it (tooltip_rest_test: long, piled)
	load("res://scripts/ui/Tip.gd").explain(l, {"title": "This week's training load", "what": "How hard the boxer trains before the bout.",
		"rows": [["Tank at the first bell", "-%d" % int(FightWeek.STOP_TANK[s]), "", "bad"],
			["Round 1", "flat" if str(r1["state"]) == FightWeek.STATE_FLAT else "sharp", "", ""],
			["Pad work kept", "%d%%" % roundi(float(FightWeek.BANK_SHARE[s]) * 100.0), "", ""]]})
	return l


func _right(r: Dictionary, band: Dictionary) -> Control:
	var col := UI.vbox(8)
	col.custom_minimum_size = Vector2(440, 0)
	col.add_child(UI.label("ON FIGHT NIGHT", 18, UI.MUTED, "caps"))
	var tank: Dictionary = r["tank"]
	col.add_child(UI.kv("The tank at the first bell", str(100 - int(tank["off"]))))
	col.add_child(UI.meter(clampf((100.0 - float(tank["off"])) / 100.0, 0.0, 1.0), UI.GREEN, [], 420.0))
	for p in tank["parts"]:
		col.add_child(UI.kv("  " + str(p[0]), "-%d" % int(p[1]), UI.RED, "body"))
	var r1: Dictionary = r["round_one"]
	col.add_child(UI.kv("Round 1", "%s, edge %+.1f" % [str(r1["state"]).capitalize(), float(r["edge"])],
		UI.GREEN if float(r["edge"]) >= 0.0 else UI.RED))
	col.add_child(UI.kv("Rounds 1-2, from sparring", "edge %+.1f" % float(r.get("spar_edge", 0.0)), UI.GREEN if float(r.get("spar_edge", 0.0)) > 0.0 else UI.MUTED))
	for row in r["nights"]:
		var mt: Dictionary = row["match"]
		col.add_child(UI.kv("Sparring, %d days out" % int(row["days"]), "no partner yet" if mt.is_empty() else
			"%s · %d line(s)" % [str(mt["word"]), (row.get("readied", []) as Array).size()],
			UI.RED if mt.is_empty() else WORD_COL.get(str(mt["word"]), UI.FG)))
	var left: Array = r["unsparred"]
	col.add_child(UI.kv("Lines still unsparred", str(left.size()), UI.RED if left.size() > 0 else UI.GREEN))
	var w: Dictionary = r["weight"]
	col.add_child(UI.kv("Scale on the day", "inside the gap" if bool(w["in_gap"]) else "outside the gap",
		UI.GREEN if bool(w["in_gap"]) else UI.RED))
	if not band.is_empty():   # S514 FIGHTWEEK3: the win band on this plan (FightWeekPlan.band)
		var lo := roundi(float(band["lo"]) * 100.0)
		var hi := roundi(float(band["hi"]) * 100.0)
		var wb := UI.kv("Win chance on this plan", "%d%% to %d%%" % [lo, hi], UI.GREEN if lo >= 50 else (UI.RED if hi <= 50 else UI.FG))
		wb.name = "FwWinBand"
		col.add_child(wb)
		if hi - lo >= 30:   # as OfferCard._band: a band this wide is still a rough guess
			col.add_child(UI.muted("  Wide: the film night narrows it", UI.SMALL, true))
	# S543: "Fatigue after the bell +6" was shown and never applied (FightWeek.tired_after has no reader in the sim): not promised now.
	return col


func _footer(main: Node, plan: Dictionary, r: Dictionary) -> Control:
	var row := UI.hbox(16)
	var words := UI.vbox(0)
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(words)
	words.add_child(UI.label("\"%s\"" % str(plan.get("line", "")), 22, UI.FG, "bold", true))
	words.add_child(UI.label("Your assistant's pick for the night and the weight. The load is set for you.", 16, UI.MUTED))
	row.add_child(UI.button("Use the pick", "BtnQuiet", main.act.bind("fwpick", "")))
	var missing := int(r["missing"]) > 0
	var lock := UI.button2("Lock the week", "pick a partner for every night" if missing else "", "BtnSolid",
		main.act.bind("fwlock", ""), Vector2(240, 60), UI.GOLD_INK, UI.GOLD_INK, missing, UI.BODY, UI.TINY,
		"pick a partner for every night")
	row.add_child(lock)
	return row
