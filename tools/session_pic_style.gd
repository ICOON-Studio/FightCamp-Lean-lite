extends RefCounted
class_name SessionPicStyle
## TRAINCLIPS1 r5 - the ink exercise-card look for tools/bake_session_pics.gd.
##
## Round 4 shaded the body with the game's PBR materials and then tried to posterise the shaded pixels into ink in 2D:
## the tones came out as blobs and the outline never appeared. This round draws the look in 3D (tools/session_pic_ink.gdshader
## fills every facet with one of three flat greys, tools/session_pic_hull.gdshader draws the ink line), renders at 1024 and
## only then downsamples - so the tones and the line survive the trip to 256. What is left in 2D is deliberately thin:
## snap each layer onto the palette, draw the ink line where two tones meet, lay the 35 % start ghost over the charcoal
## tile, and stroke the gold arrow. Every constant here is also a threshold in tests/session_pics_test.gd.

const INK_SHADER := "res://tools/session_pic_ink.gdshader"
const HULL_SHADER := "res://tools/session_pic_hull.gdshader"

## The palette. The values are kept far apart on purpose: the body greys and the prop greys must not read as each other,
## and nothing but the ink line may be darker than INK_LUMA.
const BG := Color(0.106, 0.090, 0.078)        # #1b1714 - the operator's charcoal tile
const INK := Color(0.0, 0.0, 0.0)             # the 2-3 px outline and the tone boundaries
const GREY_DARK := Color(0.30, 0.30, 0.32)
const GREY_MID := Color(0.46, 0.46, 0.48)
const GREY_LIGHT := Color(0.74, 0.74, 0.76)
const RED := Color(0.62, 0.08, 0.08)          # her kit: the only colour on the body
const RED_SHADOW := Color(0.44, 0.06, 0.06)
## The props are WARM on purpose. The start ghost is composited at 35 % over the tile, and a neutral grey at 35 % lands on
## the very colour a neutral prop grey has (S352: the ghost's mid tone read as the heavy bag, and the bag seemed to touch
## her head). Warm props can never be confused with a ghost of the body, and they match the reference's brown-grey bags.
const PROP_GREY := Color(0.60, 0.56, 0.48)    # bag, rope, board: flat mid grey
const PROP_DARK := Color(0.19, 0.20, 0.32)    # the coach's mitt: black, still clear of the ink and of the tile
const GOLD := Color(0.914, 0.722, 0.290)      # #e9b84a, the arrow
const PALETTE: Array[Color] = [INK, GREY_DARK, GREY_MID, GREY_LIGHT, RED, RED_SHADOW, PROP_GREY, PROP_DARK]

const PX := 256                               # the card's size
const GRAIN := 0.040                          # +/- of the tile's charcoal (a photo tile, not a cut-out)
const BG_TOL := 0.070                         # the tile's own grain must stay inside this
const PROP_TOL := 0.045       # tight: a ghost of the body's mid grey is not far from a prop, and must not read as one
const INK_LUMA := 0.09                        # darker than this is ink (or the tile, which is 0.093)
const RED_TOL := 0.12
const MARGIN := 6                             # px of the finished card that the drawing keeps clear of
const GHOST := 0.35                           # the start figure's opacity
const ARROW_PX := 4

static var _bg: PackedByteArray = PackedByteArray()


# ---------------------------------------------------------------- 3D: the ink materials -------------------------------------------------

## The four ink fills, shared by every body: the grey ramp, her red kit, the flat white trim and the flat dark hair.
static func ink_materials() -> Dictionary:
	var shader: Shader = load(INK_SHADER) as Shader
	return {
		"skin": _mat(shader, GREY_LIGHT, GREY_MID, GREY_DARK),
		"kit": _mat(shader, RED, RED, RED_SHADOW),
		"trim": _mat(shader, GREY_LIGHT, GREY_LIGHT, GREY_LIGHT),
		"dark": _mat(shader, GREY_DARK, GREY_DARK, GREY_DARK),
		"hair": _mat(shader, GREY_DARK, GREY_DARK, GREY_DARK),
	}


