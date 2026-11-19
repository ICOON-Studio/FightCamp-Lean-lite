extends SceneTree
## TURNPROBE2 (ops/research/TASK_TURNPROBE2.md): measure turning pro's three failing lines the right way.
## Line 2: paired diff per career (YES vs PREP), median, week each signed, purse each got.
## Line 4: debut's own money (cash change from signing to week after debut, minus paired NEVER same span).
## Line 7: for each YES offer, fork simulation per ask, record which ends with most gym cash + boxer purse.

const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Fork := preload("res://tools/turn_pro_probe2_fork.gd")

const BOTS := ["YES", "RANK", "PREP", "NEVER", "AMB"]
const SEED_SETS := [4421, 9001]
var N := 30
const WEEKS := 104
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const DOC := "res://docs/TURNPROBE2_RESULT.md"

var results: Array = []
var fork_results: Array = []


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
	print("TURNPROBE2 %d careers/bot x %d bots x %d seed sets, %d weeks; seeds %s" % [N, BOTS.size(), SEED_SETS.size(), WEEKS, str(SEED_SETS)])
	for ss in SEED_SETS:
		for bot in BOTS:
			for i in N:
				var stip: bool = i < (N / 2)
				var seed_n: int = ss + i * 137 + BOTS.find(bot) * 7919
				var r := _career(bot, seed_n, stip, i, ss)
				r["seed_set"] = ss; r["idx"] = i
				results.append(r)
	var elapsed := (Time.get_ticks_msec() - t0) / 1000.0
	print("TURNPROBE2 wall time: %.1f s" % elapsed)
	var L := _report(elapsed)
	for line in L:
		print(line)
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh != null:
		fh.store_string("\n".join(L) + "\n"); fh.close(); print("wrote %s" % DOC)
	print("TURNPROBE2 done")
	quit(0)


func _career(bot: String, seed_n: int, stipend_on: bool, idx: int, seed_set: int) -> Dictionary:
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
	if not stipend_on:
		GymSpend.set_stipend(c, f, false)
	var signed := false; var signed_day := -1; var signed_house := ""
	var door_closed := false; var debut_won := false; var debut_opp_gap := 0.0
	var asks_made: Array = []; var both_called_count := 0; var cash_w52 := 0
	var morale_at_sign := 50.0; var guard := 0; var last_week := 0
	var offered_with_both := 0
	var cash_at_sign := 0; var cash_after_debut := 0; var debut_done_day := -1
	var purse_got := 0; var offer_snapshots: Array = []
	while c.day < WEEKS * 7 and not c.closed and guard < 5000:
		guard += 1
		if not c.pro_offer.is_empty():
			var offs: Array = c.pro_offer.get("offers", [])
			if offs.size() >= 2:
				offered_with_both += 1
		if not c.pro_offer.is_empty() and not signed:
			if bot == "YES":
				var snap := {"career": c.duplicate(true), "fighter_id": str(f["id"]), "seed": seed_n, "day": c.day,
					"offer": c.pro_offer.duplicate(true)}
				offer_snapshots.append(snap)
			_handle_offer(bot, c, f, asks_made)
		if not signed and bool(f.get("pro", false)):
			signed = true; signed_day = c.day; signed_house = str(f.get("pro_house", ""))
			morale_at_sign = float(f.get("morale", 50.0))
			debut_opp_gap = float(f["bout"].get("deal", {}).get("opp_gap", Roster.PRO_OPP_GAP))
			cash_at_sign = c.cash; purse_got = int(f.get("purse", 0))
		if int(f.get("pro_declines", 0)) >= 3:
			door_closed = true
		var week := Clock.week_of(c.day)
		if week > last_week:
			if week == 52 and cash_w52 == 0:
				cash_w52 = c.cash
			last_week = week
		if signed and debut_done_day == -1:
			var bout: Dictionary = f.get("bout", {})
			if not bout.is_empty() and bool(bout.get("done", false)):
				debut_done_day = c.day; cash_after_debut = c.cash
		_answer_open(c, f)
		Sim.step_day(c)
	if cash_w52 == 0:
		cash_w52 = c.cash
	for r in c.results:
		if str(r.get("fid", "")) == str(f["id"]) and bool(r.get("pro", false)):
			debut_won = bool(r.get("win", false)); break
	if debut_done_day == -1 and signed:
		debut_done_day = c.day; cash_after_debut = c.cash
	var fork_asks: Array = []
	if bot == "YES" and signed and not offer_snapshots.is_empty():
		for snap in offer_snapshots:
			var fork_res := Fork.run_forks(snap, snap["offer"], seed_n, snap["day"])
			fork_asks.append(fork_res)
			fork_results.append({"bot": bot, "seed_set": seed_set, "idx": idx, "stipend": stipend_on, "forks": [fork_res]})
	return {"bot": bot, "seed": seed_n, "stipend": stipend_on, "idx": idx, "closed": c.closed,
		"signed": signed, "signed_day": signed_day, "signed_house": signed_house,
		"door_closed": door_closed, "debut_won": debut_won, "debut_opp_gap": debut_opp_gap,
		"asks": asks_made.duplicate(), "both_called_count": offered_with_both,
		"cash_w52": cash_w52, "cash_w104": c.cash, "morale_at_signing": morale_at_sign,
		"declines": int(f.get("pro_declines", 0)), "pro": bool(f.get("pro", false)),
		"w": int(f.get("w", 0)), "l": int(f.get("l", 0)),
		"cash_at_sign": cash_at_sign, "cash_after_debut": cash_after_debut, "debut_done_day": debut_done_day,
		"purse_got": purse_got, "cash_history": c.cash_history.duplicate(true)}


