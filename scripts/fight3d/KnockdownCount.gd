extends Node
## S377 KNOCKCOUNT1 - what happens after a knockdown (Argon on FIGHT9R6's film: "a completely non-functional knockdown state
## where the winner dances on the loser's body while the clock runs out" - no count, the clock ran on 17 s, the standing
## boxer stood on the downed one's leg in his stance). There is no referee in the ring (operator S369), so the ring keeps the
## rule itself and the count is a broadcast graphic:
## - the fall plays and its slow-motion replay (KnockdownReplay); the round clock HOLDS from the count beat on (FightView.t
##   does not run, so the round's exchanges are not eaten by the count);
## - the standing boxer backs off to the neutral corner farthest from the downed one (round the body) in his guard, eyes on
##   him, the fight's own glide (his guard loop while FootPlant takes the steps) at PACE_MS - S377 operator on the corner
##   crew's casual walk (af_walk) played on a boxer: "the walking on the clip is so bad"; the fight's mocap step loops
##   (Footwork.STRIDE) were filmed too and squat bow-legged at this pace - and he waits there, facing him;
## - the count runs big under the banner, one number a second of the fight's own time (2x counts twice as fast; the replay
##   pauses it with the rest of the ring);
## - no stoppage: the downed boxer gets up by the sim's `up_at` (Knockdowns: 2-9; his countdown clip plays from its rise),
##   the count runs on to the mandatory 8, BOX! - both go back to the fight where they stand;
## - "RSC": he gets up, the count ends in STOPPED; "KO": he stays on the canvas (the knockout clip holds its last frame), the
##   count goes to 10. The winner celebrates in his corner and the bout ends at once (FightView._bell).
##   attach(view) -> Node   start(down, stop, up_at, fall_in)   holding() -> bool   stop()   phase, shown (probes read them)

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FightHud := preload("res://scripts/fight3d/FightHud.gd")
const RingCamera := preload("res://scripts/fight3d/RingCamera.gd")
const UI := preload("res://scripts/ui/TV.gd")

const DOWN_S := 1.0          # the count starts this long after the fall (and after the replay, when one plays)
const TICK_S := 1.0          # one number a second
const MANDATORY := 8         # amateur rule: a standing count always runs to 8
const KO_AT := 10
const UP_AT := 6             # the sim's up_at for an opponent's heart 55 (Knockdowns), when the round has none
const RISE_COUNT := 3        # his rise starts this many numbers before up_at (the clips stand ~2.9-3.5 s after their rise)
const STAND_HEAD_M := 1.3    # up again: the head this high at scale 1 (a standing guard's head ~1.56 m, flat ~0.2 m)
const NEUTRAL_IN_M := 0.6    # the neutral corner mark: this far in from the posts on both axes (Referee._neutral)
const BOX_S := 0.9
const PACE_MS := 0.9         # his ground speed backing to the corner (the fight's own walk: Footwork 0.55 x ~1.75 m/s)
const FACE_S := 0.12         # he turns to keep the downed boxer in front of him
const CLEAR_M := 0.8         # his path keeps this far from the lying body (hips to head), round its nearer end
const ROPE_IN_M := 2.45      # a detour waypoint stays this far in from the centre on both axes
const END_S := 1.6           # KO / STOPPED shows this long before the bell
const HOLD_END_S := 0.15     # a knockout clip freezes this close to its end (a finished clip would hand him to his guard)
## Each countdown clip: where its rise starts (hips still flat on the canvas) and where it reaches the guard (clip seconds,
## the baked clips' hips heights and clip_recovery.json's back_s; S377 map).
## The count's own lens (the fight's pair framing aimed at the empty canvas between a man on the canvas and one in a corner,
## S377 film): side-on to the line from the downed boxer to the neutral corner, inside the ropes, high, wide enough for both.
const LENS_DIST_M := 3.4
const LENS_H := 1.9
const LOOK_H := 0.6
const LOOK_AT := 0.5         # the lens looks this far from the downed boxer toward the corner
const EDGE_M := 1.0          # room kept beyond each of them in the frame
const HUD_SPREAD := 1.35     # the body-map panels cover each side of the frame: both boxers stay in its middle 3/4
const BACK_GAP_M := 2.2      # after BOX! the count's lens holds until they are this close again (or BACK_S)
const BACK_S := 3.0
const ASPECT := 16.0 / 9.0
const RISE_FROM := {"pro_knockout_countdown_v1": 23.0, "pro_knockout_countdown_v2": 24.0, "pro_knockout_countdown_v3": 26.0,
	"mc_knockout_count": 23.0}
