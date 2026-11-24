extends RefCounted
## KNOWBUILD1 (S545; owner interview S543 K1-K4 on map v9, ops/research/DESIGN_KNOW_STAKES1_V9.md): a prospect is a
## MOMENT (K3). The scout brings one name at a time (one every 4-6 weeks, at most two open: ProspectClock 3D); each carries
## the region show they box on (bout_day, 4-18 days out) and the rival club's 7-day window (window_from / window_to, read off
## the rival's own look) with the day inside it the rival signs (rival_day, fixed on arrival: waiting never moves it).
## The calls: SIGN NOW, START THE TRIAL (by the day, $36 a day, tomorrow's question picked each evening, K4; refunded if the
## rival signs during it; at most 7 days), WAIT FOR THE BOUT (Continue), PASS. Letting the window run out is not Pass: the
## rival signs the prospect - one news line in Mail and a row on the got-away list (who, where, the last look; KNOWBUILD2's
## return bout reads it). Pass frees the slot with no news line (the row is kept, marked passed).
## K1, THE PLACE NOT DOLLARS: no bond. A signing holds one of the gym's places to the season's end (ProspectClock.season_end;
## f["held_to"]): Let go is not offered before it (Leaving.let_go_price). The stipend the boxer draws stays as it is.
## Prospect states: later (not arrived) | scout (open) | trial | signed | passed | gone; "invited" is an old save's Monday
## trial (Roster.invite), which now starts this trial on its day.
##   start(c) / day(c)               the arrival clock and the day's events (Sim.step_day)
##   arrive(c, id) -> p              bring a name in today (the scout's next one; tests and jumps name one)
##   card(c, p) -> {...}             what the signing card shows      evening(p) -> bool  a trial evening waits for an answer
##   start_trial / ask / send_home / pass_on / sign                  the calls
##   needs(c) / stops(c)             the Needs strip's lines and Continue's stops        got_away(c) -> rows
## Preloads only pure rules; state modules by load() (Roster and GymSpend preload much of the game).

const K := preload("res://scripts/rules/Knowledge.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")
const PC := preload("res://scripts/rules/ProspectClock.gd")
const Gen := preload("res://scripts/rules/ProspectGen.gd")
const Data := preload("res://scripts/state/Data.gd")

const OPEN := ["scout", "trial"]
## The open session while a name waits (v8): body and skills a little each week, 8 a week each (the greybox's wb / ws).
const WAIT_WEEK := 8.0
const NEWS_GONE := "%s sign the prospect %s, %s."


static func _gs() -> GDScript:
	return load("res://scripts/state/GymSpend.gd")


## The level a prospect is read against: the mean rating of the region's boxers in that division (Region rows).
static func level(c: Career, div: String) -> float:
	var s := 0.0
	var n := 0
	for r in c.rivals:
		if str(r.get("div", "")) == div and r.has("rating"):
			s += float(r["rating"])
			n += 1
	return s / n if n > 0 else 60.0


## Every division's level averaged (the two-year walk's drift print).
static func region_level(c: Career) -> float:
	var s := 0.0
	var divs := {}
	for r in c.rivals:
		divs[str(r.get("div", ""))] = true
	for d in divs:
		s += level(c, str(d))
	return s / maxf(1.0, float(divs.size()))


static func by_id(c: Career, id: String) -> Dictionary:
	for p in c.prospects:
		if str(p["id"]) == id:
			return p
	return {}


static func open(c: Career) -> Array:
	return c.prospects.filter(func(p): return OPEN.has(str(p.get("state", ""))))


static func evening(p: Dictionary) -> bool:
	return str(p.get("state", "")) == "trial" and bool((p.get("trial", {}) as Dictionary).get("evening", false))


## Places free for a trial or a signing: the gym's places less the boxers and the trials holding one.
static func free_places(c: Career) -> int:
	var trials := c.prospects.filter(func(p): return str(p.get("state", "")) == "trial").size()
	return int(_gs().places(c)) - int(_gs().used(c)) - trials


## A new career (Career.new_career) or an old save's first day: the named names wait their turn; the first two arrive now.
static func start(c: Career) -> void:
	for p in c.prospects:
		if str(p.get("state", "")) == "scout" and not p.has("arrived") and not bool(p.get("home", false)):
			p["state"] = "later"
	c.scout = {"next": c.day, "n": 0}
	for i in PC.OPEN_MAX:
		_next_arrival(c)
	c.scout["next"] = c.day + _gap(c)


