extends RefCounted
class_name SessionPicCard
## TRAINCLIPS1 r5 - the 2D half of the ink card (split out of session_pic_style.gd, which had passed the 500-line rule):
## snap a rendered layer onto the palette, ink where two tones meet, lay the faint start figure over the charcoal tile
## and stroke the gold arrow. The look itself is drawn in 3D - tools/session_pic_ink.gdshader and session_pic_hull.gdshader.

const GHOST := SessionPicStyle.GHOST
const MARGIN := SessionPicStyle.MARGIN
const PX := SessionPicStyle.PX
const BG := SessionPicStyle.BG
const GOLD := SessionPicStyle.GOLD
const GRAIN := SessionPicStyle.GRAIN
const ARROW_PX := SessionPicStyle.ARROW_PX
const PALETTE := SessionPicStyle.PALETTE

static var _bg: PackedByteArray = PackedByteArray()


## One rendered layer (ghost or finish) onto the palette: flat tones, ink where two tones meet.
static func ink_layer(raw: Image) -> Image:
	var small := Image.create_from_data(raw.get_width(), raw.get_height(), false, raw.get_format(), raw.get_data())
	if small.get_format() != Image.FORMAT_RGBA8:
		small.convert(Image.FORMAT_RGBA8)
	small.resize(PX, PX, Image.INTERPOLATE_LANCZOS)
	var data := small.get_data()
	var idx := PackedByteArray()
	idx.resize(PX * PX)
	for i in PX * PX:
		var o := i * 4
		if data[o + 3] < 128:
			idx[i] = 255
			data[o] = 0
			data[o + 1] = 0
			data[o + 2] = 0
			data[o + 3] = 0
			continue
		var k := _index_rgb(data[o], data[o + 1], data[o + 2])
		idx[i] = k
		var c: Color = PALETTE[k]
		data[o] = _b(c.r)
		data[o + 1] = _b(c.g)
		data[o + 2] = _b(c.b)
		data[o + 3] = 255
	# The tone boundaries: a pixel next to another tone is ink. This is the interior line the hull cannot draw.
	for y in PX:
		for x in PX:
			var i2 := y * PX + x
			if idx[i2] == 255:
				continue
			var here := idx[i2]
			var edge := false
			for d in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
				var nx: int = x + int(d[0])
				var ny: int = y + int(d[1])
				if nx < 0 or ny < 0 or nx >= PX or ny >= PX:
					continue
				var there := idx[ny * PX + nx]
				if there != 255 and there != here:
					edge = true
					break
			if edge:
				var o2 := i2 * 4
				data[o2] = 0
				data[o2 + 1] = 0
				data[o2 + 2] = 0
	return Image.create_from_data(PX, PX, false, Image.FORMAT_RGBA8, data)


## The finished card: charcoal tile, the start figure at GHOST behind, the finish figure solid, the gold arrow on top.
static func card(finish: Image, start: Image, from_px: Vector2, to_px: Vector2) -> Image:
	var out := bg_data().duplicate()
	if start != null:
		_over(out, start.get_data(), GHOST)
	_over(out, finish.get_data(), 1.0)
	var img := Image.create_from_data(PX, PX, false, Image.FORMAT_RGBA8, out)
	if from_px.distance_to(to_px) >= 6.0:
		arrow(img, from_px, to_px)
	return img


static func _over(base: PackedByteArray, layer: PackedByteArray, alpha: float) -> void:
	for i in PX * PX:
		var o := i * 4
		var a := layer[o + 3] / 255.0 * alpha
		if a <= 0.0:
			continue
		var k := 1.0 - a
		base[o] = _b(base[o] / 255.0 * k + layer[o] / 255.0 * a)
		base[o + 1] = _b(base[o + 1] / 255.0 * k + layer[o + 1] / 255.0 * a)
		base[o + 2] = _b(base[o + 2] / 255.0 * k + layer[o + 2] / 255.0 * a)


