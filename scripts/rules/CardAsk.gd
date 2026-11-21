extends RefCounted
## THE VISIT (S531 "she asked about your gym"; S533 P4PBUILD1 stage 1, DESIGN_THREEP4P_V2 section 3). After an amateur
## bout your boxer won, the beaten opponent may ask to train here because of what your corner did that night. Coaching
## earns the attention; it is never bought. The gates, in order:
##   1. an amateur win, against a boxer of the region (a rival row: the identity that moves on signing);
##   2. EVIDENCE from the settled exchanges: a call your boxer heard, that fitted, on the ropes, and the next exchange was
##      off the ropes ("after the call", never "because of"); or the same planned line winning twice on the ropes;
##   3. reception empty, a place free in the club, no 120-day wait running on that boxer;
##   4. a seeded roll under chance(): bounded, never certain. A repeated easy win adds nothing: with no pressure there
##      is no evidence, and the plan's part is a share of the night, not a count.
## Pure: VisitWire asks; the dict walkin() returns becomes career.applicant.
##   evidence(rounds) -> {qualifies, kind: "call" | "line" | "", what, count, refs: [[round, exchange]], pressure}
##   chance(reputation, qualifies, worked, used) -> float      asks(...) -> bool
##   reason(ev, what_words) -> the one line said at reception  walkin(rival, f, day) -> the fighter dict for reception
##   gone(applicant, day)   cooled(rival, day)   trial_day_for(applicant, day) -> the Monday, or -1

const BASE := 0.05
const REP_PER_POINT := 0.001   # the gym's name: reputation 100 adds 0.10
const REP_MAX := 100
const EVIDENCE := 0.03         # once a bout, however often the line repeated
const SHARE_MAX := 0.07        # the plan's share of the night: every planned exchange won adds all of it
const CAP := 0.25
const WAIT_DAYS := 7           # at reception through day + 7, gone the day after (time never stops for a visitor)
const COOLDOWN_DAYS := 120     # after a pass or an expiry that boxer does not ask again
const TRIAL_DECIDE_DAYS := 1   # after the trial: one more day to sign or pass
const REPEAT_MIN := 2          # the same planned line, on the ropes, on this many different exchanges
const FITS := ["best", "ok"]


## Pressure as the exchange recorded it: your boxer started it on the own ropes, or pinned there.
static func under_pressure(x: Dictionary) -> bool:
	return str(x.get("at", "")) == "own_ropes" or bool(x.get("pinned", false))


## What the other corner could have seen, from the bout's closed rounds (each round's "exchanges").
static func evidence(rounds: Array) -> Dictionary:
	var lines := {}
	var calls: Array = []
	var pressure := 0
	for r in rounds:
		if not (r is Dictionary):
			continue
		var exs: Array = r.get("exchanges", [])
		for i in exs.size():
			var x: Dictionary = exs[i]
			if not under_pressure(x):
				continue
			pressure += 1
			if not bool(x.get("won", false)):
				continue
			var ref := [int(r.get("n", 0)), i + 1]
			if bool(x.get("planned", false)) and str(x.get("arrow_fit", "")) in FITS and str(x.get("arrow", "")) != "":
				var got: Array = lines.get(str(x["arrow"]), [])
				got.append(ref)
				lines[str(x["arrow"])] = got
			# A call counts only when heard, fitted, and the NEXT exchange of the round opened off the ropes.
			if bool(x.get("shout", false)) and str(x.get("fit", "")) in FITS and i + 1 < exs.size() and not under_pressure(exs[i + 1]):
				calls.append({"call": str(x.get("call", "")), "ref": ref})
	if not calls.is_empty():
		return {"qualifies": true, "kind": "call", "what": str(calls[0]["call"]), "count": calls.size(),
			"refs": calls.slice(0, 2).map(func(k): return k["ref"]), "pressure": pressure}
	var best := ""
	for id in lines:
		if (lines[id] as Array).size() >= REPEAT_MIN and (best == "" or (lines[id] as Array).size() > (lines[best] as Array).size()):
			best = str(id)
	if best != "":
		return {"qualifies": true, "kind": "line", "what": best, "count": (lines[best] as Array).size(),
			"refs": (lines[best] as Array).slice(0, 2), "pressure": pressure}
	return {"qualifies": false, "kind": "", "what": "", "count": 0, "refs": [], "pressure": pressure}


## The seeded chance once the gates are open. worked / used = the plan's exchanges won / fought that night.
static func chance(reputation: int, qualifies: bool, worked: int, used: int) -> float:
	var p := BASE + REP_PER_POINT * float(clampi(reputation, 0, REP_MAX))
	if qualifies:
		p += EVIDENCE
	if used > 0:
		p += SHARE_MAX * clampf(float(worked) / float(used), 0.0, 1.0)
	return clampf(p, 0.0, CAP)


