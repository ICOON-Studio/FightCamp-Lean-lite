extends SceneTree
## KNOWSTAKES9 (S541): greybox of the prospect decision under the v9 rules. DESIGN_KNOW_STAKES1_V9.md section 5.
## Based on tools/knowstakes8.gd: the SAME people (seeds 54000.., same truths and v8 dice), merit, bond and second name; the
## v8 arm lives there (this file's first run replayed it: docs/KNOWSTAKES9_RESULT.md run 0).
## Widths, offsets and reads come from scripts/rules/Knowledge.gd itself (fresh / expose / hard_spar / range_of / _offset);
## everything else is an ESTIMATE of this greybox. Every call on one prospect uses that prospect's own dice (rday_u, sat,
## bout_day are drawn once per person): the calls share the dice.
## v9 knobs (args, each with its map default): smult= first-look width x (a scout saw them once), maybe= scout filter,
## wb= ws= open-session exposure a week waited, tb= ts= trial exposure over 7 days, pad= ceiling share left after the pad
## test, stop= points clear of the level at which a trial is ended early, bout=0|1 (every scouted name boxes inside 4-18
## days), daily=0|1 (0 = the whole week or nothing), ivw=0|1 (weigh your look and the rival's by how narrow each is; 0 =
## the v8 probe's plain average), pool=maybes|all, tcd= trial dollars a day, sel= how close to the level the selective
## player still buys a read, match=0|1 (the rival's offer can be matched at +$50 a week), noclock=1 (control).
## Args: n=<prospects> ; last line: KNOWSTAKES9 done.

const K := preload("res://scripts/rules/Knowledge.gd")

const LEVEL := 60.0
const STIPEND := 250.0
const CUT_WEEK := 8
const BOND_WEEKS := 12
const CEIL_HW := 14.0
const WINDOW := 7
const FIRE_REC := 65.8
const FIRE_NOREC := 57.1
const MATCH_COST := 600.0    # matching the rival's offer: +$50 a week over the 12 bound weeks
const BOUT_HW := 11.5        # watching a bout opens under fire rough (v7: about 23 wide)
const DENSE := 250.0         # Kalli's measure: best call beats worst by more than one week's stipend
const VALUES: Array = [3000.0, 5000.0, 8000.0]
const CALLS: Array = ["hunch", "look", "wait"]
const ARMS: Array = ["hunch", "look", "wait", "sign_cut", "clock_only", "buy_all", "selective", "truth"]

var n := 20000
var pool := "maybes"
var seed0 := 54000
var smult := 1.0; var maybe := 3.0; var stop := 2.0; var pad := 0.5
var wb := 8.0; var ws := 8.0; var tb := 24.0; var ts := 24.0
var bout := 1; var daily := 1; var ivw := 1; var match_on := 0; var noclock := 0
var tcd := 36.0; var sel := 1.2

func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		var i := s.find("=")
		if i < 0:
			continue
		var key := s.substr(0, i)
		var val := s.substr(i + 1)
		if key in ["n", "bout", "daily", "ivw", "match", "noclock"]:
			set("match_on" if key == "match" else key, int(val))
		elif key == "pool":
			pool = val
		else:
			set(key, float(val))
	print("=== KNOWSTAKES9 PROBE: %d prospects (seeds %d..), level %.0f, V %s ===" % [n, seed0, LEVEL, str(VALUES)])
	print("knobs: pool=%s smult=%.2f maybe=%.1f wb=%.0f ws=%.0f tb=%.0f ts=%.0f pad=%.2f stop=%.1f bout=%d daily=%d ivw=%d tcd=%.0f sel=%.1f match=%d noclock=%d"
		% [pool, smult, maybe, wb, ws, tb, ts, pad, stop, bout, daily, ivw, tcd, sel, match_on, noclock])
	print("BARS (fixed before any run): B1 each of hunch/look/wait best in 15-60%% of decisive decisions; B2 selective beats")
	print("  every arm but truth, 95%% low end > 0; B3 selective's reads flip the first-look call 25-60%%; B4 the clock adds less")
	print("  R2 beside the first look than the test day; B5 (new, Kalli + Dola) in >= 40%% of ALL prospects the best of the three")
	print("  calls beats the worst by more than $%.0f, and in >= 30%% it beats the second by $%.0f or more. CONTROL: noclock=1" % [DENSE, DENSE])
	print("  (the rival never decides) must leave the hunch best in under 15%% of decisive decisions.")
	var people: Array = []
	var sd := seed0
	while people.size() < n:
		var p := _person(sd)
		sd += 1
		if pool == "maybes":
			var e := estimate(p, K.fresh(int(p["seed"])), CEIL_HW, "v9")
			if absf(float(e["est"]) - LEVEL) > maybe:
				continue
		people.append(p)
	print("population: %s, %d prospects kept of %d drawn" % [pool, people.size(), sd - seed0])
	for v in VALUES:
		_run(people, "v9", float(v))
	_clock_r2(people)
	print("KNOWSTAKES9 done")
	quit(0)

