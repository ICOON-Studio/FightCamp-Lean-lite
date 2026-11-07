extends Camera3D
## The ring's broadcast camera (split from FightStage S302): the TV main lens that rides beside the pair (S379), the film
## shots the intro, the corner minute and the count place, the ropes between it and the boxers made see-through, and the
## nudge on a power shot.
##   broadcast(a, b, snap, delta)  film(pos, look, fov, focus)  close_up(a, b, head_y, hit)  shake(m)  nudge(delta)  clear_view(ring_side, a, b, delta)

const TvShot := preload("res://scripts/fight3d/TvShot.gd")

## The nudge decays with this time constant (seconds).
const SHAKE_TAU_S := 0.09
## S311 clear view: a rope or post within this of the line from the lens to a boxer (stopped this short of her, so the
## ropes behind her stay) is hidden.
const SIGHT_MARGIN_M := 0.3
const SIGHT_SHORT_M := 0.25
## S311 (operator: "make the ropes transparent when they block in the view"): a blocking rope or post fades to SEE_ALPHA
## over FADE_S instead of vanishing, and back to solid when the view clears.
const SEE_ALPHA := 0.18
const FADE_S := 0.2
## S320: a piece this far toward the lens from the pair's middle starts to fade, and is see-through from the second (it
## was see-through at once past 1.2 m).
const NEAR_FADE := Vector2(0.9, 1.5)

