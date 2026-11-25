extends RefCounted
## PICSFIX1 (S543, owner on two pictures of "Watch it in pictures": "why fighters are entagled like that on the left and
## on the right the punch does not touch the opponent", then "Yes, fix them now"; task ops/research/TASK_PICSFIX1.md):
## the gate tools/pics2d_set.gd runs on the posed pair at the frame it saves. A picture that fails is not written.
##   apart_m  the smallest distance between the two torsos: the Hips-Spine-Chest-UpperChest-Neck bone chain of each as a
##            line (a capsule's axis), never the roots - a leaning puncher's chest sat inside the other boxer's at 0.40 m
##            between the roots. Bar APART_MIN_M, measured on the pictures that read clean (docs/PICSFIX1_RESULT.md).
##   landed   hit_m: the glove's front within LAND_M of the target point, and near_m: the glove on the puncher's side of
##            the head (the body for a body shot) - a hook's glove never ends behind the head, a straight never through it.
##   blocked  block_m: the glove's front within BLOCK_M of the defender's glove (its padding: the centre less the glove's
##            front reach) or her forearm (the LowerArm-Hand bone line less FOREARM_R).
##   missed   clear of the head by MISS_PX_M and of both her gloves by MISS_HAND_M on the picture, and apart_m.
##   clinch   chest to chest (CLINCH_CHEST_M at most between the Chest bones), heads beside each other (HEAD_APART_M at
##            least, no head inside a head), no arm through a torso (ARM_OFF_M at least from the other torso's line), apart_m.

const TORSO := ["Hips", "Spine", "Chest", "UpperChest", "Neck"]
const TRUNK := ["Hips", "Spine", "Chest", "UpperChest"]   # the clinch: heads and necks side by side are the hold itself
const APART_MIN_M := 0.60      # the S540 pictures that read clean: 0.63-1.35; the tangled body hooks: 0.54-0.60
const APART_PIC_MIN_M := 0.60
const CLINCH_APART_M := 0.22   # the clinch: chest on chest, never inside (an ESTIMATE: two chest fronts ~0.11 before the spine line)
const CLINCH_FEET_M := 0.0     # the clinch: no foot past the other's
const LAND_M := 0.04
const NEAR_MIN_M := 0.03
const BLOCK_M := 0.05
const FOREARM_R := 0.04
const FEET_MIN_M := 0.16      # nearest foot bones along the line (the boots reach ~0.08 past each); clean >= 0.16, crossed <= 0.14
const HEAD_CLEAR_M := 0.60    # a head's bone to the other's trunk line and head: clean pictures 0.64-1.30, the crowded body hooks 0.45-0.60
const FEET := ["LeftFoot", "RightFoot", "LeftToes", "RightToes"]
const MISS_PX_M := 0.20
const MISS_HAND_M := 0.14
## C508 (S554, owner on the missed hook: "aims too high i think and too far away from the head"): a hook that misses is
## a NEAR miss - on the picture the glove clears his face by a hand's width, and by no more than MISS_NEAR_MAX_M
const MISS_NEAR_MIN_M := 0.13
const MISS_NEAR_MAX_M := 0.24
const MISS_NEAR_HAND_M := 0.21   # ... and his WRISTS by this much: at 0.14 the two gloves overlapped on the picture and it read as a block
const MISS_NEAR_GOOD_M := 0.19   # the search stops at the first staging this near
const CLINCH_CHEST_M := 0.50
const HEAD_APART_M := 0.15     # head bone to head bone: one head breadth (ANSUR II means: men 0.155 m, women 0.147 m) - cheek to cheek, never inside
const ARM_OFF_M := 0.07


static func world(stage: Node3D, i: int, bone: String) -> Vector3:
	var sk: Skeleton3D = stage.boxers[i]["skel"]
	var b := sk.find_bone(bone)
	if b < 0:
		return Vector3.INF
	return sk.global_transform * sk.get_bone_global_pose(b).origin


## The bones' world points in order; flattened onto the picture's plane when `view` (the camera's look) is given.
static func chain(stage: Node3D, i: int, bones: Array, view := Vector3.ZERO) -> Array:
	var out: Array = []
	for b in bones:
		var p := world(stage, i, str(b))
		if p.is_finite():
			out.append(p - view * p.dot(view))
	return out


## Closest distance between two bone chains (polylines).
static func chain_dist(a: Array, b: Array) -> float:
	var best := INF
	for i in a.size() - 1:
		for j in b.size() - 1:
			var c := Geometry3D.get_closest_points_between_segments(a[i], a[i + 1], b[j], b[j + 1])
			best = minf(best, c[0].distance_to(c[1]))
	return best


