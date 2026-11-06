extends RefCounted
## S379 the films' opening (operator: "skip the walk in for the clips, make the clips start when each man is in his corner
## and then walk to center start fighting"). FightIntro plays it instead of its full intro when FightIntro.from_corners is
## set (the film tools) or the run passes the user arg `fromcorners` (the probes); the game keeps the full intro. No ring
## entry through the ropes, no tale of the tape, no names - their lenses stood outside the ropes:
## - both boxers stand in their corners in their guard, their teams on the apron behind them, under one high wide from the
##   neutral corner on the broadcast side, INSIDE the ropes, its FOV fixed for the shot (both whole in the letterbox), a slow
##   crane down (one move, eased, well under TvShot.TURN_MAX_DEG_S);
## - after HOLD_S both walk to the centre in their guard on the fight's own steps: the body moves at a calm WALK_MS (eased in
##   and out) and FootPlant steps the feet - one foot holds the canvas while the other steps, as every step of the round does
##   (Footwork glide). Not the advance loop through StepRoot: that loop is not a cycle (its feet jump 0.36 m at the seam, once
##   a second) and StepRoot reads its travel BACKWARDS (-0.73 m a loop: the lead foot slides forward lowest), so the boxers
##   turned round and walked 5 m backwards to the middle (S379, tools/corner_start_probe.gd);
## - there they square up (a jab's length apart, FightIntro.cue_walk's marks), a straight cut to the close two-shot (held
##   TWO_SHOT_S, over the TV rulebook's 2 s), the gloves touch, "Seconds out!", the bell - FightIntro.finish hands the ring to
##   the broadcast lens. About 9 s.
##   start(intro)   tick(delta)   stop()   phase, walk_m, walk_s, arrived (probes read them)

const CornerShots := preload("res://scripts/fight3d/CornerShots.gd")
const TvShot := preload("res://scripts/fight3d/TvShot.gd")

const HOLD_S := 2.0          # both in their corners before the walk
const WALK_MS := 0.75        # a calm walk (the fight's glide steps ~0.9 m/s), eased in over WALK_ACC_S, out over WALK_DECEL_M
const WALK_ACC_S := 0.5
const WALK_DECEL_M := 0.4
const WALK_MAX_S := 9.0      # a walk that has not arrived by then is placed on its mark
## After both have arrived (s): the gloves touch, part, "Seconds out!", the bell; the two-shot holds from the arrival.
const TOUCH_S := 0.35
const UNTOUCH_S := 1.25
const OUT_S := 1.55
const BELL_S := 2.45
const TWO_SHOT_S := 2.5
## The wide: over the neutral corner on the broadcast side (FightIntro's `side`, the two-shot's and the round's side of the
## 180-degree line), WIDE_H up (the boxers in opposite corners span ~85 deg from any lens inside the ropes: up high the lens
## stands furthest from them), inside the ropes (TvShot.clamp_in), looking at the ring's middle at LOOK_H; over WIDE_MOVE_S
## it cranes WIDE_DOWN_M down. Its FOV holds both boxers head to feet in their corners with MARGIN_M beside them, inside the
## 2.39:1 letterbox (CornerOverlay), from both ends of the move.
const WIDE_H := 3.4
const LOOK_H := 0.8
const WIDE_MOVE_S := 7.0
const WIDE_DOWN_M := 0.3
const MARGIN_M := 0.3
const ASPECT := 16.0 / 9.0   # the fight's picture (the letterbox is drawn on it; at the bell's cut the viewport may not be laid out)
const LETTERBOX := ASPECT / 2.39
const FOV_PAD := 1.04
const HEAD_M := 2.0
const FOOT_M := -0.08

var fi: Node                 # the FightIntro playing this opening
var phase := ""              # "corners" | "walk" | "touch" | "done"
var walk_m := [0.0, 0.0]     # how far each body went on the walk (probes)
var walk_s := 0.0
var _marks: Array = []       # each boxer's square-up mark at the centre
var arrived := [false, false]
var _t_walk := 0.0
var _t_arr := 0.0
var _wide := {}
var _two := {}


func start(intro: Node) -> void:
	fi = intro
	phase = "corners"
	# Both in front of their stools' place in their guard, each team on its apron (the full intro's corner beat).
	fi.cue_corners()
	var crew: Node = fi.crew
	var axis := ((crew.corner("blue")["seat"] as Vector3) - (crew.corner("red")["seat"] as Vector3)).normalized()
	for i in 2:
		_marks.append(axis * (float(fi.stage.gap_m) + 0.1) * (-0.5 if i == 0 else 0.5))
	_wide = _wide_shot()


func tick(delta: float) -> void:
	var t: float = fi.t
	fi.crew.tick(delta)
	match phase:
		"corners":
			if t >= HOLD_S:
				phase = "walk"
				_t_walk = t
		"walk":
			walk_s += delta
			for i in 2:
				if not arrived[i] and (_walk(i, delta, t - _t_walk) or t - _t_walk > WALK_MAX_S):
					_arrive(i)
			if arrived[0] and arrived[1]:
				phase = "touch"
				_t_arr = t
				_two = fi._framing("two_shot")
		"touch":
			var s := t - _t_arr
			for cue in [[TOUCH_S, "touch"], [UNTOUCH_S, "untouch"], [OUT_S, "seconds_out"], [BELL_S, "bell"]]:
				if s >= float(cue[0]) and s - delta < float(cue[0]):
					fi.call("cue_" + str(cue[1]))
			if s >= maxf(BELL_S, TWO_SHOT_S) + 0.05:
				phase = "done"
				fi.finish()
				return
	_camera(t)


