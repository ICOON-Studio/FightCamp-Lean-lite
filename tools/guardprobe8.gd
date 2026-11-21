extends SceneTree
## S535 GUARDPROBE8 - guard v7: does a guard line cost a move line? The TRADE at the real line limit. MEASUREMENT ONLY: nothing under
## scripts/ is edited. guardprobe7.gd's walk, population, seeds and sizes (step s1), copied in; the coach is a NEW coach (rating 30:
## PlanBoard.arrow_limit = 4), so the four-move plan is FULL and a guard line must take a move line's place. Nothing else in the bout
## reads the coach's rating (BoutNight 196 writes a plan only when none is written).
## Arms a cell: CONTROL (BoutNight.play_out), BASE (the four moves, no guard line), DROP:k (move line k dropped, nothing in its place),
## SWAP:g:k (move line k swapped for guard line g, the three RIGHT lines of probe 7), ADD:g (g added as a fifth line: over the limit, the
## reference for what the slot costs), WSWAP (the weakest move line swapped for the wrong line High WHEN at range).
## PRE-REGISTERED READ (written before the run): the line given up is the plan's WEAKEST move line in that cell, found on the pilot's own
## seeds (9000-9099: the DROP arm that loses least), never on the test's. Bars on those three swaps a cell: (1) some swap beats BASE by 3+
## wins in 100 in at least 3 cells; (2) some swap loses to BASE by 3+ in at least 3 cells; (3) of the four legal plans (BASE + the three
## swaps) none is best in more than 7 of 12 cells (ties count for both). All 12 swaps a cell are printed beside it.
## plan=best (run B, added after run A showed the written plans carry lines that never fire): BASE is the best four lines the boxer can
## do and fire, picked one at a time on the pilot's seeds (_best_plan). docs/GUARDPROBE8_RESULT.md = both runs under one summary.
##   python ops/Tools/godot_slot.py run --who guardprobe8 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe8.gd -- n=200
##   user args: n=<bouts a cell>  plan=best  part=<k>/<m> out=<file.json> (cells k of m, saved)  merge=<a.json,b.json,..> doc=<file.md> (writes the result)  pilot (writes nothing)

