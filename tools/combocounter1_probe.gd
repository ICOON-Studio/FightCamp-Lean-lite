extends SceneTree
## S540 COMBOCOUNTER1: the combo counter's A/B ON THE WIRED GAME (scripts/rules/ComboCounter.gd in state/LiveRound.gd).
## The greybox (tools/repeatbite1.gd, docs/REPEATBITE1_RESULT.md P2) laid the counter over recorded exchanges and scored a
## bout by its rounds; here every bout is PLAYED twice through the game's own Bouts.fight_step "sim", ComboCounter.on false
## (OFF, the game before) and true (ON), and scored by its real outcome - so a counter now also moves what came after it
## (energy, damage, reads, knockdowns), which the greybox could not see.
## Population: REPEATBITE1's (tools/repeatread_probe.gd: 60 boxers from Data.lucy, own stats +-7, style, drilled
## combinations 35-85, seeded) x the first opponent of each of six styles x NIGHTS nights; plans SPAM / WEAPON / SPREAD.
## THE FILM: night k (ON) carries the boxer's cc_film from night k-1 against the same opponent with the same plan.
## Bars (REPEATBITE1's, unchanged): (a) SPAM loses 5+ in 100 v the counter-puncher and 2+ overall; (b) WEAPON (ON) beats
## SPREAD (ON) v at least two styles; (c) each (a) effect > 2 standard errors; (d) the read fires in 25-60 bouts of 100
## for SPAM, under 15 for SPREAD; (e) no one plan shape is the best (ON) v all six styles.
## Usage: godot --headless --script res://tools/combocounter1_probe.gd -- [nights=3] [boxers=60] [out=docs/COMBOCOUNTER1_RESULT.md]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Probe1 := preload("res://tools/repeatread_probe.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const ComboCounter := preload("res://scripts/rules/ComboCounter.gd")

const ARMS := ["SPAM", "WEAPON", "SPREAD"]

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
	var cell := {}
	for arm in ARMS:
		var all := _stats()
		for opp in opps:
			var st := _stats()
			for bi in boxers.size():
				var film := ""
				for night in nights:
					var day := 40 + bi * 7 + night * 131
					ComboCounter.on = false
					var off := _play(boxers[bi], opp, str(arm), day, "")
					ComboCounter.on = true
					var on := _play(boxers[bi], opp, str(arm), day, film)
					film = str(on["film"])
					var r := {"off": off["win"], "on": on["win"], "fired": on["fired"], "countered": on["countered"]}
					_add(st, r)
					_add(all, r)
			cell["%s|%s" % [arm, opp["style"]]] = st
		cell["%s|ALL" % arm] = all
		print("COMBOCOUNTER1 played %s" % arm)
	_report(cell, opps, n_box, nights)
	var path := str(args.get("out", "docs/COMBOCOUNTER1_RESULT.md"))
	var fa := FileAccess.open("res://" + path, FileAccess.WRITE)
	fa.store_string("\n".join(_out) + "\n")
	fa.close()
	print("COMBOCOUNTER1_PROBE done -> %s" % path)
	quit(0)


func _say(line: String) -> void:
	_out.append(line)
	print(line)


func _play(sheet: Dictionary, opp_row: Dictionary, arm: String, day: int, film: String) -> Dictionary:
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
	f["cc_film"] = film
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	var fired := 0
	var countered := 0
	for r in m["rounds"]:
		for x in r["exchanges"]:
			var cc: Dictionary = x.get("cc", {})
			fired += 1 if bool(cc.get("fired", false)) else 0
			countered += 1 if bool(cc.get("countered", false)) else 0
	return {"win": 1.0 if str(m.get("outcome", "")) == "win" else 0.0, "fired": fired, "countered": countered, "film": str(f.get("cc_film", ""))}


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


func _report(cell: Dictionary, opps: Array, n_box: int, nights: int) -> void:
	_say("# COMBOCOUNTER1 - the combo counter on the wired game (S540)")
	_say("")
	_say("Rule: scripts/rules/ComboCounter.gd (READ_AT %d, ring-smart %.0f+ one sooner, CHANCE %.2f, counter-puncher x%.2f, margin -%.0f, fade %d a bell, film half-read). %d boxers x %d opponents x %d nights = %d bouts a plan, each played OFF and ON through Bouts.fight_step, scored by the real outcome." % [
		ComboCounter.READ_AT, ComboCounter.IQ_AT, ComboCounter.CHANCE, ComboCounter.COUNTER_STYLE, ComboCounter.COUNTER_MARGIN, ComboCounter.FADE, n_box, opps.size(), nights, n_box * opps.size() * nights])
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
	_say("")
	_say("WIRED VERDICT: %s" % ("PASS" if a_ok and b_ok and c_ok and d_ok and e_ok else "FAIL (a %s, b %s, c %s, d %s, e %s)" % [a_ok, b_ok, c_ok, d_ok, e_ok]))


func _row(arm: String, style: String, st: Dictionary) -> void:
	var n := maxf(1.0, st["n"])
	_say("| %s | %s | %d | %.1f%% | %.1f%% | %+.1f | %.1f | %.0f | %.2f | %.2f |" % [arm, style, int(n), _pct(st, "off"), _pct(st, "on"),
		_delta(st), 2.0 * _err(st), _pct(st, "fired_bouts"), st["fired"] / n, st["countered"] / n])
