extends SceneTree
## GYMSURVIVE1 (issue #414): does a fresh gym survive two years?
## Population: Career.quick_start() (one walk-in boxer signed, the shipped cash and members),
## 30 careers x 2 seeds (4421, 9001), 104 weeks, the game's day loop (Sim.step_day)
## with the bout loop as tools/turn_pro_probe3.gd _answer_open does it.
## Arms:
##   PASSIVE: touch nothing (today's probes).
##   SENSIBLE: one class night (ClubClasses, Wed), sign a second walk-in when one arrives
##             and cash > 3 months of costs, accept the first pro offer (Roster.turn_pro plain deal).
##   LEAN: SENSIBLE + half stipend / day job for the boxer when cash < 8 weeks of costs.
## Per arm: share of careers closed by week 26/52/78/104, median closure week,
##   cash at weeks 13/26/52/104 (median [p10..p90]), members at the same weeks,
##   and for every closed career the week's biggest cost lines at closure and income lines.

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

const SEEDS := [4421, 9001]
const N := 30
const WEEKS := 104
const DAYS := 104 * 7
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const ARMS := ["PASSIVE", "SENSIBLE", "LEAN", "GROW", "GROWLOAN"]   # S531 GROW: the owner's "careful gym grows" (Q-277)
const MARKS := [13, 26, 52, 104]   # weeks to sample
const DOC := "res://docs/GYMSURVIVE1_RESULT.md"

var results: Array = []
var run_arms: Array = ARMS   # S531: `-- arms=GROW` runs only those (writes docs/GYMSURVIVE1_<ARMS>_RESULT.md)
var doc_path: String = DOC
var ran_n: int = N   # careers per seed actually run (pilot = 2); the page reports this, never N


func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	var pilot := false
	var user_args := OS.get_cmdline_user_args()
	for a in user_args:
		if str(a) == "pilot":
			pilot = true
		elif str(a).begins_with("arms="):
			run_arms = Array(str(a).trim_prefix("arms=").split(","))
			doc_path = "res://docs/GYMSURVIVE1_%s_RESULT.md" % "_".join(run_arms)
	var n_careers: int = N
	if pilot:
		n_careers = 2
	ran_n = n_careers
	print("arms=%s pilot=%s careers=%d seeds=%s weeks=%d" % [str(run_arms), str(pilot), n_careers, str(SEEDS), WEEKS])
	if pilot:
		print("projected time: ~%d min (pilot)" % (2 * SEEDS.size() * run_arms.size()))
	else:
		print("projected time: ~%d min" % (n_careers * SEEDS.size() * run_arms.size() * 2))
	for arm in run_arms:
		for ss in SEEDS:
			for i in n_careers:
				var seed_n: int = ss + i * 137 + ARMS.find(arm) * 7919
				var r := _career(str(arm), seed_n, i, ss)
				results.append(r)
		print("GYMSURVIVE1 arm=%s done (%d careers)" % [arm, n_careers * SEEDS.size()])
	var elapsed := (Time.get_ticks_msec() - t0) / 1000.0
	print("GYMSURVIVE1 wall time: %.1f s" % elapsed)
	var L := _report(elapsed)
	for line in L:
		print(line)
	var fh := FileAccess.open(doc_path, FileAccess.WRITE)
	if fh != null:
		fh.store_string("\n".join(L) + "\n"); fh.close(); print("wrote %s" % doc_path)
	# Pass lines
	for arm in run_arms:
		var sub := results.filter(func(r): return str(r["arm"]) == arm)
		var closed_count: int = sub.filter(func(r): return bool(r["closed"])).size()
		var closed_share: float = float(closed_count) / float(sub.size())
		var close_weeks: Array = []
		for r in sub:
			if bool(r["closed"]):
				close_weeks.append(int(r["close_week"]))
		var med_str: String = "none"
		if not close_weeks.is_empty():
			med_str = str(int(_median(close_weeks)))
		print("GYMSURVIVE1 done arm=%s closed104=%.0f%% med_close_week=%s" % [arm, closed_share * 100.0, med_str])
	print("GYMSURVIVE1 done")
	quit(0)


