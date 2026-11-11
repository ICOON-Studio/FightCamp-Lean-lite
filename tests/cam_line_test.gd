extends SceneTree
## CAMLINE2: the camera ruler's pure parts (CamLine.gd) and the game path it is read against, headless.
##  1. HIDDEN: a lens straight behind one boxer reads HIDDEN and a side-on lens does not, with the pair along world X,
##     world Z and between them (CAMLINE1's box read 0.00 along X); two boxers who differ in height and stance.
##  2. The ropes' read (truly between the lens and a boxer or not, one rope with two alphas) and the far blur's read.
##  3. The glove's smear on made-up pictures (a crisp disc, the same disc streaked a known length).
##  4. THE GAME PATH: RingRopes as the ring builds them, a RingCamera in the tree, a boxer leaning on a rope, an inside
##     side-on lens, RingCamera.clear_view with delta 0. And the live lens (RingCamera.broadcast) while the pair turns.
##  5. PART B, the game path with two bodies the lens can read (a stand-in stage: `boxers` with a skeleton and the
##     GloveClear layer each): the pair turns through a captured step while the hips FightStage hands in stand still
##     (RkPure switched the layer off); one boxer folds in behind the other; the close-up's side; the far blur.
## The bars are CamLine's constants. Prints CAM_LINE failures=<n>.

const CamLine := preload("res://scripts/fight3d/CamLine.gd")
const TvShot := preload("res://scripts/fight3d/TvShot.gd")
const RingRopes := preload("res://scripts/fight3d/RingRopes.gd")
const RingCamera := preload("res://scripts/fight3d/RingCamera.gd")

const ASPECT := 16.0 / 9.0
const HALF := 2.75   # FightStage.RING_M * 0.5

var failures := 0


