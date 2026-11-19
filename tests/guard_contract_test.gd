extends SceneTree
## TASK GUARDBLIND1: blind contract test for the guard through a bout (guard damage v4).
## Written from the CONTRACT in ops/research/TASK_GUARDBLIND1.md and the ## header comments of
## scripts/state/GuardState.gd and scripts/rules/GuardWear.gd only. The function bodies and
## tests/guard_state_test.gd were not read. Where the code disagrees with the contract, one of
## the two is wrong; any such check is kept and reported, not weakened.

const GuardState := preload("res://scripts/state/GuardState.gd")
const Data := preload("res://scripts/state/Data.gd")
const OPP_ATTRS := {"stamina": 55.0, "strength": 55.0}
const EPS := 0.01

var failures: int = 0

func _initialize() -> void:
	_test_open()
	_test_class_edges()
	_test_share()
	_test_corner()
	_test_hands_up()
	_test_after_shape()
	_test_after_monotonic()
	_test_after_ropes()
	_test_after_amateur()
	_test_after_recovery()
	_test_after_bounds()
	_test_tie()
	_test_damage_on()
	_test_guard_habit()
	if failures == 0:
		print("GUARD_CONTRACT PASS fails=0")
	else:
		print("GUARD_CONTRACT FAIL fails=%d" % failures)
	quit(1 if failures > 0 else 0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("ok  " + label)
	else:
		failures += 1
		print("FAIL " + label)

func _close(a: float, b: float) -> bool:
	return absf(a - b) < EPS

func _opened(pro: bool, limit: float) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 1)
	f["pro"] = pro
	f["limit"] = limit
	f["bout"] = {}
	GuardState.open(f, 1)
	return f

func _g(f: Dictionary, side: String) -> float:
	return float(f["bout"]["guard"][side]["g"])

func _set_g(f: Dictionary, side: String, g: float) -> void:
	var s: Dictionary = f["bout"]["guard"][side]
	s["g"] = g
	f["bout"]["guard"][side] = s

func _set_max(f: Dictionary, side: String, mx: float) -> void:
	var s: Dictionary = f["bout"]["guard"][side]
	s["max"] = mx
	f["bout"]["guard"][side] = s

func _flag(f: Dictionary, side: String) -> bool:
	return bool(f["bout"]["guard"][side]["clinch"])

func _after(f: Dictionary, landed: Array, at: String, call: String, n: int) -> Dictionary:
	return GuardState.after(f, landed, at, OPP_ATTRS, call, n, [])

func _test_open() -> void:
	var f: Dictionary = _opened(true, 81.0)
	_check(f["bout"].has("guard"), "open(f, 1) creates f[\"bout\"][\"guard\"]")
	for side in ["a", "b"]:
		var s: Dictionary = f["bout"]["guard"][side]
		_check(s.has("g") and s.has("max") and s.has("clinch"),
			"guard %s has g, max, clinch" % side)
		_check(not bool(s["clinch"]), "guard %s starts with clinch false" % side)
	_check(_close(_g(f, "a"), float(f["bout"]["guard"]["a"]["max"])), "our guard opens full")
	_check(_close(_g(f, "b"), float(f["bout"]["guard"]["b"]["max"])), "their guard opens full")

func _test_class_edges() -> void:
	for limit in [60.0, 64.0, 81.0, 120.0]:
		var f: Dictionary = _opened(false, limit)
		var both: bool = _close(_g(f, "a"), 70.0) and _close(_g(f, "b"), 70.0)
		_check(both, "amateur limit %.1f opens at 70" % limit)
	_check(_close(_g(_opened(true, 64.0), "a"), 80.0), "pro 64.0 kg is light: max 80")
	_check(_close(_g(_opened(true, 64.1), "a"), 100.0), "pro 64.1 kg is middle: max 100")
	_check(_close(_g(_opened(true, 81.0), "a"), 100.0), "pro 81.0 kg is middle: max 100")
	_check(_close(_g(_opened(true, 81.1), "a"), 120.0), "pro 81.1 kg is heavy: max 120")

