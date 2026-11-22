extends RefCounted
## S538 RESULTV2 (owner Q-S294-303 "the result page needs more graphics,use tooltips/modals to shorten things"; the approved
## picture ops/previews/s538_look/result_v2.png). Two cards of the result's SUMMARY tab:
##   card(m, names, lab, scores) -> ROUND BY ROUND: a row a round - the exchanges won, a square a judge, a bar an exchange
##       (up = your boxer's, down = the opponent's, as tall as the margin in punches landed), both energy bars.
##       scores[round][judge] = [ours, theirs] (ResultPage._score); [] on a stopped bout (no cards).
##   cost(main, m, f) -> WHAT IT COST: the boxer's figure with the bout's marks (ResultMarks), the punches taken to the head
##       and to the body, the damage word, times hurt / the opponent hurt / standing counts, the body report's one button.
## Names stay in the header (S448): "your boxer" and "the opponent" here.

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/TV.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")
const ResultMarks := preload("res://scripts/ui/ResultMarks.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")
const AftermathTiles := preload("res://scripts/ui/AftermathTiles.gd")
const Tip := preload("res://scripts/ui/Tip.gd")

const SIDES := ["your boxer", "the opponent"]


static func card(m: Dictionary, names: Array, lab: Dictionary, scores: Array) -> PanelContainer:
	var p := ResultCause.panel("")
	p.name = "RoundStrip"
	var v: VBoxContainer = p.get_child(0)
	var head := UI.hbox(10)
	var t := UI.caps("ROUND BY ROUND")
	t.add_theme_color_override("font_color", UI.GOLD)
	t.add_theme_font_size_override("font_size", 18)
	head.add_child(t)
	head.add_child(UI.spacer())
	head.add_child(UI.label("bar up = your boxer's exchange · down = the opponent's", 16, UI.MUTED))
	v.add_child(head)
	var cause := str(((lab.get("changes", {}) as Dictionary).get("rewrite", {}) as Dictionary).get("move", ""))
	var rounds: Array = m["rounds"]
	for i in rounds.size():
		if i > 0:
			v.add_child(_rule())
		v.add_child(_round(rounds[i], i, names, cause, scores[i] if i < scores.size() else []))
	if not scores.is_empty():
		var key := UI.hbox(5)
		for c in [Broadcast.HERS, Broadcast.HERS, Broadcast.THEIRS]:
			key.add_child(_sq(c))
		key.add_child(UI.label("  a square a judge, in the colour of the boxer the round went to · hover a round for its words", 16, UI.MUTED))
		v.add_child(key)
	return p


static func _round(r: Dictionary, i: int, names: Array, cause: String, judges: Array) -> HBoxContainer:
	var h := UI.hbox(16)
	h.name = "Round%d" % (i + 1)
	var exs: Array = r.get("exchanges", [])
	var won := exs.filter(func(x): return bool(x["won"])).size()
	var left := UI.vbox(0)
	left.name = "Score"
	left.custom_minimum_size = Vector2(104, 0)
	left.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	left.add_child(UI.label("ROUND %d" % (i + 1), 24, Palette.TEXT, "display"))
	left.add_child(UI.display("%d-%d" % [won, exs.size() - won], 36, (Broadcast.HERS if bool(r["won"]) else Broadcast.THEIRS).lightened(0.3)))
	var ours := 0
	if not judges.is_empty():
		var dots := UI.hbox(5)
		for sc in judges:
			ours += int(int(sc[0]) > int(sc[1]))
			dots.add_child(_sq(Broadcast.HERS if int(sc[0]) > int(sc[1]) else (Broadcast.THEIRS if int(sc[0]) < int(sc[1]) else Palette.LINE)))
		left.add_child(dots)
	var said := "Your boxer won %d of the %d exchanges." % [won, exs.size()]
	if not judges.is_empty():
		var cards := ", ".join(PackedStringArray(judges.map(func(sc): return "%d-%d" % [int(sc[0]), int(sc[1])])))
		said += " The judges scored it %s: %d for %s." % [cards, maxi(ours, judges.size() - ours), SIDES[0] if ours * 2 > judges.size() else SIDES[1]]
	elif str(r.get("down", "")) != "":
		said += " The round ended early."
	Tip.short(left, "ROUND %d" % (i + 1), said, "A judge scores the whole round, not the count of exchanges.")
	h.add_child(left)
	var row := UI.hbox(4)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for x in exs:
		row.add_child(_exchange(x, r, names, cause))
	h.add_child(row)
	var en: Dictionary = r.get("energy", {})
	if not en.is_empty():
		var e := UI.vbox(6)
		e.name = "Energy"
		e.custom_minimum_size = Vector2(150, 0)
		e.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		e.add_child(_gauge("Energy, yours", float(en.get("a_end", 0)), Broadcast.HERS))
		e.add_child(_gauge("theirs", float(en.get("b_end", 0)), Broadcast.THEIRS))
		Tip.short(e, "ENERGY AT THE BELL", "What each boxer had left in the tank when the round ended, out of 100.", "Compare the two: the fresher boxer carries more into the next round.")
		h.add_child(e)
	return h


