extends RefCounted
## A fighter's bouts, from offer to the next goal - per fighter since week 4 (each carries her own offers, bout, camp and
## office talk). Offers arrive and expire with the days; the player accepts or declines, sets a camp, weighs her in, works
## her corner on fight night; the result books her record, the ticket cut and the members, and sends her to the office for
## her next goal. Rules live in BoutRules / AmateurBooking / FighterGoal; this file moves the career's data.
## Offer ids carry the fighter: "lucy:o8". Sim.step_day calls day_events after each day.

const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FightWords := preload("res://scripts/state/FightWords.gd")
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const CoachNotes := preload("res://scripts/rules/CoachNotes.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Champs := preload("res://scripts/state/Champs.gd")


const OFFER_ANSWER_DAYS := 3
const MISMATCH_ANSWER_DAYS := 5
## Days until the next offer after: an offer expires, the player declines, she misses weight, a bout is fought.
const AFTER_EXPIRY := 4
const AFTER_DECLINE := 5
const AFTER_MISSED_WEIGHT := 6
const AFTER_FIGHT := 10
## The goals she can pick in the office after a bout.
const NEXT_GOALS: Array[String] = ["southpaw_answer", "five_round_engine"]


## [fighter, offer] for an offer id, or [{}, {}].
static func find_offer(c: Career, id: String) -> Array:
	for f in c.fighters:
		for o in f["offers"]:
			if str(o["id"]) == id:
				return [f, o]
	return [{}, {}]


static func offer(c: Career, id: String) -> Dictionary:
	return find_offer(c, id)[1]


## Every offer still waiting for an answer, across the roster: [[fighter, offer]] (unsafe mismatches included).
static func open_offers(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		for o in f["offers"]:
			if not bool(o["answered"]):
				out.append([f, o])
	return out


static func offers_settled(f: Dictionary) -> bool:
	for o in f["offers"]:
		if not bool(o["answered"]) and not bool(o["mismatch"]):
			return false
	return true


static func camp_due(c: Career, f: Dictionary) -> bool:
	var b: Dictionary = f["bout"]
	return not b.is_empty() and (f["camp"] as Dictionary).is_empty() and int(b["day"]) - c.day >= BoutRules.CAMP_MIN_DAYS


static func weigh_in_today(c: Career, f: Dictionary) -> bool:
	var b: Dictionary = f["bout"]
	return not b.is_empty() and c.day == int(b["day"]) - 1 and not bool(b["weighed"])


static func fight_day(c: Career, f: Dictionary) -> bool:
	var b: Dictionary = f["bout"]
	return not b.is_empty() and c.day == int(b["day"]) and bool(b["weighed"]) and not bool(b["done"])


## The fighter whose fight night is today, or {}.
static func fighting_today(c: Career) -> Dictionary:
	for f in c.fighters:
		if fight_day(c, f):
			return f
	return {}


## The fighter whose weigh-in is today, or {}.
static func weighing_today(c: Career) -> Dictionary:
	for f in c.fighters:
		if weigh_in_today(c, f):
			return f
	return {}


## After each day: per fighter, a pair of offers arrives when nothing is booked or pending; unanswered offers expire.
static func day_events(c: Career) -> void:
	for f in c.fighters:
		tape_days(c, f)
		if bool(f.get("pro", false)) or Champs.active(f):
			continue   # S328 no other offers while she is in the championships
		if (f["bout"] as Dictionary).is_empty() and c.day >= int(f["next_offer_day"]) and offers_settled(f):
			var div: Dictionary = Data.DIVISIONS[f["div"]]
			var names: Array = div["opponents"]
			var opp: Dictionary = c.rival(str(names[int(f["opp_index"]) % names.size()])).duplicate(true)
			var id := "%s:o%d" % [f["id"], c.day]
			var on := AmateurBooking.fight_day(c.day, AmateurBooking.lead_weeks(id))
			var own := AmateurBooking.bouts_of(int(f["w"]), int(f["l"]))
			f["offers"] = [
				_offer(id, opp, on, c.day + OFFER_ANSWER_DAYS, own),
				_offer("%s:m%d" % [f["id"], c.day], c.rival(str(div["mismatch"])).duplicate(true), on + 7, c.day + MISMATCH_ANSWER_DAYS, own),
			]
			c.add_news("Two bout offers came in for %s." % f["name"])
		for o in f["offers"]:
			if not bool(o["answered"]) and c.day > int(o["expires"]):
				o["answered"] = true
				o["expired"] = true
				if not bool(o["mismatch"]):
					c.add_news("The offer from %s for %s expired." % [o["opp"]["club"], f["first"]])
					f["next_offer_day"] = c.day + AFTER_EXPIRY


static func _offer(id: String, opp: Dictionary, on: int, expires: int, own_bouts: int) -> Dictionary:
	var theirs := AmateurBooking.bouts_of(int(opp["w"]), int(opp["l"]))
	return {"id": id, "opp": opp, "day": on, "expires": expires, "answered": false, "accepted": false, "expired": false,
		"mismatch": not AmateurBooking.experience_match_ok(own_bouts, theirs), "own_bouts": own_bouts, "their_bouts": theirs}


static func accept(c: Career, id: String) -> bool:
	var fo := find_offer(c, id)
	var f: Dictionary = fo[0]
	var o: Dictionary = fo[1]
	if o.is_empty() or bool(o["answered"]) or bool(o["mismatch"]):
		return false
	for x in f["offers"]:
		x["answered"] = true
	o["accepted"] = true
	# S341: her own copy - tape study writes her file into it (OppFile), never into the answered offer.
	f["bout"] = {"opp": (o["opp"] as Dictionary).duplicate(true), "day": int(o["day"]), "weighed": false, "made": false, "done": false,
		"film": BoutRules.FILM_DEPTH_DEFAULT}
	f["booked_fight"] = true
	FighterProfile.apply_morale(f, "booked", "A fight booked: %s" % o["opp"]["name"])
	c.add_news("Booked: %s vs %s, %s." % [f["name"], o["opp"]["name"], Clock.fmt(int(o["day"]))])
	return true


static func decline(c: Career, id: String) -> void:
	var fo := find_offer(c, id)
	var o: Dictionary = fo[1]
	if o.is_empty():
		return
	o["answered"] = true
	if not bool(o["mismatch"]):
		fo[0]["next_offer_day"] = c.day + AFTER_DECLINE


## Pays and starts her camp. Returns the cost.
static func start_camp(c: Career, f: Dictionary, focus: String, protocol: int, film: bool) -> int:
	if (f["bout"] as Dictionary).is_empty() or not (f["camp"] as Dictionary).is_empty():
		return 0
	var cost := BoutRules.camp_cost(protocol, film)
	if cost > 0:
		c.pay(-cost, "Fight camp for %s: %s%s" % [f["first"], str(BoutRules.PROTOCOLS[protocol]["name"]).to_lower(), " + film study" if film else ""])
	f["camp"] = {"focus": focus, "protocol": protocol, "film": film, "start": c.day}
	# S327: the camp steps her load up only as far as stays safe against her usual (was straight to Hard - a 1.5x spike);
	# the Hard camp is the player's "more risk" pick and trains Hard.
	f["load_setting"] = "hard" if protocol == 3 else TrainingLoad.camp_default(Injuries.chronic(f))
	if film:
		tape_days(c, f)
	return cost


## S341 tape study (OppFile): the camp's sessions so far open her file one tell each (weapon first, weakness last); each
## is a news line, and the fight's film depth follows what is found.
static func tape_days(c: Career, f: Dictionary) -> void:
	var camp: Dictionary = f["camp"]
	var b: Dictionary = f["bout"]
	if camp.is_empty() or b.is_empty() or not bool(camp.get("film", false)):
		return
	var opp: Dictionary = b["opp"]
	if not opp.has("habits"):
		opp["habits"] = RoundStyle.opponent_habits(opp)
	while int(camp.get("tapes", 0)) < OppFile.sessions_due(int(camp["start"]), c.day):
		camp["tapes"] = int(camp.get("tapes", 0)) + 1
		var id := OppFile.tape(opp)
		if id == "":
			break
		for t in OppFile.tells(opp):
			if str(t["id"]) == id:
				# Her best weapon is mail; the later finds are news only (they are on her file card): 1 mail a camp.
				c.add_news("Tape on %s: %s - %s. %s." % [opp["first"], str(t["what"]).to_lower(), str(t["value"]).to_lower(), t["counter"]], id == "weapon")
	b["film"] = OppFile.film_depth(opp)
	OppFile.remember(c.rival(str(opp["name"])), opp)


## Steps her on the scale. Missed weight calls the bout off and the club pays for the empty slot. Returns made.
static func weigh(c: Career, f: Dictionary) -> bool:
	f["bout"]["weighed"] = true
	var made := BoutRules.made_weight(float(f["weight"]), float(f["limit"]))
	f["bout"]["made"] = made
	if not made and f["bout"].has("champ"):
		# S328 a championship has no empty slot to pay for: she is out of the draw.
		f["bout"] = {}
		f["camp"] = {}
		f["booked_fight"] = false
		Champs.withdraw(c, f, "she missed weight")
		return made
	if not made:
		c.add_news("%s missed weight. The bout is off." % f["name"])
		c.pay(-BoutRules.MISSED_WEIGHT_COST, "Empty slot: %s missed weight" % f["first"])
		f["bout"] = {}
		f["camp"] = {}
		f["booked_fight"] = false
		f["next_offer_day"] = c.day + AFTER_MISSED_WEIGHT
	return made


## Fight night lives in BoutNight (S326 split); these entry points keep their old names for every caller.
static func fight_modal(f: Dictionary) -> Dictionary:
	return BoutNight.fight_modal(f)


static func rounds_of(f: Dictionary) -> int:
	return BoutNight.rounds_of(f)


static func fight_step(c: Career, f: Dictionary, m: Dictionary, a: String) -> void:
	BoutNight.fight_step(c, f, m, a)


static func corner_jobs(parts: PackedStringArray) -> Dictionary:
	return BoutNight.corner_jobs(parts)


static func stopped(m: Dictionary) -> String:
	return BoutNight.stopped(m)


static func coach_note(c: Career, f: Dictionary, source: String) -> void:
	BoutNight.coach_note(c, f, source)


static func notes_bank() -> Dictionary:
	return BoutNight.notes_bank()


static func _energy(f: Dictionary, n: int, corner: String) -> Dictionary:
	return BoutNight._energy(f, n, corner)


static func _counts(c: Career, f: Dictionary, m: Dictionary, r: Dictionary) -> void:
	BoutNight._counts(c, f, m, r)


static func _finish(c: Career, f: Dictionary, m: Dictionary) -> void:
	BoutNight._finish(c, f, m)



static func after_fight(c: Career, f: Dictionary) -> void:
	var champ := (f["bout"] as Dictionary).has("champ")
	var won := false
	for r in c.results:
		if str(r.get("fid", "")) == str(f["id"]):
			won = bool(r["win"])
			break
	f["bout"] = {}
	f["camp"] = {}
	if not champ:
		f["opp_index"] = int(f["opp_index"]) + 1
	f["load_setting"] = TrainingLoad.DEFAULT
	f["next_offer_day"] = c.day + AFTER_FIGHT
	f["booked_fight"] = false
	# S328 a championship round books the next one (or ends her run); a bout booked before she entered hands over to it.
	if champ:
		Champs.after_bout(c, f, won)
	elif Champs.active(f):
		Champs.book_next(c, f)
	Roster.check_pro(c)


static func goal_choices(c: Career, f: Dictionary) -> Array:
	var out: Array = []
	for id in NEXT_GOALS:
		out.append(FighterGoal.goal_for(f, id, c.day))
	return out


static func set_goal(c: Career, f: Dictionary, id: String) -> void:
	f["goal"] = FighterGoal.goal_for(f, id, c.day)
	f["goal_talk"] = false
	c.add_news("%s's new goal: %s." % [f["first"], f["goal"]["title"]])