## S379 C222 TV coverage (operator on the FIGHT9 round-9 film: "the camera movement makes me dizzy, watch what angles are
## used in televised events and try to do the same, why you keep zooming in and out and rotate all at the same time"; the
## rulebook: docs/TV_CAMERA_RULES.md). It replaces the S317 shot director (six ringside lenses that orbited 2-8 deg/s, cut
## every 4-7.5 s and re-widened every frame near the ropes: tools/cam_motion_probe.gd measured turns up to 220 deg/s and 78
## frames zooming while the lens moved). Every shot is placed ONCE at its cut - side-on to the pair, its FOV fixed for the
## whole shot (TvShot.place frames both head to feet) - and while it holds the lens rides beside the pair (it keeps its
## offset from their eased middle, so the picture holds still around them) and only pans, eased and at most
## TvShot.TURN_MAX_DEG_S, where the ropes stop it. "main" = TV's elevated main camera, most of the round; "apron" = the
## ringside handheld, lower and a little off side-on, now and then; "clinch" = lifted and turned toward the side where the
## far head shows (S369). Each: dist (m from the pair's middle), h (lens height), look_h (-1: centred head to feet,
## TvShot.centre_h), yaw (deg off side-on), hold (s).
const SHOTS := [
	{"name": "main", "dist": 3.1, "h": 1.85, "look_h": -1.0, "yaw": 0.0, "hold": Vector2(14.0, 20.0)},
	{"name": "apron", "dist": 2.6, "h": 1.4, "look_h": -1.0, "yaw": 12.0, "hold": Vector2(5.0, 7.0)},
	{"name": "clinch", "dist": 2.8, "h": 2.15, "look_h": 1.4, "yaw": 28.0, "hold": Vector2(30.0, 30.0)},
]
## S379: no shot shorter than MIN_SHOT_S (the rulebook's replay shots run 2-4 s; live TV cuts about every 9 s) - but the
## emergency cut, the rulebook's "leave a blocked angle immediately": a boxer within NEAR_HARD_M of the lens, or the lens
## within BEHIND_HARD_DEG of straight behind one (the probe's bar is 45; the hips swing up to ~5 deg in a frame). After
## MIN_SHOT_S a shot also cuts when it is within BEHIND_CUT_DEG of behind a boxer, a boxer is within TOO_CLOSE_M, or a
## boxer's head or feet have been out of the frame LOST_S. The pair's middle eases at MID_W (1/s), the lens rides at POS_W.
## The regular "behind" cut needs BEHIND_HOLD_S under BEHIND_CUT_DEG (a step in or out swings their line for a moment).
## The pair circles (the probe measured ~14 deg/s for seconds on end) while the lens holds its direction, so a new shot
## is placed AHEAD of their turn: LEAD_S seconds of it (at most LEAD_MAX_DEG) off side-on, to come round through side-on.
const MIN_SHOT_S := 2.2
const BEHIND_CUT_DEG := 58.0
const BEHIND_HOLD_S := 0.25
const BEHIND_HARD_DEG := 50.0
const LEAD_S := 1.4
const LEAD_MAX_DEG := 26.0
const AXIS_TAU_S := 0.6
## A shot younger than MIN_SHOT_S that a fast pivot carries under PROTECT_DEG slides round the pair toward side-on, at most
## SLIDE_DEG_S and eased (SLIDE_ACC), instead of cutting away at once; only under BEHIND_HARD_DEG does it cut.
const PROTECT_DEG := 64.0
const SLIDE_DEG_S := 7.5
const SLIDE_ACC := 20.0
const NEAR_HARD_M := 0.85
const LOST_S := 0.3
const MID_W := 2.4
const POS_W := 4.0
const MAX_DT_S := 1.0 / 30.0
## A new shot within JUMP_CUT_M and JUMP_CUT_DEG of the lens it replaces would be a jump cut (it reads as a glitch, not
## a new camera): the apron angle goes up instead.
const JUMP_CUT_M := 0.8
const JUMP_CUT_DEG := 25.0
const JUMP_MID_M := 1.2   # on a snap, the pair's middle this far from the lens's: a fresh shot (a new round, a skip)
## S368: a lens never turns further than this off side-on to the pair (shot yaw + orbit + the turn that keeps it inside the
## ropes). Near the ropes it comes closer and widens instead (spot_inside's room search), and when even MIN_DIST_M does not
## fit on this side it rises to the crane lens on the same broadcast side - never crossing the 180-degree line.
const SIDE_ARC_DEG := 40.0
## S368: deep in a corner neither side has a side-on spot inside the ropes even at MIN_DIST_M (the pair half a metre off two
## ropes): the lens rises over the top rope (RingSet's ropes at 0.45 / 0.85 / 1.25 m) like a TV crane, side-on, at most
## HIGH_DIST_M out, instead of swinging round behind a boxer.
const OVER_ROPES_H := 2.3
const HIGH_DIST_M := 2.6
const TOP_ROPE_H := 1.25
## S347 (operator: "this transparent rope on all your stills start to become annoying, why you do not change angle?"):
## the lens stands INSIDE the ropes, IN_M in from them, so no rope is ever between it and the pair - the ropes are only
## behind them (the tape room's rule, TapeFilm). A shot whose spot is outside turns toward the open ring, smallest turn
## first (TURNS, deg); with no room at its distance anywhere it comes closer (down to MIN_DIST_M).
const RING_HALF_M := TvShot.RING_HALF_M     # FightStage.RING_M * 0.5
const IN_M := TvShot.IN_M
const MIN_DIST_M := 1.9
const TURNS := [0.0, 25.0, -25.0, 50.0, -50.0, 80.0, -80.0, 115.0, -115.0, 150.0, -150.0, 180.0]
## S317 motion blur (operator: "go ahead" on the download): sphynx-owner's Godot Motion Blur Addon v1.1.1 (MIT, per-object
## velocity blur as a compositor effect; needs his Easy Compositor Addon v1.0.4, MIT) - res://addons. The reference's fast
## punches smear; ours stepped frame to frame. Camera rotation counts little (an orbit should not smear the ring); a cut
## or a jump of the lens past JUMP_M gets no blur on that frame. `-- noblur` = the control arm; headless runs have none.
const MOTION_BLUR := "res://addons/godot-motion-blur/guertin/guertin_motion_blur.gd"
const BLUR := 1.0
const JUMP_M := 0.4
## S348 (S348 round-1 still: "Step back" walked her into the over-the-shoulder lens, her back hid the other woman's face):
## a boxer this close to the lens (flat) cuts to the next shot.
const TOO_CLOSE_M := 1.3
## S369 (CAMCLINCH1): in a tie-up the heads sit side by side along the side-on line, so a side-on lens lets the near head
## hide the far one. While `clinch_heads` holds both heads the shot is SHOTS "clinch": turned its yaw off side-on toward the
## side where lens -> far head clears the near head, lifted, looking at the midpoint of the heads (S379: placed at its cut,
## no longer swung round while the lens held).
var avoid := Vector3.INF      # the referee (FightStage sets it every frame); INF = nobody to keep off
var clinch_heads: Array = []  # [head_a, head_b] in world space while a clinch is held, else []

