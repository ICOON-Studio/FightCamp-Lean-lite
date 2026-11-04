extends RefCounted
## MOVEPICS1 r3 (S383 skeptic, round 3: "step_back near-identical to backed_up", "step_out has no lateral step", "break
## reads as another step back", "cut_off: Lucy a red blob, the arrows confuse", "pivot_out: they overlap like a clinch,
## the arc swings toward Maria", "the ropes are short floating sticks", "3b-3@inside pixel-identical to 3b-3", "1-6-3:
## the uppercut is not readable") - the boxing cards whose clip alone does not say the move, each its own picture on
## the ink layers of tools/bake_move_pics.gd (`t`), and the ring's ropes:
##   step_back - Maria's lead hook lands where Lucy's head WAS (her faint figure); Lucy one step back, out of its reach
##   step_out  - seen from behind Maria, a little high: her jab runs into the card through the faint Lucy, Lucy stepped
##               out to the side and back, off that line; the arrow is that step on the floor
##   break     - the faint pair tied up in the clinch, both solid a step apart, an arrow each way
##   cut_off   - Maria (faint, then solid) slides along the ropes for the open side; Lucy steps across into that lane
##               first - ONE arrow, her step
##   pivot_out - her back on her own ropes (faint): she turns out to the side, away from Maria, and faces her (solid)
##   ropes     - three long ropes in their own layer under both bodies (never framed, never in front): right behind
##               Maria (opp), right behind Lucy (own), or two sides meeting at the post behind Maria (corner)
##   inside    - 3b-3@inside: Maria at the inside range (heads close), both hooks shortened onto their targets
##   ghost_arrows - an uppercut thrown earlier in a combo (1-6-3) gets its own rising arrow

const Specs := preload("res://tools/move_pic_specs.gd")
const Ideas := preload("res://tools/move_pic_ideas.gd")
const SPS := preload("res://tools/session_pic_style.gd")

const IDS := ["step_back", "break"]   # r4: step_out, cut_off, pivot_out -> move_pic_ideas3.gd
const CAM := {"step_back": [-74.0, 6.0], "step_out": [-15.0, 28.0], "break": [-74.0, 6.0], "cut_off": [-122.0, 20.0],
	"pivot_out": [-45.0, 22.0]}
const ROPE_LEN := 6.0         # m: the ropes run off both sides of the card
const ROPE_BEHIND := 0.30     # m from the hips to the ropes at her back
const POST_SIDE := 0.55       # m along the ropes from Maria to the corner post
const INSIDE_GAP := 0.58      # m pelvis to pelvis: StrikeMap's inside range (0.45-0.7)
const UPPERCUT_GHOST := 0.80  # the earlier uppercut's figure: clearly there, still behind the finish
const OUT_SIDE := Vector3(-0.55, 0.0, -0.22)   # m the step out takes her: to the side, a little back
const BREAK_BACK := 0.42      # m each boxer steps back out of the tie-up
const CUT_GAP := 1.00         # m from Lucy's line to Maria's
const CUT_M := [-0.60, -0.18] # m along the ropes: Maria's start and where she has slid to
const CUT_HER := [-0.45, 0.32] # m: Lucy's start and her step across, into Maria's lane
const PIVOT_TO := Vector3(-0.78, 0.0, 0.22)   # m: off the ropes, out to the side (the card's left), clear of Maria
const PIVOT_M_Z := 0.95


static func has(id: String) -> bool:
	return IDS.has(id)


static func shot(t, id: String, s: Dictionary) -> Dictionary:
	s["az"] = CAM[id][0]
	s["elev"] = CAM[id][1]
	var out: Dictionary = {}
	match id:
		"step_back":
			out = _step_back(t)
		"step_out":
			out = _step_out(t)
		"break":
			out = _break(t)
		"cut_off":
			out = _cut_off(t)
		"pivot_out":
			out = _pivot_out(t)
	var base := {"kind": "idea", "az": s["az"], "elev": s["elev"], "idea": id}
	var m: Dictionary = out.get("measure", {})
	out["row"] = func() -> Dictionary:
		var r := base.duplicate()
		r.merge(m)
		return r
	if not out.has("ropes"):
		out["ropes"] = ""
		out["ppos"] = Vector3.ZERO
	return out