## A test or a jump that fixes Career.seed after the career began: the names that arrived today are drawn again on that seed.
static func restart(c: Career) -> void:
	for p in c.prospects:
		if str(p.get("state", "")) == "scout" and int(p.get("arrived", -1)) == c.day:
			p.erase("arrived")
	start(c)


static func _gap(c: Career) -> int:
	var r := RandomNumberGenerator.new()
	r.seed = hash([c.seed, "scout", int(c.scout.get("n", 0))])
	return r.randi_range(PC.ARRIVE_MIN, PC.ARRIVE_MAX)


## The scout's next name: the first named prospect still to come (not the first hour's second walk-in), else a new one.
static func _next_arrival(c: Career) -> Dictionary:
	var fh: GDScript = load("res://scripts/rules/FirstHour.gd")
	for p in c.prospects:
		if str(p.get("state", "")) == "later" and c.fighter_by_id(str(p["id"])).is_empty():
			if str(p["id"]) == fh.SECOND_WALKIN and fh.on(c) and not bool(c.first_hour.get("walkin", false)):
				continue
			return arrive(c, str(p["id"]))
	var n := int(c.scout.get("n", 0))
	var tp: Array = Data.PROSPECTS.duplicate()
	var base: Dictionary = tp[n % tp.size()]
	var g := Gen.make(n, hash([c.seed, "gen", n]), tp, level(c, str(base["div"])))
	g["state"] = "later"
	g["trial_day"] = -1
	c.prospects.append(g)
	return arrive(c, str(g["id"]))


## Bring the name in today, dated: the show they box on and the rival's window (both fixed now). Returns the row.
static func arrive(c: Career, id: String, dated: bool = true) -> Dictionary:
	var p := by_id(c, id)
	if p.is_empty() or str(p.get("state", "")) == "signed":
		return {}
	var seed := absi(hash([c.seed, id, "know"]))
	var r := RandomNumberGenerator.new()
	r.seed = seed
	var k := K.fresh(seed)
	k["ceil_hw"] = PC.CEIL_HW
	p["know"] = k
	p["state"] = "scout"
	p["arrived"] = c.day
	p["trial_day"] = -1
	p["trial"] = {}
	if p.has("gone"):   # brought in again (a test or a jump): the region row the rival club gave the name goes too
		c.rivals = c.rivals.filter(func(r): return not (r.has("got_away") and str(r["name"]) == str(p["name"])))
	p.erase("gone")
	c.scout["n"] = int(c.scout.get("n", 0)) + 1
	if not dated:
		for key in ["bout_day", "window_from", "window_to", "rival_day"]:
			p[key] = -1
		return p
	var lvl := level(c, str(p["div"]))
	var likes := PC.rival_likes(p, seed, lvl)
	var w := PC.window(c.day, likes, r.randi_range(0, PC.LAST_SPREAD))
	p["bout_day"] = PC.bout_day(c.day, r.randf())   # a region show is a Saturday
	p["window_from"] = int(w["from"])
	p["window_to"] = int(w["to"])
	p["rival_day"] = PC.rival_day(int(w["from"]), int(w["to"]), r.randf())
	p["likes"] = likes
	p["club"] = _club(c, p, r)
	p["bout_u"] = r.randf()
	return p


static func _club(c: Career, p: Dictionary, r: RandomNumberGenerator) -> String:
	var clubs: Array = []
	for row in c.rivals:
		var club := str(row.get("club", ""))
		if str(row.get("div", "")) == str(p["div"]) and club != "" and club != c.gym_name and not clubs.has(club):
			clubs.append(club)
	return str(clubs[r.randi() % clubs.size()]) if not clubs.is_empty() else "Eastside ABC"


