extends SceneTree
## S443 R29 wiring check (the map's probe JUDGES1 gates (a), (b), (c) read on real bouts; it does not set the weights):
## Lucy as signed, 6 weaker and 6 stronger, against every OPPONENT + MISMATCH + RIVAL, SIMS bouts each through fight
## night's own rounds (BoutNight.play_out). Per decision: the judges' verdict against the old rounds-won cards
## (BoutRules.cards_of); per round: the judges' majority against the exchange winner (r.won); splits; "out-landed and lost".
##   godot --headless --audio-driver Dummy --path . --script res://tools/judges_agree_probe.gd [-- sims]
## Prints JUDGES_AGREE lines.

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const JudgeNight := preload("res://scripts/state/JudgeNight.gd")

const CAMP := {"protocol": 2, "focus": "conditioning", "film": false, "partner": false, "start": 0}


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var sims := int(args[0]) if not args.is_empty() else 40
	var t := {"bouts": 0, "decisions": 0, "flipped": 0, "rounds": 0, "round_agree": 0, "split": 0, "majority": 0, "unanimous": 0,
		"draw": 0, "outlanded_lost": 0}
	for shift in [-6.0, 0.0, 6.0]:
		for o in Data.OPPONENTS + [Data.MISMATCH] + Data.RIVALS:
			for k in sims:
				var sc := Career.new()
				sc.day = 60000 + k * 7
				sc.seed = 443
				sc.coach = {"rating": 58.0}
				var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
				for s in f["stats"]:
					f["stats"][s] = float(f["stats"][s]) + shift
				f["camp"] = CAMP.duplicate(true)
				f["bout"] = {"opp": (o as Dictionary).duplicate(true), "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1}
				sc.fighters = [f]
				var m := BoutNight.fight_modal(f)
				BoutNight.play_out(sc, f, m)
				t["bouts"] += 1
				var rounds: Array = m["rounds"]
				JudgeNight.cards(f, m)
				if BoutNight.stopped(m) != "" or not m.has("judges"):
					continue
				t["decisions"] += 1
				var old := BoutRules.verdict(BoutRules.cards_of(rounds))
				var new := BoutRules.verdict((m["judges"]["cards"] as Array).map(func(c): return "%d-%d" % [int(c[0]), int(c[1])]))
				t["flipped"] += int(old != new)
				t[str(m["judges"]["verdict"])] += 1
				var la := 0
				var lb := 0
				for ri in rounds.size():
					var r: Dictionary = rounds[ri]
					var sum := [0, 0]
					for x in r["exchanges"]:
						sum[0] += int(x["landed"][0])
						sum[1] += int(x["landed"][1])
					la += sum[0]
					lb += sum[1]
					var ours := ((m["judges"]["by_round"] as Array)[ri] as Array).filter(func(s): return int(s["a"]) > int(s["b"])).size()
					t["rounds"] += 1
					t["round_agree"] += int((ours >= 2) == bool(r["won"]))
				t["outlanded_lost"] += int((la > lb and new == "loss") or (lb > la and new == "win"))
	var d := maxf(1.0, float(t["decisions"]))
	print("JUDGES_AGREE bouts=%d decisions=%d (Lucy -6/0/+6 x every opponent x %d)" % [t["bouts"], t["decisions"], sims])
	print("JUDGES_AGREE (a) exchange winner takes the round on the judges' majority: %.1f in 100 (band 80-90)" % (100.0 * t["round_agree"] / maxf(1.0, t["rounds"])))
	print("JUDGES_AGREE (b) out-landed and lost the decision: %.1f in 100 (under 15)" % (100.0 * t["outlanded_lost"] / d))
	print("JUDGES_AGREE (c) split %.1f, majority %.1f, unanimous %.1f, draw %.1f in 100 (split band 10-25)" % [
		100.0 * t["split"] / d, 100.0 * t["majority"] / d, 100.0 * t["unanimous"] / d, 100.0 * t["draw"] / d])
	print("JUDGES_AGREE decisions that change hands against the old rounds-won cards: %.1f in 100" % (100.0 * t["flipped"] / d))
	quit(0)