func _handle_offer(bot: String, c: Career, f: Dictionary, asks_made: Array) -> void:
	var offers: Array = c.pro_offer.get("offers", [])
	if offers.is_empty():
		return
	var sign_now := false
	match bot:
		"YES":
			sign_now = true
		"RANK":
			if Region.our_rank(c, f) == 1 or Roster.titles(f) > 0:
				sign_now = true
			else:
				Roster.decline_pro(c); return
		"PREP":
			if c.members >= 90 or offers.size() >= 2:
				sign_now = true
			else:
				Roster.decline_pro(c); return
		"NEVER":
			Roster.decline_pro(c); return
		"AMB":
			var kind: String = ProCall.ambition_kind(Recruit.ambition(f))
			if kind == "pro" or int(f.get("pro_declines", 0)) >= 1:
				sign_now = true
			else:
				Roster.decline_pro(c); return
	if not sign_now:
		return
	var pick_key := _best_house(c, f, offers)
	if bot == "YES":
		_try_best_ask(c, f, pick_key, asks_made)
	Roster.turn_pro(c, pick_key)


func _best_house(c: Career, f: Dictionary, offers: Array) -> String:
	if offers.size() == 1:
		return str(offers[0]["key"])
	var costs: int = int(Roster.debut_sheet(c, f, 1.0)["costs"])
	var share: float = Roster.signing_share(f)
	var best_key := ""; var best_bd := -999999
	for t in offers:
		var m: Dictionary = ProOfferWire.money(c, f, t, costs, share)
		var bd: int = int(m.get("by_debut", 0))
		if bd > best_bd:
			best_bd = bd; best_key = str(t["key"])
	return best_key


