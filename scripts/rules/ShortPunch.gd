extends RefCounted
## ShortPunch - inside-range punch math (pure module).
##
## Up close (chest to chest), punches travel 15-30 cm, not the 60-90 cm of long-range clips.
## Given a punch clip's fist path (cumulative distance vs clip time), this module computes where
## to start the clip so only the last want_m of fist travel plays before contact.
##
## PURE: zero preloads, no autoload, no Node access, no file/network access.

const TRAVEL_M := {"lead_hook": 0.25, "rear_hook": 0.25, "lead_uppercut": 0.20, "rear_uppercut": 0.20,
	"body_hook": 0.22, "jab": 0.20, "cross": 0.22}
const MIN_M := 0.15
const MAX_M := 0.30
const MIN_WIND_S := 0.08


## Fist travel for this punch up close: TRAVEL_M[move] (unknown -> 0.22) plus (roll - 0.5) * 0.08,
## clamped to [MIN_M, MAX_M]. roll is 0..1 (the beat's random roll).
static func want(move: String, roll: float) -> float:
	var base: float = TRAVEL_M.get(move, 0.22)
	return clampf(base + (roll - 0.5) * 0.08, MIN_M, MAX_M)


## How far the fist has travelled (metres) by clip time t. Linear interpolation between samples;
## before the first sample -> first cum; after the last -> last cum; empty path -> 0.0.
static func path_at(path: Array, t: float) -> float:
	if path.is_empty():
		return 0.0
	if t <= path[0][0]:
		return path[0][1]
	var n: int = path.size()
	if t >= path[n - 1][0]:
		return path[n - 1][1]
	for i in range(n - 1):
		var t0: float = path[i][0]
		var t1: float = path[i + 1][0]
		if t <= t1:
			var c0: float = path[i][1]
			var c1: float = path[i + 1][1]
			var dt: float = t1 - t0
			if dt < 0.0001:
				return c0
			return c0 + (t - t0) / dt * (c1 - c0)
	return path[n - 1][1]


## The clip time to start at so the fist travels want_m before contact. Searches back from contact_s
## for the time s where path_at(contact_s) - path_at(s) == want_m. Clamped so at least MIN_WIND_S
## of real time remains before contact. Returns 0.0 if the path is too short or empty.
static func skip(path: Array, contact_s: float, want_m: float, speed: float = 1.0) -> float:
	if path.is_empty() or contact_s <= 0.0:
		return 0.0
	var contact_cum: float = path_at(path, contact_s)
	var first_cum: float = path[0][1]
	if contact_cum - first_cum < want_m:
		return 0.0
	var target_cum: float = contact_cum - want_m
	var n: int = path.size()
	var idx: int = 0
	for i in range(n - 1, -1, -1):
		if path[i][0] <= contact_s:
			idx = i
			break
	for i in range(idx, -1, -1):
		var c_i: float = path[i][1]
		if c_i <= target_cum:
			var t_i: float = path[i][0]
			var t_next: float
			var c_next: float
			if i + 1 < n and path[i + 1][0] <= contact_s:
				t_next = path[i + 1][0]
				c_next = path[i + 1][1]
			else:
				t_next = contact_s
				c_next = contact_cum
			var dc: float = c_next - c_i
			var max_start: float = maxf(0.0, contact_s - MIN_WIND_S * speed)
			if abs(dc) < 0.0001:
				return clampf(t_i, 0.0, max_start)
			var frac: float = (target_cum - c_i) / dc
			return clampf(t_i + frac * (t_next - t_i), 0.0, max_start)
	return 0.0


## Both the combo rhythm and the short punch skip into the clip; the later start wins.
static func merge(combo_skip: float, short_skip: float) -> float:
	return maxf(combo_skip, short_skip)