func _person(sd: int) -> Dictionary:
	var r := RandomNumberGenerator.new()
	r.seed = sd
	var p := _truths(r, sd)
	p["loss_u"] = r.randf(); p["rday_u"] = r.randf()
	p["a2"] = r.randi_range(7, 42); p["fc_noise"] = r.randi_range(-7, 7)
	p["n2"] = _truths(r, sd + 500000)
	# v9 dice, drawn after everything v8 drew so the v8 people stay the same people
	var r9 := RandomNumberGenerator.new()
	r9.seed = sd + 900000
	p["bout_day"] = r9.randi_range(4, 18)
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

func _sm(ver: String) -> float:
	return smult if ver == "v9" else 1.0

## One look at one group: centre and half-width, the first look widened by smult in v9.
func _look(k: Dictionary, attr: String, truth: float, ver: String) -> Array:
	var r: Dictionary = K.range_of(k, attr, truth)
	var m := _sm(ver)
	return [truth + (float(r["centre"]) - truth) * m, float(r["width"]) * m]

func rival_look(p: Dictionary, ver: String) -> Dictionary:
	var k := K.fresh(int(p["seed"]) + 7777)
	var lb := _look(k, "strength", float(p["b"]), ver)
	var ls := _look(k, "accuracy", float(p["s"]), ver)
	return {"b": lb[0], "s": ls[0], "wb": lb[1], "ws": ls[1]}

func rival_likes(p: Dictionary, ver: String) -> bool:
	var rl := rival_look(p, ver)
	return 0.5 * (float(rl["b"]) + float(rl["s"])) > LEVEL

## Last day of the rival's window (v8 was 21, -7 record, -7 rival likes, -0..6, floor 7).
## v9 (Kalli 3): only what the rival sees: 7 when they like the look, 14 when not, +0..6.
func clock(p: Dictionary, ver: String) -> int:
	if noclock == 1:
		return 999
	return (7 if rival_likes(p, ver) else 14) + int(p["crand"])

func rival_day(p: Dictionary, ver: String) -> int:
	var d := clock(p, ver)
	return maxi(1, d - int(floor(float(p.get("rday_u", 0.0)) * float(WINDOW))))

## What the player believes from the card: {est, u}. The rival's look is on the card in v8 and v9.
func estimate(p: Dictionary, k: Dictionary, ceil_hw: float, ver: String) -> Dictionary:
	var lb := _look(k, "strength", float(p["b"]), ver)
	var ls := _look(k, "accuracy", float(p["s"]), ver)
	var b: float = lb[0]
	var s: float = ls[0]
	var wf := 15.0
	var f := FIRE_REC if bool(p.get("rec", false)) else FIRE_NOREC
	if bool(k.get("under_fire_opened", false)):
		var rf: Dictionary = K.range_of(k, "durability", float(p["f"]))
		f = float(rf["centre"])
		wf = float(rf["width"])
	elif bool(k.get("bout_seen", false)):
		f = float(p["f"]) + K._offset(k, "durability") * BOUT_HW
		wf = BOUT_HW
	var rl := rival_look(p, ver)
	if ivw == 1 and ver == "v9":
		var a := 1.0 / (float(lb[1]) * float(lb[1]))
		var c2 := 1.0 / (float(rl["wb"]) * float(rl["wb"]))
		b = (a * b + c2 * float(rl["b"])) / (a + c2)
		a = 1.0 / (float(ls[1]) * float(ls[1]))
		c2 = 1.0 / (float(rl["ws"]) * float(rl["ws"]))
		s = (a * s + c2 * float(rl["s"])) / (a + c2)
	else:
		b = 0.5 * (b + float(rl["b"]))
		s = 0.5 * (s + float(rl["s"]))
	var c: float = float(p["c"]) + K._offset(k, "ceiling") * ceil_hw
	var est := 0.6 * (0.4 * b + 0.4 * s + 0.2 * f) + 0.4 * (c - 12.0)
	var u := 0.24 * float(lb[1]) + 0.24 * float(ls[1]) + 0.12 * wf + 0.4 * ceil_hw
	return {"est": est, "u": u}

