extends SceneTree
## S408: the guard knee stays on the source take. Measured as a knock-knee really is (tools/knee_plane_probe.gd): the knee's
## distance out of the plane through hip, ankle and foot direction, as a share of leg length, + = towards her own midline.
## Read inside skeleton_updated (the pose as drawn), only on the idle the bar is calibrated on, once it has settled: not its fade in
## from a walk (a blend of two poses) and not the fidgets (other takes). Clips run on real time, so "settled" is seconds, not frames.
## Source take Box1_M3_Idle (tools/knee_plane_raw.py): lead -0.0065, rear +0.0291. Population: mh_boxer_01 orthodox v mh_boxer_02 southpaw.
## The bar must be able to read worse: the same drawn pose with its knee pushed 8 cm towards the other knee has to trip it.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Probe := preload("res://tools/knee_plane_probe.gd")
const DT := 1.0 / 30.0
const WARMUP := 30
const FRAMES := 660
const MIN_GUARD_FRAMES := 15
const SETTLE_S := 0.5               # past FightStage.GUARD_FADE_S (0.2) and the join's own ease
const SOURCE := [-0.0065, 0.0291]   # [lead, rear]
const MEAN_BAR := 0.03              # her mean may sit this far from the source
const INWARD_BAR := 0.06            # no frame's knee further in than this

var failures := 0
var drawn: Array = [[], []]


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _norm(d: Dictionary, knee: Vector3) -> float:
	var leg: float = (d["hip"] as Vector3).distance_to(d["ankle"])
	return Probe.off_plane(d["hip"], knee, d["ankle"], d["ball"], d["left"]) / maxf(leg, 1e-4)


func _watch(skel: Skeleton3D, idx: int, rig: Node) -> void:
	skel.skeleton_updated.connect(func():
		var xf := skel.global_transform
		var legs: Array = []
		for j in 2:
			var ids: Array = rig._legs[j]["ids"]
			legs.append({"hip": xf * skel.get_bone_global_pose(ids[0]).origin, "knee": xf * skel.get_bone_global_pose(ids[1]).origin,
				"ankle": xf * skel.get_bone_global_pose(ids[2]).origin, "ball": xf * skel.get_bone_global_pose(ids[3]).origin,
				"left": skel.get_bone_name(ids[0]).begins_with("Left")})
		drawn[idx] = legs)


func _initialize() -> void:
	Engine.max_fps = 30   # clips run on real time and stage._process on DT: uncapped, 330 frames last a fraction of a second
	_check(Probe.selftest(), "the ruler reads a straight leg 0 and a knee moved in as +")
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_01.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue", "stance": "southpaw"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Array = stage.boxers
	for i in 2:
		_watch(bx[i]["skel"], i, bx[i]["rig"])
	var sums := [[0.0, 0.0], [0.0, 0.0]]
	var worst := [[-INF, -INF], [-INF, -INF]]
	var worst_at := [["", ""], ["", ""]]
	var age := [0.0, 0.0]
	var count := [0, 0]
	for f in WARMUP + FRAMES:
		stage._process(DT)
		await process_frame
		if f < WARMUP:
			continue
		for i in 2:
			age[i] = float(age[i]) + root.get_process_delta_time() if str((bx[i]["ap"] as AnimationPlayer).current_animation) == "pro_idle" else 0.0
			if float(age[i]) < SETTLE_S or (drawn[i] as Array).size() < 2:
				continue
			count[i] += 1
			for j in 2:
				var d: Dictionary = drawn[i][j]
				var v := _norm(d, d["knee"])
				sums[i][j] += v
				if v > float(worst[i][j]):
					worst[i][j] = v
					worst_at[i][j] = "%.2f s into pro_idle" % float(age[i])
	for i in 2:
		_check(int(count[i]) >= MIN_GUARD_FRAMES, "boxer %d held a guard for %d frames" % [i, int(count[i])])
		if int(count[i]) == 0:
			continue
		for j in 2:
			var leg := "lead" if j == 0 else "rear"
			var mean := float(sums[i][j]) / float(count[i])
			print("GUARD_KNEE boxer=%d %s mean=%.4f worst_in=%.4f (%s) source=%.4f frames=%d" % [i, leg, mean, float(worst[i][j]), str(worst_at[i][j]), float(SOURCE[j]), int(count[i])])
			_check(absf(mean - float(SOURCE[j])) <= MEAN_BAR, "boxer %d %s knee stays on the source (%.4f v %.4f)" % [i, leg, mean, float(SOURCE[j])])
			_check(float(worst[i][j]) <= INWARD_BAR, "boxer %d %s knee never knocks in (%.4f)" % [i, leg, float(worst[i][j])])
	var d0: Dictionary = {} if (drawn[0] as Array).size() < 2 else drawn[0][1]
	if d0.is_empty():
		_check(false, "a drawn pose to test the bar on")
	else:
		var other: Vector3 = drawn[0][0]["knee"]
		var pushed: Vector3 = (d0["knee"] as Vector3) + (other - (d0["knee"] as Vector3)).normalized() * 0.08
		_check(_norm(d0, pushed) - _norm(d0, d0["knee"]) > MEAN_BAR, "a knee pushed 8 cm in trips the bar")
	print("GUARD_KNEE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