## The day (Sim.step_day, after the date moved): arrivals, trial days, the bout, the open session, the rival's day.
static func day(c: Career) -> void:
	if not c.scout.has("next"):
		start(c)
	for p in c.prospects.duplicate():
		var st := str(p.get("state", ""))
		if st != "signed" and not c.fighter_by_id(str(p["id"])).is_empty():   # already on the books (signed some other way)
			p["state"] = "signed"
			continue
		if st == "scout" and not p.has("arrived"):   # a home junior: ours, no show, no rival
			arrive(c, str(p["id"]), false)
		elif st == "invited" and int(p.get("trial_day", 0)) <= c.day:   # an old save's Monday trial starts this trial
			if not p.has("know"):
				arrive(c, str(p["id"]), false)
			start_trial(c, str(p["id"]), true)
			_trial_day(c, p)   # the Monday it was booked for is trial day 1 (the fitness test); tonight it asks to be watched
		elif st == "trial":
			_trial_day(c, p)
		elif st == "scout":
			_open_day(c, p)
	if c.day >= int(c.scout.get("next", 0)) and open(c).size() < PC.OPEN_MAX:
		_next_arrival(c)
		c.scout["next"] = c.day + _gap(c)


static func _open_day(c: Career, p: Dictionary) -> void:
	if int(p.get("rival_day", -1)) >= 0 and c.day >= int(p["rival_day"]):
		_gone(c, p)
		return
	K.expose(p["know"], "body", WAIT_WEEK / 7.0, "session")
	K.expose(p["know"], "skills", WAIT_WEEK / 7.0, "session")
	if c.day == int(p.get("bout_day", -1)):
		_bout(c, p)


## The prospect's own bout: under fire opens rough and the record moves (a win more likely the more merit over the level).
static func _bout(c: Career, p: Dictionary) -> void:
	var k: Dictionary = p["know"]
	if not bool(k.get("under_fire_opened", false)):
		# the exposure that leaves under fire PC.BOUT_HW wide (Knowledge.width: FLOOR + (start - FLOOR) / (1 + e / HALF))
		K.expose(k, "under_fire", ((K.UNDER_FIRE_START - K.FLOOR) / (PC.BOUT_HW - K.FLOOR) - 1.0) * K.HALF, "bout")
	else:
		K.bout(k)
	var win_p := clampf(0.5 + (PC.merit(p) - level(c, str(p["div"]))) / 20.0, 0.2, 0.8)
	var won := float(p.get("bout_u", 0.5)) < win_p
	p["w" if won else "l"] = int(p["w" if won else "l"]) + 1
	p["boxed"] = {"d": c.day, "won": won}


static func _trial_day(c: Career, p: Dictionary) -> void:
	var t: Dictionary = p["trial"]
	if int(p.get("rival_day", -1)) >= 0 and c.day >= int(p["rival_day"]):
		if int(t.get("paid", 0)) > 0:
			c.pay(int(t["paid"]), "Trial refunded: %s" % str(p["first"]))
		_gone(c, p)
		return
	if bool(t.get("evening", false)):   # an evening nobody answered (a probe or a jump): another day, the least asked
		if int(t["days"]) >= KR.TRIAL_MAX_DAYS:
			send_home(c, str(p["id"]))
			return
		t["next"] = KR.least_asked(p["know"])
		t["evening"] = false
	var q := str(t.get("next", ""))
	if q == "":
		return
	var before := PC.ranges(p["know"], p)
	var cost := KR.apply_trial_day(p["know"], q)
	c.pay(-cost, "Trial day %d: %s" % [int(t["days"]) + 1, str(p["first"])])
	t["paid"] = int(t.get("paid", 0)) + cost
	t["days"] = int(t["days"]) + 1
	if q == "spar":
		t["tired"] = int(t.get("tired", 0)) + int(KR.RISK_TIREDNESS)
	var g := "ceiling" if q == "pads" else ("fire" if q == "spar" else q)
	t["last"] = {"q": q, "g": g, "before": before[g], "after": PC.ranges(p["know"], p)[g]}
	t["next"] = ""
	t["evening"] = true
	if c.day == int(p.get("bout_day", -1)):
		_bout(c, p)


static func start_trial(c: Career, id: String, quiet: bool = false) -> bool:
	var p := by_id(c, id)
	if p.is_empty() or not str(p.get("state", "")) in ["scout", "invited"] or (free_places(c) <= 0 and not quiet):
		return false
	p["state"] = "trial"
	p["trial"] = {"start": c.day, "days": 0, "next": "body", "evening": false, "paid": 0, "last": {}, "tired": 0}
	return true