static func _mat(shader: Shader, lit: Color, mid: Color, dark: Color) -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = shader
	m.set_shader_parameter("col_lit", lit)
	m.set_shader_parameter("col_mid", mid)
	m.set_shader_parameter("col_dark", dark)
	return m


## Which ink class a surface wears, from the name of the material MHRig / FighterKit / Gloves gave it.
static func surface_class(mat_name: String) -> String:
	if mat_name.begins_with("MH_Trunks") or mat_name.begins_with("MH_Top") or mat_name == "Glove":
		return "kit"
	if mat_name.begins_with("MH_Trim"):
		return "trim"
	if mat_name.begins_with("MH_Hair"):
		return "hair"
	if mat_name.begins_with("MH_Brow") or mat_name.begins_with("MH_Eye") or mat_name.begins_with("tripo_material"):
		return "dark"
	return "skin"


## The card meshes are drawn flat and WITHOUT a hull: her brows, lashes and eyes are a few centimetres across, and a
## 2.5 px inverted hull around each card would swallow the face (S352: the first bake's head was a black speckled blob).
static func wants_hull(mat_name: String) -> bool:
	return not (mat_name.begins_with("MH_Brow") or mat_name.begins_with("MH_Eye"))


## The hair is a solid dark mass, not a card texture: the cards' own alpha test left her scalp speckled with skin.
static func wants_alpha(mat_name: String) -> bool:
	return not mat_name.begins_with("MH_Hair")


## Paints `body` in ink: every surface takes its flat fill and gets an inverted-hull twin for the outline. Returns the
## hull materials, so the driver can keep their width_m at the card's 2.5 px as the camera size changes.
static func ink_body(body: Node3D, mats: Dictionary) -> Array:
	var hull_shader: Shader = load(HULL_SHADER) as Shader
	var hulls: Array = []
	var cache := {}
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		if mi.mesh == null or mi.mesh.get_surface_count() == 0:
			continue
		var outline := MeshInstance3D.new()
		outline.name = "InkOutline"
		outline.mesh = mi.mesh
		outline.extra_cull_margin = 0.6
		outline.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var painted := 0
		for s in mi.mesh.get_surface_count():
			var base: Material = mi.mesh.surface_get_material(s)
			var name := ""
			var tex: Texture2D = null
			if base is StandardMaterial3D:
				name = (base as StandardMaterial3D).resource_name
				tex = (base as StandardMaterial3D).albedo_texture
			var cls := surface_class(name)
			if mi.material_override != null:
				mi.material_override = mats[cls]   # it beats a per-surface override: the glove wears one from Gloves.mount
			mi.set_surface_override_material(s, mats[cls])
			var cut: Texture2D = tex if wants_alpha(name) else null
			var key := "%s|%s" % [cls, cut.get_rid() if cut != null else "-"]
			var hull: ShaderMaterial
			if cache.has(key):
				hull = cache[key]
			else:
				hull = ShaderMaterial.new()
				hull.shader = hull_shader
				if cut != null:
					hull.set_shader_parameter("alpha_tex", cut)
					hull.set_shader_parameter("use_alpha", 1.0)
				cache[key] = hull
				hulls.append(hull)
			if not wants_hull(name):
				# No twin for this surface - but the twin's other surfaces must not fall back to the body's own material
				# and draw a second copy of the eyes. A material that always discards keeps the twin out of the way.
				hull = _hide_hull(hull_shader)
			outline.set_surface_override_material(s, hull)
			painted += 1
		if painted == 0:
			outline.free()
			continue
		outline.skin = mi.skin
		mi.add_child(outline)
		var skel := _skeleton_of(mi)
		if skel != null:
			outline.skeleton = outline.get_path_to(skel)
	return hulls


static func _skeleton_of(node: Node) -> Skeleton3D:
	var n: Node = node
	while n != null:
		if n is Skeleton3D:
			return n as Skeleton3D
		n = n.get_parent()
	return null


