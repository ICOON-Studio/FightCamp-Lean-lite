extends Camera3D
## The ring's broadcast camera (split from FightStage S302): a TV lens at the apron that follows the pair, the close-up on
## a big shot, the ropes between it and the boxers hidden, and the nudge on a power shot.
##   broadcast(a, b, snap, delta)  close_up(a, b, head_y, hit)  shake(m)  nudge(delta)  clear_view(ring_side, mid)

## The nudge decays with this time constant (seconds).
const SHAKE_TAU_S := 0.09

var close := false            # the big-shot close-up holds until broadcast() runs again
var _side := Vector3.LEFT     # the side of the pair the camera is on (it never jumps across the ring)
var _clock := 0.0
var _shake := 0.0             # metres, decaying
var _shake_t := 0.0


func _init() -> void:
	# A broadcast lens: the ring sharp, the hall beyond it soft.
	var lens := CameraAttributesPractical.new()
	lens.dof_blur_far_enabled = true
	lens.dof_blur_far_transition = 2.5
	lens.dof_blur_amount = 0.14
	attributes = lens


## At the apron, side-on to the pair, both women head to feet filling about 60% of the frame; it follows the pair
## smoothly and drifts slowly along the ropes like a TV camera operator.
func broadcast(a: Vector3, b: Vector3, snap: bool = false, delta: float = 0.0) -> void:
	close = false
	_clock += delta
	var mid := (a + b) * 0.5
	var side := _side_of(a, b)
	_side = side
	side = Basis(Vector3.UP, deg_to_rad(18.0) * sin(_clock * 0.11)) * side
	_lens(false)
	var want_pos := mid + side * 3.6 + Vector3(0, 1.45, 0)
	var want_look := mid + Vector3(0, 0.98, 0)
	(attributes as CameraAttributesPractical).dof_blur_far_distance = 3.6 + 2.2
	fov = 34.0
	if snap:
		look_at_from_position(want_pos, want_look, Vector3.UP)
		return
	var k := clampf(delta * 2.2, 0.0, 1.0)
	look_at_from_position(position.lerp(want_pos, k), want_look, Vector3.UP)


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
	look_at_from_position(mid + side * 2.5 - hitter * 0.15 + Vector3(0, 0.08, 0), mid, Vector3.UP)


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
func clear_view(ring_side: Array, mid: Vector3) -> void:
	var to_cam := Vector3(position.x - mid.x, 0, position.z - mid.z).normalized()
	for n in ring_side:
		var d := Vector3((n as Node3D).position.x - mid.x, 0, (n as Node3D).position.z - mid.z)
		(n as Node3D).visible = d.dot(to_cam) < 1.2


## S307 the corner minute's film shots: a lens at `pos` on `look`, sharp only around `focus` metres (shallow depth of
## field: the near shoulder and the hall behind go soft). `focus` <= 0 = the broadcast lens.
func film(pos: Vector3, look: Vector3, lens_fov: float, focus: float) -> void:
	close = true
	fov = lens_fov
	_lens(focus > 0.0, focus)
	look_at_from_position(pos, look, Vector3.UP)


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
		lens.dof_blur_far_transition = 2.5
		lens.dof_blur_amount = 0.14
