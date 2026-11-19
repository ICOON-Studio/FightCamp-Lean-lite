extends Node
## FIGHTPLAYER2 phase 3 (S512, scope 3b step 3; `-- fightplayer2`): the v2 fight player. It PLAYS the choreographer's
## timeline and does nothing else to a boxer:
##   - a take (punch, reaction, block, defence) starts when its event says, from where it says, through the join smoother
##     with the join time of its kind;
##   - the take's own hip travel moves the BODY (RootPath), so a punch steps as it was captured and a hit man who
##     staggers back has really given ground when the take ends;
##   - between takes the distance plan moves the bodies (PairPlace: the man it names covers the ground, the pair stays
##     side-on to the fixed camera) and the one leg layer left on steps the feet after the body;
##   - when a take ends the boxer goes back to the guard take.
## Every pose layer of the shipped player is switched off while this plays (the baseline: they buy nothing); the join
## smoother, the twist bones, the foot lock, the floor and the tired sag stay. Directors' scenes (walk-in, corner
## minute, the count) get the old stack back for as long as they run. The shipped player is the control arm: without
## the switch nothing here is built.
##   FightStage: setup(stage) / tick(delta) / guard(who) / finished(who) / scene(on)
##   FightView: queue(beats, t0, t1) when an exchange is settled, clock(t) every frame; BeatFire: takes(view, beat)

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const Choreo := preload("res://scripts/fight3d/v2/Choreographer.gd")
const Gap := preload("res://scripts/fight3d/v2/ChoreoGap.gd")
const ClipCensus := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const RootPath := preload("res://scripts/fight3d/v2/RootPath.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FightSfx := preload("res://scripts/audio/FightSfx.gd")
const HitImpact := preload("res://scripts/fight3d/HitImpact.gd")
const PunchAim := preload("res://scripts/fight3d/v2/PunchAim.gd")
const FootCarry := preload("res://scripts/fight3d/v2/FootCarry.gd")
const PairPlace := preload("res://scripts/fight3d/v2/PairPlace.gd")
const FootTake := preload("res://scripts/fight3d/v2/FootTake.gd")
const StepPlay := preload("res://scripts/fight3d/v2/StepPlay.gd")

static var KEEP: Array = _keep()
const GUARD := "pro_idle"
const FOOT_DB := "res://assets/data/foot_db.json"
## The join into each kind of take: [half-life, length] s (scope 3e: into a punch 0.15, a reaction 0.05, a slip 0.15,
## back to the guard 0.30).
const JOIN := {"punch": Vector2(0.05, 0.15), "reaction": Vector2(0.035, 0.11), "block": Vector2(0.02, 0.06),
	"defence": Vector2(0.05, 0.15), "guard": Vector2(0.10, 0.30), "pass": Vector2(0.10, 0.30),
	"fidget": Vector2(0.10, 0.30), "feint": Vector2(0.05, 0.15), "step": Vector2(0.07, 0.22)}
const JOIN_TURN := Vector2(0.08, 0.24)
const JOIN_HOME := Vector2(0.06, 0.22)   # the punching hand back to the guard (ChoreoRules.ARM_HOME_S)
const LEAD_MPS := 2.0         # a reaction's lost travel is given at most this fast (0.19 m in 0.11 s, 0.5 m in 0.25 s)
const WAITING := ["", "guard", "fidget", "feint", "step"]   # what a wait thing (ChoreoWait) may take over
## S528 (the owner on film 5, C434: "why the fighter do not walk ?"): every move of a body is a captured boxing step
## (StepClips; StepPlay picks and times it) and the feet belong to the take (FootTake). `-- fp2nosteps` = the plan moves
## the guard pose as it did (the control arm).
static var steps_on: bool = not OS.get_cmdline_user_args().has("fp2nosteps")
const DOWN := ["knock", "fall", "countdown", "win", "ko_"]

var st: Node = null
var db: Dictionary = {}
var plan: Dictionary = {}
var t := 0.0                  # the round's clock (FightView.t)
var live := false             # a round is being played (the clock runs)
var _next := [0, 0]
var _take: Array = [{}, {}]   # per boxer: {clip, kind, origin, from_s, path, travel}
var _home: Array = [Vector3.ZERO, Vector3.ZERO]   # where each body stands on the canvas, the take's travel aside
var _off: Array = [[], []]
var _due: Array = []          # [t, Callable]: sounds and camera on the contact
var _scene := false
var log_on: bool = OS.get_cmdline_user_args().has("fp2log")
var _aim: Array = [null, null]       # per boxer: PunchAim
var _fronts: Array = [{}, {}]       # per boxer: take -> where its glove front is at the contact, in the body frame
var _rels: Array = [{}, {}]
var _drawn: Array = [{}, {}]        # per boxer: Head and Chest as drawn last frame (skeleton space)
var _sampled := false
var _feet: Array = [null, null]      # per boxer: FootCarry (the legs in the fight)
var _moved: Array = [Transform3D.IDENTITY, Transform3D.IDENTITY]   # per boxer: the plan's own motion of his body since FootCarry last asked
var _join_next := Vector2.ZERO       # the next _play joins with this instead of its kind's join (the arm home)
var hit_until := -1.0         # a landed punch is on screen until this clock time (the film's rulers find contacts by it)
var pair: PairPlace = PairPlace.new(self)   # where the pair stands and faces (follow, side-on, facing)
var walk: StepPlay = StepPlay.new(self)       # the planned steps and the ring steps (S528)
var _ft: Array = [null, null]        # per boxer: FootTake (the legs in the fight)
var contacts: Array = []      # every contact as played: {t, who, move, result, gap, take} (the rulers read it)


## The layers left on. The legs: FootTake (S528: a foot is pinned while its take stands on it and follows the take's own
## steps; FootPlant's own step only where no take steps) + FloorStand. `-- fp2plant` = FootPlant (each foot holds its
## spot and steps when the body has moved off it: the legs of films 1-5). `-- fp2carry` = FootCarry instead (S513: the take's own footwork shown as captured, the plan's travel
## stepped from the plan; headless it reads equal on slip, 4x less in the guard, knees shakier - the film decides which
## is the default). `-- fp2lock` = FootLock (a spring: it let a standing foot creep at every start).
static func _keep() -> Array:
	var args := OS.get_cmdline_user_args()
	var legs := ["FootLock", "FloorStand"] if args.has("fp2lock") else (["FootCarry", "FloorStand"] if args.has("fp2carry") else (["FootPlant", "FloorStand"] if args.has("fp2plant") else ["FootTake", "FloorStand"]))
	return ["JoinSmoother", "MetaHumanTwist", "TiredSag", "PunchAim"] + legs


static var force := false   # a test switches v2 on without the command line (set FightClips.untouched with it)


static func on() -> bool:
	return force or OS.get_cmdline_user_args().has("fightplayer2")


func setup(stage: Node) -> void:
	st = stage
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(ClipCensus.DB_PATH))
	db = parsed if parsed is Dictionary else {}
	var fparsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(FOOT_DB))
	var fdb: Dictionary = fparsed if fparsed is Dictionary else {}
	walk.steps = fdb.get("steps", {})
	for i in 2:
		var skel: Skeleton3D = st.boxers[i]["skel"]
		if KEEP.has("FootTake") and st.boxers[i].get("feet") != null:
			_ft[i] = FootTake.add(skel, st.boxers[i]["ap"], st.boxers[i]["feet"], fdb.get("feet", {}), bool(st.boxers[i].get("south", false)))
		_aim[i] = PunchAim.attach(skel, st.boxers[i]["ap"], st.boxers[i].get("js"))
		if KEEP.has("FootCarry") and st.boxers[i].get("feet") != null:
			_feet[i] = FootCarry.add(skel, st.boxers[i]["ap"], st.boxers[i]["feet"])
			if _feet[i] != null:
				_feet[i].moved = pair.take_moved.bind(i)
				_feet[i].ahead = pair.ahead.bind(i)
		var ids := [skel.find_bone("Head"), skel.find_bone("Chest")]
		var d: Dictionary = _drawn[i]
		skel.skeleton_updated.connect(func():
			d["Head"] = skel.get_bone_global_pose(int(ids[0])).origin
			d["Chest"] = skel.get_bone_global_pose(int(ids[1])).origin)
	_layers(false)
	for i in 2:
		var z: float = R.REST_M * (0.5 if i == 1 else -0.5)
		_home[i] = Vector3(0.0, 0.0, z)
		st.boxers[i]["pos"] = _home[i]
		(st.boxers[i]["node"] as Node3D).position = _home[i]
		guard(i)
	pair.face(0.0)