func _try_best_ask(c: Career, f: Dictionary, key: String, asks_made: Array) -> void:
	var runway: int = GymBills.runway_weeks(c.cash, 0)
	var entries: Array = ProOfferWire.answers(c, key, runway)
	var best_kind := ""; var best_bd := -999999
	var costs: int = int(Roster.debut_sheet(c, f, 1.0)["costs"])
	var share: float = Roster.signing_share(f)
	for e in entries:
		var ans: String = str(e.get("answer", "wont"))
		if ans == "wont":
			continue
		var after: Dictionary = e.get("after", {}).duplicate()
		var sold: int = mini(ProDebut.TICKETS, int(c.pro_offer.get("forecast", 0)) + int(after.get("extra_tickets", 0)))
		var pay_now: int = 0 if bool(after.get("costs_covered", false)) else costs
		var m: Dictionary = ProCall.money(after, sold, pay_now, share, int(f.get("weekly_salary", 0)) > 0, maxi(0, int(f.get("weekly_salary", 0))))
		var bd: int = int(m.get("by_debut", 0))
		if bd > best_bd:
			best_bd = bd; best_kind = str(e.get("kind", ""))
	if best_kind != "":
		var said := ProOfferWire.ask(c, key, best_kind, runway)
		if said != "":
			asks_made.append(best_kind)


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


func _median(vals: Array) -> float:
	if vals.is_empty():
		return 0.0
	var v: Array = vals.duplicate(); v.sort()
	var mid := int(v.size() / 2)
	return float(v[mid]) if v.size() % 2 == 1 else (float(v[mid - 1]) + float(v[mid])) / 2.0


func _group_best(ss: int, stip: bool) -> Dictionary:
	var bc := {}; for bot in BOTS: bc[bot] = 0
	var sub := results.filter(func(r): return r["seed_set"] == ss and r["stipend"] == stip)
	for i in N:
		var grp := sub.filter(func(r): return int(r["idx"]) == i)
		if grp.is_empty():
			continue
		var best_c := -999999; var best_b := ""
		for r in grp:
			if int(r["cash_w104"]) > best_c:
				best_c = int(r["cash_w104"]); best_b = str(r["bot"])
		if best_b != "":
			bc[best_b] = int(bc[best_b]) + 1
	return bc


func _cash_at_day(history: Array, day: int) -> int:
	if history.is_empty():
		return 0
	var week := int(floor(day / 7.0)) + 1
	var best_cash: int = int(history[0].get("c", 0))
	for h in history:
		if int(h.get("w", 0)) <= week:
			best_cash = int(h.get("c", best_cash))
		else:
			break
	return best_cash


func _report(elapsed: float) -> Array:
	var L: Array = []
	L.append("# TURNPROBE2 RESULT - measure turning pro's three failing lines the right way")
	L.append("")
	L.append("Probe run: %s. %d careers/bot x 5 bots x 2 seed sets = %d careers, %d weeks each. Wall time: %.1f s." % [
		Time.get_datetime_string_from_system(), N, N * BOTS.size() * SEED_SETS.size(), WEEKS, elapsed])
	L.append(""); L.append("## Population"); L.append("")
	L.append("- Seeds: %s. Each seed set runs every bot with the same %d career indices (0..%d)." % [str(SEED_SETS), N, N - 1])
	L.append("- Stipend split: half (idx < %d) pay the stipend, half on the day job." % (N / 2))
	L.append("")
	L.append("## Per-bot summary")
	L.append("")
	L.append("| bot | seed_set | stip | n | w52_med | w104_med | signed | door | hf_pick |")
	L.append("|---|---|---|---|---|---|---|---|---|")
	for ss in SEED_SETS:
		for bot in BOTS:
			for stip in [true, false]:
				var sub := results.filter(func(r): return r["bot"] == bot and r["seed_set"] == ss and r["stipend"] == stip)
				if sub.is_empty():
					continue
				var cw52: Array = sub.map(func(r): return int(r["cash_w52"]))
				var cw104: Array = sub.map(func(r): return int(r["cash_w104"]))
				var ns: int = sub.filter(func(r): return bool(r["signed"])).size()
				var nd: int = sub.filter(func(r): return bool(r["door_closed"])).size()
				var nh: int = sub.filter(func(r): return str(r["signed_house"]) == "hf").size()
				L.append("| %s | %d | %s | %d | %d | %d | %d | %d | %d |" % [
					bot, ss, "stip" if stip else "dayj", sub.size(),
					int(_median(cw52)), int(_median(cw104)), ns, nd, nh])
	L.append("")
	L.append("## Pass lines (design section 7)")
	L.append("")
	_pass_lines(L)
	L.append("")
	L.append("Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_pro_probe2.gd`")
	L.append(""); L.append("TURNPROBE2 done")
	return L


