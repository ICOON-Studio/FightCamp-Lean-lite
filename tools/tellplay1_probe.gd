extends SceneTree
## TELLPLAY1 (S543, ops/research/TASK_TELLPLAY1.md; design ops/research/DESIGN_TELLPLAY1.md). Measurement only: nothing under
## scripts/ changes; the two flagged rules are local copies in tools/tellplay1_rules.gd. Population: TURNPROBE18's ten types
## (5 women, 5 men, six styles, their pro-ready books, week 4) against 180 opponent files of their own sex and class
## (DebutOpp.make, 6 styles x 6 weapons x 5 weaknesses, the same-rated man). Two instruments:
##   THE READ - BoutRead's round edges + CardOdds (the 4-round debut card), rules A/B on and off, the same files.
##   THE REAL BOUT - BoutNight.play_out (Bouts.fight_step "start" + the auto corner's rounds through LiveRound, as
##   tests/bout_read_test.gd plays it), paired dice: bout k is career day 50000 + 7k under every arm.
## Stages (after --): stage=trial | read | bout_lines | bout_base; a=on|off b=off|chain|carry:<x> coach=<rating> n=<bouts>
## files=<per cell> types=<i,j> out=<jsonl>.
const R := preload("res://tools/tellplay1_rules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const STYLES := ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer", "Slugger"]
const WEAPONS := ["Never stops throwing", "Stops people", "Body hooks", "Heavy right hand", "Right hand over the jab", "Long jab"]
const WEAKS := ["Fades after round 2", "Leaves the chin open", "Walks in straight", "Slow to start", "Backs straight up"]
const SITS := ["press", "range", "counter", "loadup", "tiring"]
const CAMP := {"protocol": 2}
const WEEK := 4
var types: Array = []
var coach := 58.0
var out_path := ""
var t0 := 0
var reads := 0
var bouts := 0
var cache := {}


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).trim_prefix(key + "=")
	return def


func say(d: Dictionary) -> void:
	var s := JSON.stringify(d)
	if out_path != "":
		var fh := FileAccess.open(out_path, FileAccess.READ_WRITE if FileAccess.file_exists(out_path) else FileAccess.WRITE)
		if fh != null:
			fh.seek_end()
			fh.store_line(s)
			fh.close()
	print(s)


func man(style: String, threat: String, weak: String, rating: float) -> Dictionary:
	return {"name": "M %s|%s|%s" % [style, threat, weak], "style": style, "threat": threat, "weak": weak, "rating": snappedf(rating, 0.01)}


## The opponent as the read and the bout both get him (turnprobe18.read's build).
func opp_of(ti: int, m: Dictionary) -> Dictionary:
	var f: Dictionary = types[ti]["f"]
	var opp := DebutOpp.make(f, 0.0, 0, "probe18")
	opp.merge({"name": str(m["name"]), "first": str(m["name"]).split(" ")[0], "style": str(m["style"]), "threat": str(m["threat"]),
		"weak": str(m["weak"]), "rating": float(m["rating"])}, true)
	return opp


func arrows(ti: int, m: Dictionary, line: Dictionary, k: float) -> Array:
	var f: Dictionary = types[ti]["f"]
	if line.is_empty():
		return []
	return CoachPlan.write(str(m["style"]), k, f.get("moves", {}), f.get("combos", {}), f.get("steps", {})) + [line]


## The game's read (rule A on/off, rule B mode) of type ti on the usual plan (line {}) or the coach's plan + one line.
func read(ti: int, m: Dictionary, line: Dictionary, a_on: bool, b_mode: String, k: float) -> float:
	var key := "%d|%s|%s|%s|%s|%s|%.1f" % [ti, m["name"], line.get("move", ""), line.get("when", ""), a_on, b_mode, k]
	if cache.has(key):
		return float(cache[key])
	var f: Dictionary = (types[ti]["f"] as Dictionary).duplicate()
	f["pro"] = true
	f["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": 4}
	f["arrows"] = arrows(ti, m, line, k)
	var p := R.chance(f, opp_of(ti, m), CAMP, k, a_on, b_mode)
	reads += 1
	cache[key] = p
	return p