var close := false            # a film shot (or the close-up) holds until broadcast() runs again
var shot_name := ""           # S379: what the lens shows (probes read it): main / apron / clinch / film / close
var cut_why := ""             # S379: why the last broadcast cut came (probes read it)
var cuts := 0                 # S379: broadcast cuts so far (probes read it: a cut, however small the change)
var _shot := -1
var _shot_t := 0.0            # real seconds the current shot has held
var _shot_hold := 0.0
var _rng := RandomNumberGenerator.new()
var _blur: CompositorEffect = null
var _side := Vector3.LEFT     # the side of the pair the camera is on (flat)
var _shake := 0.0             # metres, decaying
var _shake_t := 0.0
var _clinch_s := 1.0          # S369: which sign (+1 / -1) of the clinch yaw the clinch lens holds
var _apron_s := 1.0           # S379: the apron shot turns to alternate sides
var _mid := Vector3.ZERO      # S379: the pair's middle, eased (flat)
var _mid_v := Vector3.ZERO
var _anchor := Vector3.ZERO   # S393 C242: where the lens's middle rests (TvShot.anchored)
var _pos := Vector3.ZERO      # the lens, riding at _mid + _off
var _pos_v := Vector3.ZERO
var _off := Vector3.ZERO
var _h := 1.85
var _look_h := 0.95
var _ang := Vector2.ZERO      # yaw, pitch (deg)
var _ang_v := Vector2.ZERO
var _lost := 0.0
var _behind_s := 0.0          # S379: seconds the lens has been under BEHIND_CUT_DEG
var _axis := INF              # the pair's line a -> b (deg about +Y) last frame
var _axis_w := 0.0            # how fast it turns (deg/s, eased over AXIS_TAU_S)
var _slide_w := 0.0           # deg/s the young shot's lens slides round the pair (PROTECT_DEG)


func _init() -> void:
	# A broadcast lens: the ring sharp, the hall beyond it soft.
	var lens := CameraAttributesPractical.new()
	lens.dof_blur_far_enabled = true
	lens.dof_blur_far_transition = 2.0
	lens.dof_blur_amount = 0.22
	attributes = lens
	if DisplayServer.get_name() != "headless" and not OS.get_cmdline_user_args().has("noblur") and ResourceLoader.exists(MOTION_BLUR):
		_blur = (load(MOTION_BLUR) as Script).new() as CompositorEffect
		_blur.set("intensity", BLUR)
		_blur.set("multiplier_camera_rotation", 0.1)
		var comp := Compositor.new()
		comp.compositor_effects = [_blur]
		compositor = comp


## No blur on a frame whose lens jumped (a cut): its motion vectors would smear the whole picture.
func _place_lens(pos: Vector3, look: Vector3) -> void:
	if _blur != null:
		_blur.set("intensity", 0.0 if position.distance_to(pos) > JUMP_M else BLUR)
	look_at_from_position(pos, look, Vector3.UP)


## S379 the TV lens (SHOTS): a cut places a shot once (TvShot.place, its FOV fixed till the next cut); while it holds it
## rides beside the pair and pans (_ride); it cuts on the rules above (_due). `snap` = the ring changes hands (a round, the
## intro's bell, the count): a fresh shot when a film shot was on or the pair jumped, else the shot on screen holds.
func broadcast(a: Vector3, b: Vector3, snap: bool = false, delta: float = 0.0) -> void:
	var was_film := close
	close = false
	# Real seconds: the 2x pace must not turn the lens faster. At most one 30 fps frame (MAX_DT_S): the frame the shout's
	# slow motion starts divides an unscaled delta by the new time scale.
	var dt := minf(delta / maxf(Engine.time_scale, 0.05), MAX_DT_S)
	_shot_t += dt
	var mid := Vector3((a.x + b.x) * 0.5, 0.0, (a.z + b.z) * 0.5)
	var why := ""
	if _shot < 0 or was_film:
		why = "start"
	elif snap and mid.distance_to(_mid) > JUMP_MID_M:
		why = "jump"
	else:
		why = _due(a, b)
	if why != "":
		_cut(a, b, mid, why)
	else:
		_ride(a, b, dt)


