extends RefCounted
## S398 Fight prep's THE MATCHUP (operator on the text version: "this looks like a poor text-adventure. add graphics and
## stunning visuals"): the opponent's studio portrait, then one row per trait on her file - THEIR card (the move picture the
## trait is about, its kind and words) -> YOUR ANSWER card (the move picture of the answer, the words, Write it). A habit is
## the corner's read on the night (nothing to write); a trait still hidden is a grey card saying what opens it.
## Pictures: the game's own move pictures (assets/ui/moves, baked from the fighters) picked by the words; portraits:
## PromoShot (the studio photos). Every card says something the player acts on (the operator's S398 rule).
##   MatchupCards.make(main, career, fighter, opp, spars) -> PanelContainer "PrepAnswers"

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")

const MOVES := "res://assets/ui/moves/"
const PIC := 64
const KIND_ICON := {"style": "footprints", "weapon": "hand-fist", "habit": "refresh-cw", "weakness": "trending-down"}
const KIND_COL := {"style": "#0e7490", "weapon": "#b42318", "habit": "#7c3aed", "weakness": "#23935d"}
## S399 menu art A/B, arm "b" (PromoShot.ui_art): the kind's flat comic picture instead of the icon tile.
const KIND_PIC_B := {"style": "threat_game", "weapon": "threat_weapon", "habit": "threat_habit", "weakness": "threat_weakness"}
const PIC_B_DIR := "res://assets/ui/style_b/icons"
const KIND_WORD := {"style": "THEIR GAME", "weapon": "THEIR BEST WEAPON", "habit": "THEIR HABIT", "weakness": "THEIR WEAKNESS"}
## Words -> the move picture that shows them (first match wins).
const PICS := [["body", "body_hook"], ["uppercut", "rear_uppercut"], ["lead hook", "lead_hook"], ["left hook", "lead_hook"],
	["hook", "lead_hook"], ["cross", "cross"], ["right hand", "cross"], ["jab", "jab"], ["walks you down", "herd"],
	["press", "backed_up"], ["counter", "slip_2-3"], ["angle", "spins_out"], ["step off", "spins_out"], ["pivot", "spins_out"],
	["tie", "tie_up"], ["clinch", "tie_up"], ["step back", "step_back"], ["busy", "1-2-3"], ["fade", "1-2-3"],
	["hands drop", "jab"], ["feint", "feint"], ["step in", "step_in"], ["elbow", "step_back"]]


static func pic_for(words: String) -> Texture2D:
	var w := words.to_lower()
	for p in PICS:
		if w.contains(str(p[0])):
			var path := MOVES + str(p[1]) + ".png"
			if ResourceLoader.exists(path):
				return load(path)
	return null


static func make(main: Node, c: Career, f: Dictionary, opp: Dictionary, spars: Array) -> PanelContainer:
	var card := UI.card()
	card[0].name = "PrepAnswers"
	var v: VBoxContainer = card[1]
	var head := UI.hbox(14)
	head.add_child(UI.caps("THE MATCHUP - WHAT YOUR PLAN SHOULD ANSWER"))
	head.add_child(UI.spacer())
	var limit := PlanBoard.arrow_limit(Sim.coach_rating(c))
	var written := (f.get("arrows", []) as Array).size()
	var test := "test them at sparring %s" % Clock.fmt(int(spars[0])) if not spars.is_empty() else "no sparring left to test them"
	var lines := UI.label("Your plan: %d line%s written (the coach allows %d) - %s" % [written, "" if written == 1 else "s", limit, test], 16, UI.FG if written > 0 else UI.AMBER, "semi")
	lines.name = "PlanLines"
	head.add_child(lines)
	v.add_child(head)
	var body := UI.hbox(22)
	v.add_child(body)
	body.add_child(_portrait(f, opp))
	var rows := UI.vbox(10)
	rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(rows)
	var film := bool((f.get("camp", {}) as Dictionary).get("film", false))
	var corner: Array = []
	for t in OppFile.tells(opp):
		var id := str(t["id"])
		if id == "look":
			continue
		if OppFile.known(opp, id) and str(t["when"]) == "":   # a habit: the corner's call on the night
			corner.append(str(t["value"]).to_lower())
			continue
		rows.add_child(_row(main, opp, t, film))
	if not corner.is_empty():   # S398 critics: two rows nobody could act on, said once
		var cl := UI.label("The corner calls these on the night: %s." % ", ".join(corner), 16, UI.MUTED, "body", true)
		cl.name = "CornerCalls"
		rows.add_child(cl)
	return card[0]


