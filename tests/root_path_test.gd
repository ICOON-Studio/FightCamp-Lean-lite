extends SceneTree
## FIGHTPLAYER2 phase 3 (S512): a pinned take keeps its own hip travel beside it, and v2/RootPath reads it back.
## 1. A hand-made clip: hold_root_xz pins the hips exactly as before AND the path beside it is what the pin took away.
## 2. Real bakes (no body needed): the path's furthest point equals the clip census's hips travel for the same take
##    (two routes to one number: the Hips track here, the sampled skeleton in tools/clip_census.gd).
## 3. FightClips.as_bought leaves the clip untouched (the census's route). Prints ROOT_PATH failures=<n>.

const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const RootPath := preload("res://scripts/fight3d/v2/RootPath.gd")
const Census := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const TAKES := {"pro_hit_by_gutshot_v2": "Hit_By_Gutshot_V2", "pro_back_dodge": "Back_Dodge", "pro_left_dodge": "Left_Dodge",
	"pro_kidney_shot": "Kidney_Shot", "pro_right_cross": "Right_Cross", "pro_left_hook_v2": "Left_Hook_V2"}

var failures := 0


func _initialize() -> void:
	# 1. The hand-made clip.
	var anim := _made()
	FightClips.as_bought = false
	FightClips.hold_root_xz(anim)
	var pinned := true
	for k in anim.track_get_key_count(0):
		var v: Vector3 = anim.track_get_key_value(0, k)
		pinned = pinned and is_equal_approx(v.x, 0.10) and is_equal_approx(v.z, -0.20) and is_equal_approx(v.y, 1.0 + 0.01 * k)
	_check(pinned, "the hips are pinned on their first X/Z and keep their height")
	var path := RootPath.of(anim)
	_check(path.size() == 5, "a path key for every hips key (%d)" % path.size())
	_check(RootPath.at(path, 0.0).is_equal_approx(Vector2.ZERO), "the path starts at zero")
	_check(RootPath.at(path, 0.2).is_equal_approx(Vector2(0.2, 0.4)), "the path at a key is what the pin took away (%s)" % RootPath.at(path, 0.2))
	_check(RootPath.at(path, 0.25).is_equal_approx(Vector2(0.25, 0.5)), "linear between keys (%s)" % RootPath.at(path, 0.25))
	_check(RootPath.at(path, 9.0).is_equal_approx(Vector2(0.4, 0.8)) and RootPath.at(path, -1.0).is_equal_approx(Vector2.ZERO), "held past the ends")
	_check(RootPath.reach(path).is_equal_approx(Vector2(Vector2(0.4, 0.8).length(), Vector2(0.4, 0.8).length())), "reach = the furthest point and the end")
	FightClips.hold_root_xz(anim)
	_check(RootPath.at(RootPath.of(anim), 0.4).is_equal_approx(Vector2(0.4, 0.8)), "a second pin does not wipe the path")
	_check(RootPath.world(Basis(Vector3.UP, PI), Vector2(0.3, 0.5)).is_equal_approx(Vector3(-0.3, 0.0, -0.5)), "a body turned round travels the other way")
	_check(RootPath.of(_made()).is_empty() and RootPath.at(PackedVector3Array(), 1.0) == Vector2.ZERO, "no path on a clip that was never pinned")
	# 3. As bought: nothing is pinned.
	var raw := _made()
	FightClips.as_bought = true
	FightClips.hold_root_xz(raw)
	FightClips.as_bought = false
	_check((raw.track_get_key_value(0, 4) as Vector3).is_equal_approx(Vector3(0.5, 1.04, 0.6)) and RootPath.of(raw).is_empty(), "as bought leaves the clip alone")
	# 2. Real bakes against the census.
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(Census.DB_PATH))
	var rows: Dictionary = (parsed as Dictionary).get("rows", {}) if parsed is Dictionary else {}
	_check(not rows.is_empty(), "the census table reads")
	for name in TAKES:
		var file: String = FightClips.BAKED_DIR + FightClips.PRO_PREFIX + str(TAKES[name]) + ".res"
		if not ResourceLoader.exists(file) or not rows.has(name):
			_check(false, "%s is on disk and in the census" % name)
			continue
		var take := (load(file) as Animation).duplicate(true) as Animation
		for t in take.get_track_count():
			take.track_set_path(t, NodePath("Skeleton3D:%s" % str(take.track_get_path(t))))
		FightClips.hold_root_xz(take)
		var got := RootPath.reach(RootPath.of(take)).x
		var want := float(rows[name]["hips_max_m"])
		_check(absf(got - want) <= 0.03, "%s travels %.2f m on its path, %.2f m in the census" % [name, got, want])
	print("ROOT_PATH failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## Five hips keys 0.1 s apart, travelling (+0.1, +0.2) a key from (0.10, 1.0, -0.20), rising 1 cm a key.
func _made() -> Animation:
	var anim := Animation.new()
	anim.length = 0.4
	var t := anim.add_track(Animation.TYPE_POSITION_3D)
	anim.track_set_path(t, NodePath("Skeleton3D:Hips"))
	for k in 5:
		anim.position_track_insert_key(t, 0.1 * k, Vector3(0.10 + 0.1 * k, 1.0 + 0.01 * k, -0.20 + 0.2 * k))
	return anim


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
