extends SceneTree
## S324 update 27 balance-check (make-it-a-game plan "How each is checked"): plays 26-week careers through the real game
## (Main.act, the same path as golden_path_test) for two players and reports how often the gym closes.
##   careless - each of four careless habits on with chance CARELESS_P per career (seeded): hires the full-time head coach,
##              takes unsafe offers too, hard camps, signs no sponsor, trains Hard every week (S326) - a population of
##              careless players, not one player
##   sensible - hires the sessional coach, takes only safe offers, standard camps with film, signs every sponsor on offer,
##              trains Normal, rests the week after a bout and comes back through a Light week (S326)
## Population: Lucy (quick start) with each stat jittered +-4 and the gym's reputation 10 +-3, seed = career index; the
## same seeds for both players. Plan bounds: careless closes in 15-40 % of careers by week 26, sensible under 5 %.
## S327 bounds after "Money too harsh" (8 weeks below $0 to close, a loss costs 1-2 members): careless closes 5-25 %,
## sensible 0 %; injured at least once: careless 50-80 %, sensible 30-50 % (real rates alone give ~43 %: 1.3 per 1000 h
## training over 26 weeks ~29 %, ~3.7 bouts at ~6 % ~20 %; the bound moved, the rates did not).
## S397 money bites (ops/research/MONEY_BITES_S397.md 5, 9): `money=1` adds where the cash came from and went
## (harness_money.gd), `pro=1` takes the pro offer and books pro fights, `sign=1` signs a second boxer from week 13, and
## both players spend (harness_spend.gd; careless gains the `spender` habit). Bounds at 104 weeks, n=10, money=1 pro=1
## sign=1: sensible closes 0; its median cash at each quarter from week 13 on is 1-4 months of costs; it owns 2-4
## upgrades and 1-4 staff roles at the end; careless closes 20-80% of careers, the median close after week 26.
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/career_harness.gd -- n=20 weeks=26
## Prints CAREER lines and a HARNESS summary per player.

const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const HarnessMoney := preload("res://tools/harness_money.gd")
const HarnessSpend := preload("res://tools/harness_spend.gd")

const CARELESS_P := 0.5
## S397 money bites: `spender` buys whatever the cash covers (HarnessSpend); the sensible player spends by its own rule.
const HABITS := ["head_coach", "unsafe_bouts", "hard_camps", "no_sponsors", "hard_weeks", "spender"]