const RISE_TO := {"pro_knockout_countdown_v1": 26.55, "pro_knockout_countdown_v2": 29.05, "pro_knockout_countdown_v3": 31.467,
	"mc_knockout_count": 26.55}

var view: Control
var phase := ""        # "" | "fall" (before scene mode) | "down" (fall + replay) | "count" | "end" (word up, bell next) | "over"
                       # | "back" (after BOX!: boxing again, the count's lens holds till they close in)
var shown := ""        # the count graphic's text (probes read it)
var top := 0           # the highest number counted this knockdown
var _down := -1
var _stop := ""
var _up_at := UP_AT
var _wait := 0.0
var _fall_in := 0.0
var _tick := 0.0
var _rising := false
var _standing := false
var _scened := false
var _label: Label
var _pop := 1.0
var _flash := 0.0
var _lens := {}        # the count shot: {pos, look, fov}
var _path: Array = []  # the walker's waypoints to the neutral corner
var _body := Vector3.ZERO


static func attach(v: Control) -> Node:
	var k := new()
	k.name = "KnockdownCount"
	k.view = v
	v.add_child(k)
	k._build()
	return k


func _build() -> void:
	_label = UI.display("", 150)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_constant_override("outline_size", 14)
	_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	view.add_child(_label)
	FightHud.pin(_label, Vector4(0.5, 0, 0.5, 0), Vector4(-640, 300, 640, 470))


## Boxer `down` goes down; `stop` is the round's stoppage ("", "KO", "RSC"); the fall clip starts `fall_in` s from now.
func start(down: int, stop_how: String, up_at: int, fall_in: float) -> void:
	if phase != "":
		return
	_down = down
	_stop = stop_how
	_up_at = clampi(up_at, 1, 9) if up_at > 0 else UP_AT
	_fall_in = fall_in
	_wait = 0.0
	_tick = TICK_S
	top = 0
	_rising = false
	_standing = false
	_lens = {}
	phase = "fall"
	_drop_next(float(view.t))
	_show("", UI.GOLD)


## True from the count beat until BOX! or the bell: the round clock holds (FightView._process).
func holding() -> bool:
	return phase in ["fall", "down", "count", "end"]


## Clears a count a skipped round or bout left (FightView.skip_round / skip_bout / play_round). The knockdown's replay
## does not cut in later (it would pause the corner minute or the result card). A knockout stays on the canvas: the bout
## is over, the ring keeps him down under the result ("over").
func stop() -> void:
	var r: Node = view.get("replay")
	if r != null and not r.active():
		r.set("_hit", -1.0)
	if holding():
		_crew_clear()
	_flash = 0.0
	_show("", UI.GOLD)
	if _stop == "KO" and holding():
		if not _scened:
			view.stage.scene_mode(true)
			_scened = true
		phase = "over"
		return
	if _scened and view.stage != null and view.stage.scene and phase != "over":
		view.stage.scene_mode(false)
	_scened = false
	phase = ""