## The lines the boxer can write (turnprobe18.lines_for, copied): every move out of each tell situation's card he can throw.
func lines_for(ti: int, m: Dictionary) -> Array:
	var f: Dictionary = types[ti]["f"]
	var tells := OppFile.tells({"style": m["style"], "threat": m["threat"], "weak": m["weak"], "w": 6, "l": 6})
	var out: Array = []
	var seen := {}
	for t in tells:
		var sit := str(t.get("when", ""))
		if sit == "" or not PlanFight.GAME_CARD.has(sit) or str(t["id"]) not in ["style", "weapon", "weakness"]:
			continue
		for o in PlanLines.options(str(PlanFight.GAME_CARD[sit]), sit, f.get("moves", {}), f.get("combos", {})):
			if str(o["why"]) != "":
				continue
			var kk := "%s|%s" % [o["id"], sit]
			if seen.has(kk):
				continue
			seen[kk] = true
			out.append({"move": str(o["id"]), "when": sit, "tell": str(t["id"])})
	return out


func files() -> Array:
	var out: Array = []
	for s in STYLES:
		for w in WEAPONS:
			for k in WEAKS:
				out.append([s, w, k])
	return out


## One real bout: type ti, file m, arrows (empty = the coach writes his own at the first bell), rule A on/off, dice k.
func bout(ti: int, m: Dictionary, arr: Array, a_on: bool, k: int, ck: float) -> String:
	var sc := Career.new()
	sc.day = 50000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": ck}
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = true
	sf["camp"] = CAMP.duplicate(true)
	sf["arrows"] = arr.duplicate(true)
	var opp := opp_of(ti, m)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": 4, "pro": true, "stale": 0.0}
	sf["bout"]["mode_bias"] = R.bias(sf, opp, a_on)
	sc.fighters = [sf]
	var md := BoutNight.fight_modal(sf)
	BoutNight.play_out(sc, sf, md)
	bouts += 1
	return BoutNight.outcome_of(sf, md)


func _mixes(ti: int, m: Dictionary) -> Dictionary:
	var f: Dictionary = types[ti]["f"]
	var opp := opp_of(ti, m)
	var r := {}
	for on in [false, true]:
		var mx := R.mix(f, opp, on)
		var row := {}
		for s in R.MIX_SITS:
			row[s] = snappedf(float(mx.get(s, 0.0)), 0.001)
		r["on" if on else "off"] = row
	return r


## STAGE read: per type and file, the usual read and every line's gain (points), rules as given.
func stage_read(a_on: bool, b_mode: String, want: Array) -> void:
	for ti in types.size():
		if not want.is_empty() and not want.has(ti):
			continue
		var r0 := float(types[ti]["night0"])
		var m0 := man(STYLES[0], WEAPONS[2], WEAKS[0], r0)
		var f0: Dictionary = (types[ti]["f"] as Dictionary).duplicate()
		f0["pro"] = true
		f0["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": 4}
		f0["arrows"] = []
		var game := float(BoutRead.CardOdds.result(BoutRead.round_edges(f0, opp_of(ti, m0), CAMP, coach), BoutRead.RingDuel.FORM_SD)["win"])
		say({"tag": "control", "ti": ti, "game_read": snappedf(100.0 * game, 0.01), "copy_read": snappedf(100.0 * read(ti, m0, {}, false, "off", coach), 0.01)})
		for fl in files():
			var m := man(fl[0], fl[1], fl[2], r0)
			var u := read(ti, m, {}, a_on, b_mode, coach)
			var ls: Array = []
			for l in lines_for(ti, m):
				ls.append([l["move"], l["when"], l["tell"], snappedf(100.0 * (read(ti, m, l, a_on, b_mode, coach) - u), 0.01)])
			say({"tag": "read", "a": a_on, "b": b_mode, "coach": coach, "ti": ti, "type": types[ti]["name"], "tstyle": types[ti]["style"],
				"style": fl[0], "threat": fl[1], "weak": fl[2], "tsits": R.tell_sits(m), "usual": snappedf(100.0 * u, 0.01), "lines": ls,
				"mix": _mixes(ti, m)})
		print("TP1 read type %d done, %d reads, %.1f s" % [ti, reads, (Time.get_ticks_msec() - t0) / 1000.0])