func _test_share() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 1)
	f["pro"] = true
	f["limit"] = 81.0
	f["bout"] = {}
	_check(_close(GuardState.share(f, "a"), -1.0), "share before the bell is -1 (a)")
	_check(_close(GuardState.share(f, "b"), -1.0), "share before the bell is -1 (b)")
	var g: Dictionary = _opened(true, 81.0)
	_check(_close(GuardState.share(g, "a"), 1.0), "share at the bell is 1.0")
	_set_g(g, "a", 37.0)
	_check(_close(GuardState.share(g, "a"), 0.37), "share is g / max")

func _test_corner() -> void:
	var f: Dictionary = _opened(true, 81.0)
	_set_g(f, "a", 30.0)
	_set_g(f, "b", 25.0)
	GuardState.open(f, 2)
	_check(_close(_g(f, "a"), 45.0), "corner minute adds +15 to our guard")
	_check(_close(_g(f, "b"), 40.0), "corner minute adds +15 to their guard")
	var full: Dictionary = _opened(true, 81.0)
	GuardState.open(full, 2)
	_check(_close(_g(full, "a"), 100.0), "corner never overfills a full guard (a)")
	_check(_close(_g(full, "b"), 100.0), "corner never overfills a full guard (b)")
	var nearly: Dictionary = _opened(true, 81.0)
	_set_g(nearly, "a", 92.0)
	GuardState.open(nearly, 2)
	_check(_close(_g(nearly, "a"), 100.0), "corner clamps at max, not past it")
	var ff: Dictionary = _opened(true, 81.0)
	_set_g(ff, "a", 45.0)
	_after(ff, [0, 4], "centre", "tie", 1)
	_check(_flag(ff, "a"), "a successful tie sets the clinch flag")
	GuardState.open(ff, 2)
	_check(not _flag(ff, "a"), "the corner resets our clinch flag")
	_check(not _flag(ff, "b"), "the corner resets their clinch flag")

func _test_hands_up() -> void:
	var f: Dictionary = _opened(true, 81.0)
	_after(f, [0, 4], "centre", "hands", 1)
	_set_g(f, "a", 30.0)
	_set_g(f, "b", 30.0)
	GuardState.open(f, 2)
	_check(_close(_g(f, "a"), 50.0), "Hands up earns +5 at the next corner (ours)")
	_check(_close(_g(f, "b"), 45.0), "Hands up does not widen their corner bonus")
	var f2: Dictionary = _opened(true, 81.0)
	_after(f2, [0, 4], "centre", "hands", 1)
	_after(f2, [0, 4], "centre", "hands", 1)
	_set_g(f2, "a", 30.0)
	GuardState.open(f2, 2)
	_check(_close(_g(f2, "a"), 50.0), "Hands up twice in a round gives +5 once")
	var f3: Dictionary = _opened(true, 81.0)
	_after(f3, [0, 4], "centre", "calm", 1)
	_set_g(f3, "a", 30.0)
	GuardState.open(f3, 2)
	_check(_close(_g(f3, "a"), 45.0), "a round without Hands up gets the +15 base only")
	var f4: Dictionary = _opened(true, 81.0)
	_after(f4, [0, 4], "centre", "hands", 1)
	GuardState.open(f4, 2)
	_set_g(f4, "a", 30.0)
	_after(f4, [0, 4], "centre", "calm", 2)
	GuardState.open(f4, 3)
	_check(_close(_g(f4, "a"), 45.0), "Hands up flag resets: the next corner is base only")

