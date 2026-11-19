extends SceneTree
## S527 GUARDPROBE3 - size the opponent's adaptation so guard posture is a real choice.
## Brief: ops/research/TASK_GUARDPROBE3.md. Extends guard_probe2's cells (6 opponent styles x am3 + pro6).
## Per round: body share = cell's measured share + S once our boxer has held the same posture N rounds.
## Arms: N in {2, 3}, S in {0.15, 0.25, 0.35}. Bots: HIGH, LOW, NEUTRAL, SWITCH, WATCH.
## 50 bouts per cell minimum. PASS: no bot best in >60% cells AND at least 3 bots best in 15%+ cells.
##   godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe3.gd

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

const SEED0 := 7000
const N_BOUTS := 50
const LIMIT_S := 4800.0  ## 80-minute ceiling

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

## Arms: N in {2, 3}, S in {0.15, 0.25, 0.35}.
const ARMS := [
	{"N": 2, "S": 0.15},
	{"N": 2, "S": 0.25},
	{"N": 2, "S": 0.35},
	{"N": 3, "S": 0.15},
	{"N": 3, "S": 0.25},
	{"N": 3, "S": 0.35},
]

const BOTS := ["HIGH", "LOW", "NEUTRAL", "SWITCH", "WATCH"]

static var t0 := 0
static var cut_short := false
static var L := []

func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	_say(["# GUARDPROBE3 - size the opponent's adaptation so guard posture is a real choice", "",
		"Run: `godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe3.gd`.",
		"Seeds %d-%d, %d bouts a cell, 12 cells (6 styles x 2 configs)." % [SEED0, SEED0 + N_BOUTS - 1, N_BOUTS],
		"Arms: N in {2, 3}, S in {0.15, 0.25, 0.35}. Bots: HIGH, LOW, NEUTRAL, SWITCH, WATCH.",
		"", "## Method", "",
		"For each cell, run %d bouts and measure the baseline body share (her body shots / her landed)." % N_BOUTS,
		"Then for each (N, S) arm and each bot, simulate the posture decisions round-by-round:",
		"- Track consecutive rounds of the same posture",
		"- Once counter >= N, the shift happens: body share += S for HIGH, body share -= S for LOW",
		"- For each round, compute the damage using the adjusted body share and posture multipliers",
		"", "## Results", ""])
	
	# Step 1: Run bouts and compute baseline body shares
	var cell_data := {}  # cell id -> {baseline_body_share, rounds_data}
	for cell in CELLS:
		if _over_time():
			break
		var rounds_data := []  # array of {through: float}
		var total_body_a := 0
		var total_landed_a := 0
		for i in N_BOUTS:
			if _over_time():
				break
			var r := _play(cell, SEED0 + i)
			total_body_a += int(r["body_a"])
			total_landed_a += int(r["landed_a"])
			rounds_data.append(r["rounds"])
		var baseline_body_share := float(total_body_a) / maxf(1.0, float(total_landed_a))
		cell_data[cell["id"]] = {"baseline_body_share": baseline_body_share, "rounds_data": rounds_data}
		_say("Cell %s: baseline_body_share=%.3f (%d bouts)" % [cell["id"], baseline_body_share, rounds_data.size()])
	
	# Step 2: For each arm, compute damage per bot per cell
	var arm_results := {}  # arm_key -> {bot -> {cell -> damage}}
	for arm in ARMS:
		if _over_time():
			break
		var arm_key := "N=%d_S=%.2f" % [arm["N"], arm["S"]]
		arm_results[arm_key] = {}
		for bot in BOTS:
			arm_results[arm_key][bot] = {}
			for cell in CELLS:
				if _over_time():
					break
				var cd: Dictionary = cell_data.get(cell["id"], {})
				if cd.is_empty():
					continue
				var baseline_body_share: float = cd["baseline_body_share"]
				var rounds_data: Array = cd["rounds_data"]
				var total_damage := 0.0
				for bout_rounds in rounds_data:
					var damage := _simulate_bot(bot, arm, baseline_body_share, bout_rounds, int(cell["rounds"]))
					total_damage += damage
				arm_results[arm_key][bot][cell["id"]] = total_damage
	
	# Step 3: For each arm, find the best bot per cell and check pass condition
	var pass_arms := []
	_say("")
	_say("## Arm results")
	for arm in ARMS:
		if _over_time():
			break
		var arm_key := "N=%d_S=%.2f" % [arm["N"], arm["S"]]
		var best_bot_count := {}
		for bot in BOTS:
			best_bot_count[bot] = 0
		var cell_best := {}  # cell id -> best bot
		for cell in CELLS:
			var best_bot := ""
			var best_damage := 999999.0
			for bot in BOTS:
				var damage: float = arm_results[arm_key][bot].get(cell["id"], 999999.0)
				if damage < best_damage:
					best_damage = damage
					best_bot = bot
			if best_bot != "":
				best_bot_count[best_bot] += 1
				cell_best[cell["id"]] = best_bot
		
		# Check pass condition
		var max_count := 0
		var bots_above_15 := 0
		for bot in BOTS:
			var count: int = best_bot_count[bot]
			max_count = maxi(max_count, count)
			if count >= 2:  # 15% of 12 = 1.8, so >= 2
				bots_above_15 += 1
		var passes := max_count <= 7 and bots_above_15 >= 3  # 60% of 12 = 7.2, so <= 7
		
		_say("")
		_say("### Arm %s" % arm_key)
		_say("Best bot per cell: %s" % str(best_bot_count))
		_say("Max count: %d, bots above 15%%: %d, passes: %s" % [max_count, bots_above_15, str(passes)])
		if passes:
			pass_arms.append(arm_key)
	
	# Step 4: Print the result
	_say("")
	_say("## Summary")
	if pass_arms.is_empty():
		_say("NONE - no arm passes the condition")
		_say("RESULT: tools/guard_probe3.gd -> NONE")
	else:
		var smallest: String = pass_arms[0]
		_say("Smallest passing arm: %s" % smallest)
		_say("RESULT: tools/guard_probe3.gd -> %s" % smallest)
	
	if cut_short:
		_say("- The run hit the brief's 80-minute ceiling and stopped early; the cells above are the ones it finished.")
	
	# Write result page
	var file := FileAccess.open("res://docs/GUARDPROBE3_RESULT.md", FileAccess.WRITE)
	if file == null:
		print("GUARDPROBE3 could not write the result page: %s" % str(FileAccess.get_open_error()))
	else:
		file.store_string("\n".join(L) + "\n")
		file.close()
		print("GUARDPROBE3 wrote docs/GUARDPROBE3_RESULT.md (%.1f s, cut_short=%s)" % [_secs(), str(cut_short)])
	print("GUARDPROBE3 done")
	quit(0)

