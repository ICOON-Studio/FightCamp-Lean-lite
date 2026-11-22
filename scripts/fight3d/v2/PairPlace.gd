extends RefCounted
## FIGHTPLAYER2 (S525, split out of Player2 at the 500-line rule): where the PAIR stands and faces.
##   follow  - the bodies follow the distance plan (the man the plan names covers the ground; nobody backs into the ropes);
##   square  - the pair turns about its own middle to stay side-on to the fixed camera (owner S500: "Boxers stay side-on";
##             the shipped player does it in RingPlace, v2 places the boxers itself and had lost it: by the second v2
##             film's last third the line between them pointed at the lens and one man's back hid the other);
##   face    - each man faces the other man's place;
##   place   - a take's own hip travel on top of where the man stands.
## It holds no state of its own: the places are Player2's (`_home`, `_take`, `_moved`).

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const Gap := preload("res://scripts/fight3d/v2/ChoreoGap.gd")
const RootPath := preload("res://scripts/fight3d/v2/RootPath.gd")
const FixedCam := preload("res://scripts/fight3d/FixedCam.gd")

## The bodies follow the plan at the plan's own speed plus this (S525; it was a flat 2.4 m/s: when a punch that steps
## ended, its 10-20 cm of travel came off the distance in two frames, a slide. Now it is walked off).
const CATCH_MPS := 0.7
const FACE_S := 0.10          # the turn to face the other man eases over this
const FACE_MAX_RPS := 3.5     # ... and is never faster than this (S513, the first film: side view to back view in one picture)
const FACE_HOLD_M := 0.50     # places closer than this give no line to face along (a take's travel carries a body past the other): hold
const EDGE_IN_M := 0.35       # nobody backs closer to the ropes than this
## The side-on turn, degrees a second: a calm circle while both wait (0.4 m/s of feet at rest), a drift while a take plays.
const SQUARE_WAIT_DPS := 28.0
const SQUARE_BUSY_DPS := 9.0
## S530 ANGLES (film 6, both critics: "No angles. In 75 seconds nobody pivots off the line", "every 3-5 s one man pivots
## 20-45 deg off the line"): the pair circles (StepPlay: a ring step that turns the pair's line with the captured side
## steps), so side-on has this much slack either way - inside it nothing turns the pair back; past it the pair is
## eased back to the slack's edge. Nobody's back hides the other man inside it. `-- fp2nocircle` = side-on, no circling.
## S531: the camera is fixed (owner S500) and neither critic of films 7 and 9 saw a circle step; what they saw is two men
## overlapping in the picture whenever the line is off side-on. The fight is fought on the camera's line: circling is
## off by default (`-- fp2circle` = on) and the slack is small.
## S531 (later the same day, owner Q-S294-276: "Let the camera follow the turn"): FixedCam.follow - the tripod swings
## after the pair, circling is back ON (`-- fp2nocircle` = off, the tripod then never needs to move). The slack is how
## far the pair may be off the lens while the tripod catches up (or stands at the end of its swing).
const SLACK_DEG := 24.0
static var circle_on: bool = not OS.get_cmdline_user_args().has("fp2nocircle")

var p: Node = null            # Player2
var _want_was := 0.0          # the distance asked for last frame (how fast it changes is how fast the bodies may follow)


func _init(player: Node) -> void:
	p = player
	FixedCam.follow = circle_on   # S531: only the v2 player swings the tripod
	FixedCam.lift = 0.25


## The bodies follow the distance plan.
func follow(delta: float) -> void:
	if delta <= 0.0:
		return
	var gap: Array = p.plan["gap"]
	var want: float = p.walk.want(Gap.at(gap, p.t))   # a step under way goes by its take's own hips (StepPlay)
	var a: Vector3 = stand(0)
	var b: Vector3 = stand(1)
	var line := Vector3(b.x - a.x, 0.0, b.z - a.z)
	var dist := line.length()
	if dist < 0.01:
		return
	var axis := line / dist
	var most := (maxf(absf(Gap.at(gap, p.t) - Gap.at(gap, p.t - delta)), absf(want - _want_was)) / delta + CATCH_MPS) * delta
	_want_was = want
	var err := clampf(want - dist, -most, most)
	if absf(err) < 0.0005:
		return
	var mover: String = p.walk.mover(Gap.who(gap, p.t))
	var share := [0.5, 0.5]
	if mover == "a":
		share = [1.0, 0.0]
	elif mover == "b":
		share = [0.0, 1.0]
	var edge: float = float(p.st.RING_M) * 0.5 - EDGE_IN_M
	for i in 2:
		var back: Vector3 = axis * (-1.0 if i == 0 else 1.0) * err * float(share[i])
		var to: Vector3 = (p._home[i] as Vector3) + back
		if err > 0.0 and maxf(absf(to.x), absf(to.z)) > edge and float(share[1 - i]) < 1.0:
			share[1 - i] = float(share[1 - i]) + float(share[i])   # his back is on the ropes: the other man gives the room
			share[i] = 0.0
	for i in 2:
		_shift(i, axis * (-1.0 if i == 0 else 1.0) * err * float(share[i]))


