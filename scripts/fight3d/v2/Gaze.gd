extends SkeletonModifier3D
## FIGHTPLAYER2 (S536 FP2POSE1, the owner on the blue cross still, C454: "where the fuck is he looking at"): THE EYES
## STAY ON THE OTHER MAN. The Punch PRO takes are a shadow boxer's: with nobody in front of him the actor's head rides
## his shoulders (the raw FBX, Box1_M3_Right_Cross: head 76 deg off his own punch line at the contact, 21 deg FURTHER
## round than his chest; our bake shows the same 86 deg, tools/fp2pose_probe.gd) - on the side-on camera the puncher
## looks into the lens and his split stance reads as crossed legs. v2 had no gaze at all (the shipped player's head
## layers are off under v2). This gives the take the one thing a shadow boxer has not got, a target:
##   - the head and neck turn (about the upright) until the face is within DEAD_DEG of the other man's head as drawn,
##     never further against the upper chest than a neck goes (NECK_MAX_DEG: the chin behind the punching shoulder);
##   - the chin stays down but the eyes do not go to the floor (PITCH_DOWN_DEG under the line to his head at most);
##   - a man who is being hit, is down, or is in a director's scene keeps the take's own head (eased over EASE_S).
## Only the neck and the head are written; where the head IS does not change by more than the neck's own swing.
## `-- fp2nogaze` = the takes' own heads (the control arm; tests/player2_test.gd GAZE is red with it).
##   add(skel, player, i, after) -> Gaze | null

const DEAD_DEG := 6.0
const NECK_MAX_DEG := 70.0
const PITCH_DOWN_DEG := 15.0
const PITCH_UP_DEG := 10.0
const PITCH_MOST_DEG := 35.0
const NECK_SHARE := 0.35      # of the turn, given at the neck; the head joint gives the rest
const EASE_S := 0.12
const FOLLOW_S := 0.04
const NEAR_M := 0.25          # heads closer than this (flat) give no line to look along
const OFF := ["reaction"]
static var gaze_on: bool = not OS.get_cmdline_user_args().has("fp2nogaze")

var p: Node = null            # Player2
var who := 0
var w := 0.0                  # how much of the gaze is on
var _yaw := 0.0               # the turn given now (radians, about the upright)
var _pitch := 0.0             # the lift given now
var _head := -1
var _neck := -1
var _chest := -1
var _head_rest := Basis.IDENTITY
var _chest_rest := Basis.IDENTITY


static func add(skel: Skeleton3D, player: Node, i: int, after: Node) -> Node:
	var m := new()
	m.name = "Gaze"
	m.p = player
	m.who = i
	m._head = skel.find_bone("Head")
	m._neck = skel.find_bone("Neck")
	m._chest = skel.find_bone("UpperChest")
	if m._head < 0 or m._neck < 0 or m._chest < 0:
		m.free()
		return null
	m._head_rest = skel.get_bone_global_rest(m._head).basis.orthonormalized().inverse()
	m._chest_rest = skel.get_bone_global_rest(m._chest).basis.orthonormalized().inverse()
	skel.add_child(m)
	skel.move_child(m, (after.get_index() + 1) if after != null else 0)
	return m


func _process_modification() -> void:
	if p == null or not gaze_on:
		return
	var skel := get_skeleton()
	var dt := get_process_delta_time()
	var kind := str((p._take[who] as Dictionary).get("kind", ""))
	var seen: Dictionary = p._drawn[1 - who]
	var on: bool = not bool(p._scene) and not (kind in OFF) and not bool(p._down(who)) and seen.has("Head")
	w = move_toward(w, 1.0 if on else 0.0, dt / EASE_S)
	if w < 0.005 or not seen.has("Head"):
		_yaw = 0.0
		_pitch = 0.0
		return
	var sb := skel.global_transform.basis.orthonormalized()
	var node: Node3D = p.st.boxers[who]["node"]
	var front: Vector3 = sb.inverse() * node.global_transform.basis.orthonormalized().z   # the body's own front, in the skeleton
	var hg := skel.get_bone_global_pose(_head)
	var to: Vector3 = (p.st.boxers[1 - who]["skel"] as Skeleton3D).global_transform * (seen["Head"] as Vector3) - skel.global_transform * hg.origin
	var to_f := Vector3(to.x, 0.0, to.z)
	var face: Vector3 = (sb * (hg.basis.orthonormalized() * _head_rest * front)).normalized()
	var face_f := Vector3(face.x, 0.0, face.z)
	var chest: Vector3 = sb * (skel.get_bone_global_pose(_chest).basis.orthonormalized() * _chest_rest * front)
	var chest_f := Vector3(chest.x, 0.0, chest.z)
	var want_yaw := 0.0
	var want_pitch := 0.0
	if to_f.length() > NEAR_M and face_f.length() > 0.2 and chest_f.length() > 0.2:
		var dead := deg_to_rad(DEAD_DEG)
		var err := to_f.signed_angle_to(face_f, Vector3.UP)          # how far round the face is off him
		want_yaw = err - clampf(err, -dead, dead)
		var hc := chest_f.signed_angle_to(face_f, Vector3.UP)        # the head against the chest, as the take has it
		var most := deg_to_rad(NECK_MAX_DEG)
		if want_yaw > 0.0:
			want_yaw = minf(want_yaw, maxf(hc + most, 0.0))
		else:
			want_yaw = maxf(want_yaw, minf(hc - most, 0.0))
		var rel := asin(clampf(face.y, -1.0, 1.0)) - asin(clampf(to.normalized().y, -1.0, 1.0))
		if rel < -deg_to_rad(PITCH_DOWN_DEG):
			want_pitch = minf(-deg_to_rad(PITCH_DOWN_DEG) - rel, deg_to_rad(PITCH_MOST_DEG))
		elif rel > deg_to_rad(PITCH_UP_DEG):
			want_pitch = maxf(deg_to_rad(PITCH_UP_DEG) - rel, -deg_to_rad(PITCH_MOST_DEG))
	var k := 1.0 - exp(-dt / FOLLOW_S)
	_yaw = lerpf(_yaw, want_yaw, k)
	_pitch = lerpf(_pitch, want_pitch, k)
	var ww := w * w * (3.0 - 2.0 * w)
	var ay := -_yaw * ww
	var ap := _pitch * ww
	if absf(ay) < 0.0005 and absf(ap) < 0.0005:
		return
	var axis := face_f.cross(Vector3.UP).normalized() if face_f.length() > 0.2 else Vector3.RIGHT   # turning about it lifts the face
	var inv := sb.inverse()
	var part: Basis = inv * (Basis(Vector3.UP, ay * NECK_SHARE) * Basis(axis, ap * NECK_SHARE)) * sb
	var whole: Basis = inv * (Basis(Vector3.UP, ay) * Basis(axis, ap)) * sb
	var ng := skel.get_bone_global_pose(_neck)
	skel.set_bone_global_pose(_neck, Transform3D(part * ng.basis, ng.origin))
	var moved := skel.get_bone_global_pose(_head)                    # where the neck's share has carried the head
	skel.set_bone_global_pose(_head, Transform3D(whole * hg.basis, moved.origin))
