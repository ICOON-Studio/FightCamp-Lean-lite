extends SceneTree
## S311 real-fight gap 1: RangeBreath says what range the ring keeps (rest out of reach / an entry lunge / the pocket).
##   1. hand-made beats: the lunge before a burst, the pocket inside it, the step out after it and who takes it,
##   2. the gap for each phase, 3. on real round scripts the rest share and the range swings sit in the real bands
##   (Game Godot/research/S310_REAL_FIGHT_GAPS.md: long range 40-63 % of a round, 18-35 swings a minute). Bounds only.

const RB := preload("res://scripts/fight3d/RangeBreath.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")

var failures := 0


func _initialize() -> void:
	var beats := [
		{"t": 0.4, "who": "a", "move": "say"},
		{"t": 2.0, "who": "a", "move": "jab"},
		{"t": 2.6, "who": "b", "move": "cross"},
		{"t": 4.0, "who": "b", "move": "step_in"},
		{"t": 6.0, "who": "b", "move": "lead_hook"},
		{"t": 7.0, "who": "a", "move": "jab"},
	]
	# 1. The phases on a hand-made exchange.
	_check(str(RB.phase(beats, 0, 1.0)["phase"]) == "rest", "before the first punch (1.0 s away) they rest out of range")
	var lunge := RB.phase(beats, 1, 1.75)
	_check(str(lunge["phase"]) == "in" and int(lunge["who"]) == 0 and str(lunge["move"]) == "jab",
		"0.25 s before Lucy's jab she lunges in (phase %s, who %d)" % [lunge["phase"], lunge["who"]])
	_check(str(RB.phase(beats, 2, 2.2)["phase"]) == "pocket", "0.2 s after a punch they stay in the pocket")
	_check(str(RB.phase(beats, 3, 3.0)["phase"]) == "pocket", "0.4 s after the burst's last punch they are still in it")
	var out := RB.phase(beats, 3, 3.3)
	_check(str(out["phase"]) == "rest" and int(out["who"]) == 0,
		"0.7 s after Maria's last cross Lucy (who did not throw it) steps out first (phase %s, who %d)" % [out["phase"], out["who"]])
	var hook := RB.phase(beats, 4, 5.75)
	_check(str(hook["phase"]) == "in" and int(hook["who"]) == 1, "the step_in beat is no punch: the lunge comes before Maria's hook")
	_check(str(RB.phase(beats, 5, 6.5)["phase"]) == "pocket", "punches 1.0 s apart are one burst (pocket between them)")
	# 2. The gap per phase.
	var jab_gap := 0.96
	_check(is_equal_approx(RB.want_m(lunge, jab_gap, 0.5), jab_gap), "a jab is thrown at the jab gap")
	_check(RB.want_m(hook, jab_gap, 0.5) < jab_gap - 0.1, "a hook is thrown inside the jab gap")
	var lo := RB.want_m(out, jab_gap, 0.0)
	var hi := RB.want_m(out, jab_gap, 1.0)
	_check(lo >= 1.299 and hi <= 1.7 and hi > lo and lo - jab_gap >= 0.35 and hi - jab_gap <= 0.75,
		"rest is out of reach, %.2f-%.2f m: an entry lunge of 0.4-0.7 m to the jab gap" % [lo, hi])
	# 3. Real round scripts: share of time at rest and range swings (rest -> lunge) a minute.
	var rest_s := 0.0
	var total_s := 0.0
	var swings := 0
	for seed in [3, 11, 29, 47, 83, 131]:
		var r := {"n": 1, "won": seed % 2 == 0, "mine": 62.0, "theirs": 58.0, "corner": "", "lines": []}
		var s: Array = RS.build(r, "Out-boxer", "Pressure fighter", 30.0, seed)["beats"]
		var next := 0
		var last := ""
		var t := 0.0
		while t < 30.0:
			while next < s.size() and float(s[next]["t"]) <= t:
				next += 1
			var ph := str(RB.phase(s, next, t)["phase"])
			if ph == "rest":
				rest_s += 0.05
			if ph == "in" and last == "rest":
				swings += 1
			last = ph
			total_s += 0.05
			t += 0.05
	var share := rest_s / total_s
	var per_min := float(swings) / (total_s / 60.0)
	print("RANGE rest share %.2f, entries %.1f a minute (6 exchanges x 30 s)" % [share, per_min])
	_check(share >= 0.30 and share <= 0.75, "rest out of range %.0f %% of the time (real long range 40-63 %%)" % (share * 100.0))
	_check(per_min >= 8.0 and per_min <= 40.0, "%.1f entries a minute (real range swings 18-35 a minute)" % per_min)
	# 4. S313 the clinch: from its beat to the referee's break they hold the clinch range; the break hands back to the rest.
	var cl := [
		{"t": 2.0, "who": "a", "move": "jab", "result": "lands"},
		{"t": 2.4, "who": "b", "move": "clinch", "dur": 3.0, "break_t": 5.4},
		{"t": 5.4, "who": "a", "move": "step_out", "ref": true},
		{"t": 5.4, "who": "b", "move": "step_out", "ref": true},
		{"t": 8.0, "who": "a", "move": "cross", "result": "lands"},
	]
	var held := RB.phase(cl, 2, 3.0)
	_check(str(held["phase"]) == "clinch" and int(held["who"]) == 1, "inside the clinch Maria holds (phase %s, who %d)" % [held["phase"], held["who"]])
	_check(is_equal_approx(RB.want_m(held, jab_gap, 0.5), RB.CLINCH_M) and RB.CLINCH_M < 0.65, "tied up they stand inside range")
	_check(str(RB.phase(cl, 4, 5.6)["phase"]) == "rest", "after the break they part to rest")
	_check(str(RB.phase(cl, 2, 5.45)["phase"]) != "clinch", "the hold ends at break_t even before its beats fire")
	print("RANGE_BREATH %s (%d failures)" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(failures)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