func _test_after_shape() -> void:
	var rec: Dictionary = _after(_opened(true, 81.0), [0, 6], "centre", "calm", 1)
	var keys: bool = rec.has("g") and rec.has("blocked") and rec.has("clinch")
	keys = keys and rec.has("through") and rec.has("share")
	_check(keys, "after() returns g, blocked, clinch, through, share")
	var g: Array = rec["g"]
	var blocked: Array = rec["blocked"]
	var through: Array = rec["through"]
	var share: Array = rec["share"]
	var sizes: bool = g.size() == 2 and blocked.size() == 2
	sizes = sizes and through.size() == 2 and share.size() == 2
	_check(sizes, "g, blocked, through, share have two entries each")
	_check(typeof(blocked[0]) == TYPE_INT and typeof(blocked[1]) == TYPE_INT,
		"blocked entries are ints")
	_check(int(blocked[0]) >= 0 and int(blocked[1]) >= 0, "blocked entries are not negative")
	_check(typeof(through[0]) == TYPE_FLOAT and typeof(through[1]) == TYPE_FLOAT,
		"through entries are floats")
	_check(float(through[0]) >= 0.0 and float(through[1]) >= 0.0,
		"through entries are not negative")
	_check(float(share[0]) >= 0.0 and float(share[0]) <= 1.0, "share[0] is in 0..1")
	_check(float(share[1]) >= 0.0 and float(share[1]) <= 1.0, "share[1] is in 0..1")
	_check(typeof(rec["clinch"]) == TYPE_BOOL, "clinch is a bool")

func _test_after_monotonic() -> void:
	var prev_ours: float = 999.0
	for theirs in [2, 4, 8]:
		var g: float = float(_after(_opened(true, 81.0), [2, theirs], "centre", "calm", 1)["g"][0])
		_check(g <= prev_ours, "bigger landed[1] never leaves our guard higher (%d)" % theirs)
		prev_ours = g
	var prev_theirs: float = 999.0
	for ours in [2, 4, 8]:
		var g2: float = float(_after(_opened(true, 81.0), [ours, 2], "centre", "calm", 1)["g"][1])
		_check(g2 <= prev_theirs, "bigger landed[0] never leaves their guard higher (%d)" % ours)
		prev_theirs = g2
	var rec_q: Dictionary = _after(_opened(true, 81.0), [0, 0], "centre", "calm", 1)
	_check(int(rec_q["blocked"][0]) == 0 and int(rec_q["blocked"][1]) == 0,
		"nobody landed: no blocks")
	_check(float(rec_q["through"][0]) == 0.0 and float(rec_q["through"][1]) == 0.0,
		"nobody landed: nothing through")
	var prev_b: int = -1
	for theirs2 in [2, 6]:
		var rec3: Dictionary = _after(_opened(true, 81.0), [0, theirs2], "centre", "calm", 1)
		_check(int(rec3["blocked"][0]) >= prev_b,
			"more thrown at us never means fewer blocks (%d)" % theirs2)
		prev_b = int(rec3["blocked"][0])
	var rec_hot: Dictionary = _after(_opened(true, 81.0), [0, 6], "centre", "calm", 1)
	_check(int(rec_hot["blocked"][0]) >= 1, "punches that do not land are partly blocked")

func _test_after_ropes() -> void:
	var g_c: float = float(_after(_opened(true, 81.0), [0, 6], "centre", "calm", 1)["g"][0])
	var g_r: float = float(_after(_opened(true, 81.0), [0, 6], "own_ropes", "calm", 1)["g"][0])
	_check(g_r <= g_c, "own_ropes wears our guard at least as much as centre")
	var g_tc: float = float(_after(_opened(true, 81.0), [6, 0], "centre", "calm", 1)["g"][1])
	var g_tr: float = float(_after(_opened(true, 81.0), [6, 0], "opp_ropes", "calm", 1)["g"][1])
	_check(g_tr <= g_tc, "opp_ropes wears their guard at least as much as centre")

