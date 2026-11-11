extends RefCounted
## CAMLINE2 the fight camera's RULER (operator S429: the lens straight behind one boxer hides the other; the far ropes fade
## at head height; "its the gloves that have a weird blur effect"). Pure reads: no camera rule calls these yet - the probe
## (tools/cam_line_probe.gd) and tests/cam_line_test.gd do. Nothing here touches the scene tree or decides a shot.
##   project(xf, fov, aspect, p)        hidden(xf, fov, aspect, me, other)   hidden_share(xf, fov, aspect, a, b)
##   rope_rows(ring_side)               ropes_read(rows, lens, feet)         between(lens, foot, a, b)
##   far_ropes(rows, xf, .., heads, ..)  far_blur(lens_attributes, d)        longest_run(rows, key, at, at_least)
##   smear(still, moved, at, dir)       bleed(smear result, at, dir, heads, ropes)
## A boxer is a Dictionary of world points, read from the skeleton AS SHOWN (after its modifiers):
##   head (the skull's base), sh_l, sh_r (shoulder joints), el_l, el_r, hand_l, hand_r (the glove's middle), hips, feet.
## "Behind" is TvShot.behind_deg (one copy of that rule).

## The bars this ruler is read against (frozen in Part A; Part B changes none of them).
const HIDDEN_AT := 0.6            # a boxer is HIDDEN when this share of the head-and-chest box is covered by the other body
const HIDDEN_SHARE_MAX := 0.02    # share of live frames with a HIDDEN boxer
const HIDDEN_RUN_MAX_S := 0.4     # the longest a boxer may stay HIDDEN
const BEHIND_DEG := 30.0          # TvShot.behind_deg under this = the lens looks along the pair
const BEHIND_RUN_MAX_S := 0.4     # the longest the lens may look along the pair
const FADED_AT := 0.95            # a rope piece under this alpha counts as faded
const SPLIT_AT := 0.02            # one rope whose pieces differ by more than this in alpha is cut in two
const SMEAR_MAX := 1.3            # a glove at full speed may smear to this many times its own width (TASK_CAMLINE1 step 3)

## The body, metres on a 1.75 m boxer (the shoulder half width itself is measured from the two shoulder joints).
const SHOULDER_PAD_M := 0.05      # the deltoid outside the shoulder joint
const SHOULDER_MIN_M := 0.17
const HEAD_R_M := 0.10
const HEAD_UP_M := 0.10           # the skull's base to the head's middle
const ARM_R_M := 0.05
const GLOVE_R_M := 0.09
const GRID := Vector2i(12, 16)    # sample points over the head-and-chest box
const DEPTH_GAP_M := 0.05         # a part hides only what is at least this much farther from the lens

## The glove's smear (pixels along its travel): a pixel counts as glove-coloured in the still frame when its colour
## direction is within GLOVE_TOL of the glove's; beyond the glove it counts as smeared when the played frame moved it at
## least TINT_AT of the way from the still colour to the glove's colour; a hole of up to GAP_PX is bridged (and counted
## as a ghost: separate copies of the glove instead of one streak).
const GLOVE_TOL := 0.2
const TINT_AT := 0.15
const BLEED_AT := 0.25
const GAP_PX := 5


## `p` on the picture of a lens at `xf`: x and y in -1..1 inside the frame (y up), z = metres in front of the lens
## (x, y = INF when it is not in front).
static func project(xf: Transform3D, fov: float, aspect: float, p: Vector3) -> Vector3:
	var c := xf.affine_inverse() * p
	var t := tan(deg_to_rad(fov) * 0.5)
	if -c.z < 0.05 or t < 0.0001:
		return Vector3(INF, INF, -c.z)
	return Vector3(c.x / -c.z / (t * aspect), c.y / -c.z / t, -c.z)


## Half the shoulder width of `body`, metres: measured between its shoulder joints, plus the deltoid.
static func half_width(body: Dictionary) -> float:
	return maxf(SHOULDER_MIN_M, 0.5 * (body["sh_l"] as Vector3).distance_to(body["sh_r"]) + SHOULDER_PAD_M)


