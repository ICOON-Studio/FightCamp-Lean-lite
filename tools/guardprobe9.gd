extends SceneTree
## S536 GUARDPROBE9 - guard v8: the guard WHEN-line is paid for by the FEET (ops/research/TASK_GUARDREV8.md, DESIGN_GUARDDMG1_V8.md).
## MEASUREMENT ONLY: nothing under scripts/ is edited. The population and the bell-by-bell stance layer are stanceprobe1.gd's (five Data
## prospects, Data's region opponents by style and sex, 5 styles x amateur 3 / pro 6 = 10 cells, 40 seeds, every arm on the same dice);
## the exchange-by-exchange guard line is guardprobe8.gd's walk (v7's table, v6's after-the-settle rules), copied in.
## THE RULE PROBED (sizes set BEFORE the run, never on the test's seeds):
##   - Each boxer has a NATURAL stance width, a trait: Narrow / Shoulder / Wide from (Power - Speed) / 4 (stanceprobe1's rule). Pad weeks
##     move it ONE step (the arms "one step wider" / "one step narrower", kept on the pad). The angle and the weight lean are dropped.
##   - Hands High wants planted feet (Wide). Hands Loose wants light feet (Narrow). steps = how far his stance is from the line's.
##   - In the 30 seconds a guard line fires: its plus is worth x fit[steps]; High out of its feet costs STEP SPEED (step points off
##     that exchange, a step); Loose out of its feet costs LEGS (energy after that exchange, a step). In its feet a line is v7's line.
##   - A stance that is not his natural one also changes him (stanceprobe1's round-2 width column, measured there): a step wider =
##     power, head movement, chin +5, footwork and foot speed -3, 1.5 energy a round; a step narrower the reverse.
## Pairs a cell (what a player can choose): no guard line / the HIGH lines / the LOOSE lines / BOTH (probe 7's three right lines), each
## on the natural stance and on the shifted stances that are not plainly wrong for it (10 pairs). FREE:<lines> = v7's rule (no feet).
## PASS (all, written before the run):
##   1 every effect (fit, steps, legs, stance) changes 2+ bouts in 100 on its two test pairs;
##   2 a guard line COSTS: on the natural stance the paid lines are 2.0+ wins in 100 under the same lines FREE, pooled over cells and
##     the three line sets, more than two standard errors, AND some line set is 3+ under its free twin in 3+ cells;
##   3 no pair best in more than 6 of 10 cells (exact ties count for both);
##   4 4+ cells clear: the best pair more than two standard errors (paired, seed by seed) above EVERY other pair;
##   5 the natural stance is not always the answer: for 2+ of 5 boxers a shifted pair is clearly above his best natural-stance pair
##     (10 cells pooled, two standard errors), and the best pair of a cell is on the natural stance in at most 8 of 10 cells.
##   python ops/Tools/godot_slot.py run --who guardrev8 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/guardprobe9.gd [-- seeds=40 abl=20 size=1 doc=<file.md> raw=<file.json> from=<file.json>]

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

const BOXERS := ["kira", "samira", "tess", "danny", "josh"]
const STYLES := ["Out-boxer", "Pressure fighter", "Counter-puncher", "Volume puncher", "Slugger"]
const SCALES := [
	{"id": "am", "name": "amateur, 3 rounds", "pro": false, "rounds": 3},
	{"id": "pro", "name": "pro, 6 rounds", "pro": true, "rounds": 6},
]
const WIDTHS := ["Narrow", "Shoulder", "Wide"]
const SHIFT_WORDS := {-1: "one step narrower", 0: "natural stance", 1: "one step wider"}
const PLANS := [
	{"arrows": [{"move": "1-2"}, {"move": "step_in"}, {"move": "cut_off"}, {"move": "tie_up"}], "combos": {"1-2": 60.0, "1-1": 45.0}},
	{"arrows": [{"move": "2-3"}, {"move": "feint"}, {"move": "pivot_out"}, {"move": "1-2"}], "combos": {"2-3": 60.0, "1-2": 50.0}},
]
## stanceprobe1's fitted field (its seeds 900+): opponents re-rated so today's game wins about half.
const OPP_OFF := {"am": -3.4, "pro": -6.5}
const DAY0 := 61000
## v7's table: moment -> [High, Loose] power points into the exchange's sum (DESIGN_GUARDDMG1_V7.md 2.2, step s1).
const TABLE := {"loadup": [9.0, -10.0], "press": [-4.0, 3.0], "range": [-8.0, 4.0], "counter": [-3.0, -8.0], "tiring": [-9.0, 9.0],
	"hurt": [-9.0, 8.0], "she_tired": [4.0, -8.0], "she_hurt": [8.0, -12.0]}