func _process(delta: float) -> void:
	_pop = lerpf(_pop, 1.0, 1.0 - exp(-delta / 0.08))
	if _label != null:
		_label.pivot_offset = _label.size * 0.5
		_label.scale = Vector2.ONE * _pop
	if _flash > 0.0:
		_flash -= delta
		if _flash <= 0.0 and phase in ["", "back"]:
			_show("", UI.GOLD)
	if phase == "" or view.stage == null:
		return
	if _stop == "KO":
		_hold_down()
	match phase:
		"fall":
			_wait += delta
			if _wait >= _fall_in + 0.05:
				_scene_on()
		"down":
			_wait += delta
			if _wait >= _fall_in + DOWN_S and not _replay_due():
				_begin_count()
		"count":
			_count(delta)
		"end":
			_wait += delta
			if _wait >= END_S:
				phase = "over"
				view._bell()
		"back":
			_wait += delta
			var a: Vector3 = view.stage.boxers[0]["pos"]
			var b: Vector3 = view.stage.boxers[1]["pos"]
			if _wait >= BACK_S or Vector2(a.x - b.x, a.z - b.z).length() <= BACK_GAP_M:
				phase = ""
				view.stage.broadcast(true)   # back to the fight's lenses
				return
	if phase in ["down", "count", "end", "over", "back"]:
		_frame(delta)


## The beats the round script put right behind the count (a clinch entry, its tie-up and break, ~0.15-1.2 s after it) are
## gone: nobody fights a man on the canvas. Later beats play after BOX!; a caption stays.
func _drop_next(t0: float) -> void:
	var keep: Array = (view.beats as Array).slice(0, int(view.next))
	for i in range(int(view.next), (view.beats as Array).size()):
		var b: Dictionary = view.beats[i]
		if float(b["t"]) <= t0 + 1.5 and not (str(b["move"]) in ["say", "count"]):
			continue
		keep.append(b)
	view.beats = keep


## Both boxers leave the fight's footwork for the count: the downed one lies where he fell (the fight would turn his body to
## face the other), the standing one stands in his guard until he walks.
func _scene_on() -> void:
	view.stage.scene_mode(true)
	_scened = true
	view.stage.guard(1 - _down)
	phase = "down"


func _replay_due() -> bool:
	var r: Node = view.replay
	return r != null and (r.active() or float(r.get("_hit")) >= 0.0)


func _begin_count() -> void:
	var st: Node3D = view.stage
	var walker: Dictionary = st.boxers[1 - _down]
	var from: Vector3 = (walker["node"] as Node3D).position
	var body := _body_centre()
	var h := Stage.RING_M * 0.5 - NEUTRAL_IN_M
	var corners := [Vector3(-h, 0, h), Vector3(h, 0, -h)]
	var mark: Vector3 = corners[0] if body.distance_to(corners[0]) >= body.distance_to(corners[1]) else corners[1]
	_path = _route(from, mark)
	_body = body
	_lens = _count_lens(body, mark)
	phase = "count"
	_tick = TICK_S


func _count(delta: float) -> void:
	_walk(delta)
	_rise_watch()
	_tick -= delta
	if _tick > 0.0:
		return
	_tick += TICK_S
	# Each number holds its second: the word (KO / BOX! / STOPPED) comes on the tick after the last number.
	if _stop == "KO":
		if top >= KO_AT:
			_finish("KO")
		else:
			_number(top + 1)
		return
	# A standing count: on to the mandatory 8 (or his up_at, 9), held there until he stands.
	var last := maxi(MANDATORY, _up_at)
	if top >= last and _standing:
		if _stop == "RSC":
			_finish("STOPPED")
		else:
			_box()
		return
	if top < last:
		_number(top + 1)
	if not _rising and not _standing and top >= _up_at - RISE_COUNT:
		_rise()


func _number(n: int) -> void:
	top = n
	_show(str(n), UI.GOLD)


## His countdown clip from its rise (the canvas part before it is the same lying pose), the join smoother over the cut.
func _rise() -> void:
	_rising = true
	var bx: Dictionary = view.stage.boxers[_down]
	var ap: AnimationPlayer = bx["ap"]
	var clip := str(ap.current_animation if str(ap.current_animation) != "" else ap.assigned_animation)
	if not RISE_FROM.has(clip):
		_standing = true   # react_hurt and the like never went down
		view.stage.guard(_down)
		return
	if bx.get("js") != null:
		(bx["js"] as Node).join(0.15, 0.6)
	if str(ap.current_animation) == "":
		ap.play(clip)
	ap.speed_scale = 1.0
	ap.seek(maxf(float(RISE_FROM[clip]), ap.current_animation_position), true)


