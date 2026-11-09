extends SceneTree
## S398 bar 5 (the blind reader): two of the game's boxers fight the same opponent; their round reports are printed with
## nothing else, for a fresh reader to tell them apart and name each style. Kira (fast hands, thin chin) and Samira (raw
## power, no defence), both against Maria Ortega, three bouts each, the corner's auto plan.
##   <godot.exe> --headless --path . --script res://tools/round_reports.gd > reports.txt

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const CAMP := {"protocol": 2, "focus": "conditioning", "film": false, "partner": false, "start": 0}


func _bouts(raw: Dictionary, label: String) -> void:
	print("===== BOXER %s =====" % label)
	var f0: Dictionary = Data.fighter_state(raw.duplicate(true), 0)
	f0["div"] = "wlw"
	for k in 3:
		var sc := Career.new()
		sc.day = 70000 + k * 11
		sc.seed = 398
		sc.coach = {"rating": 58.0}
		var f: Dictionary = f0.duplicate(true)
		f["camp"] = CAMP.duplicate(true)
		var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		f["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1}
		sc.fighters = [f]
		var m := BoutNight.fight_modal(f)
		BoutNight.play_out(sc, f, m)
		print("-- bout %d: %s" % [k + 1, BoutNight.outcome_of(f, m)])
		for r in m.get("rounds", []):
			print("Round %d:" % int(r["n"]))
			for l in r.get("lines", []):
				print("  " + str(l))


func _initialize() -> void:
	var kira: Dictionary = {}
	var samira: Dictionary = {}
	for p in Data.PROSPECTS:
		if str(p["id"]) == "kira":
			kira = p
		elif str(p["id"]) == "samira":
			samira = p
	_bouts(kira, "A")
	_bouts(samira, "B")
	quit(0)
