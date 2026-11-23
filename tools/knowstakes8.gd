extends SceneTree
## KNOWSTAKES8 (S540): greybox of the prospect decision, v7 rules against v8 rules, on the SAME prospects and dice.
## DESIGN_KNOW_STAKES1_V8.md section 5. Widths, offsets and reads come from scripts/rules/Knowledge.gd itself
## (fresh / expose / hard_spar / range_of); the ceiling range, the clock, the bond and the value of a good signing are
## ESTIMATES of this greybox, swept where unknown (V = what a good signing is worth to the club, $3,000 / $5,000 / $8,000).
## Population: n prospects per run (seeds 54000..), every one different (body, skills, under fire ~ N(60, 7), ceiling gap
## U(4, 22)), each with a second name due 7-42 days later. One free place. Region level 60.
## Three pure calls replayed on every decision with the same dice: HUNCH (decide on the first look), LOOK (buy the read
## that fits the clock, then decide), WAIT (Continue 7 days, then decide, seeing the next name if it came).
## Args: n=<decisions> ; last line: KNOWSTAKES8 done.

const K := preload("res://scripts/rules/Knowledge.gd")

const LEVEL := 60.0
const STIPEND := 250.0
const CUT_WEEK := 8          # a flop is plain by week 8 of training (sign-and-cut lets go then)
const BOND_WEEKS := 12       # v8: the stipend binds 12 weeks
const TEST_COST := 60.0
const TRIAL_COST := 125.0
const CEIL_HW := 9.0         # v7
const CEIL_HW_V8 := 14.0     # v8: the ceiling is the widest unknown at first sight
const WINDOW := 7            # v8: the rival decides on one day of a 7-day window that ends on the date shown
const PAD_SHARE := 0.5       # v8: the trial's pad test halves the ceiling range (Kalli asked a third; run 6 of the result)
const WAIT_BODY := 8.0       # v8: a week waited = the open session: body exposure +8
const WAIT_SKILLS := 8.0     # v8: and skills +8 (light pads at the open session)
const FIRE_REC := 65.8       # E[under fire | the record reads well] in this population
const FIRE_NOREC := 57.1
const VALUES: Array = [3000.0, 5000.0, 8000.0]
const CALLS: Array = ["hunch", "look", "wait"]
const ARMS: Array = ["hunch", "look", "wait", "sign_cut", "clock_only", "buy_all", "selective", "truth"]

var n := 20000
var pool := "maybes"     # maybes = the scout brings names whose first look sits within MAYBE of the level; all = no filter
const MAYBE := 3.0
const SEL_ABS := 1.2      # selective reads only real coin flips: |first look - level| < 1.2 (the read button's odds line)
var seed0 := 54000


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("n="):
			n = int(s.substr(2))
		elif s.begins_with("pool="):
			pool = s.substr(5)
	print("=== KNOWSTAKES8 PROBE: %d prospects (seeds %d..), level %.0f, V %s ===" % [n, seed0, LEVEL, str(VALUES)])
	print("BARS (fixed before the run, v8 only): B1 each of hunch/look/wait best in >= 15%% and none > 60%% of decisive")
	print("  decisions; B2 selective beats every other arm but truth, 95%% low end > 0; B3 selective's reads flip the first-look call")
	print("  25-60%%; B4 the clock, beside the first look, adds less R2 than the test day adds. CONTROL: v7 with clock 999 -> look")
	print("  best in > 60%%.")
	var people: Array = []
	var sd := seed0
	while people.size() < n:
		var p := _person(sd)
		sd += 1
		if pool == "maybes":
			var e := estimate(p, K.fresh(int(p["seed"])), CEIL_HW_V8, "v7")
			if absf(float(e["est"]) - LEVEL) > MAYBE:
				continue
		people.append(p)
	print("population: %s, %d prospects kept of %d drawn" % [pool, people.size(), sd - seed0])
	for v in VALUES:
		for ver in ["v7", "v8", "v7_noclock"]:
			_run(people, str(ver), float(v))
	_clock_r2(people)
	print("KNOWSTAKES8 done")
	quit(0)