static func apart_m(stage: Node3D, view := Vector3.ZERO, bones: Array = TORSO) -> float:
	return chain_dist(chain(stage, 0, bones, view), chain(stage, 1, bones, view))


static func _r(v: float) -> float:
	return snappedf(v, 0.001)


## How near the glove front is to boxer d's guard: her two gloves' padding and her two forearms. [metres, what]
static func block_m(stage: Node3D, who: int, hand: String) -> Array:
	var d := 1 - who
	var f: Vector3 = stage.glove_front(who, hand)
	var pad: float = float(stage.boxers[d]["front"]) * float(stage._scale(d))
	var gl: Dictionary = (stage.boxers[d]["gloves"] as Node).gloves
	var best := [INF, ""]
	for s in ["Left", "Right"]:
		var g: Vector3 = (gl["l" if s == "Left" else "r"] as Node3D).global_position
		var m := maxf(0.0, f.distance_to(g) - pad)
		if m < best[0]:
			best = [m, s.to_lower() + " glove"]
		var e := world(stage, d, s + "LowerArm")
		var w := world(stage, d, s + "Hand")
		var fa := maxf(0.0, f.distance_to(Geometry3D.get_closest_point_to_segment(f, e, w)) - FOREARM_R)
		if fa < best[0]:
			best = [fa, s.to_lower() + " forearm"]
	return best


## The gate on a punch picture. dirv: from the puncher toward the target; px: world -> picture pixels; ppm: pixels a metre.
static func punch(stage: Node3D, who: int, hand: String, res: String, body: bool, dirv: Vector3, px: Callable, ppm: float, view: Vector3) -> Dictionary:
	var d := 1 - who
	var g: Vector3 = stage.glove_front(who, hand)
	var tgt: Vector3 = stage.v2.target(d, body)
	var m := {"hit_m": _r(g.distance_to(tgt))}
	var fails := _apart(stage, view, m)
	if res == "landed":
		var c := world(stage, d, "Chest" if body else "Head")
		m["near_m"] = _r((c - g).dot(dirv))
		if m["hit_m"] > LAND_M:
			fails.append("hit_m %.3f > %.2f" % [m["hit_m"], LAND_M])
		if m["near_m"] < NEAR_MIN_M:
			fails.append("near_m %.3f < %.2f (the glove past the %s)" % [m["near_m"], NEAR_MIN_M, "body" if body else "head"])
	elif res == "blocked":
		var b := block_m(stage, who, hand)
		m["block_m"] = _r(b[0])
		m["block_on"] = b[1]
		if b[0] > BLOCK_M:
			fails.append("block_m %.3f > %.2f" % [b[0], BLOCK_M])
	else:
		var gp: Vector2 = px.call(g)
		var head_px := gp.distance_to(px.call(tgt)) / ppm
		var hand_px := INF
		for hb in ["LeftHand", "RightHand"]:
			hand_px = minf(hand_px, gp.distance_to(px.call(world(stage, d, hb))) / ppm)
		m["clear_m"] = _r(head_px)
		m["clear_hand_m"] = _r(hand_px)
		if head_px < MISS_PX_M - 0.005:
			fails.append("clear_m %.3f < %.2f" % [head_px, MISS_PX_M])
		if hand_px < MISS_HAND_M - 0.005:
			fails.append("clear_hand_m %.3f < %.2f" % [hand_px, MISS_HAND_M])
	m["fails"] = fails
	return m


## The gate on the clinch picture.
static func clinch(stage: Node3D, view: Vector3) -> Dictionary:
	var m := {"chest_m": _r(world(stage, 0, "Chest").distance_to(world(stage, 1, "Chest"))),
		"head_m": _r(world(stage, 0, "Head").distance_to(world(stage, 1, "Head")))}
	var arm := INF
	for i in 2:
		var torso := chain(stage, 1 - i, TRUNK)
		for s in ["Left", "Right"]:
			arm = minf(arm, chain_dist(chain(stage, i, [s + "UpperArm", s + "LowerArm", s + "Hand"]), torso))
	m["arm_m"] = _r(arm)
	var fails := _apart(stage, view, m, true)
	if m["chest_m"] > CLINCH_CHEST_M:
		fails.append("chest_m %.3f > %.2f (not chest to chest)" % [m["chest_m"], CLINCH_CHEST_M])
	if m["head_m"] < HEAD_APART_M:
		fails.append("head_m %.3f < %.2f (a head inside a head)" % [m["head_m"], HEAD_APART_M])
	if arm < ARM_OFF_M:
		fails.append("arm_m %.3f < %.2f (an arm through a torso)" % [arm, ARM_OFF_M])
	m["fails"] = fails
	return m