## The files of type ti whose weapon or weakness maps to sit, spread over the list (nf of them).
func files_for(sit: String, nf: int) -> Array:
	var hit: Array = files().filter(func(fl): return R.tell_sits({"threat": fl[1], "weak": fl[2]}).has(sit))
	var out: Array = []
	for j in nf:
		out.append(hit[int(floor((float(j) + 0.5) * float(hit.size()) / float(nf)))])
	return out


## STAGE bout_lines (bar 5): per type, situation and file, the read's best line in that situation (rules on), then n paired
## bouts on the coach's plan and on the coach's plan + that line, rule A on in the bout (rule B has no bout side).
func stage_bout_lines(b_mode: String, n: int, nf: int, want: Array) -> void:
	for ti in types.size():
		if not want.is_empty() and not want.has(ti):
			continue
		for sit in SITS:
			for fl in files_for(sit, nf):
				var m := man(fl[0], fl[1], fl[2], float(types[ti]["night0"]))
				var best := {}
				var bg := -INF
				var u := read(ti, m, {}, true, b_mode, coach)
				for l in lines_for(ti, m):
					if str(l["when"]) != sit:
						continue
					var g := read(ti, m, l, true, b_mode, coach) - u
					if g > bg:
						bg = g; best = l
				if best.is_empty():
					continue
				var arr := arrows(ti, m, {"move": best["move"], "when": best["when"]}, coach)
				var wu := 0; var wl := 0; var du := 0; var dl := 0; var disc := 0
				for k in n:
					var ou := bout(ti, m, [], true, k, coach)
					var ol := bout(ti, m, arr, true, k, coach)
					wu += int(ou == "win"); wl += int(ol == "win"); du += int(ou == "draw"); dl += int(ol == "draw")
					disc += int((ou == "win") != (ol == "win"))
				say({"tag": "bout_line", "b": b_mode, "ti": ti, "type": types[ti]["name"], "sit": sit, "style": fl[0], "threat": fl[1],
					"weak": fl[2], "line": best["move"], "read_gain": snappedf(100.0 * bg, 0.01),
					"read_gain_boff": snappedf(100.0 * (read(ti, m, {"move": best["move"], "when": best["when"]}, true, "off", coach) - read(ti, m, {}, true, "off", coach)), 0.01),
					"read_usual": snappedf(100.0 * u, 0.01), "n": n, "win_usual": wu, "win_line": wl, "draw_usual": du, "draw_line": dl, "disc": disc})
			print("TP1 bout_lines type %d %s, %d bouts, %.1f s" % [ti, sit, bouts, (Time.get_ticks_msec() - t0) / 1000.0])


## STAGE bout_base (bar 6): the coach's plan, no player line, rule A off and on, n paired bouts per file; per type x opponent
## style, nf files rotating the weapons and weaknesses.
func stage_bout_base(n: int, nf: int, want: Array) -> void:
	for ti in types.size():
		if not want.is_empty() and not want.has(ti):
			continue
		for si in STYLES.size():
			for j in nf:
				var idx := (j * 7 + si * 3 + ti) % (WEAPONS.size() * WEAKS.size())
				var m := man(STYLES[si], WEAPONS[idx / WEAKS.size()], WEAKS[idx % WEAKS.size()], float(types[ti]["night0"]))
				var w0 := 0; var w1 := 0; var disc := 0
				for k in n:
					var o0 := bout(ti, m, [], false, k, coach)
					var o1 := bout(ti, m, [], true, k, coach)
					w0 += int(o0 == "win"); w1 += int(o1 == "win"); disc += int((o0 == "win") != (o1 == "win"))
				say({"tag": "bout_base", "ti": ti, "type": types[ti]["name"], "tstyle": types[ti]["style"], "style": m["style"],
					"threat": m["threat"], "weak": m["weak"], "tsits": R.tell_sits(m), "n": n, "win_off": w0, "win_on": w1, "disc": disc,
					"read_off": snappedf(100.0 * read(ti, m, {}, false, "off", coach), 0.01), "read_on": snappedf(100.0 * read(ti, m, {}, true, "off", coach), 0.01)})
		print("TP1 bout_base type %d, %d bouts, %.1f s" % [ti, bouts, (Time.get_ticks_msec() - t0) / 1000.0])


