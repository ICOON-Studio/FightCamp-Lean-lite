extends SceneTree
## S526 GUARDPROBE2 - where do the punches go, by opponent? A probe before the guard posture choice.
## Brief: ops/research/TASK_GUARDPROBE2.md. Measures the body/head split per opponent style, then applies
## GuardWear.posture_damage what-if to the through-guard leak and prints which posture (HIGH/NEUTRAL/LOW)
## leaves our boxer with least total damage per cell.
##   godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe2.gd

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const GuardState := preload("res://scripts/state/GuardState.gd")
const BoutBurn := preload("res://scripts/rules/BoutBurn.gd")
const BodyFacts := preload("res://scripts/rules/BodyFacts.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const StepValue := preload("res://scripts/rules/StepValue.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")

const SEED0 := 6000
const N := 200
const LIMIT_S := 5400.0  ## 90-minute ceiling
const BASE := {"jab": 1.0, "power": 2.5, "heavy": 4.0}

## One shipped opponent per style (from tools/treevalue_probe.gd's STYLE_OPP).
const STYLE_OPP := {
	"Pressure fighter": "Maria Ortega",
	"Slugger": "Jade Cooper",
	"Out-boxer": "Holly Price",
	"Counter-puncher": "Priya Nair",
	"Volume puncher": "Erin Doyle",
	"Boxer-puncher": "Dana Whitfield",
}

## 12 cells: 6 styles x 2 configs (amateur 3x3, pro 6x3).
const CELLS := [
	{"id": "am3_pressure", "cfg": "am3", "pro": false, "rounds": 3, "limit": 60.0, "gap": 0.0, "who": "tess", "style": "Pressure fighter"},
	{"id": "am3_slugger", "cfg": "am3", "pro": false, "rounds": 3, "limit": 60.0, "gap": 0.0, "who": "tess", "style": "Slugger"},
	{"id": "am3_outboxer", "cfg": "am3", "pro": false, "rounds": 3, "limit": 60.0, "gap": 0.0, "who": "tess", "style": "Out-boxer"},
	{"id": "am3_counter", "cfg": "am3", "pro": false, "rounds": 3, "limit": 60.0, "gap": 0.0, "who": "tess", "style": "Counter-puncher"},
	{"id": "am3_volume", "cfg": "am3", "pro": false, "rounds": 3, "limit": 60.0, "gap": 0.0, "who": "tess", "style": "Volume puncher"},
	{"id": "am3_boxpunch", "cfg": "am3", "pro": false, "rounds": 3, "limit": 60.0, "gap": 0.0, "who": "tess", "style": "Boxer-puncher"},
	{"id": "pro6_pressure", "cfg": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "gap": 0.0, "who": "danny", "style": "Pressure fighter"},
	{"id": "pro6_slugger", "cfg": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "gap": 0.0, "who": "danny", "style": "Slugger"},
	{"id": "pro6_outboxer", "cfg": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "gap": 0.0, "who": "danny", "style": "Out-boxer"},
	{"id": "pro6_counter", "cfg": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "gap": 0.0, "who": "danny", "style": "Counter-puncher"},
	{"id": "pro6_volume", "cfg": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "gap": 0.0, "who": "danny", "style": "Volume puncher"},
	{"id": "pro6_boxpunch", "cfg": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "gap": 0.0, "who": "danny", "style": "Boxer-puncher"},
]

const PLANS := [
	{"label": "press behind the cross (1-2, step in, cut off, tie up)", "arrows": [{"move": "1-2"}, {"move": "step_in"}, {"move": "cut_off"}, {"move": "tie_up"}], "combos": {"1-2": 60.0, "1-1": 45.0}},
	{"label": "feint and hook (2-3, feint, pivot, 1-2)", "arrows": [{"move": "2-3"}, {"move": "feint"}, {"move": "pivot_out"}, {"move": "1-2"}], "combos": {"2-3": 60.0, "1-2": 50.0}},
]

static var t0 := 0
static var cut_short := false
static var L := []

func _initialize() -> void:
	var n := N
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--n="):
			n = maxi(1, int(a.trim_prefix("--n=")))
	t0 = Time.get_ticks_msec()
	_say(["# GUARDPROBE2 - where do the punches go, by opponent? (S526)", "",
		"Run: `godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe2.gd`.",
		"Seeds %d-%d, %d bouts a cell, 12 cells (6 styles x 2 configs). Measures the body/head split per opponent style," % [SEED0, SEED0 + n - 1, n],
		"then applies GuardWear.posture_damage what-if to the through-guard leak and prints which posture (HIGH/NEUTRAL/LOW)",
		"leaves our boxer with least total damage per cell.",
		"", "## The rule (read from LiveRound / BoutBurn.MIX / BodyMap)", "",
		"A settled bout splits damage between head and body as follows: LiveRound.open initializes f[\"bout\"][\"body\"] = {a: 0, b: 0}",
		"(body shots taken all fight, a = by her on us, b = by us on her). Each exchange, Exchanges.body_shots(landed, share, roll)",
		"takes a share of landed punches to the body (BODY_SHARE 0.20, BODY_THREAT_SHARE 0.35 if opponent threatens body, BODY_CALL_SHARE",
		"if corner calls 'Go to the body'). Body shots are tracked in f[\"bout\"][\"body\"] and cost energy via Exchanges.body_cost(body).",
		"The body map (BodyMap) tracks damage to specific places (head, eyes, nose, ribs) from ExchangeBeats, with RIB_HIT 2.9 per body hook",
		"and HEAD_HIT 0.59 / FACE_HIT 1.18 for head punches. The damage in m[\"damage\"] is a separate pool (guard through, counters, setups,",
		"reads) not split by body part. The stoppage reads m[\"damage\"] for knockdowns; the result page shows m[\"body_map\"] for the figure.",
		"For this probe, 'body damage' = body shots taken (f[\"bout\"][\"body\"]) as a share of total landed punches; 'head damage' = the rest."])
	var recs := {}
	for cell in CELLS:
		var arr := []
		for i in n:
			if not _over_time():
				arr.append(_play(cell, SEED0 + i, false))
		recs[cell["id"]] = arr
	_say(["", "## 1. Body/head split per cell (baseline, no habit forced)", "",
		"| cell | style | bouts | our body shots taken | our landed body shots | her body share | our body share | her body share (habit) | our body share (habit) |",
		"|---|---|---|---|---|---|---|---|---|"])
	var cell_body_shares := {}  # cell id -> her body share
	for cell in CELLS:
		var arr: Array = recs[cell["id"]]
		if arr.is_empty():
			continue
		var body_a := 0  # body shots taken by us (landed by her)
		var body_b := 0  # body shots landed by us (taken by her)
		var landed_a := 0  # total landed by her on us
		var landed_b := 0  # total landed by us on her
		for r in arr:
			body_a += int(r["body_a"])
			body_b += int(r["body_b"])
			landed_a += int(r["landed_a"])
			landed_b += int(r["landed_b"])
		var her_body_share := float(body_a) / maxf(1.0, float(landed_a))
		var our_body_share := float(body_b) / maxf(1.0, float(landed_b))
		cell_body_shares[str(cell["id"])] = her_body_share
		# Now with habit forced
		var body_a_h := 0
		var body_b_h := 0
		var landed_a_h := 0
		var landed_b_h := 0
		for i in n:
			if _over_time():
				break
			var r: Dictionary = _play(cell, SEED0 + i, true)
			body_a_h += int(r["body_a"])
			body_b_h += int(r["body_b"])
			landed_a_h += int(r["landed_a"])
			landed_b_h += int(r["landed_b"])
		var her_body_share_h := float(body_a_h) / maxf(1.0, float(landed_a_h))
		var our_body_share_h := float(body_b_h) / maxf(1.0, float(landed_b_h))
		_say("| %s | %s | %d | %d | %d | %.3f | %.3f | %.3f | %.3f |" % [
			str(cell["id"]), str(cell["style"]), arr.size(),
			body_a, body_b, her_body_share, our_body_share, her_body_share_h, our_body_share_h])
	_say(["", "## 2. Posture what-if (probe-side only, scripts/ not edited)", "",
		"Applies GuardWear.posture_damage to the through-the-guard leak (GuardState.wear_through's result split head/body by the",
		"measured share) and the +8%% wear for HIGH. Prints per cell which posture (HIGH/NEUTRAL/LOW) leaves our boxer with least",
		"total damage, and by how much in %%.", "",
		"| cell | style | baseline through | HIGH through | NEUTRAL through | LOW through | best | saving %% |",
		"|---|---|---|---|---|---|---|---|"])
	var best_posture_count := {"HIGH": 0, "NEUTRAL": 0, "LOW": 0}
	var body_share_min := 1.0
	var body_share_max := 0.0
	for cell in CELLS:
		var arr: Array = recs[cell["id"]]
		if arr.is_empty():
			continue
		var her_body_share: float = cell_body_shares.get(str(cell["id"]), 0.2)
		body_share_min = minf(body_share_min, her_body_share)
		body_share_max = maxf(body_share_max, her_body_share)
		# Compute baseline through-guard damage (neutral posture)
		var baseline_through := 0.0
		for r in arr:
			baseline_through += float(r["through_a"])
		# Compute posture variants: split through into head/body, apply multipliers
		var head_through := baseline_through * (1.0 - her_body_share)
		var body_through := baseline_through * her_body_share
		var high_through := head_through * GuardWear.posture_damage("high", "head") + body_through * GuardWear.posture_damage("high", "body")
		var neutral_through := head_through * GuardWear.posture_damage("neutral", "head") + body_through * GuardWear.posture_damage("neutral", "body")
		var low_through := head_through * GuardWear.posture_damage("low", "head") + body_through * GuardWear.posture_damage("low", "body")
		# Find best posture
		var best := "NEUTRAL"
		var best_dmg := neutral_through
		if high_through < best_dmg:
			best = "HIGH"
			best_dmg = high_through
		if low_through < best_dmg:
			best = "LOW"
			best_dmg = low_through
		best_posture_count[best] = int(best_posture_count[best]) + 1
		var saving := 0.0
		if baseline_through > 0.0:
			saving = (1.0 - best_dmg / baseline_through) * 100.0
		_say("| %s | %s | %.0f | %.0f | %.0f | %.0f | %s | %.1f%% |" % [
			str(cell["id"]), str(cell["style"]),
			baseline_through, high_through, neutral_through, low_through, best, saving])
	var result_line := "RESULT: tools/guard_probe2.gd -> body_share=%.3f..%.3f best_posture=HIGH %d / NEUTRAL %d / LOW %d" % [
		body_share_min, body_share_max, int(best_posture_count["HIGH"]), int(best_posture_count["NEUTRAL"]), int(best_posture_count["LOW"])]
	_say(["", "## 3. Summary", "", "`%s`" % result_line])
	if cut_short:
		_say("- The run hit the brief's 90-minute ceiling and stopped early; the cells above are the ones it finished.")
	# Write result page
	var file := FileAccess.open("res://docs/GUARDPROBE2_RESULT.md", FileAccess.WRITE)
	if file == null:
		print("GUARDPROBE2 could not write the result page: %s" % str(FileAccess.get_open_error()))
	else:
		file.store_string("\n".join(L) + "\n")
		file.close()
		print("GUARDPROBE2 wrote docs/GUARDPROBE2_RESULT.md (%.1f s, cut_short=%s)" % [_secs(), str(cut_short)])
	print("GUARDPROBE2 done")
	quit(0)

static func _say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s)
		L.append(s)

