extends SceneTree
## TURNPROBE1 (ops/research/TASK_TURNPROBE1.md): do the two promoters, the one ask and the timing make a real choice?
## One-boxer careers from Career.quick_start, 104 weeks through Sim.step_day. Five bots answer c.pro_offer each day.
## Half the careers pay the stipend, half put the boxer on the day job. 30 careers/bot, 2 seed sets (4421, 9001).

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

const BOTS := ["YES", "RANK", "PREP", "NEVER", "AMB"]
const SEED_SETS := [4421, 9001]
var N := 30
const WEEKS := 104
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const DOC := "res://docs/TURNPROBE1_RESULT.md"

var results: Array = []


func _initialize() -> void:
	var args := OS.get_cmdline_args()
	for i in range(args.size()):
		if args[i] == "--" and i + 1 < args.size():
			var narg := args[i + 1]
			if narg.is_valid_int():
				N = int(narg)
			break
	var t0 := Time.get_ticks_msec()
	print("TURNPROBE1 %d careers/bot x %d bots x %d seed sets, %d weeks; seeds %s" % [N, BOTS.size(), SEED_SETS.size(), WEEKS, str(SEED_SETS)])
	for ss in SEED_SETS:
		for bot in BOTS:
			for i in N:
				var stip: bool = i < (N / 2)
				var seed_n: int = ss + i * 137 + BOTS.find(bot) * 7919
				var r := _career(bot, seed_n, stip, i)
				r["seed_set"] = ss; r["idx"] = i
				results.append(r)
	var elapsed := (Time.get_ticks_msec() - t0) / 1000.0
	print("TURNPROBE1 wall time: %.1f s" % elapsed)
	var L := _report(elapsed)
	for line in L:
		print(line)
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh != null:
		fh.store_string("\n".join(L) + "\n"); fh.close(); print("wrote %s" % DOC)
	print("TURNPROBE1 done")
	quit(0)


func _career(bot: String, seed_n: int, stipend_on: bool, idx: int) -> Dictionary:
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
	while c.day < WEEKS * 7 and not c.closed and guard < 5000:
		guard += 1
		# Track both-called BEFORE handling (offer is cleared after sign/decline)
		if not c.pro_offer.is_empty():
			var offs: Array = c.pro_offer.get("offers", [])
			if offs.size() >= 2:
				offered_with_both += 1
		if not c.pro_offer.is_empty() and not signed:
			_handle_offer(bot, c, f, asks_made)
		if not signed and bool(f.get("pro", false)):
			signed = true; signed_day = c.day; signed_house = str(f.get("pro_house", ""))
			morale_at_sign = float(f.get("morale", 50.0))
			debut_opp_gap = float(f["bout"].get("deal", {}).get("opp_gap", Roster.PRO_OPP_GAP))
		if int(f.get("pro_declines", 0)) >= 3:
			door_closed = true
		var week := Clock.week_of(c.day)
		if week > last_week:
			if week == 52 and cash_w52 == 0:
				cash_w52 = c.cash
			last_week = week
		_answer_open(c, f)
		Sim.step_day(c)
	if cash_w52 == 0:
		cash_w52 = c.cash
	for r in c.results:
		if str(r.get("fid", "")) == str(f["id"]) and bool(r.get("pro", false)):
			debut_won = bool(r.get("win", false)); break
	return {"bot": bot, "seed": seed_n, "stipend": stipend_on, "idx": idx, "closed": c.closed,
		"signed": signed, "signed_day": signed_day, "signed_house": signed_house,
		"door_closed": door_closed, "debut_won": debut_won, "debut_opp_gap": debut_opp_gap,
		"asks": asks_made.duplicate(), "both_called_count": offered_with_both,
		"cash_w52": cash_w52, "cash_w104": c.cash, "morale_at_signing": morale_at_sign,
		"declines": int(f.get("pro_declines", 0)), "pro": bool(f.get("pro", false)),
		"w": int(f.get("w", 0)), "l": int(f.get("l", 0))}


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


func _pctile(vals: Array, p: float) -> float:
	if vals.is_empty():
		return 0.0
	var v: Array = vals.duplicate(); v.sort()
	var idx: float = p * float(v.size() - 1)
	var lo := int(floor(idx)); var hi := int(ceil(idx))
	return float(v[lo]) if lo == hi else float(v[lo]) + (idx - float(lo)) * (float(v[hi]) - float(v[lo]))


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


