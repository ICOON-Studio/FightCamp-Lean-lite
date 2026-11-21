extends SceneTree
## TURNPROBE11 (S534, ops/research/TASK_TURNPROBE11.md): the probe map v11 (DESIGN_TURNPRO1_V11.md section 9) defines, run
## BEFORE any critic scores the map. Measurement only: nothing under scripts/ is touched; v11's numbers are the flagged local
## copy tools/turnprobe11_rules.gd.
## ARMS: control = today's rules (the game's own ProOfferWire.ask + Roster.turn_pro + BoutFinish); v11 = the map's rules;
## mutant = v11 with the guarantee purse back at $1,800 (the instrument must be able to read worse); nowish = v11, wish off.
## POPULATION (printed): the six people the game can sign (Data.lucy + Data.PROSPECTS), each played from signing to the
## first pro call by a bot that takes every legal bout, then CALLED on `days` different days a week apart (k = 0..days-1):
## a bout's dice are the fight day's (BoutNight._counts), never the career seed, so one call day is one roll.
## CELL = boxer x seats on the day of the call (members set so the forecast reads 48 / 56 / 64 / 72) x gym (healthy $12,000;
## crunch $1,000, under the signing costs, at the seats in cseats). The gym's reputation is set to carry those members.
## Made cases (gyms=crunch52,dayjob): the crunch at 52 loyalty; a healthy gym with the boxer off the stipend.
## Each cell x call day plays EVERY signable option (house x granted ask, and no ask) from the call to week `weeks`.
## Stage A (stage=a): each boxer x house x ask on `nights` scratch nights (PlanTest's dice, as tools/turn_gap_probe.gd).
## Args (after --): stage=b|a boxers=0,1 days=4 weeks=40 seats=48,56,64,72 gyms=healthy,crunch cseats=48,64 nights=200 out=<jsonl>.
## One JSON line a career; tools/turnprobe11_sum.py turns the lines into docs/TURNPROBE11_RESULT.md's tables.

const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")
const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const V11 := preload("res://tools/turnprobe11_rules.gd")

const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const CASH := {"healthy": 12000, "crunch": 1000, "crunch52": 1000, "dayjob": 12000}
const CONTROL_ASKS := ["price", "costs"]   ## today's asks played (TURNPROBE3B: later +4, softer and split were never best)
const BOT_AIM := 0.65        ## the booking bot takes the offered pro fight whose read is nearest this
const DICE_DAY := 50000      ## PlanTest.DICE_DAY: scratch nights far from any real fight night
const MAX_WEEKS := 156
var weeks := 40
var out_path := ""
var t0 := 0
var n_done := 0


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).trim_prefix(key + "=")
	return def


