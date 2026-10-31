extends RefCounted
## What needs the player: HOME's list, the top-bar flags, and the three states of CONTINUE - across the roster.
## A red need blocks time: CONTINUE turns into NEEDS YOU and opens it.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const SeasonPath := preload("res://scripts/rules/SeasonPath.gd")


## S324 update 27: GymBills' read of the gym's money now: "ok" | "warn" (runway under 8 weeks) | "red" (below $0) | "closed".
static func money_status(career: Career) -> String:
	if career.closed:
		return "closed"
	return GymBills.status(career.cash, money_net(career), career.weeks_below)


static func money_net(career: Career) -> int:
	return int(Sim.weekly_income(career)["total"]) - int(Sim.weekly_costs(career)["total"])


## [{red, t, s, act, arg, label}]
static func needs(career: Career) -> Array:
	var n: Array = []
	# S324: a closed gym is the one thing left; money trouble warns but never stops time (the player must be able to
	# play out of it - book a bout, sign a sponsor, cut the coach).
	if career.closed:
		return [{"red": true, "t": "The gym has closed", "s": "%d weeks below $0" % career.weeks_below,
			"act": "closedgym", "arg": "", "label": "See the summary"}]
	var ms := money_status(career)
	if ms == "red" or ms == "warn":
		n.append({"red": false, "t": "Money: " + GymBills.line(career.cash, money_net(career), career.weeks_below),
			"s": "below $0 for %d weeks in a row closes the gym; book bouts, sign sponsors, or cut costs" % GymBills.CLOSE_AFTER_WEEKS,
			"act": "go", "arg": "money:0", "label": "Money"})
	var a := career.applicant
	if not a.is_empty():
		n.append({"red": true, "t": "A fighter is waiting at reception",
			"s": "%s, %s, amateur %d-%d" % [a["name"], str(a["wc"]).to_lower(), a["w"], a["l"]],
			"act": "interview", "arg": "", "label": "Meet her"})
	for p in career.prospects:
		if str(p["state"]) == "invited" and int(p["trial_day"]) <= career.day:
			n.append({"red": true, "t": "Trial today: %s" % p["name"], "s": "%s, %s; she is at the gym" % [str(p["wc"]).to_lower(), p["note"]],
				"act": "trial", "arg": p["id"], "label": "Watch her"})
	if not career.pro_offer.is_empty():
		var pf := career.fighter_by_id(str(career.pro_offer["fid"]))
		n.append({"red": true, "t": "A promoter wants to sign %s" % pf["name"], "s": "%s: a pro contract" % career.pro_offer["promoter"],
			"act": "prooffer", "arg": pf["id"], "label": "Hear it"})
	for f in career.fighters:
		if Injuries.pending(f):
			n.append({"red": true, "t": "%s is hurt before her bout" % f["first"], "s": Injuries.line(career, f) + "; pull her out or let her fight hurt",
				"act": "injurychoice", "arg": f["id"], "label": "Decide"})
		for o in f["offers"]:
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				n.append({"red": true, "t": "Answer a bout offer: %s vs %s" % [f["name"], o["opp"]["name"]],
					"s": "expires %s" % Clock.fmt(int(o["expires"])), "act": "openBout", "arg": o["id"], "label": "Open"})
		if Bouts.weigh_in_today(career, f):
			n.append({"red": true, "t": "Weigh-in today: %s" % f["first"], "s": "%s must make %.1f kg" % [f["name"], f["limit"]],
				"act": "weighin", "arg": f["id"], "label": "Weigh in"})
	# S327 (operator "Money too harsh"): a sponsor on offer is money the player may not know is there - say so.
	for d in career.deals:
		if str(d["state"]) == "offer":
			n.append({"red": false, "t": "A sponsor is waiting: %s" % d["name"], "s": "%s a week for %s" % [GameMoney.text(int(d["per"])), d["what"]],
				"act": "go", "arg": "money:3", "label": "Deals"})
	if not career.fighters.is_empty() and career.coach.is_empty():
		n.append({"red": false, "t": "Hire a coach", "s": "without one, training runs at 60%",
			"act": "go", "arg": "gym:1", "label": "Staff"})
	for f in career.fighters:
		if Bouts.camp_due(career, f):
			var days := int(f["bout"]["day"]) - career.day
			n.append({"red": false, "t": "Set %s's fight camp" % f["first"],
				"s": "bout on %s, %d weeks: time for a camp" % [Clock.fmt(int(f["bout"]["day"])), int(days / 7.0)],
				"act": "camp", "arg": f["id"], "label": "Set camp"})
	# S328 update 30: the season goal - she is eligible and the entry window is open.
	for f in career.fighters:
		if Champs.cannot_enter(career, f) == "":
			var close := SeasonPath.entry_close(career.day)
			n.append({"red": false, "t": "Enter %s for the nationals" % f["first"],
				"s": "entries close %s; the regional starts %s" % [Clock.fmt(close), Clock.fmt(Champs.stage_day(close, 0))],
				"act": "go", "arg": "world:4", "label": "Nationals"})
	if career.review_pending and not career.last_report.is_empty():
		n.append({"red": false, "t": "Week %d review is ready" % int(career.last_report["week"]),
			"s": "gains, moves, rankings, money", "act": "review", "arg": "", "label": "Open"})
	for f in career.fighters:
		if bool(f["goal_talk"]):
			n.append({"red": false, "t": "%s is waiting in your office" % f["first"], "s": "pick her next goal",
				"act": "goaltalk", "arg": f["id"], "label": "Talk"})
	return n


