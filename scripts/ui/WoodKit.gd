extends RefCounted
## S498 ONELOOK1 round 2 (operator on Q-S294-261: "i do not like the wooden panels , some pictures ahve some dont , how do
## you call this consistent ?"): NO WOOD. One plain panel for every card on every page and the fight HUD - the dark slate
## from the palette (CARD, a 1 px LINE edge, 6 px corners) - and one flat button family on palette tokens. No texture,
## no grain, no frame. The name stays (25 callers ask WoodKit.slate / bar / plates); tests/one_look_test.gd fails any
## panel or button that is not one of these. ink() gives the words on a dark surface their chalk colours.
## (S417's wooden pieces, Q-S294-159, are retired; the PNGs stay in assets/ui/wood/ for history, read by nothing.)

const Palette := preload("res://scripts/ui/Palette.gd")   # S493 the one palette
const INK := Palette.TEXT        # chalk
const SOFT := Palette.MUTED      # a quieter chalk
const HEAD := Palette.HEADER     # a card's title
const BLUE := Palette.ACCENT     # your side, light enough to read on slate
const DARK_INK := Palette.PAPER_INK   # words on a light plate (the tan tab, an amber warning)
## The paper inks UI.gd gives a word (UI.FG, UI.MUTED, UI.GOLD; tests/wood_kit_test.gd holds them equal).
const PAPER_MUTED := Palette.PAPER_MUTED
const PAPER_BLUE := Palette.PAPER_BLUE
## THE panel: every card, board, modal and HUD plate.
const PANEL_BG := Palette.CARD
const PANEL_EDGE := Palette.LINE
const PANEL_RADIUS := 6
const PANEL_EDGE_W := 1
## Button name -> [kind, ink]. kind: "plain" a tile, "on" the chosen tan, "act" the one red action. Every button is one
## of these three flat plates.
const KIND_BG := {"plain": Palette.TILE, "on": Palette.CHOSEN, "act": Palette.ACTION}
const PIECE := {
	"Button": ["plain", INK], "Ghost": ["plain", SOFT], "BtnQuiet": ["plain", SOFT],
	"GhostDark": ["plain", INK], "Tab": ["plain", INK], "Choice": ["plain", INK],
	"Pill": ["plain", SOFT], "Speed": ["plain", SOFT], "Ink": ["plain", INK],
	"TBtn": ["plain", INK], "Btn": ["plain", INK], "Rail": ["plain", INK],
	"GoFight": ["act", INK], "RailOn": ["on", DARK_INK],
	"TabOn": ["on", DARK_INK], "ChoiceOn": ["on", DARK_INK],
	"PillOn": ["on", DARK_INK], "SpeedOn": ["on", DARK_INK],
	"Go": ["act", INK],
	"BtnSolid": ["act", INK], "TBtnPrimary": ["act", INK],
	"GoBlock": ["act", INK], "FlagRed": ["act", INK],
}


