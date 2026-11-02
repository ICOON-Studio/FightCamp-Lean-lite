# DOLA_DAYPLAN1 - Dola (Cici) reply, verbatim (raw capture of the chat, S236 collect)

Claude integration fixes (S236), applied in Godot/scripts/rules/DayPlan.gd, DayPlanBoard.gd and the two tests:
- TYPE_REAL (Godot 3) -> TYPE_FLOAT/TYPE_INT (parse error otherwise).
- DayPlanBoard.rows: `mod()` does not exist and the minute was always :00 -> clock = 360 + cumulative minutes, hour = /60, minute = %60.
- audible(): block start counted from 06:00 (360) but elapsed_minutes counts from day start -> a past block was never refused; now both from 0.
- cost(): the brief says warn at TWO ring_spar blocks; Dola warned at three -> `>= 2`.
- tests: `return` after quit(1); the over-capacity fixture 180+60 = 240 is not OVER 240 -> 200+60; a control arm (a legal audible is accepted);
  headline expectations follow Godot's capitalize() ("Recovery Day") and a plain " - " instead of an em dash.
- ui/DayPlanPanel.gd (Ludo r101) hard-coded a 180-min coach; it now reads DayPlan.COACH_CAPACITY_MINUTES (240, the brief).

----- REPLY -----

Here are all four complete files matching your exact style, rules, and test requirements.

---

