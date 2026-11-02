extends RefCounted
## S356 the peak-camp bonus (Game Godot/research/CORE3_DESIGN_S354.md, Kalli's pick): a camp whose three goal lines are all
## met on fight night - made weight, the camp's stat on its target, and her fatigue never overreached - sends her out at her
## peak: +BONUS to every stat for that fight only, and a gold line on the result and the week review. The camp's goal is
## fixed the day the camp starts (the Training tab's line stops moving with her).
##   goal(stats, focus, fighter_goal) -> {stat, target}   lines(camp, f) -> [{id, label, ok}]   met(lines)
##   boost(stats, cap) -> {stat: added} (stats change)   unboost(stats, added)   line(first, lines) -> String
## Pure static; the fatigue line reads WeekPlan.OVERREACHED.

const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

const BONUS := 1.0
## Sim.STAT_CAP: the bonus never lifts a stat past the cap.
const CAP := 99.0
## Weight counts as made within the scale's tolerance (the goal line's own 0.05 kg).
const WEIGHT_SLACK := 0.05


## The camp's stat line: her focus stat, two points up (her FighterGoal's target when it names the same stat).
static func goal(stats: Dictionary, focus: String, fighter_goal: Dictionary) -> Dictionary:
	var key := str(fighter_goal.get("stat", fighter_goal.get("key", "")))
	var target := floorf(float(stats.get(focus, 50.0))) + 2.0
	if key == focus and fighter_goal.has("target"):
		target = float(fighter_goal["target"])
	return {"stat": focus, "target": target}


## The three goal lines as they stand on fight night. camp = f["camp"] ({goal, peak}); empty when the camp set no goal.
static func lines(camp: Dictionary, f: Dictionary) -> Array:
	var g: Dictionary = camp.get("goal", {})
	if g.is_empty():
		return []
	var stat := str(g["stat"])
	return [
		{"id": "weight", "label": "Weight", "ok": float(f.get("weight", 0.0)) <= float(f.get("limit", 0.0)) + WEIGHT_SLACK},
		{"id": stat, "label": stat.capitalize().replace("_", " "),
			"ok": float((f.get("stats", {}) as Dictionary).get(stat, 0.0)) >= float(g["target"])},
		{"id": "fatigue", "label": "Fatigue peak", "ok": float(camp.get("peak", 0.0)) < WeekPlan.OVERREACHED},
	]


static func met(rows: Array) -> bool:
	return rows.size() == 3 and rows.all(func(r): return bool(r["ok"]))


static func boost(stats: Dictionary, cap: float) -> Dictionary:
	var added := {}
	for k in stats:
		var was := float(stats[k])
		stats[k] = minf(cap, was + BONUS)
		added[k] = float(stats[k]) - was
	return added


static func unboost(stats: Dictionary, added: Dictionary) -> void:
	for k in added:
		if stats.has(k):
			stats[k] = float(stats[k]) - float(added[k])


static func line(first: String, rows: Array) -> String:
	if met(rows):
		return "Peak camp: %s met all three goal lines - +%d to every stat tonight." % [first, int(BONUS)]
	var missed := rows.filter(func(r): return not bool(r["ok"])).map(func(r): return str(r["label"]).to_lower())
	return "" if rows.is_empty() else "No peak bonus: %s missed (%s)." % [first, ", ".join(missed)]
