extends SceneTree
## S443 RESULTTABS: the fight result as a summary with tabs (operator Q-S294-199 "Yes, summary + tabs"). Plays the result
## page's sample bout through the game's own fight night (tools/result_dump.gd, the first of seeds 44-63 with a measured fix) and
## builds the real page: the summary holds the verdict, ONE cause with its measured fix (FixLab), what it cost and the
## rounds strip; the three tabs build; the fix button writes the measured lines into the plan; no he/she in the words.
## S538 RESULTV2 (owner Q-S294-303 "more graphics, use tooltips/modals to shorten things"): the summary is pictures - the
## icon tiles, the bars, the figure - every one with a tooltip that explains, and "More: the whole read" opens the modal
## that holds every fact in words (Close and Esc shut it).

const Dump := preload("res://tools/result_dump.gd")
const FixLab := preload("res://scripts/state/FixLab.gd")
const FightNight := preload("res://scripts/ui/modals/FightNight.gd")
const BoutActs := preload("res://scripts/ui/BoutActs.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const ResultScorecard := preload("res://scripts/ui/ResultScorecard.gd")
const ResultTiles := preload("res://scripts/ui/ResultTiles.gd")
const ResultRead := preload("res://scripts/ui/ResultRead.gd")
const Tip := preload("res://scripts/ui/Tip.gd")

var failures := 0
var asserts := 0


func _initialize() -> void:
	# S468: the page's sample bout is no longer pinned to seed 44's story (since the S466 card fix that bout never walks a
	# planned line into the opponent's game, so FixLab had no cause; best was "" and the read of the fix's lines below was
	# a script error that left the test hanging). The sample is the first bout of seeds 44-63 where FixLab finds a line to
	# rewrite; what is checked is FixLab's rule on that bout, not which line a seed loses on. tools/fixlab_scan.gd (S468):
	# on all 20 the plan as written wins 9 of 40 and the best change 11, under MIN_GAIN, so the page offers NO fix - that
	# case is checked as the page draws it, and the button's path is then walked with the rewrite set as the fix.
	var c: Career
	var f: Dictionary
	var m: Dictionary
	var seed_used := -1
	for sd in range(44, 64):
		var cf := Dump._setup(sd)
		var mm := Dump._fight(cf[0], cf[1], Dump.PLAN, true)
		var pre := FixLab.run(cf[0], mm)
		# S538: and that line lost an exchange (after the S538 rule changes seed 46's only wrong-fit line won its one use)
		if bool(pre.get("ok", false)) and (pre["changes"] as Dictionary).has("rewrite") and int(pre["changes"]["rewrite"].get("lost", 0)) > 0:
			c = cf[0]
			f = cf[1]
			m = mm
			seed_used = sd
			break
	_check(seed_used >= 0, "one bout of seeds 44-63 has a line FixLab would rewrite")
	if seed_used < 0:
		print("RESULT_TABS failures=%d" % failures)
		quit(1)
		return
	print("RESULT_TABS sample bout: seed %d" % seed_used)
	m["step"] = "result"
	m["night_seen"] = true   # the headline card was seen (HeadlineCard)
	_check(m.has("lab_from"), "the bout keeps the boxer at the first bell (lab_from); outcome %s %s" % [m["outcome"], str(m["cards"])])
	var worst := _lab_rules(c, f, m)
	var desk := Desk.new()
	desk.career = c
	desk.modal = m
	root.add_child(desk)
	var page := _page(desk, m)
	_check(m.has("fixlab") and not m.has("lab_from"), "the fix is measured once, on the first draw")
	if not m.has("fixlab"):
		print("RESULT_TABS failures=%d" % (failures + 1))
		quit(1)
		return
	var lab: Dictionary = m["fixlab"]
	print("RESULT_TABS lab written=%d best=%s best_wins=%d verdict=%s of %d" % [int(lab["written"]), lab["best"], int(lab["best_wins"]), lab["verdict"], int(lab["nights"])])
	var fixed := str(lab["best"]) != ""
	for n in ["ResultHead", "Judges", "WhyRank", "ResultTabs", "Tab_summary", "Cause", "CauseHead", "FixLadder", "Cost", "RoundStrip", "BackHome",
			"Portrait", "JudgesKey", "ResultTiles", "Tile_ticket", "Tile_members", "Tile_clue", "HeadCount", "BodyCount", "CostFacts", "Energy", "WholeRead"]:
		_check(page.find_child(n, true, false) != null, "the summary holds %s" % n)
	_check((page.find_child("PlanFix", true, false) != null) == fixed, "the fix button is there only when a change beats luck (best '%s')" % str(lab["best"]))
	var head: Label = page.find_child("CauseHead", true, false)
	var cause := "Line %s: %s" % [FixLab.LETTERS[int(worst["i"])], ResultCause._move(str(worst["move"]))]
	_check(head != null and head.text.begins_with(cause), "the one cause is the line that lost most, '%s': '%s'" % [cause, head.text if head else ""])
	var bars: Control = page.find_child("FixLadder", true, false)   # S538: the verdict sentence is the bars' tooltip (and the modal's)
	var verdict := str(Tip.of(bars).get("now", "")) if bars != null else ""
	print("RESULT_TABS verdict: %s" % verdict)
	_check(verdict != "" and (verdict.contains("Even the best plan") == (["even", "class"].has(str(lab["verdict"])))), "the verdict sentence follows the numbers")
	_check(str(Tip.of(bars).get("do", "")).begins_with("Measured: %d more nights" % int(lab["nights"])), "the bars' tooltip says how the fix was measured")
	_tooltips(page)
	_whole_read(desk, page, m, verdict)
	_check(not fixed or str(lab["best"]) == "both" or int(lab["changes"].get("both", {}).get("wins", -1)) < int(lab["best_wins"]), "both changes are the fix unless they win less")
	for k in lab["changes"]:
		_check((str(lab["best"]) != str(k)) or int(lab["changes"][k]["wins"]) - int(lab["written"]) >= FixLab.MIN_GAIN, "the fix beats the plan as written by %d nights or more" % FixLab.MIN_GAIN)
	_check(int((page.find_child("Round1", true, false) as Node).get_child(0).get_child_count()) >= 2, "the rounds strip draws round 1")
	_check(_pronouns(page) == "", "no he/she on the summary: %s" % _pronouns(page))
	for t in ["scorecard", "exchanges", "numbers", "plan"]:
		m["result_tab"] = t
		page = _page(desk, m)
		_check(page.find_child("Tab_" + t, true, false) != null and page.find_child("BackHome", true, false) != null, "the %s tab builds with Back home" % t)
		_check(_pronouns(page) == "", "no he/she on the %s tab: %s" % [t, _pronouns(page)])
	_scorecard(desk, m)
	if not fixed:
		lab["best"] = "rewrite"   # no change beat luck on this bout: the button's path is walked with the rewrite as the fix
		m["result_tab"] = "summary"
		page = _page(desk, m)
		_check(page.find_child("PlanFix", true, false) != null, "with a fix the summary holds PlanFix")
	var want: Array = lab["changes"][str(lab["best"])]["arrows"]
	BoutActs.act(desk, "planfix", str(f["id"]))
	_check(f["arrows"] == want and bool(m.get("fix_done", false)), "Put the fix in the plan writes the measured lines: %s" % str(f["arrows"]))
	m["result_tab"] = "summary"
	page = _page(desk, m)
	var b: Button = page.find_child("PlanFix", true, false)
	_check(b != null and b.disabled, "the fix button reads as done once pressed")
	print("RESULT_TABS asserts=%d" % asserts)
	print("RESULT_TABS failures=%d" % failures)
	quit(failures)


## FixLab's choices on this bout, from the records: the planned line lost most while it walked into the opponent's game
## is the line to rewrite, to another move the Playbook offers at that line's own place; both changes fit the coach's lines.
func _lab_rules(c: Career, f: Dictionary, m: Dictionary) -> Dictionary:
	var from: Dictionary = m["lab_from"]
	var arrows: Array = from["arrows"]
	var worst := FixLab.worst_line(arrows, m["rounds"])
	var wi := int(worst.get("i", -1))
	_check(wi >= 0 and wi < arrows.size() and str(arrows[wi]["move"]) == str(worst.get("move", "")) and int(worst.get("lost", 0)) > 0,
		"the worst line is one of the plan's own and lost exchanges: %s" % str(worst))
	var ch := FixLab.changes(from, m["rounds"], 4)
	var to := str(ch.get("rewrite", {}).get("to", ""))
	_check(to != "" and to != str(worst.get("move", "")), "the worst line is rewritten to another move: %s" % to)
	_check(PlanLines.options(str(worst.get("place", "")), str(ch.get("rewrite", {}).get("sit", "")), from.get("moves", {}), from.get("combos", {})).any(
		func(o): return str(o["id"]) == to and str(o["why"]) == ""), "the rewrite is a move the Playbook offers at that line's place: %s" % to)
	if ch.has("add"):
		_check(PlanLines.find(arrows, PlanLines.place_for(str(ch["add"]["sit"])), str(ch["add"]["sit"])) < 0, "the new line answers a situation no line had: %s" % str(ch["add"]["sit"]))
	if ch.has("both"):
		_check((ch["both"]["arrows"] as Array).size() <= 4, "both changes fit the 4 lines a coach holds")
	var full := FixLab.changes(from, m["rounds"], 3)
	# S461: the fixture's plan now fires (result_dump gives its combos at Sharp), so which line went unused is read off the bout
	# itself: FixLab's rule - a full plan's new line replaces a line that never fired, and with every line fired it offers none.
	var fired := {}
	for r in m["rounds"]:
		for x in r["exchanges"]:
			if bool(x.get("planned", false)):
				fired[str(x.get("arrow", ""))] = true
	var unused: Array = (from["arrows"] as Array).filter(func(a): return not fired.has(str(a["move"])))
	if unused.is_empty():
		_check(not full.has("add"), "a full plan with every line fired gets no new line (%s)" % str(full.get("add", {})))
	else:
		_check(unused.any(func(a): return str(a["move"]) == str(full.get("add", {}).get("replaces", ""))),
			"a full plan puts the new line in place of one never used (%s; unused %s)" % [str(full.get("add", {}).get("replaces", "")), str(unused)])
	_check(FixLab.verdict(25, 30, 40) == "plan_right" and FixLab.verdict(5, 18, 40) == "even" and FixLab.verdict(5, 12, 40) == "class" and FixLab.verdict(5, 30, 40) == "fixed", "the verdict bands")
	return worst


## S504 SCORECARD (Q-265): three paper sheets whose totals ARE the bout's cards, a hover on every score that names the judge
## and the round, the round cards, and the sheet input's rules: a flipped close round on judge 3 only, no stopped round.
func _scorecard(desk: Desk, m: Dictionary) -> void:
	m["result_tab"] = "scorecard"
	var page := _page(desk, m)
	for n in ["JudgesCards", "Sheet1", "Sheet2", "Sheet3", "RoundByRound", "WhatItMeans", "RoundCard1"]:
		_check(page.find_child(n, true, false) != null, "the scorecard holds %s" % n)
	var j := ResultScorecard.sheet_input(m)
	var cards: Array = m["cards"]
	for ji in 3:
		var tot: Array = j["cards"][ji]
		_check("%d-%d" % [int(tot[0]), int(tot[1])] == str(cards[ji]), "judge %d's sheet adds up to the card %s: %s" % [ji + 1, str(cards[ji]), str(tot)])
		var st: Label = page.find_child("Stamp%d" % (ji + 1), true, false)
		var want := "RED" if int(tot[0]) > int(tot[1]) else ("BLUE" if int(tot[1]) > int(tot[0]) else "EVEN")
		_check(st != null and st.text == want, "judge %d's stamp reads %s" % [ji + 1, want])
	var cell: Control = page.find_child("Score3_1_a", true, false)
	_check(cell != null and cell.tooltip_text.begins_with("Round 1 · Judge 3 gave it to"), "a score's hover is that judge's reason: %s" % (cell.tooltip_text.get_slice("
", 0) if cell else ""))
	var fake := {"rounds": [{"won": true, "exchanges": []}, {"won": false, "exchanges": []}, {"won": true, "exchanges": []}], "cards": ["29-28", "29-28", "28-29"], "stopped": ""}
	var fj := ResultScorecard.sheet_input(fake)
	var flips := 0
	for ri in 3:
		var row: Array = fj["by_round"][ri]
		flips += int((int(row[2]["a"]) > int(row[2]["b"])) != (int(row[0]["a"]) > int(row[0]["b"])))
	_check(flips == 1 and str(fj["verdict"]) == "split", "a split card flips one round on judge 3 only: %d flips, %s" % [flips, str(fj["verdict"])])
	fake["stopped"] = "TKO"
	_check((ResultScorecard.sheet_input(fake)["by_round"] as Array).size() == 2, "a stoppage scores only the rounds before it")
	fake["rounds"] = [{"won": true, "exchanges": []}]
	_check(ResultScorecard.sheet_input(fake).is_empty(), "a first-round stoppage has no card")
	_check(_pronouns(page) == "", "no he/she on the scorecard: %s" % _pronouns(page))


## S538 every tile, bar and round of the summary has a tooltip, and it EXPLAINS: six words or more, never the label again.
func _tooltips(page: Control) -> void:
	var tiles: Node = page.find_child("ResultTiles", true, false)
	_check(tiles != null and tiles.get_child_count() >= 3, "the summary has its row of icon tiles (%d)" % (tiles.get_child_count() if tiles else 0))
	if tiles == null:
		return
	var hover: Array = tiles.get_children()
	for n in ["HeadCount", "BodyCount", "Damage", "Energy", "Score", "FixLadder"]:
		hover.append(page.find_child(n, true, false))
	hover.append_array(page.find_child("CostFacts", true, false).get_children())
	hover.append_array(page.find_child("Round1", true, false).get_child(1).get_children())   # round 1's exchanges
	for c in hover:
		var spec: Dictionary = Tip.of(c) if c != null else {}
		var said := " ".join(PackedStringArray(Tip.prose(spec))) if not spec.is_empty() else ""
		var label := ""
		for l in (c as Node).find_children("*", "Label", true, false) if c != null else []:
			label += (l as Label).text + " "
		_check(said.split(" ", false).size() >= 6 and said.to_lower().strip_edges() != label.to_lower().strip_edges(),
			"%s has a tooltip that explains: '%s'" % [str(c.name) if c else "a missing node", said.left(70)])
	for t in tiles.get_children():
		_check((t as Node).find_children("*", "TextureRect", true, false).size() >= 1, "tile %s carries an icon" % str(t.name))


## S538 "More: the whole read" opens the modal; it holds every fact of the page in words; Close and Esc shut it.
func _whole_read(desk: Desk, page: Control, m: Dictionary, verdict: String) -> void:
	var more: Button = page.find_child("WholeRead", true, false)
	if more == null:
		return
	more.emit_signal("pressed")
	var read: Control = desk.find_child("ResultRead", false, false)
	_check(read != null, "More: the whole read opens the modal")
	if read == null:
		return
	var text := ""
	for l in read.find_children("*", "Label", true, false):
		text += (l as Label).text + "\n"
	var facts := [verdict, ResultTiles.measured(m["fixlab"]), str(m.get("clue", ResultTiles.NO_CLUE)), str(m.get("rank_words", "")), "times hurt", "standing count",
		"Energy at the bell", "exchanges", "Record "]
	for t in ResultTiles.take(m):
		facts.append(str(t["words"]))
	for cd in m["cards"]:
		facts.append(str(cd))
	for t in m.get("aftermath", []):
		if str(t.get("id", "")) == "damage":
			facts.append(str(t["big"]))
			facts.append_array(t.get("lines", []))
	for k in ["rewrite", "add"]:
		if (m["fixlab"]["changes"] as Dictionary).has(k):
			facts.append("%d of %d" % [int(m["fixlab"]["changes"][k]["wins"]), int(m["fixlab"]["nights"])])
	var head: Label = page.find_child("CauseHead", true, false)
	facts.append(head.text if head != null else "?")
	for fact in facts:
		_check(str(fact) == "" or text.contains(str(fact)), "the whole read holds: %s" % str(fact).left(80))
	_check(_pronouns(read) == "", "no he/she in the whole read: %s" % _pronouns(read))
	(read.find_child("ReadClose", true, false) as Button).emit_signal("pressed")
	_check(desk.find_child("ResultRead", false, false) == null, "Close shuts the whole read")
	more.emit_signal("pressed")
	var again: Control = desk.find_child("ResultRead", false, false)
	var esc := InputEventAction.new()
	esc.action = "ui_cancel"
	esc.pressed = true
	if again != null:
		again._input(esc)
	_check(again != null and desk.find_child("ResultRead", false, false) == null, "Esc shuts the whole read")


func _page(desk: Desk, m: Dictionary) -> Control:
	for ch in desk.get_children():
		desk.remove_child(ch)
		ch.free()
	var night := FightNight.new()
	desk.add_child(night)
	night.build(desk, m)
	return night


## The first label with he/she/her/him/his in it ("" when none).
func _pronouns(n: Node) -> String:
	var re := RegEx.create_from_string("\\b(he|she|her|him|his|hers|himself|herself)\\b")
	for l in n.find_children("*", "Label", true, false):
		if re.search((l as Label).text.to_lower()) != null:
			return (l as Label).text
	for b in n.find_children("*", "Button", true, false):
		if re.search((b as Button).text.to_lower()) != null:
			return (b as Button).text
	return ""


func _check(ok: bool, label: String) -> void:
	asserts += 1
	if not ok:
		failures += 1
		print("FAIL ", label)


class Desk extends Node:
	var career: Career
	var modal: Dictionary = {}
	func act(_what: String, _arg: String = "") -> void:
		pass
	func open_modal(m: Dictionary) -> void:
		modal = m
	func redraw_modal() -> void:
		pass
	func toast(_t: String) -> void:
		pass
