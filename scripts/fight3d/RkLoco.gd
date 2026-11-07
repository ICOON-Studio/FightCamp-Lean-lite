extends RefCounted
## S399 ROKOKO2 locomotion (operator S399 on the films: "the fighters are sliding, is that intended?"): every move across the
## canvas is a captured step clip, and the CLIP's own hip travel moves the body - never a body gliding under a guard.
##   Each loco clip (RkClips "loco": true) is made IN PLACE at load: its hips keep their height and bob, their floor travel
##   comes out into a root curve (body-local metres per frame, register). Every frame, tick() moves her by the curve's change
##   since the last frame (bx["pos"] in the fight, the node itself in a scene), turned and scaled by her node, mirrored for a
##   southpaw. So her feet land where the take put them while she travels (Godot's own root motion would also take the hips'
##   height away - the bob of the walk).
##   pick(bx, dir, metres) -> {"clip", "seconds"}: the loco clip whose travel points the way the fight asks, played for the
##   whole loops (or the whole captured step) nearest the distance - the plan asks for a displacement, the picker covers it.
## Clips (RkClips): rk_loc_in = the actor's captured step in (Boxing 0.20-1.80, mirrored), rk_loc_back = Mixamo Walking
## Backwards (the walk the operator passed), rk_loc_left / rk_loc_right = Mixamo boxing side steps, rk_loc_walk = Mixamo
## Standard Walk (corner to centre, hands down).

const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const FPS := 30.0
const MAX_LOOPS := 3

static var _curves: Dictionary = {}   # skeleton instance id -> {clip: {"curve": PackedVector3Array, "loop_s", "loop_m"}}


static func on() -> bool:
	return RkClips.on()


static func is_loco(clip: String) -> bool:
	return clip.begins_with("rk_loc_")


## Takes the floor travel out of `anim`'s Hips track (bare bone-name paths) into a root curve for this skeleton. `loops`:
## how many loops the clip was chained from (1 = a single captured step).
static func register(name: String, anim: Animation, skel: Skeleton3D, body: Node3D, loops: int) -> void:
	var hips_t := -1
	for t in anim.get_track_count():
		if anim.track_get_type(t) == Animation.TYPE_POSITION_3D and str(anim.track_get_path(t)) == "Hips":
			hips_t = t
	if hips_t < 0:
		return
	var hips := skel.find_bone("Hips")
	var parent := skel.get_bone_parent(hips)
	var pb: Basis = skel.get_bone_global_rest(parent).basis if parent >= 0 else Basis.IDENTITY
	var up := pb.inverse() * Vector3.UP
	var to_body: Basis = (body.global_transform.affine_inverse() * skel.global_transform).basis
	var p0: Vector3 = anim.track_get_key_value(hips_t, 0)
	var curve := PackedVector3Array()
	var n := anim.track_get_key_count(hips_t)
	for k in n:
		var p: Vector3 = anim.track_get_key_value(hips_t, k)
		var d := p - p0
		var h := d - up * (d.dot(up) / up.length_squared())
		anim.track_set_key_value(hips_t, k, p - h)
		var b := to_body * (pb * h)
		curve.append(Vector3(b.x, 0.0, b.z))
	var end: Vector3 = curve[curve.size() - 1]
	var per := maxi(loops, 1)
	if not _curves.has(skel.get_instance_id()):
		_curves[skel.get_instance_id()] = {}
	_curves[skel.get_instance_id()][name] = {"curve": curve, "loop_s": anim.length / per, "loop_m": end.length() / per,
		"dir": end.normalized() if end.length() > 0.01 else Vector3.ZERO, "length": anim.length, "loops": per}


static func info(skel: Skeleton3D, clip: String) -> Dictionary:
	return (_curves.get(skel.get_instance_id(), {}) as Dictionary).get(clip, {})


static func sample(row: Dictionary, t: float) -> Vector3:
	var c: PackedVector3Array = row["curve"]
	var f := clampf(t * FPS, 0.0, float(c.size() - 1))
	var i := int(f)
	return c[i] if i >= c.size() - 1 else c[i].lerp(c[i + 1], f - i)


## The loco clip for a step of `metres` toward `dir` (body-local, +Z = her facing): {} when none points that way.
static func pick(bx: Dictionary, dir: Vector3, metres: float) -> Dictionary:
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var want := Vector3(dir.x, 0.0, dir.z).normalized()
	if bool(bx.get("south", false)):
		want.x = -want.x   # her clips are mirrored: the curves are stored as built (orthodox)
	var best := ""
	var best_dot := 0.8
	for clip in (_curves.get(skel.get_instance_id(), {}) as Dictionary):
		var row: Dictionary = _curves[skel.get_instance_id()][clip]
		if clip == "rk_loc_walk" or not ap.has_animation(clip):
			continue
		var dt := (row["dir"] as Vector3).dot(want)
		if dt > best_dot:
			best_dot = dt
			best = clip
	if best == "":
		return {}
	var row2: Dictionary = _curves[skel.get_instance_id()][best]
	var loops := clampi(int(round(metres / maxf(float(row2["loop_m"]), 0.01))), 1, int(row2["loops"]))
	return {"clip": best, "seconds": float(row2["loop_s"]) * loops, "metres": float(row2["loop_m"]) * loops}


## One frame: a loco clip playing moves her by its root curve. Returns the world move (zero when none plays).
## `delta`: this frame; the AnimationPlayer advances AFTER the stage's _process, so the clip time this frame will show is
## predicted (its position + delta x its playing speed) - else her body trails her feet by a frame (S399: +0.08 m of slide
## on the side step's push-and-drag).
static func tick(bx: Dictionary, in_scene: bool, delta: float = 0.0) -> Vector3:
	var ap: AnimationPlayer = bx["ap"]
	var clip := str(ap.current_animation)
	var row := info(bx["skel"], clip) if is_loco(clip) else {}
	if row.is_empty():
		bx["rk_root"] = []
		return Vector3.ZERO
	var t := minf(ap.current_animation_position + delta * ap.get_playing_speed(), ap.current_animation_length)
	var last: Array = bx.get("rk_root", [])
	var t0: float = float(last[1]) if last.size() == 2 and str(last[0]) == clip and float(last[1]) <= t else 0.0
	bx["rk_root"] = [clip, t]
	var d := sample(row, t) - sample(row, t0)
	if bool(bx.get("south", false)):
		d.x = -d.x
	var node: Node3D = bx["node"]
	var w := node.global_transform.basis * d
	w.y = 0.0
	if in_scene:
		node.position += w
	else:
		bx["pos"] = (bx["pos"] as Vector3) + w
	return w
