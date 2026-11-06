extends RefCounted
## S391 FOOTWORK wired into the ring (operator on the step clips: "those clips are all terrible", board C240 "the walking
## is terrrible at the startof the fight"; clips scored 4/10: feet skate and cross). BoxerFootwork + BoxerFootworkRig take
## over from the S320 glide. The fight still says WHERE she stands (bx["pos"], Footwork.walk, RangeBreath: nothing the
## fight decides changes), but her body no longer glides there: the feet chase that place in step pairs and the body is
## shown over the feet, so it travels only as far as they are put down. FootPlant stays under the rig and has the legs
## back whenever the rig lets go (want = 0): falls, knockouts, the win, the clinch, and in a scene anything but her guard.
## `-- nofootwork` = the S320 glide on FootPlant, `-- stepclips` = the old stride clips (the control arms).
##   tick(st, i, delta)  before RingPlace shows her     shown(bx) -> Vector3   where her hips are shown
##   scene(st, delta)    a director's boxers (FightStage._process, scene on)   walk_to / walking / arrived: CornerCrew.walk

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const GuardLife := preload("res://scripts/fight3d/GuardLife.gd")

const BOUNCE_SHARE := 0.55   # of the time on the balls of her feet, fresh (BoxerFootwork.bounce_share)
const DEAD_M := 0.07         # her place may sit this far off her feet before a step goes in
const ARRIVE_M := 0.02       # ... this far at the end of a director's walk
const PAIR_M := 0.34         # the longest calm step pair
const QUICK_M := 0.45        # the longest lunge pair
const QUICK_V := 1.3         # her place moving this fast (m/s): a lunge
const DUR_S := Vector2(0.27, 0.46)   # a pair's length (each foot a little over half of it)
const CALM_V := 0.75         # the pace a pair is timed on when her place is not moving (m/s)
const FREE := ["knockout", "win", "countdown", "fall"]   # as FootPlant's free clips
const TELEPORT_M := 0.15     # a director moved her body this far from where it was shown: stand there
const WALK_LEAD_M := 0.35    # a director's walk stays this far ahead of her feet at most
const BACK_MS := 0.6         # backing to the neutral corner
const JUMP_M := 1.2          # her place this far from her feet was set, not stepped to (a film rewound, a scene's end)


static func on(st: Node, bx: Dictionary) -> bool:
	return bx.get("rig") != null and bool(st.feet.rig_on)


## One frame of boxer i in the fight: who has the legs, her facing, the bounce, the next step.
static func tick(st: Node, i: int, delta: float) -> void:
	var bx: Dictionary = st.boxers[i]
	if delta <= 0.0 or not on(st, bx):   # 0: FightStage.setup places them; a stage that only poses stills never takes the rig
		return
	var rig: Node = bx["rig"]
	var ap: AnimationPlayer = bx["ap"]
	var clip := str(ap.current_animation)
	var free: bool = st.clinch.engaged or int(st.clinch.holder) >= 0   # from the tie-up on: the hold's bars read the clip's own body
	for w in FREE:
		free = free or clip.contains(w)
	rig.want = 0.0 if free else 1.0
	rig.ease_w(delta)
	var plan: RefCounted = rig.plan
	var pos: Vector3 = bx["pos"]
	var other: Vector3 = st.boxers[1 - i]["pos"]
	var yaw := atan2(other.x - pos.x, other.z - pos.z)
	var goal: Vector2 = _xz(_end(st, bx)) - rig.mid() + _xz(st.feet.offset(other - pos))   # S392: inside, her feet go off the line with her
	if free or float(rig.w) <= 0.0 or goal.distance_to(plan.centre()) > JUMP_M:
		_stand(rig, _xz(pos), yaw)   # she stands where the fight says until the rig has her back
		return
	var dt := 0.0 if float(st._hold_left) > 0.0 else delta   # the hit-stop holds the feet too
	plan.face(yaw)
	plan.hold_want = 0.0 if _guarded(clip) else 1.0
	plan.pivot_want = _drive(clip)
	var opp: Node = st.boxers[1 - i].get("rig")
	plan.keep_off = opp.plan.spots() if opp != null else []
	plan.bounce_share = BOUNCE_SHARE * float(bx.get("legs", 1.0))   # burning legs stop bouncing first
	plan.tick(dt)
	_chase(rig, goal, (bx["vel"] as Vector3).length() if float(bx["move_left"]) > 0.0 else 0.0, DEAD_M)


