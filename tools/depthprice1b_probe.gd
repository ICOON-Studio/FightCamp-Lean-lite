extends SceneTree
## DEPTHPRICE1B (DEPTH_SCOPE_S534 change 1, club rows): price the four solved club choices, on a greybox.
## MEASUREMENT ONLY: every price is a flagged LOCAL rule applied from this file after the game's own day (Sim.step_day);
## nothing under scripts/ is changed. One row a run: -- row=14|15|17|7 [kinds=..] [seeds=..] [careers=n] [weeks=n]
## [rules=control,priced] [size=1|2] [arms=..]. One "DP1B {json}" line a career; docs/DEPTHPRICE1B_RESULT.md is written
## from those lines (the tables are not built here).
## Population: 5 club kinds x 2 seed sets = 10 cells. Kinds: the game's three starts (ClubStart fresh / debt / backed),
## "short" (fresh on 4 weeks of costs, MONEYFOUR2's CASH-SHORT) and "test" (TestClub: three boxers in three classes).
## The career seed is the same in every arm and rule of a cell (paired). No two fighters are identical: the walk-ins are
## the game's own (Lucy; the debt start's better, heavier walk-in; Kira and Josh in the test club).
##   row 14 CLASS NIGHTS  arms N0 / N1 (Wed) / N3 (Mon+Wed+Fri, the coach's pad nights)
##          price: the class takes the coach's whole evening - a boxer on pads that night drills NOTHING (0.0, today
##          ClubClasses.BAG_SHARE 0.5). size 2: and the coach, spent, does not coach the next morning (gain x WeekPlan.TIRED_GAIN).
##   row 15 STIPEND / DAY JOB  arms FULL / HALF / JOB (every amateur boxer of the club)
##          price: a winning amateur's sponsorship grows - +$50 a week a win on the full stipend (half: +$25), up to 7 wins.
##          SECOND PRICE (size=2, after the first pointed the wrong way): the stipend stays flat and the JOB takes evenings -
##          a boxer on a day job misses Monday's and Wednesday's pads, on the half sponsorship Wednesday's.
##   row 17 THE FIT-OUT LOAN  arms NEVER / EARLY (name draws 5 past the room, deposit + 2 weeks of costs banked) /
##          LATE (name draws 35 past the room, deposit + 8 weeks banked)
##          price: a week that ends below $0 while the loan runs is a missed payment - a late fee of one payment
##          (GymUpgrades.LOAN.week) and the club's name takes BoutRules.STOPPED_LOSS_REPUTATION. size 2: and after a move
##          a fifth of the members do not follow (they come back by the weekly walk), and the sponsor the move brings
##          signs only once the new room is half full.
##   row 7  DIET  arms CUT (the diet on Cut all year) / HOLD (on Hold: only the camp's and the fight week's own cut runs).
##          Every boxer starts 1.5 kg over her class. price: a day on the cut builds less - the day's stat gains
##          x WeekPlan.TIRED_GAIN (0.6). size 2: and the cut leaves heavier legs (+4 fatigue a cut day).

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const DayJob := preload("res://scripts/rules/DayJob.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const KINDS := ["fresh", "debt", "backed", "short", "test"]
const ARMS := {"14": ["N0", "N1", "N3"], "15": ["FULL", "HALF", "JOB", "TOP1"], "17": ["NEVER", "EARLY", "LATE"], "7": ["CUT", "HOLD"]}
const WEEKS := {"14": 52, "15": 78, "17": 104, "7": 52}
const CLASS_NIGHTS := {"N0": [], "N1": [2], "N3": [0, 2, 4]}
const OVER_KG := 1.5
const WIN_STEP := 50   # row 15: dollars a week a win on the full stipend
const WIN_CAP := 7
const MOVE_LOSS := 0.2   # row 17 size 2: the members who do not follow a move
const CUT_FATIGUE := 4.0   # row 7 size 2

var row := "14"
var size := 1
var st := {}   # the running career's counters


func _initialize() -> void:
	var kinds: Array = KINDS
	var seeds: Array = [4421, 9001]
	var careers := 4
	var rules: Array = ["control", "priced"]
	var arms: Array = []
	var weeks := 0
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("row="): row = s.trim_prefix("row=")
		elif s.begins_with("kinds="): kinds = Array(s.trim_prefix("kinds=").split(","))
		elif s.begins_with("seeds="): seeds = Array(s.trim_prefix("seeds=").split(",")).map(func(x): return int(x))
		elif s.begins_with("careers="): careers = int(s.trim_prefix("careers="))
		elif s.begins_with("rules="): rules = Array(s.trim_prefix("rules=").split(","))
		elif s.begins_with("arms="): arms = Array(s.trim_prefix("arms=").split(","))
		elif s.begins_with("weeks="): weeks = int(s.trim_prefix("weeks="))
		elif s.begins_with("size="): size = int(s.trim_prefix("size="))
	if arms.is_empty():
		arms = ARMS[row]
	if weeks <= 0:
		weeks = int(WEEKS[row])
	var t0 := Time.get_ticks_msec()
	print("DEPTHPRICE1B row=%s size=%d kinds=%s seeds=%s careers=%d weeks=%d rules=%s arms=%s" % [row, size, str(kinds),
		str(seeds), careers, weeks, str(rules), str(arms)])
	var n := 0
	for kind in kinds:
		for ss in seeds:
			for i in careers:
				var seen := {}   # row 17: the arm's control career, to reuse when the price could not have fired
				for rule in rules:
					for arm in arms:
						# an arm the price cannot touch runs once (its control line is its priced line)
						if rule == "priced" and rules.has("control") and ((row == "14" and arm == "N0") or (row == "17" and arm == "NEVER")):
							continue
						if row == "15" and arm == "TOP1" and kind != "test":
							continue   # one boxer: the best boxer on the stipend IS the FULL arm
						var r: Dictionary
						if row == "17" and rule == "priced" and seen.has(arm) and int(seen[arm]["loan_below"]) == 0 and (size < 2 or (seen[arm]["moves"] as Array).is_empty()):
							r = (seen[arm] as Dictionary).duplicate(true)   # no week below $0 while paying: the priced career is this one, day for day
							r["rule"] = "priced"; r["copied"] = true
						else:
							r = _career(str(kind), int(ss), i, str(rule), str(arm), weeks)
						if rule == "control":
							seen[arm] = r
						print("DP1B " + JSON.stringify(r))
						n += 1
	print("DEPTHPRICE1B row=%s size=%d done careers=%d wall=%.0fs" % [row, size, n, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)


func _make(kind: String, seed_n: int) -> Career:
	var c := Career.quick_start("Anvil Street Gym", "London", kind if kind in ["debt", "backed"] else "fresh")
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	for r in c.rivals:   # quick_start seeds the rivals' pasts off randi(): re-seed so a cell's arms meet the same field
		var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == str(r.get("div", ""))).map(func(o): return [o["name"], o["club"]])
		r["bouts"] = RivalPast.seed(r, others, c.seed, c.day)
	if kind == "test":
		TestClub.make(c)
	else:
		Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	if kind == "short":
		c.cash = 4 * int(Sim.weekly_costs(c)["total"])
	return c


func _career(kind: String, seed_set: int, idx: int, rule: String, arm: String, weeks: int) -> Dictionary:
	var c := _make(kind, seed_set + idx * 137)
	var priced := rule == "priced"
	var costs0: int = int(Sim.weekly_costs(c)["total"])
	st = {"bouts": 0, "wins": 0, "missed": 0, "cut_days": 0, "class_cash": 0, "halved": 0, "below": 0, "min_cash": c.cash,
		"moves": [], "late": 0, "loan_below": 0, "approached": 0, "promised": 0, "matched": 0, "pro_calls": 0, "pro": 0, "stipend_paid": 0, "run_below": 0, "max_run": 0}
	var m0 := _mastery(c)
	var s0 := _stats(c)
	var cash0 := c.cash
	if row == "14":
		for d in CLASS_NIGHTS[arm]:
			ClubClasses.toggle(c.coach, int(d))
	else:
		ClubClasses.toggle(c.coach, 2)   # the sensible owner's Wednesday class (GYMSURVIVE1: without it a fresh gym closes)
	var boxers0: int = c.fighters.size()
	if row == "15":
		_sponsor(c, arm)
	if row == "7":
		for f in c.fighters:
			f["weight"] = maxf(float(f["weight"]), float(f["limit"]) + OVER_KG)
	var prem0: int = c.premises
	var coach_tired := {}   # row 14 size 2: fighter id -> true when last night was a class night
	var guard := 0
	while c.day < weeks * 7 and not c.closed and guard < 20000:
		guard += 1
		var dow := posmod(c.day, 7)
		if row == "7":
			for f in c.fighters:
				f["diet"] = "cut" if arm == "CUT" else "hold"
		if row == "17" and dow == 0:   # every arm grows the same way; NEVER only never moves
			_grow(c, costs0, arm == "EARLY", arm != "NEVER")
		if dow == 0:
			# every arm signs a sponsor on offer; row 17 size 2: the sponsor a move brings signs only once the new room is half full
			var half_full: int = (int(GymUpgrades.premises(maxi(0, c.premises - 1))["cap"]) + int(GymSpend.premises(c)["cap"])) / 2
			var sponsor_waits: bool = priced and row == "17" and size >= 2 and c.members < half_full
			for d in c.deals:
				if str(d.get("state", "")) == "offer" and not sponsor_waits:
					d["state"] = "signed"
		if row == "15":
			# a rival club comes for an unhappy boxer (ApproachWire): the owner keeps her the cheapest way - the promised
			# club show when one can be booked, else matching the offer (the stipend, held 12 weeks)
			for f in ApproachWire.open_for(c):
				st["approached"] = int(st["approached"]) + 1
				if ApproachWire.answer(c, str(f["id"]), "promise") == "":
					st["promised"] = int(st["promised"]) + 1
				elif ApproachWire.answer(c, str(f["id"]), "match") == "":
					st["matched"] = int(st["matched"]) + 1
			if dow == 0:
				_sponsor(c, arm)   # back to the arm's deal once a matched offer's 12 weeks are over
				_stipends(c, priced)
		if not c.pro_offer.is_empty():
			st["pro_calls"] = int(st["pro_calls"]) + 1
			Roster.turn_pro(c, "")
		if c.premises > prem0:
			(st["moves"] as Array).append(Clock.week_of(c.day))
			prem0 = c.premises
			if priced and row == "17" and size >= 2:
				c.members -= int(float(c.members) * MOVE_LOSS)
		_answer_open(c)
		# what the day's price needs to know before the game steps the day
		var before := {}
		var class_night: bool = ClubClasses.on(c.coach, dow)
		for f in c.fighters:
			var fid := str(f["id"])
			var on_pads: bool = row == "14" and class_night and (PadWeek.nights_of(f).get("pads", []) as Array).has(dow)
			var cutting: bool = row == "7" and str(Sim.week_ctx(c, f)["diet"]) == "cut"
			before[fid] = {"pads": on_pads, "cut": cutting, "stats": (f["stats"] as Dictionary).duplicate()}
			st["halved"] = int(st["halved"]) + int(on_pads)
			st["cut_days"] = int(st["cut_days"]) + int(cutting)
		var paying: bool = c.fitout_weeks > 0
		Sim.step_day(c)
		if priced:
			for f in c.fighters:
				var b: Dictionary = before.get(str(f["id"]), {})
				if b.is_empty():
					continue
				# the class took the coach's evening: the night the game noted for Sunday's drill (DrillWeek.note) carries 0 minutes
				var noted: Dictionary = f.get(DrillWeek.NOTED, {})
				if row == "14" and bool(b["pads"]) and noted.has(str(dow)):
					noted[str(dow)]["minutes"] = 0.0
				# row 15, second price: the job takes evenings - a boxer on a day job misses Monday's and Wednesday's pads
				# (DayJob.LOST 2), on the half sponsorship Wednesday's (HALF_LOST 1); the night noted for Sunday carries 0 minutes
				if row == "15" and size >= 2 and noted.has(str(dow)) and str(noted[str(dow)]["kind"]) == "pads" and [2, 0].slice(0, DayJob.count_of(f)).has(dow):
					noted[str(dow)]["minutes"] = 0.0
					st["halved"] = int(st["halved"]) + 1
				if row == "14" and size >= 2 and bool(coach_tired.get(str(f["id"]), false)):
					_scale_gain(f, b["stats"], WeekPlan.TIRED_GAIN)
				if row == "7" and bool(b["cut"]):
					_scale_gain(f, b["stats"], WeekPlan.TIRED_GAIN)
					if size >= 2:
						f["week_fatigue"] = minf(100.0, float(f.get("week_fatigue", 20.0)) + CUT_FATIGUE)
		for f in c.fighters:
			coach_tired[str(f["id"])] = bool((before.get(str(f["id"]), {}) as Dictionary).get("pads", false))
		if c.day % 7 == 0:
			st["class_cash"] = int(st["class_cash"]) + int(GymSpend.income(c)["class_nights"])
			for f in c.fighters:
				st["stipend_paid"] = int(st["stipend_paid"]) + int(f.get("weekly_salary", 0))
			if priced and row == "17" and paying and c.cash < 0:
				c.pay(-int(GymUpgrades.LOAN["week"]), "Fit-out loan: late fee")
				c.reputation = maxi(0, c.reputation - BoutRules.STOPPED_LOSS_REPUTATION)
				st["late"] = int(st["late"]) + 1
			st["below"] = int(st["below"]) + int(c.cash < 0)
			st["loan_below"] = int(st["loan_below"]) + int(paying and c.cash < 0)
			st["run_below"] = int(st["run_below"]) + 1 if c.cash < 0 else 0
			st["max_run"] = maxi(int(st["max_run"]), int(st["run_below"]))
			st["min_cash"] = mini(int(st["min_cash"]), c.cash)
	var m1 := _mastery(c)
	var s1 := _stats(c)
	var owed: int = GymUpgrades.loan_left(c.fitout_weeks)
	return {"row": row, "size": size, "rule": rule, "arm": arm, "kind": kind, "ss": seed_set, "idx": idx, "closed": c.closed,
		"close_week": Clock.week_of(c.day) if c.closed else -1, "cash0": cash0, "cash": c.cash, "owed": owed, "members": c.members,
		"rep": c.reputation, "boxers": c.fighters.size(), "premises": c.premises, "bouts": st["bouts"], "wins": st["wins"],
		"missed": st["missed"], "cut_days": st["cut_days"], "class_cash": st["class_cash"], "halved": st["halved"],
		"below": st["below"], "max_run": st["max_run"], "min_cash": st["min_cash"], "moves": st["moves"], "late": st["late"], "loan_below": st["loan_below"], "approached": st["approached"], "promised": st["promised"],
		"matched": st["matched"], "left": boxers0 - c.fighters.size(),
		"pro_calls": st["pro_calls"], "pro": c.fighters.filter(func(f): return bool(f.get("pro", false))).size(),
		"stipend_paid": st["stipend_paid"], "mastery": snappedf(m1 - m0, 0.1), "stats": snappedf(s1 - s0, 0.01),
		"natural": Membership.natural_members(c.reputation, c.dues_band)}


## The day's stat gains x k (the part above the morning's value shrinks; a stat that did not rise is left alone).
func _scale_gain(f: Dictionary, was: Dictionary, k: float) -> void:
	for key in (f["stats"] as Dictionary).keys():
		var a := float(f["stats"][key])
		var b := float(was.get(key, a))
		if a > b:
			f["stats"][key] = b + (a - b) * k


## Row 15: the arm's deal for every amateur boxer - FULL the club stipend, HALF half of it (one work morning), JOB the
## day job, TOP1 the stipend for the boxer with the most potential and the day job for the rest. A stipend an answer
## to a rival club holds is left alone until its end day.
func _sponsor(c: Career, arm: String) -> void:
	var top := ""
	var top_pot := -1
	for f in c.fighters:
		if not bool(f.get("pro", false)) and int(f.get("pot", 0)) > top_pot:
			top_pot = int(f.get("pot", 0)); top = str(f["id"])
	for f in c.fighters:
		if bool(f.get("pro", false)) or ApproachWire.stipend_locked(c, f):
			continue
		var want := "full" if arm == "FULL" or (arm == "TOP1" and str(f["id"]) == top) else ("half" if arm == "HALF" else "job")
		var has := "half" if bool(f.get("half_job", false)) else ("job" if bool(f.get("day_job", false)) else "full")
		if want == has:
			continue
		if want == "half": GymSpend.set_half(c, f)
		else: GymSpend.set_stipend(c, f, want == "full")


## Row 15: the week's sponsorship. Control = the game's own flat stipend (set_stipend / set_half wrote it). Priced = it
## grows with her wins: +WIN_STEP a week a win (x size), half on the half sponsorship, up to WIN_CAP wins.
func _stipends(c: Career, priced: bool) -> void:
	for f in c.fighters:
		if bool(f.get("pro", false)) or int(f.get("weekly_salary", 0)) <= 0:
			continue
		var half := bool(f.get("half_job", false))
		var base: int = roundi(GameMoney.FIGHTER_STIPEND * 0.5) if half else GameMoney.FIGHTER_STIPEND
		var step: int = (WIN_STEP * size) / (2 if half else 1)
		f["weekly_salary"] = base + (step * mini(int(f.get("w", 0)), WIN_CAP) if priced and size < 2 else 0)


func _mastery(c: Career) -> float:
	var total := 0.0
	for f in c.fighters:
		for k in ["moves", "combos", "own_combos"]:
			for v in (f.get(k, {}) as Dictionary).values():
				total += float(v) if (v is float or v is int) else float((v as Dictionary).get("mastery", 0.0)) if v is Dictionary else 0.0
	return total


func _stats(c: Career) -> float:
	var total := 0.0
	for f in c.fighters:
		for v in (f["stats"] as Dictionary).values():
			total += float(v)
	return total


## Row 17: the careful owner's Monday (tools/gym_survive_probe.gd _grow, kept: recruit to 3, fitness kit + assistant, the
## youth section, the cheapest kit while the name draws more than the room) and the move on the fit-out loan.
## EARLY: the name draws 5 past the room and the deposit + 2 weeks of costs are banked. LATE: 35 past, + 8 weeks.
func _grow(c: Career, costs0: int, early: bool, may_move: bool) -> void:
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
	var natural: int = Membership.natural_members(c.reputation, c.dues_band)
	var cap: int = int(GymSpend.premises(c)["cap"])
	var bank: int = int(GymUpgrades.LOAN["down"]) + costs0 * (2 if early else 8)
	if may_move and natural >= cap + (5 if early else 35) and c.premises + 1 < GymUpgrades.PREMISES.size() and c.cash > bank:
		if GymSpend.move(c, true) == "":
			return
	if natural > GymSpend.member_cap(c):
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


## The bout loop of tools/gym_survive_probe.gd (accept the sheet's offers, camps, weigh-ins, the fight by the sim), with
## the counts this probe reads: bouts, wins, missed weights.
func _answer_open(c: Career) -> void:
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
			if not Bouts.weigh(c, f):
				st["missed"] = int(st["missed"]) + 1
		if Bouts.fight_day(c, f):
			var n0: int = c.results.size()
			var top: Variant = c.results[0] if n0 > 0 else null
			Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
			Bouts.after_fight(c, f)
			if not c.results.is_empty() and (c.results.size() > n0 or c.results[0] != top):
				st["bouts"] = int(st["bouts"]) + 1
				st["wins"] = int(st["wins"]) + int(bool(c.results[0]["win"]))
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
