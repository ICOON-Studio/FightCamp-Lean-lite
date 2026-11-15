extends RefCounted
## S491 operator ("whenyou change to large fonts everything breaks inthe scene going out of bound"): the Text size setting
## used to zoom the whole window (content_scale_factor 1.15 / 1.3), so every screen built for 1920 x 1080 lost its right and
## bottom edges (the fight's opponent plate at x 1300-1900 fell off a 1670-wide canvas). Now the canvas stays 1920 x 1080
## and only the letters grow: every Label / Button / RichTextLabel / LineEdit that enters the tree gets its font size times
## the factor, once (a meta keeps the scaled size, so a re-parented node is not scaled twice).
##   TextScale.use(tree, factor)   TextScale.factor() -> float   TextScale.scaled(px, factor) -> int

const META := "text_scale_px"
static var _f := 1.0
static var _hooked: SceneTree = null


static func factor() -> float:
	return _f


static func scaled(px: int, f: float) -> int:
	return maxi(1, int(round(float(px) * f)))


## Sets the factor for every node added from now on (a screen rebuilds on the next visit). 1.0 = nothing touched.
static func use(tree: SceneTree, f: float) -> void:
	_f = f
	if tree == null:
		return
	if _hooked != tree:
		_hooked = tree
		tree.node_added.connect(_on_added)


static func _on_added(n: Node) -> void:
	if _f == 1.0 or not (n is Control):
		return
	if n is Label or n is Button or n is LineEdit or n is RichTextLabel:
		_scale.call_deferred(n)   # after the builder has set its own font size


static func _scale(n: Node) -> void:
	if not is_instance_valid(n) or _f == 1.0:
		return
	var c := n as Control
	var key := "normal_font_size" if c is RichTextLabel else "font_size"
	var now := c.get_theme_font_size(key)
	if c.has_meta(META) and int(c.get_meta(META)) == now:
		return
	var px := scaled(now, _f)
	c.add_theme_font_size_override(key, px)
	if c is RichTextLabel:
		for k in ["bold_font_size", "italics_font_size", "bold_italics_font_size", "mono_font_size"]:
			c.add_theme_font_size_override(k, scaled(c.get_theme_font_size(k), _f))
	c.set_meta(META, px)
	if (c is Label or c is Button) and c.is_inside_tree():   # once laid out: a fixed box that no longer fits steps back
		c.get_tree().process_frame.connect(_settle.bind(c, now), CONNECT_ONE_SHOT)
		c.draw.connect(_settle_later.bind(c, now))   # a later width or a later text: check again when it redraws


static func _settle_later(c: Control, base: int) -> void:
	_settle.call_deferred(c, base)


## A grown one-line text in a box that did not grow: back down toward its Medium size (never below) until it fits.
static func _settle(c: Control, base: int) -> void:
	if not is_instance_valid(c) or not c.is_inside_tree():
		return
	var text := str(c.get("text"))
	if text == "" or text.contains("
") or (c is Label and (c as Label).autowrap_mode != TextServer.AUTOWRAP_OFF):
		return
	var font := c.get_theme_font("font")
	if font == null:
		return
	var room := c.size.x
	if c is Button:
		var sb := c.get_theme_stylebox("normal")
		room -= sb.get_margin(SIDE_LEFT) + sb.get_margin(SIDE_RIGHT) if sb != null else 0.0
	var px := c.get_theme_font_size("font_size")
	while px > base and font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x > room + 1.0:
		px -= 1
	if px != c.get_theme_font_size("font_size"):
		c.add_theme_font_size_override("font_size", px)
		c.set_meta(META, px)


## S491 ("text out of bound": "Draw the lea"): one line that must fit a box. Starts at px times the text-size factor and
## steps down to min_px; still too wide = an ellipsis and the full text on hover. Marked so _scale leaves it alone.
static func fit(l: Control, width: float, px: int, min_px: int = 14) -> int:
	var font := l.get_theme_font("font")
	if l is Button:   # a button's own padding comes off the room, and it may not grow past its slot
		var sb := l.get_theme_stylebox("normal")
		if sb != null:
			width -= sb.get_margin(SIDE_LEFT) + sb.get_margin(SIDE_RIGHT)
	var size := scaled(px, _f)
	var text := str(l.get("text"))
	while size > min_px and font != null and font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x > width:
		size -= 1
	l.add_theme_font_size_override("font_size", size)
	l.set_meta(META, size)
	l.set("clip_text", true)
	l.set("text_overrun_behavior", TextServer.OVERRUN_TRIM_ELLIPSIS)
	if font != null and font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x > width and l.tooltip_text == "":
		l.tooltip_text = text
		l.mouse_filter = Control.MOUSE_FILTER_PASS
	return size


## S491 audit ("we need to have a cohesive interface"): every visible one-line Label / Button under `root` whose text is
## wider than its box (cut, or spilling onto a neighbour). -> [{name, text, need, have}] widest overflow first.
static func overflow(root: Node, slack: float = 2.0) -> Array:
	var out: Array = []
	for n in root.find_children("*", "Control", true, false):
		var c := n as Control
		if not c.is_visible_in_tree() or not (c is Label or c is Button):
			continue
		var text := str(c.get("text"))
		if text.strip_edges() == "" or text.contains("\n"):
			continue
		if c is Label and (c as Label).autowrap_mode != TextServer.AUTOWRAP_OFF:
			continue
		if bool(c.get("clip_text")) and c.tooltip_text != "":   # cut on purpose, the whole line on hover (a mail preview)
			continue
		var font := c.get_theme_font("font")
		if font == null:
			continue
		var pad := 0.0
		if c is Button:
			var sb := c.get_theme_stylebox("normal")
			pad = sb.get_margin(SIDE_LEFT) + sb.get_margin(SIDE_RIGHT) if sb != null else 0.0
		var need := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, c.get_theme_font_size("font_size")).x + pad
		var have := c.get_global_rect().size.x
		if need > have + slack:
			out.append({"name": str(c.name), "text": text, "need": need, "have": have})
	out.sort_custom(func(a, b): return float(a["need"]) - float(a["have"]) > float(b["need"]) - float(b["have"]))
	return out
