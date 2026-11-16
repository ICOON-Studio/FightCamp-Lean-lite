extends SceneTree
## FILMCOUNT1 test - count any marked pattern on a film, re-measure the film game.
## Hand-built films for every WHEN x THEN, real tapes for noise and finds.

const FC := preload("res://scripts/rules/FilmCount.gd")
const FM := preload("res://scripts/rules/FilmMoments.gd")   # S498: the moments were split out of FilmCount
const FB := preload("res://scripts/rules/FilmBout.gd")
const FP := preload("res://scripts/rules/FilmPattern.gd")
const RP := preload("res://scripts/rules/RivalPast.gd")

var failures := 0


func _initialize() -> void:
	var t0: float = Time.get_ticks_msec() / 1000.0
	_test_hand_built()
	_test_noise()
	_test_finds()
	_test_hurt_moments()
	var elapsed: float = Time.get_ticks_msec() / 1000.0 - t0
	print("elapsed=%.1fs" % elapsed)
	print("FILM_COUNT failures=%d noise_avg=%.4f noise_worst=%.4f" % [failures, _noise_avg, _noise_worst])
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


# --- helpers ---

func _is_punch(move: String) -> bool:
	return move != "step_in" and move != "step_out" and move != "tired" and move != "count" and move != "slip" and move != "clinch" and move != "inside"


func _beat(who: String, move: String, result: String, t: float, big: bool = false, def_val: String = "", after: String = "", seen: bool = true) -> Dictionary:
	return {"t": t, "who": who, "move": move, "result": result, "big": big, "def": def_val, "after": after, "seen": seen, "caption": "", "knockback": false}


func _ex(i: int, round: int, at: int, mode: String, a_mode: String, beats: Array) -> Dictionary:
	var landed: Array = [0, 0]
	for b in beats:
		if str(b["result"]) == "lands":
			if str(b["who"]) == "a":
				landed[0] += 1
			elif str(b["who"]) == "b":
				landed[1] += 1
	return {"i": i, "round": round, "at": at, "mode": mode, "a_mode": a_mode,
		"place": 1, "pinned": false, "won": landed[1] > landed[0], "landed": landed, "beats": beats}


func _film(exchanges: Array, rounds: int = 3) -> Dictionary:
	return {"exchanges": exchanges, "rounds": rounds, "won": true, "how": "on points, 2-1"}


# --- hand-built tests ---

func _test_hand_built() -> void:
	_test_jab_after()
	_test_combo_stood()
	_test_hurt_to_body()
	_test_hurt_wild()
	_test_last_min_fewer()
	_test_round1_fewer()
	_test_after_body_fewer()
	_test_walked_outlanded()
	_test_seen_only()
	_test_countered()
	_test_to_body_non_punch()


func _test_jab_after() -> void:
	var beats: Array = [
		_beat("b", "jab", "lands", 1.0, false, "", "right_low"),
		_beat("b", "jab", "lands", 5.0, false, "", "right_low"),
		_beat("b", "jab", "misses", 10.0, false, "", "guard_up"),
		_beat("b", "cross", "lands", 15.0, false, "", "guard_up"),
		_beat("b", "lead_hook", "lands", 20.0, false, "", "threw_on"),
	]
	var ex := _ex(0, 1, 0, "range", "range", beats)
	var film := _film([ex])
	var c: Dictionary = FC.count(film, {"when": "jab", "then": "right_low"})
	_check(str(c["kind"]) == "after", "jab after: kind=after")
	_check(int(c["n"]) == 3, "jab after: n=3 (got %d)" % int(c["n"]))
	_check(int(c["k"]) == 2, "jab after: k=2 (got %d)" % int(c["k"]))
	_check(int(c["rest_n"]) == 2, "jab after: rest_n=2 (got %d)" % int(c["rest_n"]))
	_check(int(c["rest_k"]) == 0, "jab after: rest_k=0 (got %d)" % int(c["rest_k"]))