## Another day: tomorrow's question (K4). False on day 7 or an unknown question.
static func ask(c: Career, id: String, q: String) -> bool:
	var p := by_id(c, id)
	if not evening(p) or not KR.QUESTIONS.has(q) or int(p["trial"]["days"]) >= KR.TRIAL_MAX_DAYS:
		return false
	p["trial"]["next"] = q
	p["trial"]["evening"] = false
	return true


## Send home: the trial ends, the name stays open on the list until the rival's day (the days are paid).
static func send_home(c: Career, id: String) -> void:
	var p := by_id(c, id)
	if str(p.get("state", "")) == "trial":
		p["state"] = "scout"
		p["trial"]["evening"] = false
		p["trial"]["next"] = ""
		p["sent_home"] = c.day


## Pass: the slot frees today; no news line; kept on the got-away list, marked passed; they box on at the rival club.
static func pass_on(c: Career, id: String) -> void:
	var p := by_id(c, id)
	if p.is_empty() or not str(p.get("state", "")) in ["scout", "trial", "invited"]:
		return
	p["state"] = "passed"
	p["gone"] = _row(c, p, true)
	_to_rival(c, p)


static func _gone(c: Career, p: Dictionary) -> void:
	p["state"] = "gone"
	p["gone"] = _row(c, p, false)
	_to_rival(c, p)
	c.add_news(NEWS_GONE % [str(p.get("club", "Eastside ABC")), str(p["name"]), Clock.fmt(c.day)], true, true)


## The got-away row: who, where, when, the last look (KNOWBUILD2's return bout reads it).
static func _row(c: Career, p: Dictionary, passed: bool) -> Dictionary:
	var r := PC.ranges(p["know"], p) if p.has("know") else {}
	var look := "" if r.is_empty() else "body %d-%d, skills %d-%d" % [int(r["body"]["lo"]), int(ceil(float(r["body"]["hi"]))), int(r["skills"]["lo"]), int(ceil(float(r["skills"]["hi"])))]
	return {"d": c.day, "club": str(p.get("club", "Eastside ABC")), "look": look, "passed": passed, "div": str(p["div"]),
		"est": PC.estimate(r) if not r.is_empty() else 0.0}


static func _to_rival(c: Career, p: Dictionary) -> void:
	var s: Dictionary = p.get("stats", {})
	var sum := 0.0
	for k in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		sum += float(s.get(k, 55.0))
	c.rivals.append({"div": str(p["div"]), "name": str(p["name"]), "first": str(p.get("first", "")), "club": str(p.get("club", "Eastside ABC")),
		"age": int(p.get("age", 20)), "stance": str(p.get("stance", "orthodox")), "style": str(p.get("style", "Boxer-puncher")),
		"w": int(p.get("w", 0)), "l": int(p.get("l", 0)), "rating": snappedf(sum / 6.0, 0.5), "threat": "", "weak": "",
		"got_away": c.day, "passed": str(p["state"]) == "passed", "bouts": []})


static func got_away(c: Career) -> Array:
	var out: Array = []
	for p in c.prospects:
		if p.has("gone") and str(p.get("state", "")) in ["gone", "passed"]:
			out.append((p["gone"] as Dictionary).merged({"id": str(p["id"]), "name": str(p["name"])}))
	out.sort_custom(func(a, b): return int(a["d"]) > int(b["d"]))
	return out


## Sign: the boxer joins on the club stipend with the read so far, and holds a place to the season's end (K1).
static func sign(c: Career, id: String) -> Dictionary:
	var p := by_id(c, id)
	if p.is_empty() or not str(p.get("state", "")) in ["scout", "trial", "invited"]:
		return {}
	if str(p["state"]) != "trial" and free_places(c) <= 0:
		return {}
	var raw: Dictionary = p.duplicate(true)
	for key in ["state", "trial_day", "note", "trial", "know", "arrived", "bout_day", "window_from", "window_to", "rival_day", "likes",
			"club", "bout_u", "boxed", "sent_home", "gone", "scouted"]:
		raw.erase(key)
	var roster: GDScript = load("res://scripts/state/Roster.gd")
	p["state"] = "signed"
	var f: Dictionary = roster.sign_fighter(c, raw, load("res://scripts/rules/Recruit.gd").default_cards(str(p.get("style", ""))))
	if p.has("know"):
		f["know"] = (p["know"] as Dictionary).duplicate(true)   # the read the gym had stays the read
	f["held_to"] = PC.season_end(c.day)
	f["signed_read"] = {"d": c.day, "trial_days": int((p.get("trial", {}) as Dictionary).get("days", 0))}
	var tired := int((p.get("trial", {}) as Dictionary).get("tired", 0))
	if tired > 0:
		f["week_fatigue"] = float(f.get("week_fatigue", 20.0)) + tired
	load("res://scripts/state/HomeJuniors.gd").on_sign(c, raw, f)
	return f