func _camera(t: float) -> void:
	var cam: Camera3D = fi.stage.camera
	if phase == "touch" and not _two.is_empty():
		var u := clampf((t - _t_arr) / 3.0, 0.0, 1.0)
		cam.film((_two["pos"] as Vector3) + (_two["drift"] as Vector3) * u, _two["look"], float(_two["fov"]), float(_two["focus"]))
		return
	var k := clampf(t / WIDE_MOVE_S, 0.0, 1.0)
	k = k * k * (3.0 - 2.0 * k)
	var p: Vector3 = (_wide["from"] as Vector3).lerp(_wide["to"], k)
	cam.film(p, _wide["look"], float(_wide["fov"]), float(_wide["focus"]))


## The high wide over the neutral corner: {from, to, look, fov, focus}.
func _wide_shot() -> Dictionary:
	var crew: Node = fi.crew
	var side := ((crew.corner("blue")["seat"] as Vector3) - (crew.corner("red")["seat"] as Vector3)).normalized() 		.cross(Vector3.UP).normalized()
	var at: Array = []
	var sc: Array = []
	for i in 2:
		at.append(CornerShots.pos(fi.stage.boxers[i]))
		sc.append((fi.stage.boxers[i]["node"] as Node3D).scale.y)
	var w := corner_wide(side, at, sc, WIDE_H, LOOK_H, Vector3.DOWN * WIDE_DOWN_M)
	return {"from": w["pos"], "to": (w["pos"] as Vector3) + (w["drift"] as Vector3), "look": w["look"], "fov": w["fov"],
		"focus": w["focus"]}


## S380 a lens over the neutral corner on `side`, inside the ropes, `h` up, looking at the ring's middle at `look_h`, that
## holds both boxers standing at `at` (their corners; `scale_y` their sizes) head to feet in the letterbox from both ends of
## its `drift` - CornerStart's wide, and FightIntro's wide and tale-of-the-tape shots (they stood 7.2 / 8.4 m out, outside
## the ropes). FightIntro's framing shape: {pos, look, fov, focus, drift}.
static func corner_wide(side: Vector3, at: Array, scale_y: Array, h: float, look_h: float, drift: Vector3) -> Dictionary:
	var from := TvShot.clamp_in(side * TvShot.RING_HALF_M * 1.5) + Vector3.UP * h
	var look := Vector3.UP * look_h
	var pts: Array = []
	for i in at.size():
		var p: Vector3 = at[i]
		pts.append(Vector3(p.x, FOOT_M, p.z))
		pts.append(Vector3(p.x, HEAD_M * float(scale_y[i]), p.z))
	var fov := maxf(_fov(from, look, pts, ASPECT), _fov(from + drift, look, pts, ASPECT)) * FOV_PAD
	return {"pos": from, "look": look, "fov": clampf(fov, 30.0, 70.0), "focus": from.distance_to((at[0] as Vector3) + Vector3.UP * 1.2),
		"drift": drift}


## The vertical FOV (deg) that holds every point of `pts` from `lens` on `look`: MARGIN_M beside each across the frame,
## inside the letterbox up and down.
static func _fov(lens: Vector3, look: Vector3, pts: Array, aspect: float) -> float:
	var inv := Basis.looking_at(look - lens, Vector3.UP).inverse()
	var need := 0.0
	for p in pts:
		var c: Vector3 = inv * ((p as Vector3) - lens)
		var depth := -c.z
		if depth < 0.3:
			continue
		need = maxf(need, absf(c.y) / depth / LETTERBOX)
		need = maxf(need, (absf(c.x) + MARGIN_M) / depth / aspect)
	return rad_to_deg(2.0 * atan(need))


## One frame of boxer i's walk to his mark, facing it (the guard plays on; FootPlant takes the steps). True on arrival.
func _walk(i: int, delta: float, since: float) -> bool:
	var n: Node3D = fi.stage.boxers[i]["node"]
	var to: Vector3 = _marks[i]
	var d := Vector3(to.x - n.position.x, 0.0, to.z - n.position.z)
	var dist := d.length()
	if dist < 0.005:
		return true
	var v := WALK_MS * n.scale.x * minf(1.0, since / WALK_ACC_S) * clampf(dist / WALK_DECEL_M, 0.25, 1.0)
	var stride := minf(dist, v * delta)
	n.position += d / dist * stride
	walk_m[i] += stride
	return dist - stride < 0.005


## On the mark, squared up to the other's mark (his guard plays on).
func _arrive(i: int) -> void:
	arrived[i] = true
	var a: Dictionary = fi.stage.boxers[i]
	var at: Vector3 = _marks[i]
	if CornerShots.pos(a).distance_to(at) > 0.05:
		(a["node"] as Node3D).position = Vector3(at.x, 0.0, at.z)
	fi.crew.turn(a, fi.crew.yaw_to(at, _marks[1 - i]))


## Skipped mid-walk (FightIntro.finish places them on their marks): nothing more to walk.
func stop() -> void:
	phase = "done"
