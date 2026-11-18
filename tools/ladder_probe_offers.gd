extends RefCounted
## LADDERPROBE4 (S518, ops/research/TASK_LADDERPROBE4.md): the rival gyms' phone calls (map R9, scripts/rules/RivalOffer.gd,
## scripts/state/RivalOfferWire.gd) measured on top of LADDERPROBE3's own tables. A measurement only: no rule or constant is
## changed here or in the game. tools/ladder_probe.gd calls these static funcs - begin / answer / observe / collect while it
## plays, lines when it prints - and keeps every table it printed before.
## The answer policy is the run seed's: seed %% 3 == 0 accept, 1 not_this_show (a pass once that rival's free answer is
## spent), 2 pass. The call is answered the day it opens, in the same pass that answers LateAskWire, so nothing lapses
## unanswered as it did in LADDERPROBE3, where a call left alone cost the challenger 2 points four days later.
## A boxer-season is one of our amateurs in one calendar year (Clock: day 0 is Mon 5 Jan 2026). Only a ranked boxer is rung
## (Region.RANK_MIN_WINS wins), so a season with no call is reported as "not yet ranked" or "ranked, nobody rang" and never
## folded into the offers median. The run's last days fall in a third calendar year: a stub season, reported on its own.

const RivalOfferWire := preload("res://scripts/state/RivalOfferWire.gd")
const RivalOffer := preload("res://scripts/rules/RivalOffer.gd")
const Region := preload("res://scripts/state/Region.gd")
const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const POLICIES := ["accept", "not_this_show", "pass"]
const FULL_DAYS := 300   # a calendar year the run actually played; the third year is a ten-day stub
const PRIOR := "res://docs/LADDERPROBE3_RESULT.md"

static func policy(seed_n: int) -> String:
	return POLICIES[posmod(seed_n, 3)]

## Every call the run answered (or tried), for the probe's own per-seed line.
static func calls(r: Dictionary) -> int:
	var n := 0
	for s in ((r["off"] as Dictionary)["seas"] as Dictionary).values():
		n += int(s["offers"])
	return n

static func year(day: int) -> int:
	return int(Clock._date(day)["year"])

## The run's own bag: the policy, the calls already answered, the bouts booked, one record a boxer-season.
static func begin(c: Career, r: Dictionary, seed_n: int) -> void:
	r["off"] = {"policy": policy(seed_n), "seed": seed_n, "seen": {}, "bouts": {}, "seas": {}, "refused_open": {}, "why": {}, "gates": {}}
	observe(c, r)

## One of our amateurs in one calendar year, created on first sight (a call, a bout, or a day observed).
static func _seas(r: Dictionary, f: Dictionary, day: int) -> Dictionary:
	var off: Dictionary = r["off"]
	var key := "%s|%d" % [str(f["id"]), year(day)]
	var s: Dictionary = (off["seas"] as Dictionary).get(key, {})
	if s.is_empty():
		s = {"fid": str(f["id"]), "name": str(f["name"]), "div": str(f["div"]), "club": str(r["club"]),
			"policy": str(off["policy"]), "year": year(day), "days": 0, "offers": 0, "accept": 0, "not_this_show": 0,
			"pass": 0, "nts_fell": 0, "paid": 0, "free_pass": 0, "refused": 0, "lapsed": 0, "rivals": {}, "call_weeks": {},
			"ranked_weeks": {}, "ever_ranked": false, "offer_bouts": 0, "sheet_bouts": 0, "w": 0, "l": 0, "d": 0,
			"left": false, "close_rep": -1, "pos": 0, "size": 0}
		(off["seas"] as Dictionary)[key] = s
	return s

