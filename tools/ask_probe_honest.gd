extends SceneTree
## ASKPROBE1 review: the probe through the game's REAL bout (Bouts.fight_step + LiveRound, the loop of tools/adapt_probe.gd),
## the real division (Career.quick_start rivals of "wlw", Region's table order), the real sheet (Bouts.legal_index), the real
## scale (Sim.weigh_forecast on the show AskBout.show_day prints). Each answer is scored for THREE players SEPARATELY:
## RECORD = expected net record (win - loss), GROWTH = mean FightLearn.teach, SAFE = bouts toward the season's 5
## (1 - stoppage share x SHOWS_LOST, a 30-day rest at one show every 14 days). WAIT scores 0 on all three, costs nothing.
## A missed weight = the bout is off (0 on all three, -MISSED_WEIGHT_COST). The gate costs a picked name GATE_RATE of each
## player's unit per $450 (a review ASSUMPTION, printed). Ties go to the cheaper answer (wait, sheet, step_up, name).
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/ask_probe_honest.gd -- n=20 gate=450 step_teach=1.0
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Region := preload("res://scripts/state/Region.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const FightLearn := preload("res://scripts/rules/FightLearn.gd")
const AskBout := preload("res://scripts/rules/AskBout.gd")
const KINDS := ["wait", "sheet", "step_up", "name"]
const PLAYERS := ["RECORD", "GROWTH", "SAFE"]
const SHOWS_LOST := 30.0 / 14.0
const GATE_RATE := 0.10
var n := 20
var gate := float(BoutRules.TICKET_CUT)
var step_teach := 1.0
var rng := RandomNumberGenerator.new()
var c: Career


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"n": n = int(kv[1])
				"gate": gate = float(kv[1])
				"step_teach": step_teach = float(kv[1])
	rng.seed = 4421
	c = Career.quick_start()
	print("ASK_PROBE population: Data.lucy() re-rated per fighter (six stats shifted to the target power, +-3 seeded noise each),")
	print("  vs Career.quick_start rivals of wlw; cases A-G + 60 generated (w 0-8, l 0-2, power 52-68); n=%d real bouts per name;" % n)
	print("  gate=$%d (x%.2f a player unit per $450), step_teach x%.2f, seed 4421" % [int(gate), GATE_RATE, step_teach])
	var cases := [["A", 1, 0, 60.0, 200, 0.0], ["B", 6, 1, 63.0, 150, 0.0], ["C", 4, 1, 61.0, 30, 0.0], ["D", 5, 3, 60.0, 120, 0.0],
		["E", 6, 2, 63.0, 100, 0.0], ["F", 5, 2, 61.0, 90, 1.5], ["G", 2, 2, 58.0, 180, 0.0]]
	print("CASE  rank  own     RECORD   GROWTH   SAFE     answers (kind:name win%/stop%/teach)")
	for k in cases:
		var taken: Array = [{"name": "Kira", "day": _shows()[1]}] if k[0] == "G" else []
		var r := _fighter(k[1], k[2], k[3], k[4], k[5], taken)
		print("%-5s %-5d %-7s %-8s %-8s %-8s %s" % [k[0], r["rank"], r["own"], r["win"]["RECORD"], r["win"]["GROWTH"], r["win"]["SAFE"], r["line"]])
	var tally := {}
	for p in PLAYERS + ["OWN"]:
		tally[p] = {"wait": 0, "sheet": 0, "step_up": 0, "name": 0}
	for i in 60:
		var r := _fighter(i % 9, (i / 9) % 3, 52.0 + rng.randf() * 16.0, 20 + rng.randi_range(0, 160), 0.0, [])
		for p in PLAYERS:
			tally[p][r["win"][p]] += 1
		tally["OWN"][r["win"][r["own"]]] += 1
	var worst := ["", 0]
	for p in tally:
		print("OVER 60 %-7s %s" % [p, str(tally[p])])
		for kd in tally[p]:
			if int(tally[p][kd]) > int(worst[1]) and p == "OWN":
				worst = [kd, int(tally[p][kd])]
	print("ASK_PROBE DOMINANT: %s wins %d of 60" % worst if int(worst[1]) > 36 else "ASK_PROBE spread ok: no answer wins more than 6 in 10")
	quit(0)


func _shows() -> Array:
	var first := c.day - posmod(c.day, 7) + 5 + 14   # Saturdays every 14 days from two weeks out
	return [first - 7, first, first + 14, first + 28]


func _fighter(w: int, l: int, power: float, nat_days: int, over_kg: float, taken: Array) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
	var p0 := BoutRules.fight_power(f["stats"], {}, 0, "")
	for s in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		f["stats"][s] = float(f["stats"][s]) + power - p0 + rng.randf_range(-3.0, 3.0)
	f["w"] = w
	f["l"] = l
	f["weight"] = float(f["limit"]) + over_kg
	var own := BoutRules.fight_power(f["stats"], {}, 0, "")
	var rows: Array = []
	for rv in c.rivals:
		if str(rv["div"]) == "wlw":
			rows.append({"name": rv["name"], "club": rv["club"], "w": int(rv["w"]), "l": int(rv["l"]), "rating": float(rv["rating"]), "ours": false})
	rows.append({"name": f["name"], "club": c.gym_name, "w": w, "l": l, "rating": own, "ours": true})
	rows.sort_custom(Region.before)
	var rank := 0
	var place := 0
	for r in rows:
		if int(r["w"]) >= Region.RANK_MIN_WINS:
			place += 1
			if bool(r["ours"]):
				rank = place
	var names: Array = Data.DIVISIONS["wlw"]["opponents"]
	var sheet := str(names[Bouts.legal_index(c, names, int(f.get("opp_index", 0)), w + l)])
	var fd := {"w": w, "l": l, "d": 0, "rank": rank}
	var show := AskBout.show_day(c.day, _shows(), taken)
	var made := bool(Sim.weigh_forecast(c, f, int(show["day"]))["ok"])
	var best := {}
	var line := "show +%dd%s " % [int(show["days_away"]), "" if made else " WEIGHT MISSED"]
	for p in PLAYERS:
		best[p] = ["wait", 0.0]
	for a in AskBout.answers(fd, rows, sheet):
		for nm in a["names"]:
			var s := _play(f, c.rival(str(nm)), own, str(a["kind"]) == "step_up") if made else {"rec": 0.0, "teach": 0.0, "stop": 0.0, "off": true}
			var cost := gate / 450.0 * GATE_RATE if bool(a["gate"]) else 0.0
			var sc := {"RECORD": s["rec"] - cost, "GROWTH": s["teach"] - cost,
				"SAFE": (0.0 if s.has("off") else 1.0 - s["stop"] * SHOWS_LOST) - cost}
			line += "%s:%s %.0f/%.0f/%.2f " % [a["kind"], str(nm).get_slice(" ", 0), (s["rec"] + 1.0) * 50.0, s["stop"] * 100.0, s["teach"]]
			for p in PLAYERS:
				if float(sc[p]) > float(best[p][1]):
					best[p] = [str(a["kind"]), float(sc[p])]
	var who := "SAFE" if w + l < 5 and nat_days <= 60 else ("RECORD" if rank > 0 and w >= 5 else "GROWTH")
	var win := {}
	for p in PLAYERS:
		win[p] = best[p][0]
	return {"rank": rank, "own": who, "win": win, "line": line}


func _play(base: Dictionary, opp0: Dictionary, own: float, step: bool) -> Dictionary:
	var net := 0.0
	var teach := 0.0
	var stops := 0
	var gap := float(opp0["rating"]) - own
	var day0 := c.day
	var rivals0: Array = c.rivals.duplicate(true)
	for i in n:
		c.day = day0 + 1 + i   # the bout's dice follow the day (as adapt_probe's c.day = 20 + i)
		var f: Dictionary = base.duplicate(true)
		c.fighters = [f]
		f["camp"] = {}
		f["morale"] = 60.0
		f["notes_seen"] = []
		f["bout"] = {"opp": opp0.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "start")
		while true:
			while not LiveRound.live(m).is_empty():
				Bouts.fight_step(c, f, m, "shout:")
			if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
				break
			Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
		Bouts.fight_step(c, f, m, "end")
		var out := str(m.get("outcome", ""))
		var stopped := out == "loss" and Bouts.stopped(m) != ""
		net += 1.0 if out == "win" else (-1.0 if out == "loss" else 0.0)
		stops += int(stopped)
		teach += FightLearn.teach(gap, out == "win", stopped) * (step_teach if step else 1.0)
		c.rivals = rivals0.duplicate(true)   # the night writes the rivals' records: every bout starts from the same table
	c.day = day0
	return {"rec": net / n, "teach": teach / n, "stop": float(stops) / n}
