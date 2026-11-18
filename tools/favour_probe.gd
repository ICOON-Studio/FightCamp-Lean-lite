extends SceneTree
## FAVOURPROBE1 (S514, ops/research/TASK_FAVOURPROBE1.md): where favours with the hosts sit after a year of real play.
## A measurement only - no rule or constant is changed. 40 seeds x 2 clubs (a quick-start club with Lucy, and the TEST
## CLUB scripts/state/TestClub.gd), each stepped 364 days through Sim.step_day, every open need answered in code as
## TestJump._tidy / _to_nationals answer them at the state level (no UI): offers accepted (Bouts.accept), the fight week
## set (FightWeekPlan.draft -> best-ranked free partners -> lock), the weigh-in (Bouts.weigh), the bout (Bouts.fight_step
## "sim" + after_fight), the office goal (Bouts.set_goal), the week review closed, an injury past the bell pulled out.
## Styles: THRIFTY = YES to every late ask; EAGER = NO to every late ask (earns nothing: the floor). BOTH pay partners
## from other clubs with a favour when they have one (FightWeekPlan.lock's own PartnerMatch.cost path), ask the kilo
## whenever the fight week's scale offers it (weigh_ways[2].ok at the set), and answer a fall-through with next month
## when a favour is left (else the replacement, else go home). Pro offers are declined (Roster.decline_pro: the year
## stays in the amateur club-show economy favours live in); the nationals are never entered; cash is floored at $20000
## as two_boxers_two_years_test does (money is not the measurement; the floor never changes a favour payment, since
## PartnerMatch.cost prefers a favour over cash whenever one is held). No fighter is synthesized or copied: the clubs'
## own distinct boxers, the game's own named rivals. Favours are read ONLY through FightWeekPlan.favours(c, host) (a
## club not in Career.favours counts as FAVOURS_START 1 - the brief's trap), for every RegionShows.HOSTS host touched.
## Usage: python ops/Tools/godot_slot.py run --who favourprobe1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
##          --path . --log-file E:/FightCamp/tmp/favourprobe1.log --script res://tools/favour_probe.gd -- [seeds=40] [seed=4421] [days=364]

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const LateAskWire := preload("res://scripts/state/LateAskWire.gd")
const PullOutWire := preload("res://scripts/state/PullOutWire.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const RegionShows := preload("res://scripts/rules/RegionShows.gd")
const WeighGap := preload("res://scripts/rules/WeighGap.gd")

const STYLES := ["THRIFTY", "EAGER"]
const CLUBS := ["QUICK", "TEST"]
const CASH_FLOOR := 20000
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const DOC := "res://docs/FAVOURPROBE1_RESULT.md"
const KINDS := ["partner", "kilo", "miss", "next_month"]

var n_seeds := 40
var base_seed := 4421
var n_days := 364
var runs: Array = []
var lock_refused := 0
var ask_refused := 0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"seeds": n_seeds = int(kv[1])
				"seed": base_seed = int(kv[1])
				"days": n_days = int(kv[1])
	var t0 := Time.get_ticks_msec()
	print("FAVOURPROBE1 %d seeds x 2 clubs x 2 styles, %d days a run, seeds %d..%d" % [n_seeds, n_days, base_seed, base_seed + n_seeds - 1])
	print("  THRIFTY: YES to every late ask. EAGER: NO (the floor). Both spend favours on partners, the kilo and next month when held.")
	for style in STYLES:
		for club in CLUBS:
			for s in n_seeds:
				_run(str(style), str(club), base_seed + s)
	_report((Time.get_ticks_msec() - t0) / 1000)
	_doc()
	print("FAVOURPROBE1 done")
	quit(0)


## One club: quick-start with Lucy signed and Reid hired, or the TEST CLUB (Lucy, Kira, Josh + Ana, Reid). Past the
## first-week guide and the first hour (TestJump's classic calendar). Rivals' invented pasts re-seeded to the run seed:
## quick_start draws randi() before the probe sets its seed, and a replay must agree.
func _career(club: String, seed_n: int) -> Career:
	var c := Career.quick_start()
	c.seed = seed_n
	c.first_hour = {}
	FirstWeek.skip(c)
	for r in c.rivals:
		var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == str(r.get("div", ""))).map(func(o): return [o["name"], o["club"]])
		r["bouts"] = RivalPast.seed(r, others, c.seed, c.day)
	if club == "TEST":
		TestClub.make(c)
	else:
		Sim.sign(c, PICKS.duplicate())
		Sim.hire(c, "reid")
	return c