## The screen rectangle round `pts` = [[point, metres across the view, metres up and down], ...]: every point is widened
## ACROSS THE CAMERA'S VIEW (along the lens's own right and up), never along a world axis - the same body gives the same
## box from every side of the ring. {rect, depth}; an empty rect when no point is in front of the lens.
static func span(xf: Transform3D, fov: float, aspect: float, pts: Array) -> Dictionary:
	var right := xf.basis.x.normalized()
	var up := xf.basis.y.normalized()
	var lo := Vector2(INF, INF)
	var hi := Vector2(-INF, -INF)
	var depth := 0.0
	var n := 0
	for row in pts:
		var at: Vector3 = row[0]
		var mid := project(xf, fov, aspect, at)
		if not is_finite(mid.x):
			continue
		depth += mid.z
		n += 1
		for o in [right * float(row[1]), -right * float(row[1]), up * float(row[2]), -up * float(row[2])]:
			var s := project(xf, fov, aspect, at + (o as Vector3))
			if is_finite(s.x):
				lo = Vector2(minf(lo.x, s.x), minf(lo.y, s.y))
				hi = Vector2(maxf(hi.x, s.x), maxf(hi.y, s.y))
	if n == 0 or hi.x <= lo.x or hi.y <= lo.y:
		return {"rect": Rect2(), "depth": 0.0}
	return {"rect": Rect2(lo, hi - lo), "depth": depth / n}


## The body as screen boxes, nearest-first is NOT implied: [head, chest (shoulders to hips), legs, then per arm: upper
## arm, forearm, glove]. The first two are the head-and-chest box the HIDDEN bar is about.
static func parts(xf: Transform3D, fov: float, aspect: float, body: Dictionary) -> Array:
	var s := float(body.get("scale", 1.0))
	var w := half_width(body)
	var chest: Vector3 = ((body["sh_l"] as Vector3) + (body["sh_r"] as Vector3)) * 0.5
	var head: Vector3 = (body["head"] as Vector3) + Vector3.UP * HEAD_UP_M * s
	var out: Array = [
		span(xf, fov, aspect, [[head, HEAD_R_M * s, HEAD_R_M * s]]),
		span(xf, fov, aspect, [[chest, w, 0.05 * s], [body["hips"], w, 0.0]]),
		span(xf, fov, aspect, [[body["hips"], w, 0.0], [body["feet"], w * 0.8, 0.0]]),
	]
	for side in ["l", "r"]:
		out.append(span(xf, fov, aspect, [[body["sh_" + side], ARM_R_M * s, ARM_R_M * s], [body["el_" + side], ARM_R_M * s, ARM_R_M * s]]))
		out.append(span(xf, fov, aspect, [[body["el_" + side], ARM_R_M * s, ARM_R_M * s], [body["hand_" + side], ARM_R_M * s, ARM_R_M * s]]))
		out.append(span(xf, fov, aspect, [[body["hand_" + side], GLOVE_R_M * s, GLOVE_R_M * s]]))
	return out


## The head-and-chest box of `body` on screen (the two boxes merged).
static func head_chest_box(xf: Transform3D, fov: float, aspect: float, body: Dictionary) -> Rect2:
	var p := parts(xf, fov, aspect, body)
	var a: Rect2 = p[0]["rect"]
	var b: Rect2 = p[1]["rect"]
	if not a.has_area():
		return b
	return a.merge(b) if b.has_area() else a


## The share (0..1) of `me`'s head-and-chest box that `other`'s body covers, as this lens sees it: GRID points over the
## box, a point counted when a part of the other body that is NEARER the lens lies over it. 0 when the box is not in
## front of the lens. `boxes` 1 = her head alone (is the FACE covered).
static func hidden(xf: Transform3D, fov: float, aspect: float, me: Dictionary, other: Dictionary, boxes: int = 2) -> float:
	var mine := parts(xf, fov, aspect, me)
	var theirs := parts(xf, fov, aspect, other)
	var box: Rect2 = head_chest_box(xf, fov, aspect, me) if boxes == 2 else mine[0]["rect"]
	if not box.has_area():
		return 0.0
	var seen := 0
	var covered := 0
	for iy in GRID.y:
		for ix in GRID.x:
			var p := box.position + box.size * Vector2((ix + 0.5) / GRID.x, (iy + 0.5) / GRID.y)
			var depth := INF
			for k in boxes:
				if (mine[k]["rect"] as Rect2).has_point(p):
					depth = minf(depth, float(mine[k]["depth"]))
			if not is_finite(depth):
				continue
			seen += 1
			for c in theirs:
				if float(c["depth"]) < depth - DEPTH_GAP_M and (c["rect"] as Rect2).has_point(p):
					covered += 1
					break
	return float(covered) / seen if seen > 0 else 0.0


