extends SceneTree
## S498 FIGHT MOTION WEEK day 3: heads never overlap inside (HeadClear, the rule GloveClear's head lean runs on).
## The numbers of the r2b film's two overlaps (a body shot against the gut-shot fold): heads 15-19 cm apart, the hit
## head lower, hips 0.8-1.0 m apart.

const HC := preload("res://scripts/fight3d/HeadClear.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("PASS ", what)
	else:
		failures += 1
		print("FAIL ", what)


func _gap(a: Vector3, b: Vector3) -> float:
	return a.distance_to(b)


func _init() -> void:
	var hips0 := Vector3(0, 0.9, 0)
	var hips1 := Vector3(0.9, 0.9, 0)

	# 1. far apart: nothing
	var far: Dictionary = HC.want(Vector3(0.1, 1.5, 0), Vector3(0.8, 1.5, 0), hips0, hips1)
	_check((far["push"] as Vector3).length() == 0.0 and int(far["side"]) == 0, "heads 70 cm apart: no lean")

	# 2. the film's overlap, dead in line: both lean, to opposite sides, and the pair ends clear
	var c0 := Vector3(0.36, 1.40, 0.0)
	var c1 := Vector3(0.52, 1.36, 0.0)
	var w0: Dictionary = HC.want(c0, c1, hips0, hips1)
	var w1: Dictionary = HC.want(c1, c0, hips1, hips0)
	var p0: Vector3 = w0["push"]
	var p1: Vector3 = w1["push"]
	_check(p0.length() > 0.03 and p1.length() > 0.03, "heads 16 cm apart: both lean (%.3f, %.3f m)" % [p0.length(), p1.length()])
	_check(absf(p0.y) < 1e-6 and absf(p1.y) < 1e-6, "the lean is horizontal")
	_check(p0.z * p1.z < 0.0, "dead in line: the heads go to opposite sides (z %.3f / %.3f)" % [p0.z, p1.z])
	_check(p0.x < 0.0 and p1.x > 0.0, "each also comes back off the other (x %.3f / %.3f)" % [p0.x, p1.x])
	_check(absf(p0.z) > 0.5 * absf(p0.x), "the lean is sideways at least half as much as back")
	var after := _gap(c0 + p0, c1 + p1)
	_check(after >= HC.TOUCH_M - 0.005, "after both leans the centres are %.3f m apart (touch %.2f)" % [after, HC.TOUCH_M])
	_check(after <= HC.TOUCH_M + HC.SOFT_M, "and not thrown apart (%.3f m)" % after)
	_check((p0 + p1).length() < 1e-4, "the two leans mirror each other")

	# 3. a head already to one side goes further that way (no crossing through the other's head)
	var s0: Dictionary = HC.want(c0 + Vector3(0, 0, 0.06), c1, hips0, hips1)
	var s1: Dictionary = HC.want(c1, c0 + Vector3(0, 0, 0.06), hips1, hips0)
	_check((s0["push"] as Vector3).z > 0.0, "a head 6 cm to one side leans further to that side")
	_check((s1["push"] as Vector3).z < 0.0, "and the other leans the other way")
	var s2: Dictionary = HC.want(c0 + Vector3(0, 0, -0.06), c1, hips0, hips1)
	_check((s2["push"] as Vector3).z < 0.0 and int(s2["side"]) == -int(s0["side"]), "the other side the same")

	# 4. dead in line the last side is kept (no flip from frame to frame)
	var k1: Dictionary = HC.want(c0 + Vector3(0, 0, 0.01), c1, hips0, hips1, HC.TOUCH_M, -1)
	var k2: Dictionary = HC.want(c0 + Vector3(0, 0, -0.01), c1, hips0, hips1, HC.TOUCH_M, 1)
	_check(int(k1["side"]) == -1 and int(k2["side"]) == 1, "inside 3 cm of the line the last side is kept")
	# ... and outside it too: the fold crosses the line in a frame, a side once taken never flips mid-lean
	var k3: Dictionary = HC.want(c0 + Vector3(0, 0, 0.07), c1, hips0, hips1, HC.TOUCH_M, -1)
	_check(int(k3["side"]) == -1 and (k3["push"] as Vector3).z * (k1["push"] as Vector3).z > 0.0, "a head 7 cm across the line keeps the side it took")

	# 5. one head well below the other: the 3D distance is already the touch
	var low: Dictionary = HC.want(Vector3(0.40, 1.05, 0), Vector3(0.50, 1.40, 0), hips0, hips1)
	_check((low["push"] as Vector3).length() == 0.0, "a head 35 cm lower: no lean")

	# 6. the soft start: just outside the touch a small lean, growing as they close
	var a: Dictionary = HC.want(Vector3(0.30, 1.4, 0), Vector3(0.30 + HC.TOUCH_M + 0.02, 1.4, 0), hips0, hips1)
	var b: Dictionary = HC.want(Vector3(0.30, 1.4, 0), Vector3(0.30 + HC.TOUCH_M - 0.06, 1.4, 0), hips0, hips1)
	var out: Dictionary = HC.want(Vector3(0.30, 1.4, 0), Vector3(0.30 + HC.TOUCH_M + 0.05, 1.4, 0), hips0, hips1)
	var la := (a["push"] as Vector3).length()
	var lb := (b["push"] as Vector3).length()
	_check(la > 0.0 and la < 0.01, "2 cm outside the touch: a few mm of lean (%.4f)" % la)
	_check(lb > la * 3.0, "6 cm inside it: more (%.4f)" % lb)
	_check((out["push"] as Vector3).length() == 0.0, "5 cm outside it: none")
	_check(is_equal_approx(HC.knee(-0.04, 0.08), 0.0) and is_equal_approx(HC.knee(0.04, 0.08), 0.04) and HC.knee(0.0, 0.08) > 0.0, "the knee meets both ends")

	# 7. the boxer whose punch is landing gives less, the pair still ends clear
	_check(is_equal_approx(HC.shares(0.0, 0.0), 0.5) and is_equal_approx(HC.shares(1.0, 0.0), HC.HOLD_SHARE) and is_equal_approx(HC.shares(0.0, 1.0), 1.0 - HC.HOLD_SHARE), "shares: half each, the landing punch a quarter")
	var h0: Dictionary = HC.want(c0, c1, hips0, hips1, HC.TOUCH_M, 0, HC.shares(1.0, 0.0))
	var h1: Dictionary = HC.want(c1, c0, hips1, hips0, HC.TOUCH_M, 0, HC.shares(0.0, 1.0))
	_check((h0["push"] as Vector3).length() < (h1["push"] as Vector3).length() * 0.5, "the hitter leans under half of what she does")
	var after_h := _gap(c0 + (h0["push"] as Vector3), c1 + (h1["push"] as Vector3))
	_check(after_h >= HC.TOUCH_M - 0.005, "and the pair is still clear (%.3f)" % after_h)

	# 8. never more than MAX_M
	var deep: Dictionary = HC.want(Vector3(0.40, 1.4, 0), Vector3(0.41, 1.4, 0), hips0, hips1, 0.60, 0, 1.0)
	_check((deep["push"] as Vector3).length() <= HC.MAX_M + 1e-6, "a lean is capped at %.2f m" % HC.MAX_M)

	# 9. the heads on one spot: still a direction (off the line to the other, to her own left)
	var same: Dictionary = HC.want(c0, c0, hips0, hips1)
	var ps: Vector3 = same["push"]
	_check(ps.length() > 0.05 and ps.x < 0.0 and absf(ps.z) > 0.01, "heads on one spot: back and to a side")

	# 10. it never pops: grows at most RISE_MPS, goes at most FALL_MPS
	var dt := 1.0 / 30.0
	var e1: Vector3 = HC.ease(Vector3.ZERO, Vector3(0.12, 0, 0), dt)
	_check(is_equal_approx(e1.length(), HC.RISE_MPS * dt), "one frame grows %.3f m" % e1.length())
	var e2: Vector3 = HC.ease(Vector3(0.12, 0, 0), Vector3.ZERO, dt)
	_check(is_equal_approx(0.12 - e2.length(), HC.FALL_MPS * dt), "one frame gives back %.3f m" % (0.12 - e2.length()))
	var e3: Vector3 = HC.ease(Vector3(0.10, 0, 0), Vector3(0.101, 0, 0), dt)
	_check(is_equal_approx(e3.x, 0.101), "a small change is taken whole")
	_check(HC.RISE_MPS * dt < 0.09, "a frame's growth stays under PopCap's 9 cm a frame")

	# 11. the line to the other missing (hips on one spot): still finite
	var nl: Dictionary = HC.want(c0, c1, hips0, hips0)
	_check((nl["push"] as Vector3).is_finite() and (nl["push"] as Vector3).length() > 0.0, "no line between the hips: a finite lean")

	# 12. the body puncher's dip: sideways only, to his own left by default, more the nearer the heads, none at range
	_check(HC.low_punch("pro_body_shot") and HC.low_punch("pro_kidney_shot") and HC.low_punch("body_hook") and not HC.low_punch("pro_left_jab") and not HC.low_punch(""), "a body punch is known by its clip")
	var d_near: Dictionary = HC.dip(Vector3(0.20, 1.4, 0), Vector3(0.70, 1.4, 0), hips0, hips1)
	var d_mid: Dictionary = HC.dip(Vector3(0.10, 1.4, 0), Vector3(0.88, 1.4, 0), hips0, hips1)
	var d_far: Dictionary = HC.dip(Vector3(0.0, 1.5, 0), Vector3(1.0, 1.5, 0), hips0, hips1)
	var dn: Vector3 = d_near["push"]
	_check(is_equal_approx(dn.length(), HC.DIP_M) and absf(dn.x) < 1e-6 and absf(dn.y) < 1e-6, "heads 50 cm apart: the full dip, sideways only (%.3f)" % dn.length())
	_check((d_mid["push"] as Vector3).length() > 0.0 and (d_mid["push"] as Vector3).length() < HC.DIP_M, "78 cm apart: part of it")
	_check((d_far["push"] as Vector3).length() == 0.0, "a metre apart: none")
	var left0 := Vector3.UP.cross((hips1 - hips0).normalized())
	_check(dn.dot(left0) > 0.0 and int(d_near["side"]) == 1, "dead in line he dips to his own left")
	var d_keep: Dictionary = HC.dip(Vector3(0.20, 1.4, 0), Vector3(0.70, 1.4, 0), hips0, hips1, -1)
	_check((d_keep["push"] as Vector3).dot(left0) < 0.0, "a side once taken is kept")
	var d_off: Dictionary = HC.dip(Vector3(0.20, 1.4, 0) - left0 * 0.08, Vector3(0.70, 1.4, 0), hips0, hips1)
	_check((d_off["push"] as Vector3).dot(left0) < 0.0, "a head already to the right dips right")
	# the fold then comes down beside the dipped head: she takes the other side at once
	var dipped := c0 + (HC.dip(c0, c1, hips0, hips1)["push"] as Vector3)
	var her: Dictionary = HC.want(c1, dipped, hips1, hips0)
	var him: Dictionary = HC.want(dipped, c1, hips0, hips1)
	_check((her["push"] as Vector3).z * (dipped.z - c1.z) < 0.0, "her lean goes away from his dipped head")
	_check(_gap(dipped + (him["push"] as Vector3), c1 + (her["push"] as Vector3)) >= HC.TOUCH_M - 0.005, "dip + leans: the pair is clear")
	var e4: Vector3 = HC.ease(Vector3.ZERO, Vector3(0.11, 0, 0), dt, HC.DIP_MPS, HC.DIP_MPS)
	_check(is_equal_approx(e4.length(), HC.DIP_MPS * dt), "the dip comes at its own slower pace (%.3f m a frame)" % e4.length())

	print("HEAD_CLEAR failures=%d" % failures)
	quit(failures)
