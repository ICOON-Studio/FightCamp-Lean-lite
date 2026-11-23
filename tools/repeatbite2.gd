extends SceneTree
## S539 REPEATBITE2 greybox (TASK_REPEATBITE2; owner Q-S294-306 "Yes, make it bite"; rule S534: probe FIRST). Nothing under
## scripts/ is changed. Same population, bouts, dice and bars as tools/repeatbite1.gd (REPEATBITE1): 60 boxers x 6 styles x 3
## nights, plans SPAM / WEAPON / SPREAD, each bout played ONCE per plan, the variants laid over the same recorded exchanges.
## Base P2 (REPEATBITE1's diagnostic): only the plan's own lines count, the count carries and fades 1 a bell, night k's
## opponent filmed night k-1 and starts with that bout's top line half-read, read at 2 (one sooner v rating 65+).
## Variants: P2 (control, must reproduce REPEATBITE1's 34 / 17), P2+R1 (count per move AND situation), P2+R2 (only won uses
## count), P2+R1R2 (both). Rules: tools/repeatbite2_rules.gd. The film: P2 keeps REPEATBITE1's top (most-thrown move, every
## throw); the R variants film the last bout's most-COUNTED read key under their own rule.
## Bars, fixed before the run, unchanged from REPEATBITE1: (a) SPAM loses 5+ in 100 v the counter-puncher and 2+ overall;
## (b) WEAPON (ON) beats SPREAD (ON) against at least two styles; (c) every (a) effect > 2 standard errors; (d) the read fires
## in 25-60 bouts of 100 for SPAM and under 15 for SPREAD; (e) no one plan shape is the best (ON) against all six styles.
## Usage: godot --headless --script res://tools/repeatbite2.gd -- [nights=3] [boxers=60] [out=...md]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Probe1 := preload("res://tools/repeatread_probe.gd")
const R := preload("res://tools/repeatbite1_rules.gd")
const R2 := preload("res://tools/repeatbite2_rules.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")

const ARMS := ["SPAM", "WEAPON", "SPREAD"]
const VARIANTS := [["P2", false, false], ["P2+R1", true, false], ["P2+R2", false, true], ["P2+R1R2", true, true]]   # [name, r1 same situation, r2 won uses]

var _out: PackedStringArray = []


func _initialize() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2:
			args[kv[0]] = kv[1]
	var nights := int(args.get("nights", "3"))
	var n_box := int(args.get("boxers", "60"))
	var opps: Array = Probe1._opponents()
	var boxers: Array = []
	for i in n_box:
		boxers.append(Probe1._boxer(i))
	var rec := {}   # arm -> Array of bouts {style, rating, rounds:[[{arrow, margin, won, landed}]], stopped, real_win, top, key}
	for arm in ARMS:
		var list: Array = []
		for opp in opps:
			for bi in boxers.size():
				for night in nights:
					list.append(_play(boxers[bi], opp, str(arm), 40 + bi * 7 + night * 131, night))
		rec[arm] = list
		print("REPEATBITE2 played %s %d bouts" % [arm, list.size()])
	_say("## REPEATBITE2 - the plan-line counter refined (greybox, S539)")
	_say("")
	_say("Rule copy tools/repeatbite1_rules.gd: counter chance %.2f a throw into a read (counter-puncher x%.2f), ring-smart opponent (rating %.0f+) reads one throw sooner, a counter = the exchange lost (margin -%.0f or lower). %d boxers x %d opponents x %d nights = %d bouts a plan, played once, every variant on the same bouts." % [
		R.CHANCE, R.COUNTER_STYLE, R.IQ_AT, R.COUNTER_MARGIN, n_box, opps.size(), nights, n_box * opps.size() * nights])
	var verdicts: PackedStringArray = []
	for v in VARIANTS:
		verdicts.append("%s %s" % [v[0], _variant(v, rec, opps)])
	_say("")
	_say("## Verdicts")
	_say("")
	for line in verdicts:
		_say("- " + line)
	var path := str(args.get("out", "E:/FightCamp/tmp/repeatbite2/REPEATBITE2_TABLES.md"))
	var fa := FileAccess.open(path if path.contains(":") else "res://" + path, FileAccess.WRITE)
	fa.store_string("\n".join(_out) + "\n")
	fa.close()
	print("REPEATBITE2_PROBE done -> %s" % path)
	quit(0)


func _say(line: String) -> void:
	_out.append(line)
	print(line)


