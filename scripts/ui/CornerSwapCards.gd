extends RefCounted
## S442 LOOP drawing 1 (owner: "All three"; docs/mockups/s442/loop/corner_cards.png): the corner minute's PLAN row as
## swap cards. The line that lost most (LineSwap.lost_most over the bout so far) with its tally and the situation it is
## rated in; up to two rated lines to swap into it (LineSwap.options), each one click; "Keep the plan"; "Other changes"
## (today's full list, so nothing a player could do before is lost); the ring strip: where each plan line fires, the
## hovered card's line drawn to its place. A swap writes sel["arrow"] = {i, move}, the same path the dropdown uses
## (CornerJobsRow.suffix -> "|arrow=i:move" -> BoutNight -> PlanFight.corner_change = LineSwap.apply).
##   row(f, round_exs, arrows, limit) -> LineSwap.row + {round_game} or {}     build(mn, sel, on_change, other, ink, mute) -> VBox

const UI := preload("res://scripts/ui/UI.gd")
const TV := preload("res://scripts/ui/TV.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const LineSwap := preload("res://scripts/rules/LineSwap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const SwapLink := preload("res://scripts/ui/SwapLink.gd")

## The drawing's colours: green = Beats it, red = the lost line / Walks into it, cream = hover (CallButtons.GRADE_COLOR).
const GOOD := Color("#6cc27a")
const FAIR := Color("#f0a020")
const POOR := Color("#e06060")
const CARD_BG := Color("#211a15")
const EDGE := Color("#4a3a30")
const W := 302.0


## What the minute shows ({} when no planned line lost): rated over every exchange of the bout so far. The bout's running
## tally of each line (LiveRound "plan_tally", [won, thrown]) stands in for the exchanges, so the 3D corner and the
## words page read the same thing without the rounds list.
static func row(f: Dictionary, round_exs: Array, arrows: Array, limit: int) -> Dictionary:
	var b: Dictionary = f.get("bout", {})
	var got := LineSwap.row(arrows, exs_from_tally(b.get("plan_tally", {})), round_exs, f.get("moves", {}), f.get("combos", {}), limit)
	if not got.is_empty():
		got["round_game"] = LineSwap.shown_game(round_exs)
	return got


## {arrow: [won, thrown]} -> the exchange records LineSwap counts (first thrown first: the tally keeps that order).
static func exs_from_tally(tally: Dictionary) -> Array:
	var out: Array = []
	for arrow in tally.keys():
		var wt: Array = tally[arrow]
		for k in int(wt[1]):
			out.append({"planned": true, "arrow": str(arrow), "won": k < int(wt[0]), "at": str(StrikeMap.move(str(arrow)).get("from", ""))})
	return out


static func letter(i: int) -> String:
	return char(65 + i)


static func build(mn: Dictionary, sel: Dictionary, on_change: Callable, other: OptionButton, ink: Color, mute: Color) -> VBoxContainer:
	var sw: Dictionary = mn["swap"]
	var lost: Dictionary = sw["lost"]
	var arrows: Array = mn.get("arrows", [])
	var li := LineSwap._plan_index(arrows, str(lost["move"]))
	var box := UI.vbox(6)
	box.name = "SwapCards"
	box.add_child(_header(letter(li), str(lost["tally"]), str(sw.get("game_words", ""))))
	var cards := UI.hbox(12)
	var cur: Dictionary = sel.get("arrow", {})
	var tiles := _strip(arrows, str(sw.get("round_game", "")))
	var link := SwapLink.new()
	link.pin_name = "Pin_" + letter(li)
	for o in sw["options"]:
		var on := not cur.is_empty() and int(cur["i"]) == int(o["i"]) and str(cur["move"]) == str(o["move"])
		var c := _card(o, letter(li), float(PlanFight.rate(str(o["move"]), mn.get("combos", {}))), on, func():
			sel["arrow"] = {} if on else {"i": int(o["i"]), "move": str(o["move"])}
			on_change.call())
		var tile: Control = tiles.get_meta("tiles", {}).get(str(lost["at"]), null)
		c.mouse_entered.connect(link.point.bind(c, tile, "%s → %s" % [letter(li), str(o["name"])]))
		c.mouse_exited.connect(link.point.bind(null, tile, ""))
		cards.add_child(c)
	var side := UI.vbox(10)
	var names := PackedStringArray()
	for i in arrows.size():
		names.append(letter(i))
	var stay := (names[0] + " stays") if names.size() == 1 else ("%s and %s stay" % [", ".join(names.slice(0, -1)), names[-1]] if names.size() <= 4 else "All %d lines stay" % names.size())
	var keep := UI.button2("Keep the plan", stay, "ChoiceOn" if cur.is_empty() else "Choice", func():
		sel["arrow"] = {}
		on_change.call(), Vector2(208, 58), ink, mute, false, UI.SMALL + 3, UI.SMALL + 2)
	keep.name = "KeepPlan"
	side.add_child(keep)
	other.fit_to_longest_item = false   # the list's longest line ("Mid range: Step back -> ...") set the row's width
	other.clip_text = true
	other.custom_minimum_size = Vector2(208, 40)
	other.tooltip_text = "Every other change: any line of the plan, or a new one where the fight went"
	side.add_child(other)
	cards.add_child(side)
	box.add_child(cards)
	box.add_child(tiles)
	box.add_child(link)
	return box


## "[C] LOST MOST  One-two-hook 1 of 2  |  (eye) Opponent waited to counter" on a dark strip with a red edge.
static func _header(l: String, tally: String, game: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "LostMost"
	var sb := UI.box(Color("#241c17"), POOR, 4, 0, 12, 4)
	sb.border_width_left = 4
	p.add_theme_stylebox_override("panel", sb)
	var h := UI.hbox(10)
	h.add_child(_pin(l, POOR))
	var cap := UI.label("LOST MOST", UI.SMALL + 1, TV.MUTED, "caps")
	h.add_child(cap)
	h.add_child(UI.label(tally, 21, TV.FG, "bold"))
	if game != "":
		var bar := ColorRect.new()
		bar.color = EDGE
		bar.custom_minimum_size = Vector2(2, 24)
		h.add_child(bar)
		h.add_child(Icons.icon("eye", 22, TV.MUTED, "The situation the line fires in: its cards are rated there"))
		h.add_child(UI.label(game, 20, TV.FG))
	p.add_child(h)
	return p


## One swap card, the whole card one click: name + fit chip, the worth bar (PlanFight.EDGE scale, the lost line's red
## tick), "+8 over improvising · C was -6", "Untrained: lands 80%" or "Ends at: Outside", and "Swap into C".
static func _card(o: Dictionary, l: String, rate: float, on: bool, press: Callable) -> Button:
	var b := UI.button("", "Choice", press)
	b.name = "Swap_" + str(o["move"])
	b.custom_minimum_size = Vector2(W, 128)
	for st in ["normal", "hover", "pressed", "focus", "hover_pressed"]:
		b.add_theme_stylebox_override(st, UI.box(CARD_BG if not on else Color("#3a2f26"), EDGE, 6, 1, 0, 0))
	var fit := str(o["fit"])
	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.add_theme_constant_override("separation", 2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var top := UI.hbox(8)
	top.add_child(UI.label(str(o["name"]), 23, TV.FG, "bold"))
	top.add_child(UI.spacer())
	if str(o.get("fit_words", "")) != "":
		var chip := PanelContainer.new()
		chip.add_theme_stylebox_override("panel", UI.box(GOOD if fit == "best" else (POOR if fit == "wrong" else Color("#5a5048")), Color(0, 0, 0, 0), 4, 0, 10, 1))
		chip.add_child(UI.label(str(o["fit_words"]), 19, Color("#0f2a17") if fit == "best" else TV.FG, "bold"))
		chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top.add_child(chip)
	v.add_child(_pad(top, 6))
	var wb := SwapLink.WorthBar.new()
	wb.was = float(o["was_worth"])
	wb.worth = float(o["worth"])
	wb.fill = GOOD if fit == "best" else Color("#cdbfa8")
	wb.custom_minimum_size = Vector2(W - 26, 12)
	v.add_child(_pad(wb, 0))
	v.add_child(_pad(UI.label("%+d over improvising · %s was %+d" % [roundi(float(o["worth"])), l, roundi(float(o["was_worth"]))], 19, TV.MUTED), 0))
	var to := str(StrikeMap.move(str(o["move"])).get("to", ""))
	if rate < 1.0:
		v.add_child(_pad(UI.label("Untrained: lands %d%%" % roundi(rate * 100.0), 19, FAIR, "bold"), 0))
	elif to != "" and to != str(StrikeMap.move(str(o["move"])).get("from", "")):
		v.add_child(_pad(UI.label("Ends at: " + str(StrikeMap.card(to).get("name", to)), 19, TV.MUTED), 0))
	var gap := Control.new()
	gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(gap)
	var foot := PanelContainer.new()
	var fsb := UI.box(Color("#2f2620"), Color("#6a5a4a"), 0, 0, 0, 3)
	fsb.border_width_top = 1
	fsb.corner_radius_bottom_left = 6
	fsb.corner_radius_bottom_right = 6
	foot.add_theme_stylebox_override("panel", fsb)
	foot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fh := UI.hbox(8)
	fh.alignment = BoxContainer.ALIGNMENT_CENTER
	fh.add_child(Icons.icon("swap", 20, TV.FG))
	fh.add_child(UI.label(("In the plan: %s" if on else "Swap into %s") % l, 19, TV.FG, "bold"))
	foot.add_child(fh)
	v.add_child(foot)
	b.add_child(v)
	b.tooltip_text = "%s instead of the line that lost most. It is worth %+d against improvising there; the line was %+d." % [
		str(o["name"]), roundi(float(o["worth"])), roundi(float(o["was_worth"]))]
	Halo.hover(b, Halo.CHALK, 6.0)
	if on:
		Halo.ring(b, Halo.CHALK, 6.0, 0.8)
	return b


static func _pad(c: Control, top: int) -> MarginContainer:
	var m := MarginContainer.new()
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_theme_constant_override("margin_left", 12)
	m.add_theme_constant_override("margin_right", 12)
	m.add_theme_constant_override("margin_top", top)
	m.add_child(c)
	return m


## StrikeMap's eight places, each plan letter on its place in the colour of its fit (its caption: caption()).
static func _strip(arrows: Array, round_game: String) -> HFlowContainer:
	var flow := HFlowContainer.new()
	flow.name = "LinesFire"
	flow.add_theme_constant_override("h_separation", 2)   # S443 2 (was 4) and slimmer chips: one line beside her figure
	flow.add_theme_constant_override("v_separation", 4)
	var tiles := {}
	for cd in StrikeMap.CARDS:
		var id := str(cd["id"])
		var p := PanelContainer.new()
		p.name = "Fire_" + id
		var h := UI.hbox(6)
		var col := UI.vbox(0)
		var here := false
		for i in arrows.size():
			var mv := str((arrows[i] as Dictionary).get("move", ""))
			if str(StrikeMap.move(mv).get("from", "")) != id:
				continue
			here = true
			var fit := PlanFight.fit(mv, PlanLines.sit_for(str((arrows[i] as Dictionary).get("when", "")), round_game))
			h.add_child(_pin(letter(i), {"best": GOOD, "ok": FAIR, "wrong": POOR}.get(fit, TV.FG), 17))
		var name_l := UI.label(str(cd["name"]), UI.TINY, TV.FG if here else TV.MUTED)   # S443 TINY: the eight places keep to one line beside her figure
		h.add_child(name_l)
		h.move_child(name_l, 0)
		col.add_child(h)
		var said := UI.label("", UI.SMALL, Halo.CHALK, "bold")
		said.name = "Said"
		said.visible = false
		col.add_child(said)
		p.add_child(col)
		p.add_theme_stylebox_override("panel", UI.box(Color("#1a1411"), Color("#3a2e26"), 4, 1, 4, 1))
		flow.add_child(p)
		tiles[id] = p
	flow.set_meta("tiles", tiles)
	return flow


## The strip's caption, set in the PLAN tag's column beside it so the eight places keep to one line on the 3D card.
static func caption(mute: Color) -> VBoxContainer:
	var v := UI.vbox(0)
	v.name = "LinesFireCaption"
	v.add_child(UI.label("WHERE THE", UI.SMALL, mute, "caps"))
	v.add_child(UI.label("LINES FIRE", UI.SMALL, mute, "caps"))
	return v


static func _pin(l: String, colour: Color, font: int = 22) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Pin_" + l
	p.add_theme_stylebox_override("panel", UI.box(Color("#120e0c"), colour, 4, 2, 7, 0))
	p.add_child(UI.label(l, font, TV.FG, "display"))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return p
