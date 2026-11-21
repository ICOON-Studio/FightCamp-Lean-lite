extends SceneTree
## ProCall: TURNPRO1A tests.
const PC := preload("res://scripts/rules/ProCall.gd")
const PD := preload("res://scripts/rules/ProDebut.gd")
var failures := 0

func _initialize() -> void:
	_test_promoters()
	_test_who_calls()
	_test_terms()
	_test_debut_purse()
	_test_money_case_a()
	_test_money_case_b()
	_test_money_case_c()
	_test_money_own_price()
	_test_pays_back_line()
	_test_ask_later()
	_test_ask_softer()
	_test_ask_split()
	_test_ask_price()
	_test_ask_costs()
	_test_apply_ask()
	_test_morale()
	_test_ambition_kind()
	_test_age_line()
	_test_calls_open()
	_test_expires()
	_test_no_pronouns()
	print("PRO_CALL failures=%d" % failures)
	quit(1 if failures > 0 else 0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS %s" % label)
	else:
		failures += 1
		print("FAIL %s" % label)

func _test_promoters() -> void:
	var p: Dictionary = PC.promoters()
	var bow: Dictionary = p["bow"]
	var hf: Dictionary = p["hf"]
	var ok := str(bow["name"]) == "Bow Lane Promotions" and str(hf["name"]) == "Harrow & Finch Boxing"
	ok = ok and int(bow["purse"]) == 1500 and int(hf["purse"]) == 1800
	ok = ok and int(bow["break_even"]) == PD.BREAK_EVEN and int(hf["break_even"]) == 70
	ok = ok and float(bow["share"]) == PD.HER_SHARE and float(hf["share"]) == 0.3
	ok = ok and bool(hf["guaranteed"]) and not bool(bow["guaranteed"])
	ok = ok and int(bow["debut_weeks"]) == 4 and int(hf["debut_weeks"]) == 6
	ok = ok and float(bow["opp_gap"]) == 3.0 and float(hf["opp_gap"]) == 6.0   # TURNPRO6: set from played bouts (docs/TURNPRO6_RESULT.md)
	_check(ok, "promoters structure and values")

func _test_who_calls() -> void:
	var a: Array = PC.who_calls(75)
	var b: Array = PC.who_calls(60)
	var c: Array = PC.who_calls(45)
	var ok: bool = a.size() == 1 and str(a[0]) == "bow"
	ok = ok and b.size() == 2 and str(b[0]) == "bow" and str(b[1]) == "hf"
	ok = ok and c.size() == 1 and str(c[0]) == "hf"
	_check(ok, "who_calls 75=[bow] 60=[bow,hf] 45=[hf]")

func _test_terms() -> void:
	var t0: Dictionary = PC.terms("bow", 0, false)
	var t1: Dictionary = PC.terms("bow", 1, false)
	var tt: Dictionary = PC.terms("bow", 1, true)
	var ok := int(t0["purse"]) == 1500 and float(t0["factor"]) == 1.0
	ok = ok and int(t0["break_even"]) == PD.BREAK_EVEN
	ok = ok and int(t1["purse"]) == 1350 and float(t1["factor"]) == 0.9
	ok = ok and int(tt["purse"]) == 1500 and float(tt["factor"]) == 1.0
	_check(ok, "terms basic/decline/title-reset")

func _test_debut_purse() -> void:
	var tb: Dictionary = PC.terms("bow", 0, false)
	var th: Dictionary = PC.terms("hf", 0, false)
	var ok: bool = PC.debut_purse(tb, 69) == 1500
	ok = ok and PC.debut_purse(tb, 60) == 1500
	ok = ok and PC.debut_purse(tb, 55) == 1375  # 1500 - 25*5
	ok = ok and PC.debut_purse(tb, 20) == 500   # floor
	ok = ok and PC.debut_purse(tb, 0) == 500    # floor
	ok = ok and PC.debut_purse(th, 54) == 1800  # guaranteed
	ok = ok and PC.debut_purse(th, 0) == 1800   # guaranteed
	_check(ok, "debut_purse bow/hf/floor")

## Case A: Bow Lane, stipend paid, costs 1245, sold=69.
## gym_at_signing = round(1500*0.25) + round(225*0.25) - 1245 = 375 + 56 - 1245 = -814
## weekly_after = 250 - 75 = 175, even_week = 5, boxer = 1294
func _test_money_case_a() -> void:
	var t: Dictionary = PC.terms("bow", 0, false)
	var m: Dictionary = PC.money(t, 69, 1245, 0.25, true)
	var ok := int(m["purse"]) == 1500 and int(m["ticket_share"]) == 225
	ok = ok and int(m["gym_at_signing"]) == -814 and int(m["weekly_after"]) == 175
	ok = ok and int(m["even_week"]) == 5 and int(m["boxer"]) == 1294
	_check(ok, "case A bow stipend: gym=-814 weekly=175 even=5 boxer=1294")

## S529 (Arena + Goose on TURNPRO1 v3): the "own ticket price" ask stores price 40 - the ticket share is earned at it.
## 9 over break-even x $40 x 50% = 180 (at the old fixed $50 it read 225).
func _test_money_own_price() -> void:
	var t: Dictionary = PC.terms("bow", 0, false)
	t["price"] = 40
	var m: Dictionary = PC.money(t, 69, 1245, 0.25, true)
	_check(int(m["ticket_share"]) == 180, "own price $40: ticket share 180 (got %d)" % int(m["ticket_share"]))

## Case B: Bow Lane, no stipend, costs 1245, sold=69.
## weekly_after = -75, even_week = -1
func _test_money_case_b() -> void:
	var t: Dictionary = PC.terms("bow", 0, false)
	var m: Dictionary = PC.money(t, 69, 1245, 0.25, false)
	var ok := int(m["weekly_after"]) == -75 and int(m["even_week"]) == -1
	var line: String = PC.pays_back_line(m)
	ok = ok and line == "The gym gets its money back once your boxer is ranked."
	_check(ok, "case B bow no stipend: weekly=-75 even=-1 line ok")

## Case C: HF at 54 tickets, stipend paid, costs 1245.
## gym_at_signing = 450 - 1245 = -795, by_debut = -795 + 175*6 = 255, boxer = 1350
func _test_money_case_c() -> void:
	var t: Dictionary = PC.terms("hf", 0, false)
	var m: Dictionary = PC.money(t, 54, 1245, 0.25, true)
	var ok := int(m["purse"]) == 1800 and int(m["gym_at_signing"]) == -795
	ok = ok and int(m["by_debut"]) == 255 and int(m["boxer"]) == 1350
	_check(ok, "case C hf 54 tickets: gym=-795 by_debut=255 boxer=1350")

func _test_pays_back_line() -> void:
	var line: String = PC.pays_back_line({"even_week": 5})
	_check(line == "The gym is about even 5 weeks after signing.", "pays_back_line even_week=5")

func _test_ask_later() -> void:
	var t: Dictionary = PC.terms("bow", 0, false)
	var aa: Array = PC.ask_answers(t, 69, 10)
	var ok2 := false
	var ok4 := false
	for entry in aa:
		var e: Dictionary = entry
		if str(e["kind"]) == "later2":
			ok2 = str(e["answer"]) == "take" and int(e["after"]["debut_weeks"]) == 6 and int(e["after"]["purse"]) == 1350
		if str(e["kind"]) == "later4":
			ok4 = str(e["answer"]) == "take" and int(e["after"]["debut_weeks"]) == 8 and int(e["after"]["purse"]) == 1200
	_check(ok2 and ok4, "ask_answers later2/later4 always take")

func _test_ask_softer() -> void:
	var t: Dictionary = PC.terms("bow", 0, false)
	var aa: Array = PC.ask_answers(t, 69, 10)
	var ok := false
	for entry in aa:
		var e: Dictionary = entry
		if str(e["kind"]) == "softer":
			ok = str(e["answer"]) == "take" and is_equal_approx(float(e["after"]["opp_gap"]), 3.5) and int(e["after"].get("tune_ups", 0)) == 2
	_check(ok, "ask_answers softer always take")

## Split at band edges (bow break_even=60): 80 (20 over)=take, 65 (5 over)=counter, 64 (4 over)=wont.
func _test_ask_split() -> void:
	var t: Dictionary = PC.terms("bow", 0, false)
	var ok := true
	var aa80: Array = PC.ask_answers(t, 80, 10)
	var found80 := false
	for entry in aa80:
		var e: Dictionary = entry
		if str(e["kind"]) == "split":
			found80 = true
			ok = ok and str(e["answer"]) == "take"
			ok = ok and is_equal_approx(float(e["after"]["share"]), 0.6)
			ok = ok and is_equal_approx(float(e["after"]["opp_gap"]), 2.5)
	var aa65: Array = PC.ask_answers(t, 65, 10)
	var found65 := false
	for entry in aa65:
		var e: Dictionary = entry
		if str(e["kind"]) == "split":
			found65 = true
			ok = ok and str(e["answer"]) == "counter"
			ok = ok and is_equal_approx(float(e["after"]["share"]), 0.55)
	var aa64: Array = PC.ask_answers(t, 64, 10)
	var found64 := false
	for entry in aa64:
		var e: Dictionary = entry
		if str(e["kind"]) == "split":
			found64 = true
			ok = ok and str(e["answer"]) == "wont"
	ok = ok and found80 and found65 and found64
	_check(ok, "ask_answers split 80=take 65=counter 64=wont")

func _test_ask_price() -> void:
	var tbow: Dictionary = PC.terms("bow", 0, false)
	var thf: Dictionary = PC.terms("hf", 0, false)
	var ok := true
	var found_bow := false
	for entry in PC.ask_answers(tbow, 69, 10):
		var e: Dictionary = entry
		if str(e["kind"]) == "price":
			found_bow = true
			ok = ok and str(e["answer"]) == "take" and int(e["after"].get("price", 0)) == 40 and int(e["after"].get("extra_tickets", 0)) == 15
	var found_hf := false
	for entry in PC.ask_answers(thf, 69, 10):
		var e: Dictionary = entry
		if str(e["kind"]) == "price":
			found_hf = true
			ok = ok and str(e["answer"]) == "wont" and str(e["words"]).length() > 5
	_check(ok and found_bow and found_hf, "ask_answers price bow=take hf=wont")

func _test_ask_costs() -> void:
	var thf: Dictionary = PC.terms("hf", 0, false)
	var tbow: Dictionary = PC.terms("bow", 0, false)
	var ok := true
	# hf runway >= 8: +100
	var found1 := false
	for entry in PC.ask_answers(thf, 69, 10):
		var e: Dictionary = entry
		if str(e["kind"]) == "costs":
			found1 = true
			ok = ok and str(e["answer"]) == "counter" and int(e["after"].get("costs_from_purse", 0)) == 100
	# hf runway < 8: +200
	var found2 := false
	for entry in PC.ask_answers(thf, 69, 5):
		var e: Dictionary = entry
		if str(e["kind"]) == "costs":
			found2 = true
			ok = ok and int(e["after"].get("costs_from_purse", 0)) == 200
	# bow -> wont
	var found3 := false
	for entry in PC.ask_answers(tbow, 69, 10):
		var e: Dictionary = entry
		if str(e["kind"]) == "costs":
			found3 = true
			ok = ok and str(e["answer"]) == "wont" and str(e["words"]).length() > 5
	_check(ok and found1 and found2 and found3, "ask_answers costs hf=counter(100/200) bow=wont")

func _test_apply_ask() -> void:
	var t: Dictionary = PC.terms("bow", 0, false)
	# wont -> unchanged
	var wont_entry: Dictionary = {"kind": "split", "answer": "wont", "after": t.duplicate()}
	var r1: Dictionary = PC.apply_ask(t, wont_entry, true)
	var ok := int(r1["purse"]) == int(t["purse"])
	# take -> applies
	var found := false
	for entry in PC.ask_answers(t, 69, 10):
		var e: Dictionary = entry
		if str(e["kind"]) == "later2":
			found = true
			var r2: Dictionary = PC.apply_ask(t, e, true)
			ok = ok and int(r2["debut_weeks"]) == 6 and int(r2["purse"]) == 1350
	# counter without take_counter -> unchanged
	var counter_entry: Dictionary = {"kind": "costs", "answer": "counter", "after": t.duplicate()}
	counter_entry["after"]["costs_covered"] = true
	var r3: Dictionary = PC.apply_ask(t, counter_entry, false)
	ok = ok and not r3.has("costs_covered")
	_check(ok and found, "apply_ask wont/take/counter")

func _test_morale() -> void:
	var ok := true
	ok = ok and PC.morale("I want to turn pro", false, false) == 5
	ok = ok and PC.morale("I want to turn pro", true, false) == -5
	ok = ok and PC.morale("A regional title within a year", false, true) == -5
	ok = ok and PC.morale("A regional title within a year", false, false) == 0
	ok = ok and PC.morale("A regional title within a year", true, false) == 0
	ok = ok and PC.morale("A winning record by the summer", false, false) == 0
	ok = ok and PC.morale("A winning record by the summer", true, false) == 0
	_check(ok, "morale all rows")

func _test_ambition_kind() -> void:
	var ok := PC.ambition_kind("A regional title within a year") == "title"
	ok = ok and PC.ambition_kind("I want to turn pro") == "pro"
	ok = ok and PC.ambition_kind("A winning record by the summer") == "other"
	ok = ok and PC.ambition_kind("A first win in front of a home crowd") == "other"
	_check(ok, "ambition_kind title/pro/other")

func _test_age_line() -> void:
	var ok := PC.age_line(28) == ""
	ok = ok and PC.age_line(29) == "Age 29: first calls stop at 32."
	ok = ok and PC.age_line(32) == "First calls have stopped at 32."
	_check(ok, "age_line 28/29/32")

func _test_calls_open() -> void:
	var ok := PC.calls_open(28) and PC.calls_open(31) and not PC.calls_open(32) and not PC.calls_open(35)
	_check(ok, "calls_open 28/31=true 32/35=false")

func _test_expires() -> void:
	_check(PC.expires(100) == 114 and PC.expires(0) == 14, "expires 100->114 0->14")

func _test_no_pronouns() -> void:
	var lines: Array = []
	lines.append(PC.pays_back_line({"even_week": 5}))
	lines.append(PC.pays_back_line({"even_week": -1}))
	lines.append(PC.age_line(29))
	lines.append(PC.age_line(32))
	for entry in PC.ask_answers(PC.terms("bow", 0, false), 69, 10):
		lines.append(str((entry as Dictionary)["words"]))
	for entry in PC.ask_answers(PC.terms("hf", 0, false), 69, 10):
		lines.append(str((entry as Dictionary)["words"]))
	var ok := true
	for line in lines:
		var lower: String = str(line).to_lower()
		if lower.contains(" he ") or lower.contains(" she ") or lower.contains(" her ") or lower.contains(" him "):
			ok = false
			print("  PRONOUN in: %s" % lower)
	_check(ok, "no pronouns in any returned line")