## Stands her hips (her body node) on `at`, feet in her stance, no step.
static func _stand(rig: Node, at: Vector2, yaw: float) -> void:
	rig.plan.place(at, yaw)
	rig.plan.place(at - rig.mid(), yaw)


## Where her hips are shown: over her feet, easing to the fight's place as the rig lets go.
static func shown(st: Node, bx: Dictionary) -> Vector3:
	var pos: Vector3 = bx["pos"]
	if not on(st, bx):
		return pos
	var rig: Node = bx["rig"]
	var c: Vector2 = (rig.plan.centre() as Vector2) + rig.mid()
	return pos.lerp(Vector3(c.x, pos.y, c.y), float(rig.w))


## Where she will stand when this step ends: the feet aim there at once (her place runs ahead of them in a quick step).
static func _end(st: Node, bx: Dictionary) -> Vector3:
	var pos: Vector3 = bx["pos"]
	var left := float(bx["move_left"])
	var vel: Vector3 = bx["vel"]
	if left <= 0.0 or vel.length() < 0.01:
		return pos
	var travel := vel.length() * left
	if float(bx.get("aim_dir", 0.0)) != 0.0:
		travel = minf(travel, absf(float(st._gap()) - float(bx["aim_m"])))
	return pos + vel.normalized() * travel


## A step pair toward stance centre `goal` once she is off it: long as the way there, timed by how fast her place moves.
static func _chase(rig: Node, goal: Vector2, speed: float, dead: float) -> void:
	var plan: RefCounted = rig.plan
	if not (plan.pair as Dictionary).is_empty():
		if speed >= QUICK_V:   # a lunge cannot wait for a calm pair: it finishes fast
			plan.pair["dur"] = minf(float(plan.pair["dur"]), DUR_S.x)
		return
	var err: Vector2 = goal - (plan.centre() as Vector2)
	var dist := err.length()
	if dist <= dead:
		return
	var quick := speed >= QUICK_V
	var m := minf(dist, QUICK_M if quick else PAIR_M) * maxf(float(plan.scale), 0.5)
	m = minf(m, dist)
	var dur := clampf(m / maxf(speed, CALM_V), DUR_S.x, DUR_S.y)
	plan.go((plan.centre() as Vector2) + err / dist * m, dur)


## Which foot a punch drives off, [lead, rear]: a right-hand clip is her rear hand (a southpaw's clips are mirrored), a left
## hook her lead side. A jab stays on planted feet; slips, weaves and hits drive nothing.
static func _drive(clip: String) -> Array:
	if not clip.begins_with("pro_") or clip.contains("hit_by") or clip.contains("dodge") or clip.contains("weave"):
		return [0.0, 0.0]
	if clip.begins_with("pro_right_"):
		return [0.0, 1.0]
	return [1.0, 0.0] if clip.begins_with("pro_left_hook") else [0.0, 0.0]


## Standing in her guard or a fidget (a punch, a slip or a reaction calms the bounce).
static func _guarded(clip: String) -> bool:
	return clip in BeatClips.GUARD or clip in GuardLife.FIDGETS


static func _xz(v: Vector3) -> Vector2:
	return Vector2(v.x, v.z)


## --- a director's boxers (intro, corner minute): scene mode runs no fight rules, so the walk and the feet live here.

## Hands boxer i's legs to the rig for a director: she stands, in her guard, where her body stands now.
static func hold(st: Node, i: int) -> void:
	var bx: Dictionary = st.boxers[i]
	if not on(st, bx):
		return
	var n: Node3D = bx["node"]
	bx["scene_feet"] = true
	bx["walk_live"] = false
	bx["walk_at"] = n.position
	bx["shown_at"] = n.position
	(bx["rig"] as Node).want = 1.0
	if float(bx["rig"].w) <= 0.0:
		_stand(bx["rig"], _xz(n.position), n.rotation.y)


