extends RefCounted
## The fighter's goal with a deadline (copied from E:\FightCamp\Game\Godot\scripts\rules\FighterGoal.gd, GOAL1 S238 +
## the S292 retarget, stripped for the lean restart). Pure static functions: no class_name, no preload, no argument mutation.
## Kept: the archetypes week 1-2 use, goal_for, progress (ON TRACK / AT RISK / OFF TRACK / MET / MISSED), outcome, card.
## Dropped: make-the-weight, the gatekeeper, damage control, the walk-out warning, seeded picks and next_choices.
## All targets, buffers and trust/morale deltas are game-design values, not sport-science measurements.

const STAT_KEYS: Array[String] = ["power", "technique", "speed", "defense", "conditioning", "fight_iq", "chin"]
const STAT_MAX: float = 100.0
const STAT_DEFAULT: float = 55.0

const DEBUT_DAYS: int = 28
const SOUTHPAW_DAYS: int = 21
const ENGINE_DAYS: int = 28
## S292: deltas sit where a well-run plan clears about 70% (a focused week trains ~1.0 x coach x headroom).
const DEBUT_CONDITIONING_DELTA: float = 3.5
const SOUTHPAW_TECHNIQUE_DELTA: float = 2.5
## Lean: +2.5, not the prototype's +3: with a coach hired in week 1 she clears it about 70% of the time (decided rule).
const ENGINE_CONDITIONING_DELTA: float = 2.5

## ON_TRACK must hit 100% at least 2 days early; AT_RISK projects to at least 80%; OFF_TRACK less.
const ON_TRACK_BUFFER_DAYS: int = 2
const TARGET_MET_SHARE: float = 1.0
const AT_RISK_MIN_SHARE: float = 0.80
const AT_RISK_UPPER_MISS_SHARE: float = 0.90
const SHARE_EPSILON: float = 0.0001

const SUCCESS_TRUST_DELTA: int = 25
const SUCCESS_MORALE_DELTA: int = 10
const FAILURE_TRUST_DELTA: int = -25
const FAILURE_MORALE_DELTA: int = -20

const ARCHETYPES: Array[Dictionary] = [
	{
		"id": "debut_inside_a_month",
		"title": "Debut inside a month",
		"days": DEBUT_DAYS,
		"targets": {"booked_fight": true, "conditioning": DEBUT_CONDITIONING_DELTA},
		"persona_line": "Get me a fight and get my engine up.",
	},
	## S352 (board review: "Lucy is already 3-1, yet her goal reads 'debut inside a month'"): a boxer with bouts on her card
	## signs with the same month, worded as her next bout.
	{
		"id": "next_bout_inside_a_month",
		"title": "Next bout inside a month",
		"days": DEBUT_DAYS,
		"targets": {"booked_fight": true, "conditioning": DEBUT_CONDITIONING_DELTA},
		"persona_line": "Get me back in the ring and get my engine up.",
	},
	{
		"id": "southpaw_answer",
		"title": "Southpaw answer",
		"days": SOUTHPAW_DAYS,
		"targets": {"technique": SOUTHPAW_TECHNIQUE_DELTA},
		"persona_line": "Sharpen my lead hand so a southpaw cannot circle away.",
	},
	{
		"id": "five_round_engine",
		"title": "Five-round engine",
		"days": ENGINE_DAYS,
		"targets": {"conditioning": ENGINE_CONDITIONING_DELTA},
		"persona_line": "I faded in the last round. Never again.",
	},
]


## A named archetype as a fresh goal from today_day; numeric targets are deltas on the fighter's own start. Unknown id -> {}.
static func goal_for(fighter: Dictionary, archetype_id: String, today_day: int) -> Dictionary:
	var archetype: Dictionary = {}
	for entry in ARCHETYPES:
		if String((entry as Dictionary).get("id", "")) == archetype_id:
			archetype = (entry as Dictionary).duplicate(true)
	if archetype.is_empty():
		return {}
	var start_stats: Dictionary = _snapshot_stats(fighter)
	var targets: Dictionary = {}
	var raw: Dictionary = archetype.get("targets", {})
	for key in raw.keys():
		if key == "booked_fight":
			targets[key] = true
		else:
			targets[key] = minf(STAT_MAX, float(start_stats.get(key, STAT_DEFAULT)) + float(raw[key]))
	return {
		"id": archetype_id,
		"title": String(archetype.get("title", "")),
		"start_day": today_day,
		"deadline_day": today_day + int(archetype.get("days", DEBUT_DAYS)),
		"targets": targets,
		"start_stats": start_stats,
		"persona_line": String(archetype.get("persona_line", "")),
	}