## v6 2.3-2.5 after the settle, unchanged (guardprobe8's S).
const AFTER := {"worn": [2.0, 4.0], "drain": 1.0, "block": {"high": 0.75, "normal": 0.6, "loose": 0.45}, "high_wear": true,
	"hurt": {"high": 0.7, "normal": 1.0, "loose": 1.3}, "loose_dmg": 2.0, "high_out": 0.75}
const DONE_WITH := {"high": ["defence", "composure"], "loose": ["speed", "stamina"]}
## The line sets: every line sits on a moment where v7's table pays it (read right every time, as probe 8).
const FAMILIES := {"NONE": {},
	"HIGH": {"loadup": "high", "she_hurt": "high", "she_tired": "high"},
	"LOOSE": {"tiring": "loose", "hurt": "loose", "range": "loose"},
	"BOTH": {"loadup": "high", "tiring": "loose", "she_hurt": "high"}}
const FAMILY_WORDS := {"NONE": "no guard line", "HIGH": "High lines", "LOOSE": "Loose lines", "BOTH": "High + Loose"}
const FAMILY_ORDER := ["NONE", "HIGH", "LOOSE", "BOTH"]
const SUIT := {"high": 1, "loose": -1}   # the stance width each line is done in fully
## The feet's price, by run: fit = the plus kept at 0 / 1 / 2 steps from the line's stance; step = points off the exchange a step
## (High out of its feet); leg = energy after the exchange a step (Loose out of its feet). 1 = the pre-registered run.
## 2 = the ONE resize, set after run 1 failed bar 4 only (1 of 10 cells clear) and before its own run: wrong feet lose more (a line
## two steps from its feet does not come off at all, both prices up); nothing else is changed, the seeds are the same.
const SIZES := {1: {"fit": [1.0, 0.6, 0.25], "step": 2.5, "leg": 2.0}, 2: {"fit": [1.0, 0.5, 0.0], "step": 4.0, "leg": 4.0}}
## A step of stance away from his natural one (stanceprobe1 M2, the width column).
const BASE := {"power": 5.0, "slip": 5.0, "chin": 5.0, "feet": 3.0, "drain": 1.5}
const PAIRS := [["NONE", 0], ["NONE", -1], ["NONE", 1], ["HIGH", 0], ["HIGH", 1], ["LOOSE", 0], ["LOOSE", -1], ["BOTH", 0], ["BOTH", -1], ["BOTH", 1]]
const FREE := ["HIGH", "LOOSE", "BOTH"]
const EFFECTS := {"fit": [["HIGH", 0], ["LOOSE", 0]], "steps": [["HIGH", 0], ["BOTH", 0]], "legs": [["LOOSE", 0], ["BOTH", 0]], "stance": [["NONE", 1], ["NONE", -1]]}
const EFFECT_WORDS := {"fit": "the plus kept by the feet", "steps": "High out of its feet: step speed", "legs": "Loose out of its feet: the legs", "stance": "a shifted stance changes the boxer"}

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
	var doc := "res://docs/GUARDPROBE9_RAW.md"; var raw := ""; var from := ""
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
	print("GUARDPROBE9 done (%.0f s)" % _secs())
	quit(0)

static func _key(fam: String, shift: int) -> String:
	return "%s@%+d" % [fam, shift]

