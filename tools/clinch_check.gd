extends SceneTree
## S354 CLINCH2 probe: the tie-up measured on the bones, in the game's own rig. Builds a real FightStage (BoxerBuild
## bodies, every modifier on), fires SCRIPTED beats through BeatFire the way scripts/fight3d/TapeFilm.gd does - three
## clinch holds and their referee breaks in ~15 s - and samples every SAMPLE_S of every ENGAGED hold (pose_tap: the pose
## AS SHOWN, after the IK stack). No bout is played: the fight's own range machine (RangeBreath) walks the holder in.
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/clinch_check.gd
## Six checks, the task's bounds (S354: NEVER loosened):
##   overlap  glove centre >= 0.10 m from the other's head bone, >= 0.08 m from her chest line (Chest..UpperChest)
##   heads    head-to-head 0.16 .. 0.26 m
##   aframe   pelvis gap - chest gap >= 0.15 m (hips back, chests in)
##   hands    every glove centre 0.07 .. 0.40 m under its own head
##   jostle   every hold: the pair's axis turns >= 15 deg, the pelvises travel >= 0.15 m
##   digs     every dig of every hold comes within 0.08 m of the other's flank (spine_02/03 side)
## S354: a run that measures FEWER THAN 3 HOLDS is VOID - every line prints FAIL and the total reads 0/6 (the r4 probe
## printed a vacuous 4/6 with 0 holds measured).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")
const PoseTap := preload("res://tools/pose_tap.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

## The task's bounds. Never loosen one of these to make a line pass.
const GLOVE_HEAD_MIN_M := 0.10
const GLOVE_CHEST_MIN_M := 0.08
const HEADS_MIN_M := 0.16
const HEADS_MAX_M := 0.26
const AFRAME_MIN_M := 0.15
const HAND_UNDER_MIN_M := 0.07
const HAND_UNDER_MAX_M := 0.40
const TURN_MIN_DEG := 15.0
const TRAVEL_MIN_M := 0.15
const DIG_TOL_M := 0.08
const HOLDS_MIN := 3
## Gloves/GloveClear: the glove's centre sits this far past the wrist along the forearm (the wrist bone is not the glove).
const GLOVE_FWD_M := 0.08
## Clinch.FLANK_M (S313/S316): the ribs' line this far out from the other's spine, at spine_02/03 height.
const FLANK_OUT_M := 0.14
const FLANK_UP_M := 0.08
const SAMPLE_S := 0.1
const RUN_S := 16.0
const BONES := ["Head", "Chest", "UpperChest", "Spine", "Hips", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm",
	"LeftUpperArm", "RightUpperArm", "LeftFoot", "RightFoot"]
## S354 brief: {"t":1.0,"who":"a","move":"clinch","dur":3.0}, the referee's break at 4.2, twice more at 6 and 11 (the
## clinch for "b" once) - three holds in ~15 s. `digs`/`digger` are the fight rules' own fields (ClinchBeats: the woman
## who is NOT tying up works the body); every hold carries two so the dig line has six to measure.
## S354: a real clinch is the end of a burst up close (ClinchBeats places it in the gap after one): the pair is inside
## range, both women are on a punch/dodge clip (so neither is mid-step), and the clinch beat lands in that window - the
## state the range machine actually reaches a tie-up from. A clinch beat with nothing in front of it measures nothing.
const BEATS: Array = [
	{"t": 0.20, "who": "a", "move": "inside", "end_t": 1.10},
	{"t": 1.00, "who": "a", "move": "jab", "result": "misses", "def": "slip"},
	{"t": 1.20, "who": "a", "move": "clinch", "dur": 3.0, "break_t": 4.2, "digs": 2, "digger": "b"},
	{"t": 4.20, "who": "a", "move": "step_out", "ref": true},
	{"t": 4.20, "who": "b", "move": "step_out", "ref": true},
	{"t": 5.00, "who": "b", "move": "inside", "end_t": 6.00},
	{"t": 5.90, "who": "b", "move": "jab", "result": "misses", "def": "slip"},
	{"t": 6.20, "who": "b", "move": "clinch", "dur": 3.0, "break_t": 9.4, "digs": 2, "digger": "a"},
	{"t": 9.40, "who": "b", "move": "step_out", "ref": true},
	{"t": 9.40, "who": "a", "move": "step_out", "ref": true},
	{"t": 10.20, "who": "a", "move": "inside", "end_t": 11.20},
	{"t": 11.00, "who": "a", "move": "jab", "result": "misses", "def": "slip"},
	{"t": 11.20, "who": "a", "move": "clinch", "dur": 3.0, "break_t": 14.4, "digs": 2, "digger": "b"},
	{"t": 14.40, "who": "b", "move": "step_out", "ref": true},
	{"t": 14.40, "who": "a", "move": "step_out", "ref": true},
]

var stage: Node3D
var _view: Node
var _beat: RefCounted
var _taps: Array = []
var _t := 0.0
var _next := 0
var _holds := 0
var _samples := 0
var _engaged := false
var _hold: Dictionary = {}
var _rows: Array = []
# Running worst case over every hold.
var _gh := 999.0        # glove to the other's head bone
var _gc := 999.0        # glove to the other's chest line
var _hh_lo := 999.0     # head to head
var _hh_hi := -1.0
var _af := 999.0        # pelvis gap - chest gap
var _hu_lo := 999.0     # glove under its own head
var _hu_hi := -99.0
var _digs_want := 0
var _digs_hit := 0
var _at: Dictionary = {}   # measure -> [t, boxer, side]: where each worst case was measured


## BeatFire's contract (Stage, rng, clock, stop, profiles, body map, pace): a stub view, the tape room's own.
class View:
	extends Node
	var stage: Node3D
	var _amb_rng := RandomNumberGenerator.new()
	var _stop := ""
	var _profiles := {"a": {}, "b": {}}
	var _close_left := 0.0
	var t := 0.0
	var body := NoBody.new()

	class NoBody:
		extends RefCounted
		func land(_b: Dictionary, _at: float) -> void:
			pass

	func pace() -> float:
		return Engine.time_scale


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	## S379 (operator: "the holo head pointer is cut"): the hidden desktop gives a 1920x1009 window, the expanded picture
	## was 2055 wide and the 1920 movie cut ~65 px off each side - keep the picture 16:9 for films.
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	stage = Stage.new()
	root.add_child(stage)
	var pair := Faces.pair({"name": "Lucy"}, {"name": "Maria", "stance": "orthodox"})
	stage.setup({"glb": Faces.glb(pair[0]), "corner": "red", "scale": 1.0, "stance": "orthodox"},
		{"glb": Faces.glb(pair[1]), "corner": "blue", "scale": 1.0, "stance": "orthodox"})
	# The game's own cast: the corner teams and, what the tie-up needs, each boxer's CornerIK (attached by CornerCrew) -
	# without the crew the hands have no IK at all and the probe would measure a clinch that does not exist.
	FightCast.crew(stage, false)
	_view = View.new()
	_view.stage = stage
	_view._amb_rng.seed = 20261102
	root.add_child(_view)
	_beat = BeatFire.new()
	for i in 2:
		var skel: Skeleton3D = stage.boxers[i]["skel"]
		var tap: SkeletonModifier3D = PoseTap.new()
		tap.setup(skel, BONES)
		skel.add_child(tap)
		_taps.append(tap)
	print("CLINCH_CHECK start: pair clips %s, gap %.2f m" % [str(stage.has_move("clinch_att")), float(stage.gap_m)])


func _process(delta: float) -> bool:
	_t += delta
	_view.t = _t
	while _next < BEATS.size() and _t >= float(BEATS[_next]["t"]):
		_beat.fire(_view, BEATS[_next])
		_next += 1
	var ph := RangeBreath.phase(BEATS, _next, _t)
	stage.aim(ph)   # the fight's own range machine walks the holder in
	if OS.get_cmdline_user_args().has("debug") and int(_t * 4.0) != int((_t - delta) * 4.0):
		print("  t=%.2f phase %s dist %.2f want %.2f holder %d eng %s move %.2f/%.2f clips %s|%s" % [_t, str(ph["phase"]),
			(stage.boxers[0]["pos"] as Vector3).distance_to(stage.boxers[1]["pos"]), float(stage.feet.want_m),
			int(stage.clinch.holder), str(stage.clinch.engaged), float(stage.boxers[0]["move_left"]),
			float(stage.boxers[1]["move_left"]), str((stage.boxers[0]["ap"] as AnimationPlayer).current_animation),
			str((stage.boxers[1]["ap"] as AnimationPlayer).current_animation)])
	_watch(delta)
	if _t >= RUN_S:
		_report()
		return true
	return false


## One hold = one `engaged` stretch of Clinch: sample it every SAMPLE_S until the referee's break lets go.
func _watch(delta: float) -> void:
	var is_in: bool = bool(stage.clinch.engaged)
	if is_in and not _engaged:
		_engaged = true
		_holds += 1
		_hold = {"n": _holds, "who": int(stage.clinch.holder), "digs": _wanted(_t), "digger": _digger(_t),
			"sample_t": SAMPLE_S, "axis": _axis(), "turn": 0.0, "prev": [_bone(0, "Hips"), _bone(1, "Hips")],
			"travel": [0.0, 0.0], "dig_at": [], "min": {}}
		if OS.get_cmdline_user_args().has("debug"):
			for i in 2:
				var ik: Node = stage.boxers[i].get("ik")
				var r: Dictionary = ik.get("_reach")
				print("    engage hold %d: boxer %d L on %s w %.2f | R on %s w %.2f" % [_holds, i,
					str((r["Left"] as Dictionary)["on"]), float((r["Left"] as Dictionary)["w"]),
					str((r["Right"] as Dictionary)["on"]), float((r["Right"] as Dictionary)["w"])])
		return
	if is_in and _engaged:
		_hold["sample_t"] = float(_hold["sample_t"]) + delta
		var cur := _axis()
		var a0: Vector3 = _hold["axis"]
		var sgn := 1.0 if a0.cross(cur).y >= 0.0 else -1.0
		# The pair may be turned either way: the check is how FAR the axis turned, not which way (S354 r1 read 0 deg on a
		# hold that turned 34 deg the other way - a signed maximum).
		_hold["turn"] = maxf(float(_hold["turn"]), absf(sgn * rad_to_deg(a0.angle_to(cur))))
		for i in 2:
			var hips: Vector3 = _bone(i, "Hips")
			var tr: Array = _hold["travel"]
			tr[i] = float(tr[i]) + _flat(hips - (_hold["prev"] as Array)[i])
			(_hold["prev"] as Array)[i] = hips
		if float(_hold["sample_t"]) >= SAMPLE_S:
			_hold["sample_t"] = 0.0
			_sample()
		return
	if not is_in and _engaged:
		_engaged = false
		_rows.append(_hold)


## One sample of the six measurements, as shown (pose_tap: after the IK).
func _sample() -> void:
	_samples += 1
	var head := [_bone(0, "Head"), _bone(1, "Head")]
	var hips := [_bone(0, "Hips"), _bone(1, "Hips")]
	var chest := [_bone(0, "UpperChest"), _bone(1, "UpperChest")]
	# 1. overlap: no glove inside the other body.
	for i in 2:
		var other := 1 - i
		for side in ["Left", "Right"]:
			var cv: Vector3 = _glove(i, side)
			var dh := cv.distance_to(head[other])
			if dh < _gh:
				_gh = dh
				_mark("overlap head", i, side)
			var dc := _dist_line(cv, _bone(other, "Chest"), chest[other])
			if dc < _gc:
				_gc = dc
				_mark("overlap chest", i, side)
	# 2. heads ear by ear.
	var hh: float = head[0].distance_to(head[1])
	_hh_lo = minf(_hh_lo, hh)
	_hh_hi = maxf(_hh_hi, hh)
	if hh <= _hh_lo:
		_mark("heads min", 0, "")
	if hh >= _hh_hi:
		_mark("heads max", 0, "")
	# 3. the A-frame: hips back, chests in.
	_af = minf(_af, hips[0].distance_to(hips[1]) - chest[0].distance_to(chest[1]))
	# 4. every glove 0.07-0.40 m under its own head.
	for i in 2:
		for side in ["Left", "Right"]:
			var under: float = head[i].y - _glove(i, side).y
			if under < _hu_lo:
				_hu_lo = under
				_mark("hands under: least", i, side)
			if under > _hu_hi:
				_hu_hi = under
				_mark("hands under: most", i, side)
	# 6. digs: the digger's free hand against the other's ribs - the spine_02/03 band on the side her hand meets.
	var digger: int = int(_hold["digger"])
	if digger >= 0:
		var free := _free_hand(int(_hold["who"]))
		var band := _rib_band(1 - digger, _other_side(free))
		(_hold["dig_at"] as Array).append(_dist_line(_glove(digger, free), band[0], band[1]))
	if OS.get_cmdline_user_args().has("debug"):
		var out := "    t=%.2f hh %.2f af %.2f hold %d" % [_t, head[0].distance_to(head[1]),
			hips[0].distance_to(hips[1]) - chest[0].distance_to(chest[1]), int(_hold["n"])]
		for i in 2:
			var o := 1 - i
			for side in ["L", "R"]:
				var full := "Left" if side == "L" else "Right"
				out += " | %d%s up%+.2f gh%.2f" % [i, side, head[i].y - _glove(i, full).y, _glove(i, full).distance_to(head[o])]
		var h := int(_hold["who"])
		var hs := "Right" if bool(stage.boxers[h].get("south", false)) else "Left"
		var ik: Node = stage.boxers[h]["ik"]
		var rw: float = float((((ik.get("_reach") as Dictionary)[hs]) as Dictionary)["w"])
		out += " || holder %d lead %s hand y %.2f head y %.2f reach w %.2f" % [h, hs, _bone(h, hs + "Hand").y, head[h].y, rw]
		for i in 2:
			var k: Node = stage.boxers[i].get("ik")
			for side in ["Left", "Right"]:
				var r: Dictionary = (k.get("_reach") as Dictionary)[side]
				if not bool(r["on"]):
					continue
				var c: Callable = r["target"]
				if c.is_valid():
					var tp: Vector3 = c.call()
					out += " | %d%s tgt y %.2f hand y %.2f d %.2f" % [i, side[0], tp.y, _bone(i, side + "Hand").y,
						_bone(i, side + "Hand").distance_to(tp)]
		print(out)
		print("      dig k %.2f hold %.2f digs %d digger %d" % [float(stage.clinch.call("_dig_k")), float(stage.clinch.get("_hold")),
			int(stage.clinch.get("_digs")), int(stage.clinch.get("_digger"))])
		var dg := int(_hold["digger"])
		if dg >= 0:
			var o := 1 - dg
			var side := _free_hand(int(_hold["who"]))
			var sh := _bone(dg, side + "UpperArm")
			var band := _rib_band(o, _other_side(side))
			var lo: Vector3 = band[0]
			var hi: Vector3 = band[1]
			print("      reach: shoulder->ribs lo %.2f hi %.2f | glove->band %.2f" % [sh.distance_to(lo), sh.distance_to(hi),
				_dist_line(_glove(dg, side), lo, hi)])
			var want: Vector3 = stage.clinch.call("_dig_point", o, side)
			print("      want->band %.2f glove->want %.2f" % [_dist_line(want, lo, hi),
				_glove(dg, side).distance_to(want)])


func _report() -> void:
	var voided := _holds < HOLDS_MIN
	var mins: Dictionary = {}
	for row in _rows:
		var d: Dictionary = row["min"]
		d["gh"] = row.get("gh", 999.0)
	var ov: bool = _gh >= GLOVE_HEAD_MIN_M and _gc >= GLOVE_CHEST_MIN_M
	var hd: bool = _hh_lo >= HEADS_MIN_M and _hh_hi <= HEADS_MAX_M
	var af: bool = _af >= AFRAME_MIN_M
	var hn: bool = _hu_lo >= HAND_UNDER_MIN_M and _hu_hi <= HAND_UNDER_MAX_M
	var jo := true
	var jturn := 999.0
	var jtravel := 999.0
	for row in _rows:
		jturn = minf(jturn, float(row["turn"]))
		jtravel = minf(jtravel, maxf(float((row["travel"] as Array)[0]), float((row["travel"] as Array)[1])))
		jo = jo and float(row["turn"]) >= TURN_MIN_DEG
		jo = jo and maxf(float((row["travel"] as Array)[0]), float((row["travel"] as Array)[1])) >= TRAVEL_MIN_M
	var dg := true
	for row in _rows:
		var want := int(row["digs"])
		var got := _touches(row["dig_at"])
		_digs_want += want
		_digs_hit += mini(want, got)
		dg = dg and want > 0 and got == want
	if voided:   # S354: no hold measured, no check counted.
		ov = false
		hd = false
		af = false
		hn = false
		jo = false
		dg = false
	_dig_line(_digs_hit, _digs_want, dg)
	_line("overlap", "min glove-other head %.2f m, glove-other chest %.2f m" % [_gh, _gc], ov)
	_line("heads", "head-head min %.2f max %.2f m" % [_hh_lo, _hh_hi], hd)
	_line("aframe", "pelvis gap - chest gap %.2f m" % _af, af)
	_line("hands", "glove under own head %.2f..%.2f m" % [_hu_lo, _hu_hi], hn)
	_line("jostle", "axis turn %.0f deg, pelvis travel %.2f m" % [jturn, jtravel], jo)
	print("CLINCH holds %d" % _holds)
	var n := 0
	for ok in [ov, hd, af, hn, jo, dg]:
		n += 1 if ok else 0
	print("CLINCH OK %d/6" % (0 if voided else n))
	if voided:
		print("CLINCH VOID: %d holds measured, %d needed - every line FAILS" % [_holds, HOLDS_MIN])
	# The measurements behind the six lines (this probe's own log; the six lines above are the gate).
	print("  samples %d over %d holds, %d digs wanted, %d digs reached the ribs" % [_samples, _holds, _digs_want, _digs_hit])
	for key in _at:
		var m: Array = _at[key]
		print("  worst %-18s %.2f at t=%.2f, boxer %d %s" % [key, _worst(key), float(m[0]), int(m[1]), str(m[2])])
	for row in _rows:
		print("  hold %d: holder %d digger %d digs %d | turn %.1f deg, pelvis travel %.2f/%.2f m | dig dist %s"
			% [int(row["n"]), int(row["who"]), int(row["digger"]), int(row["digs"]), float(row["turn"]),
				float((row["travel"] as Array)[0]), float((row["travel"] as Array)[1]), _series(row["dig_at"])])


func _line(what: String, body: String, ok: bool) -> void:
	print("CLINCH %-9s %-58s %s" % [what, body, "OK" if ok else "FAIL"])


func _dig_line(hit: int, want: int, ok: bool) -> void:
	print("CLINCH %-9s %-58s %s" % ["digs", "%d/%d within %.2f m of the flank" % [hit, want, DIG_TOL_M], "OK" if ok else "FAIL"])


## S354: how many separate digs reached the ribs: runs of samples at or under DIG_TOL_M, one run per dig. A hand that
## never leaves the ribs reads as one run, never as two digs.
func _touches(series: Array) -> int:
	var runs := 0
	var in_run := false
	for d in series:
		if float(d) <= DIG_TOL_M:
			if not in_run:
				runs += 1
				in_run = true
		else:
			in_run = false
	return runs


func _series(series: Array) -> String:
	var out: Array = []
	for d in series:
		out.append("%.2f" % float(d))
	return "[" + ",".join(out) + "]"


## The digs/digger of the clinch beat that is holding now (the probe counts what the BEAT asked for).
func _wanted(t: float) -> int:
	for b in BEATS:
		if str(b["move"]) == "clinch" and t >= float(b["t"]) and t < float(b["break_t"]):
			return int(b.get("digs", 0))
	return 0


func _digger(t: float) -> int:
	for b in BEATS:
		if str(b["move"]) == "clinch" and t >= float(b["t"]) and t < float(b["break_t"]):
			return 0 if str(b.get("digger", "")) == "a" else 1
	return -1


## The ribs' line point of boxer `i` on the side her `side`-named hand of the other meets: spine_02/03 height, FLANK_OUT_M
## out from her spine, a little behind the ribs' middle (Clinch._flank's own geometry).
func _flank(i: int, side: String) -> Vector3:
	var left := Vector3.UP.cross(_fwd(i)).normalized()
	var out := left if side == "Left" else -left
	return _bone(i, "Spine") + out * FLANK_OUT_M - _fwd(i) * 0.04 + Vector3.UP * FLANK_UP_M


## The other's ribs on the spine_02/03 band, on the side the `side`-named hand of the other meets: from Spine + 0.08 m
## (spine_02) out FLANK_OUT_M, up to the same offset from Chest (spine_03). Two points, because "the flank" is a band:
## the check is that the dig comes within DIG_TOL_M of it, not of one point on it.
func _rib_band(i: int, side: String) -> Array:
	var left := Vector3.UP.cross(_fwd(i)).normalized()
	var out := left if side == "Left" else -left
	var lo := _bone(i, "Spine") + out * FLANK_OUT_M - _fwd(i) * 0.04 + Vector3.UP * FLANK_UP_M
	return [lo, lo + (_bone(i, "Chest") - _bone(i, "Spine"))]


## The digger's free hand - the arm NOT in the overhook (spec 5). Read off the two bodies' own stances and the beat's
## holder, never off Clinch: the holder overhooks with her lead hand, and the woman she has tied grips with the hand that
## faces the holder's OTHER arm, so both dig with the hand on the side of the holder's own free arm.
func _free_hand(who_holds: int) -> String:
	var lead := "Right" if bool(stage.boxers[who_holds].get("south", false)) else "Left"
	return _other_side(lead)


## Facing each other, her `side` meets the other's opposite side.
static func _other_side(side: String) -> String:
	return "Right" if side == "Left" else "Left"


## Where a worst case was measured (the probe's own log line for a FAIL: which glove, which hold time).
func _mark(key: String, who: int, side: String) -> void:
	_at[key] = [_t, who, side]


func _worst(key: String) -> float:
	return {"overlap head": _gh, "overlap chest": _gc, "heads min": _hh_lo, "heads max": _hh_hi,
		"hands under: least": _hu_lo, "hands under: most": _hu_hi}.get(key, 0.0)


func _bone(i: int, bone: String) -> Vector3:
	var shown: Dictionary = (_taps[i] as SkeletonModifier3D).shown
	if shown.has(bone):
		return (stage.boxers[i]["skel"] as Skeleton3D).global_transform * (shown[bone] as Vector3)
	return (stage.boxers[i]["node"] as Node3D).global_position


func _glove(i: int, side: String) -> Vector3:
	var hand := _bone(i, side + "Hand")
	var arm := hand - _bone(i, side + "LowerArm")
	return hand + (arm.normalized() if arm.length() > 1e-5 else Vector3.UP) * GLOVE_FWD_M


func _fwd(i: int) -> Vector3:
	return (stage.boxers[i]["node"] as Node3D).global_transform.basis.z.normalized()


func _axis() -> Vector3:
	var d: Vector3 = _bone(1, "Hips") - _bone(0, "Hips")
	return d.normalized() if d.length() > 0.01 else Vector3.BACK


func _dist_line(p: Vector3, a: Vector3, b: Vector3) -> float:
	var ab := b - a
	if ab.length() < 1e-6:
		return p.distance_to(a)
	return p.distance_to(a + ab * clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0))


func _flat(v: Vector3) -> float:
	return Vector2(v.x, v.z).length()