extends RefCounted
## Sim.goal_read's card numbers (split out of Sim.gd in S524, which sat at 500 lines). `rate` = Sim.daily_gain(.., true).

const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")


static func read(career: Career, f: Dictionary, rate: Dictionary) -> Dictionary:
	var goal: Dictionary = f["goal"]
	var p: Dictionary = FighterGoal.progress(goal, f, career.day, rate)
	var card: Dictionary = FighterGoal.card(goal, p)
	# The bar shows the share of the climb from her start to the target, not current / target.
	var share := 0.0
	var n := 0
	for row in p["per_target"]:
		var key := str(row["key"])
		if key == "booked_fight":
			share += float(row["current"])
		else:
			var start := float((goal["start_stats"] as Dictionary).get(key, 0.0))
			share += clampf((float(row["current"]) - start) / maxf(0.001, float(row["target"]) - start), 0.0, 1.0)
		n += 1
	var chip := {"MET": "green", "ON_TRACK": "green", "AT_RISK": "amber"}
	return {
		"title": goal["title"], "status": card["status"], "cls": chip.get(card["status_code"], "red"),
		"left": maxi(0, int(p["days_left"])), "share": share / maxf(1.0, float(n)), "row": ", ".join(card["targets"]).to_lower(),
		"line": goal.get("persona_line", ""),
		"code": card["status_code"], "days_left": int(p["days_left"]), "targets": p["per_target"], "rate": rate,   # S387 WeekRead.goal
	}