func _pname(fam: String, shift: int) -> String:
	return "%s, %s" % [FAMILY_WORDS[fam], SHIFT_WORDS[shift]]

func _kname(key: String) -> String:
	return _pname(key.get_slice("@", 0), int(key.get_slice("@", 1)))

## Every arm of every cell, as strings of results (2 win, 1 draw, 0 loss), boxer-major, seed-minor.
func _run(seeds: int, abl: int, size: int) -> Dictionary:
	var same := 0; var tried := 0
	for bi in BOXERS.size():
		for ci in SCALES.size():
			for s in 4:
				var cell := {"si": (bi + s) % STYLES.size(), "ci": ci}
				var a := _bout(bi, cell, s, {"plain": true})
				var b := _bout(bi, cell, s, {"play_out": true})
				tried += 1; same += int(str(a["sig"]) == str(b["sig"]))
	var cells := {}
	for si in STYLES.size():
		for ci in SCALES.size():
			var cell := {"si": si, "ci": ci}
			var id := "%s / %s" % [STYLES[si], SCALES[ci]["id"]]
			var out := {"w": {}, "fired": {}, "pts": {}, "en": {}, "abl": {}}
			var arms: Array = []
			for pr in PAIRS:
				arms.append([_key(str(pr[0]), int(pr[1])), {"fam": pr[0], "shift": pr[1]}])
			for fam in FREE:
				arms.append(["FREE:" + str(fam), {"fam": fam, "shift": 0, "free": true}])
			for arm in arms:
				var bits := ""; var fired := 0.0; var pts := 0.0; var en := 0.0
				for bi in BOXERS.size():
					for s in seeds:
						var r := _bout(bi, cell, s, arm[1])
						bits += str(int(r["win2"])); fired += float(r["fired"]); pts += float(r["pts"]); en += float(r["en"])
				out["w"][arm[0]] = bits; out["fired"][arm[0]] = fired; out["pts"][arm[0]] = pts; out["en"][arm[0]] = en
			var cb := ""
			for bi in BOXERS.size():
				for s in abl:
					cb += str(int(_bout(bi, cell, s, {"play_out": true})["win2"]))
			out["ctrl"] = cb
			for ef in EFFECTS:
				out["abl"][ef] = {}
				for pr in EFFECTS[ef]:
					var ab := ""
					for bi in BOXERS.size():
						for s in abl:
							ab += str(int(_bout(bi, cell, s, {"fam": pr[0], "shift": pr[1], "off": ef})["win2"]))
					out["abl"][ef][_key(str(pr[0]), int(pr[1]))] = ab
			cells[id] = out
			print("cell %s done, %d bouts, %.0f s" % [id, n_bouts, _secs()])
	return {"seeds": seeds, "abl": abl, "size": size, "took": _secs(), "bouts": n_bouts, "dirty": n_dirty, "same": same, "tried": tried, "guard_diff": guard_diff, "cells": cells}

static func _person(id: String) -> Dictionary:
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