static func asks(won: bool, pro: bool, reception_free: bool, place_free: bool, linked: bool, is_cooled: bool,
		qualifies: bool, p: float, roll: float) -> bool:
	return won and not pro and reception_free and place_free and linked and is_cooled and qualifies and roll < p


## Why a qualifying night brought nobody ("" = the roll, which is nobody's fault).
static func blocked(reception_free: bool, place_free: bool, linked: bool, is_cooled: bool) -> String:
	if not linked:
		return "the opponent is not a boxer of this region"
	if not is_cooled:
		return "the opponent was turned away here not long ago"
	if not reception_free:
		return "someone is already at reception"
	if not place_free:
		return "every place in the club is taken"
	return ""


## What the visitor says at reception: the exact thing the corner did. what_words = the call's or the line's own name.
static func reason(ev: Dictionary, what_words: String) -> String:
	if str(ev.get("kind", "")) == "call":
		return "\"Your boxer was on the ropes, your corner called %s, and after the call the ring was open again. Nobody calls that for me.\"" % what_words
	if str(ev.get("kind", "")) == "line":
		return "\"%d times I had your boxer on the ropes, and %d times the same answer came back: %s. That was drilled. I want that.\"" % [
			int(ev.get("count", 0)), int(ev.get("count", 0)), what_words]
	return "\"I lost, and I watched your corner work. Can I train here?\""


## The same thing as the result page says it (no speaker, no name).
static func noticed(ev: Dictionary, what_words: String) -> String:
	if str(ev.get("kind", "")) == "call":
		return "%s, called with your boxer on the ropes, and the next exchange was fought off them" % what_words
	return "%s got your boxer off the ropes %d times" % [what_words, int(ev.get("count", 0))]


static func gone(applicant: Dictionary, day: int) -> bool:
	return bool(applicant.get("from_card", false)) and day > int(applicant.get("expires", day))


## Whether this boxer may ask (again): no wait running from a pass or an expiry.
static func cooled(rival: Dictionary, day: int) -> bool:
	return day >= int(rival.get("visit_cool", -1))


## The one trial a visit can hold: next Monday, when it falls inside the visit and none was booked. -1 = none.
static func trial_day_for(applicant: Dictionary, day: int) -> int:
	var monday := day - posmod(day, 7) + 7
	if int(applicant.get("trial_day", -1)) >= 0 or monday > int(applicant.get("expires", -1)):
		return -1
	return monday


static func trial_seen(applicant: Dictionary, day: int) -> bool:
	return int(applicant.get("trial_day", -1)) >= 0 and day >= int(applicant["trial_day"])


## The region's boxer as a walk-in: today's record, age, style and club from the rival row; the division, limit and sex
## of the bout just boxed (a bout is always inside one division). The row carries no ability numbers, so those are read
## from the rating the same way every time (the id and the spread come from the name).
static func walkin(rival: Dictionary, f: Dictionary, day: int) -> Dictionary:
	var name := str(rival.get("name", "A boxer"))
	var first := str(rival.get("first", name.split(" ")[0]))
	var rating := float(rival.get("rating", 52.0))
	var age := int(rival.get("age", 22))
	var h := absi(name.hash())
	var stats := {}
	var k := 0
	for s in ["power", "speed", "technique", "defense", "conditioning", "fight_iq", "chin"]:
		stats[s] = snappedf(clampf(rating + float(((h >> (k * 3)) % 11) - 5), 30.0, 90.0), 0.1)
		k += 1
	var limit := float(f.get("limit", 60.0))
	return {"id": "card_%d" % absi(h), "name": name, "first": first, "sex": str(f.get("sex", "f")), "age": age,
		"wc": str(f.get("wc", "")), "limit": limit, "weight": snappedf(limit + 1.2, 0.1), "stance": str(rival.get("stance", "orthodox")),
		"style": str(rival.get("style", "Boxer-puncher")), "w": int(rival.get("w", 0)), "l": int(rival.get("l", 0)),
		"pot": clampi(int(rating) + 8 + maxi(0, 24 - age) * 2, int(rating) + 3, 88), "cards": [], "focus": "technique",
		"div": str(f.get("div", "")), "diet": "hold", "fatigue": 20, "weekly_salary": 250, "booked_fight": false, "history": [],
		"stats": stats, "goal": {}, "club_before": str(rival.get("club", "")), "met_day": day, "expires": day + WAIT_DAYS,
		"from_card": true, "rival": name, "trial_day": -1}
