extends RefCounted
## S398 menus round 6 ("one fixture list": Fights' CALENDAR and World's COMING UP told the same dates two ways): ONE list,
## drawn the same on both pages - the club's own dates (weigh-ins, fight nights, camps, the promoter, the nationals' road,
## no-gi opens, the month-end bill, the next stop) in gold, the region's shows plain. Each date once.
##   Fixtures.events(career) -> [{d, t, ours}]   Fixtures.card(career) -> [PanelContainer, body]

const UI := preload("res://scripts/ui/UI.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Region := preload("res://scripts/state/Region.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")


static func events(c: Career) -> Array:
	var ev: Array = []
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if not fb.is_empty() and fb.has("day"):   # S398: a pro offer's bout dict can come without a day yet (main CI)
			ev.append({"d": int(fb["day"]) - 1, "t": "Weigh-in: %s" % f["first"], "ours": true})
			ev.append({"d": int(fb["day"]), "t": "Fight night: %s vs %s%s" % [f["first"], fb["opp"]["name"], " (pro debut)" if bool(fb.get("pro", false)) else ""], "ours": true})
		if not (f["camp"] as Dictionary).is_empty():
			ev.append({"d": int(f["camp"]["start"]), "t": "%s's camp started" % f["first"], "ours": true})
		if ProLadder.on_ladder(c, f) and fb.is_empty() and (f.get("pro_offers", []) as Array).is_empty():
			ev.append({"d": maxi(int(f.get("pro_next", c.day)), c.day + 1), "t": "The promoter calls: %s's next fights" % f["first"], "ours": true})
	var next := Clock.next_stop(c)
	if not ["weigh-in", "fight night"].has(str(next["r"])) and not str(next["r"]).contains("review"):   # CONTINUE says the review
		var why := str(next["r"])   # S442 UX audit: capitalize() title-cased the line and lower-cased the name ("A Bout Offer Arrives (lucy)")
		ev.append({"d": int(next["d"]), "t": why.left(1).to_upper() + why.substr(1), "ours": true})
	ev.append({"d": GameMoney.next_bill_day(c.day), "t": "Month-end bill", "ours": true})
	for e in Champs.calendar(c):   # S328 the nationals: entries close, her road round by round
		ev.append({"d": int(e["d"]), "t": str(e["t"]), "ours": true})
	for g in c.grapplers:   # S396 blind review: Ana's opens were missing
		for d in g.get("entered", []):
			if int(d) >= c.day:
				ev.append({"d": int(d), "t": "%s's no-gi open" % g["first"], "ours": true})
	for d in Region.next_shows(c.day, 4):
		ev.append({"d": d, "t": "%s, %d rival bouts" % [Region.show_name(d), Region.SHOW_BOUTS], "ours": false})
	ev.sort_custom(func(a, b): return int(a["d"]) < int(b["d"]))
	var seen := {}
	var out: Array = []
	for e in ev:
		var key := "%d|%s" % [e["d"], str(e["t"]).to_lower()]
		if not seen.has(key):
			seen[key] = true
			out.append(e)
	return out


static func card(c: Career) -> Array:
	var card := UI.card("FIXTURES")
	card[0].name = "Fixtures"
	var rows: Array = []
	for e in events(c):
		if not bool(e["ours"]):   # S416 "there is nothing to do in this menu": other clubs' shows are nothing you can act on
			continue
		rows.append(UI.kv(Clock.fmt(int(e["d"])), e["t"], UI.GOLD if bool(e["ours"]) else UI.FG))
	UI.add_rows(card[1], rows)
	return card