## The charcoal tile with its grain, built once and reused by every card.
static func bg_data() -> PackedByteArray:
	if not _bg.is_empty():
		return _bg
	var d := PackedByteArray()
	d.resize(PX * PX * 4)
	for y in PX:
		for x in PX:
			# A 4x4 grain cell: it reads as a photograph's grain and still compresses in the PNG.
			var n := (_hash01((x >> 2) * 928371 + (y >> 2) * 689287) * 2.0 - 1.0) * GRAIN
			var o := (y * PX + x) * 4
			d[o] = _b(BG.r + n)
			d[o + 1] = _b(BG.g + n)
			d[o + 2] = _b(BG.b + n)
			d[o + 3] = 255
	_bg = d
	return d


## A gold curved arrow, ARROW_PX wide, bowing toward the middle of the card and ending in a head at `to`.
static func arrow(img: Image, from: Vector2, to: Vector2) -> void:
	var mid := (from + to) * 0.5
	var perp := (to - from).orthogonal().normalized()
	var bow := clampf(from.distance_to(to) * 0.30, 10.0, 40.0)
	var ctrl := mid + perp * bow
	if (ctrl - mid).dot(Vector2(PX, PX) * 0.5 - mid) < 0.0:
		ctrl = mid - perp * bow
	var tip := (to - ctrl).normalized()
	var head := minf(16.0, maxf(9.0, from.distance_to(to) * 0.22))
	var end := to - tip * head * 0.6
	var steps := maxi(8, int(from.distance_to(end)))
	for i in steps + 1:
		var t := float(i) / float(steps)
		var u := 1.0 - t
		_stamp(img, u * u * from + 2.0 * u * t * ctrl + t * t * end, ARROW_PX * 0.5)
	_fill_triangle(img, to, to - tip.rotated(0.42) * head, to - tip.rotated(-0.42) * head)


static func _fill_triangle(img: Image, a: Vector2, b: Vector2, c: Vector2) -> void:
	var lo := Vector2(minf(a.x, minf(b.x, c.x)), minf(a.y, minf(b.y, c.y)))
	var hi := Vector2(maxf(a.x, maxf(b.x, c.x)), maxf(a.y, maxf(b.y, c.y)))
	for y in range(maxi(0, int(lo.y)), mini(PX, int(hi.y) + 2)):
		for x in range(maxi(0, int(lo.x)), mini(PX, int(hi.x) + 2)):
			if _in_tri(Vector2(x, y), a, b, c):
				img.set_pixel(x, y, GOLD)


static func _in_tri(p: Vector2, a: Vector2, b: Vector2, c: Vector2) -> bool:
	var d1 := (p - b).cross(b - a)
	var d2 := (p - c).cross(c - b)
	var d3 := (p - a).cross(a - c)
	var neg := d1 < 0.0 or d2 < 0.0 or d3 < 0.0
	var pos := d1 > 0.0 or d2 > 0.0 or d3 > 0.0
	return not (neg and pos)


static func _stamp(img: Image, p: Vector2, r: float) -> void:
	for y in range(maxi(0, int(p.y - r - 1)), mini(PX, int(p.y + r + 2))):
		for x in range(maxi(0, int(p.x - r - 1)), mini(PX, int(p.x + r + 2))):
			if Vector2(x, y).distance_to(p) <= r:
				img.set_pixel(x, y, GOLD)


## Snap a rendered pixel onto the palette. Red first, then the two prop families BY HUE, then the neutral greys by tone.
## The hue test matters: a neutral blend that lands on a prop's lightness (a boot's edge, a hair card against the tile)
## used to be read as the heavy bag, so the bag looked like it was touching her head and every prop check missed.
static func _index_rgb(r: int, g: int, b: int) -> int:
	if r - g > 40 and r - b > 40:
		return 4 if (r + g + b) > 169 else 5
	if r - b >= 10 and r - g <= 18:
		return 6                       # warm: the bag, the rope, the board
	if b - r >= 10 and b - g >= 10:
		return 7                       # cool: the coach's mitt
	var l := (r * 77 + g * 150 + b * 29) >> 8
	if l < 38:
		return 0
	if l < 98:
		return 1
	if l < 154:
		return 2
	return 3


static func _b(v: float) -> int:
	return clampi(int(round(v * 255.0)), 0, 255)




static func _hash01(n: int) -> float:
	n = (n ^ (n >> 16)) * 0x45d9f3b
	n = (n ^ (n >> 16)) * 0x45d9f3b
	n = n ^ (n >> 16)
	return float(n & 0xffff) / 65535.0
