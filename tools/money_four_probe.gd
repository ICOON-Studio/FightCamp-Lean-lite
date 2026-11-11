extends SceneTree
## MONEYFOUR1 - what four fighters cost the club in a year. Measure only.
## Plays 52-week careers with the sensible player (career_harness.gd _decide) for 5 cells:
##   ONE: one fighter (control), FOUR_ALL: four on stipend, FOUR_TWO: two on stipend/two day job,
##   FOUR_ONE: one on stipend/three day job, FOUR_NONE: four on day job.
## n=10 careers per cell, same seeds in each. Prints one line per career and cell.
## Usage: <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/money_four_probe.gd

const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const HarnessMoney := preload("res://tools/harness_money.gd")
const HarnessSpend := preload("res://tools/harness_spend.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")

const HABITS := ["head_coach", "unsafe_bouts", "hard_camps", "no_sponsors", "hard_weeks", "spender"]
## Three prospects in three different weight classes (Feather, Welter, Middle).
const EXTRA_IDS := ["kira", "samira", "tess"]
const EXTRA_PICKS := {
	"kira": ["Jab and move", "Defence drills", "Hill sprints"],
	"samira": ["Body work", "Pad rounds", "Hill sprints"],
	"tess": ["Pad rounds", "Hill sprints", "Defence drills"],
}

var main: Node
var habits := {}


