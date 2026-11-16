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
