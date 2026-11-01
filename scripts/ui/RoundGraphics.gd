extends RefCounted
## S320 (operator on the round and result screens: "these needs much better visuals for the player to understand what
## happenned"; "you change the menu concept, try more modern panels"): the fight's numbers as pictures - who won each
## 30 seconds, the punches landed side by side, the energy left, the rounds so far, each judge's round-by-round card and
## what decided it as tiles. Builders only; FightNight puts them on the round and result pages.
##   strip(exchanges)  versus(rows, names)  energy(a, b)  rounds(rounds)  judges(rounds, cards)  decided(lines)
##   tile(title, value, colour)  totals(exchanges)

const UI := preload("res://scripts/ui/TV.gd")  # S333: fight graphics keep the dark TV look
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")

## Her corner and the opponent's, as on the scorebug.
const HERS := Color(0.86, 0.26, 0.22)
const THEIRS := Color(0.26, 0.47, 0.88)
const TRACK := Color(1, 1, 1, 0.08)
const EX_SECONDS := 30


## Six tiles, one per 30 seconds, in the colour of whoever won it; "SHOUT" under the ones you shouted (green: it worked).
static func strip(exchanges: Array) -> HBoxContainer:
	var row := UI.hbox(6)
	for x in exchanges:
		var won := bool(x["won"])
		var tile := PanelContainer.new()
		tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tile.add_theme_stylebox_override("panel", UI.box(HERS if won else THEIRS, Color(0, 0, 0, 0), 8, 0, 6, 6))
		var v := UI.vbox(0)
		tile.add_child(v)
		var t := UI.mono("%d:%02d" % [((int(x["i"]) + 1) * EX_SECONDS) / 60, ((int(x["i"]) + 1) * EX_SECONDS) % 60], UI.SMALL, Color.WHITE)
		t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(t)
		var said := ""
		var said_c := Color(1, 1, 1, 0.85)
		if bool(x.get("shout", false)):
			var worked := won and str(x.get("fit", "")) in ["best", "ok"]
			said = "SHOUT" if worked else "SHOUT X"
			said_c = Color("#d9ffd9") if worked else Color("#ffd2cc")
		elif str(x.get("setup", "")) != "":
			said = "SET-UP"
		elif not (x.get("read", {}) as Dictionary).is_empty():   # S333 THE READ
			said = "READ IT" if str(x["read"]["result"]) == "landed" else "WENT EARLY"
		var s := UI.label(said if said != "" else " ", UI.TINY, said_c, "bold")
		s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(s)
		row.add_child(tile)
	return row


## [[label, hers, theirs], ...] as two-sided bars: her number left, theirs right, the bar split by share.
static func versus(rows: Array) -> VBoxContainer:
	var v := UI.vbox(8)
	for r in rows:
		var a := float(r[1])
		var b := float(r[2])
		var head := UI.hbox(8)
		head.add_child(UI.mono(str(int(a)), UI.SMALL, UI.FG))
		var lab := UI.muted(str(r[0]), UI.TINY)
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		head.add_child(lab)
		head.add_child(UI.mono(str(int(b)), UI.SMALL, UI.FG))
		v.add_child(head)
		var bar := HBoxContainer.new()
		bar.add_theme_constant_override("separation", 3)
		bar.custom_minimum_size = Vector2(0, 10)
		var share := 0.5 if a + b <= 0.0 else a / (a + b)
		for side in 2:
			var c := ColorRect.new()
			c.color = HERS if side == 0 else THEIRS
			c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			c.size_flags_stretch_ratio = maxf(0.02, share if side == 0 else 1.0 - share)
			bar.add_child(c)
		v.add_child(bar)
	return v


## Energy left at the bell, both (0..100): a bar each, filling from the outside in, coloured by how much is left.
static func energy(a: float, b: float) -> VBoxContainer:
	var v := UI.vbox(4)
	var head := UI.hbox(8)
	head.add_child(UI.mono(str(int(a)), UI.SMALL, UI.FG))
	var lab := UI.muted("Energy at the bell", UI.TINY)
	lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(lab)
	head.add_child(UI.mono(str(int(b)), UI.SMALL, UI.FG))
	v.add_child(head)
	var row := UI.hbox(10)
	for side in 2:
		var e := clampf(a if side == 0 else b, 0.0, 100.0)
		var track := HBoxContainer.new()
		track.add_theme_constant_override("separation", 0)
		track.custom_minimum_size = Vector2(0, 10)
		track.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var fill := ColorRect.new()
		fill.color = UI.GREEN if e >= 60.0 else (UI.AMBER if e >= 30.0 else UI.RED)
		fill.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fill.size_flags_stretch_ratio = maxf(0.01, e)
		var rest := ColorRect.new()
		rest.color = TRACK
		rest.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rest.size_flags_stretch_ratio = maxf(0.01, 100.0 - e)
		# Hers fills from her (left) edge, theirs from the right edge.
		track.add_child(fill if side == 0 else rest)
		track.add_child(rest if side == 0 else fill)
		row.add_child(track)
	v.add_child(row)
	return v


