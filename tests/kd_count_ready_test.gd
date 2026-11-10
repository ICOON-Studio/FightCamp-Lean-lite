extends SceneTree
## S422: the knockdown count never waits forever on a replay that does not begin (KdWait.count_ready).
const KW := preload("res://scripts/rules/KdWait.gd")


func _initialize() -> void:
	var fails := 0
	var d := 1.0
	var late: float = KW.REPLAY_LATE_S
	var cases := [
		# [wait, fall_in, replay_due, replay_active, expected, why]
		[0.5, 0.4, false, false, false, "before DOWN_S"],
		[0.4 + d, 0.4, false, false, true, "no replay: DOWN_S after the fall"],
		[0.4 + d, 0.4, true, false, false, "a replay is due: wait for it"],
		[0.4 + d + late - 0.1, 0.4, true, false, false, "due, not yet late"],
		[0.4 + d + late, 0.4, true, false, true, "due but never began: the count starts"],
		[60.0, 0.4, true, false, true, "the S421 hang: a minute on, still due"],
		[60.0, 0.4, true, true, false, "a playing replay is never cut"],
	]
	for c in cases:
		var got: bool = KW.count_ready(c[0], c[1], d, c[2], c[3])
		print("  %-42s wait=%.2f due=%s active=%s -> %s" % [c[5], c[0], c[2], c[3], got])
		if got != c[4]:
			fails += 1
			print("FAIL %s: expected %s" % [c[5], c[4]])
	print("KD_COUNT_READY failures=%d" % fails)
	quit(1 if fails > 0 else 0)