## Standing = his head back up (the clip's own rise); he is handed to his guard where the clip reaches it (back_s).
func _rise_watch() -> void:
	if not _rising:
		return
	var bx: Dictionary = view.stage.boxers[_down]
	var ap: AnimationPlayer = bx["ap"]
	var clip := str(ap.current_animation)
	if not _standing and _head_y(bx) >= STAND_HEAD_M * (bx["node"] as Node3D).scale.y:
		_standing = true
	if (RISE_TO.has(clip) and ap.current_animation_position >= float(RISE_TO[clip])) or (clip == "" and _standing):
		_rising = false
		_standing = true
		view.stage.guard(_down)


func _box() -> void:
	_show("BOX!", UI.GREEN)
	_flash = BOX_S
	_crew_clear()
	view.stage.scene_mode(false)
	_scened = false
	phase = "back"
	_wait = 0.0


func _finish(word: String) -> void:
	_show(word, UI.RED)
	_crew_clear()
	var st: Node3D = view.stage
	st.play(1 - _down, BeatClips.pick(BeatClips.WIN, st.has_move, view._amb_rng.randf()))
	phase = "end"
	_wait = 0.0


## The walk to the corner stops (BOX!, the stoppage word, a skipped round).
func _crew_clear() -> void:
	_path.clear()


## Straight to the mark, or round the lying body (a segment from his hips to his head, not a point: a man lying across the
## way is 1.6-1.8 m long) past whichever end makes the shorter walk.
func _route(from: Vector3, mark: Vector3) -> Array:
	var bx: Dictionary = view.stage.boxers[_down]
	var hips: Vector3 = (bx["node"] as Node3D).position
	var head := _head_ground(bx)
	if _seg_gap(from, mark, hips, head) >= CLEAR_M:
		return [mark]
	var mid := (hips + head) * 0.5
	var best: Array = [mark]
	var best_len := INF
	for end in [hips, head]:
		var out := Vector3(end.x - mid.x, 0.0, end.z - mid.z)
		var wp: Vector3 = end + (out.normalized() if out.length() > 0.01 else Vector3.RIGHT) * CLEAR_M
		wp = Vector3(clampf(wp.x, -ROPE_IN_M, ROPE_IN_M), 0.0, clampf(wp.z, -ROPE_IN_M, ROPE_IN_M))
		var length := from.distance_to(wp) + wp.distance_to(mark)
		if length < best_len:
			best_len = length
			best = [wp, mark]
	return best


## The closest the walk from p to q comes to the body segment a-b (on the canvas, sampled every 5 cm).
static func _seg_gap(p: Vector3, q: Vector3, a: Vector3, b: Vector3) -> float:
	var n := maxi(1, int(p.distance_to(q) / 0.05))
	var gap := INF
	for i in n + 1:
		var x := p.lerp(q, float(i) / n)
		var at := Vector2(x.x, x.z)
		gap = minf(gap, at.distance_to(Geometry2D.get_closest_point_to_segment(at, Vector2(a.x, a.z), Vector2(b.x, b.z))))
	return gap


func _head_ground(bx: Dictionary) -> Vector3:
	var skel: Skeleton3D = bx["skel"]
	var id := skel.find_bone("Head")
	if id < 0:
		return (bx["node"] as Node3D).position
	var head := skel.global_transform * skel.get_bone_global_pose(id).origin
	return Vector3(head.x, 0.0, head.z)


## Backing to the corner: facing the downed boxer, along the path at PACE_MS, on whichever step loop goes that way (a back
## step mostly, a side step when the corner is off to his side); at the mark, his guard.
func _walk(delta: float) -> void:
	var st: Node3D = view.stage
	var who := 1 - _down
	var walker: Dictionary = st.boxers[who]
	var n: Node3D = walker["node"]
	var face := atan2(_body.x - n.position.x, _body.z - n.position.z)
	n.rotation.y = lerp_angle(n.rotation.y, face, 1.0 - exp(-delta / FACE_S))
	if _path.is_empty():
		return
	var to: Vector3 = _path[0]
	var d := Vector3(to.x - n.position.x, 0.0, to.z - n.position.z)
	var stride := PACE_MS * delta
	if d.length() <= stride:
		n.position = Vector3(to.x, 0.0, to.z)
		_path.pop_front()
		return
	n.position += d.normalized() * stride


