extends Camera3D
## The ring's broadcast camera (split from FightStage S302): a TV lens at the apron that follows the pair, the close-up on
## a big shot, the ropes between it and the boxers made see-through, and the nudge on a power shot.
##   broadcast(a, b, snap, delta)  close_up(a, b, head_y, hit)  shake(m)  nudge(delta)  clear_view(ring_side, a, b, delta)

## The nudge decays with this time constant (seconds).
const SHAKE_TAU_S := 0.09
## S311 clear view: a rope or post within this of the line from the lens to a boxer (stopped this short of her, so the
## ropes behind her stay) is hidden.
const SIGHT_MARGIN_M := 0.3
const SIGHT_SHORT_M := 0.25
## S311 (operator: "make the ropes transparent when they block in the view"): a blocking rope or post fades to SEE_ALPHA
## over FADE_S instead of vanishing, and back to solid when the view clears.
const SEE_ALPHA := 0.18
const FADE_S := 0.2

## S317 shot director (operator, on a reference boxing game's video: "look how much better their game looks"; the
## reference cuts every 5.8 s on average - 15 shots in 86 s - between ringside lenses at chest height that keep
## orbiting, the pair filling ~70 % of the frame; ours sat 3.6 m out at 1.45 m on one slowly drifting angle, ~45 %).
## Each shot: dist (m from the pair's middle), h (lens height), look_h, fov, yaw (deg off the side-on line), orbit
## (deg/s while it holds); "shoulder" = behind one boxer's shoulder onto the other. HOLD_S = how long a shot holds.
const SHOTS := [
	{"name": "side", "dist": 3.0, "h": 1.3, "look_h": 1.0, "fov": 36.0, "yaw": 0.0, "orbit": 6.0},
	{"name": "low_diag", "dist": 2.7, "h": 1.0, "look_h": 1.1, "fov": 40.0, "yaw": 38.0, "orbit": -9.0},
	{"name": "shoulder", "dist": 1.75, "h": 1.78, "look_h": 1.25, "fov": 40.0, "yaw": 0.0, "orbit": 0.0},
	{"name": "side_wide", "dist": 3.7, "h": 1.55, "look_h": 1.0, "fov": 34.0, "yaw": -30.0, "orbit": 8.0},
	{"name": "low_diag", "dist": 2.7, "h": 1.0, "look_h": 1.1, "fov": 40.0, "yaw": -40.0, "orbit": 10.0},
	{"name": "shoulder", "dist": 1.75, "h": 1.78, "look_h": 1.25, "fov": 40.0, "yaw": 0.0, "orbit": 0.0},
]
const HOLD_S := Vector2(4.0, 7.5)
## S317 motion blur (operator: "go ahead" on the download): sphynx-owner's Godot Motion Blur Addon v1.1.1 (MIT, per-object
## velocity blur as a compositor effect; needs his Easy Compositor Addon v1.0.4, MIT) - res://addons. The reference's fast
## punches smear; ours stepped frame to frame. Camera rotation counts little (an orbit should not smear the ring); a cut
## or a jump of the lens past JUMP_M gets no blur on that frame. `-- noblur` = the control arm; headless runs have none.
const MOTION_BLUR := "res://addons/godot-motion-blur/guertin/guertin_motion_blur.gd"
const BLUR := 1.0
const JUMP_M := 0.4

var close := false            # the big-shot close-up holds until broadcast() runs again
var _shot := -1
var _shot_t := 0.0            # seconds the current shot has held
var _shot_hold := 0.0
var _over := 0                # the shoulder shot's boxer (alternates)
var _rng := RandomNumberGenerator.new()
var _blur: CompositorEffect = null
var _side := Vector3.LEFT     # the side of the pair the camera is on (it never jumps across the ring)
var _clock := 0.0
var _shake := 0.0             # metres, decaying
var _shake_t := 0.0