## Why the shot on screen must end now ("" = it holds).
func _due(a: Vector3, b: Vector3) -> String:
	var lens := Vector3(global_position.x, 0.0, global_position.z)
	var behind := TvShot.behind_deg(a, b, lens)
	var near := minf(TvShot.flat_gap(lens, a), TvShot.flat_gap(lens, b))
	if behind < BEHIND_HARD_DEG or near < NEAR_HARD_M:
		return "emergency"
	if _shot_t < MIN_SHOT_S:
		return ""
	if _behind_s >= BEHIND_HOLD_S:
		return "behind"
	if near < TOO_CLOSE_M:
		return "close"
	if _lost >= LOST_S:
		return "frame"
	if (clinch_heads.size() == 2) != (shot_name == "clinch"):
		return "clinch"
	if _shot_t >= _shot_hold:
		return "hold"
	return ""


## A straight cut to a fresh shot: "main" again after anything but a held main (which hands over to the apron for a
## while), "clinch" while the heads are tied up. Same side of the pair as the lens on screen (the 180-degree line).
func _cut(a: Vector3, b: Vector3, mid: Vector3, why: String) -> void:
	if _shot < 0:
		_rng.seed = 379
	var k := 0
	if clinch_heads.size() == 2:
		k = 2
	elif why == "hold" and shot_name == "main":
		k = 1
	var sh: Dictionary = SHOTS[k]
	var here := Vector3(global_position.x - mid.x, 0.0, global_position.z - mid.z)
	var prefer := here if here.length() > 0.3 else _side
	# Ahead of the pair's turn: the lens direction stays put while their side-on line turns at _axis_w.
	var lead := signf(_axis_w) * minf(absf(_axis_w) * LEAD_S, LEAD_MAX_DEG)
	var yaw := lead
	if k == 1:
		_apron_s = signf(_axis_w) if absf(_axis_w) > 3.0 else -_apron_s
		yaw = maxf(float(sh["yaw"]), absf(lead)) * _apron_s
	elif k == 2:
		# S379 fix: the clinch shot's own turn (SHOTS "clinch" yaw 28), not the lead (often 0), and placed keeping it
		# (TvShot.place `keep_yaw`; it came back near side-on): the S369 turn toward the side where the far head shows
		# did nothing in a clinch (tools/cam_view_probe.gd clinch=: the lens 15 deg off side-on, now 29).
		yaw = _clinch_yaw(mid, TvShot.side_on(a, b, prefer), float(sh["dist"]), float(sh["h"]), float(sh["yaw"]))
	var p := TvShot.place(a, b, prefer, float(sh["dist"]), yaw, float(sh["h"]), float(sh["look_h"]), _aspect(),
		TvShot.PLACE_CLEAR_M, k == 2)
	var old := global_position
	if k == 0 and _shot >= 0 and old.distance_to(p["lens"]) < JUMP_CUT_M 			and rad_to_deg(here.angle_to(p["off"] as Vector3)) < JUMP_CUT_DEG:
		k = 1
		sh = SHOTS[1]
		_apron_s = signf(_axis_w) if absf(_axis_w) > 3.0 else -_apron_s
		yaw = maxf(float(sh["yaw"]), absf(lead)) * _apron_s
		p = TvShot.place(a, b, prefer, float(sh["dist"]), yaw, float(sh["h"]), float(sh["look_h"]), _aspect())
	_shot = k
	cuts += 1
	shot_name = str(sh["name"])
	_shot_t = 0.0
	_lost = 0.0
	_shot_hold = _rng.randf_range((sh["hold"] as Vector2).x, (sh["hold"] as Vector2).y)
	_mid = mid
	_anchor = mid
	_mid_v = Vector3.ZERO
	_off = p["off"]
	_side = _off.normalized() if _off.length() > 0.05 else _side
	_pos = p["lens"]
	_pos_v = Vector3.ZERO
	_h = _pos.y
	_look_h = float(p["look_h"])
	_behind_s = 0.0
	_slide_w = 0.0
	cut_why = "%s (old lens behind %.0f near %.2f) -> %.2f m out, yaw %.0f, behind %.0f, pair turning %.0f deg/s%s" % [why,
		TvShot.behind_deg(a, b, here + mid), minf(TvShot.flat_gap(here + mid, a), TvShot.flat_gap(here + mid, b)),
		_off.length(), yaw, TvShot.behind_deg(a, b, _pos), _axis_w, " HIGH" if bool(p["high"]) else ""]
	fov = float(p["fov"])
	_ang = TvShot.aim(_pos, p["look"])
	_ang_v = Vector2.ZERO
	_lens(false)
	_set_lens(true)


