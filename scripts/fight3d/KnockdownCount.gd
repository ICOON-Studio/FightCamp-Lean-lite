extends Node
## S377 KNOCKCOUNT1 - what happens after a knockdown:
## - the fall plays and its slow-motion replay (KnockdownReplay); the round clock HOLDS from the count beat on;
## - the standing boxer backs off to the neutral corner farthest from the downed one on the fight's mocap back-step loop
##   moved by StepRoot, turned so the loop's travel points at the corner, and waits there facing him;
## - the count runs big under the banner, one number a second of the fight's own time;
## - no stoppage: the downed boxer gets up by the sim's `up_at`, the count runs on to the mandatory 8, BOX!;
## - "RSC": he gets up, the count ends in STOPPED; "KO": he stays on the canvas, the count goes to 10.
##   attach(view) -> Node   start(down, stop, up_at, fall_in)   holding() -> bool   stop()   phase, shown (probes read them)

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FightHud := preload("res://scripts/fight3d/FightHud.gd")
const RingCamera := preload("res://scripts/fight3d/RingCamera.gd")
const TvShot := preload("res://scripts/fight3d/TvShot.gd")
const UI := preload("res://scripts/ui/TV.gd")
const StepRoot := preload("res://scripts/fight3d/StepRoot.gd")
const RingFeet := preload("res://scripts/fight3d/RingFeet.gd")

const DOWN_S := 1.0          # the count starts this long after the fall (and after the replay, when one plays)
const TICK_S := 1.0          # one number a second
const MANDATORY := 8         # amateur rule: a standing count always runs to 8
const KO_AT := 10
const UP_AT := 6             # the sim's up_at for an opponent's heart 55 (Knockdowns), when the round has none
const RISE_COUNT := 3        # his rise starts this many numbers before up_at (the clips stand ~2.9-3.5 s after their rise)
const STAND_HEAD_M := 1.3    # up again: the head this high at scale 1 (a standing guard's head ~1.56 m, flat ~0.2 m)
const NEUTRAL_IN_M := 0.6    # the neutral corner mark: this far in from the posts on both axes (Referee._neutral)
const BOX_S := 0.9
const WALK_CLIP := "retreat" # the fight's back-step loop (FightClips.BAKED loc_retreat)
const WALK_SPEED := 0.6      # a calm back-step to the corner (1x is the fight's explosive retreat); StepRoot keeps the feet
const FACE_S := 0.12         # he turns to keep the downed boxer in front of him
const CLEAR_M := 0.8         # his path keeps this far from the lying body (hips to head), round its nearer end
const ROPE_IN_M := 2.45      # a detour waypoint stays this far in from the centre on both axes
const END_S := 1.6           # KO / STOPPED shows this long before the bell
const HOLD_END_S := 0.15     # a knockout clip freezes this close to its end (a finished clip would hand him to his guard)
const LENS_DIST_M := 3.4
const LENS_H := 1.9
const LOOK_H := 0.6
const LOOK_AT := 0.5         # the lens looks this far from the downed boxer toward the corner
const EDGE_M := 1.0          # room kept beyond each of them in the frame
const HUD_SPREAD := 1.35     # the body-map panels cover each side of the frame: both boxers stay in its middle 3/4
const BACK_GAP_M := 2.2      # after BOX! the count's lens holds until they are this close again (or BACK_S)
const BACK_S := 3.0
const OPEN_HALF := TvShot.OPEN_W * 0.5     # S379: the picture's open middle, as a share of its width from the centre (HUD panels outside)
const ASPECT := 16.0 / 9.0
const DOWN_LENS_DIST_M := 1.3   # S377: high over him (the overhead count shot) - only the canvas round him is in
const DOWN_LENS_H := 3.0
const DOWN_HALF_M := 1.0         # the count close-up: his head and body (hips to head), the walker out of it
const RISE_FROM := {"pro_knockout_countdown_v1": 23.0, "pro_knockout_countdown_v2": 24.0, "pro_knockout_countdown_v3": 26.0,
	"mc_knockout_count": 23.0}
