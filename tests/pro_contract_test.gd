extends SceneTree
## TASK PROCONTRACT1: blind contract test for turning pro (TURNPRO1 v2).
## Written strictly from the contract, DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md
## sections 1-6, and module header comments without reading forbidden function bodies.

const Career := preload("res://scripts/state/Career.gd")
const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const ProWeekLines := preload("res://scripts/ui/ProWeekLines.gd")

var failures: int = 0

func _initialize() -> void:
	_test_check_pro_eligibility_and_structure()
	_test_two_houses_and_forecast()
	_test_window_lapse_and_return()
	_test_asks_and_plain()
	_test_turn_pro_and_declines()
	_test_proweeklines()
	if failures == 0:
		print("PRO_CONTRACT PASS fails=0")
	else:
		print("PRO_CONTRACT FAIL fails=%d" % failures)
	quit(1 if failures > 0 else 0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("ok  " + label)
	else:
		failures += 1
		print("FAIL " + label)

func _make_career(members: int = 50, day: int = 0) -> Career:
	var c: Career = Career.quick_start()
	c.day = day
	c.members = members
	c.fighters.clear()
	var f: Dictionary = Data.fighter_state(Data.lucy(), day)
	f["pro_declines"] = 0
	f["bout"] = {}
	f["booked_fight"] = false
	c.fighters.append(f)
	return c

func _test_check_pro_eligibility_and_structure() -> void:
	# Sub-threshold: 6 wins rank 3, 7 wins rank 4, 8 wins rank 5
	var c: Career = _make_career(50, 10)
	var f: Dictionary = c.fighter()
	f["w"] = 6
	f["rank"] = 3
	Roster.check_pro(c)
	_check(c.pro_offer.is_empty(), "6 wins rank 3: no offer")
	f["w"] = 7
	f["rank"] = 4
	Roster.check_pro(c)
	_check(c.pro_offer.is_empty(), "7 wins rank 4: no offer")
	f["w"] = 8
	f["rank"] = 5
	Roster.check_pro(c)
	_check(c.pro_offer.is_empty(), "8 wins rank 5: no offer")

	# At the line: 7 wins top-3 ranking, and 9 wins any rank
	f["w"] = 7
	f["rank"] = 3
	f["age"] = 22
	Roster.check_pro(c)
	_check(not c.pro_offer.is_empty(), "7 wins with rank 3: offer made")
	c.pro_offer.clear()
	f["w"] = 9
	f["rank"] = 0
	Roster.check_pro(c)
	_check(not c.pro_offer.is_empty(), "9 wins at rank 0: offer made")

	# Edge: second check_pro on the same day changes nothing
	var expires_before: int = int(c.pro_offer.get("expires", 0))
	var fid_before: String = str(c.pro_offer.get("fid", ""))
	Roster.check_pro(c)
	_check(int(c.pro_offer.get("expires", 0)) == expires_before and str(c.pro_offer.get("fid", "")) == fid_before, "second check_pro on same day changes nothing")

	# Edge: offer is not made while a bout is booked
	var c_bk: Career = _make_career(50, 10)
	var f_bk: Dictionary = c_bk.fighter()
	f_bk["w"] = 9
	f_bk["bout"] = {"day": 24, "opponent": "Jane"}
	f_bk["booked_fight"] = true
	Roster.check_pro(c_bk)
	_check(c_bk.pro_offer.is_empty(), "an offer is not made while a bout is booked")
	f_bk["bout"] = {}
	f_bk["booked_fight"] = false
	Roster.check_pro(c_bk)
	_check(not c_bk.pro_offer.is_empty(), "offer made once booked bout is cleared")

	# Edge: age 32 or older gets no first call; 31 does
	var c_age: Career = _make_career(50, 10)
	var f_age: Dictionary = c_age.fighter()
	f_age["w"] = 9
	f_age["age"] = ProCall.AGE_STOP
	f_age["pro_declines"] = 0
	Roster.check_pro(c_age)
	_check(c_age.pro_offer.is_empty(), "never at age 32 or older for a first call")
	f_age["age"] = 31
	Roster.check_pro(c_age)
	_check(not c_age.pro_offer.is_empty(), "first call made at age 31")

	# Structure: first house old keys and added keys
	var o: Dictionary = c.pro_offer
	_check(str(o.get("fid", "")) == str(f.get("id", "")), "c.pro_offer keeps fid")
	_check(o.has("promoter") and o.has("purse") and o.has("terms") and o.has("step") and o.has("top"), "c.pro_offer keeps promoter, purse, terms, step, top")
	_check(o.get("offers", []) is Array and not (o.get("offers", []) as Array).is_empty(), "c.pro_offer adds offers array")
	_check(o.has("forecast") and int(o.get("forecast", 0)) >= 0, "c.pro_offer adds forecast")
	_check(int(o.get("expires", 0)) == c.day + ProCall.WINDOW_DAYS, "c.pro_offer adds expires (day + 14)")
	_check(o.get("asked", null) is Dictionary and o.get("plain", null) is Dictionary, "c.pro_offer adds asked and plain dictionaries")

func _test_two_houses_and_forecast() -> void:
	var pmap: Dictionary = ProCall.promoters()
	_check(pmap.has("bow") and pmap.has("hf"), "ProCall.promoters defines bow and hf")
	var bow_base: Dictionary = pmap.get("bow", {}) as Dictionary
	var hf_base: Dictionary = pmap.get("hf", {}) as Dictionary
	_check(int(bow_base.get("purse", 0)) == 1500 and int(bow_base.get("break_even", 0)) == 60 and int(bow_base.get("debut_weeks", 0)) == 4, "bow: $1,500, break-even 60, debut 4 weeks out")
	_check(int(hf_base.get("purse", 0)) == 1800 and int(hf_base.get("debut_weeks", 0)) == 6, "hf: $1,800, debut 6 weeks out")

	# Pure rule ProCall.who_calls: far below, band [45, 75], far above
	_check(ProCall.who_calls(40) == ["hf"], "forecast 40 (< 45): Harrow & Finch alone")
	var mid_calls: Array = ProCall.who_calls(60)
	_check(mid_calls.size() == 2 and mid_calls.has("bow") and mid_calls.has("hf"), "forecast 60 (within 15 of 60): both houses call")
	_check(ProCall.who_calls(80) == ["bow"], "forecast 80 (> 75): Bow Lane alone")

	# In career check_pro: tickets = 20 + floor(members * 0.5) + 2 * w
	var c_low: Career = _make_career(0, 5)
	c_low.fighter()["w"] = 9  # tickets = 38 (< 45)
	Roster.check_pro(c_low)
	var off_low: Array = c_low.pro_offer.get("offers", []) as Array
	_check(off_low.size() == 1 and str((off_low[0] as Dictionary).get("key", "")) == "hf", "career forecast < 45 produces Harrow & Finch alone")

	var c_mid: Career = _make_career(40, 5)
	c_mid.fighter()["w"] = 9  # tickets = 58 ([45, 75])
	Roster.check_pro(c_mid)
	var off_mid: Array = c_mid.pro_offer.get("offers", []) as Array
	var keys_mid: Array = off_mid.map(func(it: Dictionary) -> String: return str(it.get("key", "")))
	_check(off_mid.size() == 2 and keys_mid.has("bow") and keys_mid.has("hf"), "career forecast within 15 of 60 produces both houses")

	var c_high: Career = _make_career(100, 5)
	c_high.fighter()["w"] = 9  # tickets = 88 (> 75)
	Roster.check_pro(c_high)
	var off_high: Array = c_high.pro_offer.get("offers", []) as Array
	_check(off_high.size() == 1 and str((off_high[0] as Dictionary).get("key", "")) == "bow", "career forecast > 75 produces Bow Lane alone")

func _test_window_lapse_and_return() -> void:
	_check(ProCall.WINDOW_DAYS == 14, "ProCall.WINDOW_DAYS is 14")
	var c: Career = _make_career(40, 10)
	var f: Dictionary = c.fighter()
	f["w"] = 9
	Roster.check_pro(c)
	_check(int(c.pro_offer.get("expires", 0)) == 24, "offer expires on day 10 + 14 = 24")

	# Edge: day 13 vs day 14 (day 13 = still there, day 14 = lapsed)
	c.day = 23
	Roster.check_pro(c)
	_check(not c.pro_offer.is_empty(), "the window running out on day 13 vs day 14 (13 = still there)")

	c.day = 24
	Roster.check_pro(c)
	_check(c.pro_offer.is_empty(), "day 14: offer has lapsed")
	_check(int(f.get("pro_declines", 0)) == 0, "lapse is NOT a decline: pro_declines does not move")

	# Promoter calls again after 2 more wins (no call before them)
	f["w"] = 10
	Roster.check_pro(c)
	_check(c.pro_offer.is_empty(), "no call after only 1 win following lapse")

	f["w"] = 11
	Roster.check_pro(c)
	_check(not c.pro_offer.is_empty(), "promoter calls again after 2 more wins")

func _test_asks_and_plain() -> void:
	var c: Career = _make_career(40, 0)
	c.fighter()["w"] = 9
	Roster.check_pro(c)

	# 1. "will not" answer does not spend the ask
	var wont_txt: String = ProOfferWire.ask(c, "bow", "costs", 10)
	_check(wont_txt != "", "ask 'costs' on bow returns refusal text")
	var asked_map: Dictionary = c.pro_offer.get("asked", {}) as Dictionary
	_check((asked_map.get("bow", {}) as Dictionary).is_empty(), "a 'will not' answer does not spend the ask")

	# 2. Taken ask spends it and updates terms
	var take_txt: String = ProOfferWire.ask(c, "bow", "later2", 10)
	_check(take_txt != "", "taken ask 'later2' on bow returns text")
	var off_bow: Dictionary = ProOfferWire.offer(c.pro_offer, "bow")
	_check(int(off_bow.get("debut_weeks", 0)) == 6, "taken ask later2 updates debut_weeks to 6")

	# 3. Second ask on same house is refused
	var second_txt: String = ProOfferWire.ask(c, "bow", "softer", 10)
	_check(second_txt == "", "second ask on the same house is refused")

	# 4. Other house keeps its own ask
	var hf_txt: String = ProOfferWire.ask(c, "hf", "costs", 10)
	_check(hf_txt != "", "the other house keeps its own ask and accepts costs")

	# 5. back_to_plain restores plain terms and ask stays spent
	ProOfferWire.back_to_plain(c, "bow")
	var plain_bow: Dictionary = ProOfferWire.offer(c.pro_offer, "bow")
	_check(int(plain_bow.get("debut_weeks", 0)) == 4, "back_to_plain restores plain terms")
	var ask_after_plain: String = ProOfferWire.ask(c, "bow", "later4", 10)
	_check(ask_after_plain == "", "ask stays spent after back_to_plain")

func _test_turn_pro_and_declines() -> void:
	# 5a. Sign with "bow": 4 weeks out, stipend stops, pro_signed records previous stipend
	var c_bow: Career = _make_career(40, 100)
	var f_bow: Dictionary = c_bow.fighter()
	f_bow["w"] = 9
	f_bow["weekly_salary"] = 250
	Roster.check_pro(c_bow)
	Roster.turn_pro(c_bow, "bow")

	_check(bool(f_bow.get("pro", false)), "f[pro] true after turn_pro")
	_check(int(f_bow.get("weekly_salary", -1)) == 0, "the stipend stops (weekly_salary 0)")
	_check(c_bow.pro_offer.is_empty(), "c.pro_offer is empty after signing")
	var bout_bow: Dictionary = f_bow.get("bout", {}) as Dictionary
	_check(bool(bout_bow.get("pro", false)), "debut is booked pro")
	_check(int(bout_bow.get("day", 0)) == Roster.debut_day(100, 4), "signing with 'bow' books 4 weeks out")

	var ps_bow: Dictionary = f_bow.get("pro_signed", {}) as Dictionary
	_check(int(ps_bow.get("d", -1)) == 100 and str(ps_bow.get("key", "")) == "bow" and str(ps_bow.get("house", "")) != "", "pro_signed records d, the house key and its name")
	_check(int(ps_bow.get("stipend", 0)) == 250, "pro_signed records previous weekly_salary (250) before zeroing")
	_check(int(ps_bow.get("costs", 0)) > 0, "pro_signed records costs > 0 when gym pays them")

	# 5b. Sign with "hf" (costs ask taken): books 6 weeks out, costs recorded as 0
	var c_hf: Career = _make_career(40, 200)
	var f_hf: Dictionary = c_hf.fighter()
	f_hf["w"] = 9
	f_hf["weekly_salary"] = 250
	Roster.check_pro(c_hf)
	ProOfferWire.ask(c_hf, "hf", "costs", 10)
	Roster.turn_pro(c_hf, "hf")
	var bout_hf: Dictionary = f_hf.get("bout", {}) as Dictionary
	_check(int(bout_hf.get("day", 0)) == Roster.debut_day(200, 6), "signing with 'hf' books 6 weeks out")
	var ps_hf: Dictionary = f_hf.get("pro_signed", {}) as Dictionary
	_check(int(ps_hf.get("costs", -1)) == 0, "pro_signed records costs as 0 when house pays from purse")

	# 5c. Decline pro and edge: a decline's next call puts the declined house FIRST
	var c_dec: Career = _make_career(40, 10)
	var f_dec: Dictionary = c_dec.fighter()
	f_dec["w"] = 9
	Roster.check_pro(c_dec)
	var off_dec: Array = c_dec.pro_offer.get("offers", []) as Array
	var declined_house: String = str((off_dec[0] as Dictionary).get("key", ""))

	Roster.decline_pro(c_dec)
	_check(int(f_dec.get("pro_declines", 0)) == 1, "Roster.decline_pro increments pro_declines to 1")
	_check(c_dec.pro_offer.is_empty(), "c.pro_offer empty after decline")

	f_dec["w"] += 2
	Roster.check_pro(c_dec)
	_check(not c_dec.pro_offer.is_empty(), "offer returns after 2 wins following decline")
	var next_off: Array = c_dec.pro_offer.get("offers", []) as Array
	_check(str((next_off[0] as Dictionary).get("key", "")) == declined_house, "a decline's next call puts the declined house FIRST")

	# 5d. Edge (design s1, corrected S525): after 2 declines only a regional number 1 calls; after 3 the door is closed.
	Roster.decline_pro(c_dec)
	_check(int(f_dec.get("pro_declines", 0)) == 2, "second decline")
	f_dec["w"] += 9
	f_dec["rank"] = 2
	Roster.check_pro(c_dec)
	_check(c_dec.pro_offer.is_empty(), "two declines then 9 more wins = no call short of a number 1 ranking")
	f_dec["rank"] = 1
	Roster.check_pro(c_dec)
	_check(not c_dec.pro_offer.is_empty(), "two declines: a number 1 ranking brings the call")
	Roster.decline_pro(c_dec)
	_check(int(f_dec.get("pro_declines", 0)) == 3, "three declines reached")
	_check(str((c_dec.news[0] as Dictionary).get("t", "")).contains("No promoter will call"), "the third decline's news closes the door: %s" % str((c_dec.news[0] as Dictionary).get("t", "")))
	f_dec["w"] += 9
	Roster.check_pro(c_dec)
	_check(c_dec.pro_offer.is_empty(), "three declines: the door is closed even at number 1")
	Roster.decline_pro(c_dec)
	_check(int(f_dec.get("pro_declines", 0)) == 3, "declining with no offer on the table changes nothing")

func _test_proweeklines() -> void:
	# 6a. Nothing for an amateur
	var f_am: Dictionary = Data.fighter_state(Data.lucy(), 0)
	_check(ProWeekLines.lines_for(f_am, 14).is_empty(), "ProWeekLines.lines_for returns nothing for an amateur")

	# 6b. Days 1-28 after signing and before debut: one "signed" line
	var f_pro: Dictionary = Data.fighter_state(Data.lucy(), 0)
	f_pro["pro"] = true
	f_pro["first"] = "Lucy"
	f_pro["name"] = "Lucy Jackson"
	f_pro["pro_signed"] = {"d": 0, "house": "bow", "stipend": 250, "costs": 1245}
	f_pro["bout"] = {"pro": true, "day": 42}

	# Day 7 (N = 1 week since signing)
	var lines_d7: Array = ProWeekLines.lines_for(f_pro, 7)
	_check(lines_d7.size() == 1, "day 7 has 1 signed line")
	var l7: Dictionary = lines_d7[0] as Dictionary
	_check(str(l7.get("kind", "")) == "signed", "day 7 line kind is 'signed'")
	var t7: String = str(l7.get("t", ""))
	_check(t7.contains("Amateur cut lost $" + str(ProCall.LOST_CUT_A_WEEK * 1)), "day 7 cut lost matches ProCall.LOST_CUT_A_WEEK x 1 ($75)")
	_check(t7.contains("stipend saved $" + str(250 * 1)), "day 7 stipend saved matches stipend x 1 ($250)")
	_check(t7.contains("week") and t7.contains("since signing"), "day 7 mentions week since signing")
	_check(not t7.contains("Lucy") and not t7.contains("Jackson"), "no boxer name in day 7 line text")
	_check(str(l7.get("head", "")).to_upper().contains("LUCY"), "boxer name only in head")

	# Day 28 (N = 4 weeks since signing)
	var lines_d28: Array = ProWeekLines.lines_for(f_pro, 28)
	_check(lines_d28.size() == 1, "day 28 has 1 signed line")
	var l28: Dictionary = lines_d28[0] as Dictionary
	var t28: String = str(l28.get("t", ""))
	_check(t28.contains("Amateur cut lost $" + str(ProCall.LOST_CUT_A_WEEK * 4)), "day 28 cut lost matches ProCall.LOST_CUT_A_WEEK x 4 ($300)")
	_check(t28.contains("stipend saved $1,000") or t28.contains("stipend saved $1000"), "day 28 stipend saved matches stipend x 4 ($1,000)")
	_check(t28.contains("4 weeks") and t28.contains("since signing"), "day 28 mentions 4 weeks since signing")
	_check(not t28.contains("Lucy") and not t28.contains("Jackson"), "no boxer name in day 28 line text")

	# 6c. Edge: ProWeekLines on day 29 after signing = nothing
	var lines_d29: Array = ProWeekLines.lines_for(f_pro, 29)
	_check(lines_d29.is_empty(), "ProWeekLines on day 29 after signing = nothing")

	# 6d. The debut's week: ledger line and next line
	(f_pro["pro_signed"] as Dictionary)["debut"] = {"d": 42, "gym": 375}
	var lines_deb: Array = ProWeekLines.lines_for(f_pro, 42)
	var has_ledger: bool = false
	var has_next: bool = false
	var no_name_in_text: bool = true
	for item in lines_deb:
		var row: Dictionary = item as Dictionary
		var kind: String = str(row.get("kind", ""))
		var text: String = str(row.get("t", ""))
		if text.contains("Lucy") or text.contains("Jackson"):
			no_name_in_text = false
		if kind == "ledger":
			has_ledger = true
			var lower: String = text.to_lower()
			_check(lower.contains("share") and lower.contains("costs") and lower.contains("net"), "ledger line contains share, costs, net")
		elif kind == "next":
			has_next = true
			_check(text.begins_with("NEXT: "), "next line starts with 'NEXT: '")
	_check(has_ledger, "debut week produces ledger line")
	_check(has_next, "debut week produces next line")
	_check(no_name_in_text, "no boxer name in any debut week line text")
