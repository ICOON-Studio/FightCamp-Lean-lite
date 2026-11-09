extends SceneTree
## GYMKIND1: does each kind of kit build something worth its price? The map, the clamp, opening rows give 1.0, every piece
## bought gives 1.10, unfitted pieces do not count.

const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymKinds := preload("res://scripts/rules/GymKinds.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)


func _initialize() -> void:
	_map()
	_opening_gives_one()
	_all_bought_gives_max()
	_clamp()
	_unfitted_not_counted()
	_unknown_stat()
	print("GYM_KINDS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The map: each kind points at the stats it builds, and the reverse is consistent.
func _map() -> void:
	_check(GymKinds.KIND_STATS.has("bag") and GymKinds.KIND_STATS["bag"] == ["power", "speed"], "bag builds power and speed")
	_check(GymKinds.KIND_STATS.has("rack") and GymKinds.KIND_STATS["rack"] == ["power", "chin"], "rack builds power and chin")
	_check(GymKinds.KIND_STATS.has("bench") and GymKinds.KIND_STATS["bench"] == ["power", "chin"], "bench builds power and chin")
	_check(GymKinds.KIND_STATS.has("cardio") and GymKinds.KIND_STATS["cardio"] == ["conditioning"], "cardio builds conditioning")
	_check(GymKinds.KIND_STATS.has("mirror") and GymKinds.KIND_STATS["mirror"] == ["technique"], "mirror builds technique")
	_check(GymKinds.KIND_STATS.has("mat") and GymKinds.KIND_STATS["mat"] == ["defense"], "mat builds defense")
	_check(not GymKinds.KIND_STATS.has("ring"), "a ring builds nothing here")
	_check(not GymKinds.KIND_STATS.has("kit"), "corner kit builds nothing here")
	for stat in GymKinds.STAT_KINDS:
		for kind in GymKinds.STAT_KINDS[stat]:
			_check((GymKinds.KIND_STATS[kind] as Array).has(stat), "reverse: %s -> %s -> %s" % [stat, kind, stat])


## Opening rows (the start kit) give exactly 1.0 on every stat: nothing added past the start.
func _opening_gives_one() -> void:
	var rows: Array = GymSlots.start_rows()
	for stat in GymKinds.STAT_KINDS:
		var m := GymKinds.gain_mult(rows, 0, stat)
		_check(is_equal_approx(m, 1.0), "opening rows: %s = %.4f (1.0)" % [stat, m])


## Every piece bought (all non-locked slots owned) gives exactly 1.10 on every mapped stat.
func _all_bought_gives_max() -> void:
	var rows: Array = []
	for s in GymSlots.all():
		rows.append({"id": str(s["id"]), "day": -GymSlots.FIT_DAYS})
	for stat in GymKinds.STAT_KINDS:
		var m := GymKinds.gain_mult(rows, 0, stat)
		_check(is_equal_approx(m, 1.10), "all bought: %s = %.4f (1.10)" % [stat, m])


## The clamp: owned places cannot push the multiplier past 1.10 or below 1.0.
func _clamp() -> void:
	var rows: Array = GymSlots.start_rows()
	for stat in GymKinds.STAT_KINDS:
		var m := GymKinds.gain_mult(rows, 0, stat)
		_check(m >= 1.0 and m <= 1.10, "clamp: %s = %.4f in [1.0, 1.10]" % [stat, m])
	var empty: Array = []
	for stat in GymKinds.STAT_KINDS:
		var m := GymKinds.gain_mult(empty, 0, stat)
		_check(is_equal_approx(m, 1.10), "empty rows (old save): %s = %.4f (1.10, whole gym stands)" % [stat, m])


## Unfitted pieces (bought but still in the fitters' week) do not count toward the multiplier.
func _unfitted_not_counted() -> void:
	var rows: Array = GymSlots.start_rows()
	rows.append({"id": "mat_blue", "day": 0})
	var during_fit := GymKinds.gain_mult(rows, 3, "defense")
	_check(is_equal_approx(during_fit, 1.0), "mat_blue fitting on day 3: defense = %.4f (1.0)" % during_fit)
	var after_fit := GymKinds.gain_mult(rows, 7, "defense")
	_check(after_fit > 1.0 and after_fit < 1.10, "mat_blue fitted on day 7: defense = %.4f (between 1.0 and 1.10)" % after_fit)


## A stat not in the map returns 1.0.
func _unknown_stat() -> void:
	_check(is_equal_approx(GymKinds.gain_mult(GymSlots.start_rows(), 0, "heart"), 1.0), "heart (not in the map) = 1.0")
	_check(is_equal_approx(GymKinds.gain_mult(GymSlots.start_rows(), 0, "fight_iq"), 1.0), "fight_iq (not in the map) = 1.0")
