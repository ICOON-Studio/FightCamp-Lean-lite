extends Node
## S313 real-fight gap 4 (Game Godot/research/S310_REAL_FIGHT_GAPS.md row "Clinch"; filmed R1 1:14 chest to chest, R1
## 5:22.9 heads together and the referee parts them): the tie-up in the ring. No clinch clip exists (Fab, MoCap Online,
## Reallusion checked S311), so it is built from our own pieces: RangeBreath's "clinch" phase walks the holder in to
## CLINCH_M; here both stand in the block pose held mid-loop, each body shifted to its own left so the heads pass each
## other's shoulder, the holder's arms over the other's upper back and the other's hands on the holder's flanks
## (CornerIK, attached to every boxer by CornerCrew), each looking past the other's shoulder. The referee walks in;
## at break_t FightView's "ref" step_out beats call release(), the referee pushes them apart and both step out.
##   setup(stage)  start(holder, dur)  release()  offset(i, to) -> Vector3  floor_m(base) -> float  engaged

const POSES := ["pro_block_loop", "mc_block"]
## The tie-up starts once the pelvises are this close (the holder's walk in ends at RangeBreath.CLINCH_M).
const ENGAGE_M := 0.62
## Nobody closes inside this while tied up (the stage's usual floor is MIN_GAP_M 0.62).
const MIN_M := 0.32
## Each body shifts this far to her own left: heads 2 x SIDE_M apart sideways, cheek past the other's ear.
## S316 (operator on a clinch still: "very bad" - faces nose to nose): 0.13 puts the heads ear by ear, chin over the
## other's shoulder.
const SIDE_M := 0.13
const EASE_S := 0.3
## The pose is held between these shares of its loop (a block loop played to its end would hand back to the guard).
## Letting go: the shift and the closest gap ease back over this long (the referee's push and their step out cover it).
const RELEASE_S := 0.5
const HOLD_SPAN := Vector2(0.3, 0.75)
const HOLD_SPEED := 0.35
## Where the hands go, metres: over the shoulder blade (behind and below the shoulder joint), and on the flank.
const BACK_M := 0.13
const BLADE_DOWN_M := 0.06
const FLANK_M := 0.14
## S316 the overhook: the holder's wrist this far outside, behind and above the other's elbow.
const OVERHOOK_OUT_M := 0.07
const OVERHOOK_BACK_M := 0.06
const OVERHOOK_UP_M := 0.08

var stage: Node
var holder := -1
var engaged := false
var _w := 0.0
var _left := 0.0
var _pose := ""


func setup(s: Node) -> void:
	stage = s
	name = "Clinch"
	for p in POSES:
		if stage.has_move(p):
			_pose = p
			break


## A "clinch" beat: `who` ties up for about `dur` seconds (the referee's break releases it; this is the safety net).
func start(who: int, dur: float) -> void:
	holder = who
	engaged = false
	_left = dur + 1.5
	var ref: Node = stage.get("referee")
	if ref != null:
		ref.step_in()


func release() -> void:
	if holder < 0:
		return
	var was := engaged
	holder = -1
	engaged = false
	for i in 2:
		var ik: Node = stage.boxers[i].get("ik")
		if ik != null:
			ik.reach("Left", null)
			ik.reach("Right", null)
			ik.look(null)
		if was:
			stage.guard(i)
	var ref: Node = stage.get("referee")
	if ref != null:
		ref.part()


## The closest the two may stand: MIN_M while tied up, easing back to the stage's `base` as they let go (no snap apart).
func floor_m(base: float) -> float:
	if holder >= 0:
		return MIN_M
	return lerpf(base, MIN_M, _w)


## The shown body's shift (FightStage._compose adds it like the punch carry): her own left of the line to the other.
func offset(_i: int, to: Vector3) -> Vector3:
	if _w <= 0.0 or to.length() < 0.01:
		return Vector3.ZERO
	return Vector3.UP.cross(to.normalized()) * SIDE_M * _w * _w * (3.0 - 2.0 * _w)


func _process(delta: float) -> void:
	_w = move_toward(_w, 1.0 if engaged else 0.0, delta / (EASE_S if engaged else RELEASE_S))
	if holder < 0:
		return
	_left -= delta
	if _left <= 0.0:
		release()
		return
	var dist := (stage.boxers[0]["pos"] as Vector3).distance_to(stage.boxers[1]["pos"])
	if not engaged and dist <= ENGAGE_M and _free(0) and _free(1):
		_engage()
	if engaged and _pose != "":
		for i in 2:
			var ap: AnimationPlayer = stage.boxers[i]["ap"]
			var len := ap.get_animation(_pose).length
			if str(ap.current_animation) != _pose:
				stage.act(i, _pose, HOLD_SPEED)
				ap.seek(len * HOLD_SPAN.x, true)
			elif ap.current_animation_position > len * HOLD_SPAN.y:
				ap.seek(len * HOLD_SPAN.x, true)


## Not mid-step and not locked in a hit reaction.
func _free(i: int) -> bool:
	return float(stage.boxers[i]["move_left"]) <= 0.0 and stage.stun.left(i) <= 0.0


func _engage() -> void:
	engaged = true
	for i in 2:
		var ik: Node = stage.boxers[i].get("ik")
		if ik == null:
			continue
		var other := 1 - i
		# Facing each other, her left hand meets the other's right side.
		# S316: the holder overhooks - each arm over the other's arm at the elbow, pinning it (was: a hug around the
		# shoulders); the held boxer's gloves stay on the holder's ribs (she can only work the body).
		if i == holder:
			ik.reach("Left", _overhook.bind(other, "Right"))
			ik.reach("Right", _overhook.bind(other, "Left"))
		else:
			ik.reach("Left", _flank.bind(other, -1.0))
			ik.reach("Right", _flank.bind(other, 1.0))
		ik.look(_past.bind(other))


func _bone(i: int, bone: String) -> Vector3:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var id := skel.find_bone(bone)
	return skel.global_transform * skel.get_bone_global_pose(id).origin if id >= 0 else (stage.boxers[i]["node"] as Node3D).global_position


func _fwd(i: int) -> Vector3:
	return (stage.boxers[i]["node"] as Node3D).global_transform.basis.z.normalized()


## Over the other's arm just above her elbow on her `side`, from outside and a little behind: the holder's forearm pins it.
func _overhook(i: int, side: String) -> Vector3:
	var left := Vector3.UP.cross(_fwd(i)).normalized()
	var out := left if side == "Left" else -left
	return _bone(i, side + "LowerArm") + out * OVERHOOK_OUT_M - _fwd(i) * OVERHOOK_BACK_M + Vector3.UP * OVERHOOK_UP_M


## Over the other's shoulder blade on her `side`.
func _blade(i: int, side: String) -> Vector3:
	return _bone(i, side + "UpperArm") - _fwd(i) * BACK_M - Vector3.UP * BLADE_DOWN_M


## On the other's flank: `sgn` -1 her right side, +1 her left (her own frame), a little behind the ribs.
func _flank(i: int, sgn: float) -> Vector3:
	var left := Vector3.UP.cross(_fwd(i)).normalized()
	return _bone(i, "Spine") + left * FLANK_M * sgn - _fwd(i) * 0.04 + Vector3.UP * 0.08


## Past the other's shoulder (her own right of the other's head: the heads sit side by side).
func _past(i: int) -> Vector3:
	var left := Vector3.UP.cross(_fwd(i)).normalized()
	return _bone(i, "Head") - left * 0.35 - _fwd(i) * 0.3 - Vector3.UP * 0.15