## Her legs go back to the clip and FootPlant (a scene starts).
static func release(bx: Dictionary) -> void:
	bx["scene_feet"] = false
	if bx.get("rig") != null:
		(bx["rig"] as Node).want = 0.0


## A scene hands her back: the director left her body where it is. Her feet go there if they are not (a skip, a cut).
static func handed_back(st: Node, bx: Dictionary) -> void:
	bx["scene_feet"] = false
	if on(st, bx) and _xz(shown(st, bx)).distance_to(_xz(bx["pos"])) > TELEPORT_M:
		_stand(bx["rig"], _xz(bx["pos"]), (bx["node"] as Node3D).rotation.y)


## One frame of her walk at `speed` toward `to`. True once her feet stand there.
static func walking(bx: Dictionary, to: Vector3, speed: float, delta: float) -> bool:
	var at: Vector3 = bx["walk_at"]
	var d := Vector3(to.x - at.x, 0.0, to.z - at.z)
	var rig: Node = bx["rig"]
	var ahead: float = (_xz(at) - rig.mid() - (rig.plan.centre() as Vector2)).length()
	if d.length() > 0.001 and ahead < WALK_LEAD_M:
		bx["walk_at"] = at + d.limit_length(speed * delta)
	bx["walk_live"] = true
	if d.length() > 0.001 or not arrived(bx, to):
		return false
	bx["walk_live"] = false   # on the mark: her body stands on it exactly (a turn on the spot or a sit starts from there)
	(bx["node"] as Node3D).position = Vector3(to.x, (bx["node"] as Node3D).position.y, to.z)
	bx["walk_at"] = (bx["node"] as Node3D).position
	bx["shown_at"] = bx["walk_at"]
	return true


## One frame of a boxer backing away to `to` in a scene (the knockdown's neutral corner). True once his feet stand there.
static func backing(st: Node, i: int, to: Vector3, delta: float) -> bool:
	var bx: Dictionary = st.boxers[i]
	if not bool(bx.get("scene_feet", false)):
		st.guard(i)
		hold(st, i)
	return walking(bx, to, BACK_MS * (bx["node"] as Node3D).scale.x, delta)


static func arrived(bx: Dictionary, to: Vector3) -> bool:
	var rig: Node = bx["rig"]
	return (rig.plan.pair as Dictionary).is_empty() and (_xz(to) - rig.mid() - (rig.plan.centre() as Vector2)).length() <= ARRIVE_M * 1.5


## Every frame of a scene: a boxer the rig holds stands on her feet, facing the way her node faces (the director turns it).
static func scene(st: Node, delta: float) -> void:
	for i in st.boxers.size():
		var bx: Dictionary = st.boxers[i]
		if not on(st, bx):
			continue
		var rig: Node = bx["rig"]
		rig.ease_w(delta)
		if not bool(bx.get("scene_feet", false)):
			continue
		var n: Node3D = bx["node"]
		var clip := str((bx["ap"] as AnimationPlayer).current_animation)
		rig.want = 1.0 if _guarded(clip) else 0.0
		if float(rig.want) <= 0.0:
			bx["walk_at"] = n.position   # a sit, a stand: the clip and its director have her
			bx["shown_at"] = n.position
			continue
		var moved := _xz(n.position).distance_to(_xz(bx["shown_at"])) > TELEPORT_M
		if moved or float(rig.w) <= 0.0:
			bx["walk_at"] = n.position
			_stand(rig, _xz(n.position), n.rotation.y)
		var plan: RefCounted = rig.plan
		plan.face(n.rotation.y)
		plan.hold_want = 0.0
		plan.tick(delta)
		_chase(rig, _xz(bx["walk_at"]) - rig.mid(), 0.0, ARRIVE_M if bool(bx.get("walk_live", false)) else DEAD_M)
		if not bool(bx.get("walk_live", false)):
			continue   # standing or turning on the spot: the body stays put, the feet come under it
		var c: Vector2 = (plan.centre() as Vector2) + rig.mid()
		n.position = Vector3(c.x, n.position.y, c.y)
		bx["shown_at"] = n.position