## Both torso measures into m: apart_m in the ring, apart_pic_m on the picture (the two chains flattened along the camera's
## look - a body beside a body in depth still reads as one body through the other). Returns the fails list begun.
static func _apart(stage: Node3D, view: Vector3, m: Dictionary, held := false) -> Array:
	var line := Vector3.ZERO
	var bones: Array = TRUNK if held else TORSO
	m["apart_m"] = _r(apart_m(stage, Vector3.ZERO, bones))
	m["apart_pic_m"] = _r(apart_m(stage, view.normalized(), bones))
	if line == Vector3.ZERO:   # red -> blue
		line = world(stage, 1, "Hips") - world(stage, 0, "Hips")
		line = Vector3(line.x, 0.0, line.z).normalized()
	var front := -INF
	var back := INF
	for b in FEET:
		var p := world(stage, 0, b)
		var q := world(stage, 1, b)
		if p.is_finite():
			front = maxf(front, p.dot(line))
		if q.is_finite():
			back = minf(back, q.dot(line))
	m["feet_m"] = _r(back - front)
	var hd := INF
	for i in 2:   # a head to the other's trunk and head (the clinch: to the other's head only - cheek by cheek is the hold)
		var h := [world(stage, i, "Head"), world(stage, i, "Head")]
		hd = minf(hd, chain_dist(h, chain(stage, 1 - i, ["Head", "Head"] if held else TORSO + ["Head"])))
	m["head_clear_m"] = _r(hd)
	var fails: Array = []
	# the clinch from the side: the two trunks always cover each other on the picture (chest to chest, heads side by side,
	# one body a little in front of the other) - its picture bar is off; the ring distance holds it
	var bars := [CLINCH_APART_M, -INF, CLINCH_FEET_M, HEAD_APART_M] if held else [APART_MIN_M, APART_PIC_MIN_M, FEET_MIN_M, HEAD_CLEAR_M]
	if m["apart_m"] < bars[0]:
		fails.append("apart_m %.3f < %.2f" % [m["apart_m"], bars[0]])
	if m["apart_pic_m"] < bars[1]:
		fails.append("apart_pic_m %.3f < %.2f (on the picture)" % [m["apart_pic_m"], bars[1]])
	if m["feet_m"] < bars[2]:
		fails.append("feet_m %.3f < %.2f (feet crossed)" % [m["feet_m"], bars[2]])
	if hd < bars[3]:
		fails.append("head_clear_m %.3f < %.2f (a head in the other body)" % [hd, bars[3]])
	return fails


## Set dressing for the tool: only the two boxers and their kit (ring, ropes, crowd, corner team, props hidden, the sky off).
static func clean_set(stage: Node3D, mine_nodes: Array) -> void:
	for n in stage.find_children("*", "VisualInstance3D", true, false):
		var mine := false
		for b in mine_nodes:
			if (b as Node).is_ancestor_of(n) or n == b:
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


static func show_all(n: Node) -> void:
	if n is Node3D:
		(n as Node3D).visible = true
	for ch in n.get_children():
		show_all(ch)


## Fallback framing (S540): the same side camera, centred on the outermost head/hands/toes and widened just enough.
static func fit(stage: Node3D, cam: Camera3D, who: Array, ortho: float) -> void:
	var right := cam.global_transform.basis.x
	var lo := INF
	var hi := -INF
	for i in who:
		for b in ["Head", "LeftToes", "RightToes", "LeftHand", "RightHand"]:
			var d := world(stage, i, b).dot(right)
			lo = minf(lo, d)
			hi = maxf(hi, d)
	var shift := right * ((lo + hi) * 0.5 - cam.global_position.dot(right))
	cam.global_position += shift
	cam.size = maxf(ortho, (hi - lo) + 0.5)


static func framed(stage: Node3D, cam: Camera3D, who: Array, size: int) -> Array:
	var bad: Array = []
	for i in who:
		for p in [["Head", 0.14], ["LeftToes", -0.06], ["RightToes", -0.06], ["LeftHand", 0.0], ["RightHand", 0.0]]:
			var s := cam.unproject_position((world(stage, i, str(p[0])) + Vector3.UP * float(p[1])))
			if s.x < 4.0 or s.x > size - 4.0 or s.y < 4.0 or s.y > size - 4.0:
				bad.append("%s %s at %s" % [["red", "blue"][i], str(p[0]), str(s.round())])
	return bad