func _say(d: Dictionary) -> void:
	var s := JSON.stringify(d)
	if out_path != "":
		var fh := FileAccess.open(out_path, FileAccess.READ_WRITE if FileAccess.file_exists(out_path) else FileAccess.WRITE)
		if fh != null:
			fh.seek_end()
			fh.store_line(s)
			fh.close()
	if str(d.get("tag", "")) != "career":
		print(s)


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	var stage := _arg("stage", "b")
	var days := int(_arg("days", "4"))
	weeks = int(_arg("weeks", "40"))
	out_path = _arg("out", "")
	var seats: Array = Array(_arg("seats", "48,56,64,72").split(",")).map(func(s): return int(s))
	var gyms: Array = Array(_arg("gyms", "healthy,crunch").split(","))
	var cseats: Array = Array(_arg("cseats", "48,64").split(",")).map(func(s): return int(s))
	var nights := int(_arg("nights", "200"))
	var people: Array = [Data.lucy()] + Data.PROSPECTS
	var which: Array = Array(_arg("boxers", "0,1,2,3,4,5").split(",")).map(func(s): return int(s))
	_say({"tag": "run", "stage": stage, "days": days, "weeks": weeks, "seats": seats, "gyms": gyms, "cseats": cseats, "nights": nights, "boxers": which,
		"people": people.map(func(p): return "%s (%s, %s, %s, potential %s)" % [p["name"], p["style"], p["stance"], p["div"], str(p.get("pot", "?"))]),
		"picks": PICKS, "bot": "takes every legal amateur bout; books the offered pro fight read nearest %.2f" % BOT_AIM})
	for bi in which:
		var snap := _build(people[bi], 7000 + bi * 137)
		if snap.is_empty():
			_say({"tag": "noready", "b": bi, "who": str(people[bi]["name"])})
			continue
		var calls := _calls(snap, 1 if stage == "a" else days)
		for k in calls.size():
			var cc: Career = calls[k]
			var cf: Dictionary = cc.fighter_by_id(str(snap["fid"]))
			_say({"tag": "call", "b": bi, "who": str(cf["name"]), "style": str(cf.get("style", "")), "k": k, "day": cc.day, "w": int(cf["w"]), "l": int(cf["l"]),
				"members": cc.members, "rep": cc.reputation, "cash": cc.cash, "loyalty": Loyalty.value(cf), "morale": float(cf.get("morale", 50.0)),
				"seats_real": ProOfferWire.forecast(cc, cf, Roster.titles(cf)), "wish": V11.wish(cf), "night": DebutRead.DebutOpp.night(cf["stats"]),
				"t": (Time.get_ticks_msec() - t0) / 1000})
			if stage == "a":
				_stage_a(bi, cc, str(snap["fid"]), nights)
				continue
			for s in seats:
				for g in gyms:
					if str(g) == "crunch" and not cseats.has(int(s)):
						continue
					_cell(bi, k, cc, str(snap["fid"]), int(s), str(g))
	print("TURNPROBE11 done: %d careers, %.1f s" % [n_done, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)


## One person from signing to the first pro call (tools/turn_gap_probe.gd's road, the boxer's own goal kept).
func _build(who: Dictionary, seed_n: int) -> Dictionary:
	var c := Career.quick_start()
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	c.applicant = who.duplicate(true)
	Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	var guard := 0
	while c.day < MAX_WEEKS * 7 and not c.closed and guard < 5000:
		guard += 1
		if not c.pro_offer.is_empty():
			return {"career": c, "fid": str(f["id"]), "day": c.day}
		_day(c, f, "", "", {})
		Sim.step_day(c)
	return {}


## The same boxer called on n days a week apart: the amateur road goes on (no offer is shown) until the boxer is free.
func _calls(snap: Dictionary, n: int) -> Array:
	var c: Career = snap["career"]
	var f: Dictionary = c.fighter_by_id(str(snap["fid"]))
	var out: Array = []
	var guard := 0
	var last := -1
	while out.size() < n and guard < 600 and not c.closed and not c.fighter_by_id(str(snap["fid"])).is_empty():
		guard += 1
		c.pro_offer = {}
		if c.day >= int(snap["day"]) + 7 * out.size() and c.day > last and (f["bout"] as Dictionary).is_empty():
			out.append(c.duplicate(true))
			last = c.day   # never two calls on one day: the same dice twice
			continue
		_day(c, f, "", "", {})
		Sim.step_day(c)
	return out


## The call as one cell sees it: seats and cash set, the offer made by the game (both houses), every option played out.
func _cell(bi: int, k: int, call: Career, fid: String, seats: int, gym: String) -> void:
	var c: Career = call.duplicate(true)
	var f: Dictionary = c.fighter_by_id(fid)
	c.pro_offer = {}
	var base := ProOfferWire.forecast(c, f, Roster.titles(f)) - int(floor(c.members * 0.5))
	c.members = maxi(0, 2 * (seats - base))
	# the gym's draw follows its reputation (Membership.natural_members): set to the members, or the seats walk back in weeks
	c.reputation = clampi(roundi((float(c.members) - 48.0) / 0.6), 0, 100)
	c.cash = int(CASH[gym])
	if gym == "crunch52":
		f["loyalty"] = 52
	if gym == "dayjob":
		GymSpend.set_stipend(c, f, false)
		f["day_job"] = true
	c.pro_offer = ProOfferWire.make(c, f, Roster.titles(f))
	var offs: Array = c.pro_offer.get("offers", [])
	if offs.size() != 2:
		_say({"tag": "skip", "b": bi, "k": k, "seats": seats, "gym": gym, "why": "%d houses called" % offs.size()})
		return
	var crunch := gym.begins_with("crunch")
	var runway := 0 if crunch else 999
	var opts: Array = []
	for house in ["bow", "hf"]:
		opts.append(["control", house, "none"])
		for e in ProOfferWire.answers(c, house, runway):
			if str(e["answer"]) != "wont" and str(e["kind"]) in CONTROL_ASKS:
				opts.append(["control", house, str(e["kind"])])
		for a in V11.asks(house, crunch or c.cash < int(Roster.debut_sheet(c, f, 1.0)["costs"])):
			opts.append(["v11", house, a])
	opts.append(["mutant", "hf", "none"])
	if V11.wish(f) != "" and k == 0:
		opts.append(["nowish", "bow", "none"])
		opts.append(["nowish", "hf", "none"])
	for o in opts:
		var r := _career(c, fid, str(o[0]), str(o[1]), str(o[2]), runway)
		r.merge({"tag": "career", "b": bi, "who": str(f["name"]), "k": k, "seats": seats, "gym": gym, "arm": o[0], "house": o[1], "ask": o[2]})
		_say(r)
		n_done += 1
	print("cell b%d k%d seats %d %s: %d options, %d careers, %.0f s" % [bi, k, seats, gym, opts.size(), n_done, (Time.get_ticks_msec() - t0) / 1000.0])


func _sign(c: Career, f: Dictionary, arm: String, house: String, ask: String, runway: int) -> Dictionary:
	if arm == "control":
		if ask != "none":
			ProOfferWire.ask(c, house, ask, runway)
		var t: Dictionary = ProOfferWire.offer(c.pro_offer, house)
		var shown := float(DebutRead.card(f, t, c.day, float(c.coach.get("rating", 0.0)))["win"])
		var gap := float(t.get("opp_gap", 0.0))
		Roster.turn_pro(c, house)
		return {"gap": gap, "shown": shown, "wish": ""}
	return V11.sign(c, f, house, ask, 1800 if arm == "mutant" else V11.HF_PURSE, arm != "nowish")


## One option from the call to week `weeks`: sign, camp, debut, the pro ladder. The readouts v11 section 9 names.
func _career(cell: Career, fid: String, arm: String, house: String, ask: String, runway: int) -> Dictionary:
	var c: Career = cell.duplicate(true)
	var f: Dictionary = c.fighter_by_id(fid)
	var day0 := c.day
	var cash0 := c.cash
	var st := {"sets": 0, "lean_sets": 0, "lean_diff": 0, "second_day": -1, "second_cash": 0}
	var sg := _sign(c, f, arm, house, ask, runway)
	st["share"] = Roster.share_of(f)
	var guard := 0
	while c.day < day0 + weeks * 7 and guard < 1000:
		guard += 1
		if not c.closed and not c.fighter_by_id(fid).is_empty():
			_day(c, f, arm, house, st)
		Sim.step_day(c)
	var here := not c.fighter_by_id(fid).is_empty()
	var deb: Dictionary = st.get("debut", {})
	var ok: bool = not deb.is_empty() and int(st["second_day"]) >= 0 and int(st["second_day"]) - int(deb["day"]) <= 112 \
		and int(st["second_cash"]) >= cash0 and here and not c.closed
	return {"call_day": day0, "cash0": cash0, "gap": sg["gap"], "shown": sg["shown"], "wish": sg.get("wish", ""), "covered": sg.get("covered", 0),
		"share": st["share"], "deb": deb, "second_day": st["second_day"], "second_cash": st["second_cash"], "pass": ok,
		"lean": [st["sets"], st["lean_sets"], st["lean_diff"]],
		"end": {"cash": c.cash, "members": c.members, "rep": c.reputation, "morale": float(f.get("morale", 0.0)), "loy": Loyalty.value(f),
			"dur": float(f.get("durability_cap", 99.0)), "pw": int(f.get("pro_w", 0)), "pl": int(f.get("pro_l", 0)), "pd": int(f.get("pro_d", 0)),
			"here": here, "closed": c.closed}}


## A day's answers before the clock moves. arm "" = the amateur road before the call. A v11 arm applies the map's night.
func _day(c: Career, f: Dictionary, arm: String, house: String, st: Dictionary) -> void:
	for o2 in (f["offers"] as Array).duplicate():
		if bool(o2["answered"]) or bool(o2["mismatch"]):
			continue
		if not (f["bout"] as Dictionary).is_empty():
			Bouts.decline(c, str(o2["id"]))
		else:
			Bouts.accept(c, str(o2["id"]))
	for o2 in (f["offers"] as Array).duplicate():
		if not bool(o2["answered"]):
			Bouts.decline(c, str(o2["id"]))
	if Bouts.camp_due(c, f):
		Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary).get("opp", {})), false)
	if Bouts.weigh_in_today(c, f):
		Bouts.weigh(c, f)
	if Bouts.fight_day(c, f):
		var debut: bool = arm != "" and bool((f["bout"] as Dictionary).get("tickets", false))
		var before := {"members": c.members, "rep": c.reputation, "morale": float(f.get("morale", 50.0))}
		var night: Dictionary = Roster.debut_night(c, f) if debut else {}
		Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
		if debut:
			var row: Dictionary = c.results[0]
			var outcome := str(row.get("outcome", "?"))
			var d := {"day": c.day, "o": outcome, "stop": outcome == "loss" and str(row.get("cards", "")).contains(" round "),
				"sold": int(night.get("sold", 0)), "her": int(night.get("her", 0)), "gym": int(night.get("gym", 0)), "crowd": BoutRules.WIN_MEMBERS if outcome == "win" else 0}
			if arm != "control":
				d.merge(V11.after_debut(c, f, house, before, int(d["sold"]), int(d["her"]), outcome), true)
			st["debut"] = d
		Bouts.after_fight(c, f)
	if bool(f.get("goal_talk", false)):
		Bouts.set_goal(c, f, "five_round_engine")
	if arm != "" and bool(f.get("pro", false)) and ProLadder.on_ladder(c, f) and (f["bout"] as Dictionary).is_empty():
		var rows: Array = ProLadder.offer_rows(c, f)
		if rows.is_empty():
			return
		var pick := _nearest(rows, true)
		var plain := _nearest(rows, false)
		st["sets"] = int(st["sets"]) + 1
		if rows.any(func(r): return (r["offer"] as Dictionary).has("lean")):
			st["lean_sets"] = int(st["lean_sets"]) + 1
		if plain.is_empty() or int(pick["opp"]["id"]) != int(plain["opp"]["id"]):
			st["lean_diff"] = int(st["lean_diff"]) + 1
		var res: Dictionary = ProLadder.book(c, f, int(pick["opp"]["id"]), false)
		if bool(res.get("ok", false)) and int(st["second_day"]) < 0 and st.has("debut"):
			st["second_day"] = c.day
			st["second_cash"] = c.cash