func _person(sd: int) -> Dictionary:
	var r := RandomNumberGenerator.new()
	r.seed = sd
	var p := _truths(r, sd)
	p["loss_u"] = r.randf()
	p["rday_u"] = r.randf()
	p["a2"] = r.randi_range(7, 42)
	p["fc_noise"] = r.randi_range(-7, 7)
	p["n2"] = _truths(r, sd + 500000)
	return p


func _truths(r: RandomNumberGenerator, sd: int) -> Dictionary:
	var b := clampf(r.randfn(60.0, 7.0), 30.0, 90.0)
	var s := clampf(r.randfn(60.0, 7.0), 30.0, 90.0)
	var f := clampf(r.randfn(60.0, 7.0), 30.0, 90.0)
	var c := (0.4 * b + 0.4 * s + 0.2 * f) + r.randf_range(4.0, 22.0)
	return {"seed": sd, "b": b, "s": s, "f": f, "c": c, "rec": (f + r.randfn(0.0, 6.0)) > 64.0,
		"crand": r.randi_range(0, 6)}


static func merit(p: Dictionary) -> float:
	return 0.6 * (0.4 * float(p["b"]) + 0.4 * float(p["s"]) + 0.2 * float(p["f"])) + 0.4 * (float(p["c"]) - 12.0)


## The rival's own first look (same rule, own seed) and the clock it sets.
static func rival_look(p: Dictionary) -> Dictionary:
	var k := K.fresh(int(p["seed"]) + 7777)
	return {"b": float(K.range_of(k, "strength", float(p["b"]))["centre"]),
		"s": float(K.range_of(k, "accuracy", float(p["s"]))["centre"])}


static func clock(p: Dictionary, ver: String) -> int:
	if ver == "v7_noclock":
		return 999
	var rl := rival_look(p)
	var d := 21
	if bool(p["rec"]):
		d -= 7
	if 0.5 * (float(rl["b"]) + float(rl["s"])) > LEVEL:
		d -= 7
	if ver == "v8":
		d -= int(p["crand"])
	return maxi(d, 7)


## The day the rival signs: v7 the date itself; v8 one day of the window ending on it.
static func rival_day(p: Dictionary, ver: String) -> int:
	var d := clock(p, ver)
	if ver != "v8":
		return d
	return maxi(1, d - int(floor(float(p.get("rday_u", 0.0)) * float(WINDOW))))


static func ceil0(ver: String) -> float:
	return CEIL_HW_V8 if ver == "v8" else CEIL_HW


## Odds the rival signs before day t, as the button shows them (v8: from the window only).
static func risk_before(d: int, t: int) -> float:
	var lo := maxi(1, d - WINDOW + 1)
	if t <= lo:
		return 0.0
	return clampf(float(t - lo) / float(d - lo + 1), 0.0, 1.0)


## What the player believes: {est, u}. v8 shows the rival's look beside one's own.
static func estimate(p: Dictionary, k: Dictionary, ceil_hw: float, ver: String) -> Dictionary:
	var rb: Dictionary = K.range_of(k, "strength", float(p["b"]))
	var rs: Dictionary = K.range_of(k, "accuracy", float(p["s"]))
	var b: float = float(rb["centre"])
	var s: float = float(rs["centre"])
	var wf := 15.0
	var f := FIRE_REC if bool(p.get("rec", false)) else FIRE_NOREC  # the record is on the card in v7 and v8
	if bool(k.get("under_fire_opened", false)):
		var rf: Dictionary = K.range_of(k, "durability", float(p["f"]))
		f = float(rf["centre"])
		wf = float(rf["width"])
	if ver == "v8":
		var rl := rival_look(p)
		b = 0.5 * (b + float(rl["b"]))
		s = 0.5 * (s + float(rl["s"]))
	var c: float = float(p["c"]) + K._offset(k, "ceiling") * ceil_hw
	var est := 0.6 * (0.4 * b + 0.4 * s + 0.2 * f) + 0.4 * (c - 12.0)
	var u := 0.24 * float(rb["width"]) + 0.24 * float(rs["width"]) + 0.12 * wf + 0.4 * ceil_hw
	return {"est": est, "u": u}