## One exchange: its bar, the punches landed under it, the plan line used (its letter, a tick or a cross) and HURT.
static func _exchange(x: Dictionary, r: Dictionary, names: Array, cause: String) -> VBoxContainer:
	var won := bool(x["won"])
	var l: Array = x.get("landed", [0, 0])
	var v := UI.vbox(0)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.mouse_filter = Control.MOUSE_FILTER_PASS
	v.tooltip_text = ResultTabs._tip(x, names)
	var bar := ExBar.new()
	bar.won = won
	bar.margin = absi(int(l[0]) - int(l[1]))
	bar.gold = bool(x.get("planned", false)) and str(x.get("arrow", "")) == cause and cause != ""
	bar.custom_minimum_size = Vector2(34, 58)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(bar)
	var sc := UI.label("%d-%d" % [int(l[0]), int(l[1])], 17, Palette.TEXT, "bold")
	sc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(sc)
	var mark := ""
	var col: Color = UI.MUTED
	var letter := ResultTabs._letter(r, str(x.get("arrow", ""))) if bool(x.get("planned", false)) else ""
	if letter != "":
		mark = letter + (" ✓" if won else " ✕")
		col = ResultTabs.FIT_COL.get(str(x.get("arrow_fit", "none")), UI.MUTED)
	if bool(((x.get("after", {}) as Dictionary).get("hurt", [false, false]) as Array)[0]):
		mark = (mark + " " if mark != "" else "") + "HURT"
		col = UI.AMBER
	var tag := UI.label(mark if mark != "" else " ", 14, col, "bold")
	tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(tag)
	return v


static func _gauge(text: String, val: float, col: Color) -> VBoxContainer:
	var v := UI.vbox(3)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var top := UI.hbox(6)
	top.add_child(UI.label(text, 16, UI.MUTED))
	top.add_child(UI.spacer())
	top.add_child(UI.label("%d" % roundi(val), 16, Palette.TEXT, "bold"))
	v.add_child(top)
	var track := UI.hbox(0)
	track.custom_minimum_size = Vector2(0, 7)
	for part in [[col, clampf(val, 0.0, 100.0)], [Color(Palette.TEXT, 0.10), 100.0 - clampf(val, 0.0, 100.0)]]:
		var c := ColorRect.new()
		c.color = part[0]
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		c.size_flags_stretch_ratio = maxf(float(part[1]), 0.001)
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		track.add_child(c)
	v.add_child(track)
	return v


static func _sq(col: Color) -> ColorRect:
	var c := ColorRect.new()
	c.color = col
	c.custom_minimum_size = Vector2(14, 14)
	c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


static func _rule() -> ColorRect:
	var c := ColorRect.new()
	c.color = Color(Palette.TEXT, 0.10)
	c.custom_minimum_size = Vector2(0, 1)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


## What the bout cost your boxer.
static func cost(main: Node, m: Dictionary, f: Dictionary) -> PanelContainer:
	var p := ResultCause.panel("WHAT IT COST YOUR BOXER")
	p.name = "Cost"
	var v: VBoxContainer = p.get_child(0)
	var st := FightStats.of(m["rounds"])
	var took := int(st["landed"][1])
	var body := int(st["body"][1])
	var dmg := {}
	for t in m.get("aftermath", []):
		if str((t as Dictionary).get("id", "")) == "damage":
			dmg = t
	var bodies: Array = m.get("bodies", ["", ""])
	var fig: Control = ResultMarks.figure(m.get("body_map", {}), "a", str(bodies[0]), "red", m.get("body_track", {}))
	var marked := fig != null and fig.has_meta("result_size")   # close-ups pinned either side: the counts go above
	if marked:
		fig.custom_minimum_size = fig.get_meta("result_size")
	var head := _count(took - body, "punches to the head", "HeadCount", "Every punch that landed on your boxer's head: jabs count the same as big shots here.")
	var ribs := _count(body, "punches to the body", "BodyCount", "Punches that landed on the ribs and liver. Body work drains the tank round after round.")
	var word := UI.vbox(0)
	word.name = "Damage"
	word.mouse_filter = Control.MOUSE_FILTER_PASS
	var big := UI.display(str(dmg.get("big", "%d punches taken" % took)).to_upper(), 24, AftermathTiles.TONE.get(str(dmg.get("tone", "flat")), UI.FG))
	big.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	word.add_child(big)
	var sub := UI.label("took %d punch%s" % [took, "" if took == 1 else "es"], 16, UI.MUTED)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	word.add_child(sub)
	word.tooltip_text = "\n".join(PackedStringArray(dmg.get("lines", [])))
	if fig != null:
		fig.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		fig.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if marked or fig == null:   # the figure keeps its own strips for the close-ups: the counts stand left of it, the word above
		var title := v.get_child(0) as Control
		var top := UI.hbox(12)
		v.remove_child(title)
		title.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		top.add_child(title)
		top.add_child(UI.spacer())
		top.add_child(word)
		v.add_child(top)
		var mid := UI.hbox(8)
		var counts := UI.vbox(18)
		counts.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		counts.add_child(head)
		counts.add_child(ribs)
		mid.add_child(counts)
		if fig != null:
			var c := CenterContainer.new()
			c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			c.add_child(fig)
			mid.add_child(c)
		v.add_child(mid)
	else:
		var mid2 := UI.hbox(8)
		head.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		mid2.add_child(head)
		var c2 := CenterContainer.new()
		c2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		c2.add_child(fig)
		mid2.add_child(c2)
		var right := UI.vbox(26)
		right.add_child(word)
		right.add_child(ribs)
		mid2.add_child(right)
		v.add_child(mid2)
	v.add_child(_rule())
	v.add_child(_facts(m))
	var focus := ResultTabs.body_focus(main, m, f)   # the body report's one action: train the part that went first
	if focus != null:
		if focus.get_child_count() == 2:   # its sentence and its button side by side: the card stays one screen tall
			var line := focus.get_child(0) as Control
			var btn := focus.get_child(1) as Control
			focus.remove_child(line)
			focus.remove_child(btn)
			focus.free()
			focus = UI.hbox(12)
			line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			line.custom_minimum_size = Vector2(150, 0)
			btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			focus.add_child(line)
			focus.add_child(btn)
		v.add_child(focus)
	return p