## The opponent, large: the studio photo, the name, the record and game.
static func _portrait(f: Dictionary, opp: Dictionary) -> VBoxContainer:
	var col := UI.vbox(6)
	col.custom_minimum_size = Vector2(170, 0)
	var frame := PanelContainer.new()
	frame.add_theme_stylebox_override("panel", UI.box(Color("#1f2a44"), Color(0, 0, 0, 0), 12, 0, 0, 0))
	frame.clip_contents = true
	var pic := PromoShot.picture(str(Faces.pair(f, opp)[1]), Vector2(170, 210))
	if pic != null:
		frame.add_child(pic)
	else:
		frame.custom_minimum_size = Vector2(170, 210)
	col.add_child(frame)
	col.add_child(UI.label(str(opp.get("name", "")), 22, UI.FG, "bold"))
	col.add_child(UI.label("%d-%d, %s, %s" % [int(opp.get("w", 0)), int(opp.get("l", 0)), str(opp.get("stance", "")), str(opp.get("style", "")).to_lower()],
		15, UI.MUTED, "body", true))
	return col


## One trait: THEIR card -> YOUR ANSWER card (or the corner's read, or what opens a hidden one).
static func _row(main: Node, opp: Dictionary, t: Dictionary, film: bool) -> HBoxContainer:
	var id := str(t["id"])
	var kind := id.get_slice(":", 0)
	var row := UI.hbox(12)
	row.name = "Trait_" + id.replace(":", "_")
	if not OppFile.known(opp, id):
		row.add_child(_card(null, KIND_WORD.get(kind, str(t["what"]).to_upper()), "Not found yet",
			"opens on tape in this camp, one every %d days" % OppFile.TAPE_EVERY if film else "shows on the night: no tape study in this camp",
			Color("#f3f5f8"), "lock", 380))
		return row
	# S398 critics: ten near-identical renders carried nothing - each kind has its own icon and colour
	var their := _card(_kind_pic(kind), str(KIND_WORD.get(kind, str(t["what"]).to_upper())), str(t["value"]), "", UI.PANEL,
		str(KIND_ICON.get(kind, "info")), 380, str(KIND_COL.get(kind, "#334155")))
	row.add_child(their)
	var arrow := UI.label("->", 30, UI.MUTED, "bold")
	arrow.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(arrow)
	if str(t["when"]) == "":   # a habit: the corner shouts the counter on the night - nothing to write
		row.add_child(_card(null, "THE CORNER", "Reads it on the night", "the counter is shouted when it comes", Color("#f3f5f8"), "user-check", 0))
		return row
	var answer := str(t["counter"])
	if answer.begins_with("Plan an arrow for "):   # the game row: an instruction, not the threat again
		answer = "Write what your fighter does %s" % answer.trim_prefix("Plan an arrow for ").replace("'", "").to_lower()
	var yours := _card(null, "SUGGESTED ANSWER - NOT IN YOUR PLAN YET", answer, "", Color("#eef4ff"), "target", 640, "#2f6fdb")
	var w := UI.button("Write it", "BtnSolid", main.act.bind("ptab", "1"))
	w.name = "WriteIt_" + id.replace(":", "_")
	w.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	(yours.get_child(0) as HBoxContainer).add_child(w)
	row.add_child(yours)
	return row


static func _kind_pic(kind: String) -> Texture2D:
	if PromoShot.ui_art() != "b" or not KIND_PIC_B.has(kind):
		return null
	var path := PIC_B_DIR.path_join(str(KIND_PIC_B[kind]) + ".png")
	return load(path) if ResourceLoader.exists(path) else null


## A picture card: the move picture (or an icon tile), the caps kind, the words, a small line under them.
static func _card(tex: Texture2D, kind: String, words: String, small: String, bg: Color, icon: String, width: int, tile_col := "#334155") -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(bg, UI.LINE, 10, 1, 8, 8))
	p.custom_minimum_size = Vector2(width, PIC + 16)
	if width == 0:
		p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var h := UI.hbox(12)
	p.add_child(h)
	if tex != null:
		var r := TextureRect.new()
		r.texture = tex
		r.custom_minimum_size = Vector2(PIC, PIC)
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(r)
	else:
		var tile := PanelContainer.new()
		tile.add_theme_stylebox_override("panel", UI.box(Color("#cfd6dd") if icon == "lock" else Color(tile_col), Color(0, 0, 0, 0), 8, 0, 0, 0))
		tile.custom_minimum_size = Vector2(PIC, PIC)
		tile.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var ic := Icons.icon(icon, 40, Color.WHITE)
		ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		tile.add_child(ic)
		h.add_child(tile)
	var t := UI.vbox(3)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	t.add_child(UI.caps(kind))
	t.add_child(UI.label(words, 18, UI.FG if icon != "lock" else UI.MUTED, "bold", true))
	if small != "":
		t.add_child(UI.label(small, 14, UI.MUTED, "body", true))
	h.add_child(t)
	return p
