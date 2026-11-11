extends SceneTree
## S428 BARGUARD1: while a shot holds, a boxer at the lens must not walk his boots under the corner bar.
## The cut's FOV stays. The correction looks lower first, then raises the lens, at most 0.6 m a second.

const BarGuard := preload("res://scripts/fight3d/BarGuard.gd")
const TvShot := preload("res://scripts/fight3d/TvShot.gd")

const ASPECT := 16.0 / 9.0
const DT := 1.0 / 60.0
const RATE := 0.6
const HOLD_S := 1.5

var failures := 0


func _initialize() -> void:
	_close()
	_far()
	_head()
	print("BAR_GUARD failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		failures += 1


func _xf(lens: Vector3, look: Vector3) -> Transform3D:
	return Transform3D(Basis.looking_at(look - lens, Vector3.UP), lens)


func _heads(boots: Array) -> Array:
	var out: Array = []
	for b in boots:
		out.append((b as Vector3) + Vector3.UP * TvShot.HEAD_M)
	return out


func _in_frame(xf: Transform3D, fov: float, heads: Array) -> bool:
	for h in heads:
		if not TvShot.in_view(xf, fov, ASPECT, h as Vector3):
			return false
	return true


## A main-shot lens, as a cut places it, for a pair standing apart in the middle.
func _shot() -> Dictionary:
	var a := Vector3(-0.6, 0.0, 0.0)
	var b := Vector3(0.6, 0.0, 0.0)
	var p := TvShot.place(a, b, Vector3.ZERO, 3.1, 0.0, 1.85, -1.0, ASPECT)
	return {"a": a, "b": b, "lens": p["lens"], "look": p["look"], "fov": float(p["fov"])}


func _step(lens: Vector3, look: Vector3, fov: float, boots: Array, dt: float) -> Dictionary:
	var g: Dictionary = BarGuard.fix(_xf(lens, look), fov, ASPECT, boots, dt)
	var raise := float(g["raise_m"])
	var drop := float(g["look_drop_m"])
	return {
		"lens": Vector3(lens.x, lens.y + raise, lens.z),
		"look": Vector3(look.x, look.y - drop, look.z),
		"raise_m": raise,
		"look_drop_m": drop,
		"keys": g.keys(),
	}


func _close() -> void:
	var shot := _shot()
	var lens: Vector3 = shot["lens"]
	var fov: float = shot["fov"]
	var flat := Vector3(lens.x, 0.0, lens.z)
	var toward := (Vector3.ZERO - flat).normalized()
	var near := flat + toward * 0.8
	var far := flat + toward * 2.5
	var boots: Array = [near, far]
	var look := Vector3((near.x + far.x) * 0.5, (shot["look"] as Vector3).y, (near.z + far.z) * 0.5)
	_check(absf(TvShot.flat_gap(lens, near) - 0.8) < 0.02, "(a) one boxer stands 0.8 m from the lens (%.2f)" % TvShot.flat_gap(lens, near))
	_check(absf(TvShot.flat_gap(lens, far) - 2.5) < 0.02, "(a) the other stands 2.5 m from the lens (%.2f)" % TvShot.flat_gap(lens, far))
	var start := BarGuard.lowest_boot(_xf(lens, look), fov, ASPECT, boots)
	_check(start > 0.0, "(a) his boots start under the bar (%.3f)" % start)
	var fov0 := fov
	var over := false
	var sum := 0.0
	for _i in 90:
		var stepped: Dictionary = _step(lens, look, fov, boots, DT)
		var raise := float(stepped["raise_m"])
		var drop := float(stepped["look_drop_m"])
		sum += raise + drop
		if raise < -1e-6 or drop < -1e-6 or raise + drop > RATE * DT + 1e-5 or raise > RATE * DT + 1e-5 or drop > RATE * DT + 1e-5:
			over = true
		if (stepped["keys"] as Array).has("fov"):
			over = true
		lens = stepped["lens"]
		look = stepped["look"]
	var end := BarGuard.lowest_boot(_xf(lens, look), fov, ASPECT, boots)
	_check(end <= 0.0, "(a) boots clear after 1.5 s at 60 fps (%.4f)" % end)
	_check(not over, "(c) the correction never exceeds 0.6 m a second")
	_check(sum <= RATE * HOLD_S + 1e-3, "(c) 1.5 s of correction stays within 0.9 m (%.3f)" % sum)
	_check(is_equal_approx(fov, fov0), "(d) the FOV is unchanged (%.2f)" % fov)


func _far() -> void:
	var shot := _shot()
	var lens: Vector3 = shot["lens"]
	var look: Vector3 = shot["look"]
	var fov: float = shot["fov"]
	var boots: Array = [shot["a"], shot["b"]]
	var before := BarGuard.lowest_boot(_xf(lens, look), fov, ASPECT, boots)
	_check(before < 0.0, "(b) both far: boots already clear (%.3f)" % before)
	var moved := false
	for _i in 120:
		var stepped: Dictionary = _step(lens, look, fov, boots, DT)
		if absf(float(stepped["raise_m"])) > 1e-8 or absf(float(stepped["look_drop_m"])) > 1e-8:
			moved = true
		lens = stepped["lens"]
		look = stepped["look"]
	_check(not moved, "(b) both far: the correction is zero (no drift)")


func _head() -> void:
	var shot := _shot()
	var lens: Vector3 = shot["lens"]
	var look: Vector3 = shot["look"]
	var fov: float = shot["fov"]
	var boots: Array = [shot["a"], shot["b"]]
	var heads := _heads(boots)
	# The cut's FOV is capped at 60, so the placed head can sit a hair outside in_view. The held shot the
	# operator sees is the other way: the head is in the picture and the boots have slipped under the bar.
	var found := false
	for step in 80:
		var lifted := Vector3(look.x, look.y + 0.01 * float(step + 1), look.z)
		var low := BarGuard.lowest_boot(_xf(lens, lifted), fov, ASPECT, boots)
		if low > 0.01 and _in_frame(_xf(lens, lifted), fov, heads):
			look = lifted
			found = true
			break
	_check(found and _in_frame(_xf(lens, look), fov, heads), "(e) the head starts in frame (HEAD_M) while the boots are under the bar")
	var fov0 := fov
	for _i in 90:
		var stepped: Dictionary = _step(lens, look, fov, boots, DT)
		lens = stepped["lens"]
		look = stepped["look"]
	var end_xf := _xf(lens, look)
	_check(BarGuard.lowest_boot(end_xf, fov, ASPECT, boots) <= 0.0, "(e) boots clear without giving up the head")
	_check(_in_frame(end_xf, fov, heads), "(e) the head still in frame (HEAD_M)")
	_check(is_equal_approx(fov, fov0), "(d) the FOV stays the cut's FOV")
