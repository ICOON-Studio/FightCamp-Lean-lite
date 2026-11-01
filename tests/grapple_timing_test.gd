extends SceneTree
## S336 GrappleTiming: a keyframe gap lasts as long as its largest joint move takes at SPEED (either man; Core and hips
## count double), clamped to [MIN_S, MAX_S]. SPEED is calibrated on the Sekai clip lengths (BJJ_SOURCES_S334.md): the
## closest GrappleMap moves, chained through graph.json from the clip's start to its finish, land within 35%. Moves
## keep their own rhythm (few gaps sit on a clamp). And GrapplePlayer plays the gaps at those lengths: length_s() is
## their sum, each keyframe is reached at its time, shown_frame() is the nearest keyframe, a position still breathes.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const TIMING := "res://scripts/grapple/GrappleTiming.gd"
const GRAPH := "res://assets/grapplemap/graph.json"
const TOLERANCE := 0.35
## [Sekai clip, its length in seconds, the GrappleMap positions its closest moves chain through].
const REFS := [
	["kimura from side control", 4.8, ["twister side w/ bottom underhook", "far side side control kimura", "perfect kimura"]],
	["americana (none in GrappleMap: the figure-four worked round the head, bottom flat)", 5.2,
		["far side side control kimura", "north/south kimura", "near side side control kimura"]],
	["toreando pass (GrappleMap: bull fighter pass)", 10.0, ["standing vs seated w/ knee pinned",
		"standing vs supine w/ legs extended", "bull fighter pass", "knee on belly center", "judo side vs double c-cups"]],
	["back take", 7.9, ["parallel turtle", "parallel turtle w/ seatbelt", "turtle w/ seatbelt and near hook",
		"back on choke arm side w/ one leg trapped", "back on choke arm side"]],
]

var failures := 0


func _initialize() -> void:
	var T: Variant = load(TIMING) if ResourceLoader.exists(TIMING) else null
	_check(T != null, "scripts/grapple/GrappleTiming.gd exists")
	if T == null:
		_finish()
		return
	_rules(T)
	var db: Array = DB.load_db()
	_calibration(T, db)
	_spread(T, db)
	_player(T, db)
	_finish()


## Hand-made frames: the rule itself.
func _rules(T: Variant) -> void:
	var s: float = T.SPEED
	_check(T.durations([_frame({})]).is_empty(), "a position (one keyframe) has no gaps")
	var hand: PackedFloat32Array = T.durations([_frame({}), _frame({"RightHand": 0.4})])
	_check(hand.size() == 1 and is_equal_approx(hand[0], 0.4 / s), "a hand moving 0.4 m takes 0.4 / SPEED = %.2f s (%s)" % [0.4 / s, hand])
	var core: float = T.durations([_frame({}), _frame({"Core": 0.2})])[0]
	var hip: float = T.durations([_frame({}), _frame({"LeftHip": 0.2})])[0]
	_check(is_equal_approx(core, hand[0]) and is_equal_approx(hip, hand[0]), "Core and hips count double: 0.2 m of either = the hand's 0.4 m (%.2f, %.2f s)" % [core, hip])
	var both: float = T.durations([_frame({}), _frame({"RightHand": 0.4, "LeftToe": 0.1, "Head": 0.15})])[0]
	_check(is_equal_approx(both, hand[0]), "the largest joint move decides (%.2f s)" % both)
	var other: float = T.durations([_frame({}), _frame({"RightHand": 0.4}, 1)])[0]
	_check(is_equal_approx(other, hand[0]), "either man's move counts (%.2f s)" % other)
	var tiny: float = T.durations([_frame({}), _frame({"LeftWrist": 0.01})])[0]
	var huge: float = T.durations([_frame({}), _frame({"Core": 3.0})])[0]
	_check(is_equal_approx(tiny, T.MIN_S) and is_equal_approx(huge, T.MAX_S), "clamped to [%.2f, %.2f] s (%.2f, %.2f)" % [T.MIN_S, T.MAX_S, tiny, huge])
	var three: PackedFloat32Array = T.durations([_frame({}), _frame({"RightHand": 0.4}), _frame({"RightHand": 0.4, "Core": 0.4})])
	_check(three.size() == 2 and three[1] > three[0], "one duration per gap, each its own (%s)" % three)
	var keys: PackedFloat32Array = T.key_times([_frame({}), _frame({"RightHand": 0.4}), _frame({"RightHand": 0.4, "Core": 0.4})])
	_check(keys.size() == 3 and keys[0] == 0.0 and is_equal_approx(keys[2], three[0] + three[1]), "key_times: when each keyframe is reached (%s)" % keys)


