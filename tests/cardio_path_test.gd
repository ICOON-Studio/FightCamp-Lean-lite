extends SceneTree
## S434 CARDIO1 round 1 (the review's "test misses the game path" and "stale BoutRead caches"): the round-3 fade on the paths
## the game runs, with Stamina different from the mean. Population: Lucy (Data.lucy through Data.fighter_state, the walk-in
## the game signs) against Priya (Data.OPPONENTS[1], no "Fades" word, so round 3 carries her own fade only), her Stamina and
## Recovery set by hand in pairs that keep the same mean (the old conditioning 62), so the mean cannot tell them apart.
##   1. LiveRound.open (the watched and simmed bout): round 3's base is round 2's less BoutRules.own_fade(Stamina) - 0.5 at
##      2 under the line (the slope; the S433 step gave 1.0), 0 at 1 over, with the same conditioning 62 (main faded both 1.0).
##   2. BoutRead.round_edges (the fight-prep read, cached): two fighters with the same conditioning and a different split
##      read different round-3 edges, and the cached read equals a fresh one (the cache keys hold Stamina and Recovery).
##   2b. The cache keys Stamina to the tenth: Stamina 0.4 under the line then 0.4 over it (one whole point, one Recovery)
##      each read their own round 3 (the whole-point key served the faded one to both).
##   3. BoutRead's own round 3 carries the slope: two Stamina points under the line cost 0.5 more in round 3 than two
##      points over it (energy moves both pairs alike), bounded 0.4..0.6.
##   4. The Training tab's goal tooltip for Cardio names Stamina's own number beside Stamina's line (WeekEditors.line_tip).

const Data := preload("res://scripts/state/Data.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")
const WeekEditors := preload("res://scripts/ui/WeekEditors.gd")

const MEAN := 62.0

var checks := 0
var failures := 0