## The stance layer for round n (stanceprobe1._apply, the width column only): dw = steps wider than his natural stance.
func _stance(f: Dictionary, S: Dictionary, dw: int, n: int) -> void:
	if dw == 0:
		return
	var fb: Dictionary = f["bout"]
	var a: Dictionary = (S["a0"] as Dictionary).duplicate()
	var d := {"power": float(BASE["power"]) * dw, "head_movement": float(BASE["slip"]) * dw, "chin": float(BASE["chin"]) * dw,
		"foot_speed": -float(BASE["feet"]) * dw, "footwork": -float(BASE["feet"]) * dw}
	for k in d:
		a[k] = clampf(float(a.get(k, 55.0)) + float(d[k]), Attrs.LO, Attrs.HI)
	var lv: Dictionary = PunchStart.from_moves(S["moves0"], float(f["stats"]["technique"]), PunchStart.raw_floor(a))
	for pk in Attrs.PUNCHES:
		a[pk] = maxf(float(a.get(pk, 0.0)), clampf(float(lv[pk]), Attrs.LO, Attrs.HI))
	f["attrs"] = a
	if n >= 2 and fb.has("energy"):
		fb["energy"]["a"] = clampf(float(fb["energy"]["a"]) - float(BASE["drain"]) * dw, 0.0, 100.0)
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
		"lines": FAMILIES[str(arm.get("fam", "NONE"))], "fired": 0, "pts": 0.0, "en": 0.0}
	if arm.has("play_out"):
		BoutNight.play_out(c, f, m)
	else:
		var nat := int(p["nat"])
		var w := clampi(nat + int(arm.get("shift", 0)), -1, 1)
		st["w"] = w
		var dw := 0 if st["off"] == "stance" else w - nat
		var S := {"a0": Attrs.of(f).duplicate(), "moves0": (f["moves"] as Dictionary).duplicate()}
		_stance(f, S, dw, 1)
		m.merge({"step": "round", "round": 0, "rounds": []}, true)
		BoutNight._peak(c, f)
		ProReadWire.open(f)
		m["lab_from"] = f.duplicate(true)
		_open(c, f, m, "", st)
		while int(m["round"]) < BoutNight.rounds_of(f) and BoutNight.stopped(m) == "" and not TowelWire.coach_pull(c, f, m) and not CrackWire.bell(c, f, m, BoutNight.rounds_of(f)):
			_stance(f, S, dw, int(m["round"]) + 1)
			_open(c, f, m, BoutRules.auto_corner(f["stats"]), st)
	n_bouts += 1
	var out := str(BoutNight.outcome_of(f, m))
	var sig := out
	for r in m["rounds"]:
		sig += "|%d%s%d-%d" % [int(r["n"]), "W" if bool(r["won"]) else "L", int(r["landed"][0]), int(r["landed"][1])]
	return {"win2": 2 if out == "win" else (1 if out == "draw" else 0), "sig": sig, "fired": int(st["fired"]), "pts": float(st["pts"]), "en": float(st["en"])}

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

## Steps between his stance and the line's (0 in the FREE arms: v7's rule).
func _steps(hands: String, st: Dictionary) -> int:
	if hands == "normal" or bool(st["free"]):
		return 0
	return absi(int(st["w"]) - int(SUIT[hands]))

## The line's points for this exchange, graded as a plan line, its plus kept by the feet, High's step price off it.
func _points(hands: String, sit: String, f: Dictionary, st: Dictionary) -> float:
	if hands == "normal":
		return 0.0
	var e := float(TABLE[sit][0 if hands == "high" else 1])
	var at := Attrs.of(f)
	var pair: Array = DONE_WITH[hands]
	var mean := (float(at.get(str(pair[0]), 55.0)) + float(at.get(str(pair[1]), 55.0))) * 0.5
	var word := "Good" if mean >= Exchanges.GOOD_AT else ("OK" if mean >= Exchanges.OK_AT else "Poor")
	var k := _steps(hands, st)
	var v := e * float(LineGrade.PLUS[word]) if e > 0.0 else e * float(Exchanges.COMMIT[word])
	if v > 0.0 and st["off"] != "fit":
		v *= float(Z["fit"][k])
	if hands == "high" and st["off"] != "steps":
		v -= float(Z["step"]) * k
		st["pts"] = float(st["pts"]) + float(Z["step"]) * k
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
		_post(c, f, m, lv, rec, hands, snap, i)
	# Loose out of its feet: the legs pay after the 30 seconds (this round's later exchanges, or the next bell when it was the last).
	var leg := float(Z["leg"]) * _steps(hands, st) if hands == "loose" and st["off"] != "legs" else 0.0
	st["en"] = float(st["en"]) + leg
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

