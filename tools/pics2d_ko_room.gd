extends RefCounted
## KDPIC1 (S566, ops/research/TASK_KDPIC1.md; S563 digest "Not done": "The knockdown picture pushes the man off the ring's
## left edge"). The knockdown take (pro_knockout_v1) lays the hit man flat on his back, 1.6-1.8 m from his spot to his
## head, straight back along the ring line. The page draws every picture slid to where the men really stand (ring_ui.js
## slide), a man may stand up to two steps back past his Long spot (ring_ui.js fit: redIn / blueIn >= -2, "on the ropes"),
## and the page's stage shows only the middle of the ring (order.html .stage: at 1920x1080 it is 1078 x 646 px, the
## picture 126% of its height = +-2.09 m about the picture's middle; the ropes are at +-2.7 m). From the ropes spot he has
## 0.87 m of stage behind him: the fall left the stage (and, cut less, the ring).
## The rules, measured on the take as it plays (frame()), then fitted (fit()) and put on each picture (apply()):
##   - every bone stays INSIDE_M inside the ring's edge (the game's own rule, scripts/fight3d/KnockdownRing.gd S390, with
##     the picture's margin) were he standing BACK_M further back, and WIN_MARGIN_M inside the stage's edge from his own
##     spot (WIN_BACK_M);
##   - first he TURNS as he goes down (a fall is not a straight line): his body is turned about his own spot, away from the
##     camera, by the smallest angle (YAW_STEP steps) that leaves at most SHARE_MAX of his travel to cut - his feet stay
##     where he stood and he lies across the ring's depth, the head toward the far ropes;
##   - what is still past the lines is cut from his travel, one share of his hips' travel on every frame, so he falls the
##     way the take falls, only less far (a cut held at the line slid his feet back toward the puncher, S566 smoke).
## Both grow with his hips' travel from the contact (0 there): no jump from the landed run.

const KnockdownRing := preload("res://scripts/fight3d/KnockdownRing.gd")
const BACK_M := 2.0 * 0.355   # two step takes (ring_ui.js STEP_M) behind his Long spot: the page's furthest-back spot
const ROPE_TOP_M := 1.25      # RingSet: the top rope
## The game's KnockdownRing.INSIDE_M (0.35) keeps a downed man off the ropes for the count; a picture only needs him
## inside them ("a fall back to the ropes is real"): the bones this far in (the skull and the gloves past the bone).
const INSIDE_M := 0.20
const WIN_HALF_PX := 508.6    # the stage's half width in render px (768 high): 1078 / 2 / (646 * 1.26 / 768)
const WIN_MARGIN_M := 0.20    # a bone this far inside the stage's edge (the skull, the glove past the bone)
## The stage window is held from his OWN spot, not BACK_M back: from the ropes spot the page draws even the standing man at
## the stage's edge (S566 beat_shot "on the ropes"), and no fall fits there (measured: 1.0-1.3 m past it whatever the
## turn or the cut). Showing that needs the page to follow the man (not this brief's to change: docs/KDPIC1_RESULT.md).
const WIN_BACK_M := 0.0
const YAW_STEP := 5.0
const YAW_MAX := 85.0
const SHARE_MAX := 0.15   # the cut carries him back toward the puncher: at 0.30 his boots ended on the puncher's front boot (S566 smoke3)
const FEET := ["LeftFoot", "RightFoot", "LeftToes", "RightToes"]
## OFF (0): his feet kept this far (flat) from the other man's feet by carrying him toward the ring's far side. Tried in
## S566 at 0.25 m for the hooks (thrown from 0.54-0.58 m in, the take's legs reach forward as he goes down): it hit its cap
## (100% of his travel) and put his raised boots against the puncher's thigh on the picture; with it off his boots end
## behind the puncher's front boot (smoke8). Kept for a later take whose legs do not lift.
const FEET_CLEAR_M := 0.0
const BONES := ["Head", "Hips", "LeftHand", "RightHand", "LeftFoot", "RightFoot", "LeftToes", "RightToes", "Neck", "LeftShoulder", "RightShoulder"]