static func sign_out(p: Dictionary, v: float) -> Dictionary:
	if merit(p) >= LEVEL:
		return {"val": v, "free": -1}
	return {"val": -STIPEND * float(BOND_WEEKS), "free": CUT_WEEK * 7}

func second(p: Dictionary, free_from: int, t0: int, v: float, ver: String) -> float:
	if free_from < 0:
		return 0.0
	var q: Dictionary = p["n2"]
	if t0 + free_from > int(p["a2"]) + clock(q, ver):
		return 0.0
	var e := estimate(q, K.fresh(int(q["seed"])), CEIL_HW, ver)
	if float(e["est"]) < LEVEL:
		return 0.0
	return float(sign_out(q, v)["val"])

func _new_out(first: bool) -> Dictionary:
	return {"val": 0.0, "cost": 0.0, "lost": false, "signed": false, "flip": false, "first": first, "read": false, "days": 0, "matched": false}

## The rival's day came first. match=1: their offer can be matched that day (+$50 a week) on the read so far.
func _lost(p: Dictionary, st: Dictionary, out: Dictionary, v: float) -> Dictionary:
	var t: int = int(st["t"])
	if match_on == 1 and float(estimate(p, st["k"], float(st["ch"]), "v9")["est"]) >= LEVEL:
		out["cost"] = float(out["cost"]) + MATCH_COST + tcd * float(out["days"])
		out["matched"] = true
		return _finish(p, out, true, t, v, "v9")
	out["lost"] = true
	out["val"] = second(p, 0, t, v, "v9") - float(out["cost"])
	return out

func _finish(p: Dictionary, out: Dictionary, go: bool, t: int, v: float, ver: String) -> Dictionary:
	var val := -float(out["cost"])
	if go:
		var so := sign_out(p, v)
		val += float(so["val"]) + second(p, int(so["free"]), t, v, ver)
		out["signed"] = true
	else:
		val += second(p, 0, t, v, ver)
	out["flip"] = go != bool(out["first"])
	out["val"] = val
	return out

## v9 trial, a day at a time, each day its own question: day 1 the fitness test (body 16, the code's test day), days 2-4
## pads (skills), day 5 the pad test (ceiling), day 6 conditioning (the rest of the body read), day 7 the hard spar.
## st = {k, ch, t}. Returns "lost" / "ok". The days used are charged when it ends without the rival's day coming first.
func _trial9(p: Dictionary, st: Dictionary, out: Dictionary, max_days: int, rday: int, open: int, avoid: bool) -> String:
	var k: Dictionary = st["k"]
	for i in max_days:
		var day: int = i + 1
		st["t"] = int(st["t"]) + 1
		if rday <= int(st["t"]):
			return "lost"
		out["days"] = day
		if day == 1:
			K.expose(k, "body", 16.0, "test")
		elif day <= 4:
			K.expose(k, "skills", ts / 3.0, "session")
		elif day == 5:
			st["ch"] = float(st["ch"]) * pad
		elif day == 6:
			K.expose(k, "body", tb - 16.0, "session")
		else:
			K.hard_spar(k, false)
		if daily == 0:
			continue
		var e := estimate(p, k, float(st["ch"]), "v9")
		if absf(float(e["est"]) - LEVEL) >= stop:
			break
		if avoid and int(st["t"]) + 1 >= open:
			break
	out["cost"] = float(out["cost"]) + tcd * float(out["days"])
	out["read"] = true
	return "ok"

func _wait9(p: Dictionary, st: Dictionary, target: int) -> void:
	var k: Dictionary = st["k"]
	var days: int = target - int(st["t"])
	K.expose(k, "body", wb * float(days) / 7.0, "session")
	K.expose(k, "skills", ws * float(days) / 7.0, "session")
	if bout == 1 and int(p["bout_day"]) <= target and int(p["bout_day"]) > int(st["t"]):
		k["bout_seen"] = true
	st["t"] = target

