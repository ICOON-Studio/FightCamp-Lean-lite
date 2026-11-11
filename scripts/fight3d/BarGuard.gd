extends RefCounted
## S428 BARGUARD1 (operator S426: "the hud hides players feet"). A cut frames the boots once (TvShot.BAR_CLEAR) and
## keeps that FOV for the whole shot. While the shot holds, a boxer can walk up to the lens and his boots slide under
## the corner bar. This lowers the look point first, then raises the lens, at most RATE_M_S, until every boot is back
## on or above the bar line. The FOV is never widened mid-shot.
##   lowest_boot(lens_xf, fov, aspect, boots) -> float    0 = on the bar line, negative = clear, positive = under it
##   fix(lens_xf, fov, aspect, boots, dt) -> {raise_m, look_drop_m}

const TvShot := preload("res://scripts/fight3d/TvShot.gd")

## Metres a second. A bigger step reads as a pop.
const RATE_M_S := 0.6
const _MIN_DEPTH := 0.05


## How far the lowest boot sits below the bar, as a fraction of the lower half of the picture.
## The bar covers the bottom ~16% (1 - BAR_CLEAR of the lower half). A boot above the look axis is clear (negative).
static func lowest_boot(lens_xf: Transform3D, fov: float, aspect: float, boots: Array) -> float:
	if aspect <= 0.0 or fov <= 1.0:
		return 1.0
	var t := tan(deg_to_rad(fov) * 0.5)
	var worst := -1.0
	var any := false
	var inv := lens_xf.affine_inverse()
	for b in boots:
		var c: Vector3 = inv * (b as Vector3)
		var depth := -c.z
		var below := 1.0
		if depth >= _MIN_DEPTH:
			below = -c.y / (t * depth) - TvShot.BAR_CLEAR
		if not any or below > worst:
			worst = below
			any = true
	return worst if any else -1.0


## The smallest step this frame that puts every boot back on the bar line. Look down first; raise the lens with
## whatever budget that left. A head that is already in frame (HEAD_M over the boot) is not pushed out.
static func fix(lens_xf: Transform3D, fov: float, aspect: float, boots: Array, dt: float) -> Dictionary:
	var zero := {"raise_m": 0.0, "look_drop_m": 0.0}
	if dt <= 0.0 or boots.is_empty() or aspect <= 0.0:
		return zero
	if lowest_boot(lens_xf, fov, aspect, boots) <= 0.0:
		return zero
	var budget := RATE_M_S * dt
	var origin := lens_xf.origin
	var look := _look_point(lens_xf, boots)
	var drop := _amount(origin, look, fov, aspect, boots, budget, lens_xf, false, 0.0)
	var raise := 0.0
	var left := budget - drop
	if left > 1e-8 and not _clear(origin, look, 0.0, drop, fov, aspect, boots):
		raise = _amount(origin, look, fov, aspect, boots, left, lens_xf, true, drop)
	return {"raise_m": raise, "look_drop_m": drop}


## The point the lens is aimed at, on its forward ray, level with the boots' middle. Lowering that point's y is the
## tilt; the caller does the same to its own look point.
static func _look_point(lens_xf: Transform3D, boots: Array) -> Vector3:
	var origin := lens_xf.origin
	var forward := -lens_xf.basis.z
	var mid := Vector3.ZERO
	var n := 0
	for b in boots:
		var p: Vector3 = b
		mid += Vector3(p.x, 0.0, p.z)
		n += 1
	mid /= float(n)
	var flat := Vector3(forward.x, 0.0, forward.z)
	if flat.length() < 0.02:
		return Vector3(mid.x, origin.y - 1.0, mid.z)
	var horiz := Vector3(mid.x - origin.x, 0.0, mid.z - origin.z).dot(flat.normalized())
	return origin + forward * maxf(horiz / flat.length(), 0.4)


static func _pose(origin: Vector3, look: Vector3, raise_m: float, drop_m: float) -> Transform3D:
	var o := origin
	o.y += raise_m
	var k := look
	k.y -= drop_m
	var dir := k - o
	if dir.length() < 0.05:
		dir = Vector3(0.0, -1.0, 0.2)
	return Transform3D(Basis.looking_at(dir, Vector3.UP), o)


static func _clear(origin: Vector3, look: Vector3, raise_m: float, drop_m: float, fov: float, aspect: float, boots: Array) -> bool:
	return lowest_boot(_pose(origin, look, raise_m, drop_m), fov, aspect, boots) <= 0.0


## One head per boxer: the highest boot at that spot, HEAD_M above it (pair_points' head, not the foot margin).
static func _heads(boots: Array) -> Array:
	var roots: Array = []
	for b in boots:
		var p: Vector3 = b
		var merged := false
		for i in roots.size():
			var q: Vector3 = roots[i]
			if Vector2(p.x - q.x, p.z - q.z).length() < 0.15:
				if p.y > q.y:
					roots[i] = p
				merged = true
				break
		if not merged:
			roots.append(p)
	var heads: Array = []
	for r in roots:
		heads.append((r as Vector3) + Vector3.UP * TvShot.HEAD_M)
	return heads


static func _keeps_heads(before: Transform3D, after: Transform3D, fov: float, aspect: float, boots: Array) -> bool:
	for h in _heads(boots):
		var p: Vector3 = h
		if TvShot.in_view(before, fov, aspect, p) and not TvShot.in_view(after, fov, aspect, p):
			return false
	return true


static func _safe(origin: Vector3, look: Vector3, raise_m: float, drop_m: float, fov: float, aspect: float, boots: Array, before: Transform3D) -> bool:
	return _keeps_heads(before, _pose(origin, look, raise_m, drop_m), fov, aspect, boots)


## Smallest metres along one axis (look-drop, or raise once the drop is locked) inside `budget` that clears the
## boots without losing a head. If the budget is not enough, take the largest safe step so the next frame continues.
static func _amount(origin: Vector3, look: Vector3, fov: float, aspect: float, boots: Array, budget: float, before: Transform3D, raising: bool, drop_locked: float) -> float:
	var cap := _max_safe(origin, look, fov, aspect, boots, budget, before, raising, drop_locked)
	if cap <= 1e-8:
		return 0.0
	var raise_cap := cap if raising else 0.0
	var drop_cap := drop_locked if raising else cap
	if not _clear(origin, look, raise_cap, drop_cap, fov, aspect, boots):
		return cap
	var lo := 0.0
	var hi := cap
	for _i in 16:
		var mid := (lo + hi) * 0.5
		var raise_m := mid if raising else 0.0
		var drop_m := drop_locked if raising else mid
		if _clear(origin, look, raise_m, drop_m, fov, aspect, boots):
			hi = mid
		else:
			lo = mid
	return hi


static func _max_safe(origin: Vector3, look: Vector3, fov: float, aspect: float, boots: Array, budget: float, before: Transform3D, raising: bool, drop_locked: float) -> float:
	if _holds(origin, look, budget, fov, aspect, boots, before, raising, drop_locked):
		return budget
	var lo := 0.0
	var hi := budget
	for _i in 16:
		var mid := (lo + hi) * 0.5
		if _holds(origin, look, mid, fov, aspect, boots, before, raising, drop_locked):
			lo = mid
		else:
			hi = mid
	return lo


static func _holds(origin: Vector3, look: Vector3, amount: float, fov: float, aspect: float, boots: Array, before: Transform3D, raising: bool, drop_locked: float) -> bool:
	var raise_m := amount if raising else 0.0
	var drop_m := drop_locked if raising else amount
	return _safe(origin, look, raise_m, drop_m, fov, aspect, boots, before)
