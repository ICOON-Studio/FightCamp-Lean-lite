extends RefCounted
## S538 RESULTV2 (owner Q-S294-303 "the result page needs more graphics,use tooltips/modals to shorten things"; Q-S294-304
## on the mockup ops/previews/s538_look/result_v2.png: "Yes, build them"). Two pieces of the result's SUMMARY tab:
##   take(m) -> the night's take-home as rows {id, icon, big, side, label, col, tip, words, pips}: the ticket cut, ladder
##              points, members, what it taught, the host's favour, the plan's clue (the old footer's numbers, one list)
##   row(m) -> the bottom row of icon tiles, each with a tooltip that explains the number
##   why(main, m, f, names) -> the WHY card: icon + ONE headline + dots, the measured fix as a bar pair; the long
##              sentences are the bars' tooltip and the modal's words (ResultRead)
##   icon(name, px, colour) -> a line icon (Lucide, ISC, assets/ui/icons/CREDITS.md; the ladder is our own five lines)

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/TV.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const Tip := preload("res://scripts/ui/Tip.gd")

const NO_CLUE := "No recorded clue: the plan's lines were not tracked in this bout."
const SVG := {
	"ticket": '<rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/>',
	"ladder": '<path d="M8 3v18"/><path d="M16 3v18"/><path d="M8 7h8"/><path d="M8 12h8"/><path d="M8 17h8"/>',
	"members": '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>',
	"favour": '<path d="m11 17 2 2a1 1 0 1 0 3-3"/><path d="m14 14 2.5 2.5a1 1 0 1 0 3-3l-3.88-3.88a3 3 0 0 0-4.24 0l-.88.88a1 1 0 1 1-3-3l2.81-2.81a5.79 5.79 0 0 1 7.06-.87l.47.28a2 2 0 0 0 1.42.25L21 4"/><path d="m21 3 1 11h-2"/><path d="M3 3 2 14l6.5 6.5a1 1 0 1 0 3-3"/><path d="M3 4h8"/>',
	"clue": '<path d="M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5"/><path d="M9 18h6"/><path d="M10 22h4"/>',
	"cards": '<rect width="18" height="18" x="3" y="3" rx="2"/><path d="M3 9h18"/><path d="M9 21V9"/>',
}

static var _cache := {}


static func icon(name: String, px: int, colour: Color) -> TextureRect:
	var r := TextureRect.new()
	if SVG.has(name):
		var key := "%s@%d" % [name, px]
		if not _cache.has(key):
			var img := Image.new()
			img.load_svg_from_string('<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">%s</svg>' % str(SVG[name]), float(px) / 24.0)
			_cache[key] = ImageTexture.create_from_image(img)
		r.texture = _cache[key]
	else:
		r.texture = Icons.texture(name, px)
	r.modulate = colour
	r.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	r.custom_minimum_size = Vector2(px, px)
	r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## Lit and empty dots: `lit` of `total` in `col` (at most 10 drawn; past that the words beside them carry the count).
static func pips(lit: int, total: int, col: Color, px: int = 14) -> HBoxContainer:
	var h := UI.hbox(5)
	h.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in mini(total, 10):
		var d := Panel.new()
		d.custom_minimum_size = Vector2(px, px)
		d.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		d.mouse_filter = Control.MOUSE_FILTER_IGNORE
		d.add_theme_stylebox_override("panel", UI.box(col if i < lit else Palette.PAGE, col if i < lit else Palette.MUTED, px / 2, 2, 0, 0))
		h.add_child(d)
	return h