func _career(arm: String, seed_n: int, idx: int, seed_set: int) -> Dictionary:
	var c := Career.quick_start()
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	# SENSIBLE and LEAN: one class night on Wednesday
	if arm == "SENSIBLE" or arm == "LEAN" or arm == "GROW" or arm == "GROWLOAN":
		ClubClasses.toggle(c.coach, 2)   # Wednesday
	var costs0: int = int(Sim.weekly_costs(c)["total"])
	var three_months: int = int(float(costs0) * GymBills.WEEKS_A_MONTH * 3.0)
	var eight_weeks: int = int(float(costs0) * 8.0)
	var walkin_signed := false
	var pro_signed := false
	var half_on := false
	var snap: Dictionary = {}
	for w in MARKS:
		snap[w] = {"cash": 0, "members": 0, "taken": false}
	var closed := false
	var close_week := -1
	var close_costs := {}
	var close_income := {}
	var final_day := 0
	var guard := 0
	while c.day < DAYS and not c.closed and guard < 10000:
		guard += 1
		var week: int = Clock.week_of(c.day)
		# SENSIBLE/LEAN: sign second walk-in when one arrives and cash > 3 months of costs
		if (arm == "SENSIBLE" or arm == "LEAN") and not walkin_signed and not c.applicant.is_empty():
			if c.cash > three_months and c.fighters.size() < 2:
				Sim.sign(c, PICKS.duplicate())
				walkin_signed = true
		# SENSIBLE/LEAN: accept first pro offer
		if (arm == "GROW" or arm == "GROWLOAN") and c.day % 7 == 0:
			_grow(c, eight_weeks, arm == "GROWLOAN")
		# GROWLOAN: the candidate design - the move's fit-out paid $750 a month for 12 months after a $3,000 deposit
		if arm == "GROWLOAN" and c.day % 28 == 0 and int(c.get_meta("loan_left", 0)) > 0:
			c.pay(-LOAN_MONTH, "Fit-out loan")
			c.set_meta("loan_left", int(c.get_meta("loan_left", 0)) - 1)
		if (arm == "SENSIBLE" or arm == "LEAN" or arm == "GROW" or arm == "GROWLOAN") and not pro_signed and not c.pro_offer.is_empty():
			Roster.turn_pro(c, "")
			pro_signed = true
		# LEAN: half stipend when cash < 8 weeks of costs
		if arm == "LEAN" and not half_on and c.cash < eight_weeks:
			for ff in c.fighters:
				if not bool(ff.get("pro", false)):
					GymSpend.set_half(c, ff)
					half_on = true
					break
		_answer_open(c)
		Sim.step_day(c)
		final_day = c.day
		# Sample at week boundaries
		if c.day % 7 == 0 and not c.closed:
			for w in MARKS:
				if week == w and not (snap[w] as Dictionary)["taken"]:
					(snap[w] as Dictionary)["cash"] = c.cash
					(snap[w] as Dictionary)["members"] = c.members
					(snap[w] as Dictionary)["taken"] = true
	# If closed, record closure info
	if c.closed:
		closed = true
		close_week = Clock.week_of(c.day)
		close_costs = Sim.weekly_costs(c)
		close_income = Sim.weekly_income(c)
	# Fill any missing snapshots with last known values
	for w in MARKS:
		if not (snap[w] as Dictionary)["taken"]:
			(snap[w] as Dictionary)["cash"] = c.cash
			(snap[w] as Dictionary)["members"] = c.members
	return {"arm": arm, "seed": seed_n, "idx": idx, "seed_set": seed_set, "rep_end": c.reputation,
		"cap_end": GymSpend.member_cap(c), "premises_end": c.premises, "fighters_end": c.fighters.size(),
		"closed": closed, "close_week": close_week, "final_day": final_day,
		"close_costs": close_costs, "close_income": close_income,
		"walkin_signed": walkin_signed, "pro_signed": pro_signed, "half_on": half_on,
		"snap": snap, "cash0": c.cash_history[0]["c"] if not c.cash_history.is_empty() else 0,
		"cash_end": c.cash, "members_end": c.members}


