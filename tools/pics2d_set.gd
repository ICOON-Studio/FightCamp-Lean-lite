extends SceneTree
## PICS2D2 (S540, task ops/research/TASK_PICS2D2.md): the boxing picture set for the 2D view (scripts/ui/FightPictures.gd).
## Our own 3D: the game's MetaHuman bodies on the v2 player as it ships, the toon look, a fixed orthographic side camera
## (red on the left), transparent. Per corner: jab, cross, lead / rear hook, body hook, body cross, lead / rear uppercut x
## landed / blocked / missed, then guard, clinch, a knockdown in three frames each way and each corner on its stool.
## The ring placer is off and the PAIR is placed here; a landed punch goes through the game's own finish (Player2._arm ->
## PunchAim), a blocked one onto her block, a missed one meets a pull or a duck (BeatClips' defence takes).
## PICSFIX1 (S543, owner: "why fighters are entagled like that on the left and on the right the punch does not touch the
## opponent"): every picture passes tools/pics2d_gate.gd at the saved frame or is not written; the range is FOUND (the
## puncher steps back until torsos, feet and heads are clear, his arm reaches on the finish), never a body pushed into a
## body. Nothing in scripts/fight3d is changed (FIGHTPLAYER2 method line). docs/PICSFIX1_RESULT.md.
##   python tools/hidden_desktop.py run --timeout=1800 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_set.gd -- <out_dir> art=toon set=w|m [only=<prefix> | only=*<part>] [gate=report]
## Prints PICS2D_SET wrote=<n> refused=<n> gate_failed=<n>, writes <out_dir>/contacts.json (pixels + the gate's measures).

