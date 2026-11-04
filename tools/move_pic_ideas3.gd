extends RefCounted
## MOVEPICS1 r4 (S383 skeptic, round 4) - the escapes and defences that still did not say their move, each re-composed on
## the ink layers of tools/bake_move_pics.gd (`t`). In the review's words Maria is the red boxer (the player's, `t._her`)
## and Lucy the blue one (`t._spar`). Every arrow ends on its target; the card's row says by how much (`*_tip_m`).
##   herd      - Maria walks Lucy toward the corner at range, arms out to shut the lane, a clear gap between them
##   cut_off   - Lucy on the ropes sliding for the open side (her lane arrow), Maria stepped across it, clear space
##   pivot_out - Maria's back on her own ropes (faint), turned on the lead foot (solid), the arc round that foot
##   roll      - Maria at the bottom of the roll, her head under Lucy's hook, the U of her head under the glove
##   roll_out  - under the hook (faint), up and out to the side (solid), the U from under the hook to her head
##   step_out  - seen from behind Maria: Lucy's jab lands where her head was, Maria one step to the side of the line
##   push_off  - Maria's arms long, Lucy pushed back off them: the arrow runs along the gap to Lucy's chest
##   slip      - Lucy's cross passes BESIDE Maria's head, the head slipped off its line
##   spins_out - Lucy pinned in the corner (faint), spun out round Maria (solid), the arc from the corner to her
##   has(id) -> bool   shot(t, id, spec) -> the card's layers, focus, arrows and row   rope_run / post -> ring pieces

const Specs := preload("res://tools/move_pic_specs.gd")
const Ideas := preload("res://tools/move_pic_ideas.gd")
const SPS := preload("res://tools/session_pic_style.gd")

const IDS := ["herd", "cut_off", "pivot_out", "roll", "roll_out", "step_out", "push_off", "slip", "spins_out"]
const CAM := {"herd": [-110.0, 14.0], "cut_off": [-165.0, 22.0], "pivot_out": [-35.0, 30.0], "roll": [-130.0, 12.0],
	"roll_out": [-155.0, 10.0], "step_out": [150.0, 20.0], "push_off": [-80.0, 6.0], "slip": [35.0, 10.0],
	"spins_out": [150.0, 24.0]}
const BACK_T := 0.07          # m from the upper spine to the skin of the back
const ROPE_R := 0.022
const POST_R := 0.07
const HERD_GAP := 1.40        # m pelvis to pelvis: at range, not tied up
const HERD_ROPES := 0.35      # m from Lucy's back to the ropes she is walked toward
const CUT_LUCY := Vector3(-0.30, 0.0, 1.0)
const CUT_FROM := Vector3(-0.25, 0.0, 0.0)    # Maria square to Lucy before the step
const CUT_TO := Vector3(0.55, 0.0, 0.45)      # Maria stepped across Lucy's lane
const PIVOT_DEG := 100.0
const PIVOT_LUCY := Vector3(0.50, 0.0, 1.45)
const GLOVE_OVER := 0.26      # m the hook passes over the ducked head
const U_RISE := 0.7           # the U's far side, as a share of the dip's sideways travel
const ROLL_OUT_AT := Vector3(0.70, 0.0, -0.15)
const STEP_OUT_AT := Vector3(-0.62, 0.0, -0.06)
const PUSH_GAP := 1.10        # m pelvis to pelvis after the push
const ARM_REACH := 0.60       # m from the shoulder line to the pushing gloves
const CHEST_FRONT := 0.12
const SLIP_PAST := 0.15       # m the cross's glove has gone past where the head was
const SPIN_R := 1.05          # m from Maria to Lucy, before and after the spin
const SPIN_DEG := -72.0
const SLIP_AT := 0.20         # s into the slip: the head furthest to the side (head_away's 0.233 is already dropping in)
const SPIN_POST := Vector3(0.40, 0.0, 0.0)    # post x; its z sits on Lucy's back


static func has(id: String) -> bool:
	return IDS.has(id)