## The held shot: the pair's middle eases, the lens rides at its offset from it (stopped by the ropes: it slides along
## them), and the lens pans toward the middle, eased and capped (TvShot.turn). The FOV never changes here.
func _ride(a: Vector3, b: Vector3, dt: float) -> void:
	if dt <= 0.0:
		return
	_anchor = TvShot.anchored(_anchor, Vector3((a.x + b.x) * 0.5, 0.0, (a.z + b.z) * 0.5))
	var m := TvShot.spring(_mid, _mid_v, _anchor, MID_W, dt)
	_mid = m[0]
	_mid_v = m[1]
	var axis := rad_to_deg(atan2(-(b.z - a.z), b.x - a.x))
	if is_finite(_axis):
		_axis_w = lerpf(_axis_w, wrapf(axis - _axis, -180.0, 180.0) / dt, 1.0 - exp(-dt / AXIS_TAU_S))
	_axis = axis
	var behind := TvShot.behind_deg(a, b, Vector3(global_position.x, 0.0, global_position.z))
	_behind_s = _behind_s + dt if behind < BEHIND_CUT_DEG else 0.0
	var slide := 0.0
	if _shot_t < MIN_SHOT_S and behind < PROTECT_DEG:
		var side := TvShot.side_on(a, b, _off)
		slide = -signf(side.signed_angle_to(_off, Vector3.UP)) * SLIDE_DEG_S
	_slide_w = move_toward(_slide_w, slide, SLIDE_ACC * dt)
	if absf(_slide_w) > 0.0:
		_off = Basis(Vector3.UP, deg_to_rad(_slide_w * dt)) * _off
	var want := TvShot.clamp_in(_mid + _off)
	want.y = _h
	var p := TvShot.spring(_pos, _pos_v, want, POS_W, dt)
	_pos = p[0]
	_pos_v = p[1]
	var look := _mid + Vector3.UP * _look_h
	if shot_name == "clinch" and clinch_heads.size() == 2:
		look = ((clinch_heads[0] as Vector3) + (clinch_heads[1] as Vector3)) * 0.5
	var t := TvShot.turn(_ang, _ang_v, TvShot.aim(_pos, look), dt)
	_ang = t[0]
	_ang_v = t[1]
	_set_lens(false)
	_lost = 0.0 if _seen(a) and _seen(b) else _lost + dt


## No blur on a cut's frame (its motion vectors would smear the whole picture).
func _set_lens(cut: bool) -> void:
	if _blur != null:
		_blur.set("intensity", 0.0 if cut else BLUR)
	global_transform = Transform3D(TvShot.basis_of(_ang), _pos)
	(attributes as CameraAttributesPractical).dof_blur_far_distance = Vector2(_off.x, _off.z).length() + 1.6


## A boxer standing at `p` (feet) is in the frame head to feet.
func _seen(p: Vector3) -> bool:
	return _in_view(p + Vector3.UP * 0.05) and _in_view(p + Vector3.UP * 1.85)


func _in_view(p: Vector3) -> bool:
	return TvShot.in_view(global_transform, fov, _aspect(), p)


func _aspect() -> float:
	return TvShot.aspect_of(self)


## S369: tries +`yaw` and -`yaw` off `side` and keeps the one whose lens -> far-head line passes furthest from the near
## head (the clinch shot's turn).
func _clinch_yaw(mid: Vector3, side: Vector3, dist: float, h: float, yaw: float) -> float:
	var h0: Vector3 = clinch_heads[0]
	var h1: Vector3 = clinch_heads[1]
	var best_yaw := _clinch_s * yaw
	var best_clear := -1.0
	for s in [_clinch_s, -_clinch_s]:
		var y := float(s) * yaw
		var d := Basis(Vector3.UP, deg_to_rad(y)) * side
		var lens := TvShot.clamp_in(Vector3(mid.x, 0.0, mid.z) + d * dist) + Vector3(0, h, 0)
		var near_h := h0 if lens.distance_to(h0) < lens.distance_to(h1) else h1
		var far_h := h1 if near_h == h0 else h0
		var clear := Geometry3D.get_closest_point_to_segment(near_h, lens, far_h).distance_to(near_h)
		if best_clear < 0.0 or clear > best_clear + 0.02:
			best_clear = clear
			best_yaw = y
			_clinch_s = float(s)
	return best_yaw


