extends SceneTree
## LEDGERPROBE1 (S538, DEPTH_SCOPE_S534 order: probe before any sixth map): the contract tab's choice - per boxer KEEP
## him as he is / CUT his stipend (day job; he may leave) / RELEASE him (Leaving.let_go; a pro's manager pays the fee).
## MEASUREMENT ONLY: nothing under scripts/ is changed; the arms call the game's own GymSpend.set_stipend / Leaving.let_go
## on a copy of the career (SaveGame.to_dict -> from_dict) taken at the moment the tab would be opened.
## Population (named in the output): 5 club kinds (ClubStart fresh / debt / backed, "short" = fresh on 4 weeks of costs,
## "test" = TestClub) x 2 seed sets x `careers` careers. Every boxer DIFFERS: on first sight each boxer's stats move by a
## seeded -5..+5 and the potential by -8..+8 (flagged local, _differ), so no two careers hold the same person.
## The owner is the same careful owner in every arm (DEPTHPRICE1B's: Wednesday class, recruit to 3 on a good trial, kit,
## accept the sheet's bouts, turn pro on the call, keep an approached boxer by the promise else the match).
## Moments (a Monday, the boxer free of a booked bout, so RELEASE is legal):
##   LOSS     an amateur on the full stipend after two losses in a row
##   SQUEEZE  an amateur on the full stipend while the club's cash is under 4 weeks of costs
##   PRO      a professional after the first pro bout (CUT is not legal: "a pro lives on purses"; arms KEEP / RELEASE)
## One unit = (career, boxer, moment); each unit's arms start from the SAME copied state (paired).
## Read at +26 and +52 weeks: club cash net of the loan, the club's wins and bouts, reputation, members, closed.
##
## BARS, FIXED BEFORE THE RUN (cash at +52 weeks is the yardstick; wins and reputation are read beside it):
##  (a) no arm is best on cash in every cell (cell = moment x club kind, cells with 3+ units), and none in more than 6 of
##      10 (DEPTH_SCOPE_S534). An arm that sweeps cash still passes (a) only if it pays 3+ club wins in 100 bouts or 3+
##      reputation for it against another arm (a priced trade, DEPTHPRICE1B's reading).
##  (b) the bot that READS the ledger beats the blind bots by more than its error: 2-fold over the seed sets, each bot is
##      fitted on one set and scored on the other. BLIND-CONSTANT = the one best arm per moment. BLIND-RECORD = one
##      threshold on the win share (the roster shows the record without the tab). LEDGER = one threshold on what the tab
##      alone shows: his net a week to date (ticket cuts and purse share in, stipend out), for a pro the year's take.
##      Pass: LEDGER's held-out mean cash beats BOTH blind bots by more than 2 paired standard errors.
##  (c) the best arm flips on something the tab shows: split the units of a moment at the median of the ledger number;
##      the best arm differs between the halves and in each half beats the other half's best by more than 1 paired SE.
## PASS = (a) and (b) and (c). One "LP1 {json}" line a unit; docs/LEDGERPROBE1_RESULT.md is written from those lines.
## Run: -- [kinds=..] [seeds=..] [careers=n] [base=weeks] [horizon=weeks]

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const GymDeals := preload("res://scripts/state/GymDeals.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Leaving := preload("res://scripts/state/Leaving.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Region := preload("res://scripts/state/Region.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")

const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const KINDS := ["fresh", "debt", "backed", "short", "test"]
const SQUEEZE_WEEKS := 4
const MIN_DAY := 56   # no moment in the first 8 weeks: the books hold nothing yet

## The probe's own counters for the running career (copied with the career at a moment).
var ps := {}


func _initialize() -> void:
	var kinds: Array = KINDS
	var seeds: Array = [4421, 9001]
	var careers := 4
	var base := 104
	var horizon := 52
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("kinds="): kinds = Array(s.trim_prefix("kinds=").split(","))
		elif s.begins_with("seeds="): seeds = Array(s.trim_prefix("seeds=").split(",")).map(func(x): return int(x))
		elif s.begins_with("careers="): careers = int(s.trim_prefix("careers="))
		elif s.begins_with("base="): base = int(s.trim_prefix("base="))
		elif s.begins_with("horizon="): horizon = int(s.trim_prefix("horizon="))
	var t0 := Time.get_ticks_msec()
	print("LEDGERPROBE1 population: kinds=%s x seeds=%s x careers=%d, base=%d weeks, horizon=%d weeks; every boxer's stats -5..+5 and potential -8..+8 by seed" % [
		str(kinds), str(seeds), careers, base, horizon])
	var n := 0
	for kind in kinds:
		for ss in seeds:
			for i in careers:
				n += _base(str(kind), int(ss), i, base, horizon)
	print("LEDGERPROBE1 done units=%d wall=%.0fs" % [n, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)


func _make(kind: String, seed_n: int) -> Career:
	var c := Career.quick_start("Anvil Street Gym", "London", kind if kind in ["debt", "backed"] else "fresh")
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	for r in c.rivals:   # quick_start seeds the rivals' pasts off randi(): re-seed so the career is repeatable
		var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == str(r.get("div", ""))).map(func(o): return [o["name"], o["club"]])
		r["bouts"] = RivalPast.seed(r, others, c.seed, c.day)
	if kind == "test":
		TestClub.make(c)
	else:
		Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	if kind == "short":
		c.cash = SQUEEZE_WEEKS * int(Sim.weekly_costs(c)["total"])
	ClubClasses.toggle(c.coach, 2)   # the sensible owner's Wednesday class
	return c


## The base career (the owner keeps everyone). At each moment: copy the state, play every arm from the copy, print the unit.
func _base(kind: String, seed_set: int, idx: int, base: int, horizon: int) -> int:
	var c := _make(kind, seed_set + idx * 137)
	ps = {"costs0": int(Sim.weekly_costs(c)["total"]), "paid": {}, "streak": {}, "seen": {}, "fired": {}, "latch": {},
		"bouts": 0, "wins": 0, "sb": 0, "sw": 0}
	var units := 0
	var checks: Array = []   # the copy check: KEEP from the copy must equal the base career 26 weeks on
	var guard := 0
	while c.day < base * 7 and not c.closed and guard < 20000:
		guard += 1
		for ch in checks.duplicate():
			if c.day == int(ch["day"]):
				print("LP1COPY %s" % JSON.stringify({"kind": kind, "ss": seed_set, "idx": idx, "fid": ch["fid"], "same": c.cash == int(ch["cash"]) and c.reputation == int(ch["rep"])}))
				checks.erase(ch)
		if posmod(c.day, 7) == 0 and c.day >= MIN_DAY:
			_differ(c)
			for u in _moments(c):
				var fid := str(u["fid"])
				ps["fired"]["%s|%s" % [fid, u["moment"]]] = true
				var snap := SaveGame.to_dict(c)
				var ps0: Dictionary = ps.duplicate(true)
				var row := {"kind": kind, "ss": seed_set, "idx": idx, "fid": fid, "moment": u["moment"], "day": c.day,
					"tab": _tab(c, c.fighter_by_id(fid)), "arms": {}}
				for arm in (["KEEP", "RELEASE"] if str(u["moment"]) == "PRO" else ["KEEP", "CUT", "RELEASE"]):
					row["arms"][arm] = _arm(snap, ps0, fid, str(arm), horizon)
				ps = ps0
				print("LP1 " + JSON.stringify(row))
				units += 1
				if checks.size() < 2:
					var k: Dictionary = row["arms"]["KEEP"]["h26"]
					checks.append({"day": c.day + 182, "fid": fid, "cash": int(k["raw"]), "rep": int(k["rep"])})
		_day(c, "", "")
	return units


## Who is at a moment this Monday: [{fid, moment}], one unit per boxer and moment, only while RELEASE is legal.
func _moments(c: Career) -> Array:
	var out: Array = []
	var tight: bool = c.cash < SQUEEZE_WEEKS * int(Sim.weekly_costs(c)["total"])
	for f in c.fighters:
		var fid := str(f["id"])
		var pro := bool(f.get("pro", false))
		var want: Array = []
		if pro:
			if c.results.any(func(r): return str(r.get("fid", "")) == fid and bool(r.get("pro", false))):
				want.append("PRO")
		elif int(f.get("weekly_salary", 0)) > 0 and not bool(f.get("day_job", false)):
			if int((ps["streak"] as Dictionary).get(fid, 0)) >= 2:
				ps["latch"][fid + "|LOSS"] = true
			if tight:
				want.append("SQUEEZE")
			if bool((ps["latch"] as Dictionary).get(fid + "|LOSS", false)):
				want.append("LOSS")
		if want.is_empty() or f.has("leaves_after") or ApproachWire.is_open(f) or ApproachWire.stipend_locked(c, f):
			continue
		if str(Leaving.let_go_price(c, fid)["why_not"]) != "":
			continue
		for m in want:
			if not (ps["fired"] as Dictionary).has("%s|%s" % [fid, m]):
				out.append({"fid": fid, "moment": m})
				break   # one moment a boxer a Monday
	return out


## What the contract tab would show for this boxer today (and the hidden potential, for the write-up only).
func _tab(c: Career, f: Dictionary) -> Dictionary:
	var who := str(f.get("first", ""))
	var fid := str(f["id"])
	var cash_in := 0
	for e in c.ledger:
		var t := str(e["t"])
		if int(e["amount"]) > 0 and (t.begins_with("Ticket cut") or t.begins_with("Purse share") or t.begins_with("Debut tickets")) and t.contains(who):
			cash_in += int(e["amount"])
	var paid := int((ps["paid"] as Dictionary).get(fid, 0))
	var weeks: int = maxi(1, (c.day - int(f.get("joined", 0))) / 7)
	var mean := 0.0
	for v in (f["stats"] as Dictionary).values():
		mean += float(v)
	mean /= maxf(1.0, float((f["stats"] as Dictionary).size()))
	var costs: int = int(Sim.weekly_costs(c)["total"])
	return {"name": str(f["name"]), "pro": bool(f.get("pro", false)), "in": cash_in, "paid": paid, "net": cash_in - paid,
		"weeks": weeks, "net_week": snappedf(float(cash_in - paid) / float(weeks), 0.1), "w": int(f.get("w", 0)), "l": int(f.get("l", 0)),
		"streak": int((ps["streak"] as Dictionary).get(fid, 0)), "fee": Leaving.release_fee(c, f), "take": GymDeals.year_take(c, f),
		"share": Roster.share_of(f), "loyalty": Loyalty.value(f), "rank": Region.our_rank(c, f), "cash": c.cash, "costs": costs,
		"runway": snappedf(float(c.cash) / float(maxi(1, costs)), 0.1), "free_places": GymSpend.places(c) - GymSpend.used(c),
		"boxers": c.fighters.size(), "rep": c.reputation, "members": c.members, "age": int(f.get("age", 0)),
		"pot": int(f.get("pot", 0)), "stat_mean": snappedf(mean, 0.1)}


## One arm, from the copied state: the tab's answer on day 0, then the same careful owner for `horizon` weeks.
func _arm(snap: Dictionary, ps0: Dictionary, fid: String, arm: String, horizon: int) -> Dictionary:
	var c := SaveGame.from_dict(snap)
	ps = ps0.duplicate(true)
	ps["bouts"] = 0; ps["wins"] = 0; ps["sb"] = 0; ps["sw"] = 0
	var applied := ""
	var cash0: int = c.cash
	if arm == "CUT":
		applied = GymSpend.set_stipend(c, c.fighter_by_id(fid), false)
	elif arm == "RELEASE":
		applied = "" if bool(Leaving.let_go(c, fid)["ok"]) else "refused"
	var out := {"applied": applied, "fee": c.cash - cash0}
	var t0: int = c.day
	var guard := 0
	while c.day < t0 + horizon * 7 and not c.closed and guard < 20000:
		guard += 1
		if c.day == t0 + 182:
			out["h26"] = _read(c, fid)
		_day(c, fid, arm)
	out["h52"] = _read(c, fid)
	if not out.has("h26"):
		out["h26"] = out["h52"]
	return out


func _read(c: Career, fid: String) -> Dictionary:
	var f := c.fighter_by_id(fid)
	return {"cash": c.cash - GymUpgrades.loan_left(c.fitout_weeks), "raw": c.cash, "rep": c.reputation, "members": c.members,
		"bouts": ps["bouts"], "wins": ps["wins"], "sb": ps["sb"], "sw": ps["sw"], "closed": c.closed, "boxers": c.fighters.size(),
		"sub_in": not f.is_empty(), "sub_pro": bool(f.get("pro", false)), "sub_job": bool(f.get("day_job", false)), "day": c.day}


## One day of the careful owner. `sub` / `arm`: the unit's boxer and the arm (only CUT changes the owner: he does not
## buy her back with the stipend when a rival club comes - the promise if it can be booked, else she goes).
func _day(c: Career, sub: String, arm: String) -> void:
	var dow := posmod(c.day, 7)
	if dow == 0:
		_differ(c)
		_grow(c, int(ps["costs0"]))
		_differ(c)
		for d in c.deals:
			if str(d.get("state", "")) == "offer":
				d["state"] = "signed"
	for f in ApproachWire.open_for(c):
		if ApproachWire.answer(c, str(f["id"]), "promise") != "" and not (arm == "CUT" and str(f["id"]) == sub):
			ApproachWire.answer(c, str(f["id"]), "match")
	if not c.pro_offer.is_empty():
		Roster.turn_pro(c, "")
	_answer_open(c, sub)
	Sim.step_day(c)
	if c.day % 7 == 0:
		for f in c.fighters:
			var fid := str(f["id"])
			ps["paid"][fid] = int((ps["paid"] as Dictionary).get(fid, 0)) + int(f.get("weekly_salary", 0))


## No two boxers alike: on first sight, a boxer's stats move by a seeded -5..+5 and the potential by -8..+8.
func _differ(c: Career) -> void:
	for f in c.fighters:
		var fid := str(f["id"])
		if (ps["seen"] as Dictionary).has(fid):
			continue
		ps["seen"][fid] = true
		var rng := RandomNumberGenerator.new()
		rng.seed = hash(fid) + c.seed * 31
		for k in (f["stats"] as Dictionary).keys():
			var v: Variant = f["stats"][k]
			if v is float or v is int:
				f["stats"][k] = clampf(float(v) + rng.randf_range(-5.0, 5.0), 15.0, 95.0)
		if f.has("pot"):
			f["pot"] = clampi(int(f["pot"]) + rng.randi_range(-8, 8), 50, 99)


## The careful owner's Monday (tools/depthprice1b_probe.gd _grow without the move): recruit to 3 on a good trial, fitness
## kit + assistant, the youth section, the cheapest kit while the name draws more than the room.
func _grow(c: Career, costs0: int) -> void:
	var eight := costs0 * 8
	for p in c.prospects:
		if str(p.get("state", "")) == "invited" and int(p["trial_day"]) <= c.day:
			if bool(Roster.trial_read(c, p)["good"]) and c.cash > eight:
				Roster.sign_prospect(c, str(p["id"]), PICKS.duplicate())
			else:
				p["state"] = "passed"
	var waiting: bool = c.prospects.any(func(p): return str(p.get("state", "")) == "invited")
	if not waiting and c.fighters.size() < 3 and c.cash > eight:
		for p in c.prospects:
			if str(p.get("state", "")) == "scout" and Roster.invite(c, str(p["id"])):
				break
	if not GymUpgrades.has(c.upgrades, "fitkit") and c.cash > eight + 1500 + 4 * 280:
		GymSpend.buy(c, "fitkit")
		if not c.staff_roles.has("assistant"):
			GymSpend.hire(c, "assistant")
	elif not GymUpgrades.has(c.upgrades, "youth") and c.cash > eight + 1800:
		GymSpend.buy(c, "youth")
	if not c.applicant.is_empty() and c.cash > eight and c.fighters.size() < 3:
		Sim.sign(c, PICKS.duplicate())
	if Membership.natural_members(c.reputation, c.dues_band) > GymSpend.member_cap(c):
		var best := ""
		var best_per := 0.0
		for sl in GymSlots.all():
			var id := str(sl["id"])
			if int(sl["price"]) <= 0 or int(sl["places"]) <= 0 or GymSlots.blocked(id, c.gym_slots, c.cash - eight) != "":
				continue
			var per := float(sl["places"]) / float(sl["price"])
			if per > best_per:
				best_per = per
				best = id
		if best != "":
			GymSpend.buy_slot(c, best)


## The bout loop of tools/depthprice1b_probe.gd (accept the sheet's offers, camps, weigh-ins, the fight by the sim), with
## this probe's counts: the club's bouts and wins, the unit boxer's, and each boxer's run of losses.
func _answer_open(c: Career, sub: String) -> void:
	for f in c.fighters:
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
			var n0: int = c.results.size()
			var top: Variant = c.results[0] if n0 > 0 else null
			Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
			Bouts.after_fight(c, f)
			if not c.results.is_empty() and (c.results.size() > n0 or c.results[0] != top):
				var win := bool(c.results[0]["win"])
				var fid := str(f["id"])
				ps["bouts"] = int(ps["bouts"]) + 1
				ps["wins"] = int(ps["wins"]) + int(win)
				if fid == sub:
					ps["sb"] = int(ps["sb"]) + 1
					ps["sw"] = int(ps["sw"]) + int(win)
				ps["streak"][fid] = 0 if win else int((ps["streak"] as Dictionary).get(fid, 0)) + 1
		if bool(f.get("goal_talk", false)):
			Bouts.set_goal(c, f, "five_round_engine")
	for f in c.fighters:
		if bool(f.get("pro", false)) and ProLadder.on_ladder(c, f) and (f["bout"] as Dictionary).is_empty():
			var rows := ProLadder.offer_rows(c, f)
			for kind in ["above", "tune", "payday"]:
				var pick := rows.filter(func(r): return str(r["kind"]) == kind)
				if not pick.is_empty():
					ProLadder.book(c, f, int(pick[0]["opp"]["id"]), false)
					break