static func shot(t, id: String, s: Dictionary) -> Dictionary:
	s["az"] = CAM[id][0]
	s["elev"] = CAM[id][1]
	var m := {}
	var out: Dictionary = {}
	match id:
		"herd":
			out = _herd(t, m)
		"cut_off":
			out = _cut_off(t, m)
		"pivot_out":
			out = _pivot_out(t, m)
		"roll":
			out = _roll(t, m, false)
		"roll_out":
			out = _roll(t, m, true)
		"step_out":
			out = _step_out(t, m)
		"push_off":
			out = _push_off(t, m)
		"slip":
			out = _slip(t, m)
		"spins_out":
			out = _spins_out(t, m)
	var base := {"kind": "idea", "az": s["az"], "elev": s["elev"], "idea": id, "r4": true}
	out["row"] = func() -> Dictionary:
		var r := base.duplicate()
		r.merge(m)
		return r
	out["ropes"] = ""      # ring pieces are placed here, not by Ideas2.ropes
	out["ppos"] = Vector3.ZERO
	return out


# ---------------------------------------------------------------- helpers -------------------------------------------------

## World points -> card pixels, and the tip's distance to its target recorded as m[key].
static func _end_on(t, m: Dictionary, key: String, pts_w: Array, target: Vector3) -> Array:
	t._img_size = Vector2(t.CARD, t.CARD)
	m[key] = snappedf((pts_w[-1] as Vector3).distance_to(target), 0.001)
	var px := []
	for w in pts_w:
		px.append(t._px(w))
	return px


static func _seg(a: Vector3, b: Vector3, n := 8) -> Array:
	var out := []
	for i in n + 1:
		out.append(a.lerp(b, float(i) / float(n)))
	return out


static func _flat(p: Vector3, y := 0.05) -> Vector3:
	return Vector3(p.x, y, p.z)


## The back of a body at the top rope: +1 = her back faces +Z (Lucy), -1 = -Z (Maria). The upper spine plus the flesh.
static func back_z(t, bx: Dictionary, side: float) -> float:
	var a: float = t._bone_world(bx, "UpperChest").z
	var b: float = t._bone_world(bx, "Chest").z
	return (maxf(a, b) if side > 0.0 else minf(a, b)) + side * BACK_T


## Three ropes from `a` to `b` (floor points), at the ring's heights, in the ropes' own layer.
static func rope_run(t, a: Vector3, b: Vector3) -> void:
	for h in t.ROPE_H:
		var p := Vector3(a.x, h, a.z)
		var q := Vector3(b.x, h, b.z)
		var rope: Array = SPS.prop_cyl(ROPE_R, p.distance_to(q), SPS.PROP_GREY, t._hull_shader, 12)
		var mi := rope[0] as MeshInstance3D
		mi.transform = Transform3D(Basis(Quaternion(Vector3.UP, (q - p).normalized())), (p + q) * 0.5)
		t._hulls.append(rope[1])
		t._props.add_child(mi)


static func post(t, at: Vector3) -> void:
	var p: Array = SPS.prop_cyl(POST_R, 1.42, SPS.PROP_GREY, t._hull_shader, 16)
	(p[0] as MeshInstance3D).position = Vector3(at.x, 0.71, at.z)
	t._hulls.append(p[1])
	t._props.add_child(p[0])


static func _her(pose: Dictionary, pos := Vector3.ZERO, rot := 0.0, alpha := 1.0) -> Dictionary:
	return Ideas._her(pose, pos, rot, alpha)


static func _spar(pose: Dictionary, pos: Vector3, rot := PI, alpha := 1.0) -> Dictionary:
	return Ideas._spar(pose, pos, rot, alpha)


static func _ropes() -> Dictionary:
	return {"who": "ropes"}


# ---------------------------------------------------------------- the cards -------------------------------------------------

