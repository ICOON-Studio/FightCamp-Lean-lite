extends SceneTree
## ASK2 (ASKPROBE1 round 2): is ASK FOR A FIGHT a decision, and for whom? Built from tools/ask_probe_honest.gd (S442 review).
## Every bout is the game's REAL bout (Bouts.fight_step + LiveRound, auto corner - tools/adapt_probe.gd's loop). The division
## is the real one (Career.quick_start rivals of wlw, Region.rankings with our fighter in it, Region.day_events playing the
## rivals' club shows), the sheet is the real one (Bouts.legal_index, 2-4 weeks out 1 in 3 each, Bouts.makeable_day),
## the scale is Sim.weigh_forecast, the show is AskBout.show_day on Region.next_shows, the answers are AskBout.answers.
## ONE NIGHT: per legal name n_night real bouts -> win %, stoppage-loss %, FightLearn.teach (printed; ASK_PLAN reads it).
## THE SEASON: `horizon` days under four policies, seasons x each, common dice (season s: same dice under every policy):
##   WAIT       never ask: the sheet sends the next name in turn when Bouts would (AFTER_FIGHT after a bout), dated 2-4
##              weeks out (1 in 3 each, seeded) and moved by makeable_day; accepted at once.
##   ASK_SHEET  ask the sheet name each time the ask opens; ASK_STEP ask the step up (else the sheet name);
##   ASK_PLAN   ask the legal name with the best one-night win % (a stand-in for "the name the written plan beats").
##   Every asker asks only when the printed show makes weight ("Weight at risk" = wait: the sheet runs that day).
## Scored for THREE players APART, never summed: RECORD = wins - losses in the season; GROWTH = the rating the fights
## taught (FightLearn.teach, step ups x step_teach, added to the six fight stats as it lands); SAFE = bouts fought minus
## days out (suspension / injury inside the horizon) / 14 (a show every 14 days). A picked name keeps the gate: -$gate
## for the club and, a review ASSUMPTION the map does not set, gate/450 x gate_rate of each player's unit.
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/ask_probe.gd -- part=all seed=4421 gate=450 step_teach=1.0
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Region := preload("res://scripts/state/Region.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const FightLearn := preload("res://scripts/rules/FightLearn.gd")
const AskBout := preload("res://scripts/rules/AskBout.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")
const SeasonPath := preload("res://scripts/rules/SeasonPath.gd")
const POLICIES := ["WAIT", "ASK_SHEET", "ASK_STEP", "ASK_PLAN"]
const PLAYERS := ["RECORD", "GROWTH", "SAFE"]
const STATS := ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]
const SHOW_DAYS := 14.0
var part := "all"
var n_night := 100; var n_night60 := 30; var seasons := 100; var seasons60 := 30; var count60 := 60; var horizon := 70
var gate := float(BoutRules.TICKET_CUT)
var gate_rate := 0.10; var step_teach := 1.0; var pick_down := true; var seed := 4421
var rng := RandomNumberGenerator.new()
var c: Career
var rivals0: Array = []
var fmt := Callable(Clock, "fmt")
var bouts_played := 0
var _wcache := {}


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() != 2:
			continue
		match kv[0]:
			"part": part = kv[1]
			"n_night": n_night = int(kv[1])
			"n_night60": n_night60 = int(kv[1])
			"seasons": seasons = int(kv[1])
			"seasons60": seasons60 = int(kv[1])
			"count60": count60 = int(kv[1])
			"horizon": horizon = int(kv[1])
			"gate": gate = float(kv[1])
			"gate_rate": gate_rate = float(kv[1])
			"step_teach": step_teach = float(kv[1])
			"seed": seed = int(kv[1])
			"pick_down": pick_down = kv[1] != "0"
	rng.seed = seed
	c = Career.quick_start()
	c.seed = seed
	rivals0 = c.rivals.duplicate(true)
	var t0 := Time.get_ticks_msec()
	print("ASK_PROBE seed=%d part=%s horizon=%d days gate=$%d gate_rate=%.2f step_teach=x%.2f pick_down=%s" % [seed, part,
		horizon, int(gate), gate_rate, step_teach, pick_down])
	print("ASK_PROBE population: Data.lucy() re-rated per fighter (six stats shifted to the target power, +-3 seeded noise each),")
	print("  vs Career.quick_start rivals of wlw (Region.rankings, our row in it); cases A-G of the map, then %d generated" % count60)
	print("  (w 0-8, l 0-2, power 52-68, start day 0-42, 1 in 5 walking 0.5-1.6 kg over). Cases: %d bouts a name one night," % n_night)
	print("  %d seasons a policy; the generated: %d bouts a name, %d seasons a policy." % [seasons, n_night60, seasons60])
	_print_table()
	if part == "all" or part == "cases":
		_cases()
	if part == "all" or part == "spread":
		_spread()
	print("ASK_PROBE real bouts played: %d in %d s" % [bouts_played, (Time.get_ticks_msec() - t0) / 1000])
	quit(0)