func _init() -> void:
	# A broadcast lens: the ring sharp, the hall beyond it soft.
	var lens := CameraAttributesPractical.new()
	lens.dof_blur_far_enabled = true
	lens.dof_blur_far_transition = 2.0
	lens.dof_blur_amount = 0.22
	attributes = lens
	if DisplayServer.get_name() != "headless" and not OS.get_cmdline_user_args().has("noblur") and ResourceLoader.exists(MOTION_BLUR):
		_blur = (load(MOTION_BLUR) as Script).new() as CompositorEffect
		_blur.set("intensity", BLUR)
		_blur.set("multiplier_camera_rotation", 0.1)
		var comp := Compositor.new()
		comp.compositor_effects = [_blur]
		compositor = comp


## No blur on a frame whose lens jumped (a cut): its motion vectors would smear the whole picture.
func _place_lens(pos: Vector3, look: Vector3) -> void:
	if _blur != null:
		_blur.set("intensity", 0.0 if position.distance_to(pos) > JUMP_M else BLUR)
	look_at_from_position(pos, look, Vector3.UP)


## The ringside lenses (SHOTS): each follows the pair, orbits slowly while it holds, and cuts to the next after HOLD_S
## (a cut is a snap, never a swing across the ring). `snap` = start on a fresh shot.
func broadcast(a: Vector3, b: Vector3, snap: bool = false, delta: float = 0.0) -> void:
	close = false
	_clock += delta
	_shot_t += delta
	var cut := snap or _shot < 0 or _shot_t >= _shot_hold
	if cut:
		if _shot < 0:
			_rng.seed = 317
		_shot = (_shot + 1) % SHOTS.size()
		_shot_t = 0.0
		_shot_hold = _rng.randf_range(HOLD_S.x, HOLD_S.y)
		if str(SHOTS[_shot]["name"]) == "shoulder":
			_over = 1 - _over
	var sh: Dictionary = SHOTS[_shot]
	var mid := (a + b) * 0.5
	var side := _side_of(a, b)
	_side = side
	_lens(false)
	var want_pos: Vector3
	var want_look: Vector3
	if str(sh["name"]) == "shoulder":
		# Behind one boxer's shoulder, a little to the camera's side, onto the other's face.
		var near: Vector3 = a if _over == 0 else b
		var far: Vector3 = b if _over == 0 else a
		var axis := (far - near).normalized()
		want_pos = near - axis * float(sh["dist"]) + side * 0.95 + Vector3(0, float(sh["h"]), 0)
		want_look = far + Vector3(0, float(sh["look_h"]), 0)
	else:
		var yaw := deg_to_rad(float(sh["yaw"]) + float(sh["orbit"]) * _shot_t)
		var dir := Basis(Vector3.UP, yaw) * side
		want_pos = mid + dir * float(sh["dist"]) + Vector3(0, float(sh["h"]), 0)
		want_look = mid + Vector3(0, float(sh["look_h"]), 0)
	(attributes as CameraAttributesPractical).dof_blur_far_distance = want_pos.distance_to(want_look) + 1.6
	fov = float(sh["fov"])
	if cut:
		_place_lens(want_pos, want_look)
		return
	var k := clampf(delta * 3.0, 0.0, 1.0)
	_place_lens(position.lerp(want_pos, k), want_look)


## Low at the side, both heads in frame (`head_y` = the hit boxer's head height), held until broadcast() is called again.
func close_up(a: Vector3, b: Vector3, head_y: float, hit: int) -> void:
	close = true
	_lens(false)
	var mid := (a + b) * 0.5 + Vector3(0, head_y - 0.12, 0)
	var axis := (b - a).normalized()
	var side := _side_of(a, b)
	fov = 32.0
	(attributes as CameraAttributesPractical).dof_blur_far_distance = 2.5 + 1.2
	var hitter := axis if hit == 1 else -axis
	_place_lens(mid + side * 2.5 - hitter * 0.15 + Vector3(0, 0.08, 0), mid)