func _head_y(bx: Dictionary) -> float:
	var skel: Skeleton3D = bx["skel"]
	var id := skel.find_bone("Head")
	return (skel.global_transform * skel.get_bone_global_pose(id)).origin.y if id >= 0 else 0.0


## The knockout clip stops a hair before its end, so the finished-clip handover never stands him up.
func _hold_down() -> void:
	var ap: AnimationPlayer = view.stage.boxers[_down]["ap"]
	var clip := str(ap.current_animation)
	if clip.contains("knockout") and ap.current_animation_position >= ap.current_animation_length - HOLD_END_S:
		ap.speed_scale = 0.0


## The camera while the fight's own framing is off (scene mode): before the count the fight's pair lens, from the count on
## the count's own shot (it holds through the bell). The walker's place is where he is drawn.
func _frame(delta: float) -> void:
	var st: Node3D = view.stage
	var bx: Dictionary = st.boxers[1 - _down]
	if st.scene:
		var at := (bx["node"] as Node3D).position
		bx["pos"] = Vector3(at.x, 0.0, at.z)
	if st.camera == null:
		return
	if not _lens.is_empty() and phase in ["count", "end", "over", "back"]:
		st.camera.film(_lens["pos"], _lens["look"], float(_lens["fov"]), 0.0)
	elif not st.camera.close:
		st.broadcast(false, delta)
	st.camera.clear_view(st._ring_side, st.boxers[0]["pos"], st.boxers[1]["pos"], delta)


## Side-on to the line body -> corner, on whichever side has more room inside the ropes; the fov widens until both fit.
func _count_lens(body: Vector3, mark: Vector3) -> Dictionary:
	var line := Vector3(mark.x - body.x, 0.0, mark.z - body.z)
	var span := maxf(line.length(), 0.5)
	var mid := body.lerp(mark, LOOK_AT)
	var side := Vector3.UP.cross(line / span).normalized()
	var arc := Vector2(-RingCamera.SIDE_ARC_DEG, RingCamera.SIDE_ARC_DEG)
	var sp: Array = RingCamera.spot_inside(mid, side, LENS_DIST_M, 0.0, arc)
	var other: Array = RingCamera.spot_inside(mid, -side, LENS_DIST_M, 0.0, arc)
	if (bool(other[3]) and not bool(sp[3])) or (bool(other[3]) == bool(sp[3]) and float(other[1]) > float(sp[1])):
		sp = other
	var pos: Vector3 = (sp[0] as Vector3) + Vector3.UP * LENS_H
	var look := mid + Vector3.UP * LOOK_H
	var dist := maxf(Vector2(pos.x - look.x, pos.z - look.z).length(), 0.5)
	var half_w := (maxf(span * LOOK_AT, span * (1.0 - LOOK_AT)) + EDGE_M) * HUD_SPREAD
	var vfov := rad_to_deg(2.0 * atan(half_w / dist / ASPECT))
	return {"pos": pos, "look": look, "fov": clampf(vfov, 34.0, 70.0)}


## Where the downed body lies: halfway between his hips and his head on the canvas.
func _body_centre() -> Vector3:
	var bx: Dictionary = view.stage.boxers[_down]
	var skel: Skeleton3D = bx["skel"]
	var hips: Vector3 = (bx["node"] as Node3D).position
	var id := skel.find_bone("Head")
	if id >= 0:
		var head := skel.global_transform * skel.get_bone_global_pose(id).origin
		hips = (hips + Vector3(head.x, 0.0, head.z)) * 0.5
	return Vector3(hips.x, 0.0, hips.z)


func _show(text: String, colour: Color) -> void:
	shown = text
	if _label == null:
		return
	_label.text = text
	_label.add_theme_color_override("font_color", colour)
	_pop = 1.35 if text != "" else 1.0