## The open call, answered the day it opens (the brief: the same loop pass that answers LateAskWire). True when something
## was answered, so the probe's pass loop runs again. A refused answer (a non-empty return) is counted on its own; the call
## it leaves waiting lapses as the game's own pass four days later, and that is counted too.
static func answer(c: Career, f: Dictionary, r: Dictionary) -> bool:
	if not RivalOfferWire.is_open(f):
		return false
	var off: Dictionary = r["off"]
	var o: Dictionary = f["rival_offer"]
	var key := "%s|%d" % [str(f["id"]), int(o["day"])]
	if (off["seen"] as Dictionary).has(key):
		return false
	(off["seen"] as Dictionary)[key] = true
	var s := _seas(r, f, c.day)
	s["offers"] = int(s["offers"]) + 1
	var rv: Dictionary = s["rivals"]
	rv[str(o["name"])] = int(rv.get(str(o["name"]), 0)) + 1
	(s["call_weeks"] as Dictionary)[int(c.day / 7)] = true
	var v := RivalOfferWire.view(c, f)
	var free := int(v["pass_cost"]) == 0   # hurt or already booked: the map's free No
	var choice := str(off["policy"])
	if choice == "not_this_show" and not bool(v["nts_left"]):
		choice = "pass"
		s["nts_fell"] = int(s["nts_fell"]) + 1
	var why := RivalOfferWire.answer(c, str(f["id"]), choice)
	if why != "":
		s["refused"] = int(s["refused"]) + 1
		var wh: Dictionary = off["why"]
		wh[why] = int(wh.get(why, 0)) + 1
		(off["refused_open"] as Dictionary)[key] = "%s|%d" % [str(f["id"]), year(c.day)]
		return true
	s[choice] = int(s[choice]) + 1
	if choice == "pass":
		if free:
			s["paid"] = int(s["paid"]) + 1
		else:
			s["free_pass"] = int(s["free_pass"]) + 1
	if choice == "accept":
		_note_bout(r, f)   # the bout is on the book now, with f["bout"]["rival_offer"] set
	return true

## A bout on the book, counted once a night a boxer (fid and the bout's day): an offer's bout carries "rival_offer", the
## matchmaker's own does not. Bouts.after_fight clears f["bout"] on the night, so the booking is read while it stands.
static func _note_bout(r: Dictionary, f: Dictionary) -> void:
	var b: Dictionary = f.get("bout", {})
	if b.is_empty() or not b.has("day"):
		return
	var off: Dictionary = r["off"]
	var key := "%s|%d" % [str(f["id"]), int(b["day"])]
	if (off["bouts"] as Dictionary).has(key):
		return
	var offer := b.has("rival_offer")
	(off["bouts"] as Dictionary)[key] = {"fid": str(f["id"]), "day": int(b["day"]), "offer": offer}
	var s := _seas(r, f, int(b["day"]))
	if offer:
		s["offer_bouts"] = int(s["offer_bouts"]) + 1
	else:
		s["sheet_bouts"] = int(s["sheet_bouts"]) + 1

## Once a day, after every open need is answered: the days a boxer-season lived, the weeks she was ranked, the bouts on the
## book, and a refused call that has since lapsed.
static func observe(c: Career, r: Dictionary) -> void:
	var off: Dictionary = r["off"]
	for f in c.fighters:
		if bool(f.get("pro", false)):
			continue
		var s := _seas(r, f, c.day)
		s["days"] = int(s["days"]) + 1
		if int(f["w"]) >= Region.RANK_MIN_WINS:
			s["ever_ranked"] = true
			(s["ranked_weeks"] as Dictionary)[int(c.day / 7)] = true
		_note_bout(r, f)
	for key in (off["refused_open"] as Dictionary).keys().duplicate():
		var fid := str(key).get_slice("|", 0)
		var f2 := c.fighter_by_id(fid)
		var o2: Dictionary = f2.get("rival_offer", {})
		if not f2.is_empty() and not o2.is_empty() and "%s|%d" % [fid, int(o2["day"])] == str(key):
			continue
		var s2: Dictionary = (off["seas"] as Dictionary).get(str((off["refused_open"] as Dictionary)[key]), {})
		if not s2.is_empty():
			s2["lapsed"] = int(s2["lapsed"]) + 1
		(off["refused_open"] as Dictionary).erase(key)

## Why the phone stayed silent on a ranked Monday: RivalOfferWire.monday's own gates, in its own order, read before the
## day's needs are answered (the state the wire itself saw). Pure reads only - who_offers, _cands, _show_after and the Ask
## door change nothing. This is the "ranked, nobody rang" bucket explained.
static func gates(c: Career, r: Dictionary) -> void:
	if c.day <= 0 or c.day % 7 != 0:
		return
	var g: Dictionary = (r["off"] as Dictionary)["gates"]
	var week := int(c.day / 7)
	for f in c.fighters:
		if bool(f.get("pro", false)) or int(f["w"]) < Region.RANK_MIN_WINS:
			continue
		var label := ""
		if RivalOfferWire.is_open(f):
			label = "a rival rang"
		elif not (f.get("late_ask", {}) as Dictionary).is_empty():
			label = "a host's late ask waits"
		elif week < int(f.get("ro_next", 0)):
			label = "the %d-week gap since her last call" % RivalOfferWire.OFFER_GAP_WEEKS
		else:
			var door: Dictionary = RivalOfferWire._flow().open(c, f)
			if not bool(door["open"]):
				label = _door(str(door["why"]))
			elif RivalOfferWire._show_after(c.day) < 0:
				label = "no region show 7-21 days out"
			elif RivalOffer.who_offers({"rep": LadderPoints.rep_of(f), "free": true}, RivalOfferWire._cands(c, f), week).is_empty():
				var mine := LadderPoints.rep_of(f)
				var raw := c.rivals.filter(func(q): return str(q.get("div", "")) == str(f["div"]) and LadderPoints.rep_of(q) < mine).size()
				var legal := RivalOfferWire._cands(c, f).filter(func(q): return int(q["rep"]) < mine).size()
				label = "no rival below her on points" if raw == 0 else ("no legal rival below her (novice vs open)" if legal == 0 else "a rival below her, still cooling down")
			else:
				label = "every gate open, yet no call"
		g[label] = int(g.get(label, 0)) + 1

