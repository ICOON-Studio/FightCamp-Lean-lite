extends RefCounted
## S514 FIGHTWEEK3 piece: FAVOURS EARNED (map ops/research/AMATEURWEEK1_MAP_V6_S455.md s7-8, rules in
## scripts/rules/FightWeekEvents.gd). A host short of a boxer asks the club: the only way favours are EARNED (partners,
## the kilo and a missed weight only spend them).
##   monday(c)        every day (GymSpend.day_events): on the Monday of a show's week (FightWeekEvents.roll_day(show) =
##                    5 days out) the host rolls once for that show (seeded by the career seed and the show day, so a reload
##                    rolls the same). FightWeekEvents.asks(roll, fits_gap, ready, asked_this_show): fits_gap = a boxer of
##                    ours whose weight class the host is short in; ready = the Ask door open (AskFlow.open: no bout, fit,
##                    rested, an offer not waiting) and inside the club-show weight gap (WeighGap.in_gap) with the boxer
##                    the sheet would send; asked_this_show =
##                    the show already rolled (c.late_asks). One of ours already on that show = no ask (one slot a show).
##                    A yes roll opens f.late_ask = {show, host, opp, monday} on ONE boxer: the red need, one clock stop.
##   is_open(f) / open_for(c)
##   view(c, f)       {host, show, opp (the rival), fav_now, fav_after, stop (StopWord), teaches}
##   answer(c, fid, yes)  "" or why. yes = the bout on that show through the sheet's accept path (AskFlow.book "sheet"):
##                    a fight week on short notice (b.short_notice: never rolled for a pull-out, x2 reputation on a win
##                    like the fall-through's replacement), the host named on the bout, +1 favour with that host
##                    (FightWeekEvents.fill_gap, capped at 3). no = nothing changes. Either way f.late_ask clears.
## Ships ON (a core rule of the fight week, not an opt-in).

const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const RegionShows := preload("res://scripts/rules/RegionShows.gd")
const StopWord := preload("res://scripts/rules/StopWord.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const Data := preload("res://scripts/state/Data.gd")
const AskBout := preload("res://scripts/rules/AskBout.gd")

## The x2 reputation on a win, as the fall-through's replacement (FightWeekEvents.REPLACEMENT_REP_X).
const REP_X := FightWeekEvents.REPLACEMENT_REP_X


static func _flow() -> GDScript:
	return load("res://scripts/state/AskFlow.gd")   # AskFlow loads Bouts at runtime; GymSpend preloads this: no preload loop


static func roll_of(seed: int, show_day: int) -> float:
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%d|%d|late_ask" % [seed, show_day])
	return rng.randf()


static func host_of(show_day: int) -> String:
	var hosts: Array = RegionShows.HOSTS
	return str(hosts[posmod(hash("%d|host" % show_day), hosts.size())])


static func is_open(f: Dictionary) -> bool:
	return not (f.get("late_ask", {}) as Dictionary).is_empty()


static func open_for(c: Career) -> Array:
	return c.fighters.filter(func(f): return is_open(f))


## Ready for a show: the Ask door open and inside the club-show weight gap with the boxer the sheet would send.
static func ready_for(c: Career, f: Dictionary, show_day: int) -> bool:
	if is_open(f) or not Data.DIVISIONS.has(str(f.get("div", ""))):
		return false
	var a: Dictionary = _flow().input(c, f)
	a["offer_waiting"] = false   # a sheet offer still waiting is not a bout: the host's ask may come beside it (a yes replaces it)
	var bouts: GDScript = load("res://scripts/state/Bouts.gd")
	if not bool(AskBout.open(a, c.day, int(bouts.AFTER_FIGHT))["open"]):
		return false
	if c.day < int(f.get("last_bout_day", -9999)) + int(bouts.AFTER_FIGHT):
		return false   # ASKGAP1 opened the Ask door the day after a bout; the host's short-notice ask still waits out the rest
	if not bool(_flow().in_gap(c, f, float(f["weight"]))):   # a club show matches walking weights within a gap (WeighGap)
		return false
	# FAVOURPROBE1: the sheet's name must be a legal experience match, or AskFlow.book refuses the yes (38 in 160 years).
	var ab: GDScript = load("res://scripts/rules/AmateurBooking.gd")
	var opp := c.rival(str(_flow().sheet_name(c, f)))
	return not opp.is_empty() and ab.experience_match_ok(
		ab.bouts_of(int(f["w"]), int(f["l"])), ab.bouts_of(int(opp["w"]), int(opp["l"])))


## The boxers who could fill the host's gap at `show_day`, in roster order.
static func candidates(c: Career, show_day: int) -> Array:
	for g in c.fighters:
		if int((g.get("bout", {}) as Dictionary).get("day", -1)) == show_day:
			return []   # one of ours already holds the show
	return c.fighters.filter(func(f): return ready_for(c, f, show_day))


static func monday(c: Career) -> Array:
	var out: Array = []
	var show := c.day + FightWeekEvents.ROLL_DAYS_OUT
	var region: GDScript = load("res://scripts/state/Region.gd")
	if not region.is_show_day(show):
		return out
	var key := str(show)
	var asked := c.late_asks.has(key)
	var cands := candidates(c, show)
	var roll := roll_of(c.seed, show)
	c.late_asks[key] = true
	# The host is short in one weight class: the class of one of our ready boxers, picked by the same dice.
	var f: Dictionary = cands[int(roll * 6.0 * 7919.0) % cands.size()] if not cands.is_empty() else {}
	if not FightWeekEvents.asks(roll, not f.is_empty(), not f.is_empty(), asked):
		return out
	var opp := str(_flow().sheet_name(c, f))
	var host := host_of(show)
	f["late_ask"] = {"show": show, "host": host, "opp": opp, "monday": c.day}
	var line := "%s is one boxer short for %s's show and asks for %s. Answer before the clock runs on." \
		% [host, Clock.fmt(show), f["first"]]
	c.add_news(line)
	out.append(line)
	return out


static func view(c: Career, f: Dictionary) -> Dictionary:
	var a: Dictionary = f["late_ask"]
	var opp := c.rival(str(a["opp"]))
	var now := FightWeekPlan.favours(c, str(a["host"]))
	return {"host": str(a["host"]), "show": int(a["show"]), "opp": opp, "fav_now": now,
		"fav_after": FightWeekEvents.fill_gap(now),
		"stop": StopWord.word(_flow().gap_of(f, opp)) if not opp.is_empty() else "",
		"teaches": str(_flow().teach_word(c, f, opp, "sheet")) if not opp.is_empty() else ""}


static func answer(c: Career, fid: String, yes: bool) -> String:
	var f := c.fighter_by_id(fid)
	if f.is_empty() or not is_open(f):
		return "no ask is waiting"
	var a: Dictionary = f["late_ask"]
	f["late_ask"] = {}
	if not yes:
		return ""
	var host := str(a["host"])
	for o in f.get("offers", []):   # the host's bout replaces a sheet offer still waiting (book needs the Ask door open)
		if not bool(o["answered"]):
			o["answered"] = true
	if not _flow().book(c, f, "sheet", str(a["opp"]), int(a["show"])):
		return "the bout could not be booked"
	var b: Dictionary = f["bout"]
	b["host"] = host
	b["short_notice"] = true
	b["rep_x"] = REP_X
	b["late_ask"] = true
	c.favours[host] = FightWeekEvents.fill_gap(FightWeekPlan.favours(c, host))
	c.add_news("%s takes the gap at %s on %s. The host owes the club one." % [f["first"], host, Clock.fmt(int(a["show"]))])
	return ""