## The night's take-home, one row a number (the old footer's list, with the icon, the tooltip and the modal's sentence).
static func take(m: Dictionary) -> Array:
	var out: Array = []
	var win := bool(m.get("win", false))
	if m.has("tickets"):
		out.append({"id": "tickets", "icon": "ticket", "big": "%d SOLD" % int(m["tickets"]["sold"]), "label": "DEBUT TICKETS", "col": UI.GOLD,
			"tip": "Seats the gym sold for the pro debut. The gym's share of them is the next tile.", "words": "%d debut tickets sold." % int(m["tickets"]["sold"])})
		out.append(_money(int(m.get("gym_cut", 0)), "THE GYM'S SHARE", "What the gym keeps from the debut's tickets and purse, paid on the night."))
	elif bool(m.get("pro", false)):
		out.append(_money(int(m.get("gym_cut", 0)), "THE GYM'S PURSE SHARE", "The gym's part of the boxer's purse, paid on the night. The rest is the boxer's."))
	else:
		var cut := int(m.get("club_cut", BoutRules.TICKET_CUT))
		var none := "THE HOST KEPT THE GATE" if m.has("gate_line") else "NO TICKET CUT AT THE CHAMPIONSHIPS"   # S512 a picked name
		out.append(_money(cut, "GYM TICKET CUT" if cut > 0 else none, "The host pays the gym for bringing a boxer to the show, win or lose." if cut > 0
			else ("A bout the gym asked for by name: the host keeps the whole gate." if m.has("gate_line") else "The championships pay no ticket cut: the title is the prize.")))
		var lp: Dictionary = m.get("ladder_pts", {})
		if not lp.is_empty():   # S515 LADDERWIRE1: the ladder points this bout moved (season ladder v6)
			var dl := int(lp["a_delta"])
			var rank := str(m.get("rank_words", "")).trim_suffix(".")
			var fits := rank != "" and rank.length() <= 30   # a longer rank line is the tile's hover (it leads the left name card too)
			out.append({"id": "ladder", "icon": "ladder", "big": ("+%d" % dl) if dl > 0 else ("%d" % dl if dl < 0 else "NO CHANGE"), "side": "NOW %d" % int(lp["a_rep"]),
				"label": "LADDER POINTS" + (" · " + rank.to_upper() if fits else ""), "col": UI.GREEN if dl > 0 else (UI.RED if dl < 0 else UI.MUTED),
				"tip": ("" if fits or rank == "" else rank + ". ") + "The season ladder ranks boxers by these points. Beating a better boxer pays more; losing to a weaker one costs more.",
				"words": "Ladder points %s, now %d." % [("+%d" % dl) if dl > 0 else ("%d" % dl if dl < 0 else "unchanged"), int(lp["a_rep"])]})
	var lost := int(m.get("members_lost", 0))
	out.append({"id": "members", "icon": "members", "big": "+%d" % BoutRules.WIN_MEMBERS if win else ("-%d" % lost if lost > 0 else "NO CHANGE"), "label": "MEMBERS AFTER THE NEWS",
		"col": UI.GOLD if lost == 0 else UI.RED, "tip": "The town reads the result: a win brings members in, a loss sends some away, a stoppage more. Members pay the dues.",
		"words": "Members after the news %s." % ("+%d" % BoutRules.WIN_MEMBERS if win else ("-%d" % lost if lost > 0 else "unchanged"))})
	if m.has("taught") and not bool(m.get("pro", false)) and not m.has("tickets"):   # S512 ASKFIGHT1: what the fight taught (FightLearn)
		var g := float(m["taught"].get("grow", 0.0))
		var step := str(m["taught"].get("kind", "")) == "step_up"
		out.append({"id": "taught", "icon": "trending-up", "big": ("+%.1f" % g) if g > 0.0 else "NOTHING", "label": "WHAT IT TAUGHT, EVERY ABILITY" + (" (A STEP UP)" if step else ""),
			"col": UI.GREEN if g > 0.0 else UI.MUTED, "tip": "A real bout teaches what the gym cannot: every fight ability grows by this. A harder opponent teaches more.",
			"words": "What it taught, every ability%s: %s." % [" (a step up)" if step else "", ("+%.1f" % g) if g > 0.0 else "nothing"]})
	var hf: Dictionary = m.get("host_favour", {})
	if not hf.is_empty() and not bool(m.get("pro", false)) and not m.has("tickets"):   # S515 FAVOURS2: the host's favour count
		var earned := bool(hf["earned"])
		var need := int(FightWeekEvents.BOUTS_PER_FAVOUR)
		out.append({"id": "favour", "icon": "favour", "big": "+1 FAVOUR" if earned else "%d OF %d" % [int(hf["count"]), need],
			"label": "THE HOST OWES YOU ONE" if earned else "BOUTS FOR THE HOST TOWARD A FAVOUR", "col": UI.GREEN if earned else UI.GOLD,
			"pips": [need if earned else int(hf["count"]), need],
			"tip": "Every %d bouts boxed on this host's shows, the host owes the gym a favour to call in later." % need,
			"words": "The host owes the gym a favour." if earned else "%d of %d bouts for the host toward a favour." % [int(hf["count"]), need]})
	if m.has("injury"):
		out.append({"id": "injury", "icon": "heart-pulse", "big": str(m["injury"]).to_upper(), "label": "INJURY REPORT", "col": UI.RED, "small": true, "wide": true,
			"tip": "The doctor's finding after the bout. The boxer's page says how long it keeps the boxer out of sparring and bouts.", "words": "Injury report: %s." % str(m["injury"])})
	return out


