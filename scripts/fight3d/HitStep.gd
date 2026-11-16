extends RefCounted
## A landed punch moves the hit boxer back a little (pure rule, no wiring).
## kind() classifies the hit; back_m() / over_s() say how far and how long;
## at() is the smoothstep fraction; moved() combines them.

const BACK_M := {"jab": 0.03, "power": 0.10, "body": 0.16, "big": 0.22}
const OVER_S := {"jab": 0.12, "power": 0.20, "body": 0.22, "big": 0.30}
const MAX_MPS := 1.4


static func kind(move: String, big: bool) -> String:
	if big:
		return "big"
	if move.contains("body") or move.contains("kidney"):
		return "body"
	if move.contains("jab"):
		return "jab"
	return "power"


static func back_m(move: String, big: bool, room_m: float = 99.0) -> float:
	if OS.get_cmdline_user_args().has("nohitstep"):
		return 0.0
	var k: String = kind(move, big)
	var raw: float = float(BACK_M[k])
	var cap: float = maxf(room_m, 0.0)
	return minf(raw, cap)


static func over_s(move: String, big: bool) -> float:
	var k: String = kind(move, big)
	var base: float = float(OVER_S[k])
	var bm: float = float(BACK_M[k])
	var min_over: float = bm * 1.5 / MAX_MPS
	return maxf(base, min_over)


static func at(t: float, over: float) -> float:
	if over <= 0.0:
		return 1.0
	if t <= 0.0:
		return 0.0
	if t >= over:
		return 1.0
	var u: float = t / over
	return u * u * (3.0 - 2.0 * u)


static func moved(move: String, big: bool, t: float, room_m: float = 99.0) -> float:
	var bm: float = back_m(move, big, room_m)
	var ov: float = over_s(move, big)
	return bm * at(t, ov)


## ---- The wiring (S500): the rule above, run on a boxer's own dictionary. Nothing here reads the stage. ----
## start() at a clean landed punch, tick() once a frame moves the place, lean() is the body's rock back over feet
## that have not stepped yet, speed() times the step pair that follows. `-- nohitstep` makes back_m 0: nothing starts.
const LEAN_MAX_M := 0.08   # the body rocks back this far over planted feet; past it the feet must step
const LEAN_OUT_S := 0.25   # after the step back is over the rock eases out (the feet stand under the place by then)


## How far `at` can go along `dir` before the ropes (a square ring, `edge_m` from its middle to where the hips may stand).
static func room(at: Vector3, dir: Vector3, edge_m: float) -> float:
	var best: float = 99.0
	for k in [0, 2]:
		var d: float = dir[k]
		if absf(d) > 0.0001:
			best = minf(best, ((edge_m if d > 0.0 else -edge_m) - at[k]) / d)
	return maxf(best, 0.0)


## A clean punch from a boxer standing at `from` landed on `bx`: the step back starts (a new hit replaces one in flight).
static func start(bx: Dictionary, from: Vector3, move: String, big: bool, edge_m: float) -> void:
	var at: Vector3 = bx["pos"]
	var dir := Vector3(at.x - from.x, 0.0, at.z - from.z)
	if dir.length() < 0.01:
		return
	dir = dir.normalized()
	var m: float = back_m(move, big, room(at, dir, edge_m))
	if m <= 0.0:
		return
	bx["knock"] = {"dir": dir, "m": m, "over": over_s(move, big), "t": 0.0, "done": 0.0, "w": 1.0}


## One frame: how far the place moves (add it to bx["pos"]). Zero when no step back is running.
static func tick(bx: Dictionary, delta: float) -> Vector3:
	var k: Dictionary = bx.get("knock", {})
	if k.is_empty() or delta <= 0.0:
		return Vector3.ZERO
	k["t"] = float(k["t"]) + delta
	var want: float = float(k["m"]) * at(float(k["t"]), float(k["over"]))
	var step: Vector3 = (k["dir"] as Vector3) * (want - float(k["done"]))
	k["done"] = want
	if float(k["t"]) >= float(k["over"]):
		k["w"] = move_toward(float(k["w"]), 0.0, delta / LEAN_OUT_S)
		if float(k["w"]) <= 0.0:
			bx.erase("knock")
	return step


## How fast the place is going back now (m/s): the feet's step pair is timed on it. 0 once it has arrived.
static func speed(bx: Dictionary) -> float:
	var k: Dictionary = bx.get("knock", {})
	if k.is_empty() or float(k["t"]) >= float(k["over"]):
		return 0.0
	return 1.5 * float(k["m"]) / float(k["over"])


## The rock back: `lag` is the place minus where the body is shown over its feet. The body goes back with the blow at
## once, up to LEAN_MAX_M, and only along the blow's line; the feet step after it and the rock eases out.
static func lean(bx: Dictionary, lag: Vector3) -> Vector3:
	var k: Dictionary = bx.get("knock", {})
	if k.is_empty():
		return Vector3.ZERO
	var dir: Vector3 = k["dir"]
	return dir * clampf(lag.dot(dir), 0.0, LEAN_MAX_M) * float(k["w"])