const RISE_TO := {"pro_knockout_countdown_v1": 26.55, "pro_knockout_countdown_v2": 29.05, "pro_knockout_countdown_v3": 31.467,
	"mc_knockout_count": 26.55}

var view: Control
var phase := ""        # "" | "fall" | "down" | "count" | "end" | "over" | "back"
var shown := ""        # the count graphic's text (probes read it)
var top := 0           # the highest number counted this knockdown
var _down := -1
var _stop := ""
var _up_at := UP_AT
var _wait := 0.0
var _fall_in := 0.0
var _walking_off := false
var _mark := Vector3.ZERO
const KnockdownRing := preload("res://scripts/fight3d/KnockdownRing.gd")
const WALK_AFTER_S := 1.6   # S390: he turns and goes once the body has landed: planned earlier the route ran through where it fell
var _tick := 0.0
var _rising := false
var _standing := false
var _scened := false
var _label: Label
var _pop := 1.0
var _flash := 0.0
var _lens := {}        # the count shot: {pos, look, fov}
var _down_lens := {}   # the shot on the downed boxer while the other walks
var _path: Array = []  # the walker's waypoints to the neutral corner
var _body := Vector3.ZERO
var _clip_t := 0.0     # where his walk loop was last frame (StepRoot moves him by the clip's travel since then)


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
	FightHud.pin(_label, Vector4(0.5, 0, 0.5, 0), Vector4(-640, 110, 640, 270))


## Boxer `down` goes down; `stop` is the round's stoppage ("", "KO", "RSC"); the fall clip starts `fall_in` s from now.
func start(down: int, stop_how: String, up_at: int, fall_in: float) -> void:
	if phase != "": return
	_down = down; _stop = stop_how
	_up_at = clampi(up_at, 1, 9) if up_at > 0 else UP_AT
	_walking_off = false; _fall_in = fall_in; _wait = 0.0; _tick = TICK_S; top = 0
	_rising = false; _standing = false; _lens = {}; _down_lens = {}
	phase = "fall"
	_drop_next(float(view.t))
	_show("", UI.GOLD)


## True from the count beat until BOX! or the bell: the round clock holds (FightView._process).
func holding() -> bool:
	return phase in ["fall", "down", "count", "end"]


## Clears a count a skipped round or bout left (FightView.skip_round / skip_bout / play_round).
func stop() -> void:
	var r: Node = view.get("replay")
	if r != null and not r.active(): r.set("_hit", -1.0)
	if holding(): _crew_clear()
	_flash = 0.0; _show("", UI.GOLD)
	if _stop == "KO" and holding():
		if not _scened:
			view.stage.scene_mode(true); _scened = true
		phase = "over"; return
	if _scened and view.stage != null and view.stage.scene and phase != "over":
		view.stage.scene_mode(false)
	_scened = false; phase = ""


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
	if phase in ["fall", "down", "count"]:
		var bx: Dictionary = view.stage.boxers[_down]
		KnockdownRing.keep(bx["node"], bx["skel"], Stage.RING_M * 0.5, delta)
		KnockdownRing.clear(view.stage.boxers[1 - _down]["node"], bx["skel"], Stage.RING_M * 0.5, delta)
	match phase:
		"fall":
			_wait += delta
			if _wait >= _fall_in + 0.05:
				_scene_on()
		"down":
			_wait += delta
			# S390 (two judges: he stands on the fallen man's leg for 2 s): once the fall has landed the walk to the corner starts,
			# before the replay, so the replay's return finds them apart.
			if _wait >= _fall_in + WALK_AFTER_S:
				if not _walking_off:
					_plan_walk()
				_walk(delta)
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
			# S379 (C222): the count's lens is fixed - once either of them walks out of it the broadcast takes over.
			if _wait >= BACK_S or Vector2(a.x - b.x, a.z - b.z).length() <= BACK_GAP_M or not _both_in_lens():
				phase = ""
				view.stage.broadcast(true)   # back to the fight's lenses
				return
	if phase in ["down", "count", "end", "over", "back"]:
		_frame(delta)


