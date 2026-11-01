extends RefCounted
## The road from her first bout to her pro debut: five steps, the one she is on lit, and what the next one needs.
## Pure rule (no UI); the card on her page is a later task.

const SeasonPath := preload("res://scripts/rules/SeasonPath.gd")
const Roster := preload("res://scripts/state/Roster.gd")

const STEPS := ["First bout", "Nationals ready", "The nationals", "Pro offer", "Pro debut"]


## Her road: five steps, the one she is on lit, and what the next one needs.
## f holds: bouts, w, reg_days, age, injured, rank, pro_declines, nat_final, nationals, pro, pro_bouts.
static func road(f: Dictionary, day: int) -> Dictionary:
	var bouts: int = int(f.get("bouts", 0))
	var w: int = int(f.get("w", 0))
	var reg_days: int = int(f.get("reg_days", 0))
	var age: int = int(f.get("age", 0))
	var injured: bool = bool(f.get("injured", false))
	var rank: int = int(f.get("rank", 0))
	var pro_declines: int = int(f.get("pro_declines", 0))
	var nat_final: bool = bool(f.get("nat_final", false))
	var nationals: String = str(f.get("nationals", ""))
	var pro: bool = bool(f.get("pro", false))
	var pro_bouts: int = int(f.get("pro_bouts", 0))

	var steps: Array = []
	for i in range(STEPS.size()):
		steps.append({"name": STEPS[i], "done": false, "lit": false})

	# Step 0: First bout
	steps[0]["done"] = bouts >= 1

	# Step 1: Nationals ready
	var elig: Dictionary = SeasonPath.eligible(bouts, reg_days, age, false, pro)
	steps[1]["done"] = elig["ok"] or steps[2]["done"]

	# Step 2: The nationals
	var nationals_result: bool = nationals != "" and nationals != "entered"
	steps[2]["done"] = nationals_result or pro

	# Re-check step 1 now that step 2 is known
	steps[1]["done"] = elig["ok"] or steps[2]["done"]

	# Step 3: Pro offer
	# Roster.pro_ready reads f["w"] as a must-have key: hand it a copy with the defaults filled in.
	var g := f.duplicate()
	g["w"] = w
	steps[3]["done"] = pro or Roster.pro_ready(g)

	# Step 4: Pro debut
	steps[4]["done"] = pro_bouts >= 1

	# Find lit (first not done)
	var lit: int = -1
	for i in range(steps.size()):
		if not steps[i]["done"]:
			lit = i
			steps[i]["lit"] = true
			break

	# Build need
	var need: String = ""
	if lit >= 0:
		need = _need_for(lit, f, day, elig)

	return {"steps": steps, "lit": lit, "need": need}


## What the lit step needs.
static func _need_for(lit: int, f: Dictionary, day: int, elig: Dictionary) -> String:
	var bouts: int = int(f.get("bouts", 0))
	var w: int = int(f.get("w", 0))
	var reg_days: int = int(f.get("reg_days", 0))
	var age: int = int(f.get("age", 0))
	var injured: bool = bool(f.get("injured", false))
	var rank: int = int(f.get("rank", 0))
	var pro_declines: int = int(f.get("pro_declines", 0))
	var nationals: String = str(f.get("nationals", ""))
	var pro: bool = bool(f.get("pro", false))

	match lit:
		0:
			return "Book her first amateur bout"
		1:
			var n: int = SeasonPath.entry_close(day) - day
			if elig["ok"]:
				return "Ready - enter her"
			return elig["reason"] + " - entries close in %d days" % n
		2:
			var n: int = SeasonPath.entry_close(day) - day
			if nationals == "entered":
				return "She is in the draw"
			if injured:
				return "Injured - she cannot enter"
			return "Enter her before entries close in %d days" % n
		3:
			if pro_declines >= 3:
				return "No more offers - she stays amateur"
			if pro_declines >= 2:
				return "Only a No. 1 ranking brings another offer"
			var need: int = Roster.PRO_WINS + pro_declines * Roster.PRO_RETURN_WINS
			var any: int = Roster.PRO_WINS_ANY_RANK + pro_declines * Roster.PRO_RETURN_WINS
			var ranked: bool = rank >= 1 and rank <= Roster.PRO_RANK
			if ranked:
				var more: int = need - w
				if more == 1:
					return "1 more win"
				return "%d more wins" % more
			else:
				var more_ranked: int = maxi(need - w, 0)
				var more_any: int = any - w
				return "%d more wins and a top-3 ranking, or %d more wins" % [more_ranked, more_any]
		4:
			if pro:
				return "Her debut is booked %d weeks after she signs" % Roster.PRO_DEBUT_WEEKS
			return "Sign the offer"
	return ""