## Current and projected progress toward every target. `gains_rate` is {stat_key: points per day}.
## Returns {days_left, share_done 0..1, projected_share, status, line, per_target: [...]}.
static func progress(goal: Dictionary, fighter_now: Dictionary, today_day: int, gains_rate: Dictionary) -> Dictionary:
	var deadline_day: int = int(goal.get("deadline_day", int(goal.get("start_day", 0)) + DEBUT_DAYS))
	var days_left: int = deadline_day - today_day
	var effective_days: float = float(maxi(0, days_left))
	var early_days: float = maxf(0.0, float(days_left - ON_TRACK_BUFFER_DAYS))
	var targets: Dictionary = _dict_copy(goal.get("targets", {}))
	var start_stats: Dictionary = _dict_copy(goal.get("start_stats", {}))
	var target_keys: Array[String] = _ordered_target_keys(targets)
	var has_numeric_target: bool = false
	for key in target_keys:
		if key != "booked_fight":
			has_numeric_target = true

	var per_target: Array = []
	var all_met: bool = not target_keys.is_empty()
	var sum_share_done: float = 0.0
	var min_projected_share: float = INF
	var min_early_share: float = INF
	for key in target_keys:
		var row: Dictionary = _evaluate_target(key, targets[key], fighter_now, start_stats, gains_rate,
			effective_days, early_days, days_left, has_numeric_target)
		per_target.append(row)
		if not bool(row.get("met", false)):
			all_met = false
		sum_share_done += float(row.get("share_done", 0.0))
		min_projected_share = minf(min_projected_share, float(row.get("trajectory_projected_share", 0.0)))
		min_early_share = minf(min_early_share, float(row.get("trajectory_early_share", 0.0)))

	var share_done: float = 0.0
	if not per_target.is_empty():
		share_done = clampf(sum_share_done / float(per_target.size()), 0.0, 1.0)
	if all_met:
		share_done = 1.0
	var projected_share: float = 0.0
	var early_share: float = 0.0
	if not per_target.is_empty() and is_finite(min_projected_share):
		projected_share = maxf(0.0, min_projected_share)
		early_share = maxf(0.0, min_early_share)

	var status: String = "OFF_TRACK"
	if all_met:
		status = "MET"
	elif days_left < 0:
		status = "MISSED"
	elif days_left >= ON_TRACK_BUFFER_DAYS and early_share >= TARGET_MET_SHARE - SHARE_EPSILON:
		status = "ON_TRACK"
	elif projected_share >= AT_RISK_MIN_SHARE - SHARE_EPSILON:
		status = "AT_RISK"

	var clean_per_target: Array = []
	for item in per_target:
		var clean_row: Dictionary = (item as Dictionary).duplicate(true)
		clean_row.erase("trajectory_projected_share")
		clean_row.erase("trajectory_early_share")
		clean_per_target.append(clean_row)
	return {
		"days_left": days_left,
		"share_done": share_done,
		"projected_share": projected_share,
		"status": status,
		"line": _progress_line(goal, status, days_left, share_done, projected_share),
		"per_target": clean_per_target,
	}


## The end of the goal window: trust and morale move.
static func outcome(goal: Dictionary, met: bool) -> Dictionary:
	var title: String = String(goal.get("title", "Fighter goal")).strip_edges()
	if title.is_empty():
		title = "Fighter goal"
	if met:
		return {
			"trust_delta": SUCCESS_TRUST_DELTA,
			"morale_delta": SUCCESS_MORALE_DELTA,
			"line": "%s met: fighter trust +%d, morale +%d." % [title, SUCCESS_TRUST_DELTA, SUCCESS_MORALE_DELTA],
		}
	return {
		"trust_delta": FAILURE_TRUST_DELTA,
		"morale_delta": FAILURE_MORALE_DELTA,
		"line": "%s missed: trust %d, morale %d - walk-out warning, she may walk out to a rival gym." % [
			title, FAILURE_TRUST_DELTA, FAILURE_MORALE_DELTA],
	}


## The goal card strings: title, "DAYS LEFT 18", status word, one line per target, colour key.
static func card(goal: Dictionary, progress_read: Dictionary) -> Dictionary:
	var raw_status: String = String(progress_read.get("status", "OFF_TRACK"))
	var target_lines: Array[String] = []
	for entry in progress_read.get("per_target", []):
		if entry is Dictionary:
			target_lines.append(String((entry as Dictionary).get("line", "")))
	var colour: String = _colour_for_status(raw_status)
	return {
		"title": String(goal.get("title", "Fighter goal")),
		"days_left": "DAYS LEFT %d" % maxi(0, int(progress_read.get("days_left", 0))),
		"status": raw_status.replace("_", " "),
		"status_code": raw_status,
		"targets": target_lines,
		"colour": colour,
		"line": String(progress_read.get("line", "")),
	}


static func _snapshot_stats(fighter: Dictionary) -> Dictionary:
	var raw_stats: Dictionary = _dict_copy(fighter.get("stats", {}))
	var snap: Dictionary = {}
	for key in STAT_KEYS:
		snap[key] = float(raw_stats.get(key, fighter.get(key, STAT_DEFAULT)))
	return snap


static func _ordered_target_keys(targets: Dictionary) -> Array[String]:
	var ordered: Array[String] = []
	for key in ["booked_fight", "conditioning", "technique", "speed", "power", "defense", "fight_iq", "chin"]:
		if targets.has(key):
			ordered.append(key)
	return ordered


