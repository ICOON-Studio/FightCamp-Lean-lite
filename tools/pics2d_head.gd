extends "res://tools/pics2d_anim_more.gd"
## HEADPICS1 (S560-S561, ops/research/TASK_HEADPICS1.md): THE HEAD MOVES OF head.html IN PICTURES. head.html plays four head
## moves on the feet switch (slip, roll, lean back = pull, slip in) and a punch they make miss showed the plain "missed" run.
##   <col>_<punch>_slipped   the jab / cross, the other man SLIPS
##   <col>_<punch>_rolled    the lead hook / overhand (the rear hook take, as the page borrows it), he ROLLS: pro_*_weave
##   <col>_<punch>_leaned    the jab / cross / lead hook / overhand, he LEANS BACK: pro_back_dodge
##   <col>_slip_in[_r2|_r1]  the st_in_m step with the slip's lean on the way in; drawn as the steps are
## <col> is the PUNCHER's corner (the page's runOf: blue_jab_slipped = blue's jab, red slips it); a slip in is the stepper's.
## STAGING (S561, after two tries read as "he stood too far away"): the plain missed run gives the other man ground until the
## glove is clear of his face, so the punch fell 0.11-0.33 m short of where the head had been. A head move is the opposite: the
## punch is thrown AT the head (the puncher stands where his glove goes through the place the head is in the guard) and the
## head is not there any more. Nothing is given, nobody steps.
## THE SLIP IS A LEAN, NOT A TAKE: pro_left/right_dodge step 0.3-0.6 m across the line (ChoreoReact, S531 "NO SIDE DODGE";
## try 1: his boot at his own knee, it read as a duck). The slip here is the guard with the trunk leant off the line toward
## the camera and a little in, from the Spine bone up (the gloves ride with it: the guard stays), eased in before the contact
## and out after it - a SkeletonModifier3D, so no take is changed and nothing is saved. slip=take plays R.WEAVE_STRAIGHT instead.
## Printed per run: HEAD_GATE <run> gap_m (the glove to his head on the picture, at the contact) over_m (the glove's front
## over the top of his head) drop_m (a roll: how far his head went down) passes_m (how far the glove gets past the place his head WAS) ear_m (his rear glove ahead
## of his head bone) turn_deg (his shoulders off square to the line) foot_y (his lowest foot bone over the canvas).
##   same command as pics2d_anim.gd with --script res://tools/pics2d_head.gd -- <out_dir> art=toon set=m south=blue [only=...]

const HEAD_RUNS := {"jab_slipped": ["jab", "slip"], "cross_slipped": ["cross", "slip"], "lead_hook_rolled": ["lead_hook", "roll"],
	"overhand_rolled": ["rear_hook", "roll"], "jab_leaned": ["jab", "pull"], "cross_leaned": ["cross", "pull"],
	"lead_hook_leaned": ["lead_hook", "pull"], "overhand_leaned": ["rear_hook", "pull"]}
const KIND := {"slip": "weave", "roll": "weave", "pull": "pull"}
const GAP_M := 0.12        # the task's bar: the head this far off the glove on the picture
const ROLL_DROP_M := 0.20  # a roll: his head this far under where it was in the guard (try 4: pro_left_weave left him standing)
const ROLL_TAKE := "pro_right_weave"   # the duck that goes down on both men; pro_left_weave's head goes UP (clip_db head_dir y +0.88)
const EAR_M := 0.05        # GUARDEAR1: the rear glove ahead of the ear line
const TURN_MAX_DEG := 75.0 # past this his back is turning to the camera / the other man
const FOOT_MIN_Y := -0.03  # a foot bone under the canvas
const FOOT_MAX_Y := 0.12   # both feet over this = he floats
## Where the glove's front ends, in m past the front of his face in the guard. A slip and a roll: THROUGH the place his head
## was. A lean back: SHORT of it - he sways 0.2 m and his own gloves ride in front of his face, so a punch thrown through
## the old place ended on his gloves and read as a block (tries 3 and 4); it stops in the air in front of him instead.
const THROUGH_M := {"slip": 0.13, "lean": 0.13, "roll": 0.10, "pull": -0.14}

