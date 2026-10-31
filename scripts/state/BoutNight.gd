extends RefCounted
## S326 fight night, split out of Bouts.gd (it had reached the 500-line cap): the bout from the first bell to the
## scorecards - rounds of six exchanges (LiveRound), the corner's calls and jobs, standing counts and stoppages
## (Knockdowns), the result (record, money, members, morale, goals) and the injury roll. Bouts keeps the offers, camp
## and weigh-in, and delegates its fight-night entry points here so callers did not change.

const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FightWords := preload("res://scripts/state/FightWords.gd")
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const CoachNotes := preload("res://scripts/rules/CoachNotes.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const BoutBurn := preload("res://scripts/rules/BoutBurn.gd")
const BodyReport := preload("res://scripts/rules/BodyReport.gd")
const BodyTrack := preload("res://scripts/rules/BodyTrack.gd")
const NOTES_PATH := "res://assets/data/fight_habits.json"

static var _notes_bank: Dictionary = {}


## The fight-night moment: {type, fid, step: tape|round|result, round, rounds, total, ...}.
static func fight_modal(f: Dictionary) -> Dictionary:
	return {"type": "fight", "fid": f["id"], "step": "tape", "round": 0, "rounds": [], "total": rounds_of(f)}


## Rounds in her booked bout: 3 for an amateur, 4 for her pro debut.
static func rounds_of(f: Dictionary) -> int:
	return int((f.get("bout", {}) as Dictionary).get("rounds", BoutRules.ROUNDS))


## Advances fight night: "start" opens round 1, "corner:<call>[|<habit>]" the next round on that plan (and that habit
## fixed, S309), "shout:<call>" fights the
## open round's next 30 seconds ("shout:" = say nothing), "sim" the whole bout, "rest" the rest of it (the corner's calls;
## the 3D view's SKIP BOUT), "end" the scorecards. S308: a round is six exchanges (LiveRound); opening one fights its first
## 30 seconds on the plan, so the corner always has a clue to read before the first shout.
static func fight_step(c: Career, f: Dictionary, m: Dictionary, a: String) -> void:
	if a == "start" or a == "sim":
		m["step"] = "round"
		m["round"] = 0
		m["rounds"] = []
		_open(c, f, m, "")
	elif a.begins_with("corner:") and not stopped(m) and LiveRound.live(m).is_empty():
		# S309: "corner:<call>|<habit>" also fixes one habit for the round. S310 the other corner jobs ride as labelled
		# parts: "|fix=<habit>|setup=<combo>@<gap>|talk=<calm|fire|truth>|rec=water:2,ice:1,head:0".
		var parts := a.trim_prefix("corner:").split("|")
		var jobs := corner_jobs(parts)
		_open(c, f, m, parts[0], str(jobs.get("fix", "")), jobs)
	elif a.begins_with("shout:"):
		_shout(c, f, m, a.trim_prefix("shout:"))
	elif a == "round_out":
		_shout_out(c, f, m)
	if a == "sim" or a == "rest":
		_shout_out(c, f, m)
		while int(m["round"]) < rounds_of(f) and not stopped(m):
			_open(c, f, m, BoutRules.auto_corner(f["stats"]))
			_shout_out(c, f, m)
	if a == "sim" or a == "rest" or a == "end":
		_finish(c, f, m)


## The corner action's parts after the call: a bare second part is the S309 habit; "key=value" parts are S310 jobs.
static func corner_jobs(parts: PackedStringArray) -> Dictionary:
	var jobs := {}
	for i in range(1, parts.size()):
		var p := str(parts[i])
		if not p.contains("="):
			jobs["fix"] = p
			continue
		var kv := p.split("=", true, 1)
		match kv[0]:
			"fix", "talk":
				jobs[kv[0]] = kv[1]
			"setup":
				var sg := kv[1].split("@")
				if sg.size() == 2:
					jobs["setup"] = {"combo": sg[0], "gap": sg[1]}
			"rec":
				var pts := {}
				for item in kv[1].split(",", false):
					var q := item.split(":")
					if q.size() == 2:
						pts[q[0]] = int(q[1])
				jobs["rec"] = pts
	return jobs


static func _open(c: Career, f: Dictionary, m: Dictionary, plan: String, fix: String = "", jobs: Dictionary = {}) -> void:
	m["round"] = int(m["round"]) + 1
	var n := int(m["round"])
	var e := _energy(f, n, plan)
	# S310 the second's recover points on the round she starts; a hurt she was not cleared of comes out with her.
	var rounds: Array = m.get("rounds", [])
	if n > 1 and not rounds.is_empty():
		var last: Dictionary = rounds[-1]
		var body: Dictionary = f["bout"].get("body", {"a": 0, "b": 0})
		var rec := CornerJobs.recover(jobs.get("rec", {}), float(e.get("a", 100.0)), int(body.get("a", 0)), bool(last.get("hurt_at_bell", false)))
		e["a"] = float(e.get("a", 100.0)) + float(rec["energy"])
		e["a_end"] = float(e.get("a_end", 100.0)) + float(rec["energy"])
		body["a"] = int(body.get("a", 0)) - int(rec["body"])
		jobs["hurt"] = bool(rec["hurt"])
		jobs["did"] = rec
	LiveRound.open(c, f, m, n, plan, e, fix, jobs)
	LiveRound.live(m)["did"] = jobs.get("did", {})
	_shout(c, f, m, "")


## One exchange; the sixth closes the round into m["rounds"] with its lines and counts.
static func _shout(c: Career, f: Dictionary, m: Dictionary, call: String) -> void:
	var r := LiveRound.exchange(c, f, m, call)
	if r.is_empty():
		return
	_lines(c, f, r)
	(m["rounds"] as Array).append(r)
	_counts(c, f, m, r)


static func _shout_out(c: Career, f: Dictionary, m: Dictionary) -> void:
	while not LiveRound.live(m).is_empty():
		_shout(c, f, m, "")


## "RSC" / "KO" when the referee stopped the bout in its last round, else "".
static func stopped(m: Dictionary) -> String:
	var rounds: Array = m.get("rounds", [])
	return "" if rounds.is_empty() else str((rounds[-1] as Dictionary).get("stopped", ""))


## Fight model step 2 (Knockdowns, Qwen KNOCKDOWN1): the round's loser may take standing counts; three in a round, four
## in the bout, or a count she does not beat, and the referee stops it. Damage and counts carry across the bout.
static func _counts(c: Career, f: Dictionary, m: Dictionary, r: Dictionary) -> void:
	var opp: Dictionary = f["bout"]["opp"]
	var rating := float(opp.get("rating", 60.0))
	var st: Dictionary = f["stats"]
	var sides := {
		"a": {"power": float(st["power"]), "chin": float(st["chin"]), "heart": float((f.get("personality", {}) as Dictionary).get("heart", 55.0))},
		"b": {"power": rating, "chin": rating - (8.0 if str(opp.get("weak", "")).to_lower().contains("chin") else 0.0), "heart": 55.0},
	}
	var so_far: Dictionary = m.get("counts", {"a": 0, "b": 0})
	var rng := RandomNumberGenerator.new()
	rng.seed = c.day * 53 + int(r["n"]) * 11 + c.fighters.find(f) * 2003
	var loser := "b" if bool(r["won"]) else "a"
	var k := Knockdowns.round_counts(RoundScript.margin(r), loser, sides, m.get("damage", {"a": 0.0, "b": 0.0}), so_far, rng)
	m["damage"] = k["damage"]
	so_far[loser] = int(so_far[loser]) + int(k["counts"])
	m["counts"] = so_far
	r["counts"] = int(k["counts"])
	r["down"] = loser if int(k["counts"]) > 0 else ""
	r["stopped"] = str(k["how"])
	if int(k["counts"]) == 0:
		return
	var name := str(f["first"]) if loser == "a" else str(opp["first"])
	var lines: Array = r["lines"]
	lines.append("%s is caught and takes a standing count%s." % [name, "" if int(k["counts"]) == 1 else " - %d of them" % int(k["counts"])])
	if str(k["how"]) == "KO":
		lines.append("%s goes down and does not beat the count." % name)
	elif str(k["how"]) == "RSC":
		lines.append("The referee waves it off: %s has taken enough." % name)


static func _lines(c: Career, f: Dictionary, r: Dictionary) -> void:
	var opp: Dictionary = f["bout"]["opp"]
	var camp: Dictionary = f["camp"]
	var n := int(r["n"])
	var subs := {"her": f["first"], "opp": opp["first"], "threat": str(opp["threat"]).to_lower(), "round": n,
		"focus": str(Data.LABEL.get(camp.get("focus", ""), "")).to_lower()}
	r["lines"] = FightWords.round_lines(str(opp["style"]), bool(r["won"]), str(r["corner"]), subs, c.day + n * 13)
	var ln: Array = r["landed"]
	(r["lines"] as Array).append("Exchanges %d-%d; punches landed %d-%d." % [int(r["won_n"]), Exchanges.EXCHANGES - int(r["won_n"]), int(ln[0]), int(ln[1])])
	if int(r["calls"]) > 0:
		(r["lines"] as Array).append("Your shouts that worked: %d of %d." % [int(r["worked"]), int(r["calls"])])


## S302 combos + energy (operator: "combos should also be associated with energy (stamina) in the fight"). Both tanks run
## across the bout (f["bout"]["energy"]): her combos and the corner's call spend hers, her conditioning sets the rate and the
## 60 s break gives some back (Combos). Her drilled combos add an edge that shrinks as she tires; an empty tank costs
## power. The opponent tires too (her penalty helps us); her combos add no edge, her rating already holds her skill.
## Returns {a, b (energy at the bell to start the round), a_end, b_end, bonus (power points for play_round)}.
static func _energy(f: Dictionary, n: int, corner: String) -> Dictionary:
	var fb: Dictionary = f["bout"]
	if n == 1 or not fb.has("energy"):
		# S327 she fights hurt (the player's call, Injuries.fight_hurt): less in her tank from the first bell.
		fb["energy"] = {"a": Combos.TANK - float(fb.get("hurt", 0.0)), "b": Combos.TANK, "qa": 0.0, "qb": 0.0}
	var op := RoundStyle.from_opponent(fb["opp"])
	var mine: Dictionary = f.get("combos", {})
	var cond_a := float(f["stats"].get("conditioning", 55.0))
	var cond_b := RoundStyle.stat(op, "conditioning")
	var a0 := float(fb["energy"]["a"])
	var b0 := float(fb["energy"]["b"])
	# S303 (John J-COMBOENERGY1): the rest refills half the fast debt; the slow part stays spent all fight.
	var ra := Combos.after_round(a0, float(fb["energy"].get("qa", 0.0)), Combos.round_spend(mine, corner, cond_a), cond_a)
	var rb := Combos.after_round(b0, float(fb["energy"].get("qb", 0.0)), Combos.round_spend(op["combos"], "", cond_b), cond_b)
	var a1 := float(ra["bell"])
	var b1 := float(rb["bell"])
	fb["energy"] = {"a": ra["next"], "b": rb["next"], "qa": ra["debt"], "qb": rb["debt"]}
	return {"a": a0, "b": b0, "a_end": a1, "b_end": b1,
		"bonus": Combos.edge(mine, a0) - Combos.tired_penalty(a1) + Combos.tired_penalty(b1)}


static func _finish(c: Career, f: Dictionary, m: Dictionary) -> void:
	var opp: Dictionary = f["bout"]["opp"]
	var camp: Dictionary = f["camp"]
	var rounds: Array = m["rounds"]
	var won := rounds.filter(func(r): return bool(r["won"])).size()
	var pro := bool(f["bout"].get("pro", false))
	var cards := BoutRules.scorecards(won, rounds.size())
	var outcome := BoutRules.verdict(cards)
	# A stoppage settles it whatever the cards say: the boxer still standing wins.
	var stop := stopped(m)
	m["stopped"] = stop
	if stop != "":
		outcome = "loss" if str((rounds[-1] as Dictionary)["down"]) == "a" else "win"
	# S328 a championship bout must have a winner (amateur judges pick one on every card): level cards go to the boxer who
	# took the last round.
	if outcome == "draw" and f["bout"].has("champ"):
		outcome = "win" if bool((rounds[-1] as Dictionary)["won"]) else "loss"
	var win := outcome == "win"
	var focus_label := str(Data.LABEL.get(camp.get("focus", ""), ""))
	var why := BoutRules.why(rounds, not camp.is_empty(), int(camp.get("protocol", 0)), focus_label, int(f["bout"]["film"]),
		str(opp["threat"]).to_lower(), str(f["first"]))
	m["step"] = "result"
	m["win"] = win
	m["outcome"] = outcome
	m["pro"] = pro
	m["cards"] = cards
	m["why"] = why
	# S329 update 31: the debut pays from the tickets she sold before the bell (the members before tonight's result).
	var tickets: Dictionary = Roster.debut_night(c, f) if pro and bool(f["bout"].get("tickets", false)) else {}
	var rec := "pro_" if pro else ""
	if outcome == "win":
		f[rec + "w"] = int(f.get(rec + "w", 0)) + 1
		c.members += BoutRules.WIN_MEMBERS
		c.reputation += BoutRules.WIN_REPUTATION
	elif outcome == "loss":
		f[rec + "l"] = int(f.get(rec + "l", 0)) + 1
		var gone := mini(c.members, BoutRules.STOPPED_LOSS_MEMBERS if stop != "" else BoutRules.LOSS_MEMBERS)
		c.members -= gone
		c.reputation = maxi(0, c.reputation - (BoutRules.STOPPED_LOSS_REPUTATION if stop != "" else BoutRules.LOSS_REPUTATION))
		m["members_lost"] = gone
	else:
		f[rec + "d"] = int(f.get(rec + "d", 0)) + 1
	if not tickets.is_empty():
		m["tickets"] = tickets
		m["gym_cut"] = int(tickets["gym"])
		c.pay(int(tickets["gym"]), "Debut tickets: %d sold, the gym's %d%% of her share - %s vs %s" % [int(tickets["sold"]),
			int(Roster.GYM_SHARE * 100), f["first"], opp["name"]])
		c.add_news(Roster.debut_words(f, tickets))
	elif pro:
		var purse := int(f["bout"]["purse"])
		m["gym_cut"] = Roster.gym_cut(purse)
		c.pay(Roster.gym_cut(purse), "Purse share (%d%%): %s vs %s" % [int(Roster.GYM_SHARE * 100), f["first"], opp["name"]])
		if win:
			f["purse"] = mini(int(f["purse_top"]), int(f["purse"]) + int(f["purse_step"]))
	else:
		# S328 a championship is England Boxing's show: no ticket cut for the club.
		m["club_cut"] = 0 if f["bout"].has("champ") else BoutRules.TICKET_CUT
		if not f["bout"].has("champ"):
			c.pay(BoutRules.TICKET_CUT, "Ticket cut: %s vs %s" % [f["first"], opp["name"]])
		var r := c.rival(str(opp["name"]))
		if not r.is_empty() and outcome != "draw":
			Region.record(r, not win)
	if win:
		for d in c.deals:
			if str(d["state"]) == "locked":
				d["state"] = "offer"
				c.add_news("%s wants to sponsor %s: %s a week (MONEY > Deals)." % [d["name"], f["first"], GameMoney.text(int(d["per"]))])
	var card_text := ", ".join(cards) if stop == "" else "%s round %d" % [stop, rounds.size()]
	c.results.push_front({"d": c.day, "fid": f["id"], "who": f["first"], "opp": opp["name"], "win": win, "outcome": outcome, "pro": pro, "cards": card_text,
		"why": why[0] if not why.is_empty() else ""})
	var lead := "Pro: " if pro else ""
	var how := "on points" if stop == "" else "inside the distance"
	if win:
		c.add_news("%s%s beats %s %s (%s). %d locals sign up." % [lead, f["name"], opp["name"], how, card_text, BoutRules.WIN_MEMBERS])
	elif outcome == "draw":
		c.add_news("%s and %s draw (%s)." % [f["name"], opp["name"], card_text])
	else:
		c.add_news("%s loses to %s %s (%s). %d members leave the gym." % [f["name"], opp["name"], how, card_text,
			int(m.get("members_lost", 0))])
	FighterProfile.apply_morale(f, outcome, {"win": "Beat %s", "loss": "Lost to %s", "draw": "Drew with %s"}[outcome] % opp["name"])
	coach_note(c, f, "fight")
	var goal: Dictionary = f.get("goal", {})
	if not goal.is_empty():
		var status := str(FighterGoal.progress(goal, f, c.day, {})["status"])
		var met := status == "MET"
		(f["history"] as Array).append({"title": goal["title"], "met": met, "d": c.day})
		# The defect FighterGoal reported: its morale move now lands on the fighter.
		FighterProfile.apply_morale(f, "goal_met" if met else "goal_missed", "%s %s" % [goal["title"], "met" if met else "missed"])
	Region.update_rank(c, f)
	f["goal"] = {}
	f["goal_talk"] = true
	f["bout"]["done"] = true
	# S327 update 29 part B: the body report - the part that went first from the settled rounds' burn (BoutBurn, the same
	# BodyLoad pipeline as the 3D view), what to train next, and how it compares to her last bout.
	var burn := BoutBurn.per_round(rounds, f["stats"], str(f.get("style", "")))
	var report := BodyReport.report(burn, str(f["first"]))
	m["body_report"] = report
	# A bout not watched in 3D (words, or skipped) has no body track: her figure on the result page shows the same burn the
	# report reads, so the picture and the line agree.
	var track: Dictionary = m.get("body_track", {})
	var shown := 0.0
	for v in (track.get("a", {}) as Dictionary).values():
		shown += float(v)
	if not burn.is_empty() and shown <= 0.0:
		var south := str(f.get("stance", "")).to_lower() == "southpaw"
		var hers := {}
		for part in burn[-1]:
			hers[BodyTrack.body_place(part, south)] = float(burn[-1][part])
		track["a"] = hers
		m["body_track"] = track
	m["body_change"] = BodyReport.change_line(f.get("last_body_report", {}), report)
	f["last_body_report"] = report
	Injuries.after_bout(c, f, m)
	Roster.check_pro(c)


## S302 coach's notes (Qwen COACHNOTES1, Kalli's words): the coach learns one more thing about her from a fight, sometimes
## from a week of sparring; each new note is a news line and fills her card (FighterPage).
static func coach_note(c: Career, f: Dictionary, source: String) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = c.day * 131 + absi(hash(str(f.get("id", ""))))
	var got := CoachNotes.reveal(f, source, rng)
	if got.is_empty():
		return
	for row in CoachNotes.card(f, notes_bank()):
		if got.has(row["id"]):
			c.add_news("Coach's notes on %s: \"%s\"" % [f["first"], row["line"]])


static func notes_bank() -> Dictionary:
	if _notes_bank.is_empty() and FileAccess.file_exists(NOTES_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(NOTES_PATH))
		_notes_bank = parsed if parsed is Dictionary else {"_": {}}
	return _notes_bank