func _side_of(a: Vector3, b: Vector3) -> Vector3:
	var side := (b - a).normalized().cross(Vector3.UP).normalized()
	return -side if side.dot(_side) < 0.0 else side


## S302: a power shot nudges the lens (the framing itself is untouched).
func shake(m: float) -> void:
	_shake = maxf(_shake, m)


func nudge(delta: float) -> void:
	if _shake < 0.002:
		h_offset = 0.0
		v_offset = 0.0
		return
	_shake_t += delta
	h_offset = _shake * sin(_shake_t * 71.0)
	v_offset = _shake * 0.7 * sin(_shake_t * 53.0 + 1.3)
	_shake *= exp(-delta / SHAKE_TAU_S)


## A TV camera shoots between the ropes: every rope or post nearer the camera than the boxers is hidden.
func clear_view(ring_side: Array, a: Vector3, b: Vector3, delta: float = 0.0) -> void:
	var mid := (a + b) * 0.5
	var to_cam := Vector3(global_position.x - mid.x, 0, global_position.z - mid.z).normalized()
	var cam := Vector2(global_position.x, global_position.z)
	for n in ring_side:
		var node := n as Node3D
		var at := node.global_position
		var d := Vector3(at.x - mid.x, 0, at.z - mid.z)
		var hide := d.dot(to_cam) >= 1.2
		# S311: the range breathes and the pair reaches the ropes (~110 m a round): from a corner angle the side next to
		# the camera crossed both bodies. A rope or post that crosses the camera's line to either boxer goes too.
		var along := node.global_transform.basis.y
		var half := Vector2(along.x, along.z) * float(((node as MeshInstance3D).mesh as CylinderMesh).height) * 0.5
		var c := Vector2(at.x, at.z)
		for p in [a, b]:
			var to := Vector2(p.x, p.z)
			var end := to + (cam - to).normalized() * SIGHT_SHORT_M
			var q := Geometry2D.get_closest_points_between_segments(c - half, c + half, cam, end)
			hide = hide or q[0].distance_to(q[1]) < SIGHT_MARGIN_M
		_fade(node as MeshInstance3D, SEE_ALPHA if hide else 1.0, delta)


## Eases a ring piece's own material toward `want` alpha (delta 0 = at once); solid pieces stay opaque.
static func _fade(m: MeshInstance3D, want: float, delta: float) -> void:
	var mat := m.material_override as StandardMaterial3D
	var c := mat.albedo_color
	c.a = want if delta <= 0.0 else move_toward(c.a, want, delta / FADE_S)
	mat.albedo_color = c
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA if c.a < 0.999 else BaseMaterial3D.TRANSPARENCY_DISABLED


## S307 the corner minute's film shots: a lens at `pos` on `look`, sharp only around `focus` metres (shallow depth of
## field: the near shoulder and the hall behind go soft). `focus` <= 0 = the broadcast lens.
func film(pos: Vector3, look: Vector3, lens_fov: float, focus: float) -> void:
	close = true
	fov = lens_fov
	_lens(focus > 0.0, focus)
	_place_lens(pos, look)


func _lens(shallow: bool, focus: float = 0.0) -> void:
	var lens := attributes as CameraAttributesPractical
	lens.dof_blur_near_enabled = shallow
	if shallow:
		# The sharp band grows with the distance, as a real lens's depth of field does.
		lens.dof_blur_near_distance = maxf(0.1, focus * 0.7)
		lens.dof_blur_near_transition = focus * 0.25
		lens.dof_blur_far_distance = focus * 1.35 + 0.2
		lens.dof_blur_far_transition = 1.2
		lens.dof_blur_amount = 0.2
	else:
		# S317: the hall behind the ring goes properly soft (was 0.14: the crowd read sharp and cheap).
		lens.dof_blur_far_transition = 2.0
		lens.dof_blur_amount = 0.22
