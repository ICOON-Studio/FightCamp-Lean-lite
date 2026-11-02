extends RefCounted
## S370 every gain carries its cause (S367 critic: "decimal gains make a week feel like nothing happened"; praised sims name
## why a number moved - S370_MENUS_RESEARCH.md). The week's sessions are tallied per stat as they land (Sim.step_day), and
## the week review says which ones moved each stat: "Heavy bag x3, Strength circuit x1". Pure static functions.
##   add(src, stat, session_name, points)   words(src, stat) -> String   top(src, stat) -> [[name, times, points], ...]

const SHOWN := 2   # the review names the two sessions that did the most


## Tallies one session's gain on one stat into `src` ({stat: {session: [times, points]}}).
static func add(src: Dictionary, stat: String, session_name: String, points: float) -> void:
	if stat == "" or session_name == "" or points <= 0.0:
		return
	var per: Dictionary = src.get_or_add(stat, {})
	var row: Array = per.get(session_name, [0, 0.0])
	per[session_name] = [int(row[0]) + 1, float(row[1]) + points]


## The sessions that moved `stat`, most points first (ties by name): [[name, times, points], ...].
static func top(src: Dictionary, stat: String) -> Array:
	var out: Array = []
	var per: Dictionary = src.get(stat, {})
	for k in per.keys():
		out.append([str(k), int(per[k][0]), float(per[k][1])])
	out.sort_custom(func(a: Array, b: Array) -> bool:
		return a[2] > b[2] if not is_equal_approx(float(a[2]), float(b[2])) else str(a[0]) < str(b[0]))
	return out


## "from Heavy bag x3, Strength circuit x1" - or "" when nothing trained it this week.
static func words(src: Dictionary, stat: String) -> String:
	var rows := top(src, stat)
	if rows.is_empty():
		return ""
	var parts: Array = []
	for r in rows.slice(0, SHOWN):
		parts.append("%s x%d" % [r[0], int(r[1])])
	return "from " + ", ".join(parts)