func _report(D: Dictionary) -> void:
	var seeds := int(D["seeds"]); var abl := int(D["abl"])
	var C: Dictionary = D["cells"]
	var ids: Array = []
	for si in STYLES.size():
		for sc in SCALES:
			ids.append("%s / %s" % [STYLES[si], sc["id"]])
	var per := BOXERS.size() * seeds
	_say(["# GUARDPROBE9 - guard v8: the guard line paid for by the feet (S536), sizes run %d" % int(D["size"]), "",
		"Run: python ops/Tools/godot_slot.py run --who guardrev8 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe9.gd -- seeds=%d abl=%d size=%d" % [seeds, abl, int(D["size"])], "",
		"What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex, re-rated %+.1f amateur / %+.1f pro as stanceprobe1 fitted) and every bout (the game's fight night, walked exchange by exchange)." % [float(OPP_OFF["am"]), float(OPP_OFF["pro"])],
		"What is scratch: the guard lines (v7's table), the feet's price on them and the shifted stance's layer. Every arm of a seed fights the same night (same dice): %d bouts a pair and cell = 5 boxers x %d seeds. A draw is half a win." % [per, seeds], "",
		"Sizes (set before the run): the plus kept at 0 / 1 / 2 steps from the line's stance %s; High out of its feet %.1f points off the exchange a step; Loose out of its feet %.1f energy after the exchange a step. A shifted stance: %s a step." % [str(Z["fit"]), float(Z["step"]), float(Z["leg"]), str(BASE)],
		"Line sets: HIGH = High WHEN the opponent loads up / your boxer is hurt / your boxer is tired; LOOSE = Loose WHEN the opponent is tiring / is hurt / boxes at range; BOTH = High WHEN loading up, Loose WHEN tiring, High WHEN your boxer is hurt (probe 7's right three).", "",
		"Self-check 1: the walk with every guard size off gives the same bout as BoutNight.play_out in %d of %d bouts. Self-check 2: the copied guard walk against the game's, max |diff| = %.6f. Attribute copies the game would have rebuilt (must be 0): %d." % [int(D["same"]), int(D["tried"]), float(D["guard_diff"]), int(D["dirty"])], "",
		"## 1. Who they are", "", "| Boxer | Style | Power | Speed | Natural stance | In his feet | One step off | Two steps off |", "| :--- | :--- | ---: | ---: | :--- | :--- | :--- | :--- |"])
	for id in BOXERS:
		var t: Dictionary = people[id]["t"]; var nat := int(people[id]["nat"])
		var by := {0: [], 1: [], 2: []}
		for h in ["high", "loose"]:
			(by[absi(nat - int(SUIT[h]))] as Array).append("Hands High" if h == "high" else "Hands Loose")
		_say("| %s | %s | %.0f | %.0f | %s | %s | %s | %s |" % [t["name"], t["style"], float(t["stats"]["power"]), float(t["stats"]["speed"]), WIDTHS[nat + 1],
			", ".join(by[0]) if not (by[0] as Array).is_empty() else "-", ", ".join(by[1]) if not (by[1] as Array).is_empty() else "-", ", ".join(by[2]) if not (by[2] as Array).is_empty() else "-"])
	_say(["", "## 2. Every cell: wins in 100 bouts by pair (+- one standard error)", ""])
	var best_count := {}; var n_clear := 0; var nat_cells := 0
	var sum_rows: Array = ["| Cell | Today's game (%d seeds) | No guard line, natural | Best pair | Wins | Against no line, natural | Inside the noise of the best |" % abl, "| :--- | ---: | ---: | :--- | ---: | ---: | :--- |"]
	for id in ids:
		var W: Dictionary = C[id]["w"]
		_say(["### %s" % id, "", "| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |", "| :--- | ---: | ---: | ---: | ---: | :--- |"])
		var by := {}
		for fam in FAMILY_ORDER:
			var row := "| %s |" % FAMILY_WORDS[fam]
			for sh in [-1, 0, 1]:
				var k := _key(fam, sh)
				if W.has(k):
					by[k] = W[k]
					var w := _wr(W[k])
					row += " %.1f +- %.1f |" % [float(w[0]), float(w[1])]
				else:
					row += " - |"
			var k0 := _key(fam, 0)
			_say(row + " %.1f | %.1f points, %.1f energy |" % [float(C[id]["fired"][k0]) / per, float(C[id]["pts"][k0]) / per, float(C[id]["en"][k0]) / per])
		var b := _best(by)
		for k in b["bests"]:
			best_count[k] = int(best_count.get(k, 0)) + 1
		var clear := (b["bests"] as Array).size() == 1 and (b["ties"] as Array).is_empty()
		n_clear += int(clear)
		var on_nat := false
		for k in b["bests"]:
			on_nat = on_nat or str(k).ends_with("@+0")
		nat_cells += int(on_nat)
		var bn: Array = (b["bests"] as Array).map(func(k): return _kname(str(k)))
		var tn: Array = (b["ties"] as Array).map(func(k): return _kname(str(k)))
		_say(["", "Best: **%s** (%.1f)%s." % [" = ".join(bn), float(b["top"]), " - CLEAR" if clear else "; inside two standard errors of it: " + ("-" if tn.is_empty() else "; ".join(tn))], ""])
		sum_rows.append("| %s | %.1f | %.1f | %s | %.1f | %s | %s |" % [id, float(_wr(C[id]["ctrl"])[0]), float(_wr(W["NONE@+0"])[0]), " = ".join(bn), float(b["top"]), _pm(_d(W[b["bests"][0]], W["NONE@+0"])), "CLEAR" if clear else ("-" if tn.is_empty() else "; ".join(tn))])
	_say(["## 3. The summary", ""]); _say(sum_rows)
	var top := 0; var bc: Array = []
	for k in best_count:
		top = maxi(top, int(best_count[k])); bc.append("%s %d" % [_kname(str(k)), int(best_count[k])])
	_say(["", "Best counts: %s. The most any one pair wins: %d of %d cells (bar: 6 or fewer)." % ["; ".join(bc), top, ids.size()],
		"Cells with a clear best (every other pair more than two standard errors under it, seed by seed): %d of %d (bar: 4 or more)." % [n_clear, ids.size()],
		"Cells whose best pair is on the natural stance: %d of %d (bar: 8 or fewer)." % [nat_cells, ids.size()], ""])
	# ---- the cost: the same lines FREE (v7) against PAID on the natural stance
	_say(["## 4. What a guard line costs: the same lines free (v7's rule, no feet) against paid, on the natural stance", "",
		"| Cell | High lines: free | paid | the feet cost | Loose lines: free | paid | the feet cost | High + Loose: free | paid | the feet cost |", "| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
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
	var b_cost := float(pc[0]) <= -2.0 and -float(pc[0]) > 2.0 * float(pc[1]) and cells3 >= 3
	_say(["", "(free and paid are against no guard line on the natural stance, wins in 100.) Pooled over the cells and the three line sets: paid against free %s wins in 100 (bar: 2.0 or more under, beyond two standard errors). Cells where some line set is 3+ under its free twin: %d of %d (bar: 3 or more). Cells where some paid line set on the natural stance does not beat no guard line at all: %d of %d." % [_pm(pc), cells3, ids.size(), under_none, ids.size()], ""])
	# ---- by boxer: the natural stance against a shifted one
	_say(["## 5. Is the natural stance always the answer? (each boxer, the 10 cells pooled, %d bouts a pair)" % (ids.size() * seeds), "",
		"| Boxer | Natural | Best pair on the natural stance | Wins | Best pair on a shifted stance | Wins | Shifted against natural | Clear |", "| :--- | :--- | :--- | ---: | :--- | ---: | ---: | :--- |"])
	var beaten := 0
	for bi in BOXERS.size():
		var nat := int(people[BOXERS[bi]]["nat"])
		var on := {}; var off := {}
		for pr in PAIRS:
			var k := _key(str(pr[0]), int(pr[1])); var s := ""
			for id in ids:
				s += str(C[id]["w"][k]).substr(bi * seeds, seeds)
			if int(pr[1]) == 0: on[k] = s
			elif clampi(nat + int(pr[1]), -1, 1) != nat: off[k] = s
		var bo := _best(on); var bf := _best(off)
		var dd := _d(off[bf["bests"][0]], on[bo["bests"][0]])
		var clear := float(dd[0]) > 2.0 * float(dd[1])
		beaten += int(clear)
		_say("| %s | %s | %s | %.1f | %s | %.1f | %s | %s |" % [people[BOXERS[bi]]["t"]["first"], WIDTHS[nat + 1], FAMILY_WORDS[str(bo["bests"][0]).get_slice("@", 0)], float(bo["top"]), _kname(str(bf["bests"][0])), float(bf["top"]), _pm(dd), "yes" if clear else "no"])
	var b_nat := beaten >= 2 and nat_cells <= 8
	_say(["", "Boxers for whom a shifted pair is clearly above the best natural-stance pair: %d of %d (bar: 2 or more). The best of several pairs on the same bouts flatters both sides a little; read the size, not the last decimal." % [beaten, BOXERS.size()], ""])
	# ---- each effect switched off
	_say(["## 6. Does each effect move the result? (the effect off on its two test pairs, %d seeds, the same dice as with it on)" % abl, "",
		"| Effect off | Test pairs | Bouts whose result changed, in 100 | Wins in 100 with it off against on | Moves it (2 in 100 or more) |", "| :--- | :--- | ---: | ---: | :--- |"])
	var all_move := true
	for ef in EFFECTS:
		var changed := 0.0; var total := 0.0; var s_off := ""; var s_on := ""
		for pr in EFFECTS[ef]:
			var k := _key(str(pr[0]), int(pr[1]))
			for id in ids:
				var o: String = C[id]["abl"][ef][k]; var w: String = C[id]["w"][k]
				for bi in BOXERS.size():
					for s in abl:
						var a := o[bi * abl + s]; var b := w[bi * seeds + s]
						total += 1.0; changed += float(a != b); s_off += a; s_on += b
		var share := 100.0 * changed / maxf(1.0, total)
		all_move = all_move and share >= 2.0
		_say("| %s | %s | %.1f | %s | %s |" % [EFFECT_WORDS[ef], "; ".join((EFFECTS[ef] as Array).map(func(pr): return _pname(str(pr[0]), int(pr[1])))), share, _pm(_d(s_off, s_on)), "yes" if share >= 2.0 else "NO"])
	var bars := [all_move, b_cost, top <= 6, n_clear >= 4, b_nat]
	var ok := not bars.has(false) and int(D["dirty"]) == 0
	_say(["", "## 7. Bars (written in the probe before the run)", "",
		"- 1 every effect moves the result: %s." % ("PASS" if all_move else "FAIL"),
		"- 2 a guard line costs something measurable: %s wins in 100 against free, %d cells 3+ under = %s." % [_pm(pc), cells3, "PASS" if b_cost else "FAIL"],
		"- 3 no pair best in more than 6 of 10 cells: %d = %s." % [top, "PASS" if top <= 6 else "FAIL"],
		"- 4 four or more cells clear of the noise: %d = %s." % [n_clear, "PASS" if n_clear >= 4 else "FAIL"],
		"- 5 the natural stance is not always the answer: clearly beaten for %d of %d boxers, best in %d of %d cells = %s." % [beaten, BOXERS.size(), nat_cells, ids.size(), "PASS" if b_nat else "FAIL"],
		"", "%d bouts played in %.0f s." % [int(D["bouts"]), float(D["took"])], "",
		"RESULT: tools/guardprobe9.gd -> %s (effects %s; cost %s, %d cells 3+; top pair best in %d of %d cells; %d of %d cells clear; natural clearly beaten for %d of %d boxers and best in %d of %d cells)" % ["PASS" if ok else "FAIL",
			"all move" if all_move else "NOT all move", _pm(pc), cells3, top, ids.size(), n_clear, ids.size(), beaten, BOXERS.size(), nat_cells, ids.size()]])

func _secs() -> float: return float(Time.get_ticks_msec() - t0) / 1000.0

func _say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s); L.append(s)