## The row read nearest the bot's aim; with_lean false = as if the house added no row (the lean's control).
func _nearest(rows: Array, with_lean: bool) -> Dictionary:
	var best := {}
	var best_d := 9.0
	for r in rows:
		if not with_lean and (r["offer"] as Dictionary).has("lean"):
			continue
		var d := absf(float((r["chance"] as Dictionary).get("mid", 0.5)) - BOT_AIM)
		if d < best_d:
			best_d = d
			best = r
	return best


## Stage A, the night: each house and ask signed at 60 seats in a healthy gym, played to the morning of fight night, then
## fought on the same scratch nights (control = today's plain offer of each house).
func _stage_a(bi: int, call: Career, fid: String, nights: int) -> void:
	var cell: Career = call.duplicate(true)
	var f0: Dictionary = cell.fighter_by_id(fid)
	cell.pro_offer = {}
	cell.members = maxi(0, 2 * (60 - (ProOfferWire.forecast(cell, f0, Roster.titles(f0)) - int(floor(cell.members * 0.5)))))
	cell.cash = int(CASH["healthy"])
	cell.pro_offer = ProOfferWire.make(cell, f0, Roster.titles(f0))
	for o in [["control", "bow", "none"], ["control", "hf", "none"], ["v11", "bow", "none"], ["v11", "bow", "softer"], ["v11", "bow", "later2"],
			["v11", "hf", "none"], ["v11", "hf", "later2"]]:
		var c: Career = cell.duplicate(true)
		var f: Dictionary = c.fighter_by_id(fid)
		var sg := _sign(c, f, str(o[0]), str(o[1]), str(o[2]), 999)
		var guard := 0
		while guard < 200 and not Bouts.fight_day(c, f) and not (f["bout"] as Dictionary).is_empty():
			guard += 1
			_day(c, f, "", "", {})
			Sim.step_day(c)
		if (f["bout"] as Dictionary).is_empty():
			continue
		if Bouts.camp_due(c, f):
			Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, false, false)
		if Bouts.weigh_in_today(c, f):
			Bouts.weigh(c, f)
		var tp: Dictionary = BoutRules.tank_parts_for(c.results, f, float(f.get("week_fatigue", 20.0)), int(f["bout"].get("day", c.day)))
		var res := {"win": 0, "draw": 0, "loss": 0, "stop_l": 0}
		for n in nights:
			var parts := _one(c, f, DICE_DAY + n * 7, float(tp["off"])).split(":")
			res[parts[0] if res.has(parts[0]) else "loss"] += 1
			if parts[0] == "loss" and parts[1] != "" and parts[1] != "RTD":
				res["stop_l"] += 1
		res.merge({"tag": "night", "b": bi, "who": str(f["name"]), "arm": o[0], "house": o[1], "ask": o[2], "n": nights, "gap": sg["gap"], "shown": sg["shown"],
			"plain": sg.get("plain", sg["shown"]), "opp": str(f["bout"]["opp"]["style"]), "rating": float(f["bout"]["opp"]["rating"])})
		_say(res)


func _one(c: Career, f: Dictionary, day: int, tank_off: float) -> String:
	var sc := Career.new()
	sc.day = day
	sc.coach = c.coach.duplicate(true)
	sc.seed = c.seed
	var sf: Dictionary = f.duplicate(true)
	sf["bout"]["stale"] = tank_off
	sf["bout"]["tank_why"] = ""
	sc.fighters = [sf]
	var m := BoutNight.fight_modal(sf)
	BoutNight.play_out(sc, sf, m)
	return BoutNight.outcome_of(sf, m) + ":" + BoutNight.stopped(m)