func _play9(p: Dictionary, call: String, v: float) -> Dictionary:
	var ver := "v9"
	var d := clock(p, ver)
	var open: int = maxi(1, d - WINDOW + 1)      # the first day the rival may sign
	var rday := rival_day(p, ver)
	var st := {"k": K.fresh(int(p["seed"])), "ch": CEIL_HW, "t": 0}
	var e0 := estimate(p, st["k"], CEIL_HW, ver)
	var first: bool = float(e0["est"]) >= LEVEL
	var out := _new_out(first)
	var bd: int = int(p["bout_day"])
	var has_bout: bool = bout == 1 and bd <= d
	match call:
		"hunch":
			return _finish(p, out, first, 0, v, ver)
		"sign_cut":
			return _finish(p, out, true, 0, v, ver)
		"truth":
			return _finish(p, out, merit(p) >= LEVEL, 0, v, ver)
		"clock_only":
			return _finish(p, out, rival_likes(p, ver), 0, v, ver)
		"look":
			if _trial9(p, st, out, 7, rday, open, open > 2) == "lost":
				return _lost(p, st, out, v)
		"buy_all":
			var keep := daily
			daily = 0
			var r := _trial9(p, st, out, 7, rday, open, false)
			daily = keep
			if r == "lost":
				return _lost(p, st, out, v)
		"wait":
			var target: int = bd if has_bout else mini(7, d)
			if rday <= target:
				_wait9(p, st, rday - 1)
				st["t"] = rday
				return _lost(p, st, out, v)
			_wait9(p, st, target)
			if int(p["a2"]) <= target:
				var q: Dictionary = p["n2"]
				var eq := estimate(q, K.fresh(int(q["seed"])), CEIL_HW, ver)
				var ew := estimate(p, st["k"], float(st["ch"]), ver)
				if float(eq["est"]) > float(ew["est"]) and float(eq["est"]) >= LEVEL:
					out["signed"] = true
					out["val"] = float(sign_out(q, v)["val"])
					return out
		"selective":   # reads the card: the hunch when it sits clear, else the trial by the day, then the bout if it is safe
			if absf(float(e0["est"]) - LEVEL) < sel:
				if _trial9(p, st, out, 7, rday, open, open > 2) == "lost":
					return _lost(p, st, out, v)
				var e1 := estimate(p, st["k"], float(st["ch"]), ver)
				if absf(float(e1["est"]) - LEVEL) < stop and has_bout and bd > int(st["t"]) and bd < open:
					_wait9(p, st, bd)
	var e9 := estimate(p, st["k"], float(st["ch"]), ver)
	return _finish(p, out, float(e9["est"]) >= LEVEL, int(st["t"]), v, ver)

func _run(people: Array, ver: String, v: float) -> void:
	var vals := {}
	for a in ARMS:
		vals[a] = []
	var best := {"hunch": 0, "look": 0, "wait": 0, "tie": 0}
	var flips := 0; var reads := 0; var sel_lost := 0; var all_lost := 0
	var dense := 0; var dense2 := 0; var wrong := 0; var tdays := 0; var trials := 0
	var gone := {"look": 0, "wait": 0}; var matched := {"look": 0, "wait": 0}; var lflip := 0
	for p in people:
		var res := {}
		for a in ARMS:
			res[a] = _play9(p, str(a), v)
			(vals[a] as Array).append(float(res[a]["val"]))
		var xs: Array = []
		for c in CALLS:
			xs.append(float(res[c]["val"]))
		var srt: Array = xs.duplicate(); srt.sort()
		if float(srt[2]) - float(srt[0]) > DENSE:
			dense += 1
		if float(srt[2]) - float(srt[1]) >= DENSE:
			dense2 += 1
		if float(srt[2]) - float(srt[1]) > 0.01:
			best[CALLS[xs.find(srt[2])]] += 1
		else:
			best["tie"] += 1
		if bool(res["hunch"]["first"]) != (merit(p) >= LEVEL):
			wrong += 1
		for c in ["look", "wait"]:
			gone[c] += int(bool(res[c]["lost"])); matched[c] += int(bool(res[c]["matched"]))
		lflip += int(bool(res["look"]["flip"]) and not bool(res["look"]["lost"]))
		if int(res["look"]["days"]) > 0:
			trials += 1
			tdays += int(res["look"]["days"])
		if bool(res["selective"]["read"]) and not bool(res["selective"]["lost"]):
			reads += 1
			if bool(res["selective"]["flip"]):
				flips += 1
		if bool(res["selective"]["lost"]):
			sel_lost += 1
		if bool(res["buy_all"]["lost"]):
			all_lost += 1
	var nn := float(people.size())
	var decisive: int = int(best["hunch"]) + int(best["look"]) + int(best["wait"])
	print("--- %s, V $%.0f: %d prospects, %d decisive (%.1f%%), first look wrong %.1f%% ---"
		% [ver, v, people.size(), decisive, 100.0 * decisive / nn, 100.0 * wrong / nn])
	var shares := []
	for c in CALLS:
		var sh := 100.0 * float(best[c]) / maxf(1.0, float(decisive))
		shares.append(sh)
		print("  best per decision: %-6s %5.1f%%" % [c, sh])
	var d1 := 100.0 * dense / nn
	var d2 := 100.0 * dense2 / nn
	print("  B5 density: best beats worst by > $%.0f in %.1f%% of all prospects; best beats second by >= $%.0f in %.1f%%" % [DENSE, d1, DENSE, d2])
	print("  look's trial: mean %.1f days over %d trials, flips the first look in %.1f%%; rival's day first: look gone %.1f%% matched %.1f%%, wait gone %.1f%% matched %.1f%%"
		% [float(tdays) / maxf(1.0, float(trials)), trials, 100.0 * lflip / nn, 100.0 * gone["look"] / nn, 100.0 * matched["look"] / nn,
		100.0 * gone["wait"] / nn, 100.0 * matched["wait"] / nn])
	var sel: Array = vals["selective"]
	var b2 := true
	for a in ARMS:
		var dif := _diff(sel, vals[a])
		print("  arm %-10s mean $%7.0f   selective minus it $%6.0f (95%%: %6.0f .. %6.0f)" % [a, _mean(vals[a]), dif[0], dif[1], dif[2]])
		if a != "selective" and a != "truth" and dif[1] <= 0.0:
			b2 = false
	var flip := 100.0 * float(flips) / maxf(1.0, float(reads))
	print("  selective's reads flip the first-look call: %.1f%% of %d completed reads; lost to the rival: selective %.1f%%, buy-all %.1f%%"
		% [flip, reads, 100.0 * sel_lost / nn, 100.0 * all_lost / nn])
	var b1 := true
	for sh in shares:
		if float(sh) < 15.0 or float(sh) > 60.0:
			b1 = false
	if noclock == 1:
		print("  CONTROL (no clock: hunch best < 15%%): %s" % ["PASS" if float(shares[0]) < 15.0 else "FAIL"])
	print("  B1 %s  B2 %s  B3 %s  B5 %s" % ["PASS" if b1 else "FAIL", "PASS" if b2 else "FAIL",
		"PASS" if flip >= 25.0 and flip <= 60.0 else "FAIL", "PASS" if d1 >= 40.0 and d2 >= 30.0 else "FAIL"])

