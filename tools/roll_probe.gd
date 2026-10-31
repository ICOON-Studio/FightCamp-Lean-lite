extends SceneTree
## S327 probe: do Injuries' seeds give the training roll its real rate? Rolls a normal 10 h week (1.3 %) for 40 careers x
## 26 weeks with the game's own seed formula, and the same count with one free-running RNG as the control arm.
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")

func _initialize() -> void:
	var hits := 0
	var n := 0
	var careers_hit := 0
	for i in 40:
		var cseed := i * 7919 + 1
		var any := false
		for w in 26:
			var day := (w + 1) * 7
			var s := cseed * 7919 + day * 977 + 3 * 31 + absi(hash("lucy"))
			n += 1
			if bool(InjuryRoll.training_roll(s, 10.0, 1.0)["injured"]):
				hits += 1
				any = true
		careers_hit += 1 if any else 0
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345
	var ctrl := 0
	for k in n:
		ctrl += 1 if rng.randf() < 0.013 else 0
	print("ROLL_PROBE game seeds: %d / %d weeks hurt (%.2f %%), careers hit %d / 40 | control rng %d (%.2f %%) | expected 1.30 %%" % [hits, n, 100.0 * hits / n, careers_hit, ctrl, 100.0 * ctrl / n])
	quit(0)
