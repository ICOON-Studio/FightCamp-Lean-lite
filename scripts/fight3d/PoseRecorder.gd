extends SkeletonModifier3D
## S376 KNOCKDOWN1: the LAST modifier on a boxer's skeleton keeps the pose the viewer was shown (every bone's local
## position and rotation, and her body's place in the ring) for the last REC_S seconds, on its own clock (game time).
## KnockdownReplay sets `play` to a time on that clock: the recorder then draws that moment (interpolated between the
## frames around it) over whatever the animation and the other modifiers did - the slow-motion replay of the shot.
##   var r := PoseRecorder.new(); r.body = her_root; skel.add_child(r)   r.clock   r.oldest()   r.play = t / -1.0

const REC_S := 4.0

var body: Node3D               # her root in the ring (Footwork moves it)
var clock := 0.0               # seconds recorded so far (game time)
var play := -1.0               # >= 0: draw the recorded moment at this clock time instead of recording
var _t: PackedFloat32Array = []
var _root: Array = []          # Transform3D per frame
var _pos: Array = []           # PackedVector3Array per frame
var _rot: Array = []           # Array[Quaternion] per frame
var _was_playing := false


func oldest() -> float:
	return _t[0] if not _t.is_empty() else clock


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	if play >= 0.0 and _t.size() >= 2:
		_was_playing = true
		_draw(skel, play)
		return
	if _was_playing:
		# Back to live: her root goes back where the freeze left it (the newest frame); the bones are live again.
		_was_playing = false
		if body != null and not _root.is_empty():
			body.global_transform = _root[_root.size() - 1]
		return
	clock += get_process_delta_time()
	var n := skel.get_bone_count()
	var pos := PackedVector3Array()
	pos.resize(n)
	var rot: Array = []
	rot.resize(n)
	for b in n:
		pos[b] = skel.get_bone_pose_position(b)
		rot[b] = skel.get_bone_pose_rotation(b)
	_t.append(clock)
	_root.append(body.global_transform if body != null else Transform3D.IDENTITY)
	_pos.append(pos)
	_rot.append(rot)
	while _t.size() > 2 and _t[0] < clock - REC_S:
		_t.remove_at(0)
		_root.pop_front()
		_pos.pop_front()
		_rot.pop_front()


## The recorded moment at clock time `at`, blended between the two frames around it.
func _draw(skel: Skeleton3D, at: float) -> void:
	var k := clampi(_t.bsearch(at) - 1, 0, _t.size() - 2)
	var span := maxf(1e-5, _t[k + 1] - _t[k])
	var w := clampf((at - _t[k]) / span, 0.0, 1.0)
	var pa: PackedVector3Array = _pos[k]
	var pb: PackedVector3Array = _pos[k + 1]
	var ra: Array = _rot[k]
	var rb: Array = _rot[k + 1]
	for b in mini(skel.get_bone_count(), pa.size()):
		skel.set_bone_pose_position(b, pa[b].lerp(pb[b], w))
		skel.set_bone_pose_rotation(b, (ra[b] as Quaternion).slerp(rb[b] as Quaternion, w))
	if body != null:
		body.global_transform = (_root[k] as Transform3D).interpolate_with(_root[k + 1] as Transform3D, w)
