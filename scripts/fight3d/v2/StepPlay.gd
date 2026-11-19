extends RefCounted
## FIGHTPLAYER2 (S528, the owner on film 5, C434: "why the fighter do not walk ?"): every move of a body across the
## canvas is a captured boxing STEP (StepClips). Two kinds of planned step come here from the tracks:
##   - a step of the DISTANCE plan (ChoreoGap: the creep in, the step out, the ease back to rest): the man the plan names
##     plays the step take for the way he goes (in = forward, out = back), timed so the take's hips travel while the plan
##     moves him. The plan stays the authority on where a body is (the punches' distances hang on it); the take is played
##     on the spot and the leg layer (FootTake) pins the standing foot, so a step the plan makes shorter than it was
##     captured is a shorter step, never a slide;
##   - a RING step (ChoreoDrift: between exchanges both men move together, the distance held): where to is decided here,
##     when it starts, from where the pair stands in the ring - back toward the middle when it has drifted off it, away
##     from the ropes, otherwise the way the planner's roll says (along their line: one walks the other down; across
##     it: both step to the same side). The pair's middle moves; each man plays the step for his own direction.
## A step never starts under a punch, a defence or a reaction of his that is due before it would end.

const TAKES := {"fwd": ["st_fwd_s"], "back": ["st_back_s", "st_back_m"], "left": ["st_left_s", "st_left_m", "st_left_l"],
	"right": ["st_right_s", "st_right_m", "st_right_l"]}
const RATE := Vector2(0.75, 1.5)   # how much slower / faster than captured a step take may play
const LEAD_S := 0.06               # the take is started this long before its hips begin to travel
const MIN_M := 0.07                # a move shorter than this is a weight shift, not a step
const ALONG_M := 0.36              # a ring step along the pair's line (one forward, one back)
const SIDE_M := 0.34               # ... and across it (both to the same side)
const CENTRE_M := 0.9              # the pair's middle further than this from the ring's: the next ring step heads back
const EDGE_M := 0.75               # no ring step puts a man closer to the ropes than this
const BUSY := ["punch", "reaction", "block", "defence", "pass"]

var p: Node = null                 # Player2
var steps: Dictionary = {}         # foot_db "steps": take -> {length_s, travel [fwd, side], move_s [from, to]}
var walked := 0.0                  # metres the pair's middle has been walked (probes)
var played := 0                    # step takes started (probes)
var _seg: Array = []               # ring steps under way: {t0, t1, vec, s}
var _vec := {}                     # ring step id -> where it goes (decided when its first man starts)
var _last := Vector3.ZERO


func _init(player: Node) -> void:
	p = player


func reset() -> void:
	_seg = []
	_vec = {}


## A step event of boxer i's track.
func start(i: int, e: Dictionary) -> void:
	if not (str(p._take[i].get("kind", "")) in p.WAITING) or _busy_soon(i, float(e["end_t"])):
		return
	var dir := ""
	var dist := 0.0
	if e.has("drift"):
		var v := _ring(e)
		if v == Vector3.ZERO:
			return
		var to: Vector3 = (p._home[1 - i] as Vector3) - (p._home[i] as Vector3)
		to.y = 0.0
		if to.length() < 0.05:
			return
		to = to.normalized()
		var along := v.dot(to)
		var across := v.dot(Vector3.UP.cross(to))   # + = to his own left
		if absf(along) >= absf(across):
			dir = "fwd" if along > 0.0 else "back"
			dist = absf(along)
		else:
			dir = "left" if across > 0.0 else "right"
			dist = absf(across)
	else:
		dir = "fwd" if float(e["m"]) < 0.0 else "back"
		dist = absf(float(e["m"])) * float(e.get("share", 1.0))
	if dist < MIN_M:
		return
	if bool(p.st.boxers[i].get("south", false)) and dir in ["left", "right"]:
		dir = "right" if dir == "left" else "left"   # his library is mirrored
	var clip := pick(dir, dist, func(c: String) -> bool: return p._has(i, c))
	if clip == "":
		return
	var mv: Array = steps[clip]["move_s"]
	var dur := maxf(float(e["end_t"]) - p.t, 0.15)
	var rate := clampf((float(mv[1]) - float(mv[0])) / dur, RATE.x, RATE.y)
	p._play(i, clip, maxf(float(mv[0]) - LEAD_S * rate, 0.0), "step", false)
	(p.st.boxers[i]["ap"] as AnimationPlayer).speed_scale = rate
	played += 1


