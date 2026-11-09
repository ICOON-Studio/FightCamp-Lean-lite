extends SceneTree
## S411 R28 groundwork: how bad do a boxer's eyes get as bouts really play? Same bout as body_map_test test 5 (exchanges at rolled
## margins, boxer "a" a small favourite), 300 seeds, at each corner: the share of bouts where the bout's loser has an eye at or
## under each band. Pure read, changes nothing.
##   <godot.exe> --headless --path . --audio-driver Dummy --fixed-fps 30 --script res://tools/eye_band_probe.gd

const BM := preload("res://scripts/rules/BodyMap.gd")
const BR := preload("res://scripts/rules/BoutRules.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")
const EX := 6
const SEEDS := 300


func _initialize() -> void:
	print("EYE population: 300 seeded bouts, 63 v 60 rated, 6 exchanges a round, odd seeds southpaw; the loser's worse eye at each corner")
	for rounds in [3, 4, 6]:
		_run(rounds)
	quit(0)


func _exchange(rn: int, seed_v: int, won: bool, mine: float, theirs: float) -> Array:
	var rd := {"n": rn, "won": won, "mine": mine, "theirs": theirs, "corner": "", "lines": [], "names": ["Lucy", "Maria"]}
	return RS.build(rd, "Out-boxer", "Out-boxer", 30.0, seed_v)["beats"]


func _run(rounds: int) -> void:
	var at := []
	for r in rounds:
		at.append({"hurt": 0, "critical": 0, "doctor": 0, "sum": 0.0})
	for s in SEEDS:
		var south := {"a": s % 2 == 1, "b": false}
		var mp: Dictionary = BM.fresh()
		var rng := RandomNumberGenerator.new()
		rng.seed = s * 7919 + 1
		var ex_won := 0
		var snaps := []
		for rn in rounds:
			for ex in EX:
				var mine: float = 63.0 + (rng.randf() - 0.5) * BR.ROUND_SPREAD
				var theirs: float = 60.0 + (rng.randf() - 0.5) * BR.ROUND_SPREAD
				var won := mine > theirs
				if won:
					ex_won += 1
				BM.add_beats(mp, _exchange(rn + 1, (s * 100 + rn) * 10 + ex, won, mine, theirs), south)
			snaps.append({"a": minf(BM.value(mp, "a", "left_eye"), BM.value(mp, "a", "right_eye")),
				"b": minf(BM.value(mp, "b", "left_eye"), BM.value(mp, "b", "right_eye"))})
		var loser := "b" if ex_won * 2 > rounds * EX else "a"
		for r in rounds:
			var v: float = snaps[r][loser]
			at[r]["sum"] = float(at[r]["sum"]) + v
			for b in [["hurt", BM.HURT], ["critical", BM.CRITICAL], ["doctor", BM.DOCTOR]]:
				if v <= float(b[1]):
					at[r][b[0]] = int(at[r][b[0]]) + 1
	for r in rounds:
		var a: Dictionary = at[r]
		print("EYE %d-round bout, after round %d: mean worse eye %.0f | hurt %.0f%% | critical %.0f%% | doctor %.0f%%" % [rounds, r + 1,
			float(a["sum"]) / SEEDS, 100.0 * int(a["hurt"]) / SEEDS, 100.0 * int(a["critical"]) / SEEDS, 100.0 * int(a["doctor"]) / SEEDS])
