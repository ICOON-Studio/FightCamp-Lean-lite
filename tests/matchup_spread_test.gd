extends SceneTree
## FIGHTERMODEL4B. A scout is worth paying when the tape moves the chance.
## Probe: 60 worlds, men's lightweight, your boxer at 64, opponents within 8 rating points.
##   edge = win_chance(you, them) - win_chance(you, them with the shape hidden)
## Bar 1: median |edge| at least 0.08. Bar 2: signed mean within +-0.01, and the share of
## opponents who read worse than their level between 0.45 and 0.55.
## Prints MATCHUP_SPREAD failures=<n>.

const WG := preload("res://scripts/world/WorldGen.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")

const WORLDS := 60
const SEED0 := 7000
const DIV := "m_lw"
const START_RATING := 64.0
const BAND := 8.0
const MEDIAN_AT := 0.08
const MEAN_BAND := 0.01
const WORSE_LO := 0.45
const WORSE_HI := 0.55

var failures := 0


func _initialize() -> void:
	var edges: Array = []
	var bands := {"lo": [0.0, 0, 0], "up": [0.0, 0, 0], "hi": [0.0, 0, 0], "top": [0.0, 0, 0]}
	for c in WORLDS:
		var world := WG.generate(SEED0 + c)
		var boxers: Array = world["divisions"][DIV]["boxers"]
		var p := MM.join(boxers, "You", START_RATING, 22, SEED0 + c)
		for b in boxers:
			if b == p or bool(b.get("retired", false)):
				continue
			var gap := float(b["rating"]) - START_RATING
			var edge := MM.win_chance(p, b) - MM.win_chance(p, MM.level_only(b))
			var key := "lo" if gap <= 0.0 else ("up" if gap <= BAND else ("hi" if gap <= 16.0 else "top"))
			bands[key][0] += edge
			bands[key][1] += 1
			if edge < 0.0:
				bands[key][2] += 1
			if absf(gap) <= BAND:
				edges.append(edge)
	var abs_e: Array = []
	var signed := 0.0
	var worse := 0
	for e in edges:
		var x := float(e)
		abs_e.append(absf(x))
		signed += x
		if x < 0.0:
			worse += 1
	abs_e.sort()
	var n := edges.size()
	var med := _at(abs_e, 0.50)
	var mean := signed / float(maxi(1, n))
	var share := float(worse) / float(maxi(1, n))
	print("SPREAD median %.4f signed %+.4f worse %.4f n %d p90 %.4f" % [med, mean, share, n, _at(abs_e, 0.90)])
	for key in ["lo", "up", "hi", "top"]:
		var row: Array = bands[key]
		print("BAND %s n %d signed %+.4f worse %.3f" % [key, int(row[1]), float(row[0]) / float(maxi(1, int(row[1]))), float(row[2]) / float(maxi(1, int(row[1])))])
	_check(med >= MEDIAN_AT, "bar 1: typical matchup median |edge| %.4f (at least %.2f)" % [med, MEDIAN_AT])
	_check(absf(mean) <= MEAN_BAND and share >= WORSE_LO and share <= WORSE_HI,
		"bar 2: centred read signed mean %+.4f (within +-%.2f), share worse %.3f (%.2f-%.2f)" % [mean, MEAN_BAND, share, WORSE_LO, WORSE_HI])
	print("MATCHUP_SPREAD failures=%d" % failures)
	quit(failures)


func _at(sorted_asc: Array, p: float) -> float:
	var n := sorted_asc.size()
	if n == 0:
		return 0.0
	if n % 2 == 0 and is_equal_approx(p, 0.50):
		return (float(sorted_asc[n / 2 - 1]) + float(sorted_asc[n / 2])) / 2.0
	return float(sorted_asc[clampi(int(round(p * float(n - 1))), 0, n - 1)])


func _check(ok: bool, label: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", label])
	if not ok:
		failures += 1