## The beats the round script put right behind the count are gone: nobody fights a man on the canvas.
func _drop_next(t0: float) -> void:
	var keep: Array = (view.beats as Array).slice(0, int(view.next))
	for i in range(int(view.next), (view.beats as Array).size()):
		var b: Dictionary = view.beats[i]
		if float(b["t"]) <= t0 + 1.5 and not (str(b["move"]) in ["say", "count"]):
			continue
		keep.append(b)
	view.beats = keep


func _scene_on() -> void:
	view.stage.scene_mode(true)
	_scened = true
	view.stage.guard(1 - _down)
	phase = "down"


func _replay_due() -> bool:
	var r: Node = view.replay
	return r != null and (r.active() or float(r.get("_hit")) >= 0.0)


func _plan_walk() -> void:
	_walking_off = true
	var st: Node3D = view.stage
	var walker: Dictionary = st.boxers[1 - _down]
	var from: Vector3 = (walker["node"] as Node3D).position
	var body := _body_centre()
	var h := Stage.RING_M * 0.5 - NEUTRAL_IN_M
	var corners := [Vector3(-h, 0, h), Vector3(h, 0, -h)]
	_mark = corners[0] if body.distance_to(corners[0]) >= body.distance_to(corners[1]) else corners[1]
	_path = _route(from, _mark)
	_body = body


func _begin_count() -> void:
	_plan_walk()   # again from where he stands now, round where the body lies
	var from: Vector3 = (view.stage.boxers[1 - _down]["node"] as Node3D).position
	var body := _body_centre()
	var mark: Vector3 = _mark
	_body = body
	_lens = _count_lens(body, mark)
	_down_lens = _on_body_lens(body, mark, from)
	phase = "count"
	_tick = TICK_S


func _count(delta: float) -> void:
	_walk(delta)
	_rise_watch()
	_tick -= delta
	if _tick > 0.0:
		return
	_tick += TICK_S
	if _stop == "KO":
		if top >= KO_AT:
			_finish("KO")
		else:
			_number(top + 1)
		return
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


## His countdown clip from its rise, the join smoother over the cut.
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


## Standing = his head back up; he is handed to his guard where the clip reaches it.
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


func _crew_clear() -> void:
	_path.clear()


func _feet_ground(bx: Dictionary) -> Vector3:
	var skel: Skeleton3D = bx["skel"]
	var f_pos := Vector3.ZERO
	var count := 0
	for bone in ["LeftFoot", "RightFoot"]:
		var id := skel.find_bone(bone)
		if id >= 0:
			var lp := skel.global_transform * skel.get_bone_global_pose(id).origin
			f_pos += Vector3(lp.x, 0.0, lp.z)
			count += 1
	return (f_pos / float(count)) if count > 0 else (bx["node"] as Node3D).position


## Straight to the mark, or round the lying body past whichever end makes the shorter walk.
func _route(from: Vector3, mark: Vector3) -> Array:
	var bx: Dictionary = view.stage.boxers[_down]
	var hips: Vector3 = (bx["node"] as Node3D).position
	var head := _head_ground(bx)
	var feet := _feet_ground(bx)
	if _seg_gap(from, mark, hips, head) >= CLEAR_M and _seg_gap(from, mark, hips, feet) >= CLEAR_M:
		return [mark]
	var mid := (head + feet) * 0.5
	var best: Array = [mark]
	var best_len := INF
	for end in [head, feet]:
		var out := Vector3(end.x - mid.x, 0.0, end.z - mid.z)
		var wp: Vector3 = end + (out.normalized() if out.length() > 0.01 else Vector3.RIGHT) * (CLEAR_M + 0.15)
		wp = Vector3(clampf(wp.x, -ROPE_IN_M, ROPE_IN_M), 0.0, clampf(wp.z, -ROPE_IN_M, ROPE_IN_M))
		var length := from.distance_to(wp) + wp.distance_to(mark)
		if length < best_len:
			best_len = length
			best = [wp, mark]
	return best


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


