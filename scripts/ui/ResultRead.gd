extends Control
## S538 RESULTV2 the modal "THE WHOLE READ" (owner Q-S294-303 "use tooltips/modals to shorten things"; approved picture
## ops/previews/s538_look/result_v2_modal.png): everything the summary says in pictures, in words, in five blocks - why it
## was lost and the measured fix; the plan's clue; what it cost; rank and the club; the cards. Close or Esc shuts it.
##   blocks(m, f, ctx) -> [{icon, col, title, lines: [[text, colour, size]]}]   ctx = {names, how, swing, record, scores}
##   open(main, m, f, ctx) -> the overlay (a child of main, named ResultRead)

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/TV.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")
const ResultTiles := preload("res://scripts/ui/ResultTiles.gd")
const ResultRounds := preload("res://scripts/ui/ResultRounds.gd")

const WIDE := 1120.0
const SIDES := ["your boxer", "the opponent"]


static func blocks(m: Dictionary, f: Dictionary, ctx: Dictionary) -> Array:
	var names: Array = ctx["names"]
	var win := bool(m.get("win", false))
	return [
		{"icon": "hand-fist", "col": UI.RED if not win else UI.GOLD, "title": "WHY IT WAS WON, AND WHAT TO SHARPEN" if win else "WHY IT WAS LOST, AND THE MEASURED FIX", "lines": _why(m, names, win)},
		{"icon": "clue", "col": UI.GOLD, "title": "THE PLAN'S CLUE", "lines": [[str(m.get("clue", ResultTiles.NO_CLUE)), UI.FG, 19]]},
		{"icon": "user", "col": UI.GREEN, "title": "WHAT IT COST YOUR BOXER", "lines": _cost(m)},
		{"icon": "ladder", "col": UI.MUTED, "title": "RANK AND THE CLUB", "lines": _club(m, ctx)},
		{"icon": "cards", "col": Palette.ACCENT, "title": "THE CARDS", "lines": _cards(m, ctx)}]


static func _why(m: Dictionary, names: Array, win: bool) -> Array:
	var out: Array = []
	var lab: Dictionary = m.get("fixlab", {})
	var ch: Dictionary = lab.get("changes", {})
	if not bool(lab.get("ok", false)) or ch.is_empty():
		var read := FightWhy.read(m["rounds"], str(names[0]), str(names[1]), str(m.get("opp_style", "")))
		out.append([str(read["against"]), UI.RED if not win else UI.FG, 21])
		out.append([str(read["next"]), UI.FG, 19])
		if bool(lab.get("ok", false)):
			out.append([_said(lab, names, win), UI.GOLD, 19])
		return out
	var rw: Dictionary = ch.get("rewrite", {})
	var add: Dictionary = ch.get("add", {})
	if not rw.is_empty():
		var sit := ResultCause._sit(str(rw["sit"]), names)
		out.append(["Line %s: %s into %s. Lost %d of the %d exchanges it was used in. The Playbook rates it %s against %s." % [str(rw["letter"]),
			ResultCause._move(str(rw["move"])), sit, int(rw["lost"]), int(rw["used"]), str(PlanLines.FIT_WORDS["wrong"]), sit], UI.RED, 21])
	if not add.is_empty():
		out.append(["Nothing in the plan for %s: lost %d of %d." % [ResultCause._sit(str(add["sit"]), names), int(add["lost"]), int(add["seen"])], UI.RED, 21 if rw.is_empty() else 19])
	var best := str(lab.get("best", ""))
	var lines: PackedStringArray = []
	for k in ["rewrite", "add"]:
		if ch.has(k) and (best == "both" or best == k or best == ""):
			lines.append(ResultCause._line_words(k, ch[k], names))
	var wins: PackedStringArray = []
	var rows := ResultTiles.fix_rows(lab)
	for i in rows.size():
		wins.append(("%s wins %d of %d" if i == 0 else "%s, %d of %d") % [str(rows[i][0]) if i == 0 else str(rows[i][0]).to_lower(), int(rows[i][1]), int(lab["nights"])])
	out.append(["%s: %s. %s." % ["The fix" if best != "" else "Changes tried (none beats luck)", "; ".join(lines), "; ".join(wins)], UI.FG, 19])
	out.append([_said(lab, names, win), UI.GOLD if str(lab.get("verdict", "")) != "fixed" else UI.GREEN, 19])
	if bool(m.get("fix_done", false)):
		out.append(["The fix is in the plan for the next bout.", UI.GREEN, 19])
	out.append([ResultTiles.measured(lab), UI.MUTED, 16])
	return out


static func _said(lab: Dictionary, names: Array, win: bool) -> String:
	var l: Label = ResultCause._verdict(lab, names, win)
	var text := l.text
	l.free()
	return text


static func _cost(m: Dictionary) -> Array:
	var out: Array = []
	for t in m.get("aftermath", []):
		if str((t as Dictionary).get("id", "")) == "damage":
			out.append(["%s. %s" % [str(t["big"]), " ".join(PackedStringArray(t.get("lines", [])))], UI.FG, 19])
	var tl := ResultRounds.tally(m)
	var folds: Array = tl[3]
	out.append(["%d times hurt, %d times the opponent was hurt, %d standing count%s%s." % [int(tl[0]), int(tl[1]), int(tl[2]), "" if int(tl[2]) == 1 else "s",
		"" if folds.is_empty() else " (body knockdown from the liver: %s)" % ", ".join(PackedStringArray(folds))], UI.FG, 19])
	var rep: Dictionary = m.get("body_report", {})
	if str(rep.get("line", "")) != "":
		out.append([str(rep["line"]), UI.FG, 19])
	return out