var slip_deg := [22.0, 5.0]     # the slip: degrees toward the camera, degrees in toward the other man
var slipin_deg := [18.0, 8.0]  # the slip in: the same lean, deeper in, at the middle of the step
var head_kind := ""
var head_m := {}
var head_was := Vector3.INF
var head_rows := {}
var leans: Array = [null, null]
var lean_step := -1   # the boxer whose step in carries the slip


## The trunk turned from one bone up, in the world's own axes, after the take has been applied (and before the skin).
class Lean extends SkeletonModifier3D:
	var world_rot := Quaternion.IDENTITY
	var bone := -1
	func _process_modification() -> void:
		var sk := get_skeleton()
		if sk == null or bone < 0 or world_rot.is_equal_approx(Quaternion.IDENTITY):
			return
		var wb := sk.global_transform.basis.orthonormalized()
		var g := sk.get_bone_global_pose(bone)
		sk.set_bone_global_pose(bone, Transform3D(wb.inverse() * Basis(world_rot) * wb * g.basis, g.origin))


func _run() -> void:
	for k in 2:
		slip_deg[k] = float(_arg("slip_deg", "%f,%f" % slip_deg).split(",")[k])
		slipin_deg[k] = float(_arg("slipin_deg", "%f,%f" % slipin_deg).split(",")[k])
	for who in 2:
		var col: String = ["red", "blue"][who]
		for key in HEAD_RUNS:
			var name := "%s_%s" % [col, key]
			if _want(name):
				await _head_run(who, str(HEAD_RUNS[key][0]), str(HEAD_RUNS[key][1]), name)
	for who in 2:
		var col: String = ["red", "blue"][who]
		lean_step = who
		if _want(col + "_slip_in"):
			await _step_run(who, "step_in", col + "_slip_in")
		for rk in ["_r2", "_r1"]:
			if _want(col + "_slip_in" + rk):
				await _step_run(who, "step_in", col + "_slip_in" + rk, float(RANGE_IN[rk]), true)
		lean_step = -1
		_lean(who, 0.0, 0.0)
	for n in head_rows:
		if runs.has(n):
			(runs[n] as Dictionary)["head"] = head_rows[n]
	_save()
	_finish()


func _lean(i: int, side_deg: float, in_deg: float) -> void:
	var sk: Skeleton3D = stage.boxers[i]["skel"]
	if leans[i] == null:
		var l := Lean.new()
		l.bone = sk.find_bone("Spine")
		sk.add_child(l)
		leans[i] = l
	var toward := axis * (1.0 if i == 0 else -1.0)
	var camdir := ((cam.global_position - _node(i).global_position) * Vector3(1, 0, 1)).normalized()
	(leans[i] as Lean).world_rot = Quaternion(Vector3.UP.cross(camdir).normalized(), deg_to_rad(side_deg)) * Quaternion(Vector3.UP.cross(toward).normalized(), deg_to_rad(in_deg))


## How much of the slip is on, `off` s from the contact: on its way from -0.22, whole from -0.05 to +0.08, gone by +0.30.
func _env(off: float) -> float:
	return smoothstep(-0.22, -0.05, off) if off <= 0.0 else 1.0 - smoothstep(0.08, 0.30, off)


## A bone's world point with the lean on it (the modifier's pose lasts one draw: the skeleton reads back the take's own).
func _leant(i: int, bone: String) -> Vector3:
	var p := Gate.world(stage, i, bone)
	if leans[i] == null or (leans[i] as Lean).world_rot.is_equal_approx(Quaternion.IDENTITY):
		return p
	var o := Gate.world(stage, i, "Spine")
	return o + (leans[i] as Lean).world_rot * (p - o)


