extends SceneTree
## TURNPROBE13 (S536, ops/research/TASK_TURNPRO13.md): the probe map v13 (DESIGN_TURNPRO1_V13.md section 9) defines, run
## BEFORE any critic scores the map. Measurement only: nothing under scripts/ is touched; v13's rules are the flagged local
## copy tools/turnprobe13_rules.gd. A copy of tools/turnprobe12.gd: the same population, pairing, bot and cells.
## ARMS: control = today's rules (the game's own ProOfferWire.ask + Roster.turn_pro + BoutFinish); v13 = the map's rules;
## flat = v13 with the tune-up name rule OFF (the new lever's control arm: every pro win pays the usual 5 reputation).
## The MUTANT is today's costs ask on the guarantee house (control arm): the instrument must read its proven +$909.
## POPULATION (printed): the six people the game can sign (Data.lucy + Data.PROSPECTS), each played from signing to the
## first pro call by a bot that takes every legal bout, then CALLED on `days` different days at least a week apart: a
## bout's dice are the fight day's (BoutNight._counts), never the career seed, so one call WEEK of a boxer is one roll
## (tools/turnprobe13_sum.py counts a boxer's week once).
## CELL = gym on the day of the call: seats 48 / 56 / 64 with room for more members (members set so the forecast reads
## that, reputation set to carry them), or "full" (members at the gym's cap, a name that draws 10 more). Cash $12,000.
## Each cell x roll plays both v13 options (ticket house, guarantee house; no ask) from the call to week `weeks`; the
## cells in `ctl` also play today's rules (ticket no ask, guarantee no ask, guarantee costs) and the flat arm (both houses).
## Stage A (stage=a): each boxer x house x ask on `nights` scratch nights (PlanTest's dice, as tools/turn_gap_probe.gd).
## Args (after --): stage=b|a boxers=0,1 seeds=1 days=36 weeks=40 cells=48,56,64,full ctl=56,full nights=200 out=<jsonl>.
## One JSON line a career; tools/turnprobe13_sum.py turns the lines into docs/TURNPROBE13_RESULT.md's tables.

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
const V13 := preload("res://tools/turnprobe13_rules.gd")

const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const CASH := 12000
const ROAD_CASH := 3000      ## the amateur road between calls: cash never under this (each cell sets its own cash at the call)
const FULL_DRAW := 10        ## the full cell: the gym's name draws this many more than it has room for
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
	var days := int(_arg("days", "36"))
	var seeds := int(_arg("seeds", "1"))
	weeks = int(_arg("weeks", "40"))
	out_path = _arg("out", "")
	var cells: Array = Array(_arg("cells", "48,56,64,full").split(","))
	var ctl: Array = Array(_arg("ctl", "56,full").split(","))
	var nights := int(_arg("nights", "200"))
	var people: Array = [Data.lucy()] + Data.PROSPECTS
	var which: Array = Array(_arg("boxers", "0,1,2,3,4,5").split(",")).map(func(s): return int(s))
	_say({"tag": "run", "stage": stage, "days": days, "seeds": seeds, "weeks": weeks, "cells": cells, "ctl": ctl, "nights": nights, "boxers": which,
		"people": people.map(func(p): return "%s (%s, %s, %s, potential %s)" % [p["name"], p["style"], p["stance"], p["div"], str(p.get("pot", "?"))]),
		"picks": PICKS, "bot": "takes every legal amateur bout; books the offered pro fight read nearest %.2f" % BOT_AIM})
	for bi in which:
		for si in (1 if stage == "a" else seeds):
			var snap := _build(people[bi], 7000 + bi * 137 + si * 1009)
			if snap.is_empty():
				_say({"tag": "noready", "b": bi, "s": si, "who": str(people[bi]["name"])})
				continue
			var calls := _calls(snap, 1 if stage == "a" else days)
			for j in calls.size():
				var k: int = si * 100 + j
				var cc: Career = calls[j]
				var cf: Dictionary = cc.fighter_by_id(str(snap["fid"]))
				_say({"tag": "call", "b": bi, "who": str(cf["name"]), "style": str(cf.get("style", "")), "k": k, "day": cc.day, "w": int(cf["w"]), "l": int(cf["l"]),
					"members": cc.members, "rep": cc.reputation, "cap": GymSpend.member_cap(cc), "loyalty": Loyalty.value(cf),
					"seats_real": ProOfferWire.forecast(cc, cf, Roster.titles(cf)), "night": DebutRead.DebutOpp.night(cf["stats"]),
					"t": (Time.get_ticks_msec() - t0) / 1000})
				if stage == "a":
					_stage_a(bi, cc, str(snap["fid"]), nights)
					continue
				for cell in cells:
					_cell(bi, k, cc, str(snap["fid"]), str(cell), ctl.has(cell))
	print("TURNPROBE13 done: %d careers, %.1f s" % [n_done, (Time.get_ticks_msec() - t0) / 1000.0])
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
		_day(c, f, "", "", "", {})
		Sim.step_day(c)
	return {}