static func _herd(t, m: Dictionary) -> Dictionary:
	var st: Array = Specs.stride(t._her, "advance")
	var fin := Ideas._p("advance", st[0])
	var travel: Vector3 = st[2]
	t._pose(t._her, fin, Vector3.ZERO)
	var hips: Vector3 = t._bone_world(t._her, "Hips")
	# Arms out wide at chest height: the lane to either side is shut.
	fin["ik"] = [{"hand": "LeftHand", "tip": hips + Vector3(0.48, 0.18, 0.34)},
		{"hand": "RightHand", "tip": hips + Vector3(-0.46, 0.16, 0.28)}]
	var bs: Array = Specs.stride(t._spar, "retreat")
	var lucy := Ideas._p("retreat", bs[0])
	var l_at := Vector3(hips.x + 0.10, 0.0, hips.z + HERD_GAP)
	t._pose(t._spar, lucy, l_at)
	var rz: float = back_z(t, t._spar, 1.0) + HERD_ROPES
	var post_at := Vector3(l_at.x + 0.75, 0.0, rz)
	rope_run(t, post_at, post_at + Vector3(-3.2, 0.0, 0.0))
	rope_run(t, post_at, post_at + Vector3(0.0, 0.0, -2.6))
	post(t, post_at)
	var layers := [_ropes(), _spar(lucy, l_at), _her(fin)]
	var foot := str(st[1])
	var arrows := [func() -> Array:
		t._pose(t._her, fin, Vector3.ZERO)
		var b: Vector3 = t._bone_world(t._her, foot)
		var a := b - travel
		return _end_on(t, m, "arrow_tip_m", _seg(_flat(a), _flat(b)), _flat(b))]
	m.merge({"clip": "advance", "partner": "retreat", "gap_m": snappedf(HERD_GAP, 0.01),
		"lucy_back_to_rope_m": snappedf(rz - ROPE_R - back_z(t, t._spar, 1.0), 0.001)})
	return {"layers": layers, "focus": Vector3(0.0, 0.9, HERD_GAP * 0.5), "arrows": arrows}


static func _cut_off(t, m: Dictionary) -> Dictionary:
	var bs: Array = Specs.stride(t._spar, "strafe_right")
	var lucy := Ideas._p("strafe_right", bs[0])
	t._pose(t._spar, lucy, CUT_LUCY)
	var rz: float = back_z(t, t._spar, 1.0) + ROPE_R
	rope_run(t, Vector3(-2.6, 0.0, rz), Vector3(2.6, 0.0, rz))
	var st: Array = Specs.stride(t._her, "strafe_left")
	var fin := Ideas._p("strafe_left", st[0])
	var foot := str(st[1])
	var layers := [_ropes(), _spar(lucy, CUT_LUCY), _her(fin, CUT_TO)]
	t._pose(t._her, fin, CUT_TO)
	var maria_hips: Vector3 = t._bone_world(t._her, "Hips")
	var lane_z: float = CUT_LUCY.z - 0.18
	# Lucy's way out along the ropes, to where Maria now stands in it.
	var lane := func() -> Array:
		var a := Vector3(CUT_LUCY.x + 0.25, 0.05, lane_z)
		var b := Vector3(maria_hips.x - 0.22, 0.05, lane_z)
		return _end_on(t, m, "lane_tip_to_maria_m", _seg(a, b), Vector3(maria_hips.x - 0.22, 0.05, lane_z))
	var step := func() -> Array:
		t._pose(t._her, fin, CUT_TO)
		var b: Vector3 = t._bone_world(t._her, foot)
		var a := b - (CUT_TO - CUT_FROM)
		return _end_on(t, m, "arrow_tip_m", _seg(_flat(a), _flat(b)), _flat(b))
	t._pose(t._spar, lucy, CUT_LUCY)
	var l_hips: Vector3 = t._bone_world(t._spar, "Hips")
	m.merge({"clip": "strafe_left", "partner": "strafe_right", "space_m": snappedf(Vector2(maria_hips.x - l_hips.x,
		maria_hips.z - l_hips.z).length(), 0.01), "lucy_back_to_rope_m": snappedf(rz - ROPE_R - back_z(t, t._spar, 1.0), 0.001)})
	return {"layers": layers, "focus": Vector3((CUT_LUCY.x + CUT_TO.x) * 0.5, 0.85, CUT_LUCY.z * 0.5), "arrows": [lane, step]}


