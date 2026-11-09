extends SubViewportContainer
## S412 operator on the versus screen: "or have them shadow box towards the camera wooth some looping clips". One boxer, live,
## in the game's own body and corner kit, working through a window of an owned shadowboxing take, turned toward the lens and a
## little toward the other corner. A window is about twelve seconds; the seam is a blend, so the loop does not jump. Nothing here
## runs without a picture: make() returns null in a headless run and the page keeps its baked still.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const CornerWarm := preload("res://scripts/fight3d/CornerWarm.gd")

const TAKES := ["rk_shadowboxing_a", "rk_shadowboxing_b"]
const WINDOW_S := 12.0
const SEAM_S := 0.4
const TOWARD_CORNER_DEG := 20.0
const TURN_RATE := 1.5   # how fast the chest is eased back toward the lens: slow, so the boxer's own turns still read
const LENS_M := 4.5
const LENS_Y := 1.0
const AIM_Y := 0.92

var _body: Node3D
var _skel: Skeleton3D
var _ap: AnimationPlayer
var _cam: Camera3D
var _span := Vector2.ZERO
var _toward := 0.0
var _next := "loop_a"


static func make(stem: String, corner: String, right: bool, key: int) -> Control:
	if DisplayServer.get_name() == "headless":
		return null
	var glb := "res://assets/models/metahuman/%s.glb" % stem
	if not ResourceLoader.exists(glb):
		return null
	var c: Control = new()
	c.call("_build", glb, corner, right, key)
	return c


func _build(glb: String, corner: String, right: bool, key: int) -> void:
	name = "Live_" + corner
	stretch = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toward = deg_to_rad(TOWARD_CORNER_DEG) * (-1.0 if right else 1.0)
	var vp := SubViewport.new()
	vp.transparent_bg = true
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_4X
	vp.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
	add_child(vp)
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_CLEAR_COLOR
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.85, 0.85, 0.85)
	e.ambient_light_energy = 0.55
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	vp.add_child(env)
	for l in [[Vector3(-55, 35, 0), 1.25, Color(1.0, 0.97, 0.93)], [Vector3(-25, -50, 0), 0.5, Color(0.92, 0.95, 1.0)], [Vector3(-10, 170, 0), 0.7, Color(1.0, 0.95, 0.88)]]:
		var light := DirectionalLight3D.new()
		light.rotation_degrees = l[0]
		light.light_energy = l[1]
		light.light_color = l[2]
		vp.add_child(light)
	_cam = Camera3D.new()
	_cam.fov = 26.0
	vp.add_child(_cam)
	_cam.look_at_from_position(Vector3(0.0, LENS_Y, LENS_M), Vector3(0.0, AIM_Y, 0.0), Vector3.UP)
	_cam.make_current()
	_body = MH.load_fighter(glb)
	if _body == null:
		return
	Kit.colour_vest(_body, Stage.VESTS[corner], Stage.CLOTH_ROUGHNESS)
	Kit.cloth_normals(_body)
	Kit.dress(_body, glb, "boxing")
	var gloves := Gloves.new()
	gloves.name = "Gloves"
	_body.add_child(gloves)
	gloves.mount(_body, Stage.CORNERS[corner][0], Stage.CORNERS[corner][1])
	vp.add_child(_body)
	_skel = _body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	_ap = _body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	_load_take(str(TAKES[absi(key) % TAKES.size()]), key)
	_body.rotation.y = 0.0


## The take goes in twice under two names: playing the other name is what lets the seam blend.
func _load_take(take: String, key: int) -> void:
	var lib: AnimationLibrary = _ap.get_animation_library("")
	var prefix := str(_ap.get_node(_ap.root_node).get_path_to(_skel))
	if not FightClips._add_baked(lib, _skel, prefix, take, FightClips.OWNED_DIR + take + ".res"):
		push_error("VersusLive: no take " + take)
		return
	var anim: Animation = lib.get_animation(take)
	lib.add_animation("loop_a", anim)
	lib.add_animation("loop_b", anim)
	_span = CornerWarm.window(anim.length, key, WINDOW_S)
	_ap.play("loop_a")
	_ap.seek(_span.x, true)


func _process(delta: float) -> void:
	if _ap == null or _span == Vector2.ZERO:
		return
	if _ap.current_animation_position >= _span.y - SEAM_S:
		var to := "loop_b" if _ap.current_animation == "loop_a" else "loop_a"
		_ap.play(to, SEAM_S)
		_ap.seek(_span.x, true)
	var l := (_skel.global_transform * _skel.get_bone_global_pose(_skel.find_bone("LeftUpperArm"))).origin
	var r := (_skel.global_transform * _skel.get_bone_global_pose(_skel.find_bone("RightUpperArm"))).origin
	var chest := ((l - r) * Vector3(1, 0, 1)).normalized().cross(Vector3.UP)
	var want := Vector3(sin(_toward), 0.0, cos(_toward))
	_body.rotate_y(chest.signed_angle_to(want, Vector3.UP) * clampf(delta * TURN_RATE, 0.0, 1.0))
	var h := _skel.global_transform * _skel.get_bone_global_pose(_skel.find_bone("Hips"))
	_body.position += Vector3(-h.origin.x, 0.0, -h.origin.z) * clampf(delta * 6.0, 0.0, 1.0)