## The same boxer called on n days at least a week apart: the amateur road goes on (no offer is shown) until the boxer is free.
func _calls(snap: Dictionary, n: int) -> Array:
	var c: Career = snap["career"]
	var f: Dictionary = c.fighter_by_id(str(snap["fid"]))
	var out: Array = []
	var guard := 0
	var last := -1
	while out.size() < n and guard < 1500 and not c.closed and not c.fighter_by_id(str(snap["fid"])).is_empty():
		guard += 1
		c.pro_offer = {}
		c.cash = maxi(c.cash, ROAD_CASH)   # the bot does not run the gym: keep its doors open so the road gives every call week
		if c.day >= maxi(int(snap["day"]), last + 7) and (f["bout"] as Dictionary).is_empty():
			out.append(c.duplicate(true))
			last = c.day   # never two calls inside a week: the same Saturday is the same dice
			continue
		_day(c, f, "", "", "", {})
		Sim.step_day(c)
	return out


## The call as one cell sees it: members, name and cash set, the offer made by the game (both houses), every option played out.
func _cell(bi: int, k: int, call: Career, fid: String, cell: String, with_control: bool) -> void:
	var c: Career = call.duplicate(true)
	var f: Dictionary = c.fighter_by_id(fid)
	c.pro_offer = {}
	var cap := GymSpend.member_cap(c)
	if cell == "full":
		c.members = cap
		c.reputation = clampi(roundi((float(cap + FULL_DRAW) - 48.0) / 0.6), 0, 100)
	else:
		var base := ProOfferWire.forecast(c, f, Roster.titles(f)) - int(floor(c.members * 0.5))
		c.members = maxi(0, 2 * (int(cell) - base))
		# the gym's draw follows its reputation (Membership.natural_members): set to the members, or the seats walk back in weeks
		c.reputation = clampi(roundi((float(c.members) - 48.0) / 0.6), 0, 100)
	c.cash = CASH
	var seats := ProOfferWire.forecast(c, f, Roster.titles(f))
	c.pro_offer = ProOfferWire.make(c, f, Roster.titles(f))
	var offs: Array = c.pro_offer.get("offers", [])
	if offs.size() != 2:
		_say({"tag": "skip", "b": bi, "k": k, "cell": cell, "seats": seats, "why": "%d houses called" % offs.size()})
		return
	var opts: Array = []
	for house in ["bow", "hf"]:
		for a in V13.asks(house):
			opts.append(["v13", house, a])
	if with_control:
		opts.append(["flat", "bow", "none"])
		opts.append(["flat", "hf", "none"])
		opts.append(["control", "bow", "none"])
		opts.append(["control", "hf", "none"])
		opts.append(["control", "hf", "costs"])
	for o in opts:
		var r := _career(c, fid, str(o[0]), str(o[1]), str(o[2]))
		r.merge({"tag": "career", "b": bi, "who": str(f["name"]), "k": k, "cell": cell, "seats": seats, "cap": cap, "members0": c.members, "rep0": c.reputation,
			"arm": o[0], "house": o[1], "ask": o[2]})
		_say(r)
		n_done += 1
	print("cell b%d k%d %s (seats %d, members %d of %d): %d options, %d careers, %.0f s" % [bi, k, cell, seats, c.members, cap, opts.size(), n_done,
		(Time.get_ticks_msec() - t0) / 1000.0])


func _sign(c: Career, f: Dictionary, arm: String, house: String, ask: String) -> Dictionary:
	if arm == "control":
		if ask != "none":
			ProOfferWire.ask(c, house, ask, 999)
		var t: Dictionary = ProOfferWire.offer(c.pro_offer, house)
		var shown := float(DebutRead.card(f, t, c.day, float(c.coach.get("rating", 0.0)))["win"])
		var gap := float(t.get("opp_gap", 0.0))
		Roster.turn_pro(c, house)
		return {"gap": gap, "plain": shown, "shown": shown}
	return V13.sign(c, f, house, ask)


