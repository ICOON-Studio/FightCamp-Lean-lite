extends RefCounted
## S481 FIGHTWEEK2 (his S473 "Yes, build it", Q-238 v9 "Yes, approve", C402 "ok" on the partner screen): the amateur FIGHT
## WEEK as the player sets it - the load stop, 0-2 fight-week sparring nights and one week-before night, each with a picked
## sparring partner, the weight way and the film night - and the LOCK that writes it into the bout the fight already reads:
##   bout.load (WeekPhase.week_for, BoutRules.tank_parts_for), bout.spar_days + bout.eat_less (the tank's choice layer),
##   bout.r1_edge (BoutRules round-1 power edge: the best night's PartnerMatch edge, plus Rest up's flat round), bout.unsparred
##   (FireLevel.round_mastery: lines still unsparred fire a level down in rounds 1-2), bout.fw_film (WeekPlan: the film night
##   takes a pad night), f.sparred (the plan lines she has sparred).
## A plan LINE is unsparred when its key (move|when) is not in f.sparred; f.sparred is filled with her whole plan the day the
## bout is booked (mark), so only lines written or changed after the booking are unsparred - the v9 rule.
## Partners: two from our own club (free) and three from other clubs ($160, or a favour with that club). Deterministic from
## the fighter and the bout day, so a reload shows the same list.
##   mark(c, f)  is_open(f)  lines(f)  partners(c, f)  opp_known(f)  draft(c, f)  read(c, f, plan)  lock(c, f, plan) -> ""|why

const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const FightWeekPick := preload("res://scripts/rules/FightWeekPick.gd")
const PartnerMatch := preload("res://scripts/rules/PartnerMatch.gd")
const WeighGap := preload("res://scripts/rules/WeighGap.gd")
const RegionShows := preload("res://scripts/rules/RegionShows.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")

const RATING_STATS := ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]   # = Champs.RATING_STATS
const STYLES := ["Out-boxer", "Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher"]
const STANCES := ["orthodox", "southpaw"]
const OWN_PARTNERS := 2
const OUTSIDE_PARTNERS := 3
const FAVOURS_START := 1   # every host club starts one favour up (FightWeekEvents.FAVOURS_MAX 3)
## Fight-week nights sit 2-6 days out (the day before is the weigh-in); a week-before night 8 days out.
const SPAR_FIRST := 6
const SPAR_LAST := 2
const WEEK_BEFORE := 8


## Called the day an amateur bout is booked (Bouts.accept): marks it a fight week (no camp), names the show's host and
## files her whole plan as sparred.
static func mark(c: Career, f: Dictionary) -> void:
	var b: Dictionary = f["bout"]
	if bool(b.get("pro", false)) or bool(f.get("pro", false)) or b.has("champ"):
		return
	b["fight_week"] = true
	b["load"] = FightWeek.DEFAULT_STOP   # an unset week runs on the map's default, Tick over (his Q-229 note: one rest day)
	var hosts: Array = RegionShows.HOSTS
	b["host"] = str(hosts[posmod(hash("%s|%d" % [str(f["id"]), int(b["day"])]), hosts.size())])
	var keys: Array = []
	for a in f.get("arrows", []):
		keys.append(key_of(a))
	f["sparred"] = keys


static func key_of(arrow: Dictionary) -> String:
	return "%s|%s" % [str(arrow.get("move", "")), str(arrow.get("when", ""))]


## The week can still be set: a fight-week bout, not locked, not fought.
static func is_open(f: Dictionary) -> bool:
	var b: Dictionary = f.get("bout", {})
	return WeekPhase.amateur(b) and not bool(b.get("fw_locked", false)) and not bool(b.get("done", false))


## Her plan lines in ring order: [{id, move, when, text, unsparred}]. No f.sparred = every line sparred (today's game).
static func lines(f: Dictionary) -> Array:
	var arrows: Array = f.get("arrows", [])
	var done: Array = f.get("sparred", [])
	var out: Array = []
	for row in PlanLines.lines(arrows):
		var ln: Dictionary = row
		var a: Dictionary = arrows[int(ln["i"])]
		var k := key_of(a)
		var where := str(PlanLines.PLACE_WORDS.get(str(ln["place"]), str(ln["place"])))
		var mv := str(StrikeMap.move(str(ln["move"])).get("name", str(ln["move"])))
		var w := str(ln["when"])
		var text := "%s -> %s" % [where if w == "" else "If " + str(FightFlow.WHEN_WORDS.get(w, "the opponent " + w)), mv]
		out.append({"id": k, "move": str(ln["move"]), "when": str(ln["when"]), "text": text,
			"unsparred": f.has("sparred") and not done.has(k)})
	return out


