extends SceneTree
## FOOTWORK1 bars (S381): the plan (BoxerFootwork) and the plan on the real boxer (BoxerFootworkRig, read on
## skeleton_updated = the final pose). Stance within +-15 % whenever both feet stand, feet never cross (lateral order in
## her frame), a planted ball moves < 1 cm, heels up in guard, bounce 1.8-2.5 Hz and 3-12 cm (measured: real 2.2-2.4 Hz /
## 3-12 cm, Undisputed idle 2.0 Hz IQR 1.8-2.3 / 3.9-9.6 cm), each pair's travel = the plant displacement, step-drag
## order. On the skeleton: the ankle reaches its target (< 1 cm), knees bent (< 172 deg), balls on the canvas.
## Round 2 (eyes on r3): bounce period CV 0.10-0.25 (a human, not a metronome), flat-footed spells, a planted ball at
## 0 cm in the plan and on the skeleton, the lead knee over the toes in each foot's frontal plane (valgus <= 8 deg; S472 the rear <= 20, the take's own 17.8), ankles
## >= 0.15 m apart across the line when both feet plant, torso lean 8-12 deg; the rig bars on a woman and a man.

const Footwork := preload("res://scripts/fight3d/BoxerFootwork.gd")
const Rig := preload("res://scripts/fight3d/BoxerFootworkRig.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Probe := preload("res://tools/footwork_probe.gd")
const DT := 1.0 / 60.0
const SEQ := ["fwd", "fwd", "back", "back", "left", "left", "right", "right"]

var failures := 0


func _initialize() -> void:
	for south in [false, true]:
		_plan_bars(south)
		_go_bars(south)
	_human_bars()
	for who in ["mh_boxer_10", "mh_boxer_01"]:
		await _rig_bars(who)
	print("BOXER_FOOTWORK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## S391 go(): the ring's step pairs (RingFeet): now, onto any spot, in the real order; the feet never cross, a planted ball
## stays, the stance comes back, and the body ends on the spot; hold calms the bounce; place stands her with no step.
func _go_bars(south: bool) -> void:
	var tag := "go " + ("southpaw" if south else "orthodox")
	var fw = Footwork.new(Vector2(0.3, -0.2), 0.4, south)
	fw.auto_flat = false
	# her frame: x = her left, y = forward; the first foot by the way she goes (lead foot on her left when orthodox)
	var cases := [[Vector2(0.0, 0.4), Footwork.LEAD], [Vector2(0.0, -0.3), Footwork.REAR],
		[Vector2(0.25, 0.0), Footwork.LEAD if not south else Footwork.REAR], [Vector2(-0.25, 0.0), Footwork.REAR if not south else Footwork.LEAD],
		[Vector2(0.15, 0.3), Footwork.LEAD], [Vector2(-0.2, -0.3), Footwork.REAR if not south else Footwork.LEAD]]
	for c in cases:
		var v: Vector2 = c[0]
		var to: Vector2 = fw.centre() + Footwork.rot(v, fw.yaw)
		fw.go(to, 0.32)
		_check(fw.pair.size() > 0, "%s %s starts at once" % [tag, str(v)])
		_check(int(fw.pair["first"]) == int(c[1]), "%s %s: first foot %d (want %d)" % [tag, str(v), int(fw.pair["first"]), int(c[1])])
		var slip := 0.0
		var cross := INF
		var was: Array = [fw.feet[0]["at"], fw.feet[1]["at"]]
		var flying := [false, false]
		for f in int(0.5 / DT):
			fw.tick(DT)
			var rel := Footwork.unrot((fw.feet[0]["at"] as Vector2) - (fw.feet[1]["at"] as Vector2), fw.yaw)
			cross = minf(cross, rel.x * fw.side)
			for i in 2:
				var planted: bool = (fw.feet[i]["swing"] as Dictionary).is_empty()
				flying[i] = flying[i] or not planted
				if planted and not flying[i]:
					slip = maxf(slip, (fw.feet[i]["at"] as Vector2).distance_to(was[i]))
		_check(not fw.busy(), "%s %s lands inside 0.5 s" % [tag, str(v)])
		_check(fw.centre().distance_to(to) < 0.005, "%s %s ends on the spot (%.3f m off)" % [tag, str(v), fw.centre().distance_to(to)])
		_check(slip < 0.001, "%s %s: a foot waiting its turn holds the canvas (%.3f m)" % [tag, str(v), slip])
		_check(cross > 0.1, "%s %s: feet stay on their own sides (%.2f m)" % [tag, str(v), cross])
	fw.hold_want = 1.0
	for f in int(0.5 / DT):
		fw.tick(DT)
	_check(fw.hold >= 1.0 and float(fw.amp) < Footwork.BOUNCE_M * 0.5, "%s hold calms the bounce (%.3f m)" % [tag, float(fw.amp)])
	fw.place(Vector2(1.0, 1.0), 1.0)
	_check(fw.centre().distance_to(Vector2(1.0, 1.0)) < 0.001 and not fw.busy(), "%s place stands her there" % tag)


func _plan_bars(south: bool) -> void:
	var tag := "southpaw" if south else "orthodox"
	var fw = Footwork.new(Vector2(0.3, -0.2), 0.4, south)
	fw.auto_flat = false   # these bars judge the bounce itself; _human_bars judges the flat-footed spells
	var ys: Array = []
	var heel_min := INF
	for f in int(4.0 / DT):
		fw.tick(DT)
		var p: Dictionary = fw.pose()
		ys.append(float(p["hip"].y))
		for ft in p["feet"]:
			heel_min = minf(heel_min, float(ft["heel"]))
	var hz := _minima(ys) / 4.0
	var p2p: float = ys.max() - ys.min()
	_check(hz >= 1.8 and hz <= 2.5, "%s bounce %.2f Hz (bar 1.8-2.5)" % [tag, hz])
	_check(p2p >= 0.03 and p2p <= 0.12, "%s bounce %.1f cm p2p in place (bar 3-12)" % [tag, p2p * 100.0])
	_check(heel_min > 0.0, "%s heels up in guard (lowest %.1f cm)" % [tag, heel_min * 100.0])
	for d in SEQ:
		fw.step(d)
	var worst_w := 0.0
	var worst_cross := INF
	var worst_slide := 0.0
	var worst_ball_y := 0.0
	var plant: Array = [null, null]
	var steps := 0
	var move_ys: Array = []
	var turned := false
	for f in int(12.0 / DT):
		if not turned and fw.done_pairs.size() == SEQ.size() and not fw.busy():
			turned = true
			fw.face(0.4 + deg_to_rad(30.0))
			fw.step("fwd")
		fw.tick(DT)
		var p: Dictionary = fw.pose()
		if fw.busy():
			move_ys.append(float(p["hip"].y))
		var feet: Array = p["feet"]
		var rel := Footwork.unrot(Vector2(feet[0]["ball"].x - feet[1]["ball"].x, feet[0]["ball"].z - feet[1]["ball"].z), float(p["yaw"]))
		worst_cross = minf(worst_cross, rel.x * fw.side)
		if bool(feet[0]["planted"]) and bool(feet[1]["planted"]) and not fw.busy():
			worst_w = maxf(worst_w, maxf(absf(absf(rel.x) / Footwork.STANCE_WID - 1.0), absf(absf(rel.y) / Footwork.STANCE_LEN - 1.0)))
		for i in 2:
			var at := Vector2(feet[i]["ball"].x, feet[i]["ball"].z)
			if bool(feet[i]["planted"]):
				if plant[i] == null:
					plant[i] = at
				worst_slide = maxf(worst_slide, at.distance_to(plant[i]))
				worst_ball_y = maxf(worst_ball_y, absf(float(feet[i]["ball"].y)))
			else:
				plant[i] = null
		steps = fw.done_pairs.size()
	_check(steps == SEQ.size() + 1, "%s all %d step pairs taken (%d)" % [tag, SEQ.size() + 1, steps])
	_check(worst_w <= 0.15, "%s stance within 15 %% of the set width and length when both feet stand (worst %.1f %%)" % [tag, worst_w * 100.0])
	_check(worst_cross > 0.10, "%s feet never cross: lead foot always on her lead side (closest %.1f cm)" % [tag, worst_cross * 100.0])
	_check(worst_slide < 0.01, "%s a planted foot never slides (worst %.2f cm)" % [tag, worst_slide * 100.0])
	_check(worst_ball_y < 0.0005, "%s a planted ball stays ON the canvas, no hover (worst %.2f cm)" % [tag, worst_ball_y * 100.0])
	var mp2p: float = move_ys.max() - move_ys.min() if not move_ys.is_empty() else 0.0
	_check(mp2p >= 0.03 and mp2p <= 0.16, "%s bounce on the move %.1f cm (bar 3-16; Undisputed 13-18, real fight 10-16 max)" % [tag, mp2p * 100.0])
	var travel_err := 0.0
	var order_ok := true
	for k in fw.done_pairs.size():
		var dp: Dictionary = fw.done_pairs[k]
		var moved: Array = dp["moved"]
		var mean: Vector2 = ((moved[0] as Vector2) + (moved[1] as Vector2)) * 0.5
		travel_err = maxf(travel_err, ((dp["centre1"] as Vector2) - (dp["centre0"] as Vector2) - mean).length())
		var want := _first(str(dp["dir"]), south)
		if want >= 0 and int(dp["first"]) != want:
			order_ok = false
			print("  order: %s first=%d want=%d" % [dp["dir"], dp["first"], want])
	_check(travel_err < 0.001, "%s each pair's body travel = the plants' displacement (worst %.2f mm)" % [tag, travel_err * 1000.0])
	_check(order_ok, "%s step-drag order: fwd lead first, back rear first, sideways the near foot first" % tag)
	var last: Dictionary = fw.done_pairs.back()
	_check(absf(wrapf(fw.yaw - (0.4 + deg_to_rad(30.0)), -PI, PI)) < 0.01, "%s turns by stepping to a new facing (%.1f deg)" % [tag, rad_to_deg(fw.yaw - 0.4)])
	_check(str(last["dir"]) == "fwd", "%s the turn rides the queued step" % tag)


## Round 2: the bounce of a human. 60 s bouncing in place: the hips' bottom-to-bottom periods vary (CV 0.10-0.25,
## Undisputed idle IQR 1.8-2.3 Hz) and so do the depths; 120 s with the flat-footed spells on: both modes show, the
## flat-footed bob stays under 2 cm and its heels come down.
func _human_bars() -> void:
	var fw = Footwork.new(Vector2.ZERO, 0.0, false, 1.0, 7)
	fw.auto_flat = false
	var ys: Array = []
	for f in int(60.0 / DT):
		fw.tick(DT)
		ys.append(float(fw.pose()["hip"].y))
	var bottoms: Array = []
	var depths: Array = []
	var top := -INF
	for k in range(1, ys.size() - 1):
		top = maxf(top, float(ys[k]))
		if float(ys[k]) < float(ys[k - 1]) and float(ys[k]) <= float(ys[k + 1]):
			bottoms.append(k * DT)
			depths.append(top - float(ys[k]))
			top = -INF
	var per: Array = []
	for k in range(1, bottoms.size()):
		per.append(float(bottoms[k]) - float(bottoms[k - 1]))
	var cv := _cv(per)
	_check(cv >= 0.10 and cv <= 0.25, "bounce period varies like a human: CV %.3f over %d bounces (bar 0.10-0.25)" % [cv, per.size()])
	var dcv := _cv(depths.slice(1))
	_check(dcv >= 0.08 and dcv <= 0.3, "bounce depth varies: CV %.3f (bar 0.08-0.30)" % dcv)
	var fw2 = Footwork.new(Vector2.ZERO, 0.0, false, 1.0, 11)
	var flat_t := 0.0
	var bounce_t := 0.0
	var flat_ys: Array = []
	var flat_heel := 0.0
	for f in int(120.0 / DT):
		fw2.tick(DT)
		var p: Dictionary = fw2.pose()
		if float(p["spring"]) <= 0.0:
			flat_t += DT
			flat_ys.append(float(p["hip"].y))
			flat_heel = maxf(flat_heel, float(p["feet"][0]["heel"]))
		elif float(p["spring"]) >= 1.0:
			bounce_t += DT
	var share := bounce_t / maxf(bounce_t + flat_t, 1e-3)
	_check(share > 0.3 and share < 0.8, "flat-footed spells: bouncing %.0f %% of 120 s (bar 30-80; real boxers 25-35, game feel %.0f)" % [share * 100.0, Footwork.new().bounce_share * 100.0])
	var fp2p: float = flat_ys.max() - flat_ys.min() if not flat_ys.is_empty() else 1.0
	_check(fp2p < 0.02 and flat_heel < 0.005, "flat-footed: bob %.1f cm (bar < 2), lead heel %.1f cm (down)" % [fp2p * 100.0, flat_heel * 100.0])


static func _cv(xs: Array) -> float:
	if xs.size() < 2:
		return 0.0
	var m := 0.0
	for x in xs:
		m += float(x)
	m /= xs.size()
	var v := 0.0
	for x in xs:
		v += (float(x) - m) * (float(x) - m)
	return sqrt(v / (xs.size() - 1)) / maxf(m, 1e-6)


## 0 = lead, 1 = rear. Orthodox lead foot is on her left.
func _first(dir: String, south: bool) -> int:
	match dir:
		"fwd":
			return 0
		"back":
			return 1
		"left":
			return 1 if south else 0
		"right":
			return 0 if south else 1
	return -1


func _rig_bars(who: String) -> void:
	print(" rig on ", who)
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED   # no fight ticks on an empty stage (the 2nd stage's first frame)
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % who, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var body: Node3D = bx["node"]
	var ap: AnimationPlayer = bx["ap"]
	if bx.get("weave") != null:
		(bx["weave"] as SkeletonModifier3D).active = false   # S392: these bars measure the bounce alone; GuardWeave leans on purpose
	var life := skel.get_node_or_null("FighterLife") as SkeletonModifier3D   # S411: so does a boxer's own rest pose (FIGHTERLOOK1): off, the rig reads 9.8; on, 3-4 deg more
	if life != null:
		life.active = false
	if bx.get("feet") != null:
		(bx["feet"] as Node).free()
	var fw = Footwork.new(Vector2(body.global_position.x, body.global_position.z), body.global_rotation.y, false, body.scale.x)
	var rig: Node = bx.get("rig")   # S391: every boxer carries it, let go until RingFeet takes her legs
	_check(rig != null, "the rig attaches to the boxer")
	if rig == null:
		return
	rig.plan = fw
	rig.want = 1.0
	rig.w = 1.0
	var reads: Array = []
	skel.skeleton_updated.connect(func(): reads.append(_read(skel, rig)))
	var clip_len := ap.get_animation("pro_idle").length
	for d in ["fwd", "back", "left", "right"]:
		fw.step(d)
	var worst_ik := 0.0
	var worst_knee := 0.0
	var worst_slide := 0.0
	var worst_floor := 0.0
	var bent_most := 180.0
	var worst_track := 0.0
	var worst_valgus := -INF
	var worst_rear_valgus := -INF   # S472: the rear knee has its own bar (below)
	var worst_lat := INF
	var worst_ball := 0.0
	var leans := Vector2(INF, -INF)
	var plant: Array = [null, null]
	for f in 240:
		fw.tick(DT)
		rig.drive()
		ap.play("pro_idle")
		ap.seek(fmod(f * DT, clip_len), true)
		ap.pause()
		reads.clear()
		await process_frame
		if reads.is_empty():
			continue
		var r: Array = reads.back()
		var p: Dictionary = fw.pose()
		var yaw := float(p["yaw"])
		var left := Vector3(cos(yaw), 0.0, -sin(yaw))
		var fwd := Vector3(sin(yaw), 0.0, cos(yaw))
		if bool(p["feet"][0]["planted"]) and bool(p["feet"][1]["planted"]):
			worst_lat = minf(worst_lat, absf(((r[0]["ankle"] as Vector3) - (r[1]["ankle"] as Vector3)).dot(left)))
		var tor: Vector3 = r[2]["torso"]
		var lean := rad_to_deg(atan2(tor.dot(fwd), tor.y))
		leans = Vector2(minf(leans.x, lean), maxf(leans.y, lean))
		for i in 2:
			if (float(r[i]["valgus"]) > 6.0 or float(r[i]["knee_toe"]) > 20.0) and OS.get_cmdline_user_args().has("verbose"):
				print("  knee f=%d foot=%d valgus=%.1f off-line=%.1f knee=%.1f planted=%s pair=%s" % [f, i, r[i]["valgus"],
					r[i]["knee_toe"], r[i]["knee"], p["feet"][i]["planted"], str(fw.pair.get("dir", "-")) + " u=%.2f" % float(fw.pair.get("u", 0.0))])
			if i == 1:
				worst_rear_valgus = maxf(worst_rear_valgus, float(r[i]["valgus"]))
			else:
				worst_valgus = maxf(worst_valgus, float(r[i]["valgus"]))
			if float(r[i]["ik_err"]) > 0.005 and OS.get_cmdline_user_args().has("verbose"):
				print("  ik f=%d foot=%d err=%.3f knee=%.1f planted=%s phase=%.2f pair=%s" % [f, i, r[i]["ik_err"], r[i]["knee"],
					p["feet"][i]["planted"], fw.phase, str(fw.pair.get("dir", "-")) + " u=%.2f" % float(fw.pair.get("u", 0.0))])
			worst_ik = maxf(worst_ik, float(r[i]["ik_err"]))
			worst_knee = maxf(worst_knee, float(r[i]["knee"]))
			bent_most = minf(bent_most, float(r[i]["knee"]))
			worst_track = maxf(worst_track, float(r[i]["knee_toe"]))
			var toe: Vector3 = r[i]["toe"]
			if bool(p["feet"][i]["planted"]):
				if plant[i] == null:
					plant[i] = Vector2(toe.x, toe.z)
				worst_slide = maxf(worst_slide, Vector2(toe.x, toe.z).distance_to(plant[i]))
				worst_floor = maxf(worst_floor, absf(toe.y - float(r[i]["toe_y"]) - float(p["feet"][i]["ball"].y)))
				worst_ball = maxf(worst_ball, absf(toe.y - float(r[i]["toe_y"])))
			else:
				plant[i] = null
	_check(worst_ik < 0.01, "on the skeleton each ankle reaches its target (worst %.2f cm)" % (worst_ik * 100.0))
	_check(worst_knee < 172.0 and bent_most > 110.0, "knees stay bent, never folded (inner angle %.1f-%.1f deg)" % [bent_most, worst_knee])
	_check(worst_track < 25.0, "knees point over the toes (worst %.1f deg off the foot line)" % worst_track)
	_check(worst_slide < 0.01, "on the skeleton a planted ball never slides (worst %.2f cm)" % (worst_slide * 100.0))
	_check(worst_floor < 0.01, "on the skeleton the balls stand on the canvas (worst %.2f cm off)" % (worst_floor * 100.0))
	_check(worst_ball < 0.003, "%s: a planted ball's height on the skeleton 0 cm (worst %.2f cm)" % [who, worst_ball * 100.0])
	_check(worst_valgus <= 8.0, "%s: lead knee over the toes in each foot's frontal plane (worst valgus %.1f deg, bar 8)" % [who, worst_valgus])
	# S472 (his "Take's 18 deg" on the rear knee pair): the source take Box1_M3_Idle's own rear knee sits 17.8 deg inside its toes
	# by this very measure (tools/stance_raw.py; lead 1.2), so bar 8 failed the real boxer. Rear bar = the take + 2 deg.
	_check(worst_rear_valgus <= 20.0, "%s: rear knee no further inside the toes than the take (worst valgus %.1f deg, bar 20, take 17.8)" % [who, worst_rear_valgus])
	_check(worst_lat >= 0.15, "%s: ankles %.1f cm apart across the line when both feet plant (bar >= 15)" % [who, worst_lat * 100.0])
	_check(leans.x >= 8.0 and leans.y <= 12.0, "%s: torso leans %.1f-%.1f deg forward from the hips (bar 8-12)" % [who, leans.x, leans.y])
	await _bounce_bars(who, skel, body, ap, rig)
	stage.queue_free()


## Round 3 (operator on r4c_side: "his ass is bouncing more than usual"; probe r4c: hips 7.3 cm a bounce, 6.3 of it from
## 24 deg of knee, 1.1 from the ankles, 2 cm fore-aft): per bounce on the final pose (footwork_probe's measures), 6 s
## bouncing in place then step pairs. The bounce reads from the feet: hips 3-4.5 cm in place (worst 5), the head about
## as much (hips / head <= 1.4), pelvis pitch <= 3 deg and fore-aft <= 1.5 cm a bounce, the ankles give at least half
## the hips' rise, step pairs <= 6 cm.
func _bounce_bars(who: String, skel: Skeleton3D, body: Node3D, ap: AnimationPlayer, rig: Node) -> void:
	var fw = Footwork.new(Vector2(body.global_position.x, body.global_position.z), body.global_rotation.y, false, body.scale.x)
	fw.auto_flat = false
	rig.plan = fw
	var hips_rest := skel.get_bone_global_rest(skel.find_bone("Hips")).basis
	var got: Array = []
	var on := [true]
	skel.skeleton_updated.connect(func():
		if on[0]:
			got.append(Probe.sample(skel, rig, fw, hips_rest)))
	var rows: Array = []
	var clip_len := ap.get_animation("pro_idle").length
	for f in int(9.0 / DT):
		if f == int(6.0 / DT):
			for d in ["fwd", "back", "left", "right"]:
				fw.step(d)
		fw.tick(DT)
		rig.drive()
		ap.play("pro_idle")
		ap.seek(fmod(f * DT, clip_len), true)
		ap.pause()
		got.clear()
		await process_frame
		if not got.is_empty():
			rows.append([fw.beats, fw.busy(), got.back()])
	on[0] = false
	var st: Dictionary = Probe.stats(rows, false)
	var mv: Dictionary = Probe.stats(rows, true)
	var hy: Array = st["hip_y"]
	print("  %s per bounce in place: hips %.2f cm, head %.2f, ankles %.2f, legs %.2f, knee %.1f / %.1f deg" % [who,
		hy[0] * 100.0, st["head_y"][0] * 100.0, st["ankle_y"][0] * 100.0, st["leg"][0] * 100.0, st["knee_l"][0], st["knee_r"][0]])
	_check(int(st["bounces"]) >= 10 and hy[0] >= 0.03 and hy[0] <= 0.045 and hy[1] <= 0.05,
		"%s: hips %.1f cm p2p a bounce in place, worst %.1f, %d bounces (bar 3-4.5, worst 5; r4c 7.3)" % [who, hy[0] * 100.0,
		hy[1] * 100.0, st["bounces"]])
	_check(float(st["ratio"][1]) <= 1.4, "%s: hips / head p2p %.2f (worst %.2f; bar <= 1.4)" % [who, st["ratio"][0], st["ratio"][1]])
	_check(float(st["pitch"][1]) <= 3.0, "%s: pelvis pitch %.1f deg a bounce (worst; bar <= 3)" % [who, st["pitch"][1]])
	_check(float(st["hip_fa"][1]) <= 0.015, "%s: hips fore-aft %.2f cm a bounce (worst; bar <= 1.5; r4c 2.0)" % [who,
		st["hip_fa"][1] * 100.0])
	_check(float(st["ankle_y"][0]) >= 0.5 * float(hy[0]), "%s: the ankles give %.1f of the hips' %.1f cm (bar >= half; r4c 1.1 of 7.3)" % [who,
		st["ankle_y"][0] * 100.0, hy[0] * 100.0])
	_check(int(mv["bounces"]) >= 2 and float(mv["hip_y"][0]) <= 0.06, "%s: hips %.1f cm a bounce on step pairs (bar <= 6; r4c 9.8)" % [who,
		mv["hip_y"][0] * 100.0])


func _read(skel: Skeleton3D, rig: Node) -> Array:
	var out: Array = []
	var xf := skel.global_transform
	for i in 2:
		var ids: Array = rig._legs[i]["ids"]
		var a := xf * skel.get_bone_global_pose(ids[0]).origin
		var k := xf * skel.get_bone_global_pose(ids[1]).origin
		var an := xf * skel.get_bone_global_pose(ids[2]).origin
		var toe := xf * skel.get_bone_global_pose(ids[3]).origin
		var want: Vector3 = rig.last[i].get("ankle", an)
		# round 2: the knee off its foot's line, either way, in the foot's frontal plane (below). Round 1 measured the bend
		# direction off the hip-ankle line - KneeTrack's measure - which on a turned-out rear foot under a hip forward of
		# it reads 0 exactly when the knee caves in toward the big toe: r3's valgus.
		var foot := Vector2(toe.x - an.x, toe.z - an.z).normalized()
		# frontal plane of the foot (normal = heel-to-toe): the shin's tilt from vertical, + = knee on the hip's side (valgus)
		var lat := Vector3(foot.x, 0.0, foot.y).cross(Vector3.UP)
		var shin := Vector2((k - an).dot(lat), (k - an).y)
		var valgus := rad_to_deg(atan2(shin.x * signf((a - an).dot(lat)), shin.y))
		out.append({"ik_err": an.distance_to(want), "knee": rad_to_deg((a - k).angle_to(an - k)), "toe": toe,
			"toe_y": (xf * Vector3(0, float(rig._legs[i]["toe_y"]), 0)).y, "knee_toe": absf(valgus), "valgus": valgus, "ankle": an})
	var neck := xf * skel.get_bone_global_pose(skel.find_bone("Neck")).origin
	var hips := xf * skel.get_bone_global_pose(skel.find_bone("Hips")).origin
	out.append({"torso": neck - hips})
	return out


func _minima(ys: Array) -> int:
	var n := 0
	for k in range(1, ys.size() - 1):
		if float(ys[k]) < float(ys[k - 1]) and float(ys[k]) <= float(ys[k + 1]):
			n += 1
	return n


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok   ", label)
	else:
		failures += 1
		print("  FAIL ", label)
