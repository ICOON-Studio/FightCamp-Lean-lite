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

const RootPath := preload("res://scripts/fight3d/v2/RootPath.gd")

## S529 (film 6, both critics: "a fencing lunge", "stance width jumps", 120 steps a minute that "lead nowhere"): the
## step takes played are the REFITTED ones (StepClips.REFIT: the guard's own stance and height, a boxing step's length;
## as bought the actor's short step forward was 0.51 m from a stance 25 % wider and 8 cm lower than the guard, so
## the feet were over 1.3 x the guard's spread in half of all frames). A take is played from its FIRST frame (it starts
## in the guard's stance now: nothing to join into mid-swing) and is never shorter than the move it carries.
const TAKES := {"fwd": ["st_in_s", "st_in_m"], "back": ["st_out_s", "st_out_m"], "left": ["st_l_s", "st_l_m"],
	"right": ["st_r_s", "st_r_m"]}
const RATE := Vector2(0.75, 1.5)   # how much slower / faster than captured a step take may play
const SHORT_OK_M := 0.03           # a take this much shorter than the move still carries it
const LEAD_S := 0.06               # a plan step's take is started this long before its hips begin to travel
const MIN_M := 0.07                # a move shorter than this is a weight shift, not a step
const KICK_M := 0.12               # a move under a take this long gets the leg layer's step at once (`-- fp2nokick` = off)
## A ring step along the pair's line (one forward, one back) and across it (both to the same side): a small one or a
## longer one (the refitted takes' own lengths), by the planner's roll.
const ALONG_M := Vector2(0.23, 0.35)
const SIDE_M := Vector2(0.20, 0.34)
const CENTRE_M := 0.9              # the pair's middle further than this from the ring's: the next ring step heads back
## S530 ANGLES: this share of the ring steps CIRCLE - both men take the side step to the same hand (each man's own
## right, or each man's own left), so the pair's line turns about its middle; each foot covers CIRCLE_M of arc (17 deg
## at the rest distance). Past CIRCLE_BACK_DEG off side-on the next circle goes back the other way (PairPlace.SLACK_DEG).
const CIRCLE_SHARE := 0.5
const CIRCLE_M := 0.20
const CIRCLE_BACK_DEG := 8.0
const EDGE_M := 0.75               # no ring step puts a man closer to the ropes than this
const BUSY := ["punch", "reaction", "block", "defence", "pass"]

var p: Node = null                 # Player2
var steps: Dictionary = {}         # foot_db "steps": take -> {length_s, travel [fwd, side], move_s [from, to]}
var walked := 0.0                  # metres the pair's middle has been walked (probes)
var played := 0                    # step takes started (probes)
var kicked := 0                    # steps started under a take (probes)
var kick_on: bool = not OS.get_cmdline_user_args().has("fp2nokick")
var _seg: Array = []               # ring steps under way: {i, clip, vec, s} (the leader's take carries the pair)
var _own: Array = []               # plan steps under way: {i, clip, t0, t1, d} (his take carries his share of the move)
var _vec := {}                     # ring step id -> where it goes (decided when its first man starts)
var _turn := {}                    # ring step id -> the turn of the pair's line, radians (a circle step; 0 = a straight one)
var circled := 0                   # circle steps started (probes)
var _last := Vector3.ZERO


func _init(player: Node) -> void:
	p = player


func reset() -> void:
	_seg = []
	_vec = {}
	_turn = {}
	_own = []