func _test_combo_stood() -> void:
	var beats: Array = [
		_beat("b", "jab", "lands", 1.0, false, "", "guard_up"),
		_beat("b", "cross", "lands", 2.0, false, "", "stood"),
		_beat("b", "jab", "lands", 10.0, false, "", "guard_up"),
		_beat("b", "cross", "lands", 11.0, false, "", "guard_up"),
		_beat("b", "lead_hook", "lands", 20.0, false, "", "stood"),
	]
	var ex := _ex(0, 1, 0, "range", "range", beats)
	var film := _film([ex])
	var c: Dictionary = FC.count(film, {"when": "combo", "then": "stood"})
	_check(int(c["n"]) == 2, "combo stood: n=2 (got %d)" % int(c["n"]))
	_check(int(c["k"]) == 1, "combo stood: k=1 (got %d)" % int(c["k"]))
	_check(int(c["rest_n"]) == 3, "combo stood: rest_n=3 (got %d)" % int(c["rest_n"]))
	_check(int(c["rest_k"]) == 1, "combo stood: rest_k=1 (got %d)" % int(c["rest_k"]))


func _test_hurt_to_body() -> void:
	var beats: Array = [
		_beat("a", "cross", "lands", 5.0, true),
		_beat("b", "body_hook", "lands", 6.0),
		_beat("a", "jab", "lands", 15.0, true),
		_beat("b", "jab", "lands", 16.0),
	]
	var ex := _ex(0, 1, 0, "range", "range", beats)
	var film := _film([ex])
	var c: Dictionary = FC.count(film, {"when": "hurt", "then": "to_body"})
	_check(int(c["n"]) == 2, "hurt to_body: n=2 (got %d)" % int(c["n"]))
	_check(int(c["k"]) == 1, "hurt to_body: k=1 (got %d)" % int(c["k"]))
	_check(int(c["rest_n"]) == 0, "hurt to_body: rest_n=0 (got %d)" % int(c["rest_n"]))


func _test_hurt_wild() -> void:
	var beats: Array = [
		_beat("a", "cross", "lands", 5.0, true),
		_beat("b", "lead_hook", "misses", 6.0, false, ""),
		_beat("a", "jab", "lands", 15.0, true),
		_beat("b", "cross", "misses", 16.0, false, ""),
	]
	var ex := _ex(0, 1, 0, "range", "range", beats)
	var film := _film([ex])
	var c: Dictionary = FC.count(film, {"when": "hurt", "then": "wild"})
	_check(int(c["n"]) == 2, "hurt wild: n=2 (got %d)" % int(c["n"]))
	_check(int(c["k"]) == 2, "hurt wild: k=2 (got %d)" % int(c["k"]))


func _test_last_min_fewer() -> void:
	var beats_ex4: Array = [
		_beat("b", "jab", "lands", 1.0),
		_beat("b", "cross", "lands", 5.0),
	]
	var beats_ex5: Array = [
		_beat("b", "jab", "lands", 2.0),
	]
	var beats_ex0: Array = [
		_beat("b", "jab", "lands", 1.0),
		_beat("b", "cross", "lands", 3.0),
		_beat("b", "lead_hook", "lands", 5.0),
		_beat("b", "jab", "lands", 10.0),
	]
	var ex0 := _ex(0, 1, 0, "range", "range", beats_ex0)
	var ex4 := _ex(4, 1, 120, "range", "range", beats_ex4)
	var ex5 := _ex(5, 1, 150, "range", "range", beats_ex5)
	var film := _film([ex0, ex4, ex5])
	var c: Dictionary = FC.count(film, {"when": "last_min", "then": "fewer"})
	_check(int(c["inside"]) == 3, "last_min fewer: inside=3 (got %d)" % int(c["inside"]))
	_check(int(c["outside"]) == 4, "last_min fewer: outside=4 (got %d)" % int(c["outside"]))
	_check(float(c["slowdown"]) == 0.9, "last_min fewer: slowdown=0.9")


