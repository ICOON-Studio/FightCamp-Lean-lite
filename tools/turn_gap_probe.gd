extends SceneTree
## TURNGAP1 (issue #415): the debut's opponent gap -> win chance curve, on one fixed boxer.
## Population: 20 boxers at the moment of their first pro offer, taken from Career.quick_start()
## careers played forward with turn_pro_probe3's loop. For EACH boxer, deep-copy the career once
## per gap and sign the plain deal through Roster.turn_pro after setting the gap WHERE THE DEAL
## READS IT (the offer's opp_gap, which ProOfferWire.signed duplicates into the deal).
## Gaps: -4, -2, -1, 0, 1, 2, 4, 8. Play to the debut's result row. 10 seeds a boxer a gap.

const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const GAPS := [-4.0, -2.0, -1.0, 0.0, 1.0, 2.0, 4.0, 8.0]
const SEEDS_PER := 10
const N_BOXERS := 20
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const MAX_DAYS := 120
const DOC := "res://docs/TURNGAP1_RESULT.md"

## {boxer_idx: {gap: [wins, total]}}
var wins_by_boxer_gap := {}
## {gap: [wins, total]}
var wins_by_gap := {}
## {boxer_idx: {gap: win_share}}
var boxer_win_shares := {}
## One boxer's override proof per gap
var override_proof := []


func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	print("TURNGAP1 %d boxers x %d gaps x %d seeds" % [N_BOXERS, GAPS.size(), SEEDS_PER])
	# Build 20 boxers at pro_ready
	var pro_ready_snapshots: Array = []
	for boxer_idx in N_BOXERS:
		var seed_n: int = 7000 + boxer_idx * 137
		var snap := _build_pro_ready(seed_n, boxer_idx)
		if snap.is_empty():
			print("WARN: boxer %d did not reach pro_ready" % boxer_idx)
			continue
		pro_ready_snapshots.append({"idx": boxer_idx, "snap": snap})
	print("Built %d pro-ready boxers" % pro_ready_snapshots.size())
	# Override proof: one boxer per gap, print debutant rating and gap used
	if not pro_ready_snapshots.is_empty():
		var proof_snap: Dictionary = pro_ready_snapshots[0]["snap"]
		for gap in GAPS:
			var proof := _override_check(proof_snap, gap)
			override_proof.append(proof)
	# For each boxer, for each gap, run SEEDS_PER seeds
	for entry in pro_ready_snapshots:
		var boxer_idx: int = entry["idx"]
		var snap: Dictionary = entry["snap"]
		wins_by_boxer_gap[boxer_idx] = {}
		boxer_win_shares[boxer_idx] = {}
		for gap in GAPS:
			wins_by_boxer_gap[boxer_idx][gap] = [0, 0]
			var total_wins: int = 0
			var total_runs: int = 0
			for seed_j in SEEDS_PER:
				var full_seed: int = 10000 + boxer_idx * 1000 + seed_j * 7 + int(gap * 100)
				var won: bool = _run_one(snap, gap, full_seed)
				total_runs += 1
				if won:
					total_wins += 1
			wins_by_boxer_gap[boxer_idx][gap] = [total_wins, total_runs]
			boxer_win_shares[boxer_idx][gap] = float(total_wins) / float(maxi(1, total_runs))
	# Aggregate by gap
	for gap in GAPS:
		wins_by_gap[gap] = [0, 0]
	for boxer_idx in wins_by_boxer_gap:
		for gap in GAPS:
			var wt: Array = wins_by_boxer_gap[boxer_idx][gap]
			wins_by_gap[gap][0] += int(wt[0])
			wins_by_gap[gap][1] += int(wt[1])
	var elapsed := (Time.get_ticks_msec() - t0) / 1000.0
	print("TURNGAP1 wall time: %.1f s" % elapsed)
	# Print results
	var L: Array = _report(elapsed)
	for line in L:
		print(line)
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh != null:
		fh.store_string("\n".join(L) + "\n"); fh.close(); print("wrote %s" % DOC)
	# Pass line
	var gap6580 := _find_gap_for_range(65.0, 80.0)
	var gap7085 := _find_gap_for_range(70.0, 85.0)
	var override_ok := _check_override()
	print("TURNGAP1 done gap6580=%s gap7085=%s override_ok=%s" % [gap6580, gap7085, override_ok])
	quit(0)


func _build_pro_ready(seed_n: int, boxer_idx: int) -> Dictionary:
	var c := Career.quick_start()
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	var rng := RandomNumberGenerator.new(); rng.seed = seed_n
	var amb_roll: float = rng.randf()
	if amb_roll < 0.33:
		f["ambition"] = "Turn pro as soon as the call comes"
	elif amb_roll < 0.66:
		f["ambition"] = "A regional title within a year"
	else:
		f["ambition"] = "A winning record by the summer"
	var guard := 0
	while c.day < 104 * 7 and not c.closed and guard < 5000:
		guard += 1
		if not c.pro_offer.is_empty():
			# Snapshot at the moment of first pro offer
			return {"career": c.duplicate(true), "fighter_id": str(f["id"]),
				"offer": c.pro_offer.duplicate(true), "day": c.day, "seed": seed_n}
		_answer_open(c, f)
		Sim.step_day(c)
	return {}


