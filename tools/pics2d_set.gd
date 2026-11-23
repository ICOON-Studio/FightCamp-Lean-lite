extends SceneTree
## PICS2D2 (S540, owner Q-S294-310 "Keep, build the full set"; task ops/research/TASK_PICS2D2.md, PICS2D1 docs/PICS2D1_RESULT.md):
## the full boxing picture set for the 2D view (scripts/ui/FightPictures.gd). Our own 3D: the game's MetaHuman bodies on
## the v2 player as it ships, the toon look (art=toon), a fixed side camera (orthographic, red on the left), transparent.
## Per corner: jab, cross, lead hook, rear hook, body hook, body cross, lead and rear uppercut x landed / blocked / missed,
## then guard, clinch, a knockdown in three frames each way and each corner on its stool. Both corners rendered, no mirror.
## What changed from PICS2D1 (its 0.18-0.32 m "glove beside the head"): the ring placer (Player2.tick, run by the stage's
## own _process) is switched off and the PAIR is placed here - the take's own reach sets the range - and a landed punch
## goes through the game's own finish (Player2._arm -> PunchAim, the ribs for a body shot), a blocked one through
## BlockCatch (the catching glove) with the glove carried onto that glove, a missed one meets a pull or a duck (BeatClips'
## own defence takes) so the miss reads from the side. Nothing in scripts/fight3d is changed (FIGHTPLAYER2 method line).
##   python tools/hidden_desktop.py run --timeout=900 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_set.gd -- <out_dir> art=toon set=w|m [only=<prefix> | only=*<part of the name>]
## Prints PICS2D_SET wrote=<n> refused=<n> and writes <out_dir>/contacts.json (glove + target in pixels, hit_m per picture).