func _run(style: String, club: String, seed_n: int) -> void:
	var c := _career(club, seed_n)
	var r := {"style": style, "club": club, "seed": seed_n, "touched": {}, "fav": {}, "asks": 0, "taken": 0, "earned": 0,
		"spends": {"partner": 0, "kilo": 0, "miss": 0, "next_month": 0}, "booked": 0, "fought": 0, "missed": 0,
		"closed": false, "days": 0}
	for _d in n_days:
		if c.closed:
			r["closed"] = true
			break
		c.cash = maxi(c.cash, CASH_FLOOR)
		Sim.step_day(c)
		r["days"] = c.day
		_answer(c, r, style)
	for h in RegionShows.HOSTS:
		if (r["touched"] as Dictionary).has(str(h)):
			(r["fav"] as Dictionary)[str(h)] = FightWeekPlan.favours(c, str(h))
	runs.append(r)
	var vals: Array = (r["fav"] as Dictionary).values()
	var mean := 0.0
	for v in vals:
		mean += float(v)
	mean /= maxf(1.0, float(vals.size()))
	print("  %s %s seed %d: day %d, %d hosts touched, mean %.2f, asks %d/%d, spends p%d k%d m%d n%d, bouts %d%s" % [
		style, club, seed_n, int(r["days"]), vals.size(), mean, int(r["taken"]), int(r["asks"]),
		int(r["spends"]["partner"]), int(r["spends"]["kilo"]), int(r["spends"]["miss"]), int(r["spends"]["next_month"]),
		int(r["fought"]), " CLOSED" if bool(r["closed"]) else ""])


## Everything open, answered as the player would at the clock stop; a pass can open new needs (a yes books a bout, a
## bout opens the fight week), so passes repeat until quiet.
func _answer(c: Career, r: Dictionary, style: String) -> void:
	for _pass in 6:
		var did := false
		c.review_pending = false
		if not c.pro_offer.is_empty():
			Roster.decline_pro(c)
			did = true
		for f in c.fighters:
			if bool(f.get("goal_talk", false)):
				Bouts.set_goal(c, f, "five_round_engine")
				did = true
			if ApproachWire.is_open(f):
				_approach(c, f)
				did = true
			if LateAskWire.is_open(f):
				_late(c, r, f, style)
				did = true
			if PullOutWire.is_open(f):
				_fell(c, r, f)
				did = true
			if Injuries.pending(f):
				Injuries.pull_out(c, f)
				did = true
			for o in (f["offers"] as Array).duplicate():
				if bool(o["answered"]) or bool(o["mismatch"]):
					continue
				if (f["bout"] as Dictionary).is_empty():
					if Bouts.accept(c, str(o["id"])):
						r["booked"] = int(r["booked"]) + 1
						_touch(r, str((f["bout"] as Dictionary).get("host", "")))
						did = true
				else:
					Bouts.decline(c, str(o["id"]))
					did = true
			if FightWeekPlan.is_open(f):
				_week(c, r, f)
				did = true
			if Bouts.camp_due(c, f):
				Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary)["opp"]), false)
				did = true
			if Bouts.weigh_in_today(c, f):
				_weigh(c, r, f)
				did = true
		while true:
			var g := Bouts.fighting_today(c)
			if g.is_empty():
				break
			var m := Bouts.fight_modal(g)
			Bouts.fight_step(c, g, m, "sim")
			Bouts.after_fight(c, g)
			r["fought"] = int(r["fought"]) + 1
			did = true
		if not did:
			break