## Backing to the corner: the back-step loop plays and the body goes where its planted foot pushes it (StepRoot).
func _walk(delta: float) -> void:
	var st: Node3D = view.stage
	var who := 1 - _down
	var walker: Dictionary = st.boxers[who]
	var n: Node3D = walker["node"]
	var ap: AnimationPlayer = walker["ap"]
	var skel: Skeleton3D = walker["skel"]
	if _path.is_empty():
		var face := atan2(_body.x - n.position.x, _body.z - n.position.z)
		n.rotation.y = lerp_angle(n.rotation.y, face, 1.0 - exp(-delta / FACE_S))
		return
	if RingFeet.on(st, walker):   # S391: he backs off on his own steps, in his guard, eyes on the body (no step clip)
		var way := atan2(_body.x - n.position.x, _body.z - n.position.z)
		n.rotation.y = lerp_angle(n.rotation.y, way, 1.0 - exp(-delta / FACE_S))
		if RingFeet.backing(st, who, _path[0], delta):
			_path.pop_front()
		return
	if str(ap.current_animation) != WALK_CLIP:
		if ap.has_animation(WALK_CLIP):
			ap.get_animation(WALK_CLIP).loop_mode = Animation.LOOP_LINEAR
		st.act(who, WALK_CLIP, WALK_SPEED)
		_clip_t = ap.current_animation_position
		return
	var t1 := ap.current_animation_position
	var step := skel.global_transform.basis * StepRoot.moved(ap, skel, WALK_CLIP, _clip_t, t1)
	_clip_t = t1
	step.y = 0.0
	var to: Vector3 = _path[0]
	var d := Vector3(to.x - n.position.x, 0.0, to.z - n.position.z)
	var head := skel.global_transform.basis * StepRoot.heading(ap, skel, WALK_CLIP)
	head.y = 0.0
	if head.length() > 0.01 and d.length() > 0.05:
		var foot := _planted(walker)
		var turn := head.signed_angle_to(d, Vector3.UP) * (1.0 - exp(-delta / FACE_S))
		n.rotation.y += turn
		var off := Vector3(foot.x - n.position.x, 0.0, foot.z - n.position.z)
		n.position += off - off.rotated(Vector3.UP, turn)
	if d.length() <= step.length() + 0.02:
		n.position = Vector3(to.x, 0.0, to.z)
		_path.pop_front()
		if _path.is_empty():
			st.guard(who)
		return
	n.position += step


func _planted(bx: Dictionary) -> Vector3:
	var skel: Skeleton3D = bx["skel"]
	var low := Vector3.INF
	for bone in StepRoot.FEET:
		var at := skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin
		if not low.is_finite() or at.y < low.y: low = at
	return low


func _head_y(bx: Dictionary) -> float:
	var skel: Skeleton3D = bx["skel"]
	var id := skel.find_bone("Head")
	return (skel.global_transform * skel.get_bone_global_pose(id)).origin.y if id >= 0 else 0.0


func _hold_down() -> void:
	var ap: AnimationPlayer = view.stage.boxers[_down]["ap"]
	var clip := str(ap.current_animation)
	if clip.contains("knockout") and ap.current_animation_position >= ap.current_animation_length - HOLD_END_S:
		ap.speed_scale = 0.0


func _frame(delta: float) -> void:
	var st: Node3D = view.stage
	var bx: Dictionary = st.boxers[1 - _down]
	if st.scene:
		var at := (bx["node"] as Node3D).position
		bx["pos"] = Vector3(at.x, 0.0, at.z)
	if st.camera == null:
		return
	# S379 (C222): the overhead stays on him while he is down; as he starts to get up, a straight cut to the count's wider
	# fixed shot (the overhead framed only the canvas round him - his head rose out of it).
	if not _down_lens.is_empty() and phase == "count" and not _path.is_empty() and not (_rising or _standing):
		st.camera.film(_down_lens["pos"], _down_lens["look"], float(_down_lens["fov"]), 0.0)
	elif not _lens.is_empty() and phase in ["count", "end", "over", "back"]:
		st.camera.film(_lens["pos"], _lens["look"], float(_lens["fov"]), 0.0)
	elif not st.camera.close:
		st.broadcast(false, delta)
	st.camera.clear_view(st._ring_side, st.boxers[0]["pos"], st.boxers[1]["pos"], delta)


