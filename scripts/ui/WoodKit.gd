extends RefCounted
## S417 the look the operator approved on Q-S294-159 ("Yes, build this look"): wood with brass corners round a slate
## board, painted wooden tabs and buttons, a plank for the top bar. The pieces are Ludo's blank cuts of the approved
## concept (docs/mockups/s416/overview_painted_ludo.png), packed by tools/wood_kit_pack.py. UI.theme() builds every
## card and button from here, so all pages change together; ink() gives the words on a slate their chalk colours.

const DIR := "res://assets/ui/wood/"
const INK := Color("#efe6d8")    # chalk
const SOFT := Color("#b8a88f")   # a quieter chalk
const HEAD := Color("#f2c14e")   # a card's title
const BLUE := Color("#8fbcff")   # the ring-canvas blue, light enough to read on slate
const DARK_INK := Color("#241f1a")
## The paper inks UI.gd gives a word (UI.FG, UI.MUTED, UI.GOLD; tests/wood_kit_test.gd holds them equal).
const PAPER_MUTED := Color("#5d5243")
const PAPER_BLUE := Color("#27589e")
## The corner kept unscaled on the framed slate (the brass plate), and on a wooden button.
const FRAME := 52
const EDGE := 9
## Button name -> [piece, ink, tint]. A name not listed keeps its flat plate.
const PIECE := {
	"Button": ["tab", INK, Color.WHITE], "Ghost": ["tab", SOFT, Color.WHITE], "BtnQuiet": ["tab", SOFT, Color.WHITE],
	"GhostDark": ["tab", INK, Color.WHITE], "Tab": ["tab", INK, Color.WHITE], "Choice": ["tab", INK, Color.WHITE],
	"Pill": ["tab", SOFT, Color.WHITE], "Speed": ["tab", SOFT, Color.WHITE], "Ink": ["tab", INK, Color.WHITE],
	"TBtn": ["plank", INK, Color.WHITE], "Btn": ["plank", INK, Color.WHITE], "Rail": ["plank", INK, Color.WHITE],
	"GoFight": ["plank", INK, Color.WHITE], "RailOn": ["plank_on", INK, Color.WHITE],
	"TabOn": ["tab_on", DARK_INK, Color.WHITE], "ChoiceOn": ["tab_on", DARK_INK, Color.WHITE],
	"PillOn": ["tab_on", DARK_INK, Color.WHITE], "SpeedOn": ["tab_on", DARK_INK, Color.WHITE],
	"Go": ["tab_on", DARK_INK, Color(1.0, 0.84, 0.46)],
	"BtnSolid": ["red", Color.WHITE, Color.WHITE], "TBtnPrimary": ["red", Color.WHITE, Color.WHITE],
	"GoBlock": ["red", Color.WHITE, Color.WHITE], "FlagRed": ["red", Color.WHITE, Color.WHITE],
}


static func tex(piece: String) -> Texture2D:
	return load(DIR + piece + ".png") as Texture2D


static func _nine(piece: String, border: int, pad_h: int, pad_top: int, pad_bottom: int, tint: Color) -> StyleBoxTexture:
	var s := StyleBoxTexture.new()
	s.texture = tex(piece)
	s.set_texture_margin_all(border)
	s.content_margin_left = pad_h
	s.content_margin_right = pad_h
	s.content_margin_top = pad_top
	s.content_margin_bottom = pad_bottom
	s.modulate_color = tint
	return s


## The framed slate, for a card. The frame is 22 px; `pad` is measured from the card's outer edge.
static func slate(pad_h: int = 30, pad_v: int = 26) -> StyleBoxTexture:
	return _nine("panel", FRAME, pad_h, pad_v, pad_v, Color.WHITE)


## The plank across the top of the screen.
static func bar(pad_h: int, pad_v: int) -> StyleBoxTexture:
	var s := _nine("bar", 0, pad_h, pad_v, pad_v, Color.WHITE)
	s.texture_margin_bottom = 8
	return s


## Sets button `name`'s four states from its wooden piece and returns its ink. Pressed: darker, the word sinks 2 px.
static func plates(t: Theme, name: String, pad_h: int, pad_v: int) -> Color:
	var row: Array = PIECE[name]
	var tint: Color = row[2]
	t.set_stylebox("normal", name, _nine(row[0], EDGE, pad_h, pad_v, pad_v + 2, tint))
	t.set_stylebox("hover", name, _nine(row[0], EDGE, pad_h, pad_v, pad_v + 2, tint * Color(1.18, 1.18, 1.18)))
	t.set_stylebox("pressed", name, _nine(row[0], EDGE, pad_h, pad_v + 2, pad_v, tint * Color(0.78, 0.78, 0.78)))
	t.set_stylebox("disabled", name, _nine(row[0], EDGE, pad_h, pad_v, pad_v + 2, Color(tint, 0.42)))
	return row[1]


## Words the page builders made in the paper inks take the chalk inks wherever they sit on something dark: a slate, a
## dark plank, a dark plate. On a sticky, a polaroid, a whiteboard or a light plate they keep the paper inks, and so does
## everything already coloured. A see-through panel or button follows what is behind it.
static func ink(n: Node, dark: bool = false) -> void:
	for c in n.get_children():
		var here := dark
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
		var is_dark := path.contains("wood_panel") or path.contains("chalk") or (path.begins_with(DIR) and not path.contains("tab_on"))
		return 1 if is_dark else -1
	return 0


## For a control that draws its own words and lines: is the nearest surface behind it dark?
static func on_dark(n: Node) -> bool:
	var p := n.get_parent()
	while p != null:
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