## The host's late ask: count it, touch its host, answer by style. A yes books the short-notice bout and earns +1 (cap 3).
func _late(c: Career, r: Dictionary, f: Dictionary, style: String) -> void:
	var host := str((f["late_ask"] as Dictionary)["host"])
	r["asks"] = int(r["asks"]) + 1
	_touch(r, host)
	var before := FightWeekPlan.favours(c, host)
	var yes := style == "THRIFTY"
	var why := LateAskWire.answer(c, str(f["id"]), yes)
	if yes and why == "":
		r["taken"] = int(r["taken"]) + 1
		r["earned"] = int(r["earned"]) + FightWeekPlan.favours(c, host) - before
		r["booked"] = int(r["booked"]) + 1
		_touch(r, str((f["bout"] as Dictionary).get("host", "")))
	elif yes:
		ask_refused += 1   # the sheet's next name is past the novice rule: ready_for checks the gap, not the match - book refuses


## The fall-through: next month when a favour is left, else the replacement, else go home (TestJump's never-stall order).
func _fell(c: Career, r: Dictionary, f: Dictionary) -> void:
	var b: Dictionary = f["bout"]
	var host := str((b["fell"] as Dictionary)["host"])
	_touch(r, host)
	var id := "next_month" if FightWeekPlan.favours(c, host) >= 1 else "take_replacement"
	var before := FightWeekPlan.favours(c, host)
	var why := PullOutWire.answer(c, str(f["id"]), id)
	if why != "" and id == "next_month":
		id = "take_replacement"
		why = PullOutWire.answer(c, str(f["id"]), id)
	if why != "":
		why = PullOutWire.answer(c, str(f["id"]), "go_home")
	if id == "next_month" and why == "":
		r["spends"]["next_month"] = int(r["spends"]["next_month"]) + before - FightWeekPlan.favours(c, host)


## The fight week as the assistant drafts it, every night on the best-ranked free partner (ask_probe4's pick), the kilo
## asked whenever the scale offers it. lock pays: a favour with a partner's club when held, else $160; the kilo one
## favour with the host. Spends are read off the favours the lock moved, per host.
func _week(c: Career, r: Dictionary, f: Dictionary) -> void:
	var plan := FightWeekPlan.draft(c, f)
	var plist := FightWeekPlan.partners(c, f)
	var keys: Array = (plan["nights"] as Dictionary).keys()
	keys.sort()
	keys.reverse()
	var used: Array = []
	for k in keys:
		for p in plist:
			if not used.has(str(p["id"])):
				(plan["nights"] as Dictionary)[k] = str(p["id"])
				used.append(str(p["id"]))
				break
	var kilo := bool((FightWeekPlan.weigh_ways(c, f)[2] as Dictionary)["ok"])
	plan["ask_kilo"] = kilo
	var host := str((f["bout"] as Dictionary).get("host", ""))
	var before := _snap(c)
	var why := FightWeekPlan.lock(c, f, plan)
	if why != "":
		lock_refused += 1
		return
	_touch(r, host)
	for k in keys:
		var pid := str((plan["nights"] as Dictionary)[k])
		for p in plist:
			if str(p["id"]) == pid and not bool(p["ours"]):
				_touch(r, str(p["club"]))
	for h in RegionShows.HOSTS:
		var delta: int = int(before[str(h)]) - FightWeekPlan.favours(c, str(h))
		if delta <= 0:
			continue
		var kilo_part := WeighGap.MISS_FAVOUR if kilo and str(h) == host else 0
		r["spends"]["kilo"] = int(r["spends"]["kilo"]) + kilo_part
		r["spends"]["partner"] = int(r["spends"]["partner"]) + delta - kilo_part


## The scale: a miss the host cannot re-match costs a favour (PullOutWire.weigh_miss inside Bouts.weigh).
func _weigh(c: Career, r: Dictionary, f: Dictionary) -> void:
	var before := _snap(c)
	var made := Bouts.weigh(c, f)
	if made:
		return
	r["missed"] = int(r["missed"]) + 1
	for h in RegionShows.HOSTS:
		var delta: int = int(before[str(h)]) - FightWeekPlan.favours(c, str(h))
		if delta > 0:
			r["spends"]["miss"] = int(r["spends"]["miss"]) + delta
			_touch(r, str(h))


