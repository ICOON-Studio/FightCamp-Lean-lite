extends SceneTree
## TASK PROCONTRACT1: blind contract test for turning pro (TURNPRO1 v2), cut to v17 by S543 TURNPROBUILD17 (map
## DESIGN_TURNPRO1_V17.md section 6): the two houses, who calls by the forecast, the 14-day window, the lapse, the asks and
## the decline rule are gone; their checks are deleted or rewritten (docs/TURNPROBUILD17_RESULT.md lists each). Kept: the
## offer line, the structure keys, no offer beside a booked bout, the age stop, signing, the week review's lines.

const Career := preload("res://scripts/state/Career.gd")
const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const ProWeekLines := preload("res://scripts/ui/ProWeekLines.gd")

var failures: int = 0

func _initialize() -> void:
	_test_check_pro_eligibility_and_structure()
	_test_turn_pro_and_not_yet()
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
	var day_before: int = int(c.pro_offer.get("day", -1))
	var fid_before: String = str(c.pro_offer.get("fid", ""))
	Roster.check_pro(c)
	_check(int(c.pro_offer.get("day", -2)) == day_before and str(c.pro_offer.get("fid", "")) == fid_before, "second check_pro on same day changes nothing")

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
	Roster.check_pro(c_age)
	_check(c_age.pro_offer.is_empty(), "never at age 32 or older for a first call")
	f_age["age"] = 31
	Roster.check_pro(c_age)
	_check(not c_age.pro_offer.is_empty(), "first call made at age 31")


	# Structure: the old keys, one promoter (S543 v17), the two bouts of fight 1 today and four weeks on
	var o: Dictionary = c.pro_offer
	_check(str(o.get("fid", "")) == str(f.get("id", "")), "c.pro_offer keeps fid")
	_check(o.has("promoter") and o.has("purse") and o.has("terms") and o.has("step") and o.has("top"), "c.pro_offer keeps promoter, purse, terms, step, top")
	_check(not o.has("offers") and not o.has("asked") and not o.has("expires"), "one promoter, one offer: no houses, no asks, no window")
	_check(o.has("forecast") and int(o.get("forecast", 0)) >= 0, "c.pro_offer adds forecast")
	_check((o.get("pair_now", {}) as Dictionary).has("safe") and (o.get("pair_later", {}) as Dictionary).has("risky"), "c.pro_offer carries fight 1's two bouts today and four weeks on")


func _test_turn_pro_and_not_yet() -> void:
	# 5a. Sign: the stipend stops, pro_signed records the previous stipend, the debut is picked from two bouts
	var c_bow: Career = _make_career(40, 100)
	var f_bow: Dictionary = c_bow.fighter()
	f_bow["w"] = 9
	f_bow["weekly_salary"] = 250
	Roster.check_pro(c_bow)
	Roster.turn_pro(c_bow)

	_check(bool(f_bow.get("pro", false)), "f[pro] true after turn_pro")
	_check(int(f_bow.get("weekly_salary", -1)) == 0, "the stipend stops (weekly_salary 0)")
	_check(c_bow.pro_offer.is_empty(), "c.pro_offer is empty after signing")
	_check((f_bow.get("bout", {}) as Dictionary).is_empty() and (f_bow.get("pro_pair", {}) as Dictionary).has("safe"), "the debut waits as two bouts (S543 v17)")
	_check(int(f_bow.get("pro_due", 0)) == Roster.debut_day(100, 4), "the debut night is 4 weeks out")

	var ps_bow: Dictionary = f_bow.get("pro_signed", {}) as Dictionary
	_check(int(ps_bow.get("d", -1)) == 100 and str(ps_bow.get("house", "")) == Roster.PROMOTER, "pro_signed records d and the promoter's name")
	_check(int(ps_bow.get("stipend", 0)) == 250, "pro_signed records previous weekly_salary (250) before zeroing")
	_check(int(ps_bow.get("costs", 0)) > 0, "pro_signed records costs > 0 when gym pays them")

	# 5c. Not yet (S543 v17 replaces the decline rule): the offer returns four weeks later, the line does not move
	var c_dec: Career = _make_career(40, 10)
	var f_dec: Dictionary = c_dec.fighter()
	f_dec["w"] = 9
	Roster.check_pro(c_dec)
	Roster.decline_pro(c_dec)
	_check(int(f_dec["pro_start"]["patience"]) == 2 and c_dec.pro_offer.is_empty(), "Not yet: a mark spent, the offer goes")
	c_dec.day += 27
	Roster.check_pro(c_dec)
	_check(c_dec.pro_offer.is_empty(), "no call inside four weeks")
	c_dec.day += 1
	Roster.check_pro(c_dec)
	_check(not c_dec.pro_offer.is_empty() and int(f_dec["w"]) == 9, "the offer returns four weeks later at the same 9 wins")
	Roster.decline_pro(c_dec)
	c_dec.day += 28
	Roster.check_pro(c_dec)
	_check(bool(c_dec.pro_offer.get("rival", false)), "the third call is a rival gym's")
	Roster.decline_pro(c_dec)
	_check(not c_dec.pro_offer.is_empty(), "Not yet does nothing on the rival gym's call")
	c_dec.pro_offer = {}
	Roster.decline_pro(c_dec)
	_check(int(f_dec["pro_start"]["patience"]) == 1, "declining with no offer on the table changes nothing")

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