func _test_after_amateur() -> void:
	var fa: Dictionary = _opened(false, 81.0)
	var fp: Dictionary = _opened(true, 81.0)
	_set_g(fa, "a", 70.0)
	_set_g(fp, "a", 70.0)
	_set_max(fp, "a", 70.0)
	var a_am: float = float(_after(fa, [0, 6], "centre", "calm", 1)["g"][0])
	var a_pro: float = float(_after(fp, [0, 6], "centre", "calm", 1)["g"][0])
	_check(a_am >= a_pro, "amateur wears our guard less, same landed, same max")
	var fa2: Dictionary = _opened(false, 81.0)
	var fp2: Dictionary = _opened(true, 81.0)
	_set_g(fa2, "b", 70.0)
	_set_g(fp2, "b", 70.0)
	_set_max(fp2, "b", 70.0)
	var b_am: float = float(_after(fa2, [6, 0], "centre", "calm", 1)["g"][1])
	var b_pro: float = float(_after(fp2, [6, 0], "centre", "calm", 1)["g"][1])
	_check(b_am > b_pro, "amateur wears their guard less, same landed, same max")

func _test_after_recovery() -> void:
	var fa: Dictionary = _opened(false, 70.0)
	_set_g(fa, "a", 50.0)
	_set_g(fa, "b", 50.0)
	var rec_a: Dictionary = _after(fa, [0, 0], "centre", "calm", 1)
	_check(_close(float(rec_a["g"][0]), 54.0), "0 thrown at us: we recover +4 amateur")
	_check(_close(float(rec_a["g"][1]), 54.0), "0 thrown at them: they recover +4 amateur")
	var fp: Dictionary = _opened(true, 81.0)
	_set_g(fp, "a", 50.0)
	_set_g(fp, "b", 50.0)
	var rec_p: Dictionary = _after(fp, [0, 0], "centre", "calm", 1)
	_check(_close(float(rec_p["g"][0]), 53.0), "0 thrown at us: we recover +3 pro")
	_check(_close(float(rec_p["g"][1]), 53.0), "0 thrown at them: they recover +3 pro")

func _test_after_bounds() -> void:
	var f: Dictionary = _opened(true, 81.0)
	_set_g(f, "a", 3.0)
	_set_g(f, "b", 4.0)
	var rec: Dictionary = _after(f, [30, 30], "centre", "calm", 1)
	_check(float(rec["g"][0]) >= 0.0, "our guard never goes below 0")
	_check(float(rec["g"][1]) >= 0.0, "their guard never goes below 0")
	_check(float(rec["g"][0]) <= 100.0, "our guard never goes above its max")
	_check(float(rec["g"][1]) <= 100.0, "their guard never goes above its max")
	var fa: Dictionary = _opened(false, 70.0)
	_set_g(fa, "a", 69.0)
	_set_g(fa, "b", 68.0)
	var rec2: Dictionary = _after(fa, [0, 0], "centre", "calm", 1)
	_check(float(rec2["g"][0]) <= 70.0, "recovery never pushes our guard past its max")
	_check(float(rec2["g"][1]) <= 70.0, "recovery never pushes their guard past its max")

func _tie_diff(g0: float, call: String) -> float:
	var f_c: Dictionary = _opened(true, 81.0)
	_set_g(f_c, "a", g0)
	var f_t: Dictionary = _opened(true, 81.0)
	_set_g(f_t, "a", g0)
	var g_c: float = float(_after(f_c, [0, 4], "centre", "calm", 1)["g"][0])
	var g_t: float = float(_after(f_t, [0, 4], "centre", call, 1)["g"][0])
	return g_t - g_c

