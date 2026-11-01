extends RefCounted
## S336 how long each keyframe gap of a GrappleMap move lasts (GrappleMap stores no timing; BJJ_SOURCES_S334.md "We set
## the timing ourselves"). An animator's spacing: a gap lasts as long as its largest joint move takes at SPEED, either
## man, the Core and hips counting double (a big body shift is slow, a hand flick is fast), clamped to [MIN_S, MAX_S].
## SPEED is calibrated on the Sekai clip lengths with the closest GrappleMap moves chained start to finish (kimura from
## side control 4.8 s, americana 5.2 s, toreando 10.0 s, back take 7.9 s): all four within 25%, the median gap ~0.7 s,
## and fewer than 1 gap in 10 on a clamp (tests/grapple_timing_test.gd prints the matches). Pure: no scene.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const SPEED := 0.8   # metres a second of the gap's largest (weighted) joint move
const MIN_S := 0.18
const MAX_S := 1.2
const HEAVY := ["Core", "LeftHip", "RightHip"]
const HEAVY_WEIGHT := 2.0


## One duration per gap, frames.size() - 1 of them (none for a position). frames: Array of [man0, man1] joints.
static func durations(frames: Array) -> PackedFloat32Array:
	var heavy := HEAVY.map(func(n): return DB.joint(n))
	var out := PackedFloat32Array()
	for k in frames.size() - 1:
		var far := 0.0
		for m in 2:
			var a: PackedVector3Array = frames[k][m]
			var b: PackedVector3Array = frames[k + 1][m]
			for j in a.size():
				far = maxf(far, a[j].distance_to(b[j]) * (HEAVY_WEIGHT if heavy.has(j) else 1.0))
		out.append(clampf(far / SPEED, MIN_S, MAX_S))
	return out


## When each keyframe is reached: 0, then the durations summed (frames.size() of them; [0.0] for a position).
static func key_times(frames: Array) -> PackedFloat32Array:
	var out := PackedFloat32Array([0.0])
	for d in durations(frames):
		out.append(out[out.size() - 1] + d)
	return out