func _head_run(who: int, fam: String, kind: String, name: String) -> void:
	head_kind = "lean" if kind == "slip" and _arg("slip", "lean") == "lean" else kind
	head_m = {}
	head_was = Vector3.INF
	var takes := _takes(who, fam)
	if takes.is_empty():
		print("PICS2D_ANIM no %s take on %s" % [fam, name])
		refused += 1
		head_kind = ""
		return
	var d := 1 - who
	var clip: String = takes[0]
	var row: Dictionary = stage.v2.db["rows"][clip]
	var cs := float(row.get("contact_s", 0.3))
	var hand: String = stage.hand_of(who, str(row.get("hand", "LeftHand")))
	var dirv := axis * (1.0 if who == 0 else -1.0)
	var step := 0.0
	cover = ""
	for attempt in 3:   # the take's own glove through the place his face is in the guard
		await _home_guard(step, who)
		stage.v2._play(who, clip, 0.0, "punch", false)
		await _to_contact(who, clip, cs)
		step += (stage.v2.target(d, false) + dirv * float(THROUGH_M[head_kind]) - stage.glove_front(who, hand)).dot(dirv)
	var b := {"clip": clip, "cs": cs, "hand": hand, "step": step, "side": Vector3.ZERO, "cover": ""}
	await _home_guard(step, who)
	_aim([0, 1])
	var pl := _plan(who, b, fam, "missed")
	var first := 0   # the offsets before anything starts are all the guard: keep the last of them only
	for k in offs.size():
		if float(offs[k]) <= float(pl["t0"]):
			first = k
	var files: Array = []
	var times: Array = []
	var hit_at: Array = []
	for k in range(first, offs.size()):
		var off := float(offs[k])
		await _pose_at(who, b, pl, Vector3.ZERO, off)
		var f := "%s_%d" % [name, files.size()]
		if not await _frame(f):
			refused += 1
			head_kind = ""
			_lean(d, 0.0, 0.0)
			return
		if is_zero_approx(off):
			var gp: Vector2 = _px(stage.glove_front(who, hand))
			hit_at = [snappedf(gp.x / SIZE, 0.001), snappedf(gp.y / SIZE, 0.001)]
		files.append(f + ".png")
		times.append(off)
	_lean(d, 0.0, 0.0)
	runs[name] = {"files": files, "offs": times, "contact": times.find(0.0), "clip": clip, "cover": "", "answer": str(pl["ans"]) if str(pl["ans"]) != "" else "slip lean",
		"step": snappedf(step, 0.001), "gate_fails": [], "hit": hit_at}
	print("PICS2D_ANIM %s = %s, answer %s, %d frames, step %.2f m" % [name, clip, runs[name]["answer"], files.size(), step])
	var fails: Array = []
	var gap := float(head_m.get("gap_m", 0.0))
	if gap < GAP_M:
		fails.append("gap_m %.3f < %.2f" % [gap, GAP_M])
	if kind == "roll" and float(head_m.get("drop_m", 0.0)) < ROLL_DROP_M:
		fails.append("drop_m %.3f < %.2f (he did not go under)" % [float(head_m.get("drop_m", 0.0)), ROLL_DROP_M])
	if kind != "pull" and float(head_m.get("passes_m", -1.0)) < -0.03:
		fails.append("passes_m %.3f (the glove stops short of where his head was)" % float(head_m.get("passes_m", -1.0)))
	if float(head_m.get("ear_m", 0.0)) < EAR_M:
		fails.append("ear_m %.3f < %.2f (his rear glove not ahead of the ear)" % [float(head_m.get("ear_m", 0.0)), EAR_M])
	if float(head_m.get("turn_deg", 0.0)) > TURN_MAX_DEG:
		fails.append("turn_deg %.0f > %.0f (his back turns)" % [float(head_m.get("turn_deg", 0.0)), TURN_MAX_DEG])
	if float(head_m.get("foot_y", 0.0)) < FOOT_MIN_Y or float(head_m.get("foot_y", 0.0)) > FOOT_MAX_Y:
		fails.append("foot_y %.3f (a foot under the canvas or both off it)" % float(head_m.get("foot_y", 0.0)))
	head_m["fails"] = fails
	head_rows[name] = head_m.duplicate()
	(runs[name] as Dictionary)["gate_fails"] = fails
	print("HEAD_GATE %s %s %s" % [name, JSON.stringify(head_m), "PASS" if fails.is_empty() else "FAIL"])
	if not fails.is_empty():
		failed.append(name)
	head_kind = ""
	_save()