func _test_round1_fewer() -> void:
	var beats_r1: Array = [
		_beat("b", "jab", "lands", 1.0),
		_beat("b", "cross", "lands", 5.0),
		_beat("b", "jab", "lands", 10.0),
	]
	var beats_r2: Array = [
		_beat("b", "jab", "lands", 1.0),
		_beat("b", "cross", "lands", 5.0),
	]
	var ex_r1 := _ex(0, 1, 0, "range", "range", beats_r1)
	var ex_r2 := _ex(0, 2, 0, "range", "range", beats_r2)
	var film := _film([ex_r1, ex_r2])
	var c: Dictionary = FC.count(film, {"when": "round1", "then": "fewer"})
	_check(int(c["inside"]) == 3, "round1 fewer: inside=3 (got %d)" % int(c["inside"]))
	_check(int(c["outside"]) == 2, "round1 fewer: outside=2 (got %d)" % int(c["outside"]))


func _test_after_body_fewer() -> void:
	var beats: Array = [
		_beat("a", "body_hook", "lands", 5.0),
		_beat("b", "jab", "lands", 10.0),
		_beat("b", "cross", "lands", 20.0),
		_beat("b", "jab", "lands", 50.0),
	]
	var ex := _ex(0, 1, 0, "range", "range", beats)
	var film := _film([ex])
	var c: Dictionary = FC.count(film, {"when": "after_body", "then": "fewer"})
	_check(int(c["inside"]) == 2, "after_body fewer: inside=2 (got %d)" % int(c["inside"]))
	_check(int(c["outside"]) == 1, "after_body fewer: outside=1 (got %d)" % int(c["outside"]))


func _test_walked_outlanded() -> void:
	var beats_ex0: Array = [
		_beat("a", "jab", "lands", 1.0),
		_beat("a", "cross", "lands", 5.0),
		_beat("b", "jab", "lands", 3.0),
	]
	var beats_ex1: Array = [
		_beat("a", "jab", "lands", 2.0),
		_beat("b", "cross", "lands", 4.0),
	]
	var ex0 := _ex(0, 1, 0, "range", "press", beats_ex0)
	var ex1 := _ex(1, 1, 30, "range", "range", beats_ex1)
	var film := _film([ex0, ex1])
	var c: Dictionary = FC.count(film, {"when": "walked", "then": "outlanded"})
	_check(int(c["in_landed"]) == 2, "walked outlanded: in_landed=2 (got %d)" % int(c["in_landed"]))
	_check(int(c["out_landed"]) == 1, "walked outlanded: out_landed=1 (got %d)" % int(c["out_landed"]))


func _test_seen_only() -> void:
	var beats: Array = [
		_beat("b", "jab", "lands", 1.0, false, "", "right_low", true),
		_beat("b", "jab", "lands", 5.0, false, "", "right_low", false),
		_beat("b", "jab", "lands", 10.0, false, "", "guard_up", true),
	]
	var ex := _ex(0, 1, 0, "range", "range", beats)
	var film := _film([ex])
	var c_all: Dictionary = FC.count(film, {"when": "jab", "then": "right_low"}, false)
	var c_seen: Dictionary = FC.count(film, {"when": "jab", "then": "right_low"}, true)
	_check(int(c_all["k"]) == 2, "seen_only all: k=2 (got %d)" % int(c_all["k"]))
	_check(int(c_seen["k"]) == 1, "seen_only seen: k=1 (got %d)" % int(c_seen["k"]))
	_check(int(c_seen["n"]) == 3, "seen_only seen: n=3 (got %d)" % int(c_seen["n"]))


func _test_countered() -> void:
	var beats: Array = [
		_beat("b", "jab", "lands", 1.0, false, "", "guard_up"),
		_beat("a", "cross", "lands", 2.0),
		_beat("b", "jab", "lands", 10.0, false, "", "guard_up"),
		_beat("a", "jab", "misses", 15.0),
	]
	var ex := _ex(0, 1, 0, "range", "range", beats)
	var film := _film([ex])
	var c: Dictionary = FC.count(film, {"when": "jab", "then": "countered"})
	_check(int(c["n"]) == 2, "countered: n=2 (got %d)" % int(c["n"]))
	_check(int(c["k"]) == 1, "countered: k=1 (got %d)" % int(c["k"]))


func _test_to_body_non_punch() -> void:
	var beats: Array = [
		_beat("a", "cross", "lands", 5.0, true),
		_beat("b", "body_hook", "lands", 6.0),
	]
	var ex := _ex(0, 1, 0, "range", "range", beats)
	var film := _film([ex])
	var c: Dictionary = FC.count(film, {"when": "hurt", "then": "to_body"})
	_check(int(c["k"]) == 1, "hurt to_body non-punch: k=1 (got %d)" % int(c["k"]))


