extends Node
## S307 the corner minute between rounds (docs/FIGHT_NIGHT_SCRIPT.md v2, operator: "make the whole corner come in through
## the ropes holding the stool and having real time to act ... as close to real movie clip"; Q-S294-12 "Yes, build it").
## Real time: the bell, both walk to their corners and sit, water and ice, her coach face to face while YOU pick the call
## (the corner card), the cutman in a pro bout, a cut-away to the other corner, "seconds out", both walk out. Shot like a
## film: letterbox, shallow focus, a slow drift on every shot, cuts on the action. The corner team never walks through the
## ropes on screen: it is in place by the cut that shows it. No pick by "seconds out" = the coach's own call.
##   run(view, stage, crew, ctx)   ctx = {round, card, won, pro, names, energy}   emits done(call)

const CornerShots := preload("res://scripts/fight3d/CornerShots.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")

signal done(call: String)

## The bell rings at the end of the minute: the next round starts here (seconds).
const MINUTE_S := 58.0
## The shot list: [start s, framing] (CornerShots). "cutman" plays in pro bouts only.
## S307 film check: no shot holds longer than ~6 s; over the shoulder, profile, the whole corner and the reverse take turns.
const SHOTS := [[0.0, "part"], [2.2, "behind"], [4.4, "low_out"], [6.4, "water"], [7.8, "ice"], [9.0, "ots"], [14.0, "side2"],
	[19.0, "reverse"], [23.0, "corner_wide"], [27.0, "ots"], [30.0, "cutman"], [34.0, "side2"], [40.0, "other"], [43.5, "reverse"],
	[47.0, "corner_wide"], [52.0, "push"], [54.6, "broadcast"]]
## What happens when: [s, cue] (the cue_<name> methods).
const CUES := [[0.3, "walk"], [2.2, "crew_in"], [6.4, "water"], [7.8, "ice"], [9.0, "face"], [30.0, "cutman"], [34.0, "cutman_off"],
	[40.0, "blue_talk"], [50.0, "default_call"], [52.0, "seconds_out"], [52.4, "stand"], [54.6, "walk_out"]]
## The coach's line for each call (what a real corner says in that minute).
const LINES := {"long": "Stay long. Jab and move, make her reach for you.", "body": "Go downstairs. Dig to the body, the head comes later.",
	"calm": "Breathe. Slow it down and pick your shots."}
## After the pick the reverse holds on the coach this long, then back over his shoulder.
const REVERSE_S := 3.5

var view: Node
var stage: Node3D
var crew: CornerCrew
var ctx: Dictionary
var ui: Control
var t := 0.0
var pick := ""
var fix := ""             # S309: the habit fixed for the next round ("" = none)
var _shot_i := -1
var _cue_i := 0
var _frame: Dictionary = {}
var _shot_t0 := 0.0
var _shot_len := 1.0
var _hold_until := -1.0
var _shots: Array = []
var _lines: Array = []    # [[at s, text]] captions still to show
var _card_off := -1.0     # the card steps aside this long after the call (the picture is the minute's)


func run(v: Node, s: Node3D, c: CornerCrew, context: Dictionary) -> void:
	view = v
	stage = s
	crew = c
	ctx = context
	_shots = SHOTS.filter(func(x): return str(x[1]) != "cutman" or bool(ctx.get("pro", false)))
	stage.scene_mode(true)
	crew.set_shown(true)
	for a in crew.actors.values():
		(a["node"] as Node3D).visible = false
	ui = CornerOverlay.new()
	view.add_child(ui)
	ui.build(ctx["card"], ctx["names"])
	ui.chose.connect(_pick)
	ui.fixed.connect(func(h: String): fix = h)
	ui.skip.connect(finish)
	_tick_ui()


func _process(delta: float) -> void:
	t += delta
	while _cue_i < CUES.size() and float(CUES[_cue_i][0]) <= t:
		call("cue_" + str(CUES[_cue_i][1]))
		_cue_i += 1
	crew.tick(delta)
	_camera()
	while not _lines.is_empty() and float(_lines[0][0]) <= t:
		ui.say(str(_lines[0][1]))
		_lines.pop_front()
	if _card_off > 0.0 and t >= _card_off:
		_card_off = -1.0
		ui.show_card(false)
	_tick_ui()
	if t >= MINUTE_S:
		finish()


func _tick_ui() -> void:
	ui.clock(MINUTE_S - t + 2.0, int(ctx["round"]) + 1)