func _print_table() -> void:
	c.fighters = []
	var line := "DIVISION wlw at day %d:" % c.day
	for r in Region.rankings(c, "wlw"):
		line += " %s %d-%d (%.1f)," % [str(r["name"]).get_slice(" ", 0), int(r["w"]), int(r["l"]), float(r["rating"])]
	print(line)


# ---------------------------------------------------------------- the cases and the spread

func _cases() -> void:
	# [id, w, l, power, over_kg, start day, morale, a teammate on the first show]
	var cases := [["A", 1, 0, 60.0, 0.0, 0, 60.0, false], ["B", 6, 1, 63.0, 0.0, 0, 60.0, false],
		["C", 2, 0, 61.0, 0.0, 40, 60.0, false], ["D", 5, 3, 60.0, 0.0, 0, 35.0, false],
		["E", 6, 2, 63.0, 0.0, 0, 60.0, false], ["F", 5, 2, 61.0, 1.5, 0, 60.0, false],
		["G", 2, 2, 58.0, 0.0, 0, 60.0, true]]
	print("\nCASES (first show 14+ days out from day 0: day %d; C = 2-0, three bouts short of the five, from day 40: the map's 4-1 already has five; D = morale 35)" % _first_show(0))
	var i := 0
	for k in cases:
		var fk := {"id": str(k[0]), "idx": i, "w": int(k[1]), "l": int(k[2]), "power": float(k[3]), "over": float(k[4]),
			"d0": int(k[5]), "morale": float(k[6]),
			"taken": [{"name": "Kira", "day": _first_show(int(k[5]))}] if bool(k[7]) else []}
		i += 1
		var res := _fighter(fk, n_night, seasons, true)
		print("  BEST %s: %s" % [fk["id"], _best_line(res)])


func _spread() -> void:
	var tally := {}
	var clear := {}
	for p in PLAYERS:
		tally[p] = {}
		clear[p] = {}
		for po in POLICIES:
			tally[p][po] = 0
			clear[p][po] = 0
	var ask_vs_wait := {}
	for p in PLAYERS:
		ask_vs_wait[p] = {"ask": 0, "wait": 0, "even": 0}
	print("\nSPREAD of %d generated fighters (one line each: id rec start power over | best per player, * = clear by 2 SE)" % count60)
	for i in count60:
		var over := rng.randf_range(0.5, 1.6) if rng.randf() < 0.2 else 0.0
		var fk := {"id": "g%02d" % i, "idx": 100 + i, "w": i % 9, "l": (i / 9) % 3, "power": 52.0 + rng.randf() * 16.0,
			"over": over, "d0": rng.randi_range(0, 42), "morale": 55.0 + rng.randf() * 10.0, "taken": []}
		var res := _fighter(fk, n_night60, seasons60, false)
		var bl := "  %s %d-%d d%d p%.1f o%.1f |" % [fk["id"], fk["w"], fk["l"], fk["d0"], fk["power"], fk["over"]]
		for p in PLAYERS:
			var b: Dictionary = res["best"][p]
			tally[p][b["policy"]] += 1
			if bool(b["clear"]):
				clear[p][b["policy"]] += 1
			bl += " %s %s%s" % [p, b["policy"], "*" if bool(b["clear"]) else ""]
			var av: Dictionary = res["ask_vs_wait"][p]
			ask_vs_wait[p][str(av["verdict"])] += 1
		print(bl)
	print("\nOVER %d, best policy per player (clear = the best beats the second by more than 2 SE of the paired difference)" % count60)
	var dom := []
	for p in PLAYERS:
		var s := "  %-7s" % p
		for po in POLICIES:
			s += " %s %d (clear %d)" % [po, int(tally[p][po]), int(clear[p][po])]
			if int(tally[p][po]) * 10 > count60 * 6:
				dom.append("%s: %s wins %d of %d" % [p, po, int(tally[p][po]), count60])
		print(s)
	print("OVER %d, fighters with NO clear best (the top two within 2 SE): %s" % [count60, str(_noclear(tally, clear))])
	print("OVER %d, the best ASK policy vs WAIT, per player (by 2 SE of the paired difference):" % count60)
	for p in PLAYERS:
		print("  %-7s ask better %d, wait better %d, even %d" % [p, ask_vs_wait[p]["ask"], ask_vs_wait[p]["wait"], ask_vs_wait[p]["even"]])
	if dom.is_empty():
		print("ASK_PROBE spread ok: no policy wins more than 6 in 10 for any player")
	else:
		print("ASK_PROBE DOMINANT: " + "; ".join(dom))


