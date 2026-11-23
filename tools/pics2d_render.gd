extends SceneTree
## PICS2D1 (S539, owner "yes, run the 2D picture test"; ops/research/FIGHTBIZ1_COMPARE.md s2 + s4 item 1): one paired picture
## per exchange outcome, from our own 3D. Both boxers (the game's MetaHuman bodies), the v2 player as it ships (no pose fixes
## here), a FIXED SIDE camera (orthographic, red on the left), each punch frozen at its contact frame, a flat toon look
## (ArtStyle, `art=toon` is forced) on a transparent background, SIZE px square. Ring, ropes and crowd are hidden.
## 14 pictures: guard, guard_inside, then red/blue x jab/cross/lead_hook x landed/missed. A missed punch = the target
## is out of reach by MISS_M at the contact frame; a landed one has the glove LAND_M from the face (the placer's range is
## overridden for the picture only: the v2 takes as played often stop at the guard). Every picture is framed head to feet or refused.
##   python tools/hidden_desktop.py run --timeout=300 --log=<file> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_render.gd -- <out_dir> art=toon [red=02 blue=01]
## Prints PICS2D_RENDER wrote=<n> refused=<n>.

const SIZE := 1024
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const PUNCHES := ["jab", "cross", "lead_hook"]
const LAND_M := 0.10      # glove centre to the face at contact, along the ring line (a glove is ~0.25 m long)
const MISS_M := 0.46      # glove centre to the face on a miss, along the ring line: clearly short
const MIN_APART_M := 0.42  # the two bodies' roots never closer than this (no body through body)
const ORTHO_M := 2.55        # the picture is this many metres tall (and wide)
const LOOK_Y := 1.02

