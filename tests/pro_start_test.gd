extends SceneTree
## S543 TURNPRO17 step 1: ProStart, the rules of turning pro (map DESIGN_TURNPRO1_V17.md; the owner's approved numbers,
## two tuned by TURNPROBE17). Pure rules: patience and "Not yet", the two bouts' chance / purse / name, the two bars.

const ProStart := preload("res://scripts/rules/ProStart.gd")

var failures := 0


func _initialize() -> void:
	_test_when()
	_test_chance()
	_test_bars()
	_test_hunger_leaves()
	_test_lines()
	print("PRO_START failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _test_when() -> void:
	var s := ProStart.new_state()
	_check(int(s["conf"]) == 50 and int(s["hunger"]) == 70 and int(s["patience"]) == 3, "a boxer starts at confidence 50, hunger 70, three marks")
	_check(ProStart.not_yet(s) and int(s["patience"]) == 2 and int(s["hunger"]) == 55, "the first Not yet: a mark gone, hunger 55")
	_check(ProStart.can_wait(s), "a second Not yet is still open")
	_check(ProStart.not_yet(s) and int(s["patience"]) == 1 and int(s["hunger"]) == 40, "the second Not yet: one mark left, hunger 40")
	_check(not ProStart.can_wait(s), "the third call is the rival gym's: no Not yet")
	_check(not ProStart.not_yet(s) and int(s["patience"]) == 1 and int(s["hunger"]) == 40, "a refused Not yet changes nothing")


func _test_chance() -> void:
	_check(absf(ProStart.shift(50)) < 0.0001, "confidence 50 moves nothing")
	_check(absf(ProStart.shift(100) - 0.05) < 0.0001 and absf(ProStart.shift(0) + 0.05) < 0.0001, "confidence moves the chance 5 points at most, either way")
	_check(absf(ProStart.shift(66) - 0.016) < 0.0001, "confidence 66 is worth +1.6 points")
	_check(absf(ProStart.shown(0.97, "safe", 50) - 0.90) < 0.0001 and absf(ProStart.shown(0.60, "safe", 50) - 0.75) < 0.0001, "the safe bout is kept inside 75-90%")
	_check(absf(ProStart.shown(0.70, "risky", 50) - 0.55) < 0.0001 and absf(ProStart.shown(0.20, "risky", 50) - 0.40) < 0.0001, "the risky bout is kept inside 40-55%")
	_check(absf(ProStart.shown(0.82, "safe", 100) - 0.87) < 0.0001 and absf(ProStart.shown(0.50, "risky", 0) - 0.45) < 0.0001, "confidence comes on top of the band")
	_check(ProStart.purse(1500, "safe") == 1500 and ProStart.purse(1500, "risky") == 2625, "the risky purse is x1.75 ($1,500 -> $2,625)")
	_check(ProStart.name_gain("safe") == 1 and ProStart.name_gain("risky") == 3, "name +1 safe, +3 risky")


func _test_bars() -> void:
	var s := ProStart.new_state()
	var m := ProStart.after_fight(s, "safe", "win")
	_check(m == {"conf": 4, "hunger": -10, "name": 1}, "a safe win: confidence +4, hunger -10, name +1 (%s)" % str(m))
	m = ProStart.after_fight(s, "risky", "win")
	_check(m == {"conf": 12, "hunger": 10, "name": 3}, "a risky win: confidence +12, hunger +10, name +3 (%s)" % str(m))
	m = ProStart.after_fight(s, "risky", "points")
	_check(m == {"conf": -10, "hunger": 10, "name": 0}, "a risky loss on points: confidence -10, hunger +10 (%s)" % str(m))
	m = ProStart.after_fight(s, "safe", "ko")
	_check(m == {"conf": -30, "hunger": 0, "name": 0}, "a safe loss by stoppage: confidence -30, hunger unmoved (%s)" % str(m))
	_check(int(s["fights"]) == 4 and ProStart.on(s), "four fights in, the two-bout booking still applies")
	for i in 2:
		ProStart.after_fight(s, "safe", "win")
	_check(not ProStart.on(s), "after fight 6 the normal booking takes over")
	var hi := ProStart.new_state()
	for i in 12:
		ProStart.after_fight(hi, "risky", "win")
	_check(int(hi["conf"]) == 100 and int(hi["hunger"]) == 100, "both bars stop at 100")
	var lo := ProStart.new_state()
	for i in 12:
		ProStart.after_fight(lo, "safe", "ko")
	_check(int(lo["conf"]) == 0, "confidence stops at 0")
	var r := ProStart.new_state()
	_check(ProStart.rest(r, 8) == -10 and int(r["hunger"]) == 60, "the rest after a stoppage (8 weeks): hunger -10")
	_check(ProStart.rest(r, 3) == 0, "under four extra weeks costs nothing")


func _test_hunger_leaves() -> void:
	var s := ProStart.new_state()
	_check(ProStart.booking_check(s) == "", "a hungry boxer books without a word")
	s["hunger"] = 0
	_check(ProStart.booking_check(s) == "warn" and int(s["warn"]) == 1, "at 0 hunger: the first warning")
	_check(ProStart.booking_check(s) == "warn" and int(s["warn"]) == 2, "the second warning")
	_check(ProStart.booking_check(s) == "gone", "the third booking at 0: the boxer is gone")
	var all_safe := ProStart.new_state()
	for i in 6:
		ProStart.after_fight(all_safe, "safe", "win")
	_check(int(all_safe["hunger"]) == 10, "six safe wins take hunger 70 -> 10 (%d)" % int(all_safe["hunger"]))


func _test_lines() -> void:
	var s := ProStart.new_state()
	var m := ProStart.after_fight(s, "risky", "win")
	_check(ProStart.bar_line(m, s) == "Confidence 50 → 62, Hunger 70 → 80", "the result line names both bars (%s)" % ProStart.bar_line(m, s))
	_check(ProStart.bar_line({"conf": 0, "hunger": 0}, s) == "", "no line when nothing moved")


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", label)
	else:
		print("ok   ", label)