static func _secs() -> float:
	return float(Time.get_ticks_msec() - t0) / 1000.0

static func _over_time() -> bool:
	cut_short = cut_short or _secs() > LIMIT_S
	return cut_short

static func _play(cell: Dictionary, seed: int, force_habit: bool) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed * 7919 + 13
	var who := str(cell["who"])
	var t := Data.lucy()
	if who != "lucy":
		for p in Data.PROSPECTS:
			if str(p["id"]) == who:
				t = p.duplicate(true)
	var f := Data.fighter_state(t, seed)
	for k in f["stats"]:
		f["stats"][k] = clampf(float(f["stats"][k]) + rng.randf_range(-3.0, 3.0), 25.0, 95.0)
	var plan_idx := 0 if str(cell["cfg"]) == "am3" else 1
	var pl: Dictionary = PLANS[plan_idx]
	f["limit"] = float(cell["limit"])
	f.erase("height")
	f.erase("reach")
	BodyFacts.fill(f)
	f = f.merged({"pro": bool(cell["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [],
		"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
	f.erase("last_bout_day")
	# Find opponent by style
	var opp_name := str(STYLE_OPP.get(str(cell["style"]), ""))
	var all: Array = Data.OPPONENTS + [Data.MISMATCH] + Data.RIVALS + Data.DIVISION_RIVALS
	var opp: Dictionary = {}
	for o in all:
		if str(o["name"]) == opp_name:
			opp = (o as Dictionary).duplicate(true)
			break
	if opp.is_empty():
		for o in all:
			if str(o["style"]) == str(cell["style"]):
				opp = (o as Dictionary).duplicate(true)
				break
	var paper := BoutRules.fight_power(f["stats"], {}, 0, "", bool(cell["pro"]))
	opp["rating"] = paper + float(cell["gap"])
	# Force habit if requested
	if force_habit:
		var habits: Array = RoundStyle.opponent_habits(opp)
		if not habits.has("digs_body_when_hurt"):
			habits.append("digs_body_when_hurt")
		opp["habits"] = habits
		if not str(opp.get("threat", "")).to_lower().contains("body"):
			opp["threat"] = str(opp.get("threat", "")) + " | body"
	f["bout"] = {"opp": opp, "day": seed, "weighed": true, "made": true, "done": false, "film": 1, "rounds": int(cell["rounds"])}
	var c := Career.new()
	c.day = seed
	c.seed = seed
	c.coach = {"rating": 60.0}
	c.fighters = [f]
	var m := {"fid": f["id"], "step": "tape", "total": int(cell["rounds"])}
	BoutNight.play_out(c, f, m)
	# Extract body shots and landed counts
	var landed_a := 0  # total landed by her on us
	var landed_b := 0  # total landed by us on her
	var through_a := 0.0  # through-guard damage taken by us
	for r in m["rounds"]:
		for x in r["exchanges"]:
			landed_a += int(x["landed"][1])
			landed_b += int(x["landed"][0])
			var g: Dictionary = x.get("guard", {})
			var through: Array = g.get("through", [0.0, 0.0])
			through_a += float(through[0])
	var body: Dictionary = f["bout"].get("body", {"a": 0, "b": 0})
	var body_a: int = int(body.get("a", 0))
	var body_b: int = int(body.get("b", 0))
	return {"body_a": body_a, "body_b": body_b, "landed_a": landed_a, "landed_b": landed_b, "through_a": through_a}
