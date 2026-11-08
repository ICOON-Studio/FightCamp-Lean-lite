extends SceneTree
## BJJBEAT1: the two-sided beat (BjjBeat, BEATS2 = 1) against the real bars. Seeded, headless, n >= 1000.
## BJJBEAT2 baseline at n=1000, before STRIPE_EDGE: four-stripe blue 0.796. The mean of that blue row with purple
## 0.723, brown 0.719 and black 0.677 is 0.729, which the old RESULT line called "4-stripe". White was 0.780, beside it.
## Even fields and the first scorer use tools/bjj_tree_tally.gd (the same calls as tools/bjj_tree_balance.gd).
## Belt gaps and four-stripe rows use tools/bjj_realism_probe.gd's walks (parts=walk,inside).
## A 20-s stall count fired when BjjRef's stall tally for the bout is above zero (the count, not only a later penalty).
## Optional, not used by the harness: -- n=80 only=even|gaps|inside|all search=24 space=ACT_P:0.2:0.8,LATE_S:40:140

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const Tally := preload("res://tools/bjj_tree_tally.gd")
const Probe := preload("res://tools/bjj_realism_probe.gd")

var failures := 0
var _lines: Array = []


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _in(x: float, lo: float, hi: float) -> bool:
	return x >= lo and x <= hi


func _d(x: float, lo: float, hi: float) -> float:
	if x < lo:
		return (lo - x) / maxf(0.01, hi - lo)
	return (x - hi) / maxf(0.01, hi - lo) if x > hi else 0.0


## Even field of one belt: submission share, sub attempts a bout, referee decisions, stall-count share, first scorer.
func _even(belt: String, n: int) -> Dictionary:
	var t0 := Time.get_ticks_msec()
	var ws: Array = Tally.even_field(belt, n)
	var t: Dictionary = Tally.tally(ws)
	var dec := 0
	var stall := 0
	for w in ws:
		if str(w.get("by", "")) == "decision":
			dec += 1
		var st: Variant = w.get("stalls", [0, 0])
		if int(st[0]) + int(st[1]) > 0:
			stall += 1
	var nn := maxf(1.0, float(t["bouts"]))
	var fn := maxf(1.0, float(t["first_n"]))
	return {"sub": float(t["subs"]) / nn, "att": float(t["sub_att"]) / nn,
		"apm": float(t["sub_att"]) / maxf(1.0, float(t["secs"]) / 60.0), "ref": float(dec) / nn,
		"stall": float(stall) / nn, "first": float(t["first_won"]) / fn, "first_n": int(t["first_n"]),
		"top": Tally.top(t["finish"]), "ms": Time.get_ticks_msec() - t0}