# --- noise test ---

var _noise_avg: float = 0.0
var _noise_worst: float = 0.0


func _test_noise() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 495

	var all_claims: Array = FP.claims()
	var pass_counts: Array = []
	for i in all_claims.size():
		pass_counts.append(0)
	var films_per_claim := 1000

	# Build films and count all claims on each (precompute once per film)
	for fi in films_per_claim:
		var opp := _noise_opp(rng, fi)
		var row := _noise_row(rng, fi)
		var film: Dictionary = FB.build(opp, row)
		var pre := FM.precompute(film)
		for ci in all_claims.size():
			var claim: Dictionary = all_claims[ci]
			var counts: Dictionary = FC.count_pre(pre, claim)
			var result: Dictionary = FC.judge(counts)
			if str(result["word"]) == "pass":
				pass_counts[ci] = int(pass_counts[ci]) + 1

	var total_pass_rate: float = 0.0
	var worst_pass_rate: float = 0.0
	var worst_claim := ""
	for ci in all_claims.size():
		var rate: float = float(pass_counts[ci]) / float(films_per_claim)
		total_pass_rate += rate
		if rate > worst_pass_rate:
			worst_pass_rate = rate
			worst_claim = str(all_claims[ci])
		if rate >= 0.08:   # S498 collect: name every claim over the bar (the delivered test said only the worst number)
			print("NOISY claim %s passes on %.1f %% of chance films" % [str(all_claims[ci]), rate * 100.0])

	_noise_avg = total_pass_rate / float(all_claims.size())
	_noise_worst = worst_pass_rate
	_check(_noise_avg < 0.03, "noise avg pass rate < 0.03 (got %.4f)" % _noise_avg)
	_check(_noise_worst < 0.08, "noise worst pass rate < 0.08 (got %.4f, claim %s)" % [_noise_worst, worst_claim])


func _noise_opp(rng: RandomNumberGenerator, idx: int) -> Dictionary:
	var styles: Array = ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer"]
	var threats: Array = ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]
	var style: String = str(styles[rng.randi_range(0, styles.size() - 1)])
	var threat: String = str(threats[rng.randi_range(0, threats.size() - 1)])
	var rating: int = 55 + rng.randi_range(0, 20)
	var sex: String = "f" if rng.randf() < 0.5 else "m"
	return {"id": "noise_%d" % idx, "style": style, "threat": threat, "rating": rating,
		"habits": [], "weak": "", "sex": sex}


func _noise_row(rng: RandomNumberGenerator, idx: int) -> Dictionary:
	var d: int = 1000 + idx
	var win: bool = rng.randf() < 0.5
	var how: String
	if rng.randf() < 0.2:
		how = "stopped in round %d" % rng.randi_range(1, 3)
	else:
		var decisions: Array = RP.DECISIONS
		how = str(decisions[rng.randi_range(0, decisions.size() - 1)])
	return {"d": d, "vs": "Opponent", "vs_club": "ABC", "win": win, "how": how}


# --- finds test ---