func _clock_r2(people: Array) -> void:
	for ver in ["v9"]:
		var m: Array = []; var dd: Array = []; var e0: Array = []; var e1: Array = []
		for p in people:
			m.append(merit(p))
			dd.append(float(clock(p, ver)))
			var k := K.fresh(int(p["seed"]))
			e0.append(float(estimate(p, k, CEIL_HW, ver)["est"]))
			K.expose(k, "body", 16.0, "test")
			e1.append(float(estimate(p, k, CEIL_HW, ver)["est"]))
		var r0 := _r2(e0, m)
		var gain := _r2(e1, m) - r0
		var add := _r2two(e0, dd, m) - r0
		print("--- %s R2 of the truth: clock alone %.3f, first look %.3f, the clock beside it adds %.3f, the test day adds %.3f: B4 %s"
			% [ver, _r2(dd, m), r0, add, gain, "PASS" if add < gain else "FAIL"])

static func _mean(a: Array) -> float:
	var s := 0.0
	for x in a:
		s += float(x)
	return s / maxf(1.0, float(a.size()))

static func _diff(a: Array, b: Array) -> Array:
	var nn := a.size(); var s := 0.0; var s2 := 0.0
	for i in nn:
		var d: float = float(a[i]) - float(b[i])
		s += d
		s2 += d * d
	var mu := s / float(nn)
	var half := 1.96 * sqrt(maxf(0.0, s2 / float(nn) - mu * mu)) / sqrt(float(nn))
	return [mu, mu - half, mu + half]

## Sum of products of deviations.
static func _sp(x: Array, y: Array) -> float:
	var mx := _mean(x)
	var my := _mean(y)
	var t := 0.0
	for i in x.size():
		t += (float(x[i]) - mx) * (float(y[i]) - my)
	return t

static func _r2(x: Array, y: Array) -> float:
	var sxx := _sp(x, x)
	var syy := _sp(y, y)
	if sxx <= 0.0 or syy <= 0.0:
		return 0.0
	return pow(_sp(x, y), 2.0) / (sxx * syy)

## R2 of y on two regressors (ordinary least squares).
static func _r2two(x1: Array, x2: Array, y: Array) -> float:
	var s11 := _sp(x1, x1); var s22 := _sp(x2, x2); var s12 := _sp(x1, x2)
	var s1y := _sp(x1, y); var s2y := _sp(x2, y); var syy := _sp(y, y)
	var det := s11 * s22 - s12 * s12
	if absf(det) < 1e-9 or syy <= 0.0:
		return 0.0
	return ((s22 * s1y - s12 * s2y) / det * s1y + (s11 * s2y - s12 * s1y) / det * s2y) / syy