func _initialize() -> void:
	var n := 10
	var weeks := 52
	var t0 := Time.get_ticks_msec()
	var cells := ["ONE", "FOUR_ALL", "FOUR_TWO", "FOUR_ONE", "FOUR_NONE"]
	for cell in cells:
		for i in n:
			_career(cell, i, weeks)
		print("MONEYFOUR1 cell=%s done" % cell)
	print("MONEYFOUR1 careers=%d (measure only)" % (n * cells.size()))
	print("HARNESS done in %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


func _career(cell: String, i: int, weeks: int) -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	main.save_path = "user://moneyfour_probe.save"
	main.no_render = true
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	var rng := RandomNumberGenerator.new()
	rng.seed = i * 7919 + 1
	c.reputation = 10 + rng.randi_range(-3, 3)
	c.seed = i * 7919 + 1
	for k in Data.STATS:
		c.applicant["stats"][k] = float(c.applicant["stats"][k]) + rng.randf_range(-4.0, 4.0)
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	habits = {}
	var hr := RandomNumberGenerator.new()
	hr.seed = i * 104729 + 17
	for h in HABITS:
		habits[h] = false
	main.act("hire", "reid")
	var sign_day := c.day
	if cell != "ONE":
		_sign_four(c, i, sign_day)
	var cash_w13 := 0
	var cash_w26 := 0
	var cash_w39 := 0
	var cash_w52 := 0
	var bouts := 0
	var ticket_income := 0
	var stipends_paid := 0
	var weeks_below_zero := 0
	var guard := 0
	var last_week := 0
	while c.day < weeks * 7 and not c.closed and guard < 2400:
		guard += 1
		_decide(cell, c)
		if c.closed:
			break
		main.run_to_stop(60)
		var week := Clock.week_of(c.day)
		if week > last_week:
			stipends_paid += _fighter_payroll(c)
			last_week = week
		if week == 13 and cash_w13 == 0:
			cash_w13 = c.cash
		if week == 26 and cash_w26 == 0:
			cash_w26 = c.cash
		if week == 39 and cash_w39 == 0:
			cash_w39 = c.cash
		if c.cash < 0:
			weeks_below_zero += 1
		bouts = _count_bouts(c)
		ticket_income = _ticket_income(c)
	cash_w52 = c.cash
	var closed := 1 if c.closed else 0
	var close_week: String = str(Clock.week_of(c.day)) if c.closed else "-"
	print("MONEYFOUR cell=%s career=%d closed=%d close_week=%s cash_w13=$%d cash_w26=$%d cash_w39=$%d cash_w52=$%d bouts=%d ticket_income=$%d stipends_paid=$%d weeks_below_zero=%d" % [
		cell, i, closed, str(close_week), cash_w13, cash_w26, cash_w39, cash_w52, bouts, ticket_income, stipends_paid, weeks_below_zero])
	main.queue_free()
	await process_frame


func _sign_four(c: Career, i: int, sign_day: int) -> void:
	for idx in EXTRA_IDS.size():
		var pid: String = EXTRA_IDS[idx]
		var raw: Dictionary = _prospect_raw(c, pid)
		if raw.is_empty():
			continue
		var picks: Array = (EXTRA_PICKS[pid] as Array)
		Roster.sign_fighter(c, raw, picks)


func _prospect_raw(c: Career, pid: String) -> Dictionary:
	for p in c.prospects:
		if str(p["id"]) == pid:
			var raw: Dictionary = p.duplicate(true)
			for k in ["state", "trial_day", "note"]:
				raw.erase(k)
			p["state"] = "signed"
			return raw
	return {}


func _count_bouts(c: Career) -> int:
	var n := 0
	for f in c.fighters:
		n += int(f.get("w", 0)) + int(f.get("l", 0)) + int(f.get("d", 0))
	return n


func _ticket_income(c: Career) -> int:
	var total := 0
	for e in c.ledger:
		if str(e["t"]).begins_with("Ticket cut"):
			total += absi(int(e["amount"]))
	return total


func _fighter_payroll(c: Career) -> int:
	var total := 0
	for f in c.fighters:
		total += int(f.get("weekly_salary", 0))
	return total


func _decide(cell: String, c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	HarnessSpend.decide(main, c, true, false)
	if cell == "FOUR_ALL" or cell == "FOUR_TWO" or cell == "FOUR_ONE" or cell == "FOUR_NONE":
		_set_stipends_fixed(cell, c)
	else:
		HarnessSpend._stipends(main, c)
	for d in c.deals:
		if str(d["state"]) == "offer":
			main.act("deal", str(d["id"]))
	if not c.pro_offer.is_empty():
		main.act("prooffer", str(c.pro_offer["fid"]))
		main.act("declinepro")
	for f in c.fighters:
		if Injuries.pending(f):
			main.act("pullout", str(f["id"]))
		var want := "normal"
		var mine: Array = c.results.filter(func(r): return str(r.get("fid", "")) == str(f["id"]))
		var since := c.day - int(mine[0]["d"]) if not mine.is_empty() else 99
		want = "rest" if since < 7 else ("light" if since < 14 else "normal")
		if str(f.get("load_setting", "")) != want:
			main.act("trainload", "%s|%s" % [f["id"], want])
		for o in f["offers"]:
			if bool(o["answered"]) or not (f["bout"] as Dictionary).is_empty():
				continue
			if bool(o["mismatch"]):
				continue
			main.act("accept", str(o["id"]))
		for o in f["offers"]:
			if not bool(o["answered"]):
				main.act("declineOffer", str(o["id"]))
		if ProLadder.on_ladder(c, f) and (f["bout"] as Dictionary).is_empty():
			var rows := ProLadder.offer_rows(c, f)
			var order := ["above", "tune", "payday"]
			for kind in order:
				var pick := rows.filter(func(r): return str(r["kind"]) == kind)
				if not pick.is_empty():
					main.act("probook", "%s:%d:o" % [f["id"], int(pick[0]["opp"]["id"])])
					break
		if Bouts.camp_due(c, f):
			main.act("camp", str(f["id"]))
			main.modal["protocol"] = 2
			main.act("startcamp")
		if Bouts.weigh_in_today(c, f):
			main.act("weighin", f["id"])
			main.act("doWeigh")
		if Bouts.fight_day(c, f):
			main.act("fightnight")
			main.act("fightstep", "sim")
			main.act("afterfight")
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")
	if not main.modal.is_empty() and str(main.modal.get("type", "")) != "info":
		main.act("close")


func _set_stipends_fixed(cell: String, c: Career) -> void:
	var ams := c.fighters.filter(func(f): return not bool(f.get("pro", false)))
	ams.sort_custom(func(a, b): return _rating(a) > _rating(b))
	var on_count := 0
	match cell:
		"FOUR_ALL": on_count = ams.size()
		"FOUR_TWO": on_count = 2
		"FOUR_ONE": on_count = 1
		"FOUR_NONE": on_count = 0
	for idx in ams.size():
		var f: Dictionary = ams[idx]
		var want := idx < on_count
		if want == bool(f.get("day_job", false)):
			main.act("stipend", "%s|%s" % [f["id"], "on" if want else "off"])


static func _rating(f: Dictionary) -> float:
	var t := 0.0
	for k in f["stats"]:
		t += float(f["stats"][k])
	return t
