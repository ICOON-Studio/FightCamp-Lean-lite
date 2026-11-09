extends RefCounted
## S412 operator on the versus screen: "make fighters to have unique random poses instead of same or mirrored ones".
## Eight pre-fight poses, picked by eye from a sheet of the game's own clips (tools/bake_full_body.gd bakes them). Each boxer has
## three, spread so boxers next to each other differ; a bout picks one each and never the same pose on both sides. Pure.
##   of(stem) -> three POOL indices. pair(a, b, key) -> [which of a's three, which of b's three], the same every time for one key.

const POOL := [["pro_idle", 0.1], ["pro_idle_fidget_v2", 0.5], ["pro_idle_fidget_v3", 0.5], ["pro_idle_fidget_v8", 0.5],
	["rk_shadowboxing_a", 0.3], ["rk_shadowboxing_a", 0.6], ["rk_shadowboxing_b", 0.3], ["rk_guard", 0.5]]
const PER_BOXER := 3


## The pool poses this boxer was baked in. The first is the plain <stem>.png the roster cards show.
static func of(stem: String) -> Array:
	var n := int(stem.right(2))
	return [n % POOL.size(), (n + 3) % POOL.size(), (n + 5) % POOL.size()]


## Which of each boxer's three pictures a bout shows. The key is the bout's offer id, so a page redraw never changes them.
static func pair(a: String, b: String, key: String) -> Array:
	var i := absi(hash(key + a)) % PER_BOXER
	var j := absi(hash(key + b)) % PER_BOXER
	var mine: int = of(a)[i]
	for step in PER_BOXER:
		var k := (j + step) % PER_BOXER
		if of(b)[k] != mine:
			return [i, k]
	return [i, j]


## The picture name for pose number `i` of a stem already carrying its kit ("mh_boxer_10_alt").
static func picture(stem: String, i: int) -> String:
	return stem if i == 0 else "%s_p%d" % [stem, i]