func _report(elapsed: float) -> Array:
	var L: Array = []
	L.append("# TURNPROBE1 RESULT - do the two promoters, the one ask and the timing make a real choice?")
	L.append("")
	L.append("Probe run: %s. %d careers/bot x 5 bots x 2 seed sets = %d careers, %d weeks each. Wall time: %.1f s." % [
		Time.get_datetime_string_from_system(), N, N * BOTS.size() * SEED_SETS.size(), WEEKS, elapsed])
	L.append(""); L.append("## Population"); L.append("")
	L.append("- Seeds: %s. Each seed set runs every bot with the same %d career indices (0..%d)." % [str(SEED_SETS), N, N - 1])
	L.append("- Stipend split: half (idx < %d) pay the stipend, half on the day job." % (N / 2))
	L.append("- One boxer (Lucy from quick_start), Reid hired, FirstWeek skipped. No cash floor (money is the measurement).")
	L.append("- Bots answer c.pro_offer every day (trap: check_pro runs after bouts and week end only).")
	L.append("")
	L.append("## Per-bot summary")
	L.append("")
	L.append("| bot | seed_set | stip | n | w52_med | w52_p25 | w52_p75 | w104_med | w104_p25 | w104_p75 | signed | door | hf_pick | both_ever |")
	L.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
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
				var nb: int = sub.filter(func(r): return int(r["both_called_count"]) > 0).size()
				L.append("| %s | %d | %s | %d | %d | %d | %d | %d | %d | %d | %d | %d | %d | %d |" % [
					bot, ss, "stip" if stip else "dayj", sub.size(),
					int(_median(cw52)), int(_pctile(cw52, 0.25)), int(_pctile(cw52, 0.75)),
					int(_median(cw104)), int(_pctile(cw104, 0.25)), int(_pctile(cw104, 0.75)),
					ns, nd, nh, nb])
	L.append("")
	L.append("## Best bot at week 104 (share of careers)")
	L.append("")
	for ss in SEED_SETS:
		for stip in [true, false]:
			var bc := _group_best(ss, stip)
			var total := 0; for bot in BOTS: total += int(bc[bot])
			var parts: Array = []
			for bot in BOTS:
				parts.append("%s %d/%d (%.0f%%)" % [bot, int(bc[bot]), total, 100.0 * float(bc[bot]) / maxf(1, total)])
			L.append("- seed %d %s: %s" % [ss, "stip" if stip else "dayj", ", ".join(parts)])
	L.append("")
	# Debut win rate
	var sa := results.filter(func(r): return bool(r["signed"]))
	var g10 := sa.filter(func(r): return float(r["debut_opp_gap"]) <= 1.1)
	var g15 := sa.filter(func(r): return float(r["debut_opp_gap"]) >= 1.4)
	var w10: int = g10.filter(func(r): return bool(r["debut_won"])).size()
	var w15: int = g15.filter(func(r): return bool(r["debut_won"])).size()
	L.append("## Debut win rate by opponent gap")
	L.append("")
	L.append("- 1.0 under: %d/%d (%.0f%%)" % [w10, g10.size(), 100.0 * float(w10) / maxf(1, g10.size())])
	L.append("- 1.5 under: %d/%d (%.0f%%)" % [w15, g15.size(), 100.0 * float(w15) / maxf(1, g15.size())])
	L.append("")
	# Ask shares
	var ys := results.filter(func(r): return r["bot"] == "YES" and bool(r["signed"]))
	var ac := {}
	for r in ys:
		for a in (r["asks"] as Array):
			ac[a] = int(ac.get(a, 0)) + 1
	L.append("## Ask pick shares (YES bot)")
	L.append("")
	for k in ["later2", "later4", "softer", "split", "price", "costs"]:
		L.append("- %s: %d/%d (%.0f%%)" % [k, int(ac.get(k, 0)), ys.size(), 100.0 * float(ac.get(k, 0)) / maxf(1, ys.size())])
	L.append("")
	# AMB morale
	var amb_s := results.filter(func(r): return r["bot"] == "AMB" and bool(r["signed"]))
	var steady: int = amb_s.filter(func(r): return float(r["morale_at_signing"]) >= 50.0).size()
	L.append("## AMB morale at signing")
	L.append("")
	L.append("- Steady+ (>=50): %d/%d (%.0f%%)" % [steady, amb_s.size(), 100.0 * float(steady) / maxf(1, amb_s.size())])
	L.append("")
	L.append("## Pass lines (design section 7)")
	L.append("")
	_pass_lines(L)
	L.append("")
	L.append("Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_pro_probe.gd`")
	L.append(""); L.append("TURNPROBE1 done")
	return L


