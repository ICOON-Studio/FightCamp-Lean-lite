extends RefCounted
## Fight night's tale of the tape: the bout offer's versus picture, full screen, with the night's own lines.
##   mount(panel, main, m) draws it on the fight-night panel.
##   tape_rows(f, opp, her_cm) is the same list every tape screen reads (TapeRows).

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const VersusPanel := preload("res://scripts/ui/VersusPanel.gd")
const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FighterPose := preload("res://scripts/rules/FighterPose.gd")
const ClubCrest := preload("res://scripts/rules/ClubCrest.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")
const Data := preload("res://scripts/state/Data.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")

## The figure stops this far above the bottom. The tag's top sits 16 px under that, clear of the feet.
const FOOT := 72.0
const SHOW := ["Record", "Age", "Weight", "Height", "Reach", "Stance"]
const TITLE := {"Record": "RECORD", "Age": "AGE", "Weight": "ON THE SCALES", "Height": "HEIGHT", "Reach": "REACH", "Stance": "STANCE"}


static func tape_rows(f: Dictionary, opp: Dictionary, her_cm: float = 0.0) -> Array:
	return TapeRows.rows(f, opp, her_cm)


static func mount(panel: PanelContainer, main: Node, m: Dictionary) -> void:
	panel.theme_type_variation = ""
	panel.custom_minimum_size = Vector2(1920, 1080)
	panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	var wall := TextureRect.new()
	wall.name = "TapeWall"
	wall.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	wall.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	wall.texture = load(VersusPanel.BACKDROP)
	wall.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(wall)
	# S420: fight night fills the screen, so the names and corner notes sat on its edge (x 0); the bout offer gets 28 px
	# from its page. Same margin here; the wall stays full-bleed behind.
	var pad := MarginContainer.new()
	pad.name = "TapePad"
	pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right"]:
		pad.add_theme_constant_override("margin_" + side, 28)
	pad.add_theme_constant_override("margin_top", 24)
	pad.add_theme_constant_override("margin_bottom", 24)
	panel.add_child(pad)
	pad.add_child(_picture(main, c, f, opp, m))


static func _picture(main: Node, c: Career, f: Dictionary, opp: Dictionary, m: Dictionary) -> Control:
	var stems: Array = Faces.pair(f, opp)
	var poses: Array = FighterPose.pair(str(stems[0]), str(stems[1]), str(f.get("id", "")) + str(c.day))
	var crests: Array = ClubCrest.pair(c.gym_name, str(opp.get("club", "")))
	var tags: Array = VersusPanel.tags_for(f, opp)
	var root := UI.hbox(0)
	root.name = "Versus"
	root.add_child(VersusPanel.side(str(f["name"]), "%s · your fighter" % str(f["wc"]), str(stems[0]), "red", str(tags[0]), false, int(poses[0]), str(crests[0]), hash(str(f.get("id", "")) + "r"), 20, 20, FOOT, false))
	root.add_child(_card(main, c, f, opp, m))
	root.add_child(VersusPanel.side(str(opp["name"]), "%s · %s" % [str(f["wc"]), str(opp.get("club", ""))], str(stems[1]), "blue", str(tags[1]), true, int(poses[1]), str(crests[1]), hash(str(opp.get("name", "")) + "b"), 20, 20, FOOT, false))
	return root


static func _card(main: Node, c: Career, f: Dictionary, opp: Dictionary, m: Dictionary) -> Control:
	var p := PanelContainer.new()
	p.name = "VersusCard"
	p.custom_minimum_size = Vector2(VersusPanel.CARD_W, 0)
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.add_theme_stylebox_override("panel", WoodKit.slate(26, 22))
	var v := UI.vbox(0)
	p.add_child(v)
	var total := int(m.get("total", BoutRules.ROUNDS))
	var day := int((f.get("bout", {}) as Dictionary).get("day", c.day))
	v.add_child(_centre(UI.label(Clock.fmt(day).to_upper(), 22, UI.FG, "bold")))
	v.add_child(VersusPanel.gap(4))
	v.add_child(_centre(UI.label("%d x 3 min" % total, 22, UI.FG, "bold")))
	v.add_child(VersusPanel.gap(8))
	var cm := Faces.cm(Faces.stem(f))
	for r in tape_rows(f, opp, cm):
		var row: Dictionary = r
		var key := str(row["label"])
		if not SHOW.has(key):
			continue
		VersusPanel.draw_fact(v, row, str(TITLE[key]), 20, 25, 190.0)
	v.add_child(VersusPanel.gap(8))
	v.add_child(_camp_line(f))
	v.add_child(VersusPanel.gap(4))
	v.add_child(_scout_line(opp))
	v.add_child(VersusPanel.gap(10))
	v.add_child(_buttons(main, total))
	return p