## The pair turns about its own middle toward side-on to the fixed camera. The feet step after it.
func square(delta: float) -> void:
	var cam: Variant = p.st.get("camera")
	if delta <= 0.0 or not FixedCam.on or not FixedCam.square_on or not (cam is Node) or not (cam as Node).has_meta("fixed_pos"):
		return
	var a: Vector3 = p._home[0]
	var b: Vector3 = p._home[1]
	var busy := false
	for i in 2:
		busy = busy or not (str(p._take[i].get("kind", "")) in p.WAITING)
	var most := deg_to_rad(SQUARE_BUSY_DPS if busy else SQUARE_WAIT_DPS) * delta
	var turn := clampf(FixedCam.square(a, b, (cam as Node).get_meta("fixed_pos") as Vector3, delta), -most, most)
	if circle_on:
		var off := off_side()
		turn = clampf(signf(off) * maxf(absf(off) - deg_to_rad(SLACK_DEG), 0.0), -most, most)
	if turn == 0.0:
		return
	var mid := (a + b) * 0.5
	_shift(0, mid + (a - mid).rotated(Vector3.UP, turn) - a)
	_shift(1, mid + (b - mid).rotated(Vector3.UP, turn) - b)


## How far (radians about +Y) the pair's line is from side-on to the fixed camera: the turn that would square it
## (0 with no fixed camera).
func off_side() -> float:
	var cam: Variant = p.st.get("camera")
	if not FixedCam.on or not FixedCam.square_on or not (cam is Node) or not (cam as Node).has_meta("fixed_pos"):
		return 0.0
	var a: Vector3 = p._home[0]
	var b: Vector3 = p._home[1]
	var d := Vector3(b.x - a.x, 0.0, b.z - a.z)
	var mid := (a + b) * 0.5
	var cp: Vector3 = (cam as Node).get_meta("fixed_pos")
	var to_cam := Vector3(cp.x - mid.x, 0.0, cp.z - mid.z)
	if d.length() < 0.05 or to_cam.length() < 0.05:
		return 0.0
	var line := Vector3.UP.cross(to_cam.normalized())
	if d.dot(line) < 0.0:
		line = -line
	return atan2(d.cross(line).y, d.dot(line))


## The pair turns about its own middle by `ang` (a circle step under way).
func turn_pair(ang: float) -> void:
	var a: Vector3 = p._home[0]
	var b: Vector3 = p._home[1]
	var mid := (a + b) * 0.5
	_shift(0, mid + (a - mid).rotated(Vector3.UP, ang) - a)
	_shift(1, mid + (b - mid).rotated(Vector3.UP, ang) - b)


func _shift(i: int, by: Vector3) -> void:
	p._home[i] = (p._home[i] as Vector3) + by
	p._moved[i] = Transform3D(Basis.IDENTITY, by) * (p._moved[i] as Transform3D)


## FootCarry: what the plan (not a take) has done to boxer i's body since it last asked.
func take_moved(i: int) -> Transform3D:
	var m: Transform3D = p._moved[i]
	p._moved[i] = Transform3D.IDENTITY
	return m


## FootCarry: where the plan carries boxer i's body in the next `secs` (a step lands there).
func ahead(secs: float, i: int) -> Vector3:
	if not p.live or p.plan.is_empty() or p._scene:
		return Vector3.ZERO
	var line: Vector3 = stand(1) - stand(0)
	line.y = 0.0
	var dist := line.length()
	if dist < 0.01:
		return Vector3.ZERO
	var most := (R.GAP_SPEED_MPS + CATCH_MPS) * secs
	var err := clampf(Gap.at(p.plan["gap"], p.t + secs) - dist, -most, most)
	var mover := Gap.who(p.plan["gap"], p.t + secs * 0.5)
	var share := 0.5 if mover in ["both", ""] else (1.0 if mover == "ab"[i] else 0.0)
	return line / dist * (-1.0 if i == 0 else 1.0) * err * share


## Where boxer i stands for the DISTANCE: his place, plus a reaction's or a defence's travel so far (a punch's own
## travel is inside its take's contact distance already).
func stand(i: int) -> Vector3:
	if str(p._take[i].get("kind", "")) == "punch":
		return p._home[i]
	return (p._home[i] as Vector3) + travel(i)


