extends SceneTree
## S535 GUARDPROBE7 - guard v7: High / Loose as WHEN-lines of the fight plan (DESIGN_GUARDDMG1_V7.md). MEASUREMENT ONLY: nothing
## under scripts/ is edited. An arm is a set of guard lines {moment: "high" | "loose"}; a line fires in the exchange fought in its
## moment (Exchanges.situation), its points go into lv["base"] before Exchanges.settle, graded as a plan line (LineGrade.PLUS on a
## plus, Exchanges.COMMIT on a minus); after the settle v6 2.5, unchanged. CONTROL = BoutNight.play_out. Self-contained: the walk, the
## population and the after-settle rules are guardprobe6.gd's as it stood for docs/GUARDPROBE6_RESULT.md (S534), copied in.
##   python ops/Tools/godot_slot.py run --who guardprobe7 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe7.gd
##   user args: n=<bouts a cell> sizes=auto (the ladder picks) | s1 | s2 | s3   pilot (prints, writes nothing)

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
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")
const FilmNight := preload("res://scripts/state/FilmNight.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const SEED0 := 6000
const N := 200
const READ_RIGHT := 0.70
const SITS := ["loadup", "press", "range", "counter", "tiring", "hurt", "she_tired", "she_hurt"]
## Each arm's guard lines, moment -> action. RIGHT = the brief's corner sentence + cover when hurt; WRONG = the same actions on wrong moments.
const LINES := {
	"NORMAL": {}, "PLAIN": {},
	"RIGHT": {"loadup": "high", "tiring": "loose", "she_hurt": "high"},
	"WRONG": {"range": "high", "tiring": "high", "loadup": "loose"},
	"FULL": {"loadup": "high", "she_tired": "high", "she_hurt": "high", "press": "loose", "range": "loose", "tiring": "loose", "hurt": "loose"},
	"ONE:loadup": {"loadup": "high"}, "ONE:tiring": {"tiring": "loose"}, "ONE:she_hurt": {"she_hurt": "high"},
	"ONE:she_tired": {"she_tired": "high"}, "ONE:hurt": {"hurt": "loose"},
}
const ARMS := ["CONTROL", "NORMAL", "RIGHT", "WRONG", "NOISY", "FULL", "RIGHT0", "ONE:loadup", "ONE:tiring", "ONE:she_hurt", "ONE:she_tired", "ONE:hurt"]
const ONES := ["ONE:loadup", "ONE:tiring", "ONE:she_hurt", "ONE:she_tired", "ONE:hurt"]
## What a guard line is done with (LineGrade.DONE_WITH's form: two attributes, their mean grades it).
const DONE_WITH := {"high": ["defence", "composure"], "loose": ["speed", "stamina"]}
## The ladder: the plus of [High WHEN loading up, Loose WHEN tiring, Loose WHEN hurt, High WHEN your boxer is hurt]; 9 = a best plan line, 17 = a best call.
const STEPS := {"s1": [9.0, 9.0, 8.0, 8.0], "s2": [12.0, 12.0, 10.0, 11.0], "s3": [15.0, 15.0, 12.0, 14.0]}
const SEED_PICK := 9000
const PICK_CELLS := 9   ## the ladder takes the smallest step with RIGHT 5+ up in this many cells (the bar is 8: one cell of margin)
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
static var L := []
static var X := {}   ## "ARM|moment" -> [exchanges, won, a line fired]

## table: moment -> [High, Loose] power points. worn / drain / block / hurt / loose_dmg / high_out: v6 2.3-2.5, unchanged.
static func _sizes(key: String) -> Dictionary:
	var p: Array = STEPS[key]
	return {"table": {"loadup": [p[0], -10.0], "press": [-4.0, 3.0], "range": [-8.0, 4.0], "counter": [-3.0, -8.0], "tiring": [-9.0, p[1]],
			"hurt": [-9.0, p[2]], "she_tired": [4.0, -8.0], "she_hurt": [p[3], -12.0]},
		"worn": [2.0, 4.0], "drain": 1.0, "block": {"high": 0.75, "normal": 0.6, "loose": 0.45}, "high_wear": true,
		"hurt": {"high": 0.7, "normal": 1.0, "loose": 1.3}, "loose_dmg": 2.0, "high_out": 0.75}

## The ladder, on its own seeds (never the test's): the smallest step where RIGHT beats NORMAL by 5+ in PICK_CELLS cells.
static func _pick(opps: Dictionary, n: int) -> String:
	_say(["", "## Sizing ladder (seeds %d-%d, %d bouts a cell: its own seeds, not the test's)" % [SEED_PICK, SEED_PICK + n - 1, n], "",
		"| step | High WHEN loading up | Loose WHEN tiring | Loose WHEN hurt | High WHEN your boxer is hurt | cells where RIGHT beats NORMAL by 5+ | mean RIGHT-NORMAL |", "|---|---|---|---|---|---|---|"])
	var pick := ""
	for key in STEPS:
		S = _sizes(key)
		var cells := 0; var mean := 0.0
		for fm in FORMATS:
			for t in TYPES:
				var w := [0, 0]
				for i in n:
					w[0] += int(_bout(fm, t, opps, SEED_PICK + i, "NORMAL")["win"])
					w[1] += int(_bout(fm, t, opps, SEED_PICK + i, "RIGHT")["win"])
				var d := 100.0 * float(int(w[1]) - int(w[0])) / float(n)
				cells += 1 if d >= 5.0 else 0; mean += d / 12.0
		var p: Array = STEPS[key]
		_say("| %s | +%s | +%s | +%s | +%s | %d of 12 | %+.1f |" % [key, str(p[0]), str(p[1]), str(p[2]), str(p[3]), cells, mean])
		if pick == "" and cells >= PICK_CELLS:
			pick = str(key)
	_say(["", "Taken: %s (the smallest step with %d of 12 on the ladder's seeds - the bar is 8, one cell of margin; the top step if none)." % [pick if pick != "" else "s3", PICK_CELLS]])
	return pick if pick != "" else "s3"

func _initialize() -> void:
	var n := N; var pilot := false; var sets := ["auto"]
	for a in OS.get_cmdline_user_args():
		if a == "pilot":
			pilot = true
		elif a.begins_with("n="):
			n = maxi(1, int(a.trim_prefix("n=")))
		elif a.begins_with("sizes="):
			sets = Array(a.trim_prefix("sizes=").split(","))
	var t0 := Time.get_ticks_msec()
	var opps := _make_opps()
	var same := 0; var tried := 0
	S = _sizes("s1")
	for fm in FORMATS:
		for t in TYPES:
			for i in mini(n, 10):
				var a := _bout(fm, t, opps, SEED0 + i, "CONTROL")
				var b := _bout(fm, t, opps, SEED0 + i, "PLAIN")
				tried += 1; same += 1 if a["sig"] == b["sig"] else 0
	_say(["# GUARDPROBE7 - guard v7, High / Loose as WHEN-lines of the fight plan (S535)", "",
		"Run: python ops/Tools/godot_slot.py run --who guardprobe7 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe7.gd -- n=%d" % n,
		"Seeds %d-%d, %d bouts a cell and arm, 12 cells (4 opponent types x amateur 3 / pro 4 / pro 6 rounds), the same seeds for every arm." % [SEED0, SEED0 + n - 1, n],
		"Measurement only: scripts/ not edited. A guard line is this tool's local rule: it fires in the exchange fought in its moment, its points go",
		"into the exchange's own sum (lv base) BEFORE Exchanges.settle, graded as a plan line; counts, blocks, wear, hurt and the drain after it (v6 2.3-2.5).",
		"CONTROL = BoutNight.play_out, today's rules. The population, the seeds and the walk are GUARDPROBE6's.",
		"", "## Population", "",
		"Ours: amateur 3 = Lucy (Out-boxer, 60 kg), pro 4 = Tess (Pressure fighter, 75 kg), pro 6 = Danny (90 kg limit set on the bout); the seven",
		"stats jittered +/-3 by the bout seed, each on guard_probe.gd's written plan for that format. Opponents at our paper rating (an even match),",
		"three different generated boxers a type, taken in turn by seed (never two identical fighters; women box women, men box men by name list).",
		"", "| type | # | style | generator seed | punch at rating 60 | pace | forward | heart |", "|---|---|---|---|---|---|---|---|"])
	for t in TYPES:
		for k in (opps[t["id"]] as Array).size():
			var o: Dictionary = opps[t["id"]][k]
			_say("| %s | %d | %s | %d | %.1f | %.0f | %.0f | %.0f |" % [t["id"], k + 1, o["style"], int(o["gen_seed"]), float(o["power60"]), float(o["pace"]), float(o["forward"]), float(o["heart"])])
	_say(["", "Self-check 1: the probe's own walk of the bout with every guard size off reproduces BoutNight.play_out in %d of %d bouts (rounds, exchanges won, damage, stoppage)." % [same, tried]])
	if sets == ["auto"]:
		sets = [_pick(opps, mini(n, 100))]
	for key in sets:
		S = _sizes(key)
		X = {}; guard_diff = 0.0
		var R := {}
		for fm in FORMATS:
			for t in TYPES:
				var id := "%s|%s" % [fm["id"], t["id"]]
				R[id] = {}
				for arm in ARMS:
					var acc := {"n": n, "win": 0, "draw": 0, "stoploss": 0, "stopwin": 0, "exw": 0, "exn": 0, "fired": 0}
					for i in n:
						var b := _bout(fm, t, opps, SEED0 + i, arm)
						for k2 in ["win", "draw", "stoploss", "stopwin", "exw", "exn", "fired"]:
							acc[k2] += int(b[k2])
					R[id][arm] = acc
				print("  [%s] %s done at %.0f s" % [key, id, (Time.get_ticks_msec() - t0) / 1000.0])
		_report(key, R, n)
	_say(["", "(run took %.0f s)" % ((Time.get_ticks_msec() - t0) / 1000.0)])
	if not pilot:
		FileAccess.open("res://docs/GUARDPROBE7_RESULT.md", FileAccess.WRITE).store_string("\n".join(L) + "\n")
	print("GUARDPROBE7 done")
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
			push_error("GUARDPROBE7: no three %s found" % str(t["id"]))
		out[t["id"]] = arr
	return out

## The boxer, the opponent and the fight moment for one bout (guardprobe6.gd, unchanged).
static func _setup(fm: Dictionary, t: Dictionary, opps: Dictionary, seed: int) -> Array:
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
		"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
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
	c.day = seed; c.seed = seed; c.coach = {"rating": 60.0}; c.fighters = [f]
	return [c, f, {"fid": f["id"], "step": "tape", "total": int(fm["rounds"])}]

static func _bout(fm: Dictionary, t: Dictionary, opps: Dictionary, seed: int, arm: String) -> Dictionary:
	var su := _setup(fm, t, opps, seed)
	var c: Career = su[0]; var f: Dictionary = su[1]; var m: Dictionary = su[2]
	var st := {"arm": arm, "drain": 0.0}
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

## The guard action this exchange: the arm's line for the moment the boxer takes it for. NOISY reads the moment right
## READ_RIGHT of the time, else takes it for one of the other seven (its own dice).
static func _hands(arm: String, c: Career, lv: Dictionary, i: int, sit: String) -> String:
	var lines: Dictionary = LINES.get("RIGHT" if arm in ["RIGHT0", "NOISY"] else arm, {})
	var seen := sit
	if arm == "NOISY":
		var nr := RandomNumberGenerator.new()
		nr.seed = c.day * 977 + int(lv["n"]) * 53 + i * 11 + 5
		if nr.randf() >= READ_RIGHT:
			var others := SITS.filter(func(x): return x != sit)
			seen = str(others[nr.randi() % others.size()])
	return str(lines.get(seen, "normal"))

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
	var hands := "normal" if plain else _hands(arm, c, lv, i, sit)
	st["fired"] = int(st.get("fired", 0)) + (1 if hands != "normal" else 0)
	if str(lv["plan"]) == "hands" and not plain:   # the round's corner call "Hands up" = High all round (v6 2.1, kept)
		hands = "high"
	elif str(lv["plan"]) == "let_go" and not plain:
		hands = "loose"
	var edge := 0.0
	var snap: Dictionary = (f["bout"]["guard"] as Dictionary).duplicate(true)
	if not plain:
		edge = _points(hands, sit, f, arm.ends_with("0")) + _worn(GuardState.share(f, "b")) - _worn(GuardState.share(f, "a"))
		if hands == "high" and str(lv["mode"]) in ["press", "loadup"]:   # v6 2.4: covering tires the puncher
			lv["opp_drain"] = float(lv.get("opp_drain", 0.0)) + float(S["drain"])
			st["drain"] = float(st["drain"]) + float(S["drain"])
	lv["base"] = float(lv["base"]) + edge
	var r := LiveRound.exchange(c, f, m, "")
	lv["base"] = float(lv["base"]) - edge
	var rec: Dictionary = lv["ex"][-1]
	if not plain:
		_post(c, f, m, lv, rec, hands, snap, i)
		if arm in ["NORMAL", "RIGHT", "WRONG", "NOISY"]:
			var row: Array = X.get("%s|%s" % [arm, sit], [0, 0, 0])
			X["%s|%s" % [arm, sit]] = [int(row[0]) + 1, int(row[1]) + (1 if bool(rec["won"]) else 0), int(row[2]) + (1 if hands != "normal" else 0)]
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

static func _w(R: Dictionary, id: String, arm: String) -> float:
	return 100.0 * float(R[id][arm]["win"]) / maxf(1.0, float(R[id][arm]["n"]))

static func _c(R: Dictionary, id: String, arm: String, diff := false) -> String:
	return ("%+.1f" % (_w(R, id, arm) - _w(R, id, "NORMAL"))) if diff else ("%.1f" % _w(R, id, arm))

static func _report(key: String, R: Dictionary, n: int) -> void:
	var s: Dictionary = _sizes(key)
	_say(["", "## Sizes '%s'" % key, "", "Points by the moment [High, Loose]: %s." % str(s["table"]),
		"A plus x %s, a minus x %s, by how the boxer does it (High: Defence + Composure; Loose: Speed + Stamina)." % [str(LineGrade.PLUS), str(Exchanges.COMMIT)],
		"After the settle, as v6: worn guard -%s / -%s; drain %s; blocked share %s; High 1 in 3 landed becomes a block, ours x%s, wear +8%%; hurt chance %s; Loose +1 landed for the winner, +%s head damage." % [str(s["worn"][0]), str(s["worn"][1]), str(s["drain"]), str(s["block"]), str(s["high_out"]), str(s["hurt"]), str(s["loose_dmg"])],
		"", "The arms' lines:"])
	for arm in ["RIGHT", "WRONG", "FULL"]:
		_say("- %s (moment: action): %s." % [arm, str(LINES[arm])])
	_say(["- NOISY: RIGHT's lines; the moment is read right %d times in 100, else taken for one of the other seven." % roundi(READ_RIGHT * 100.0),
		"- RIGHT0: RIGHT's lines with the table zeroed (the instrument's control). ONE:x: that one line of FULL alone.",
		"", "Self-check 2: the reused GuardState.after copy against the game's own guard on exchanges with no line, max |diff| = %.6f points." % guard_diff,
		"", "### Wins in 100 bouts (draws are not wins)", "",
		"| cell | CONTROL | NORMAL | RIGHT | WRONG | NOISY | FULL | RIGHT0 | RIGHT-NORMAL | WRONG-NORMAL | NOISY-NORMAL | RIGHT lines fired a bout |", "|---|---|---|---|---|---|---|---|---|---|---|---|"])
	var b1 := 0; var b2 := 0; var b3 := 0; var b0 := 0; var norm_off := 0.0
	var best_n := {}
	var ones := ["", "### One line alone: wins in 100 against NORMAL", "", "| cell | %s | best |" % " | ".join(ONES), "|---|%s---|" % "---|".repeat(ONES.size())]
	for fm in FORMATS:
		for t in TYPES:
			var id := "%s|%s" % [fm["id"], t["id"]]
			var base := _w(R, id, "NORMAL")
			b1 += 1 if _w(R, id, "RIGHT") - base >= 5.0 else 0
			b2 += 1 if _w(R, id, "WRONG") - base <= -5.0 else 0
			b3 += 1 if _w(R, id, "NOISY") > base + 0.001 else 0
			b0 += 1 if _w(R, id, "RIGHT0") - base >= 5.0 else 0
			norm_off = maxf(norm_off, absf(base - _w(R, id, "CONTROL")))
			_say("| %s %s | %s | %.1f | %s | %s | %s | %s | %s | %s | %s | %s | %s |" % [fm["id"], t["id"], _c(R, id, "CONTROL"), base, _c(R, id, "RIGHT"), _c(R, id, "WRONG"), _c(R, id, "NOISY"), _c(R, id, "FULL"), _c(R, id, "RIGHT0"),
				_c(R, id, "RIGHT", true), _c(R, id, "WRONG", true), _c(R, id, "NOISY", true), "%.1f" % (float(R[id]["RIGHT"]["fired"]) / float(n))])
			var top := -999.0
			for a in ONES:
				top = maxf(top, _w(R, id, a))
			var names := []; var cells := []
			for a in ONES:
				cells.append(_c(R, id, a, true))
				if _w(R, id, a) >= top - 0.001:
					names.append(a)
					best_n[a] = int(best_n.get(a, 0)) + 1
			ones.append("| %s %s | %s | %s |" % [fm["id"], t["id"], " | ".join(cells), ", ".join(names)])
	_say(["", "%d bouts a cell: one win rate is +/- about %.1f in 100 (one sd); the arms share seeds, so a difference between two arms is tighter than that." % [n, 100.0 * sqrt(0.25 / float(n))]])
	_say(ones)
	_say(["", "### One exchange: won in 100, by the moment it is fought in (all cells pooled; a line acts only in its own moments)", "",
		"| the moment | exchanges (NORMAL) | NORMAL | RIGHT | its line | RIGHT-NORMAL | WRONG | its line | WRONG-NORMAL | NOISY | a line fired in 100 |", "|---|---|---|---|---|---|---|---|---|---|---|"])
	for sit in SITS:
		var v := {}
		for a in ["NORMAL", "RIGHT", "WRONG", "NOISY"]:
			var row: Array = X.get("%s|%s" % [a, sit], [0, 0, 0])
			v[a] = 100.0 * float(row[1]) / maxf(1.0, float(row[0]))
		var nz: Array = X.get("NOISY|%s" % sit, [0, 0, 0])
		_say("| %s | %d | %.1f | %.1f | %s | %+.1f | %.1f | %s | %+.1f | %.1f | %.0f |" % [str(Exchanges.MODES[sit]["label"]), int((X.get("NORMAL|%s" % sit, [0, 0, 0]) as Array)[0]), v["NORMAL"],
			v["RIGHT"], str(LINES["RIGHT"].get(sit, "-")), v["RIGHT"] - v["NORMAL"], v["WRONG"], str(LINES["WRONG"].get(sit, "-")), v["WRONG"] - v["NORMAL"], v["NOISY"], 100.0 * float(nz[2]) / maxf(1.0, float(nz[0]))])
	var most := 0; var most_name := ""
	for a in best_n:
		if int(best_n[a]) > most:
			most = int(best_n[a]); most_name = str(a)
	var p1 := b1 >= 8; var p2 := b2 >= 8; var p3 := b3 >= 6; var p4 := most <= 7 and not best_n.is_empty()
	_say(["", "### Bars (sizes '%s')" % key, "",
		"- Bar 1, RIGHT beats NORMAL by 5+ wins in 100 in at least 8 of 12 cells: %d of 12 = %s." % [b1, "PASS" if p1 else "FAIL"],
		"- Bar 2, WRONG loses to NORMAL by 5+ in at least 8 of 12 cells: %d of 12 = %s." % [b2, "PASS" if p2 else "FAIL"],
		"- Bar 3, NOISY (read right %d in 100) still beats NORMAL in at least 6 of 12 cells: %d of 12 = %s." % [roundi(READ_RIGHT * 100.0), b3, "PASS" if p3 else "FAIL"],
		"- Bar 4, no single line best in more than 7 of 12 cells: %s (most: %s, %d of 12) = %s." % [str(best_n), most_name, most, "PASS" if p4 else "FAIL"],
		"- Also: NORMAL against CONTROL, worst cell %.1f in 100 apart (the worn-guard edge and the corner call's cover are the only differences)." % norm_off,
		"- The instrument can read worse: RIGHT0 (the table zeroed) reaches bar 1's +5 in %d of 12 cells." % b0,
		"", "RESULT: tools/guardprobe7.gd -> sizes=%s right=%s(%d/12) wrong=%s(%d/12) noisy=%s(%d/12) single=%s(%d/12) -> %s" % [key, "PASS" if p1 else "FAIL", b1, "PASS" if p2 else "FAIL", b2, "PASS" if p3 else "FAIL", b3, "PASS" if p4 else "FAIL", most, "PASS" if p1 and p2 and p3 and p4 else "FAIL"]])