func _play(sheet: Dictionary, opp_row: Dictionary, arm: String, day: int, night: int) -> Dictionary:
	var c := Career.quick_start()
	c.seed = 538
	c.fighters.append(Data.fighter_state(sheet.duplicate(true), c.day))
	c.day = day
	c.coach = {}
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	var combos := {}
	for mv in SM.MOVES:
		if str(mv.get("kind", "")) == "combo":
			combos[str(mv["combo"])] = float(sheet["drill"])
	f["combos"] = combos
	for k in (f.get("steps", {}) as Dictionary):
		f["steps"][k] = float(sheet["drill"])
	var opp: Dictionary = opp_row.duplicate(true)
	f["arrows"] = Probe1._plan(arm, f, opp)
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	var rounds: Array = []
	var count := {}
	for r in m["rounds"]:
		var exs: Array = []
		for x in r["exchanges"]:
			exs.append({"arrow": str(x.get("arrow", "")), "sit": str(x.get("sit", "")), "planned": bool(x.get("planned", false)), "margin": float(x["margin"]), "won": bool(x["won"]), "landed": x["landed"]})
			count[str(x.get("arrow", ""))] = int(count.get(str(x.get("arrow", "")), 0)) + 1
		rounds.append(exs)
	var top := ""
	for k in count:
		if k != "" and (top == "" or int(count[k]) > int(count[top])):
			top = k
	return {"style": str(opp["style"]), "rating": float(opp.get("rating", 60.0)), "rounds": rounds, "night": night,
		"stopped": BoutNight.stopped(m) != "", "real_win": str(m.get("outcome", "")) == "win", "top": top,
		"key": "%s|%s|%d" % [sheet["id"], opp["name"], day]}


## One bout under one variant: {off, on, fired, counters}.
static func _apply(b: Dictionary, r1: bool, r2: bool, last_top: String) -> Dictionary:
	var n_at := R.read_at(2, float(b["rating"]))
	var ch := R.chance(str(b["style"]))
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%s|bite" % b["key"])
	var counts: Dictionary = R.film_start(last_top, n_at)
	var tally := {}   # read key -> counted uses this bout (the next night's film under R1/R2)
	var off_r := 0
	var on_r := 0
	var fired := 0
	var countered := 0
	for exs in b["rounds"]:
		var on_exs: Array = []
		for x in exs:
			var roll := rng.randf()
			var k := R2.key(str(x["arrow"]), str(x["sit"]), r1) if bool(x["planned"]) else ""
			var e: Dictionary = x
			if k != "":
				if R.is_read(int(counts.get(k, 0)), n_at):
					fired += 1
					if roll < ch:
						countered += 1
						e = R.countered(x)
				if R2.counts_toward(bool(x["won"]), r2):
					counts[k] = int(counts.get(k, 0)) + 1
					tally[k] = int(tally.get(k, 0)) + 1
			on_exs.append(e)
		off_r += int(bool(Exchanges.round_of(exs)["won"]))
		on_r += int(bool(Exchanges.round_of(on_exs)["won"]))
		counts = R.bell(counts, true)
	var top := ""
	for k2 in tally:
		if top == "" or int(tally[k2]) > int(tally[top]):
			top = k2
	var nr: int = (b["rounds"] as Array).size()
	var off := float(b["real_win"]) if bool(b["stopped"]) else float(off_r * 2 > nr)
	var on := float(b["real_win"]) if bool(b["stopped"]) else float(on_r * 2 > nr)
	return {"off": off, "on": on, "fired": fired, "countered": countered, "top": top}


static func _stats() -> Dictionary:
	return {"n": 0.0, "off": 0.0, "on": 0.0, "d": 0.0, "d2": 0.0, "fired_bouts": 0.0, "fired": 0.0, "countered": 0.0}


static func _add(st: Dictionary, r: Dictionary) -> void:
	var dd: float = float(r["on"]) - float(r["off"])
	st["n"] += 1.0
	st["off"] += float(r["off"])
	st["on"] += float(r["on"])
	st["d"] += dd
	st["d2"] += dd * dd
	st["fired_bouts"] += 1.0 if int(r["fired"]) > 0 else 0.0
	st["fired"] += float(r["fired"])
	st["countered"] += float(r["countered"])


static func _delta(st: Dictionary) -> float:
	return 100.0 * st["d"] / maxf(1.0, st["n"])


static func _err(st: Dictionary) -> float:
	var n := maxf(2.0, st["n"])
	var mean: float = st["d"] / n
	return 100.0 * sqrt(maxf(0.0, st["d2"] / n - mean * mean) / n)


static func _pct(st: Dictionary, k: String) -> float:
	return 100.0 * st[k] / maxf(1.0, st["n"])