func _noclear(_t: Dictionary, clear: Dictionary) -> Dictionary:
	var out := {}
	for p in PLAYERS:
		var n := count60
		for po in POLICIES:
			n -= int(clear[p][po])
		out[p] = n
	return out


func _best_line(res: Dictionary) -> String:
	var s := ""
	for p in PLAYERS:
		var b: Dictionary = res["best"][p]
		var av: Dictionary = res["ask_vs_wait"][p]
		s += "%s %s%s (ask vs wait: %s %+.2f) " % [p, b["policy"], "*" if bool(b["clear"]) else "", av["verdict"], float(av["diff"])]
	return s


# ---------------------------------------------------------------- one fighter

func _make(fk: Dictionary) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
	var p0 := BoutRules.fight_power(f["stats"], {}, 0, "")
	for s in STATS:
		f["stats"][s] = float(f["stats"][s]) + float(fk["power"]) - p0 + rng.randf_range(-3.0, 3.0)
	f["w"] = int(fk["w"])
	f["l"] = int(fk["l"])
	f["weight"] = float(f["limit"]) + float(fk["over"])
	f["morale"] = float(fk["morale"])
	return f


func _fighter(fk: Dictionary, nn: int, ns: int, verbose: bool) -> Dictionary:
	_wcache.clear()
	var f := _make(fk)
	c.rivals = rivals0.duplicate(true)
	c.day = int(fk["d0"])
	# One night: every legal answer at the first decision, nn real bouts each.
	var night := {"_place": _place(f)}   # the place at the start (the seasons move the rivals' table)
	var ans := _answers(f, fk, int(fk["idx"]) % 3)
	var nl := ""
	for a in ans:
		for nm in a["names"]:
			var r := _night(f, fk, str(nm), nn, str(a["kind"]) == "step_up")
			night[str(nm)] = r
			nl += " %s:%s %.0f/%.0f/%.2f" % [a["kind"], str(nm).get_slice(" ", 0), r["win"] * 100.0, r["stop"] * 100.0, r["teach"]]
	var runs := {}
	for po in POLICIES:
		runs[po] = []
		for s in ns:
			runs[po].append(_season(f, fk, po, s, night))
	var res := {"best": {}, "ask_vs_wait": {}}
	for p in PLAYERS:
		res["best"][p] = _best(runs, p)
		res["ask_vs_wait"][p] = _ask_vs_wait(runs, p)
	if verbose:
		var own := BoutRules.fight_power(f["stats"], {}, 0, "")
		print("CASE %s %d-%d power %.1f over %.1f kg start day %d place %d | one night (kind:name win%%/stop%%/teach):%s" % [fk["id"],
			fk["w"], fk["l"], own, fk["over"], fk["d0"], night["_place"], nl])
		print("    policy     RECORD  GROWTH  SAFE  | wins  losses bouts stops days_out gates money  place pro%  five_by_70%  asks missed_wt")
		for po in POLICIES:
			var m := _means(runs[po])
			print("    %-10s %+6.2f  %6.2f  %5.2f | %4.2f  %4.2f   %4.2f  %4.2f  %5.1f   %4.2f  %5d  %4.1f  %3.0f   %3.0f        %4.2f  %4.2f" % [po,
				m["RECORD"], m["GROWTH"], m["SAFE"], m["wins"], m["losses"], m["bouts"], m["stops"], m["out"], m["gates"],
				int(m["money"]), m["place"], m["pro"] * 100.0, m["five"] * 100.0, m["asks"], m["missed"]])
	return res