## The step take for `dir` whose captured travel is nearest `dist`.
func pick(dir: String, dist: float, has: Callable) -> String:
	var best := ""
	var best_d := INF
	for c in TAKES.get(dir, []):
		if not steps.has(c) or not has.call(c):
			continue
		var tr: Array = steps[c]["travel"]
		var d := absf(Vector2(float(tr[0]), float(tr[1])).length() - dist)
		if d < best_d:
			best_d = d
			best = str(c)
	return best


## A punch, a defence or a reaction of his is due before `end_t`: the step would be cut in the air.
func _busy_soon(i: int, end_t: float) -> bool:
	var track: Array = p.plan["tracks"]["a" if i == 0 else "b"]
	for k in range(int(p._next[i]) + 1, track.size()):
		if float(track[k]["t"]) > end_t - 0.05:
			return false
		if str(track[k]["kind"]) in BUSY:
			return true
	return false


## Where ring step `e` takes the pair's middle (decided once, by the first man to start it).
func _ring(e: Dictionary) -> Vector3:
	var id := int(e["drift"])
	if _vec.has(id):
		return _vec[id]
	var a: Vector3 = p._home[0]
	var b: Vector3 = p._home[1]
	var line := Vector3(b.x - a.x, 0.0, b.z - a.z)
	var v := Vector3.ZERO
	if line.length() > 0.3:
		var axis := line.normalized()
		var across := Vector3.UP.cross(axis)
		var edge: float = float(p.st.RING_M) * 0.5 - EDGE_M
		var ok: Array = []
		for o in [axis * ALONG_M, -axis * ALONG_M, across * SIDE_M, -across * SIDE_M]:
			var fits := true
			for h in [a, b]:
				var to: Vector3 = h + o
				var now := maxf(absf(h.x), absf(h.z))
				fits = fits and (maxf(absf(to.x), absf(to.z)) <= edge or maxf(absf(to.x), absf(to.z)) < now)
			if fits:
				ok.append(o)
		var mid := (a + b) * 0.5
		mid.y = 0.0
		if not ok.is_empty():
			if mid.length() > CENTRE_M:
				v = ok[0]
				for o in ok:
					if (mid + o).length() < (mid + v).length():
						v = o
			else:
				var fresh: Array = ok.filter(func(o): return (o as Vector3).dot(_last) > -0.01)   # not straight back where they came from
				var pool: Array = fresh if not fresh.is_empty() else ok
				v = pool[clampi(int(float(e.get("roll", 0.0)) * pool.size()), 0, pool.size() - 1)]
	_vec[id] = v
	if v != Vector3.ZERO:
		_last = v
		_seg.append({"t0": float(e["t"]), "t1": float(e["end_t"]), "vec": v, "s": 0.0})
	return v


## The ring steps under way move the pair's middle (both bodies, the distance untouched).
func follow() -> void:
	var k := 0
	while k < _seg.size():
		var g: Dictionary = _seg[k]
		var u := clampf((p.t - float(g["t0"])) / maxf(float(g["t1"]) - float(g["t0"]), 0.05), 0.0, 1.0)
		var s := u * u * (3.0 - 2.0 * u)
		var by: Vector3 = (g["vec"] as Vector3) * (s - float(g["s"]))
		g["s"] = s
		if by != Vector3.ZERO:
			p.pair._shift(0, by)
			p.pair._shift(1, by)
			walked += by.length()
		if u >= 1.0:
			_seg.remove_at(k)
		else:
			k += 1
