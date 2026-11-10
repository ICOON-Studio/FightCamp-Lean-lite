extends ColorRect
## S427 the project's ONE outline (operator C273: "use proper outline effects throught all project not cheap solutions").
## A glowing frame round a control: `Halo.ring(host, colour, radius)` for the chosen thing, `Halo.hover(host, ...)` for
## what lights when the mouse is over it. Never a flat StyleBoxFlat border for "this one is chosen" again.
## `Halo.cutout(picture)` is the same idea for a cut-out picture: a line along the figures, not a box round them.
## Drawn by halo.gdshader; it never takes a click and lives outside the host's own rect by MARGIN pixels.

const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const SHADER := preload("res://scripts/ui/halo.gdshader")
const CUTOUT := preload("res://scripts/ui/cutout.gdshader")

const MARGIN := 26.0
const GOLD := Color("#f2c14e")
const CHALK := Color("#efe6d8")

var power := 1.0: set = set_power
var _clock := 0.0


## The chosen frame: full strength, breathing, the light travelling round.
static func ring(host: Control, tint: Color = GOLD, radius: float = 10.0, strength: float = 1.0, grow: float = 0.0) -> ColorRect:
	var h: ColorRect = new()
	h.name = "Halo"
	h._setup(tint, radius, grow)
	h.power = strength
	host.add_child(h)
	if host is Container:
		# A container lays its children out inside itself: take the glow's room back every time it has sorted them.
		(host as Container).sort_children.connect(h._outside.bind(grow))
		h._outside(grow)
	return h


## Lights while the mouse is over `host` (a quieter chalk frame by default), fades when it leaves.
static func hover(host: Control, tint: Color = CHALK, radius: float = 10.0, strength: float = 0.55) -> ColorRect:
	var h := ring(host, tint, radius, 0.0)
	h.name = "HaloHover"
	host.mouse_entered.connect(h.fade.bind(strength))
	host.mouse_exited.connect(h.fade.bind(0.0))
	return h


## A cut-out picture (transparent round the figures): a line along their own edge and a soft shadow under them.
## `width` and `shadow` are in the picture's own pixels; the picture needs that much clear room round the figures.
static func cutout(pic: CanvasItem, tint: Color = CHALK, width: float = 3.0, shadow: float = 14.0) -> void:
	var m := ShaderMaterial.new()
	m.shader = CUTOUT
	m.set_shader_parameter("line", tint)
	m.set_shader_parameter("width_px", width)
	m.set_shader_parameter("shadow_px", shadow)
	pic.material = m


func _setup(tint: Color, radius: float, grow: float) -> void:
	color = Color.WHITE
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	offset_left = -MARGIN - grow
	offset_top = -MARGIN - grow
	offset_right = MARGIN + grow
	offset_bottom = MARGIN + grow
	var m := ShaderMaterial.new()
	m.shader = SHADER
	m.set_shader_parameter("margin_px", MARGIN)
	m.set_shader_parameter("radius_px", radius)
	m.set_shader_parameter("tint", tint)
	if MenuFx.instant:
		m.set_shader_parameter("breathe", 0.0)
		m.set_shader_parameter("travel", 0.0)
	material = m
	resized.connect(_sized)
	_sized()
	set_process(not MenuFx.instant)


func _outside(grow: float) -> void:
	var host := get_parent() as Control
	if host == null:
		return
	var room := Vector2.ONE * (MARGIN + grow)
	position = -room
	size = host.size + room * 2.0


func _sized() -> void:
	(material as ShaderMaterial).set_shader_parameter("rect_px", size)


func _process(delta: float) -> void:
	if power <= 0.0 or not is_visible_in_tree():
		return
	_clock += delta
	(material as ShaderMaterial).set_shader_parameter("clock", _clock)


func set_power(v: float) -> void:
	power = v
	visible = v > 0.001
	if material != null:
		(material as ShaderMaterial).set_shader_parameter("power", v)


func set_tint(tint: Color) -> void:
	(material as ShaderMaterial).set_shader_parameter("tint", tint)


func fade(to: float) -> void:
	if MenuFx.instant or not is_inside_tree():
		power = to
		return
	create_tween().tween_property(self, "power", to, 0.14)