## The camera: cut to the shot whose start time has come (a pick holds the reverse for a while), drift along the shot.
func _camera() -> void:
	var due := 0
	for k in _shots.size():
		if float(_shots[k][0]) <= t:
			due = k
	if t < _hold_until:
		due = _shot_i
	if due != _shot_i:
		_cut(due, str(_shots[due][1]))
	var name := str(_shots[_shot_i][1])
	var cam: Camera3D = stage.camera
	if name == "broadcast":
		cam.broadcast(CornerShots.pos(ctx_actor("her")), CornerShots.pos(ctx_actor("opp")), false, get_process_delta_time())
		return
	if _frame.is_empty():
		return
	var u := clampf((t - _shot_t0) / _shot_len, 0.0, 1.0)
	var f: Dictionary = CornerShots.frame(name, _shot_ctx()) if bool(_frame.get("track", false)) else _frame
	if f.is_empty():
		return
	var p: Vector3 = (f["pos"] as Vector3) + (_frame["drift"] as Vector3) * u
	if bool(_frame.get("track", false)) and name == "behind":
		p = cam.position.lerp(p, clampf(get_process_delta_time() * 3.0, 0.0, 1.0))
	cam.film(p, f["look"], float(f["fov"]), float(f["focus"]))


func _cut(k: int, name: String) -> void:
	_shot_i = k
	_shot_t0 = t
	var next_t := MINUTE_S
	for j in range(k + 1, _shots.size()):
		if float(_shots[j][0]) > t:
			next_t = float(_shots[j][0])
			break
	_shot_len = maxf(0.5, next_t - t)
	_frame = {} if name == "broadcast" else CornerShots.frame(name, _shot_ctx())
	if name == "broadcast":
		stage.camera.broadcast(CornerShots.pos(ctx_actor("her")), CornerShots.pos(ctx_actor("opp")), true)


func _cut_to(name: String, hold_s: float) -> void:
	for k in _shots.size():
		if str(_shots[k][1]) == name:
			_cut(k, name)
			_shot_len = hold_s
			_hold_until = t + hold_s
			return


func _shot_ctx() -> Dictionary:
	return {"her": ctx_actor("her"), "opp": ctx_actor("opp"), "coach": crew.actors["coach"], "blue_coach": crew.actors["blue_coach"],
		"red": crew.corner("red"), "blue": crew.corner("blue"), "cam": stage.camera}


func ctx_actor(who: String) -> Dictionary:
	return stage.boxers[0 if who == "her" else 1]


## 0:00 the bell: both turn away and walk to their own corner, stand in front of the stool, turn to face out, sit.
func cue_walk() -> void:
	for i in 2:
		var c: Dictionary = crew.corner("red" if i == 0 else "blue")
		var a: Dictionary = stage.boxers[i]
		var spot: Vector3 = crew.sit_spot(i, c)
		var face := crew.yaw_to(Vector3.ZERO, c["d"])
		var sit := func(): crew.turn(a, face, func(): crew.sit(i))
		var other := CornerShots.pos(stage.boxers[1 - i])
		var wp := _around(CornerShots.pos(a), spot, other)
		if wp == spot:
			crew.walk(a, spot, sit)
		else:
			crew.walk(a, wp, func(): crew.walk(a, spot, sit))


## A waypoint that keeps a walker 0.8 m clear of the other boxer (the straight line when it already is).
static func _around(from: Vector3, to: Vector3, other: Vector3) -> Vector3:
	var seg := Vector3(to.x - from.x, 0, to.z - from.z)
	var u := clampf(Vector3(other.x - from.x, 0, other.z - from.z).dot(seg) / maxf(0.0001, seg.length_squared()), 0.0, 1.0)
	var near := from + seg * u
	var off := Vector3(near.x - other.x, 0, near.z - other.z)
	if off.length() >= 0.8 or u <= 0.0 or u >= 1.0:
		return to
	var side := off.normalized() if off.length() > 0.01 else Vector3.UP.cross(seg.normalized())
	return Vector3(other.x, 0, other.z) + side * 0.85