var main: Node
var args := {}
var habits := {}


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := a.split("=", true, 1)
		if kv.size() == 2:
			args[kv[0]] = kv[1]
	var n := int(args.get("n", "20"))
	var weeks := int(args.get("weeks", "26"))
	var t0 := Time.get_ticks_msec()
	for policy in ["careless", "sensible"]:
		var rows: Array = []
		var first := int(args.get("first", "0"))   # S397: one career per process (first=k n=1) - see harness_sum.py
		for i in range(first, first + n):
			rows.append(await _career(policy, i, weeks))
		_summary(policy, rows, weeks)
		if args.get("money", "0") == "1":
			HarnessMoney.report(policy, rows)
	print("HARNESS done in %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


func _career(policy: String, i: int, weeks: int) -> Dictionary:
	main = load("res://scenes/Main.tscn").instantiate()
	main.save_path = "user://harness.save"
	main.no_render = args.get("render", "0") != "1"   # S397: rules only (render=1 builds every screen, as before)
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	var rng := RandomNumberGenerator.new()
	rng.seed = i * 7919 + 1
	c.reputation = 10 + rng.randi_range(-3, 3)
	c.seed = i * 7919 + 1   # S325 the career's dice (injuries): one per career, the same for both players
	if args.get("overdraft", "0") == "1":   # S399 force the overdraft on for this run
		c.overdraft_on = true
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
		habits[h] = policy == "careless" and hr.randf() < float(args.get("p", str(CARELESS_P)))
	main.act("hire", "hale" if habits["head_coach"] else "reid")
	var min_cash := c.cash
	var bouts := 0
	var guard := 0
	var hm := HarnessMoney.new()
	while c.day < weeks * 7 and not c.closed and guard < 1200:
		guard += 1
		_decide(policy, c)
		if not main.no_render:
			await process_frame   # S398 Menus: one frame after the stop's clicks too, as a player's clicks have
		if c.closed:
			break
		main.run_to_stop(60)
		if not main.no_render:
			await process_frame   # S398 Menus: hundreds of renders in one frame overflowed Godot's deferred-call queue
		hm.sample(c)
		min_cash = mini(min_cash, c.cash)
		bouts = c.results.size()
	hm.finish(c)
	var f := c.fighter()
	var on: Array = HABITS.filter(func(h): return bool(habits[h]))
	# S325 update 28: her injuries this career (the news lines Injuries._hurt writes), split by where they came from.
	var hurt_bout := c.news.filter(func(x): return str(x["t"]).contains("is hurt in the fight") or str(x["t"]).contains("is suspended")).size()
	var hurt_train := c.news.filter(func(x): return str(x["t"]).contains("is hurt in training")).size()
	var pulled := c.news.filter(func(x): return str(x["t"]).contains("for the empty slot") and str(x["t"]).contains(" is out of the ")).size()
	var row := {"policy": policy, "i": i, "habits": on, "closed": c.closed, "week": Clock.week_of(c.day), "cash": c.cash, "min_cash": min_cash,
		"w": int(f.get("w", 0)), "l": int(f.get("l", 0)), "bouts": bouts, "members": c.members, "rep": c.reputation,
		"inj_bout": hurt_bout, "inj_train": hurt_train, "pulled": pulled,
		"money": hm.as_row(), "roster": c.fighters.size(), "pros": c.fighters.filter(func(x): return bool(x.get("pro", false))).size()}
	print("CAREER %s #%d habits=%s closed=%s week=%d cash=%d min=%d record=%d-%d members=%d rep=%d injuries bout=%d training=%d pulled=%d" % [
		policy, i, ",".join(on), str(c.closed), row["week"], c.cash, min_cash, row["w"], row["l"], c.members, c.reputation, hurt_bout, hurt_train, pulled])
	print("CAREERJSON " + JSON.stringify(row))   # S397 harness_sum.py aggregates these across processes
	if args.get("news", "0") == "1":   # S397: the career's own news, oldest first, for a stalled career
		var own_news := c.news.filter(func(n): return bool(n.get("own", false)) and not str(n["t"]).begins_with("Two bout offers"))
		own_news.reverse()
		for x in own_news.slice(0, 70):
			print("  NEWS d%d %s" % [int(x["d"]), str(x["t"]).left(150)])
	main.queue_free()
	await process_frame
	return row


## One stop's decisions for this player (the golden path's steady player, with the two players' differences).
func _decide(policy: String, c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	HarnessSpend.decide(main, c, policy == "sensible", bool(habits.get("spender", false)))
	if not habits["no_sponsors"]:
		for d in c.deals:
			if str(d["state"]) == "offer":
				main.act("deal", str(d["id"]))
	if not c.pro_offer.is_empty():
		main.act("prooffer", str(c.pro_offer["fid"]))
		main.act("turnpro" if args.get("pro", "0") == "1" else "declinepro")
	# S397 money=1 runs: a second fighter from scouting once the gym has run a quarter (both players).
	if args.get("sign", "0") == "1" and c.fighters.size() < 2 and c.day >= 7 * 13:
		for p in c.prospects:
			if str(p["state"]) == "scout":
				main.act("invite", str(p["id"]))
				break
	for p in c.prospects:
		if str(p["state"]) == "invited" and c.day >= int(p["trial_day"]):
			main.act("trial", str(p["id"]))
			main.act("signprospect")
	for f in c.fighters:
		# S327 (Q-S294-46) hurt before a booked bout: the careless player with unsafe_bouts lets her fight hurt, else pull out.
		if Injuries.pending(f):
			main.act("fighthurt" if habits["unsafe_bouts"] else "pullout", str(f["id"]))
		# S326 update 29 the weekly load: careless with hard_weeks trains Hard every week; the sensible player trains Normal
		# (camp included) and rests the week after a bout. S380: NO-OP since S354/S380 - the sim reads the week's sessions
		# (WeekPlan) and the camp's protocol, never load_setting; hard_weeks needs the planner's Hard mornings to mean anything.
		var want :="hard" if habits["hard_weeks"] else "normal"
		if policy == "sensible":
			var mine: Array = c.results.filter(func(r): return str(r.get("fid", "")) == str(f["id"]))
			var since := c.day - int(mine[0]["d"]) if not mine.is_empty() else 99
			want = "rest" if since < 7 else ("light" if since < 14 else "normal")   # back up through Light, never a jump
		if str(f.get("load_setting", "")) != want:
			main.act("trainload", "%s|%s" % [f["id"], want])
		for o in f["offers"]:
			if bool(o["answered"]) or not (f["bout"] as Dictionary).is_empty():
				continue
			if bool(o["mismatch"]) and not habits["unsafe_bouts"]:
				continue
			main.act("accept", str(o["id"]))
		for o in f["offers"]:
			if not bool(o["answered"]):
				main.act("declineOffer", str(o["id"]))
		if ProLadder.on_ladder(c, f) and (f["bout"] as Dictionary).is_empty():
			var rows := ProLadder.offer_rows(c, f)
			var order := ["payday", "above", "tune"] if habits["unsafe_bouts"] else ["above", "tune", "payday"]
			for kind in order:
				var pick := rows.filter(func(r): return str(r["kind"]) == kind)
				if not pick.is_empty():
					main.act("probook", "%s:%d:o" % [f["id"], int(pick[0]["opp"]["id"])])
					break
		if Bouts.camp_due(c, f):
			main.act("camp", str(f["id"]))
			main.modal["protocol"] = 3 if habits["hard_camps"] else 2
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


func _summary(policy: String, rows: Array, weeks: int) -> void:
	var closed := rows.filter(func(r): return bool(r["closed"]))
	var cash: Array = rows.map(func(r): return int(r["cash"]))
	cash.sort()
	var wins := 0.0
	var bouts := 0.0
	for r in rows:
		wins += float(r["w"])
		bouts += float(r["bouts"])
	var close_weeks: Array = closed.map(func(r): return int(r["week"]))
	print("HARNESS %s n=%d weeks=%d closed=%d (%.0f %%) close weeks %s | cash end median %d (min %d, max %d) | bouts %.1f wins %.1f a career" % [
		policy, rows.size(), weeks, closed.size(), 100.0 * closed.size() / maxf(1.0, rows.size()), str(close_weeks),
		int(cash[cash.size() / 2]), int(cash[0]), int(cash[cash.size() - 1]), bouts / rows.size(), wins / rows.size()])
	var hurt := rows.filter(func(r): return int(r["inj_bout"]) + int(r["inj_train"]) > 0)
	var ib := 0
	var it := 0
	for r in rows:
		ib += int(r["inj_bout"])
		it += int(r["inj_train"])
	print("HARNESS %s injured at least once %d (%.0f %%) | bout injuries %d, training %d, pulled out %d" % [policy, hurt.size(),
		100.0 * hurt.size() / maxf(1.0, rows.size()), ib, it, rows.reduce(func(a, r): return a + int(r["pulled"]), 0)])
	for h in HABITS:
		var with_h := rows.filter(func(r): return (r.get("habits", []) as Array).has(h))
		if with_h.is_empty():
			continue
		print("HARNESS %s habit %s: %d careers, closed %d" % [policy, h, with_h.size(), with_h.filter(func(r): return bool(r["closed"])).size()])