func _variant(v: Array, rec: Dictionary, opps: Array) -> String:
	var name := str(v[0])
	var cell := {}
	for arm in ARMS:
		var tops := {}   # key without the day's night -> last bout's top move (the film)
		var all := _stats()
		for b in rec[arm]:
			var fk := "%s|%s|%s" % [arm, b["style"], str(b["key"]).get_slice("|", 0)]
			var r := _apply(b, bool(v[1]), bool(v[2]), str(tops.get(fk, "")) if int(b["night"]) > 0 else "")
			tops[fk] = str(b["top"]) if not (bool(v[1]) or bool(v[2])) else str(r["top"])
			var ck := "%s|%s" % [arm, b["style"]]
			if not cell.has(ck):
				cell[ck] = _stats()
			_add(cell[ck], r)
			_add(all, r)
		cell["%s|ALL" % arm] = all
	_say("")
	_say("### %s - P2%s%s" % [name, " + R1 (count per move and situation)" if bool(v[1]) else "", " + R2 (only won uses count)" if bool(v[2]) else ""])
	_say("")
	_say("| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |")
	_say("|---|---|---|---|---|---|---|---|---|---|")
	for arm in ARMS:
		for opp in opps:
			_row(str(arm), str(opp["style"]), cell["%s|%s" % [arm, opp["style"]]])
		_row(str(arm), "ALL SIX", cell["%s|ALL" % arm])
	var cp: Dictionary = cell["SPAM|Counter-puncher"]
	var all_s: Dictionary = cell["SPAM|ALL"]
	var a_ok := _delta(cp) <= -5.0 and _delta(all_s) <= -2.0
	var where: PackedStringArray = []
	var best_arm := {}
	for opp in opps:
		var sty := str(opp["style"])
		var gap := _pct(cell["WEAPON|" + sty], "on") - _pct(cell["SPREAD|" + sty], "on")
		if gap > 0.0:
			where.append("%s %+.1f" % [sty, gap])
		var ba := ""
		for arm in ARMS:
			if ba == "" or _pct(cell["%s|%s" % [arm, sty]], "on") > _pct(cell["%s|%s" % [ba, sty]], "on"):
				ba = str(arm)
		best_arm[sty] = ba
	var b_ok := where.size() >= 2
	var c_ok := absf(_delta(cp)) > 2.0 * _err(cp) and absf(_delta(all_s)) > 2.0 * _err(all_s)
	var spam_f := _pct(all_s, "fired_bouts")
	var spread_f := _pct(cell["SPREAD|ALL"], "fired_bouts")
	var d_ok := spam_f >= 25.0 and spam_f <= 60.0 and spread_f < 15.0
	var shapes := {}
	for sty in best_arm:
		shapes[best_arm[sty]] = true
	var e_ok := shapes.size() > 1
	_say("")
	_say("- (a) SPAM v the counter-puncher %+.1f, overall %+.1f -> %s" % [_delta(cp), _delta(all_s), "PASS" if a_ok else "FAIL"])
	_say("- (b) WEAPON beats SPREAD (ON) against: %s -> %s" % [", ".join(where) if not where.is_empty() else "none", "PASS" if b_ok else "FAIL"])
	_say("- (c) effects v 2 errors: counter-puncher %.1f v %.1f, overall %.1f v %.1f -> %s" % [absf(_delta(cp)), 2.0 * _err(cp), absf(_delta(all_s)), 2.0 * _err(all_s), "PASS" if c_ok else "FAIL"])
	_say("- (d) the read fires in %.0f bouts of 100 for SPAM (25-60), %.0f for SPREAD (under 15) -> %s" % [spam_f, spread_f, "PASS" if d_ok else "FAIL"])
	_say("- (e) the best plan (ON) by style: %s -> %s" % [str(best_arm), "PASS" if e_ok else "FAIL"])
	var ok := a_ok and b_ok and c_ok and d_ok and e_ok
	_say("")
	_say("%s VERDICT: %s" % [name, "PASS" if ok else "FAIL"])
	return "PASS" if ok else "FAIL (a %s, b %s, c %s, d %s, e %s)" % [a_ok, b_ok, c_ok, d_ok, e_ok]


func _row(arm: String, style: String, st: Dictionary) -> void:
	var n := maxf(1.0, st["n"])
	_say("| %s | %s | %d | %.1f%% | %.1f%% | %+.1f | %.1f | %.0f | %.2f | %.2f |" % [arm, style, int(n), _pct(st, "off"), _pct(st, "on"),
		_delta(st), 2.0 * _err(st), _pct(st, "fired_bouts"), st["fired"] / n, st["countered"] / n])