## The shipped pose layers off (fight) or back on (a director's scene).
func _layers(on_again: bool) -> void:
	for i in st.boxers.size():
		var skel: Skeleton3D = st.boxers[i]["skel"]
		if _feet[i] != null:
			(_feet[i] as SkeletonModifier3D).active = not on_again
			_feet[i].reset()
		if _ft[i] != null:
			(_ft[i] as SkeletonModifier3D).active = not on_again
		if on_again:
			for m in _off[i]:
				if is_instance_valid(m):
					(m as SkeletonModifier3D).active = true
			_off[i] = []
			continue
		for c in skel.get_children():
			if c is SkeletonModifier3D and (c as SkeletonModifier3D).active and not KEEP.has(str(c.name)):
				(c as SkeletonModifier3D).active = false
				(_off[i] as Array).append(c)
		var rig: Node = st.boxers[i].get("rig")
		if rig != null:
			rig.want = 0.0
			rig.w = 0.0
		var fp: Node = st.boxers[i].get("feet")
		if fp != null:
			fp.set("_body", null)   # the bought stance as bought: no front-back stretch of the feet


## A director takes the boxers (on) or hands them back where they stand (off).
func scene(on_scene: bool) -> void:
	_scene = on_scene
	_layers(on_scene)
	if on_scene:
		return
	for i in 2:
		var n: Node3D = st.boxers[i]["node"]
		_home[i] = Vector3(n.position.x, 0.0, n.position.z)
		_take[i] = {}