## Both boxers' heads and feet are in the open middle of the stage camera's picture: within OPEN_HALF of the width from
## its centre (the body-map panels cover the outer ~18 % of each side).
func _both_in_lens() -> bool:
	var cam: Camera3D = view.stage.camera
	var w := cam.get_viewport().get_visible_rect().size.x
	for bx in view.stage.boxers:
		var skel: Skeleton3D = bx["skel"]
		for bone in ["Head", "LeftFoot", "RightFoot"]:
			var id := skel.find_bone(bone)
			var p := skel.global_transform * skel.get_bone_global_pose(id).origin if id >= 0 else Vector3.INF
			if id >= 0 and (not cam.is_position_in_frustum(p) or absf(cam.unproject_position(p).x - w * 0.5) > w * OPEN_HALF):
				return false
	return true


func _count_lens(body: Vector3, mark: Vector3) -> Dictionary:
	var line := Vector3(mark.x - body.x, 0.0, mark.z - body.z)
	var span := maxf(line.length(), 0.5)
	var mid := body.lerp(mark, 0.38)
	var side := Vector3.UP.cross(line / span).normalized()
	var arc := Vector2(-RingCamera.SIDE_ARC_DEG, RingCamera.SIDE_ARC_DEG)
	var sp: Array = RingCamera.spot_inside(mid, side, LENS_DIST_M, 0.0, arc)
	var other: Array = RingCamera.spot_inside(mid, -side, LENS_DIST_M, 0.0, arc)
	if (bool(other[3]) and not bool(sp[3])) or (bool(other[3]) == bool(sp[3]) and float(other[1]) > float(sp[1])):
		sp = other
	var pos: Vector3 = (sp[0] as Vector3) + Vector3.UP * LENS_H
	var look := mid + Vector3.UP * LOOK_H
	var dist := maxf(Vector2(pos.x - look.x, pos.z - look.z).length(), 0.5)
	var half_w := (maxf(span * 0.38, span * 0.62) + 1.25) * 1.45
	var vfov := rad_to_deg(2.0 * atan(half_w / dist / ASPECT))
	return {"pos": pos, "look": look, "fov": clampf(vfov, 36.0, 70.0)}


func _on_body_lens(body: Vector3, mark: Vector3, walker: Vector3) -> Dictionary:
	var line := Vector3(mark.x - body.x, 0.0, mark.z - body.z)
	var side := Vector3.UP.cross(line.normalized()) if line.length() > 0.05 else Vector3.BACK
	if side.dot(Vector3(walker.x - body.x, 0.0, walker.z - body.z)) > 0.0: side = -side
	var arc := Vector2(-RingCamera.SIDE_ARC_DEG, RingCamera.SIDE_ARC_DEG)
	var sp: Array = RingCamera.spot_inside(body, side, DOWN_LENS_DIST_M, 0.0, arc)
	if not bool(sp[3]):
		var other: Array = RingCamera.spot_inside(body, -side, DOWN_LENS_DIST_M, 0.0, arc)
		if bool(other[3]): sp = other
	var pos: Vector3 = (sp[0] as Vector3) + Vector3.UP * DOWN_LENS_H
	var look := body + Vector3.UP * 0.1
	return {"pos": pos, "look": look, "fov": clampf(rad_to_deg(2.0 * atan(DOWN_HALF_M / pos.distance_to(look))), 30.0, 60.0)}


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
	if _label == null: return
	_label.text = text
	_label.add_theme_color_override("font_color", colour)
	_pop = 1.35 if text != "" else 1.0