## A hull material that discards every fragment (a blank alpha texture with the cut on): the surfaces that carry no
## outline still need *something* on the twin, or it draws them again with the body's own material.
static var _hide: ShaderMaterial = null

static func _hide_hull(hull_shader: Shader) -> ShaderMaterial:
	if _hide != null:
		return _hide
	var blank := Image.create(2, 2, false, Image.FORMAT_RGBA8)
	blank.fill(Color(0, 0, 0, 0))
	_hide = ShaderMaterial.new()
	_hide.shader = hull_shader
	_hide.set_shader_parameter("alpha_tex", ImageTexture.create_from_image(blank))
	_hide.set_shader_parameter("use_alpha", 1.0)
	return _hide


## A flat prop tone - props are flat mid grey with the same outline, never shaded. It is the ink shader with all three
## tones equal, NOT a StandardMaterial3D: a base material's albedo_color and a shader's source_color uniform do not land
## in the same place in the frame buffer, and a prop that missed the palette read as body grey (S352: the heavy bag came
## out GREY_LIGHT, 0.79 instead of 0.60, and every prop check missed it).
static func prop_material(col: Color) -> ShaderMaterial:
	var m := _mat(load(INK_SHADER) as Shader, col, col, col)
	return m


## The mesh a prop's outline is drawn with (the inverted hull, shared with the body).
static func outline_child(mesh: Mesh, hull_shader: Shader) -> MeshInstance3D:
	var hull := ShaderMaterial.new()
	hull.shader = hull_shader
	var out := MeshInstance3D.new()
	out.name = "InkOutline"
	out.mesh = mesh
	out.material_override = hull
	out.extra_cull_margin = 0.4
	out.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return out


## A prop ready to hang: flat tone, and its own ink twin. Returns the hull material so the driver keeps its width.
static func prop_mesh(mesh: Mesh, col: Color, hull_shader: Shader) -> Array:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = prop_material(col)
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var twin := outline_child(mesh, hull_shader)
	mi.add_child(twin)
	return [mi, twin.material_override as ShaderMaterial]


static func prop_cyl(r: float, h: float, col: Color, hull_shader: Shader, segs: int = 32) -> Array:
	var cyl := CylinderMesh.new()
	cyl.top_radius = r
	cyl.bottom_radius = r
	cyl.height = h
	cyl.radial_segments = segs
	cyl.rings = 1
	return prop_mesh(cyl, col, hull_shader)


static func prop_sphere(r: float, col: Color, hull_shader: Shader) -> Array:
	var sph := SphereMesh.new()
	sph.radius = r
	sph.height = r * 2.0
	sph.radial_segments = 32
	sph.rings = 16
	return prop_mesh(sph, col, hull_shader)


static func prop_box(size: Vector3, col: Color, hull_shader: Shader) -> Array:
	var box := BoxMesh.new()
	box.size = size
	return prop_mesh(box, col, hull_shader)


## Distance from `p` to a tagged prop (see the meta the driver writes): inside the shape = 0.
static func prop_gap(p: Vector3, node: Node, glove: bool) -> float:
	var kind := str(node.get_meta("prop_kind", ""))
	if kind == "":
		return INF
	var c: Vector3 = node.get_meta("prop_c")
	var r: float = float(node.get_meta("prop_r"))
	var h: float = float(node.get_meta("prop_h"))
	if kind == "disc" and glove:
		var n: Vector3 = (node as Node3D).global_transform.basis.y.normalized()
		var rel := p - c
		var along: float = rel.dot(n)
		var plane: Vector3 = rel - n * along
		if plane.length() <= r and absf(along) <= h:
			return 0.0
		return minf(maxf(0.0, absf(along) - h), maxf(0.0, plane.length() - r))
	if kind == "cyl":
		var q := p - c
		var xz := maxf(0.0, Vector2(q.x, q.z).length() - r)
		var dy := maxf(0.0, absf(q.y) - h)
		return sqrt(xz * xz + dy * dy)
	return maxf(0.0, p.distance_to(c) - r)