## Where Maria stands so the glove of `punch` lands on Lucy's head in `her_pose` at `her_off`.
static func _glove_on_head(t, punch: Dictionary, her_pose: Dictionary, her_off: Vector3) -> Vector3:
	t._pose(t._her, her_pose, her_off)
	var head: Vector3 = t._target(t._her, false)
	var gm: Array = t._glove_motion(t._spar, punch, Vector3.ZERO)
	var p: Vector3 = head - (gm[1] as Vector3) * t.HEAD_R - (gm[0] as Vector3)
	p.y = 0.0
	return p


## A foot's step along the floor: from where it stood in the first pose to where it stands in the second.
static func _foot_line(t, who: Dictionary, p0: Dictionary, o0: Vector3, r0: float, p1: Dictionary, o1: Vector3, r1: float,
		foot: String) -> Array:
	var node: Node3D = who["node"]
	node.rotation.y = r0
	t._pose(who, p0, o0)
	var a: Vector3 = t._bone_world(who, foot)
	node.rotation.y = r1
	t._pose(who, p1, o1)
	var b: Vector3 = t._bone_world(who, foot)
	node.rotation.y = r0
	return Ideas._line(t, Vector3(a.x, 0.05, a.z), Vector3(b.x, 0.05, b.z))


static func _step_back(t) -> Dictionary:
	var idle := Ideas._p("pro_idle", 0.0)
	var st: Array = Specs.stride(t._her, "retreat")
	var fin := Ideas._p("retreat", st[0])
	var travel: Vector3 = st[2]
	var hook := Specs.resolve(t._spar, {"clip": "pro_left_hook", "at": "contact"})
	var m_at := _glove_on_head(t, hook, idle, Vector3.ZERO)
	var layers := [Ideas._spar(hook, m_at, PI, 1.0), Ideas._her(idle, Vector3.ZERO, 0.0, SPS.GHOST), Ideas._her(fin, travel)]
	var arrows := [func() -> Array: return _foot_line(t, t._her, idle, Vector3.ZERO, 0.0, fin, travel, 0.0, str(st[1]))]
	return {"layers": layers, "focus": Vector3(0.0, 0.92, (m_at.z + travel.z) * 0.5), "arrows": arrows,
		"measure": {"clip": "retreat", "t": snappedf(st[0], 0.001), "partner": "pro_left_hook", "back_m": snappedf(travel.length(), 0.01)}}


static func _step_out(t) -> Dictionary:
	var idle := Ideas._p("pro_idle", 0.0)
	# The side step whose stepping foot goes the way she steps (-X: off the line, to the card's left from this camera).
	var clip := "strafe_left"
	for c in ["strafe_left", "strafe_right"]:
		if (Specs.stride(t._her, c)[2] as Vector3).x < 0.0:
			clip = c
	var st: Array = Specs.stride(t._her, clip)
	var fin := Ideas._p(clip, st[0])
	var jab := Specs.resolve(t._spar, {"clip": "pro_left_jab", "at": "contact"})
	var m_at := _glove_on_head(t, jab, idle, Vector3.ZERO)
	var layers := [Ideas._spar(jab, m_at, PI, 1.0), Ideas._her(idle, Vector3.ZERO, 0.0, SPS.GHOST), Ideas._her(fin, OUT_SIDE)]
	var arrows := [func() -> Array: return _foot_line(t, t._her, idle, Vector3.ZERO, 0.0, fin, OUT_SIDE, 0.0, str(st[1]))]
	return {"layers": layers, "focus": Vector3(OUT_SIDE.x * 0.5, 0.85, m_at.z * 0.4), "arrows": arrows,
		"measure": {"clip": clip, "t": snappedf(st[0], 0.001), "partner": "pro_left_jab", "out_m": snappedf(OUT_SIDE.length(), 0.01)}}


static func _break(t) -> Dictionary:
	var gap: float = Specs.CLINCH_GAP
	var att := Ideas._p("clinch_att", lerpf(Specs.CLINCH_SPAN.x, Specs.CLINCH_SPAN.y, 0.35))
	var vic := Ideas._p("clinch_vic", att["t"])
	var st: Array = Specs.stride(t._her, "retreat")
	var fin := Ideas._p("retreat", st[0])
	var mst: Array = Specs.stride(t._spar, "retreat")
	var mfin := Ideas._p("retreat", mst[0])
	var her_to := Vector3(0.0, 0.0, -BREAK_BACK)
	var m_to := Vector3(0.0, 0.0, gap + BREAK_BACK)
	var layers := [Ideas._spar(vic, Vector3(0.0, 0.0, gap), PI, SPS.GHOST * 0.9), Ideas._her(att, Vector3.ZERO, 0.0, SPS.GHOST),
		Ideas._spar(mfin, m_to, PI, 1.0), Ideas._her(fin, her_to)]
	var arrows := [
		func() -> Array: return Ideas._line(t, Vector3(0.0, 0.05, -0.05), Vector3(0.0, 0.05, her_to.z - 0.12)),
		func() -> Array: return Ideas._line(t, Vector3(0.0, 0.05, gap + 0.05), Vector3(0.0, 0.05, m_to.z + 0.12))]
	return {"layers": layers, "focus": Vector3(0.0, 0.9, gap * 0.5), "arrows": arrows,
		"measure": {"clip": "clinch_att", "partner": "clinch_vic", "apart_m": snappedf(m_to.z - her_to.z, 0.01)}}