static func _evaluate_target(key: String, target_val: Variant, fighter_now: Dictionary, start_stats: Dictionary,
		gains_rate: Dictionary, effective_days: float, early_days: float, days_left: int, has_numeric_target: bool) -> Dictionary:
	if key == "booked_fight":
		var booked: bool = bool(fighter_now.get("booked_fight", false))
		var cur_booked: float = 1.0 if booked else 0.0
		# While training days remain, booking is an event still to come: it does not drag the trajectory until the end.
		var traj_proj: float = cur_booked
		var traj_early: float = cur_booked
		if not booked and has_numeric_target:
			if days_left >= ON_TRACK_BUFFER_DAYS:
				traj_proj = 1.0
				traj_early = 1.0
			elif days_left > 0:
				traj_proj = 1.0
				traj_early = AT_RISK_UPPER_MISS_SHARE
		return {
			"key": key, "label": _label_for_key(key), "current": cur_booked, "target": 1.0, "projected": cur_booked,
			"share_done": cur_booked, "projected_share": cur_booked, "trajectory_projected_share": traj_proj,
			"trajectory_early_share": traj_early, "met": booked,
			"status": "MET" if booked else ("MISSED" if days_left < 0 else ("ON_TRACK" if traj_early >= 1.0 else "AT_RISK")),
			"line": "%s %d / 1" % [_label_for_key(key), 1 if booked else 0],
		}
	var numeric_target: float = float(target_val)
	var stats: Dictionary = _dict_copy(fighter_now.get("stats", {}))
	var current_val: float = float(stats.get(key, start_stats.get(key, STAT_DEFAULT)))
	var rate_val: float = float(gains_rate.get(key, 0.0))
	var projected_val: float = current_val + rate_val * effective_days
	var early_val: float = current_val + rate_val * early_days
	var met: bool = current_val >= numeric_target - SHARE_EPSILON
	var denom: float = maxf(numeric_target, 0.001)
	var share_done: float = 1.0 if met else clampf(current_val / denom, 0.0, 1.0)
	var projected_share: float = maxf(0.0, projected_val / denom)
	var early_share: float = maxf(0.0, early_val / denom)
	var item_status: String = "OFF_TRACK"
	if met:
		item_status = "MET"
	elif days_left < 0:
		item_status = "MISSED"
	elif days_left >= ON_TRACK_BUFFER_DAYS and early_share >= TARGET_MET_SHARE - SHARE_EPSILON:
		item_status = "ON_TRACK"
	elif projected_share >= AT_RISK_MIN_SHARE - SHARE_EPSILON:
		item_status = "AT_RISK"
	return {
		"key": key, "label": _label_for_key(key), "current": current_val, "target": numeric_target,
		"projected": projected_val, "share_done": share_done, "projected_share": projected_share,
		"trajectory_projected_share": projected_share, "trajectory_early_share": early_share, "met": met,
		"status": item_status, "line": _format_target_line(key, current_val, numeric_target),
	}


static func _label_for_key(key: String) -> String:
	match key:
		"booked_fight":
			return "Booked Fight"
		"defense":
			return "Defence"
		"fight_iq":
			return "Ring IQ"
		_:
			return key.capitalize()


static func _format_target_line(key: String, current_val: float, target_num: float) -> String:
	var label: String = _label_for_key(key)
	if absf(current_val - roundf(current_val)) < 0.05 and absf(target_num - roundf(target_num)) < 0.05:
		return "%s %d / %d" % [label, roundi(current_val), roundi(target_num)]
	return "%s %.1f / %.1f" % [label, current_val, target_num]


static func _progress_line(goal: Dictionary, status: String, days_left: int, share_done: float, projected_share: float) -> String:
	var title: String = String(goal.get("title", "Fighter goal"))
	var pct_done: int = roundi(share_done * 100.0)
	var pct_proj: int = roundi(projected_share * 100.0)
	match status:
		"MET":
			return "%s - MET (%d%% complete, %d days left)" % [title, pct_done, maxi(0, days_left)]
		"MISSED":
			return "%s - MISSED (deadline passed by %d days, %d%% complete)" % [title, absi(days_left), pct_done]
		"ON_TRACK":
			return "%s - ON TRACK (%d days left, projected %d%%)" % [title, days_left, pct_proj]
		"AT_RISK":
			return "%s - AT RISK (%d days left, projected %d%%)" % [title, days_left, pct_proj]
		_:
			return "%s - OFF TRACK (%d days left, projected %d%%)" % [title, maxi(0, days_left), pct_proj]


static func _colour_for_status(status: String) -> String:
	match status:
		"MET":
			return "gold"
		"ON_TRACK":
			return "cool"
		"AT_RISK":
			return "amber"
		_:
			return "red"


static func _dict_copy(value: Variant) -> Dictionary:
	if value is Dictionary:
		return (value as Dictionary).duplicate(true)
	return {}