## 0:02 (the cut behind her): her coach and second wait in the corner, the stool down; the same across the ring.
func cue_crew_in() -> void:
	for side in ["red", "blue"]:
		var c: Dictionary = crew.corner(side)
		var pre := "" if side == "red" else "blue_"
		var coach: Dictionary = crew.actors[pre + "coach"]
		var second: Dictionary = crew.actors[pre + "second"]
		var d: Vector3 = c["d"]
		var l: Vector3 = c["l"]
		# Her coach waits at her right front, clear of the low shot from her left.
		var cs := (c["seat"] as Vector3) - l * 0.6 + d * 0.6
		crew.place(coach, cs, crew.yaw_to(cs, c["seat"]))
		crew.play(coach, "af_idle_foldarms" if side == "red" else "af_idle")
		# The second works from the apron, outside the ropes at her right (he slid the stool in under the middle rope).
		var ss := (c["seat"] as Vector3) - l * 0.85
		crew.place(second, ss, crew.yaw_to(ss, c["seat"]))
		crew.play(second, "af_crouch_idle")
		(coach["node"] as Node3D).visible = true
		(second["node"] as Node3D).visible = true
		(crew.props[side + "_stool"] as Node3D).visible = true
		(crew.props[side + "_bucket"] as Node3D).visible = true


## 0:06 water: her coach, inside the ropes at her front-left, holds the bottle to her lips (his hand reaches it; from
## the apron the second's arm is 0.3 m short of her mouth).
func cue_water() -> void:
	var her := ctx_actor("her")
	var coach: Dictionary = crew.actors["coach"]
	var c: Dictionary = crew.corner("red")
	# His hand a hand's width in front of her lips: the bottle's middle sits there, tipped to them.
	var hand := func(): return _mouth(her) + CornerShots.fwd(her) * 0.13 + Vector3.DOWN * 0.03
	_stand_to_reach(coach, hand.call(), (c["seat"] as Vector3) + (c["l"] as Vector3) * 0.5 + (c["d"] as Vector3) * 0.6, "Left")
	coach["ik"].reach("Left", hand)
	crew.hold("bottle", coach, "Left", func(): return _mouth(her))


## 0:08 ice: the bottle goes, the ice pack sits on the back of her neck.
func cue_ice() -> void:
	crew.drop("bottle")
	crew.actors["coach"]["ik"].reach("Left", null)
	crew.play(crew.actors["second"], "af_idle")
	crew.hold_at("ice", ctx_actor("her"), "Neck", Vector3(0, 0.03, -0.05))


## 0:09 her coach crouches in front of her, face to face; the corner card comes up.
func cue_face() -> void:
	var her := ctx_actor("her")
	var coach: Dictionary = crew.actors["coach"]
	var c: Dictionary = crew.corner("red")
	var at := CornerShots.pos(her) + (c["d"] as Vector3) * 1.15 * (her["node"] as Node3D).scale.x
	crew.place(coach, at, crew.yaw_to(at, CornerShots.pos(her)))
	crew.play(coach, "af_crouch_idle")
	crew.play(her, "af_sit_talk" if not bool(ctx.get("won", false)) else "af_sit_idle")
	crew.look(coach, her)
	crew.look(her, coach)
	ui.show_card(true)
	_lines.append([t + 0.3, "\"%s\"" % ("Good round. Listen to me." if bool(ctx.get("won", false)) else "Look at me. We get this one back.")])


func cue_cutman() -> void:
	if not crew.actors.has("cutman"):
		return
	var cut: Dictionary = crew.actors["cutman"]
	var her := ctx_actor("her")
	var c: Dictionary = crew.corner("red")
	var cheek := func(): return CornerShots.bone(her, "Head") + CornerShots.fwd(her) * 0.08 + CornerShots.side(her) * 0.055
	_stand_to_reach(cut, cheek.call(), (c["seat"] as Vector3) + (c["l"] as Vector3) * 0.55 + (c["d"] as Vector3) * 0.4, "Right")
	cut["ik"].reach("Right", cheek)
	crew.look(cut, her)
	(cut["node"] as Node3D).visible = true


func cue_cutman_off() -> void:
	if crew.actors.has("cutman"):
		(crew.actors["cutman"]["node"] as Node3D).visible = false


## 0:40 the other corner: their coach stands over their boxer and talks.
func cue_blue_talk() -> void:
	var opp := ctx_actor("opp")
	var coach: Dictionary = crew.actors["blue_coach"]
	var c: Dictionary = crew.corner("blue")
	var at := CornerShots.pos(opp) + (c["d"] as Vector3) * 0.95
	crew.place(coach, at, crew.yaw_to(at, CornerShots.pos(opp)))
	crew.play(coach, "af_talk")
	crew.look(coach, opp)
	crew.look(opp, coach)


