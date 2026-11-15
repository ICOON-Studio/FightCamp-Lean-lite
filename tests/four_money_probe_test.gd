extends SceneTree
## FOURMONEY1 probe: what four starters' stipends do to the weekly bill, runway and break-even.
## Pure read over GymBills + ClubStart; no game file changes.

const GymBillsRef = preload("res://scripts/rules/GymBills.gd")
const ClubStartRef = preload("res://scripts/rules/ClubStart.gd")

const COACH_WEEK := 450
const STIPEND := 250

func _init() -> void:
	var fails := 0
	var ids: Array = ClubStartRef.ids()
	var rows: Array = []
	for id in ids:
		for n in [1, 4]:
			var g := {
				"members": ClubStartRef.members(id),
				"coaches": 1,
				"boxers": n,
				"rent_mult": ClubStartRef.rent_mult(id),
				"month": 1,
			}
			var w: Dictionary = GymBillsRef.week(g)
			var rent: int = int(w["rent"])
			var fees: int = int(w["fees"])
			var power: int = int(w["power"])
			var insurance: int = int(w["insurance"])
			var kit: int = int(GymBillsRef.KIT_BUDGET["standard"]["week"])
			var week_costs: int = rent + fees + power + insurance + kit + COACH_WEEK + STIPEND * n
			var income: int = int(w["income"])
			var net: int = income - week_costs
			var months: int = ClubStartRef.months(id)
			var raw: float = float(week_costs) * GymBillsRef.WEEKS_A_MONTH * float(months)
			var start_cash: int = roundi(raw / 100.0) * 100
			var rw: int = GymBillsRef.runway_weeks(start_cash, net)
			var per_member: float = float(GymBillsRef.FEE_MONTH) / GymBillsRef.WEEKS_A_MONTH
			var be: int = int(ceil(float(week_costs) / per_member))
			var line := "FOURMONEY %s n=%d week_costs=%d income=%d net=%d start_cash=%d runway_weeks=%d break_even_members=%d" % [
				id, n, week_costs, income, net, start_cash, rw, be]
			print(line)
			rows.append({"id": id, "n": n, "week_costs": week_costs, "net": net, "rw": rw, "be": be,
				"start_cash": start_cash, "income": income})

	# fresh n=4 on today's start cash (n=1's start_cash)
	var fresh1: Dictionary = {}
	var fresh4: Dictionary = {}
	for r in rows:
		if r["id"] == "fresh" and r["n"] == 1:
			fresh1 = r
		if r["id"] == "fresh" and r["n"] == 4:
			fresh4 = r
	var today_cash: int = int(fresh1["start_cash"])
	var fresh4_net: int = int(fresh4["net"])
	var fresh4_rw_today: int = GymBillsRef.runway_weeks(today_cash, fresh4_net)
	print("FOURMONEY fresh n=4 on_today_cash runway_weeks=%d" % fresh4_rw_today)

	# Checks: per start, n=4 costs exceed n=1 by 750 +/- 60; runway >= 0; be(n=4) > be(n=1)
	for id in ids:
		var r1: Dictionary = {}
		var r4: Dictionary = {}
		for r in rows:
			if r["id"] == id and r["n"] == 1:
				r1 = r
			if r["id"] == id and r["n"] == 4:
				r4 = r
		var diff: int = int(r4["week_costs"]) - int(r1["week_costs"])
		if diff < 690 or diff > 810:
			print("FOURMONEY FAIL %s cost_diff=%d (expected 750 +/- 60)" % [id, diff])
			fails += 1
		if int(r4["rw"]) < 0:
			print("FOURMONEY FAIL %s n=4 runway_weeks=%d < 0" % [id, r4["rw"]])
			fails += 1
		if int(r1["rw"]) < 0:
			print("FOURMONEY FAIL %s n=1 runway_weeks=%d < 0" % [id, r1["rw"]])
			fails += 1
		if int(r4["be"]) <= int(r1["be"]):
			print("FOURMONEY FAIL %s break_even n=4 (%d) not > n=1 (%d)" % [id, r4["be"], r1["be"]])
			fails += 1

	if fails == 0:
		print("FOURMONEY PASS fails=0")
	else:
		print("FOURMONEY FAIL fails=%d" % fails)
	quit()