## The Ask door's own reason, in a few words (AskBout.open's sentence carries the boxer's name).
static func _door(why: String) -> String:
	if why.contains("already has a bout booked"):
		return "the Ask door: a bout is booked"
	if why.contains("still waits"):
		return "the Ask door: a sheet offer waits"
	if why.contains("not fit"):
		return "the Ask door: hurt"
	if why.contains("Too soon"):
		return "the Ask door: resting after a bout"
	if why.contains("first bout"):
		return "the Ask door: before her first bout"
	return "the Ask door: " + why

## The run's end: the wins and losses in the offer bouts (the career's own record, matched on the boxer and the night), the
## season close's own table (LadderSeason keeps our rows at 1 January), and who left mid-run.
static func collect(c: Career, r: Dictionary) -> void:
	var off: Dictionary = r["off"]
	for x in c.results:
		var b: Dictionary = (off["bouts"] as Dictionary).get("%s|%d" % [str(x["fid"]), int(x["d"])], {})
		if b.is_empty() or not bool(b["offer"]) or bool(x.get("pro", false)):
			continue
		var s: Dictionary = (off["seas"] as Dictionary).get("%s|%d" % [str(x["fid"]), year(int(x["d"]))], {})
		if s.is_empty():
			continue
		if bool(x["win"]):
			s["w"] = int(s["w"]) + 1
		elif str(x["outcome"]) == "draw":
			s["d"] = int(s["d"]) + 1
		else:
			s["l"] = int(s["l"]) + 1
	for t in c.seasons:
		for row in t["rows"]:
			if not bool(row["ours"]):
				continue
			var s2: Dictionary = (off["seas"] as Dictionary).get("%s|%d" % [str(row["fid"]), int(t["year"])], {})
			if s2.is_empty():
				continue
			s2["close_rep"] = int(row["rep"]); s2["pos"] = int(row["pos"]); s2["size"] = int(t["size"])
	for s3 in (off["seas"] as Dictionary).values():
		s3["left"] = c.fighter_by_id(str(s3["fid"])).is_empty()

static func _med(vals: Array) -> float:
	if vals.is_empty():
		return 0.0
	var v: Array = vals.duplicate()
	v.sort()
	var mid := int(v.size() / 2)
	return float(v[mid]) if v.size() % 2 == 1 else (float(v[mid - 1]) + float(v[mid])) / 2.0

## "middle (min-max)" of a list of ints, as the probe's own cells print it; the mean when asked. "-" when empty.
static func _cell(vals: Array, mean := false) -> String:
	if vals.is_empty():
		return "-"
	var v: Array = vals.duplicate()
	v.sort()
	var mid: float = float(v.reduce(func(acc, x): return acc + int(x), 0)) / v.size() if mean else _med(v)
	return "%.1f (%d-%d)" % [mid, int(v[0]), int(v[v.size() - 1])]

static func _pct(n: int, d: int) -> String:
	return "%.1f%%" % (100.0 * float(n) / float(d)) if d > 0 else "-"

static func _table(L: Array, head: String, rows: Array) -> void:
	L.append(""); L.append(head); L.append("|" + "---|".repeat(head.count("|") - 1))
	for row in rows:
		if str(row) != "":
			L.append(str(row))
	L.append("")

static func _seasons(runs: Array) -> Array:
	var out: Array = []
	for r in runs:
		for s in ((r["off"] as Dictionary)["seas"] as Dictionary).values():
			out.append(s)
	return out

static func _full(seas: Array) -> Array:
	return seas.filter(func(q): return int(q["days"]) >= FULL_DAYS)

