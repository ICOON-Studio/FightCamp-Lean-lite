extends Node
## S307 the fight's intro, once before round 1 (docs/FIGHT_NIGHT_SCRIPT.md v2 "Intro", Q-S294-12): both boxers in their
## corners with their teams on the apron, the announcer names each (caption: corner, club, record) while she raises a
## glove, both walk to the centre and touch gloves, "seconds out", the bell. About 13 s; SKIP jumps to the bell. Same
## film look as the corner minute (CornerOverlay's letterbox, CornerCrew's walking and hands).
##   run(view, stage, crew, ctx)   ctx = {names: [full names], intros: [caption lines]}   emits done

const CornerShots := preload("res://scripts/fight3d/CornerShots.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")

signal done

const LENGTH_S := 13.0
## [start s, framing]
const SHOTS := [[0.0, "wide"], [2.0, "red"], [5.0, "blue"], [8.0, "broadcast"], [10.1, "two_shot"], [11.6, "wide_out"]]
## [s, cue]
const CUES := [[0.0, "corners"], [2.0, "name_red"], [2.6, "raise_red"], [4.4, "lower_red"], [5.0, "name_blue"], [5.6, "raise_blue"],
	[7.4, "lower_blue"], [8.0, "walk"], [10.4, "touch"], [11.3, "untouch"], [11.6, "seconds_out"], [12.6, "bell"]]

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


func _process(delta: float) -> void:
	t += delta
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
			# The whole ring from high at the side, a slow push in.
			var p := side * 7.2 + Vector3.UP * 2.7
			return {"pos": p, "look": Vector3.UP * 0.8, "fov": 42.0, "focus": 7.0, "drift": -side * 0.9}
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


## Both stand in front of their stools' place in their guard; each corner's coach and second on the apron behind.
func cue_corners() -> void:
	for side in ["red", "blue"]:
		var c: Dictionary = crew.corner(side)
		var i := 0 if side == "red" else 1
		var at := (c["seat"] as Vector3) + (c["d"] as Vector3) * 0.2
		crew.place(stage.boxers[i], at, crew.yaw_to(at, Vector3.ZERO))
		stage.guard(i)
		var pre := "" if side == "red" else "blue_"
		var l: Vector3 = c["l"]
		for k in [["coach", -0.85, "af_idle_foldarms"], ["second", 0.85, "af_idle"]]:
			var a: Dictionary = crew.actors[pre + str(k[0])]
			var spot := (c["seat"] as Vector3) + l * float(k[1]) - (c["d"] as Vector3) * 0.1
			crew.place(a, spot, crew.yaw_to(spot, Vector3.ZERO))
			crew.play(a, str(k[2]))
			(a["node"] as Node3D).visible = true


func cue_name_red() -> void:
	ui.say(str(ctx["intros"][0]))


func cue_name_blue() -> void:
	ui.say(str(ctx["intros"][1]))


func cue_raise_red() -> void:
	_raise(0, true)
	crew.play(crew.actors["coach"], "af_nod_yes")


func cue_lower_red() -> void:
	_raise(0, false)


func cue_raise_blue() -> void:
	_raise(1, true)
	crew.play(crew.actors["blue_coach"], "af_nod_yes")


func cue_lower_blue() -> void:
	_raise(1, false)


## Her rear glove up above her head to the crowd (her hand IK), then back to the guard.
func _raise(i: int, up: bool) -> void:
	var a: Dictionary = stage.boxers[i]
	var hand: String = str(stage.hand_of(i, "RightHand")).trim_suffix("Hand")
	if not up:
		a["ik"].reach(hand, null)
		return
	a["ik"].reach(hand, func():
		return CornerShots.bone(a, "Head") + Vector3.UP * 0.32 * (a["node"] as Node3D).scale.x + CornerShots.fwd(a) * 0.08 - CornerShots.side(a) * 0.12)


## To the centre, a jab's length apart, facing.
func cue_walk() -> void:
	ui.say("")
	var axis := ((crew.corner("blue")["seat"] as Vector3) - (crew.corner("red")["seat"] as Vector3)).normalized()
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		var mark: Vector3 = axis * (stage.gap_m + 0.1) * (-0.5 if i == 0 else 0.5)
		var face := crew.yaw_to(mark, Vector3.ZERO)
		crew.walk(a, mark, func(): crew.turn(a, face, func(): stage.guard(i)))


## The touch: both lead gloves meet between them at chest height.
func cue_touch() -> void:
	var mid := (CornerShots.bone(stage.boxers[0], "Chest") + CornerShots.bone(stage.boxers[1], "Chest")) * 0.5 + Vector3.UP * 0.05
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		var hand: String = str(stage.hand_of(i, "LeftHand")).trim_suffix("Hand")
		var toward := (CornerShots.pos(stage.boxers[1 - i]) - CornerShots.pos(a)).normalized()
		a["ik"].reach(hand, func(): return mid - toward * 0.06)
		crew.look(a, stage.boxers[1 - i])


func cue_untouch() -> void:
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		a["ik"].reach("Left", null)
		a["ik"].reach("Right", null)


func cue_seconds_out() -> void:
	ui.say("\"Seconds out!\"")
	for a in crew.actors.values():
		(a["node"] as Node3D).visible = false


func cue_bell() -> void:
	ui.say("")


## The bell: the fight takes the boxers back where they stand, ROUND 1 starts.
func finish() -> void:
	if not is_inside_tree():
		return
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		a["ik"].reach("Left", null)
		a["ik"].reach("Right", null)
		crew.look(a, null)
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
