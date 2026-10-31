extends SceneTree
## ProDebut: 11 tests.

const PD := preload("res://scripts/rules/ProDebut.gd")

var failures := 0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	_test7()
	_test8()
	_test9()
	_test10()
	_test11()
	print("PRO_DEBUT failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _same_dict(a: Dictionary, b: Dictionary) -> bool:
	if a.size() != b.size():
		return false
	for k in a:
		if not b.has(k):
			return false
		if a[k] is Dictionary and b[k] is Dictionary:
			if not _same_dict(a[k], b[k]):
				return false
		elif a[k] != b[k]:
			return false
	return true


## 1. start_costs(true, false) == 1245.
func _test1() -> void:
	var got: int = PD.start_costs(true, false)
	_check(got == 1245, "test 1: start_costs(true,false)==1245 (got %d)" % got)


## 2. Other start_costs cases.
func _test2() -> void:
	var ok := true
	var a: int = PD.start_costs(true, true)
	var b: int = PD.start_costs(false, true)
	var c: int = PD.start_costs(false, false)
	if a != 1105:
		ok = false
	if b != 230:
		ok = false
	if c != 370:
		ok = false
	_check(ok, "test 2: start_costs (true,true)=%d (false,true)=%d (false,false)=%d" % [a, b, c])


## 3. tickets_sold cases.
func _test3() -> void:
	var ok := true
	var a: int = PD.tickets_sold(40, 7, 0)
	var b: int = PD.tickets_sold(41, 7, 0)
	var c: int = PD.tickets_sold(40, 7, 1)
	var d: int = PD.tickets_sold(0, 0, 0)
	var e: int = PD.tickets_sold(200, 20, 5)
	var f: int = PD.tickets_sold(-5, -1, -1)
	if a != 54:
		ok = false
	if b != 54:
		ok = false
	if c != 64:
		ok = false
	if d != 20:
		ok = false
	if e != 100:
		ok = false
	if f != 20:
		ok = false
	_check(ok, "test 3: tickets_sold 40,7,0=%d 41,7,0=%d 40,7,1=%d 0,0,0=%d 200,20,5=%d -5,-1,-1=%d" % [a, b, c, d, e, f])


## 4. night(60, 1.0): at break-even.
func _test4() -> void:
	var n: Dictionary = PD.night(60, 1.0)
	var ok := true
	if n["above"] != 0:
		ok = false
	if n["share"] != 0:
		ok = false
	if n["gym"] != 0:
		ok = false
	if n["her"] != 0:
		ok = false
	if n["money"] != 3000:
		ok = false
	_check(ok, "test 4: night(60,1.0) above=%d share=%d gym=%d her=%d money=%d" % [n["above"], n["share"], n["gym"], n["her"], n["money"]])


## 5. night(100, 1.0): full house.
func _test5() -> void:
	var n: Dictionary = PD.night(100, 1.0)
	var ok := true
	if n["above"] != 40:
		ok = false
	if n["money"] != 5000:
		ok = false
	if n["share"] != 1000:
		ok = false
	if n["gym"] != 250:
		ok = false
	if n["her"] != 750:
		ok = false
	_check(ok, "test 5: night(100,1.0) above=%d money=%d share=%d gym=%d her=%d" % [n["above"], n["money"], n["share"], n["gym"], n["her"]])


## 6. night(70, ...) rounding.
func _test6() -> void:
	var n1: Dictionary = PD.night(70, 1.0)
	var n2: Dictionary = PD.night(70, 0.9)
	var ok := true
	if n1["above"] != 10:
		ok = false
	if n1["share"] != 250:
		ok = false
	if n1["gym"] != 63:
		ok = false
	if n1["her"] != 187:
		ok = false
	if n2["share"] != 225:
		ok = false
	if n2["gym"] != 56:
		ok = false
	if n2["her"] != 169:
		ok = false
	_check(ok, "test 6: night(70,1.0) share=%d gym=%d her=%d; night(70,0.9) share=%d gym=%d her=%d" % [n1["share"], n1["gym"], n1["her"], n2["share"], n2["gym"], n2["her"]])


## 7. night edge cases: below break-even, over clamp, negative.
func _test7() -> void:
	var n1: Dictionary = PD.night(30, 1.0)
	var n2: Dictionary = PD.night(150, 1.0)
	var n3: Dictionary = PD.night(-3, 1.0)
	var ok := true
	if n1["share"] != 0:
		ok = false
	if n1["her"] != 0:
		ok = false
	if n2["sold"] != 100:
		ok = false
	if n3["sold"] != 0:
		ok = false
	_check(ok, "test 7: night(30) share=%d her=%d; night(150) sold=%d; night(-3) sold=%d" % [n1["share"], n1["her"], n2["sold"], n3["sold"]])


## 8. Monotonicity and consistency for every sold 0..100, terms in [1.0, 0.9].
func _test8() -> void:
	var ok := true
	for terms in [1.0, 0.9]:
		var prev_share: int = -1
		for sold in range(0, 101):
			var n: Dictionary = PD.night(sold, terms)
			if n["her"] < 0:
				ok = false
			if n["gym"] < 0:
				ok = false
			if n["gym"] + n["her"] != n["share"]:
				ok = false
			if n["share"] < prev_share:
				ok = false
			prev_share = n["share"]
	_check(ok, "test 8: monotonicity and consistency sold 0..100")


## 9. sheet(40, 7, 1, true, false, 1.0).
func _test9() -> void:
	var s: Dictionary = PD.sheet(40, 7, 1, true, false, 1.0)
	var ok := true
	if s["costs"] != 1245:
		ok = false
	if s["sold"] != 64:
		ok = false
	if s["night"]["share"] != 100:
		ok = false
	if s["night"]["gym"] != 25:
		ok = false
	if s["gym_net"] != -1220:
		ok = false
	_check(ok, "test 9: sheet costs=%d sold=%d night.share=%d night.gym=%d gym_net=%d" % [s["costs"], s["sold"], s["night"]["share"], s["night"]["gym"], s["gym_net"]])


## 10. sheet(120, 9, 2, false, true, 1.0).
func _test10() -> void:
	var s: Dictionary = PD.sheet(120, 9, 2, false, true, 1.0)
	var ok := true
	if s["sold"] != 100:
		ok = false
	if s["costs"] != 230:
		ok = false
	if s["gym_net"] != 20:
		ok = false
	_check(ok, "test 10: sheet sold=%d costs=%d gym_net=%d" % [s["sold"], s["costs"], s["gym_net"]])


## 11. Dictionary key checks.
func _test11() -> void:
	var ok := true
	var n: Dictionary = PD.night(50, 1.0)
	var night_keys: Array = ["sold", "money", "above", "share", "gym", "her"]
	if n.size() != night_keys.size():
		ok = false
	for k in night_keys:
		if not n.has(k):
			ok = false
	var s: Dictionary = PD.sheet(40, 7, 1, true, false, 1.0)
	var sheet_keys: Array = ["costs", "sold", "night", "gym_net"]
	if s.size() != sheet_keys.size():
		ok = false
	for k in sheet_keys:
		if not s.has(k):
			ok = false
	_check(ok, "test 11: dictionary keys exact")