func cue_default_call() -> void:
	if pick == "":
		_pick(str(ctx["card"]["call"]))


## 0:52 "Seconds out!": the corner team climbs out (gone at the cut) and the ice goes.
func cue_seconds_out() -> void:
	ui.show_card(false)
	_lines.append([t, "\"Seconds out!\""])
	crew.drop("ice")
	for i in 2:
		crew.look(stage.boxers[i], null)
	for role in crew.actors:
		(crew.actors[role]["node"] as Node3D).visible = false


func cue_stand() -> void:
	for i in 2:
		crew.stand(i)


## 0:55 both walk out to the centre, a jab's length apart, and take up the guard; the stools are gone.
func cue_walk_out() -> void:
	ui.say("")
	for side in ["red", "blue"]:
		(crew.props[side + "_stool"] as Node3D).visible = false
		(crew.props[side + "_bucket"] as Node3D).visible = false
	var axis := ((crew.corner("blue")["seat"] as Vector3) - (crew.corner("red")["seat"] as Vector3)).normalized()
	for i in 2:
		var a: Dictionary = stage.boxers[i]
		var mark: Vector3 = axis * stage.gap_m * (-0.5 if i == 0 else 0.5)
		var face := crew.yaw_to(mark, Vector3.ZERO)
		crew.walk(a, mark, func(): crew.turn(a, face, func(): stage.guard(i)))


## Skipped before they reached the centre: both stand on their marks, facing (the cut to the next round hides it).
func _marks() -> void:
	var axis := ((crew.corner("blue")["seat"] as Vector3) - (crew.corner("red")["seat"] as Vector3)).normalized()
	for i in 2:
		var mark: Vector3 = axis * stage.gap_m * (-0.5 if i == 0 else 0.5)
		if CornerShots.pos(stage.boxers[i]).distance_to(mark) > 0.3:
			crew.place(stage.boxers[i], mark, crew.yaw_to(mark, Vector3.ZERO))


## Stands `a` (playing its idle) so that its `side` shoulder is a forearm and a half from `point`, coming from `near`.
func _stand_to_reach(a: Dictionary, point: Vector3, near: Vector3, side: String) -> void:
	var dir := Vector3(point.x - near.x, 0, point.z - near.z).normalized()
	var left := Vector3.UP.cross(dir).normalized()
	var sc := (a["node"] as Node3D).scale.x
	var at := point - dir * 0.28 * sc + left * (-0.19 if side == "Left" else 0.19) * sc
	crew.place(a, at, atan2(dir.x, dir.z))
	crew.play(a, "af_idle")
	(a["node"] as Node3D).visible = true


func _mouth(her: Dictionary) -> Vector3:
	return CornerShots.bone(her, "Head") + CornerShots.fwd(her) * 0.1 * (her["node"] as Node3D).scale.x + Vector3.DOWN * 0.01


func _pick(k: String) -> void:
	if pick != "":
		return
	pick = k
	_card_off = t + 6.0
	ui.picked(k)
	_lines.clear()
	_lines.append([t, "\"%s\"" % LINES.get(k, BoutRules.CORNER[k])])
	# S309: his read only when it backs your call (it argued for his own call after you picked another).
	if k == str(ctx["card"]["call"]):
		_lines.append([t + 3.4, "\"%s\"" % str(ctx["card"]["why"])])
	for h in ctx["card"].get("fixes", []):
		if str(h["id"]) == fix:
			_lines.append([t + 3.4, "\"One more thing. %s: fix it this round.\"" % str(h["name"])])
	_lines.append([t + 7.5, ""])
	crew.play(crew.actors["coach"], "af_crouch_idle")
	crew.play(ctx_actor("her"), "af_sit_idle")
	if t >= 9.0 and t < 50.0:
		_cut_to("reverse", REVERSE_S)


## The bell: the fight takes the boxers back, the corner goes, the next round starts on the call.
func finish() -> void:
	if not is_inside_tree() or not is_processing():
		return
	# S308: skipped from a button, this node stays in the tree to the frame's end; its _process must not film again
	# (round 1 opened stuck on the intro's wide lens).
	set_process(false)
	if pick == "":
		pick = str(ctx["card"]["call"])
	for i in 2:
		crew.look(stage.boxers[i], null)
	crew.set_shown(false)
	_marks()
	stage.scene_mode(false)
	stage.broadcast(true)
	ui.queue_free()
	queue_free()
	done.emit(pick + ("|" + fix if fix != "" else ""))
