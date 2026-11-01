extends SceneTree
## BodyFigure: 5 tests.
## 1. Bands: value -> band colour; missing place = fine.
## 2. Flash: hit -> near WHITE; after FLASH_S -> band colour again.
## 3. Tips: last 3 punches, newest first.
## 4. Geometry: front-view mirror; place_at(centre) == place; (2,2) == "".
## 5. Scale: centres double at 2x size (within 1 px).
## 6. Portrait (S320 C146): every fight body has a baked picture in both corners; on it each place is found at its own
##    centre, the boxer's left eye/ribs sit on the viewer's right, the eyes above the nose above the ribs, all inside it.
## 7. Hurt spots (S332 C151 'wtf is that' on a ring over her face): a fine face is her own skin; a hurt face reddens; a hit
##    on a fine nose warms the face for FLASH_S, then clears; a hurt rib side reddens only that side.

const BF_SCRIPT := preload("res://scripts/ui/BodyFigure.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

var failures := 0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	_test7()
	print("BODY_FIGURE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _make_bf() -> Control:
	var bf: Control = BF_SCRIPT.new()
	get_root().add_child(bf)
	return bf


## 1. Bands.
func _test1() -> void:
	var ok := true
	var bf := _make_bf()
	bf.set_values({"nose": 56.0})
	if bf.colour_of("nose") != BF_SCRIPT.BAND_COLOURS["fine"]:
		ok = false
	bf.set_values({"nose": 55.0})
	if bf.colour_of("nose") != BF_SCRIPT.BAND_COLOURS["hurt"]:
		ok = false
	bf.set_values({"nose": 35.0})
	if bf.colour_of("nose") != BF_SCRIPT.BAND_COLOURS["critical"]:
		ok = false
	bf.set_values({"nose": 15.0})
	if bf.colour_of("nose") != BF_SCRIPT.BAND_COLOURS["doctor"]:
		ok = false
	# Missing place -> fine.
	if bf.colour_of("head") != BF_SCRIPT.BAND_COLOURS["fine"]:
		ok = false
	bf.queue_free()
	_check(ok, "test 1: bands")


## 2. Flash.
func _test2() -> void:
	var ok := true
	var bf := _make_bf()
	bf.hit("left_eye", "jab")
	var c: Color = bf.colour_of("left_eye")
	if c.r < 0.9 or c.g < 0.9 or c.b < 0.9:
		ok = false
	# Simulate past FLASH_S (0.35 s).
	var remaining: float = BF_SCRIPT.FLASH_S + 0.01
	while remaining > 0.0:
		var dt: float = minf(remaining, 0.05)
		bf._process(dt)
		remaining -= dt
	var band_c: Color = BF_SCRIPT.BAND_COLOURS["fine"]
	var after: Color = bf.colour_of("left_eye")
	if absf(after.r - band_c.r) > 0.01 or absf(after.g - band_c.g) > 0.01 or absf(after.b - band_c.b) > 0.01:
		ok = false
	bf.queue_free()
	_check(ok, "test 2: flash")


## 3. Tips: three hits then a fourth -> newest three, newest first.
func _test3() -> void:
	var ok := true
	var bf := _make_bf()
	bf.hit("nose", "jab")
	bf.hit("nose", "cross")
	bf.hit("nose", "lead_hook")
	bf.hit("nose", "jab")
	var tip: String = bf.tip_of("nose")
	var expected := "Nose 100 (fine) - jab, lead_hook, cross"
	if tip != expected:
		ok = false
		print("  got: '%s' expected: '%s'" % [tip, expected])
	bf.queue_free()
	_check(ok, "test 3: tips")


## 4. Geometry: front view.
func _test4() -> void:
	var ok := true
	var bf := _make_bf()
	bf.size = Vector2(90, 150)
	# Centre of each place -> that place.
	for p in ["head", "left_eye", "right_eye", "nose", "left_ribs", "right_ribs"]:
		var c: Vector2 = bf.centre_of(p)
		var hit: String = bf.place_at(c)
		if hit != p:
			ok = false
			print("  place_at(centre_of(%s)=%s) -> '%s'" % [p, str(c), hit])
	# Front view: boxer's left on viewer's right.
	if bf.centre_of("left_eye").x <= bf.centre_of("right_eye").x:
		ok = false
	if bf.centre_of("left_ribs").x <= bf.centre_of("right_ribs").x:
		ok = false
	# (2, 2) -> "".
	if bf.place_at(Vector2(2, 2)) != "":
		ok = false
	bf.queue_free()
	_check(ok, "test 4: geometry front view")


## 5. Scale: at 180 x 300 centres are 2x the 90 x 150 centres (within 1 px).
func _test5() -> void:
	var ok := true
	var bf1 := _make_bf()
	bf1.size = Vector2(90, 150)
	var bf2: Control = BF_SCRIPT.new()
	get_root().add_child(bf2)
	bf2.size = Vector2(180, 300)
	for p in ["head", "left_eye", "right_eye", "nose", "left_ribs", "right_ribs"]:
		var c1: Vector2 = bf1.centre_of(p)
		var c2: Vector2 = bf2.centre_of(p)
		var expected: Vector2 = c1 * 2.0
		if absf(c2.x - expected.x) > 1.0 or absf(c2.y - expected.y) > 1.0:
			ok = false
			print("  %s: %s vs expected %s" % [p, str(c2), str(expected)])
	bf1.queue_free()
	bf2.queue_free()
	_check(ok, "test 5: scale 2x")


func _test6() -> void:
	var ok := true
	for stem in Faces.CM.keys():
		for corner in ["red", "blue"]:
			var p: Dictionary = BF_SCRIPT.portrait_for("res://assets/models/metahuman/%s.glb" % stem, corner)
			if p.is_empty() or p["tex"] == null:
				ok = false
				print("  no portrait %s %s" % [stem, corner])
				continue
			var bf := _make_bf()
			bf.size = Vector2(150, 210)
			bf.set_portrait(p)
			for place in ["head", "left_eye", "right_eye", "nose", "left_ribs", "right_ribs"]:
				var c: Vector2 = bf.centre_of(place)
				if bf.place_at(c) != place or not Rect2(Vector2.ZERO, bf.size).has_point(c):
					ok = false
					print("  %s %s: %s at %s" % [stem, place, bf.place_at(c), str(c)])
			var le: Vector2 = bf.centre_of("left_eye")
			var re: Vector2 = bf.centre_of("right_eye")
			if le.x <= re.x or bf.centre_of("left_ribs").x <= bf.centre_of("right_ribs").x:
				ok = false
				print("  %s: left side not on the viewer's right" % stem)
			if not (le.y < bf.centre_of("nose").y and bf.centre_of("nose").y < bf.centre_of("left_ribs").y):
				ok = false
				print("  %s: eyes/nose/ribs out of order" % stem)
			bf.queue_free()
	if not BF_SCRIPT.portrait_for("", "red").is_empty():
		ok = false
	_check(ok, "test 6: portraits")


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 7. Hurt spots on her own skin.
func _test7() -> void:
	var face: Array = BF_SCRIPT.SPOTS[0]
	var bf := _make_bf()
	bf.set_values({})
	var clear: bool = bf.spot_colour(face).a == 0.0
	bf.set_values({"left_eye": 40.0})
	var hurt: Color = bf.spot_colour(face)
	bf.set_values({})
	bf.hit("nose", "jab")
	var hit: Color = bf.spot_colour(face)
	bf._process(BF_SCRIPT.FLASH_S + 0.01)
	var after: bool = bf.spot_colour(face).a == 0.0
	bf.set_values({"left_ribs": 40.0})
	var sides: bool = bf.spot_colour(BF_SCRIPT.SPOTS[1]).a > 0.0 and bf.spot_colour(BF_SCRIPT.SPOTS[2]).a == 0.0
	bf.queue_free()
	_check(clear and hurt.a > 0.0 and hit.a > 0.0 and hit.r > hit.g and after and sides,
		"test 7: hurt spots (clear %s, hurt a=%.2f, hit %s, cleared %s, one rib side %s)" % [clear, hurt.a, str(hit), after, sides])