## The worse of the two: how much of either boxer the other one hides. A frame is HIDDEN at HIDDEN_AT or more.
static func hidden_share(xf: Transform3D, fov: float, aspect: float, a: Dictionary, b: Dictionary) -> float:
	return maxf(hidden(xf, fov, aspect, a, b), hidden(xf, fov, aspect, b, a))


## One row for each rope piece and post of the list the game hands RingCamera.clear_view (FightStage._ring_side):
## {rope (its id; -1 = a post), alpha, a, b (the piece's two ends, world)}. The nodes must be in the tree.
static func rope_rows(ring_side: Array) -> Array:
	var rows: Array = []
	for n in ring_side:
		var m := n as MeshInstance3D
		var mat := m.material_override as StandardMaterial3D
		var half := m.global_transform.basis.y * float((m.mesh as CylinderMesh).height) * 0.5
		rows.append({"rope": int(m.get_meta("rope")) if m.has_meta("rope") else -1,
			"alpha": mat.albedo_color.a if mat != null else 1.0, "a": m.global_position - half, "b": m.global_position + half})
	return rows


## The piece a..b truly stands BETWEEN the lens and a boxer standing at `foot` (flat): the line from the lens to her
## (her middle and `half_m` to each side) crosses the piece at least BODY_M before it reaches her. A rope she leans on is
## beside her, not in front (a side of her body that would stand beyond the rope's line is not looked at); a rope behind
## her is not between. From a lens inside the ropes no rope is ever between.
const BODY_M := 0.15
static func between(lens: Vector3, foot: Vector3, a: Vector3, b: Vector3, half_m: float = 0.25) -> bool:
	var l := Vector2(lens.x, lens.z)
	var f := Vector2(foot.x, foot.z)
	if l.distance_to(f) < 0.05:
		return false
	var across := (f - l).normalized().orthogonal() * half_m
	var pa := Vector2(a.x, a.z)
	var pb := Vector2(b.x, b.z)
	for off in [Vector2.ZERO, across, -across]:
		var to: Vector2 = f + (off as Vector2)
		if (pb - pa).cross(f - pa) * (pb - pa).cross(to - pa) < 0.0:
			continue
		var hit: Variant = Geometry2D.segment_intersects_segment(l, to, pa, pb)
		if hit != null and l.distance_to(hit as Vector2) <= l.distance_to(f) - BODY_M:
			return true
	return false


## Reads the ring side per rope: {rope id: {pieces, faded (pieces under FADED_AT), lo, hi (alpha), split (one rope, two
## alphas), between (a piece of it truly stands between the lens and a boxer of `feet`)}}. Posts (rope -1) are left out.
static func ropes_read(rows: Array, lens: Vector3, feet: Array) -> Dictionary:
	var out := {}
	for r in rows:
		var id := int(r["rope"])
		if id < 0:
			continue
		if not out.has(id):
			out[id] = {"pieces": 0, "faded": 0, "lo": 1.0, "hi": 0.0, "split": false, "between": false}
		var o: Dictionary = out[id]
		var al := float(r["alpha"])
		o["pieces"] = int(o["pieces"]) + 1
		o["faded"] = int(o["faded"]) + (1 if al < FADED_AT else 0)
		o["lo"] = minf(float(o["lo"]), al)
		o["hi"] = maxf(float(o["hi"]), al)
		if not bool(o["between"]):
			for f in feet:
				if between(lens, f, r["a"], r["b"]):
					o["between"] = true
					break
	for rid in out:
		out[rid]["split"] = float(out[rid]["hi"]) - float(out[rid]["lo"]) > SPLIT_AT
	return out