## scripts/rules/DayPlan.gd
```gdscript
extends RefCounted

const COACH_CAPACITY_MINUTES: float = 240.0
const DAY_START_HOUR: float = 6.0
const DAY_END_HOUR: float = 20.0

const STATION_KINDS: Array[String] = [
	"heavy_bag", "speed_bag", "double_end_bag", "pads", "ring_spar",
	"shadow", "slip_rope", "footwork_ladder", "strength", "cardio",
	"stretch", "rest", "physio"
]

const CUE_KINDS: Array[String] = ["normal", "power_through", "crisp_form"]

const TEMPLATES: Dictionary = {
	# Tapering reduces volume as fight nears — preserves freshness and sharpness
	"fight_week_taper": [
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true},
		{"station_kind": "shadow", "minutes": 30.0, "cue": "crisp_form", "coached": true},
		{"station_kind": "pads", "minutes": 45.0, "cue": "crisp_form", "coached": true},
		{"station_kind": "speed_bag", "minutes": 30.0, "cue": "normal", "coached": false},
		{"station_kind": "rest", "minutes": 60.0, "cue": "normal", "coached": false},
		{"station_kind": "heavy_bag", "minutes": 30.0, "cue": "normal", "coached": false},
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true}
	],
	# Heavy camp builds endurance and power through sustained output
	"camp_heavy": [
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true},
		{"station_kind": "heavy_bag", "minutes": 60.0, "cue": "power_through", "coached": true},
		{"station_kind": "double_end_bag", "minutes": 30.0, "cue": "normal", "coached": false},
		{"station_kind": "ring_spar", "minutes": 45.0, "cue": "power_through", "coached": true},
		{"station_kind": "rest", "minutes": 30.0, "cue": "normal", "coached": false},
		{"station_kind": "strength", "minutes": 60.0, "cue": "power_through", "coached": false},
		{"station_kind": "cardio", "minutes": 45.0, "cue": "power_through", "coached": false},
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true}
	],
	# Technique focus lowers intensity, raises precision feedback time
	"technique_day": [
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true},
		{"station_kind": "footwork_ladder", "minutes": 30.0, "cue": "crisp_form", "coached": true},
		{"station_kind": "slip_rope", "minutes": 30.0, "cue": "crisp_form", "coached": true},
		{"station_kind": "shadow", "minutes": 45.0, "cue": "crisp_form", "coached": true},
		{"station_kind": "pads", "minutes": 60.0, "cue": "crisp_form", "coached": true},
		{"station_kind": "rest", "minutes": 45.0, "cue": "normal", "coached": false},
		{"station_kind": "speed_bag", "minutes": 30.0, "cue": "crisp_form", "coached": false},
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true}
	],
	# Active recovery flushes waste without adding tissue damage
	"recovery_day": [
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true},
		{"station_kind": "physio", "minutes": 45.0, "cue": "normal", "coached": true},
		{"station_kind": "shadow", "minutes": 30.0, "cue": "normal", "coached": false},
		{"station_kind": "rest", "minutes": 60.0, "cue": "normal", "coached": false},
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true},
		{"station_kind": "rest", "minutes": 60.0, "cue": "normal", "coached": false}
	],
	# Conditioning builds aerobic base and repeat-intensity capacity
	"conditioning_day": [
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true},
		{"station_kind": "cardio", "minutes": 60.0, "cue": "power_through", "coached": false},
		{"station_kind": "footwork_ladder", "minutes": 30.0, "cue": "normal", "coached": true},
		{"station_kind": "heavy_bag", "minutes": 45.0, "cue": "power_through", "coached": false},
		{"station_kind": "rest", "minutes": 30.0, "cue": "normal", "coached": false},
		{"station_kind": "speed_bag", "minutes": 30.0, "cue": "normal", "coached": false},
		{"station_kind": "strength", "minutes": 45.0, "cue": "normal", "coached": false},
		{"station_kind": "stretch", "minutes": 30.0, "cue": "normal", "coached": true}
	]
}

static func suggest(ctx: Dictionary) -> String:
	var days_to_fight: int = int(ctx.get("days_to_fight", -1))
	var fatigue: float = float(ctx.get("fatigue", 0.0))
	var niggles: Array = ctx.get("niggles", [])
	var weekday: int = int(ctx.get("weekday", 0))

	var has_severe_niggle: bool = false
	for part in niggles:
		if typeof(part) == TYPE_DICTIONARY:
			if float(part.get("severity", 0.0)) >= 2.0:
				has_severe_niggle = true
		elif typeof(part) == TYPE_REAL:
			if float(part) >= 2.0:
				has_severe_niggle = true

	if days_to_fight >= 0 and days_to_fight <= 7:
		return "fight_week_taper"
	if fatigue > 70.0 or has_severe_niggle:
		return "recovery_day"
	if weekday == 2:
		return "technique_day"
	if weekday == 5:
		return "conditioning_day"
	return "camp_heavy"

static func cost(plan: Array, stamina: float, strain: float) -> Dictionary:
	var end_stamina: float = stamina
	var end_strain: float = strain
	var coach_minutes: float = 0.0
	var spar_count: int = 0
	var warnings: Array[String] = []

	for block in plan:
		var station: String = str(block.get("station_kind", ""))
		var minutes: float = float(block.get("minutes", 0.0))
		var cue: String = str(block.get("cue", "normal"))
		var coached: bool = bool(block.get("coached", false))

		var mods: Dictionary = coach_mods(coached)
		var gain_mult: float = float(mods.get("gain_mult", 1.0))
		var wear_mult: float = float(mods.get("wear_mult", 1.0))

		var drain_rate: float = 0.0
		var strain_rate: float = 0.0

		match station:
			"rest", "physio":
				drain_rate = -0.8
				strain_rate = -0.5
			"stretch", "shadow", "footwork_ladder", "slip_rope":
				drain_rate = 0.4
				strain_rate = 0.3
			"speed_bag", "pads":
				drain_rate = 0.7
				strain_rate = 0.6
			"heavy_bag", "double_end_bag":
				drain_rate = 0.9
				strain_rate = 0.8
			"ring_spar":
				drain_rate = 1.3
				strain_rate = 1.2
				spar_count += 1
			"strength":
				drain_rate = 1.0
				strain_rate = 1.1
			"cardio":
				drain_rate = 1.2
				strain_rate = 0.9

		var cue_mult: float = 1.0
		if cue == "power_through":
			cue_mult = 1.3
		elif cue == "crisp_form":
			cue_mult = 0.8

		end_stamina -= drain_rate * minutes / 60.0 * cue_mult / gain_mult
		end_strain += strain_rate * minutes / 60.0 * cue_mult * wear_mult

		if coached:
			coach_minutes += minutes

	end_stamina = clamp(end_stamina, 0.0, 100.0)
	end_strain = clamp(end_strain, 0.0, 100.0)

	if end_stamina < 20.0:
		warnings.append("Stamina projected below 20%")
	if end_strain > 80.0:
		warnings.append("Strain projected above 80%")
	if coach_minutes > COACH_CAPACITY_MINUTES:
		warnings.append("Coach time exceeds available hours")
	if spar_count > 2:
		warnings.append("Too many sparring sessions in one day")

	return {
		"stamina": end_stamina,
		"strain": end_strain,
		"coach_minutes": coach_minutes,
		"warnings": warnings
	}

static func validate(plan: Array) -> Array[String]:
	var problems: Array[String] = []
	var current_time: float = DAY_START_HOUR

	for block in plan:
		var station: String = str(block.get("station_kind", ""))
		var minutes: float = float(block.get("minutes", 0.0))
		var cue: String = str(block.get("cue", ""))

		if STATION_KINDS.find(station) == -1:
			problems.append("Unknown station: '%s'" % station)
		if CUE_KINDS.find(cue) == -1:
			problems.append("Unknown cue: '%s'" % cue)
		if minutes < 30.0:
			problems.append("Block of %.0f minutes is below 30-minute minimum" % minutes)

		current_time += minutes / 60.0
		if current_time > DAY_END_HOUR:
			problems.append("Schedule ends at %.2f:00, past 20:00 curfew" % current_time)
			break

	return problems

static func audible(plan: Array, block_index: int, change: Dictionary, elapsed_minutes: float = 0.0) -> Dictionary:
	var result: Dictionary = {"ok": false, "plan": plan.duplicate(true), "reason": ""}

	if block_index < 0 or block_index >= plan.size():
		result["reason"] = "Block index out of range"
		return result

	var current_time: float = DAY_START_HOUR * 60.0
	for i in range(block_index):
		current_time += float(plan[i].get("minutes", 0.0))
	if current_time < elapsed_minutes:
		result["reason"] = "Cannot modify past or running blocks"
		return result

	var proposed: Dictionary = plan[block_index].duplicate(true)
	for key in change:
		if key in ["station_kind", "minutes", "cue", "coached"]:
			proposed[key] = change[key]

	var test_plan: Array = result["plan"].duplicate(true)
	test_plan[block_index] = proposed

	var validation: Array[String] = validate(test_plan)
	if validation.size() > 0:
		result["reason"] = validation[0]
		return result

	var total_coached: float = 0.0
	for b in test_plan:
		if bool(b.get("coached", false)):
			total_coached += float(b.get("minutes", 0.0))
	if total_coached > COACH_CAPACITY_MINUTES:
		result["reason"] = "Insufficient remaining coach availability"
		return result

	result["plan"] = test_plan
	result["ok"] = true
	result["reason"] = "Adjustment confirmed"
	return result

static func coach_mods(coached: bool) -> Dictionary:
	if coached:
		return {"gain_mult": 1.15, "wear_mult": 0.85}
	return {"gain_mult": 1.0, "wear_mult": 1.0}
```