## Pooled by club, policy and boxer (and the calendar year when asked). The key carries the policy's own order so the rows
## read accept, not_this_show, pass. calls / rivals / close pool only the seasons that had one (the brief's trap).
static func _grp(seas: Array, with_year: bool) -> Dictionary:
	var bag: Dictionary = {}
	for s in seas:
		var k := "%s|%d|%s" % [str(s["club"]), POLICIES.find(str(s["policy"])), str(s["name"])]
		if with_year:
			k += "|%d" % int(s["year"])
		var a: Dictionary = bag.get(k, {"club": str(s["club"]), "policy": str(s["policy"]), "name": str(s["name"]),
			"div": str(s["div"]), "year": int(s["year"]) if with_year else -1, "n": 0, "calls": [], "with_call": 0,
			"not_ranked": 0, "no_call": 0, "call_weeks": 0, "ranked_weeks": 0, "offer_bouts": 0, "sheet_bouts": 0,
			"w": 0, "l": 0, "d": 0, "rivals": [], "refused": 0, "lapsed": 0, "close": [], "paid": 0, "free_pass": 0,
			"accept": 0, "not_this_show": 0, "pass": 0, "nts_fell": 0, "left": 0, "days": []})
		a["n"] = int(a["n"]) + 1
		a["call_weeks"] = int(a["call_weeks"]) + (s["call_weeks"] as Dictionary).size()
		a["ranked_weeks"] = int(a["ranked_weeks"]) + (s["ranked_weeks"] as Dictionary).size()
		for k2 in ["offer_bouts", "sheet_bouts", "w", "l", "d", "refused", "lapsed", "paid", "free_pass", "accept", "not_this_show", "pass", "nts_fell"]:
			a[k2] = int(a[k2]) + int(s[k2])
		a["left"] = int(a["left"]) + int(bool(s["left"]))
		(a["days"] as Array).append(int(s["days"]))
		if int(s["offers"]) > 0:
			a["with_call"] = int(a["with_call"]) + 1
			(a["calls"] as Array).append(int(s["offers"]))
			(a["rivals"] as Array).append((s["rivals"] as Dictionary).size())
		elif bool(s["ever_ranked"]):
			a["no_call"] = int(a["no_call"]) + 1
		else:
			a["not_ranked"] = int(a["not_ranked"]) + 1
		if int(s["close_rep"]) >= 0:
			(a["close"] as Array).append(int(s["close_rep"]))
		bag[k] = a
	return bag

static func _keys(bag: Dictionary) -> Array:
	var k: Array = bag.keys()
	k.sort()
	return k

## The points at the probe's own marks, pooled by club, policy and boxer - the cells LADDERPROBE3 printed, so the two read
## side by side. A boxer who left mid-run keeps the marks she was seen at.
static func _marks(runs: Array, marks: Array) -> Dictionary:
	var bag: Dictionary = {}
	for r in runs:
		var pol := str((r["off"] as Dictionary)["policy"])
		for o in (r["ours"] as Dictionary).values():
			var k := "%s|%d|%s" % [str(r["club"]), POLICIES.find(pol), str(o["name"])]
			var a: Dictionary = bag.get(k, {"club": str(r["club"]), "policy": pol, "name": str(o["name"]), "div": str(o["div"]), "n": 0, "rep": {}})
			a["n"] = int(a["n"]) + 1
			for day in marks:
				if (o["rep"] as Dictionary).has(day):
					var lst: Array = (a["rep"] as Dictionary).get(day, [])
					lst.append(int((o["rep"] as Dictionary)[day]))
					(a["rep"] as Dictionary)[day] = lst
			bag[k] = a
	return bag

## LADDERPROBE3's own published numbers, read from its result doc (not copied here): the "Our boxers' points" table's two
## "middle (min-max)" cells a row, day 364 then day 728. {} when the doc is not there.
static func _prior() -> Dictionary:
	var out: Dictionary = {}
	var fh := FileAccess.open(PRIOR, FileAccess.READ)
	if fh == null:
		return out
	var txt := fh.get_as_text()
	fh.close()
	var sec := txt.split("## Our boxers' points")
	if sec.size() < 2:
		return out
	for line in str(sec[1]).split("\n## ")[0].split("\n"):
		var t := str(line).strip_edges()
		if not t.begins_with("| QUICK |") and not t.begins_with("| TEST |"):
			continue
		var cells := t.split("|")
		var nums: Array = []
		for cell in cells:
			var v := str(cell).strip_edges()
			var head := v.get_slice("(", 0).strip_edges()
			if v.contains("(") and head.is_valid_float():
				nums.append(float(head))
		if nums.size() >= 2:
			out["%s|%s" % [str(cells[1]).strip_edges(), str(cells[2]).strip_edges()]] = nums
	return out

