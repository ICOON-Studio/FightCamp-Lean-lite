extends Node
## S307 the fight's intro, once before round 1 (docs/FIGHT_NIGHT_SCRIPT.md v2 "Intro", Q-S294-12): both boxers in their
## corners with their teams on the apron, the announcer names each (caption: corner, club, record) while she raises a
## glove, both walk to the centre and touch gloves, "seconds out", the bell. About 13 s; SKIP jumps to the bell. Same
## film look as the corner minute (CornerOverlay's letterbox, CornerCrew's walking and hands).
##   run(view, stage, crew, ctx)   ctx = {names: [full names], intros: [caption lines]}   emits done

const CornerShots := preload("res://scripts/fight3d/CornerShots.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")
const TapeCard := preload("res://scripts/fight3d/TapeCard.gd")

signal done

## S310 (operator: "add the tale of the tape when the fighters stand on their starting corners for a while"): after the
## opening wide, both hold in their corners TAPE_S while the tale of the tape (TaleOfTape / TapeCard) sits between them
## on a level side shot; the announcer's names follow.
const TAPE_S := 5.5
## S317 (operator S316: "the first animation is about entering the ring through the ropes"): each boxer first ducks in
## through the ropes on the side of her corner that faces the camera (FightClips "entry_ring", played pure), red first,
## blue BLUE_ENTER_S later, each on her own shot; then she walks to her corner mark. ENTER_S before the corners.
const ENTER_S := 8.8
const BLUE_ENTER_S := 2.4
## The clip ducks between the ropes from DUCK.x to DUCK.y s (hips lowest at 2.7 s): her body crosses the rope line then,
## from OUT_M outside the ropes to IN_M inside, ENTRY_ALONG_M from her corner post along that side.
const DUCK := Vector2(1.0, 5.0)
const OUT_M := 0.42                  # on the apron (FightStage APRON_M 0.6), not past its edge
const IN_M := 0.6
const ENTRY_ALONG_M := 1.1
const E := ENTER_S
const LENGTH_S := 13.0 + TAPE_S + E
## [start s, framing]
const SHOTS := [[0.0, "entry_red"], [BLUE_ENTER_S + 1.0, "entry_blue"], [E, "wide"], [1.5 + E, "tape"], [2.0 + TAPE_S + E, "red"],
	[5.0 + TAPE_S + E, "blue"], [8.0 + TAPE_S + E, "broadcast"], [10.1 + TAPE_S + E, "two_shot"], [11.6 + TAPE_S + E, "wide_out"]]
## [s, cue]
const CUES := [[0.0, "enter_red"], [BLUE_ENTER_S, "enter_blue"], [5.6, "to_corner_red"], [5.6 + BLUE_ENTER_S, "to_corner_blue"],
	[E, "corners"], [1.8 + E, "tape"], [1.6 + TAPE_S + E, "untape"], [2.0 + TAPE_S + E, "name_red"], [2.6 + TAPE_S + E, "raise_red"],
	[4.4 + TAPE_S + E, "lower_red"], [5.0 + TAPE_S + E, "name_blue"], [5.6 + TAPE_S + E, "raise_blue"], [7.4 + TAPE_S + E, "lower_blue"],
	[8.0 + TAPE_S + E, "walk"], [10.4 + TAPE_S + E, "touch"], [11.3 + TAPE_S + E, "untouch"], [11.6 + TAPE_S + E, "seconds_out"],
	[12.6 + TAPE_S + E, "bell"]]

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
var _entering := [-1.0, -1.0]   # per boxer: intro time her entry began (-1 = not entering)


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
	_carry_in()
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
		"entry_red", "entry_blue":
			# From inside the ring, along her rope side and a little in: she ducks in toward the lens's side.
			var e := _entry(0 if shot == "entry_red" else 1)
			var at: Vector3 = e["rope"]
			var p := at + (e["along"] as Vector3) * 2.6 + (e["in"] as Vector3) * 1.4 + Vector3.UP * 1.15
			var look := at + Vector3.UP * 0.95
			return {"pos": p, "look": look, "fov": 40.0, "focus": p.distance_to(look), "drift": (e["in"] as Vector3) * 0.3}
		"wide", "wide_out":
			# The whole ring from high at the side, a slow push in.
			var p := side * 7.2 + Vector3.UP * 2.7
			return {"pos": p, "look": Vector3.UP * 0.8, "fov": 42.0, "focus": 7.0, "drift": -side * 0.9}
		"tape":
			# Both in their corners, square on from the side and level, so the card sits in the gap between them.
			var p := side * 8.4 + Vector3.UP * 1.6
			return {"pos": p, "look": Vector3.UP * 1.1, "fov": 40.0, "focus": 8.4, "drift": -side * 0.5}
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


## Where boxer i comes in: her rope side is the one of her corner's two that faces the wide camera (red: x = -half,
## blue: z = +half). rope = the crossing point on the rope line; in = into the ring; along = from the post along that side.
func _entry(i: int) -> Dictionary:
	var post: Vector3 = crew.corner("red" if i == 0 else "blue")["post"]
	var inward := Vector3(1, 0, 0) if i == 0 else Vector3(0, 0, -1)
	var along := Vector3(0, 0, 1) if i == 0 else Vector3(-1, 0, 0)
	var rope := post + along * ENTRY_ALONG_M
	return {"rope": rope, "in": inward, "along": along, "out_at": rope - inward * OUT_M, "in_at": rope + inward * IN_M}