func _override_check(snap: Dictionary, gap: float) -> Dictionary:
	var c: Career = snap["career"].duplicate(true)
	var fid: String = str(snap["fighter_id"])
	var f: Dictionary = c.fighter_by_id(fid)
	if f.is_empty():
		return {"gap": gap, "night": -1.0, "opp_rating": -1.0, "deal_gap": -1.0, "ok": false}
	c.pro_offer = snap["offer"].duplicate(true)
	var key := str((c.pro_offer.get("offers", [{}]) as Array)[0].get("key", ""))
	# Set opp_gap on the offer terms WHERE THE DEAL READS IT
	for t2 in c.pro_offer.get("offers", []):
		t2["opp_gap"] = gap
	var night: float = BoutRules.fight_power(f["stats"], {}, 0, "", true)
	Roster.turn_pro(c, key)
	var deal: Dictionary = f.get("bout", {}).get("deal", {})
	var deal_gap: float = float(deal.get("opp_gap", -999.0))
	var opp_rating: float = float(f.get("bout", {}).get("opp", {}).get("rating", -1.0))
	return {"gap": gap, "night": night, "opp_rating": opp_rating, "deal_gap": deal_gap,
		"expected_opp_rating": snappedf(night - gap, 0.1), "ok": absf(deal_gap - gap) < 0.01}


func _run_one(snap: Dictionary, gap: float, run_seed: int) -> bool:
	var c: Career = snap["career"].duplicate(true)
	var fid: String = str(snap["fighter_id"])
	var f: Dictionary = c.fighter_by_id(fid)
	if f.is_empty():
		return false
	var results_before: int = c.results.size()
	c.pro_offer = snap["offer"].duplicate(true)
	var key := str((c.pro_offer.get("offers", [{}]) as Array)[0].get("key", ""))
	# Set opp_gap on the offer terms WHERE THE DEAL READS IT
	for t2 in c.pro_offer.get("offers", []):
		t2["opp_gap"] = gap
	# Vary the day slightly to get different fight outcomes (BoutNight seeds from c.day)
	# S531: was run_seed % 7, and run_seed steps by seed_j * 7 - every seed landed on the same day (the same night 10 times)
	var day_offset: int = int(run_seed / 7) % 10   # seed_j moves it by one day: 10 seeds = 10 nights
	c.day = c.day + day_offset
	Roster.turn_pro(c, key)
	var guard := 0
	while c.day < snap["day"] + MAX_DAYS and not c.closed and guard < 2000:
		guard += 1
		_answer_open(c, f)
		Sim.step_day(c)
		if c.results.size() > results_before:
			for r in c.results.slice(0, c.results.size() - results_before):
				if str(r.get("fid", "")) == fid and bool(r.get("pro", false)):
					return bool(r.get("win", false))
	return false


func _bout_read_at_signing(snap: Dictionary, gap: float) -> Dictionary:
	var c: Career = snap["career"].duplicate(true)
	var fid: String = str(snap["fighter_id"])
	var f: Dictionary = c.fighter_by_id(fid)
	if f.is_empty():
		return {}
	c.pro_offer = snap["offer"].duplicate(true)
	var key := str((c.pro_offer.get("offers", [{}]) as Array)[0].get("key", ""))
	for t2 in c.pro_offer.get("offers", []):
		t2["opp_gap"] = gap
	var night: float = BoutRules.fight_power(f["stats"], {}, 0, "", true)
	var opp_rating: float = snappedf(night - gap, 0.1)
	var opp := {"name": "Test Opponent", "rating": opp_rating, "w": 0, "l": 0, "pro": true,
		"style": "Boxer-puncher", "stance": "orthodox", "threat": "Heavy right hand",
		"weak": "Fades after round 3", "div": f.get("div", "wlw"), "age": 24}
	var camp := {}
	var salt: int = 0
	var coach: float = 0.0
	var lik: float = BoutRead.likely(f, opp, camp, salt, coach)
	var b := BoutRead.band(f, opp, camp, salt, coach)
	return {"likely": lik, "band_lo": float(b.get("lo", 0.0)), "band_hi": float(b.get("hi", 0.0))}


func _answer_open(c: Career, f: Dictionary) -> void:
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
	if bool(f.get("pro", false)) and ProLadder.on_ladder(c, f) and (f["bout"] as Dictionary).is_empty():
		var rows := ProLadder.offer_rows(c, f)
		for kind in ["above", "tune", "payday"]:
			var pick := rows.filter(func(r): return str(r["kind"]) == kind)
			if not pick.is_empty():
				ProLadder.book(c, f, int(pick[0]["opp"]["id"]), false)
				break


