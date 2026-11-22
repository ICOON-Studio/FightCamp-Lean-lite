extends SceneTree
## S537 GUARDPROBE10 - guard v9: the guard lines follow the OPPONENT (ops/research/TASK_GUARDREV9.md, DESIGN_GUARDDMG1_V9.md).
## MEASUREMENT ONLY: nothing under scripts/ is edited. guardprobe9's instrument and self-checks (the exchange-by-exchange walk around the
## game's fight night, Data's region opponents by style and sex, 5 styles x amateur 3 / pro 6 = 10 cells, 40 seeds, paired dice).
## WHAT CHANGED FROM PROBE 9 (sizes and bars set BEFORE the run, never on the test's seeds):
##   - ONE guard a plan, on ONE of the OPPONENT's moments: High WHEN he loads up / Elbows in WHEN he presses / Light WHEN he boxes at
##     range. No line sits on your boxer's own trouble (hurt, tired): that is the corner's shout.
##   - Three guards, three feet: High = Wide (planted), Elbows in = Shoulder, Light = Narrow. steps = how far his stance is from it.
##     In the 30 seconds the line fires: its plus x fit[steps]; High and Elbows in out of their feet cost STEP SPEED (points off that
##     exchange a step); Light out of its feet costs LEGS (energy after that exchange a step).
##   - A stance moved a step toward the guard is NOT OWNED on the night: slower feet and energy a round (STANCE1's rule), on top of
##     what the shifted stance does to the boxer (stanceprobe1's width column).
##   - Seven boxers: the five Data prospects + two generated (a Narrow man, a Wide man), so every natural stance has 2 or 3 boxers.
## Pairs a cell (7): no guard line; each guard on the natural stance; each guard with the stance moved a step toward it (not owned).
## For a boxer already in the guard's feet "a step toward" IS his natural stance (the same bouts). FREE:<guard> = v7's rule (no feet).
## PASS (all):
##   1 every effect (fit, steps, legs, stance, not owned) changes 2+ bouts in 100 on its test pairs;
##   2 a guard line COSTS: on the natural stance the paid lines are 2.0+ wins in 100 under the same lines FREE, pooled over cells and
##     guards, more than two standard errors, AND some guard is 3+ under its free twin in 3+ cells (probe 9's bar, unchanged);
##   3 no pair best in more than 5 of 10 opponent cells (exact ties count for both);
##   4 4+ cells clear: the best pair more than two standard errors (paired, seed by seed) above EVERY other pair;
##   5 the best guard changes with the opponent's style for EVERY boxer (his best guard is not the same against all five styles),
##     and for 4+ of the 7 boxers that change is beyond two standard errors (guard A over B against one style, B over A against another);
##   6 the natural stance is best in some opponent cells and beaten in others (1+ cells each way).
##   python ops/Tools/godot_slot.py run --who guardrev9 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/guardprobe10.gd [-- seeds=40 abl=20 size=1 doc=<file.md> raw=<file.json> from=<file.json>]

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const GuardState := preload("res://scripts/state/GuardState.gd")
const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const BoutBurn := preload("res://scripts/rules/BoutBurn.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const PunchStart := preload("res://scripts/rules/PunchStart.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const ClinchRest := preload("res://scripts/rules/ClinchRest.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")
const FilmNight := preload("res://scripts/state/FilmNight.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")

const BOXERS := ["kira", "gen_narrow", "samira", "gen_wide", "tess", "danny", "josh"]
## The two generated boxers (never a copy of a prospect: own stats, own style, legal for boxing), built on a prospect's sheet.
const GEN := {
	"gen_narrow": {"from": "danny", "name": "Leon Ward (generated)", "first": "Leon", "style": "Out-boxer", "age": 21,
		"stats": {"power": 55.0, "speed": 65.0, "technique": 58.0, "defense": 59.0, "conditioning": 60.0, "fight_iq": 58.5, "chin": 56.0}},
	"gen_wide": {"from": "josh", "name": "Marcus Doyle (generated)", "first": "Marcus", "style": "Slugger", "age": 25,
		"stats": {"power": 67.5, "speed": 57.0, "technique": 56.5, "defense": 53.0, "conditioning": 61.0, "fight_iq": 55.0, "chin": 65.5}},
}
const STYLES := ["Out-boxer", "Pressure fighter", "Counter-puncher", "Volume puncher", "Slugger"]
const SCALES := [
	{"id": "am", "name": "amateur, 3 rounds", "pro": false, "rounds": 3},
	{"id": "pro", "name": "pro, 6 rounds", "pro": true, "rounds": 6},
]
const WIDTHS := ["Narrow", "Shoulder", "Wide"]
const SHIFT_WORDS := {0: "natural stance", 1: "a step toward it"}
const PLANS := [
	{"arrows": [{"move": "1-2"}, {"move": "step_in"}, {"move": "cut_off"}, {"move": "tie_up"}], "combos": {"1-2": 60.0, "1-1": 45.0}},
	{"arrows": [{"move": "2-3"}, {"move": "feint"}, {"move": "pivot_out"}, {"move": "1-2"}], "combos": {"2-3": 60.0, "1-2": 50.0}},
]
const OPP_OFF := {"am": -3.4, "pro": -6.5}
const DAY0 := 61000
## v9's table: the opponent's moment -> [High, Elbows in, Light] points into the exchange's sum. High and Light at loadup / counter
## are v7's; Elbows in is new; Light at range is up (v7 +4), Light when pressed is down (v7 +3): DESIGN_GUARDDMG1_V9.md 2.2.
const TABLE := {"loadup": [9.0, -2.0, -10.0], "press": [-4.0, 8.0, -3.0], "range": [-8.0, -5.0, 8.0], "counter": [-3.0, -3.0, -8.0],
	"tiring": [-9.0, -4.0, 5.0], "hurt": [-9.0, -4.0, 5.0]}
const COL := {"high": 0, "tight": 1, "loose": 2}
## v6 2.3-2.5 after the settle, unchanged for High and Light; Elbows in has no after-the-settle rule (it walks as "normal").
const AFTER := {"worn": [2.0, 4.0], "drain": 1.0, "block": {"high": 0.75, "normal": 0.6, "loose": 0.45}, "high_wear": true,
	"hurt": {"high": 0.7, "normal": 1.0, "loose": 1.3}, "loose_dmg": 2.0, "high_out": 0.75}
const DONE_WITH := {"high": ["defence", "composure"], "tight": ["defence", "strength"], "loose": ["speed", "stamina"]}
const FAMILIES := {"NONE": {}, "HIGH": {"loadup": "high"}, "TIGHT": {"press": "tight"}, "LIGHT": {"range": "loose"}}
const FAM_HANDS := {"HIGH": "high", "TIGHT": "tight", "LIGHT": "loose"}
const FAMILY_WORDS := {"NONE": "no guard line", "HIGH": "High guard", "TIGHT": "Elbows in", "LIGHT": "Light guard"}
const FAMILY_ORDER := ["NONE", "HIGH", "TIGHT", "LIGHT"]
const SUIT := {"high": 1, "tight": 0, "loose": -1}   # the stance width each guard is done in fully
## The feet's price, by run. fit = the plus kept at 0 / 1 / 2 steps from the guard's stance; step = points off the exchange a step
## (High, Elbows in out of their feet); leg = energy after the exchange a step (Light out of its feet); un_feet / un_drain = a stance
## not owned yet: footwork and foot speed off, energy a round. 1 = the pre-registered run (probe 9 run 2's prices; ST1's not-owned
## feet price doubled: its -2 was half of what a step of stance itself moves). plus = a multiplier on the table's plus values.
## 2 = the ONE resize, set after run 1 failed bar 4 only (1 of 10 cells clear; every other bar passed) and before its own run: the
## guard's plus on its moment is worth half as much again (High +13.5, Elbows in +12, Light +12), so the right guard stands further
## from the others. Nothing else is changed; the seeds are the same.
const SIZES := {1: {"fit": [1.0, 0.5, 0.0], "step": 4.0, "leg": 4.0, "un_feet": 4.0, "un_drain": 2.0, "plus": 1.0},
	2: {"fit": [1.0, 0.5, 0.0], "step": 4.0, "leg": 4.0, "un_feet": 4.0, "un_drain": 2.0, "plus": 1.5}}
const BASE := {"power": 5.0, "slip": 5.0, "chin": 5.0, "feet": 3.0, "drain": 1.5}
const PAIRS := [["NONE", 0], ["HIGH", 0], ["HIGH", 1], ["TIGHT", 0], ["TIGHT", 1], ["LIGHT", 0], ["LIGHT", 1]]
const FREE := ["HIGH", "TIGHT", "LIGHT"]
const EFFECTS := {"fit": [["HIGH", 0], ["LIGHT", 0]], "steps": [["HIGH", 0], ["TIGHT", 0]], "legs": [["LIGHT", 0]], "stance": [["HIGH", 1], ["LIGHT", 1]], "unowned": [["HIGH", 1], ["TIGHT", 1]]}
const EFFECT_WORDS := {"fit": "the plus kept by the feet", "steps": "High / Elbows in out of their feet: step speed", "legs": "Light out of its feet: the legs", "stance": "a shifted stance changes the boxer", "unowned": "a stance not owned yet: slow feet, energy"}
const BARS := {"top": 5, "clear": 4, "cost": 2.0, "cost_cells": 3, "cross": 4}

var L: Array = []
var t0 := 0
var n_bouts := 0
var n_dirty := 0
var guard_diff := 0.0
var Z: Dictionary = SIZES[1]
var people := {}

func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	var opt := {"seeds": 40, "abl": 20, "size": 1}
	var doc := "res://docs/GUARDPROBE10_RAW.md"; var raw := ""; var from := ""
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() != 2: continue
		if opt.has(kv[0]): opt[kv[0]] = int(kv[1])
		elif kv[0] == "doc": doc = kv[1]
		elif kv[0] == "raw": raw = kv[1]
		elif kv[0] == "from": from = kv[1]
	for id in BOXERS:
		var t := _person(str(id))
		var st := Data.fighter_state(t.duplicate(true), DAY0)
		people[id] = {"t": t, "nat": _natural(st)}
	var D := {}
	if from != "":
		D = JSON.parse_string(FileAccess.get_file_as_string(from))
	else:
		Z = SIZES[int(opt["size"])]
		D = _run(int(opt["seeds"]), mini(int(opt["abl"]), int(opt["seeds"])), int(opt["size"]))
		if raw != "":
			var fr := FileAccess.open(raw, FileAccess.WRITE)
			fr.store_string(JSON.stringify(D)); fr.close()
	Z = SIZES[int(D["size"])]
	_report(D)
	var fa := FileAccess.open(doc, FileAccess.WRITE)
	if fa != null:
		fa.store_string("\n".join(L) + "\n"); fa.close()
	print("GUARDPROBE10 done (%.0f s)" % _secs())
	quit(0)

static func _key(fam: String, shift: int) -> String:
	return "%s@%+d" % [fam, shift]

func _pname(fam: String, shift: int) -> String:
	return str(FAMILY_WORDS[fam]) if fam == "NONE" else "%s, %s" % [FAMILY_WORDS[fam], SHIFT_WORDS[shift]]

func _kname(key: String) -> String:
	return _pname(key.get_slice("@", 0), int(key.get_slice("@", 1)))

## The step his stance moves for a guard's "a step toward it" arm (0 = he is already in its feet).
func _toward(bi: int, fam: String) -> int:
	return 0 if fam == "NONE" else signi(int(SUIT[FAM_HANDS[fam]]) - int(people[BOXERS[bi]]["nat"]))

## One arm over every boxer and n seeds, as a string of results (2 win, 1 draw, 0 loss), boxer-major, seed-minor. twin = the same
## bouts already fought for a boxer in the guard's feet (toward = natural = free; nothing to switch off but the fit, which is 1.0):
## his results are copied from it instead of fought again.
func _arm(cell: Dictionary, n: int, arm: Dictionary, twin: String, fired: Array) -> String:
	var bits := ""
	var fam := str(arm.get("fam", "NONE"))
	for bi in BOXERS.size():
		if twin != "" and fam != "NONE" and _toward(bi, fam) == 0:
			bits += twin.substr(bi * n, n)
			continue
		for s in n:
			var r := _bout(bi, cell, s, arm)
			bits += str(int(r["win2"])); fired[0] += float(r["fired"])
	return bits

func _run(seeds: int, abl: int, size: int) -> Dictionary:
	var same := 0; var tried := 0
	for bi in BOXERS.size():
		for ci in SCALES.size():
			for s in 3:
				var cell := {"si": (bi + s) % STYLES.size(), "ci": ci}
				var a := _bout(bi, cell, s, {"plain": true})
				var b := _bout(bi, cell, s, {"play_out": true})
				tried += 1; same += int(str(a["sig"]) == str(b["sig"]))
	var cells := {}
	for si in STYLES.size():
		for ci in SCALES.size():
			var cell := {"si": si, "ci": ci}
			var id := "%s / %s" % [STYLES[si], SCALES[ci]["id"]]
			var out := {"w": {}, "fired": {}, "abl": {}}
			var W: Dictionary = out["w"]
			for pr in PAIRS:
				var k := _key(str(pr[0]), int(pr[1])); var fired := [0.0]
				W[k] = _arm(cell, seeds, {"fam": pr[0], "shift": pr[1]}, str(W[_key(str(pr[0]), 0)]) if int(pr[1]) == 1 else "", fired)
				out["fired"][k] = fired[0]
			for fam in FREE:
				W["FREE:" + str(fam)] = _arm(cell, seeds, {"fam": fam, "shift": 0, "free": true}, str(W[_key(str(fam), 0)]), [0.0])
			var cb := ""
			for bi in BOXERS.size():
				for s in abl:
					cb += str(int(_bout(bi, cell, s, {"play_out": true})["win2"]))
			out["ctrl"] = cb
			for ef in EFFECTS:
				out["abl"][ef] = {}
				for pr in EFFECTS[ef]:
					var k := _key(str(pr[0]), int(pr[1]))
					var cut := ""
					for bi in BOXERS.size():
						cut += str(W[k]).substr(bi * seeds, abl)
					out["abl"][ef][k] = _arm(cell, abl, {"fam": pr[0], "shift": pr[1], "off": ef}, cut, [0.0])
			cells[id] = out
			print("cell %s done, %d bouts, %.0f s" % [id, n_bouts, _secs()])
	return {"seeds": seeds, "abl": abl, "size": size, "took": _secs(), "bouts": n_bouts, "dirty": n_dirty, "same": same, "tried": tried, "guard_diff": guard_diff, "cells": cells}

static func _person(id: String) -> Dictionary:
	if GEN.has(id):
		var g: Dictionary = GEN[id]
		var p := _person(str(g["from"]))
		p.merge({"id": id, "name": g["name"], "first": g["first"], "style": g["style"], "age": g["age"], "stats": (g["stats"] as Dictionary).duplicate()}, true)
		return p
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			return (p as Dictionary).duplicate(true)
	return Data.lucy()

## The natural width from the frame's stats (stanceprobe1's rule, ESTIMATE): -1 Narrow, 0 Shoulder, +1 Wide.
static func _natural(st: Dictionary) -> int:
	var lean := (float(st["stats"]["power"]) - float(st["stats"]["speed"])) / 4.0
	return 1 if lean >= 2.0 else (-1 if lean <= -2.0 else 0)

static func _pool(sex: String, style: String) -> Array:
	var out: Array = []
	var all: Array = Data.OPPONENTS + Data.RIVALS + Data.DIVISION_RIVALS
	for o in all:
		var d := str((o as Dictionary).get("div", "wlw"))
		if str(Data.DIVISIONS[d]["sex"]) == sex and float(o["rating"]) < 68.0 and str(o["style"]) == style:
			out.append(o)
	return out

## The stance layer for round n: dw = steps wider than his natural stance (stanceprobe1's width column); raw = the stance is not
## owned yet (slower feet, energy a round).
func _stance(f: Dictionary, S: Dictionary, dw: int, raw: bool, n: int) -> void:
	if dw == 0 and not raw:
		return
	var fb: Dictionary = f["bout"]
	var a: Dictionary = (S["a0"] as Dictionary).duplicate()
	var un := float(Z["un_feet"]) if raw else 0.0
	var d := {"power": float(BASE["power"]) * dw, "head_movement": float(BASE["slip"]) * dw, "chin": float(BASE["chin"]) * dw,
		"foot_speed": -float(BASE["feet"]) * dw - un, "footwork": -float(BASE["feet"]) * dw - un}
	for k in d:
		a[k] = clampf(float(a.get(k, 55.0)) + float(d[k]), Attrs.LO, Attrs.HI)
	var lv: Dictionary = PunchStart.from_moves(S["moves0"], float(f["stats"]["technique"]), PunchStart.raw_floor(a))
	for pk in Attrs.PUNCHES:
		a[pk] = maxf(float(a.get(pk, 0.0)), clampf(float(lv[pk]), Attrs.LO, Attrs.HI))
	f["attrs"] = a
	if n >= 2 and fb.has("energy"):
		fb["energy"]["a"] = clampf(float(fb["energy"]["a"]) - float(BASE["drain"]) * dw - (float(Z["un_drain"]) if raw else 0.0), 0.0, 100.0)
	if not Attrs._clean(f): n_dirty += 1

## One bout. arm: {fam, shift, free, off} or {plain} (the walk with every guard size off) or {play_out} (the game's own).
func _bout(bi: int, cell: Dictionary, seed_i: int, arm: Dictionary) -> Dictionary:
	var p: Dictionary = people[BOXERS[bi]]
	var t: Dictionary = p["t"]
	var sc: Dictionary = SCALES[int(cell["ci"])]
	var day := DAY0 + seed_i * 211 + bi * 37 + int(cell["si"]) * 1009 + int(cell["ci"]) * 5003
	var f := Data.fighter_state(t.duplicate(true), day)
	var pl: Dictionary = PLANS[1 if bool(sc["pro"]) else 0]
	f = f.merged({"pro": bool(sc["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [],
		"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
	f.erase("last_bout_day")
	var pool := _pool(str(t["sex"]), str(STYLES[int(cell["si"])]))
	var opp: Dictionary = (pool[seed_i % pool.size()] as Dictionary).duplicate(true)
	opp["rating"] = BoutRules.fight_power(t["stats"], {}, 0, "", false) + float(OPP_OFF[str(sc["id"])])
	opp["height"] = float(f["height"]); opp["reach"] = float(f["reach"])
	f["bout"] = {"opp": opp, "day": day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": int(sc["rounds"]), "stale": 0.0}
	var c := Career.new()
	c.day = day; c.seed = seed_i + 1; c.coach = {"rating": 60.0}; c.fighters = [f]
	var m := {"type": "fight", "fid": f["id"], "step": "tape", "round": 0, "rounds": [], "total": int(sc["rounds"])}
	var st := {"plain": arm.has("plain"), "free": bool(arm.get("free", false)), "off": str(arm.get("off", "")), "drain": 0.0,
		"lines": FAMILIES[str(arm.get("fam", "NONE"))], "fired": 0}
	if arm.has("play_out"):
		BoutNight.play_out(c, f, m)
	else:
		var nat := int(p["nat"])
		var mv := _toward(bi, str(arm.get("fam", "NONE"))) if int(arm.get("shift", 0)) == 1 else 0
		st["w"] = nat + mv
		var dw := 0 if st["off"] == "stance" else mv
		var raw: bool = mv != 0 and str(st["off"]) != "unowned"
		var S := {"a0": Attrs.of(f).duplicate(), "moves0": (f["moves"] as Dictionary).duplicate()}
		_stance(f, S, dw, raw, 1)
		m.merge({"step": "round", "round": 0, "rounds": []}, true)
		BoutNight._peak(c, f)
		ProReadWire.open(f)
		m["lab_from"] = f.duplicate(true)
		_open(c, f, m, "", st)
		while int(m["round"]) < BoutNight.rounds_of(f) and BoutNight.stopped(m) == "" and not TowelWire.coach_pull(c, f, m) and not CrackWire.bell(c, f, m, BoutNight.rounds_of(f)):
			_stance(f, S, dw, raw, int(m["round"]) + 1)
			_open(c, f, m, BoutRules.auto_corner(f["stats"]), st)
	n_bouts += 1
	var out := str(BoutNight.outcome_of(f, m))
	var sig := out
	for r in m["rounds"]:
		sig += "|%d%s%d-%d" % [int(r["n"]), "W" if bool(r["won"]) else "L", int(r["landed"][0]), int(r["landed"][1])]
	return {"win2": 2 if out == "win" else (1 if out == "draw" else 0), "sig": sig, "fired": int(st["fired"])}

## BoutNight._open with no corner jobs, then the round's six exchanges (guardprobe8._open).
func _open(c: Career, f: Dictionary, m: Dictionary, plan: String, st: Dictionary) -> void:
	m["round"] = int(m["round"]) + 1
	var n := int(m["round"])
	var e := BoutNight._energy(f, n, plan)
	var rounds: Array = m.get("rounds", [])
	var jobs := {}
	if n > 1 and not rounds.is_empty():
		var last: Dictionary = rounds[-1]
		var body: Dictionary = f["bout"].get("body", {"a": 0, "b": 0})
		var rec := CornerJobs.recover({}, float(e.get("a", 100.0)), int(body.get("a", 0)), bool(last.get("hurt_at_bell", false)))
		e["a"] = float(e.get("a", 100.0)) + float(rec["energy"]); e["a_end"] = float(e.get("a_end", 100.0)) + float(rec["energy"])
		body["a"] = int(body.get("a", 0)) - int(rec["body"])
		jobs["hurt"] = bool(rec["hurt"]); jobs["did"] = rec
	LiveRound.open(c, f, m, n, plan, e, "", jobs)
	LiveRound.live(m)["did"] = jobs.get("did", {})
	if n == 1:
		f["bout"]["arrow_limit"] = StyleName.limit(f, BoutNight.arrow_limit(c))
		if (f["bout"]["arrows"] as Array).is_empty():
			f["bout"]["arrows"] = CoachPlan.write(str(f["bout"]["opp"].get("style", "")), float(c.coach.get("rating", 0.0)), f.get("moves", {}), f.get("combos", {}), f.get("steps", {}))
	while not LiveRound.live(m).is_empty():
		_ex(c, f, m, st)

## Steps between his stance and the guard's (0 in the FREE arms: v7's rule).
func _steps(hands: String, st: Dictionary) -> int:
	if hands == "normal" or bool(st["free"]):
		return 0
	return absi(int(st["w"]) - int(SUIT[hands]))

## The line's points for this exchange, graded as a plan line, its plus kept by the feet, the step price off it (High, Elbows in).
func _points(hands: String, sit: String, f: Dictionary, st: Dictionary) -> float:
	if hands == "normal":
		return 0.0
	var e := float(TABLE[sit][int(COL[hands])])
	if e > 0.0: e *= float(Z["plus"])
	var at := Attrs.of(f)
	var pair: Array = DONE_WITH[hands]
	var mean := (float(at.get(str(pair[0]), 55.0)) + float(at.get(str(pair[1]), 55.0))) * 0.5
	var word := "Good" if mean >= Exchanges.GOOD_AT else ("OK" if mean >= Exchanges.OK_AT else "Poor")
	var k := _steps(hands, st)
	var v := e * float(LineGrade.PLUS[word]) if e > 0.0 else e * float(Exchanges.COMMIT[word])
	if v > 0.0 and st["off"] != "fit":
		v *= float(Z["fit"][k])
	if hands != "loose" and st["off"] != "steps":
		v -= float(Z["step"]) * k
	return v

static func _worn(share: float) -> float:
	return float(AFTER["worn"][1]) if share < 0.25 else (float(AFTER["worn"][0]) if share < 0.5 else 0.0)

## One exchange: BoutNight._shout with the guard line around LiveRound.exchange (guardprobe8._ex + the feet).
func _ex(c: Career, f: Dictionary, m: Dictionary, st: Dictionary) -> void:
	var lv := LiveRound.live(m)
	var i := (lv["ex"] as Array).size()
	var plain := bool(st["plain"])
	var sit := Exchanges.situation(str(lv["mode"]), LiveRound.her_energy(lv, i), bool(lv["her_hurt"]))
	var hands := "normal" if plain else str((st["lines"] as Dictionary).get(sit, "normal"))
	st["fired"] = int(st["fired"]) + (1 if hands != "normal" else 0)
	var edge := 0.0
	var snap: Dictionary = (f["bout"]["guard"] as Dictionary).duplicate(true)
	if not plain:
		edge = _points(hands, sit, f, st) + _worn(GuardState.share(f, "b")) - _worn(GuardState.share(f, "a"))
		if hands == "high" and str(lv["mode"]) in ["press", "loadup"]:   # v6 2.4: covering tires the puncher
			lv["opp_drain"] = float(lv.get("opp_drain", 0.0)) + float(AFTER["drain"])
			st["drain"] = float(st["drain"]) + float(AFTER["drain"])
	lv["base"] = float(lv["base"]) + edge
	var r := LiveRound.exchange(c, f, m, "")
	lv["base"] = float(lv["base"]) - edge
	var rec: Dictionary = lv["ex"][-1]
	if not plain:
		_post(c, f, m, lv, rec, "normal" if hands == "tight" else hands, snap, i)
	# Loose out of its feet: the legs pay after the 30 seconds (this round's later exchanges, or the next bell when it was the last).
	var leg := float(Z["leg"]) * _steps(hands, st) if hands == "loose" and st["off"] != "legs" else 0.0
	if r.is_empty():
		lv["cost"] = float(lv["cost"]) + leg
		return
	f["bout"]["energy"]["a"] = maxf(0.0, float(f["bout"]["energy"]["a"]) - leg)
	if not plain:
		r["landed"] = [0, 0]
		for x in r["exchanges"]:
			r["landed"] = [int(r["landed"][0]) + int(x["landed"][0]), int(r["landed"][1]) + int(x["landed"][1])]
		r["guard"] = GuardState.share(f, "a")
		r["hurt_at_bell"] = bool(rec["after"]["hurt"][0])
		f["bout"]["energy"]["b"] = maxf(0.0, float(f["bout"]["energy"]["b"]) - float(st["drain"]))
		st["drain"] = 0.0
	BoutNight._lines(c, f, r)
	(m["rounds"] as Array).append(r)
	r["film"] = FilmNight.minute(f, r, (m["rounds"] as Array).size())
	BoutNight._counts(c, f, m, r)
	m["towel"] = TowelWire.card(c, f, m, BoutNight.count_sides(f, f["bout"]["opp"]), BoutNight.rounds_of(f))

## v6 2.5 after the settle (guardprobe8._post, unchanged).
func _post(c: Career, f: Dictionary, m: Dictionary, lv: Dictionary, rec: Dictionary, hands: String, snap: Dictionary, i: int) -> void:
	var opp: Dictionary = f["bout"]["opp"]
	var landed: Array = rec["landed"]
	var won := bool(rec["won"])
	var theirs0 := int(landed[1])
	var conv := 0
	var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
	if hands == "high":
		conv = roundi(float(theirs0) / 3.0)
		landed[1] = theirs0 - conv
		landed[0] = maxi(0, int(round(float(int(landed[0])) * float(AFTER["high_out"]))))
	elif hands == "loose":
		landed[0 if won else 1] = int(landed[0 if won else 1]) + 1
		theirs0 = int(landed[1])
		if not won:
			dmg["a"] = float(dmg.get("a", 0.0)) + float(AFTER["loose_dmg"])
	var old: Dictionary = rec["guard"]
	f["bout"]["guard"] = snap
	var ng := _guard_after(f, landed, theirs0, conv, str(rec["at"]), RingDuel.opp(opp), str(rec["call"]), int(lv["n"]), RoundStyle.opponent_habits(opp), hands)
	if hands == "normal":
		for k in 2:
			guard_diff = maxf(guard_diff, absf(float(ng["g"][k]) - float(old["g"][k])))
	if GuardState.damage_on:
		dmg["a"] = float(dmg.get("a", 0.0)) + float(ng["through"][0]) - float(old["through"][0])
		dmg["b"] = float(dmg.get("b", 0.0)) + float(ng["through"][1]) - float(old["through"][1])
	m["damage"] = dmg
	rec["guard"] = ng
	if float(rec["margin"]) < -Exchanges.HURT_AT and hands != "normal":
		var hr := RandomNumberGenerator.new()
		hr.seed = c.day * 131 + int(lv["n"]) * 17 + i * 29 + 7
		var mult := float(AFTER["hurt"][hands])
		if mult < 1.0 and bool(lv["her_hurt"]) and hr.randf() < 1.0 - mult:
			lv["her_hurt"] = false
		elif mult > 1.0 and not bool(lv["her_hurt"]):
			var p := clampf(0.3 + (float(RingDuel.side(RingDuel.opp(opp))["power"]) - float(RingDuel.side(Attrs.of(f))["chin"])) / 100.0, 0.1, 0.8)
			if hr.randf() < (mult - 1.0) * p / maxf(0.01, 1.0 - p):
				lv["her_hurt"] = true
		rec["after"]["hurt"][0] = bool(lv["her_hurt"])

## GuardState.after, copied (guardprobe8._guard_after, unchanged).
func _guard_after(f: Dictionary, landed: Array, theirs0: int, conv: int, at: String, opp_attrs: Dictionary, call: String, n: int, opp_habits: Array, hands: String) -> Dictionary:
	var gs: Dictionary = f["bout"]["guard"]
	var amateur := not bool(f.get("pro", false))
	var own := Attrs.of(f)
	var thrown_a := ceili(float(theirs0) / BoutBurn.LAND_RATE)
	var blocks := [roundi(float(maxi(0, thrown_a - theirs0)) * float(AFTER["block"][hands])) + conv, GuardState.blocked_of(int(landed[0]))]
	var ctxs := [
		{"ropes": at == "own_ropes", "amateur": amateur, "shoulder": GuardWear.shoulder(float(own.get("stamina", 55.0)), float(own.get("strength", 55.0)))},
		{"ropes": at == "opp_ropes", "amateur": amateur, "shoulder": GuardWear.shoulder(float(opp_attrs.get("stamina", 55.0)), float(opp_attrs.get("strength", 55.0)))}]
	if hands == "high" and bool(AFTER["high_wear"]):
		ctxs[0]["posture"] = "high"
	var habits := [GuardState.guard_habit(f.get("habits", [])), GuardState.guard_habit(opp_habits)]
	var morale := [float(f.get("morale", 60.0)), 60.0]
	for k in 2:
		if habits[k] != "":
			ctxs[k]["trait"] = habits[k]
			ctxs[k]["round_n"] = n
	var keys := ["a", "b"]
	var wc := GuardState.wclass(float(f.get("limit", 60.0)))
	var through := [0.0, 0.0]
	for k in 2:
		var s: Dictionary = gs[keys[k]]
		var thrown_at := thrown_a if k == 0 else ceili(float(int(landed[0])) / BoutBurn.LAND_RATE)
		var wt := GuardState.wear_through(int(blocks[k]), float(s["g"]), float(s["max"]), wc, ctxs[k])
		through[k] = float(wt[1])
		var rec := GuardWear.in_round(thrown_at, amateur) * maxf(0.0, 1.0 + GuardWear.trait_recovery_pct(str(habits[k]), n, float(morale[k])))
		s["g"] = GuardWear.clamp_guard(float(s["g"]) - float(wt[0]) + rec, float(s["max"]))
	var ours: Dictionary = gs["a"]
	var clinch := {}
	if ClinchRest.tied(call, "", at):
		clinch = GuardWear.clinch(MoveTree.mastery(f, "tie_up") >= 60.0, float(ours["g"]), float(ours["max"]), bool(ours.get("clinch", false)))
		if bool(clinch["ok"]):
			ours["g"] = GuardWear.clamp_guard(float(ours["g"]) + float(clinch["guard"]), float(ours["max"]))
			ours["clinch"] = true
	if call == "hands":
		ours["hands_next"] = true
	return {"g": [float(gs["a"]["g"]), float(gs["b"]["g"])], "blocked": blocks, "clinch": bool(clinch.get("ok", false)), "through": through,
		"share": [float(gs["a"]["g"]) / maxf(1.0, float(gs["a"]["max"])), float(gs["b"]["g"]) / maxf(1.0, float(gs["b"]["max"]))]}

# ---------------------------------------------------------------- the reading
static func _v(s: String, i: int) -> float:
	return float(int(s[i])) * 0.5

## [wins in 100, one standard error] of a result string.
static func _wr(s: String) -> Array:
	var n := float(maxi(1, s.length())); var w := 0.0; var w2 := 0.0
	for i in s.length():
		var x := _v(s, i)
		w += x; w2 += x * x
	var mean := w / n
	return [100.0 * mean, 100.0 * sqrt(maxf(0.0, w2 / n - mean * mean) / maxf(1.0, n - 1.0))]

## a against b, bout by bout on the same dice: [difference in wins in 100, its standard error].
static func _d(a: String, b: String) -> Array:
	var n := float(maxi(2, mini(a.length(), b.length()))); var s := 0.0; var s2 := 0.0
	for i in mini(a.length(), b.length()):
		var x := _v(a, i) - _v(b, i)
		s += x; s2 += x * x
	var mean := s / n
	return [100.0 * mean, 100.0 * sqrt(maxf(0.0, s2 / n - mean * mean) / (n - 1.0))]

static func _pm(v: Array) -> String:
	return "%+.1f +- %.1f" % [float(v[0]), float(v[1])]

## The pairs with the most wins in by (key -> string) and the others inside two standard errors of the first of them.
func _best(by: Dictionary) -> Dictionary:
	var top := -1.0
	for k in by:
		top = maxf(top, float(_wr(by[k])[0]))
	var bests: Array = []
	for k in by:
		if float(_wr(by[k])[0]) >= top - 0.001:
			bests.append(k)
	var ties: Array = []
	for k in by:
		if bests.has(k): continue
		var dd := _d(by[bests[0]], by[k])
		if float(dd[0]) <= 2.0 * float(dd[1]):
			ties.append(k)
	return {"top": top, "bests": bests, "ties": ties}

func _fam(key: String) -> String:
	return key.get_slice("@", 0)

func _short(key: String) -> String:
	return str(FAMILY_WORDS[_fam(key)]) if _fam(key) == "NONE" else "%s, %s" % [FAMILY_WORDS[_fam(key)], "natural" if key.ends_with("@+0") else "a step"]

func _report(D: Dictionary) -> void:
	var seeds := int(D["seeds"]); var abl := int(D["abl"])
	var C: Dictionary = D["cells"]
	var ids: Array = []
	for si in STYLES.size():
		for sc in SCALES:
			ids.append("%s / %s" % [STYLES[si], sc["id"]])
	var nb := BOXERS.size()
	var per := nb * seeds
	_say(["# GUARDPROBE10 - guard v9: the guard lines follow the opponent (S537), sizes run %d" % int(D["size"]), "",
		"Run: python ops/Tools/godot_slot.py run --who guardrev9 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe10.gd -- seeds=%d abl=%d size=%d" % [seeds, abl, int(D["size"])], "",
		"What is real: five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex, re-rated %+.1f amateur / %+.1f pro as stanceprobe1 fitted) and every bout (the game's fight night, walked exchange by exchange)." % [float(OPP_OFF["am"]), float(OPP_OFF["pro"])],
		"What is scratch: two generated boxers (a Narrow man and a Wide man on a prospect's sheet, own stats and style), the three guards and their table, the feet's price, the shifted stance's layer and its not-owned price. Every arm of a seed fights the same night (same dice): %d bouts a pair and cell = %d boxers x %d seeds. A draw is half a win." % [per, nb, seeds], "",
		"Sizes (set before the run): the plus kept at 0 / 1 / 2 steps from the guard's stance %s; High and Elbows in out of their feet %.1f points off the exchange a step; Light out of its feet %.1f energy after the exchange a step. A shifted stance: %s a step; not owned yet: footwork and foot speed -%.1f, %.1f energy a round. The table's plus values x %.1f." % [str(Z["fit"]), float(Z["step"]), float(Z["leg"]), str(BASE), float(Z["un_feet"]), float(Z["un_drain"]), float(Z["plus"])],
		"The guards (one a plan, one line): High guard WHEN the opponent loads up (its feet: Wide); Elbows in WHEN the opponent presses (Shoulder); Light guard WHEN the opponent boxes at range (Narrow). Table, moment -> [High, Elbows in, Light]: %s." % str(TABLE), "",
		"Self-check 1: the walk with every guard size off gives the same bout as BoutNight.play_out in %d of %d bouts. Self-check 2: the copied guard walk against the game's, max |diff| = %.6f. Attribute copies the game would have rebuilt (must be 0): %d." % [int(D["same"]), int(D["tried"]), float(D["guard_diff"]), int(D["dirty"])], "",
		"## 1. Who they are", "", "| Boxer | Style | Power | Speed | Natural stance | In his feet | One step off | Two steps off |", "| :--- | :--- | ---: | ---: | :--- | :--- | :--- | :--- |"])
	for id in BOXERS:
		var t: Dictionary = people[id]["t"]; var nat := int(people[id]["nat"])
		var by := {0: [], 1: [], 2: []}
		for fam in FREE:
			(by[absi(nat - int(SUIT[FAM_HANDS[fam]]))] as Array).append(FAMILY_WORDS[fam])
		_say("| %s | %s | %.0f | %.0f | %s | %s | %s | %s |" % [t["name"], t["style"], float(t["stats"]["power"]), float(t["stats"]["speed"]), WIDTHS[nat + 1],
			", ".join(by[0]) if not (by[0] as Array).is_empty() else "-", ", ".join(by[1]) if not (by[1] as Array).is_empty() else "-", ", ".join(by[2]) if not (by[2] as Array).is_empty() else "-"])
	# ---- the opponent cells
	_say(["", "## 2. Every opponent cell: wins in 100 bouts by pair (+- one standard error)", ""])
	var best_count := {}; var n_clear := 0; var nat_cells := 0; var tow_cells := 0
	var sum_rows: Array = ["| Cell | Today's game (%d seeds) | No guard line | Best pair | Wins | Against no line | Inside the noise of the best |" % abl, "| :--- | ---: | ---: | :--- | ---: | ---: | :--- |"]
	for id in ids:
		var W: Dictionary = C[id]["w"]
		_say(["### %s" % id, "", "| | natural stance | a step toward it (not owned) | line fired a bout (natural) |", "| :--- | ---: | ---: | ---: |"])
		var by := {}
		for fam in FAMILY_ORDER:
			var row := "| %s |" % FAMILY_WORDS[fam]
			for sh in [0, 1]:
				var k := _key(fam, sh)
				if W.has(k):
					by[k] = W[k]
					var w := _wr(W[k])
					row += " %.1f +- %.1f |" % [float(w[0]), float(w[1])]
				else:
					row += " - |"
			_say(row + " %.1f |" % (float(C[id]["fired"][_key(fam, 0)]) / per))
		var b := _best(by)
		for k in b["bests"]:
			best_count[k] = int(best_count.get(k, 0)) + 1
		var clear := (b["bests"] as Array).size() == 1 and (b["ties"] as Array).is_empty()
		n_clear += int(clear)
		var on_nat := false; var on_tow := false
		for k in b["bests"]:
			on_nat = on_nat or str(k).ends_with("@+0")
			on_tow = on_tow or str(k).ends_with("@+1")
		nat_cells += int(on_nat); tow_cells += int(on_tow)
		var bn: Array = (b["bests"] as Array).map(func(k): return _kname(str(k)))
		var tn: Array = (b["ties"] as Array).map(func(k): return _kname(str(k)))
		_say(["", "Best: **%s** (%.1f)%s." % [" = ".join(bn), float(b["top"]), " - CLEAR" if clear else "; inside two standard errors of it: " + ("-" if tn.is_empty() else "; ".join(tn))], ""])
		sum_rows.append("| %s | %.1f | %.1f | %s | %.1f | %s | %s |" % [id, float(_wr(C[id]["ctrl"])[0]), float(_wr(W["NONE@+0"])[0]), " = ".join(bn), float(b["top"]), _pm(_d(W[b["bests"][0]], W["NONE@+0"])), "CLEAR" if clear else ("-" if tn.is_empty() else "; ".join(tn))])
	_say(["## 3. The summary by opponent cell", ""]); _say(sum_rows)
	var top := 0; var bc: Array = []
	for k in best_count:
		top = maxi(top, int(best_count[k])); bc.append("%s %d" % [_kname(str(k)), int(best_count[k])])
	_say(["", "Best counts: %s. The most any one pair wins: %d of %d cells (bar: %d or fewer)." % ["; ".join(bc), top, ids.size(), int(BARS["top"])],
		"Cells with a clear best (every other pair more than two standard errors under it, seed by seed): %d of %d (bar: %d or more)." % [n_clear, ids.size(), int(BARS["clear"])],
		"Cells whose best pair is on the natural stance (or no line): %d of %d; on a stance moved a step: %d of %d (bar: 1 or more each way)." % [nat_cells, ids.size(), tow_cells, ids.size()], ""])
	# ---- the cost: the same line FREE (v7) against PAID on the natural stance
	_say(["## 4. What a guard line costs: the same line free (v7's rule, no feet) against paid, on the natural stance", "",
		"| Cell | High: free | paid | the feet cost | Elbows in: free | paid | the feet cost | Light: free | paid | the feet cost |", "| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
	var all_paid := ""; var all_free := ""; var cells3 := 0; var under_none := 0
	for id in ids:
		var W: Dictionary = C[id]["w"]; var row := "| %s |" % id; var worst := 999.0; var lost := false
		for fam in FREE:
			var paid: String = W[_key(fam, 0)]; var free: String = W["FREE:" + fam]
			var dd := _d(paid, free)
			worst = minf(worst, float(dd[0]))
			lost = lost or float(_d(paid, W["NONE@+0"])[0]) <= 0.0
			all_paid += paid; all_free += free
			row += " %s | %s | %s |" % ["%+.1f" % float(_d(free, W["NONE@+0"])[0]), "%+.1f" % float(_d(paid, W["NONE@+0"])[0]), _pm(dd)]
		cells3 += int(worst <= -3.0); under_none += int(lost)
		_say(row)
	var pc := _d(all_paid, all_free)
	var b_cost := float(pc[0]) <= -float(BARS["cost"]) and -float(pc[0]) > 2.0 * float(pc[1]) and cells3 >= int(BARS["cost_cells"])
	_say(["", "(free and paid are against no guard line, wins in 100, all seven boxers; a boxer in the guard's feet pays nothing.) Pooled over the cells and the three guards: paid against free %s wins in 100 (bar: %.1f or more under, beyond two standard errors). Cells where some guard is 3+ under its free twin: %d of %d (bar: %d or more). Cells where some paid guard on the natural stance does not beat no guard line at all: %d of %d." % [_pm(pc), float(BARS["cost"]), cells3, ids.size(), int(BARS["cost_cells"]), under_none, ids.size()], ""])
	# ---- by boxer: his best pair against each style (amateur + pro pooled)
	_say(["## 5. By boxer: his best pair against each opponent style (amateur + pro, %d bouts a pair)" % (2 * seeds), "",
		"| Boxer | Natural | %s | Guards that are his best | Changes beyond the noise |" % " | ".join(STYLES), "| :--- | :--- | %s :--- | :--- |" % ":--- | ".repeat(STYLES.size())])
	var n_change := 0; var n_cross := 0; var bx_nat := 0; var bx_tow := 0
	var G := {-1: {}, 0: {}, 1: {}}
	for bi in nb:
		var nat := int(people[BOXERS[bi]]["nat"])
		var BY: Array = []; var bk: Array = []; var row := "| %s | %s |" % [people[BOXERS[bi]]["t"]["first"], WIDTHS[nat + 1]]
		var fams := {}
		for si in STYLES.size():
			var by := {}
			for pr in PAIRS:
				var k := _key(str(pr[0]), int(pr[1])); var s := ""
				for sc in SCALES:
					s += str(C["%s / %s" % [STYLES[si], sc["id"]]]["w"][k]).substr(bi * seeds, seeds)
				if int(pr[1]) == 1 and _toward(bi, str(pr[0])) == 0: continue   # the same bouts as his natural stance
				by[k] = s
				if not (G[nat] as Dictionary).has(si): G[nat][si] = {}
				G[nat][si][k] = str((G[nat][si] as Dictionary).get(k, "")) + s
			var b := _best(by)
			var k0 := str(b["bests"][0])
			BY.append(by); bk.append(k0); fams[_fam(k0)] = true
			bx_nat += int(k0.ends_with("@+0")); bx_tow += int(k0.ends_with("@+1"))
			row += " %s (%.1f, %s) |" % [_short(k0), float(b["top"]), "%+.1f" % float(_d(by[k0], by["NONE@+0"])[0])]
		var cross := ""; var ratio := 0.0
		for s1 in STYLES.size():
			for s2 in STYLES.size():
				var A := str(bk[s1]); var B := str(bk[s2])
				if s1 == s2 or _fam(A) == _fam(B) or not (BY[s2] as Dictionary).has(A) or not (BY[s1] as Dictionary).has(B): continue
				var d1 := _d(BY[s1][A], BY[s1][B]); var d2 := _d(BY[s2][A], BY[s2][B])
				var swing := float(d1[0]) - float(d2[0]); var se := sqrt(float(d1[1]) * float(d1[1]) + float(d2[1]) * float(d2[1]))
				if se > 0.0 and swing / se > ratio:
					ratio = swing / se
					cross = "%s vs %s: %+.1f +- %.1f" % [STYLES[s1], STYLES[s2], swing, se]
		n_change += int(fams.size() >= 2); n_cross += int(ratio > 2.0)
		var fw: Array = fams.keys().map(func(k): return FAMILY_WORDS[k])
		_say(row + " %s | %s |" % [", ".join(fw), ("yes (%s)" % cross) if ratio > 2.0 else ("no (%s)" % (cross if cross != "" else "one guard"))])
	_say(["", "(each cell: best pair (wins in 100, against no guard line). The change: the best pair against one style over the best pair against another, on both styles' bouts; a swing more than two standard errors = beyond the noise. The best of several pairs on the same bouts flatters it a little.)",
		"Boxers whose best guard is not the same against all five styles: %d of %d (bar: all). Boxers for whom that change is beyond the noise: %d of %d (bar: %d or more)." % [n_change, nb, n_cross, nb, int(BARS["cross"])],
		"Of the %d boxer x style cells the best pair is on the natural stance (or no line) in %d and on a stance moved a step in %d." % [nb * STYLES.size(), bx_nat, bx_tow], "",
		"### By natural stance x opponent style (the boxers of a stance pooled)", "", "| Natural stance | %s |" % " | ".join(STYLES), "| :--- | %s" % ":--- | ".repeat(STYLES.size())])
	var g_clear := 0
	for nat in [-1, 0, 1]:
		var row := "| %s |" % WIDTHS[nat + 1]
		for si in STYLES.size():
			var b := _best(G[nat][si])
			var clear := (b["bests"] as Array).size() == 1 and (b["ties"] as Array).is_empty()
			g_clear += int(clear)
			row += " %s (%.1f)%s |" % [_short(str(b["bests"][0])), float(b["top"]), " CLEAR" if clear else ""]
		_say(row)
	_say(["", "Stance x style cells with a clear best: %d of 15 (no bar; read beside bar 4)." % g_clear, ""])
	# ---- each effect switched off
	_say(["## 6. Does each effect move the result? (the effect off on its test pairs, %d seeds, the same dice as with it on)" % abl, "",
		"| Effect off | Test pairs | Bouts whose result changed, in 100 | Wins in 100 with it off against on | Moves it (2 in 100 or more) |", "| :--- | :--- | ---: | ---: | :--- |"])
	var all_move := true
	for ef in EFFECTS:
		var changed := 0.0; var total := 0.0; var s_off := ""; var s_on := ""
		for pr in EFFECTS[ef]:
			var k := _key(str(pr[0]), int(pr[1]))
			for id in ids:
				var o: String = C[id]["abl"][ef][k]; var w: String = C[id]["w"][k]
				for bi in nb:
					for s in abl:
						var a := o[bi * abl + s]; var b := w[bi * seeds + s]
						total += 1.0; changed += float(a != b); s_off += a; s_on += b
		var share := 100.0 * changed / maxf(1.0, total)
		all_move = all_move and share >= 2.0
		_say("| %s | %s | %.1f | %s | %s |" % [EFFECT_WORDS[ef], "; ".join((EFFECTS[ef] as Array).map(func(pr): return _pname(str(pr[0]), int(pr[1])))), share, _pm(_d(s_off, s_on)), "yes" if share >= 2.0 else "NO"])
	var b_style := n_change == nb and n_cross >= int(BARS["cross"])
	var b_nat := nat_cells >= 1 and tow_cells >= 1
	var bars := [all_move, b_cost, top <= int(BARS["top"]), n_clear >= int(BARS["clear"]), b_style, b_nat]
	var ok := not bars.has(false) and int(D["dirty"]) == 0
	_say(["", "(all seven boxers are in every row; a boxer in the guard's feet has nothing to switch off, so the shares are diluted by them.)", "",
		"## 7. Bars (written in the probe before the run)", "",
		"- 1 every effect moves the result: %s." % ("PASS" if all_move else "FAIL"),
		"- 2 a guard line costs something measurable: %s wins in 100 against free, %d cells 3+ under = %s." % [_pm(pc), cells3, "PASS" if b_cost else "FAIL"],
		"- 3 no pair best in more than %d of 10 cells: %d = %s." % [int(BARS["top"]), top, "PASS" if top <= int(BARS["top"]) else "FAIL"],
		"- 4 four or more cells clear of the noise: %d = %s." % [n_clear, "PASS" if n_clear >= int(BARS["clear"]) else "FAIL"],
		"- 5 the best guard changes with the opponent's style for every boxer: %d of %d change, %d beyond the noise = %s." % [n_change, nb, n_cross, "PASS" if b_style else "FAIL"],
		"- 6 the natural stance is best in some cells and beaten in others: best in %d, beaten in %d of %d = %s." % [nat_cells, tow_cells, ids.size(), "PASS" if b_nat else "FAIL"],
		"", "%d bouts played in %.0f s." % [int(D["bouts"]), float(D["took"])], "",
		"RESULT: tools/guardprobe10.gd -> %s (effects %s; cost %s, %d cells 3+; top pair best in %d of %d cells; %d of %d cells clear; best guard changes for %d of %d boxers, %d beyond the noise; natural best in %d cells, a moved stance in %d)" % ["PASS" if ok else "FAIL",
			"all move" if all_move else "NOT all move", _pm(pc), cells3, top, ids.size(), n_clear, ids.size(), n_change, nb, n_cross, nat_cells, tow_cells]])

func _secs() -> float: return float(Time.get_ticks_msec() - t0) / 1000.0

func _say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s); L.append(s)
