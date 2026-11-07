extends Node3D
## FIGHTERLOOK1 round 1 (both blind critics: "the corner is badly under-lit, the most emotional moment is the hardest to read";
## "the second's face lost in shadow"): the broadcast trick - a soft fill that rides behind whichever lens is live, so every
## face the camera looks at is lit from its side. No shadows and NO specular (it lifts the faces without bringing the glare
## back); a metre behind the lens so a near shoulder is not blown out. Realistic look only (`art=toon` has its own even
## light), off under `-- nolook` (the control arm).
##   attach(stage) -> FaceFill | null

const ENERGY := 0.95   # round 2: 0.55 still left Lucy's corner close-ups "a dim brown mask"
const RANGE_M := 6.0
const BACK_M := 1.0
const UP_M := 0.25

var _light: OmniLight3D
var _key: SpotLight3D
var _rim: SpotLight3D
## Designer pass (round 2): a key and a rim on the face the lens is on - warm key 45 deg above and to the lens' right, cool rim
## behind the far shoulder. Short range: in a wide shot the subject point is empty air and the ring rig carries the light.
const SUBJECT_M := 1.4
const KEY_ENERGY := 1.6
const RIM_ENERGY := 2.2


static func attach(stage: Node) -> Node:
	var args := OS.get_cmdline_user_args()
	if stage == null or args.has("nolook") or (load("res://scripts/fight3d/ArtStyle.gd") as GDScript).mode() == "toon":
		return null
	var f: Node3D = (load("res://scripts/fight3d/FaceFill.gd") as GDScript).new()
	f.name = "FaceFill"
	stage.add_child(f)
	return f


func _ready() -> void:
	_light = OmniLight3D.new()
	_light.light_energy = ENERGY
	_light.omni_range = RANGE_M
	_light.omni_attenuation = 1.2
	_light.light_specular = 0.0
	_light.shadow_enabled = false
	_light.light_color = Color(1.0, 0.96, 0.9)
	add_child(_light)
	_key = _spot(Color(1.0, 0.9, 0.78), KEY_ENERGY, 0.35)
	_rim = _spot(Color(0.75, 0.85, 1.0), RIM_ENERGY, 0.6)


func _spot(c: Color, e: float, spec: float) -> SpotLight3D:
	var s := SpotLight3D.new()
	s.light_color = c
	s.light_energy = e
	s.light_specular = spec
	s.spot_range = 2.6
	s.spot_angle = 28.0
	s.spot_attenuation = 1.0
	s.shadow_enabled = false
	add_child(s)
	return s


func _process(_dt: float) -> void:
	var cam := get_viewport().get_camera_3d() if get_viewport() != null else null
	if cam == null:
		return
	var back: Vector3 = cam.global_transform.basis.z.normalized()   # a camera looks down its -Z
	_light.global_position = cam.global_position + back * BACK_M + Vector3.UP * UP_M
	var right: Vector3 = cam.global_transform.basis.x.normalized()
	var subject: Vector3 = cam.global_position - back * SUBJECT_M
	var key_at: Vector3 = subject + (back * 0.8 + right * 0.8).normalized() * 1.2 + Vector3.UP * 0.9
	var rim_at: Vector3 = subject - back * 1.1 - right * 0.5 + Vector3.UP * 0.7
	if key_at.distance_to(subject) > 0.1:
		_key.look_at_from_position(key_at, subject, Vector3.UP)
	if rim_at.distance_to(subject) > 0.1:
		_rim.look_at_from_position(rim_at, subject, Vector3.UP)