func _percentile(sorted_vals: Array, p: float) -> float:
	if sorted_vals.is_empty():
		return 0.0
	var idx: float = p * float(sorted_vals.size() - 1)
	var lo: int = int(floor(idx))
	var hi: int = int(ceil(idx))
	if lo == hi:
		return float(sorted_vals[lo])
	var frac: float = idx - float(lo)
	return lerpf(float(sorted_vals[lo]), float(sorted_vals[hi]), frac)


func _report(elapsed: float) -> Array:
	var L: Array = []
	L.append("# TURNGAP1 RESULT - the debut's opponent gap -> win chance curve")
	L.append("")
	L.append("Probe run: %s. %d boxers x %d gaps x %d seeds. Wall time: %.1f s." % [
		Time.get_datetime_string_from_system(), N_BOXERS, GAPS.size(), SEEDS_PER, elapsed])
	L.append("")
	L.append("## Override proof (one boxer, each gap)")
	L.append("")
	L.append("| gap | night | deal_gap | opp_rating | expected_opp_rating | ok |")
	L.append("|---|---|---|---|---|---|")
	for p in override_proof:
		L.append("| %.1f | %.1f | %.1f | %.1f | %.1f | %s |" % [
			float(p["gap"]), float(p["night"]), float(p["deal_gap"]),
			float(p["opp_rating"]), float(p["expected_opp_rating"]),
			"YES" if bool(p["ok"]) else "NO"])
	L.append("")
	L.append("## Per-gap win share (all boxers)")
	L.append("")
	L.append("| gap | wins | total | win_share |")
	L.append("|---|---|---|---|")
	for gap in GAPS:
		var wt: Array = wins_by_gap[gap]
		var w: int = int(wt[0]); var t: int = int(wt[1])
		var share: float = 100.0 * float(w) / float(maxi(1, t))
		L.append("| %.1f | %d | %d | %.1f%% |" % [gap, w, t, share])
	L.append("")
	L.append("## Per-boxer win share median [p10..p90]")
	L.append("")
	L.append("| gap | median | p10 | p90 |")
	L.append("|---|---|---|---|")
	for gap in GAPS:
		var shares: Array = []
		for boxer_idx in boxer_win_shares:
			shares.append(boxer_win_shares[boxer_idx][gap])
		shares.sort()
		var med: float = _percentile(shares, 0.5)
		var p10: float = _percentile(shares, 0.1)
		var p90: float = _percentile(shares, 0.9)
		L.append("| %.1f | %.1f%% | %.1f%% | %.1f%% |" % [gap, med * 100.0, p10 * 100.0, p90 * 100.0])
	L.append("")
	L.append("## BoutRead at signing (what the offer would say)")
	L.append("")
	if not override_proof.is_empty():
		var proof_snap: Dictionary = {}
		# Rebuild the first boxer's snapshot for BoutRead
		var seed_n: int = 7000
		var c := Career.quick_start()
		c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
		Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
		var f: Dictionary = c.fighter()
		var guard := 0
		while c.day < 104 * 7 and not c.closed and guard < 5000:
			guard += 1
			if not c.pro_offer.is_empty():
				proof_snap = {"career": c.duplicate(true), "fighter_id": str(f["id"]),
					"offer": c.pro_offer.duplicate(true), "day": c.day}
				break
			_answer_open(c, f)
			Sim.step_day(c)
		if not proof_snap.is_empty():
			L.append("| gap | likely | band_lo | band_hi |")
			L.append("|---|---|---|---|")
			for gap in GAPS:
				var br := _bout_read_at_signing(proof_snap, gap)
				if br.is_empty():
					continue
				L.append("| %.1f | %.1f%% | %.1f%% | %.1f%% |" % [
					gap, float(br["likely"]) * 100.0, float(br["band_lo"]) * 100.0, float(br["band_hi"]) * 100.0])
	L.append("")
	L.append("## Gap targets")
	L.append("")
	var gap6580 := _find_gap_for_range(65.0, 80.0)
	var gap7085 := _find_gap_for_range(70.0, 85.0)
	L.append("- Gap for 65-80%% win share: %s" % gap6580)
	L.append("- Gap for 70-85%% win share: %s" % gap7085)
	L.append("")
	L.append("Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_gap_probe.gd`")
	L.append("")
	L.append("TURNGAP1 done")
	return L


func _find_gap_for_range(lo: float, hi: float) -> String:
	var best_gap: String = "none"
	var best_dist: float = INF
	for gap in GAPS:
		var wt: Array = wins_by_gap[gap]
		var w: int = int(wt[0]); var t: int = int(wt[1])
		var share: float = 100.0 * float(w) / float(maxi(1, t))
		if share >= lo and share <= hi:
			var mid: float = (lo + hi) / 2.0
			var dist: float = absf(share - mid)
			if dist < best_dist:
				best_dist = dist; best_gap = "%.1f" % gap
	return best_gap


func _check_override() -> String:
	var all_ok := true
	for p in override_proof:
		if not bool(p["ok"]):
			all_ok = false; break
	return "yes" if all_ok else "no"
