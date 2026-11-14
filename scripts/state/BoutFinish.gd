extends RefCounted
## SPLIT471: the end-of-bout bookkeeping split out of BoutNight.gd (it had reached the 500-line cap).
## From the last bell to the scorecards, the record, money, members, morale, goals, injury roll and coach's notes.
## BoutNight._finish delegates here; every external caller (Bouts, PlanTest, FixLab) still goes through BoutNight.

const JudgeNight := preload("res://scripts/state/JudgeNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const AfterFight := preload("res://scripts/state/AfterFight.gd")
const Data := preload("res://scripts/state/Data.gd")
const PeakCamp := preload("res://scripts/rules/PeakCamp.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Region := preload("res://scripts/state/Region.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const CornerTrust := preload("res://scripts/rules/CornerTrust.gd")
const CoachNotes := preload("res://scripts/rules/CoachNotes.gd")
const BoutBurn := preload("res://scripts/rules/BoutBurn.gd")
const BodyReport := preload("res://scripts/rules/BodyReport.gd")
const BodyTrack := preload("res://scripts/rules/BodyTrack.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")
const NOTES_PATH := "res://assets/data/fight_habits.json"

static var _notes_bank: Dictionary = {}


## "RSC" / "KO" when the referee stopped the bout in its last round, else "" (private copy; BoutNight.stopped is the
## public one; kept here so BoutFinish does not preload BoutNight).
static func _stopped(m: Dictionary) -> String:
	var rounds: Array = m.get("rounds", [])
	return "" if rounds.is_empty() else str((rounds[-1] as Dictionary).get("stopped", ""))


## win | loss | draw from the bout's rounds (private copy; BoutNight.outcome_of is the public one).
static func _outcome_of(f: Dictionary, m: Dictionary) -> String:
	var rounds: Array = m["rounds"]
	var outcome := BoutRules.verdict(JudgeNight.cards(f, m))
	if _stopped(m) != "":
		outcome = "loss" if _stopped(m) == "RTD" or (str((rounds[-1] as Dictionary)["down"]) == "a" and _stopped(m) != CrackWire.STOP_B) else "win"
	if outcome == "draw" and f["bout"].has("champ"):
		outcome = "win" if bool((rounds[-1] as Dictionary)["won"]) else "loss"
	return outcome


static func run(c: Career, f: Dictionary, m: Dictionary) -> void:
	var opp: Dictionary = f["bout"]["opp"]
	var camp: Dictionary = f["camp"]
	var rounds: Array = m["rounds"]
	var won := rounds.filter(func(r): return bool(r["won"])).size()
	var pro := bool(f["bout"].get("pro", false))
	var cards := JudgeNight.cards(f, m)   # S443 R29: m["judges"] always; their cards only when JudgeNight.decides()
	var stop := _stopped(m)
	m["stopped"] = stop
	ProReadWire.close(f, m)
	var before := AfterFight.snap(c, f, opp)   # S430 the result page's "what the fight did" tiles read the change
	var outcome := _outcome_of(f, m)
	var win := outcome == "win"
	var focus_label := str(Data.LABEL.get(camp.get("focus", ""), ""))
	var why := BoutRules.why(rounds, not camp.is_empty(), int(camp.get("protocol", 0)), focus_label, int(f["bout"].get("answered", 0)),
		str(opp["threat"]).to_lower(), str(f["first"]))
	# S356 the peak bonus was for this fight only; its line leads the reasons and goes in the week review.
	PeakCamp.unboost(f["stats"], f["bout"].get("peak_add", {}))
	var peak := PeakCamp.line(str(f["first"]), f["bout"].get("peak_rows", []))
	if float(f["bout"].get("stale", 0.0)) > 0.0:
		why.push_front("The Tank: %s started %d down at the first bell (%s)." % [f["first"], int(round(float(f["bout"]["stale"]))),
			str(f["bout"].get("tank_why", "tiredness"))])
	if not rounds.is_empty() and not bool(rounds[0]["won"]) and BoutRules.never_faced(str(f.get("stance", "orthodox")), opp,
			camp, bool(f["bout"].get("lefty", false))):
		why.push_front("Round 1: %s had never faced a southpaw." % f["first"])
	if peak != "":
		why.push_front(peak)
		f["peak_line"] = peak
	m["peak"] = not (f["bout"].get("peak_add", {}) as Dictionary).is_empty()
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
		# S357 a short-notice win against the tougher replacement counts twice (the twist card's price paid off).
		c.reputation += BoutRules.WIN_REPUTATION * (2 if bool(f["bout"].get("short_notice", false)) else 1)
	elif outcome == "loss":
		f[rec + "l"] = int(f.get(rec + "l", 0)) + 1
		if stop != "":
			Attrs.wear_stoppage(f)
		var gone := mini(c.members, BoutRules.STOPPED_LOSS_MEMBERS if stop != "" else BoutRules.LOSS_MEMBERS)
		c.members -= gone
		c.reputation = maxi(0, c.reputation - (BoutRules.STOPPED_LOSS_REPUTATION if stop != "" else BoutRules.LOSS_REPUTATION))
		m["members_lost"] = gone
	else:
		f[rec + "d"] = int(f.get(rec + "d", 0)) + 1
	if pro:
		m["ladder"] = ProLadder.result(c, f, outcome, stop != "")   # S397 the debut puts her on the table; a ladder bout moves it
	if not tickets.is_empty():
		m["tickets"] = tickets
		m["gym_cut"] = int(tickets["gym"])
		c.pay(int(tickets["gym"]), "Debut tickets: %d sold, the gym's %d%% of the fighter's share - %s vs %s" % [int(tickets["sold"]),
			int(Roster.GYM_SHARE * 100), f["first"], opp["name"]])
		c.add_news(Roster.debut_words(f, tickets))
	elif pro:
		var purse := int(f["bout"]["purse"])
		m["gym_cut"] = Roster.gym_cut(purse, f)
		c.pay(Roster.gym_cut(purse, f), "Purse share (%d%%): %s vs %s" % [roundi(Roster.share_of(f) * 100), f["first"], opp["name"]])
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
		# S341 her record keeps the bout against us (RivalPast), as her own result - a draw too.
		RivalPast.add(r, c.day, str(f["name"]), c.gym_name, not win and outcome != "draw",
			"a draw" if outcome == "draw" else ("on points" if stop == "" else "%s in round %d" % [stop, rounds.size()]), true)
	if win:
		for d in c.deals:
			if str(d["state"]) == "locked":
				d["state"] = "offer"
				c.add_news("%s wants to sponsor %s: %s a week (Club, Money)." % [d["name"], f["first"], GameMoney.text(int(d["per"]))])
	var card_text := ", ".join(cards) if stop == "" else "%s round %d" % [stop, rounds.size()]
	f["last_bout_day"] = c.day   # S434 the Tank's last bout, read by the bout page too (BoutRules.tank_read)
	c.results.push_front({"d": c.day, "fid": f["id"], "who": f["first"], "opp": opp["name"], "win": win, "outcome": outcome, "pro": pro, "cards": card_text,
		"why": why[0] if not why.is_empty() else "", "plan_rec": PlanRecord.summary(rounds)})
	# S341 three rounds show everything: her whole file opens, and the career's record of her keeps it.
	OppFile.open_all(opp)
	OppFile.remember(c.rival(str(opp["name"])), opp)
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
	CornerTrust.settle(f, opp["name"])
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
	AfterFight.book(c, f, m, before, notes_bank())
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