## The Sekai clips: the chained moves' totals land within TOLERANCE of each clip's length.
func _calibration(T: Variant, db: Array) -> void:
	var g: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(GRAPH))
	var pos := {}
	for p in g["positions"]:
		pos[str(p["title"])] = int(p["id"])
	print("  SPEED %.2f m/s, gaps clamped to [%.2f, %.2f] s" % [T.SPEED, T.MIN_S, T.MAX_S])
	for r in REFS:
		var names: Array = r[2]
		var parts: PackedStringArray = []
		var total := 0.0
		var linked := true
		for i in names.size() - 1:
			var move := _move(g, pos.get(names[i], -1), pos.get(names[i + 1], -1))
			if move.is_empty():
				linked = false
				parts.append("NO MOVE %s -> %s" % [names[i], names[i + 1]])
				continue
			var d := _sum(T.durations(db[int(move["id"])]["frames"]))
			total += d
			parts.append("#%d '%s' %.2f s [%s -> %s]" % [int(move["id"]), str(move["title"]).get_slice(" todo:", 0), d, names[i], names[i + 1]])
		var off := total / float(r[1]) - 1.0
		_check(linked and absf(off) <= TOLERANCE, "%s: Sekai %.1f s, GrappleMap %.2f s (%+.0f%%)" % [r[0], r[1], total, off * 100.0])
		for p in parts:
			print("         ", p)


## Over every move: inside the clamps, mostly off them, and gaps inside one move differ (a roll vs a hand shift).
func _spread(T: Variant, db: Array) -> void:
	var all: Array = []
	var varied := 0
	var long_moves := 0
	for s in db:
		if not DB.is_transition(s):
			continue
		var d: Array = Array(T.durations(s["frames"]))
		all.append_array(d)
		if d.size() >= 3:
			long_moves += 1
			if d.max() >= 1.5 * d.min():
				varied += 1
	all.sort()
	var at_min := all.filter(func(x): return x <= T.MIN_S + 0.0001).size()
	var at_max := all.filter(func(x): return x >= T.MAX_S - 0.0001).size()
	print("  %d gaps: min %.2f s, median %.2f s, max %.2f s; %.0f%% at the floor, %.0f%% at the ceiling" % [all.size(), all[0],
		all[int(all.size() / 2.0)], all.back(), 100.0 * at_min / all.size(), 100.0 * at_max / all.size()])
	_check(all[0] >= T.MIN_S - 0.0001 and all.back() <= T.MAX_S + 0.0001, "every gap inside the clamps")
	_check(float(at_min + at_max) / all.size() < 0.2, "under 20%% of gaps sit on a clamp (%d of %d)" % [at_min + at_max, all.size()])
	_check(float(varied) / long_moves > 0.5, "most moves vary their pace: %d of %d (3+ gaps) have a gap 1.5x another" % [varied, long_moves])