static func _pivot_out(t, m: Dictionary) -> Dictionary:
	var idle := Ideas._p("pro_idle", 0.0)
	t._pose(t._her, idle, Vector3.ZERO)
	var lead: Vector3 = t._bone_world(t._her, "LeftFoot")
	var rear: Vector3 = t._bone_world(t._her, "RightFoot")
	var rz: float = back_z(t, t._her, -1.0) - ROPE_R
	rope_run(t, Vector3(-2.6, 0.0, rz), Vector3(2.6, 0.0, rz))
	var ang := deg_to_rad(PIVOT_DEG)
	var centre := Vector3(lead.x, 0.0, lead.z)
	var pos: Vector3 = Ideas._turn(Vector3.ZERO, centre, ang)
	var layers := [_ropes(), _spar(idle, PIVOT_LUCY, PI), _her(idle, Vector3.ZERO, 0.0, SPS.GHOST), _her(idle, pos, ang)]
	var arrows := [func() -> Array:
		var pts := []
		for i in Ideas.ARC_STEPS + 1:
			pts.append(_flat(Ideas._turn(rear, centre, ang * float(i) / float(Ideas.ARC_STEPS))))
		var node: Node3D = t._her["node"]
		node.rotation.y = ang
		t._pose(t._her, idle, pos)
		var tgt: Vector3 = _flat(t._bone_world(t._her, "RightFoot"))
		m["lead_foot_moved_m"] = snappedf(_flat(t._bone_world(t._her, "LeftFoot")).distance_to(_flat(lead)), 0.001)
		node.rotation.y = 0.0
		return _end_on(t, m, "arrow_tip_m", pts, tgt)]
	m.merge({"clip": "pro_idle", "pivot_deg": PIVOT_DEG, "pivot_foot": "LeftFoot",
		"maria_back_to_rope_m": snappedf(back_z(t, t._her, -1.0) - (rz + ROPE_R), 0.001)})
	return {"layers": layers, "focus": Vector3(0.15, 0.85, 0.55), "arrows": arrows}


## The roll (out=false): Maria at the bottom, the hook over her head, the U of her head under it. The roll out: faint at
## the bottom, solid up and out to the side, the U ending on her head.
static func _roll(t, m: Dictionary, out: bool) -> Dictionary:
	var clip := "pro_left_weave"
	var deep := Ideas._p(clip, Specs.head_low(t._her, clip))
	var lift: Vector3 = t.ARROW_LIFT["Head"]
	t._pose(t._her, Ideas._p(clip, 0.0), Vector3.ZERO)
	var h0: Vector3 = t._bone_world(t._her, "Head") + lift
	t._pose(t._her, deep, Vector3.ZERO)
	var hb: Vector3 = t._bone_world(t._her, "Head") + lift
	var hook := Specs.resolve(t._spar, {"clip": "pro_left_hook", "at": "contact"})
	t._pose(t._spar, hook, Vector3.ZERO)
	var g0: Vector3 = t._glove_tip(t._spar, "LeftHand")
	var over := hb - lift + Vector3(0.0, GLOVE_OVER, 0.0)
	var m_at := over - g0
	m_at.y = 0.0
	if m_at.z < 0.75:
		m_at.z = 0.75
	# The hook's arm reached up over the ducked head (its clip throws at chin height).
	hook["ik"] = {"hand": "LeftHand", "tip": over, "passes": 4}
	var up := Ideas._p("pro_idle", 0.0)
	var layers: Array
	if out:
		layers = [_her(deep, Vector3.ZERO, 0.0, SPS.GHOST), _spar(hook, m_at), _her(up, ROLL_OUT_AT)]
	else:
		layers = [_spar(hook, m_at), _her(deep)]
	var arrows := [func() -> Array:
		var pts := []
		var u := 0.0
		while u <= float(deep["t"]):
			t._pose(t._her, Ideas._p(clip, u), Vector3.ZERO)
			pts.append(t._bone_world(t._her, "Head") + lift)
			u += t.STEP_DT
		pts.append(hb)
		var end: Vector3
		if out:
			t._pose(t._her, up, ROLL_OUT_AT)
			end = t._bone_world(t._her, "Head") + lift
		else:
			end = Vector3(hb.x + (hb.x - h0.x) * U_RISE, h0.y, hb.z)
		# The far side of the U: the head's descent mirrored, rising to `end`.
		var mid := Vector3(end.x, hb.y, (hb.z + end.z) * 0.5)
		for i in range(1, 11):
			var k := float(i) / 10.0
			pts.append(hb.lerp(mid, k).lerp(mid.lerp(end, k), k))
		t._pose(t._spar, hook, m_at)
		var glove: Vector3 = t._glove_tip(t._spar, "LeftHand")
		var low := INF
		for p in pts:
			low = minf(low, (p as Vector3).y)
		m["u_under_glove_m"] = snappedf(glove.y - low, 0.001)
		m["glove_over_head_m"] = snappedf(glove.y - (hb.y - lift.y), 0.001)
		return _end_on(t, m, "arrow_tip_m", pts, end)]
	m.merge({"clip": clip, "t": snappedf(float(deep["t"]), 0.001), "partner": "pro_left_hook"})
	if out:
		m["out_m"] = snappedf(Vector2(ROLL_OUT_AT.x, ROLL_OUT_AT.z).length(), 0.01)
	var cx := (ROLL_OUT_AT.x * 0.5) if out else hb.x * 0.5
	return {"layers": layers, "focus": Vector3(cx, 0.9, m_at.z * 0.5), "arrows": arrows}