static func ring(stage: Node3D) -> Node3D:
	return stage.find_child("RingSet", true, false) as Node3D


## His hips along `away` (flat), m: the fall's travel is measured on them.
static func hips_along(stage: Node3D, i: int, away: Vector3) -> float:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var bi := skel.find_bone("Hips")
	return ((skel.global_transform * skel.get_bone_global_pose(bi).origin) * Vector3(1, 0, 1)).dot(away) if bi >= 0 else 0.0


## One frame of the take as it plays: his root, his bones, his hips' travel from `h0` (the contact).
static func frame(stage: Node3D, i: int, away: Vector3, h0: float) -> Dictionary:
	return {"o": (stage.boxers[i]["node"] as Node3D).global_position, "pts": _pts(stage, i, BONES), "feet": _pts(stage, i, FEET),
		"other": _pts(stage, 1 - i, FEET), "trav": maxf(0.0, hips_along(stage, i, away) - h0)}


static func _pts(stage: Node3D, i: int, names: Array) -> Array:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var out: Array = []
	for b in names:
		var bi := skel.find_bone(str(b))
		if bi >= 0:
			out.append(skel.global_transform * skel.get_bone_global_pose(bi).origin)
	return out


## How far (m, along `away`) the furthest of `pts` stands past the ring's line or the stage's edge, were he BACK_M further back.
static func over(stage: Node3D, cam: Camera3D, pts: Array, away: Vector3) -> float:
	var rs := ring(stage)
	var worst := -INF
	var inv := rs.global_transform.affine_inverse() if rs != null else Transform3D()
	var a := (inv.basis * away * Vector3(1, 0, 1)).normalized()
	var lim := float(rs.get("RING_M")) * 0.5 - INSIDE_M if rs != null else INF
	var mid := cam.get_viewport().get_visible_rect().size.x * 0.5
	var ppm := (cam.unproject_position(Vector3.ZERO + away) - cam.unproject_position(Vector3.ZERO)).x   # px a metre along away (signed)
	var win := WIN_HALF_PX * cam.get_viewport().get_visible_rect().size.y / 768.0
	for p in pts:
		var q: Vector3 = p + away * BACK_M
		worst = maxf(worst, ((inv * q) * Vector3(1, 0, 1)).dot(a) - lim)
		var x := cam.unproject_position(p + away * WIN_BACK_M).x - mid   # px from the stage's middle, + = the way he falls
		worst = maxf(worst, x * signf(ppm) / absf(ppm) - (win / absf(ppm) - WIN_MARGIN_M))
	return worst


## The share of his travel to cut so a frame that stands `over_m` past the lines, `trav` m into the fall, is on them.
static func cut(over_m: float, trav: float) -> float:
	if over_m <= 0.0:
		return 0.0
	return 1.0 if trav < 0.05 else minf(1.0, over_m / trav)