static func _money(n: int, label: String, tip: String) -> Dictionary:
	return {"id": "ticket", "icon": "ticket", "big": UI.signed(n), "label": label, "col": UI.GREEN if n > 0 else UI.MUTED, "tip": tip,
		"words": "%s %s." % [label.substr(0, 1) + label.substr(1).to_lower(), UI.signed(n)]}


## The plan's clue as a tile: the recorded line's dots (won or got off, of the times it was planned) and its sentence.
static func clue(m: Dictionary) -> Dictionary:
	var text := str(m.get("clue", NO_CLUE))
	var c: Dictionary = PlanRecord.clue(m.get("rounds", [])) if m.has("clue") else {}
	var t := {"id": "clue", "icon": "clue", "big": "NO CLUE", "label": "THE PLAN'S CLUE", "col": UI.MUTED, "tip": text, "words": text, "small": true}
	if c.is_empty():
		return t
	var mv := str(StrikeMap.move(str(c["move"]).split("@")[0]).get("name", str(c["move"])))
	var good := int(c["n"]) if str(c["kind"]) == "worked" else (0 if str(c["kind"]) == "not_ready" else int(c["of"]) - int(c["n"]))
	t["big"] = "%s: %d of %d" % [mv, good, int(c["of"])]
	t["pips"] = [good, int(c["of"])]
	t["col"] = UI.GREEN if str(c["kind"]) == "worked" else UI.GOLD
	return t


## The bottom row: one tile a number, the plan's clue last (gold edge).
static func row(m: Dictionary) -> HBoxContainer:
	var h := UI.hbox(14)
	h.name = "ResultTiles"
	for t in take(m) + [clue(m)]:
		h.add_child(tile(t))
	return h


static func tile(t: Dictionary) -> PanelContainer:
	var col: Color = t["col"]
	var p := PanelContainer.new()
	p.name = "Tile_" + str(t["id"])
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_stretch_ratio = 1.8 if bool(t.get("wide", false)) else 1.0   # the doctor's finding is a sentence: it wraps
	p.custom_minimum_size = Vector2(0, 104)
	p.add_theme_stylebox_override("panel", UI.box(Color(Palette.TEXT, 0.05), UI.GOLD if str(t["id"]) == "clue" else Color(Palette.TEXT, 0.10), 6, 1, 16, 10))
	var h := UI.hbox(14)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(h)
	h.add_child(icon(str(t["icon"]), 44, col))
	var v := UI.vbox(2)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(v)
	var small := bool(t.get("small", false))
	if t.has("pips") and small:
		v.add_child(pips(int(t["pips"][0]), int(t["pips"][1]), col, 12))
	var top := UI.hbox(8)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if t.has("pips") and not small:
		top.add_child(pips(int(t["pips"][0]), int(t["pips"][1]), col, 18))
	var big := UI.label(str(t["big"]), 20 if str(t["big"]).length() < 40 else 17, col, "bold", true) if small else UI.display(str(t["big"]), 34, col)
	big.name = "Big"
	big.size_flags_horizontal = Control.SIZE_EXPAND_FILL if small else Control.SIZE_FILL
	top.add_child(big)
	if str(t.get("side", "")) != "":
		var side := UI.display(str(t["side"]), 22, UI.MUTED)
		side.size_flags_vertical = Control.SIZE_SHRINK_END
		top.add_child(side)
	v.add_child(top)
	var cap := UI.caps(str(t["label"]))
	cap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cap.custom_minimum_size = Vector2(150, 0)
	v.add_child(cap)
	Tip.short(p, str(t["label"]).get_slice(" · ", 0), str(t["tip"]))
	return p