static func _step_out(t, m: Dictionary) -> Dictionary:
	var clip := "strafe_left"
	for c in ["strafe_left", "strafe_right"]:
		if (Specs.stride(t._her, c)[2] as Vector3).x < 0.0:
			clip = c
	var st: Array = Specs.stride(t._her, clip)
	var fin := Ideas._p(clip, st[0])
	var idle := Ideas._p("pro_idle", 0.0)
	var jab := Specs.resolve(t._spar, {"clip": "pro_left_jab", "at": "contact"})
	var m_at: Vector3 = _glove_on_head(t, jab, idle)
	var foot := str(st[1])
	# No faint Maria: Lucy's glove marks where her head was (r3's faint figure smeared purple over Lucy).
	var layers := [_spar(jab, m_at), _her(fin, STEP_OUT_AT)]
	var arrows := [func() -> Array:
		t._pose(t._her, Ideas._p(clip, 0.0), Vector3.ZERO)
		var a: Vector3 = t._bone_world(t._her, foot)
		t._pose(t._her, fin, STEP_OUT_AT)
		var b: Vector3 = t._bone_world(t._her, foot)
		return _end_on(t, m, "arrow_tip_m", _seg(_flat(a), _flat(b)), _flat(b))]
	t._pose(t._spar, jab, m_at)
	var g: Vector3 = t._glove_tip(t._spar, "LeftHand")
	t._pose(t._her, fin, STEP_OUT_AT)
	m.merge({"clip": clip, "t": snappedf(float(st[0]), 0.001), "partner": "pro_left_jab",
		"glove_to_head_now_m": snappedf(g.distance_to(t._target(t._her, false)), 0.001),
		"side_m": snappedf(-STEP_OUT_AT.x, 0.01)})
	return {"layers": layers, "focus": Vector3(STEP_OUT_AT.x * 0.5, 0.85, m_at.z * 0.4), "arrows": arrows}


## Where Lucy stands so the glove of `punch` is on Maria's face in `pose` (at the origin).
static func _glove_on_head(t, punch: Dictionary, pose: Dictionary) -> Vector3:
	t._pose(t._her, pose, Vector3.ZERO)
	var head: Vector3 = t._target(t._her, false)
	var gm: Array = t._glove_motion(t._spar, punch, Vector3.ZERO)
	var p: Vector3 = head - (gm[1] as Vector3) * t.HEAD_R - (gm[0] as Vector3)
	p.y = 0.0
	return p


static func _push_off(t, m: Dictionary) -> Dictionary:
	var hit := Ideas._p("pro_hit_by_cross_v1", 0.14)
	var l_at := Vector3(0.0, 0.0, PUSH_GAP)
	var push := Ideas._p("pro_idle", 0.0)
	t._pose(t._her, push, Vector3.ZERO)
	var sh: Vector3 = (t._bone_world(t._her, "LeftUpperArm") + t._bone_world(t._her, "RightUpperArm")) * 0.5
	var y: float = sh.y - 0.10
	push["ik"] = [{"hand": "LeftHand", "tip": Vector3(sh.x + 0.10, y, sh.z + ARM_REACH)},
		{"hand": "RightHand", "tip": Vector3(sh.x - 0.10, y, sh.z + ARM_REACH)}]
	var layers := [_spar(hit, l_at), _her(push)]
	var arrows := [func() -> Array:
		t._pose(t._spar, hit, l_at)
		var chest: Vector3 = t._bone_world(t._spar, "UpperChest")
		var front := Vector3(0.0, y - 0.08, chest.z - CHEST_FRONT)
		var a := Vector3(0.0, y - 0.08, sh.z + ARM_REACH + 0.04)
		m["gap_m"] = snappedf(front.z - a.z + 0.04, 0.001)
		return _end_on(t, m, "arrow_tip_m", _seg(a, front), front)]
	m.merge({"clip": "pro_idle", "partner": "pro_hit_by_cross_v1", "pelvis_gap_m": PUSH_GAP})
	return {"layers": layers, "focus": Vector3(0.0, 0.92, PUSH_GAP * 0.5), "arrows": arrows}