## FightView: exchange k is settled - plan it from where the pair stands now.
func queue(beats: Array, t0: float, t1: float) -> void:
	var opts := {"t0": t0, "t1": t1, "gap0": pair.gap(), "seed": int(t0) * 131 + beats.size(),
		"south": {"a": bool(st.boxers[0].get("south", false)), "b": bool(st.boxers[1].get("south", false))},
		"scale": {"a": _scale(0), "b": _scale(1)}}
	plan = Choreo.plan(beats, db, opts)
	_next = [0, 0]
	walk.reset()
	if log_on:
		print("FP2 plan %.0f-%.0f gap0 %.2f counts %s log %d" % [t0, t1, float(opts["gap0"]), str(plan["counts"]), (plan["log"] as Array).size()])
		for l in plan["log"]:
			print("FP2   ", l)


func clock(now: float, playing: bool) -> void:
	t = now
	live = playing


## BeatFire: true when v2 shows this beat itself (its plan already holds every punch, step and defence).
func takes(view: Node, b: Dictionary) -> bool:
	var move := str(b["move"])
	if R.is_punch(move):
		if view.get("body") != null:
			view.body.land(b, R.impact_s_for(move))   # the body map
		return true
	if move in ["step_in", "step_out"]:
		FightSfx.step()
		return true
	if move in ["slip", "tired", "clinch"]:
		var who := 0 if str(b["who"]) == "a" else 1
		var has := func(c: String) -> bool: return _has(who, c)
		if move == "slip":
			_play(who, BeatClips.defence("slip", "jab", true, bool(st.boxers[who].get("south", false)), has), 0.0, "defence", true)
		elif move == "tired":
			_play(who, "pro_idle_tired" if _has(who, "pro_idle_tired") else GUARD, 0.0, "pass", false)
		return true   # a clinch: no owned take holds two men (scope 8.8) - they stay at range
	return false


func tick(delta: float) -> void:
	if st == null or _scene or st.boxers.size() < 2:
		return
	if not _sampled:
		_sample()
	if live and not plan.is_empty():
		for i in 2:
			var track: Array = plan["tracks"]["a" if i == 0 else "b"]
			while int(_next[i]) < track.size() and float(track[int(_next[i])]["t"]) <= t:
				_event(i, track[int(_next[i])])
				_next[i] = int(_next[i]) + 1
		var k := 0
		while k < _due.size():
			if float(_due[k][0]) <= t:
				(_due[k][1] as Callable).call()
				_due.remove_at(k)
			else:
				k += 1
		pair.follow(delta)
		walk.follow()
		pair.square(delta)
		if log_on and int(t / 15.0) != int((t - delta) / 15.0):
			for i in 2:
				if _feet[i] != null:
					print("FP2 feet %s t %.0f steps %d slip by cause %s" % ["ab"[i], t, int(_feet[i].steps), str(_feet[i].tally)])
				if _ft[i] != null:
					print("FP2 feet %s t %.0f steps from a take %d, FootPlant's own %d | step takes %d, the pair walked %.1f m" % ["ab"[i], t, int(_ft[i].took), int(_ft[i].own), walk.played, walk.walked])
					print("FP2 feet %s   a low foot moved, by what ruled it: %s" % ["ab"[i], str(_ft[i].tally)])
	pair.place()
	pair.face(delta)


