extends RefCounted
## S392 CORNERWARM: the owned mocap takes play while boxers wait in their corner before the bell.
## Pure static selection and windowing for the 7 owned takes in assets/anim/baked/owned.

const CLIPS := [
	"rk_shadowboxing_a",
	"rk_shadowboxing_b",
	"rk_boxing",
	"cmu_13_17",
	"cmu_13_18",
	"cmu_14_01",
	"cmu_14_02",
]


## S393: the seed for one boxer in one bout. The two corners always differ, and bouts differ from each other.
static func seed_for(bout_seed: int, boxer: int) -> int:
	return bout_seed * 2 + boxer


## Picks one of the 7 owned takes that `has` accepts. Deterministic for a given `seed`.
## If `has` refuses all clips, returns "".
static func pick(seed: int, has: Callable) -> String:
	var available: Array = []
	for c in CLIPS:
		if bool(has.call(c)):
			available.append(c)
	if available.is_empty():
		return ""
	return str(available[posmod(seed, available.size())])


## Picks a [start, end] window inside a take of length `clip_len`.
## If `clip_len <= want_s` or `want_s <= 0.0`, returns the whole take: Vector2(0.0, clip_len).
## Otherwise, picks a start inside [0.0, clip_len - want_s] deterministically from `seed`,
## and returns Vector2(start, start + want_s).
static func window(clip_len: float, seed: int, want_s: float) -> Vector2:
	if clip_len <= 0.0:
		return Vector2.ZERO
	if want_s <= 0.0 or clip_len <= want_s:
		return Vector2(0.0, clip_len)
	var max_start := clip_len - want_s
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var start := clampf(rng.randf_range(0.0, max_start), 0.0, max_start)
	return Vector2(start, start + want_s)
