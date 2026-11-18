extends RefCounted
## S490 FIGHTWEEK3 piece 1 (map ops/research/FIGHTWEEK_SCREEN_V1_CRITIC_DOLA.md section 6 "Things that happen"): THE PULL-OUT
## ROLL and THE FALL-THROUGH CARD - FightWeekEvents.gd's rules made live in the fight week.
##   eligible(f)          an amateur fight-week bout (b.fight_week; never pro, never a championship, never our own show's
##                        home bout), not fought
##   roll_of(fid, day)    the pull-out dice in [0, 1): seeded by the boxer's id and the bout day, so a reload rolls the same
##   day(c)               every day (GymSpend.day_events): on FightWeekEvents.roll_day(b.day) (the Monday, 5 days out) each
##                        eligible bout not yet rolled sets b.rolled; a pull-out (FightWeekEvents.pulls_out) opens
##                        b.fell = {day, host, was (the old opponent's name)} and counts b.stops (one_stop: at most one stop
##                        per boxer per bout). Returns the news lines.
##   is_open(f) / open_for(c)   b.fell waiting (Needs: the red need FELL THROUGH, the top-bar flag)
##   replacement(c, f)    the boxer the host sends: from the boxer's own division (weight class and sex legal), a legal
##                        experience match (AmateurBooking), the lowest rating above the old opponent's (else the highest
##                        legal one), its bout copy's rating raised to at least the old opponent's + RATING_UP (5.0).
##                        {} when nobody in the class may step in.
##   columns(c, f)        FightWeekEvents.answers on the boxer's view + {word, rating_up, favours_now, new_day}
##   answer(c, fid, id)   "" or why. take_replacement: the replacement on the same night, b.rep_x = 2 and b.short_notice
##                        (BoutFinish pays twice the reputation on a win), the fight week stays. go_home: the bout is gone,
##                        morale += FightWeekEvents.GO_HOME_MOOD (-6), tiredness carries, offers again after
##                        AFTER_GO_HOME days. next_month: FightWeekEvents.spend one favour with the host, the bout moves
##                        NEXT_MONTH_DAYS on with the same opponent and host, re-marked a fight week (FightWeekPlan.mark),
##                        never rolled again; refused with its why when no favour is left. Every taken answer clears b.fell.
## Preloads rules + FightWeekPlan + Data only (Bouts preloads GymSpend, which calls day(): no preload of Bouts here).
## Ships ON (a core rule of the fight week, not an opt-in).

const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const Newcomers := preload("res://scripts/state/Newcomers.gd")   # S517 the sheet refills with novices
const Data := preload("res://scripts/state/Data.gd")
const WeighGap := preload("res://scripts/rules/WeighGap.gd")

## The replacement is a step up: its rating at least the old opponent's + 5 (rating points, BoutRules' fight_power scale).
const RATING_UP := 5.0
## The host's next month: the same show a month on (~4 weeks).
const NEXT_MONTH_DAYS := 28
## Gone home: the next offers come as after a declined one (= Bouts.AFTER_DECLINE).
const AFTER_GO_HOME := 5
const WORDS := {"take_replacement": "Take the replacement", "go_home": "Go home", "next_month": "Next month's slot"}


static func eligible(f: Dictionary) -> bool:
	var b: Dictionary = f.get("bout", {})
	return WeekPhase.amateur(b) and not bool(f.get("pro", false)) and not bool(b.get("done", false)) \
		and not bool(b.get("home", false)) and not bool(b.get("short_notice", false))   # S490 review: a twist-swapped bout never loses a second opponent


static func roll_of(fid: String, bout_day: int) -> float:
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%s|%d|pull_out" % [fid, bout_day])
	return rng.randf()


static func is_open(f: Dictionary) -> bool:
	return not ((f.get("bout", {}) as Dictionary).get("fell", {}) as Dictionary).is_empty()


