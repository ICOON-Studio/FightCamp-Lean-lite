extends SceneTree
## SIGPACE1 (issue #413): can a boxer reach a Signature (mastery 85+) in two seasons, with camps and bouts?
## Population: 30 careers x 2 seeds, 104 weeks each, amateur only (decline pro offers).
## Arms: pads coach 58 (today) vs 75 (better), each with/without camp focus on technique.
## Per arm at weeks 26/52/78/104: Technique, Ring IQ, mastery cap, best move mastery, share at 85+, weeks to first Signature.
## Pass line: SIGPACE1 done sig52=<share> sig104=<share> cap104=<median> per arm.

const Bouts := preload("res://scripts/state/Bouts.gd")
const Career := preload("res://scripts/state/Career.gd")
const Data := preload("res://scripts/state/Data.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PunchStart := preload("res://scripts/rules/PunchStart.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const SEEDS := [4421, 9001]
const WEEKS := 104
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const CHECK_WEEKS := [26, 52, 78, 104]
const SIG_THRESHOLD := 85.0

var N := 30
var results: Array = []


func _initialize() -> void:
	var args := OS.get_cmdline_args()
	var user_args := OS.get_cmdline_user_args()
	if not user_args.is_empty():
		for a in user_args:
			if str(a).is_valid_int():
				N = int(str(a))
				break
	elif args.size() >= 2 and args[0] == "--":
		if str(args[1]).is_valid_int():
			N = int(str(args[1]))
	var t0 := Time.get_ticks_msec()
	print("arms=4 (coach58/75 x focus/no) pilot=%d seeds=%s weeks=%d" % [N, str(SEEDS), WEEKS])
	print("pilot=%d" % N)
	for seed_val in SEEDS:
		for coach_pads in [58, 75]:
			for camp_focus in [false, true]:
				for i in N:
					var seed_n: int = seed_val + i * 137 + coach_pads * 31 + (1 if camp_focus else 0) * 17
					var r := _run_career(seed_n, coach_pads, camp_focus, i, seed_val)
					results.append(r)
	var elapsed := (Time.get_ticks_msec() - t0) / 1000.0
	print("SIGPACE1 wall time: %.1f s" % elapsed)
	var L := _report(elapsed)
	for line in L:
		print(line)
	print("SIGPACE1 done")
	quit(0)


func _run_career(seed_n: int, coach_pads: int, camp_focus_on: bool, idx: int, seed_set: int) -> Dictionary:
	var c := Career.quick_start()
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	# Set coach pads skill to the arm's value
	c.coach["areas"]["pads"] = coach_pads
	c.coach["rating"] = coach_pads  # Overall rating matches pads for this probe
	var rng := RandomNumberGenerator.new(); rng.seed = seed_n
	var amb_roll: float = rng.randf()
	if amb_roll < 0.33:
		f["ambition"] = "Turn pro as soon as the call comes"
	elif amb_roll < 0.66:
		f["ambition"] = "A regional title within a year"
	else:
		f["ambition"] = "A winning record by the summer"
	var snapshots: Array = []  # Week snapshots for reporting
	var first_sig_week: int = -1
	var guard := 0
	while c.day < WEEKS * 7 and not c.closed and guard < 8000:
		guard += 1
		# Decline pro offers (amateur only)
		if not c.pro_offer.is_empty():
			Roster.decline_pro(c)
		# Handle bout offers
		_answer_open(c, f)
		# Start camp if due, with focus on technique if arm says so
		if Bouts.camp_due(c, f):
			var focus := "technique" if camp_focus_on else Sim.focus_of(c, f)
			Bouts.start_camp(c, f, focus, 2, OppFile.has_tape((f["bout"] as Dictionary).get("opp", {})), false)
		if Bouts.weigh_in_today(c, f):
			Bouts.weigh(c, f)
		if Bouts.fight_day(c, f):
			Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
			Bouts.after_fight(c, f)
		if bool(f.get("goal_talk", false)):
			Bouts.set_goal(c, f, "five_round_engine")
		# Snapshot at check weeks (end of week = day 6 of the week, i.e., Sunday)
		var week := Clock.week_of(c.day)
		var dow := c.day % 7  # 0=Monday, 6=Sunday
		if week in CHECK_WEEKS and dow == 6:
			var snap := _snapshot(f, week)
			snapshots.append(snap)
			if first_sig_week < 0 and float(snap["best_mastery"]) >= SIG_THRESHOLD:
				first_sig_week = week
		Sim.step_day(c)
	# Final snapshot if we missed the last week
	var final_week := Clock.week_of(c.day)
	if final_week >= WEEKS and (snapshots.is_empty() or int(snapshots[-1]["week"]) < WEEKS):
		snapshots.append(_snapshot(f, WEEKS))
		if first_sig_week < 0 and float(snapshots[-1]["best_mastery"]) >= SIG_THRESHOLD:
			first_sig_week = WEEKS
	# Fill in any missing check weeks with the closest snapshot
	var captured_weeks: Array = snapshots.map(func(s): return int(s["week"]))
	for w in CHECK_WEEKS:
		if not captured_weeks.has(w):
			# Find the closest snapshot before this week
			var best_snap: Dictionary = {}
			for s in snapshots:
				if int(s["week"]) <= w:
					if best_snap.is_empty() or int(s["week"]) > int(best_snap["week"]):
						best_snap = s
			if not best_snap.is_empty():
				var fill := best_snap.duplicate()
				fill["week"] = w
				snapshots.append(fill)
	return {"seed": seed_n, "coach_pads": coach_pads, "camp_focus": camp_focus_on, "idx": idx, "seed_set": seed_set,
		"snapshots": snapshots, "first_sig_week": first_sig_week, "closed": c.closed, "final_day": c.day}


func _snapshot(f: Dictionary, week: int) -> Dictionary:
	var tech: float = float(f["stats"]["technique"])
	var fight_iq: float = float(f["stats"]["fight_iq"])
	var cap_val: float = MoveMastery.cap(tech, fight_iq)
	var best_mastery: float = 0.0
	var best_move: String = ""
	for m in Data.MOVES:
		var mv: float = float(f["moves"].get(m, 0.0))
		if mv > best_mastery:
			best_mastery = mv; best_move = m
	return {"week": week, "technique": tech, "fight_iq": fight_iq, "cap": cap_val,
		"best_mastery": best_mastery, "best_move": best_move, "has_sig": best_mastery >= SIG_THRESHOLD}


func _answer_open(c: Career, f: Dictionary) -> void:
	# Handle bout offers (accept/decline)
	for o2 in (f["offers"] as Array).duplicate():
		if bool(o2["answered"]) or bool(o2["mismatch"]):
			continue
		if not (f["bout"] as Dictionary).is_empty():
			Bouts.decline(c, str(o2["id"]))
		else:
			Bouts.accept(c, str(o2["id"]))
	# Decline remaining unanswered
	for o2 in (f["offers"] as Array).duplicate():
		if not bool(o2["answered"]):
			Bouts.decline(c, str(o2["id"]))
	# Weigh-in and fight (camp is started in _run_career with the arm's focus)
	if Bouts.weigh_in_today(c, f):
		Bouts.weigh(c, f)
	if Bouts.fight_day(c, f):
		Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
		Bouts.after_fight(c, f)
	if bool(f.get("goal_talk", false)):
		Bouts.set_goal(c, f, "five_round_engine")


func _report(elapsed: float) -> Array:
	var L: Array = []
	L.append("# SIGPACE1 RESULT - Signature pace over two seasons")
	L.append("")
	L.append("Probe run: %s. %d careers x %d seeds x 4 arms = %d careers, %d weeks each. Wall time: %.1f s." % [
		Time.get_datetime_string_from_system(), N, SEEDS.size(), N * SEEDS.size() * 4, WEEKS, elapsed])
	L.append("")
	L.append("## Method")
	L.append("")
	L.append("- Population: %d quick_start careers per arm, 2 seed sets. Amateur only (decline all pro offers)." % N)
	L.append("- Arms: pads coach skill 58 (today's Reid overall rating) vs 75 (a better coach), each with/without camp focus on technique.")
	L.append("- Camp focus: when true, camps set focus='technique' (the stat that most affects mastery cap). When false, uses plan's default focus.")
	L.append("- Bout handling: accept sheet offers, start camps, weigh in, fight by sim (like turn_pro_probe3).")
	L.append("- Check weeks: 26, 52, 78, 104 (end of each).")
	L.append("")
	L.append("## Per-arm tables")
	L.append("")
	for coach_pads in [58, 75]:
		for camp_focus in [false, true]:
			var arm_label := "coach%d %s" % [coach_pads, "focus" if camp_focus else "no-focus"]
			var sub := results.filter(func(r): return int(r["coach_pads"]) == coach_pads and bool(r["camp_focus"]) == camp_focus)
			L.append("### Arm: %s" % arm_label)
			L.append("")
			L.append("| week | tech_med | tech_p10 | tech_p90 | iq_med | iq_p10 | iq_p90 | cap_med | cap_p10 | cap_p90 | best_med | best_p10 | best_p90 | sig_share | sig_n |")
			L.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
			for w in CHECK_WEEKS:
				var snaps: Array = []
				for r in sub:
					for s in (r["snapshots"] as Array):
						if int(s["week"]) == w:
							snaps.append(s); break
				if snaps.is_empty():
					continue
				var techs: Array = snaps.map(func(s): return float(s["technique"]))
				var iqs: Array = snaps.map(func(s): return float(s["fight_iq"]))
				var caps: Array = snaps.map(func(s): return float(s["cap"]))
				var bests: Array = snaps.map(func(s): return float(s["best_mastery"]))
				var sig_count: int = snaps.filter(func(s): return bool(s["has_sig"])).size()
				var sig_share: float = 100.0 * float(sig_count) / float(snaps.size())
				L.append("| %d | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.0f%% | %d |" % [
					w, _med(techs), _p10(techs), _p90(techs), _med(iqs), _p10(iqs), _p90(iqs),
					_med(caps), _p10(caps), _p90(caps), _med(bests), _p10(bests), _p90(bests), sig_share, sig_count])
			# Weeks to first Signature
			var sig_weeks: Array = []
			for r in sub:
				var w: int = int(r["first_sig_week"])
				if w >= 0:
					sig_weeks.append(w)
			var sig_pct: float = 100.0 * float(sig_weeks.size()) / float(sub.size())
			var med_weeks: String = "%.0f" % _med(sig_weeks) if not sig_weeks.is_empty() else "none"
			L.append("")
			L.append("- Careers reaching Signature: %d/%d (%.0f%%), median week: %s" % [sig_weeks.size(), sub.size(), sig_pct, med_weeks])
			L.append("")
	# Pass lines
	L.append("## Pass lines")
	L.append("")
	for coach_pads in [58, 75]:
		for camp_focus in [false, true]:
			var arm_label := "coach%d_%s" % [coach_pads, "focus" if camp_focus else "nofocus"]
			var sub := results.filter(func(r): return int(r["coach_pads"]) == coach_pads and bool(r["camp_focus"]) == camp_focus)
			var sig52 := _sig_share_at(sub, 52)
			var sig104 := _sig_share_at(sub, 104)
			var cap104 := _cap_med_at(sub, 104)
			L.append("SIGPACE1 done sig52=%.0f%% sig104=%.0f%% cap104=%.1f arm=%s" % [sig52, sig104, cap104, arm_label])
	L.append("")
	L.append("Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/sig_pace_probe.gd`")
	L.append("")
	return L


func _sig_share_at(sub: Array, week: int) -> float:
	var snaps: Array = []
	for r in sub:
		for s in (r["snapshots"] as Array):
			if int(s["week"]) == week:
				snaps.append(s); break
	if snaps.is_empty():
		return 0.0
	var sig_count: int = snaps.filter(func(s): return bool(s["has_sig"])).size()
	return 100.0 * float(sig_count) / float(snaps.size())


func _cap_med_at(sub: Array, week: int) -> float:
	var caps: Array = []
	for r in sub:
		for s in (r["snapshots"] as Array):
			if int(s["week"]) == week:
				caps.append(float(s["cap"])); break
	return _med(caps)


func _med(vals: Array) -> float:
	if vals.is_empty():
		return 0.0
	var v: Array = vals.duplicate()
	for i in v.size():
		v[i] = float(v[i])
	v.sort()
	var mid := int(v.size() / 2)
	return float(v[mid]) if v.size() % 2 == 1 else (float(v[mid - 1]) + float(v[mid])) / 2.0


func _p10(vals: Array) -> float:
	return _percentile(vals, 10)


func _p90(vals: Array) -> float:
	return _percentile(vals, 90)


func _percentile(vals: Array, pct: int) -> float:
	if vals.is_empty():
		return 0.0
	var v: Array = vals.duplicate()
	for i in v.size():
		v[i] = float(v[i])
	v.sort()
	var idx: float = float(pct) / 100.0 * float(v.size() - 1)
	var lo: int = int(floor(idx))
	var hi: int = int(ceil(idx))
	if lo == hi:
		return float(v[lo])
	var frac: float = idx - float(lo)
	return float(v[lo]) * (1.0 - frac) + float(v[hi]) * frac