func _test_tie() -> void:
	_check(_close(_tie_diff(100.0, "tie"), 0.0), "tie at a full guard gives nothing")
	_check(_close(_tie_diff(50.0, "tie"), 0.0), "a tie at exactly half gives nothing")
	var f_h: Dictionary = _opened(true, 81.0)
	_set_g(f_h, "a", 50.0)
	var rec_h: Dictionary = _after(f_h, [0, 4], "centre", "tie", 1)
	_check(not bool(rec_h["clinch"]), "a tie at exactly half does not set clinch")
	_check(_close(_tie_diff(45.0, "tie"), 10.0), "tie under half gives +10 guard")
	_check(_close(_tie_diff(49.9, "tie"), 10.0), "tie just under half gives +10")
	var f_u: Dictionary = _opened(true, 81.0)
	_set_g(f_u, "a", 45.0)
	var rec_u: Dictionary = _after(f_u, [0, 4], "centre", "tie", 1)
	_check(bool(rec_u["clinch"]), "tie under half returns clinch true")
	var f_u2: Dictionary = _opened(true, 81.0)
	_set_g(f_u2, "a", 45.0)
	var rec_u2: Dictionary = _after(f_u2, [0, 4], "centre", "calm", 1)
	_check(_close(float(rec_u["g"][1]), float(rec_u2["g"][1])), "tie does not touch their guard")
	var f_s: Dictionary = _opened(true, 81.0)
	_set_g(f_s, "a", 45.0)
	_after(f_s, [0, 4], "centre", "tie", 1)
	_set_g(f_s, "a", 45.0)
	var rec_s: Dictionary = _after(f_s, [0, 4], "centre", "tie", 1)
	var f_s2: Dictionary = _opened(true, 81.0)
	_set_g(f_s2, "a", 45.0)
	var rec_s2: Dictionary = _after(f_s2, [0, 4], "centre", "calm", 1)
	_check(_close(float(rec_s["g"][0]), float(rec_s2["g"][0])),
		"a second tie in the same round gives nothing")
	_check(not bool(rec_s["clinch"]), "a second tie in the same round returns clinch false")
	var f_n: Dictionary = _opened(true, 81.0)
	_set_g(f_n, "a", 45.0)
	_after(f_n, [0, 4], "centre", "tie", 1)
	GuardState.open(f_n, 2)
	_set_g(f_n, "a", 45.0)
	var rec_n: Dictionary = _after(f_n, [0, 4], "centre", "tie", 2)
	var f_n3: Dictionary = _opened(true, 81.0)
	_set_g(f_n3, "a", 45.0)
	var rec_n3: Dictionary = _after(f_n3, [0, 4], "centre", "calm", 2)
	_check(_close(float(rec_n["g"][0]) - float(rec_n3["g"][0]), 10.0),
		"a tie after the corner (new round) gives +10 again")
	_check(_flag(f_n, "a"), "a tie in the new round sets the clinch flag again")

func _test_damage_on() -> void:
	var f_on: Dictionary = _opened(true, 81.0)
	var f_off: Dictionary = _opened(true, 81.0)
	GuardState.damage_on = true
	var rec_on: Dictionary = _after(f_on, [0, 6], "centre", "calm", 1)
	GuardState.damage_on = false
	var rec_off: Dictionary = _after(f_off, [0, 6], "centre", "calm", 1)
	GuardState.damage_on = true
	_check(str(rec_on["g"]) == str(rec_off["g"]), "damage_on false: after() returns the same g")
	_check(str(rec_on["blocked"]) == str(rec_off["blocked"]), "damage_on false: same blocked")
	_check(str(rec_on["through"]) == str(rec_off["through"]), "damage_on false: same through")
	_check(str(rec_on["share"]) == str(rec_off["share"]), "damage_on false: same share")
	_check(bool(rec_on["clinch"]) == bool(rec_off["clinch"]), "damage_on false: same clinch")
	_set_g(f_on, "a", 37.0)
	_check(_close(GuardState.share(f_on, "a"), 0.37), "share reads g / max")

func _test_guard_habit() -> void:
	_check(GuardState.guard_habit([]) == "", "no habits: guard_habit is empty")
	_check(GuardState.guard_habit(["work_rate"]) == "", "no guard habits: guard_habit is empty")
	_check(GuardState.guard_habit(["slow_starter"]) == "slow_starter",
		"slow_starter is a guard habit")
	_check(GuardState.guard_habit(["fades_late"]) == "fades_late", "fades_late is a guard habit")
	_check(GuardState.guard_habit(["chases_stoppage"]) == "chases_stoppage",
		"chases_stoppage is a guard habit")
	_check(GuardState.guard_habit(["steady", "fades_late"]) == "fades_late",
		"non-guard habits are ignored")
	_check(GuardState.guard_habit(["fades_late", "slow_starter"]) == "slow_starter",
		"the first listed guard habit wins")