## A step event of boxer i's track.
func start(i: int, e: Dictionary) -> void:
	if not (str(p._take[i].get("kind", "")) in p.WAITING) or _busy_soon(i, float(e["end_t"])):
		# S529 THE STEP UNDER A PUNCH (film 6, coach 1: "every lead punch starts with a step of the lead foot that
		# lands on the contact frame"): he cannot play a step take (a punch of his has him, or is about to), so the
		# plan slides his body under the take he is in. The leg layer's own step used to start only once the body had
		# left a foot 17 cm behind - late, any foot. It starts NOW, on the plan's clock, with the foot a boxer moves
		# first (the lead foot going in, the rear foot going out); the other follows when it is left behind.
		if kick_on and not e.has("drift") and p._ft[i] != null and absf(float(e["m"])) * float(e.get("share", 1.0)) >= KICK_M:
			var lead := 1 if bool(p.st.boxers[i].get("south", false)) else 0
			p._ft[i].kick(lead if float(e["m"]) < 0.0 else 1 - lead)
			kicked += 1
		return
	var dir := ""
	var dist := 0.0
	var fresh := false   # a ring step this man is the first to start: its window is his take's
	if e.has("drift"):
		fresh = not _vec.has(int(e["drift"]))
		var v := _ring(e)
		var th: float = float(_turn.get(int(e["drift"]), 0.0))
		if v == Vector3.ZERO and th == 0.0:
			return
		var to: Vector3 = (p._home[1 - i] as Vector3) - (p._home[i] as Vector3)
		to.y = 0.0
		if to.length() < 0.05:
			return
		to = to.normalized()
		var along := v.dot(to)
		var across := v.dot(Vector3.UP.cross(to))   # + = to his own left
		if th != 0.0:
			dir = "right" if th > 0.0 else "left"   # a turn about +Y takes both men to their own right
			dist = CIRCLE_M
		elif absf(along) >= absf(across):
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
	if e.has("drift"):
		# a ring step is the take's own: from its first frame, at its own pace or a little quicker
		var rate := clampf(float(mv[1]) / dur, 1.0, RATE.y)
		p._play(i, clip, 0.0, "step", false)
		(p.st.boxers[i]["ap"] as AnimationPlayer).speed_scale = rate
		if fresh:   # the pair's middle moves as his take's hips travel (the other man answers a few frames later)
			_seg.append({"i": i, "clip": clip, "vec": _vec[int(e["drift"])], "s": 0.0, "turn": float(_turn.get(int(e["drift"]), 0.0))})
			if float(_turn.get(int(e["drift"]), 0.0)) != 0.0:
				circled += 1
				if p.log_on:
					print("FP2 %6.2f circle %+.0f deg (the line is %+.0f deg off side-on)" % [p.t, rad_to_deg(float(_turn[int(e["drift"])])), rad_to_deg(p.pair.off_side())])
	else:
		# a step of the distance plan: the take's travel timed onto the plan's ramp; while it plays the BODY goes by the
		# take's own hips (want), so the feet and the body keep one clock
		var rate := clampf((float(mv[1]) - float(mv[0])) / dur, RATE.x, RATE.y)
		p._play(i, clip, maxf(float(mv[0]) - LEAD_S * rate, 0.0), "step", false)
		(p.st.boxers[i]["ap"] as AnimationPlayer).speed_scale = rate
		_own.append({"i": i, "clip": clip, "t0": p.t, "t1": float(e["end_t"]), "d": float(e["m"]) * float(e.get("share", 1.0))})
	played += 1


## How much of its hip travel boxer i's step take `clip` has made (0..1); -1 when he is no longer in it.
func _frac(i: int, clip: String) -> float:
	var ap: AnimationPlayer = p.st.boxers[i]["ap"]
	if str(ap.current_animation) != clip or str(p._take[i].get("kind", "")) != "step":
		return -1.0
	var path := RootPath.of(ap.get_animation(clip))
	if path.is_empty():
		return -1.0
	var a := RootPath.at(path, float(p._take[i].get("from_s", 0.0)))
	var whole := RootPath.at(path, 99.0) - a
	if whole.length() < 0.01:
		return 1.0
	return clampf((RootPath.at(path, ap.current_animation_position) - a).dot(whole) / whole.length_squared(), 0.0, 1.0)


## The distance the bodies go to now: the plan's, but a step under way is carried by its take's own hip travel instead
## of the plan's ramp (S529, film 6's knee ruler: the plan had moved the body its whole step before the take lifted the
## last foot - the leg at its reach, then a foot covering 0.35 m in five frames). When the take ends, or is cut, the
## plan has the rest.
func want(planned: float) -> float:
	var w := planned
	var k := 0
	while k < _own.size():
		var o: Dictionary = _own[k]
		var f := _frac(int(o["i"]), str(o["clip"]))
		var u := clampf((p.t - float(o["t0"])) / maxf(float(o["t1"]) - float(o["t0"]), 0.05), 0.0, 1.0)
		if f < 0.0 or (f >= 1.0 and u >= 1.0):
			_own.remove_at(k)
			continue
		w += float(o["d"]) * (f - u * u * (3.0 - 2.0 * u))
		k += 1
	return w