func _place(f: Dictionary) -> int:
	c.fighters = [f]
	return AskBout.place_of(Region.rankings(c, "wlw"), str(f["name"]), Region.RANK_MIN_WINS)


func _answers(f: Dictionary, fk: Dictionary, opp_index: int) -> Array:
	c.fighters = [f]
	var names: Array = Data.DIVISIONS["wlw"]["opponents"]
	var own := int(f["w"]) + int(f["l"])
	var sheet := str(names[Bouts.legal_index(c, names, opp_index, own)])
	var rows := Region.rankings(c, "wlw")
	var ans := AskBout.answers({"name": f["name"], "w": int(f["w"]), "l": int(f["l"])}, rows, sheet, Region.RANK_MIN_WINS)
	if pick_down:   # the map's rule; pick_down=0 is the what-if "a picked name only from the places above"
		return ans
	var me := AskBout.place_of(rows, str(f["name"]), Region.RANK_MIN_WINS)
	for a in ans:
		if str(a["kind"]) == "name":
			a["names"] = (a["names"] as Array).filter(func(nm): return AskBout.place_of(rows, str(nm), Region.RANK_MIN_WINS) < me)
	return ans.filter(func(a): return not (a["names"] as Array).is_empty())


func _night(f: Dictionary, fk: Dictionary, nm: String, nn: int, step: bool) -> Dictionary:
	var wins := 0
	var stops := 0
	var teach := 0.0
	var keep: Array = c.rivals.duplicate(true)
	var day0 := c.day
	for i in nn:
		var r := _fight(f, fk, nm, 900000 + i, day0)
		c.rivals = keep.duplicate(true)
		wins += int(bool(r["won"]))
		stops += int(bool(r["stopped"]))
		teach += float(r["teach"]) * (step_teach if step else 1.0)
	c.day = day0
	return {"win": float(wins) / nn, "stop": float(stops) / nn, "teach": teach / nn}


# ---------------------------------------------------------------- the season

func _season(base: Dictionary, fk: Dictionary, policy: String, s: int, night: Dictionary) -> Dictionary:
	c.rivals = rivals0.duplicate(true)
	c.news.clear()
	var f: Dictionary = base.duplicate(true)
	f["id"] = "ask%d_s%d" % [int(fk["idx"]), s]
	f["bout"] = {}
	c.fighters = [f]
	var d0 := int(fk["d0"])
	var end := d0 + horizon
	var st := {"wins": 0, "losses": 0, "bouts": 0, "stops": 0, "teach": 0.0, "out": 0, "gates": 0, "money": 0, "asks": 0,
		"missed": 0, "by70": 0}
	var start_bouts := int(f["w"]) + int(f["l"])
	var bout := {}
	var free := d0
	var last := d0 - Bouts.AFTER_FIGHT
	var next_offer := d0
	var next_ask := d0
	var opp_index := int(fk["idx"]) % 3
	var ko: Array = []
	# The sheet's lead, 1 in 3 each: the game's lead_weeks hashes the offer id, and djb2 mixes ids that differ by one
	# character badly (ask0_s*: 4 weeks in 100 of 100), so the probe draws the same range, seeded per fighter and season.
	var lead := RandomNumberGenerator.new()
	lead.seed = seed * 7919 + int(fk["idx"]) * 104729 + s
	for day in range(d0, end + 1):
		c.day = day
		if not bout.is_empty() and day == int(bout["day"]):
			if bool(bout["made"]):
				var r := _fight(f, fk, str(bout["opp"]), s * 1000 + day, day)
				var stopped := bool(r["stopped"])
				var t := float(r["teach"]) * (step_teach if str(bout["kind"]) == "step_up" else 1.0)
				for k in STATS:
					f["stats"][k] = float(f["stats"][k]) + t
				st["teach"] += t
				st["bouts"] += 1
				if day <= SeasonPath.ENTRY_CLOSE_DAY:
					st["by70"] += 1
				if bool(r["won"]):
					st["wins"] += 1
					f["w"] = int(f["w"]) + 1
				else:
					st["losses"] += 1
					f["l"] = int(f["l"]) + 1
				var out := int(r["out"])
				if stopped:
					st["stops"] += 1
					out = maxi(out, InjuryRoll.ko_days(ko, day))
					ko.append(day)
				free = day + 1 + out
				st["out"] += mini(out, end - day)
				st["money"] += BoutRules.TICKET_CUT - (int(gate) if str(bout["kind"]) == "name" else 0)
				last = day
				next_offer = maxi(day + Bouts.AFTER_FIGHT, free)
				opp_index += 1
			else:
				st["missed"] += 1
				next_offer = day + Bouts.AFTER_MISSED_WEIGHT
			bout = {}
			f["bout"] = {}
		Region.day_events(c)
		if bout.is_empty() and day >= free:
			if policy != "WAIT" and day >= last + Bouts.AFTER_FIGHT and day >= next_ask:
				bout = _ask(f, fk, policy, day, opp_index, night)
				if bout.is_empty():
					next_ask = day + 7
				else:
					st["asks"] += 1
					if str(bout["kind"]) == "name":
						st["gates"] += 1
			if bout.is_empty() and day >= next_offer:
				bout = _sheet(f, fk, day, opp_index, lead)
				if bout.is_empty():
					next_offer = day + Bouts.AFTER_DECLINE
			if not bout.is_empty():
				f["bout"] = {"opp": {"name": bout["opp"]}, "day": int(bout["day"]), "done": false}
		if c.news.size() > 50:
			c.news.clear()
	var cost := gate / 450.0 * gate_rate * float(st["gates"])
	st["RECORD"] = float(st["wins"] - st["losses"]) - cost
	st["GROWTH"] = float(st["teach"]) - cost
	st["SAFE"] = float(st["bouts"]) - float(st["out"]) / SHOW_DAYS - cost
	c.fighters = [f]
	f["bout"] = {}
	st["place"] = _place(f)
	var w := int(f["w"])
	var pl := int(st["place"])
	st["pro"] = 1.0 if (w >= 7 and pl > 0 and pl <= 3) or w >= 9 else 0.0
	st["five"] = 1.0 if start_bouts + int(st["by70"]) >= SeasonPath.MIN_BOUTS else 0.0
	return st