static func _simulate_bot(bot: String, arm: Dictionary, baseline_body_share: float, bout_rounds: Array, total_rounds: int) -> float:
	var N: int = arm["N"]
	var S: float = arm["S"]
	var total_damage := 0.0
	var counter := 0
	var prev_posture := ""
	var switch_happened := false
	for r_idx in mini(total_rounds, bout_rounds.size()):
		var round_data: Dictionary = bout_rounds[r_idx]
		
		# Determine posture
		var posture := ""
		if bot == "HIGH":
			posture = "high"
		elif bot == "LOW":
			posture = "low"
		elif bot == "NEUTRAL":
			posture = "neutral"
		elif bot == "SWITCH":
			if switch_happened:
				posture = "low"
			else:
				posture = "high"
		elif bot == "WATCH":
			if switch_happened:
				if baseline_body_share > 0.5:
					posture = "low"
				else:
					posture = "high"
			else:
				posture = "neutral"
		
		# Update counter
		if posture == prev_posture:
			counter += 1
		else:
			counter = 1
		
		# Check if switch should happen (for SWITCH and WATCH)
		if bot == "SWITCH" and not switch_happened and counter >= N and posture == "high":
			switch_happened = true
		elif bot == "WATCH" and not switch_happened and counter >= N and posture == "neutral":
			switch_happened = true
		
		# Compute body share
		var body_share := baseline_body_share
		if counter >= N:
			if posture == "high":
				body_share = baseline_body_share + S
			elif posture == "low":
				body_share = baseline_body_share - S
		
		# Compute damage for this round
		var round_through: float = round_data.get("through", 0.0)
		
		# Split into head and body
		var head_damage := round_through * (1.0 - body_share)
		var body_damage := round_through * body_share
		
		# Apply posture multipliers
		head_damage *= GuardWear.posture_damage(posture, "head")
		body_damage *= GuardWear.posture_damage(posture, "body")
		
		total_damage += head_damage + body_damage
		prev_posture = posture
	
	return total_damage

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

static func _play(cell: Dictionary, seed: int) -> Dictionary:
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
	var through_a := 0.0  # through-guard damage taken by us
	var rounds_data := []
	for r in m["rounds"]:
		var round_through := 0.0
		for x in r["exchanges"]:
			landed_a += int(x["landed"][1])
			var g: Dictionary = x.get("guard", {})
			var through: Array = g.get("through", [0.0, 0.0])
			round_through += float(through[0])
		rounds_data.append({"through": round_through})
		through_a += round_through
	var body: Dictionary = f["bout"].get("body", {"a": 0, "b": 0})
	var body_a: int = int(body.get("a", 0))
	return {"body_a": body_a, "landed_a": landed_a, "through_a": through_a, "rounds": rounds_data}
