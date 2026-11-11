extends SceneTree
## CEIL14: a ceiling for each of the 14 abilities, shaped by class bias and archetype tilt.
## Pure read; never writes to the fighter dict.

const R := preload("res://scripts/rules/Recruit.gd")
const A := preload("res://scripts/rules/Attrs.gd")

var _fails := 0
var _checks := 0   # S434 collect: the count is counted, never typed


func _c(f: Dictionary, ability: String) -> float:
	var inst = R.new()
	var found := false
	for m in inst.get_method_list():
		if str(m["name"]) == "ceiling_of":
			found = true
			break
	if not found:
		return -1.0
	return float(inst.call("ceiling_of", f, ability))


func _check(ok: bool, what: String) -> void:
	_checks += 1
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])


func _initialize() -> void:
	var ola := {"style": "Out-boxer", "pot": 68,
		"attrs": {"strength": 60.0, "explosiveness": 55.0, "speed": 55.0, "stamina": 55.0,
		"recovery": 55.0, "flexibility": 55.0, "durability": 55.0, "fight_iq": 55.0,
		"composure": 55.0, "accuracy": 55.0, "timing": 55.0, "defence": 55.0,
		"footwork": 55.0, "inside": 55.0}}
	var rocco := {"style": "Slugger", "pot": 82,
		"attrs": {"strength": 58.0, "explosiveness": 64.0, "speed": 58.0, "stamina": 58.0,
		"recovery": 58.0, "flexibility": 58.0, "durability": 58.0, "fight_iq": 58.0,
		"composure": 58.0, "accuracy": 58.0, "timing": 58.0, "defence": 58.0,
		"footwork": 58.0, "inside": 58.0}}
	var nonsense := {"style": "nonsense", "pot": 70,
		"attrs": {"strength": 55.0, "explosiveness": 55.0, "speed": 55.0, "stamina": 55.0,
		"recovery": 55.0, "flexibility": 55.0, "durability": 55.0, "fight_iq": 55.0,
		"composure": 55.0, "accuracy": 55.0, "timing": 55.0, "defence": 55.0,
		"footwork": 55.0, "inside": 55.0}}
	var ola_no := {"style": "Out-boxer", "pot": 68,
		"stats": {"power": 55.0, "speed": 55.0, "technique": 55.0, "defense": 55.0,
		"conditioning": 55.0, "fight_iq": 55.0, "chin": 55.0}}
	# S434 collect: the population and every ceiling of Ola and Rocco, as the brief asks.
	for who in [["Ola", ola], ["Rocco", rocco], ["nonsense", nonsense]]:
		var fd: Dictionary = who[1]
		print("POP %s style=%s pot=%d" % [who[0], str(fd["style"]), int(fd["pot"])])
	for who in [["Ola", ola], ["Rocco", rocco]]:
		for ab_name in A.ABILITIES:
			print("CEIL %s %s %.2f" % [who[0], ab_name, _c(who[1], ab_name)])
	var exp_a := {"footwork": 72.19, "speed": 76.00, "defence": 70.19, "timing": 68.69,
		"inside": 63.19, "explosiveness": 60.00, "strength": 62.00, "stamina": 67.19,
		"recovery": 67.19, "flexibility": 67.19, "durability": 67.19, "fight_iq": 67.19,
		"composure": 67.19, "accuracy": 67.19}
	var ok_a := true
	for ab in exp_a:
		if absf(_c(ola, ab) - float(exp_a[ab])) > 0.01:
			ok_a = false
	_check(ok_a, "(a) Ola 14 ceilings")
	var ok_b := absf(_c(ola, "footwork") - 72.19) <= 0.01 and absf(_c(ola, "inside") - 63.19) <= 0.01 and absf(_c(ola, "flexibility") - 67.19) <= 0.01
	_check(ok_b, "(b) footwork/inside/flexibility each get a ceiling")
	_check(_c(ola, "footwork") > _c(ola, "inside"), "(c) out-boxer footwork ceiling > inside ceiling")
	var ok_d := absf(_c(rocco, "explosiveness") - 90.00) <= 0.01 and _c(rocco, "explosiveness") > _c(rocco, "speed") and absf(_c(rocco, "speed") - 78.37) <= 0.01 and absf(_c(rocco, "accuracy") - 74.00) <= 0.01 and absf(_c(rocco, "durability") - 85.87) <= 0.01 and absf(_c(rocco, "footwork") - 77.87) <= 0.01
	_check(ok_d, "(d) Rocco ceilings")
	var ok_e := true
	for f in [ola, rocco]:
		var pot_v: float = float(f.get("pot", 70))
		for ab in A.ABILITIES:
			var cv := _c(f, ab)
			var now_v: float = float((f.get("attrs", {}) as Dictionary).get(ab, 55.0))
			var in_band := (cv >= pot_v - 8.0 - 0.01 and cv <= pot_v + 8.0 + 0.01) or absf(cv - (now_v + 2.0)) <= 0.01
			if not in_band or cv < now_v + 2.0 - 0.01 or cv > 99.01:
				ok_e = false
	_check(ok_e, "(e) every ceiling in [pot-8, pot+8] or now+2, >= now+2, <= 99")
	var ok_f := absf(_c(nonsense, "accuracy") - 76.00) <= 0.01 and absf(_c(nonsense, "timing") - 76.00) <= 0.01 and absf(_c(nonsense, "durability") - 64.00) <= 0.01 and absf(_c(nonsense, "footwork") - 70.00) <= 0.01
	_check(ok_f, "(f) unknown style = Boxer-puncher, no tilt")
	var ok_g := absf(_c(ola_no, "footwork") - 72.19) <= 0.01 and not ola_no.has("attrs")
	_check(ok_g, "(g) no-attrs Ola reads stats, does not write attrs")
	print("CEILING_SHAPE checks=%d failures=%d" % [_checks, _fails])
	quit(1 if _fails > 0 else 0)