## The turn (radians, about UP, signed away from the camera) and the share of travel cut that keep every frame inside.
static func fit(stage: Node3D, cam: Camera3D, away: Vector3, frames: Array) -> Dictionary:
	var fwd := -cam.global_transform.basis.z * Vector3(1, 0, 1)
	var sgn := signf(Vector3.UP.cross(away).dot(fwd))   # turning by +angle * sgn swings `away` toward the far side
	var tmax := 0.01
	for f in frames:
		tmax = maxf(tmax, float(f["trav"]))
	# where he already stands on the contact picture is not the fall's doing: the fall may not take him further out than that
	var base := maxf(0.0, over(stage, cam, frames[0]["pts"], away)) if not frames.is_empty() else 0.0
	var best := {}
	var deg := 0.0
	while deg <= YAW_MAX + 0.01:
		var yaw := deg_to_rad(deg) * sgn
		var share := 0.0
		for f in frames:
			var w := clampf(float(f["trav"]) / tmax, 0.0, 1.0)
			var o: Vector3 = f["o"]
			var pts: Array = (f["pts"] as Array).map(func(p) -> Vector3: return o + (p - o).rotated(Vector3.UP, yaw * w))
			share = maxf(share, cut(over(stage, cam, pts, away) - base, float(f["trav"])))
			if OS.get_cmdline_user_args().has("ko_debug") and int(deg) % 15 == 0:
				print("KO_DEBUG deg %d trav %.3f over %.3f base %.3f -> share %.2f" % [int(deg), float(f["trav"]), over(stage, cam, pts, away), base, share])
		if best.is_empty() or share < float(best["share"]) - 0.001:
			best = {"yaw": yaw, "share": share, "tmax": tmax, "deg": deg, "base_m": base}
		if share <= SHARE_MAX:
			break
		deg += YAW_STEP
	# the feet: what is short of FEET_CLEAR_M after the turn and the cut, as a share of his travel, carried to the far side
	var far := (fwd - away * fwd.dot(away)).normalized()
	var side := 0.0
	var gap0 := INF   # how near the feet already are on the contact picture (the punch stands him there): not the fall's doing
	if not frames.is_empty():
		for p in frames[0]["feet"]:
			for r in frames[0]["other"]:
				gap0 = minf(gap0, ((p - r) * Vector3(1, 0, 1)).length())
	var clear := minf(FEET_CLEAR_M, gap0)
	for f in frames:
		var w := clampf(float(f["trav"]) / tmax, 0.0, 1.0)
		var o: Vector3 = f["o"]
		var lack := 0.0
		for p in f["feet"]:
			var q: Vector3 = o + (p - o).rotated(Vector3.UP, float(best["yaw"]) * w) - away * float(best["share"]) * float(f["trav"])
			for r in f["other"]:
				lack = maxf(lack, clear - ((q - r) * Vector3(1, 0, 1)).length())
		side = maxf(side, cut(lack, float(f["trav"])) if lack > 0.0 else 0.0)
	best["far"] = far
	best["side"] = side
	best["gap0"] = gap0
	return best


## The fit put on the man as he is posed now (`f` = frame() of this pose): turned about his spot, carried back by the share.
static func apply(stage: Node3D, i: int, away: Vector3, fit_r: Dictionary, f: Dictionary) -> void:
	var node: Node3D = stage.boxers[i]["node"]
	var w := clampf(float(f["trav"]) / float(fit_r["tmax"]), 0.0, 1.0)
	var o := node.global_position
	node.global_transform = Transform3D(Basis(Vector3.UP, float(fit_r["yaw"]) * w) * node.global_transform.basis, o)
	node.global_position = o - away * float(fit_r["share"]) * float(f["trav"]) + fit_r.get("far", Vector3.ZERO) * float(fit_r.get("side", 0.0)) * float(f["trav"])


## The ring inside the ropes as the picture sees it: its four corners on the canvas and at the top rope, in picture px
## (the camera's own viewport, so a wide picture gets wide px). tools/ko_room_check.py tests the mask pixels against it.
static func ring_px(stage: Node3D, cam: Camera3D) -> Array:
	var rs := ring(stage)
	var out: Array = []
	if rs == null:
		return out
	var h := float(rs.get("RING_M")) * 0.5
	for y in [0.0, ROPE_TOP_M]:
		for c in [Vector3(-h, y, -h), Vector3(h, y, -h), Vector3(h, y, h), Vector3(-h, y, h)]:
			var p := cam.unproject_position(rs.global_transform * c)
			out.append([snappedf(p.x, 0.1), snappedf(p.y, 0.1)])
	return out


## One metre along `away` in picture px (the page's slide of a man stood further back).
static func metre_px(stage: Node3D, cam: Camera3D, away: Vector3) -> Array:
	var o: Vector3 = (stage.boxers[0]["node"] as Node3D).global_position
	var d := cam.unproject_position(o + away) - cam.unproject_position(o)
	return [snappedf(d.x, 0.01), snappedf(d.y, 0.01)]