func _pass_lines(L: Array) -> void:
	var ok1 := true
	for ss in SEED_SETS:
		for stip in [true, false]:
			var bc := _group_best(ss, stip)
			var total := 0; for bot in BOTS: total += int(bc[bot])
			for bot in BOTS:
				if total > 0 and 100.0 * float(bc[bot]) / total > 60.0:
					ok1 = false
	L.append("### 1. No bot dominates (>60%) at week 104")
	L.append("- %s" % ("PASS" if ok1 else "FAIL"))
	L.append("### 2. PREP beats YES at w104 by $1,500+ (paired diff)")
	var prep_yes_diffs: Array = []
	var prep_yes_details: Array = []
	for ss in SEED_SETS:
		for stip in [true, false]:
			for i in N:
				var prep_r := results.filter(func(r): return r["bot"] == "PREP" and r["seed_set"] == ss and r["stipend"] == stip and int(r["idx"]) == i)
				var yes_r := results.filter(func(r): return r["bot"] == "YES" and r["seed_set"] == ss and r["stipend"] == stip and int(r["idx"]) == i)
				if prep_r.is_empty() or yes_r.is_empty():
					continue
				var diff: int = int(prep_r[0]["cash_w104"]) - int(yes_r[0]["cash_w104"])
				prep_yes_diffs.append(diff)
				prep_yes_details.append({"ss": ss, "stip": stip, "idx": i, "diff": diff,
					"prep_signed": int(prep_r[0]["signed_day"]), "prep_purse": int(prep_r[0]["purse_got"]),
					"yes_signed": int(yes_r[0]["signed_day"]), "yes_purse": int(yes_r[0]["purse_got"])})
	var line2_median: float = _median(prep_yes_diffs)
	L.append("- Paired diffs: %d careers, median: $%d" % [prep_yes_diffs.size(), int(line2_median)])
	for j in mini(3, prep_yes_details.size()):
		var d: Dictionary = prep_yes_details[j]
		L.append("  - seed %d %s idx %d: diff $%d (PREP day %d purse $%d, YES day %d purse $%d)" % [
			int(d["ss"]), "stip" if bool(d["stip"]) else "dayj", int(d["idx"]), int(d["diff"]),
			int(d["prep_signed"]), int(d["prep_purse"]), int(d["yes_signed"]), int(d["yes_purse"])])
	L.append("- %s (constant: ProCall.BAND / ProCall.SECOND_TERMS)" % ("PASS" if line2_median >= 1500 else "FAIL"))
	var y_stip := results.filter(func(r): return r["bot"] == "YES" and r["stipend"]).map(func(r): return int(r["cash_w52"]))
	var n_stip := results.filter(func(r): return r["bot"] == "NEVER" and r["stipend"]).map(func(r): return int(r["cash_w52"]))
	var yn52: Array = results.filter(func(r): return r["bot"] == "YES" and not r["stipend"]).map(func(r): return int(r["cash_w52"]))
	var nn52: Array = results.filter(func(r): return r["bot"] == "NEVER" and not r["stipend"]).map(func(r): return int(r["cash_w52"]))
	var yn104: Array = results.filter(func(r): return r["bot"] == "YES" and not r["stipend"]).map(func(r): return int(r["cash_w104"]))
	var nn104: Array = results.filter(func(r): return r["bot"] == "NEVER" and not r["stipend"]).map(func(r): return int(r["cash_w104"]))
	L.append("### 3. Stipend timing: YES vs NEVER")
	L.append("- stip w52: YES $%d vs NEVER $%d" % [int(_median(y_stip)), int(_median(n_stip))])
	L.append("- no-stip w52: NEVER $%d vs YES $%d" % [int(_median(nn52)), int(_median(yn52))])
	L.append("- no-stip w104: YES $%d vs NEVER $%d" % [int(_median(yn104)), int(_median(nn104))])
	var ok3: bool = _median(y_stip) > _median(n_stip) and _median(nn52) > _median(yn52) and _median(yn104) > _median(nn104)
	L.append("- %s (constant: ProCall.LOST_CUT_A_WEEK)" % ("PASS" if ok3 else "FAIL"))
	L.append("### 4. YES debut loses gym money 40-70% (debut's own money)")
	var line4_pcts: Array = []
	for ss in SEED_SETS:
		for stip in [true, false]:
			var yes_sub := results.filter(func(r): return r["bot"] == "YES" and r["seed_set"] == ss and r["stipend"] == stip and bool(r["signed"]))
			var never_sub := results.filter(func(r): return r["bot"] == "NEVER" and r["seed_set"] == ss and r["stipend"] == stip)
			var neg_count := 0; var total_count := 0
			for yr in yes_sub:
				var idx_val: int = int(yr["idx"])
				var nr_arr := never_sub.filter(func(r): return int(r["idx"]) == idx_val)
				if nr_arr.is_empty():
					continue
				var nr: Dictionary = nr_arr[0]
				var yes_sign_day: int = int(yr["signed_day"])
				var yes_debut_done: int = int(yr["debut_done_day"])
				if yes_sign_day < 0 or yes_debut_done < 0:
					continue
				var yes_cash_change: int = int(yr["cash_after_debut"]) - int(yr["cash_at_sign"])
				var never_history: Array = nr.get("cash_history", [])
				var never_cash_at_sign: int = _cash_at_day(never_history, yes_sign_day)
				var never_cash_at_debut: int = _cash_at_day(never_history, yes_debut_done)
				var never_cash_change: int = never_cash_at_debut - never_cash_at_sign
				var debut_impact: int = yes_cash_change - never_cash_change
				total_count += 1
				if debut_impact < 0:
					neg_count += 1
			var pct: float = 100.0 * float(neg_count) / maxf(1, total_count)
			line4_pcts.append(pct)
			L.append("- seed %d %s: %d/%d (%.0f%%) debuts lost money" % [ss, "stip" if stip else "dayj", neg_count, total_count, pct])
	var line4_avg: float = 0.0
	if not line4_pcts.is_empty():
		var s: float = 0.0
		for p in line4_pcts:
			s += p
		line4_avg = s / float(line4_pcts.size())
	L.append("- Average: %.0f%% -> %s (constant: ProCall.PURSE_FLOOR / ProCall.SHORT_TICKET)" % [line4_avg, "PASS" if line4_avg >= 40.0 and line4_avg <= 70.0 else "FAIL"])
	var ra := results.filter(func(r): return r["bot"] == "RANK")
	var rd: int = ra.filter(func(r): return bool(r["door_closed"])).size()
	var rd_p: float = 100.0 * float(rd) / maxf(1, ra.size())
	L.append("### 5. RANK door closes 10-30%")
	L.append("- %d/%d (%.0f%%) -> %s" % [rd, ra.size(), rd_p, "PASS" if rd_p >= 10.0 and rd_p <= 30.0 else "FAIL"])
	var sa2 := results.filter(func(r): return bool(r["signed"]))
	var g10b := sa2.filter(func(r): return float(r["debut_opp_gap"]) <= 1.1)
	var g15b := sa2.filter(func(r): return float(r["debut_opp_gap"]) >= 1.4)
	var w10b: int = g10b.filter(func(r): return bool(r["debut_won"])).size()
	var w15b: int = g15b.filter(func(r): return bool(r["debut_won"])).size()
	var p10: float = 100.0 * float(w10b) / maxf(1, g10b.size())
	var p15: float = 100.0 * float(w15b) / maxf(1, g15b.size())
	L.append("### 6. Debut win rate 65-80% at 1.0, 70-85% at 1.5")
	L.append("- 1.0: %.0f%% (%d/%d) %s" % [p10, w10b, g10b.size(), "ok" if p10 >= 65.0 and p10 <= 80.0 else "out"])
	L.append("- 1.5: %.0f%% (%d/%d) %s" % [p15, w15b, g15b.size(), "ok" if p15 >= 70.0 and p15 <= 85.0 else "out"])
	var ok6: bool = p10 >= 65.0 and p10 <= 80.0 and p15 >= 70.0 and p15 <= 85.0
	L.append("- %s (constant: Roster.PRO_OPP_GAP / ProCall.SOFTER_OPP_ADD)" % ("PASS" if ok6 else "FAIL"))
	L.append("### 7. Each ask is the best in 10%+ of offers (fork method)")
	var ask_counts := {"later2": 0, "later4": 0, "softer": 0, "split": 0, "price": 0, "costs": 0, "no_ask": 0}
	var total_offers := 0
	for fr in fork_results:
		if str(fr["bot"]) != "YES":
			continue
		for fork_data in (fr["forks"] as Array):
			total_offers += 1
			var best_ask: String = str(fork_data.get("best_ask", ""))
			if ask_counts.has(best_ask):
				ask_counts[best_ask] += 1
	var ok7 := true
	for k in ["later2", "later4", "softer", "split", "price", "costs"]:
		var pp: float = 100.0 * float(ask_counts[k]) / maxf(1, total_offers)
		if pp < 10.0:
			ok7 = false
		L.append("- %s: %.0f%% (%d/%d)" % [k, pp, ask_counts[k], total_offers])
	L.append("- no_ask: %.0f%% (%d/%d)" % [100.0 * float(ask_counts["no_ask"]) / maxf(1, total_offers), ask_counts["no_ask"], total_offers])
	L.append("- %s (constant: ProCall ask constants)" % ("PASS" if ok7 else "FAIL"))
	var sa3 := results.filter(func(r): return bool(r["signed"]))
	var hfc: int = sa3.filter(func(r): return str(r["signed_house"]) == "hf").size()
	var hfp: float = 100.0 * float(hfc) / maxf(1, sa3.size())
	var btc: int = results.filter(func(r): return int(r["both_called_count"]) > 0).size()
	var btp: float = 100.0 * float(btc) / maxf(1, results.size())
	L.append("### 8. HF picked 25%+, both together 25-50%")
	L.append("- HF: %.0f%% (%d/%d) %s" % [hfp, hfc, sa3.size(), "ok" if hfp >= 25.0 else "out"])
	L.append("- both: %.0f%% (%d/%d) %s" % [btp, btc, results.size(), "ok" if btp >= 25.0 and btp <= 50.0 else "out"])
	var ok8: bool = hfp >= 25.0 and btp >= 25.0 and btp <= 50.0
	L.append("- %s (constant: ProCall.BAND)" % ("PASS" if ok8 else "FAIL"))
	var amb_s2 := results.filter(func(r): return r["bot"] == "AMB" and bool(r["signed"]))
	var st: int = amb_s2.filter(func(r): return float(r["morale_at_signing"]) >= 50.0).size()
	var st_p: float = 100.0 * float(st) / maxf(1, amb_s2.size())
	L.append("### 9. AMB morale Steady+ at signing 70%+")
	L.append("- %d/%d (%.0f%%) -> %s" % [st, amb_s2.size(), st_p, "PASS" if st_p >= 70.0 else "FAIL"])
