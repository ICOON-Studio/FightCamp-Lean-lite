extends SceneTree
## Knockdowns test: standing counts, knockdowns and stoppages as a pure rule module.

const KD := preload("res://scripts/rules/Knockdowns.gd")

var failures := 0


func _initialize() -> void:
	test1_even_fighters()
	test2_big_puncher()
	test3_only_loser_counted()
	test4_heart()
	test5_count_rule()
	test6_ko_only_at_damage()
	test7_determinism()
	test8_damage_grows()
	print("KNOCKDOWNS failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _sides(pa: float, ca: float, ha: float, pb: float, cb: float, hb: float) -> Dictionary:
	return {"a": {"power": pa, "chin": ca, "heart": ha}, "b": {"power": pb, "chin": cb, "heart": hb}}


func test1_even_fighters() -> void:
	var any_count := 0
	var stopped := 0
	var n := 1000
	for seed in range(n):
		var sides := _sides(60, 60, 55, 60, 60, 55)
		var r := KD.simulate_bout(sides, 3, seed)
		if int(r["counts"]["a"]) + int(r["counts"]["b"]) > 0:
			any_count += 1
		if bool(r["stopped"]):
			stopped += 1
	var share_count := float(any_count) / float(n)
	var share_stop := float(stopped) / float(n)
	print("  test1: any_count=%.3f stopped=%.3f" % [share_count, share_stop])
	_check(share_count >= 0.10 and share_count <= 0.25, "test1: even fighters, share with a count in [0.10, 0.25] (John J-KDRATES1 club band) (got %.3f)" % share_count)
	_check(share_stop >= 0.03 and share_stop <= 0.12, "test1: even fighters, share stopped in [0.03, 0.12] (John: 5-12 club, 1-6 elite) (got %.3f)" % share_stop)


func test2_big_puncher() -> void:
	var sides1 := _sides(72, 60, 55, 60, 48, 55)
	var count_weak_chin := 0
	for seed in range(1000):
		var r := KD.simulate_bout(sides1, 3, seed)
		if int(r["counts"]["b"]) > 0:
			count_weak_chin += 1

	var sides_even := _sides(60, 60, 55, 60, 60, 55)
	var count_even := 0
	for seed in range(1000):
		var r := KD.simulate_bout(sides_even, 3, seed)
		if int(r["counts"]["a"]) + int(r["counts"]["b"]) > 0:
			count_even += 1

	var sides2 := _sides(60, 72, 55, 48, 60, 55)
	var count_reverse := 0
	for seed in range(1000):
		var r := KD.simulate_bout(sides2, 3, seed)
		if int(r["counts"]["a"]) > 0:
			count_reverse += 1

	print("  test2: weak_chin=%d even=%d reverse=%d" % [count_weak_chin, count_even, count_reverse])
	_check(count_weak_chin > count_even, "test2: more counts on weak chin (%d) than even (%d)" % [count_weak_chin, count_even])
	_check(count_weak_chin > count_reverse, "test2: more counts weak chin (%d) than reverse (%d)" % [count_weak_chin, count_reverse])


func test3_only_loser_counted() -> void:
	var ok := true
	for i in range(200):
		var rng := RandomNumberGenerator.new()
		rng.seed = i + 5000
		var sides := _sides(65, 60, 55, 55, 60, 55)
		var damage := {"a": 10.0, "b": 10.0}
		var csf := {"a": 0, "b": 0}
		var r := KD.round_counts("clear", "b", sides, damage, csf, rng)
		if str(r["loser"]) != "b":
			ok = false
		if int(r["counts"]) < 0:
			ok = false
	_check(ok, "test3: only the loser is counted (200 rolls)")


func test4_heart() -> void:
	var sum_high := 0
	var count_high := 0
	var sum_low := 0
	var count_low := 0
	for i in range(500):
		var rng_h := RandomNumberGenerator.new()
		rng_h.seed = i + 9000
		var sides_h := _sides(65, 60, 90, 55, 60, 90)
		var damage_h := {"a": 20.0, "b": 20.0}
		var csf_h := {"a": 0, "b": 0}
		var rh := KD.round_counts("clear", "b", sides_h, damage_h, csf_h, rng_h)
		if int(rh["counts"]) > 0:
			for ua in rh["up_at"]:
				sum_high += int(ua)
				count_high += 1

		var rng_l := RandomNumberGenerator.new()
		rng_l.seed = i + 9000
		var sides_l := _sides(65, 60, 20, 55, 60, 20)
		var damage_l := {"a": 20.0, "b": 20.0}
		var csf_l := {"a": 0, "b": 0}
		var rl := KD.round_counts("clear", "b", sides_l, damage_l, csf_l, rng_l)
		if int(rl["counts"]) > 0:
			for ua in rl["up_at"]:
				sum_low += int(ua)
				count_low += 1

	var mean_high: float = float(sum_high) / float(maxi(count_high, 1))
	var mean_low: float = float(sum_low) / float(maxi(count_low, 1))
	print("  test4: mean_up_at heart90=%.2f (n=%d) heart20=%.2f (n=%d)" % [mean_high, count_high, mean_low, count_low])
	_check(count_high > 0 and count_low > 0 and mean_high < mean_low, "test4: heart 90 up_at (%.2f) < heart 20 up_at (%.2f)" % [mean_high, mean_low])


func test5_count_rule() -> void:
	var sides := _sides(50, 50, 55, 70, 50, 55)
	var damage := {"a": 10.0, "b": 10.0}
	var csf := {"a": 3, "b": 0}
	var found_rsc := false
	for i in range(50):
		var r := RandomNumberGenerator.new()
		r.seed = i + 100
		var res := KD.round_counts("dominant", "a", sides, damage, csf, r)
		if bool(res["stopped"]) and str(res["how"]) == "RSC":
			found_rsc = true
			break
	_check(found_rsc, "test5: counts_so_far {a:3} + more counts -> RSC")

	var found_round_stop := false
	for i in range(200):
		var r := RandomNumberGenerator.new()
		r.seed = i + 200
		var res := KD.round_counts("dominant", "a", sides, damage, {"a": 0, "b": 0}, r)
		if int(res["counts"]) >= 3 and bool(res["stopped"]) and str(res["how"]) == "RSC":
			found_round_stop = true
			break
	_check(found_round_stop, "test5: three counts in one round -> RSC")


func test6_ko_only_at_damage() -> void:
	var any_ko := false
	for i in range(500):
		var rng := RandomNumberGenerator.new()
		rng.seed = i + 3000
		var sides := _sides(60, 60, 55, 60, 60, 55)
		var damage := {"a": 30.0, "b": 30.0}
		var csf := {"a": 0, "b": 0}
		var res := KD.round_counts("close", "b", sides, damage, csf, rng)
		if str(res["how"]) == "KO":
			any_ko = true
			break
	_check(not any_ko, "test6: damage 30 close round -> never KO (500 rolls)")


func test7_determinism() -> void:
	var sides := _sides(65, 58, 60, 58, 62, 50)
	var r1 := KD.simulate_bout(sides, 4, 12345)
	var r2 := KD.simulate_bout(sides, 4, 12345)
	_check(JSON.stringify(r1) == JSON.stringify(r2), "test7: same seed gives same result")

	var results := {}
	for seed in range(50):
		var r := KD.simulate_bout(sides, 4, seed)
		var key := JSON.stringify(r)
		results[key] = true
	_check(int(results.size()) >= 2, "test7: different seeds give at least 2 different outcomes (got %d)" % results.size())


func test8_damage_grows() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 777
	var sides := _sides(60, 60, 55, 60, 60, 55)
	var damage := {"a": 10.0, "b": 20.0}
	var csf := {"a": 0, "b": 0}
	var res := KD.round_counts("dominant", "b", sides, damage, csf, rng)
	var dmg_out: Dictionary = res["damage"]
	var expected_loser_dmg: float = 20.0 + float(KD.DAMAGE_PER_ROUND["dominant"])
	var expected_winner_dmg: float = 10.0 + float(KD.WINNER_DAMAGE)
	_check(abs(float(dmg_out["b"]) - expected_loser_dmg) < 0.01, "test8: loser damage grew by DAMAGE_PER_ROUND[dominant] (got %.1f, expected %.1f)" % [float(dmg_out["b"]), expected_loser_dmg])
	_check(abs(float(dmg_out["a"]) - expected_winner_dmg) < 0.01, "test8: winner damage grew by WINNER_DAMAGE (got %.1f, expected %.1f)" % [float(dmg_out["a"]), expected_winner_dmg])
