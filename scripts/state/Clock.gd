extends RefCounted
class_name Clock
## Days and stops. Day 0 is Monday 5 January 2026. A week ends when the day counter reaches a multiple of 7 (the day
## just finished was a Sunday); the month bill falls every 28 days. CONTINUE runs day by day until stop_now() says stop.

const Sim := preload("res://scripts/state/Sim.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

const DAYS := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
const MONTHS := ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
## Milliseconds per day at speeds 1, 2, 3 (the prototype's pace).
const TICK_MS := [420, 220, 90]


static func _date(day: int) -> Dictionary:
	var base := int(Time.get_unix_time_from_datetime_dict({"year": 2026, "month": 1, "day": 5, "hour": 12}))
	return Time.get_datetime_dict_from_unix_time(base + day * 86400)


## "Mon 5 Jan"
static func fmt(day: int) -> String:
	var d := _date(day)
	return "%s %d %s" % [DAYS[posmod(day, 7)], int(d["day"]), MONTHS[int(d["month"]) - 1]]


## "Mon 5 Jan 2026"
static func fmt_long(day: int) -> String:
	return "%s %d" % [fmt(day), int(_date(day)["year"])]


static func week_of(day: int) -> int:
	return int(floor(day / 7.0)) + 1


## The next thing CONTINUE runs to: {d, r}.
static func next_stop(career: Career) -> Dictionary:
	var cands: Array = []
	cands.append({"d": (int(floor(career.day / 7.0)) + 1) * 7, "r": "week review"})
	cands.append({"d": GameMoney.next_bill_day(career.day), "r": "the month-end bill"})
	for f in career.fighters:
		var who := "" if career.fighters.size() < 2 else " (%s)" % f["first"]
		if (f["bout"] as Dictionary).is_empty() and Bouts.offers_settled(f) and not bool(f.get("pro", false)):
			cands.append({"d": maxi(int(f["next_offer_day"]), career.day + 1), "r": "a bout offer arrives" + who})
		if not (f["bout"] as Dictionary).is_empty():
			cands.append({"d": int(f["bout"]["day"]) - 1, "r": "weigh-in" + who})
			cands.append({"d": int(f["bout"]["day"]), "r": "fight night" + who})
	for p in career.prospects:
		if str(p["state"]) == "invited":
			cands.append({"d": int(p["trial_day"]), "r": "%s's trial" % p["first"]})
	var best: Dictionary = {}
	for c in cands:
		if int(c["d"]) > career.day and (best.is_empty() or int(c["d"]) < int(best["d"])):
			best = c
	return best


## Steps one day. Returns true when time must stop here.
static func step(career: Career) -> bool:
	Sim.step_day(career)
	return stop_now(career)


static func stop_now(career: Career) -> bool:
	if not Needs.blockers(career).is_empty() or not Bouts.fighting_today(career).is_empty():
		return true
	if career.review_pending and career.day % 7 == 0:
		return true
	if GameMoney.is_bill_day(career.day):
		return true
	return false