static func _slip(t, m: Dictionary) -> Dictionary:
	var clip := "slip"
	var away := Ideas._p(clip, SLIP_AT)
	var lift: Vector3 = t.ARROW_LIFT["Head"]
	var cross := Specs.resolve(t._spar, {"clip": "pro_right_cross", "at": "contact"})
	t._pose(t._her, Ideas._p(clip, 0.0), Vector3.ZERO)
	var head0: Vector3 = t._target(t._her, false)
	var gm: Array = t._glove_motion(t._spar, cross, Vector3.ZERO)
	var m_at: Vector3 = head0 - (gm[1] as Vector3) * (t.HEAD_R - SLIP_PAST) - (gm[0] as Vector3)
	m_at.y = 0.0
	var layers := [_spar(cross, m_at), _her(away)]
	var arrows := [func() -> Array:
		# Start head to slipped head in one stroke: the clip's own head path loops round on the way down.
		t._pose(t._her, Ideas._p(clip, 0.0), Vector3.ZERO)
		var a: Vector3 = t._bone_world(t._her, "Head") + lift
		t._pose(t._her, away, Vector3.ZERO)
		var tgt: Vector3 = t._bone_world(t._her, "Head") + lift
		return _end_on(t, m, "arrow_tip_m", _seg(a, tgt), tgt)]
	t._pose(t._spar, cross, m_at)
	var g: Vector3 = t._glove_tip(t._spar, "RightHand")
	t._pose(t._her, away, Vector3.ZERO)
	var face: Vector3 = t._target(t._her, false)
	m.merge({"clip": clip, "t": snappedf(float(away["t"]), 0.001), "partner": "pro_right_cross",
		"glove_to_head_now_m": snappedf(g.distance_to(face), 0.001), "head_off_line_m": snappedf(absf(face.x - g.x), 0.001)})
	return {"layers": layers, "focus": Vector3(0.0, 0.95, m_at.z * 0.5), "arrows": arrows}


static func _spins_out(t, m: Dictionary) -> Dictionary:
	var idle := Ideas._p("pro_idle", 0.0)
	var start := Vector3(0.0, 0.0, SPIN_R)
	t._pose(t._spar, idle, start)
	var rz: float = back_z(t, t._spar, 1.0) + ROPE_R
	var post_at := Vector3(SPIN_POST.x, 0.0, rz)
	rope_run(t, post_at, post_at + Vector3(-3.0, 0.0, 0.0))
	rope_run(t, post_at, post_at + Vector3(0.0, 0.0, -1.2))
	post(t, post_at)
	var ang := deg_to_rad(SPIN_DEG)
	var to: Vector3 = start.rotated(Vector3.UP, ang)
	var l_rot := atan2(-to.x, -to.z)     # Lucy faces Maria
	var m_rot := atan2(to.x, to.z)       # Maria turned with the spin, facing her
	var layers := [_ropes(), _spar(idle, start, PI, SPS.GHOST * 0.9), _spar(idle, to, l_rot), _her(idle, Vector3.ZERO, m_rot)]
	var arrows := [func() -> Array:
		var pts := []
		for i in Ideas.ARC_STEPS + 1:
			pts.append(_flat(start.rotated(Vector3.UP, ang * float(i) / float(Ideas.ARC_STEPS)), 0.06))
		var node: Node3D = t._spar["node"]
		node.rotation.y = l_rot
		t._pose(t._spar, idle, to)
		var hips: Vector3 = t._bone_world(t._spar, "Hips")
		node.rotation.y = PI
		return _end_on(t, m, "arrow_tip_m", pts, _flat(hips, 0.06))]
	m.merge({"clip": "pro_idle", "spin_deg": SPIN_DEG, "spin_r_m": SPIN_R,
		"lucy_back_to_rope_m": snappedf(rz - ROPE_R - back_z(t, t._spar, 1.0), 0.001)})
	return {"layers": layers, "focus": Vector3(to.x * 0.4, 0.85, SPIN_R * 0.45), "arrows": arrows}