## The other man's answer is the head move instead of the plain miss.
func _plan(who: int, b: Dictionary, fam: String, res: String) -> Dictionary:
	var pl: Dictionary = super(who, b, fam, res)
	if head_kind == "":
		return pl
	pl["weave"] = false
	if head_kind == "lean":   # the slip: he stays in the guard, the lean is the move
		pl["ans"] = ""
		pl["ans_t"] = INF
		pl["t0"] = float(pl["punch_t"])
		return pl
	var dap: AnimationPlayer = stage.boxers[1 - who]["ap"]
	var rows: Dictionary = stage.v2.db["rows"]
	var has := func(c: String) -> bool: return dap.has_animation(c)
	var clip: String = R.WEAVE_STRAIGHT if head_kind == "slip" and dap.has_animation(R.WEAVE_STRAIGHT) else ROLL_TAKE if head_kind == "roll" and dap.has_animation(ROLL_TAKE) else BeatClips.defence(str(KIND[head_kind]), fam, str(b["hand"]) == "LeftHand", false, has)
	if clip == "" or not dap.has_animation(clip):
		print("HEADPICS no %s take for %s" % [head_kind, fam])
		return pl
	pl["ans"] = clip
	pl["ans_kind"] = "defence"
	pl["dpeak"] = float((rows.get(clip, {}) as Dictionary).get("head_peak_s", dap.get_animation(clip).length * 0.42))
	_dodge_at(pl, 1.0)   # at its deepest ON the contact: the glove goes through the place his head was
	pl["t0"] = minf(float(pl["punch_t"]), float(pl["ans_t"]))
	return pl


## Measured on the pose the run draws: the guard (where his head WAS) and the contact.
func _pose_at(who: int, b: Dictionary, pl: Dictionary, give: Vector3, off: float) -> void:
	await super(who, b, pl, give, off)
	if head_kind == "":
		return
	var d := 1 - who
	if head_kind == "lean":
		_lean(d, float(slip_deg[0]) * _env(off), float(slip_deg[1]) * _env(off))
	if off <= float(pl["t0"]):
		head_was = Gate.world(stage, d, "Head")
		return
	if not is_zero_approx(off):
		return
	if not head_was.is_finite():   # where his head was: the guard on the same spots, just before anything starts
		await super(who, b, pl, give, float(pl["t0"]) - 0.01)
		head_was = Gate.world(stage, d, "Head")
		await super(who, b, pl, give, off)
	var dirv := axis * (1.0 if who == 0 else -1.0)
	var sc: float = _node(d).scale.x
	var g: Vector3 = stage.glove_front(who, str(b["hand"]))
	var head := _leant(d, "Head")
	var ppm := SIZE / cam.size
	head_m["gap_m"] = snappedf(_px(g).distance_to(_px(head)) / ppm, 0.001)
	head_m["over_m"] = snappedf(g.y - (head.y + 0.12 * sc), 0.001)
	head_m["drop_m"] = snappedf(head_was.y - head.y, 0.001) if head_was.is_finite() else 0.0
	head_m["passes_m"] = snappedf((g - head_was).dot(dirv), 0.001) if head_was.is_finite() else -9.0
	var rear: String = str(stage.hand_of(d, "RightHand"))
	head_m["ear_m"] = snappedf((_leant(d, rear) - head).dot(-dirv), 0.001)
	var sh := Gate.world(stage, d, "RightUpperArm") - Gate.world(stage, d, "LeftUpperArm")
	sh.y = 0.0
	head_m["turn_deg"] = snappedf(rad_to_deg(absf(asin(clampf(absf(sh.normalized().dot(dirv)), 0.0, 1.0)))), 0.1)
	var ground: float = _node(d).global_position.y
	var low := INF
	for f in ["LeftToes", "RightToes", "LeftFoot", "RightFoot"]:
		var p := Gate.world(stage, d, f)
		if p.is_finite():
			low = minf(low, p.y - ground)
	head_m["foot_y"] = snappedf(low, 0.001)


## The slip in: the step's own pictures with the slip's lean on the stepper, none at the first picture, whole at the
## middle of the step, gone on the last (the next picture is his guard).
func _frame(name: String, who: Array = [0, 1]) -> bool:
	if lean_step >= 0:
		var ap: AnimationPlayer = stage.boxers[lean_step]["ap"]
		var pos := ap.current_animation_position if str(ap.current_animation) == str(STEPS["step_in"][0]) else 99.0
		var e := sin(PI * clampf(pos / float(STEP_T[-1]), 0.0, 1.0))
		_lean(lean_step, float(slipin_deg[0]) * e, float(slipin_deg[1]) * e)
	return await super._frame(name, who)
