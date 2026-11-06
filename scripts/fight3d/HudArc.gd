extends RefCounted
## S393: moved out of HudBars (the 500-line rule). One of the six: fill eases to its target, the end past `keep` is gone for the fight, unknown = a dashed "?" arc.

const SIDE_COLOUR := [Color(0.95, 0.4, 0.35), Color(0.5, 0.65, 1.0)]
const IVORY := Color("#efe8dc")

const EASE_S := 0.35
var kind := ""
var side := 0
var fill := -1.0
var keep := 1.0
var known := true
var tooltip_text := ""
var _want := 1.0
var _want_keep := 1.0
var _flash := 0.0
var _band := -1
## S392 what the last hit took (top end, -1 = none). A hit is 1.5-3 points, under 2 degrees: drawn CHUNK_MIN wide at least.
const CHUNK_HOLD_S := 0.5
const CHUNK_MIN := 0.1
## S393 (blind review: "a hard shot and a jab look alike"): the chunk grows with the hit, from a flash of WEAK_POWER to full.
const CHUNK_MAX := 0.3
const WEAK_POWER := 0.6
const CHUNK_DRAIN_S := 0.18
var chunk := -1.0
var _struck := false
var _width := CHUNK_MIN
var _chunk_hold := 0.0

func set_bar(b: Dictionary) -> void:
	known = bool(b["known"])
	_want = float(b["fill"])
	_want_keep = float(b["keep"])
	if fill < 0.0:
		fill = _want
		keep = _want_keep
	elif _struck:   # S393: only a landed punch makes a chunk; a read's drop (stamina on the exchange clock) eases
		chunk = maxf(chunk, fill)
		_chunk_hold = CHUNK_HOLD_S
		fill = minf(fill, _want)
	_struck = false
	var band := band_of(_want)
	if _band >= 0 and band != _band:
		_flash = maxf(_flash, 0.7)
	_band = band

func flash(power: float = 1.0, struck := false) -> void:
	_flash = maxf(_flash, power)
	_struck = _struck or struck
	if struck:
		_width = lerpf(CHUNK_MIN, CHUNK_MAX, clampf((power - WEAK_POWER) / (1.0 - WEAK_POWER), 0.0, 1.0))

## The chunk on the arc, (low, high); always CHUNK_MIN wide, so a hit on a full arc shows too. x < 0 = no chunk.
func chunk_span() -> Vector2:
	var top := minf(maxf(chunk, fill + _width), 1.0)
	return Vector2(minf(fill, top - _width), top) if chunk >= 0.0 else Vector2(-1.0, -1.0)

func tick(delta: float) -> void:
	var k := 1.0 - exp(-delta / EASE_S)
	fill = lerpf(fill, _want, k)
	keep = lerpf(keep, _want_keep, k)
	_flash = maxf(0.0, _flash - delta * 2.0)
	if chunk >= 0.0:
		_chunk_hold -= delta
		if _chunk_hold <= 0.0:
			chunk = lerpf(chunk, fill, 1.0 - exp(-delta / CHUNK_DRAIN_S))
			if chunk - fill < 0.004:
				chunk = -1.0

static func band_of(v: float) -> int:
	return 0 if v >= 0.6 else (1 if v >= 0.35 else 2)

func colour() -> Color:
	var v := maxf(fill, 0.0)
	# S347 (operator C193: "it reminds ufc6 too much"): no rainbow of yellow / white / purple / green. Her engine
	# (stamina, guard, heart) in her corner's colour, her body (head, body, legs) ivory while fine - amber, then red,
	# only when it matters, so the eye goes where something happened.
	if kind in ["stamina", "guard", "heart"]:
		return SIDE_COLOUR[side] if v >= 0.3 else Color("#f0a020")
	return [IVORY, Color("#f0a020"), Color("#e0503c")][band_of(v)]