## The opponent as PartnerMatch reads her: only what is known (style and stance from the booking, reach once filmed or on
## the poster, the FILMED tells).
static func opp_known(f: Dictionary) -> Dictionary:
	var o: Dictionary = f["bout"]["opp"]
	return {"sex": str(f.get("sex", "f")), "div_kg": float(f.get("limit", 60.0)), "style": str(o.get("style", "")),
		"stance": str(o.get("stance", "")), "reach_cm": float(o.get("reach", 0.0)), "level": int(o.get("rating", 0.0)),
		"tells": OppFile.found(o)}


## Five partners, best match first: {id, name, club, ours, sex, div_kg, style, stance, reach_cm, level, tells, note}.
static func partners(c: Career, f: Dictionary) -> Array:
	var b: Dictionary = f["bout"]
	var opp := opp_known(f)
	var seed := hash("%s|%d|partners" % [str(f["id"]), int(b["day"])])
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var lvl := int(rating_of(f))
	var kg := float(f.get("limit", 60.0))
	var out: Array = []
	var clubs: Array = []
	for h in RegionShows.HOSTS:
		if str(h) != str(b.get("host", "")):
			clubs.append(str(h))
	for i in OWN_PARTNERS + OUTSIDE_PARTNERS:
		var ours := i < OWN_PARTNERS
		var club := c.gym_name if ours else (str(b.get("host", "")) if i == OWN_PARTNERS else str(clubs[rng.randi_range(0, clubs.size() - 1)]))
		# the first of our own shares the opponent's style; the rest draw theirs
		var style := str(opp["style"]) if i == 0 and str(opp["style"]) != "" else str(STYLES[rng.randi_range(0, STYLES.size() - 1)])
		var p_kg := kg + float(rng.randi_range(-2, 3)) * 1.5
		var tells: Array = []
		for t in opp["tells"]:
			if rng.randf() < 0.4:
				tells.append(str(t))
		out.append({"id": "p%d" % i, "name": ("Club boxer, %d kg" % roundi(p_kg)) if ours else "Boxer at %s" % club,
			"club": club, "ours": ours, "sex": str(f.get("sex", "f")), "div_kg": p_kg, "style": style,
			"stance": str(STANCES[0 if rng.randf() < 0.7 else 1]),
			"reach_cm": float(opp["reach_cm"]) + float(rng.randi_range(-7, 7)) if float(opp["reach_cm"]) > 0.0 else 0.0,
			"level": lvl + rng.randi_range(-8, 8), "tells": tells})
	var ranked: Array = []
	for i in PartnerMatch.rank(out, opp):
		ranked.append(out[int(i)])
	return ranked


## Champs.rating_of's number (the six fight stats' mean, to 0.5) - not preloaded: Champs reaches Bouts, which preloads this.
static func rating_of(f: Dictionary) -> float:
	var s := 0.0
	for k in RATING_STATS:
		s += float((f.get("stats", {}) as Dictionary).get(k, 55.0))
	return snappedf(s / RATING_STATS.size(), 0.5)


static func favours(c: Career, club: String) -> int:
	return int(c.favours.get(club, FAVOURS_START))


## The assistant's week: {stop, nights: {days_out: partner_id}, eat_less, film, line, fact}. Its night takes the best match.
static func draft(c: Career, f: Dictionary) -> Dictionary:
	var b: Dictionary = f["bout"]
	var days := int(b["day"]) - c.day
	var unsparred := 0
	for ln in lines(f):
		if bool(ln["unsparred"]):
			unsparred += 1
	var w := weight(f)
	var facts := {"start_tired": tired(f), "tank_weight": 0 if bool(w["in_gap"]) else FightWeek.EAT_LESS_TANK,
		"opp_round1": "", "rating_gap": float(b["opp"].get("rating", 0.0)) - rating_of(f),
		"near_usable": false, "has_week_before": days >= WEEK_BEFORE, "unsparred": unsparred}
	var pk := FightWeekPick.pick(facts, int(float(c.coach.get("rating", 50.0))), 0.0)
	var nights := {}
	var at := int(pk["spar"])
	if at == FightWeekPick.SPAR_FIGHT_WEEK_DAYS:
		at = SPAR_FIRST   # the rule module's 7-day night sits on the fight week's first sparring evening here
	if at > 0 and at <= days:
		nights[at] = ""   # map v9 4.1/4.6: the partner is never pre-selected; the partner screen marks the pick only
	return {"stop": str(pk["stop"]), "nights": nights, "eat_less": str(pk["weight"]) == "eat_less",
		"film": OppFile.has_tape(b["opp"]) and not OppFile.hidden(b["opp"]).is_empty(), "line": str(pk["line"]),
		"fact": str(pk["fact"])}


static func tired(f: Dictionary) -> int:
	return roundi(float(f.get("week_fatigue", f.get("fatigue", 20.0))))