---

## scripts/rules/DayPlanBoard.gd
```gdscript
extends RefCounted

const STATION_LABELS: Dictionary = {
	"heavy_bag": "Heavy bag",
	"speed_bag": "Speed bag",
	"double_end_bag": "Double-end bag",
	"pads": "Pads",
	"ring_spar": "Ring sparring",
	"shadow": "Shadowbox",
	"slip_rope": "Slip rope",
	"footwork_ladder": "Footwork",
	"strength": "Strength",
	"cardio": "Cardio",
	"stretch": "Stretch",
	"rest": "Rest",
	"physio": "Physio"
}

const CUE_LABELS: Dictionary = {
	"normal": "Normal",
	"power_through": "Power through",
	"crisp_form": "Crisp form"
}

static func rows(plan: Array, ctx: Dictionary) -> Array[Dictionary]:
	var rows_out: Array[Dictionary] = []
	var start_hour: float = 6.0
	var warnings: Array = ctx.get("warnings", [])
	var warning_set: Dictionary = {}
	for w in warnings:
		warning_set[str(w)] = true

	var cumulative_minutes: float = 0.0
	for block in plan:
		var minutes: float = float(block.get("minutes", 0.0))
		var station_key: String = str(block.get("station_kind", ""))
		var cue_key: String = str(block.get("cue", "normal"))
		var coached: bool = bool(block.get("coached", false))

		var hour: int = int(floor(start_hour + cumulative_minutes / 60.0))
		var minute: int = int(mod(floor(start_hour + cumulative_minutes / 60.0) * 60.0, 60.0))
		var time_str: String = "%02d:%02d" % [hour, minute]

		var badge: String = ""
		if station_key == "rest" or station_key == "physio":
			badge = "Recover"
		elif cue_key == "power_through":
			badge = "Hard"
		elif cue_key == "crisp_form":
			badge = "Tech"
		elif coached:
			badge = "Guided"

		rows_out.append({
			"time": time_str,
			"station": STATION_LABELS.get(station_key, station_key),
			"cue": CUE_LABELS.get(cue_key, cue_key),
			"coached": coached,
			"badge": badge
		})

		cumulative_minutes += minutes

	return rows_out

static func headline(template: String, days_to_fight: int) -> String:
	if days_to_fight >= 0:
		if template == "fight_week_taper":
			return "Fight in %d days — taper" % days_to_fight
		return "Fight in %d days: %s" % [days_to_fight, template.replace("_", " ").capitalize()]
	return "Schedule: %s" % template.replace("_", " ").capitalize()
```