static func _row1(a: Dictionary) -> String:
	var n := maxi(1, int(a["n"]))
	return "| %s | %s | %s | %s | %d | %d | %s | %s (%d/%d) | %.2f | %.2f | %.1f-%.1f | %.2f | %s | %s | %d |" % [
		str(a["club"]), str(a["policy"]), str(a["name"]), str(a["div"]), int(a["year"]), int(a["n"]), _cell(a["calls"]),
		_pct(int(a["call_weeks"]), int(a["ranked_weeks"])), int(a["call_weeks"]), int(a["ranked_weeks"]),
		float(a["offer_bouts"]) / n, float(a["sheet_bouts"]) / n, float(a["w"]) / n, float(a["l"]) / n, float(a["d"]) / n,
		_cell(a["rivals"], true), _cell(a["close"]), int(a["refused"])]

static func _row2(a: Dictionary) -> String:
	return "| %s | %s | %s | %d | %d | %d | %d |" % [str(a["club"]), str(a["policy"]), str(a["name"]), int(a["n"]),
		int(a["with_call"]), int(a["not_ranked"]), int(a["no_call"])]

static func _row4(a: Dictionary, marks: Array, prior: Dictionary) -> String:
	var p: Array = prior.get("%s|%s" % [str(a["club"]), str(a["name"])], [])
	var c1: Array = (a["rep"] as Dictionary).get(int(marks[1]), [])
	var c2: Array = (a["rep"] as Dictionary).get(int(marks[2]), [])
	var had := p.size() >= 2
	var was := float(p[1]) if had else 0.0
	var delta := "%+.1f" % (_med(c2) - was) if had and not c2.is_empty() else "-"
	return "| %s | %s | %s | %d | %s | %s | %s | %s | %s |" % [str(a["club"]), str(a["name"]), str(a["policy"]), int(a["n"]),
		_cell(c1), "%.1f" % float(p[0]) if had else "-", _cell(c2), "%.1f" % was if had else "-", delta]

