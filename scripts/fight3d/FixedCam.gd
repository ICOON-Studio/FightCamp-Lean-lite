extends RefCounted
## S500 the fight's ONE fixed camera (owner: "can you make it so the camera is fixed always and shows clearly the boxers in
## the fight"). The round is shown from one place that never moves and never cuts: a raised tripod outside the ropes, side
## of the ring. It only turns to keep the pair in the middle and holds them the same size wherever they stand in the ring
## (the lens narrows as they go to the far ropes and opens as they come near), both eased so nothing snaps. No apron
## shot, no clinch shot, no close-up on a big shot. The intro, the corner minute and the count keep their own film shots.
## `-- tvcam` = the S379 TV coverage that cuts (the control arm).
##   show(cam, a, b, snap, dt)     spot_for(a, b) -> Vector3 (pure)     fov_for(dist, apart, aspect) -> degrees (pure)     look_for(a, b) -> Vector3 (pure)

## The cameras the player can pick in the fight (FightOptions, key C): 0 SIDE = the fixed tripod; 1 HIGH = the same
## tripod much higher, looking down on the ring; 2 TV = the S379 coverage that rides and cuts.
const NAMES := ["Side", "High", "TV"]
const HIGH := Vector2(4.4, 6.6)        # the HIGH tripod: metres out, metres up
## The boxers keep SIDE-ON to the fixed tripod (owner S500: "Boxers stay side-on"): the pair is turned about its own
## middle toward the line across the picture, at most SQUARE_DEG_S, nothing inside DEAD_DEG. Their feet step after it.
const SQUARE_DEG_S := 35.0
const SQUARE_GAIN := 2.5
const DEAD_DEG := 4.0
static var mode: int = 2 if OS.get_cmdline_user_args().has("tvcam") else 0
static var square_on: bool = not OS.get_cmdline_user_args().has("nosquare")
const OUT_M := 6.0                     # the tripod stands this far from the ring's middle (3.25 m outside the ropes) ...
const UP_M := 4.0                      # ... and this high: it looks down about 32 degrees, so a boxer behind the other is
                                       # still seen (at 2.6 m one body hid the other whenever they lined up with the lens)
const SEE_M := 3.3                     # the picture is this tall where the pair stands: a boxer fills about 60 % of it
const SIDE_ROOM_M := 1.6               # ... and never narrower than the pair plus this
const LOOK_H := 0.95                   # it looks at their belt line
const EASE_S := 0.45
const FOV := Vector2(14.0, 46.0)

static var on: bool = not OS.get_cmdline_user_args().has("tvcam")


## Where the tripod stands for a round: on the side of the ring that sees the pair side-on (their line `b - a` runs
## across the picture), chosen once when the round starts and never moved after. A pair on the diagonal: the +Z side.
static func spot_for(a: Vector3, b: Vector3) -> Vector3:
	var along_x: bool = absf(b.x - a.x) >= absf(b.z - a.z)
	var out: float = HIGH.x if mode == 1 else OUT_M
	var up: float = HIGH.y if mode == 1 else UP_M
	return Vector3(0.0, up, out) if along_x else Vector3(-out, up, 0.0)


## The player picked camera `m` (0 SIDE, 1 HIGH, 2 TV): the tripod is placed again on the next frame.
static func pick(m: int, cam: Node) -> void:
	mode = posmod(m, NAMES.size())
	on = mode != 2
	if cam != null:
		cam.remove_meta("fixed_pos")
		cam.set("_shot", -1)   # the TV coverage starts a fresh shot


## How far (radians, about +Y) the pair a -> b turns this frame to stand side-on to a tripod at `cam_pos`.
static func square(a: Vector3, b: Vector3, cam_pos: Vector3, delta: float) -> float:
	var d := Vector3(b.x - a.x, 0.0, b.z - a.z)
	var mid := (a + b) * 0.5
	var to_cam := Vector3(cam_pos.x - mid.x, 0.0, cam_pos.z - mid.z)
	if d.length() < 0.05 or to_cam.length() < 0.05 or delta <= 0.0:
		return 0.0
	var line := Vector3.UP.cross(to_cam.normalized())
	if d.dot(line) < 0.0:
		line = -line
	var ang: float = atan2(d.cross(line).y, d.dot(line))
	if absf(ang) < deg_to_rad(DEAD_DEG):
		return 0.0
	var most: float = deg_to_rad(SQUARE_DEG_S) * delta
	return clampf(ang * SQUARE_GAIN * delta, -most, most)


## RingPlace calls this once a frame: both boxers' places turn about their middle (see `square`).
static func keep_square(boxers: Array, cam: Variant, delta: float) -> void:
	if not on or not square_on or not (cam is Node) or not (cam as Node).has_meta("fixed_pos"):
		return
	var a: Vector3 = boxers[0]["pos"]
	var b: Vector3 = boxers[1]["pos"]
	var turn: float = square(a, b, (cam as Node).get_meta("fixed_pos") as Vector3, delta)
	if turn == 0.0:
		return
	var mid := (a + b) * 0.5
	boxers[0]["pos"] = mid + (a - mid).rotated(Vector3.UP, turn)
	boxers[1]["pos"] = mid + (b - mid).rotated(Vector3.UP, turn)


static func look_for(a: Vector3, b: Vector3) -> Vector3:
	return Vector3((a.x + b.x) * 0.5, LOOK_H, (a.z + b.z) * 0.5)


## The lens angle (vertical, degrees) that shows SEE_M of height at `dist`, wider when the pair stands `apart` across it.
static func fov_for(dist: float, apart: float, aspect: float) -> float:
	var tall: float = maxf(SEE_M, (apart + SIDE_ROOM_M) / maxf(aspect, 0.5))
	return clampf(rad_to_deg(2.0 * atan(tall * 0.5 / maxf(dist, 1.0))), FOV.x, FOV.y)


## One frame of the round. `snap`: the ring changed hands (a round starts, a film shot ended): no easing from the old look.
static func show(cam: Camera3D, a: Vector3, b: Vector3, snap: bool, dt: float) -> void:
	var want: Vector3 = look_for(a, b)
	if not cam.has_meta("fixed_pos"):   # once: the pair is kept side-on to it (keep_square), so it never needs moving
		cam.set_meta("fixed_pos", spot_for(a, b))
	var POS: Vector3 = cam.get_meta("fixed_pos")
	var to_cam := Vector3(POS.x - want.x, 0.0, POS.z - want.z).normalized()
	var across: float = absf(Vector3(b.x - a.x, 0.0, b.z - a.z).dot(Vector3.UP.cross(to_cam)))
	var size: Vector2 = cam.get_viewport().get_visible_rect().size if cam.is_inside_tree() else Vector2(16.0, 9.0)
	var want_fov: float = fov_for(POS.distance_to(want), across, size.x / maxf(size.y, 1.0))
	var k: float = 1.0 if snap or not cam.has_meta("fixed_look") else 1.0 - exp(-dt / EASE_S)
	var look: Vector3 = (cam.get_meta("fixed_look", want) as Vector3).lerp(want, k)
	cam.set_meta("fixed_look", look)
	cam.fov = lerpf(cam.fov, want_fov, k)
	cam.set("shot_name", "fixed")
	cam.call("_place_lens", POS, look)