## Signing at day t: value and the day the place is free again (-1 = never).
static func sign_out(p: Dictionary, v: float, ver: String) -> Dictionary:
	if merit(p) >= LEVEL:
		return {"val": v, "free": -1}
	var weeks: int = BOND_WEEKS if ver == "v8" else CUT_WEEK
	return {"val": -STIPEND * float(maxi(weeks, CUT_WEEK)), "free": CUT_WEEK * 7}


## The second name: taken on its first look if the place is free while its clock runs.
static func second(p: Dictionary, free_from: int, t0: int, v: float, ver: String) -> float:
	if free_from < 0:
		return 0.0
	var q: Dictionary = p["n2"]
	var a2: int = int(p["a2"])
	var d2: int = clock(q, ver)
	if t0 + free_from > a2 + d2:
		return 0.0
	var e := estimate(q, K.fresh(int(q["seed"])), ceil0(ver), ver)
	if float(e["est"]) < LEVEL:
		return 0.0
	return float(sign_out(q, v, ver)["val"])


func _loss_p(d: int, ver: String) -> float:
	if ver != "v8":
		return 0.25
	if d >= 21:
		return 0.125
	if d < 10:
		return 1.0 / 3.0
	return 0.25


## One call on one prospect. Returns {val, cost, lost, signed, flip, first}.
func _play(p: Dictionary, call: String, v: float, ver: String) -> Dictionary:
	var d := clock(p, ver)
	var k := K.fresh(int(p["seed"]))
	var ceil_hw := ceil0(ver)
	var rday := rival_day(p, ver)
	var e0 := estimate(p, k, ceil_hw, ver)
	var first: bool = float(e0["est"]) >= LEVEL
	var out := {"val": 0.0, "cost": 0.0, "lost": false, "signed": false, "flip": false, "first": first, "read": false}
	var t := 0
	var mode := call
	if call == "sign_cut":
		return _finish(p, out, true, 0, v, ver)
	if call == "truth":
		return _finish(p, out, merit(p) >= LEVEL, 0, v, ver)
	if call == "clock_only":
		return _finish(p, out, d <= 10, 0, v, ver)
	if call == "selective":
		var straddle := absf(float(e0["est"]) - LEVEL) < SEL_ABS
		var due: bool = int(p["a2"]) + int(p["fc_noise"]) <= 7 and risk_before(d, 8) < 0.34 and (ver != "v8" or d > 7)
		mode = "hunch" if not straddle else ("wait" if due else "look")
		if ver == "v8" and mode == "wait" and risk_before(d, 8) > 0.0:
			mode = "look"
	if mode == "hunch":
		return _finish(p, out, first, 0, v, ver)
	if mode == "look" or mode == "buy_all":
		out["read"] = true
		if mode == "buy_all" or d < 7:
			out["cost"] = float(out["cost"]) + TEST_COST
			K.expose(k, "body", 16.0, "test")
			t = 1
		var trial_ok: bool = d >= 7 + t
		if ver == "v8" and call == "selective" and risk_before(d, 7 + t) > 0.34:
			trial_ok = false
		if trial_ok:
			var lost := float(p["loss_u"]) < _loss_p(d, ver)
			if ver == "v8":
				lost = rday < 7 + t
			if not (lost and ver == "v8"):
				out["cost"] = float(out["cost"]) + TRIAL_COST
			if lost:
				out["lost"] = true
				out["val"] = second(p, 0, 0, v, ver) - float(out["cost"])
				return out
			K.expose(k, "body", 12.0 if ver == "v8" else 24.0, "session")
			K.expose(k, "skills", 24.0, "session")
			K.hard_spar(k, false)
			if ver == "v8":
				ceil_hw = ceil_hw * PAD_SHARE
			t += 7
		var e1 := estimate(p, k, ceil_hw, ver)
		var go: bool = float(e1["est"]) >= LEVEL
		out["flip"] = go != first
		return _finish(p, out, go, t, v, ver)
	# wait: Continue 7 days (or to the last day), then decide; the next name may be in.
	var w := mini(7, d)
	if ver == "v8" and rday <= w and int(p["a2"]) > w:
		out["lost"] = true
		out["val"] = second(p, 0, w, v, ver)
		return out
	if ver == "v8":
		K.expose(k, "body", WAIT_BODY * float(w) / 7.0, "session")
		K.expose(k, "skills", WAIT_SKILLS * float(w) / 7.0, "session")
	var e2 := estimate(p, k, ceil_hw, ver)
	var go2: bool = float(e2["est"]) >= LEVEL
	if int(p["a2"]) <= w:
		var q: Dictionary = p["n2"]
		var eq := estimate(q, K.fresh(int(q["seed"])), ceil0(ver), ver)
		if float(eq["est"]) > float(e2["est"]) and float(eq["est"]) >= LEVEL:
			out["signed"] = true
			out["val"] = float(sign_out(q, v, ver)["val"]) - float(out["cost"])
			return out
	return _finish(p, out, go2, w, v, ver)