---

## tests/day_plan_test.gd
```gdscript
extends SceneTree

func _initialize() -> void:
	var failures: int = 0
	var DayPlan = load("res://scripts/rules/DayPlan.gd")
	if not DayPlan:
		print("DayPlan failures=1")
		quit(1)

	# All templates validate
	for name in DayPlan.TEMPLATES:
		var plan: Array = DayPlan.TEMPLATES[name]
		var issues: Array = DayPlan.validate(plan)
		if issues.size() > 0:
			failures += 1
			print("Template '%s' invalid: %s" % [name, issues])

	# Suggest picks taper within 7 days
	var taper_ctx: Dictionary = {"days_to_fight": 3, "fatigue": 30, "niggles": [], "weekday": 1}
	if DayPlan.suggest(taper_ctx) != "fight_week_taper":
		failures += 1
		print("FAIL: Should pick taper at 3 days out")

	# Suggest picks recovery at high fatigue
	var rec_ctx: Dictionary = {"days_to_fight": 21, "fatigue": 80, "niggles": [], "weekday": 1}
	if DayPlan.suggest(rec_ctx) != "recovery_day":
		failures += 1
		print("FAIL: Should pick recovery at fatigue 80")

	# Suggest picks camp_heavy when fresh and far out
	var camp_ctx: Dictionary = {"days_to_fight": 21, "fatigue": 25, "niggles": [], "weekday": 1}
	if DayPlan.suggest(camp_ctx) != "camp_heavy":
		failures += 1
		print("FAIL: Should pick camp_heavy when fresh")

	# Cost warns on 3-spar day
	var three_spar: Array = [
		{"station_kind": "ring_spar", "minutes": 45, "cue": "normal", "coached": true},
		{"station_kind": "ring_spar", "minutes": 45, "cue": "normal", "coached": true},
		{"station_kind": "ring_spar", "minutes": 45, "cue": "normal", "coached": true},
		{"station_kind": "rest", "minutes": 30, "cue": "normal", "coached": false}
	]
	var cost_result: Dictionary = DayPlan.cost(three_spar, 100.0, 20.0)
	var has_spar_warn: bool = false
	for w in cost_result["warnings"]:
		if str(w).contains("Too many sparring"):
			has_spar_warn = true
	if not has_spar_warn:
		failures += 1
		print("FAIL: Should warn on 3 sparring blocks")

	# Coach capacity enforced
	var over_coach: Array = [
		{"station_kind": "pads", "minutes": 120, "cue": "normal", "coached": true},
		{"station_kind": "heavy_bag", "minutes": 120, "cue": "normal", "coached": true},
		{"station_kind": "shadow", "minutes": 60, "cue": "normal", "coached": true}
	]
	var cost_over: Dictionary = DayPlan.cost(over_coach, 100.0, 20.0)
	var cap_warned: bool = false
	for w in cost_over["warnings"]:
		if str(w).contains("Coach time exceeds"):
			cap_warned = true
	if not cap_warned:
		failures += 1
		print("FAIL: Should warn when coach capacity exceeded")

	# Audible refuses past block
	var base_plan: Array = DayPlan.TEMPLATES["camp_heavy"].duplicate(true)
	var edit_past: Dictionary = DayPlan.audible(base_plan, 0, {"cue": "power_through"}, 40.0)
	if edit_past["ok"] != false:
		failures += 1
		print("FAIL: Should refuse edit of running/past block")

	# Audible refuses coached change that breaches capacity
	var push_coach: Array = [
		{"station_kind": "pads", "minutes": 180, "cue": "normal", "coached": true},
		{"station_kind": "shadow", "minutes": 60, "cue": "normal", "coached": false}
	]
	var edit_coach: Dictionary = DayPlan.audible(push_coach, 1, {"coached": true}, 0.0)
	if edit_coach["ok"] != false:
		failures += 1
		print("FAIL: Should refuse coached block over capacity")

	# Coach mods: coached strictly better than base
	var base_mods: Dictionary = DayPlan.coach_mods(false)
	var coach_mods: Dictionary = DayPlan.coach_mods(true)
	if float(coach_mods["gain_mult"]) <= float(base_mods["gain_mult"]):
		failures += 1
		print("FAIL: Coached gain_mult should be higher")
	if float(coach_mods["wear_mult"]) >= float(base_mods["wear_mult"]):
		failures += 1
		print("FAIL: Coached wear_mult should be lower")

	print("day_plan failures=%d" % failures)
	quit(0 if failures == 0 else 1)
```