func _pass_lines(L: Array) -> void:
	# 1. No bot >60% at w104 on every seed set
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
	# 2. PREP beats YES by $1500+ at w104
	var prep_c: Array = results.filter(func(r): return r["bot"] == "PREP").map(func(r): return int(r["cash_w104"]))
	var yes_c: Array = results.filter(func(r): return r["bot"] == "YES").map(func(r): return int(r["cash_w104"]))
	var diff: float = _median(prep_c) - _median(yes_c)
	L.append("### 2. PREP beats YES at w104 by $1,500+")
	L.append("- diff $%d -> %s (constant: ProCall.BAND / ProCall.SECOND_TERMS)" % [int(diff), "PASS" if diff >= 1500 else "FAIL"])
	# 3. Stipend timing
	var y_stip := results.filter(func(r): return r["bot"] == "YES" and r["stipend"]).map(func(r): return int(r["cash_w52"]))
	var n_stip := results.filter(func(r): return r["bot"] == "NEVER" and r["stipend"]).map(func(r): return int(r["cash_w52"]))
	var yn52: Array = results.filter(func(r): return r["bot"] == "YES" and not r["stipend"]).map(func(r): return int(r["cash_w52"]))
	var nn52: Array = results.filter(func(r): return r["bot"] == "NEVER" and not r["stipend"]).map(func(r): return int(r["cash_w52"]))
	var yn104: Array = results.filter(func(r): return r["bot"] == "YES" and not r["stipend"]).map(func(r): return int(r["cash_w104"]))
	var nn104: Array = results.filter(func(r): return r["bot"] == "NEVER" and not r["stipend"]).map(func(r): return int(r["cash_w104"]))
	L.append("### 3. Stipend timing: YES vs NEVER")
	L.append("- stip w52: YES $%d vs NEVER $%d -> %s" % [int(_median(y_stip)), int(_median(n_stip)), "YES leads" if _median(y_stip) > _median(n_stip) else "NEVER leads"])
	L.append("- no-stip w52: NEVER $%d vs YES $%d -> %s" % [int(_median(nn52)), int(_median(yn52)), "NEVER leads" if _median(nn52) > _median(yn52) else "YES leads"])
	L.append("- no-stip w104: YES $%d vs NEVER $%d -> %s" % [int(_median(yn104)), int(_median(nn104)), "YES leads" if _median(yn104) > _median(nn104) else "NEVER leads"])
	var ok3: bool = _median(y_stip) > _median(n_stip) and _median(nn52) > _median(yn52) and _median(yn104) > _median(nn104)
	L.append("- %s (constant: ProCall.LOST_CUT_A_WEEK)" % ("PASS" if ok3 else "FAIL"))
	# 4. YES debut loses gym money 40-70%
	var ya := results.filter(func(r): return r["bot"] == "YES" and bool(r["signed"]))
	var neg: int = ya.filter(func(r): return int(r["cash_w52"]) < 0).size()
	var neg_p: float = 100.0 * float(neg) / maxf(1, ya.size())
	L.append("### 4. YES debut loses gym money 40-70%")
	L.append("- %d/%d (%.0f%%) -> %s (constant: ProCall.PURSE_FLOOR / ProCall.SHORT_TICKET)" % [neg, ya.size(), neg_p, "PASS" if neg_p >= 40.0 and neg_p <= 70.0 else "FAIL"])
	# 5. RANK door closes 10-30%
	var ra := results.filter(func(r): return r["bot"] == "RANK")
	var rd: int = ra.filter(func(r): return bool(r["door_closed"])).size()
	var rd_p: float = 100.0 * float(rd) / maxf(1, ra.size())
	L.append("### 5. RANK door closes 10-30%")
	L.append("- %d/%d (%.0f%%) -> %s (constant: Roster.PRO_RETURN_WINS / ProCall.AGE_STOP)" % [rd, ra.size(), rd_p, "PASS" if rd_p >= 10.0 and rd_p <= 30.0 else "FAIL"])
	# 6. Debut win rate
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
	# 7. Each ask 10%+
	var ac2 := {}
	for r in ya:
		for a in (r["asks"] as Array):
			ac2[a] = int(ac2.get(a, 0)) + 1
	var ok7 := true
	L.append("### 7. Each ask is the best in 10%+ of offers")
	for k in ["later2", "later4", "softer", "split", "price", "costs"]:
		var pp: float = 100.0 * float(ac2.get(k, 0)) / maxf(1, ya.size())
		if pp < 10.0:
			ok7 = false
		L.append("- %s: %.0f%%" % [k, pp])
	L.append("- %s (constant: ProCall ask constants)" % ("PASS" if ok7 else "FAIL"))
	# 8. HF 25%+, both 25-50%
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
	# 9. AMB morale 70%+
	var amb_s2 := results.filter(func(r): return r["bot"] == "AMB" and bool(r["signed"]))
	var st: int = amb_s2.filter(func(r): return float(r["morale_at_signing"]) >= 50.0).size()
	var st_p: float = 100.0 * float(st) / maxf(1, amb_s2.size())
	L.append("### 9. AMB morale Steady+ at signing 70%+")
	L.append("- %d/%d (%.0f%%) -> %s (constant: ProCall.morale / Recruit.ambition)" % [st, amb_s2.size(), st_p, "PASS" if st_p >= 70.0 else "FAIL"])