func _finish(p: Dictionary, out: Dictionary, go: bool, t: int, v: float, ver: String) -> Dictionary:
	var val := -float(out["cost"])
	if go:
		var so := sign_out(p, v, ver)
		val += float(so["val"])
		val += second(p, int(so["free"]), t, v, ver)
		out["signed"] = true
	else:
		val += second(p, 0, t, v, ver)
	out["val"] = val
	return out


func _run(people: Array, ver: String, v: float) -> void:
	var sums := {}
	var vals := {}
	for a in ARMS:
		vals[a] = []
	var best := {"hunch": 0, "look": 0, "wait": 0, "tie": 0}
	var flips := 0
	var reads := 0
	var sel_lost := 0
	var all_lost := 0
	for p in people:
		var res := {}
		for a in ARMS:
			res[a] = _play(p, str(a), v, ver)
			(vals[a] as Array).append(float(res[a]["val"]))
		var top := -1e18
		var who := ""
		var ties := 0
		for c in CALLS:
			var x: float = float(res[c]["val"])
			if x > top + 0.01:
				top = x; who = str(c); ties = 0
			elif absf(x - top) <= 0.01:
				ties += 1
		if ties > 0:
			best["tie"] += 1
		else:
			best[who] += 1
		if bool(res["selective"]["read"]) and not bool(res["selective"]["lost"]):
			reads += 1
			if bool(res["selective"]["flip"]):
				flips += 1
		if bool(res["selective"]["lost"]):
			sel_lost += 1
		if bool(res["buy_all"]["lost"]):
			all_lost += 1
	var decisive: int = int(best["hunch"]) + int(best["look"]) + int(best["wait"])
	print("--- %s, V $%.0f: %d prospects, %d decisive (%d ties) ---" % [ver, v, people.size(), decisive, best["tie"]])
	var shares := []
	for c in CALLS:
		var sh := 100.0 * float(best[c]) / maxf(1.0, float(decisive))
		shares.append(sh)
		print("  best per decision: %-6s %5.1f%%" % [c, sh])
	var sel: Array = vals["selective"]
	var b2 := true
	for a in ARMS:
		var m := _mean(vals[a])
		var dif := _diff(sel, vals[a])
		print("  arm %-10s mean $%7.0f   selective minus it $%6.0f (95%%: %6.0f .. %6.0f)" % [a, m, dif[0], dif[1], dif[2]])
		if a != "selective" and a != "truth" and dif[1] <= 0.0:
			b2 = false
	var flip := 100.0 * float(flips) / maxf(1.0, float(reads))
	print("  selective's reads flip the first-look call: %.1f%% of %d completed reads; lost to the rival: selective %.1f%%, buy-all %.1f%%"
		% [flip, reads, 100.0 * sel_lost / people.size(), 100.0 * all_lost / people.size()])
	if ver == "v8":
		var b1 := true
		for sh in shares:
			if float(sh) < 15.0 or float(sh) > 60.0:
				b1 = false
		print("  B1 %s  B2 %s  B3 %s" % ["PASS" if b1 else "FAIL", "PASS" if b2 else "FAIL",
			"PASS" if flip >= 25.0 and flip <= 60.0 else "FAIL"])
	elif ver == "v7_noclock":
		print("  CONTROL (look best > 60%%): %s" % ["PASS" if float(shares[1]) > 60.0 else "FAIL"])


