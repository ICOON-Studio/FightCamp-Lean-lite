extends SceneTree
## S303 probe: what the ring shows of combos and energy, by round and conditioning. Three boxers (different stats and
## combos, never identical) against one opponent profile, energy run by Combos.after_round over 3 rounds, 40 seeded
## rounds each through RoundScript.build + ComboWords.caption. Prints per round: energy start->bell, combo runs, mean run
## length, unfinished runs, ring_tired and ring_lands captions.
##   godot --headless --path . --script res://tools/combo_words_probe.gd

const C := preload("res://scripts/rules/Combos.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")
const W := preload("res://scripts/rules/ComboWords.gd")

const SEEDS := 40


func _initialize() -> void:
	var opp := {"stats": {"speed": 62.0, "conditioning": 60.0, "defense": 58.0, "technique": 60.0, "power": 61.0},
		"moves": {"Jab": 55.0, "Cross": 48.0, "Lead hook": 40.0, "Body hook": 30.0, "Uppercut": 20.0}, "combos": {"1-2": 45.0}}
	var boxers := [
		{"name": "Lucy (cond 35, sharp)", "stats": {"speed": 70.0, "conditioning": 35.0, "defense": 55.0, "technique": 62.0, "power": 66.0},
			"combos": {"1-1": 64.0, "1-2": 70.0, "1-1-2": 61.0}},
		{"name": "Maria (cond 55, signature)", "stats": {"speed": 74.0, "conditioning": 55.0, "defense": 60.0, "technique": 80.0, "power": 58.0},
			"combos": {"1-1": 88.0, "1-2": 92.0, "1-2-3": 86.0, "3b-3": 70.0}},
		{"name": "Rosa (cond 82, signature)", "stats": {"speed": 66.0, "conditioning": 82.0, "defense": 70.0, "technique": 75.0, "power": 52.0},
			"combos": {"1-2": 90.0, "2-3": 85.0, "1-2-3b": 64.0}},
	]
	for bx in boxers:
		print("== %s" % bx["name"])
		var moves := {"Jab": 80.0, "Cross": 75.0, "Lead hook": 70.0, "Body hook": 65.0, "Uppercut": 50.0, "Check hook": 40.0}
		var pa := {"moves": moves, "stats": bx["stats"], "combos": bx["combos"]}
		var cond := float(bx["stats"]["conditioning"])
		var ea := C.TANK
		var da := 0.0
		var eb := C.TANK
		var db := 0.0
		for n in range(1, 4):
			var ra := C.after_round(ea, da, C.round_spend(bx["combos"], "", cond), cond)
			var rb := C.after_round(eb, db, C.round_spend(opp["combos"], "", 60.0), 60.0)
			var runs := 0
			var run_len := 0
			var cut := 0
			var tired := 0
			var lands := 0
			for s in SEEDS:
				var a := pa.duplicate(true)
				a["energy"] = ea
				a["energy_end"] = float(ra["bell"])
				var b := opp.duplicate(true)
				b["energy"] = eb
				b["energy_end"] = float(rb["bell"])
				var round := {"n": n, "won": s % 2 == 0, "mine": 3.0 + float(s % 5), "theirs": 3.0, "corner": "", "lines": []}
				var plan := RS.build(round, "Out-boxer", "Pressure fighter", RS.SECONDS, s * 7 + n, {"a": a, "b": b})
				var beats: Array = plan["beats"]
				W.caption(beats, {"a": bx["combos"], "b": opp["combos"]}, ["Her", "Opp"], s)
				var i := 0
				while i < beats.size():
					var cid := str(beats[i].get("combo_id", ""))
					if cid == "" or str(beats[i]["who"]) != "a":
						i += 1
						continue
					var j := i
					while j + 1 < beats.size() and str(beats[j + 1].get("combo_id", "")) == cid and str(beats[j + 1]["who"]) == "a":
						j += 1
					runs += 1
					run_len += j - i + 1
					if bool(beats[j].get("combo_cut", false)):
						cut += 1
					var cap := str(beats[j]["caption"])
					if cap != "" and W.line(cid, "ring_tired", "Her", 0) != "" and _in(cid, "ring_tired", cap):
						tired += 1
					elif cap != "" and _in(cid, "ring_lands", cap):
						lands += 1
					i = j + 1
			print("  R%d energy %5.1f -> %5.1f | runs/round %.2f, mean len %.2f, unfinished %.2f | ring_tired %.2f, ring_lands %.2f" % [
				n, ea, float(ra["bell"]), runs / float(SEEDS), run_len / maxf(1.0, float(runs)), cut / float(SEEDS),
				tired / float(SEEDS), lands / float(SEEDS)])
			ea = float(ra["next"])
			da = float(ra["debt"])
			eb = float(rb["next"])
			db = float(rb["debt"])
	quit(0)


func _in(cid: String, kind: String, text: String) -> bool:
	for c in W.bank().get("combos", []):
		if str(c["id"]) == cid:
			for l in c.get(kind, []):
				if str(l).replace("{name}", "Her") == text:
					return true
	return false