## The rounds so far as numbered chips in the winner's colour.
static func rounds(all: Array) -> HBoxContainer:
	var row := UI.hbox(6)
	row.add_child(UI.muted("Rounds", UI.TINY))
	for i in all.size():
		var chip := PanelContainer.new()
		chip.add_theme_stylebox_override("panel", UI.box(HERS if bool(all[i]["won"]) else THEIRS, Color(0, 0, 0, 0), 6, 0, 10, 2))
		chip.add_child(UI.mono(str(i + 1), UI.SMALL, Color.WHITE))
		row.add_child(chip)
	return row


## Her landed punches, her body shots, and theirs, over a round's exchanges: {landed: [a, b], body: [a, b], won: [a, b]}.
static func totals(exchanges: Array) -> Dictionary:
	var out := {"landed": [0, 0], "body": [0, 0], "won": [0, 0]}
	for x in exchanges:
		for s in 2:
			out["landed"][s] += int((x.get("landed", [0, 0]) as Array)[s])
			out["body"][s] += int((x.get("body", [0, 0]) as Array)[s])
		out["won"][0 if bool(x["won"]) else 1] += 1
	return out


## Each judge's card round by round (10-9 tiles in the winner's colour) and the total. The cards follow BoutRules.scorecards:
## two judges score every round to its winner; the third gives the closest round of the majority the other way.
static func judges(all: Array, cards: Array) -> HBoxContainer:
	var won: Array = all.map(func(r): return bool(r["won"]))
	var her := won.count(true)
	var flip := -1
	if cards.size() >= 3 and str(cards[2]) != str(cards[0]):
		var best := INF
		for i in all.size():
			if bool(won[i]) == (her * 2 >= all.size()) and absf(float(all[i].get("mine", 0.0))) < best:
				best = absf(float(all[i].get("mine", 0.0)))
				flip = i
	var row := UI.hbox(10)
	for j in cards.size():
		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 12, 10))
		var v := UI.vbox(6)
		card.add_child(v)
		v.add_child(UI.caps("JUDGE %d" % (j + 1)))
		var tiles := UI.hbox(4)
		for i in all.size():
			var w := bool(won[i]) != (j == 2 and i == flip)
			var t := PanelContainer.new()
			t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			t.add_theme_stylebox_override("panel", UI.box(HERS if w else THEIRS, Color(0, 0, 0, 0), 5, 0, 4, 2))
			var l := UI.mono("10-9" if w else "9-10", UI.TINY, Color.WHITE)
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			t.add_child(l)
			tiles.add_child(t)
		v.add_child(tiles)
		var parts := str(cards[j]).split("-")
		var mine := int(parts[0]) > int(parts[1])
		v.add_child(UI.mono(str(cards[j]), UI.BODY, HERS.lightened(0.3) if mine else THEIRS.lightened(0.3)))
		row.add_child(card)
	return row


## "What decided it" lines as tiles: the part before ":" is the tile's title ("The film study: ..." -> FILM STUDY).
static func decided(lines: Array) -> HFlowContainer:
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 10)
	flow.add_theme_constant_override("v_separation", 10)
	for line in lines:
		var s := str(line)
		var title := "WHY"
		var body := s
		if s.contains(": "):
			title = s.get_slice(": ", 0).trim_prefix("The ").to_upper()
			body = s.substr(s.find(": ") + 2)
			body = body.substr(0, 1).to_upper() + body.substr(1)
		elif s.begins_with("Your corner call"):
			title = "YOUR CORNER"
		flow.add_child(tile(title, body, UI.GOLD))
	return flow


## A panel tile: a coloured title over a line.
static func tile(title: String, value: String, colour: Color, big: bool = false) -> PanelContainer:
	var p := PanelContainer.new()
	p.custom_minimum_size = Vector2(260, 0)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 14, 10))
	var v := UI.vbox(4)
	p.add_child(v)
	var t := UI.caps(title)
	t.add_theme_color_override("font_color", colour)
	v.add_child(t)
	v.add_child(UI.mono(value, 28, UI.FG) if big else UI.label(value, UI.SMALL, UI.FG, "body", true))
	return p


## One boxer's body map figure on her own body (BodyLive keeps the bout's map in the modal), or null with no map.
static func body(map: Dictionary, side: String, glb: String, corner: String, track: Dictionary = {}) -> Control:
	if map.is_empty():
		return null
	var fig: Control = BodyFigure.new()
	fig.custom_minimum_size = Vector2(168, 235)   # S324 C149 bigger (was 120 x 168)
	fig.clay = 0.0   # S352 CORNERFIG1 (operator: "a pale mannequin"): her own kit on the corner card and the result page
	fig.set_portrait(BodyFigure.portrait_for(glb, corner))
	var vals := {}
	for p in BodyMap.PLACES:
		vals[p] = BodyMap.value(map, side, p)
	fig.set_values(vals)
	if track.has(side):
		fig.set_track(track[side])   # S323: the body track (BodyBurn) on the pages too
	return fig