## Low at the side, both heads in frame (`head_y` = the hit boxer's head height), held until broadcast() is called again.
func close_up(a: Vector3, b: Vector3, head_y: float, hit: int) -> void:
	close = true
	shot_name = "close"
	_lens(false)
	var mid := (a + b) * 0.5 + Vector3(0, head_y - 0.12, 0)
	var axis := (b - a).normalized()
	var side := _side_of(a, b)
	fov = 32.0
	(attributes as CameraAttributesPractical).dof_blur_far_distance = 2.5 + 1.2
	var hitter := axis if hit == 1 else -axis
	var flat := Vector3(mid.x, 0.0, mid.z) - hitter * 0.15
	var arc := Vector2(-SIDE_ARC_DEG, SIDE_ARC_DEG)
	var sp := spot_inside(flat, side, 2.5, 0.0, arc)
	var h := mid.y + 0.08
	if not bool(sp[3]):
		sp = high_spot(flat, side, 2.5)
		h = OVER_ROPES_H
	_side = side
	fov = maxf(32.0, rad_to_deg(2.0 * atan(0.7 / maxf(float(sp[1]), 0.5))))
	_place_lens((sp[0] as Vector3) + Vector3(0, h, 0), mid)


## S347: a lens spot (flat, y 0) inside the ropes.
static func inside(p: Vector3) -> bool:
	var half := RING_HALF_M - IN_M
	return absf(p.x) <= half and absf(p.z) <= half


## The lens spot for a shot at `dist` from `mid` along `dir` (flat): the smallest turn that stands it inside the ropes;
## else the turn with the most room, as far out as it fits; else (no room even at MIN_DIST_M) the line to the ring's
## middle. S368: `limit` (deg, min..max) bounds the turns tried - the broadcast keeps every lens near side-on - and its two
## edges are tried too. Returns [spot (flat), distance, turn, fits]; fits = false only for that last fallback.
static func spot_inside(mid: Vector3, dir: Vector3, dist: float, keep_turn: float = 0.0,
		limit := Vector2(-999.0, 999.0)) -> Array:
	var c := Vector3(mid.x, 0.0, mid.z)
	var best_room := -1.0
	var best_dir := dir
	var best_t := keep_turn
	# S347 (operator: the fight must look smooth): the turn the lens already holds is tried first, so near the ropes it never
	# flips between two turns that both fit.
	var turns: Array = [keep_turn] + TURNS
	if limit.x > -180.0:
		turns += [limit.x, limit.y]
	for t in turns:
		if float(t) < limit.x or float(t) > limit.y:
			continue
		var d: Vector3 = Basis(Vector3.UP, deg_to_rad(float(t))) * dir
		if inside(c + d * dist):
			return [c + d * dist, dist, float(t), true]
		var room := dist - 0.1
		while room > MIN_DIST_M and not inside(c + d * room):
			room -= 0.1
		if room > best_room and inside(c + d * room):
			best_room = room
			best_dir = d
			best_t = float(t)
	if best_room < 0.0:
		best_dir = -c.normalized() if c.length() > 0.1 else dir
		return [c + best_dir * MIN_DIST_M, MIN_DIST_M, keep_turn, false]
	return [c + best_dir * best_room, best_room, best_t, true]


## S368 the corner's crane spot (flat; the lens stands at OVER_ROPES_H): side-on along `dir`, at most HIGH_DIST_M out.
## Same shape as spot_inside's answer: [spot, distance, turn 0, fits false].
static func high_spot(mid: Vector3, dir: Vector3, dist: float) -> Array:
	var far := minf(dist, HIGH_DIST_M)
	return [Vector3(mid.x, 0.0, mid.z) + dir * far, far, 0.0, false]


func _side_of(a: Vector3, b: Vector3) -> Vector3:
	return (b - a).normalized().cross(Vector3.UP).normalized()


## S302: a power shot nudges the lens (the framing itself is untouched).
func shake(m: float) -> void:
	_shake = maxf(_shake, m)


