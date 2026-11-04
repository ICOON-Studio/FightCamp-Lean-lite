extends RefCounted
## MOVEPICS1 r4 (S383 skeptic, round 4) - the combo and rope cards built by the standard shot (tools/bake_move_pics.gd
## `t`), with what the review found wrong put right. In the review's words Maria is the red boxer (`t._her`), Lucy blue.
##   - every faint punch of a combo LANDS: its arm reached onto Lucy's chin or liver (within LAND_OK), its figure moved in
##     from the combo's step-back only as far as that reach needs (up to MAX_IN in front of the solid one) (1-6-3's uppercut, 3b-3's body hook)
##   - an earlier uppercut's rising arrow ends on Lucy's chin (the reach bends its last stretch in), never over Maria's head
##   - a rope card pins the right fighter: her back ON the top rope (opp/corner: Lucy; own: Maria, or her faint slip)
##   - each card its own camera, so no two share a frame (1-6-3@corner vs 3b-3@corner, 3b-3@opp_ropes vs @corner)
##   has(id)   camera(id, s)   place(t, id, s, fin, ghosts, part, ppos)   rope_z(...)   ghost_arrows(...)   measure(...)

const Specs := preload("res://tools/move_pic_specs.gd")
const Ideas3 := preload("res://tools/move_pic_ideas3.gd")

## id -> the card's own camera [az, elev] (null keeps the spec's) and where its faint figures stand (null keeps the step-back).
const CARDS := {
	"1-6-3": {"cam": [-90.0, 10.0], "ghost_x": [0.30, 0.16]},
	"1-6-3@corner": {"cam": [-105.0, 14.0], "ghost_x": [0.30, 0.16]},
	"3b-3": {"cam": null},
	"3b-3@corner": {"cam": [-138.0, 12.0]},
	"3b-3@inside": {"cam": [-100.0, 8.0]},
	"3b-3@opp_ropes": {"cam": [-158.0, 10.0]},
	"1-2@opp_ropes": {"cam": [-112.0, 10.0]},
	"slip 2-3@own_ropes": {"cam": [-50.0, 10.0], "ghost_off": [Vector3(-0.10, 0.0, -0.34)]},
	"tie_up@own_ropes": {"cam": [-45.0, 28.0]},
}
const LAND_OK := 0.02         # m: the reached glove's face this close to its mark counts as on it
const STEP_IN := 0.04         # m a faint figure moves in per try until its arm reaches
const REACH_PASSES := 4
const MAX_IN := 0.40          # m in front of the solid figure a faint one may stand (an uppercut is thrown from closer)


static func has(id: String) -> bool:
	return CARDS.has(id)


static func camera(id: String, s: Dictionary) -> void:
	var c: Variant = CARDS[id].get("cam")
	if c is Array:
		s["az"] = float(c[0])
		s["elev"] = float(c[1])


## A punch landed at its contact (a combo's earlier punch) - not a single punch's start figure, not a slip.
static func _lands(gp: Dictionary) -> bool:
	return Specs.PUNCHES.has(str(gp["clip"])) and float(gp["t"]) > 0.0


## The faint figures where the card wants them, each landed punch's arm reached onto its mark.
static func place(t, id: String, ghosts: Array, part: Dictionary, ppos: Vector3) -> void:
	var offs: Array = CARDS[id].get("ghost_off", [])
	var xs: Array = CARDS[id].get("ghost_x", [])
	for i in ghosts.size():
		var g: Dictionary = ghosts[i]
		if i < offs.size():
			g["off"] = offs[i]
		if i < xs.size():
			g["off"] = (g["off"] as Vector3) + Vector3(float(xs[i]), 0.0, 0.0)
		var gp: Dictionary = g["pose"]
		if not _lands(gp):
			continue
		gp.erase("ik")
		var hand := str(gp["hand"])
		var off: Vector3 = g["off"]
		if str(gp["clip"]).contains("uppercut"):
			off.z = _natural_z(t, gp, off, part, ppos)
		# In from the step-back until the reached glove is on its mark (the first try that lands, else the closest).
		var best := [INF, off, {}]
		for k in 24:
			var tip := _mark(t, gp, off, part, ppos)
			var test := gp.duplicate()
			test["ik"] = {"hand": hand, "tip": tip, "passes": REACH_PASSES}
			t._pose(t._her, test, off)
			var miss: float = (t._glove_tip(t._her, hand) as Vector3).distance_to(tip)
			if miss < float(best[0]):
				best = [miss, off, test["ik"]]
			if miss <= LAND_OK or off.z >= MAX_IN:
				break
			off.z = minf(off.z + STEP_IN, MAX_IN)
		g["off"] = best[1]
		gp["ik"] = best[2]


## An uppercut is thrown from close: the faint figure stands where the clip's own glove meets the chin (the reach then
## only fine-tunes it) - reached from further back, its rise read as a straight punch across Maria (S383 r4 look-dev).
static func _natural_z(t, gp: Dictionary, off: Vector3, part: Dictionary, ppos: Vector3) -> float:
	var plain := gp.duplicate()
	plain.erase("ik")
	t._pose(t._her, plain, off)
	var miss: Vector3 = _mark(t, gp, off, part, ppos) - t._glove_tip(t._her, str(gp["hand"]))
	return minf(off.z + miss.z, MAX_IN)