## What the signing card shows (pure reads of the row).
static func card(c: Career, p: Dictionary) -> Dictionary:
	var r := PC.ranges(p["know"], p)
	var dated := int(p.get("window_to", -1)) >= 0
	return {"ranges": r, "level": level(c, str(p["div"])), "est": PC.estimate(r), "dated": dated,
		"bout": int(p.get("bout_day", -1)), "from": int(p.get("window_from", -1)), "to": int(p.get("window_to", -1)),
		"club": str(p.get("club", "")), "likes": bool(p.get("likes", false)), "free": free_places(c),
		"places": int(_gs().places(c)), "used": int(_gs().used(c)), "held_to": PC.season_end(c.day),
		"before_bout": PC.odds_before(int(p.get("bout_day", -1)), int(p.get("window_from", -1)), int(p.get("window_to", -1))) if dated else [0, 7]}


## The Needs strip: a trial evening blocks time (sign, send home, or another day); the bout day and the window's first and
## last day stop Continue once and say so.
static func needs(c: Career) -> Array:
	var n: Array = []
	for p in c.prospects:
		var st := str(p.get("state", ""))
		if evening(p):
			n.append({"red": true, "t": "Trial day %d: decide tonight" % int(p["trial"]["days"]), "s": "%s, %s: sign, send home, or another day" % [p["name"], str(p["wc"]).to_lower()],
				"act": "trial", "arg": p["id"], "label": "Decide"})
		if not OPEN.has(st) or int(p.get("window_to", -1)) < 0:
			continue
		if c.day == int(p.get("bout_day", -1)):
			n.append({"red": false, "t": "The prospect boxes tonight", "s": "%s at the region show: free to watch" % p["name"], "act": "prospect", "arg": p["id"], "label": "See the card"})
		if c.day == int(p["window_from"]):
			n.append({"red": false, "t": "%s decide from today" % p["club"], "s": "%s: the rival club may sign any day to %s" % [p["name"], Clock.fmt(int(p["window_to"]))], "act": "prospect", "arg": p["id"], "label": "See the card"})
		elif c.day == int(p["window_to"]):
			n.append({"red": false, "t": "%s decide today at the latest" % p["club"], "s": "%s: sign today or the rival club does" % p["name"], "act": "prospect", "arg": p["id"], "label": "See the card"})
	return n


## The first hour keeps its own pace (FirstHour.quiet: until the gym's first bout): the names still arrive and the rival's
## window still runs, but Continue does not stop for them yet.
static func _quiet(c: Career) -> bool:
	return bool(load("res://scripts/rules/FirstHour.gd").quiet(c))


## Continue's stops: {d, r} candidates (Clock.next_stop) and whether today is one (Clock.stop_now).
static func stops(c: Career) -> Array:
	var out: Array = []
	if _quiet(c):
		return out
	for p in c.prospects:
		var st := str(p.get("state", ""))
		if st == "trial" and str((p.get("trial", {}) as Dictionary).get("next", "")) != "":
			out.append({"d": c.day + 1, "r": "trial day %d" % (int(p["trial"]["days"]) + 1)})
		if OPEN.has(st) and int(p.get("window_to", -1)) >= 0:
			out.append({"d": int(p["bout_day"]), "r": "the prospect's bout"})
			out.append({"d": int(p["window_from"]), "r": "%s decide from" % p["club"]})
			out.append({"d": int(p["window_to"]), "r": "%s's last day" % p["club"]})
	return out


static func stop_today(c: Career) -> bool:
	if _quiet(c):
		return false
	for p in c.prospects:
		if OPEN.has(str(p.get("state", ""))) and int(p.get("window_to", -1)) >= 0 and c.day in [int(p["bout_day"]), int(p["window_from"]), int(p["window_to"])]:
			return true
	return false