## S531 GROW (owner Q-277 "Careful gym should grow"): what a sensible owner does each Monday - sign a walk-in when 8 weeks of
## costs are banked (up to 3 boxers), fitness classes + assistant then the youth section when 8 weeks are banked, buy the cheapest piece of kit while the gym's name draws more members than the room
## holds, and move to the next premises once the name draws 5+ past this one's cap with the move + 8 weeks banked.
const LOAN_DEPOSIT := 3000
const LOAN_MONTH := 750
const LOAN_MONTHS := 12


func _grow(c: Career, eight_weeks: int, loan := false) -> void:
	# The upgrades a careful owner takes first: fitness classes (kit + the assistant who runs them - the one upgrade
	# GymUpgrades says pays for itself inside a year; the assistant also opens a place), then the youth section.
	if not GymUpgrades.has(c.upgrades, "fitkit") and c.cash > eight_weeks + 1500 + 4 * 280:
		GymSpend.buy(c, "fitkit")
		if not c.staff_roles.has("assistant"):
			GymSpend.hire(c, "assistant")
	elif not GymUpgrades.has(c.upgrades, "youth") and c.cash > eight_weeks + 1800:
		GymSpend.buy(c, "youth")
	if not c.applicant.is_empty() and c.cash > eight_weeks and c.fighters.size() < 3:
		Sim.sign(c, PICKS.duplicate())
	var natural: int = Membership.natural_members(c.reputation, c.dues_band)
	var prem: Dictionary = GymSpend.premises(c)
	if natural >= int(prem["cap"]) + 5 and c.premises + 1 < GymUpgrades.PREMISES.size():
		var price := int(GymUpgrades.premises(c.premises + 1)["move"])
		if loan and c.cash > eight_weeks + LOAN_DEPOSIT:
			c.cash += price - LOAN_DEPOSIT   # the probe lends the rest; the arm pays it back by the month
			GymSpend.move(c)
			c.set_meta("loan_left", LOAN_MONTHS)
			return
		if not loan and GymUpgrades.move_blocked(c.premises, c.cash - eight_weeks) == "":
			GymSpend.move(c)
			return
	if natural > GymSpend.member_cap(c):
		var best := ""
		var best_per := 0.0
		for sl in GymSlots.all():
			var id := str(sl["id"])
			if int(sl["price"]) <= 0 or int(sl["places"]) <= 0 or GymSlots.blocked(id, c.gym_slots, c.cash - eight_weeks) != "":
				continue
			var per := float(sl["places"]) / float(sl["price"])
			if per > best_per:
				best_per = per
				best = id
		if best != "":
			GymSpend.buy_slot(c, best)


## The bout loop from tools/turn_pro_probe3.gd _answer_open: accept sheet offers, camps, weigh-ins,
## fight by the sim, after_fight.
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
			Bouts.weigh(c, f)
		if Bouts.fight_day(c, f):
			Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
			Bouts.after_fight(c, f)
		if bool(f.get("goal_talk", false)):
			Bouts.set_goal(c, f, "five_round_engine")
	# Pro ladder bookings for pro fighters
	for f in c.fighters:
		if bool(f.get("pro", false)) and ProLadder.on_ladder(c, f) and (f["bout"] as Dictionary).is_empty():
			var rows := ProLadder.offer_rows(c, f)
			for kind in ["above", "tune", "payday"]:
				var pick := rows.filter(func(r): return str(r["kind"]) == kind)
				if not pick.is_empty():
					ProLadder.book(c, f, int(pick[0]["opp"]["id"]), false)
					break


func _median(vals: Array) -> float:
	if vals.is_empty():
		return 0.0
	var v: Array = vals.duplicate()
	v.sort()
	var mid := int(v.size() / 2)
	return float(v[mid]) if v.size() % 2 == 1 else (float(v[mid - 1]) + float(v[mid])) / 2.0


func _percentile(vals: Array, p: float) -> float:
	if vals.is_empty():
		return 0.0
	var v: Array = vals.duplicate()
	v.sort()
	var idx: float = p * float(v.size() - 1)
	var lo: int = int(floor(idx))
	var hi: int = int(ceil(idx))
	if lo == hi:
		return float(v[lo])
	return float(v[lo]) + (idx - float(lo)) * (float(v[hi]) - float(v[lo]))