## Where a punch's glove face lands: HEAD_R short of the face (BODY_R of the liver) along the glove's travel - an
## uppercut's travel is upward, so it comes in under the chin.
static func _mark(t, gp: Dictionary, off: Vector3, part: Dictionary, ppos: Vector3) -> Vector3:
	var body := Specs.BODY_SHOTS.has(str(gp["clip"]))
	t._pose(t._spar, part, ppos)
	var tgt: Vector3 = t._target(t._spar, body)
	var plain := gp.duplicate()
	plain.erase("ik")
	var gm: Array = t._glove_motion(t._her, plain, off)
	var dir: Vector3 = gm[1]
	if not str(gp["clip"]).contains("uppercut"):
		dir = Vector3(dir.x, 0.0, dir.z).normalized()
	return tgt - dir * (t.BODY_R if body else t.HEAD_R)


## The ropes' depth for the card (NAN = Ideas2's default): on the pinned fighter's back.
static func rope_z(t, s: Dictionary, fin: Dictionary, ghosts: Array, part: Dictionary, ppos: Vector3) -> float:
	match str(s["ropes"]):
		"opp", "corner":
			t._pose(t._spar, part, ppos)
			return Ideas3.back_z(t, t._spar, 1.0) + Ideas3.ROPE_R
		"own":
			# Her faint slip stands on the ropes (she slips off them); otherwise the solid figure is pinned there.
			if not ghosts.is_empty() and str(ghosts[0]["pose"]["clip"]) == "slip":
				t._pose(t._her, ghosts[0]["pose"], ghosts[0]["off"])
			else:
				t._pose(t._her, fin, Vector3.ZERO)
			return Ideas3.back_z(t, t._her, -1.0) - Ideas3.ROPE_R
	return NAN


## The rising arrow of each earlier uppercut: from its dip to where its reached glove lands, under Lucy's chin.
static func ghost_arrows(t, ghosts: Array, m: Dictionary, part: Dictionary, ppos: Vector3) -> Array:
	var out: Array = []
	for g in ghosts:
		var gp: Dictionary = g["pose"]
		if not (str(gp["clip"]).contains("uppercut") and _lands(gp)):
			continue
		var off: Vector3 = g["off"]
		out.append(func() -> Array:
			var clip := str(gp["clip"])
			var hand := str(gp["hand"])
			var t1 := float(gp["t"])
			var t0 := Specs.wind_up(t._her, clip, hand, t1)
			var plain := gp.duplicate()
			plain.erase("ik")
			t._pose(t._her, plain, off)
			var bend: Vector3 = (gp["ik"]["tip"] as Vector3) - t._glove_tip(t._her, hand) if gp.has("ik") else Vector3.ZERO
			var pts: Array = []
			t._img_size = Vector2(t.CARD, t.CARD)
			var u := t0
			var end := Vector3.ZERO
			while true:
				t._pose(t._her, {"clip": clip, "t": u}, off)
				end = t._glove_tip(t._her, hand) + bend * smoothstep(t0, t1, u)
				pts.append(t._px(end))
				if u >= t1:
					break
				u = minf(u + t.STEP_DT, t1)
			t._pose(t._spar, part, ppos)
			m["uppercut_arrow_tip_m"] = snappedf(end.distance_to(t._target(t._spar, false)) - t.HEAD_R, 0.001)
			return pts)
	return out


## What the card measured on top of the standard row: each faint punch's glove gap, the arrow's tip on its mark, and
## the pinned back on the top rope.
static func measure(t, s: Dictionary, fin: Dictionary, ghosts: Array, part: Dictionary, ppos: Vector3, m: Dictionary) -> Dictionary:
	var out := m.duplicate()
	out["r4"] = true
	var gaps := []
	for g in ghosts:
		var gp: Dictionary = g["pose"]
		if not _lands(gp):
			continue
		var body := Specs.BODY_SHOTS.has(str(gp["clip"]))
		t._pose(t._spar, part, ppos)
		var tgt: Vector3 = t._target(t._spar, body)
		t._pose(t._her, gp, g["off"])
		gaps.append(snappedf((t._glove_tip(t._her, str(gp["hand"])) as Vector3).distance_to(tgt) - (t.BODY_R if body else t.HEAD_R), 0.001))
	if not gaps.is_empty():
		out["ghost_glove_gaps"] = gaps
	if str(s["kind"]) == "punch":
		t._pose(t._spar, part, ppos)
		var tgt2: Vector3 = t._target(t._spar, bool(s["body_shot"]))
		out["arrow_tip_m"] = snappedf((t._arrow_end as Vector3).distance_to(tgt2) - (t.BODY_R if bool(s["body_shot"]) else t.HEAD_R), 0.001)
	var rz := rope_z(t, s, fin, ghosts, part, ppos)
	if not is_nan(rz):
		out["rope_z"] = snappedf(rz, 0.001)
	t._pose(t._her, fin, Vector3.ZERO)
	t._pose(t._spar, part, ppos)
	return out


## The arrow from the point of its path furthest (on the card) from where it lands: a fist pulled back before it drives
## drew a hook-backed tail that read as a two-way arrow (1-2@opp_ropes, r4 look-dev).
static func from_furthest(pts: Array) -> Array:
	if pts.size() < 3:
		return pts
	var end: Vector2 = pts[-1]
	var at := 0
	for i in pts.size():
		if (pts[i] as Vector2).distance_to(end) > (pts[at] as Vector2).distance_to(end):
			at = i
	return pts.slice(at)
