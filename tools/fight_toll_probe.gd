extends SceneTree
## FIGHTTOLL1 - what the fight toll rule (S430) does to a sensible player's year.
## Plays 52-week careers with 4 fighters on stipend, 10 careers per cell, same seeds.
## Cell TODAY: the rule as it is (fights leave tiredness).
## Cell OFF: set f["week_fatigue"] back to pre-fight value after each fight (inside the probe only).
## Reports medians: real bouts a year, win share, training injuries, days over 80 tiredness, mean tiredness on fight day.
## Usage: <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/fight_toll_probe.gd

const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const HarnessSpend := preload("res://tools/harness_spend.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const EXTRA_IDS := ["kira", "samira", "tess"]
const EXTRA_PICKS := {
	"kira": ["Jab and move", "Defence drills", "Hill sprints"],
	"samira": ["Body work", "Pad rounds", "Hill sprints"],
	"tess": ["Pad rounds", "Hill sprints", "Defence drills"],
}

var main: Node


func _initialize() -> void:
	var n := 10
	var weeks := 52
	var t0 := Time.get_ticks_msec()
	var cells := ["TODAY", "OFF"]
	for cell in cells:
		var bouts_arr := []
		var wins_arr := []
		var injuries_arr := []
		var days_over_80_arr := []
		var fatigue_fight_day_arr := []
		for i in n:
			var result := await _career(cell, i, weeks)
			bouts_arr.append(result["bouts"])
			wins_arr.append(result["win_share"])
			injuries_arr.append(result["injuries"])
			days_over_80_arr.append(result["days_over_80"])
			fatigue_fight_day_arr.append(result["fatigue_fight_day"])
		print("FIGHTTOLL cell=%s careers=%d median_bouts=%.1f median_win_share=%.3f median_injuries=%.1f median_days_over_80=%.1f median_fatigue_fight_day=%.1f" % [
			cell, n, _median(bouts_arr), _median(wins_arr), _median(injuries_arr), _median(days_over_80_arr), _median(fatigue_fight_day_arr)])
	print("FIGHT_TOLL careers=%d (measure only)" % (n * cells.size()))
	print("HARNESS done in %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


func _median(arr: Array) -> float:
	if arr.is_empty():
		return 0.0
	var sorted_arr := arr.duplicate()
	sorted_arr.sort()
	var mid := sorted_arr.size() / 2
	if sorted_arr.size() % 2 == 0:
		return (sorted_arr[mid - 1] + sorted_arr[mid]) / 2.0
	return sorted_arr[mid]


func _career(cell: String, i: int, weeks: int) -> Dictionary:
	main = load("res://scenes/Main.tscn").instantiate()
	main.save_path = "user://fighttoll_probe.save"
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
	var habits := {}
	var hr := RandomNumberGenerator.new()
	hr.seed = i * 104729 + 17
	for h in ["head_coach", "unsafe_bouts", "hard_camps", "no_sponsors", "hard_weeks", "spender"]:
		habits[h] = false
	main.act("hire", "reid")
	var sign_day := c.day
	_sign_four(c, i, sign_day)
	var guard := 0
	var injuries := 0
	var days_over_80 := 0
	var fatigue_fight_day := []
	var bouts_before := _count_bouts(c)
	while c.day < weeks * 7 and not c.closed and guard < 2400:
		guard += 1
		var fatigue_before := {}
		for f in c.fighters:
			fatigue_before[str(f["id"])] = float(f.get("week_fatigue", 0.0))
		_decide(cell, c)
		if c.closed:
			break
		main.run_to_stop(60)
		for f in c.fighters:
			var fid := str(f["id"])
			if float(f.get("week_fatigue", 0.0)) >= 80.0:
				days_over_80 += 1
			if Bouts.fight_day(c, f) and fatigue_before.has(fid):
				fatigue_fight_day.append(fatigue_before[fid])
		if cell == "OFF":
			for f in c.fighters:
				var fid := str(f["id"])
				if fatigue_before.has(fid):
					f["week_fatigue"] = fatigue_before[fid]
	var bouts_after := _count_bouts(c)
	var real_bouts := bouts_after - bouts_before
	var win_share := _win_share(c)
	injuries = _count_injuries(c)
	main.queue_free()
	await process_frame
	return {"bouts": real_bouts, "win_share": win_share, "injuries": injuries, "days_over_80": days_over_80, "fatigue_fight_day": fatigue_fight_day}


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


func _count_injuries(c: Career) -> int:
	var n := 0
	for e in c.ledger:
		if str(e["t"]).begins_with("Injury"):
			n += 1
	return n


func _win_share(c: Career) -> float:
	var wins := 0
	var total := 0
	for f in c.fighters:
		wins += int(f.get("w", 0))
		total += int(f.get("w", 0)) + int(f.get("l", 0))
	if total == 0:
		return 0.0
	return float(wins) / float(total)


func _decide(cell: String, c: Career) -> void:
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


func _set_stipends_fixed(c: Career) -> void:
	var ams := c.fighters.filter(func(f): return not bool(f.get("pro", false)))
	ams.sort_custom(func(a, b): return _rating(a) > _rating(b))
	var on_count := ams.size()
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