static func blockers(career: Career) -> Array:
	return needs(career).filter(func(x): return bool(x["red"]))


## [{t, act, arg, red}]
static func flags(career: Career) -> Array:
	var out: Array = []
	var ms := money_status(career)
	if ms == "closed":
		out.append({"t": "GYM CLOSED", "act": "closedgym", "arg": "", "red": true})
	elif ms == "red":
		out.append({"t": "BELOW $0", "act": "go", "arg": "money:0", "red": true})
	elif ms == "warn":
		out.append({"t": "LOW CASH", "act": "go", "arg": "money:0", "red": false})
	if not career.applicant.is_empty():
		out.append({"t": "APPLICANT", "act": "interview", "arg": "", "red": true})
	for p in career.prospects:
		if str(p["state"]) == "invited" and int(p["trial_day"]) <= career.day:
			out.append({"t": "TRIAL", "act": "trial", "arg": p["id"], "red": true})
	if not career.pro_offer.is_empty():
		out.append({"t": "PRO OFFER", "act": "prooffer", "arg": career.pro_offer["fid"], "red": true})
	for f in career.fighters:
		if Bouts.camp_due(career, f):
			out.append({"t": "SET CAMP", "act": "camp", "arg": f["id"], "red": false})
	if career.review_pending:
		out.append({"t": "WEEK REVIEW", "act": "review", "arg": "", "red": false})
	for f in career.fighters:
		if Bouts.weigh_in_today(career, f):
			out.append({"t": "WEIGH-IN", "act": "weighin", "arg": f["id"], "red": true})
		if bool(f["goal_talk"]):
			out.append({"t": "NEW GOAL", "act": "goaltalk", "arg": f["id"], "red": false})
	return out


## {cls, t, s}: NEEDS YOU (red), GO TO FIGHT NIGHT, RUNNING, or CONTINUE to the next stop.
static func go_state(career: Career, running: bool) -> Dictionary:
	var b := blockers(career)
	if not b.is_empty():
		return {"cls": "GoBlock", "t": "NEEDS YOU (%d)" % b.size(), "s": str(b[0]["t"])}
	var f := Bouts.fighting_today(career)
	if not f.is_empty():
		return {"cls": "GoFight", "t": "GO TO FIGHT NIGHT", "s": "%s vs %s" % [f["first"], f["bout"]["opp"]["name"]]}
	if running:
		return {"cls": "Go", "t": "RUNNING", "s": "click to pause"}
	var stop: Dictionary = Clock.next_stop(career)
	return {"cls": "Go", "t": "CONTINUE", "s": "to %s, %s" % [Clock.fmt(int(stop["d"])), stop["r"]]}