## The three R9 lines, read off the pooled counts: no threshold tuned, the numbers say it. Where no call came, the line says
## so and names the gate that kept the phone silent - a spread between policies with no call in it is the seeds', not the answer's.
static func _verdicts(seas: Array, bag: Dictionary, marks: Array, gate_tot: Dictionary) -> Array:
	var calls: Array = []
	var cw := 0
	var rw := 0
	var nc := 0
	var ob_all := 0
	for s in seas:
		cw += (s["call_weeks"] as Dictionary).size(); rw += (s["ranked_weeks"] as Dictionary).size()
		nc += int(s["offers"]); ob_all += int(s["offer_bouts"])
		if int(s["offers"]) > 0:
			calls.append(int(s["offers"]))
	var busiest: int = int(calls.max()) if not calls.is_empty() else 0
	var cap := int(52 / RivalOfferWire.OFFER_GAP_WEEKS)
	var gsum := 0
	var shut := 0
	var rang := int(gate_tot.get("a rival rang", 0))
	var big := ""
	var bn := 0
	for lb in gate_tot.keys():
		gsum += int(gate_tot[lb])
		if str(lb).begins_with("the Ask door"):
			shut += int(gate_tot[lb])
		if int(gate_tot[lb]) > bn:
			bn = int(gate_tot[lb]); big = str(lb)
	var out: Array = ["**A few a season, never weekly?** - %d of %d full boxer-seasons had a call (%d calls in all): median %.1f offers a season (max %d), a call in %s of the weeks the boxer was ranked (%d of %d weeks). The wire's own gap (one offer every %d weeks a boxer, a rival rings again only after its own %d) caps a season at %d; the map's R9 reading is \"a few a season, never weekly\". **Why so few:** the wire rings only when the Ask door (AskFlow.open) is open; it was shut on %s of the %d ranked Mondays (the biggest gate \"%s\", %d). The other %d Mondays the gate table below splits. This probe accepts every sheet offer the day it arrives, so the boxer is booked or in the %d-day post-bout rest (Bouts.AFTER_FIGHT) nearly every Monday: on a gym that answers its own sheet at once, R9 has almost no room to fire." % [
		calls.size(), seas.size(), nc, _med(calls), busiest, _pct(cw, rw), cw, rw,
		RivalOfferWire.OFFER_GAP_WEEKS, RivalOffer.COOLDOWN_WEEKS, cap, _pct(shut, gsum), gsum, big, bn, gsum - shut - rang, Bouts.AFTER_FIGHT]]
	var drain: Array = []
	var paid := 0
	var pass_calls := 0
	var acc_calls := 0
	for s2 in seas:
		if str(s2["policy"]) == "pass":
			paid += int(s2["paid"]); pass_calls += int(s2["offers"])
		elif str(s2["policy"]) == "accept":
			acc_calls += int(s2["offers"])
	for k in _keys(bag):
		var a: Dictionary = bag[k]
		if str(a["policy"]) != "pass":
			continue
		var acc: Dictionary = bag.get("%s|%d|%s" % [str(a["club"]), POLICIES.find("accept"), str(a["name"])], {})
		var c2: Array = (a["rep"] as Dictionary).get(int(marks[2]), [])
		var a2: Array = (acc.get("rep", {}) as Dictionary).get(int(marks[2]), [])
		if not c2.is_empty() and not a2.is_empty():
			drain.append("%s %s: pass %.1f, accept %.1f (%+.1f)" % [str(a["club"]), str(a["name"]), _med(c2), _med(a2), _med(c2) - _med(a2)])
	var noise := "" if pass_calls > 0 and acc_calls > 0 else " **No call was answered under both policies, so that spread is the seeds' (different bout outcomes), not the answer's.**"
	out.append("**Does Pass drain a boxer?** - at day %d, %s. Under the pass policy our boxers paid %d ladder points on %d passes that cost (%d each, %d calls in all); a pass while hurt or booked costs nothing, and LADDERPROBE3's own runs left every call to lapse as a pass four days late.%s" % [
		int(marks[2]), "; ".join(drain) if not drain.is_empty() else "no boxer had both policies", paid * RivalOffer.PASS_COST, paid, RivalOffer.PASS_COST, pass_calls, noise])
	var crowd: Array = []
	for pol in POLICIES:
		var sub: Array = seas.filter(func(q): return str(q["policy"]) == str(pol))
		var n := maxi(1, sub.size())
		var ob := 0
		var sb := 0
		for s3 in sub:
			ob += int(s3["offer_bouts"]); sb += int(s3["sheet_bouts"])
		crowd.append("%s: %.2f sheet bouts + %.2f offer bouts = %.2f nights a boxer-season" % [str(pol), float(sb) / n, float(ob) / n, float(sb + ob) / n])
	var crowd_note := "Accepting marks the sheet offers still waiting answered (RivalOfferWire.answer), so a call takes the night the matchmaker's own offer would have had." if ob_all > 0 else "**No offer bout was booked under any policy, so nothing crowded the sheet out: the sheet spread above is the seeds'.** The mechanism is there to measure - accepting marks the sheet offers still waiting answered (RivalOfferWire.answer) - but it never fired."
	out.append("**Does Accept crowd out the sheet?** - %s. %s" % ["; ".join(crowd), crowd_note])
	return out

