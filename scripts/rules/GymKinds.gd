extends RefCounted
## GYMKIND1: each kind of kit builds something worth its price. A bag builds power and speed; a rack or bench builds power
## and chin; cardio builds conditioning; a mirror builds technique; a mat builds defense. A ring builds nothing here: it
## cannot be bought up. The multiplier on a training session's gain grows from 1.0 (the opening kit) to 1.10 (the whole
## gym of that kind), in proportion to the places the owner has added past the start.
## Pure: no nodes, no game-state writes.

const GymSlots := preload("res://scripts/rules/GymSlots.gd")

## Kind -> the session stats its equipment builds.
const KIND_STATS := {
	"bag": ["power", "speed"],
	"rack": ["power", "chin"],
	"bench": ["power", "chin"],
	"cardio": ["conditioning"],
	"mirror": ["technique"],
	"mat": ["defense"],
}

## Stat -> the kinds that build it (the reverse of KIND_STATS).
const STAT_KINDS := {
	"power": ["bag", "rack", "bench"],
	"speed": ["bag"],
	"chin": ["rack", "bench"],
	"conditioning": ["cardio"],
	"technique": ["mirror"],
	"defense": ["mat"],
}


## The places a kind contributes across the whole gym (locked pieces excluded).
static func _kind_total_places(kind: String) -> int:
	var n := 0
	for s in GymSlots.all():
		if str(s["kind"]) == kind:
			n += int(s.get("places", 0))
	return n


## The places a kind starts with (the opening kit, already fitted).
static func _kind_start_places(kind: String) -> int:
	var n := 0
	for s in GymSlots.all():
		if str(s["kind"]) == kind and bool(s.get("start", false)):
			n += int(s.get("places", 0))
	return n


## The places of these kinds the gym owns on this day.
static func _owned_places(rows: Array, day: int, kinds: Array) -> int:
	var n := 0
	for id in GymSlots.owned(rows, day):
		var s := GymSlots.item(str(id))
		if kinds.has(str(s.get("kind", ""))):
			n += int(s.get("places", 0))
	return n


## The start places of these kinds.
static func _start_places(kinds: Array) -> int:
	var n := 0
	for kind in kinds:
		n += _kind_start_places(kind)
	return n


## The total places of these kinds across the whole gym.
static func _total_places(kinds: Array) -> int:
	var n := 0
	for kind in kinds:
		n += _kind_total_places(kind)
	return n


## The gain multiplier for a stat from the gym's kit. share = (owned places of its kinds minus the opening places) /
## (all places of those kinds minus the opening places), clamped 0-1. Multiplier = 1.0 + 0.10 x share.
## Empty rows (an old save, the whole gym stands) gives share 1.0.
static func gain_mult(rows: Array, day: int, stat: String) -> float:
	if not STAT_KINDS.has(stat):
		return 1.0
	var kinds: Array = STAT_KINDS[stat]
	var total := _total_places(kinds)
	var start := _start_places(kinds)
	if total - start <= 0:
		return 1.0
	if rows.is_empty():
		return 1.10
	var owned := _owned_places(rows, day, kinds)
	var share := clampf(float(owned - start) / float(total - start), 0.0, 1.0)
	return 1.0 + 0.10 * share