var out_dir := "user://pics2d"
var sv: SubViewport
var stage: Node3D
var cam: Camera3D
var drawn: Array = [{}, {}]
var home_t: Array = []
var contacts := {}   # picture name -> the striking glove and the face on the picture, in pixels (pics2d_round's ring/streak)
var wrote := 0
var refused := 0


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	if not args.has("art=toon"):
		print("PICS2D_RENDER note: pass art=toon for the flat look (ArtStyle reads the command line)")
	Player2.force = true
	FightClips.untouched = true
	sv = SubViewport.new()
	sv.size = Vector2i(SIZE, SIZE)
	sv.transparent_bg = true
	sv.msaa_3d = Viewport.MSAA_4X
	sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(sv)
	stage = Stage.new()
	sv.add_child(stage)
	await process_frame
	# The bodies: `red=NN blue=NN` (mh_boxer_NN), or the round's own from pics2d_round.gd's round.json: `round=<json>`.
	var spec: Array = []
	for i in 2:
		var c := "red" if i == 0 else "blue"
		spec.append({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg(c, "02" if i == 0 else "01"), "corner": c, "stance": "orthodox"})
	if _arg("round", "") != "":
		var rj: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(_arg("round", "")))
		for i in 2:
			spec[i]["glb"] = str(rj["bodies"][i])
			spec[i]["scale"] = float(rj["scales"][i])
			spec[i]["stance"] = str(rj["stances"][i])
	print("PICS2D_RENDER bodies %s" % [spec])
	stage.setup(spec[0], spec[1])
	if stage.v2 == null:
		print("PICS2D_RENDER FAIL the v2 player was not built")
		quit(1)
		return
	for i in 2:
		var sk: Skeleton3D = stage.boxers[i]["skel"]
		var d: Dictionary = drawn[i]
		sk.skeleton_updated.connect(func() -> void:
			for b in sk.get_bone_count():
				d[b] = sk.get_bone_global_pose(b))
	cam = Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = ORTHO_M
	cam.near = 0.05
	cam.far = 40.0
	stage.add_child(cam)
	for f in 90:
		await process_frame
	_clean_set()
	home_t = [_node(0).global_transform, _node(1).global_transform]
	_freeze(0)
	_freeze(1)
	await _shot("guard")
	var home: Array = [_node(0).position, _node(1).position]
	var mid: Vector3 = (home[0] + home[1]) * 0.5
	stage.process_mode = Node.PROCESS_MODE_DISABLED   # the pair placer would put them back at range
	for f in 2:
		await process_frame
	_node(0).position = home[0].lerp(mid, 0.30)
	_node(1).position = home[1].lerp(mid, 0.30)
	await _shot("guard_inside")
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	_unfreeze()
	_node(0).position = home[0]
	_node(1).position = home[1]
	for who in 2:
		for fam in PUNCHES:
			for landed in [true, false]:
				await _punch(who, fam, landed, home)
	var fh := FileAccess.open(out_dir.path_join("contacts.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(contacts, "  "))
	fh.close()
	print("PICS2D_RENDER wrote=%d refused=%d" % [wrote, refused])
	quit(0 if refused == 0 else 1)


func _punch(who: int, fam: String, landed: bool, home: Array) -> void:
	var corner := "red" if who == 0 else "blue"
	var name := "%s_%s_%s" % [corner, fam, "landed" if landed else "missed"]
	var clip := _punch_clip(who, fam)
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	if clip == "":
		print("PICS2D_RENDER no %s take on %s" % [fam, corner])
		refused += 1
		return
	_unfreeze()
	stage.v2.guard(0)
	stage.v2.guard(1)
	_node(0).position = home[0]
	_node(1).position = home[1]
	for f in 50:
		await process_frame
	stage.v2._play(who, clip, 0.0, "punch", true)
	var cs := float(stage.v2.db["rows"][clip].get("contact_s", 0.3))
	for f in 240:
		await process_frame
		if str(ap.current_animation) != clip or ap.current_animation_position >= cs - 0.008:
			break
	_freeze(who)
	_freeze(1 - who)
	for f in 14:
		await process_frame
	# The pair placer turns and re-seats the bodies every frame (the travel of a take ends in odd spots): pause the stage
	# (the frozen pose stays drawn), put both back on their guard spots and facings, then fit the range along the ring line.
	var was := _reach(who)
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	_node(0).global_transform = home_t[0]
	_node(1).global_transform = home_t[1]
	var axis: Vector3 = ((home_t[1 - who].origin - home_t[who].origin) * Vector3(1, 0, 1)).normalized()
	for f in 2:
		await process_frame
	var along := _glove_to_face(who).dot(axis)
	if landed:   # the attacker steps in (or back) until the glove reaches the face, never into the other's body
		var step := along - LAND_M
		var room := (_node(1 - who).global_position - _node(who).global_position).dot(axis) - MIN_APART_M
		_node(who).global_position += axis * minf(step, room)
	elif along < MISS_M:   # the target is out of reach by the glove's width and more
		_node(1 - who).global_position += axis * (MISS_M - along)
	for f in 2:
		await process_frame
	print("PICS2D_RENDER %s = %s at %.2f s, glove-to-face %.2f m, along the line %.2f (as played %.2f)" % [name, clip, cs, _reach(who), _glove_to_face(who).dot(axis), was])
	_aim()
	var gl := _world(1 - who, "Head", 0.06) - _glove_to_face(who)
	contacts[name] = {"glove": [cam.unproject_position(gl).x, cam.unproject_position(gl).y],
		"face": [cam.unproject_position(_world(1 - who, "Head", 0.06)).x, cam.unproject_position(_world(1 - who, "Head", 0.06)).y]}
	await _shot(name)
	stage.process_mode = Node.PROCESS_MODE_INHERIT


## The striking glove's distance to the other's head, as drawn (landed ~0.1, missed clearly more).
func _reach(who: int) -> float:
	var h := _world(1 - who, "Head", 0.06)
	return minf(h.distance_to(_world(who, "LeftHand")), h.distance_to(_world(who, "RightHand")))


## From the striking glove (the one nearer the face) to the other's face.
func _glove_to_face(who: int) -> Vector3:
	var h := _world(1 - who, "Head", 0.06)
	var l := _world(who, "LeftHand")
	var r := _world(who, "RightHand")
	return h - (l if h.distance_to(l) < h.distance_to(r) else r)


func _node(i: int) -> Node3D:
	return stage.boxers[i]["node"] as Node3D


func _freeze(i: int) -> void:
	(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 0.0


func _unfreeze() -> void:
	for i in 2:
		(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 1.0


## Only the two boxers and their kit: every other visual (ring, ropes, crowd, referee, corner team) hidden, the sky off.
func _clean_set() -> void:
	var keep: Array = []
	for i in 2:
		keep.append(_node(i))
	for n in stage.find_children("*", "VisualInstance3D", true, false):
		var mine := false
		for k in keep:
			if (k as Node).is_ancestor_of(n) or n == k:
				mine = true
		if not mine and not (n is Light3D):
			(n as VisualInstance3D).visible = false
	for n in stage.find_children("*", "WorldEnvironment", true, false):
		var e: Environment = (n as WorldEnvironment).environment
		if e != null:
			e.background_mode = Environment.BG_CLEAR_COLOR
			e.glow_enabled = false
			e.fog_enabled = false
			e.volumetric_fog_enabled = false


func _punch_clip(i: int, family: String) -> String:
	var ap: AnimationPlayer = stage.boxers[i]["ap"]
	var rows: Dictionary = stage.v2.db.get("rows", {})
	for n in rows:
		var r: Dictionary = rows[n]
		if str(r.get("kind", "")) == "punch" and str(r.get("family", "")) == family and ap.has_animation(str(n)) and (r.get("drop", []) as Array).is_empty() and bool(r.get("played", false)):
			return str(n)
	return ""


func _world(i: int, bone: String, up: float = 0.0) -> Vector3:
	var sk: Skeleton3D = stage.boxers[i]["skel"]
	var b := sk.find_bone(bone)
	var g: Transform3D = drawn[i].get(b, sk.get_bone_global_rest(b)) if b >= 0 else Transform3D.IDENTITY
	return sk.global_transform * g.origin + Vector3.UP * up


## The fixed side camera: from -X (red left, blue right), level, centred on the pair.
func _aim() -> void:
	var mid := (_node(0).global_position + _node(1).global_position) * 0.5
	cam.global_position = Vector3(mid.x - 8.0, LOOK_Y, mid.z)
	cam.look_at(Vector3(mid.x, LOOK_Y, mid.z), Vector3.UP)
	cam.make_current()


func _framed() -> Array:
	var bad: Array = []
	for i in 2:
		for p in [["Head", 0.14], ["LeftToes", -0.06], ["RightToes", -0.06], ["LeftHand", 0.0], ["RightHand", 0.0]]:
			var w := _world(i, str(p[0]), float(p[1]))
			var s := cam.unproject_position(w)
			if s.x < 6.0 or s.x > SIZE - 6.0 or s.y < 6.0 or s.y > SIZE - 6.0:
				bad.append("%s %s at %s" % ["red" if i == 0 else "blue", str(p[0]), str(s.round())])
	return bad


func _shot(name: String) -> void:
	_aim()
	for f in 6:
		await process_frame
	var bad := _framed()
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s: %s" % [name, "; ".join(PackedStringArray(bad))])
		refused += 1
		return
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	sv.get_texture().get_image().save_png(path)
	wrote += 1
	print("STILL_FRAMING ok %s -> %s" % [name, path])