func _clock_r2(people: Array) -> void:
	for ver in ["v7", "v8"]:
		var m: Array = []
		var dd: Array = []
		var e0: Array = []
		var e1: Array = []
		for p in people:
			m.append(merit(p))
			dd.append(float(clock(p, ver)))
			var k := K.fresh(int(p["seed"]))
			e0.append(float(estimate(p, k, ceil0(ver), ver)["est"]))
			K.expose(k, "body", 16.0, "test")
			e1.append(float(estimate(p, k, ceil0(ver), ver)["est"]))
		var r_clock := _r2(dd, m)
		var r0 := _r2(e0, m)
		var r1 := _r2(e1, m)
		var gain := r1 - r0
		var r0c := _r2two(e0, dd, m)
		print("  the clock beside the first look adds %.3f (first look + clock %.3f)" % [r0c - r0, r0c])
		print("--- %s: how much of the truth each read explains (R2) --- clock %.3f, first look %.3f, after test day %.3f (test day adds %.3f)"
			% [ver, r_clock, r0, r1, gain])
		if ver == "v8":
			print("  B4 (the clock adds less beside the first look than the test day adds): %s" % ["PASS" if r0c - r0 < gain else "FAIL"])


static func _mean(a: Array) -> float:
	var s := 0.0
	for x in a:
		s += float(x)
	return s / maxf(1.0, float(a.size()))


## Paired difference a - b: mean and a normal 95% interval over the decisions.
static func _diff(a: Array, b: Array) -> Array:
	var nn := a.size()
	var s := 0.0
	var s2 := 0.0
	for i in nn:
		var d: float = float(a[i]) - float(b[i])
		s += d
		s2 += d * d
	var mu := s / float(nn)
	var sd := sqrt(maxf(0.0, s2 / float(nn) - mu * mu))
	var half := 1.96 * sd / sqrt(float(nn))
	return [mu, mu - half, mu + half]


static func _r2(x: Array, y: Array) -> float:
	var mx := _mean(x)
	var my := _mean(y)
	var sxy := 0.0
	var sxx := 0.0
	var syy := 0.0
	for i in x.size():
		var dx: float = float(x[i]) - mx
		var dy: float = float(y[i]) - my
		sxy += dx * dy
		sxx += dx * dx
		syy += dy * dy
	if sxx <= 0.0 or syy <= 0.0:
		return 0.0
	return sxy * sxy / (sxx * syy)


## R2 of y on two regressors (ordinary least squares).
static func _r2two(x1: Array, x2: Array, y: Array) -> float:
	var m1 := _mean(x1)
	var m2 := _mean(x2)
	var my := _mean(y)
	var s11 := 0.0
	var s22 := 0.0
	var s12 := 0.0
	var s1y := 0.0
	var s2y := 0.0
	var syy := 0.0
	for i in y.size():
		var a: float = float(x1[i]) - m1
		var b: float = float(x2[i]) - m2
		var c: float = float(y[i]) - my
		s11 += a * a; s22 += b * b; s12 += a * b; s1y += a * c; s2y += b * c; syy += c * c
	var det := s11 * s22 - s12 * s12
	if absf(det) < 1e-9 or syy <= 0.0:
		return 0.0
	var b1 := (s22 * s1y - s12 * s2y) / det
	var b2 := (s11 * s2y - s12 * s1y) / det
	return (b1 * s1y + b2 * s2y) / syy
