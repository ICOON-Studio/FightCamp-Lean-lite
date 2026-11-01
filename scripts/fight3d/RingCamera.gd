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
## S320: a piece this far toward the lens from the pair's middle starts to fade, and is see-through from the second (it
## was see-through at once past 1.2 m).
const NEAR_FADE := Vector2(0.9, 1.5)

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
## S347 (operator: "this transparent rope on all your stills start to become annoying, why you do not change angle?"):
## the lens stands INSIDE the ropes, IN_M in from them, so no rope is ever between it and the pair - the ropes are only
## behind them (the tape room's rule, TapeFilm). A shot whose spot is outside turns toward the open ring, smallest turn
## first (TURNS, deg); with no room at its distance anywhere it comes closer (down to MIN_DIST_M) and widens so the
## frame keeps HALF_H_M above and below the pair's middle (the side shot's own framing: 3.0 m at fov 36).
const RING_HALF_M := 2.75     # FightStage.RING_M * 0.5
const IN_M := 0.4
const MIN_DIST_M := 1.9
const HALF_H_M := 1.0
const TURNS := [0.0, 25.0, -25.0, 50.0, -50.0, 80.0, -80.0, 115.0, -115.0, 150.0, -150.0, 180.0]
## S317 motion blur (operator: "go ahead" on the download): sphynx-owner's Godot Motion Blur Addon v1.1.1 (MIT, per-object
## velocity blur as a compositor effect; needs his Easy Compositor Addon v1.0.4, MIT) - res://addons. The reference's fast
## punches smear; ours stepped frame to frame. Camera rotation counts little (an orbit should not smear the ring); a cut
## or a jump of the lens past JUMP_M gets no blur on that frame. `-- noblur` = the control arm; headless runs have none.
const MOTION_BLUR := "res://addons/godot-motion-blur/guertin/guertin_motion_blur.gd"
const BLUR := 1.0
const JUMP_M := 0.4
## S348 (S348 round-1 still: "Step back" walked her into the over-the-shoulder lens, her back hid the other woman's face):
## the shoulder lens stands further to the side, and a boxer this close to the lens (flat) cuts to the next shot.
const SHOULDER_SIDE_M := 1.25
const TOO_CLOSE_M := 1.3
## S348 (round-2 still: the referee stepping in to part a clinch filled a quarter of the frame; the shoulder lens in a clinch
## saw only her back): the referee closer than this cuts the shot, and no shoulder shot while their hips are this close.
const REF_CLOSE_M := 2.0
const CLINCH_GAP_M := 0.75
var avoid := Vector3.INF      # the referee (FightStage sets it every frame); INF = nobody to keep off

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
var _turn := 0.0              # S347: the turn (deg) the inside-the-ropes lens holds


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
	if not cut and _shot >= 0 and _shot_t > 0.6:   # a shot holds 0.6 s at least: never a cut every frame
		for p in [a, b]:
			if Vector2(p.x - position.x, p.z - position.z).length() < TOO_CLOSE_M:
				cut = true
		if avoid != Vector3.INF and Vector2(avoid.x - position.x, avoid.z - position.z).length() < REF_CLOSE_M:
			cut = true
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
	if cut and avoid != Vector3.INF and side.dot(Vector3(avoid.x - mid.x, 0.0, avoid.z - mid.z)) > 0.0:
		side = -side   # S348: a new shot opens on the side away from the referee (never a cut straight back into him)
	_side = side
	_lens(false)
	var want_pos: Vector3
	var want_look: Vector3
	fov = float(sh["fov"])
	var over_spot := Vector3.INF
	if str(sh["name"]) == "shoulder" and Vector2(a.x - b.x, a.z - b.z).length() >= CLINCH_GAP_M:
		# Behind one boxer's shoulder, a little to the camera's side, onto the other's face (not with her back to the
		# ropes: that spot is outside them - the side shot instead).
		var near: Vector3 = a if _over == 0 else b
		var far: Vector3 = b if _over == 0 else a
		var axis := (far - near).normalized()
		var at := near - axis * float(sh["dist"]) + side * SHOULDER_SIDE_M
		if inside(at):
			over_spot = at
			want_pos = at + Vector3(0, float(sh["h"]), 0)
			want_look = far + Vector3(0, float(sh["look_h"]), 0)
	if over_spot == Vector3.INF:
		var lens_sh: Dictionary = sh if str(sh["name"]) != "shoulder" else SHOTS[0]
		var yaw := deg_to_rad(float(lens_sh["yaw"]) + float(lens_sh["orbit"]) * _shot_t)
		var sp := spot_inside(mid, Basis(Vector3.UP, yaw) * side, float(lens_sh["dist"]), 0.0 if cut else _turn)
		_turn = float(sp[2])
		want_pos = (sp[0] as Vector3) + Vector3(0, float(lens_sh["h"]), 0)
		want_look = mid + Vector3(0, float(lens_sh["look_h"]), 0)
		fov = maxf(float(lens_sh["fov"]), rad_to_deg(2.0 * atan(HALF_H_M / maxf(float(sp[1]), 0.5))))
	(attributes as CameraAttributesPractical).dof_blur_far_distance = want_pos.distance_to(want_look) + 1.6
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
	var flat := Vector3(mid.x, 0.0, mid.z) - hitter * 0.15
	var sp := spot_inside(flat, side, 2.5)
	fov = maxf(32.0, rad_to_deg(2.0 * atan(0.7 / maxf(float(sp[1]), 0.5))))
	_place_lens((sp[0] as Vector3) + Vector3(0, mid.y + 0.08, 0), mid)