static func _flat(bg: Color, edge: Color, edge_w: int, radius: int, pad_h: int, pad_top: int, pad_bottom: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = edge
	s.set_border_width_all(edge_w)
	s.set_corner_radius_all(radius)
	s.content_margin_left = pad_h
	s.content_margin_right = pad_h
	s.content_margin_top = pad_top
	s.content_margin_bottom = pad_bottom
	s.anti_aliasing = true
	return s


## THE panel, for a card. `pad` is measured from the card's outer edge.
static func slate(pad_h: int = 30, pad_v: int = 26) -> StyleBoxFlat:
	var s := _flat(PANEL_BG, PANEL_EDGE, PANEL_EDGE_W, PANEL_RADIUS, pad_h, pad_v, pad_v)
	s.shadow_color = Palette.alpha(Palette.PAGE, 0.45)
	s.shadow_size = 6
	s.shadow_offset = Vector2(0, 3)
	return s


## Is `sb` the house panel (whatever its padding)? tests/one_look_test.gd asks this of every card on every page.
static func is_panel(sb: StyleBox) -> bool:
	if not sb is StyleBoxFlat:
		return false
	var f := sb as StyleBoxFlat
	return f.bg_color.is_equal_approx(PANEL_BG) and f.border_color.is_equal_approx(PANEL_EDGE) 		and f.border_width_top == PANEL_EDGE_W and f.border_width_left == PANEL_EDGE_W and f.corner_radius_top_left == PANEL_RADIUS


## The top bar: the page colour with one line under it.
static func bar(pad_h: int, pad_v: int) -> StyleBoxFlat:
	var s := _flat(Palette.PAGE, PANEL_EDGE, 0, 0, pad_h, pad_v, pad_v)
	s.border_width_bottom = PANEL_EDGE_W
	return s


## Is `sb` the top-bar strip (the page's top bar, the fight's corner bar)?
static func is_bar(sb: StyleBox) -> bool:
	if not sb is StyleBoxFlat:
		return false
	var f := sb as StyleBoxFlat
	return f.bg_color.is_equal_approx(Palette.PAGE) and f.border_width_top == 0 and f.border_width_bottom == PANEL_EDGE_W 		and f.border_color.is_equal_approx(PANEL_EDGE)


## Is `sb` one of the button plates (any kind, any state)?
static func is_plate(sb: StyleBox) -> bool:
	if not sb is StyleBoxFlat:
		return false
	var bg := (sb as StyleBoxFlat).bg_color
	for k in KIND_BG:
		var c: Color = KIND_BG[k]
		for v in [c, Palette.hovered(c), Palette.pressed(c), Palette.disabled(c)]:
			if bg.is_equal_approx(v):
				return true
	return false


## Sets button `name`'s four states from its flat plate and returns its ink. Pressed: darker, the word sinks 2 px.
static func plates(t: Theme, name: String, pad_h: int, pad_v: int) -> Color:
	var row: Array = PIECE[name]
	var bg: Color = KIND_BG[row[0]]
	var edge: Color = PANEL_EDGE if row[0] == "plain" else Palette.CLEAR
	var w := PANEL_EDGE_W if row[0] == "plain" else 0
	t.set_stylebox("normal", name, _flat(bg, edge, w, 4, pad_h, pad_v, pad_v + 2))
	t.set_stylebox("hover", name, _flat(Palette.hovered(bg), edge, w, 4, pad_h, pad_v, pad_v + 2))
	t.set_stylebox("pressed", name, _flat(Palette.pressed(bg), edge, w, 4, pad_h, pad_v + 2, pad_v))
	t.set_stylebox("disabled", name, _flat(Palette.disabled(bg), Palette.disabled(edge), w, 4, pad_h, pad_v, pad_v + 2))
	return row[1]


## Words the page builders made in the paper inks take the chalk inks wherever they sit on something dark: a slate, a
## dark plank, a dark plate. On a sticky, a polaroid, a whiteboard or a light plate they keep the paper inks, and so does
## everything already coloured. A see-through panel or button follows what is behind it.
static func ink(n: Node, dark: bool = false) -> void:
	for c in n.get_children():
		var here := dark
		if c.has_meta("on_dark"):
			here = bool(c.get_meta("on_dark"))
		if c is PanelContainer or c is Button:
			var tone := _tone((c as Control).get_theme_stylebox("panel" if c is PanelContainer else "normal"))
			if tone != 0:
				here = tone > 0
			if here and c is Button and str((c as Button).theme_type_variation) == "Link":
				for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
					(c as Button).add_theme_color_override(state, BLUE)
		elif here and c is Label:
			_chalk(c, "font_color")
		elif here and c is RichTextLabel:
			_chalk(c, "default_color")
		ink(c, here)


## 1 a dark surface, -1 a light one, 0 none of its own.
static func _tone(sb: StyleBox) -> int:
	if sb is StyleBoxFlat:
		var bg: Color = (sb as StyleBoxFlat).bg_color
		return 0 if bg.a < 0.5 else (1 if bg.get_luminance() < 0.45 else -1)
	if sb is StyleBoxTexture and (sb as StyleBoxTexture).texture != null:
		var path := str((sb as StyleBoxTexture).texture.resource_path)
		return 1 if (path.contains("wood_panel") or path.contains("chalk")) else -1
	return 0


## For a control that draws its own words and lines: is the nearest surface behind it dark?
static func on_dark(n: Node) -> bool:
	var p := n.get_parent()
	while p != null:
		if p.has_meta("on_dark"):   # S494: a column drawn straight on the dark page (no slate of its own) says so
			return bool(p.get_meta("on_dark"))
		if p is PanelContainer or p is Button:
			var tone := _tone((p as Control).get_theme_stylebox("panel" if p is PanelContainer else "normal"))
			if tone != 0:
				return tone > 0
		p = p.get_parent()
	return false


static func fg(n: Node) -> Color:
	return INK if on_dark(n) else DARK_INK


static func muted(n: Node) -> Color:
	return SOFT if on_dark(n) else PAPER_MUTED


static func blue(n: Node) -> Color:
	return BLUE if on_dark(n) else PAPER_BLUE


static func _chalk(c: Control, key: String) -> void:
	var was: Color = c.get_theme_color(key)
	if was == DARK_INK:
		c.add_theme_color_override(key, INK)
	elif was == PAPER_MUTED:
		c.add_theme_color_override(key, SOFT)
	elif was == PAPER_BLUE:
		c.add_theme_color_override(key, BLUE)
	elif was == Palette.GOOD_FILL:   # S493 a fill green as words on slate reads 3.0:1 - the lightened word green
		c.add_theme_color_override(key, Palette.GOOD)
	elif was == Palette.BAD_FILL:
		c.add_theme_color_override(key, Palette.BAD)