## The longest unbroken run of rows (in time order) whose `key` is at least `at` (`at_least`) or under it; a row that is
## not `live` ends a run. [rows in the run, the index of its last row] (-1 when there is none).
static func longest_run(rows: Array, key: String, at: float, at_least: bool) -> Array:
	var run := 0
	var best := [0, -1]
	for i in rows.size():
		var r: Dictionary = rows[i]
		run = run + 1 if bool(r["live"]) and (float(r[key]) >= at) == at_least else 0
		if run > int(best[0]):
			best = [run, i]
	return best


## The FAR ropes at the height of a head: pieces of `rows` in the picture, farther than `far_m` (both boxers), whose
## height on screen lies inside one of `heads` (screen boxes). {at_head (0|1), faded (pieces there under FADED_AT),
## blur (the lens's far blur at the farthest of them), seen (rope id -> [lowest, highest alpha in the picture])}.
static func far_ropes(rows: Array, xf: Transform3D, fov: float, aspect: float, heads: Array, far_m: float,
		lens: CameraAttributesPractical) -> Dictionary:
	var out := {"at_head": 0, "faded": 0, "blur": 0.0, "seen": {}}
	for row in rows:
		if int(row["rope"]) < 0:
			continue
		var at: Vector3 = ((row["a"] as Vector3) + (row["b"] as Vector3)) * 0.5
		var p := project(xf, fov, aspect, at)
		if not is_finite(p.x) or absf(p.x) > 1.0 or absf(p.y) > 1.0:
			continue
		var al := float(row["alpha"])
		var lohi: Array = out["seen"].get(row["rope"], [1.0, 0.0])
		out["seen"][row["rope"]] = [minf(float(lohi[0]), al), maxf(float(lohi[1]), al)]
		if p.z < far_m:
			continue
		for h in heads:
			if (h as Rect2).has_area() and p.y >= (h as Rect2).position.y and p.y <= (h as Rect2).end.y:
				out["at_head"] = 1
				out["blur"] = maxf(float(out["blur"]), far_blur(lens, xf.origin.distance_to(at)))
				out["faded"] = int(out["faded"]) + (1 if al < FADED_AT else 0)
				break
	return out


## The lens's far blur at `d` metres, 0..amount, read from its attributes: beyond dof_blur_far_distance the blur grows
## over dof_blur_far_transition up to dof_blur_amount (CameraAttributesPractical). 0 when the far blur is off.
static func far_blur(lens: CameraAttributesPractical, d: float) -> float:
	if lens == null or not lens.dof_blur_far_enabled:
		return 0.0
	return lens.dof_blur_amount * clampf((d - lens.dof_blur_far_distance) / maxf(lens.dof_blur_far_transition, 0.001), 0.0, 1.0)


## The glove's smear, pixels along its travel. `still` = the SAME pose drawn with nothing moving (no motion blur can act),
## `moved` = that frame as the game played it; `at` = the glove's middle (pixels), `dir` = its travel on screen. Colours
## are averaged over `band` pixels to each side of the line; the line runs `reach` pixels both ways.
## {glove (its colour), still_px (the glove's own width along the line), smear_px (that width plus the smear at both
## ends), lo, hi (the glove's run, pixels from `at`), ext_lo, ext_hi (the run with its smear), tint (per pixel, index
## s + reach: how far the played frame moved that pixel toward the glove's colour), core (share of the glove's own run
## still glove-coloured in the played frame: under 1 = a washed or see-through glove), ghosts (holes bridged)}.
static func smear(still: Image, moved: Image, at: Vector2, dir: Vector2, band: int = 6, reach: int = 260) -> Dictionary:
	var d := dir.normalized() if dir.length() > 0.001 else Vector2.RIGHT
	var n := d.orthogonal()
	var g := _band(still, at, n, 2)
	var cs: Array = []
	var cm: Array = []
	for s in range(-reach, reach + 1):
		cs.append(_band(still, at + d * s, n, band))
		cm.append(_band(moved, at + d * s, n, band))
	var lo := 0
	while lo > -reach and _hue_gap(cs[lo - 1 + reach], g) < GLOVE_TOL:
		lo -= 1
	var hi := 0
	while hi < reach and _hue_gap(cs[hi + 1 + reach], g) < GLOVE_TOL:
		hi += 1
	var tint := PackedFloat32Array()
	tint.resize(reach * 2 + 1)
	for i in tint.size():
		var c: Vector3 = cs[i]
		var to := g - c
		tint[i] = 0.0 if to.length() < 0.12 else ((cm[i] as Vector3) - c).dot(to) / to.length_squared()
	var ghosts := 0
	var ext := [lo, hi]
	for e in 2:
		var step := -1 if e == 0 else 1
		var q := int(ext[e])
		var gap := 0
		while absi(q + step) <= reach and gap <= GAP_PX:
			q += step
			if tint[q + reach] >= TINT_AT:
				if gap > 2:
					ghosts += 1
				gap = 0
				ext[e] = q
			else:
				gap += 1
	var solid := 0
	for k in range(lo, hi + 1):
		if _hue_gap(cm[k + reach], g) < GLOVE_TOL:
			solid += 1
	return {"glove": Color(g.x, g.y, g.z), "still_px": hi - lo + 1, "smear_px": int(ext[1]) - int(ext[0]) + 1, "lo": lo, "hi": hi,
		"ext_lo": int(ext[0]), "ext_hi": int(ext[1]), "tint": tint, "core": float(solid) / (hi - lo + 1), "ghosts": ghosts}