func travel(i: int) -> Vector3:
	var tk: Dictionary = p._take[i]
	var path: PackedVector3Array = tk.get("path", PackedVector3Array())
	if path.is_empty():
		return Vector3.ZERO
	var bx: Dictionary = p.st.boxers[i]
	var ap: AnimationPlayer = bx["ap"]
	if str(ap.current_animation) != str(tk["clip"]):
		return Vector3.ZERO
	var d := RootPath.at(path, ap.current_animation_position) - RootPath.at(path, float(tk["from_s"]))
	var lead: Vector2 = tk.get("lead", Vector2.ZERO)
	if lead != Vector2.ZERO:   # a reaction started part-way in: the ground its take had given by then, given on the blow
		var k := clampf((p.t - float(tk["at"])) / maxf(float(tk["lead_s"]), 0.01), 0.0, 1.0)
		d += lead * (k * k * (3.0 - 2.0 * k))
	return RootPath.world((bx["skel"] as Skeleton3D).global_transform.basis, d)


func place() -> void:
	for i in 2:
		var bx: Dictionary = p.st.boxers[i]
		var at: Vector3 = (p._home[i] as Vector3) + travel(i)
		(bx["node"] as Node3D).position = Vector3(at.x, (bx["node"] as Node3D).position.y, at.z)
		bx["pos"] = Vector3(at.x, 0.0, at.z)


## Each faces the other man's place (not his travelling hips: a slip must not turn the puncher).
func face(delta: float) -> void:
	for i in 2:
		var to: Vector3 = (p._home[1 - i] as Vector3) - (p._home[i] as Vector3)
		if to.length() < (0.05 if delta <= 0.0 else FACE_HOLD_M):
			continue
		var n: Node3D = p.st.boxers[i]["node"]
		var yaw := atan2(to.x, to.z)
		var was := n.rotation.y
		n.rotation = Vector3(0.0, yaw if delta <= 0.0 else was + clampf(angle_difference(was, lerp_angle(was, yaw, 1.0 - exp(-delta / FACE_S))), -FACE_MAX_RPS * delta, FACE_MAX_RPS * delta), 0.0)
		if delta > 0.0 and absf(angle_difference(was, n.rotation.y)) > 1e-5:   # a turn is the plan's motion too: about where he stands
			var c := n.global_position
			p._moved[i] = Transform3D(Basis.IDENTITY, c) * Transform3D(Basis(Vector3.UP, angle_difference(was, n.rotation.y)), Vector3.ZERO) * Transform3D(Basis.IDENTITY, -c) * (p._moved[i] as Transform3D)


## S537 BOUGHTCLIP1 (owner C469 "Cross can only reach shoulder?"): boxer i's size against the body the clip census was
## measured on. Every distance of the plan (a take's contact gap, its head and hips travel) is in the census body's
## metres - mh_boxer_10, a small one: its shoulder-to-wrist is CENSUS_ARM_M. The plan was handed the NODE's scale (1.0
## for every body), so a long-armed body was stood where the small body's glove ends: the plain cross of mh_boxer_01
## reaches 107 cm ahead of its hips, the census body's 90, the men stood 13-19 cm too close and the arm finish folded
## the arm to 75-84 % straight to keep the glove on the face (tools/boughtclip_probe.gd). The measure is the arm:
## 57.5 / 49.4 = 1.16 is what the reach asks of the gap (118 / 102 cm) on that pair.
const CENSUS_ARM_M := 0.494
var _size: Array = [0.0, 0.0]


func size(i: int) -> float:
	if float(_size[i]) <= 0.0:
		var sk: Skeleton3D = p.st.boxers[i]["skel"]
		var ids := [sk.find_bone("RightUpperArm"), sk.find_bone("RightLowerArm"), sk.find_bone("RightHand")]
		_size[i] = 1.0
		if not ids.has(-1):
			var arm := sk.get_bone_global_rest(ids[0]).origin.distance_to(sk.get_bone_global_rest(ids[1]).origin) + sk.get_bone_global_rest(ids[1]).origin.distance_to(sk.get_bone_global_rest(ids[2]).origin)
			_size[i] = arm * float(p._scale(i)) / CENSUS_ARM_M
	return float(_size[i])


func gap() -> float:
	var d: Vector3 = stand(1) - stand(0)
	return Vector2(d.x, d.z).length()


func node_gap() -> float:
	var d: Vector3 = (p.st.boxers[1]["node"] as Node3D).position - (p.st.boxers[0]["node"] as Node3D).position
	return Vector2(d.x, d.z).length()