func _initialize() -> void:
	await process_frame   # the root is in the tree from the first frame (global transforms need it)
	_hidden()
	_ropes_pure()
	_blur_pure()
	_smear()
	_ropes_game()
	_lens_game()
	_captured_step()
	_folded_behind()
	_far_lens()
	print("CAM_LINE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


## A boxer standing at `at` facing `face`, `height` m tall, guard up; a bladed stance (the lead shoulder forward).
static func boxer(at: Vector3, face: Vector3, height: float, south: bool) -> Dictionary:
	var s := height / 1.75
	var f := face.normalized()
	var lat := f.cross(Vector3.UP).normalized()
	var sh := (Basis(Vector3.UP, deg_to_rad(-30.0 if south else 30.0)) * lat) * 0.19 * s
	var chest := at + Vector3.UP * 1.42 * s
	var chin := at + Vector3.UP * 1.48 * s + f * 0.26 * s
	return {"scale": s, "head": at + Vector3.UP * 1.55 * s + f * 0.03 * s, "sh_l": chest - sh, "sh_r": chest + sh,
		"el_l": chest - sh + Vector3.DOWN * 0.24 * s + f * 0.12 * s, "el_r": chest + sh + Vector3.DOWN * 0.24 * s + f * 0.12 * s,
		"hand_l": chin - lat * 0.07 * s, "hand_r": chin + lat * 0.07 * s, "hips": at + Vector3.UP * 0.97 * s, "feet": at}


static func lens_at(from: Vector3, look: Vector3) -> Transform3D:
	return Transform3D(Basis.looking_at(look - from, Vector3.UP), from)


func _hidden() -> void:
	var ahead := CamLine.project(lens_at(Vector3(0, 1, 5), Vector3(0, 1, 0)), 40.0, ASPECT, Vector3(0, 1, 0))
	_check(absf(ahead.x) < 0.001 and absf(ahead.y) < 0.001 and absf(ahead.z - 5.0) < 0.001, "a point straight ahead projects to the middle, 5 m deep")
	var widths: Array = []
	for deg in [0.0, 90.0, 45.0, 200.0]:
		var u := Vector3(cos(deg_to_rad(deg)), 0.0, sin(deg_to_rad(deg)))
		var mid := Vector3(0.4, 0.0, -0.3)
		var gap := 1.1
		# Two who differ: a 1.66 m orthodox boxer and a 1.80 m southpaw.
		var a := boxer(mid - u * gap * 0.5, u, 1.66, false)
		var b := boxer(mid + u * gap * 0.5, -u, 1.80, true)
		var look := mid + Vector3.UP * 0.95
		var back_a := lens_at(mid - u * 3.1 + Vector3.UP * 1.85, look)
		var back_b := lens_at(mid + u * 3.1 + Vector3.UP * 1.85, look)
		var side := lens_at(mid + u.cross(Vector3.UP) * 3.1 + Vector3.UP * 1.85, look)
		var h_a := CamLine.hidden(back_a, 38.0, ASPECT, b, a)   # b, the far one, behind a's back
		var h_b := CamLine.hidden(back_b, 38.0, ASPECT, a, b)
		var h_s := CamLine.hidden_share(side, 38.0, ASPECT, a, b)
		print("CAM_LINE_HIDDEN pair along %3.0f deg: lens behind the short boxer %.2f, behind the tall boxer %.2f, side-on %.2f" % [deg, h_a, h_b, h_s])
		_check(h_a >= CamLine.HIDDEN_AT, "pair along %.0f deg: a lens straight behind the 1.66 m boxer reads HIDDEN (%.2f)" % [deg, h_a])
		_check(h_b >= CamLine.HIDDEN_AT, "pair along %.0f deg: a lens straight behind the 1.80 m boxer reads HIDDEN (%.2f)" % [deg, h_b])
		_check(CamLine.hidden(back_a, 38.0, ASPECT, a, b) == 0.0, "pair along %.0f deg: the NEAR boxer is never hidden by the far one" % deg)
		_check(h_s < 0.05, "pair along %.0f deg: a side-on lens does not read HIDDEN (%.2f)" % [deg, h_s])
		_check(TvShot.behind_deg(a["feet"], b["feet"], back_a.origin) < CamLine.BEHIND_DEG, "pair along %.0f deg: the lens behind reads under %.0f deg (TvShot.behind_deg)" % [deg, CamLine.BEHIND_DEG])
		_check(TvShot.behind_deg(a["feet"], b["feet"], side.origin) > 80.0, "pair along %.0f deg: the side-on lens reads near 90 deg" % deg)
		widths.append(CamLine.head_chest_box(back_a, 38.0, ASPECT, a).size.x)
	for w in widths:
		_check(absf(float(w) - float(widths[0])) < 0.03 * float(widths[0]), "the same body gives the same box width from every side of the ring (%.4f vs %.4f)" % [float(w), float(widths[0])])
	# The ruler's answer as the lens comes round from behind (no bar: printed so the reader sees what 0.6 means).
	for gap in [0.7, 1.1]:
		var row := ""
		for off in [0.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 75.0, 90.0]:
			var a := boxer(Vector3(0, 0, -gap * 0.5), Vector3.BACK, 1.66, false)
			var b := boxer(Vector3(0, 0, gap * 0.5), Vector3.FORWARD, 1.80, true)
			var dir := Basis(Vector3.UP, deg_to_rad(off)) * Vector3.FORWARD
			var xf := lens_at(dir * 3.1 + Vector3.UP * 1.85, Vector3.UP * 0.95)
			row += " %.0f:%.2f" % [TvShot.behind_deg(a["feet"], b["feet"], xf.origin), CamLine.hidden_share(xf, 38.0, ASPECT, a, b)]
		print("CAM_LINE_CURVE gap %.1f m, lens 3.1 m out, behind_deg:hidden%s" % [gap, row])


func _ropes_pure() -> void:
	var east_a := Vector3(HALF, 0.85, -1.0)
	var east_b := Vector3(HALF, 0.85, 1.0)
	var leaner := Vector3(HALF - 0.06, 0.0, 0.0)
	_check(not CamLine.between(Vector3(1.2, 1.85, -2.35), leaner, east_a, east_b), "a rope she leans on is NOT between an inside lens and her")
	_check(CamLine.between(Vector3(HALF + 1.2, 1.4, 0.2), Vector3(1.0, 0.0, 0.0), east_a, east_b), "a rope between an outside lens and her IS between")
	_check(not CamLine.between(Vector3(0.0, 1.85, 0.0), Vector3(1.0, 0.0, 0.0), east_a, east_b), "a rope behind her is NOT between the lens and her")
	var rows: Array = []
	for k in 4:
		rows.append({"rope": 3, "alpha": 0.18 if k < 2 else 1.0, "a": Vector3(HALF, 0.85, k - 2.0), "b": Vector3(HALF, 0.85, k - 1.0)})
		rows.append({"rope": 4, "alpha": 0.18, "a": Vector3(-HALF, 0.85, k - 2.0), "b": Vector3(-HALF, 0.85, k - 1.0)})
	rows.append({"rope": -1, "alpha": 0.18, "a": Vector3(HALF, 0, HALF), "b": Vector3(HALF, 1.45, HALF)})
	var read := CamLine.ropes_read(rows, Vector3(0.0, 1.85, 0.0), [leaner, Vector3(1.0, 0.0, 0.0)])
	_check(read.size() == 2 and bool(read[3]["split"]) and int(read[3]["faded"]) == 2, "one rope with two alphas reads split (a rope cut in two)")
	_check(not bool(read[4]["split"]) and int(read[4]["faded"]) == 4 and not bool(read[4]["between"]), "a rope faded whole reads one alpha, and not between")


func _blur_pure() -> void:
	var lens := CameraAttributesPractical.new()
	lens.dof_blur_far_enabled = true
	lens.dof_blur_far_distance = 4.7
	lens.dof_blur_far_transition = 2.0
	lens.dof_blur_amount = 0.22
	_check(CamLine.far_blur(lens, 4.0) == 0.0 and absf(CamLine.far_blur(lens, 5.7) - 0.11) < 0.001 and absf(CamLine.far_blur(lens, 9.0) - 0.22) < 0.001,
		"the far blur read: none before its start, half way 0.11, full 0.22")


## A red disc on grey, then the same picture box-blurred `streak` px along x (what a motion blur does to a moving glove).
func _smear() -> void:
	var w := 400
	var h := 160
	var still := Image.create(w, h, false, Image.FORMAT_RGB8)
	for y in h:
		for x in w:
			var inside := Vector2(x - 200, y - 80).length() <= 30.0
			still.set_pixel(x, y, Color(0.8, 0.1, 0.1) if inside else Color(0.5, 0.5, 0.5))
	var streak := 40
	var moved := Image.create(w, h, false, Image.FORMAT_RGB8)
	for y in h:
		for x in w:
			var sum := Vector3.ZERO
			for k in range(-streak / 2, streak / 2):
				var c := still.get_pixel(clampi(x + k, 0, w - 1), y)
				sum += Vector3(c.r, c.g, c.b)
			sum /= streak
			moved.set_pixel(x, y, Color(sum.x, sum.y, sum.z))
	var same := CamLine.smear(still, still, Vector2(200, 80), Vector2.RIGHT)
	var blur := CamLine.smear(still, moved, Vector2(200, 80), Vector2.RIGHT)
	print("CAM_LINE_SMEAR crisp: glove %d px, smear %d px | streaked %d px: glove %d px, smear %d px, core %.2f" % [
		same["still_px"], same["smear_px"], streak, blur["still_px"], blur["smear_px"], blur["core"]])
	_check(absi(int(same["still_px"]) - 61) <= 2 and int(same["smear_px"]) == int(same["still_px"]), "no blur: the smear is the glove's own width (61 px)")
	# A 40 px box blur carries 15 % of the glove's colour 14 px past each edge: 61 + 28 = 89.
	_check(absi(int(blur["smear_px"]) - 89) <= 4, "a 40 px streak reads about 89 px (%d)" % int(blur["smear_px"]))
	_check(float(blur["smear_px"]) / float(blur["still_px"]) > CamLine.SMEAR_MAX, "that streak is over the %.1fx bar (the ruler can read red)" % CamLine.SMEAR_MAX)


## The game path: the ring's own ropes, the game's camera, clear_view as FightStage calls it.
func _ropes_game() -> void:
	var ropes := RingRopes.new()
	root.add_child(ropes)
	ropes.build(HALF, [0.45, 0.85, 1.25], func(_h: float) -> StandardMaterial3D: return StandardMaterial3D.new())
	var cam := RingCamera.new()
	root.add_child(cam)
	# Two who differ in where they stand: one leans on the east rope (0.06 m from it, RingPlace.ROPE_LEAN_M), one 1.1 m in.
	var a := Vector3(HALF - 0.06, 0.0, 0.3)
	var b := Vector3(HALF - 1.16, 0.0, 0.3)
	var mid := (a + b) * 0.5
	var inside_lens := Vector3(mid.x, 1.85, 0.3 - 2.65)   # side-on, inside the ropes (z -2.35)
	cam.look_at_from_position(inside_lens, mid + Vector3.UP * 0.95, Vector3.UP)
	cam.clear_view(ropes.segments, a, b, 0.0)
	var read := CamLine.ropes_read(CamLine.rope_rows(ropes.segments), inside_lens, [a, b])
	# The east side's ropes: ids 1, 5, 9 (RingRopes.build: per height, the four sides in order north, east, south, west).
	var split := 0
	for id in read:
		var r: Dictionary = read[id]
		if bool(r["split"]):
			split += 1
		if int(id) % 4 == 1:
			print("CAM_LINE_ROPE inside lens, the rope she leans on (id %d): %d of %d pieces faded, alpha %.2f..%.2f, between=%s" % [
				id, r["faded"], r["pieces"], r["lo"], r["hi"], r["between"]])
			_check(not bool(r["split"]), "the rope she leans on (id %d) has ONE alpha" % id)
			_check(not bool(r["between"]), "the ruler: that rope (id %d) is not between the inside lens and a boxer" % id)
			_check(int(r["faded"]) == 0, "GAME: from a lens inside the ropes, the rope she leans on (id %d) does not fade (%d of %d pieces faded)" % [id, r["faded"], r["pieces"]])
	_check(split == 0, "GAME: no rope of the ring is cut in two (%d ropes show two alphas)" % split)
	# The control: a lens OUTSIDE the ropes (a film shot's) - the north side is truly in the way and fades whole.
	var outside_lens := Vector3(mid.x, 0.8, -HALF - 3.0)   # low and well outside: all three ropes cross the boxers' bodies
	cam.look_at_from_position(outside_lens, mid + Vector3.UP * 0.95, Vector3.UP)
	cam.clear_view(ropes.segments, a, b, 0.0)
	read = CamLine.ropes_read(CamLine.rope_rows(ropes.segments), outside_lens, [a, b])
	var north_between := 0
	var north_faded := 0
	for id in [0, 4, 8]:
		north_between += 1 if bool(read[id]["between"]) else 0
		north_faded += 1 if int(read[id]["faded"]) == int(read[id]["pieces"]) else 0
	print("CAM_LINE_ROPE outside lens, the north side: %d of 3 ropes between the lens and a boxer, %d of 3 faded whole" % [north_between, north_faded])
	_check(north_between == 3, "the ruler: from outside, the north ropes are between the lens and the boxers (%d of 3)" % north_between)
	_check(north_faded == 3, "GAME: a rope truly in the way fades whole (%d of 3)" % north_faded)
	cam.queue_free()
	ropes.queue_free()


## The game path of the live lens: RingCamera.broadcast, 60 frames a second, while the pair turns on the spot as boxers
## do (a steady circle, a quick pivot), mid-ring and near a corner, at range and inside. The bodies are CamLine's test
## boxers (1.66 m orthodox, 1.80 m southpaw) standing where the pair stands.
func _lens_game() -> void:
	var drills := [
		["circle 14 deg/s, mid-ring, at range", Vector3.ZERO, 1.1, func(_t: float) -> float: return 14.0, 20.0],
		["circle 14 deg/s, mid-ring, inside", Vector3.ZERO, 0.7, func(_t: float) -> float: return 14.0, 20.0],
		["a 90 deg pivot in 1 s, mid-ring, inside", Vector3.ZERO, 0.7, func(t: float) -> float: return 90.0 if t >= 3.0 and t < 4.0 else 0.0, 9.0],
		["a 90 deg pivot in 1 s, near a corner, at range", Vector3(1.5, 0.0, 1.5), 1.1, func(t: float) -> float: return 90.0 if t >= 3.0 and t < 4.0 else 0.0, 9.0],
		["pivots back and forth, near the ropes, inside", Vector3(0.0, 0.0, 1.9), 0.7, func(t: float) -> float: return 70.0 * signf(sin(t * 1.6)), 16.0],
	]
	for d in drills:
		var cam := RingCamera.new()
		root.add_child(cam)
		var ang := 90.0
		var run := [0.0, 0.0]     # seconds now: hidden, behind
		var worst := [0.0, 0.0]
		var low := 180.0
		var frames := int(float(d[4]) * 60.0)
		for i in frames:
			ang += float((d[3] as Callable).call(i / 60.0)) / 60.0
			var u := Vector3(cos(deg_to_rad(ang)), 0.0, sin(deg_to_rad(ang)))
			var a: Vector3 = (d[1] as Vector3) - u * float(d[2]) * 0.5
			var b: Vector3 = (d[1] as Vector3) + u * float(d[2]) * 0.5
			cam.broadcast(a, b, i == 0, 1.0 / 60.0)
			var hid := CamLine.hidden_share(cam.global_transform, cam.fov, ASPECT, boxer(a, u, 1.66, false), boxer(b, -u, 1.80, true))
			var behind := TvShot.behind_deg(a, b, cam.global_position)
			low = minf(low, behind)
			for k in 2:
				var bad := hid >= CamLine.HIDDEN_AT if k == 0 else behind < CamLine.BEHIND_DEG
				run[k] = float(run[k]) + 1.0 / 60.0 if bad else 0.0
				worst[k] = maxf(float(worst[k]), float(run[k]))
		print("CAM_LINE_LENS %s: longest hidden %.2f s, longest under %.0f deg %.2f s, lowest behind %.0f deg, cuts %d" % [
			d[0], worst[0], CamLine.BEHIND_DEG, worst[1], low, cam.cuts])
		_check(float(worst[0]) < CamLine.HIDDEN_RUN_MAX_S, "GAME lens, %s: nobody HIDDEN for %.1f s or more (%.2f s)" % [d[0], CamLine.HIDDEN_RUN_MAX_S, worst[0]])
		_check(float(worst[1]) < CamLine.BEHIND_RUN_MAX_S, "GAME lens, %s: never along the pair for %.1f s or more (%.2f s)" % [d[0], CamLine.BEHIND_RUN_MAX_S, worst[1]])
		cam.queue_free()


## ---- Part B: a stand-in for FightStage (the camera's parent): `boxers` = [{skel, gclear}], as BoxerBuild returns them.
class Stage extends Node3D:
	var boxers: Array = []


class Layer extends SkeletonModifier3D:   # GloveClear's two reads
	var shown_hips := Vector3.INF
	var shown_head := Vector3.INF


const BONE_OF := {"head": "Head", "sh_l": "LeftUpperArm", "sh_r": "RightUpperArm", "el_l": "LeftLowerArm", "el_r": "RightLowerArm",
	"hand_l": "LeftHand", "hand_r": "RightHand", "hips": "Hips"}


func _stage() -> Stage:
	var stage := Stage.new()
	root.add_child(stage)
	for i in 2:
		var skel := Skeleton3D.new()
		stage.add_child(skel)
		for key in BONE_OF:
			skel.add_bone(BONE_OF[key])
		var layer := Layer.new()
		skel.add_child(layer)
		stage.boxers.append({"skel": skel, "gclear": layer})
	var cam := RingCamera.new()
	cam.name = "Cam"
	stage.add_child(cam)
	return stage


## Stands boxer `i` of `stage` as `body`; `layers` = the synthetic layers run (GloveClear keeps its reads fresh).
func _pose(stage: Stage, i: int, body: Dictionary, layers: bool) -> void:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	for key in BONE_OF:
		skel.set_bone_pose_position(skel.find_bone(BONE_OF[key]), body[key])
	var layer: Layer = stage.boxers[i]["gclear"]
	layer.active = layers
	if layers:
		layer.shown_hips = body["hips"]
		layer.shown_head = (body["head"] as Vector3) + Vector3.UP * CamLine.HEAD_UP_M * float(body["scale"])


## What FightStage._shown_at hands the lens: the hips as GloveClear last showed them, on the canvas.
static func _handed(stage: Stage, i: int) -> Vector3:
	var h: Vector3 = stage.boxers[i]["gclear"].shown_hips
	return Vector3(h.x, 0.0, h.z)


## The men's bout, round 2 t=17.5 (the operator's still): the pair turns through a captured step, RkPure has switched
## every layer off, and the hips handed to the lens stand where the step began. The lens must still see the turn.
func _captured_step() -> void:
	var stage := _stage()
	var cam: RingCamera = stage.get_node("Cam")
	var run := [0.0, 0.0]
	var worst := [0.0, 0.0]
	var ang := 90.0
	for i in 420:
		var t := i / 60.0
		var stepping := t >= 3.0
		if t >= 3.0 and t < 4.0:
			ang += 90.0 / 60.0
		var u := Vector3(cos(deg_to_rad(ang)), 0.0, sin(deg_to_rad(ang)))
		var a := boxer(-u * 0.55, u, 1.66, false)
		var b := boxer(u * 0.55, -u, 1.80, true)
		_pose(stage, 0, a, not stepping)
		_pose(stage, 1, b, not stepping)
		cam.broadcast(_handed(stage, 0), _handed(stage, 1), i == 0, 1.0 / 60.0)
		var hid := CamLine.hidden_share(cam.global_transform, cam.fov, ASPECT, a, b)
		var behind := TvShot.behind_deg(a["feet"], b["feet"], cam.global_position)
		for k in 2:
			var bad := hid >= CamLine.HIDDEN_AT if k == 0 else behind < CamLine.BEHIND_DEG
			run[k] = float(run[k]) + 1.0 / 60.0 if bad else 0.0
			worst[k] = maxf(float(worst[k]), float(run[k]))
	print("CAM_LINE_STEP a 90 deg turn through a captured step (the handed hips stand still): longest hidden %.2f s, longest under %.0f deg %.2f s, cuts %d, last cut: %s" % [
		worst[0], CamLine.BEHIND_DEG, worst[1], cam.cuts, cam.cut_why])
	_check(float(worst[1]) < CamLine.BEHIND_RUN_MAX_S, "GAME lens, a captured step: never along the pair for %.1f s or more (%.2f s)" % [CamLine.BEHIND_RUN_MAX_S, worst[1]])
	_check(float(worst[0]) < CamLine.HIDDEN_RUN_MAX_S, "GAME lens, a captured step: nobody HIDDEN for %.1f s or more (%.2f s)" % [CamLine.HIDDEN_RUN_MAX_S, worst[0]])
	stage.queue_free()


## The first bout, round 1 t=92 (a gut shot): the pair has turned 35 deg from the lens's side-on line, so the lens sits
## 61 deg off the 1.66 m boxer's back (past the camera's own "behind" lines, 58 and 50), and the 1.80 m southpaw folds
## in at the waist behind that back. From a side-on lens the fold shows.
static func _fold() -> Array:
	var u := Vector3(cos(deg_to_rad(35.0)), 0.0, sin(deg_to_rad(35.0)))
	var a := boxer(-u * 0.3, u, 1.66, false)
	var b := boxer(u * 0.3, -u, 1.80, true)
	for key in ["head", "sh_l", "sh_r", "el_l", "el_r", "hand_l", "hand_r"]:
		b[key] = (b[key] as Vector3) - u * 0.35 + Vector3.DOWN * 0.35
	return [a, b]


func _folded_behind() -> void:
	var pair := _fold()
	var a: Dictionary = pair[0]
	var b: Dictionary = pair[1]
	var look := Vector3.UP * 0.95
	var spot := Vector3(0, 1.85, -2.35)
	var perp := TvShot.side_on(a["feet"], b["feet"], spot)
	var hid_here := CamLine.hidden_share(lens_at(spot, look), 38.0, ASPECT, a, b)
	var hid_side := CamLine.hidden_share(lens_at(TvShot.clamp_in(perp * 3.1) + Vector3.UP * 1.85, look), 38.0, ASPECT, a, b)
	print("CAM_LINE_FOLD the ruler on the folded pair: from the lens (%.0f deg off a back) %.2f, from side-on %.2f" % [
		TvShot.behind_deg(a["feet"], b["feet"], spot), hid_here, hid_side])
	_check(hid_here >= CamLine.HIDDEN_AT and hid_side < CamLine.HIDDEN_AT, "the ruler: the folded boxer is HIDDEN from the lens (%.2f) and shows from side-on (%.2f)" % [hid_here, hid_side])
	# The live lens: three seconds side-on to the upright pair along world X (it stands on the -Z side), then the fold.
	var stage := _stage()
	var cam: RingCamera = stage.get_node("Cam")
	cam.global_position = spot
	var up_a := boxer(Vector3(-0.3, 0.0, 0.0), Vector3.RIGHT, 1.66, false)
	var up_b := boxer(Vector3(0.3, 0.0, 0.0), Vector3.LEFT, 1.80, true)
	var run := 0.0
	var worst := 0.0
	var first := 0.0
	for i in 360:
		var folded := i >= 180
		_pose(stage, 0, a if folded else up_a, true)
		_pose(stage, 1, b if folded else up_b, true)
		cam.broadcast(_handed(stage, 0), _handed(stage, 1), i == 0, 1.0 / 60.0)
		var hid := CamLine.hidden_share(cam.global_transform, cam.fov, ASPECT, a if folded else up_a, b if folded else up_b)
		if i == 181:
			first = hid
		run = run + 1.0 / 60.0 if hid >= CamLine.HIDDEN_AT else 0.0
		worst = maxf(worst, run)
	print("CAM_LINE_FOLD the live lens: hidden %.2f as the fold comes; longest hidden %.2f s; cuts %d, last cut: %s" % [first, worst, cam.cuts, cam.cut_why])
	_check(first >= CamLine.HIDDEN_AT, "control: the live lens saw the folded boxer HIDDEN (%.2f)" % first)
	_check(worst < CamLine.HIDDEN_RUN_MAX_S, "GAME lens: a boxer folded in behind the other is not HIDDEN for %.1f s or more (%.2f s)" % [CamLine.HIDDEN_RUN_MAX_S, worst])
	_check(cam.cut_why.begins_with("hidden"), "GAME lens: it left on a \"hidden\" cut (%s)" % cam.cut_why)
	# The close-up, asked for while the lens stands on the hiding spot: it must stand where both show. (Green on main
	# too: the old close-up took a side-on spot on a fixed side of the pair's line. It guards the side rule.)
	cam.global_position = spot
	cam.close_up(a["feet"], b["feet"], (a["head"] as Vector3).y, 0)
	var hid_close := CamLine.hidden_share(cam.global_transform, cam.fov, ASPECT, a, b)
	print("CAM_LINE_FOLD the close-up: lens at (%.2f, %.2f, %.2f), hidden %.2f" % [cam.global_position.x, cam.global_position.y, cam.global_position.z, hid_close])
	_check(hid_close < CamLine.HIDDEN_AT, "GAME close-up: nobody HIDDEN from where it stands (%.2f)" % hid_close)
	_check(cam.global_position.z < 0.0, "GAME close-up: on the lens's own side of the pair when both sides show them alike (z %.2f)" % cam.global_position.z)
	stage.queue_free()


## The lens numbers: the far rope behind the heads stays a rope (no far blur at it), the crowd's first row (2.85 m
## beyond the ropes, RingSet) is fully soft; and a cut's frame and the frames after it carry the same numbers.
func _far_lens() -> void:
	for spot in [Vector3.ZERO, Vector3(1.2, 0.0, 1.0), Vector3(-1.5, 0.0, 0.4)]:
		var cam := RingCamera.new()
		root.add_child(cam)
		var mid: Vector3 = spot
		var a := mid - Vector3.RIGHT * 0.55
		var b := mid + Vector3.RIGHT * 0.55
		var seen: Array = []
		for i in 90:
			cam.broadcast(a, b, i == 0, 1.0 / 60.0)
			var lens := cam.attributes as CameraAttributesPractical
			if i == 0 or i == 89:
				seen.append([lens.dof_blur_far_transition, lens.dof_blur_amount])
		var fwd := -cam.global_transform.basis.z
		var flat := Vector3(fwd.x, 0.0, fwd.z).normalized()
		# Where the lens's own line of sight leaves the ring: the far rope behind the pair.
		var t := INF
		for ax in [0, 2]:
			if absf(flat[ax]) > 0.001:
				t = minf(t, (HALF * signf(flat[ax]) - cam.global_position[ax]) / flat[ax])
		var rope := cam.global_position + flat * t
		rope.y = 1.25
		var row := cam.global_position + flat * (t + 2.85)
		row.y = 0.6
		var attr := cam.attributes as CameraAttributesPractical
		var at_rope := CamLine.far_blur(attr, cam.global_position.distance_to(rope))
		var at_row := CamLine.far_blur(attr, cam.global_position.distance_to(row))
		print("CAM_LINE_FAR pair at %s: far blur at the rope behind the heads %.3f (%.2f m away), at the crowd's first row %.3f, full %.2f" % [
			mid, at_rope, cam.global_position.distance_to(rope), at_row, attr.dof_blur_amount])
		_check(at_rope == 0.0, "GAME lens, pair at %s: no far blur at the rope behind the heads (%.3f)" % [mid, at_rope])
		_check(at_row >= 0.999 * attr.dof_blur_amount, "GAME lens, pair at %s: the crowd's first row is fully soft (%.3f)" % [mid, at_row])
		_check(seen[0] == seen[1], "GAME lens, pair at %s: the cut's frame and the held frames carry the same far blur numbers (%s, %s)" % [mid, seen[0], seen[1]])
		cam.queue_free()


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		failures += 1
