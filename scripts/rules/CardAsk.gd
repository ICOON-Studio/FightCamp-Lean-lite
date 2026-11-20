extends RefCounted
## S531 "SHE ASKED ABOUT YOUR GYM" (owner: "build 1, 2 and 3 but it has to be distinct from theirs";
## DESIGN_THREE_FROM_P4P_S531 s1). The boxer chooses, not the gym: after an amateur bout your boxer won, the beaten
## opponent may ask to train with you because of what your corner did that night. The pull is earned in the fight - the
## plan's lines that worked, the gym's name - never bought. She comes to RECEPTION as a walk-in (the same interview and
## sign flow as any walk-in), with her real record from the bout.
## Pure: BoutFinish asks; the dict it returns becomes career.applicant.
##   chance(worked, used, reputation, opp_wins, her_wins) -> float
##   walkin(opp, f, day) -> the fighter dict for reception
##   reason(worked, used, stopped) -> the one line she says

const BASE := 0.08
const PER_WORKED := 0.06    # each plan line that worked that night
const WORKED_MAX := 4
const REP_MAX_ADD := 0.15   # reputation 100 adds this
const BIGGER_CLUB := 0.10   # she has more wins than your boxer: her own club is doing fine by her
const CAP := 0.45
const ROSTER_MAX := 6       # the small roster (scope): no ask past this
const WAIT_DAYS := 7        # she waits at reception a week, then goes back to her club (time never stops for her)


## Whether her week at reception is over (Sim.step_day clears her and says so).
static func gone(applicant: Dictionary, day: int) -> bool:
	return bool(applicant.get("from_card", false)) and day > int(applicant.get("expires", day))


static func chance(worked: int, used: int, reputation: int, opp_wins: int, her_wins: int) -> float:
	var p := BASE + PER_WORKED * float(mini(worked, WORKED_MAX))
	if used > 0 and worked * 2 >= used:
		p += 0.05   # the plan worked more often than not: the other corner saw it
	p += REP_MAX_ADD * clampf(float(reputation) / 100.0, 0.0, 1.0)
	if opp_wins > her_wins:
		p -= BIGGER_CLUB
	return clampf(p, 0.0, CAP)


## Whether she asks: an amateur win, reception empty, room on the roster, and the roll under the chance.
static func asks(won: bool, pro: bool, reception_free: bool, roster: int, p: float, roll: float) -> bool:
	return won and not pro and reception_free and roster < ROSTER_MAX and roll < p


## What she says at reception: why your corner, from the night itself.
static func reason(worked: int, used: int, stopped: bool) -> String:
	if stopped:
		return "\"Your boxer stopped me, and I never saw it coming from your corner. I want to learn that side of it.\""
	if used > 0 and worked * 2 >= used:
		return "\"Your corner had my number all night - every time I set something up, your boxer was already gone. Can I train here?\""
	return "\"I lost, but I watched your corner work between rounds. That's the coaching I've been missing.\""


## The opponent as a walk-in: her record and age from the bout, her ability spread from her rating, the division's weight.
static func walkin(opp: Dictionary, f: Dictionary, day: int) -> Dictionary:
	var name := str(opp.get("name", "A boxer"))
	var first := str(opp.get("first", name.split(" ")[0]))
	var rating := float(opp.get("rating", 52.0))
	var age := int(opp.get("age", 22))
	var h := absi(name.hash())
	var stats := {}
	var k := 0
	for s in ["power", "speed", "technique", "defense", "conditioning", "fight_iq", "chin"]:
		stats[s] = snappedf(clampf(rating + float(((h >> (k * 3)) % 11) - 5), 30.0, 90.0), 0.1)
		k += 1
	var limit := float(f.get("limit", 60.0))
	return {"id": "card_%d" % absi(h), "name": name, "first": first, "sex": str(f.get("sex", "f")), "age": age,
		"wc": str(f.get("wc", "")), "limit": limit, "weight": snappedf(limit + 1.2, 0.1), "stance": str(opp.get("stance", "orthodox")),
		"style": str(opp.get("style", "Boxer-puncher")), "w": int(opp.get("w", 0)), "l": int(opp.get("l", 0)),
		"pot": clampi(int(rating) + 8 + maxi(0, 24 - age) * 2, int(rating) + 3, 88), "cards": [], "focus": "technique",
		"div": str(f.get("div", "")), "diet": "hold", "fatigue": 20, "weekly_salary": 250, "booked_fight": false, "history": [],
		"stats": stats, "goal": {}, "club_before": str(opp.get("club", "")), "met_day": day, "expires": day + WAIT_DAYS, "from_card": true}
