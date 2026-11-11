extends Node
## S307 the fight's intro, once before round 1 (docs/FIGHT_NIGHT_SCRIPT.md v2 "Intro", Q-S294-12): both boxers in their
## corners with their teams behind them, each warming up HER way (IntroStyle: a showman celebrates, a worker
## shadow-boxes, a nervous one fidgets; the two never on the same clip), the tale of the tape, the announcer names each
## (caption: corner, club, record) while she celebrates or raises a glove, both walk to the centre and touch gloves,
## "seconds out", the bell. About 24 s; SKIP jumps to the bell. Same film look as the corner minute.
## S436: ONE clock. The camera's shots and the cues are written from the same T_ marks (the seat's round had the
## camera 4.5 s ahead: the red name call was filmed on the blue boxer, the blue one on an empty ring).
## S436 (operator on the dark tape card: "thats terrible i asked to be switched with the one that was shown when
## negotiating a contract"): the tape beat is the bout offer's versus picture (TapeVersus), without its buttons.
##   run(view, stage, crew, ctx)   ctx = {names: [full names], intros: [caption lines]}   emits done

const CornerShots := preload("res://scripts/fight3d/CornerShots.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")
const TapeVersus := preload("res://scripts/ui/TapeVersus.gd")
const CornerStart := preload("res://scripts/fight3d/CornerStart.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const RingFeet := preload("res://scripts/fight3d/RingFeet.gd")
const CornerWarm := preload("res://scripts/fight3d/CornerWarm.gd")
const IntroStyle := preload("res://scripts/fight3d/IntroStyle.gd")

signal done

## S379 ("skip the walk in for the clips"): films open in the corners and walk to the centre (CornerStart); set by the
## film tools or the user arg `fromcorners`. The game's own fight keeps the full intro.
static var from_corners := false

## S310 (operator: "add the tale of the tape when the fighters stand on their starting corners for a while").
const WARM_S := IntroStyle.SEG_S * 2.0     # 7.4 s: the wide, then one look at each corner's own warm-up
const TAPE_S := 4.5
const NAME_S := IntroStyle.NAME_S
## S391 the walk to the centre is a boxer's step pairs in her guard (RingFeet), slower than af_walk: the touch waits for it.
const WALK_S := 4.3
const TOUCH_LEAN_M := 0.03   # S391: leaned in her stance the glove's face tips down, the touch reads 5 cm short (corner_film 0.139 vs 0.089)
const T_TAPE := WARM_S
const T_RED := T_TAPE + TAPE_S
const T_BLUE := T_RED + NAME_S
const T_WALK := T_BLUE + NAME_S
const T_TOUCH := T_WALK + WALK_S
const LENGTH_S := T_TOUCH + 2.6
## [start s, framing] (docs/TV_CAMERA_RULES.md: no shot under 2 s).
const SHOTS := [[0.0, "wide"], [2.6, "red"], [5.0, "blue"], [T_TAPE, "tape"], [T_RED, "red"], [T_BLUE, "blue"],
	[T_WALK, "broadcast"], [T_TOUCH - 0.3, "two_shot"]]
## [s, cue]
const CUES := [[0.0, "corners"], [T_TAPE, "tape"], [T_RED - 0.5, "untape"],
	[T_RED, "name_red"], [T_RED + 0.3, "raise_red"], [T_BLUE - 0.3, "lower_red"],
	[T_BLUE, "name_blue"], [T_BLUE + 0.3, "raise_blue"], [T_WALK - 0.3, "lower_blue"],
	[T_WALK, "walk"], [T_TOUCH, "touch"], [T_TOUCH + 0.9, "untouch"], [T_TOUCH + 1.2, "seconds_out"], [T_TOUCH + 2.2, "bell"]]

var view: Node
var stage: Node3D
var crew: CornerCrew
var ctx: Dictionary
var ui: Control
var t := 0.0
var _cue_i := 0
var _shot := ""
var _shot_t0 := 0.0
var _frame: Dictionary = {}
var _tape: Control = null
var corners: RefCounted = null  # S379: the corner-start opening (CornerStart) when it plays instead
var _warm := [{}, {}]           # per boxer: the clip she is on now {clip, from, to} ({} = none)
var _warming := false
var _plans := [{}, {}]          # per boxer: IntroStyle's plan {style, warm, name, hold}
var _seg := [-1, -1]            # per boxer: the warm-up segment she is on
var _named := [false, false]    # per boxer: her name call is on (the warm-up leaves her alone)
var _drop_at := [-1.0, -1.0]    # per boxer: when a raised glove comes down by itself (a nervous boxer's quick one)


func run(v: Node, s: Node3D, c: CornerCrew, context: Dictionary) -> void:
	view = v
	stage = s
	crew = c
	ctx = context
	stage.scene_mode(true)
	crew.set_shown(true)
	for a in crew.actors.values():
		(a["node"] as Node3D).visible = false
	for k in crew.props:
		(crew.props[k] as Node3D).visible = false
	ui = CornerOverlay.new()
	view.add_child(ui)
	ui.build_intro()
	ui.skip.connect(finish)
	_plan_intros()
	if from_corners or OS.get_cmdline_user_args().has("fromcorners"):
		corners = CornerStart.new()
		corners.start(self)


func _process(delta: float) -> void:
	t += delta
	_tick_warm()
	if corners != null:
		corners.tick(delta)
		return
	while _cue_i < CUES.size() and float(CUES[_cue_i][0]) <= t:
		call("cue_" + str(CUES[_cue_i][1]))
		_cue_i += 1
	crew.tick(delta)
	_camera(delta)
	if t >= LENGTH_S:
		finish()


func _camera(delta: float) -> void:
	var due := ""
	for s in SHOTS:
		if float(s[0]) <= t:
			due = str(s[1])
	if due != _shot:
		_shot = due
		_shot_t0 = t
		_frame = _framing(due)
	var cam: Camera3D = stage.camera
	if _shot == "broadcast":
		cam.broadcast(CornerShots.pos(stage.boxers[0]), CornerShots.pos(stage.boxers[1]), false, delta)
		return
	if _frame.is_empty():
		return
	var u := clampf((t - _shot_t0) / 3.0, 0.0, 1.0)
	cam.film((_frame["pos"] as Vector3) + (_frame["drift"] as Vector3) * u, _frame["look"], float(_frame["fov"]), float(_frame["focus"]))


## The intro's framings, from the ring and where the boxers stand.
func _framing(shot: String) -> Dictionary:
	var red: Dictionary = crew.corner("red")
	var blue: Dictionary = crew.corner("blue")
	var side := ((blue["seat"] as Vector3) - (red["seat"] as Vector3)).normalized().cross(Vector3.UP).normalized()
	match shot:
		"wide", "wide_out":
			# The whole ring from high over the neutral corner, a slow crane down. S380 (operator on a still through the
			# ropes: "i thought you fixed the ropes, why old problems appear again?"): it stood 7.2 m out, outside the ropes;
			# now inside them (CornerStart.corner_wide), framed on both corner marks.
			return CornerStart.corner_wide(side, [_corner_mark(0), _corner_mark(1)], _scales(), 3.4, 0.8, Vector3.DOWN * 0.3)
		"tape":
			# Both in their corners, square on from the side and level, so the card sits in the gap between them (S380: from
			# the neutral corner inside the ropes, not 8.4 m out), a slow push in.
			return CornerStart.corner_wide(side, [_corner_mark(0), _corner_mark(1)], _scales(), 1.6, 1.1, -side * 0.3)
		"red", "blue":
			# Medium on her in her corner, low, the corner team behind her.
			var c: Dictionary = red if shot == "red" else blue
			var a: Dictionary = stage.boxers[0 if shot == "red" else 1]
			var at := CornerShots.pos(a)
			var p := at + (c["d"] as Vector3) * 3.1 + (c["l"] as Vector3) * 0.6 + Vector3.UP * 0.9
			var look := at + Vector3.UP * 1.3
			return {"pos": p, "look": look, "fov": 36.0, "focus": p.distance_to(look), "drift": -(c["d"] as Vector3) * 0.5}
		"two_shot":
			# Close two-shot from the side: the gloves touch.
			var mid := (CornerShots.pos(stage.boxers[0]) + CornerShots.pos(stage.boxers[1])) * 0.5
			var p := mid + side * 2.3 + Vector3.UP * 1.4
			var look := mid + Vector3.UP * 1.25
			return {"pos": p, "look": look, "fov": 30.0, "focus": p.distance_to(look), "drift": side * -0.15}
	return {}


func _scales() -> Array:
	return [(stage.boxers[0]["node"] as Node3D).scale.y, (stage.boxers[1]["node"] as Node3D).scale.y]


## Her corner mark: in front of her stool's place.
func _corner_mark(i: int) -> Vector3:
	var c: Dictionary = crew.corner("red" if i == 0 else "blue")
	return (c["seat"] as Vector3) + (c["d"] as Vector3) * 0.2


## Both stand in front of their stools' place in their guard; each corner's coach and second on the apron behind.
func cue_corners() -> void:
	for side in ["red", "blue"]:
		var c: Dictionary = crew.corner(side)
		var i := 0 if side == "red" else 1
		stage._ropes.part(i, Vector3.ZERO, 0.0)
		stage.boxers[i]["ik"].upright(0.0)
		(stage.boxers[i]["node"] as Node3D).visible = true
		var at := _corner_mark(i)
		# S317: she walked here from the ropes; placed only when she has not arrived (a skip, a slow walk).
		if CornerShots.pos(stage.boxers[i]).distance_to(at) > 0.3:
			crew.place(stage.boxers[i], at, crew.yaw_to(at, Vector3.ZERO))
			stage.guard(i)
		var pre := "" if side == "red" else "blue_"
		var l: Vector3 = c["l"]
		for k in [["coach", -0.7, "af_idle_foldarms"], ["second", 0.7, "af_idle"]]:
			var a: Dictionary = crew.actors[pre + str(k[0])]
			var spot := (c["post"] as Vector3) - (c["d"] as Vector3) * 1.15 + l * float(k[1])   # S400 operator: corner team on the floor, past the apron
			crew.place(a, spot, crew.yaw_to(spot, Vector3.ZERO), -1.08)   # RingSet's arena floor (was on the ring: legs through the ropes)
			crew.play(a, str(k[2]))
			(a["node"] as Node3D).visible = true
	if not _has_nowarm():
		_start_warm()


static func _has_nowarm() -> bool:
	return OS.get_cmdline_user_args().has("nowarm") or OS.get_cmdline_user_args().has("--nowarm") or OS.get_cmdline_args().has("--nowarm")


## Each boxer's own intro (IntroStyle): the player's fighter from her personality, the opponent from her name.
func _plan_intros() -> void:
	var ap: AnimationPlayer = stage.boxers[0]["ap"]
	var segments := int(ceil(T_BLUE / IntroStyle.SEG_S)) + 1
	_plans = IntroStyle.plan_pair(ctx.get("personality_red", {}), ctx.get("personality_blue", {}), int(ctx.get("seed", 0)),
		ap.has_animation, func(c: String) -> float: return ap.get_animation(c).length if ap.has_animation(c) else 0.0, segments)


func _start_warm() -> void:
	_warming = true
	_seg = [-1, -1]
	_tick_warm()


## The segment the clock is in, per boxer; a clip shorter than its segment loops inside it.
func _tick_warm() -> void:
	if not _warming:
		return
	if corners != null and str(corners.get("phase")) != "corners":
		_end_warm()
		return
	for i in 2:
		if _drop_at[i] >= 0.0 and t >= _drop_at[i]:
			_drop_at[i] = -1.0
			_raise(i, false)
		if _named[i]:
			_loop(i)
			continue
		var warm: Array = (_plans[i] as Dictionary).get("warm", [])
		if warm.is_empty():
			continue
		var k := mini(int(t / IntroStyle.SEG_S), warm.size() - 1)
		if k != _seg[i]:
			_seg[i] = k
			_warm[i] = warm[k]
			crew.play(stage.boxers[i], str(_warm[i]["clip"]), 1.0, float(_warm[i]["from"]), Vector2(0.2, 0.45))
		_loop(i)


## Her clip ran to its window's end (or stopped): back to the window's start through a short join.
func _loop(i: int) -> void:
	if (_warm[i] as Dictionary).is_empty():
		return
	var ap: AnimationPlayer = stage.boxers[i]["ap"]
	var clip := str(_warm[i]["clip"])
	if ap.current_animation != clip or not ap.is_playing() or ap.current_animation_position >= float(_warm[i]["to"]) - 0.02:
		crew.play(stage.boxers[i], clip, 1.0, float(_warm[i]["from"]), Vector2(0.15, 0.35))


func _end_warm() -> void:
	if not _warming:
		return
	_warming = false
	_warm = [{}, {}]
	_named = [false, false]
	for i in 2:
		_drop_at[i] = -1.0
		_raise(i, false)
		stage.guard(i)


## The tale of the tape: the bout offer's versus picture over the ring (no buttons: the bout is on), faded in and out.
func cue_tape() -> void:
	if view.get("main") == null or str(view.get("fid")) == "":
		return   # a film tool's stage without a career: no tape
	_tape = PanelContainer.new()
	_tape.name = "IntroTape"
	_tape.set_anchors_preset(Control.PRESET_FULL_RECT)
	_tape.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tape.modulate.a = 0.0
	ui.add_child(_tape)   # over the film bars: the picture fills the screen as it does at the bout offer
	ui.move_child(ui._skip, -1)   # SKIP stays on top and clickable ...
	_skip_at(Vector4(0.5, 1, 0.5, 1), Vector4(-136, -64, 136, -16))   # ... at the bottom, off the blue corner's name
	TapeVersus.mount(_tape, view.main, {"fid": str(view.fid), "total": int(view.get("total"))}, false)
	_fade(_tape, true)


func cue_untape() -> void:
	_fade(_tape, false)
	_skip_at(Vector4(1, 0, 1, 0), Vector4(-300, 22, -28, 70))   # CornerOverlay's own place for it


func _skip_at(anchors: Vector4, offsets: Vector4) -> void:
	var b: Button = ui._skip
	b.anchor_left = anchors.x
	b.anchor_top = anchors.y
	b.anchor_right = anchors.z
	b.anchor_bottom = anchors.w
	b.offset_left = offsets.x
	b.offset_top = offsets.y
	b.offset_right = offsets.z
	b.offset_bottom = offsets.w


func _fade(card: Control, on: bool) -> void:
	if card == null:
		return
	card.create_tween().tween_property(card, "modulate:a", 1.0 if on else 0.0, 0.4)


func cue_name_red() -> void:
	ui.say(str(ctx["intros"][0]))


func cue_name_blue() -> void:
	ui.say(str(ctx["intros"][1]))


func cue_raise_red() -> void:
	_name_call(0)


func cue_lower_red() -> void:
	_name_over(0)


func cue_raise_blue() -> void:
	_name_call(1)


func cue_lower_blue() -> void:
	_name_over(1)


## Her name is called: a showman celebrates (a clip of her own), the others raise a glove over their bounce - a nervous
## one only for a moment.
func _name_call(i: int) -> void:
	var nm: Dictionary = (_plans[i] as Dictionary).get("name", {})
	_named[i] = true
	if str(nm.get("clip", "")) != "":
		_warm[i] = nm
		crew.play(stage.boxers[i], str(nm["clip"]), 1.0, float(nm["from"]), Vector2(0.2, 0.45))
		return
	_hold(i)
	_raise(i, true)
	_drop_at[i] = t + float(nm.get("raise_s", 2.4))


## After her call she stays loose on her hold clip until the walk.
func _name_over(i: int) -> void:
	_drop_at[i] = -1.0
	_raise(i, false)
	_hold(i)


func _hold(i: int) -> void:
	var hold := str((_plans[i] as Dictionary).get("hold", ""))
	var ap: AnimationPlayer = stage.boxers[i]["ap"]
	if hold == "" or not ap.has_animation(hold):
		_warm[i] = {}
		stage.guard(i)
		return
	_warm[i] = {"clip": hold, "from": 0.0, "to": ap.get_animation(hold).length}
	crew.play(stage.boxers[i], hold, 1.0, 0.0, Vector2(0.2, 0.45))


## Her rear glove up to the crowd (her hand IK), then back to the guard.
## S359 ("wtf is this ??": the glove sat on her head): above the raising arm's own shoulder, out to that side (RAISE m).
const RAISE := Vector3(0.32, 0.3, 0.14)   # S400 (operator: "the shoulder joint seems broken"): 0.46 straight up forced ~160 deg


func _raise(i: int, up: bool) -> void:
	var a: Dictionary = stage.boxers[i]
	var hand: String = str(stage.hand_of(i, "RightHand")).trim_suffix("Hand")
	var other: String = str(stage.hand_of(i, "LeftHand")).trim_suffix("Hand")
	if not up:
		a["ik"].reach(hand, null)
		a["ik"].reach(other, null)
		return
	a["ik"].reach(other, func(): return CornerShots.low_glove(a, other))   # S399: the free glove off her face
	var out := 1.0 if hand == "Left" else -1.0   # side() is her own left
	a["ik"].reach(hand, func():
		var s: float = (a["node"] as Node3D).scale.x
		return CornerShots.bone(a, hand + "UpperArm") + (Vector3.UP * RAISE.x + CornerShots.side(a) * out * RAISE.y
			+ CornerShots.fwd(a) * RAISE.z) * s)


## To the centre, a jab's length apart, facing.
func cue_walk() -> void:
	_end_warm()
	ui.say("")
	var axis := ((crew.corner("blue")["seat"] as Vector3) - (crew.corner("red")["seat"] as Vector3)).normalized()
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		var mark: Vector3 = axis * (stage.gap_m + 0.1) * (-0.5 if i == 0 else 0.5)
		var face := crew.yaw_to(mark, Vector3.ZERO)
		crew.walk(a, mark, func(): crew.turn(a, face, func(): stage.guard(i)))


## The touch: both lead gloves meet between them at chest height without passing through each other.
func cue_touch() -> void:
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		var hand: String = str(stage.hand_of(i, "LeftHand")).trim_suffix("Hand")
		var rear: String = str(stage.hand_of(i, "RightHand")).trim_suffix("Hand")
		var lean := TOUCH_LEAN_M if RingFeet.on(stage, a) else 0.0
		# S436: read every frame - she straightens up after this cue, and a point fixed here left the gloves 10 cm apart
		a["ik"].reach(hand, func(): return CornerShots.touch_at(stage.boxers, i, lean))
		# S436 (operator on the two-shot: "this pose is wrong, not normal"): the rear glove was held low beside the lead
		# one, so both gloves pushed out together from a hunched back. A glove touch is ONE glove out; the other arm
		# hangs loose by her own hip, and she stands up out of her crouch for it.
		a["ik"].reach(rear, func(): return _rest_glove(a, rear))
		a["ik"].upright(TOUCH_UPRIGHT_DEG)
		a["ik"].loosen(TOUCH_LOOSE)   # S437: shoulders down out of the guard's shrug, the neck back over the trunk
		crew.look(a, stage.boxers[1 - i])


## Her resting glove at the touch: down by her own hip, a little forward and out (off her thigh).
const TOUCH_UPRIGHT_DEG := 9.0
const TOUCH_LOOSE := 0.8
const REST := Vector3(0.10, 0.02, 0.27)   # forward, below the hips bone, out to her side (m at scale 1)


func _rest_glove(a: Dictionary, hand: String) -> Vector3:
	var s: float = (a["node"] as Node3D).scale.x
	var out := 1.0 if hand == "Left" else -1.0   # side() is her own left
	return CornerShots.bone(a, "Hips") + (CornerShots.fwd(a) * REST.x - Vector3.UP * REST.y + CornerShots.side(a) * out * REST.z) * s


func cue_untouch() -> void:
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		a["ik"].reach("Left", null)
		a["ik"].reach("Right", null)
		a["ik"].upright(0.0)
		a["ik"].loosen(0.0)


func cue_seconds_out() -> void:
	ui.say("\"Seconds out!\"")
	for a in crew.actors.values():
		(a["node"] as Node3D).visible = false


func cue_bell() -> void:
	ui.say("")


## The bell: the fight takes the boxers back where they stand, ROUND 1 starts.
func finish() -> void:
	if not is_inside_tree() or not is_processing():
		return
	_end_warm()
	# S308: skipped from a button, this node stays in the tree to the frame's end; its _process must not film again
	# (round 1 opened stuck on the intro's wide lens).
	set_process(false)
	if corners != null:
		corners.stop()
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		a["ik"].reach("Left", null)
		a["ik"].reach("Right", null)
		a["ik"].upright(0.0)
		a["ik"].loosen(0.0)
		crew.look(a, null)
		(a["node"] as Node3D).visible = true
	stage._ropes.calm = false
	for i in 2:
		stage._ropes.part(i, Vector3.ZERO, 0.0)
		stage.boxers[i]["ik"].upright(0.0)
	_marks()
	crew.set_shown(false)
	stage.scene_mode(false)
	stage.broadcast(true)
	ui.queue_free()
	queue_free()
	done.emit()


## Skipped before they reached the centre: both on their marks (the cut to round 1 hides it).
func _marks() -> void:
	var axis := ((crew.corner("blue")["seat"] as Vector3) - (crew.corner("red")["seat"] as Vector3)).normalized()
	for i in 2:
		var mark: Vector3 = axis * stage.gap_m * (-0.5 if i == 0 else 0.5)
		if CornerShots.pos(stage.boxers[i]).distance_to(mark) > 0.3:
			crew.place(stage.boxers[i], mark, crew.yaw_to(mark, Vector3.ZERO))