static func _cut_off(t) -> Dictionary:
	var st: Array = Specs.stride(t._her, "strafe_left")
	var fin := Ideas._p("strafe_left", st[0])
	var idle := Ideas._p("pro_idle", 0.0)
	var ms: Array = Specs.stride(t._spar, "strafe_right")
	var m0 := Vector3(CUT_M[0], 0.0, CUT_GAP)
	var m1 := Vector3(CUT_M[1], 0.0, CUT_GAP)
	var h0 := Vector3(CUT_HER[0], 0.0, 0.0)
	var h1 := Vector3(CUT_HER[1], 0.0, 0.0)
	var layers := [{"who": "ropes"}, Ideas._spar(idle, m0, PI, SPS.GHOST * 0.8), Ideas._spar(Ideas._p("strafe_right", ms[0]), m1, PI, 1.0),
		Ideas._her(idle, h0, 0.0, SPS.GHOST), Ideas._her(fin, h1)]
	var arrows := [func() -> Array: return _foot_line(t, t._her, idle, h0, 0.0, fin, h1, 0.0, str(st[1]))]
	return {"layers": layers, "focus": Vector3((h1.x + m0.x) * 0.5, 0.85, CUT_GAP * 0.5), "arrows": arrows, "ropes": "opp",
		"ppos": m1, "measure": {"clip": "strafe_left", "t": snappedf(st[0], 0.001), "partner": "strafe_right",
		"step_m": snappedf(h1.x - h0.x, 0.01), "lane_m": snappedf(h1.x - m1.x, 0.01)}}


static func _pivot_out(t) -> Dictionary:
	# S383 r3 look-dev: a turn round the lead foot moved her body little and its arc read as a step towards Maria.
	# The card shows where the pivot takes her: off the ropes, out to the side away from Maria, turned to face her.
	var idle := Ideas._p("pro_idle", 0.0)
	var m_at := Vector3(0.0, 0.0, PIVOT_M_Z)
	var to_m := m_at - PIVOT_TO
	var ang := atan2(to_m.x, to_m.z)
	var layers := [{"who": "ropes"}, Ideas._spar(idle, m_at, PI, 1.0), Ideas._her(idle, Vector3.ZERO, 0.0, SPS.GHOST),
		Ideas._her(idle, PIVOT_TO, ang)]
	var arrows := [func() -> Array:
		var pts: Array = []
		t._img_size = Vector2(t.CARD, t.CARD)
		var a := Vector3(0.0, 0.05, -0.12)
		var c := Vector3(PIVOT_TO.x * 0.55, 0.05, -0.34)
		var b := Vector3(PIVOT_TO.x + 0.10, 0.05, PIVOT_TO.z - 0.05)
		for k in 17:
			var u := float(k) / 16.0
			pts.append(t._px(a.lerp(c, u).lerp(c.lerp(b, u), u)))
		return pts]
	return {"layers": layers, "focus": Vector3(PIVOT_TO.x * 0.5, 0.85, 0.35), "arrows": arrows, "ropes": "own", "ppos": m_at,
		"measure": {"clip": "pro_idle", "out_m": snappedf(Vector2(PIVOT_TO.x, PIVOT_TO.z).length(), 0.01),
		"face_deg": snappedf(rad_to_deg(ang), 0.1)}}


# ---------------------------------------------------------------- the ropes -------------------------------------------------

## [] or the ropes' own layer (rendered alone, under both bodies, never part of the framing).
static func rope_layer(kind: String) -> Array:
	return [] if kind == "" else [{"who": "ropes"}]