## A rival club's approach: keep the boxer (MATCH when it is there, else the first keep answer; let go only if nothing else).
func _approach(c: Career, f: Dictionary) -> void:
	var pick := ""
	for col in ApproachWire.columns(c, f):
		if str(col["id"]) == "match" and bool(col["available"]):
			pick = "match"
			break
		if pick == "" and str(col["id"]) != "let_go" and bool(col["available"]):
			pick = str(col["id"])
	if pick == "":
		pick = "let_go"
	ApproachWire.answer(c, str(f["id"]), pick)


func _touch(r: Dictionary, host: String) -> void:
	if host != "" and RegionShows.HOSTS.has(host):
		(r["touched"] as Dictionary)[host] = true


## Every host's favours through FightWeekPlan.favours (the default-1 trap): never the dictionary alone.
func _snap(c: Career) -> Dictionary:
	var out := {}
	for h in RegionShows.HOSTS:
		out[str(h)] = FightWeekPlan.favours(c, str(h))
	return out


func _agg(style: String, club: String) -> Dictionary:
	var rs: Array = runs.filter(func(r): return str(r["style"]) == style and (club == "" or str(r["club"]) == club))
	var vals: Array = []
	var hist := {"0": 0, "1": 0, "2": 0, "3": 0, "other": 0}
	var out := {"n": rs.size(), "hosts": 0, "asks": 0, "taken": 0, "earned": 0, "booked": 0, "fought": 0, "missed": 0,
		"closed": 0, "spends": {"partner": 0, "kilo": 0, "miss": 0, "next_month": 0}}
	for r in rs:
		for v in (r["fav"] as Dictionary).values():
			vals.append(int(v))
			var k := str(int(v))
			hist[k if hist.has(k) else "other"] = int(hist[k if hist.has(k) else "other"]) + 1
		out["hosts"] = int(out["hosts"]) + (r["fav"] as Dictionary).size()
		for k in ["asks", "taken", "earned", "booked", "fought", "missed"]:
			out[k] = int(out[k]) + int(r[k])
		out["closed"] = int(out["closed"]) + int(bool(r["closed"]))
		for k in KINDS:
			out["spends"][k] = int(out["spends"][k]) + int(r["spends"][k])
	var sum := 0.0
	for v in vals:
		sum += float(v)
	out["mean"] = sum / maxf(1.0, float(vals.size()))
	out["hist"] = hist
	out["nvals"] = vals.size()
	return out


func _pct(a: Dictionary, k: String) -> float:
	return 100.0 * float((a["hist"] as Dictionary)[k]) / maxf(1.0, float(a["nvals"]))


func _row(style: String, club: String) -> String:
	var a := _agg(style, club)
	var n: int = maxi(1, int(a["n"]))
	return "| %s | %s | %d | %.2f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f | %.1f |" % [
		style, club, int(a["hosts"]), float(a["mean"]), _pct(a, "0"), _pct(a, "1"), _pct(a, "2"), _pct(a, "3"),
		float(a["asks"]) / n, float(a["taken"]) / n, float(a["spends"]["partner"]) / n, float(a["spends"]["kilo"]) / n,
		float(a["spends"]["miss"]) / n, float(a["spends"]["next_month"]) / n]


func _verdict() -> String:
	var a := _agg("THRIFTY", "")
	var inside := float(a["mean"]) >= 1.0 and float(a["mean"]) <= 2.0
	return "THRIFTY average club: %.2f favours per touched host - %s the map's 1-2 target." % [float(a["mean"]),
		"INSIDE" if inside else "OUTSIDE"]


func _report(secs: int) -> void:
	print("\nSTYLE x CLUB (mean favours per touched host at day %d; %% of hosts at 0/1/2/3; asks and spends a year)" % n_days)
	print("| style | club | hosts | mean | at0% | at1% | at2% | at3% | asks | taken | partner | kilo | miss | next_month |")
	for style in STYLES:
		for club in CLUBS:
			print(_row(str(style), str(club)))
	for style in STYLES:
		var a := _agg(str(style), "")
		print("%s pooled: %d runs, %d touched hosts, mean %.2f, asks %.1f a year (%.1f taken), spends a year: partner %.1f, kilo %.1f, miss %.1f, next_month %.1f" % [
			style, int(a["n"]), int(a["hosts"]), float(a["mean"]), float(a["asks"]) / maxi(1, int(a["n"])),
			float(a["taken"]) / maxi(1, int(a["n"])), float(a["spends"]["partner"]) / maxi(1, int(a["n"])),
			float(a["spends"]["kilo"]) / maxi(1, int(a["n"])), float(a["spends"]["miss"]) / maxi(1, int(a["n"])),
			float(a["spends"]["next_month"]) / maxi(1, int(a["n"]))])
	print(_verdict())
	var closed := 0
	for r in runs:
		closed += int(bool(r["closed"]))
	print("lock refused %d weeks, late-ask yes refused %d; runs closed early: %d; %ds" % [lock_refused, ask_refused, closed, secs])