## The asker: the printed show (14+ days, a slot none of ours holds); the forecast must make weight, else wait.
func _ask(f: Dictionary, fk: Dictionary, policy: String, day: int, opp_index: int, night: Dictionary) -> Dictionary:
	var show := AskBout.show_day(day, Region.next_shows(day, 6), fk["taken"], fmt)
	if int(show["day"]) < 0 or not _made(f, fk, day, int(show["day"])):
		return {}
	var ans := _answers(f, fk, opp_index)
	var pick := {}
	for want in (["step_up", "sheet"] if policy == "ASK_STEP" else ["sheet", "step_up"]):
		for a in ans:
			if pick.is_empty() and str(a["kind"]) == want:
				pick = {"opp": str(a["names"][0]), "kind": want}
	if policy == "ASK_PLAN":
		var best := -1.0
		for a in ans:
			for nm in a["names"]:
				if not night.has(str(nm)):
					night[str(nm)] = _night(f, fk, str(nm), n_night60, str(a["kind"]) == "step_up")
				var wp := float(night[str(nm)]["win"])
				if wp > best:
					best = wp
					pick = {"opp": str(nm), "kind": str(a["kind"])}
	if pick.is_empty():
		return {}
	pick["day"] = int(show["day"])
	pick["made"] = true
	return pick


## The sheet as Bouts.day_events sends it: the next legal name in turn, 2-4 weeks out (1 in 3 each),
## moved by makeable_day for a fighter over the class. Accepted at once; a mismatch is declined.
func _sheet(f: Dictionary, fk: Dictionary, day: int, opp_index: int, lead: RandomNumberGenerator) -> Dictionary:
	var names: Array = Data.DIVISIONS["wlw"]["opponents"]
	var own := int(f["w"]) + int(f["l"])
	var nm := str(names[Bouts.legal_index(c, names, opp_index, own)])
	var r := c.rival(nm)
	if not AmateurBooking.experience_match_ok(own, AmateurBooking.bouts_of(int(r["w"]), int(r["l"]))):
		return {}
	var on := AmateurBooking.fight_day(day, lead.randi_range(AmateurBooking.LEAD_WEEKS_MIN, AmateurBooking.LEAD_WEEKS_MAX))
	on = Bouts.makeable_day(c, f, on)
	return {"opp": nm, "kind": "sheet", "day": on, "made": _made(f, fk, day, on)}