## The mean colour (r, g, b) of `img` over `band` pixels to each side of `p` along `n`.
static func _band(img: Image, p: Vector2, n: Vector2, band: int) -> Vector3:
	var sum := Vector3.ZERO
	for k in range(-band, band + 1):
		var q := p + n * k
		var c := img.get_pixel(clampi(int(round(q.x)), 0, img.get_width() - 1), clampi(int(round(q.y)), 0, img.get_height() - 1))
		sum += Vector3(c.r, c.g, c.b)
	return sum / (band * 2 + 1)


## How far apart two colours are in direction (hue and saturation, not brightness: a glove is lit on one side and in
## shadow on the other); a near-black pixel matches nothing.
static func _hue_gap(c: Vector3, g: Vector3) -> float:
	if c.length() < 0.06 or g.length() < 0.06:
		return 9.0
	return c.normalized().distance_to(g.normalized())


## Where a glove's smear (a `smear` result along `dir` through `at`) lands on what is behind it: pixels of the smear,
## outside the glove's own run and tinted at least BLEED_AT, that lie on a face (`heads`: [[middle, radius], ...]) or on
## a rope (`ropes`: [[end, end, half thickness], ...]), all in pixels. [on a face, on a rope].
static func bleed(res: Dictionary, at: Vector2, dir: Vector2, heads: Array, ropes: Array) -> Array:
	var d := dir.normalized()
	var reach := ((res["tint"] as PackedFloat32Array).size() - 1) / 2
	var out := [0, 0]
	for k in range(int(res["ext_lo"]), int(res["ext_hi"]) + 1):
		if (k >= int(res["lo"]) and k <= int(res["hi"])) or float(res["tint"][k + reach]) < BLEED_AT:
			continue
		var p := at + d * k
		for h in heads:
			if p.distance_to(h[0]) < float(h[1]):
				out[0] = int(out[0]) + 1
				break
		for rope in ropes:
			if Geometry2D.get_closest_point_to_segment(p, rope[0], rope[1]).distance_to(p) < float(rope[2]):
				out[1] = int(out[1]) + 1
				break
	return out


## How far two pictures of one pose differ inside `box`: the mean colour step per channel (every third pixel). 0 = the
## same picture (no blur acted anywhere in the box).
static func picture_gap(a: Image, b: Image, box: Rect2i) -> float:
	var sum := 0.0
	var n := 0
	for y in range(box.position.y, box.end.y, 3):
		for x in range(box.position.x, box.end.x, 3):
			var ca := a.get_pixel(x, y)
			var cb := b.get_pixel(x, y)
			sum += (absf(ca.r - cb.r) + absf(ca.g - cb.g) + absf(ca.b - cb.b)) / 3.0
			n += 1
	return sum / maxf(1.0, n)