func _event(i: int, e: Dictionary) -> void:
	var kind := str(e["kind"])
	if _down(i):
		return
	if kind == "step":
		if steps_on:
			walk.start(i, e)
		return
	if kind in ["pivot", "pass"]:
		return   # the distance plan moves the body
	var clip := str(e["clip"])
	if clip == "" or not _has(i, clip):
		return
	if kind in ["fidget", "feint"]:
		_wait(i, e)
		return
	_play(i, clip, float(e["from_s"]), kind, kind == "punch" or str(e.get("part", "whole")) == "whole")
	if kind == "reaction" and e.has("until_s"):   # S526: back to the guard once the reaction has shown (ChoreoRules.REACT_TAIL_S)
		_due.append([t + maxf(float(e["until_s"]) - float(e["from_s"]), 0.2), func() -> void:
			if str(_take[i].get("clip", "")) == clip and str(_take[i].get("kind", "")) == "reaction" and not _down(i):
				guard(i)])
	if kind != "punch":
		return
	var who := "a" if i == 0 else "b"
	var move := str(e["move"])
	var result := str(e["result"])
	if result == "lands" and (_fronts[i] as Dictionary).has(clip):
		_arm(i, clip, move == "body_hook")
	var big := bool(e.get("big", false))
	var ct := float(e["contact_t"])
	_due.append([ct, func() -> void:
		if str(_take[i].get("clip", "")) != clip:
			return   # cut before it arrived: nothing lands, nothing sounds
		contacts.append({"t": t, "who": who, "move": move, "result": result, "take": clip, "gap": pair.gap(),
			"node_gap": pair.node_gap(), "late_s": (st.boxers[i]["ap"] as AnimationPlayer).current_animation_position - float((db["rows"].get(clip, {}) as Dictionary).get("contact_s", 0.0))})
		if result == "lands":
			_record(i, clip, move)
			FightSfx.landed(move, big)
			if st.camera != null:
				st.camera.shake(float(HitImpact.SHAKE_M["big" if big else ("jab" if move == "jab" else "power")]))
		elif result == "blocked":
			FightSfx.blocked()
		else:
			FightSfx.missed(0.0, move, "")])
	_due.append([ct + R.arm_home_s(move), func() -> void:   # S526: the arm comes home (after the contact's own entry: same tick, this order)
		if str(_take[i].get("clip", "")) == clip and str(_take[i].get("kind", "")) == "punch":
			_join_next = JOIN_HOME
			guard(i)])


## A wait thing (ChoreoWait): a fidget take or a window of one, a paw or a feint (a punch take to `until_s` and back).
## It never takes over a punch, a reaction or a defence still playing; it hands back to the guard when it is done.
func _wait(i: int, e: Dictionary) -> void:
	if not (str(_take[i].get("kind", "")) in WAITING):
		return
	var clip := str(e["clip"])
	var kind := str(e["kind"])
	var speed := maxf(float(e.get("speed", 1.0)), 0.1)
	_play(i, clip, float(e["from_s"]), kind, true)
	(st.boxers[i]["ap"] as AnimationPlayer).speed_scale = speed
	_due.append([t + (float(e["until_s"]) - float(e["from_s"])) / speed, func() -> void:
		if str(_take[i].get("clip", "")) == clip and str(_take[i].get("kind", "")) == kind:
			guard(i)])


## A landed punch as shown, for the film's rulers and hits.json (FightStage.hit_gaps, the shipped player's row).
func _record(i: int, clip: String, move: String) -> void:
	hit_until = t + 0.07
	# S525: read AFTER this frame's pose is on the skeleton. The contact fires in the stage's _process, before the
	# animation and PunchAim have moved the arm this frame, so the glove was read where it stood one frame EARLIER:
	# a glove at 6-8 m/s is 20-27 cm short of where it lands (hits.json said 10-28 cm on three films, and both critics
	# quoted it; the 60 Hz test, which reads after the frame, said 4 cm).
	var now_f := Engine.get_process_frames()
	var gap := pair.gap()
	(st.boxers[i]["skel"] as Skeleton3D).skeleton_updated.connect(func() -> void: _measure(i, clip, move, now_f, gap), CONNECT_ONE_SHOT)