static func _centre(l: Label) -> Label:
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l


static func _camp_line(f: Dictionary) -> Control:
	var sum: Dictionary = FilmEdge.summary(f)
	var line := UI.hbox(10)
	line.name = "TapeCamp"
	line.alignment = BoxContainer.ALIGNMENT_CENTER
	var icon := KitIcon.icon("film", 22, WoodKit.INK)
	icon.name = "FilmMark"
	line.add_child(icon)
	line.add_child(_line("%d of %d" % [int(sum["n"]), int(sum["of"])], 20, ""))
	line.add_child(_line(_camp(f), 20, ""))
	return line


static func _camp(f: Dictionary) -> String:
	var fc: Dictionary = f.get("camp", {})
	if fc.is_empty() or not fc.has("focus"):
		return "No camp"
	var focus := str(Data.LABEL.get(str(fc["focus"]), str(fc["focus"])))
	var idx := clampi(int(fc.get("protocol", 0)), 0, BoutRules.PROTOCOLS.size() - 1)
	return "%s, %s" % [focus, str(BoutRules.PROTOCOLS[idx]["name"])]


static func _scout_line(opp: Dictionary) -> Control:
	var line := UI.hbox(18)
	line.name = "TapeFacts"
	line.alignment = BoxContainer.ALIGNMENT_CENTER
	line.add_child(_line(_scout(opp, "weapon", str(opp.get("threat", ""))), 20, "TapeThreat"))
	line.add_child(_line(_scout(opp, "weakness", str(opp.get("weak", ""))), 20, "TapeWeak"))
	return line


static func _scout(opp: Dictionary, id: String, value: String) -> String:
	if OppFile.known(opp, id) and value.strip_edges() != "":
		return value
	return "unknown: not on tape"


## Eight words on the picture. A longer scouting line keeps the full text on the tooltip.
static func _line(text: String, px: int, node_name: String) -> Label:
	var shown := text
	var words := text.split(" ", false)
	if words.size() > 8:
		var head := text.split(",")[0].strip_edges()
		shown = head if head != "" and head.split(" ", false).size() <= 8 else " ".join(words.slice(0, 8))
	var l := _centre(UI.label(shown, px, UI.FG, "bold"))
	if node_name != "":
		l.name = node_name
	if shown != text:
		l.tooltip_text = text
		l.mouse_filter = Control.MOUSE_FILTER_PASS
	return l


static func _buttons(main: Node, total: int) -> Control:
	var row := UI.hbox(12)
	row.name = "TapeButtons"
	var sim := UI.button("Sim to result", "BtnQuiet", main.act.bind("fightstep", "sim"))
	sim.name = "Sim"
	_button(sim)
	row.add_child(sim)
	var begin := UI.button("Begin fight", "BtnSolid", main.act.bind("fightstep", "start"))
	begin.name = "Begin"
	begin.tooltip_text = _shout(total)
	_button(begin)
	row.add_child(begin)
	return row


static func _button(b: Button) -> void:
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.custom_minimum_size = Vector2(0, 48)
	b.add_theme_font_size_override("font_size", 20)


static func _shout(total: int) -> String:
	var n := "Three" if total == 3 else "Four"
	var extra := ", a pro debut" if total > BoutRules.ROUNDS else ""
	return "%s rounds of three minutes%s. Every 30 seconds you can shout a call; read the clue, pick what fits, watch it work. In the corner between rounds you set the plan." % [n, extra]