static func ropes(t, kind: String, at: Vector3, on_back := NAN) -> void:
	if kind == "":
		return
	var z: float = at.z + ROPE_BEHIND if kind != "own" else -ROPE_BEHIND - 0.12
	if not is_nan(on_back):
		z = on_back     # r4: on the pinned fighter's back (tools/move_pic_land.gd)
	var cx: float = at.x if kind != "own" else 0.0
	if kind == "corner":
		var post := Vector3(at.x + POST_SIDE, 0.0, z)
		for h in t.ROPE_H:
			_rope(t, Vector3(post.x - ROPE_LEN * 0.5, h, z), Vector3(0.0, 0.0, PI * 0.5))
			_rope(t, Vector3(post.x, h, z - ROPE_LEN * 0.5), Vector3(PI * 0.5, 0.0, 0.0))
		var p: Array = SPS.prop_cyl(0.07, 1.42, SPS.PROP_GREY, t._hull_shader, 16)
		(p[0] as MeshInstance3D).position = post + Vector3(0.0, 0.71, 0.0)
		t._hulls.append(p[1])
		t._props.add_child(p[0])
		return
	for h in t.ROPE_H:
		_rope(t, Vector3(cx, h, z), Vector3(0.0, 0.0, PI * 0.5))


static func _rope(t, at: Vector3, rot: Vector3) -> void:
	var rope: Array = SPS.prop_cyl(0.022, ROPE_LEN, SPS.PROP_GREY, t._hull_shader, 12)
	var mi := rope[0] as MeshInstance3D
	mi.rotation = rot
	mi.position = at
	t._hulls.append(rope[1])
	t._props.add_child(mi)


# ---------------------------------------------------------------- combos -------------------------------------------------

## 3b-3@inside: Maria at the inside range, the finish and the earlier body hook bent onto their targets (arm reach).
## Returns [ppos, fin]; the ghosts' poses get their reach in place.
static func inside(t, fin: Dictionary, ghosts: Array, part: Dictionary, ppos: Vector3) -> Array:
	t._pose(t._her, fin, Vector3.ZERO)
	var hz: float = t._bone_world(t._her, "Hips").z
	var p := Vector3(ppos.x, 0.0, hz + INSIDE_GAP)
	t._pose(t._spar, part, p)
	var gm: Array = t._glove_motion(t._her, fin, Vector3.ZERO)
	var out := fin.duplicate()
	var dir := Vector3((gm[1] as Vector3).x, 0.0, (gm[1] as Vector3).z).normalized()
	out["ik"] = {"hand": str(fin["hand"]), "tip": t._target(t._spar, false) - dir * t.HEAD_R, "passes": 4}
	for g in ghosts:
		var gp: Dictionary = g["pose"]
		var body: bool = Specs.BODY_SHOTS.has(str(gp["clip"]))
		var gg: Array = t._glove_motion(t._her, gp, g["off"])
		var gd := Vector3((gg[1] as Vector3).x, 0.0, (gg[1] as Vector3).z).normalized()
		gp["ik"] = {"hand": str(gp["hand"]), "tip": t._target(t._spar, body) - gd * (t.BODY_R if body else t.HEAD_R)}
	return [p, out]


## The faint figure's alpha: an uppercut thrown earlier in the combo stands out (1-6-3: "the 6 is not readable").
static func ghost_alpha(pose: Dictionary, a: float) -> float:
	return UPPERCUT_GHOST if _earlier_uppercut(pose) else a


## A rising arrow for each earlier uppercut: its fist from the dip to the chin, on its own faint figure.
static func ghost_arrows(t, ghosts: Array) -> Array:
	var out: Array = []
	for g in ghosts:
		var gp: Dictionary = g["pose"]
		if not _earlier_uppercut(gp):
			continue
		var off: Vector3 = g["off"]
		out.append(func() -> Array:
			var clip := str(gp["clip"])
			var hand := str(gp["hand"])
			var t1 := float(gp["t"])
			var u := Specs.wind_up(t._her, clip, hand, t1)
			var pts: Array = []
			t._img_size = Vector2(t.CARD, t.CARD)
			while true:
				t._pose(t._her, {"clip": clip, "t": u}, off)
				pts.append(t._px(t._glove_tip(t._her, hand)))
				if u >= t1:
					break
				u = minf(u + t.STEP_DT, t1)
			return pts)
	return out


## An uppercut thrown earlier in a combo (landed, at its contact) - not a single punch's own start figure (t 0).
static func _earlier_uppercut(pose: Dictionary) -> bool:
	return str(pose["clip"]).contains("uppercut") and float(pose["t"]) > 0.0