# ---------------------------------------------------------------- queries every check reads -------------------------------------------------

static func is_bg(c: Color) -> bool:
	return absf(c.r - BG.r) <= BG_TOL and absf(c.g - BG.g) <= BG_TOL and absf(c.b - BG.b) <= BG_TOL


static func near_ink(c: Color) -> bool:
	return c.r <= INK_LUMA and c.g <= INK_LUMA and c.b <= INK_LUMA


static func near_kit_red(c: Color) -> bool:
	return c.r > 0.38 and c.g < 0.22 and c.b < 0.22 and c.r > c.g * 1.6


static func near_prop(c: Color) -> bool:
	return _near(c, PROP_GREY, PROP_TOL) or _near(c, PROP_DARK, PROP_TOL)


static func near_gold(c: Color) -> bool:
	return _near(c, GOLD, RED_TOL)


## The drawing's box: everything that is neither the tile nor the arrow.
static func figure_box(img: Image) -> Rect2i:
	var r := Rect2i(0, 0, 0, 0)
	var first := true
	for y in img.get_height():
		for x in img.get_width():
			var c: Color = img.get_pixel(x, y)
			if is_bg(c) or near_gold(c):
				continue
			if first:
				r = Rect2i(x, y, 1, 1)
				first = false
			else:
				r = r.expand(Vector2i(x, y))
	return r


static func kit_red_pixels(img: Image) -> Array:
	var out: Array = []
	for y in img.get_height():
		for x in img.get_width():
			if near_kit_red(img.get_pixel(x, y)):
				out.append(Vector2i(x, y))
	return out


static func prop_pixels(img: Image) -> Array:
	var out: Array = []
	for y in img.get_height():
		for x in img.get_width():
			if near_prop(img.get_pixel(x, y)):
				out.append(Vector2i(x, y))
	return out


## Her head's skin: the grey tones in the top of the box, without the kit, the props, the arrow or the ink.
static func head_skin_pixels(img: Image, box: Rect2i) -> Array:
	var top_y := box.position.y + int(float(box.size.y) * 0.28)
	var out: Array = []
	for y in range(box.position.y, mini(top_y + 1, box.position.y + box.size.y)):
		for x in range(box.position.x, box.position.x + box.size.x):
			var c: Color = img.get_pixel(x, y)
			if is_bg(c) or near_kit_red(c) or near_gold(c) or near_prop(c) or near_ink(c):
				continue
			out.append(Vector2i(x, y))
	return out


## The ink line's own pixels: black, and touching something that is neither ink nor tile.
static func count_outline(img: Image) -> int:
	var n := 0
	for y in img.get_height():
		for x in img.get_width():
			if not near_ink(img.get_pixel(x, y)):
				continue
			var drawn := false
			for dy in [-1, 0, 1]:
				for dx in [-1, 0, 1]:
					var nx: int = x + dx
					var ny: int = y + dy
					if nx < 0 or ny < 0 or nx >= img.get_width() or ny >= img.get_height():
						continue
					var c: Color = img.get_pixel(nx, ny)
					if not near_ink(c) and not is_bg(c):
						drawn = true
						break
				if drawn:
					break
			if drawn:
				n += 1
	return n


static func pixel_diff_frac(a: Image, b: Image) -> float:
	var w := a.get_width()
	var h := a.get_height()
	var diff := 0
	for y in h:
		for x in w:
			if a.get_pixel(x, y).is_equal_approx(b.get_pixel(x, y)):
				continue
			diff += 1
	return float(diff) / float(w * h)


# ---------------------------------------------------------------- small shared bits -------------------------------------------------

static func _near(c: Color, want: Color, tol: float) -> bool:
	return absf(c.r - want.r) <= tol and absf(c.g - want.g) <= tol and absf(c.b - want.b) <= tol