static func open_for(c: Career) -> Array:
	return c.fighters.filter(func(f): return is_open(f))


static func day(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		if not eligible(f):
			continue
		var b: Dictionary = f["bout"]
		if bool(b.get("rolled", false)) or c.day != FightWeekEvents.roll_day(int(b["day"])):
			continue
		b["rolled"] = true
		if not FightWeekEvents.one_stop(int(b.get("stops", 0))):
			continue
		if not FightWeekEvents.pulls_out(roll_of(str(f["id"]), int(b["day"]))):
			continue
		b["stops"] = int(b.get("stops", 0)) + 1
		b["fell"] = {"day": c.day, "host": str(b.get("host", "")), "was": str(b["opp"].get("name", ""))}
		var line := "%s's opponent pulled out of the show at %s on %s. Take the replacement, go home, or ask for next month." \
			% [f["first"], str(b.get("host", "")), Clock.fmt(int(b["day"]))]
		c.add_news(line)
		out.append(line)
	return out


static func replacement(c: Career, f: Dictionary) -> Dictionary:
	var b: Dictionary = f.get("bout", {})
	if b.is_empty() or not Data.DIVISIONS.has(str(f.get("div", ""))):
		return {}
	var cur: Dictionary = b["opp"]
	var was := str((b.get("fell", {}) as Dictionary).get("was", cur.get("name", "")))
	var cur_r := float(cur.get("rating", 60.0))
	var own := AmateurBooking.bouts_of(int(f.get("w", 0)), int(f.get("l", 0)))
	var above: Dictionary = {}
	var top: Dictionary = {}
	for n in Newcomers.sheet(c, str(f["div"])):
		var r := c.rival(str(n))
		if r.is_empty() or str(n) == was or str(n) == str(cur.get("name", "")):
			continue
		if not AmateurBooking.experience_match_ok(own, AmateurBooking.bouts_of(int(r["w"]), int(r["l"]))):
			continue
		var rr := float(r.get("rating", 0.0))
		if rr > cur_r and (above.is_empty() or rr < float(above["rating"])):
			above = r
		if top.is_empty() or rr > float(top["rating"]):
			top = r
	var pick: Dictionary = above if not above.is_empty() else top
	if pick.is_empty():
		return {}
	var rep := pick.duplicate(true)
	rep["rating"] = maxf(float(rep.get("rating", 0.0)), cur_r + RATING_UP)
	return rep


static func columns(c: Career, f: Dictionary) -> Array:
	var b: Dictionary = f["bout"]
	var host := str((b.get("fell", {}) as Dictionary).get("host", b.get("host", "")))
	var fav := FightWeekPlan.favours(c, host)
	var rep := replacement(c, f)
	var out: Array = []
	for row in FightWeekEvents.answers(fav, host):
		var col: Dictionary = (row as Dictionary).duplicate()
		col["word"] = str(WORDS[col["id"]])
		col["favours_now"] = fav
		col["rating_up"] = 0.0
		col["new_day"] = int(b["day"])
		if str(col["id"]) == "take_replacement":
			if rep.is_empty():
				col["ok"] = false
				col["why"] = "nobody in the class can step in"
			else:
				col["rating_up"] = float(rep["rating"]) - float(b["opp"].get("rating", 60.0))
		elif str(col["id"]) == "next_month":
			col["new_day"] = int(b["day"]) + NEXT_MONTH_DAYS
		out.append(col)
	return out


static func answer(c: Career, fid: String, id: String) -> String:
	var f := c.fighter_by_id(fid)
	if f.is_empty() or not is_open(f):
		return "no bout fell through"
	var col: Dictionary = {}
	for x in columns(c, f):
		if str(x["id"]) == id:
			col = x
	if col.is_empty():
		return "no such answer"
	if not bool(col["ok"]):
		return str(col["why"])
	var b: Dictionary = f["bout"]
	var fell: Dictionary = b["fell"]
	var host := str(fell["host"])
	match id:
		"take_replacement":
			var rep := replacement(c, f)
			b["opp"] = rep
			b["rep_x"] = int(col["rep_x"])
			b["short_notice"] = true   # BoutFinish: twice the reputation on a win
			b["film"] = BoutRules.FILM_DEPTH_DEFAULT
			b.erase("fell")
			c.add_news("%s takes %s on short notice at %s, %s: a tougher opponent, twice the reputation on a win." \
				% [f["first"], rep["name"], host, Clock.fmt(int(b["day"]))])
		"go_home":
			b.erase("fell")
			f["bout"] = {}
			f["booked_fight"] = false
			f["next_offer_day"] = c.day + AFTER_GO_HOME
			f["morale"] = snappedf(clampf(float(f.get("morale", FighterProfile.MORALE_START)) + float(col["mood"]), 0.0, 100.0), 0.1)
			f["mood_reason"] = "The bout at %s fell through" % host
			WeekPhase.sync(f, c.day)
			c.add_news("%s goes home from %s's show: no bout this week." % [f["first"], host])
		"next_month":
			var s := FightWeekEvents.spend(FightWeekPlan.favours(c, host), 1)
			if not bool(s["ok"]):
				return "no favour with %s" % host
			c.favours[host] = int(s["favours"])
			var nb := {"opp": b["opp"], "day": int(col["new_day"]), "weighed": false, "made": false, "done": false,
				"film": int(b.get("film", BoutRules.FILM_DEPTH_DEFAULT))}
			f["bout"] = nb
			FightWeekPlan.mark(c, f)
			nb["host"] = host   # the host gave the slot: the same club's show a month on
			nb["rolled"] = true   # one stop per boxer per bout: the moved bout never rolls again
			nb["stops"] = int(b.get("stops", 1))
			WeekPhase.sync(f, c.day)
			c.add_news("%s gives %s next month's slot: %s, %s. One favour spent." % [host, f["first"], b["opp"]["name"], Clock.fmt(int(nb["day"]))])
	return ""


## S513 FIGHTWEEK3 (map AMATEURWEEK1 v6 s6, WeighGap.miss): a club-show boxer outside the gap on the scale. The host
## re-matches on the night when a spare of her walking weight is on the card (WeighGap.REMATCH_CHANCE, 1 in 3: the spare
## is the class's next boxer up, at her weight); else the bout is off and the host takes a favour (Bouts.weigh pays
## the empty slot). True = re-matched (the bout goes on with the spare).
static func weigh_miss(c: Career, f: Dictionary) -> bool:
	var b: Dictionary = f["bout"]
	var host := str(b.get("host", ""))
	var rng := RandomNumberGenerator.new()
	rng.seed = c.seed * 6151 + int(b.get("day", c.day)) * 31 + absi(hash(str(f.get("id", "")) + "|weigh"))
	var rep := replacement(c, f)
	# S517 (home_bout_test red since S513): a spare in her division walks near its limit, so one exists only while she is
	# within the class gap over it; 6 kg over a 60 kg limit is another class and nobody on the card matches her.
	if float(f["weight"]) - float(f["limit"]) > WeighGap.gap_kg(float(f["limit"])):
		rep = {}
	var res := WeighGap.miss(rng.randf(), not rep.is_empty())
	if bool(res["rematched"]):
		rep["weight"] = float(f["weight"])
		b["was_opp"] = str((b["opp"] as Dictionary).get("name", ""))
		b["opp"] = rep
		c.add_news("%s is outside the gap with %s. %s has a spare at the weight: %s boxes instead." % [f["first"],
			b["was_opp"], host if host != "" else "The host", str(rep.get("name", "a spare"))])
		return true
	if host != "":
		c.favours[host] = maxi(0, FightWeekPlan.favours(c, host) - int(res["favours"]))
		c.add_news("%s has no spare at the weight: the bout is off and the club owes the host a favour." % host)
	return false
