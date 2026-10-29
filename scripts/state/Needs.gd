extends RefCounted
## What needs the player: HOME's list, the top-bar flags, and the three states of CONTINUE - across the roster.
## A red need blocks time: CONTINUE turns into NEEDS YOU and opens it.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")


## [{red, t, s, act, arg, label}]
static func needs(career: Career) -> Array:
	var n: Array = []
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
		for o in f["offers"]:
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				n.append({"red": true, "t": "Answer a bout offer: %s vs %s" % [f["name"], o["opp"]["name"]],
					"s": "expires %s" % Clock.fmt(int(o["expires"])), "act": "openBout", "arg": o["id"], "label": "Open"})
		if Bouts.weigh_in_today(career, f):
			n.append({"red": true, "t": "Weigh-in today: %s" % f["first"], "s": "%s must make %.1f kg" % [f["name"], f["limit"]],
				"act": "weighin", "arg": f["id"], "label": "Weigh in"})
	if not career.fighters.is_empty() and career.coach.is_empty():
		n.append({"red": false, "t": "Hire a coach", "s": "without one, training runs at 60%",
			"act": "go", "arg": "gym:1", "label": "Staff"})
	for f in career.fighters:
		if Bouts.camp_due(career, f):
			var days := int(f["bout"]["day"]) - career.day
			n.append({"red": false, "t": "Set %s's fight camp" % f["first"],
				"s": "bout on %s, %d weeks: time for a camp" % [Clock.fmt(int(f["bout"]["day"])), int(days / 7.0)],
				"act": "camp", "arg": f["id"], "label": "Set camp"})
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
