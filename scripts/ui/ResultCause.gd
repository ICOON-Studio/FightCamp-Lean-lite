extends RefCounted
## S443 the result summary's ONE cause and its measured fix (FixLab). The cause is the planned line that walked into the
## opponent's game (and the situation lost most that no line answered); the fix is the best measured change, BOTH changes
## when both together win at least as often (the coach critic's must, RESULT_R4_CRITIC_B_S442.md 6.1); the ladder shows the
## plan as written against each change, out of the same nights, with the even-fight line; one sentence says what the numbers
## say about the night ("even the best plan only gets close to an even fight" when it does). One gold button puts the fix in the
## plan (BoutActs "planfix"). Without a measurement (a bout from before S443) the card reads FightWhy's lines.
##   cause_card(main, m, f, names) -> PanelContainer   panel(title) -> PanelContainer with a VBox at child 0

const UI := preload("res://scripts/ui/TV.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const FixLab := preload("res://scripts/state/FixLab.gd")

const TEXT := 20
const ROW_H := 31   # one bar of the wins ladder


static func panel(title: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.05), Color(1, 1, 1, 0.10), 6, 1, 18, 14))
	var v := UI.vbox(8)
	p.add_child(v)
	if title != "":
		var t := UI.caps(title)
		t.add_theme_color_override("font_color", UI.GOLD)
		t.add_theme_font_size_override("font_size", 18)
		v.add_child(t)
	return p


static func cause_card(main: Node, m: Dictionary, f: Dictionary, names: Array) -> PanelContainer:
	var win := bool(m.get("win", false))
	var p := panel("WHY IT WAS WON, AND WHAT TO SHARPEN" if win else "WHY IT WAS LOST, AND THE MEASURED FIX")
	p.name = "Cause"
	var v: VBoxContainer = p.get_child(0)
	var lab: Dictionary = m.get("fixlab", {})
	var ch: Dictionary = lab.get("changes", {})
	var read := FightWhy.read(m["rounds"], str(names[0]), str(names[1]))
	if not bool(lab.get("ok", false)) or ch.is_empty():
		v.add_child(_headline(str(read["against"]), UI.RED if not win else UI.FG))
		v.add_child(UI.label(str(read["next"]), TEXT, UI.FG, "body", true))
		if bool(lab.get("ok", false)):
			v.add_child(_verdict(lab, names, win))
		return p
	var rw: Dictionary = ch.get("rewrite", {})
	var add: Dictionary = ch.get("add", {})
	if not rw.is_empty():
		v.add_child(_headline("Line %s: %s into %s" % [str(rw["letter"]), _move(str(rw["move"])), _sit(str(rw["sit"]), names)], UI.RED))
		v.add_child(UI.label("Lost %d of the %d exchanges it was used in. The Playbook rates it %s against %s." % [int(rw["lost"]),
			int(rw["used"]), str(PlanLines.FIT_WORDS["wrong"]), _sit(str(rw["sit"]), names)], TEXT, UI.FG, "body", true))
	if not add.is_empty():
		var line := "Nothing in the plan for %s: lost %d of %d." % [_sit(str(add["sit"]), names), int(add["lost"]), int(add["seen"])]
		if rw.is_empty():
			v.add_child(_headline(line, UI.RED))
		else:
			v.add_child(UI.label(line, TEXT, UI.FG, "body", true))
	v.add_child(_fix(lab, names))
	v.add_child(_verdict(lab, names, win))
	var foot := UI.hbox(14)
	var best := str(lab.get("best", ""))
	if best != "":
		var done := bool(m.get("fix_done", false))
		var b := UI.button("In the plan for the next bout" if done else "Put the fix in the plan", "BtnSolid", main.act.bind("planfix", str(f["id"])), done,
			"The plan now has these lines.")
		b.name = "PlanFix"
		b.add_theme_font_size_override("font_size", 22)
		b.custom_minimum_size = Vector2(330, 52)
		if not done:
			b.tooltip_text = "Writes the measured lines into %s's plan (the Playbook). Every line can still be changed there." % names[0]
		foot.add_child(b)
	var how := UI.label("Measured: %d more nights against %s, the corner's own calls, only the plan changes." % [int(lab["nights"]), names[1]],
		16, UI.MUTED, "body", true)
	how.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	foot.add_child(how)
	v.add_child(foot)
	return p


static func _headline(text: String, col: Color) -> Label:
	var l := UI.label(text, 28, col, "bold", true)
	l.name = "CauseHead"
	return l


## The fix as lines (what changes in the plan), then the ladder of wins.
static func _fix(lab: Dictionary, names: Array) -> VBoxContainer:
	var v := UI.vbox(6)
	var ch: Dictionary = lab["changes"]
	var best := str(lab.get("best", ""))
	var t := UI.caps("THE FIX" if best != "" else "CHANGES TRIED (NONE BEATS LUCK)")
	t.add_theme_color_override("font_color", UI.GOLD)
	v.add_child(t)
	var lines := UI.hbox(22)
	for k in ["rewrite", "add"]:
		if ch.has(k) and (best == "both" or best == k or best == ""):
			lines.add_child(_chip(_line_words(k, ch[k], names)))
	v.add_child(lines)
	var rows := [["The plan as written", int(lab["written"]), false]]
	var label := {"rewrite": "", "add": "", "both": "Both changes"}
	if ch.has("rewrite"):
		label["rewrite"] = "%s → %s" % [str(ch["rewrite"]["letter"]), str(ch["rewrite"]["to_name"])]
	if ch.has("add"):
		label["add"] = "New line %s only" % str(ch["add"]["letter"])
	for k in ["rewrite", "add", "both"]:
		if ch.has(k):
			rows.append([str(label[k]), int(ch[k]["wins"]), k == best])
	var ladder := _Ladder.new()
	ladder.name = "FixLadder"
	ladder.rows = rows
	ladder.nights = int(lab["nights"])
	ladder.custom_minimum_size = Vector2(0, rows.size() * ROW_H + 24)
	ladder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ladder.tooltip_text = "Each bar: nights won out of %d against %s. The dashed line is an even fight (half the nights)." % [int(lab["nights"]), names[1]]
	ladder.mouse_filter = Control.MOUSE_FILTER_PASS
	v.add_child(ladder)
	return v