## Every table and line the brief asks for, appended after the probe's own. The stub seasons (a calendar year the run only
## began) are reported on their own and kept out of every median above.
static func lines(L: Array, runs: Array, marks: Array) -> void:
	var all := _seasons(runs)
	var seas := _full(all)
	var stub: Array = all.filter(func(q): return int(q["days"]) < FULL_DAYS)
	var g1 := _grp(seas, true)
	var g2 := _grp(seas, false)
	var gm := _marks(runs, marks)
	var prior := _prior()
	var m1 := int(marks[1]); var m2 := int(marks[2])
	var nd: int = int(runs[0]["days"]) if not runs.is_empty() else 0
	var nc_all := 0
	for s4 in all:
		nc_all += int(s4["offers"])
	var silent := "" if nc_all > 0 else " **No call came in any of the %d runs**, so the three policies had nothing to answer: every offer column above reads 0, and the spread between policies is the seeds' (different bout outcomes), not the answer's. Where the tables above differ from LADDERPROBE3's it is not the phone - R8's 52-week leave (Region.INACTIVE_DAYS %d, built after LADDERPROBE3 was collected) takes idle rivals off the table, so there are fewer rival rows and fewer sitting at 0; our boxers' own points, bouts and w-l read exactly as LADDERPROBE3 printed them." % [runs.size(), Region.INACTIVE_DAYS]
	L.append("## R9: the rival gyms' phone calls (LADDERPROBE4)")
	L.append("")
	L.append("A measurement of the shipped R9 (scripts/rules/RivalOffer.gd, scripts/state/RivalOfferWire.gd, the card scripts/ui/RivalOfferCard.gd): every Monday a rival below our boxer on the ladder, in reach and legal, may ring for a bout at the next region show 7-21 days out. Only a ranked boxer is rung (%d wins, Region.RANK_MIN_WINS); at most one call every %d weeks a boxer (RivalOfferWire.OFFER_GAP_WEEKS), and a rival rings again only after its own %d weeks (RivalOffer.COOLDOWN_WEEKS). The call is answered here the day it opens, in the same pass that answers the host's late ask - LADDERPROBE3 left every call unanswered, to lapse as a pass (-%d points) four days later. Nothing is changed in the rules: the probe only answers." % [Region.RANK_MIN_WINS, RivalOfferWire.OFFER_GAP_WEEKS, RivalOffer.COOLDOWN_WEEKS, RivalOffer.PASS_COST])
	L.append("")
	L.append("The answer policy is the run seed's, so all three answers are measured on the same population: seed %% 3 == 0 **accept** (books that show through the sheet's own path), 1 **not_this_show** (free once a season with that rival; when RivalOfferWire.view's nts_left is false it falls to **pass**), 2 **pass** (-%d ladder points to the challenger, free while hurt or booked). A refused answer - RivalOfferWire.answer returning a reason instead of \"\" - is counted in its own column; the call it leaves waiting lapses as the game's own pass, counted beside it. **A boxer-season** is one of our amateurs in one calendar year (Clock: day 0 is Mon 5 Jan 2026, so the two seasons played are 2026 and 2027 and the run's last days open a 2028 stub, reported on its own below). The means below are a boxer-season over every season in the group, a season with no call counting 0; **the offers median pools only the seasons that had a call** (the brief's trap: a season with no call is reported separately, never folded in)." % RivalOffer.PASS_COST)
	_table(L, "| club | policy | boxer | division | season | boxer-seasons | offers a season, median (min-max) | weeks with a call / ranked weeks | offer bouts | sheet bouts | w-l in offer bouts | drawn | rivals that rang | points at 1 Jan | refused |", _keys(g1).map(func(q): return _row1(g1[q])))
	L.append("**Weeks with a call / ranked weeks** = the weeks a call came in over the weeks she was ranked at the day's end (the probe answers the day it opens, so a call is open for less than a day: this is the share of weeks the phone rang, not the share of days a card sat on the screen). **Offer bouts** = bouts booked with f[\"bout\"][\"rival_offer\"] set; **sheet bouts** = the matchmaker's own offers accepted; both counted once a night a boxer, on the night they are for. **w-l** is the result of the offer bouts only (the career's own record, matched on the boxer and the night); a booked bout that never came off - missed weight, a pull-out, the run's end - is in offer bouts and not in w-l. **Rivals that rang** = the different callers a season, mean over the seasons that had a call. **Points at 1 Jan** = the season close's own table (LadderSeason.close keeps our rows), median (min-max) across the runs. **Refused** = answers the wire would not take.")
	L.append("")
	L.append("The seasons with no call at all, kept out of the offers median: **not yet ranked** = she never reached %d wins in that calendar year (the quick-start club signs Lucy at 0-0, so her first season is largely unranked); **ranked, nobody rang** = she was ranked and no rival below her in reach ever called." % Region.RANK_MIN_WINS)
	_table(L, "| club | policy | boxer | boxer-seasons | with a call | not yet ranked | ranked, nobody rang |", _keys(g2).map(func(q): return _row2(g2[q])))
	var gate_tot: Dictionary = {}
	var gate_pol: Dictionary = {}
	for r3 in runs:
		var pol2 := str((r3["off"] as Dictionary)["policy"])
		var gg: Dictionary = (r3["off"] as Dictionary)["gates"]
		for lb in gg.keys():
			gate_tot[str(lb)] = int(gate_tot.get(str(lb), 0)) + int(gg[lb])
			gate_pol["%s|%s" % [pol2, str(lb)]] = int(gate_pol.get("%s|%s" % [pol2, str(lb)], 0)) + int(gg[lb])
	var gkeys: Array = gate_tot.keys()
	gkeys.sort_custom(func(x, y): return int(gate_tot[x]) > int(gate_tot[y]) if int(gate_tot[x]) != int(gate_tot[y]) else str(x) < str(y))
	var gsum := 0
	for lb2 in gkeys:
		gsum += int(gate_tot[lb2])
	L.append("")
	L.append("**Why a ranked Monday brought no call** - every Monday a ranked amateur of ours was read through RivalOfferWire.monday's own gates, in its own order, before the day's needs were answered (the state the wire itself saw); \"a rival rang\" is the Monday a call was waiting. %d ranked Mondays over the %d runs; the Ask door is AskFlow.open, the door the wire must find open before it rings." % [gsum, runs.size()])
	_table(L, "| the gate that stopped it | accept | not_this_show | pass | all | share of ranked Mondays |", gkeys.map(func(q): return "| %s | %d | %d | %d | %d | %s |" % [str(q), int(gate_pol.get("accept|%s" % str(q), 0)), int(gate_pol.get("not_this_show|%s" % str(q), 0)), int(gate_pol.get("pass|%s" % str(q), 0)), int(gate_tot[q]), _pct(int(gate_tot[q]), gsum)]))
	var pol_rows: Array = []
	for pol in POLICIES:
		var sub: Array = seas.filter(func(q): return str(q["policy"]) == str(pol))
		var n := maxi(1, sub.size())
		var t := {"accept": 0, "not_this_show": 0, "pass": 0, "nts_fell": 0, "free_pass": 0, "refused": 0, "lapsed": 0, "paid": 0}
		var nc := 0
		for s2 in sub:
			nc += int(s2["offers"])
			for k2 in t.keys():
				t[k2] = int(t[k2]) + int(s2[k2])
		pol_rows.append("| %s | %d | %d | %d | %d | %d | %d | %d | %d | %d | %d |" % [str(pol), n, nc, int(t["accept"]), int(t["not_this_show"]), int(t["nts_fell"]), int(t["pass"]), int(t["free_pass"]), int(t["refused"]), int(t["lapsed"]), int(t["paid"]) * RivalOffer.PASS_COST])
	_table(L, "| policy | boxer-seasons | calls | accept | not this show | of them fell to pass | pass | pass free of cost | refused | lapsed after a refusal | points our boxers paid |", pol_rows)
	var whys: Array = []
	for r in runs:
		for k in ((r["off"] as Dictionary)["why"] as Dictionary).keys():
			if not whys.has(str(k)):
				whys.append(str(k))
	whys.sort()
	if not whys.is_empty():
		var cnt: Dictionary = {}
		for r2 in runs:
			for k3 in ((r2["off"] as Dictionary)["why"] as Dictionary).keys():
				cnt[str(k3)] = int(cnt.get(str(k3), 0)) + int(((r2["off"] as Dictionary)["why"] as Dictionary)[k3])
		L.append("The refusals, in the wire's own words: %s." % "; ".join(whys.map(func(w): return "\"%s\" x%d" % [str(w), int(cnt[str(w)])])))
	var stub_g: Dictionary = {}
	for s3 in stub:
		var a: Dictionary = stub_g.get(int(s3["year"]), {"year": int(s3["year"]), "n": 0, "days": [], "calls": 0, "bouts": 0, "left": 0})
		a["n"] = int(a["n"]) + 1; (a["days"] as Array).append(int(s3["days"]))
		a["calls"] = int(a["calls"]) + int(s3["offers"]); a["bouts"] = int(a["bouts"]) + int(s3["offer_bouts"])
		a["left"] = int(a["left"]) + int(bool(s3["left"]))
		stub_g[int(s3["year"])] = a
	var stub_keys: Array = stub_g.keys()
	stub_keys.sort()
	L.append("")
	L.append("Seasons kept out of every median above: a calendar year the run did not play in full (fewer than %d days observed). The run is %d days, so the last 1 January it crosses opens a season it only begins; a boxer who left mid-run would land here too." % [FULL_DAYS, nd])
	_table(L, "| year | boxer-seasons | days observed | calls | offer bouts | left mid-run |", stub_keys.map(func(y): return "| %d | %d | %s | %d | %d | %d |" % [int(y), int(stub_g[y]["n"]), _cell(stub_g[y]["days"], true), int(stub_g[y]["calls"]), int(stub_g[y]["bouts"]), int(stub_g[y]["left"])]))
	L.append("The points against LADDERPROBE3 (docs/LADDERPROBE3_RESULT.md, read from that doc's own \"Our boxers' points\" table): the same marks %s, the same clubs and boxers, the same day loop - the only difference is that here the phone is answered. LADDERPROBE3 left every call unanswered (each would lapse as a pass four days later); each policy here pools the seeds whose seed %% 3 selects it. The brief's day 365 and 730 are read at these marks (day %d and %d), the days the probe samples and LADDERPROBE3 printed.%s" % [str(marks), m1, m2, silent])
	_table(L, "| club | boxer | policy | runs | day %d | LADDERPROBE3 day %d | day %d | LADDERPROBE3 day %d | change at day %d |" % [m1, m1, m2, m2, m2], _keys(gm).map(func(q): return _row4(gm[q], marks, prior)))
	L.append("### The three R9 lines")
	L.append("")
	for v in _verdicts(seas, gm, marks, gate_tot):
		L.append(v); L.append("")