## The scale: {now, opp, gap, margin, in_gap}. Walking weights at a club show are matched within a gap (WeighGap).
static func weight(f: Dictionary) -> Dictionary:
	var lim := float(f.get("limit", 60.0))
	var own := float(f.get("weight", lim))
	var o: Dictionary = f["bout"]["opp"]
	var opp := float(o.get("weight", lim))
	return {"now": own, "opp": opp, "gap": WeighGap.gap_kg(lim), "margin": WeighGap.margin(own, opp, lim),
		"in_gap": WeighGap.in_gap(own, opp, lim)}


## Everything the two screens show for a plan: tank, round one, each night's match, the lines readied, the r1 edge.
static func read(c: Career, f: Dictionary, plan: Dictionary) -> Dictionary:
	var stop := FightWeek.stop_of(str(plan.get("stop", "")))
	var nights: Dictionary = plan.get("nights", {})
	var opp := opp_known(f)
	var lvl := int(rating_of(f))
	var plist := partners(c, f)
	var by_id := {}
	for p in plist:
		by_id[str(p["id"])] = p
	var lns := lines(f)
	var free: Array = []
	for ln in lns:
		if bool(ln["unsparred"]):
			free.append(str(ln["id"]))
	var fw_days: Array = []
	var readied: Array = []
	var edge := 0.0
	var rows: Array = []
	var missing := 0
	var keys: Array = nights.keys()
	keys.sort()
	keys.reverse()
	for d in keys:
		var days := int(d)
		var sn := FightWeek.spar_night(days)
		if str(sn["when"]) != FightWeek.WHEN_WEEK_BEFORE:
			fw_days.append(days)
		var pid := str(nights[d])
		if not by_id.has(pid):
			missing += 1
			rows.append({"days": days, "night": sn, "partner": {}, "match": {}})
			continue
		var left: Array = free.filter(func(x): return not readied.has(x))
		var m := PartnerMatch.night(by_id[pid], opp, lvl, left.size())
		var ids := FightWeek.ready_lines(lns.map(func(x): return {"id": x["id"], "unsparred": left.has(x["id"])}), [], days)
		if int(sn["readies"]) >= 0:
			ids = ids.slice(0, int(m["lines"]))
		readied.append_array(ids)
		edge = maxf(edge, float(m["edge"]))
		rows.append({"days": days, "night": sn, "partner": by_id[pid], "match": m, "readied": ids})
	var r1 := FightWeek.round_one(tired(f), stop)
	var left_after: Array = free.filter(func(x): return not readied.has(x))
	return {"stop": stop, "tank": FightWeek.tank(tired(f), stop, fw_days, bool(plan.get("eat_less", false))),
		"round_one": r1, "edge": edge + float(r1["edge"]), "nights": rows, "missing": missing, "lines": lns,
		"readied": readied, "unsparred": left_after, "partners": plist, "weight": weight(f),
		"spar_days": fw_days}


## Locks the week. "" when done, else why not (a night with no partner, a partner she cannot pay for).
static func lock(c: Career, f: Dictionary, plan: Dictionary) -> String:
	if not is_open(f):
		return "the week is already set"
	var r := read(c, f, plan)
	if int(r["missing"]) > 0:
		return "pick a sparring partner for every night"
	var b: Dictionary = f["bout"]
	var spend := 0
	for row in r["nights"]:
		var p: Dictionary = row["partner"]
		if bool(p["ours"]):
			continue
		var cost := PartnerMatch.cost(false, favours(c, str(p["club"])), c.cash - spend)
		if not bool(cost["payable"]):
			return str(cost["reason"])
		if bool(cost["favour_ok"]):
			c.favours[str(p["club"])] = favours(c, str(p["club"])) - 1
		else:
			spend += int(cost["cash"])
	if spend > 0:
		c.pay(-spend, "Sparring partners for %s's fight week" % str(f["first"]))
	b["load"] = str(r["stop"])
	b["spar_days"] = r["spar_days"]
	b["eat_less"] = bool(plan.get("eat_less", false))
	b["r1_edge"] = float(r["edge"])
	b["unsparred"] = (r["unsparred"] as Array).map(func(k): return str(k).split("|")[0])
	var sparred: Array = f.get("sparred", [])
	for k in r["readied"]:
		if not sparred.has(k):
			sparred.append(k)
	f["sparred"] = sparred
	if bool(plan.get("film", false)):
		b["fw_film"] = c.day
		var id := OppFile.tape(b["opp"])
		if id != "":
			c.add_news("Film night on %s: a new tell found." % str(b["opp"]["first"]), true, true)
	b["fw_locked"] = true
	WeekPhase.sync(f, c.day)
	return ""
