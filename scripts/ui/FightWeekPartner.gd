extends RefCounted
## S481 FIGHTWEEK2: the SPARRING PARTNER screen (Frame B, docs/mockups/s479/sparring_partner_v1.png, his C402 "ok"), drawn
## inside the fight week modal for one night (modal.night = days out). Left: your boxer and the lines this night readies.
## Middle: the partners, best match first - the match word (CLOSE / PART / LOOSE, PartnerMatch), its points, lines and
## round-1 edge, the level, the cost (our club free; another club $160 or a favour with that club) and Spar with this
## partner (grey with the reason on screen when it cannot be paid). Right: the opponent as known, the filmed tells.
## Names only in the header (S448).

const UI := preload("res://scripts/ui/UI.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const PartnerMatch := preload("res://scripts/rules/PartnerMatch.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Champs := preload("res://scripts/state/Champs.gd")

const WORD_COL := {"CLOSE": UI.GREEN, "PART": UI.AMBER, "LOOSE": UI.RED}


static func make(main: Node, c: Career, f: Dictionary, m: Dictionary, r: Dictionary) -> Control:
	var d := int(m.get("night", 0))
	var b: Dictionary = f["bout"]
	var o: Dictionary = b["opp"]
	var sn := FightWeek.spar_night(d)
	var v := UI.vbox(14)
	var top := UI.hbox(14)
	v.add_child(top)
	var head := UI.vbox(0)
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(head)
	head.add_child(UI.display("SPARRING, %s, %d DAYS OUT" % [Clock.DAYS[posmod(int(b["day"]) - d, 7)].to_upper(), d], 40))
	var cost_word := "costs one pad night, never the tank" if bool(sn["costs_pad_night"]) else "%d off the tank" % int(sn["tank"])
	head.add_child(UI.label("%s  ·  pick one partner  ·  a closer partner readies more plan lines  ·  %s" % [str(f["first"]), cost_word],
		18, UI.MUTED))
	var host := str(b.get("host", ""))
	top.add_child(UI.chip("Favours with the host %s" % _dots(FightWeekPlan.favours(c, host)), ""))
	top.add_child(UI.chip("Cash %s" % UI.money(c.cash), ""))
	top.add_child(UI.chip("AWAY at %s" % host, "gold"))
	var cols := UI.hbox(24)
	v.add_child(cols)
	cols.add_child(_boxer(f, r, sn))
	cols.add_child(_list(main, c, f, m, r))
	cols.add_child(_opp(o))
	v.add_child(UI.sep())
	var foot := UI.hbox(16)
	v.add_child(foot)
	var words := UI.vbox(0)
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	foot.add_child(words)
	var best: Dictionary = (r["partners"] as Array)[0]
	words.add_child(UI.label("\"%s - the closest match on the list.\"" % str(best["name"]), 22, UI.FG, "bold"))
	words.add_child(UI.label("Your assistant's pick. A film night finds the next tell, which a partner can share.", 16, UI.MUTED))
	foot.add_child(UI.button("Back to the week", "Btn", main.act.bind("fwback", "")))
	return v


static func _dots(n: int) -> String:
	var s := ""
	for i in 3:
		s += "●" if i < n else "○"
	return s


static func _boxer(f: Dictionary, r: Dictionary, sn: Dictionary) -> Control:
	var col := UI.vbox(8)
	col.custom_minimum_size = Vector2(360, 0)
	col.add_child(UI.label("YOUR BOXER", 18, UI.MUTED, "caps"))
	col.add_child(UI.kv("Class", "%d kg" % roundi(float(f.get("limit", 60.0)))))
	col.add_child(UI.kv("Stance", str(f.get("stance", ""))))
	col.add_child(UI.kv("Reach", "%d cm" % int(f.get("reach", 0)) if int(f.get("reach", 0)) > 0 else "-"))
	col.add_child(UI.kv("Style", str(f.get("style", ""))))
	col.add_child(UI.kv("Level", str(int(Champs.rating_of(f)))))
	col.add_child(UI.label("LINES A NIGHT CAN READY", 17, UI.MUTED, "caps"))
	var any := false
	for ln in r["lines"]:
		if bool(ln["unsparred"]):
			any = true
			col.add_child(UI.label("·  %s" % str(ln["text"]), 17, UI.FG))
	if not any:
		col.add_child(UI.label("Every plan line is sparred: this night only sharpens.", 16, UI.MUTED, "body", true))
	var many := "every unsparred line (a late night)" if int(sn["readies"]) < 0 else "CLOSE readies 3 · PART 2 · LOOSE 1"
	col.add_child(UI.label(many, 16, UI.MUTED, "body", true))
	if float(sn["injury_x"]) > 1.0:
		col.add_child(UI.label("Late night: injury risk x%.1f, a cut ends the bout %d in 100." % [float(sn["injury_x"]),
			roundi(float(sn["cut_stop"]) * 100.0)], 16, UI.RED, "body", true))
	return col


static func _list(main: Node, c: Career, f: Dictionary, m: Dictionary, r: Dictionary) -> Control:
	var col := UI.vbox(8)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(UI.label("SPARRING PARTNERS  ·  points: style 2 · stance 1 · reach within 5 cm 1 · each filmed tell 1", 17, UI.MUTED, "caps"))
	var opp := FightWeekPlan.opp_known(f)
	var lvl := int(Champs.rating_of(f))
	var picked := str((m["plan"]["nights"] as Dictionary).get(int(m.get("night", 0)), ""))
	var spent := 0
	for row in r["nights"]:
		var p: Dictionary = row["partner"]
		if not p.is_empty() and not bool(p["ours"]) and int(row["days"]) != int(m.get("night", 0)):
			spent += PartnerMatch.OUTSIDE_FEE
	for p in r["partners"]:
		var mt := PartnerMatch.night(p, opp, lvl, 3)
		var cost := PartnerMatch.cost(bool(p["ours"]), FightWeekPlan.favours(c, str(p["club"])), c.cash - spent)
		var card: Array = UI.card()
		col.add_child(card[0])
		var line := UI.hbox(14)
		(card[1] as VBoxContainer).add_child(line)
		var info := UI.vbox(2)
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.add_child(info)
		info.add_child(UI.label(str(p["name"]), 19, UI.FG, "bold"))
		if p == (r["partners"] as Array)[0]:
			info.add_child(UI.chip("your assistant's pick: the closest match", "amber"))
		info.add_child(UI.label("%s · %s · reach %s · %s" % [str(p["style"]), str(p["stance"]), _reach(p, opp),
			PartnerMatch.level_word(int(p["level"]), lvl)], 16, UI.MUTED))
		var extra := "shares a filmed tell" if not (p["tells"] as Array).is_empty() else "no tell of the opponent's shared"
		if bool(mt["flatters"]):
			extra += " · below your boxer: the test may flatter"
		elif float(mt["injury_mult"]) > 1.0:
			extra += " · above: injury that night x%.2f" % float(mt["injury_mult"])
		info.add_child(UI.label(extra, 15, UI.MUTED))
		var badge := UI.vbox(0)
		badge.custom_minimum_size = Vector2(150, 0)
		line.add_child(badge)
		badge.add_child(UI.label(str(mt["word"]), 24, WORD_COL.get(str(mt["word"]), UI.FG), "bold"))
		var pts := int(mt["points"])
		var nl := int(PartnerMatch.LINES[str(mt["word"])])
		badge.add_child(UI.label("%d %s · %d %s · R1 %+.1f" % [pts, "pt" if pts == 1 else "pts", nl, "line" if nl == 1 else "lines",
			float(mt["edge"])], 15, UI.MUTED))
		var price := "free" if bool(p["ours"]) else ("$160 or 1 favour" if bool(cost["favour_ok"]) else "$160")
		var btn_col := UI.vbox(2)
		btn_col.custom_minimum_size = Vector2(230, 0)
		line.add_child(btn_col)
		btn_col.add_child(UI.label(price, 16, UI.FG, "bold"))
		if str(p["id"]) == picked:
			btn_col.add_child(UI.chip("Picked", "green"))
		else:
			var why := str(cost["reason"])
			btn_col.add_child(UI.button("Spar with this partner", "BtnSolid", main.act.bind("fwpartner", str(p["id"])),
				not bool(cost["payable"]), why))
			if why != "":
				btn_col.add_child(UI.label(why, 15, UI.RED))
	return col


static func _reach(p: Dictionary, opp: Dictionary) -> String:
	if float(p["reach_cm"]) <= 0.0 or float(opp["reach_cm"]) <= 0.0:
		return "unknown"
	var diff := float(p["reach_cm"]) - float(opp["reach_cm"])
	return "%d cm %s" % [absi(roundi(diff)), "longer" if diff > 0.0 else "shorter"] if absf(diff) >= 0.5 else "the same"


static func _opp(o: Dictionary) -> Control:
	var col := UI.vbox(8)
	col.custom_minimum_size = Vector2(360, 0)
	col.add_child(UI.label(str(o["name"]).to_upper(), 18, UI.MUTED, "caps"))
	col.add_child(UI.kv("Record", "%d-%d" % [int(o.get("w", 0)), int(o.get("l", 0))]))
	col.add_child(UI.kv("Style", str(o.get("style", "unknown"))))
	col.add_child(UI.kv("Stance", str(o.get("stance", "unknown"))))
	col.add_child(UI.kv("Reach", "%d cm" % int(o.get("reach", 0)) if int(o.get("reach", 0)) > 0 else "unknown"))
	col.add_child(UI.label("FILMED TELLS", 17, UI.MUTED, "caps"))
	var found := OppFile.found(o)
	for t in OppFile.tells(o):
		if found.has(str(t["id"])):
			col.add_child(UI.label("·  %s" % str(t.get("what", t["id"])), 17, UI.FG, "body", true))
	if found.is_empty():
		col.add_child(UI.label("None yet: a film night opens one.", 16, UI.MUTED, "body", true))
	col.add_child(UI.label("Not found yet: %d" % OppFile.hidden(o).size(), 16, UI.MUTED))
	return col