## GrapplePlayer plays those lengths.
func _player(T: Variant, db: Array) -> void:
	var seq: Dictionary = db[1371]
	var frames: Array = seq["frames"]
	var keys: Array = Array(T.key_times(frames))
	var p = Player.new()
	p.contact = false   # S337: timing only - the push-out (GrappleContact, its own test) nudges joints off the keyframes
	p.play(seq, [null, null], 1.0, Transform3D.IDENTITY)
	_check(is_equal_approx(p.length_s(), keys.back()), "length_s() = the durations' sum (%.2f s, %d keyframes)" % [p.length_s(), frames.size()])
	var hit := 0
	var shown := 0
	var j0: Array = p.joints_at(0.0)
	for k in frames.size():
		var jk: Array = p.joints_at(keys[k])
		var worst := 0.0
		for m in 2:
			for j in DB.JOINTS.size():
				var want: Vector3 = (frames[k][m] as PackedVector3Array)[j] - (frames[0][m] as PackedVector3Array)[j]
				worst = maxf(worst, (jk[m][j] - j0[m][j] - want).length())
		hit += 1 if worst < 0.001 else 0
		if k < frames.size() - 1:
			var gap: float = keys[k + 1] - keys[k]
			p.seek(keys[k] + gap * 0.4)
			var a: Array = p.shown_frame()
			p.seek(keys[k] + gap * 0.6)
			shown += 1 if a == frames[k] and p.shown_frame() == frames[k + 1] else 0
	_check(hit == frames.size(), "every keyframe is reached at its own time (%d of %d)" % [hit, frames.size()])
	_check(shown == frames.size() - 1, "shown_frame() is the nearest keyframe (%d of %d gaps)" % [shown, frames.size() - 1])
	# Gaps of different lengths meet at a keyframe: the curve runs in time, so no joint changes speed there with a jerk.
	var jerk := 0.0
	var h := 0.002
	for k in range(1, frames.size() - 1):
		var a: Array = p.joints_at(keys[k] - h)
		var b: Array = p.joints_at(keys[k])
		var c: Array = p.joints_at(keys[k] + h)
		for m in 2:
			for j in DB.JOINTS.size():
				jerk = maxf(jerk, ((c[m][j] - b[m][j]) - (b[m][j] - a[m][j])).length() / h)
	_check(jerk < 0.15, "speed carries through every keyframe (largest jump %.2f m/s)" % jerk)
	p.seek(keys.back() - 0.01)
	var before_end: bool = p.done()
	p.seek(keys.back())
	_check(not before_end and p.done(), "done() at the end, not before")
	var next: Array = db[839]["frames"]
	p.play_frames(next)
	_check(is_equal_approx(p.length_s(), _sum(T.durations(next))), "play_frames (browser chaining) times the new move (%.2f s)" % p.length_s())
	var mount: Dictionary = DB.find(db, "mount")
	p.play(mount, [null, null], 1.0, Transform3D.IDENTITY)
	var core := DB.joint("Core")
	var lift: float = absf(p.joints_at(1.0)[0][core].y - p.joints_at(0.0)[0][core].y)
	p.seek(3.0)
	_check(p.length_s() == 0.0 and lift > 0.005 and is_equal_approx(p.t(), 3.0), "a position still breathes (%.3f m)" % lift)
	p.free()


func _move(g: Dictionary, from: int, to: int) -> Dictionary:
	for t in g["transitions"]:
		if t["from"] != null and t["to"] != null and int(t["from"]) == from and int(t["to"]) == to:
			return t
	return {}


## A frame of both men at the origin, with `moved` joints (name: metres along x) shifted for man `man`.
func _frame(moved: Dictionary, man: int = 0) -> Array:
	var out: Array = []
	for m in 2:
		var p := PackedVector3Array()
		p.resize(DB.JOINTS.size())
		if m == man:
			for n in moved:
				p[DB.joint(n)] = Vector3(float(moved[n]), 0.0, 0.0)
		out.append(p)
	return out


func _sum(a: PackedFloat32Array) -> float:
	var s := 0.0
	for x in a:
		s += x
	return s


func _finish() -> void:
	print("FAIL %d" % failures if failures else "PASS grapple_timing_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