const SIZE := 768
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const BlockCatch := preload("res://scripts/fight3d/BlockCatch.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
## family -> [takes in order of preference, body target]
const FAMILIES := {
	"jab": [["pro_left_jab", "pro_left_jab_a", "pro_left_jab_ft"], false],
	"cross": [["pro_right_cross", "pro_right_cross_ft", "pro_right_cross_a"], false],
	"lead_hook": [["pro_left_hook_ft", "pro_left_hook_v2", "pro_left_hook_hard_ft"], false],
	"rear_hook": [["pro_right_hook_ft", "pro_right_hook", "pro_right_hook_hard"], false],
	"body_hook": [["pro_body_shot", "pro_kidney_shot"], true],
	"body_cross": [["pro_body_cross", "pro_right_cross_c", "pro_right_cross"], true],   # S542 BODYCROSS1: the authored take (tools/pics2d_bodycross_bake.gd); _c was 0.17-0.29 m high
	"lead_uppercut": [["pro_left_uppercut", "pro_left_uppercut_hard"], false],
	"rear_uppercut": [["pro_right_uppercut", "pro_right_uppercut_hurt"], false],
}
const RESULTS := ["landed", "blocked", "missed"]
const SETS := {"w": ["11", "14"], "m": ["02", "01"]}   # Lucy Jackson v Priya Nair; Isaiah v Victor (Faces.CAST / MEN_CM)
const MIN_APART_M := 0.40   # roots never closer (no body through body)
const MISS_PX_M := 0.20     # a miss: the glove at least this far from the head ON THE PICTURE
const ORTHO_M := 2.55
const LOOK_Y := 1.02
const KO_CLIP := "pro_knockout_v1"
## A landed punch: the target's own hit reaction, held this far in (the head on its way, the guard parted).
const REACT := {"jab": "pro_hit_by_jab_v3", "cross": "pro_hit_by_cross_v1_short", "lead_hook": "pro_hit_by_hook_v1_short",
	"rear_hook": "pro_hit_by_hook_v2_short", "body_hook": "pro_hit_by_gutshot_v2_short", "body_cross": "pro_hit_by_gutshot_v2_short",
	"lead_uppercut": "pro_hit_by_hook_v5", "rear_uppercut": "pro_hit_by_cross_v1_short"}
const REACT_AT_S := 0.05
const MISS_HAND_M := 0.14   # a miss: also this clear of her gloves on the picture (else it reads as a block)
const KO_AT := [0.16, 0.42, 0.97]

var out_dir := "user://pics2d_set"
var only := ""
var yaw_deg := 0.0   # the side camera turned this far about the pair (yaw=<deg>)
var sv: SubViewport
var stage: Node3D
var crew: Node3D
var cam: Camera3D
var home_t: Array = []
var axis := Vector3.ZERO     # red -> blue along the ring line
var contacts := {}
var wrote := 0
var refused := 0


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	if not await _setup():
		return
	await _run()


## The stage, the pair, the side camera; the ring placer off. False when the v2 player was not built.
func _setup() -> bool:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	only = _arg("only", "")
	yaw_deg = float(_arg("yaw", "0"))
	DirAccess.make_dir_recursive_absolute(out_dir)
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
	var pair: Array = SETS[_arg("set", "w")]
	var spec: Array = []
	for i in 2:
		spec.append({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[i], "corner": ["red", "blue"][i], "stance": "orthodox"})
	print("PICS2D_SET set=%s bodies %s" % [_arg("set", "w"), pair])
	stage.setup(spec[0], spec[1])
	if stage.v2 == null:
		print("PICS2D_SET FAIL the v2 player was not built")
		quit(1)
		return false
	crew = FightCast.crew(stage, false)
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
	axis = ((home_t[1].origin - home_t[0].origin) * Vector3(1, 0, 1)).normalized()
	stage.set_process(false)   # the ring placer off: the pair is placed here; clips, IK and the finish still run
	return true


func _run() -> void:
	if _want("guard"):
		await _home_guard()
		await _shot("guard")
	for who in 2:
		for fam in FAMILIES:
			for res in RESULTS:
				var name := "%s_%s_%s" % [["red", "blue"][who], fam, res]
				if _want(name):
					await _punch(who, str(fam), str(res), name)
	if _want("clinch"):
		await _clinch()
	for who in 2:
		if _want("%s_knockdown" % ["red", "blue"][who]):
			await _knockdown(who)
	for who in 2:
		if _want("%s_corner" % ["red", "blue"][who]):
			await _corner(who)
	var fh := FileAccess.open(out_dir.path_join("contacts.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(contacts, "  "))
	fh.close()
	print("PICS2D_SET wrote=%d refused=%d" % [wrote, refused])
	quit(0 if refused == 0 else 1)


func _want(name: String) -> bool:
	return only == "" or name.begins_with(only) or (only.begins_with("*") and name.contains(only.substr(1)))


func _take(who: int, fam: String) -> String:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	if _arg("take", "") != "" and ap.has_animation(_arg("take", "")):   # a probe: this take for every punch rendered
		return _arg("take", "")
	for c in FAMILIES[fam][0]:
		if ap.has_animation(str(c)):
			return str(c)
	return ""


## Both back on their guard spots, the guard loop playing, nothing armed.
func _home_guard(step_m: float = 0.0, who: int = 0) -> void:
	_unfreeze()
	for i in 2:
		_node(i).global_transform = home_t[i]
		var aim: Node = stage.v2._aim[i]
		if aim != null:
			aim.disarm()
		stage.v2.guard(i)
	_node(who).global_position += axis * (1.0 if who == 0 else -1.0) * step_m
	for f in 40:
		await process_frame


func _punch(who: int, fam: String, res: String, name: String) -> void:
	var clip := _take(who, fam)
	if clip == "":
		print("PICS2D_SET no %s take on %s" % [fam, name])
		refused += 1
		return
	var body: bool = FAMILIES[fam][1]
	var row: Dictionary = stage.v2.db["rows"][clip]
	var cs := float(row.get("contact_s", 0.3))
	var hand: String = stage.hand_of(who, str(row.get("hand", "LeftHand")))
	var dirv := axis * (1.0 if who == 0 else -1.0)   # from the puncher toward the target
	# Pass 1: the take alone from the guard spots - how far short of the target its glove stops along the line.
	await _home_guard()
	stage.v2._play(who, clip, 0.0, "punch", false)
	await _to_contact(who, clip, cs)
	var short: float = (stage.v2.target(1 - who, body) - stage.glove_front(who, hand)).dot(dirv)
	var room: float = (_node(1 - who).global_position - _node(who).global_position).dot(dirv) - MIN_APART_M
	var step := minf(short, room)
	# Pass 2: from that range, the game's own finish for the result. A landed glove the arm cannot reach (PunchAim
	# closes at most 0.30 m: a cross to the ribs) moves the PAIR, up to 3 tries: the puncher by the leftover gap on the
	# floor, and in closer by 0.6 of a high glove's drop so the arm angles down - never nearer than MIN_APART_M.
	var extra := Vector3.ZERO
	var tgt := Vector3.ZERO
	var gl := Vector3.ZERO
	for attempt in 3:
		await _home_guard(step, who)
		_node(who).global_position += extra
		if res == "landed":   # the head snaps first and is held; the armed glove (PunchAim follows the target) finishes on it
			await _react(1 - who, fam)
			_freeze(1 - who)
			stage.v2._arm(who, clip, body)
		elif res == "blocked":
			_arm_block(who, clip, fam, cs, hand, body)
		stage.v2._play(who, clip, 0.0, "punch", false)
		await _to_contact(who, clip, cs)
		_freeze(1 - who)
		if res == "missed":
			await _dodge(who, fam, hand, body)
		for f in 8:
			await process_frame
		tgt = stage.v2.target(1 - who, body)
		gl = stage.glove_front(who, hand)
		var r := tgt - gl
		if res != "landed" or r.length() <= 0.04:
			break
		extra += Vector3(r.x, 0.0, r.z) + dirv * maxf(0.0, -r.y) * 0.6
		extra -= dirv * maxf(0.0, (step + extra.dot(dirv)) - room)
	var hit_px := _px(gl).distance_to(_px(tgt))
	print("PICS2D_SET %s = %s step %.2f m (+%.2f), glove to target %.3f m (%.0f px)" % [name, clip, step, extra.length(), gl.distance_to(tgt), hit_px])
	await _shot(name, {"glove": _xy(gl), "target": _xy(tgt), "hit_m": snappedf(gl.distance_to(tgt), 0.001), "clip": clip, "result": res})


## Plays until the take reaches its contact frame, then freezes the puncher there.
func _to_contact(who: int, clip: String, cs: float) -> void:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	for f in 240:
		await process_frame
		if str(ap.current_animation) != clip or ap.current_animation_position >= cs - 0.008:
			break
	_freeze(who)


## A blocked punch: her BlockCatch turns the catching arm onto the punch's line, and the glove finishes ON that glove
## (FightStage.arm_block's rule, through PunchAim). A body shot is caught on the elbow.
func _arm_block(who: int, clip: String, fam: String, cs: float, hand: String, body: bool) -> void:
	var blocker := 1 - who
	var side := "Right" if hand == "LeftHand" else "Left"
	var tgt: Callable
	if body:
		var sk: Skeleton3D = stage.boxers[blocker]["skel"]
		var eb := sk.find_bone(side + "LowerArm")
		tgt = func() -> Vector3:
			var e: Vector3 = sk.global_transform * sk.get_bone_global_pose(eb).origin
			var pg: Vector3 = stage.glove_front(who, hand)
			return e + (pg - e).normalized() * 0.07
	else:
		var bc: Node = BlockCatch.block(stage, who, clip, fam, cs, 1.0, cs)
		tgt = func() -> Vector3:
			var gloves: Dictionary = (stage.boxers[blocker]["gloves"] as Node).gloves
			var ch := str(bc.call("catch_hand"))
			var g: Vector3 = ((gloves["l"] if ch.begins_with("Left") else gloves["r"]) as Node3D).global_position
			var pg: Vector3 = stage.glove_front(who, hand)
			return g + (pg - g).normalized() * 0.09
	var node: Node3D = _node(who)
	var front: Vector3 = stage.v2._fronts[who][clip]
	(stage.v2._aim[who] as Node).arm(clip, hand, cs, func() -> Vector3: return tgt.call() - node.global_transform * front,
		(stage.v2._rels[who] as Dictionary).get(clip, Vector3.ZERO), tgt)


## A missed punch: the target pulls back from a straight or an uppercut and ducks a hook (a slip goes sideways, which
## the side camera cannot see), held at the take's furthest; then, if the glove still reads on the head, she is out of range.
func _dodge(who: int, fam: String, hand: String, body: bool) -> void:
	var d := 1 - who
	var kind := "weave" if fam in ["lead_hook", "rear_hook"] else "pull"
	var has := func(c: String) -> bool: return (stage.boxers[d]["ap"] as AnimationPlayer).has_animation(c)
	var clip := BeatClips.defence(kind, fam, hand == "LeftHand", false, has)
	if clip != "":
		var ap: AnimationPlayer = stage.boxers[d]["ap"]
		stage.v2._play(d, clip, 0.0, "defence", false)
		var row: Dictionary = stage.v2.db["rows"].get(clip, {})
		var peak := float(row.get("head_peak_s", ap.get_animation(clip).length * 0.42))
		for f in 240:
			await process_frame
			if str(ap.current_animation) != clip or ap.current_animation_position >= peak:
				break
		_freeze(d)
		for f in 4:
			await process_frame
	var ppm := SIZE / ORTHO_M
	for tries in 12:   # clear of the head by MISS_PX_M and of both her gloves by MISS_HAND_M, on the picture
		var g := _px(stage.glove_front(who, hand))
		var short_px := MISS_PX_M * ppm - g.distance_to(_px(stage.v2.target(d, body)))
		for hb in ["LeftHand", "RightHand"]:
			short_px = maxf(short_px, MISS_HAND_M * ppm - g.distance_to(_px(_world(d, hb))))
		if short_px <= 1.0:
			break
		_node(d).global_position += axis * (1.0 if d == 1 else -1.0) * (short_px + 2.0) / ppm
		for f in 2:
			await process_frame


func _react(d: int, fam: String) -> void:
	var ap: AnimationPlayer = stage.boxers[d]["ap"]
	var clip := str(REACT.get(fam, ""))
	if not ap.has_animation(clip):
		return
	stage.v2._play(d, clip, 0.0, "reaction", false)
	for f in 60:
		await process_frame
		if str(ap.current_animation) != clip or ap.current_animation_position >= REACT_AT_S:
			break


func _clinch() -> void:
	await _home_guard()
	var mid: Vector3 = (home_t[0].origin + home_t[1].origin) * 0.5
	_node(0).global_position = mid - axis * 0.25
	_node(1).global_position = mid + axis * 0.25
	stage.clinch.start(0, 30.0, 0, -1)
	for f in 150:
		await process_frame
	await _shot("clinch")
	stage.clinch.holder = -1
	stage.clinch.engaged = false


## A knockdown in three frames: who goes down (the punch that did it is the picture before), the other in her guard.
func _knockdown(who: int) -> void:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	if not ap.has_animation(KO_CLIP):
		print("PICS2D_SET no %s" % KO_CLIP)
		refused += 1
		return
	var len := ap.get_animation(KO_CLIP).length
	for k in KO_AT.size():
		await _home_guard()
		stage.v2._play(who, KO_CLIP, 0.0, "reaction", false)
		for f in 400:
			await process_frame
			if ap.current_animation_position >= KO_AT[k] * len or str(ap.current_animation) != KO_CLIP:
				break
		_freeze(who)
		await _shot("%s_knockdown_%d" % [["red", "blue"][who], k + 1])


## Between rounds: the boxer on her stool in her corner (the crew's own sit), alone in the picture.
func _corner(who: int) -> void:
	await _home_guard()
	var c: Dictionary = crew.corner(["red", "blue"][who])
	var a: Dictionary = stage.boxers[who]
	stage.scene_mode(true)
	_node(who).global_position = crew.sit_spot(who, c)
	_node(1 - who).visible = false
	var stool: Node3D = (crew.get("props") as Dictionary).get(["red", "blue"][who] + "_stool")
	if stool != null:
		_show(stool)
	crew.turn(a, crew.yaw_to(Vector3.ZERO, c["d"]), func(): crew.sit(who))
	for f in 300:   # the crew's own clock (FightView ticks it in the ring)
		crew.tick(1.0 / 60.0)
		await process_frame
	await _shot("%s_corner" % ["red", "blue"][who], {}, [who])
	_node(1 - who).visible = true
	if stool != null:
		stool.visible = false
	stage.scene_mode(false)


func _show(n: Node) -> void:
	if n is Node3D:
		(n as Node3D).visible = true
	for ch in n.get_children():
		_show(ch)


func _node(i: int) -> Node3D:
	return stage.boxers[i]["node"] as Node3D


func _freeze(i: int) -> void:
	(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 0.0


func _unfreeze() -> void:
	for i in 2:
		(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 1.0


## Only the two boxers and their kit: ring, ropes, crowd, corner team and props hidden, the sky off.
func _clean_set() -> void:
	for n in stage.find_children("*", "VisualInstance3D", true, false):
		var mine := false
		for i in 2:
			if _node(i).is_ancestor_of(n) or n == _node(i):
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


func _world(i: int, bone: String, up: float = 0.0) -> Vector3:
	var sk: Skeleton3D = stage.boxers[i]["skel"]
	var b := sk.find_bone(bone)
	var g: Transform3D = sk.get_bone_global_pose(b) if b >= 0 else Transform3D.IDENTITY
	return sk.global_transform * g.origin + Vector3.UP * up


func _px(w: Vector3) -> Vector2:
	return cam.unproject_position(w)


func _xy(w: Vector3) -> Array:
	var p := _px(w)
	return [snappedf(p.x, 0.1), snappedf(p.y, 0.1)]


## The fixed side camera: from -X (red left, blue right), level, centred on who is in the picture.
func _aim(who: Array) -> void:
	cam.size = ORTHO_M
	var mid := Vector3.ZERO
	for i in who:   # the hips, not the roots: a knockdown carries the body a metre from its root
		var h := _world(i, "Hips")
		mid += Vector3(h.x, 0.0, h.z)
	mid /= float(who.size())
	var off := Vector3(-8.0, 0.0, 0.0).rotated(Vector3.UP, deg_to_rad(yaw_deg))
	cam.global_position = Vector3(mid.x + off.x, LOOK_Y, mid.z + off.z)
	cam.look_at(Vector3(mid.x, LOOK_Y, mid.z), Vector3.UP)
	cam.make_current()


## Fallback framing (S540): the same side camera, centred on the outermost head/hands/toes and widened just enough.
func _fit(who: Array) -> void:
	var right := cam.global_transform.basis.x
	var lo := INF
	var hi := -INF
	for i in who:
		for b in ["Head", "LeftToes", "RightToes", "LeftHand", "RightHand"]:
			var d := _world(i, b).dot(right)
			lo = minf(lo, d)
			hi = maxf(hi, d)
	var shift := right * ((lo + hi) * 0.5 - cam.global_position.dot(right))
	cam.global_position += shift
	cam.size = maxf(ORTHO_M, (hi - lo) + 0.5)


func _framed(who: Array) -> Array:
	var bad: Array = []
	for i in who:
		for p in [["Head", 0.14], ["LeftToes", -0.06], ["RightToes", -0.06], ["LeftHand", 0.0], ["RightHand", 0.0]]:
			var s := _px(_world(i, str(p[0]), float(p[1])))
			if s.x < 4.0 or s.x > SIZE - 4.0 or s.y < 4.0 or s.y > SIZE - 4.0:
				bad.append("%s %s at %s" % [["red", "blue"][i], str(p[0]), str(s.round())])
	return bad


func _shot(name: String, info: Dictionary = {}, who: Array = [0, 1]) -> void:
	_aim(who)
	for f in 4:
		await process_frame
	if info.has("glove"):   # the camera moved: read the contact points again
		pass
	var bad := _framed(who)
	if not bad.is_empty():   # a boxer on the floor spans more than the side camera: centre on the extremes, widen to fit
		_fit(who)
		for f in 4:
			await process_frame
		bad = _framed(who)
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s: %s" % [name, "; ".join(PackedStringArray(bad))])
		refused += 1
		return
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	sv.get_texture().get_image().save_png(path)
	contacts[name] = info
	wrote += 1
	print("STILL_FRAMING ok %s -> %s" % [name, path])