static func _line_words(k: String, row: Dictionary, names: Array) -> String:
	if k == "rewrite":
		return "Line %s: %s → %s (%s)" % [str(row["letter"]), _move(str(row["move"])), str(row["to_name"]), str(PlanLines.FIT_WORDS.get(str(row["fit"]), ""))]
	var when := str(FightFlow.WHEN_WORDS.get(str(row["sit"]), "")).replace("the opponent", names[1])
	var gone := " (in place of %s, never used)" % _move(str(row["replaces"])) if str(row.get("replaces", "")) != "" else ""
	return "New line %s: when %s → %s%s" % [str(row["letter"]), when, str(row["to_name"]), gone]


static func _chip(text: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(UI.GOLD, 0.12), UI.GOLD, 4, 2, 12, 6))
	p.add_child(UI.label(text, TEXT, Color.WHITE, "bold"))
	return p


## One sentence: what the numbers say about the night.
static func _verdict(lab: Dictionary, names: Array, win: bool) -> Label:
	var n := int(lab["nights"])
	var w := int(lab["written"])
	var b := int(lab.get("best_wins", w))
	var text := ""
	var vd := str(lab.get("verdict", ""))
	if win and vd != "plan_right":   # a win the plan did not earn: say so, then what the best plan makes of it
		var then := {"even": "Even the best plan only gets close to an even fight (%d of %d)." % [b, n],
			"class": "Even the best plan loses most nights (%d of %d): %s is the better boxer for now." % [b, n, names[1]],
			"fixed": "The fix makes it %d of %d." % [b, n]}
		text = "A win the plan did not earn: as written it wins %d of %d nights against %s. %s" % [w, n, names[1], str(then.get(vd, ""))]
	if text == "":
		match vd:
			"plan_right":
				text = "The plan was right: as written it wins %d of %d nights.%s" % [w, n, "" if win else " This night the rounds went the other way."]
			"even":
				text = "Even the best plan only gets close to an even fight (%d of %d): %s was the better boxer. Training closes the rest." % [b, n, names[1]]
			"class":
				text = "Even the best plan loses most nights (%d of %d): %s is the better boxer for now. Training has to close the gap." % [b, n, names[1]]
			_:
				text = "With the fix %s wins %d of %d nights against %s." % [names[0], b, n, names[1]]
	var l := UI.label(text, 21, UI.GOLD if str(lab.get("verdict", "")) != "fixed" else UI.GREEN, "bold", true)
	l.name = "FixVerdict"
	return l


static func _move(id: String) -> String:
	return str(StrikeMap.move(id).get("name", id))


static func _sit(sit: String, names: Array) -> String:
	var w := str(FightWhy.SIT_WORDS.get(sit, sit))
	return w % names[0] if w.contains("%s") else w


## Bars of nights won out of `nights`, the best one gold, a dashed line at half.
class _Ladder extends Control:
	const K := preload("res://scripts/ui/TV.gd")
	const BC := preload("res://scripts/ui/Broadcast.gd")
	var rows: Array = []
	var nights := 1
	const LABEL_W := 300.0
	const NUM_W := 120.0
	const BAR_H := 31.0

	func _draw() -> void:
		var font := K.font("bold")
		var bar_w := size.x - LABEL_W - NUM_W
		for i in rows.size():
			var y := 4.0 + i * BAR_H
			var r: Array = rows[i]
			var best := bool(r[2])
			var col := K.GOLD if best else (Color(1, 1, 1, 0.45) if i > 0 else BC.HERS)
			draw_string(font, Vector2(0, y + 22), str(r[0]), HORIZONTAL_ALIGNMENT_LEFT, LABEL_W - 10, 20, Color.WHITE if best or i == 0 else K.MUTED)
			draw_rect(Rect2(LABEL_W, y + 4, bar_w, 22), Color(1, 1, 1, 0.06))
			draw_rect(Rect2(LABEL_W, y + 4, bar_w * clampf(float(r[1]) / float(maxi(1, nights)), 0.0, 1.0), 22), col)
			draw_string(font, Vector2(LABEL_W + bar_w + 12, y + 22), "%d of %d" % [int(r[1]), nights], HORIZONTAL_ALIGNMENT_LEFT, NUM_W, 20,
				K.GOLD if best else Color.WHITE)
		var x := LABEL_W + bar_w * 0.5
		var y0 := 2.0
		var y1 := 4.0 + rows.size() * BAR_H
		while y0 < y1:
			draw_line(Vector2(x, y0), Vector2(x, minf(y0 + 6.0, y1)), Color(1, 1, 1, 0.7), 2.0)
			y0 += 11.0
		draw_string(font, Vector2(x - 60, y1 + 18), "even fight", HORIZONTAL_ALIGNMENT_CENTER, 120, 16, K.MUTED)