const SIZE := 768
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const BlockCatch := preload("res://scripts/fight3d/BlockCatch.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const Gate := preload("res://tools/pics2d_gate.gd")   # PICSFIX1: no body through a body, a blocked punch ends on the block
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
const ORTHO_M := 2.55
const LOOK_Y := 1.02
const KO_CLIP := "pro_knockout_v1"
## A landed punch: the target's own hit reaction, held this far in (the head on its way, the guard parted).
const REACT := {"jab": "pro_hit_by_jab_v3", "cross": "pro_hit_by_cross_v1_short", "lead_hook": "pro_hit_by_hook_v1_short",
	"rear_hook": "pro_hit_by_hook_v2_short", "body_hook": "pro_hit_by_gutshot_v2_short", "body_cross": "pro_hit_by_gutshot_v2_short",
	"lead_uppercut": "pro_hit_by_hook_v5", "rear_uppercut": "pro_hit_by_cross_v1_short"}
const REACT_AT_S := 0.05
const KO_AT := [0.16, 0.42, 0.97]
## PICSFIX1: a blocked body punch meets the cover-up (the game's own shell takes, BeatClips/RoundStyle), held this far in.
const COVER := ["mc_to_block", "mc_block"]
const CLINCH_GAPS := [0.50, 0.80]   # PICSFIX1: the roots' sweep for the clinch picture
const COVER_AT := 0.45   # the shell held (mc_block: elbows 0.44-0.47 m over the rib target all through - no take lowers them)

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
var failed: Array = []   # PICSFIX1: pictures the gate refused (not written; listed in contacts.json with the failed measure)
var report := false     # gate=report: measure and write anyway (the before numbers)
var cover := ""         # the cover-up take of the blocked body punch being posed ("" = her guard)


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
	report = _arg("gate", "on") == "report"
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
	Gate.clean_set(stage, [_node(0), _node(1)])
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
	print("PICS2D_SET wrote=%d refused=%d gate_failed=%d %s" % [wrote, refused, failed.size(), " ".join(PackedStringArray(failed))])
	quit(0 if refused == 0 and failed.is_empty() else 1)


func _want(name: String) -> bool: return only == "" or name.begins_with(only) or (only.begins_with("*") and name.contains(only.substr(1)))


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
	var takes := _takes(who, fam)
	if takes.is_empty():
		print("PICS2D_SET no %s take on %s" % [fam, name])
		refused += 1
		return
	var body: bool = FAMILIES[fam][1]
	var dirv := axis * (1.0 if who == 0 else -1.0)   # from the puncher toward the target
	var best := {}
	var tries: Array = []   # [take, cover]: a blocked body punch tries each cover-up, then her plain guard
	for clip in takes:
		for cv in (COVER + [""] if res == "blocked" and body else [""]):
			tries.append([clip, cv])
	for tr in tries:
		var clip: String = tr[0]
		cover = tr[1]
		var row: Dictionary = stage.v2.db["rows"][clip]
		var cs := float(row.get("contact_s", 0.3))
		var hand: String = stage.hand_of(who, str(row.get("hand", "LeftHand")))
		# Pass 1: the take alone from the guard spots - how far short of the target its glove stops along the line.
		await _home_guard()
		stage.v2._play(who, clip, 0.0, "punch", false)
		await _to_contact(who, clip, cs)
		var step: float = (stage.v2.target(1 - who, body) - stage.glove_front(who, hand)).dot(dirv) - (0.10 if res == "blocked" else 0.0)
		var side := Vector3.ZERO
		# PICSFIX1: the RANGE is found, never a body pushed into a body. Each try poses the result from that range and
		# runs the gate; torsos, feet or heads too close step the puncher BACK (his arm then reaches on the finish);
		# a glove short of its target or block steps him in by what is left, along the line only.
		for attempt in 6:
			await _pose(who, clip, fam, res, cs, hand, body, step, side)
			var m: Dictionary = Gate.punch(stage, who, hand, res, body, dirv, _px, SIZE / cam.size, _view())
			m["clip"] = clip
			if best.is_empty() or (m["fails"] as Array).size() < (best["fails"] as Array).size():
				best = m.merged({"step": step, "side": side, "hand": hand, "cs": cs, "cover": cover})
			if (m["fails"] as Array).is_empty():
				break
			var back := maxf(maxf(Gate.APART_MIN_M - float(m["apart_m"]), Gate.FEET_MIN_M - float(m["feet_m"])), Gate.HEAD_CLEAR_M - float(m["head_clear_m"]))
			if back > 0.0:
				step -= back + 0.02
				continue
			var gl: Vector3 = stage.glove_front(who, hand)
			var goal: Vector3 = stage.v2.target(1 - who, body) if res == "landed" else _block_point(who, hand, body)
			if res == "missed" or not goal.is_finite():
				break
			var r := goal - gl
			step += r.dot(dirv)
			side += Vector3(r.x, 0.0, r.z) - dirv * r.dot(dirv)
		if (best["fails"] as Array).is_empty():
			break
	var bc: String = best["clip"]   # the best try posed again for the picture (the gate reads it once more there)
	cover = best["cover"]
	await _pose(who, bc, fam, res, float(best["cs"]), best["hand"], body, float(best["step"]), best["side"])
	var hand2: String = best["hand"]
	var tgt: Vector3 = stage.v2.target(1 - who, body)
	var gl2: Vector3 = stage.glove_front(who, hand2)
	print("PICS2D_SET %s = %s%s step %.2f m" % [name, bc, " cover " + cover if cover != "" else "", float(best["step"])])
	await _shot(name, {"glove": _xy(gl2), "target": _xy(tgt), "clip": bc, "result": res, "cover": cover}, [0, 1],
		func() -> Dictionary: return Gate.punch(stage, who, hand2, res, body, dirv, _px, SIZE / cam.size, _view()))


## Plays until the take reaches its contact frame, then freezes the puncher there.
func _to_contact(who: int, clip: String, cs: float) -> void:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	for f in 240:
		await process_frame
		if str(ap.current_animation) != clip or ap.current_animation_position >= cs - 0.008:
			break
	_freeze(who)


## The takes of a family this boxer has, in order of preference (take=<clip>: that one only).
func _takes(who: int, fam: String) -> Array:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	if _arg("take", "") != "" and ap.has_animation(_arg("take", "")):
		return [_arg("take", "")]
	return (FAMILIES[fam][0] as Array).filter(func(c) -> bool: return ap.has_animation(str(c)))


## One pose of the punch: the pair on their spots, the puncher `step` m in along the line and `side` across, the result's
## finish (the target's reaction + PunchAim on the target / her block + PunchAim on it / her dodge), held at the contact.
func _pose(who: int, clip: String, fam: String, res: String, cs: float, hand: String, body: bool, step: float, side: Vector3) -> void:
	await _home_guard(step, who)
	_node(who).global_position += side
	if res == "landed":   # the head snaps first and is held; the armed glove (PunchAim follows the target) finishes on it
		await _react(1 - who, fam)
		_freeze(1 - who)
		stage.v2._arm(who, clip, body)
	elif res == "blocked":
		await _arm_block(who, clip, fam, cs, hand, body)
	stage.v2._play(who, clip, 0.0, "punch", false)
	await _to_contact(who, clip, cs)
	_freeze(1 - who)
	if res == "missed":
		await _dodge(who, fam, hand, body)
	for f in 8:
		await process_frame


## A blocked head punch: her BlockCatch turns the catching arm onto the punch's line and the glove finishes ON that glove
## (FightStage.arm_block's rule, through PunchAim). A blocked BODY punch (J50 row 2, "low block / elbow-down body guard";
## PICSFIX1): she covers up with the game's own cover take (COVER, held at COVER_AT) - elbows in on the ribs - and the
## glove finishes on the forearm of the side it arrives on, at the height it was thrown, never at the face.
func _arm_block(who: int, clip: String, fam: String, cs: float, hand: String, body: bool) -> void:
	var blocker := 1 - who
	if body:
		var ap: AnimationPlayer = stage.boxers[blocker]["ap"]
		for c in [cover]:
			if ap.has_animation(c):
				stage.v2._play(blocker, c, 0.0, "block", false)
				for f in 90:
					await process_frame
					if str(ap.current_animation) != c or ap.current_animation_position >= minf(COVER_AT, ap.get_animation(c).length - 0.02):
						break
				_freeze(blocker)
				break
	else:
		BlockCatch.block(stage, who, clip, fam, cs, 1.0, cs)
	var node: Node3D = _node(who)
	var front: Vector3 = stage.v2._fronts[who][clip]
	var tgt := func() -> Vector3: return _block_point(who, hand, body)
	(stage.v2._aim[who] as Node).arm(clip, hand, cs, func() -> Vector3: return tgt.call() - node.global_transform * front,
		(stage.v2._rels[who] as Dictionary).get(clip, Vector3.ZERO), tgt)


## Where a blocked glove's front finishes: on the catching glove's padding (a head punch), or on the forearm of the side
## the punch arrives on, at the body target's height (a body punch). Vector3.INF when her arm cannot be read.
func _block_point(who: int, hand: String, body: bool) -> Vector3:
	var d := 1 - who
	var side := "Right" if hand == "LeftHand" else "Left"
	var pg: Vector3 = stage.glove_front(who, hand)
	if body:   # the nearer of her two forearms to the glove (the arriving side's, or the other one tucked across)
		var best := Vector3.INF
		for sd in [side, "Left" if side == "Right" else "Right"]:
			var p := Geometry3D.get_closest_point_to_segment(pg, Gate.world(stage, d, sd + "LowerArm"), Gate.world(stage, d, sd + "Hand"))
			if not best.is_finite() or p.distance_to(pg) < best.distance_to(pg) - 0.03:
				best = p
		return best + (pg - best).normalized() * (Gate.FOREARM_R + 0.01)
	var bcn: Node = stage.boxers[d].get("block_catch")
	var ch := str(bcn.call("catch_hand")) if bcn != null else side + "Hand"
	var gloves: Dictionary = (stage.boxers[d]["gloves"] as Node).gloves
	var g: Vector3 = ((gloves["l"] if ch.begins_with("Left") else gloves["r"]) as Node3D).global_position
	return g + (pg - g).normalized() * 0.09


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
	for tries in 12:   # clear of the head by Gate.MISS_PX_M and of both her gloves by Gate.MISS_HAND_M, on the picture
		var g := _px(stage.glove_front(who, hand))
		var short_px := Gate.MISS_PX_M * ppm - g.distance_to(_px(stage.v2.target(d, body)))
		for hb in ["LeftHand", "RightHand"]:
			short_px = maxf(short_px, Gate.MISS_HAND_M * ppm - g.distance_to(_px(Gate.world(stage, d, hb))))
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
	# PICSFIX1: the clinch take leans the two trunks into each other (at the old 0.50 m between the roots they sat 0.04 m
	# apart - one body inside the other). The roots are swept from CLINCH_GAPS[0] to [1] in 1 cm steps and the first gap
	# the gate reads as chest on chest with no trunk, head or arm inside the other is the picture (else the one with the
	# fewest failed measures, which the gate then refuses). The pair take's own gap is Clinch.PAIR_GAP_M 0.68.
	var mid: Vector3 = (home_t[0].origin + home_t[1].origin) * 0.5
	var pick := [INF, 0.68]
	var gap := float(CLINCH_GAPS[0])
	while gap <= float(CLINCH_GAPS[1]) + 0.001:
		await _clinch_at(mid, gap)
		var cm: Dictionary = Gate.clinch(stage, _view())
		var n := (cm["fails"] as Array).size()
		print("PICS2D_SET clinch %.2f: %s" % [gap, str(cm["fails"])])
		if n < pick[0]:
			pick = [n, gap]
		if n == 0:
			break
		gap += 0.01
	await _clinch_at(mid, pick[1])
	print("PICS2D_SET clinch roots %.2f m apart" % pick[1])
	await _shot("clinch", {}, [0, 1], func() -> Dictionary: return Gate.clinch(stage, _view()))
	stage.clinch.holder = -1
	stage.clinch.engaged = false


func _clinch_at(mid: Vector3, gap: float) -> void:
	stage.clinch.holder = -1
	stage.clinch.engaged = false
	await _home_guard()
	_node(0).global_position = mid - axis * gap * 0.5
	_node(1).global_position = mid + axis * gap * 0.5
	stage.clinch.start(0, 30.0, 0, -1)
	for f in 150:
		await process_frame


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
		Gate.show_all(stool)
	crew.turn(a, crew.yaw_to(Vector3.ZERO, c["d"]), func(): crew.sit(who))
	for f in 300:   # the crew's own clock (FightView ticks it in the ring)
		crew.tick(1.0 / 60.0)
		await process_frame
	await _shot("%s_corner" % ["red", "blue"][who], {}, [who])
	_node(1 - who).visible = true
	if stool != null:
		stool.visible = false
	stage.scene_mode(false)


func _node(i: int) -> Node3D: return stage.boxers[i]["node"] as Node3D


func _freeze(i: int) -> void: (stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 0.0


func _unfreeze() -> void:
	for i in 2:
		(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 1.0


func _view() -> Vector3: return -cam.global_transform.basis.z


func _px(w: Vector3) -> Vector2: return cam.unproject_position(w)


func _xy(w: Vector3) -> Array:
	var p := _px(w)
	return [snappedf(p.x, 0.1), snappedf(p.y, 0.1)]


## The fixed side camera: from -X (red left, blue right), level, centred on who is in the picture.
func _aim(who: Array) -> void:
	cam.size = ORTHO_M
	var mid := Vector3.ZERO
	for i in who:   # the hips, not the roots: a knockdown carries the body a metre from its root
		var h := Gate.world(stage, i, "Hips")
		mid += Vector3(h.x, 0.0, h.z)
	mid /= float(who.size())
	var off := Vector3(-8.0, 0.0, 0.0).rotated(Vector3.UP, deg_to_rad(yaw_deg))
	cam.global_position = Vector3(mid.x + off.x, LOOK_Y, mid.z + off.z)
	cam.look_at(Vector3(mid.x, LOOK_Y, mid.z), Vector3.UP)
	cam.make_current()


func _shot(name: String, info: Dictionary = {}, who: Array = [0, 1], gate: Callable = Callable()) -> void:
	_aim(who)
	for f in 4:
		await process_frame
	var bad := Gate.framed(stage, cam, who, SIZE)
	if not bad.is_empty():   # a boxer on the floor spans more than the side camera: centre on the extremes, widen to fit
		Gate.fit(stage, cam, who, ORTHO_M)
		for f in 4:
			await process_frame
		bad = Gate.framed(stage, cam, who, SIZE)
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s: %s" % [name, "; ".join(PackedStringArray(bad))])
		refused += 1
		return
	var path := out_dir.path_join(name + ".png")
	if gate.is_valid():   # PICSFIX1: measured on the pose that is saved
		info.merge(gate.call(), true)
		var fails: Array = info["fails"]
		if not fails.is_empty():
			print("PICS_GATE %s %s: %s" % ["REPORT" if report else "FAIL", name, "; ".join(PackedStringArray(fails))])
		if not fails.is_empty() and not report:
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
			failed.append(name)
			contacts[name] = info
			return
	await RenderingServer.frame_post_draw
	sv.get_texture().get_image().save_png(path)
	contacts[name] = info
	wrote += 1
	print("STILL_FRAMING ok %s -> %s" % [name, path])
