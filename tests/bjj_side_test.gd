extends SceneTree
## BjjSide - the gym's no-gi classes as a business (S365, Kalli K-BELTROAD1 part 4).
## Population: the quick-start career (Ana Ribeiro, NoGi.athlete(): white belt, 2 stripes, 130 classes) and a blue-belt copy
## of her for the teaching trade; the BJJ side starts at BjjSide.START_MEMBERS.
##   1. money: dues at FEE_MONTH a month kept by the week, the hired coach's 5 classes, 3 when she teaches.
##   2. churn: CHURN_YEAR leaves in whole members (8 members lose 2-3 in a year), never below 0.
##   3. members join: gold 2, silver 1, bronze 0; blue belt 3 once, purple 0.
##   4. the teaching trade, measured: teaching saves money and costs her belt time - both shown, both real.
##   5. the career: weekly income/costs carry the BJJ lines, end_week bills them and churns; promote to blue adds members.
##   6. the page: THE BJJ CLASSES card, "Ana teaches" locked at white, open at blue, pressed -> 2 classes a week.

const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var _fails := 0


func _initialize() -> void:
	_money()
	_churn()
	_joins()
	_trade()
	_career()
	await _page()
	print("BJJ_SIDE %s failures=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)


func _money() -> void:
	var side := BjjSide.start()
	var m := BjjSide.money(side, false)
	_check(int(m["members"]) == 8 and int(m["dues"]) == roundi(8.0 * BjjSide.FEE_MONTH / BjjSide.WEEKS_A_MONTH), "8 members pay %d a week" % int(m["dues"]))
	_check(int(m["coach"]) == 5 * BjjSide.COACH_CLASS and int(BjjSide.money(side, true)["coach"]) == 3 * BjjSide.COACH_CLASS,
		"the hired coach: 5 classes, 3 when she teaches the beginners")
	_check(BjjSide.teach_saves() == 2 * BjjSide.COACH_CLASS, "teaching saves two classes a week")
	_check(BjjSide.FEE_MONTH > 3 * 35 - 10, "BJJ dues sit about 3x the boxing club's (UK GBP 75-120 vs GBP 28)")


func _churn() -> void:
	var side := BjjSide.start()
	var left := 0
	for w in 52:
		left += int(BjjSide.week(side, false)["left"])
	print("  measured: 8 members, one year -> %d left, %d on the mat" % [left, int(side["members"])])
	_check(left >= 2 and left <= 3 and int(side["members"]) == 8 - left, "a year of churn: 2-3 of 8 leave")
	var empty := {"members": 0, "churn": 0.0}
	for w in 10:
		BjjSide.week(empty, false)
	_check(int(empty["members"]) == 0, "an empty side stays at 0")


func _joins() -> void:
	var side := BjjSide.start()
	_check(BjjSide.medal(side, "gold") == 2 and BjjSide.medal(side, "silver") == 1 and BjjSide.medal(side, "bronze") == 0
		and BjjSide.medal(side, "") == 0 and int(side["members"]) == 11, "gold +2, silver +1, bronze and none 0")
	_check(BjjSide.promoted(side, "blue") == 3 and BjjSide.promoted(side, "purple") == 0 and int(side["members"]) == 14, "a blue belt brings 3")


## The trade: a blue-belt Ana at 3 classes vs 2. Teaching is cheaper and slower - each wins on its own measure.
func _trade() -> void:
	var f := NoGi.athlete()
	f["belt"] = "blue"
	f["belt_day"] = 0
	f["mat_classes"] = 0
	f["stripes"] = 0
	_check(BjjSide.can_teach(NoGi.athlete()) != "" and BjjSide.can_teach(f) == "", "teaching opens at blue, not at white")
	var slow := f.duplicate(true)
	slow["teaches"] = true
	var w3 := NoGi.weeks_to_ready(f, 0)
	var w2 := NoGi.weeks_to_ready(slow, 0)
	var saved := BjjSide.teach_saves() * w3
	print("  measured: purple at 3 classes %d weeks, teaching %d weeks; teaching saves %d over the %d weeks" % [w3, w2, saved, w3])
	_check(NoGi.classes_of(slow) == 2 and w2 > w3 and saved > 0, "teaching: cheaper by %d, purple %d weeks later" % [saved, w2 - w3])
	var a := f.duplicate(true)
	var b := slow.duplicate(true)
	NoGi.week(a)
	NoGi.week(b)
	_check(int(a["mat_classes"]) == 3 and int(b["mat_classes"]) == 2, "a week on the mat: 3 classes, 2 while she teaches")


func _career() -> void:
	var c := Career.quick_start()
	FirstWeek.ana_joins(c)
	_check(int(c.bjj_side["members"]) == BjjSide.START_MEMBERS and c.bjj_on() and not c.bjj_teaches(), "quick start: the BJJ side runs with 8 members")
	var inc := Sim.weekly_income(c)
	var cost := Sim.weekly_costs(c)
	_check(int(inc["bjj"]) == BjjSide.dues_week(8) and int(cost["bjj"]) == 5 * BjjSide.COACH_CLASS, "the week's money carries the BJJ dues and coach")
	c.day = 6
	var cash := c.cash
	var accrued := c.accrued
	var costs := int(Sim.weekly_costs(c)["total"])
	var boxing := int(Sim.weekly_income(c)["total"]) - int(Sim.weekly_income(c)["bjj"])   # the members' walk moves it <= ~48
	Sim.end_week(c)
	print("  measured: week 1 cash +%d (BJJ dues %d), accrued +%d (BJJ coach %d)" % [c.cash - cash, BjjSide.dues_week(8), c.accrued - accrued, 5 * BjjSide.COACH_CLASS])
	_check(c.accrued - accrued == costs and c.cash - cash >= boxing + BjjSide.dues_week(8) - 60,
		"end of the week: the BJJ dues in, the coach accrued")
	var before := int(c.bjj_side["members"])
	var why := Grapplers.promote(c, "ana")
	_check(why == "" and int(c.bjj_side["members"]) == before + BjjSide.BLUE_MEMBERS and str(c.news[0]["t"]).contains("BJJ classes"),
		"promoted to blue: +3 BJJ members and a news line (%s)" % why)
	var none := Career.new()
	_check(int(Sim.bjj_money(none)["dues"]) == 0 and int(Sim.weekly_costs(none)["bjj"]) == 0, "no no-gi athlete, no BJJ side")


func _page() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	FirstWeek.ana_joins(main.career)
	main.act("go", "fighters:0")
	main.act("fighter", "ana")
	for i in 3:
		await process_frame
	var p := main.find_child("GrapplerPage", true, false)
	var card := p.find_child("BjjClasses", true, false) if p != null else null
	var her := card.find_child("TeachHer", true, false) as Button if card != null else null
	_check(card != null and her != null and her.disabled and her.tooltip_text.contains("blue"), "the page: THE BJJ CLASSES, Ana teaches locked at white")
	var f: Dictionary = main.career.grappler_by_id("ana")
	main.act("gpromote", "ana")
	for i in 3:
		await process_frame
	p = main.find_child("GrapplerPage", true, false)
	her = p.find_child("TeachHer", true, false) as Button
	_check(str(f["belt"]) == "blue" and her != null and not her.disabled, "at blue the beginners' class is hers to take")
	her.pressed.emit()
	for i in 3:
		await process_frame
	_check(bool(f.get("teaches", false)) and NoGi.classes_of(f) == 2 and main.career.bjj_teaches(), "Ana teaches: 2 classes of her own a week")
	var call := main.find_child("CoachCall", true, false)
	var said := false
	for l in call.find_children("*", "Label", true, false):
		if (l as Label).text.contains("(2 classes a week)"):
			said = true
	_check(said, "the coach's line counts her 2 classes")


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