## WHY IT WAS LOST / WON: the one cause as an icon, a headline and dots; the measured fix as bars with the words a hover away.
static func why(main: Node, m: Dictionary, f: Dictionary, names: Array) -> PanelContainer:
	var win := bool(m.get("win", false))
	var p := ResultCause.panel("WHY IT WAS WON, AND WHAT TO SHARPEN" if win else "WHY IT WAS LOST")
	p.name = "Cause"
	var v: VBoxContainer = p.get_child(0)
	var lab: Dictionary = m.get("fixlab", {})
	var ch: Dictionary = lab.get("changes", {})
	if not bool(lab.get("ok", false)) or ch.is_empty():
		var read := FightWhy.read(m["rounds"], str(names[0]), str(names[1]), str(m.get("opp_style", "")))
		v.add_child(_cause(str(read["against"]), UI.RED if not win else UI.FG, 0, 0, "", "CauseHead"))
		v.add_child(UI.label(str(read["next"]), 20, UI.FG, "body", true))
		if bool(lab.get("ok", false)):
			v.add_child(ResultCause._verdict(lab, names, win))
		return p
	var rw: Dictionary = ch.get("rewrite", {})
	var add: Dictionary = ch.get("add", {})
	if not rw.is_empty():
		var sit := ResultCause._sit(str(rw["sit"]), names)
		v.add_child(_cause("Line %s: %s into %s" % [str(rw["letter"]), ResultCause._move(str(rw["move"])), sit], UI.RED, int(rw["lost"]), int(rw["used"]),
			"The plan sent this line into %s. The Playbook rates it %s there, and the exchanges show it." % [sit, str(PlanLines.FIT_WORDS["wrong"])], "CauseHead"))
	if not add.is_empty():
		var s2 := ResultCause._sit(str(add["sit"]), names)
		v.add_child(_cause("No answer for %s" % s2, UI.RED, int(add["lost"]), int(add["seen"]),
			"The opponent brought %s and the plan had no line for it, so your boxer had to improvise." % s2, "CauseHead" if rw.is_empty() else "CauseNext"))
	v.add_child(_fix(lab, names, win))
	var best := str(lab.get("best", ""))
	if best != "":
		var done := bool(m.get("fix_done", false))
		var b := UI.button("In the plan for the next bout" if done else "Put the fix in the plan", "BtnSolid", main.act.bind("planfix", str(f["id"])), done, "The plan now has these lines.")
		b.name = "PlanFix"
		b.add_theme_font_size_override("font_size", 22)
		b.custom_minimum_size = Vector2(330, 52)
		b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		if not done:
			b.tooltip_text = "Writes the measured lines into your boxer's plan (the Playbook). Every line can still be changed there."
		v.add_child(b)
	return p


## One cause: the glove in a ring, the headline, then `lost` red dots of `of` with the count in words.
static func _cause(text: String, col: Color, lost: int, of: int, tip: String, node_name: String) -> HBoxContainer:
	var h := UI.hbox(16)
	var first := node_name == "CauseHead"
	var ring := PanelContainer.new()
	var px := 64 if first else 44
	ring.custom_minimum_size = Vector2(px, px)
	ring.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	ring.add_theme_stylebox_override("panel", UI.box(Color(col, 0.10), col, px / 2, 2, 0, 0))
	var ic := icon("hand-fist", px * 5 / 8, col)
	ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ring.add_child(ic)
	h.add_child(ring)
	var v := UI.vbox(4)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var head := UI.label(text, 26 if first else 21, col, "bold", true)
	head.name = node_name
	v.add_child(head)
	if of > 0:
		var row := UI.hbox(10)
		row.add_child(pips(lost, of, Broadcast.HERS))
		row.add_child(UI.label("lost %d of %d" % [lost, of], 20, UI.FG, "bold"))
		v.add_child(row)
	h.add_child(v)
	if tip != "":
		Tip.short(h, "LOST %d OF %d" % [lost, of], tip)
	return h


