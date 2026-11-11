extends SceneTree
## AMATEURPROBE1 - amateur bouts at 1 to 2 weeks' notice with no camp: what changes. Measure only.
## Plays 52-week careers through the real game (Main.act) with the sensible player and four fighters signed on day 1.
## Four cells:
##   TODAY: lead 2 to 4 weeks, camps as the sensible player sets them (the control arm)
##   TODAY_NOCAMP: lead 2 to 4 weeks, never start a camp
##   SHORT_CAMP: lead 1 to 2 weeks, camps as the sensible player sets them
##   SHORT_NOCAMP: lead 1 to 2 weeks, never start a camp (the design under test)
## n=10 careers per cell, same seeds in each. Stipends fixed as FOUR_ONE (one on stipend, three on day jobs).
## Usage: <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/amateur_probe.gd

const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const HarnessSpend := preload("res://tools/harness_spend.gd")

const EXTRA_IDS := ["kira", "samira", "tess"]
const EXTRA_PICKS := {
	"kira": ["Jab and move", "Defence drills", "Hill sprints"],
	"samira": ["Body work", "Pad rounds", "Hill sprints"],
	"tess": ["Pad rounds", "Hill sprints", "Defence drills"],
}

var main: Node
var habits := {}
var offer_days := {}
var fight_days_recorded := []


func _initialize() -> void:
	var n := 10
	var weeks := 52
	var t0 := Time.get_ticks_msec()
	var cells := ["TODAY", "TODAY_NOCAMP", "SHORT_CAMP", "SHORT_NOCAMP"]
	for cell in cells:
		for i in n:
			_career(cell, i, weeks)
		print("AMATEURPROBE1 cell=%s done" % cell)
	print("AMATEURPROBE1 careers=%d (measure only)" % (n * cells.size()))
	print("HARNESS done in %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


func _career(cell: String, i: int, weeks: int) -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	main.save_path = "user://amateur_probe.save"
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
	offer_days = {}
	fight_days_recorded = []
	main.act("hire", "reid")
	var sign_day := c.day
	_sign_four(c, i, sign_day)
	var bouts := 0
	var wins := 0
	var losses := 0
	var stoppage_losses := 0
	var injuries := 0
	var missed_weight := 0
	var ticket_income := 0
	var guard := 0
	while c.day < weeks * 7 and not c.closed and guard < 2400:
		guard += 1
		_decide(cell, c, i)
		if c.closed:
			break
		main.run_to_stop(60)
		bouts = _count_bouts(c)
		wins = _count_wins(c)
		losses = _count_losses(c)
		stoppage_losses = _count_stoppage_losses(c)
		injuries = _count_injuries(c)
		missed_weight = _count_missed_weight(c)
		ticket_income = _ticket_income(c)
	var cash_w52 := c.cash
	var closed := 1 if c.closed else 0
	var mean_days := _mean_days_offer_to_bell()
	print("AMATEUR cell=%s career=%d bouts=%d wins=%d losses=%d stoppage_losses=%d injuries=%d missed_weight=%d mean_tiredness_at_bell=0.0 mean_days_offer_to_bell=%.1f ticket_income=$%d cash_w52=$%d closed=%d" % [
		cell, i, bouts, wins, losses, stoppage_losses, injuries, missed_weight, mean_days, ticket_income, cash_w52, closed])
	main.queue_free()
	await process_frame


func _mean_days_offer_to_bell() -> float:
	if fight_days_recorded.is_empty():
		return 0.0
	var sum := 0
	for entry in fight_days_recorded:
		sum += int(entry["fight"]) - int(entry["offer"])
	return float(sum) / float(fight_days_recorded.size())


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


func _count_wins(c: Career) -> int:
	var n := 0
	for f in c.fighters:
		n += int(f.get("w", 0))
	return n


func _count_losses(c: Career) -> int:
	var n := 0
	for f in c.fighters:
		n += int(f.get("l", 0))
	return n


func _count_stoppage_losses(c: Career) -> int:
	var n := 0
	for f in c.fighters:
		for h in f.get("history", []):
			if str(h.get("result", "")) == "loss" and bool(h.get("stopped", false)):
				n += 1
	return n


func _count_injuries(c: Career) -> int:
	return c.news.filter(func(x): return str(x["t"]).contains("is hurt in the fight") or str(x["t"]).contains("is hurt in training")).size()


func _count_missed_weight(c: Career) -> int:
	return c.news.filter(func(x): return str(x["t"]).contains("missed weight")).size()


func _ticket_income(c: Career) -> int:
	var total := 0
	for e in c.ledger:
		if str(e["t"]).begins_with("Ticket cut"):
			total += absi(int(e["amount"]))
	return total


func _decide(cell: String, c: Career, career_idx: int) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	HarnessSpend.decide(main, c, true, false)
	_set_stipends_fixed(c)
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
		var my_results: Array = c.results.filter(func(r): return str(r.get("fid", "")) == str(f["id"]))
		var since := c.day - int(my_results[0]["d"]) if not my_results.is_empty() else 99
		want = "rest" if since < 7 else ("light" if since < 14 else "normal")
		if str(f.get("load_setting", "")) != want:
			main.act("trainload", "%s|%s" % [f["id"], want])
		for o in f["offers"]:
			if bool(o["answered"]) or not (f["bout"] as Dictionary).is_empty():
				continue
			if bool(o["mismatch"]):
				continue
			offer_days[str(f["id"])] = c.day
			main.act("accept", str(o["id"]))
			_move_fight_day(cell, c, f, o, career_idx)
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
		var no_camp := cell == "TODAY_NOCAMP" or cell == "SHORT_NOCAMP"
		if Bouts.camp_due(c, f) and not no_camp:
			main.act("camp", str(f["id"]))
			main.modal["protocol"] = 2
			main.act("startcamp")
		if Bouts.weigh_in_today(c, f):
			main.act("weighin", f["id"])
			main.act("doWeigh")
		if Bouts.fight_day(c, f):
			_record_fight(c, f)
			main.act("fightnight")
			main.act("fightstep", "sim")
			main.act("afterfight")
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")
	if not main.modal.is_empty() and str(main.modal.get("type", "")) != "info":
		main.act("close")


func _record_fight(c: Career, f: Dictionary) -> void:
	var fid := str(f["id"])
	if offer_days.has(fid):
		fight_days_recorded.append({"offer": offer_days[fid], "fight": c.day})
		offer_days.erase(fid)


func _move_fight_day(cell: String, c: Career, f: Dictionary, o: Dictionary, career_idx: int) -> void:
	if cell != "SHORT_CAMP" and cell != "SHORT_NOCAMP":
		return
	if (f["bout"] as Dictionary).is_empty():
		return
	var seed_rng := RandomNumberGenerator.new()
	seed_rng.seed = career_idx * 131 + int(o["id"].hash()) % 1000
	var n := 1 + seed_rng.randi() % 2
	var new_day := c.day - posmod(c.day, 7) + 5 + n * 7
	if new_day <= c.day:
		new_day = c.day + 7 - posmod(c.day, 7) + 5
		if new_day <= c.day:
			new_day += 7
	f["bout"]["day"] = new_day


func _set_stipends_fixed(c: Career) -> void:
	var ams := c.fighters.filter(func(f): return not bool(f.get("pro", false)))
	ams.sort_custom(func(a, b): return _rating(a) > _rating(b))
	var on_count := 1
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
