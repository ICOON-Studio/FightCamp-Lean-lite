extends SceneTree
## S517b LADDERWIRE stage 3 R9 wired: on a Monday a rival below our boxer on the ladder (in reach, legal) rings for a bout at
## the next show; it is a red need and a card with three answers; Accept books that show, Not this show is free once a
## season with that rival, Pass gives the challenger 2 points; 1 January makes Not this show free again; at most one
## offer every 4 weeks a boxer. Population: a quick-start club with Lucy (made 6-1) against the region's own named rivals.
## Prints RIVAL_OFFER_WIRE failures=N.

const Data := preload("res://scripts/state/Data.gd")
const RivalOfferWire := preload("res://scripts/state/RivalOfferWire.gd")
const RivalOfferCard := preload("res://scripts/ui/RivalOfferCard.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Region := preload("res://scripts/state/Region.gd")
const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")

var _fails := 0


func _club() -> Career:
	var c := Career.quick_start()
	c.seed = 41
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	f["w"] = 6
	f["l"] = 1
	f["rep"] = 40
	f["offers"] = []
	f["next_offer_day"] = 9999
	# A Monday with a show 7-21 days out.
	var d := 7
	while RivalOfferWire._show_after(d) < 0:
		d += 7
	c.day = d
	return c


func _initialize() -> void:
	var c := _club()
	var f: Dictionary = c.fighters[0]
	var lines := RivalOfferWire.monday(c)
	_check(RivalOfferWire.is_open(f), "a Monday: a rival rings (%s)" % str(lines))
	var o: Dictionary = f.get("rival_offer", {})
	var r := c.rival(str(o.get("name", "")))
	_check(not r.is_empty() and str(r["div"]) == "wlw" and LadderPoints.rep_of(r) < 40, "the caller is a wlw rival below her 40 points (%d)" % LadderPoints.rep_of(r))
	_check(Region.is_show_day(int(o.get("show", -1))) and int(o["show"]) - c.day >= 7 and int(o["show"]) - c.day <= 21, "for a show 7-21 days out")
	var needs: Array = Needs.blockers(c).filter(func(n): return str(n.get("act", "")) == "rivaloffer")
	_check(needs.size() == 1, "a red need: %s" % str(needs.map(func(n): return n["t"])))
	var v := RivalOfferCard.view(c, f)
	_check((v["cols"] as Array).map(func(x): return x["word"]) == ["Accept", "Not this show", "Pass"], "the card's three answers")
	_check(str(v["cols"][0]["rows"][0]).begins_with("Ladder points on a win +"), "Accept shows the points: %s" % v["cols"][0]["rows"][0])
	_check(str(v["cols"][2]["rows"][0]).contains("2 ladder points"), "Pass shows its cost: %s" % v["cols"][2]["rows"][0])
	# Accept books the show and keeps the sheet's turn.
	var idx := int(f["opp_index"])
	_check(RivalOfferWire.answer(c, "lucy", "accept") == "", "Accept is taken")
	_check(int((f["bout"] as Dictionary).get("day", -1)) == int(o["show"]) and str(f["bout"]["opp"]["name"]) == str(r["name"]), "the bout is on that show against the caller")
	_check(int(f["opp_index"]) == idx and not RivalOfferWire.is_open(f), "the sheet's turn is kept, the offer closed")
	# Not this show: free once, then a pass.
	c = _club()
	f = c.fighters[0]
	RivalOfferWire.monday(c)
	r = c.rival(str(f["rival_offer"]["name"]))
	var their := LadderPoints.rep_of(r)
	_check(RivalOfferWire.answer(c, "lucy", "not_this_show") == "" and int(f["rep"]) == 40 and LadderPoints.rep_of(r) == their, "Not this show costs nothing")
	_check(bool(r.get("not_this_show_used", false)), "and is used for the season with that rival")
	_check(RivalOfferWire.monday(c).is_empty(), "no new offer the same week")
	f["rival_offer"] = {"name": str(r["name"]), "club": str(r["club"]), "show": c.day + 14, "day": c.day, "expires": c.day + 4}
	_check(RivalOfferWire.answer(c, "lucy", "not_this_show") == "" and int(f["rep"]) == 38 and LadderPoints.rep_of(r) == their + 2,
		"a second Not this show counts as a pass: 40 -> %d, theirs %d -> %d" % [int(f["rep"]), their, LadderPoints.rep_of(r)])
	# Pass costs 2; the season end frees Not this show again.
	c = _club()
	f = c.fighters[0]
	RivalOfferWire.monday(c)
	r = c.rival(str(f["rival_offer"]["name"]))
	_check(RivalOfferWire.answer(c, "lucy", "pass") == "" and int(f["rep"]) == 38, "Pass: 40 -> %d" % int(f["rep"]))
	r["not_this_show_used"] = true
	RivalOfferWire.season_reset(c)
	_check(not bool(r["not_this_show_used"]), "1 January: Not this show is free again")
	# Four weeks between offers for one boxer.
	c.day += 7
	_check(RivalOfferWire.monday(c).is_empty(), "one week later: no offer (4 weeks a boxer)")
	# Unanswered past its day: it lapses as a pass.
	c = _club()
	f = c.fighters[0]
	RivalOfferWire.monday(c)
	c.day += 5
	RivalOfferWire.lapse(c)
	_check(not RivalOfferWire.is_open(f) and int(f["rep"]) == 38, "left unanswered: it lapses as a pass (%d)" % int(f["rep"]))
	# A boxer with a bout booked gets no call.
	c = _club()
	f = c.fighters[0]
	f["bout"] = {"opp": {"name": "x"}, "day": c.day + 10, "weighed": false, "made": false, "done": false}
	_check(RivalOfferWire.monday(c).is_empty(), "already booked: nobody rings")
	# S518 LADDERPROBE4 (no call in 60 runs: the door was read today, shut by the rest after a bout): resting 3 days after a
	# bout, a rival rings for a show after the rest, and Accept books it.
	c = _club()
	f = c.fighters[0]
	var rest_end := c.day - 3 + Bouts.AFTER_FIGHT
	f["last_bout_day"] = c.day - 3
	_check(not bool(AskFlow.open(c, f)["open"]), "3 days after a bout the Ask door is shut today")
	var lines2 := RivalOfferWire.monday(c)
	_check(RivalOfferWire.is_open(f) and int(f["rival_offer"]["show"]) >= rest_end, "resting: a rival rings for a show after the rest (%s)" % str(lines2))
	if RivalOfferWire.is_open(f):
		var show := int(f["rival_offer"]["show"])
		_check(RivalOfferWire.answer(c, "lucy", "accept") == "" and int((f["bout"] as Dictionary).get("day", -1)) == show, "Accept books it while resting")
	print("RIVAL_OFFER_WIRE failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok   %s" % what)
	else:
		_fails += 1
		print("  FAIL %s" % what)