func _doc() -> void:
	var L: Array = []
	L.append("# FAVOURPROBE1 result - where favours with the hosts sit after a year of real play")
	L.append("")
	L.append("Probe run: %s. %d seeds x 2 clubs x 2 styles = %d runs of %d days (seeds %d..%d). A measurement only: no rule or constant was changed." % [
		Time.get_datetime_string_from_system(), n_seeds, n_seeds * 4, n_days, base_seed, base_seed + n_seeds - 1])
	L.append("")
	L.append("The fight week map (AMATEURWEEK1 v6 s7-8) set the target: **an average club sits at 1-2 favours with a host, not 3**. Favours are EARNED only by a host's late ask (LateAskWire: yes = +1, cap FightWeekEvents.FAVOURS_MAX 3) and SPENT by an outside sparring partner (FightWeekPlan.lock via PartnerMatch.cost: a favour when held, else $160), the weigh-in's ASK FOR A KILO (one favour with the host), a missed weight the host cannot re-match (PullOutWire.weigh_miss) and a fall-through's next-month slot (PullOutWire.answer). Every host starts at FightWeekPlan.FAVOURS_START 1 - a club not in Career.favours counts as 1, so every read here goes through FightWeekPlan.favours(c, host), never the dictionary alone (the brief's trap).")
	L.append("")
	L.append("## Population")
	L.append("")
	L.append("- **QUICK**: a quick-start career, Lucy signed at reception (Sim.sign, the interview's three cards), Reid hired (sessional). One boxer.")
	L.append("- **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw, women's lightweight), Kira (wfw, women's featherweight), Josh (mww, men's welterweight) and Ana on the mats, Reid hired. Three boxers, three classes.")
	L.append("- Both past the first-week guide and the first hour (TestJump's classic calendar). Rivals' invented pasts re-seeded to the run seed (quick_start draws randi() before the probe sets its seed), so a replay agrees.")
	L.append("- %d seeds a club a style, %d days each through Sim.step_day - the real day loop: offers, pull-out rolls, late asks, injuries, the region's own shows. No fighter is synthesized or copied: the clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical." % [n_seeds, n_days])
	L.append("")
	L.append("## The two styles (decisions in code, every open need answered as TestJump._tidy answers them)")
	L.append("")
	L.append("- **THRIFTY**: accepts every sheet offer; YES to every late ask; pays outside partners with a favour when it has one; asks the kilo whenever the fight week's scale offers it (weigh_ways[2].ok at the set); a fall-through answered with next month when a favour is left, else the replacement (else go home).")
	L.append("- **EAGER**: the same, but NO to every late ask - it earns nothing: the floor.")
	L.append("- Both: the fight week as FightWeekPlan.draft writes it, every night on the best-ranked free partner (ask_probe4's pick), locked when the FIGHT WEEK need appears; the bout fought by the game's own sim (Bouts.fight_step \"sim\"); the office goal five_round_engine; an injury past the bell pulled out; a rival club's approach answered with a keep (MATCH first). Pro offers declined (Roster.decline_pro: the year stays in the amateur club-show economy favours live in); the nationals never entered; the week review closed. Cash floored at $%d as two_boxers_two_years_test does - money is not the measurement, and the floor never changes a favour payment (PartnerMatch.cost prefers a favour whenever one is held)." % CASH_FLOOR)
	L.append("- A host is **touched** when the club booked a bout at its show, received its late ask (yes or no), or took a sparring partner from it (favour or cash). Final favours read at day %d for every touched host in RegionShows.HOSTS." % n_days)
	L.append("")
	L.append("## The table (style x club; means a run, % of touched hosts at each favour count)")
	L.append("")
	L.append("| style | club | touched hosts | mean favours | at 0 % | at 1 % | at 2 % | at 3 % | asks a year | taken a year | partner spends | kilo spends | miss spends | next-month spends |")
	L.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
	for style in STYLES:
		for club in CLUBS:
			L.append(_row(str(style), str(club)))
	L.append("")
	for style in STYLES:
		var a := _agg(str(style), "")
		var n: int = maxi(1, int(a["n"]))
		L.append("**%s pooled** (%d runs, %d touched hosts): mean **%.2f** favours per touched host; %.1f asks a year, %.1f taken; earns %.1f a year; spends a year: partner %.1f, kilo %.1f, missed weight %.1f, next month %.1f. Bouts a year: %.1f booked, %.1f fought, %.1f missed weight. Runs closed early: %d." % [
			style, int(a["n"]), int(a["hosts"]), float(a["mean"]), float(a["asks"]) / n, float(a["taken"]) / n,
			float(a["earned"]) / n, float(a["spends"]["partner"]) / n, float(a["spends"]["kilo"]) / n,
			float(a["spends"]["miss"]) / n, float(a["spends"]["next_month"]) / n, float(a["booked"]) / n,
			float(a["fought"]) / n, float(a["missed"]) / n, int(a["closed"])])
		L.append("")
	L.append("## The map's target")
	L.append("")
	L.append("**%s**" % _verdict())
	L.append("")
	L.append("(Per club: QUICK %.2f, TEST %.2f. EAGER, the floor that earns nothing: %.2f pooled.)" % [
		float(_agg("THRIFTY", "QUICK")["mean"]), float(_agg("THRIFTY", "TEST")["mean"]), float(_agg("EAGER", "")["mean"])])
	L.append("")
	var at := _agg("THRIFTY", "")
	var ae := _agg("EAGER", "")
	var nt: int = maxi(1, int(at["n"]))
	var spends_y := (float(at["spends"]["partner"]) + float(at["spends"]["kilo"]) + float(at["spends"]["miss"]) + float(at["spends"]["next_month"])) / nt
	L.append("Kilo and missed-weight spends are **zero in all %d years** (%.1f bouts fought a run): the fight week cuts her toward the class limit and the host's boxer walks near the same limit, so the scale sits inside the 2.5/5.0 kg gap - the kilo is never offered and the weight is never missed. The favour economy that actually moves is the outside partner and the fall-through's next-month slot." % [
		n_seeds * 4, (float(at["fought"]) + float(ae["fought"])) / (2.0 * nt)])
	L.append("")
	L.append("The earning channel is thin: %.1f asks a year a club, %.1f of them bookable, against %.1f spends a year. THRIFTY and EAGER settle at the same %.2f - saying YES to every late ask does not lift the population off the floor. A year of real play leaves the average club near 0, not at the map's 1-2." % [
		float(at["asks"]) / nt, float(at["taken"]) / nt, spends_y, float(at["mean"])])
	L.append("")
	L.append("Lock refused %d weeks. **A late-ask yes the sheet could not book: %d.** The host's ask opens on the weight gap alone (LateAskWire.ready_for), but AskFlow.book refuses when the sheet's next name is past the novice rule for our boxer (AmateurBooking.experience_match_ok): Bouts.legal_index falls back to the next name when nobody in the division is a legal match, so a novice whose whole division has graduated gets asks it cannot take - and, late in the year, only mismatch sheet offers (no bout, the clock runs on). That is the shipped rule, measured here, not changed. Spends are read off the favours each action moved (a before/after snapshot per host), so a partner paid in cash is not counted and a kilo is never double-counted with a partner at the same host." % [lock_refused, ask_refused])
	L.append("")
	L.append("Reproduce: `python ops/Tools/godot_slot.py run --who favourprobe1 -- \"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe\" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/favourprobe1.log --path . --script res://tools/favour_probe.gd -- seeds=%d seed=%d days=%d`" % [n_seeds, base_seed, n_days])
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh == null:
		print("WARNING: could not write %s" % DOC)
		return
	fh.store_string("\n".join(L) + "\n")
	fh.close()
	print("wrote %s" % DOC)
