extends RefCounted
## S397 rank 4 (P1): the pro career after the debut, on the WORLD1 tables (Career.world). After her debut a pro joins her
## division's table unranked; the world fights a month at a time; the promoter brings three offers timed by the last night (Matchmaking.next_weeks)
## (Matchmaking.offers) that stand for OFFER_DAYS; a scout (SCOUT_COST) opens his tape (OppFile: weapon, weakness) and
## narrows the read (BoutRead.band, the same read as any amateur offer); or she asks for a named
## boxer inside the promoter's band. A booked pro bout is the same bout dict the debut uses (Roster.turn_pro), carrying
## `ladder` = the opponent's world id, so camp, weigh-in and fight night run unchanged; BoutNight._finish calls result().
## Screens: Fights (offers, ask, the road). Rules: scripts/rules/Matchmaking.gd. Bars: tests/pro_ladder_test.gd.

const WG := preload("res://scripts/world/WorldGen.gd")
const WS := preload("res://scripts/world/WorldSim.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

## A pro has fought on television: the best weapon is public tape. The weakness takes a scout.
const PUBLIC_TAPE := ["weapon"]
const STEP_READ := 0.5      # the promoter's step up: a real chance, not a cliff
const TUNE_READ := Vector2(0.7, 0.93)   # a tune-up the promoter offers: likely, never a sure thing
const TUNE_AIM := 0.82
const PAYDAY_READ := Vector2(0.2, 0.45)  # a payday: a long shot that pays
const PAYDAY_TOP := 10
const MONTH_DAYS := 28
const YEAR_DAYS := 364
## The promoter calls so that the next fight night lands Matchmaking.next_weeks after the last (offers come LEAD_DAYS early).
const OFFER_DAYS := 7
const LEAD_DAYS := 42          # a booked pro bout is six weeks out: the camp
const ROUNDS_UNRANKED := 4
const ROUNDS_RANKED := 6
const ROUNDS_TOP10 := 8
const ROUNDS_TITLE := 10


## Which WORLD1 table she boxes on (four so far: women's and men's lightweight and welterweight).
static func division_for(f: Dictionary) -> String:
	var men := str(f.get("sex", "f")) == "m"
	var heavy := float(f.get("limit", 60.0)) > 62.0
	return ("m_" if men else "w_") + ("wr" if heavy else "lw")


static func on_ladder(c: Career, f: Dictionary) -> bool:
	return bool(f.get("pro", false)) and not entry(c, f).is_empty()


static func table(c: Career, f: Dictionary) -> Array:
	if c.world.is_empty():
		return []
	return c.world["divisions"][division_for(f)]["boxers"]


static func entry(c: Career, f: Dictionary) -> Dictionary:
	for b in table(c, f):
		if b.get("player", false) and str(b.get("fid", "")) == str(f["id"]):
			return b
	return {}


static func by_id(c: Career, f: Dictionary, id: int) -> Dictionary:
	for b in table(c, f):
		if int(b.get("id", 0)) == id and not b.get("player", false):
			return b
	return {}


static func _rng(c: Career, salt: String) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = hash("%d|%d|%s" % [c.seed, c.day, salt])
	return r


## Her strength on the table is her strength on the night (no camp): the world's ratings are on the same scale.
static func night(f: Dictionary) -> float:
	return snappedf(BoutRules.fight_power(f["stats"], {}, 0, ""), 0.1)


## She joins her table after the debut (the world is made the first time any pro needs it).
static func join(c: Career, f: Dictionary) -> Dictionary:
	if c.world.is_empty():
		c.world = WG.generate(hash("%d|world" % c.seed))
	var e := entry(c, f)
	if not e.is_empty():
		return e
	e = MM.join(table(c, f), str(f["name"]), night(f), int(f.get("age", 22)), hash("%d|%s" % [c.seed, str(f["id"])]))
	e["fid"] = str(f["id"])
	e["w"] = int(f.get("pro_w", 0))
	e["l"] = int(f.get("pro_l", 0))
	e["d"] = int(f.get("pro_d", 0))
	f["pro_next"] = c.day + MM.NEXT_WEEKS * 7 - LEAD_DAYS
	f["pro_offers"] = []
	return e


## Once a day (Sim.step_day): the world fights a month at a time; her offers come and go.
static func day_events(c: Career) -> void:
	if not c.world.is_empty():
		if c.day % MONTH_DAYS == 0:
			WS.simulate_month(c.world["divisions"], _rng(c, "month"))
		if c.day % YEAR_DAYS == 0:
			WS.year_end(c.world["divisions"], _rng(c, "year"))
	for f in c.fighters:
		if not on_ladder(c, f) or not (f["bout"] as Dictionary).is_empty():
			continue
		var offers: Array = f.get("pro_offers", [])
		if not offers.is_empty() and int(offers[0]["until"]) < c.day:
			f["pro_offers"] = []
			f["pro_next"] = c.day + OFFER_DAYS
			c.add_news("%s's offers lapsed: the promoter will call again next week." % f["first"])
		elif offers.is_empty() and c.day >= int(f.get("pro_next", 0)):
			_make_offers(c, f)


## S397 (operator "Offers that trade off"): the promoter's three offers are built to pull different ways, read on the
## career's own odds (BoutRead), so none is the best on every column:
##   TUNE-UP  a boxer below her or unranked, read nearest TUNE_READ: likely win, a quicker night, no place, small pay
##   STEP UP  a ranked name in her band, read nearest STEP_READ: a place and better pay for a hard night (not while she
##            rebuilds after a loss, nor after two ducks)
##   PAYDAY   a top-10 name above her band, read inside PAYDAY_READ: two to three times the pay and a big place, at a real
##            risk of being stopped
## A set where one offer is at least as good as another on chance, place, pay, weeks and stoppage risk drops the worse one.
static func _make_offers(c: Career, f: Dictionary) -> void:
	var e := entry(c, f)
	e["rating"] = night(f)
	var you := int(e.get("rank", 0))
	var reach := maxi(1, you - MM.BAND_UP) if you > 0 else MM.UNRANKED_REACH
	var tune := {}
	var step := {}
	var pay := {}
	for b in table(c, f):
		if b.get("player", false) or b.get("retired", false):
			continue
		var r := int(b.get("rank", 0))
		var mid := float(read(c, f, bout_opp(f, b, PUBLIC_TAPE))["mid"])
		var above := r > 0 and (you == 0 or r < you)
		if not above:
			if mid >= TUNE_READ.x and mid <= TUNE_READ.y and (tune.is_empty() or absf(mid - TUNE_AIM) < absf(float(tune["mid"]) - TUNE_AIM)):
				tune = {"b": b, "mid": mid}
		elif r >= reach and bool(MM.ask(e, b)["ok"]):
			if step.is_empty() or absf(mid - STEP_READ) < absf(float(step["mid"]) - STEP_READ):
				step = {"b": b, "mid": mid}
		elif r <= PAYDAY_TOP and mid >= PAYDAY_READ.x and mid <= PAYDAY_READ.y:
			if pay.is_empty() or r < int(pay["b"]["rank"]):
				pay = {"b": b, "mid": mid}
	var out: Array = []
	for kv in [["tune", tune], ["above", step], ["payday", pay]]:
		var pick: Dictionary = kv[1]
		if pick.is_empty():
			continue
		if kv[0] == "above" and (int(e.get("ducks", 0)) >= MM.DUCKS_BLOCK or e.get("rebuild", false)):
			continue
		out.append({"id": int(pick["b"]["id"]), "kind": kv[0], "file_found": PUBLIC_TAPE.duplicate(), "scouted": false,
			"until": c.day + OFFER_DAYS})
	f["pro_offers"] = _drop_dominated(c, f, out)
	if not (f["pro_offers"] as Array).is_empty():
		c.add_news("%s's promoter has %d fights on the table (Fights)." % [f["first"], (f["pro_offers"] as Array).size()])


## The numbers a row is judged on: chance, the place a win takes (0 none), the gym's pay, weeks to the next fight, stop risk.
static func offer_axes(c: Career, f: Dictionary, o: Dictionary) -> Dictionary:
	var e := entry(c, f)
	var opp := by_id(c, f, int(o["id"]))
	var mid := float(read(c, f, bout_opp(f, opp, o.get("file_found", PUBLIC_TAPE)))["mid"])
	var r := int(opp.get("rank", 0))
	var you := int(e.get("rank", 0))
	var p := MM.pay_of(e, opp)
	return {"chance": mid, "place": (21 - r) if r > 0 and (you == 0 or r < you) else 0, "pay": int(p["purse"]) + int(p["tickets"]),
		"weeks": MM.next_weeks(float(opp["rating"]) - float(e["rating"]), false), "stop": MM.stop_chance(mid, opp)}


## True when x is at least as good as y on every axis (and better on one): y is never the right pick.
static func dominates(x: Dictionary, y: Dictionary) -> bool:
	var ge: bool = x["chance"] >= y["chance"] and x["place"] >= y["place"] and x["pay"] >= y["pay"] and x["weeks"] <= y["weeks"] and x["stop"] <= y["stop"]
	var gt: bool = x["chance"] > y["chance"] or x["place"] > y["place"] or x["pay"] > y["pay"] or x["weeks"] < y["weeks"] or x["stop"] < y["stop"]
	return ge and gt


static func _drop_dominated(c: Career, f: Dictionary, out: Array) -> Array:
	var axes: Array = out.map(func(o): return offer_axes(c, f, o))
	var keep: Array = []
	for i in out.size():
		var beaten := false
		for j in out.size():
			if i != j and dominates(axes[j], axes[i]):
				beaten = true
		if not beaten:
			keep.append(out[i])
	return keep


## The opponent as a bout reads it (the shape Roster.turn_pro's debut opponent has): the career's own BoutRead and OppFile
## work on it, so the read, the scout and the plan are the same as for any amateur opponent.
static func bout_opp(f: Dictionary, opp: Dictionary, found: Array) -> Dictionary:
	return {"name": opp["name"], "first": opp["first"], "club": opp.get("club", ""), "age": int(opp["age"]),
		"stance": opp["stance"], "style": opp["style"], "w": int(opp["w"]), "l": int(opp["l"]), "rating": float(opp["rating"]),
		"threat": opp["threat"], "weak": opp["weak"], "div": f["div"], "pro": true, "rank": int(opp.get("rank", 0)),
		"belt": opp.get("belt", ""), "file_found": found.duplicate()}


## Her chance as the bout page reads it (BoutRead.band: the rating range and every hidden tell's worst and best), with the
## usual camp in front of a pro fight.
static func read(c: Career, f: Dictionary, bo: Dictionary) -> Dictionary:
	var b := BoutRead.band(f, bo, BoutRead.camp_for(f, LEAD_DAYS), c.seed, float(c.coach.get("rating", 0.0)))
	return {"lo": float(b["lo"]), "hi": float(b["hi"]), "mid": (float(b["lo"]) + float(b["hi"])) / 2.0}


## Rows for the Fights page: the opponent, the read, the pay, what a scout found.
static func offer_rows(c: Career, f: Dictionary) -> Array:
	var e := entry(c, f)
	var out: Array = []
	for o in f.get("pro_offers", []):
		var opp := by_id(c, f, int(o["id"]))
		if opp.is_empty():
			continue
		var bo := bout_opp(f, opp, o.get("file_found", []))
		out.append({"opp": opp, "bout_opp": bo, "offer": o, "chance": read(c, f, bo), "pay": MM.pay_of(e, opp), "kind": o["kind"]})
	return out


## One scout's look (SCOUT_COST) at an offered opponent or a name she may ask for: the tape opens (OppFile: the weakness;
## the weapon is public) and the read narrows; the read it had is kept to show how it moved. False when it cannot.
static func scout(c: Career, f: Dictionary, opp_id: int) -> bool:
	if c.cash < MM.SCOUT_COST:
		return false
	var opp := by_id(c, f, opp_id)
	if opp.is_empty():
		return false
	var o: Dictionary = {}
	for x in f.get("pro_offers", []):
		if int(x["id"]) == opp_id:
			o = x
	if o.is_empty():   # a name from the ask list: its file is kept beside the offers until she books
		var book_of: Dictionary = f.get_or_add("pro_scout", {})
		o = book_of.get_or_add(str(opp_id), {"id": opp_id, "file_found": PUBLIC_TAPE.duplicate(), "scouted": false})
	if bool(o.get("scouted", false)):
		return false
	var bo := bout_opp(f, opp, o.get("file_found", []))
	o["read_before"] = float(read(c, f, bo)["mid"])
	for t in OppFile.hidden(bo):
		OppFile.open(bo, str(t))
	o["file_found"] = (bo.get("file_found", []) as Array).duplicate()
	o["scouted"] = true
	c.pay(-MM.SCOUT_COST, "Scouting %s for %s" % [opp["name"], f["first"]])
	return true


## What has been found on a name (an offer's file, or a scouted name from the ask list).
static func file_of(f: Dictionary, opp_id: int) -> Dictionary:
	for x in f.get("pro_offers", []):
		if int(x["id"]) == opp_id:
			return x
	return (f.get("pro_scout", {}) as Dictionary).get(str(opp_id), {"file_found": PUBLIC_TAPE.duplicate(), "scouted": false})


## Who she can ask for: everyone ranked above her, top down, each with the promoter's answer and the unscouted read.
static func ask_rows(c: Career, f: Dictionary) -> Array:
	var e := entry(c, f)
	var ranked := table(c, f).filter(func(b): return int(b.get("rank", 0)) > 0 and not b.get("player", false) and not b.get("retired", false))
	ranked.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
	var out: Array = []
	for b in ranked:
		if int(e["rank"]) > 0 and int(b["rank"]) >= int(e["rank"]):
			break
		var answer := MM.ask(e, b)
		var file := file_of(f, int(b["id"]))
		out.append({"opp": b, "answer": answer, "file": file,
			"chance": read(c, f, bout_opp(f, b, file.get("file_found", PUBLIC_TAPE))) if bool(answer["ok"]) else {}})
	return out


## Book a fight: from her offers (a softer pick while a harder one is on the table is a duck) or by asking.
static func book(c: Career, f: Dictionary, opp_id: int, asked: bool) -> Dictionary:
	var e := entry(c, f)
	var opp := by_id(c, f, opp_id)
	if opp.is_empty() or not (f["bout"] as Dictionary).is_empty():
		return {"ok": false, "reason": "Not available"}
	if asked:
		var answer := MM.ask(e, opp)
		if not bool(answer["ok"]):
			return answer
	else:
		var offered: Array = []
		for o in f.get("pro_offers", []):
			var x := by_id(c, f, int(o["id"]))
			if not x.is_empty() and str(o["kind"]) == "above":   # only passing on the step up is a duck
				offered.append({"opp": x})
		MM.note_choice(e, opp, offered)
	var pay := MM.pay_of(e, opp)
	var title := str(opp.get("belt", "")) != ""
	var rounds := ROUNDS_TITLE if title else (ROUNDS_TOP10 if int(opp.get("rank", 0)) in range(1, 11) else
		(ROUNDS_RANKED if int(opp.get("rank", 0)) > 0 else ROUNDS_UNRANKED))
	var found: Array = file_of(f, opp_id).get("file_found", [])
	f["bout"] = {"opp": bout_opp(f, opp, found), "day": c.day - posmod(c.day, 7) + 5 + LEAD_DAYS, "weighed": false, "made": false, "done": false,
		"film": BoutRules.FILM_DEPTH_DEFAULT, "pro": true, "rounds": rounds, "purse": int(pay["purse"]) + int(pay["tickets"]),
		"ladder": opp_id, "title": title}
	f["booked_fight"] = true
	f["pro_offers"] = []
	f["pro_scout"] = {}
	c.add_news("%s will fight %s%s in six weeks (%d rounds)." % [f["name"], opp["name"],
		" (#%d)" % int(opp["rank"]) if int(opp.get("rank", 0)) > 0 else "", rounds])
	return {"ok": true, "reason": ""}


## Fight night is over (BoutNight._finish): the debut puts her on the table; a ladder bout moves it.
static func result(c: Career, f: Dictionary, outcome: String, stopped: bool) -> Dictionary:
	if not bool(f.get("pro", false)):
		return {}
	var e := join(c, f)
	var opp_id := int(f["bout"].get("ladder", 0))
	if opp_id == 0:
		return {}
	var opp := by_id(c, f, opp_id)
	if opp.is_empty():
		return {}
	if outcome == "draw":   # a draw moves nobody: both records take it
		e["d"] = int(e.get("d", 0)) + 1
		opp["d"] = int(opp.get("d", 0)) + 1
		f["pro_next"] = c.day + MM.NEXT_WEEKS * 7 - LEAD_DAYS
		return {"draw": true, "rank_before": int(e["rank"]), "rank_after": int(e["rank"])}
	var line := MM.apply_result(e, opp, table(c, f), outcome == "win", stopped)
	e["rating"] = night(f)
	f["pro_next"] = c.day + int(e.get("next_weeks", MM.NEXT_WEEKS)) * 7 - LEAD_DAYS   # her next camp starts then
	var before := int(line["rank_before"])
	var after := int(line["rank_after"])
	if after != before:
		c.add_news("%s %s: %s." % [f["name"], "moves up" if (after > 0 and (before == 0 or after < before)) else "drops",
			"now #%d in the %s" % [after, str(c.world["divisions"][division_for(f)]["info"]["name"])] if after > 0 else "unranked"])
	return line


## The road: her table's top places with her row, the belts, and the next step in words.
static func road(c: Career, f: Dictionary) -> Dictionary:
	var e := entry(c, f)
	var rows := WR.ranking_snapshot(table(c, f))
	var you := int(e.get("rank", 0))
	var next := ""
	if you == 0:
		next = "Unranked: beat anyone in the top 20 and you take their place."
	elif you == 1:
		next = "Number 1: the champions have to face you."
	else:
		next = "#%d: beat anyone from #%d up and you take their place." % [you, maxi(1, you - MM.BAND_UP)]
	if bool(e.get("rebuild", false)):
		next += " Coming off a loss: win a rebuild fight first."
	return {"rows": rows, "you": you, "name": e.get("name", ""), "next": next, "fans": int(e.get("fans", 0)),
		"ducks": int(e.get("ducks", 0)), "div": str(c.world["divisions"][division_for(f)]["info"]["name"]) if not c.world.is_empty() else ""}


## The fight night a booking today would get (a six-week camp, then the Saturday).
static func fight_day(c: Career) -> int:
	return c.day - posmod(c.day, 7) + 5 + LEAD_DAYS


## What each choice does, in words, before she takes it: the place a win takes, what a loss costs, the duck it would be.
static func stakes(c: Career, f: Dictionary, opp: Dictionary, offered: Array = []) -> Dictionary:
	var e := entry(c, f)
	var you := int(e.get("rank", 0))
	var r := int(opp.get("rank", 0))
	var gap := float(opp["rating"]) - float(e["rating"])
	var fans := 1 + int(gap > 2.0) - int(gap <= -MM.SOFT_GAP)
	var win := ""
	if r > 0 and (you == 0 or r < you):
		win = "Win: you take #%d" % r
	elif r > 0:
		win = "Win: no place moves (#%d is below you)" % r
	else:
		win = "Win: you stay unranked; it builds the record"
	if str(opp.get("belt", "")) != "":
		win += " and the %s belt" % str(opp["belt"]).split("_")[-1]
	win += ", %s fan%s." % ["+%d" % fans if fans != 0 else "no", "" if absi(fans) == 1 else "s"]
	var lose := "Lose: one fan, and a rebuild fight before you can ask up"
	if you > 0 and r > 0 and r < you:
		lose += "; you drop a place"
	if you > 0 and you <= MM.TOP_RECORD:
		lose += "; a losing record leaves the top 10"
	var duck := ""
	for x in offered:
		if float(x["rating"]) > float(opp["rating"]) + 2.0:
			duck = "Taking this over the step-up is a duck: one more fan lost (%d of %d before step-ups stop)." % [
				int(e.get("ducks", 0)) + 1, MM.DUCKS_BLOCK]
			break
	return {"win": win, "lose": lose + ".", "duck": duck}


## Her pro form: the record and the last results, newest first (W / L / D).
static func form(c: Career, f: Dictionary) -> Dictionary:
	var marks: Array = []
	for r in c.results:
		if str(r.get("fid", "")) == str(f["id"]) and bool(r.get("pro", false)):
			marks.append({"win": "W", "loss": "L", "draw": "D"}.get(str(r.get("outcome", "")), "?"))
			if marks.size() >= 5:
				break
	return {"w": int(f.get("pro_w", 0)), "l": int(f.get("pro_l", 0)), "d": int(f.get("pro_d", 0)), "last": marks}