func _made(f: Dictionary, fk: Dictionary, day: int, on: int) -> bool:
	if float(fk["over"]) <= 0.0:
		return true
	var key := "%d:%d" % [day, on]
	if not _wcache.has(key):
		c.day = day
		_wcache[key] = bool(Sim.weigh_forecast(c, f, on)["ok"])
	return bool(_wcache[key])


## One real bout (adapt_probe's loop). dice = the day the bout's dice read; real_day = the calendar day.
func _fight(base: Dictionary, fk: Dictionary, nm: String, dice: int, real_day: int) -> Dictionary:
	var keep: Array = c.fighters
	var g: Dictionary = base.duplicate(true)
	var opp: Dictionary = c.rival(nm).duplicate(true)
	var gap := float(opp["rating"]) - BoutRules.fight_power(g["stats"], {}, 0, "")
	c.day = 200000 + dice
	c.fighters = [g]
	g["camp"] = {}
	g["morale"] = float(fk["morale"])
	g["notes_seen"] = []
	g["injury"] = {}
	g["ko_history"] = []
	g["offers"] = []
	g["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": g["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, g, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, g, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(g) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, g, m, "corner:" + BoutRules.auto_corner(g["stats"]))
	Bouts.fight_step(c, g, m, "end")
	bouts_played += 1
	var outc := str(m.get("outcome", ""))
	var won := outc == "win"
	var stopped := outc == "loss" and Bouts.stopped(m) != ""
	var inj: Dictionary = g.get("injury", {})
	var out := maxi(0, int(inj.get("until_day", c.day)) - c.day) if not inj.is_empty() else 0
	c.results.clear()
	c.day = real_day
	c.fighters = keep
	return {"won": won, "stopped": stopped, "out": out, "teach": FightLearn.teach(gap, won, stopped)}


# ---------------------------------------------------------------- statistics

func _means(runs: Array) -> Dictionary:
	var out := {}
	for k in ["RECORD", "GROWTH", "SAFE", "wins", "losses", "bouts", "stops", "out", "gates", "money", "place", "pro", "five",
			"asks", "missed"]:
		var s := 0.0
		for r in runs:
			s += float(r[k])
		out[k] = s / maxf(1.0, runs.size())
	return out


## The best policy for one player (ties to the earlier, cheaper policy) and whether it is clear of the second.
func _best(runs: Dictionary, p: String) -> Dictionary:
	var order: Array = []
	for po in POLICIES:
		order.append([po, float(_means(runs[po])[p])])
	order.sort_custom(func(x, y): return float(x[1]) > float(y[1]) + 1e-9)
	var d := _paired(runs[order[0][0]], runs[order[1][0]], p)
	return {"policy": str(order[0][0]), "mean": float(order[0][1]), "clear": d[0] > 2.0 * d[1] and d[1] > 0.0}


## The best of the three asks against WAIT for one player: "ask", "wait" or "even" (2 SE of the paired difference).
func _ask_vs_wait(runs: Dictionary, p: String) -> Dictionary:
	var best := "ASK_SHEET"
	for po in ["ASK_STEP", "ASK_PLAN"]:
		if float(_means(runs[po])[p]) > float(_means(runs[best])[p]):
			best = po
	var d := _paired(runs[best], runs["WAIT"], p)
	var v := "even"
	if d[1] > 0.0 and d[0] > 2.0 * d[1]:
		v = "ask"
	elif d[1] > 0.0 and d[0] < -2.0 * d[1]:
		v = "wait"
	return {"verdict": v, "diff": d[0], "with": best}


## [mean, SE] of the season-by-season difference a - b (same dice per season).
func _paired(a: Array, b: Array, p: String) -> Array:
	var n := mini(a.size(), b.size())
	if n < 2:
		return [0.0, 0.0]
	var s := 0.0
	var ss := 0.0
	for i in n:
		var d := float(a[i][p]) - float(b[i][p])
		s += d
		ss += d * d
	var mean := s / n
	var v := maxf(0.0, ss / n - mean * mean) * n / (n - 1)
	return [mean, sqrt(v / n)]


func _first_show(day: int) -> int:
	return int(AskBout.show_day(day, Region.next_shows(day, 6), [], fmt)["day"])