func nudge(delta: float) -> void:
	if _shake < 0.002:
		h_offset = 0.0
		v_offset = 0.0
		return
	_shake_t += delta
	h_offset = _shake * sin(_shake_t * 71.0)
	v_offset = _shake * 0.7 * sin(_shake_t * 53.0 + 1.3)
	_shake *= exp(-delta / SHAKE_TAU_S)


## A TV camera shoots between the ropes: every rope or post nearer the camera than the boxers is hidden.
func clear_view(ring_side: Array, a: Vector3, b: Vector3, delta: float = 0.0) -> void:
	var mid := (a + b) * 0.5
	var to_cam := Vector3(global_position.x - mid.x, 0, global_position.z - mid.z).normalized()
	var cam := Vector2(global_position.x, global_position.z)
	var hidden := {}
	var ropes := {}
	var near := {}
	for n in ring_side:
		var node := n as Node3D
		var at := node.global_position
		var d := Vector3(at.x - mid.x, 0, at.z - mid.z)
		var hide := false
		# S320: nearer the lens than the pair, a piece fades by how near (a ramp along the rope, not a cut into stubs).
		near[node] = smoothstep(NEAR_FADE.x, NEAR_FADE.y, d.dot(to_cam))
		# S311: the range breathes and the pair reaches the ropes (~110 m a round): from a corner angle the side next to
		# the camera crossed both bodies. A rope or post that crosses the camera's line to either boxer goes too.
		var along := node.global_transform.basis.y
		var half := Vector2(along.x, along.z) * float(((node as MeshInstance3D).mesh as CylinderMesh).height) * 0.5
		var c := Vector2(at.x, at.z)
		for p in [a, b]:
			var to := Vector2(p.x, p.z)
			var end := to + (cam - to).normalized() * SIGHT_SHORT_M
			var q := Geometry2D.get_closest_points_between_segments(c - half, c + half, cam, end)
			hide = hide or q[0].distance_to(q[1]) < SIGHT_MARGIN_M
		hidden[node] = hide
		if hide and node.has_meta("rope"):
			ropes[node.get_meta("rope")] = true
	# S320 (the smooth ropes, 40 pieces a side): a rope fades WHOLE when any piece of it is in the way - faded piece by
	# piece it broke into floating stubs.
	for n in ring_side:
		var hide: bool = hidden[n] or ((n as Node).has_meta("rope") and ropes.has((n as Node).get_meta("rope")))
		_fade(n as MeshInstance3D, SEE_ALPHA if hide else lerpf(1.0, SEE_ALPHA, float(near[n])), delta)


## Eases a ring piece's own material toward `want` alpha (delta 0 = at once); solid pieces stay opaque.
static func _fade(m: MeshInstance3D, want: float, delta: float) -> void:
	var mat := m.material_override as StandardMaterial3D
	var c := mat.albedo_color
	c.a = want if delta <= 0.0 else move_toward(c.a, want, delta / FADE_S)
	mat.albedo_color = c
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA if c.a < 0.999 else BaseMaterial3D.TRANSPARENCY_DISABLED


## S307 the corner minute's film shots: a lens at `pos` on `look`, sharp only around `focus` metres (shallow depth of
## field: the near shoulder and the hall behind go soft). `focus` <= 0 = the broadcast lens.
func film(pos: Vector3, look: Vector3, lens_fov: float, focus: float) -> void:
	close = true
	shot_name = "film"
	fov = lens_fov
	_lens(focus > 0.0, focus)
	_place_lens(pos, look)


func _lens(shallow: bool, focus: float = 0.0) -> void:
	var lens := attributes as CameraAttributesPractical
	lens.dof_blur_near_enabled = false   # S396: near blur bled the hall through the coach near the lens; far side only
	if shallow:
		# The sharp band grows with the distance, as a real lens's depth of field does.
		lens.dof_blur_near_distance = maxf(0.1, focus * 0.7)
		lens.dof_blur_near_transition = focus * 0.25
		lens.dof_blur_far_distance = focus * 1.35 + 0.2
		lens.dof_blur_far_transition = 1.2
		lens.dof_blur_amount = 0.2
	else:
		# S317: the hall behind the ring goes properly soft (was 0.14: the crowd read sharp and cheap).
		lens.dof_blur_far_transition = 2.0
		lens.dof_blur_amount = 0.22
