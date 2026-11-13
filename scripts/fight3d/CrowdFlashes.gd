extends Node3D
## S447 (operator: "why cant you make your own assets instead of looking elsewhere though? like these crowd flashting effects"):
## camera flashes in the crowd, made in the game - no video overlay, no bought clip. A pool of billboard stars on real seats
## (RingSet's crowd), additive and unshaded, each a press camera's flash: full bright for one frame, gone in FLASH_S.
## Most come from the first rows (the press and the phones at ringside). A few pop at random all fight long (IDLE_PER_S);
## burst(n) fires n at once over BURST_SPREAD_S - a big shot, a knockdown, the final bell.
## The texture is drawn here in code: a hot white core, a soft glow and four thin spikes (a lens star).

const POOL := 32
const FLASH_S := 0.16          # a xenon flash is ~1/1000 s; the eye and the camera smear it to about two frames + a fade
const HOLD_S := 0.04           # full bright this long (two frames at 60), then the fade - S447 film: a flash fading from frame 1 never read
const IDLE_PER_S := 0.7        # flashes a second around the hall while nothing big happens
const BURST_SPREAD_S := 0.45   # a burst's flashes go off over this long, not in one frame
const NEAR_ROWS_SHARE := 0.7   # share of flashes from the rows nearest the ring
const SIZE_M := 1.1            # the star's size at full bright (S447 film: 0.55 m was ~20 px from the broadcast camera, lost in its blur)
const HDR := 2.6               # brighter than white, so the glow and the far blur keep it
const TEX_PX := 64

var seats: Array = []          # Vector3 head positions, nearest rows first in `near`
var near: Array = []
var rng := RandomNumberGenerator.new()
var _pool: Array = []          # [{sprite, t}] t < 0 = idle
var _queue: Array = []         # seconds until each queued burst flash fires
var _idle_t := 0.0
var fired := 0                 # flashes started (tests read it)


func setup(heads: Array, near_heads: Array, seed: int = 4471) -> void:
	seats = heads
	near = near_heads if not near_heads.is_empty() else heads
	rng.seed = seed
	var tex := star_texture()
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	mat.no_depth_test = false
	mat.albedo_texture = tex
	mat.albedo_color = Color(HDR, HDR, HDR, 1.0)
	for i in POOL:
		var s := MeshInstance3D.new()
		var q := QuadMesh.new()
		q.size = Vector2(SIZE_M, SIZE_M)
		s.mesh = q
		s.material_override = mat
		s.visible = false
		s.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(s)
		_pool.append({"node": s, "t": -1.0})


## The lens star, drawn once: a hot core, a soft glow and four thin spikes, white with a cool edge.
static func star_texture() -> ImageTexture:
	var img := Image.create(TEX_PX, TEX_PX, false, Image.FORMAT_RGBA8)
	var c := (TEX_PX - 1) * 0.5
	for y in TEX_PX:
		for x in TEX_PX:
			var dx := (x - c) / c
			var dy := (y - c) / c
			var r := sqrt(dx * dx + dy * dy)
			var core := clampf(1.0 - r / 0.18, 0.0, 1.0)
			var glow := pow(clampf(1.0 - r, 0.0, 1.0), 3.0) * 0.55
			var spike := pow(clampf(1.0 - absf(dy) / 0.035, 0.0, 1.0), 2.0) * pow(clampf(1.0 - absf(dx), 0.0, 1.0), 1.5) \
				+ pow(clampf(1.0 - absf(dx) / 0.035, 0.0, 1.0), 2.0) * pow(clampf(1.0 - absf(dy), 0.0, 1.0), 1.5)
			var a := clampf(core + glow + spike * 0.8, 0.0, 1.0)
			var cool := clampf(r * 1.4, 0.0, 1.0)
			img.set_pixel(x, y, Color(1.0 - cool * 0.12, 1.0 - cool * 0.05, 1.0, a))
	return ImageTexture.create_from_image(img)


## n flashes over BURST_SPREAD_S (a big shot, a knockdown, the final bell).
func burst(n: int) -> void:
	for i in n:
		_queue.append(rng.randf() * BURST_SPREAD_S)


func active() -> int:
	var k := 0
	for f in _pool:
		if float(f["t"]) >= 0.0:
			k += 1
	return k


func _process(delta: float) -> void:
	step(delta)


## One tick (tests call it directly).
func step(delta: float) -> void:
	if seats.is_empty():
		return
	_idle_t += delta * IDLE_PER_S
	while _idle_t >= 1.0:
		_idle_t -= 1.0 + rng.randf_range(-0.5, 0.5)
		_fire()
	var keep: Array = []
	for q in _queue:
		var left := float(q) - delta
		if left <= 0.0:
			_fire()
		else:
			keep.append(left)
	_queue = keep
	for f in _pool:
		var t := float(f["t"])
		if t < 0.0:
			continue
		t += delta
		var node: MeshInstance3D = f["node"]
		if t >= FLASH_S:
			f["t"] = -1.0
			node.visible = false
			continue
		f["t"] = t
		var k := 1.0 if t <= HOLD_S else 1.0 - (t - HOLD_S) / (FLASH_S - HOLD_S)
		node.scale = Vector3.ONE * (0.6 + 0.4 * k)
		node.transparency = 1.0 - k * k


func _fire() -> void:
	for f in _pool:
		if float(f["t"]) < 0.0:
			var src: Array = near if rng.randf() < NEAR_ROWS_SHARE else seats
			var p: Vector3 = src[rng.randi() % src.size()]
			# S447 film: seats run all round the ring, so most flashes went off behind the camera. Prefer a seat in view.
			var cam: Camera3D = get_viewport().get_camera_3d() if is_inside_tree() else null
			if cam != null:
				for tries in 8:
					if cam.is_position_in_frustum(to_global(p)):
						break
					p = src[rng.randi() % src.size()]
			var node: MeshInstance3D = f["node"]
			node.position = p + Vector3(rng.randf_range(-0.12, 0.12), rng.randf_range(0.0, 0.18), 0.0)
			node.scale = Vector3.ONE
			node.transparency = 0.0
			node.visible = true
			f["t"] = 0.0
			fired += 1
			return
