extends SceneTree
## S392 the HUD answers a hit: the arc's chunk, a flash as big as the damage, the liver lit for as long as it matters.

const HudBars := preload("res://scripts/fight3d/HudBars.gd")

var fails := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		fails += 1


func _bar(v: float) -> Dictionary:
	return {"fill": v, "keep": 1.0, "known": true}


func _initialize() -> void:
	var a = HudBars.Arc.new()
	a.kind = "body"
	a.set_bar(_bar(0.9))
	_check(a.chunk < 0.0, "the first reading is no hit: no chunk")
	a.set_bar(_bar(0.8))
	_check(is_equal_approx(a.fill, 0.8), "a hit takes the fill down at once")
	_check(is_equal_approx(a.chunk, 0.9), "the part it took stays on show (%.2f)" % a.chunk)
	a.tick(HudBars.Arc.CHUNK_HOLD_S * 0.5)
	_check(is_equal_approx(a.chunk, 0.9), "the chunk holds before it drains")
	for n in 120:
		a.tick(1.0 / 30.0)
	_check(a.chunk < 0.0, "then it drains away")
	a.set_bar(_bar(0.85))
	_check(a.chunk < 0.0, "a bar coming back at the bell makes no chunk")
	_check(a.chunk_top() < 0.0, "no chunk, nothing to draw")
	for n in 120:
		a.tick(1.0 / 30.0)
	a.set_bar(_bar(0.84))
	_check(a.chunk_top() >= a.fill + HudBars.Arc.CHUNK_MIN - 0.0001, "a small hit still shows (%.3f wide)" % (a.chunk_top() - a.fill))

	var small: float = HudBars.strength(1.5, false)
	var big: float = HudBars.strength(3.0, true)
	_check(small > 0.0 and small < big, "the flash follows the damage: %.2f, big %.2f" % [small, big])
	_check(big <= 1.0, "and stops at full")
	_check(HudBars.strength(0.0, false) == 0.0, "no damage, no flash")
	a.flash(small)
	var low: float = a._flash
	a.flash(big)
	_check(a._flash > low, "a bigger hit flashes brighter")
	a.flash(small)
	_check(is_equal_approx(a._flash, big), "a small hit does not dim a flash already up")

	var r = HudBars.Rings.new()
	_check(not r.liver_lit(), "the liver starts dark")
	r.liver_hit()
	_check(r.liver_lit() and r.liver_flash > 0.9, "a big liver shot flashes it")
	r.tick_liver(1.0, false)
	_check(r.liver_flash <= 0.0 and r.liver_lit(), "the flash is quick, the liver stays lit")
	r.tick_liver(HudBars.Rings.LIVER_MIN_S, false)
	_check(not r.liver_lit(), "with nothing wrong it goes out after %.1f s" % HudBars.Rings.LIVER_MIN_S)
	r.liver_hit()
	r.tick_liver(HudBars.Rings.LIVER_MIN_S + 5.0, true)
	_check(r.liver_lit(), "while the effect lasts it stays lit")
	r.tick_liver(0.1, false)
	_check(not r.liver_lit(), "and goes out when the effect ends")
	r.free()
	print("HIT_FLASH failures=%d" % fails)
	quit(0 if fails == 0 else 1)
