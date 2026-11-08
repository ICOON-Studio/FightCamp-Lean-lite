extends RefCounted
## The shared kit for the seven approved menus (S403, operator Q-S294-127 "Yes, build the seven"; S402 "there is no art
## consistency"): the real pieces Ludo made in the look of the approved concepts - tan plaster wall, aluminium whiteboard,
## cream paper card, yellow sticky, red magnet, framed chalkboard, marker ledge. A screen uses these and cannot drift.
## Nothing reads this module until a screen is moved onto it, one screen per task, so no other page changes look.

const DIR := "res://assets/ui/warm/"

## Nine-slice borders of each piece in its own pixels: {piece: [border kept unscaled, padding inside for content]}.
## Measured on the trimmed files (tools: scratchpad kit_pack, S403): the whiteboard's corner caps, the chalkboard's wood.
const SLICE := {"board": [58, 60], "paper": [36, 24], "sticky": [70, 26], "chalk": [40, 46]}


static func tex(piece: String) -> Texture2D:
	return load(DIR + piece + ".png") as Texture2D


## The plaster wall, tiled across its parent. Add it first, full rect, behind the page.
static func wall() -> TextureRect:
	var t := TextureRect.new()
	t.stretch_mode = TextureRect.STRETCH_TILE
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.texture = tex("wall")
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.set_anchors_preset(Control.PRESET_FULL_RECT)
	return t


## A nine-sliced box for a PanelContainer's "panel" override. `piece` is a key of SLICE.
static func box(piece: String) -> StyleBoxTexture:
	var margins: Array = SLICE[piece]
	var border: float = float(margins[0])
	var pad: float = float(margins[1])
	var s := StyleBoxTexture.new()
	s.texture = tex(piece)
	s.texture_margin_left = border
	s.texture_margin_right = border
	s.texture_margin_top = border
	s.texture_margin_bottom = border
	s.content_margin_left = pad
	s.content_margin_right = pad
	s.content_margin_top = pad
	s.content_margin_bottom = pad
	return s


## A panel in one of the pieces, ready to take children.
static func panel(piece: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", box(piece))
	return p


## A red magnet `size` pixels wide, for pinning a card.
static func magnet(size: float = 28.0) -> TextureRect:
	var t := TextureRect.new()
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.texture = tex("magnet")
	t.custom_minimum_size = Vector2(size, size)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t


## The aluminium ledge with its three markers, for the foot of a whiteboard.
static func tray(width: float = 700.0) -> TextureRect:
	var t := TextureRect.new()
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_SCALE
	t.texture = tex("tray")
	t.custom_minimum_size = Vector2(width, width * 30.0 / 704.0)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t