func _measure(i: int, clip: String, move: String, now_f: int, gap: float) -> void:
	var hand: String = st.hand_of(i, str((db["rows"].get(clip, {}) as Dictionary).get("hand", "LeftHand")))
	(st.boxers[i]["gloves"] as Node)._follow()
	var g: Vector3 = st.glove_front(i, hand)
	var tp := target(1 - i, move == "body_hook")
	var d: Vector3 = (st.boxers[i]["node"] as Node3D).global_transform.basis.orthonormalized().inverse() * (g - tp)
	(st.hit_gaps as Array).append({"now_f": now_f, "hitter": i, "move": move, "clip": clip, "miss": g.distance_to(tp),
		"graze": false, "cut": false, "gap": gap, "fwd": d.z, "side": d.x, "up": d.y})


## The glove front of every take at its contact, read once off each body (the take posed at its contact, no layer on).
func _sample() -> void:
	_sampled = true
	var rows: Dictionary = db.get("rows", {})
	for i in 2:
		var bx: Dictionary = st.boxers[i]
		var skel: Skeleton3D = bx["skel"]
		var ap: AnimationPlayer = bx["ap"]
		var node: Node3D = bx["node"]
		var body_inv := node.global_transform.affine_inverse()
		for n in rows:
			var r: Dictionary = rows[n]
			if str(r.get("kind", "")) != "punch" or not (r.get("drop", []) as Array).is_empty() or not ap.has_animation(str(n)):
				continue
			var hand: String = st.hand_of(i, str(r.get("hand", "LeftHand")))
			ap.play(str(n))
			ap.seek(float(r.get("contact_s", 0.3)), true)
			(bx["gloves"] as Node)._follow()   # the glove onto the sampled hand (it follows the skeleton a frame later otherwise)
			_fronts[i][str(n)] = body_inv * (st.glove_front(i, hand) as Vector3)
			# wrist -> glove front in the skeleton's space at the contact (PunchAim solves for the front, not the wrist)
			_rels[i][str(n)] = skel.global_transform.basis.inverse() * ((st.glove_front(i, hand) as Vector3) - skel.global_transform * skel.get_bone_global_pose(skel.find_bone(hand)).origin)
		guard(i)


## Where a punch is aimed on boxer i, as drawn: the lower face, or the ribs.
func target(i: int, body: bool) -> Vector3:
	var skel: Skeleton3D = st.boxers[i]["skel"]
	var fwd: Vector3 = (st.boxers[i]["node"] as Node3D).global_transform.basis.z.normalized()
	var s := _scale(i)
	if body:
		return skel.global_transform * (_drawn[i].get("Chest", Vector3(0, 1.2, 0)) as Vector3) + (fwd * 0.11 + Vector3.DOWN * 0.14) * s
	return skel.global_transform * (_drawn[i].get("Head", Vector3(0, 1.5, 0)) as Vector3) + (fwd * 0.09 + Vector3.UP * 0.02) * s


## The arm of a landed punch finishes on the target (PunchAim): the offset from where the take will put the glove.
func _arm(i: int, clip: String, body: bool) -> void:
	var row: Dictionary = db["rows"][clip]
	var cs := float(row.get("contact_s", 0.3))
	var bx: Dictionary = st.boxers[i]
	var front: Vector3 = _fronts[i][clip]
	(_aim[i] as Node).arm(clip, st.hand_of(i, str(row.get("hand", "LeftHand"))), cs, func() -> Vector3:
		var path: PackedVector3Array = _take[i].get("path", PackedVector3Array())
		var ap: AnimationPlayer = bx["ap"]
		var rest := RootPath.world((bx["skel"] as Skeleton3D).global_transform.basis, RootPath.at(path, cs) - RootPath.at(path, ap.current_animation_position)) if not path.is_empty() else Vector3.ZERO
		return target(1 - i, body) - ((bx["node"] as Node3D).global_transform * front + rest), _rels[i].get(clip, Vector3.ZERO))