## Her corner mark: in front of her stool's place.
func _corner_mark(i: int) -> Vector3:
	var c: Dictionary = crew.corner("red" if i == 0 else "blue")
	return (c["seat"] as Vector3) + (c["d"] as Vector3) * 0.2


func cue_enter_red() -> void:
	_enter(0)
	_enter(1, true)


func cue_enter_blue() -> void:
	_enter(1)


## On the apron outside her rope side, facing in; the entry clip plays pure from its first frame. `wait` = blue is not
## drawn until her own entry.
func _enter(i: int, wait: bool = false) -> void:
	var a: Dictionary = stage.boxers[i]
	var e := _entry(i)
	crew.place(a, e["out_at"], crew.yaw_to(e["out_at"], e["in_at"]))
	(a["node"] as Node3D).visible = not wait
	if wait:
		return
	var ap: AnimationPlayer = a["ap"]
	if ap.has_animation("entry_ring"):
		ap.play("entry_ring", 0.0)
	_entering[i] = t


## Carries an entering boxer through the ropes while the clip ducks (eased, so she leaves and lands at rest).
func _carry_in() -> void:
	for i in 2:
		if _entering[i] < 0.0:
			continue
		var e := _entry(i)
		var u := clampf((t - _entering[i] - DUCK.x) / (DUCK.y - DUCK.x), 0.0, 1.0)
		var at: Vector3 = (e["out_at"] as Vector3).lerp(e["in_at"], u * u * (3.0 - 2.0 * u))
		var n: Node3D = stage.boxers[i]["node"]
		n.position = Vector3(at.x, 0.0, at.z)
		# S320 (operator: "do you seriously donot see the errors"): a timer pressed the rope while she still stood upright
		# and held it after she stood up inside. The rope goes down only while she is bent over AT it: by how low her head
		# is (upright ~1.45 m, through the ropes ~1.0 m) and how near her hips are to the crossing point.
		var skel: Skeleton3D = stage.boxers[i]["skel"]
		var head_y: float = (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin).y
		var hips: Vector3 = skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips")).origin
		var near := 1.0 - clampf((Vector2(hips.x, hips.z).distance_to(Vector2((e["rope"] as Vector3).x, (e["rope"] as Vector3).z)) - 0.35) / 0.4, 0.0, 1.0)
		# ROPELOG (S320): her head stays low (1.0-1.3 m) while she straightens up already inside, so the rope stayed
		# down 0.3-0.6 s too long. It lets go as her hips come through the rope line (0 -> 0.15 m inside).
		var through: float = (hips - (e["rope"] as Vector3)).dot(e["in"] as Vector3)
		var held := clampf((1.40 - head_y) / 0.3, 0.0, 1.0) * near * clampf(1.0 - through / 0.15, 0.0, 1.0)
		if OS.get_cmdline_user_args().has("ropelog"):
			print("ROPELOG %d t=%.2f head=%.3f through=%.2f held=%.2f" % [i, t - _entering[i], head_y, through, held])
		stage._ropes.part(i, e["rope"], held)


func cue_to_corner_red() -> void:
	_to_corner(0)


func cue_to_corner_blue() -> void:
	_to_corner(1)


func _to_corner(i: int) -> void:
	_entering[i] = -1.0
	stage._ropes.part(i, Vector3.ZERO, 0.0)
	var a: Dictionary = stage.boxers[i]
	var mark := _corner_mark(i)
	crew.walk(a, mark, _turn_in.bind(i))


func _turn_in(i: int) -> void:
	crew.turn(stage.boxers[i], crew.yaw_to(_corner_mark(i), Vector3.ZERO), stage.guard.bind(i))


## Both stand in front of their stools' place in their guard; each corner's coach and second on the apron behind.
func cue_corners() -> void:
	for side in ["red", "blue"]:
		var c: Dictionary = crew.corner(side)
		var i := 0 if side == "red" else 1
		_entering[i] = -1.0
		stage._ropes.part(i, Vector3.ZERO, 0.0)
		(stage.boxers[i]["node"] as Node3D).visible = true
		var at := _corner_mark(i)
		# S317: she walked here from the ropes; placed only when she has not arrived (a skip, a slow walk).
		if CornerShots.pos(stage.boxers[i]).distance_to(at) > 0.3:
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


func cue_tape() -> void:
	if not ctx.has("tape"):
		return
	_tape = TapeCard.build(ctx["tape"], ctx.get("names", ["", ""]))
	ui.add_child(_tape)
	TapeCard.show(_tape, true)


func cue_untape() -> void:
	TapeCard.show(_tape, false)


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
	if not is_inside_tree() or not is_processing():
		return
	# S308: skipped from a button, this node stays in the tree to the frame's end; its _process must not film again
	# (round 1 opened stuck on the intro's wide lens).
	set_process(false)
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		a["ik"].reach("Left", null)
		a["ik"].reach("Right", null)
		crew.look(a, null)
		(a["node"] as Node3D).visible = true
	_entering = [-1.0, -1.0]
	for i in 2:
		stage._ropes.part(i, Vector3.ZERO, 0.0)
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
