extends RefCounted
## S379 (operator on the board's animation previews: "the camrea spins too fast on the clips wtf, it got me dizzy"): the
## preview cameras turned a full 360 deg over every clip whatever its length (a 3 s move = 120 deg/s). Now a slow drift: at
## most MAX_DEG_PER_S, never more than MAX_SWEEP_DEG in total, eased in and out (no jolt at the start or end).
const MAX_DEG_PER_S := 10.0
const MAX_SWEEP_DEG := 60.0


## The camera's turn (radians) at frame f of `frames`, filmed at `fps`.
static func angle(f: int, frames: int, fps: float) -> float:
	var secs := float(maxi(frames - 1, 1)) / maxf(fps, 1.0)
	var sweep := minf(MAX_SWEEP_DEG, MAX_DEG_PER_S * secs)
	return deg_to_rad(sweep) * smoothstep(0.0, 1.0, float(f) / float(maxi(frames - 1, 1)))