static func _club(m: Dictionary, ctx: Dictionary) -> Array:
	var out: Array = []
	var rank := str(m.get("rank_words", ""))
	for t in m.get("aftermath", []):
		if str((t as Dictionary).get("id", "")) == "rank":
			var more := " ".join(PackedStringArray((t.get("lines", []) as Array).filter(func(l): return str(l) != rank)))
			rank = (rank + " " + more).strip_edges()
	out.append([(rank + " " if rank != "" else "") + str(ctx.get("record", "")) + ".", UI.FG, 19])
	var words: PackedStringArray = []
	for t in ResultTiles.take(m):
		words.append(str(t["words"]))
	out.append([" ".join(words), UI.FG, 19])
	for k in ["card_ask", "visit_note"]:
		if str(m.get(k, "")) != "":
			out.append([str(m[k]), UI.GREEN if k == "card_ask" else UI.MUTED, 19])
	return out


static func _cards(m: Dictionary, ctx: Dictionary) -> Array:
	var out: Array = []
	var head := str(ctx.get("how", "")) + "."
	if str(ctx.get("swing", "")) != "":
		head += " " + str(ctx["swing"])
	var cards: Array = m.get("cards", [])
	if str(m.get("stopped", "")) == "" and not cards.is_empty():
		var parts: PackedStringArray = []
		for j in cards.size():
			parts.append("judge %d %s" % [j + 1, str(cards[j])])
		head += " The cards, your boxer's score first: %s." % ", ".join(parts)
	out.append([head, UI.FG, 19])
	var scores: Array = ctx.get("scores", [])
	var rounds: Array = m["rounds"]
	var per: PackedStringArray = []
	var energy: PackedStringArray = []
	for i in rounds.size():
		var r: Dictionary = rounds[i]
		var exs: Array = r.get("exchanges", [])
		var won := exs.filter(func(x): return bool(x["won"])).size()
		var js := ""
		if i < scores.size():
			js = " " + "/".join(PackedStringArray((scores[i] as Array).map(func(sc): return "%d-%d" % [int(sc[0]), int(sc[1])])))
		per.append("round %d %s%s (exchanges %d-%d)" % [i + 1, SIDES[0] if bool(r["won"]) else SIDES[1], js, won, exs.size() - won])
		var en: Dictionary = r.get("energy", {})
		if not en.is_empty():
			energy.append("%d v %d" % [roundi(float(en.get("a_end", 0))), roundi(float(en.get("b_end", 0)))])
	var text := ", ".join(per)
	out.append([text.substr(0, 1).to_upper() + text.substr(1) + ".", UI.FG, 19])
	if not energy.is_empty():
		out.append(["Energy at the bell, yours v theirs: %s." % ", ".join(energy), UI.FG, 19])
	return out


static func open(main: Node, m: Dictionary, f: Dictionary, ctx: Dictionary) -> Control:
	var old := main.find_child("ResultRead", false, false)
	if old != null:
		main.remove_child(old)
		old.queue_free()
	var o: Control = new()
	o.name = "ResultRead"
	o.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	o.mouse_filter = Control.MOUSE_FILTER_STOP
	var dim := ColorRect.new()
	dim.color = Color(Palette.PAGE, 0.80)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	o.add_child(dim)
	var centre := CenterContainer.new()
	centre.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	o.add_child(centre)
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Palette.HOVER, UI.GOLD, 8, 2, 34, 28))
	p.custom_minimum_size = Vector2(WIDE, 0)
	centre.add_child(p)
	var v := UI.vbox(12)
	p.add_child(v)
	var head := UI.hbox(12)
	head.add_child(UI.display("THE WHOLE READ", 40, Palette.TEXT))
	head.add_child(UI.spacer())
	var close := UI.button("Close", "Btn", o.shut)
	close.name = "ReadClose"
	close.custom_minimum_size = Vector2(110, 44)
	close.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(close)
	v.add_child(head)
	v.add_child(UI.label("Everything the summary says in pictures, in words. Esc closes it.", 18, UI.MUTED))
	for b in blocks(m, f, ctx):
		var line := ColorRect.new()
		line.color = Color(Palette.TEXT, 0.12)
		line.custom_minimum_size = Vector2(0, 1)
		v.add_child(line)
		var row := UI.hbox(20)
		var ic := ResultTiles.icon(str(b["icon"]), 34, b["col"])
		ic.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		row.add_child(ic)
		var col := UI.vbox(3)
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var t := UI.caps(str(b["title"]))
		t.add_theme_color_override("font_color", UI.GOLD)
		col.add_child(t)
		for l in b["lines"]:
			if str(l[0]).strip_edges() == "":
				continue
			var lb := UI.label(str(l[0]), int(l[2]), l[1], "bold" if int(l[2]) > 19 else "body", true)
			lb.custom_minimum_size = Vector2(WIDE - 140.0, 0)
			col.add_child(lb)
		row.add_child(col)
		v.add_child(row)
	main.add_child(o)
	return o


func shut() -> void:
	if get_parent() != null:
		get_parent().remove_child(self)
	queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_viewport() != null:
			get_viewport().set_input_as_handled()
		shut()