func _report(elapsed: float) -> Array:
	var L: Array = []
	L.append("# GYMSURVIVE1 result - does a fresh gym survive two years?")
	L.append("")
	L.append("Probe run: %s. %d careers x %d seeds x %d arms = %d careers, %d weeks each. Wall time: %.1f s." % [
		Time.get_datetime_string_from_system(), ran_n, SEEDS.size(), run_arms.size(), ran_n * SEEDS.size() * run_arms.size(), WEEKS, elapsed])
	L.append("")
	L.append("## Population")
	L.append("")
	L.append("- Career.quick_start(): one walk-in boxer signed (Lucy), Reid sessional coach hired, the shipped cash and members.")
	L.append("- %d careers x %d seeds (%s) = %d careers per arm, 104 weeks each." % [ran_n, SEEDS.size(), str(SEEDS), ran_n * SEEDS.size()])
	L.append("- Arms:")
	L.append("  - **PASSIVE**: touch nothing (today's probes).")
	L.append("  - **SENSIBLE**: one class night (ClubClasses, Wed), sign a second walk-in when one arrives and cash > 3 months of costs, accept the first pro offer (Roster.turn_pro with the plain deal).")
	L.append("  - **LEAN**: SENSIBLE + half stipend / day job for the boxer when cash < 8 weeks of costs (GymSpend.set_half).")
	L.append("- Bout loop: tools/turn_pro_probe3.gd _answer_open (accept sheet offers, camps, weigh-ins, fight by the sim, after_fight).")
	L.append("")
	L.append("## Closure share by week")
	L.append("")
	L.append("| arm | closed@26 | closed@52 | closed@78 | closed@104 | med_close_week |")
	L.append("|---|---|---|---|---|---|")
	for arm in run_arms:
		var sub := results.filter(func(r): return str(r["arm"]) == arm)
		var total: int = sub.size()
		var c26: int = sub.filter(func(r): return bool(r["closed"]) and int(r["close_week"]) <= 26).size()
		var c52: int = sub.filter(func(r): return bool(r["closed"]) and int(r["close_week"]) <= 52).size()
		var c78: int = sub.filter(func(r): return bool(r["closed"]) and int(r["close_week"]) <= 78).size()
		var c104: int = sub.filter(func(r): return bool(r["closed"])).size()
		var close_weeks: Array = []
		for r in sub:
			if bool(r["closed"]):
				close_weeks.append(int(r["close_week"]))
		var med_str: String = "none"
		if not close_weeks.is_empty():
			med_str = str(int(_median(close_weeks)))
		L.append("| %s | %d/%d (%.0f%%) | %d/%d (%.0f%%) | %d/%d (%.0f%%) | %d/%d (%.0f%%) | %s |" % [
			arm, c26, total, 100.0 * float(c26) / total,
			c52, total, 100.0 * float(c52) / total,
			c78, total, 100.0 * float(c78) / total,
			c104, total, 100.0 * float(c104) / total,
			med_str])
	L.append("")
	L.append("## Cash at weeks 13/26/52/104 (median [p10..p90])")
	L.append("")
	L.append("| arm | cash@13 | cash@26 | cash@52 | cash@104 |")
	L.append("|---|---|---|---|---|")
	for arm in run_arms:
		var sub := results.filter(func(r): return str(r["arm"]) == arm)
		var row := "| %s |" % arm
		for w in MARKS:
			var vals: Array = []
			for r in sub:
				var s: Dictionary = (r["snap"] as Dictionary).get(w, {})
				if (s as Dictionary).get("taken", false) or int(r["final_day"]) >= w * 7:
					vals.append(int((s as Dictionary).get("cash", 0)))
			if vals.is_empty():
				row += " - |"
			else:
				var med: float = _median(vals)
				var p10: float = _percentile(vals, 0.1)
				var p90: float = _percentile(vals, 0.9)
				row += " $%d [$%d..$%d] |" % [int(med), int(p10), int(p90)]
		L.append(row)
	L.append("")
	L.append("## Members at weeks 13/26/52/104 (median [p10..p90])")
	L.append("")
	L.append("| arm | members@13 | members@26 | members@52 | members@104 |")
	L.append("|---|---|---|---|---|")
	for arm in run_arms:
		var sub := results.filter(func(r): return str(r["arm"]) == arm)
		var row := "| %s |" % arm
		for w in MARKS:
			var vals: Array = []
			for r in sub:
				var s: Dictionary = (r["snap"] as Dictionary).get(w, {})
				if (s as Dictionary).get("taken", false) or int(r["final_day"]) >= w * 7:
					vals.append(int((s as Dictionary).get("members", 0)))
			if vals.is_empty():
				row += " - |"
			else:
				var med: float = _median(vals)
				var p10: float = _percentile(vals, 0.1)
				var p90: float = _percentile(vals, 0.9)
				row += " %d [%d..%d] |" % [int(med), int(p10), int(p90)]
		L.append(row)
	L.append("")
	L.append("## Closure causes (every closed career)")
	L.append("")
	L.append("| arm | seed | close_week | final_day | top_costs | top_income |")
	L.append("|---|---|---|---|---|---|")
	for arm in run_arms:
		var sub := results.filter(func(r): return str(r["arm"]) == arm and bool(r["closed"]))
		for r in sub:
			var cc: Dictionary = r["close_costs"]
			var ci: Dictionary = r["close_income"]
			var cost_parts: Array = []
			for k in ["rent", "fees", "power", "loan", "bjj", "staff_roles", "kit", "upgrades", "juniors_coach"]:
				if cc.has(k) and int(cc[k]) > 0:
					cost_parts.append("%s=$%d" % [k, int(cc[k])])
			if cc.has("total"):
				cost_parts.append("total=$%d" % int(cc["total"]))
			var inc_parts: Array = []
			for k in ["dues", "classes", "sponsors", "bjj", "fitness", "juniors", "class_nights"]:
				if ci.has(k) and int(ci[k]) > 0:
					inc_parts.append("%s=$%d" % [k, int(ci[k])])
			if ci.has("total"):
				inc_parts.append("total=$%d" % int(ci["total"]))
			L.append("| %s | %d | %d | %d | %s | %s |" % [
				arm, int(r["seed"]), int(r["close_week"]), int(r["final_day"]),
				", ".join(cost_parts), ", ".join(inc_parts)])
	if results.filter(func(r): return bool(r["closed"])).is_empty():
		L.append("| (none closed) | | | | | |")
	L.append("")
	L.append("## Per-career log")
	L.append("")
	L.append("## S531 growth at week 104 (median [p10..p90]): reputation, member room, members, boxers")
	L.append("")
	L.append("| arm | rep_end | cap_end | members_end | boxers | moved |")
	L.append("|---|---|---|---|---|---|")
	for arm in run_arms:
		var rs: Array = results.filter(func(r): return str(r["arm"]) == arm)
		var cols: Array = []
		for k in ["rep_end", "cap_end", "members_end", "fighters_end"]:
			var v: Array = rs.map(func(r): return float(r[k]))
			cols.append("%d [%d..%d]" % [int(_median(v)), int(_percentile(v, 0.1)), int(_percentile(v, 0.9))])
		var moved: int = rs.filter(func(r): return int(r["premises_end"]) > 0).size()
		L.append("| %s | %s | %d/%d |" % [arm, " | ".join(cols), moved, rs.size()])
	L.append("")
	L.append("| arm | seed | closed | final_day | cash_end | members_end | walkin | pro | half |")
	L.append("|---|---|---|---|---|---|---|---|---|")
	for r in results:
		L.append("| %s | %d | %s | %d | $%d | %d | %s | %s | %s |" % [
			str(r["arm"]), int(r["seed"]),
			"YES w%d" % int(r["close_week"]) if bool(r["closed"]) else "no",
			int(r["final_day"]), int(r["cash_end"]), int(r["members_end"]),
			"yes" if bool(r["walkin_signed"]) else "-",
			"yes" if bool(r["pro_signed"]) else "-",
			"yes" if bool(r["half_on"]) else "-"])
	L.append("")
	L.append("Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/gym_survive_probe.gd`")
	L.append("")
	L.append("GYMSURVIVE1 done")
	return L
