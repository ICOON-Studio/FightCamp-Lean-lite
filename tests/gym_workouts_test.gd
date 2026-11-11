extends SceneTree
## S429 workouts on the gym floor: every station uses strips we baked, the pick changes and rests, a heavy-bag
## fighter stands at a bag, and a roadwork fighter stays outside.

const GymWorkouts := preload("res://scripts/rules/GymWorkouts.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")

const ART := "res://assets/ui/art/hub_sprites/%s_%s.png"
const PEOPLE := ["ada", "bo", "cio", "dee", "eli"]

var failures := 0


func _initialize() -> void:
	_strips()
	_pick()
	_stations()
	_today()
	print("GYM_WORKOUTS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _strips() -> void:
	var bodies := _bodies()
	_check(bodies.size() >= 12, "hub bodies with an idle strip (%d)" % bodies.size())
	for kind in GymWorkouts.kinds():
		var clips: Array = GymWorkouts.clips_for(str(kind))
		_check(clips.size() >= 1, "%s has a strip" % kind)
		var rest := GymWorkouts.rest_clip(str(kind))
		if not clips.has(rest):
			clips.append(rest)
		for clip in clips:
			for body in bodies:
				var path := ART % [body, str(clip)]
				_check(ResourceLoader.exists(path), "%s exists" % path)
	var floor: Array = GymWorkouts.clips_for("floor")
	_check(floor == GymWorkouts.clips_for("mat"), "open floor uses the mat strips")
	_check(GymWorkouts.clips_for("desk") == ["stand"] and GymWorkouts.clips_for("office_desk") == ["stand"], "a desk stands")
	_check(GymWorkouts.clips_for("bag") == ["jab_back", "bag_combo", "bag_body", "bag_upper"], "a bag cycles the four bag strips")
	_check(GymWorkouts.clips_for("bench") == ["rest_drink", "rest_talk"], "a bench drinks and talks")


func _pick() -> void:
	_check(GymWorkouts.pick("bag", "ada", 1.25) == GymWorkouts.pick("bag", "ada", 1.25), "pick is deterministic")
	for pid in PEOPLE:
		for kind in ["bag", "mat", "bench"]:
			var clips := _blocks(kind, pid, 500)
			var changed := false
			var rest_n := 0
			var rest := GymWorkouts.rest_clip(kind)
			for i in clips.size():
				if i > 0 and str(clips[i]) != str(clips[i - 1]):
					changed = true
				if str(clips[i]) == rest:
					rest_n += 1
				if i >= 2 and str(clips[i]) == str(clips[i - 1]) and str(clips[i]) == str(clips[i - 2]):
					_check(false, "%s %s repeated %s three blocks at %d" % [kind, pid, clips[i], i])
			_check(changed, "%s %s changes strip over time" % [kind, pid])
			var pct := float(rest_n) / float(clips.size())
			_check(pct >= 0.10 and pct <= 0.30, "%s %s rests %.0f percent (want 10 to 30)" % [kind, pid, pct * 100.0])
	var stood := _blocks("desk", "ada", 12)
	var all_stand := true
	for c in stood:
		if str(c) != "stand":
			all_stand = false
	_check(all_stand, "a desk stays on stand")


func _blocks(kind: String, pid: String, n: int) -> Array:
	var out: Array = []
	var t := 0.0
	for i in n:
		var w := GymWorkouts.block_seconds(pid, i)
		_check(w >= 20.0 and w <= 40.0, "block %d is 20 to 40 s (%.0f)" % [i, w])
		var minute := (t + w * 0.5) / 60.0
		_check(GymWorkouts.block_index(pid, minute) == i, "minute %.3f is block %d" % [minute, i])
		out.append(GymWorkouts.pick(kind, pid, minute))
		t += w
	return out


func _stations() -> void:
	for sid in WeekPhase.SESSIONS:
		var kind := GymWorkouts.station_for(str(sid))
		if str(sid) == "roadwork" or str(sid) == "intervals":
			_check(kind == "", "%s is outside" % sid)
		else:
			_check(kind != "" and GymWorkouts.kinds().has(kind), "%s stands at %s" % [sid, kind])
	for sid in ["pads", "sparring", "film", "rest"]:
		var kind := GymWorkouts.station_for(sid)
		_check(kind != "" and GymWorkouts.kinds().has(kind), "evening %s stands at %s" % [sid, kind])
	_check(GymWorkouts.station_for("heavy_bag") == "bag", "heavy bag is a bag")


func _today() -> void:
	var bagger := _fighter("f-bag", "Lucy Jackson", "heavy_bag")
	var bagger2 := _fighter("f-bag-2", "Maria Ortega", "heavy_bag")
	var runner := _fighter("f-road", "Dana Whitfield", "roadwork")
	var rows: Array = GymWorkouts.fighters_today([bagger, runner, bagger2], 0)
	var ids := {}
	var spots := {}
	var saw_bag := 0
	for row in rows:
		ids[str(row["id"])] = true
		_check(not spots.has(str(row["spot"])), "spot %s is used once" % row["spot"])
		spots[str(row["spot"])] = true
		if str(row["id"]) == "f-bag" or str(row["id"]) == "f-bag-2":
			_check(str(row["kind"]) == "bag", "%s is at a bag (%s)" % [row["id"], row["kind"]])
			saw_bag += 1
		_check(str(row["stem"]).begins_with("mh_boxer_"), "%s has a body" % row["id"])
		var clip := str(row["clip"])
		_check(GymWorkouts.clips_for("bag").has(clip) or clip == GymWorkouts.rest_clip("bag"), "clip %s is a bag strip" % clip)
	_check(saw_bag == 2, "both heavy-bag fighters are on a bag")
	_check(not ids.has("f-road"), "roadwork stays off the floor")
	_check(spots.size() == rows.size() and rows.size() == 2, "two fighters, two spots")


func _fighter(id: String, nm: String, session: String) -> Dictionary:
	return {"id": id, "name": nm, "phase": "base", "week_edits": {"phase": "base", "days": {"0": [session, "normal"]}}}


func _bodies() -> Array:
	var out: Array = []
	for fn in DirAccess.get_files_at("res://assets/ui/art/hub_sprites"):
		var name := str(fn)
		if name.ends_with("_idle.png"):
			out.append(name.trim_suffix("_idle.png"))
	out.sort()
	return out


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
