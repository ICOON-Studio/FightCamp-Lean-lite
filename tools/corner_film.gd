extends SceneTree
## S307 the corner minute in the real game: plays to fight night, skips round 1 (the corner minute starts at its bell),
## takes a still at each beat of the shot list, picks a call on the card, and checks what the script promises:
## hips on the seat, the bottle at her mouth, nobody outside the ring or in a post, planted feet that do not slide on the
## walks, round 2 starting on the call. Real pictures only (the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/corner_film.gd -- <out_dir> [film] [pick=body]
## `film`: no stills, play the whole fight's corners (run it under --write-movie). Prints CORNER_FILM failures=<n>.

const W := 1920
const H := 1080
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const CornerShots := preload("res://scripts/fight3d/CornerShots.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const STILLS := [[1.0, "c01_bell_part"], [3.2, "c02_behind_walk"], [5.3, "c03_low_sits"], [7.0, "c04_water"], [8.5, "c05_ice"],
	[11.0, "c06_coach_card"], [13.5, "c07_reverse_pick"], [24.0, "c08_ots"], [31.5, "c085_cutman"], [41.5, "c09_other_corner"], [53.0, "c10_seconds_out"],
	[56.5, "c11_walk_out"]]

var main: Node
var out_dir := "user://corner_film"
var failures := 0
var film := false
var pick := "body"
var pro := false
var _flagged := {}
var _feet := {}
var _taps: Array = []       # "<i>:<foot>" -> {last: Vector3, slide: float, worst: float}


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	for a in args:
		film = film or str(a) == "film"
		pro = pro or str(a) == "pro"
		if str(a).begins_with("pick="):
			pick = str(a).substr(5)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	_to_fight_night()
	main.act("fightnight")
	await _wait(4)
	var f: Dictionary = main.career.fighter()
	print("CORNER_FILM fighter %s %s vs %s (%s)" % [f["name"], f["stats"], f["bout"]["opp"]["name"], f["bout"]["opp"]["style"]])
	FightView.highlights = true
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	var total := int(main.modal["total"])
	if pro:
		# `pro`: the corner a pro bout gets (with the cutman), on this amateur bout.
		view.crew.queue_free()
		view.crew = FightCast.crew(view.stage, true)
	# The feet as shown (after FootPlant): a last modifier on each boxer (tools/pose_tap.gd).
	for i in 2:
		var skel: Skeleton3D = view.stage.boxers[i]["skel"]
		var tap: SkeletonModifier3D = load("res://tools/pose_tap.gd").new()
		tap.setup(skel, ["LeftFoot", "RightFoot"])
		skel.add_child(tap)
		_taps.append(tap)
	for n in range(1, total):
		await _wait(30)
		view.skip_round()
		await _wait(2)
		var cm: Node = _minute(view)
		_check(cm != null, "round %d's bell starts the corner minute" % n)
		if cm == null:
			break
		if film:
			await _until(func(): return not is_instance_valid(cm), 70.0)
		else:
			await _watch(view, cm)
		await _wait(3)
		_check(bool(view.playing) and int(view.round_n) == n + 1, "round %d plays after the corner" % (n + 1))
		_check(not view.stage.scene, "the fight has the boxers back")
		if not film:
			break
	print("CORNER_FILM failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _minute(view: Node) -> Node:
	for c in view.get_children():
		if c.has_method("cue_walk"):
			return c
	return null


## Stills on the shot list; the checks run every frame of the minute.
func _watch(view: Node, cm: Node) -> void:
	var k := 0
	var picked := false
	var seat_ok := false
	var bottle_best := 9.0
	while is_instance_valid(cm):
		var tm := float(cm.t)
		_check_frame(view, cm)
		if tm > 6.9 and tm < 6.95:
			var co: Dictionary = cm.crew.actors["coach"]
			var target: Vector3 = cm._mouth(view.stage.boxers[0]) + CornerShots.fwd(view.stage.boxers[0]) * 0.15 + Vector3.DOWN * 0.03
			print("CORNER coach hand %s target %s shoulder %s elbow %s ik %s" % [CornerShots.bone(co, "LeftHand"), target,
				CornerShots.bone(co, "LeftUpperArm"), CornerShots.bone(co, "LeftLowerArm"), co["ik"]._reach["Left"]])
		if tm > 6.6 and tm < 7.6:
			var b: Node3D = cm.crew.props["bottle"]
			bottle_best = minf(bottle_best, _tip(b).distance_to(cm._mouth(view.stage.boxers[0])))
		if tm > 10.0 and not seat_ok:
			seat_ok = _seated(view, cm)
		if not picked and tm > 12.5:
			picked = true
			cm._pick(pick)
		if k < STILLS.size() and tm >= float(STILLS[k][0]):
			await RenderingServer.frame_post_draw
			var path := out_dir.path_join(str(STILLS[k][1]) + ".png")
			root.get_texture().get_image().save_png(path)
			print("wrote ", path, " shot=", cm._shots[cm._shot_i][1])
			k += 1
		await process_frame
	print("CORNER bottle tip to her mouth (closest) %.3f m" % bottle_best)
	_check(bottle_best < 0.06, "the bottle reaches her mouth (< 6 cm)")
	_check(seat_ok, "her hips sit on the stool")
	for key in _feet:
		print("CORNER foot %s worst planted slide %.3f m" % [key, float(_feet[key]["worst"])])
		_check(float(_feet[key]["worst"]) < 0.08, "foot %s stays planted on the walks (< 8 cm slide)" % key)


func _who(view: Node, cm: Node, a: Dictionary) -> String:
	for i in 2:
		if view.stage.boxers[i] == a:
			return "boxer %d" % i
	for role in cm.crew.actors:
		if cm.crew.actors[role] == a:
			return str(role)
	return "?"


func _tip(b: Node3D) -> Vector3:
	return b.global_position + b.global_transform.basis.y.normalized() * 0.11


func _seated(view: Node, cm: Node) -> bool:
	var c: Dictionary = cm.crew.corner("red")
	var hips := CornerShots.bone(view.stage.boxers[0], "Hips")
	var seat: Vector3 = c["seat"]
	var flat := Vector2(hips.x - seat.x, hips.z - seat.z).length()
	var above := hips.y - float(c["seat_y"])
	print("CORNER seated hips %.3f m off the seat centre, %.3f m above its top" % [flat, above])
	return flat < 0.12 and above > 0.04 and above < 0.16


## Everyone stands inside the ring (the second may stand on the apron) and clear of the posts; planted-foot slide.
func _check_frame(view: Node, cm: Node) -> void:
	var half: float = view.stage.RING_M * 0.5
	var people: Array = view.stage.boxers.duplicate()
	for role in cm.crew.actors:
		if (cm.crew.actors[role]["node"] as Node3D).visible:
			people.append(cm.crew.actors[role])
	var apron: float = view.stage.APRON_M
	for a in people:
		var p := CornerShots.pos(a)
		var out := maxf(absf(p.x), absf(p.z))
		var who := _who(view, cm, a)
		if (absf(out - half) < 0.15 or out > half + apron - 0.08) and not _flagged.has(who):
			_flagged[who] = true
			_check(false, "%s clear of the ropes and on the canvas or apron at t=%.1f (%.2f, %.2f)" % [who, float(cm.t), p.x, p.z])
	for i in 2:
		var bx: Dictionary = view.stage.boxers[i]
		var walking := str((bx["ap"] as AnimationPlayer).current_animation).begins_with("af_walk")
		for foot in ["LeftFoot", "RightFoot"]:
			var key := "%d:%s" % [i, foot]
			var skel: Skeleton3D = bx["skel"]
			var at: Vector3 = skel.global_transform * ((_taps[i] as Object).get("shown") as Dictionary).get(foot, Vector3.ZERO)
			var st: Dictionary = _feet.get(key, {"last": at, "slide": 0.0, "worst": 0.0, "low": at.y})
			st["low"] = minf(float(st["low"]), at.y)
			var moved := Vector2(at.x - st["last"].x, at.z - st["last"].z).length()
			if walking and at.y < float(st["low"]) + 0.02 and moved < 0.03:
				st["slide"] = float(st["slide"]) + moved
				st["worst"] = maxf(float(st["worst"]), float(st["slide"]))
			else:
				st["slide"] = 0.0
			st["last"] = at
			_feet[key] = st


func _to_fight_night() -> void:
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		_tidy(c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			offer = o
	main.act("accept", str(offer["id"]))
	main.act("camp", str(f["id"]))
	main.act("startcamp")
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		_tidy(c)
		main.run_to_stop()
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()


func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 60.0


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