static func _count(n: int, words: String, node_name: String, tip: String) -> VBoxContainer:
	var v := UI.vbox(0)
	v.name = node_name
	v.add_child(UI.display("%d" % n, 44, Palette.TEXT))
	var l := UI.label(words, 16, UI.MUTED, "body", true)
	l.custom_minimum_size = Vector2(96, 0)
	v.add_child(l)
	Tip.short(v, words.to_upper(), tip)
	return v


## Times hurt, times the opponent was hurt, standing counts: [hurt, dealt, counts, liver folds as "round n"].
static func tally(m: Dictionary) -> Array:
	var hurt := 0
	var dealt := 0
	var folds: Array = []   # S467 LIVERRIBS1: which counts were body knockdowns from the liver
	for r in m["rounds"]:
		for x in (r as Dictionary).get("exchanges", []):
			var hh: Array = ((x as Dictionary).get("after", {}) as Dictionary).get("hurt", [false, false])
			hurt += int(bool(hh[0]))
			dealt += int(bool(hh[1]))
		if bool((r as Dictionary).get("liver_fold", false)) and str((r as Dictionary).get("down", "")) == "a":
			folds.append("round %d" % int((r as Dictionary).get("n", 0)))
	return [hurt, dealt, int((m.get("counts", {}) as Dictionary).get("a", 0)), folds]


static func _facts(m: Dictionary) -> HBoxContainer:
	var tl := tally(m)
	var folds: Array = tl[3]
	var count_tip := "Counts from the referee in the bout." + ("" if folds.is_empty() else " Body knockdown (liver): %s." % ", ".join(PackedStringArray(folds)))
	var facts := UI.hbox(6)
	facts.name = "CostFacts"
	for fact in [["%d" % int(tl[0]), "times hurt", UI.AMBER if int(tl[0]) > 0 else UI.GREEN, "Exchanges your boxer finished hurt (the opponent won one big)."],
			["%d" % int(tl[1]), "times the opponent was hurt", UI.FG, "Exchanges the opponent finished hurt: the same count the other way."],
			["%d" % int(tl[2]), "standing counts" if folds.is_empty() else "counts, %d from the liver" % folds.size(), UI.RED if int(tl[2]) > 0 else UI.GREEN, count_tip]]:
		var cell := UI.vbox(0)
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cell.mouse_filter = Control.MOUSE_FILTER_PASS
		cell.tooltip_text = str(fact[3])
		var n := UI.display(str(fact[0]), 36, fact[2])
		n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cell.add_child(n)
		var w := UI.label(str(fact[1]), 16, UI.MUTED, "body", true)
		w.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		w.custom_minimum_size = Vector2(138, 0)
		cell.add_child(w)
		facts.add_child(cell)
	return facts


## One exchange's bar: up from the line for your boxer, down for the opponent, taller with the margin; gold-edged when the
## exchange used the line the cause card names.
class ExBar extends Control:
	const P := preload("res://scripts/ui/Palette.gd")
	const BC := preload("res://scripts/ui/Broadcast.gd")
	var won := false
	var margin := 0
	var gold := false

	func _draw() -> void:
		var mid := size.y * 0.5
		draw_line(Vector2(0, mid), Vector2(size.x, mid), Color(P.TEXT, 0.22), 2.0)
		var w := minf(size.x - 6.0, 30.0)
		var h := clampf(5.0 + 7.0 * float(margin), 5.0, mid - 2.0)
		var rect := Rect2((size.x - w) * 0.5, mid - h if won else mid, w, h)
		draw_rect(rect, BC.HERS if won else BC.THEIRS)
		if gold:
			draw_rect(rect, P.HEADER, false, 2.0)