## One option from the call to week `weeks`: sign, camp, debut, the pro ladder. The readouts v13 section 9 names.
func _career(cell: Career, fid: String, arm: String, house: String, ask: String) -> Dictionary:
	var c: Career = cell.duplicate(true)
	var f: Dictionary = c.fighter_by_id(fid)
	var day0 := c.day
	var cash0 := c.cash
	var st := {"sets": 0, "kinds": {"tune": 0, "above": 0, "payday": 0}, "kind": "", "tune_wins": 0, "name_back": 0}
	var sg := _sign(c, f, arm, house, ask)
	st["gap"] = float(sg["gap"])
	var guard := 0
	while c.day < day0 + weeks * 7 and guard < 1000:
		guard += 1
		if not c.closed and not c.fighter_by_id(fid).is_empty():
			_day(c, f, arm, house, ask, st)
		Sim.step_day(c)
	var here := not c.fighter_by_id(fid).is_empty()
	var e: Dictionary = ProLadder.entry(c, f) if here and bool(f.get("pro", false)) and not c.world.is_empty() else {}
	return {"call_day": day0, "cash0": cash0, "gap": sg["gap"], "shown": sg["shown"], "deb": st.get("debut", {}), "sets": st["sets"], "kinds": st["kinds"],
		"tune_wins": st["tune_wins"], "name_back": st["name_back"],
		"end": {"cash": c.cash, "members": c.members, "rep": c.reputation, "morale": float(f.get("morale", 0.0)), "loy": Loyalty.value(f),
			"dur": float(f.get("durability_cap", 99.0)), "pw": int(f.get("pro_w", 0)), "pl": int(f.get("pro_l", 0)), "pd": int(f.get("pro_d", 0)),
			"rank": int(e.get("rank", 0)), "fans": int(e.get("fans", 0)), "rebuild": bool(e.get("rebuild", false)), "here": here, "closed": c.closed}}


## A day's answers before the clock moves. arm "" = the amateur road before the call. The v13 and flat arms apply the map's
## night and road; only v13 applies the tune-up name rule.
func _day(c: Career, f: Dictionary, arm: String, house: String, ask: String, st: Dictionary) -> void:
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
		var night: Dictionary = Roster.debut_night(c, f) if debut else {}
		var ladder_bout: bool = arm != "" and not debut and bool((f["bout"] as Dictionary).get("pro", false))
		Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
		if ladder_bout and not c.results.is_empty():
			var won_tune: bool = str(c.results[0].get("outcome", "")) == "win" and str(st.get("kind", "")) == "tune"
			if won_tune:
				st["tune_wins"] = int(st.get("tune_wins", 0)) + 1
			if arm == "v13":
				st["name_back"] = int(st.get("name_back", 0)) + V13.after_fight(c, str(st.get("kind", "")), str(c.results[0].get("outcome", "")))
			st["kind"] = ""
		if debut:
			var row: Dictionary = c.results[0]
			var outcome := str(row.get("outcome", "?"))
			var stopped := str(row.get("cards", "")).contains(" round ")
			var d := {"day": c.day, "o": outcome, "stop": outcome == "loss" and stopped, "sold": int(night.get("sold", 0)), "her": int(night.get("her", 0)),
				"gym": int(night.get("gym", 0))}
			if arm == "v13" or arm == "flat":
				d.merge(V13.after_debut(c, f, house, ask, int(d["sold"]), outcome, stopped, float(st.get("gap", 0.0))), true)
			st["debut"] = d
		Bouts.after_fight(c, f)
	if bool(f.get("goal_talk", false)):
		Bouts.set_goal(c, f, "five_round_engine")
	if arm != "" and bool(f.get("pro", false)) and ProLadder.on_ladder(c, f) and (f["bout"] as Dictionary).is_empty():
		if arm == "v13" or arm == "flat":
			V13.road(c, f)
		var rows: Array = ProLadder.offer_rows(c, f)
		if rows.is_empty():
			return
		var pick := _nearest(rows)
		st["sets"] = int(st["sets"]) + 1
		var res: Dictionary = ProLadder.book(c, f, int(pick["opp"]["id"]), false)
		if bool(res.get("ok", false)):
			st["kinds"][str(pick["kind"])] = int(st["kinds"].get(str(pick["kind"]), 0)) + 1
			st["kind"] = str(pick["kind"])


## The row read nearest the bot's aim.
func _nearest(rows: Array) -> Dictionary:
	var best := {}
	var best_d := 9.0
	for r in rows:
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
	cell.cash = CASH
	cell.pro_offer = ProOfferWire.make(cell, f0, Roster.titles(f0))
	for o in [["control", "bow", "none"], ["control", "hf", "none"], ["v13", "bow", "none"], ["v13", "bow", "later2"],
			["v13", "hf", "none"], ["v13", "hf", "later2"]]:
		var c: Career = cell.duplicate(true)
		var f: Dictionary = c.fighter_by_id(fid)
		var sg := _sign(c, f, str(o[0]), str(o[1]), str(o[2]))
		var guard := 0
		while guard < 200 and not Bouts.fight_day(c, f) and not (f["bout"] as Dictionary).is_empty():
			guard += 1
			_day(c, f, "", "", "", {})
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
