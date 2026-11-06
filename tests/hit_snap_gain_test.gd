extends SceneTree
## S392: a fold that has ended leaves no gain behind. _gain_cur only eases while a brace runs, so it sat at FOLD_GAIN and the
## next plain brace started close to twice as hard as a brace should.

const HitSnap := preload("res://scripts/fight3d/HitSnap.gd")


func _initialize() -> void:
	var h := HitSnap.new()
	h.fold(true)
	h._gain_cur = HitSnap.FOLD_GAIN   # a fold at its height
	h._bt = HitSnap.FOLD_LIFE_S       # and at its end
	h._brace_step()
	var left := float(h._gain_cur)
	h.free()
	var ok := is_equal_approx(left, 1.0)
	print("%s the ended fold leaves gain %.2f (bar 1.00)" % ["ok  " if ok else "FAIL", left])
	print("HIT_SNAP_GAIN failures=%d" % (0 if ok else 1))
	quit(0 if ok else 1)
