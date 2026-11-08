extends RefCounted
## S399 ROKOKO2 joins (operator S399: "the clips seem fine but what matters is the sequence blending"). Every join INTO a
## captured clip (RkClips) shares her feet: the new clip's feet at the frame it starts from are laid over the feet she
## stands on - her place on the canvas (bx["pos"]) shifts by the best fit of the two feet (least squares: the mean of the
## two differences, weighted toward the lower, more planted foot), and the join smoother carries her hips across the shift
## (JoinSmoother.carry, as SideStep does), so nothing jumps and the blend only has the stance difference left to cover.
## Measured by tools/rokoko_seq.gd (a 30-s scripted sequence, slide inside each join's 0.45 s).
##   capture(stage, who)  BEFORE the new clip starts (a seek poses the skeleton at once)
##   align(stage, who)    right after it has started and been seeked (FightStage.guard / play, Footwork.walk)

const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const FPS := 30.0
const MAX_SHIFT_M := 0.45   # a fit further than this is not a join, it is a different place: leave it

static var _feet: Dictionary = {}   # skeleton id -> {clip: PackedVector3Array [L0, R0, L1, R1, ...] skeleton space}


## The feet (toe balls) of `clip` on `skel`, frame by frame (skeleton space), built once.
static func feet(skel: Skeleton3D, ap: AnimationPlayer, clip: String) -> PackedVector3Array:
	var sid := skel.get_instance_id()
	if (_feet.get(sid, {}) as Dictionary).has(clip):
		return _feet[sid][clip]
	var anim := ap.get_animation(clip)
	var rot := {}
	var pos := {}
	for t in anim.get_track_count():
		var b := skel.find_bone(str(anim.track_get_path(t).get_concatenated_subnames()))
		if b < 0:
			continue
		if anim.track_get_type(t) == Animation.TYPE_ROTATION_3D:
			rot[b] = t
		elif anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
			pos[b] = t
	var chains: Array = []
	for toe in ["LeftToes", "RightToes"]:
		var chain: Array = []
		var w := skel.find_bone(toe)
		while w >= 0:
			chain.push_front(w)
			w = skel.get_bone_parent(w)
		chains.append(chain)
	var out := PackedVector3Array()
	for f in int(anim.length * FPS) + 1:
		var at := minf(f / FPS, anim.length)
		for chain in chains:
			var g := Transform3D.IDENTITY
			for bi in chain:
				var rest := skel.get_bone_rest(bi)
				var basis: Basis = Basis(anim.rotation_track_interpolate(rot[bi], at)) if rot.has(bi) else rest.basis
				var origin: Vector3 = anim.position_track_interpolate(pos[bi], at) if pos.has(bi) else rest.origin
				g = g * Transform3D(basis, origin)
			out.append(g.origin)
	if not _feet.has(sid):
		_feet[sid] = {}
	_feet[sid][clip] = out
	return out


static func capture(stage: Node, who: int) -> void:
	var bx: Dictionary = stage.boxers[who]
	var skel: Skeleton3D = bx["skel"]
	var xf := skel.global_transform
	bx["rk_feet_before"] = [xf * skel.get_bone_global_pose(skel.find_bone("LeftToes")).origin,
		xf * skel.get_bone_global_pose(skel.find_bone("RightToes")).origin]


static func align(stage: Node, who: int) -> void:
	var bx: Dictionary = stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	var clip := str(ap.current_animation)
	if not RkClips.is_rk(clip) or bool(stage.get("scene")) or OS.get_cmdline_user_args().has("nojoinalign"):
		return
	var skel: Skeleton3D = bx["skel"]
	var table := feet(skel, ap, clip)
	var f := clampi(int(round(ap.current_animation_position * FPS)), 0, table.size() / 2 - 1)
	var xf := skel.global_transform
	var shift := Vector3.ZERO
	var wsum := 0.0
	var now: Array = bx.get("rk_feet_before", [])
	bx["rk_feet_before"] = []
	if now.size() != 2:
		return
	var low := minf((now[0] as Vector3).y, (now[1] as Vector3).y)
	for i in 2:
		var cur: Vector3 = now[i]
		var new: Vector3 = xf * table[f * 2 + i]
		var w := 1.0 / (0.02 + maxf((cur.y - low), 0.0))   # the planted (lower) foot anchors
		shift += (cur - new) * w
		wsum += w
	shift /= wsum
	shift.y = 0.0
	# her balls stay on these spots through the blend (RkJoinFeet) - not into a step clip: its own first step lifts them
	if bx.get("joinfeet") != null:
		# only into her GUARD: a step clip lifts the feet itself, and a punch plays its own feet (the cross's rear pivot)
		if clip in RkClips.guards():
			(bx["joinfeet"] as Node).arm(now)
		else:
			(bx["joinfeet"] as Node).release()
	if shift.length() > MAX_SHIFT_M or shift.length() < 0.005:
		return
	if bx.get("js") != null:
		(bx["js"] as Node).carry(skel.global_transform)
	bx["pos"] = (bx["pos"] as Vector3) + shift
