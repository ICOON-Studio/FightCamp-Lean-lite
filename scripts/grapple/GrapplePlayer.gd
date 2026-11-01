extends Node
## S335 plays GrappleMap sequences on two of our bodies (each driven by its GrapplePose). GrappleMap stores no timing:
## keyframes are joined by Catmull-Rom curves at SEGMENT_S each (Sekai's hand-keyed clips run ~1 keyframe a 0.3-0.6 s;
## BJJ_SOURCES_S334.md), and a position (one keyframe) breathes in place. The data is one 1.8 m body for everyone, so the
## pair is scaled as ONE (keeps the contacts) by our legs over the data's (0.86 m hip to ankle), about a point on the mat.
##   play(seq, men: [GrapplePose, GrapplePose], scale, at)   then the pose follows every frame; t() / done()

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const SEGMENT_S := 0.5
const DATA_LEG_M := 0.86
const BREATH_M := 0.012

var seq: Dictionary = {}
var men: Array = []
var scale := 1.0
var at := Transform3D.IDENTITY   # where the data's mat origin lands (world)
var _t := 0.0
var _centre := Vector3.ZERO


func play(sequence: Dictionary, poses: Array, pair_scale: float, place: Transform3D) -> void:
	seq = sequence
	men = poses
	scale = pair_scale
	at = place
	_t = 0.0
	var f0: Array = (seq["frames"] as Array)[0]
	var c := ((f0[0] as PackedVector3Array)[DB.joint("Core")] + (f0[1] as PackedVector3Array)[DB.joint("Core")]) * 0.5
	_centre = Vector3(c.x, 0.0, c.z)
	_apply()


## The browser's chaining: frames already laid on the pose on screen (GrappleGraph.placed); the pair's scale and its
## centre on the mat stay, so the next move starts exactly where the last one ended.
func play_frames(frames: Array) -> void:
	seq = {"frames": frames}
	_t = 0.0
	_apply()


## The keyframe on screen now, in the data's own space (what the next move is laid onto).
func shown_frame() -> Array:
	var frames: Array = seq["frames"]
	return frames[clampi(roundi(_t / SEGMENT_S), 0, frames.size() - 1)] if length_s() > 0.0 else frames[0]


func length_s() -> float:
	return maxf(0.0, ((seq["frames"] as Array).size() - 1) * SEGMENT_S)


func t() -> float:
	return _t


func done() -> bool:
	return _t >= length_s()


func seek(time_s: float) -> void:
	_t = clampf(time_s, 0.0, length_s()) if length_s() > 0.0 else time_s
	_apply()


func _process(delta: float) -> void:
	if seq.is_empty():
		return
	_t = minf(_t + delta, length_s()) if length_s() > 0.0 else _t + delta
	_apply()


## Both men's joints (world) at time `time_s`.
func joints_at(time_s: float) -> Array:
	var frames: Array = seq["frames"]
	var out: Array = []
	for m in 2:
		var p := PackedVector3Array()
		p.resize(DB.JOINTS.size())
		if frames.size() == 1:
			var breathe := Vector3(0.0, sin(time_s * TAU / 4.0) * BREATH_M, 0.0)
			for j in DB.JOINTS.size():
				var v: Vector3 = (frames[0][m] as PackedVector3Array)[j]
				p[j] = v + (breathe if j == DB.joint("Core") or j == DB.joint("Neck") else Vector3.ZERO)
		else:
			var u := clampf(time_s / SEGMENT_S, 0.0, frames.size() - 1.0)
			var k := mini(int(u), frames.size() - 2)
			var w := smoothstep(0.0, 1.0, u - k) if frames.size() == 2 else u - k
			for j in DB.JOINTS.size():
				var a: Vector3 = (frames[maxi(k - 1, 0)][m] as PackedVector3Array)[j]
				var b: Vector3 = (frames[k][m] as PackedVector3Array)[j]
				var c: Vector3 = (frames[k + 1][m] as PackedVector3Array)[j]
				var d: Vector3 = (frames[mini(k + 2, frames.size() - 1)][m] as PackedVector3Array)[j]
				p[j] = b.cubic_interpolate(c, a, d, w)
		for j in p.size():
			p[j] = at * ((p[j] - _centre) * scale)
		out.append(p)
	return out


func _apply() -> void:
	var js := joints_at(_t)
	for m in mini(men.size(), 2):
		if men[m] != null:
			men[m].joints = js[m]


## The pair's scale for bodies of these hip-to-ankle lengths (world metres): one scale for both, the mean.
static func pair_scale(legs_m: Array) -> float:
	var s := 0.0
	for l in legs_m:
		s += float(l)
	return s / maxf(1.0, legs_m.size()) / DATA_LEG_M