## Who covers the ground now: the plan's man; in a hold of the plan, the man whose step take is still travelling.
func mover(planned: String) -> String:
	if planned != "" or _own.is_empty():
		return planned
	var who := [false, false]
	for o in _own:
		who[int(o["i"])] = true
	return "both" if who[0] and who[1] else ("a" if who[0] else "b")


## The step take for `dir`: the shortest whose captured travel covers `dist` (a longer take played shorter closes its
## legs; a shorter take played longer left its last foot to catch up in a jerk - film 6's knee ruler), else the longest.
func pick(dir: String, dist: float, has: Callable) -> String:
	var best := ""
	var best_m := INF
	var longest := ""
	var longest_m := -1.0
	for c in TAKES.get(dir, []):
		if not steps.has(c) or not has.call(c):
			continue
		var tr: Array = steps[c]["travel"]
		var m := Vector2(float(tr[0]), float(tr[1])).length()
		if m > longest_m:
			longest_m = m
			longest = str(c)
		if m >= dist - SHORT_OK_M and m < best_m:
			best_m = m
			best = str(c)
	return best if best != "" else longest


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
		var big := fmod(float(e.get("roll", 0.0)) * 7.0, 1.0) < 0.5
		var along := ALONG_M.y if big else ALONG_M.x
		var side := SIDE_M.y if big else SIDE_M.x
		for o in [axis * along, -axis * along, across * side, -across * side]:
			var fits := true
			for h in [a, b]:
				var to: Vector3 = h + o
				var now := maxf(absf(h.x), absf(h.z))
				fits = fits and (maxf(absf(to.x), absf(to.z)) <= edge or maxf(absf(to.x), absf(to.z)) < now)
			if fits:
				ok.append(o)
		var mid := (a + b) * 0.5
		mid.y = 0.0
		# S530 a circle: when the pair is not on its way back to the middle, and both men keep their room
		if p.pair.circle_on and mid.length() <= CENTRE_M and fmod(float(e.get("roll", 0.0)) * 13.0, 1.0) < CIRCLE_SHARE:
			var off: float = p.pair.off_side()
			var way := signf(off) if absf(off) > deg_to_rad(CIRCLE_BACK_DEG) else (1.0 if fmod(float(e.get("roll", 0.0)) * 29.0, 1.0) < 0.5 else -1.0)
			var th := way * CIRCLE_M / maxf(line.length() * 0.5, 0.3)
			var room := true
			for h in [a, b]:
				var to2: Vector3 = mid + (Vector3(h.x, 0.0, h.z) - mid).rotated(Vector3.UP, th)
				room = room and maxf(absf(to2.x), absf(to2.z)) <= edge
			if room:
				_vec[id] = Vector3.ZERO
				_turn[id] = th
				return Vector3.ZERO
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
	return v


## The ring steps under way move the pair's middle (both bodies, the distance untouched).
func follow() -> void:
	var k := 0
	while k < _seg.size():
		var g: Dictionary = _seg[k]
		var s := _frac(int(g["i"]), str(g["clip"]))   # as far as the leader's take has carried its hips
		if s < 0.0:
			_seg.remove_at(k)   # his take was cut: the ring step stops where it is
			continue
		var by: Vector3 = (g["vec"] as Vector3) * maxf(s - float(g["s"]), 0.0)
		if float(g.get("turn", 0.0)) != 0.0 and s > float(g["s"]):
			p.pair.turn_pair(float(g["turn"]) * (s - float(g["s"])))
			walked += CIRCLE_M * (s - float(g["s"]))
		g["s"] = maxf(s, float(g["s"]))
		if by != Vector3.ZERO:
			p.pair._shift(0, by)
			p.pair._shift(1, by)
			walked += by.length()
		if s >= 1.0:
			_seg.remove_at(k)
		else:
			k += 1