## Starts `clip` on boxer i through the join smoother. `travel`: the take's own hip travel moves his body.
func _play(i: int, clip: String, from_s: float, kind: String, travel: bool) -> void:
	if clip == "" or not _has(i, clip):
		return
	var bx: Dictionary = st.boxers[i]
	var ap: AnimationPlayer = bx["ap"]
	var was := str(_take[i].get("kind", ""))
	_settle(i)
	if str(ap.current_animation) == clip:
		ap.stop()
	var j: Vector2 = JOIN.get(kind, JOIN["punch"])
	if _join_next != Vector2.ZERO:
		j = _join_next
		_join_next = Vector2.ZERO
	# S525: a hook, an uppercut or a body shot thrown straight out of his own punch joins slower. The jab before it
	# ends with the trunk turned 65-80 deg and the next take starts square: at the punch join that turn came back in
	# three frames (50 deg in one). The wind such a punch now gets (ChoreoRules.WIND_TURN_S) has the room.
	if kind == "punch" and was == "punch" and not R.is_straight(str((db["rows"].get(clip, {}) as Dictionary).get("family", "jab"))):
		j = JOIN_TURN
	if bx.get("js") != null:
		(bx["js"] as Node).join(j.x, j.y)
		(bx["js"] as Node).set_target(ap, clip)
	ap.speed_scale = 1.0
	ap.play(clip, 0.0 if bx.get("js") != null else j.y, 1.0)
	if from_s > 0.0:
		ap.seek(from_s, true)
	if _feet[i] != null:
		_feet[i].hold = not travel and kind in ["reaction", "block", "defence"]   # played on the spot: its feet keep the canvas
	var path: PackedVector3Array = RootPath.of(ap.get_animation(clip)) if travel else PackedVector3Array()
	# S525 (three films, both critics every time: "the man who is hit barely moves"): a reaction starts part-way into
	# its take so the head is furthest on the blow (REACT_PEAK_S), and the take's hip travel up to that point was simply
	# lost (the body only followed the path from there on: a cross's 19 cm step back, a gut shot's 34-50 cm fold never
	# showed). The body now covers that ground too, on the blow (LEAD_MPS at most): the captured size of the reaction.
	# S526 (film 5, def1 #14-#20: a dodge started 0.33 s before the punch, part-way into its take, had lost the
	# 0.3-0.5 m its take steps aside before that point - the head stayed on the jab's line): a defence gets it too.
	var lead := Vector2.ZERO
	if kind in ["reaction", "defence"] and not path.is_empty() and from_s > 0.0:
		lead = RootPath.at(path, from_s) - RootPath.at(path, 0.0)
	# a reaction gives it on the blow; a defence over the whole time it has until the punch arrives (its head's peak)
	var lead_s: float = maxf((JOIN["reaction"] as Vector2).y, lead.length() / LEAD_MPS)
	if kind == "defence":
		lead_s = maxf(float((db["rows"].get(clip, {}) as Dictionary).get("head_peak_s", from_s + 0.3)) - from_s, 0.15)
	_take[i] = {"clip": clip, "kind": kind, "from_s": from_s, "origin": _home[i], "path": path, "at": t, "lead": lead, "lead_s": lead_s}
	if log_on:
		print("FP2 %6.2f %s %-9s %s from %.2f%s" % [t, "ab"[i], kind, clip, from_s, "" if not (kind in ["reaction", "defence"]) else (" on the spot" if path.is_empty() else " gives %.2f m" % lead.length())])


## The body stays where the take that ends has carried it.
func _settle(i: int) -> void:
	var n: Node3D = st.boxers[i]["node"]
	_home[i] = Vector3(n.position.x, 0.0, n.position.z)
	_take[i] = {}


func guard(i: int) -> void:
	var ap: AnimationPlayer = st.boxers[i]["ap"]
	if not ap.has_animation(GUARD):
		return
	_play(i, GUARD, 0.0, "guard", false)
	# each man in his own point of the loop (both started in step read as one man twice)
	ap.seek(fmod(float(i) * 0.83 + t * 0.37, maxf(ap.get_animation(GUARD).length - 0.05, 0.1)), true)


## FightStage: boxer i's take has played to its end.
func finished(i: int) -> void:
	if _scene or _down(i):
		return
	guard(i)


func _down(i: int) -> bool:
	var clip := str((st.boxers[i]["ap"] as AnimationPlayer).current_animation)
	for w in DOWN:
		if clip.contains(w):
			return true
	return false


func _scale(i: int) -> float:
	return (st.boxers[i]["node"] as Node3D).scale.x


func _has(i: int, clip: String) -> bool:
	return clip != "" and (st.boxers[i]["ap"] as AnimationPlayer).has_animation(clip)