func _initialize() -> void:
	var line := BoutRules.FADE_STAMINA
	# 1.
	var c := Career.quick_start()
	c.day = 30
	var low := _fighter(c, line - 2.0, MEAN * 2.0 - (line - 2.0))
	var high := _fighter(c, line + 1.0, MEAN * 2.0 - (line + 1.0))
	_check(is_equal_approx(float(low["stats"]["conditioning"]), float(high["stats"]["conditioning"])),
		"the pair shares one conditioning (%.2f, %.2f)" % [float(low["stats"]["conditioning"]), float(high["stats"]["conditioning"])])
	var f_low := _open_fade(c, low)
	var f_high := _open_fade(c, high)
	_check(is_equal_approx(f_low, BoutRules.own_fade(line - 2.0)) and is_equal_approx(f_low, 0.5),
		"LiveRound.open: Stamina %.0f (2 under the line) fades 0.5 in round 3 (got %.3f)" % [line - 2.0, f_low])
	_check(is_zero_approx(f_high), "LiveRound.open: Stamina %.0f (over the line) does not fade, same conditioning (got %.3f)" % [line + 1.0, f_high])
	# 2.
	BoutRead._re.clear()
	BoutRead._ready.clear()
	var a := _fighter(c, line, MEAN * 2.0 - line)
	var b := _fighter(c, line - 1.0, MEAN * 2.0 - (line - 1.0))
	var opp: Dictionary = a["bout"]["opp"]
	var ra: Array = BoutRead.round_edges(a, opp, a["camp"])
	var rb: Array = BoutRead.round_edges(b, opp, b["camp"])
	var fresh: Array = BoutRead._round_edges(b, opp, b["camp"])
	_check(absf(float(rb[2]) - float(fresh[2])) < 0.0001,
		"BoutRead: the cached round 3 for Stamina %.0f equals a fresh read (%.3f vs %.3f)" % [line - 1.0, float(rb[2]), float(fresh[2])])
	_check(float(rb[2]) < float(ra[2]) - 0.1,
		"BoutRead: same conditioning, Stamina %.0f reads a worse round 3 than %.0f (%.3f vs %.3f)" % [line - 1.0, line, float(rb[2]), float(ra[2])])
	# 2b. (round 2) Stamina is keyed to the tenth: 0.4 under and 0.4 over the line share one whole point, one Recovery (64)
	# and one conditioning (62); the whole-point key served the first one's faded round 3 to the second.
	BoutRead._re.clear()
	BoutRead._ready.clear()
	var p1 := _fighter(c, line - 0.4, MEAN * 2.0 - (line - 0.4))
	var p2 := _fighter(c, line + 0.4, MEAN * 2.0 - (line + 0.4))
	BoutRead.round_edges(p1, opp, p1["camp"])
	var r2: Array = BoutRead.round_edges(p2, opp, p2["camp"])
	var f2: Array = BoutRead._round_edges(p2, opp, p2["camp"])
	_check(absf(float(r2[2]) - float(f2[2])) < 0.02,
		"BoutRead: Stamina %.1f after %.1f reads its own round 3 from the cache (%.3f vs fresh %.3f)" % [line + 0.4, line - 0.4, float(r2[2]), float(f2[2])])
	# 3.
	var under := _drop_gap(c, line - 6.0, line - 4.0)
	var over := _drop_gap(c, line + 4.0, line + 6.0)
	_check(under - over > 0.4 and under - over < 0.6,
		"BoutRead round 3: two points under the line are worth %.3f more than two over it (slope 0.25 a point: 0.5)" % (under - over))
	# 4. (round 2) The week's goal tooltip on the Training tab: Cardio names Stamina's own now -> end of week beside Stamina's
	# line, never the line under the mean's numbers alone (WeekEditors.line_tip; the S434 round 1 printed the line only).
	var g := _fighter(c, line - 2.0, MEAN * 2.0 - (line - 2.0))
	c.fighters = [g]
	var tip := WeekEditors.line_tip(g, WeekBoard.plan_of(c, g), "conditioning")
	_check(tip.contains("Stamina %.1f → " % (line - 2.0)) and tip.contains(BoutRules.night_line_words("stamina")),
		"the week's Cardio goal names Stamina %.1f beside its line: %s" % [line - 2.0, tip.strip_edges()])
	print("CARDIO_PATH checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


## Lucy with her Stamina and Recovery set (the rest of her as signed), booked against Priya tonight.
func _fighter(c: Career, stamina: float, recovery: float) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
	f["weight"] = float(f["limit"])
	var a := Attrs.of(f)
	a["stamina"] = stamina
	a["recovery"] = recovery
	Attrs.sync(f)
	f["bout"] = {"opp": (Data.OPPONENTS[1] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	return f


## Round 2's base less round 3's on LiveRound.open, the energy held equal (the fade alone).
func _open_fade(c: Career, f: Dictionary) -> float:
	c.fighters = [f]
	var e := {"bonus": 0.0, "a": 100.0, "b": 100.0}
	var m := {"fid": f["id"]}
	LiveRound.open(c, f, m, 2, "", e)
	var b2 := float(m["live"]["base"])
	LiveRound.open(c, f, m, 3, "", e)
	return b2 - float(m["live"]["base"])


## How much more round 3 drops than round 2 for Stamina s1 than for s2 (s1 < s2, the mean held at MEAN), on BoutRead.
func _drop_gap(c: Career, s1: float, s2: float) -> float:
	var f1 := _fighter(c, s1, MEAN * 2.0 - s1)
	var f2 := _fighter(c, s2, MEAN * 2.0 - s2)
	var opp: Dictionary = f1["bout"]["opp"]
	var e1: Array = BoutRead._round_edges(f1, opp, f1["camp"])
	var e2: Array = BoutRead._round_edges(f2, opp, f2["camp"])
	return (float(e2[2]) - float(e1[2])) - (float(e2[1]) - float(e1[1]))


func _check(condition: bool, label: String) -> void:
	checks += 1
	print(("ok   " if condition else "FAIL ") + label)
	if not condition:
		failures += 1