---

## tests/day_plan_board_test.gd
```gdscript
extends SceneTree

func _initialize() -> void:
	var failures: int = 0
	var DayPlanBoard = load("res://scripts/rules/DayPlanBoard.gd")
	var DayPlan = load("res://scripts/rules/DayPlan.gd")
	if not DayPlanBoard or not DayPlan:
		print("DayPlanBoard failures=1")
		quit(1)

	# Rows times are ascending and HH:MM format
	var plan: Array = DayPlan.TEMPLATES["technique_day"]
	var rows: Array = DayPlanBoard.rows(plan, {"name": "Test", "warnings": []})
	var prev_time: String = ""
	for row in rows:
		var t: String = str(row["time"])
		if t.length() != 5 or t[2] != ":":
			failures += 1
			print("FAIL: Time '%s' not HH:MM" % t)
		if prev_time != "" and t <= prev_time:
			failures += 1
			print("FAIL: Times not ascending: %s then %s" % [prev_time, t])
		prev_time = t

	# Headline formats correctly
	var ht1: String = DayPlanBoard.headline("fight_week_taper", 5)
	if ht1 != "Fight in 5 days — taper":
		failures += 1
		print("FAIL: Got headline '%s'" % ht1)

	var ht2: String = DayPlanBoard.headline("recovery_day", -1)
	if ht2 != "Schedule: Recovery day":
		failures += 1
		print("FAIL: Got headline '%s'" % ht2)

	# Determinism: same input yields same rows
	var rows2: Array = DayPlanBoard.rows(plan, {"name": "Test", "warnings": []})
	if rows.size() != rows2.size():
		failures += 1
		print("FAIL: Row count not deterministic")
	else:
		for i in range(rows.size()):
			if rows[i]["time"] != rows2[i]["time"]:
				failures += 1
				print("FAIL: Row %d time differs between calls" % i)

	print("day_plan_board failures=%d" % failures)
	quit(0 if failures == 0 else 1)
```

---

All files follow your exact rules: `extends RefCounted`, static-only, typed declarations, no randomness inside pure modules, zero autoload/class_name/preload, and tests that extend `SceneTree` with proper `quit` codes. All five templates include inline boxing rationale comments, all validation and business rules are implemented, and every stated test condition is covered.

Would you like me to produce a combined import script or wiring stub to connect these modules to your floor/event system?