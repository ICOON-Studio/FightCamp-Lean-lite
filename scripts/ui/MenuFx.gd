extends RefCounted
## S408 operator: "make the fucking game look like a game not a website form", "make art, use animations/effects in menus".
## The menus' shared art and motion: a painted full-screen scene that drifts, dust in the light, sunbeams, a logo that lands,
## things that arrive one after another, buttons that answer the mouse, numbers that count. Every screen takes its motion from
## here so the game moves one way. `instant` (stills, tests) puts everything at its end state.

const UI := preload("res://scripts/ui/UI.gd")
const Sfx := preload("res://scripts/audio/Sfx.gd")
const RAYS := preload("res://assets/ui/art/sun_rays.gdshader")

static var instant := DisplayServer.get_name() == "headless"


## `f` runs once the node is in the tree (a tween can only start there).
static func _when_in(n: Node, f: Callable) -> void:
	if n.is_inside_tree():
		f.call()
	else:
		n.tree_entered.connect(f, CONNECT_ONE_SHOT)


## A painted scene covering its parent, drifting very slowly in and out.
static func art(path: String) -> TextureRect:
	var r := TextureRect.new()
	r.name = "Art"
	r.texture = load(path)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.resized.connect(func(): r.pivot_offset = r.size * 0.5)
	if not instant:
		_when_in(r, func():
			var t := r.create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			t.tween_property(r, "scale", Vector2.ONE * 1.07, 26.0)
			t.tween_property(r, "scale", Vector2.ONE, 26.0))
	return r


static func rays(strength: float = 0.2) -> ColorRect:
	var r := ColorRect.new()
	r.name = "SunRays"
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var m := ShaderMaterial.new()
	m.shader = RAYS
	m.set_shader_parameter("strength", strength)
	r.material = m
	return r


## Dust drifting up through the light, over the whole screen.
static func dust(amount: int = 70) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.name = "Dust"
	p.amount = amount
	p.lifetime = 11.0
	p.preprocess = 11.0
	p.position = Vector2(960, 540)
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = Vector2(1200, 700)
	p.direction = Vector2(-0.4, -1.0)
	p.spread = 35.0
	p.gravity = Vector2.ZERO
	p.initial_velocity_min = 6.0
	p.initial_velocity_max = 24.0
	p.scale_amount_min = 0.12
	p.scale_amount_max = 0.42
	var g := Gradient.new()
	g.colors = PackedColorArray([Color(1, 0.96, 0.85, 0.0), Color(1, 0.96, 0.85, 0.55), Color(1, 0.96, 0.85, 0.0)])
	g.offsets = PackedFloat32Array([0.0, 0.5, 1.0])
	p.color_ramp = g
	var soft := GradientTexture2D.new()
	var spot := Gradient.new()
	spot.colors = PackedColorArray([Color.WHITE, Color(1, 1, 1, 0)])
	soft.gradient = spot
	soft.fill = GradientTexture2D.FILL_RADIAL
	soft.fill_from = Vector2(0.5, 0.5)
	soft.fill_to = Vector2(1.0, 0.5)
	soft.width = 24
	soft.height = 24
	p.texture = soft
	var add := CanvasItemMaterial.new()
	add.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	p.material = add
	return p


## The logo lands: big to its size, with a thud.
static func slam(c: Control, delay: float = 0.15) -> void:
	if instant:
		return
	c.modulate.a = 0.0
	c.scale = Vector2.ONE * 1.5
	c.resized.connect(func(): c.pivot_offset = c.size * 0.5)
	_when_in(c, func():
		c.pivot_offset = c.size * 0.5
		var t := c.create_tween().set_parallel()
		t.tween_property(c, "modulate:a", 1.0, 0.12).set_delay(delay)
		t.tween_property(c, "scale", Vector2.ONE, 0.34).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t.tween_callback(func(): Sfx.play("punch_big")).set_delay(delay + 0.14))


## Things arrive one after another, growing out of their left edge (a container keeps their position; scale is free).
static func arrive(items: Array, delay: float = 0.3, step: float = 0.06) -> void:
	if instant:
		return
	var i := 0
	for it in items:
		var c: Control = it
		var wait := delay + step * i
		c.modulate.a = 0.0
		c.scale = Vector2(0.9, 1.0)
		_when_in(c, func():
			var t := c.create_tween().set_parallel()
			t.tween_property(c, "modulate:a", 1.0, 0.22).set_delay(wait)
			t.tween_property(c, "scale", Vector2.ONE, 0.32).set_delay(wait).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT))
		i += 1


## A card that pops in from its middle.
static func pop(c: Control, delay: float = 0.1) -> void:
	if instant:
		return
	c.modulate.a = 0.0
	c.scale = Vector2.ONE * 0.8
	c.resized.connect(func(): c.pivot_offset = c.size * 0.5)
	_when_in(c, func():
		c.pivot_offset = c.size * 0.5
		var t := c.create_tween().set_parallel()
		t.tween_property(c, "modulate:a", 1.0, 0.18).set_delay(delay)
		t.tween_property(c, "scale", Vector2.ONE, 0.38).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT))


## A button grows a little under the mouse.
static func hover_grow(b: Control, by: float = 1.04) -> void:
	b.resized.connect(func(): b.pivot_offset = b.size * 0.5)
	var to := func(s: float):
		if b.is_inside_tree():
			b.create_tween().tween_property(b, "scale", Vector2.ONE * s, 0.1).set_trans(Tween.TRANS_SINE)
	b.mouse_entered.connect(to.bind(by))
	b.mouse_exited.connect(to.bind(1.0))


## S408 operator: "apply the ludo filters textures to the game for all menus": Ludo's painted wall behind every page.
static func wall() -> TextureRect:
	var r := TextureRect.new()
	r.name = "PaintedWall"
	r.texture = load("res://assets/ui/art/menu_wall.jpg")
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## S410 the picture behind the page: "" = Ludo's plain wall. Shell clears it before each page; Fighters asks for the painted gym.
static func set_wall(main: Node, path: String = "") -> void:
	var r: TextureRect = main.get_node_or_null("PaintedWall")
	if r != null:
		r.texture = load(path if path != "" else "res://assets/ui/art/menu_wall.jpg")


## ... and its painted paper grain laid over the whole page, cards, buttons and all (multiplied, so white turns to painted paper).
static func paper_filter() -> TextureRect:
	var r := wall()
	r.name = "PaintedPaper"
	r.texture = load("res://assets/ui/art/menu_paper.jpg")
	var mul := CanvasItemMaterial.new()
	mul.blend_mode = CanvasItemMaterial.BLEND_MODE_MUL
	r.material = mul
	return r


## A number that counts up to its value. `show` formats it.
static func count(l: Label, to: int, show: Callable, seconds: float = 0.6) -> void:
	l.text = str(show.call(to))
	if instant:
		return
	_when_in(l, func():
		var t := l.create_tween()
		t.tween_method(func(v: float): l.text = str(show.call(roundi(v))), 0.0, float(to), seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT))