## S347: a lens spot (flat, y 0) inside the ropes.
static func inside(p: Vector3) -> bool:
	var half := RING_HALF_M - IN_M
	return absf(p.x) <= half and absf(p.z) <= half


## The lens spot for a shot at `dist` from `mid` along `dir` (flat): the smallest turn that stands it inside the ropes;
## else the turn with the most room, as far out as it fits; else (no room even at MIN_DIST_M) the line to the ring's
## middle. Returns [spot (flat), distance].
static func spot_inside(mid: Vector3, dir: Vector3, dist: float, keep_turn: float = 0.0) -> Array:
	var c := Vector3(mid.x, 0.0, mid.z)
	var best_room := -1.0
	var best_dir := dir
	# S347 (operator: the fight must look smooth): the turn the lens already holds is tried first, so near the ropes it never
	# flips between two turns that both fit.
	for t in [keep_turn] + TURNS:
		var d: Vector3 = Basis(Vector3.UP, deg_to_rad(float(t))) * dir
		if inside(c + d * dist):
			return [c + d * dist, dist, float(t)]
		var room := dist - 0.1
		while room > MIN_DIST_M and not inside(c + d * room):
			room -= 0.1
		if room > best_room and inside(c + d * room):
			best_room = room
			best_dir = d
	if best_room < 0.0:
		best_room = MIN_DIST_M
		best_dir = -c.normalized() if c.length() > 0.1 else dir
	return [c + best_dir * best_room, best_room, keep_turn]


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
	var hidden := {}
	var ropes := {}
	var near := {}
	for n in ring_side:
		var node := n as Node3D
		var at := node.global_position
		var d := Vector3(at.x - mid.x, 0, at.z - mid.z)
		var hide := false
		# S320: nearer the lens than the pair, a piece fades by how near (a ramp along the rope, not a cut into stubs).
		near[node] = smoothstep(NEAR_FADE.x, NEAR_FADE.y, d.dot(to_cam))
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
		hidden[node] = hide
		if hide and node.has_meta("rope"):
			ropes[node.get_meta("rope")] = true
	# S320 (the smooth ropes, 40 pieces a side): a rope fades WHOLE when any piece of it is in the way - faded piece by
	# piece it broke into floating stubs.
	for n in ring_side:
		var hide: bool = hidden[n] or ((n as Node).has_meta("rope") and ropes.has((n as Node).get_meta("rope")))
		_fade(n as MeshInstance3D, SEE_ALPHA if hide else lerpf(1.0, SEE_ALPHA, float(near[n])), delta)


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
