extends SceneTree
## S391: between punches a boxer leaves the line on her own. In a punch of her own, or anything else not free, the weave lets go. Pure: GuardWeave.step, no bones.
const GuardWeave := preload("res://scripts/fight3d/GuardWeave.gd")

var _fails := 0


func _initialize() -> void:
	var w := GuardWeave.new()
	w.rng.seed = 7
	var spread := 0.0
	var moves := 0
	var last := 0.0
	for f in 30 * 30:
		w.step(1.0 / 30.0, true)
		spread = maxf(spread, absf(w.pos.x))
		if absf(w.pos.x - last) > 0.01:
			moves += 1
		last = w.pos.x
		_check(absf(w.pos.x) <= 1.0 and w.pos.y >= -0.01 and w.pos.y <= 1.0, "stays inside its limits")
	print("passive: furthest %.2f, moving %d of 900 frames" % [spread, moves])
	_check(spread >= 0.4, "she leaves the line on her own")
	_check(moves >= 300, "she keeps moving between punches")

	var own := GuardWeave.new()
	own.rng.seed = 3
	for f in 30:
		own.step(1.0 / 30.0, true)
	for f in 15:
		own.step(1.0 / 30.0, false)
	_check(own.weight == 0.0, "her own punch lets the weave go")
	own.free()
	w.free()
	print("guard_weave_test: %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
