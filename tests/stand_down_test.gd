extends SceneTree
## StandDown (STANDDOWN1, TRAINING_MAP_S432 F6 / T32): 8 checks, one per letter a..h.

const SD := preload("res://scripts/rules/StandDown.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_a()
	_test_b()
	_test_c()
	_test_d()
	_test_e()
	_test_f()
	_test_g()
	_test_h()
	print("STAND_DOWN checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	checks += 1
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _near(a: float, b: float) -> bool:
	return absf(a - b) < 0.001


func _same(x: Dictionary, y: Dictionary) -> bool:
	if x.size() != y.size():
		return false
	for k in x:
		if not y.has(k) or x[k] != y[k]:
			return false
	return true


## a. head_place: 25 -> 45, 0 -> 100, 60 -> 0 (clamped).
func _test_a() -> void:
	var ok := true
	if not _near(SD.head_place(25.0), 45.0):
		ok = false
	if not _near(SD.head_place(0.0), 100.0):
		ok = false
	if not _near(SD.head_place(60.0), 0.0):
		ok = false
	_check(ok, "a: head_place 25 -> 45, 0 -> 100, 60 -> 0")


## b. band edges (55 fine, 35 hurt) and by damage.
func _test_b() -> void:
	var ok := true
	if SD.band(55.0) != "fine":
		ok = false
	if SD.band(54.9) != "hurt":
		ok = false
	if SD.band(35.0) != "hurt":
		ok = false
	if SD.band(34.9) != "critical":
		ok = false
	if SD.band(SD.head_place(10.0)) != "fine":
		ok = false
	if SD.band(SD.head_place(25.0)) != "hurt":
		ok = false
	if SD.band(SD.head_place(40.0)) != "critical":
		ok = false
	_check(ok, "b: band 55 fine, 54.9 hurt, 35 hurt, 34.9 critical; damage 10/25/40 fine/hurt/critical")


## c. THE MAP'S TEST: damage 25 on day 100 -> hurt, locked 101..110, open on 111.
func _test_c() -> void:
	var sd: Dictionary = SD.make(100, 25.0, false)
	var ok := true
	if str(sd.get("band", "")) != "hurt":
		ok = false
	if int(sd.get("open_day", -1)) != 111:
		ok = false
	for d in range(101, 111):
		if not SD.locked(sd, d):
			ok = false
	if SD.locked(sd, 111) or SD.locked(sd, 112):
		ok = false
	_check(ok, "c: make(100, 25) hurt, open_day 111, locked 101..110, open 111 and 112")


## d. days by band; a stoppage gives {} and {} never locks.
func _test_d() -> void:
	var ok := true
	var fine: Dictionary = SD.make(100, 10.0, false)
	var crit: Dictionary = SD.make(100, 40.0, false)
	if str(fine.get("band", "")) != "fine" or int(fine.get("open_day", -1)) != 106:
		ok = false
	if str(crit.get("band", "")) != "critical" or int(crit.get("open_day", -1)) != 122:
		ok = false
	var stop: Dictionary = SD.make(100, 25.0, true)
	if not stop.is_empty():
		ok = false
	for dd in [0, 101, 105, 1000]:
		if SD.locked({}, int(dd)):
			ok = false
	_check(ok, "d: fine open bout+6, critical bout+22, stopped {} and {} never locked")


## e. the lock reason.
func _test_e() -> void:
	var ok := true
	var sd: Dictionary = SD.make(100, 25.0, false)
	var r: String = SD.reason(sd, "Thu 5 Mar")
	if r != "no sparring until Thu 5 Mar: the head took 25 damage":
		ok = false
	if SD.reason({}, "x") != "":
		ok = false
	_check(ok, "e: reason \"%s\"; {} gives \"\"" % r)


## f. spar anyway only in the fine and hurt bands.
func _test_f() -> void:
	var ok := true
	if not SD.can_spar_anyway(SD.make(100, 10.0, false)):
		ok = false
	if not SD.can_spar_anyway(SD.make(100, 25.0, false)):
		ok = false
	if SD.can_spar_anyway(SD.make(100, 40.0, false)):
		ok = false
	if SD.can_spar_anyway({}):
		ok = false
	_check(ok, "f: can_spar_anyway fine true, hurt true, critical false, {} false")


## g. head_days from InjuryRoll; the spar-anyway roll over seeds 0..9999.
func _test_g() -> void:
	var ok := true
	var hd: Array = SD.head_days()
	if hd.size() != 2 or int(hd[0]) != 21 or int(hd[1]) != 35:
		ok = false
	var sd_fine: Dictionary = SD.make(100, 10.0, false)
	var sd_hurt: Dictionary = SD.make(100, 25.0, false)
	var sd_crit: Dictionary = SD.make(100, 40.0, false)
	var n_fine: int = 0
	var n_hurt: int = 0
	var n_crit: int = 0
	for s in range(10000):
		var rf: Dictionary = SD.spar_anyway_roll(s, sd_fine)
		var rh: Dictionary = SD.spar_anyway_roll(s, sd_hurt)
		var rc: Dictionary = SD.spar_anyway_roll(s, sd_crit)
		for r in [rf, rh, rc]:   # S434 collect: the critical roll's shape is checked too
			if bool(r["knocked"]):
				if str(r["type"]) != "head" or int(r["days_out"]) < 21 or int(r["days_out"]) > 35:
					ok = false
			elif str(r["type"]) != "none" or int(r["days_out"]) != 0:
				ok = false
		if bool(rf["knocked"]):
			n_fine += 1
		if bool(rh["knocked"]):
			n_hurt += 1
		if bool(rc["knocked"]):
			n_crit += 1
	if n_hurt < 450 or n_hurt > 750:
		ok = false
	if n_fine < 100 or n_fine > 300:
		ok = false
	if n_crit != 0:
		ok = false
	for seed_twice in [0, 7, 123, 4242, 9999]:
		if not _same(SD.spar_anyway_roll(int(seed_twice), sd_hurt), SD.spar_anyway_roll(int(seed_twice), sd_hurt)):
			ok = false
		if not _same(SD.spar_anyway_roll(int(seed_twice), sd_fine), SD.spar_anyway_roll(int(seed_twice), sd_fine)):
			ok = false
	_check(ok, "g: head_days %s; knocks over 10000 seeds fine=%d hurt=%d critical=%d; deterministic" % [str(hd), n_fine, n_hurt, n_crit])


## h. the price line for the button.
func _test_h() -> void:
	var ok := true
	var p: String = SD.price_line(SD.make(100, 25.0, false))
	if p != "Spar anyway: 6 in 100 of a head knock, out 21 to 35 days, bouts closed":
		ok = false
	if SD.price_line(SD.make(100, 40.0, false)) != "":
		ok = false
	_check(ok, "h: price_line hurt \"%s\"; critical \"\"" % p)