const GP := preload("res://tools/guard_probe.gd")
const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const GuardState := preload("res://scripts/state/GuardState.gd")
const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const BoutBurn := preload("res://scripts/rules/BoutBurn.gd")
const BodyFacts := preload("res://scripts/rules/BodyFacts.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const ClinchRest := preload("res://scripts/rules/ClinchRest.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanAuto := preload("res://scripts/rules/PlanAuto.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")
const FilmNight := preload("res://scripts/state/FilmNight.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const SEED0 := 6000
const N := 200
const COACH := 30.0   ## a new coach: PlanBoard.arrow_limit(30) = 4 lines
const SEED_PILOT := 9000
const N_PILOT := 100
const BAR := 3.0
const MOMENTS := ["loadup", "press", "range", "counter", "tiring", "hurt", "she_tired", "she_hurt"]
## The three RIGHT guard lines of probe 7 [moment, action, words] and the wrong one.
const GUARD := [["loadup", "high", "High WHEN loading up"], ["tiring", "loose", "Loose WHEN tiring"], ["she_hurt", "high", "High WHEN your boxer is hurt"]]
const WRONG := ["range", "high", "High WHEN at range"]
## What a guard line is done with (LineGrade.DONE_WITH's form: two attributes, their mean grades it).
const DONE_WITH := {"high": ["defence", "composure"], "loose": ["speed", "stamina"]}
## Probe 7's step s1: the plus of [High WHEN loading up, Loose WHEN tiring, Loose WHEN hurt, High WHEN your boxer is hurt].
const STEP := [9.0, 9.0, 8.0, 8.0]
const FORMATS := [{"id": "am3", "pro": false, "rounds": 3, "limit": 60.0, "who": "lucy", "plan": 0, "sex": "f"},
	{"id": "pro4", "pro": true, "rounds": 4, "limit": 75.0, "who": "tess", "plan": 1, "sex": "f"},
	{"id": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "who": "danny", "plan": 2, "sex": "m"}]
## Four opponent types, three different generated boxers each (AttrGen.generate); power = RingDuel.side punch at rating 60.
const TYPES := [{"id": "light_presser", "arch": ["Pressure fighter"], "lo": 0.0, "hi": 47.0, "threat": "Hooks in close"},
	{"id": "heavy_presser", "arch": ["Pressure fighter", "Slugger", "Pressure fighter"], "lo": 78.0, "hi": 999.0, "threat": "One big right hand"},
	{"id": "counter", "arch": ["Counter-puncher"], "lo": 0.0, "hi": 999.0, "threat": "Right hand counter over the jab"},
	{"id": "volume", "arch": ["Volume puncher"], "lo": 0.0, "hi": 999.0, "threat": "Never stops throwing"}]
const NAMES := {"f": ["Ada Flynn", "Bea Stone", "Cora Webb", "Dee Marsh", "Eva Lund", "Fay Cross", "Gia Holt", "Ida Voss", "Joy Pike", "Kay Rudd", "Lea Dunn", "Mia Frost"],
	"m": ["Abe Flynn", "Ben Stone", "Cal Webb", "Dan Marsh", "Eli Lund", "Finn Cross", "Gus Holt", "Ian Voss", "Jay Pike", "Kit Rudd", "Lee Dunn", "Max Frost"]}
static var S: Dictionary = {}
static var guard_diff := 0.0
static var best_mode := false   ## plan=best: BASE is the best four lines the boxer can FIRE (greedy on the pilot's seeds), not the written plan
static var L := []

## table: moment -> [High, Loose] power points. worn / drain / block / hurt / loose_dmg / high_out: v6 2.3-2.5, unchanged.
static func _sizes() -> Dictionary:
	var p: Array = STEP
	return {"table": {"loadup": [p[0], -10.0], "press": [-4.0, 3.0], "range": [-8.0, 4.0], "counter": [-3.0, -8.0], "tiring": [-9.0, p[1]],
			"hurt": [-9.0, p[2]], "she_tired": [4.0, -8.0], "she_hurt": [p[3], -12.0]},
		"worn": [2.0, 4.0], "drain": 1.0, "block": {"high": 0.75, "normal": 0.6, "loose": 0.45}, "high_wear": true,
		"hurt": {"high": 0.7, "normal": 1.0, "loose": 1.3}, "loose_dmg": 2.0, "high_out": 0.75}

static func _arms(slots: int, weak: int) -> Array:
	var out := [{"id": "CONTROL"}, {"id": "BASE"}]
	for k in slots:
		out.append({"id": "DROP:%d" % k, "cut": k})
	for g in GUARD:
		out.append({"id": "ADD:%s" % g[0], "lines": {g[0]: g[1]}})
		for k in slots:
			out.append({"id": "SWAP:%s:%d" % [g[0], k], "cut": k, "lines": {g[0]: g[1]}})
	out.append({"id": "WSWAP:%d" % weak, "cut": weak, "lines": {WRONG[0]: WRONG[1]}})
	return out

static func _wins(fm: Dictionary, t: Dictionary, opps: Dictionary, plan: Array, np: int) -> float:
	var w := 0
	for i in np:
		w += int(_bout(fm, t, opps, SEED_PILOT + i, {"id": "BASE", "plan": plan})["win"])
	return 100.0 * float(w) / float(np)

## plan=best: the best four lines this boxer can FIRE against this opponent type, picked one at a time on the pilot's seeds from every
## move he can do and fire (PlanFight.can_do, PlanAuto.fires: mastery 30+), any time or WHEN a moment it is a best answer to
## (PlanFight.fit). One line a place and moment (PlanBoard.validate). Always four lines, also when the last adds nothing.
static func _best_plan(fm: Dictionary, t: Dictionary, opps: Dictionary, f: Dictionary, np: int) -> Dictionary:
	var cands := []
	for m in StrikeMap.MOVES:
		var id := str(m["id"])
		if str(m.get("kind", "")) == "forced" or not PlanFight.can_do(m, f.get("moves", {})) or not PlanAuto.fires(f, id):
			continue
		cands.append({"move": id})
		for sit in MOMENTS:
			if PlanFight.fit(id, sit) == "best":
				cands.append({"move": id, "when": sit})
	var plan := []; var taken := {}
	var steps := [_wins(fm, t, opps, [], np)]
	while plan.size() < 4:
		var top := -1.0; var top_i := -1
		for ci in cands.size():
			var c: Dictionary = cands[ci]
			if taken.has(_place(c)):
				continue
			var w := _wins(fm, t, opps, plan + [c], np)
			if w > top:
				top = w; top_i = ci
		if top_i < 0:
			break
		taken[_place(cands[top_i])] = true
		plan.append(cands[top_i]); steps.append(top)
	return {"plan": plan, "steps": steps, "cands": cands.size()}

static func _place(c: Dictionary) -> String:
	return str(StrikeMap.move(str(c["move"])).get("from", "")) + ":" + str(c.get("when", ""))

## One cell: the plan, the self-check, the pilot (its own seeds) that names the weakest move line, then every arm on the test's seeds.
static func _cell(fm: Dictionary, t: Dictionary, opps: Dictionary, n: int) -> Dictionary:
	var pl: Dictionary = GP.PLANS[int(fm["plan"])]
	var plan: Array = (pl["arrows"] as Array).duplicate(true)
	var np := mini(n, N_PILOT)
	var su := _setup(fm, t, opps, SEED_PILOT)
	var out := {"limit": StyleName.limit(su[1], BoutNight.arrow_limit(su[0])), "style": StyleName.named(su[1]), "same": 0, "tried": 0, "wins": {}, "fired": {}}
	if best_mode:
		var g := _best_plan(fm, t, opps, su[1], np)
		plan = g["plan"]; out["greedy"] = g["steps"]; out["cands"] = g["cands"]
	var moves := []
	for a in plan:
		moves.append(str(a["move"]) + ("" if str(a.get("when", "")) == "" else " WHEN " + str(a["when"])))
	out["moves"] = moves
	for i in mini(n, 10):
		var a := _bout(fm, t, opps, SEED0 + i, {"id": "CONTROL", "plan": plan})
		var b := _bout(fm, t, opps, SEED0 + i, {"id": "PLAIN", "plan": plan})
		out["tried"] = int(out["tried"]) + 1
		out["same"] = int(out["same"]) + (1 if a["sig"] == b["sig"] else 0)
	var pw := [_wins(fm, t, opps, plan, np)]
	var weak := 0
	for k in moves.size():
		var less := plan.duplicate(true)
		less.remove_at(k)
		pw.append(_wins(fm, t, opps, less, np))
		if float(pw[k + 1]) > float(pw[weak + 1]):
			weak = k
	out["pilot"] = pw; out["weak"] = weak
	for spec in _arms(moves.size(), weak):
		var bits := ""; var fired := 0
		for i in n:
			var b := _bout(fm, t, opps, SEED0 + i, (spec as Dictionary).merged({"plan": plan}))
			bits += "1" if int(b["win"]) == 1 else "0"
			fired += int(b["fired"])
		out["wins"][spec["id"]] = bits
		out["fired"][spec["id"]] = fired
	return out

func _initialize() -> void:
	var n := N; var pilot := false; var part := [0, 1]; var out_path := ""; var merge := []; var doc := "res://docs/GUARDPROBE8_RESULT.md"
	for a in OS.get_cmdline_user_args():
		if a == "pilot":
			pilot = true
		elif a.begins_with("n="):
			n = maxi(1, int(a.trim_prefix("n=")))
		elif a.begins_with("part="):
			part = [int(a.trim_prefix("part=").get_slice("/", 0)), int(a.trim_prefix("part=").get_slice("/", 1))]
		elif a == "plan=best":
			best_mode = true
		elif a.begins_with("doc="):
			doc = a.trim_prefix("doc=")
		elif a.begins_with("out="):
			out_path = a.trim_prefix("out=")
		elif a.begins_with("merge="):
			merge = Array(a.trim_prefix("merge=").split(","))
	var t0 := Time.get_ticks_msec()
	S = _sizes()
	var opps := _make_opps()
	var D := {}
	var took := 0.0
	if not merge.is_empty():
		for p in merge:
			var j: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(str(p)))
			n = int(j["n"]); took += float(j["took"]); best_mode = bool(j.get("best", false))
			guard_diff = maxf(guard_diff, float(j["guard_diff"]))
			D.merge(j["cells"])
	else:
		var idx := 0
		for fm in FORMATS:
			for t in TYPES:
				if idx % int(part[1]) == int(part[0]):
					D["%s|%s" % [fm["id"], t["id"]]] = _cell(fm, t, opps, n)
					print("  %s|%s done at %.0f s" % [fm["id"], t["id"], (Time.get_ticks_msec() - t0) / 1000.0])
				idx += 1
		took = (Time.get_ticks_msec() - t0) / 1000.0
		if out_path != "":
			FileAccess.open(out_path, FileAccess.WRITE).store_string(JSON.stringify({"n": n, "took": took, "guard_diff": guard_diff, "best": best_mode, "cells": D}))
	if D.size() == 12:
		_report(D, n, opps, took)
		if not pilot:
			FileAccess.open(doc, FileAccess.WRITE).store_string("\n".join(L) + "\n")
	print("GUARDPROBE8 done")
	quit(0)

static func _say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s)
		L.append(s)