func _test_finds() -> void:
	var tells: Array = [
		{"id": "drops_right_after_jab", "when": "jab", "then": "right_low", "habit": "drops_right_after_jab"},
		{"id": "lunges_with_jab", "when": "jab", "then": "lunged", "habit": "lunges_with_jab"},
		{"id": "admires_her_work", "when": "combo", "then": "stood", "habit": "admires_her_work"},
		{"id": "digs_body_when_hurt", "when": "hurt", "then": "to_body", "habit": "digs_body_when_hurt"},
		{"id": "loads_up_when_hurt", "when": "hurt", "then": "wild", "habit": "loads_up_when_hurt"},
		{"id": "fades_late", "when": "last_min", "then": "fewer", "habit": "fades_late"},
		{"id": "slow_starter", "when": "round1", "then": "fewer", "habit": "slow_starter"},
		{"id": "weak_body", "when": "after_body", "then": "fewer", "weak": "body shots hurt"},
		{"id": "weak_pressure", "when": "walked", "then": "outlanded", "weak": "backed up"},
	]

	print("FINDS table:")
	print("tell                    | one_film | two_films")
	print("------------------------+----------+----------")

	for tell in tells:
		var tid: String = str(tell["id"])
		var one_pass: int = 0
		var two_pass: int = 0
		var n_films: int = 300
		for fi in n_films:
			var opp := _tell_opp(tid, tell, fi)
			var row1 := _noise_row(_seeded_rng(495 + fi), fi)
			var film1: Dictionary = FB.build(opp, row1)
			var claim := {"when": str(tell["when"]), "then": str(tell["then"])}
			var pre1 := FM.precompute(film1)
			var counts1: Dictionary = FC.count_pre(pre1, claim)
			var r1: Dictionary = FC.judge(counts1)
			if str(r1["word"]) == "pass":
				one_pass += 1
			# Two films pooled
			var row2 := _noise_row(_seeded_rng(495 + fi + 10000), fi + 10000)
			var film2: Dictionary = FB.build(opp, row2)
			var pre2 := FM.precompute(film2)
			var counts2: Dictionary = FC.count_pre(pre2, claim)
			var pooled: Dictionary = FC.pooled(counts1, counts2)
			var r2: Dictionary = FC.judge(pooled)
			if str(r2["word"]) == "pass":
				two_pass += 1
		var one_rate: float = float(one_pass) / float(n_films)
		var two_rate: float = float(two_pass) / float(n_films)
		print("%-23s | %.3f   | %.3f" % [tid, one_rate, two_rate])

		if tid == "drops_right_after_jab" or tid == "lunges_with_jab":
			_check(one_rate >= 0.50, "finds %s: one_film >= 0.50 (got %.3f)" % [tid, one_rate])
		elif tid == "admires_her_work":
			_check(one_rate >= 0.40, "finds %s: one_film >= 0.40 (got %.3f)" % [tid, one_rate])
		_check(two_rate >= 0.15, "finds %s: two_films >= 0.15 (got %.3f)" % [tid, two_rate])


func _tell_opp(tid: String, tell: Dictionary, idx: int) -> Dictionary:
	var styles: Array = ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer"]
	var threats: Array = ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]
	var rng := _seeded_rng(495 + idx)
	var style: String = str(styles[rng.randi_range(0, styles.size() - 1)])
	var threat: String = str(threats[rng.randi_range(0, threats.size() - 1)])
	var rating: int = 55 + rng.randi_range(0, 20)
	var sex: String = "f" if rng.randf() < 0.5 else "m"
	var habits: Array = []
	var weak: String = ""
	if tell.has("habit"):
		habits.append(str(tell["habit"]))
	if tell.has("weak"):
		weak = str(tell["weak"])
	return {"id": "tell_%s_%d" % [tid, idx], "style": style, "threat": threat, "rating": rating,
		"habits": habits, "weak": weak, "sex": sex}


func _seeded_rng(seed_val: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	return rng


# --- hurt moments test ---

func _test_hurt_moments() -> void:
	var total_hurt: int = 0
	var n_films: int = 200
	var rng := RandomNumberGenerator.new()
	rng.seed = 495
	for fi in n_films:
		var opp := _noise_opp(rng, fi + 50000)
		if fi % 3 == 0:
			opp["habits"] = ["digs_body_when_hurt"]
		elif fi % 3 == 1:
			opp["habits"] = ["loads_up_when_hurt"]
		var row := _noise_row(rng, fi + 50000)
		var film: Dictionary = FB.build(opp, row)
		var hurt_count: int = 0
		for ex in film["exchanges"]:
			for bd in (ex as Dictionary)["beats"]:
				var beat: Dictionary = bd as Dictionary
				if str(beat["who"]) == "a" and str(beat["result"]) == "lands" and bool(beat.get("big", false)):
					hurt_count += 1
		total_hurt += hurt_count
	var mean_hurt: float = float(total_hurt) / float(n_films)
	_check(mean_hurt >= 1.0 and mean_hurt <= 5.0, "mean hurt moments: 1.0 <= %.2f <= 5.0" % mean_hurt)
	print("mean_hurt_moments=%.2f" % mean_hurt)