## The measured fix: what changes in the plan (chips), then the bars of nights won. The verdict sentence and how it was
## measured are the bars' tooltip (owner: "use tooltips/modals to shorten things") and the modal's words.
static func _fix(lab: Dictionary, names: Array, win: bool) -> VBoxContainer:
	var v := UI.vbox(8)
	var ch: Dictionary = lab["changes"]
	var best := str(lab.get("best", ""))
	var head := UI.hbox(8)
	var t := UI.caps("THE MEASURED FIX")
	t.add_theme_color_override("font_color", UI.GOLD)
	head.add_child(t)
	if best == "":
		head.add_child(UI.label("· changes tried: none beats luck", 16, UI.MUTED))
	v.add_child(head)
	for k in ["rewrite", "add"]:
		if ch.has(k) and (best == "both" or best == k or best == ""):
			var chip := PanelContainer.new()
			chip.add_theme_stylebox_override("panel", UI.box(Color(UI.GOLD, 0.12), UI.GOLD, 4, 2, 12, 6))
			chip.add_child(UI.label(ResultCause._line_words(k, ch[k], names), 19, Palette.TEXT, "bold", true))
			v.add_child(chip)
	var bars := Bars.new()
	bars.name = "FixLadder"
	bars.rows = fix_rows(lab)
	bars.nights = int(lab["nights"])
	bars.custom_minimum_size = Vector2(0, bars.rows.size() * Bars.ROW + 44)
	bars.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var said: Label = ResultCause._verdict(lab, names, win)
	var words := said.text
	said.free()
	Tip.explain(bars, {"title": "WHAT THE BARS SAY", "what": "Each bar: nights won out of %d against the opponent. The dashed line is an even fight." % int(lab["nights"]),
		"now": words, "do": measured(lab)})
	v.add_child(bars)
	return v


## [label, nights won, is the fix] for the plan as written and each change tried.
static func fix_rows(lab: Dictionary) -> Array:
	var ch: Dictionary = lab["changes"]
	var best := str(lab.get("best", ""))
	var rows := [["The plan as written", int(lab["written"]), false]]
	var label := {"rewrite": "", "add": "", "both": "Both changes"}
	if ch.has("rewrite"):
		label["rewrite"] = "%s → %s" % [str(ch["rewrite"]["letter"]), str(ch["rewrite"]["to_name"])]
	if ch.has("add"):
		label["add"] = "New line %s only" % str(ch["add"]["letter"])
	for k in ["rewrite", "add", "both"]:
		if ch.has(k):
			rows.append([str(label[k]), int(ch[k]["wins"]), k == best])
	return rows


static func measured(lab: Dictionary) -> String:
	return "Measured: %d more nights against the opponent, the corner's own calls, only the plan changes." % int(lab["nights"])


## Bars of nights won out of `nights`: the plan as written in the boxer's red, the fix gold, a dashed line at half.
class Bars extends Control:
	const K := preload("res://scripts/ui/TV.gd")
	const P := preload("res://scripts/ui/Palette.gd")
	const BC := preload("res://scripts/ui/Broadcast.gd")
	const ROW := 32.0
	const LABEL_W := 210.0
	const NUM_W := 96.0
	const TOP := 22.0
	var rows: Array = []
	var nights := 1

	func _draw() -> void:
		var font := K.font("bold")
		var bar_w := maxf(40.0, size.x - LABEL_W - NUM_W)
		var x := LABEL_W + bar_w * 0.5
		draw_string(font, Vector2(x - 60, 14), "even fight", HORIZONTAL_ALIGNMENT_CENTER, 120, 14, K.MUTED)
		for i in rows.size():
			var y := TOP + i * ROW
			var r: Array = rows[i]
			var best := bool(r[2])
			var col := K.GOLD if best else (Color(P.TEXT, 0.45) if i > 0 else BC.HERS)
			draw_string(font, Vector2(0, y + 21), str(r[0]), HORIZONTAL_ALIGNMENT_LEFT, LABEL_W - 10, 19, P.TEXT if best or i == 0 else K.MUTED)
			draw_rect(Rect2(LABEL_W, y + 4, bar_w, 22), Color(P.TEXT, 0.06))
			draw_rect(Rect2(LABEL_W, y + 4, bar_w * clampf(float(r[1]) / float(maxi(1, nights)), 0.0, 1.0), 22), col)
			draw_string(font, Vector2(LABEL_W + bar_w + 12, y + 21), "%d of %d" % [int(r[1]), nights], HORIZONTAL_ALIGNMENT_LEFT, NUM_W, 19, K.GOLD if best else P.TEXT)
		var y0 := TOP - 2.0
		var y1 := TOP + rows.size() * ROW + 4.0
		while y0 < y1:
			draw_line(Vector2(x, y0), Vector2(x, minf(y0 + 6.0, y1)), Color(P.TEXT, 0.7), 2.0)
			y0 += 11.0