static func _make_opps() -> Dictionary:
	var out := {}
	for ti in TYPES.size():
		var t: Dictionary = TYPES[ti]
		var arr := []
		var seed := 1
		while arr.size() < 3 and seed < 6000:
			var arch := str(t["arch"][arr.size() % (t["arch"] as Array).size()])
			var rng := RandomNumberGenerator.new()
			rng.seed = seed * 977 + ti * 31
			var p := AttrGen.generate(rng, arch)
			var o := {"style": arch, "shape": p["shape"], "pace": p["pace"], "forward": p["forward"], "heart": p["heart"], "rating": 60.0,
				"club": "Probe ABC", "age": 24, "stance": "orthodox", "w": 5, "l": 2, "threat": str(t["threat"]), "weak": "", "name": "x", "first": "x"}
			var pw := float(RingDuel.side(RingDuel.opp(o))["power"])
			if pw >= float(t["lo"]) and pw < float(t["hi"]):
				arr.append(o.merged({"power60": pw, "gen_seed": seed}))
			seed += 1
		if arr.size() < 3:
			push_error("GUARDPROBE8: no three %s found" % str(t["id"]))
		out[t["id"]] = arr
	return out

## The boxer, the opponent and the fight moment for one bout (guardprobe6.gd, unchanged).
static func _setup(fm: Dictionary, t: Dictionary, opps: Dictionary, seed: int, spec := {}) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed * 7919 + 13
	var who := str(fm["who"])
	var tpl := Data.lucy()
	if who != "lucy":
		for p in Data.PROSPECTS:
			if str(p["id"]) == who:
				tpl = p.duplicate(true)
	var f := Data.fighter_state(tpl, seed)
	for k in f["stats"]:
		f["stats"][k] = clampf(float(f["stats"][k]) + rng.randf_range(-3.0, 3.0), 25.0, 95.0)
	var pl: Dictionary = GP.PLANS[int(fm["plan"])]
	f["limit"] = float(fm["limit"])
	f.erase("height")
	f.erase("reach")
	BodyFacts.fill(f)
	f = f.merged({"pro": bool(fm["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [],
		"arrows": (spec.get("plan", pl["arrows"]) as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
	if int(spec.get("cut", -1)) >= 0:
		(f["arrows"] as Array).remove_at(int(spec["cut"]))   # the move line given up
	f.erase("last_bout_day")
	var ti := 0
	for j in TYPES.size():
		if TYPES[j]["id"] == t["id"]:
			ti = j
	var k3 := seed % 3
	var opp: Dictionary = (opps[t["id"]][k3] as Dictionary).duplicate(true)
	opp["name"] = str(NAMES[str(fm["sex"])][ti * 3 + k3])
	opp["first"] = str(opp["name"]).get_slice(" ", 0)
	opp["rating"] = BoutRules.fight_power(f["stats"], {}, 0, "", bool(fm["pro"]))
	f["bout"] = {"opp": opp, "day": seed, "weighed": true, "made": true, "done": false, "film": 1, "rounds": int(fm["rounds"])}
	var c := Career.new()
	c.day = seed; c.seed = seed; c.coach = {"rating": COACH}; c.fighters = [f]
	return [c, f, {"fid": f["id"], "step": "tape", "total": int(fm["rounds"])}]

static func _bout(fm: Dictionary, t: Dictionary, opps: Dictionary, seed: int, spec: Dictionary) -> Dictionary:
	var arm := str(spec["id"])
	var su := _setup(fm, t, opps, seed, spec)
	var c: Career = su[0]; var f: Dictionary = su[1]; var m: Dictionary = su[2]
	var st := {"arm": arm, "drain": 0.0, "lines": spec.get("lines", {})}
	if arm == "CONTROL":
		BoutNight.play_out(c, f, m)
	else:
		m.merge({"step": "round", "round": 0, "rounds": []}, true)
		BoutNight._peak(c, f)
		ProReadWire.open(f)
		m["lab_from"] = f.duplicate(true)
		_open(c, f, m, "", st)
		while int(m["round"]) < BoutNight.rounds_of(f) and not BoutNight.stopped(m) and not TowelWire.coach_pull(c, f, m) and not CrackWire.bell(c, f, m, BoutNight.rounds_of(f)):
			_open(c, f, m, BoutRules.auto_corner(f["stats"]), st)
	var out := BoutNight.outcome_of(f, m)
	var stop := BoutNight.stopped(m)
	var exw := 0; var exn := 0
	var sig := "%s|%s" % [out, stop]
	for r in m["rounds"]:
		for x in r["exchanges"]:
			exn += 1
			exw += 1 if bool(x["won"]) else 0
		sig += "|%d:%d:%.3f" % [int(r["n"]), int(r["won_n"]), float(r["mine"])]
	var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
	sig += "|%.3f|%.3f" % [float(dmg.get("a", 0.0)), float(dmg.get("b", 0.0))]
	return {"win": 1 if out == "win" else 0, "draw": 1 if out == "draw" else 0, "stoploss": 1 if out == "loss" and stop != "" else 0,
		"stopwin": 1 if out == "win" and stop != "" else 0, "exw": exw, "exn": exn, "sig": sig, "fired": int(st.get("fired", 0)),
		"ga": GuardState.share(f, "a"), "gb": GuardState.share(f, "b")}

## BoutNight._open with no corner jobs, then the round's six exchanges on the corner's plan (BoutNight._shout_out).
static func _open(c: Career, f: Dictionary, m: Dictionary, plan: String, st: Dictionary) -> void:
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

## The line's points for this exchange (0 with no line), graded as a plan line.
static func _points(hands: String, sit: String, f: Dictionary, zero: bool) -> float:
	if hands == "normal" or zero:
		return 0.0
	var e := float(S["table"][sit][0 if hands == "high" else 1])
	var at := Attrs.of(f)
	var pair: Array = DONE_WITH[hands]
	var mean := (float(at.get(str(pair[0]), 55.0)) + float(at.get(str(pair[1]), 55.0))) * 0.5
	var word := "Good" if mean >= Exchanges.GOOD_AT else ("OK" if mean >= Exchanges.OK_AT else "Poor")
	return e * float(LineGrade.PLUS[word]) if e > 0.0 else e * float(Exchanges.COMMIT[word])

static func _worn(share: float) -> float:
	return float(S["worn"][1]) if share < 0.25 else (float(S["worn"][0]) if share < 0.5 else 0.0)

## One exchange: BoutNight._shout with the guard line around LiveRound.exchange.
static func _ex(c: Career, f: Dictionary, m: Dictionary, st: Dictionary) -> void:
	var arm := str(st["arm"])
	var lv := LiveRound.live(m)
	var i := (lv["ex"] as Array).size()
	var plain := arm == "PLAIN"
	var sit := Exchanges.situation(str(lv["mode"]), LiveRound.her_energy(lv, i), bool(lv["her_hurt"]))
	var hands := "normal" if plain else str((st["lines"] as Dictionary).get(sit, "normal"))
	st["fired"] = int(st.get("fired", 0)) + (1 if hands != "normal" else 0)
	if str(lv["plan"]) == "hands" and not plain:   # the round's corner call "Hands up" = High all round (v6 2.1, kept)
		hands = "high"
	elif str(lv["plan"]) == "let_go" and not plain:
		hands = "loose"
	var edge := 0.0
	var snap: Dictionary = (f["bout"]["guard"] as Dictionary).duplicate(true)
	if not plain:
		edge = _points(hands, sit, f, false) + _worn(GuardState.share(f, "b")) - _worn(GuardState.share(f, "a"))
		if hands == "high" and str(lv["mode"]) in ["press", "loadup"]:   # v6 2.4: covering tires the puncher
			lv["opp_drain"] = float(lv.get("opp_drain", 0.0)) + float(S["drain"])
			st["drain"] = float(st["drain"]) + float(S["drain"])
	lv["base"] = float(lv["base"]) + edge
	var r := LiveRound.exchange(c, f, m, "")
	lv["base"] = float(lv["base"]) - edge
	var rec: Dictionary = lv["ex"][-1]
	if not plain:
		_post(c, f, m, lv, rec, hands, snap, i)
	if r.is_empty():
		return
	if not plain:
		r["landed"] = [0, 0]
		for x in r["exchanges"]:
			r["landed"] = [int(r["landed"][0]) + int(x["landed"][0]), int(r["landed"][1]) + int(x["landed"][1])]
		r["guard"] = GuardState.share(f, "a")
		r["hurt_at_bell"] = bool(rec["after"]["hurt"][0])
		# The drain is carried to the next bell (probe rule: lv["opp_drain"] alone is rebuilt every round, StepWire's too).
		f["bout"]["energy"]["b"] = maxf(0.0, float(f["bout"]["energy"]["b"]) - float(st["drain"]))
		st["drain"] = 0.0
	BoutNight._lines(c, f, r)
	(m["rounds"] as Array).append(r)
	r["film"] = FilmNight.minute(f, r, (m["rounds"] as Array).size())
	BoutNight._counts(c, f, m, r)
	m["towel"] = TowelWire.card(c, f, m, BoutNight.count_sides(f, f["bout"]["opp"]), BoutNight.rounds_of(f))

## v6 2.5 after the settle: the counts, the guard re-walked with the Hands' block share and wear, the hurt chance, the
## clean punch Loose lets in. The winner from settle stands.
static func _post(c: Career, f: Dictionary, m: Dictionary, lv: Dictionary, rec: Dictionary, hands: String, snap: Dictionary, i: int) -> void:
	var opp: Dictionary = f["bout"]["opp"]
	var landed: Array = rec["landed"]
	var won := bool(rec["won"])
	var theirs0 := int(landed[1])
	var conv := 0
	var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
	if hands == "high":
		conv = roundi(float(theirs0) / 3.0)
		landed[1] = theirs0 - conv
		landed[0] = maxi(0, int(round(float(int(landed[0])) * float(S["high_out"]))))
	elif hands == "loose":
		landed[0 if won else 1] = int(landed[0 if won else 1]) + 1
		theirs0 = int(landed[1])
		if not won:
			dmg["a"] = float(dmg.get("a", 0.0)) + float(S["loose_dmg"])
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
		var mult := float(S["hurt"][hands])
		if mult < 1.0 and bool(lv["her_hurt"]) and hr.randf() < 1.0 - mult:
			lv["her_hurt"] = false
		elif mult > 1.0 and not bool(lv["her_hurt"]):
			var p := clampf(0.3 + (float(RingDuel.side(RingDuel.opp(opp))["power"]) - float(RingDuel.side(Attrs.of(f))["chin"])) / 100.0, 0.1, 0.8)
			if hr.randf() < (mult - 1.0) * p / maxf(0.01, 1.0 - p):
				lv["her_hurt"] = true
		rec["after"]["hurt"][0] = bool(lv["her_hurt"])

## GuardState.after, copied (its call from LiveRound passes no arrow), with the Hands' block share on OUR guard, the
## punches High turned into blocks (conv) and High's +8% wear (GuardWear's unused "posture": "high").
static func _guard_after(f: Dictionary, landed: Array, theirs0: int, conv: int, at: String, opp_attrs: Dictionary, call: String, n: int, opp_habits: Array, hands: String) -> Dictionary:
	var gs: Dictionary = f["bout"]["guard"]
	var amateur := not bool(f.get("pro", false))
	var own := Attrs.of(f)
	var thrown_a := ceili(float(theirs0) / BoutBurn.LAND_RATE)
	var blocks := [roundi(float(maxi(0, thrown_a - theirs0)) * float(S["block"][hands])) + conv, GuardState.blocked_of(int(landed[0]))]
	var ctxs := [
		{"ropes": at == "own_ropes", "amateur": amateur, "shoulder": GuardWear.shoulder(float(own.get("stamina", 55.0)), float(own.get("strength", 55.0)))},
		{"ropes": at == "opp_ropes", "amateur": amateur, "shoulder": GuardWear.shoulder(float(opp_attrs.get("stamina", 55.0)), float(opp_attrs.get("strength", 55.0)))}]
	if hands == "high" and bool(S["high_wear"]):
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

static func _wr(D: Dictionary, id: String, arm: String) -> float:
	var s: String = D[id]["wins"][arm]
	return 100.0 * float(s.count("1")) / maxf(1.0, float(s.length()))

## Arm against ref on the same seeds: [the difference in wins in 100, its sd] (paired: each bout is -1, 0 or +1).
static func _d(D: Dictionary, id: String, arm: String, ref := "BASE") -> Array:
	var a: String = D[id]["wins"][arm]; var b: String = D[id]["wins"][ref]
	var n := a.length(); var s := 0.0; var q := 0.0
	for i in n:
		var d := float(int(a[i] == "1") - int(b[i] == "1"))
		s += d; q += d * d
	var m := s / float(n)
	return [100.0 * m, 100.0 * sqrt(maxf(0.0, q / float(n) - m * m) / float(n))]

static func _f(v: Array) -> String:
	return "%+.1f (%.1f)" % [float(v[0]), float(v[1])]

static func _report(D: Dictionary, n: int, opps: Dictionary, took: float) -> void:
	var same := 0; var tried := 0; var limits := {}
	for id in D:
		same += int(D[id]["same"]); tried += int(D[id]["tried"])
		limits["%s: %d%s" % [str(id).get_slice("|", 0), int(D[id]["limit"]), "" if str(D[id]["style"]) == "" else " (named style " + str(D[id]["style"]) + ")"]] = true
	_say(["# GUARDPROBE8 - guard v7: does a guard line cost a move line? (S535)%s" % (" - the BEST four-line plan" if best_mode else " - the WRITTEN four-move plan"), "",
		"Run: python ops/Tools/godot_slot.py run --who guardprobe8 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe8.gd -- n=%d%s (run in parts, part=k/m out=, then merge=)" % [n, " plan=best" if best_mode else ""],
		"Seeds %d-%d, %d bouts a cell and arm, 12 cells (4 opponent types x amateur 3 / pro 4 / pro 6 rounds), the same seeds for every arm, so every" % [SEED0, SEED0 + n - 1, n],
		"difference is PAIRED: its sd is in brackets beside it (wins in 100). Measurement only: scripts/ not edited. The guard line is probe 7's local rule,",
		"sizes step s1 (%s), read right every time (read share 1.00)." % str(STEP),
		"", "## The line limit (the game has a hard one, on the plan screens)", "",
		"- `PlanBoard.arrow_limit` (scripts/rules/PlanBoard.gd 15-16): 4 lines for a new coach, +1 per 12 rating, 9 at most. `StyleName.limit` (StyleName.gd 114-115): a named style adds one, to 7 at most.",
		"- Enforced where the plan is written: `GamePlan.gd` 367-369 refuses a line over the limit (\"The plan is full: this coach teaches N lines\"), `PlanBoard.validate` 31-32 names it.",
		"- NOT enforced in the bout: `BoutNight.gd` 193 only stores the limit (the corner change reads it, 201) and `LiveRound.gd` 96 copies every written line. A plan over the limit would fight as written; only the screens stop it.",
		"- This probe: coach rating %s = limit %d (probe 7 ran a rating-60 coach = 7 lines, so its three guard lines were free). Limit by format here: %s." % [str(COACH), PlanBoard.arrow_limit(COACH), ", ".join(limits.keys())],
		"  Nothing else in the bout reads the coach's rating%s" % (". BASE here is the best-plan arm, so it is not probe 7's NORMAL column (run A's is)." if best_mode else ", so BASE here must equal probe 7's NORMAL column (it is printed below to compare)."),
		"", "## Population (probe 7's, unchanged)", "",
		"Ours: amateur 3 = Lucy (60 kg), pro 4 = Tess (75 kg), pro 6 = Danny (90 kg), stats jittered +/-3 by the seed, each on %s." % ("the best four lines he or she can fire against that opponent type (the table below)" if best_mode else "guard_probe.gd's written four-move plan"),
		"Opponents at our paper rating, three different generated boxers a type, taken in turn by seed (never two identical fighters).", "",
		"| type | # | style | generator seed | punch at rating 60 | pace | forward | heart |", "|---|---|---|---|---|---|---|---|"])
	for t in TYPES:
		for k in (opps[t["id"]] as Array).size():
			var o: Dictionary = opps[t["id"]][k]
			_say("| %s | %d | %s | %d | %.1f | %.0f | %.0f | %.0f |" % [t["id"], k + 1, o["style"], int(o["gen_seed"]), float(o["power60"]), float(o["pace"]), float(o["forward"]), float(o["heart"])])
	_say(["", "Self-check 1: the probe's walk with every guard size off reproduces BoutNight.play_out in %d of %d bouts. Self-check 2: the copied guard walk against the game's, max |diff| = %.6f." % [same, tried, guard_diff],
		""])
	if best_mode:
		_say(["## The best four-line plan (picked one line at a time on the pilot's seeds, from every line the boxer can do and fire)", "",
			"| cell | lines to pick from | no plan | + line 1 | + line 2 | + line 3 | + line 4 |", "|---|---|---|---|---|---|---|"])
		for fm in FORMATS:
			for t in TYPES:
				var c: Dictionary = D["%s|%s" % [fm["id"], t["id"]]]; var cells := []
				for k in (c["moves"] as Array).size():
					cells.append("%s = %.1f" % [str(c["moves"][k]), float(c["greedy"][k + 1])])
				_say("| %s %s | %d | %.1f | %s |" % [fm["id"], t["id"], int(c["cands"]), float(c["greedy"][0]), " | ".join(cells)])
		_say("")
	_say(["## The pilot: which move line is the weakest (seeds %d-%d, its own, never the test's)" % [SEED_PILOT, SEED_PILOT + mini(n, N_PILOT) - 1], "",
		"Wins in 100 with that one move line dropped and nothing in its place, against the four moves. The line that costs least to drop is the one given up.", "",
		"| cell | four moves | line 1 dropped | line 2 dropped | line 3 dropped | line 4 dropped | given up |", "|---|---|---|---|---|---|---|"])
	var ids := []
	for fm in FORMATS:
		for t in TYPES:
			ids.append("%s|%s" % [fm["id"], t["id"]])
	for id in ids:
		var c: Dictionary = D[id]; var pw: Array = c["pilot"]; var cells := []
		for k in (c["moves"] as Array).size():
			cells.append("%s %+.1f" % [str(c["moves"][k]), float(pw[k + 1]) - float(pw[0])])
		_say("| %s | %.1f | %s | %s |" % [str(id).replace("|", " "), float(pw[0]), " | ".join(cells), str(c["moves"][int(c["weak"])])])
	_say(["", "## The trade: the weakest move line swapped for one guard line (wins in 100 against the four-move plan; sd of the paired difference in brackets)", "",
		"| cell | today (CONTROL) | four moves (BASE) | given up | dropped, nothing in its place | %s | %s | %s | wrong: %s | best plan |" % [GUARD[0][2], GUARD[1][2], GUARD[2][2], WRONG[2]], "|---|---|---|---|---|---|---|---|---|---|"])
	var b1 := 0; var b2 := 0; var wr3 := 0; var strict := 0; var sig_up := 0; var sig_dn := 0; var off := 0.0
	var best_n := {}; var by_line := {}
	for id in ids:
		var c: Dictionary = D[id]; var w := int(c["weak"])
		var plans := {"four moves": _wr(D, id, "BASE")}; var up := false; var dn := false; var top := -999.0; var cells := []
		for g in GUARD:
			var arm := "SWAP:%s:%d" % [g[0], w]
			var v := _d(D, id, arm)
			plans[g[2]] = _wr(D, id, arm); cells.append(_f(v)); top = maxf(top, float(v[0]))
			up = up or float(v[0]) >= BAR; dn = dn or float(v[0]) <= -BAR
			var row: Array = by_line.get(g[2], [0, 0, 0.0])
			by_line[g[2]] = [int(row[0]) + (1 if float(v[0]) >= BAR else 0), int(row[1]) + (1 if float(v[0]) <= -BAR else 0), float(row[2]) + float(v[0]) / 12.0]
			sig_up += 1 if float(v[0]) >= BAR and float(v[0]) >= 2.0 * float(v[1]) else 0
			sig_dn += 1 if float(v[0]) <= -BAR and -float(v[0]) >= 2.0 * float(v[1]) else 0
		b1 += 1 if up else 0; b2 += 1 if dn else 0; strict += 1 if top <= -BAR else 0
		var wv := _d(D, id, "WSWAP:%d" % w)
		wr3 += 1 if float(wv[0]) <= -BAR else 0
		off = maxf(off, absf(_wr(D, id, "BASE") - _wr(D, id, "CONTROL")))
		var mx := -1.0
		for p in plans:
			mx = maxf(mx, float(plans[p]))
		var names := []
		for p in plans:
			if float(plans[p]) >= mx - 0.001:
				names.append(p); best_n[p] = int(best_n.get(p, 0)) + 1
		_say("| %s | %.1f | %.1f | %s | %s | %s | %s | %s |" % [str(id).replace("|", " "), _wr(D, id, "CONTROL"), _wr(D, id, "BASE"), str(c["moves"][w]), _f(_d(D, id, "DROP:%d" % w)), " | ".join(cells), _f(wv), ", ".join(names)])
	_say(["", "By guard line, over the 12 cells (the weakest move line given up): cells 3+ up / cells 3+ down / mean."])
	for g in GUARD:
		var row: Array = by_line[g[2]]
		_say("- %s: %d up, %d down, mean %+.1f." % [g[2], int(row[0]), int(row[1]), float(row[2])])
	_say(["", "## What the slot costs: the same guard line ADDED as a fifth line (over the limit) against SWAPPED for the weakest move line", "",
		"| cell | %s added | swapped | the slot costs | %s added | swapped | the slot costs | %s added | swapped | the slot costs |" % [GUARD[0][2], GUARD[1][2], GUARD[2][2]], "|---|---|---|---|---|---|---|---|---|---|"])
	var cost := 0.0
	for id in ids:
		var w := int(D[id]["weak"]); var cells := []
		for g in GUARD:
			var sw := _d(D, id, "SWAP:%s:%d" % [g[0], w], "ADD:%s" % g[0])
			cost += float(sw[0]) / 36.0
			cells.append("%+.1f | %+.1f | %s" % [float(_d(D, id, "ADD:%s" % g[0])[0]), float(_d(D, id, "SWAP:%s:%d" % [g[0], w])[0]), _f(sw)])
		_say("| %s | %s |" % [str(id).replace("|", " "), " | ".join(cells)])
	_say(["", "Mean cost of the slot (swapped minus added), the weakest move line: %+.1f wins in 100." % cost,
		"", "## Every swap: each of the four move lines given up for each guard line (wins in 100 against the four-move plan)", "",
		"A player who does not know which move line is the weakest gives up one of these. 'drop' = that move line dropped, nothing in its place.", "",
		"| cell | move line | drop | %s | %s | %s |" % [GUARD[0][2], GUARD[1][2], GUARD[2][2]], "|---|---|---|---|---|---|"])
	var any_up := 0; var any_dn := 0; var all_up := 0; var all_dn := 0; var swaps := 0; var mean_dn := 0
	for id in ids:
		var c: Dictionary = D[id]; var cu := false; var cd := false; var msum := {}
		for k in (c["moves"] as Array).size():
			var cells := []
			for g in GUARD:
				var v := _d(D, id, "SWAP:%s:%d" % [g[0], k])
				cells.append(_f(v)); swaps += 1
				msum[g[0]] = float(msum.get(g[0], 0.0)) + float(v[0]) / float((c["moves"] as Array).size())
				cu = cu or float(v[0]) >= BAR; cd = cd or float(v[0]) <= -BAR
				all_up += 1 if float(v[0]) >= BAR else 0; all_dn += 1 if float(v[0]) <= -BAR else 0
			_say("| %s | %d %s%s | %s | %s |" % [str(id).replace("|", " "), k + 1, str(c["moves"][k]), " (weakest)" if k == int(c["weak"]) else "", _f(_d(D, id, "DROP:%d" % k)), " | ".join(cells)])
		any_up += 1 if cu else 0; any_dn += 1 if cd else 0
		var worst := 999.0
		for g in msum:
			worst = minf(worst, float(msum[g]))
		mean_dn += 1 if worst <= -BAR else 0
	_say(["", "Of the %d swaps: %d are 3+ up, %d are 3+ down. Cells with at least one swap 3+ up: %d of 12; with at least one 3+ down: %d of 12." % [swaps, all_up, all_dn, any_up, any_dn],
		"A move line picked blind (the mean over the four): a guard line loses 3+ in %d of 12 cells." % mean_dn])
	var most := 0; var most_name := ""
	for p in best_n:
		if int(best_n[p]) > most:
			most = int(best_n[p]); most_name = str(p)
	var p1 := b1 >= 3; var p2 := b2 >= 3; var p3 := most <= 7
	_say(["", "## Bars (written in the probe before the run: the weakest move line, by the pilot, is the one given up)", "",
		"- Bar 1, a guard line is worth its slot: some swap beats the four-move plan by 3+ wins in 100 in at least 3 cells: %d of 12 = %s." % [b1, "PASS" if p1 else "FAIL"],
		"- Bar 2, and not everywhere: some swap loses to the four-move plan by 3+ in at least 3 cells: %d of 12 = %s." % [b2, "PASS" if p2 else "FAIL"],
		"- Bar 3, no single plan (the four moves or one of the three swaps) best in more than 7 of 12 cells: %s (most: %s, %d of 12) = %s." % [str(best_n), most_name, most, "PASS" if p3 else "FAIL"],
		"- Not bars, said beside them: cells where EVERY right swap loses 3+ (no guard line is worth the slot): %d of 12. Swaps of the 36 that are 3+ up and at least 2 sd: %d; 3+ down and at least 2 sd: %d." % [strict, sig_up, sig_dn],
		"- The wrong swap (%s for the weakest move line) loses 3+ in %d of 12 cells." % [WRONG[2], wr3],
		"- BASE against today's game (CONTROL): worst cell %.1f in 100 apart (the worn-guard edge is the only difference)." % off,
		"", "RESULT: tools/guardprobe8.gd -> worth=%s(%d/12) notworth=%s(%d/12) single=%s(%d/12) -> %s" % ["PASS" if p1 else "FAIL", b1, "PASS" if p2 else "FAIL", b2, "PASS" if p3 else "FAIL", most, "PASS" if p1 and p2 and p3 else "FAIL"],
		"", "(the parts took %.0f s of Godot time together)" % took])
