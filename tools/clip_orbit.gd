extends SceneTree
const Drift := preload("res://tools/orbit_drift.gd")   # S379 operator: "the camera spins too fast ... got me dizzy"
## S365 the board's Boxer animations page (operator: "can you update the boxer animations, to see what we have ingame"): each
## clip the fight can pick (Game/Tools/lean_anim_catalogue.py --ids) on the game's own boxer - the fight's body, gloves and
## kit, the clip as FightClips loads it - alone on a grey grid floor (the grid shows foot slide), a camera circling once
## (operator S270: "a drone camera rotates around them", "i dont need the ring"). Frames -> <out>/<id>/f0000.jpg; the
## board's renderer (Game/Tools/lean_anim_render.py) encodes each to an mp4. What the fight adds on top (the joins, the arm
## bent to the target, glove push, head snap) is NOT in these: this is the clip itself, with KneeTrack.align(skel, 1.0) on
## every frame after the clip so the board's previews show the knees as the fight plays them (S370 TASK_KNEETRACK1).
##   python tools/hidden_desktop.py run --timeout=3600 <godot.exe> --path . --windowed --resolution 960x540 \
##       --script res://tools/clip_orbit.gd -- out=<dir> ids=<a,b,...> [glb=mh_boxer_10]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const KneeTrack := preload("res://scripts/fight3d/KneeTrack.gd")
const FPS := 30
const MIN_S := 4.0
const TAIL_S := 0.4
const RADIUS := 2.7
const HEIGHT := 1.35
const GRID_SHADER := """
shader_type spatial;
uniform vec3 base : source_color = vec3(0.46, 0.47, 0.49);
uniform vec3 line : source_color = vec3(0.30, 0.31, 0.33);
uniform vec3 major : source_color = vec3(0.20, 0.21, 0.23);
varying vec3 wp;
void vertex() { wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
float grid(vec2 p, float step, float w) {
	vec2 g = abs(fract(p / step - 0.5) - 0.5) / fwidth(p / step);
	return 1.0 - clamp(min(g.x, g.y) - w, 0.0, 1.0);
}
void fragment() {
	vec3 c = mix(base, line, grid(wp.xz, 0.25, 0.0));
	c = mix(c, major, grid(wp.xz, 1.0, 0.5));
	ALBEDO = c;
	ROUGHNESS = 0.95;
}
"""

var out_dir := "user://clip_orbit"


func _initialize() -> void:
	var ids: Array = []
	var who := "mh_boxer_10"
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("out="):
			out_dir = s.substr(4)
		elif s.begins_with("ids="):
			ids = Array(s.substr(4).split(",", false))
		elif s.begins_with("glb="):
			who = s.substr(4)
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % who, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	for n in stage.get_children():
		if n is Node3D and n != stage.boxers[0]["node"] and n != stage.camera:
			(n as Node3D).visible = false
	_studio(stage)
	var bx: Dictionary = stage.boxers[0]
	var body: Node3D = bx["node"]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var hips := skel.find_bone("Hips")
	var cam: Camera3D = stage.camera
	cam.set_process(false)
	cam.fov = 45.0
	var done := 0
	for id in ids:
		var name := str(id)
		if not ap.has_animation(name):
			print("ORBIT MISSING ", name)
			continue
		var dir := out_dir.path_join(name)
		DirAccess.make_dir_recursive_absolute(dir)
		var length: float = ap.get_animation(name).length
		var cycle := length + TAIL_S
		var total := maxf(MIN_S, cycle)
		var frames := int(ceil(total * FPS))
		var face: float = body.global_rotation.y
		for f in frames:
			var t := float(f) / FPS
			var in_cycle := fmod(t, cycle)
			Stage.IdleMatch.freeze(bx, name, minf(in_cycle, length))
			KneeTrack.align(skel, 1.0)
			var c: Vector3 = (skel.global_transform * skel.get_bone_global_pose(hips)).origin
			c.y = 1.0
			var ang := face + PI * 0.5 + Drift.angle(f, frames, 30.0)
			cam.look_at_from_position(Vector3(c.x + sin(ang) * RADIUS, HEIGHT, c.z + cos(ang) * RADIUS), c, Vector3.UP)
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_jpg(dir.path_join("f%04d.jpg" % f), 0.88)
		done += 1
		print("ORBIT %s %.2fs %d frames" % [name, length, frames])
	print("ORBIT DONE %d/%d" % [done, ids.size()])
	quit(0)


## A studio: grey grid floor, plain backdrop, three-point light.
func _studio(stage: Node3D) -> void:
	var floor := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(40, 40)
	floor.mesh = plane
	var mat := ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = GRID_SHADER
	mat.shader = sh
	floor.material_override = mat
	floor.position.y = 0.002
	root.add_child(floor)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.62, 0.64, 0.67)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.56, 0.6)
	env.environment.ambient_light_energy = 0.6
	root.add_child(env)
	for l in [[Vector3(-50, 35, 0), 1.3], [Vector3(-25, -140, 0), 0.55], [Vector3(-15, 160, 0), 0.7]]:
		var d := DirectionalLight3D.new()
		d.rotation_degrees = l[0]
		d.light_energy = l[1]
		d.shadow_enabled = l[1] > 1.0
		root.add_child(d)