## Higher belt's win share. Same seeds and side flip as the realism probe's walk matrix.
func _gap(lo: String, hi: String, n: int) -> float:
	var wins := 0
	for s in n:
		var r := Probe._rng(s, "walk|%s|%s" % [lo, hi])
		var a := Probe.gen(lo, str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|a|%s" % [s, lo]))
		var b := Probe.gen(hi, str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|b|%s" % [s, hi]))
		var w: Dictionary = Probe.walk_one(a, b, r) if s % 2 == 0 else Probe.walk_one(b, a, r)
		var higher_won := (s % 2 == 0 and not bool(w["win"])) or (s % 2 == 1 and bool(w["win"]))
		wins += 1 if higher_won else 0
	return float(wins) / maxf(1.0, n)


## Four-stripe (class share 1) over a fresh athlete (0). Same draw as the probe's inside rows.
func _inside(belt: String, n: int) -> float:
	var keep: Vector2 = BjjOpp.T["CLASS_SHARE"]
	var wins := 0
	for s in n:
		var r := Probe._rng(s, "inside|%s" % belt)
		BjjOpp.T["CLASS_SHARE"] = Vector2(0.0, 0.0)
		var a := Probe.gen(belt, str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|ia|%s" % [s, belt]))
		BjjOpp.T["CLASS_SHARE"] = Vector2(1.0, 1.0)
		var b := Probe.gen(belt, str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|ib|%s" % [s, belt]))
		var w: Dictionary = Probe.walk_one(a, b, r) if s % 2 == 0 else Probe.walk_one(b, a, r)
		var ready_won := (s % 2 == 0 and not bool(w["win"])) or (s % 2 == 1 and bool(w["win"]))
		wins += 1 if ready_won else 0
	BjjOpp.T["CLASS_SHARE"] = keep
	return float(wins) / maxf(1.0, n)


func _gap_band(lo: String, hi: String) -> Array:
	var g := BeltRoad.rank(hi) - BeltRoad.rank(lo)
	var band: Array = {1: [0.70, 0.85], 2: [0.85, 0.97], 3: [0.92, 0.99], 4: [0.92, 0.99]}[g]
	if g == 1 and lo == "white":
		band = [0.80, 0.90]
	elif g == 1 and lo == "brown":
		band = [0.60, 0.72]
	return [g, float(band[0]), float(band[1])]


func _note(line: String) -> void:
	_lines.append(line)
	print("  " + line)


func _finish(diag: bool) -> void:
	var tag := "DIAG" if diag else ("PASS" if failures == 0 else "FAIL")
	print("BJJ_BEAT_ON %s failures=%d" % [tag, failures])
	quit(0 if failures == 0 or diag else 1)


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	var n := 1000
	var only := "all"
	var search := 0
	var space := ""
	for a in OS.get_cmdline_user_args():
		var k := str(a).get_slice("=", 0)
		var v := str(a).get_slice("=", 1)
		match k:
			"n":
				n = int(v)
			"only":
				only = v
			"search":
				search = int(v)
			"space":
				space = v
			_:
				if BjjTree.T.has(k):
					BjjTree.T[k] = float(v)
					print("  set %s=%s" % [k, v])
	if search > 0:
		_search(n, search, space, only)
		quit(0)
		return
	if float(BjjTree.T.get("BEATS2", 0.0)) <= 0.0:
		_check(false, "BEATS2 is on")
		_finish(false)
		return
	var t0 := Time.get_ticks_msec()
	var even := {}
	if only == "all" or only == "even":
		for belt in ["white", "blue", "purple", "brown", "black"]:
			even[belt] = _even(belt, n)
			var m: Dictionary = even[belt]
			_note("%s sub %.3f att %.2f apm %.3f ref %.3f stall %.3f first %.3f (%d) top %s  %.1fs" % [
				belt, m["sub"], m["att"], m["apm"], m["ref"], m["stall"], m["first"], m["first_n"], m["top"],
				float(m["ms"]) / 1000.0])
		var w: Dictionary = even["white"]
		var bl: Dictionary = even["blue"]
		var br: Dictionary = even["brown"]
		var bk: Dictionary = even["black"]
		_check(_in(float(w["sub"]), 0.30, 0.55), "white even subs 0.30-0.55 (got %.3f)" % w["sub"])
		_check(_in(float(w["att"]), 2.0, 4.0), "white sub attempts 2-4 a bout (got %.2f)" % w["att"])
		_check(_in(float(w["ref"]), 0.02, 0.10), "white referee decisions 0.02-0.10 (got %.3f)" % w["ref"])
		_check(_in(float(bl["first"]), 0.80, 0.87), "first scorer wins 0.80-0.87 (got %.3f)" % bl["first"])
		_check(_in(float(w["stall"]), 0.05, 0.25), "white stall count 5-25%% (got %.3f)" % w["stall"])
		_check(float(bk["stall"]) < 0.10, "black stall count < 10%% (got %.3f)" % bk["stall"])
		_check(_in(float(bl["sub"]), 0.45, 0.60), "blue even subs 0.45-0.60 (got %.3f)" % bl["sub"])
		_check(_in(float(br["sub"]), 0.45, 0.60), "brown even subs 0.45-0.60 (got %.3f)" % br["sub"])
		_check(_in(float(bk["sub"]), 0.40, 0.60), "black even subs 0.40-0.60 (got %.3f)" % bk["sub"])
	var one := []
	var two := []
	var w2b := -1.0
	var br2bk := -1.0
	if only == "all" or only == "gaps":
		var pairs := [["white", "blue"], ["white", "purple"], ["white", "brown"], ["white", "black"],
			["blue", "purple"], ["blue", "brown"], ["blue", "black"], ["purple", "brown"], ["purple", "black"], ["brown", "black"]]
		for pair in pairs:
			var lo: String = pair[0]
			var hi: String = pair[1]
			var band: Array = _gap_band(lo, hi)
			var p := _gap(lo, hi, n)
			_note("gap %d %s>%s %.3f (%.2f-%.2f)" % [band[0], hi, lo, p, band[1], band[2]])
			_check(_in(p, float(band[1]), float(band[2])), "gap %s>%s %.2f-%.2f (got %.3f)" % [hi, lo, band[1], band[2], p])
			if int(band[0]) == 1 and not (lo == "white" or lo == "brown"):
				one.append(p)
			elif int(band[0]) == 2:
				two.append(p)
			if lo == "white" and hi == "blue":
				w2b = p
			if lo == "brown" and hi == "black":
				br2bk = p
	var stripe_b := -1.0
	var stripe_w := -1.0
	if only == "all" or only == "inside":
		for belt in ["white", "blue", "purple", "brown", "black"]:
			var p := _inside(belt, n)
			var lo := 0.72 if belt == "white" else 0.62
			var hi := 0.85 if belt == "white" else 0.76
			_note("inside %s %.3f (%.2f-%.2f)" % [belt, p, lo, hi])
			_check(_in(p, lo, hi), "inside %s %.2f-%.2f (got %.3f)" % [belt, lo, hi, p])
			if belt == "white":
				stripe_w = p
			elif belt == "blue":
				stripe_b = p
	if only == "all":
		var one_m := 0.0
		for x in one:
			one_m += float(x)
		one_m /= maxf(1.0, one.size())
		var two_m := 0.0
		for x in two:
			two_m += float(x)
		two_m /= maxf(1.0, two.size())
		var w: Dictionary = even["white"]
		var bl: Dictionary = even["blue"]
		var bk: Dictionary = even["black"]
		_note("RESULT white subs %.3f attempts %.2f ref %.3f | first scorer %.3f | stall white %.3f black %.3f" % [
			w["sub"], w["att"], w["ref"], bl["first"], w["stall"], bk["stall"]])
		_note("RESULT belt table one %.3f white->blue %.3f brown->black %.3f two %.3f 4-stripe blue %.3f 4-stripe white %.3f" % [
			one_m, w2b, br2bk, two_m, stripe_b, stripe_w])
	print("  info %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_finish(only != "all")


## Summed out-of-band distance for a tuning pass. only=even skips the belt table (the slow part).
func _search(n: int, tries: int, space: String, only: String) -> void:
	var dims: Array = []
	for d in space.split(","):
		if str(d) == "":
			continue
		dims.append([d.get_slice(":", 0), float(d.get_slice(":", 1)), float(d.get_slice(":", 2))])
	var base := BjjTree.T.duplicate()
	var r := RandomNumberGenerator.new()
	r.seed = 402
	var best: Array = []
	for i in tries:
		BjjTree.T = base.duplicate()
		BjjOpp.reset_tuning()
		var pt: Array = []
		for d in dims:
			var v := snappedf(r.randf_range(float(d[1]), float(d[2])), 0.01)
			BjjTree.T[str(d[0])] = v
			pt.append("%s=%s" % [d[0], v])
		var dist := 0.0
		var bits: Array = []
		if only != "gaps" and only != "inside":
			for belt in ["white", "blue", "brown", "black"]:
				var m := _even(belt, n)
				var sub_lo: float = {"white": 0.30, "blue": 0.45, "brown": 0.45, "black": 0.40}[belt]
				var sub_hi: float = {"white": 0.55, "blue": 0.60, "brown": 0.60, "black": 0.60}[belt]
				dist += _d(float(m["sub"]), float(sub_lo), float(sub_hi))
				if belt == "white":
					dist += _d(float(m["att"]), 2.0, 4.0) + _d(float(m["ref"]), 0.02, 0.10) + _d(float(m["stall"]), 0.05, 0.25)
				if belt == "blue":
					dist += _d(float(m["first"]), 0.80, 0.87)
				if belt == "brown":
					dist += _d(float(m["apm"]), 0.50, 0.75)
				if belt == "black":
					dist += _d(float(m["stall"]), 0.0, 0.099)
				bits.append("%s sub %.3f att %.2f apm %.2f ref %.3f stall %.3f first %.3f" % [belt, m["sub"], m["att"], m["apm"], m["ref"], m["stall"], m["first"]])
		if only == "all" or only == "gaps":
			for pair in [["white", "blue"], ["brown", "black"], ["blue", "purple"], ["white", "purple"]]:
				var band: Array = _gap_band(str(pair[0]), str(pair[1]))
				var p := _gap(str(pair[0]), str(pair[1]), n)
				dist += _d(p, float(band[1]), float(band[2]))
				bits.append("%s>%s %.3f" % [pair[1], pair[0], p])
		print("S %3d dist %6.2f  %s  || %s" % [i, dist, " ".join(pt), " | ".join(bits)])
		best.append([dist, " ".join(pt)])
	best.sort_custom(func(a, b): return float(a[0]) < float(b[0]))
	for b in best.slice(0, 6):
		print("BEST %.2f %s" % [b[0], b[1]])
