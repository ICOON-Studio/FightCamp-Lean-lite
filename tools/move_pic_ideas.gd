extends RefCounted
## MOVEPICS1 r2 (S381 art review: "step pictures all alike; the move's idea not shown") - the boxing cards whose clip
## alone does not say the move, each composed as its own picture on the same ink layers (tools/bake_move_pics.gd `t`):
##   feint     - her lead shoulder dips into half a jab; Maria flinches, guard up and back from where she stood
##   cut_off   - Maria slides along the ropes for the exit; Lucy steps across that line first
##   pivot_out - her back on the ropes, she turns on the lead foot: the gold arc runs round the front foot
##   spins_out - in the corner Lucy turns the pair: Maria is spun in to where Lucy's back was
##   push_off  - two gloves on Maria's chest, Maria shoved back out of the tie-up
##   roll_out  - under Maria's hook (faint), then up and out to the side (solid), the head's path through both
##   has(id) -> bool   shot(t, id, spec) -> the card's layers, focus, arrows and row   reach(t, bx, hand, tip) -> arm IK

const Specs := preload("res://tools/move_pic_specs.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const SPS := preload("res://tools/session_pic_style.gd")

const IDS := ["feint"]   # S383 r3: cut_off, pivot_out -> move_pic_ideas2.gd; r4: spins_out, push_off, roll_out -> ideas3
const FEINT_AT := 0.5         # of the jab's reach: the shoulder has dipped in, the glove half out - and no further
const FEINT_GAP := 1.30       # m pelvis to pelvis: outside her reach, close enough to read on a card
const FLINCH_BACK := 0.16     # m Maria's flinch takes her back
const PIVOT_DEG := 95.0
const SPIN_DEG := 160.0       # nearly a half turn: Maria ends where Lucy's back was, by the post
const CUT_GAP := 1.05        # m from Lucy's line to Maria's, square to the ropes
const CUT_HER_X := 0.42       # m: where Lucy's step lands, towards the open side (+X)
const CUT_M_X := -0.70        # m: Maria's start, on the closed side
const CUT_M_RUN := 0.26       # m Maria has slid along the ropes (her solid figure)
const PUSH_BACK := 0.26       # m the push moved Maria back (her faint figure is that much closer)
const PUSH_GAP := 0.70        # m pelvis to pelvis at the push's full reach: arms long, Maria a step off (S383: at 0.47 the
                              # pair read as a clinch hug; the arm reach lands closer the straighter the arm)
const CHEST_FRONT := 0.12     # m from the chest bone to the front of her chest, where the gloves are
const ROLL_OUT := Vector3(0.30, 0.0, -0.34)   # m from under the hook to where she comes up: outside it, and away
const ARC_STEPS := 16
const CAM := {"feint": [-74.0, 6.0], "cut_off": [-168.0, 26.0], "pivot_out": [-58.0, 30.0], "spins_out": [-62.0, 22.0],
	"push_off": [-80.0, 6.0], "roll_out": [-118.0, 10.0]}


static func has(id: String) -> bool:
	return IDS.has(id)


static func shot(t, id: String, s: Dictionary) -> Dictionary:
	s["az"] = CAM[id][0]
	s["elev"] = CAM[id][1]
	var out: Dictionary = {}
	match id:
		"feint":
			out = _feint(t)
		"cut_off":
			out = _cut_off(t)
		"pivot_out":
			out = _pivot_out(t)
		"spins_out":
			out = _spins_out(t)
		"push_off":
			out = _push_off(t)
		"roll_out":
			out = _roll_out(t)
	var base := {"kind": "idea", "az": s["az"], "elev": s["elev"], "idea": id}
	var extra: Dictionary = out.get("measure", {})
	var fn: Callable = out.get("measure_fn", Callable())
	out["row"] = func() -> Dictionary:
		var r := base.duplicate()
		r.merge(fn.call() if fn.is_valid() else extra)
		return r
	if not out.has("ropes"):
		out["ropes"] = ""
		out["ppos"] = Vector3.ZERO
	return out


static func _her(pose: Dictionary, pos := Vector3.ZERO, rot := 0.0, alpha := 1.0) -> Dictionary:
	return {"who": "her", "pose": pose, "pos": pos, "rot": rot, "alpha": alpha}


static func _spar(pose: Dictionary, pos: Vector3, rot := PI, alpha := 1.0, props := false) -> Dictionary:
	return {"who": "spar", "pose": pose, "pos": pos, "rot": rot, "alpha": alpha, "props": props}


static func _p(clip: String, at: float) -> Dictionary:
	return {"clip": clip, "t": at}


## The point of `pos` turned `ang` (rad, about +Y) round `pivot`.
static func _turn(pos: Vector3, pivot: Vector3, ang: float) -> Vector3:
	return pivot + (pos - pivot).rotated(Vector3.UP, ang)


static func _arc(t, centre: Vector3, from: Vector3, ang: float, y: float) -> Array:
	var pts: Array = []
	t._img_size = Vector2(t.CARD, t.CARD)
	for i in ARC_STEPS + 1:
		var w := _turn(from, centre, ang * float(i) / float(ARC_STEPS))
		w.y = y
		pts.append(t._px(w))
	return pts


static func _line(t, a: Vector3, b: Vector3) -> Array:
	t._img_size = Vector2(t.CARD, t.CARD)
	var pts: Array = []
	for i in 9:
		pts.append(t._px(a.lerp(b, float(i) / 8.0)))
	return pts


# ---------------------------------------------------------------- the cards -------------------------------------------------

## Half a jab: the lead shoulder dips and the glove starts out; Maria's guard comes up and she rocks back from her mark.
static func _feint(t) -> Dictionary:
	var c := Specs.contact(t._her, "pro_left_jab")
	# The instant the glove is FEINT_AT of the way (in distance, not time: the jab's start is a slow load) to contact.
	t._pose(t._her, _p("pro_left_jab", 0.0), Vector3.ZERO)
	var g0: Vector3 = t._glove_tip(t._her, "LeftHand")
	t._pose(t._her, _p("pro_left_jab", c), Vector3.ZERO)
	var reach: float = (t._glove_tip(t._her, "LeftHand") as Vector3).distance_to(g0)
	var at_t := c
	var u := 0.0
	while u < c:
		t._pose(t._her, _p("pro_left_jab", u), Vector3.ZERO)
		if (t._glove_tip(t._her, "LeftHand") as Vector3).distance_to(g0) >= reach * FEINT_AT:
			at_t = u
			break
		u += 1.0 / 60.0
	var fin := _p("pro_left_jab", at_t)
	var flinch := _p("pro_idle_to_block", Specs.clip_len(t._spar, "pro_idle_to_block") * 0.85)
	var at := Vector3(0.0, 0.0, FEINT_GAP)
	var back := at + Vector3(0.0, 0.0, FLINCH_BACK)
	var layers := [_spar(_p("pro_idle", 0.0), at, PI, SPS.GHOST * 0.8), _spar(flinch, back, PI, 1.0, true),
		_her(_p("pro_idle", 0.0), Vector3.ZERO, 0.0, SPS.GHOST), _her(fin)]
	var arrows := [func() -> Array:
		var pts: Array = []
		t._img_size = Vector2(t.CARD, t.CARD)
		var w := 0.0
		while w <= fin["t"]:
			t._pose(t._her, _p("pro_left_jab", w), Vector3.ZERO)
			pts.append(t._px(t._glove_tip(t._her, "LeftHand")))
			w += t.STEP_DT
		return pts]
	return {"layers": layers, "focus": Vector3(0.0, 0.92, FEINT_GAP * 0.5), "arrows": arrows,
		"measure": {"clip": "pro_left_jab", "t": snappedf(fin["t"], 0.001), "partner": "pro_idle_to_block", "arrow": "LeftHand"}}


## Maria slides along the ropes for the open side; Lucy's step across lands first, square in that lane.
## S383 (review: "the move's idea not shown"): seen from behind Lucy, a little high - the ropes run across the card
## behind Maria, Maria's way out is a gold line along them, and Lucy's solid figure stands at its end, a clear body's
## width to the open side of Maria (r2 had the two bodies on top of each other).
static func _cut_off(t) -> Dictionary:
	var st: Array = Specs.stride(t._her, "strafe_left")
	var travel: Vector3 = st[2]
	var fin := _p("strafe_left", st[0])
	var her_at := Vector3(CUT_HER_X, 0.0, 0.0)
	var ms: Array = Specs.stride(t._spar, "strafe_right")
	var m_at := Vector3(CUT_M_X, 0.0, CUT_GAP)
	var m_to := m_at + Vector3(CUT_M_RUN, 0.0, 0.0)
	var layers := [_spar(_p("pro_idle", 0.0), m_at, PI, SPS.GHOST * 0.8), _spar(_p("strafe_right", ms[0]), m_to, PI, 1.0, true),
		_her(_p("strafe_left", 0.0), her_at - travel, 0.0, SPS.GHOST), _her(fin, her_at)]
	_ropes_x(t, m_at.z + 0.46, 0.0)
	# Two arrows on the floor: Maria's way out along the ropes (it ends in Lucy's lane), and Lucy's step across.
	var step_arrow := func() -> Array:
		t._pose(t._her, fin, her_at)
		var foot: String = st[1]
		var a: Vector3 = t._bone_world(t._her, foot)
		return _line(t, Vector3(a.x - travel.x, 0.05, a.z - travel.z), Vector3(a.x, 0.05, a.z))
	var exit_arrow := func() -> Array:
		return _line(t, Vector3(m_to.x + 0.18, 0.05, m_at.z), Vector3(her_at.x - 0.02, 0.05, m_at.z))
	var arrows := [exit_arrow, step_arrow]
	return {"layers": layers, "focus": Vector3((her_at.x + m_to.x) * 0.5, 0.80, CUT_GAP * 0.5), "arrows": arrows, "ropes": "",
		"ppos": m_at, "measure": {"clip": "strafe_left", "t": snappedf(st[0], 0.001), "partner": "strafe_right",
		"travel_m": snappedf(travel.length(), 0.01), "lane_m": snappedf(her_at.x - m_to.x, 0.01)}}


## Her back on the ropes, she turns on the lead foot: the solid figure is the start turned PIVOT_DEG round that foot,
## the gold arc is her rear foot's path round it on the canvas.
static func _pivot_out(t) -> Dictionary:
	var idle := _p("pro_idle", 0.0)
	t._pose(t._her, idle, Vector3.ZERO)
	var lead: Vector3 = t._bone_world(t._her, "LeftFoot")
	var rear: Vector3 = t._bone_world(t._her, "RightFoot")
	var ang := deg_to_rad(PIVOT_DEG)
	var pos := _turn(Vector3.ZERO, Vector3(lead.x, 0.0, lead.z), ang)
	var m_at := Vector3(0.0, 0.0, 1.05)
	var layers := [_spar(idle, m_at, PI, 1.0, true), _her(idle, Vector3.ZERO, 0.0, SPS.GHOST), _her(idle, pos, ang)]
	var arrows := [func() -> Array: return _arc(t, lead, rear, ang, 0.05)]
	return {"layers": layers, "focus": Vector3(0.0, 0.8, 0.45), "arrows": arrows, "ropes": "own", "ppos": m_at,
		"measure": {"clip": "pro_idle", "pivot_deg": PIVOT_DEG, "pivot_foot": "LeftFoot"}}


## The tie-up in the corner turned round its middle: Lucy came off the corner post, Maria is spun in onto it.
static func _spins_out(t) -> Dictionary:
	var gap: float = Specs.CLINCH_GAP
	var att := _p("clinch_att", lerpf(Specs.CLINCH_SPAN.x, Specs.CLINCH_SPAN.y, 0.35))
	var vic := _p("clinch_vic", att["t"])
	var mid := Vector3(0.0, 0.0, gap * 0.5)
	var ang := deg_to_rad(SPIN_DEG)
	var m0 := Vector3(0.0, 0.0, gap)
	var layers := [_spar(vic, m0, PI, SPS.GHOST * 0.8), _her(att, Vector3.ZERO, 0.0, SPS.GHOST),
		_spar(vic, _turn(m0, mid, ang), PI + ang, 1.0, true), _her(att, _turn(Vector3.ZERO, mid, ang), ang)]
	var arrows := [func() -> Array:
		t._pose(t._spar, vic, m0)
		var hips: Vector3 = t._bone_world(t._spar, "Hips")
		return _arc(t, mid, Vector3(hips.x, 0.0, hips.z), ang, 0.06)]
	# The corner is behind where Lucy started: her own ropes and the post.
	_corner_behind(t)
	return {"layers": layers, "focus": Vector3(0.0, 0.85, gap * 0.5), "arrows": arrows, "ropes": "", "ppos": m0,
		"measure": {"clip": "clinch_att", "spin_deg": SPIN_DEG, "partner": "clinch_vic"}}


## Both gloves flat on her chest, the arms driven out from the guard (two arm reaches on the boxer's stance - the
## ActionForge push lunged to her waist); Maria rocked back, the arrow over the heads her way back.
static func _push_off(t) -> Dictionary:
	var hit := _p("pro_hit_by_cross_v1", 0.14)
	var m_at := Vector3(0.0, 0.0, PUSH_GAP)
	t._pose(t._spar, hit, m_at)
	var chest: Vector3 = t._bone_world(t._spar, "Chest")
	var push := _p("pro_idle", 0.0)
	push["ik"] = [{"hand": "LeftHand", "tip": chest + Vector3(0.09, 0.0, -CHEST_FRONT)},
		{"hand": "RightHand", "tip": chest + Vector3(-0.09, 0.0, -CHEST_FRONT)}]
	# No faint Maria: where she stood is under Lucy's arms, and a ghost there muddied the push (look-dev S381 r2).
	var layers := [_spar(hit, m_at, PI, 1.0), _her(push)]
	var arrows := [func() -> Array:
		var y: float = chest.y + 0.55     # over the heads: Maria's way back
		return _line(t, Vector3(chest.x, y, chest.z - PUSH_BACK), Vector3(chest.x, y, chest.z + 0.10))]
	var measure := func() -> Dictionary:
		t._pose(t._her, push, Vector3.ZERO)
		var gap := maxf(t._glove_tip(t._her, "LeftHand").distance_to(push["ik"][0]["tip"]),
			t._glove_tip(t._her, "RightHand").distance_to(push["ik"][1]["tip"]))
		return {"clip": "pro_idle", "partner": "pro_hit_by_cross_v1", "pushed_m": PUSH_BACK, "gloves_off_chest_m": snappedf(gap, 0.001)}
	return {"layers": layers, "focus": Vector3(0.0, 0.92, PUSH_GAP * 0.5), "arrows": arrows, "measure_fn": measure}


## Under the hook (faint, Maria's glove where her head was), then up outside it and away (solid).
static func _roll_out(t) -> Dictionary:
	var deep := _p("pro_left_weave", Specs.head_away(t._her, "pro_left_weave"))
	var up := _p("pro_left_weave", Specs.clip_len(t._her, "pro_left_weave") * 0.92)
	var hook := Specs.resolve(t._spar, {"clip": "pro_left_hook", "at": "contact"})
	t._pose(t._her, _p("pro_idle", 0.0), Vector3.ZERO)
	var head: Vector3 = t._target(t._her, false)
	var gm: Array = t._glove_motion(t._spar, hook, Vector3.ZERO)
	var m_at: Vector3 = head - (gm[1] as Vector3) * t.HEAD_R - (gm[0] as Vector3)
	m_at.y = 0.0
	var layers := [_spar(hook, m_at, PI, 1.0, true), _her(deep, Vector3.ZERO, 0.0, SPS.GHOST), _her(up, ROLL_OUT)]
	var arrows := [func() -> Array:
		var pts: Array = []
		t._img_size = Vector2(t.CARD, t.CARD)
		var u := 0.0
		var lift: Vector3 = t.ARROW_LIFT["Head"]
		while u <= deep["t"]:
			t._pose(t._her, _p("pro_left_weave", u), Vector3.ZERO)
			pts.append(t._px(t._bone_world(t._her, "Head") + lift))
			u += t.STEP_DT
		t._pose(t._her, up, ROLL_OUT)
		var end: Vector3 = t._bone_world(t._her, "Head") + lift
		t._pose(t._her, deep, Vector3.ZERO)
		var b: Vector3 = t._bone_world(t._her, "Head") + lift
		for i in range(1, 9):
			pts.append(t._px(b.lerp(end, float(i) / 8.0)))
		return pts]
	return {"layers": layers, "focus": Vector3(0.1, 0.9, m_at.z * 0.5), "arrows": arrows,
		"measure": {"clip": "pro_left_weave", "partner": "pro_left_hook", "out_m": snappedf(ROLL_OUT.length(), 0.01)}}


# ---------------------------------------------------------------- ring pieces -------------------------------------------------

## Three ropes along X at depth z, centred on x (the cut-off's ropes run across the card, behind Maria).
static func _ropes_x(t, z: float, cx: float) -> void:
	for h in t.ROPE_H:
		var rope: Array = SPS.prop_cyl(0.022, 2.4, SPS.PROP_GREY, t._hull_shader, 12)
		var mi := rope[0] as MeshInstance3D
		mi.rotation = Vector3(0.0, 0.0, PI * 0.5)
		mi.position = Vector3(cx, h, z)
		t._hulls.append(rope[1])
		t._props.add_child(mi)


## The corner behind Lucy's start: two ropes meeting at a post, off her back-left (away from the camera).
static func _corner_behind(t) -> void:
	var post_at := Vector3(0.42, 0.0, -0.42)
	for h in t.ROPE_H:
		for along in [Vector3.RIGHT, Vector3.BACK]:
			var rope: Array = SPS.prop_cyl(0.022, 1.6, SPS.PROP_GREY, t._hull_shader, 12)
			var mi := rope[0] as MeshInstance3D
			mi.rotation = Vector3(0.0, 0.0, PI * 0.5) if along == Vector3.RIGHT else Vector3(PI * 0.5, 0.0, 0.0)
			mi.position = post_at + Vector3(0.0, h, 0.0) + (Vector3(-0.8, 0.0, 0.0) if along == Vector3.RIGHT else Vector3(0.0, 0.0, 0.8))
			t._hulls.append(rope[1])
			t._props.add_child(mi)
	var post: Array = SPS.prop_cyl(0.07, 1.42, SPS.PROP_GREY, t._hull_shader, 16)
	(post[0] as MeshInstance3D).position = post_at + Vector3(0.0, 0.71, 0.0)
	t._hulls.append(post[1])
	t._props.add_child(post[0])


# ---------------------------------------------------------------- the arm reach -------------------------------------------------

## Two-bone IK on the posed skeleton: the upper and lower arm turned (in the clip's own bend plane) so the glove's face
## lands on `tip`. Twice, as the glove's offset from the wrist turns with the forearm.
static func reach(t, bx: Dictionary, hand: String, tip: Vector3, passes := 2) -> void:
	var skel: Skeleton3D = bx["skel"]
	var side := "Left" if hand.begins_with("Left") else "Right"
	var iu := skel.find_bone(side + "UpperArm")
	var il := skel.find_bone(side + "LowerArm")
	var ih := skel.find_bone(hand)
	if iu < 0 or il < 0 or ih < 0:
		return
	for pass_i in passes:
		var u := _w(skel, iu)
		var l := _w(skel, il)
		var h := _w(skel, ih)
		var want: Vector3 = tip - (t._glove_tip(bx, hand) - h)
		var a := u.distance_to(l)
		var b := l.distance_to(h)
		var d := clampf(u.distance_to(want), absf(a - b) + 0.01, a + b - 0.005)
		var dir := (want - u).normalized()
		var side_v := (l - u) - dir * (l - u).dot(dir)
		var perp := side_v.normalized() if side_v.length() > 1e-4 else Vector3.DOWN
		var x := (a * a - b * b + d * d) / (2.0 * d)
		var l2 := u + dir * x + perp * sqrt(maxf(a * a - x * x, 0.0))
		_aim(skel, iu, l - u, l2 - u)
		var ln := _w(skel, il)
		_aim(skel, il, _w(skel, ih) - ln, (u + dir * d) - ln)
		skel.emit_signal("skeleton_updated")


static func _w(skel: Skeleton3D, i: int) -> Vector3:
	return skel.global_transform * skel.get_bone_global_pose(i).origin


static func _aim(skel: Skeleton3D, i: int, from_w: Vector3, to_w: Vector3) -> void:
	if from_w.length() < 1e-5 or to_w.length() < 1e-5:
		return
	var inv := skel.global_transform.basis.inverse()
	var f := (inv * from_w).normalized()
	var g := (inv * to_w).normalized()
	if f.dot(g) > 0.99999:
		return
	var q := Quaternion(f, g)
	var gp := skel.get_bone_global_pose(i)
	skel.set_bone_global_pose(i, Transform3D(Basis(q) * gp.basis, gp.origin))