## STAGE trial: one type against six files (one per situation, one with no tell), printed in full: the mix on and off,
## every line's read under every rule arm, one real bout each, and a 40-bout timing cell.
func stage_trial(ti: int) -> void:
	var r0 := float(types[ti]["night0"])
	var six := [["Boxer-puncher", "Body hooks", "Leaves the chin open"], ["Boxer-puncher", "Long jab", "Leaves the chin open"],
		["Boxer-puncher", "Right hand over the jab", "Leaves the chin open"], ["Boxer-puncher", "Heavy right hand", "Leaves the chin open"],
		["Boxer-puncher", "Stops people", "Fades after round 2"], ["Boxer-puncher", "Stops people", "Leaves the chin open"]]
	for fl in six:
		var m := man(fl[0], fl[1], fl[2], r0)
		var row := {"tag": "trial", "type": types[ti]["name"], "file": fl, "tsits": R.tell_sits(m), "mix": _mixes(ti, m)}
		var arms := [[false, "off"], [true, "off"], [true, "chain"], [true, "carry:0.95"]]
		for arm in arms:
			var u := read(ti, m, {}, arm[0], arm[1], coach)
			var ls := {}
			for l in lines_for(ti, m):
				ls["%s@%s" % [l["move"], l["when"]]] = snappedf(100.0 * (read(ti, m, l, arm[0], arm[1], coach) - u), 0.01)
			row["A%s_B%s" % ["on" if arm[0] else "off", arm[1]]] = {"usual": snappedf(100.0 * u, 0.01), "lines": ls}
		row["bout_off"] = bout(ti, m, [], false, 0, coach)
		row["bout_on"] = bout(ti, m, [], true, 0, coach)
		say(row)
	var tb := Time.get_ticks_msec()
	var m6 := man("Boxer-puncher", "Stops people", "Fades after round 2", r0)
	var w := 0
	for k in 40:
		w += int(bout(ti, m6, [], false, k, coach) == "win")
	say({"tag": "timing", "ms_a_bout": (Time.get_ticks_msec() - tb) / 40.0, "wins_of_40": w})


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	out_path = _arg("out", "")
	var built := R.build_types(WEEK)
	types = built[0]
	R.A_MULT = float(_arg("am", "1.5"))
	R.A_ADD = float(_arg("aa", "0.10"))
	coach = float(_arg("coach", str(built[1])))
	var stage := _arg("stage", "trial")
	var want: Array = []
	if _arg("types", "") != "":
		want = Array(_arg("types", "").split(",")).map(func(x): return int(x))
	say({"tag": "run", "stage": stage, "coach": coach, "a_mult": R.A_MULT, "a_add": R.A_ADD, "today_tiring": R.TODAY_TIRING,
		"population": types.map(func(t): return [t["name"], t["sex"], t["style"], snappedf(float(t["night0"]), 0.01), t["f"]["stats"]])})
	match stage:
		"trial": stage_trial(int(_arg("ti", "0")))
		"read": stage_read(_arg("a", "on") == "on", _arg("b", "off"), want)
		"bout_lines": stage_bout_lines(_arg("b", "off"), int(_arg("n", "100")), int(_arg("files", "3")), want)
		"bout_base": stage_bout_base(int(_arg("n", "10")), int(_arg("files", "5")), want)
	print("TELLPLAY1 done: stage %s, %.1f s, %d reads, %d bouts" % [stage, (Time.get_ticks_msec() - t0) / 1000.0, reads, bouts])
	quit(0)
