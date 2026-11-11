extends RefCounted
## S436 INTROSTYLE (operator S434: "add some celebrating animations or shadow boxing during the introduction and do not
## make each fighters animations identical"). Pure: what each boxer does in her corner before the bell, from her
## personality and the bout's seed. No scene, no nodes.
## The wait is cut into segments of SEG_S; each segment is one KIND of thing (celebrate, shadow-box, bounce, fidget) and
## one clip of that kind. Both corners' segments start at the same moments, and at every segment the second boxer is
## refused the first one's clip: the two never play the same clip at the same time, and never the same name call.
##   plan_pair(pers_red, pers_blue, seed, has, length) -> [plan, plan]
##   plan = {style, warm: [{kind, clip, from, to}], name: {clip, from, to, raise_s}, hold}
##   name.clip "" = she raises a glove over `hold` for raise_s seconds (FightIntro's hand IK); else a celebration clip.

const SEG_S := 3.7           # a segment's length: FightIntro shows each corner once in the first two
const NAME_S := 3.0          # the name call's length
const KINDS := {
	"win": ["pro_win_v1", "pro_win_v2", "pro_win_v3", "pro_win_v4", "pro_win_v5", "pro_win_v6", "pro_win_v7", "mc_win"],
	"shadow": ["rk_shadowboxing_a", "rk_shadowboxing_b", "rk_boxing", "cmu_13_17", "cmu_13_18", "cmu_14_01", "cmu_14_02"],
	"bounce": ["ow_bounce_idle"],
	"fidget": ["pro_idle_fidget_v1", "pro_idle_fidget_v8", "mc_fidget", "pro_idle_fidget_v4", "pro_idle_fidget_v3"],
}
## What each style does, segment by segment (it repeats if the wait is longer), and how she takes her name.
const RECIPE := {
	"showman": {"warm": ["win", "bounce", "shadow", "win"], "name": "win"},        # plays to the crowd
	"worker": {"warm": ["shadow", "bounce", "shadow", "shadow"], "name": "raise"},  # stays busy, one glove up
	"nervous": {"warm": ["fidget", "bounce", "fidget", "shadow"], "name": "nod"},   # cannot stand still, a quick glove
	"default": {"warm": ["bounce", "shadow", "fidget", "shadow"], "name": "raise"},
}
const RAISE_S := {"raise": 2.4, "nod": 1.2}
const HOLD := ["ow_bounce_idle", "pro_idle"]
const FALLBACK := ["shadow", "fidget", "bounce", "win"]   # a kind with no clip left takes the next of these


## showman: sure of herself or hot-headed; worker: disciplined; nervous: low confidence; else default.
static func classify(personality: Dictionary) -> String:
	var conf := float(personality.get("confidence", 55.0))
	var disc := float(personality.get("discipline", 55.0))
	var temp := float(personality.get("temper", 55.0))
	if conf >= 65.0 or temp >= 65.0:
		return "showman"
	if disc >= 60.0:
		return "worker"
	if conf < 45.0:
		return "nervous"
	return "default"


## The opponent carries no personality: one is made from her name, always the same for the same name.
static func from_name(nm: String) -> Dictionary:
	var h := absi(nm.hash())
	return {"confidence": 35.0 + float(h % 41), "discipline": 35.0 + float((h / 41) % 41), "temper": 35.0 + float((h / 1681) % 41)}


## One boxer's plan. `avoid` = the other corner's plan (her clips are refused segment by segment), {} for the first.
## `segments` = how many segments of warm-up to plan.
static func plan(personality: Dictionary, seed: int, has: Callable, length: Callable, avoid: Dictionary = {}, segments: int = 4) -> Dictionary:
	var style := classify(personality)
	var recipe: Dictionary = RECIPE[style]
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var warm: Array = []
	var used: Array = []
	for k in segments:
		var kind := str((recipe["warm"] as Array)[k % (recipe["warm"] as Array).size()])
		var other := ""
		if avoid.has("warm") and k < (avoid["warm"] as Array).size():
			other = str(((avoid["warm"] as Array)[k] as Dictionary).get("clip", ""))
		var got := _pick(kind, rng, has, [other], used)
		if got.is_empty():
			continue
		used.append(got[1])
		var w := _window(float(length.call(got[1])), rng, SEG_S, got[0] == "win")
		warm.append({"kind": got[0], "clip": got[1], "from": w.x, "to": w.y})
	var name := {"clip": "", "from": 0.0, "to": 0.0, "raise_s": float(RAISE_S.get(str(recipe["name"]), 2.4))}
	if str(recipe["name"]) == "win":
		var other_name := str((avoid.get("name", {}) as Dictionary).get("clip", ""))
		var got := _pick("win", rng, has, [other_name], used, false)
		if not got.is_empty() and got[0] == "win":
			var w := _window(float(length.call(got[1])), rng, NAME_S, true)
			name = {"clip": got[1], "from": w.x, "to": w.y, "raise_s": 0.0}
	var hold := ""
	for c in HOLD:
		if bool(has.call(c)):
			hold = c
			break
	return {"style": style, "warm": warm, "name": name, "hold": hold}


## Both corners: the red plan first, the blue one refused red's clip at every segment and red's name call.
static func plan_pair(pers_red: Dictionary, pers_blue: Dictionary, bout_seed: int, has: Callable, length: Callable, segments: int = 4) -> Array:
	var red := plan(pers_red, bout_seed * 2, has, length, {}, segments)
	var blue := plan(pers_blue, bout_seed * 2 + 1, has, length, red, segments)
	return [red, blue]


## Seconds the two plans show the same clip in the same segment (the test's bar: 0).
static func same_clip_s(a: Dictionary, b: Dictionary) -> float:
	var out := 0.0
	var wa: Array = a.get("warm", [])
	var wb: Array = b.get("warm", [])
	for k in mini(wa.size(), wb.size()):
		if str(wa[k]["clip"]) == str(wb[k]["clip"]):
			out += SEG_S
	var na := str((a.get("name", {}) as Dictionary).get("clip", ""))
	if na != "" and na == str((b.get("name", {}) as Dictionary).get("clip", "")):
		out += NAME_S
	return out


## [kind, clip] of `kind` that exists, is not in `refuse` and (if it can) not one she already used; else the next kind
## of FALLBACK (unless `fall` is off). [] when nothing exists at all.
static func _pick(kind: String, rng: RandomNumberGenerator, has: Callable, refuse: Array, used: Array, fall: bool = true) -> Array:
	var order: Array = [kind]
	if fall:
		for f in FALLBACK:
			if f != kind:
				order.append(f)
	for kd in order:
		var pool: Array = (KINDS[kd] as Array).filter(func(c): return bool(has.call(c)) and not refuse.has(c))
		if pool.is_empty():
			continue
		var fresh: Array = pool.filter(func(c): return not used.has(c))
		var from: Array = fresh if not fresh.is_empty() else pool
		return [kd, str(from[rng.randi() % from.size()])]
	return []


## A window of `want_s` inside a clip (the whole clip when it is shorter: FightIntro loops it inside the segment).
## `late`: a celebration take opens in her guard (S436 still: a name call filmed on a boxer hiding behind her gloves), so
## its window starts past the first third.
static func _window(clip_len: float, rng: RandomNumberGenerator, want_s: float, late: bool = false) -> Vector2:
	if clip_len <= want_s or clip_len <= 0.0:
		return Vector2(0.0, maxf(clip_len, 0.0))
	var start := rng.randf_range(0.0, clip_len - want_s)
	if late:
		start = clampf(clip_len * 0.35, 0.0, clip_len - want_s)
	return Vector2(start, start + want_s)
