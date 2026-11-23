extends SceneTree
## S524 TURNPRO1 map M11: the week review's turning-pro lines from the real ledger.
## Signing writes the stipend and the gym's costs; the 4 weeks after signing say the amateur cut lost and the stipend
## saved; the debut's week says share, costs, net and one NEXT line. Control arms: an amateur and a boxer signed
## 5 weeks ago get no line. (S543 v17: the costs-covered deal went with the asks; its control is deleted.)

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProWeekLines := preload("res://scripts/ui/ProWeekLines.gd")
const UI := preload("res://scripts/ui/UI.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _career() -> Career:
	var c := Career.quick_start()
	c.seed = 11
	c.members = 60
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["w"] = 9
	f["l"] = 1
	f["offers"] = []
	f["age"] = 24
	f["loyalty"] = 60
	f["weekly_salary"] = 250
	return c


func _initialize() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	_check(ProWeekLines.lines_for(f, c.day).is_empty(), "an amateur has no pro line")
	Roster.check_pro(c)
	_check(str(c.pro_offer.get("promoter", "")) == Roster.PROMOTER, "the promoter calls (%s)" % str(c.pro_offer.get("promoter", "")))
	Roster.turn_pro(c)
	var s: Dictionary = f.get("pro_signed", {})
	_check(int(s.get("stipend", -1)) == 250 and int(f["weekly_salary"]) == 0, "signing keeps the stipend it stopped ($250)")
	_check(int(s.get("costs", -1)) > 0, "the gym's signing costs are on the record (%d)" % int(s.get("costs", -1)))
	var d0 := int(s["d"])
	_check(ProWeekLines.lines_for(f, d0).is_empty(), "the signing day itself: no line yet")
	var l1 := ProWeekLines.lines_for(f, d0 + 6)
	_check(l1.size() == 1 and str(l1[0]["t"]) == "Amateur cut lost $%d; stipend saved $250 (1 week since signing)." % ProCall.LOST_CUT_A_WEEK,
		"week 1: %s" % (str(l1[0]["t"]) if not l1.is_empty() else "none"))
	var l4 := ProWeekLines.lines_for(f, d0 + 28)
	_check(l4.size() == 1 and str(l4[0]["t"]).contains("$1,000") and str(l4[0]["t"]).contains("4 weeks"), "week 4: %s" % (str(l4[0]["t"]) if not l4.is_empty() else "none"))
	_check(ProWeekLines.lines_for(f, d0 + 35).is_empty(), "5 weeks after signing: the line is gone")
	_check(not str(l4[0]["t"]).contains(str(f["first"])) and str(l4[0]["head"]).contains(str(f["name"]).to_upper()),
		"the name is in the header only (S448)")
	# The debut night: BoutFinish writes {d, gym}; the review the day after reads share, costs, net.
	s["debut"] = {"d": d0 + 30, "gym": 300}
	var ld := ProWeekLines.lines_for(f, d0 + 31)
	var net := 300 - int(s["costs"])
	_check(ld.size() == 2 and str(ld[0]["kind"]) == "ledger" and str(ld[0]["t"]).contains("net " + UI.signed(net)) and bool(ld[0]["bad"]) == (net < 0),
		"debut ledger: %s" % (str(ld[0]["t"]) if not ld.is_empty() else "none"))
	_check(str(ld[1]["t"]).begins_with("NEXT: ") and str(ld[1]["t"]).contains("members" if net < 0 else "purse"), "the lever: %s" % (str(ld[1]["t"]) if ld.size() > 1 else "none"))
	_check(ProWeekLines.lines_for(f, d0 + 37).is_empty(), "a week after the debut: gone")
	_check(ProWeekLines.lines_for(f, d0 + 6).is_empty(), "after the debut is recorded the signing line no longer shows")
	s["costs"] = 0
	_check(str(ProWeekLines.next_line(f, 300)).contains("$500"), "a debut in profit: the next lever is the purse step")
	print("PRO_WEEK_LINES failures=%d" % failures)
	quit(0 if failures == 0 else 1)
