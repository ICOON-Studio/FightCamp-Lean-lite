extends RefCounted
class_name SessionPicPoses
## TRAINCLIPS1 r5 - which clip, which moment, and from where, for each of her eight training cards.
## Every pose is a frame of a clip that is already in assets/anim/baked (or a native MetaHuman punch); the contact times
## are the project's own (assets/data/clip_contact.json, measured by tools/clip_contact.gd), never a hand-set bone angle.

const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")

const CONTACT_PATH := "res://assets/data/clip_contact.json"
## The camera each session is shot from: az 0 = face on, -90 = her right side (the punch then runs to the right of the
## card), elev degrees above her middle, size = the first guess as a multiple of her bone height (the driver measures the
## rendered bounds and corrects it).
const SPEC := {
	"shadow": {"clip": "pro_left_jab", "hand": "LeftHand", "az": -70.0, "elev": 8.0, "size": 1.05},
	"heavy_bag": {"clip": "pro_right_cross", "hand": "RightHand", "az": -78.0, "elev": 8.0, "size": 1.10},
	"sparring": {"clip": "pro_block_loop", "hand": "LeftHand", "az": -52.0, "elev": 6.0, "size": 1.05},
	"slip_rope": {"clip": "slip", "hand": "LeftHand", "az": -22.0, "elev": 5.0, "size": 1.05},
	"pads": {"clip": "pro_left_hook", "hand": "LeftHand", "az": -55.0, "elev": 7.0, "size": 1.05},
	"speed_bag": {"clip": "pro_left_jab", "hand": "LeftHand", "az": -72.0, "elev": 8.0, "size": 1.05},
	"roadwork": {"clip": "advance", "hand": "LeftFoot", "az": -90.0, "elev": 6.0, "size": 1.05},
	"neck": {"clip": "pro_idle", "hand": "LeftHand", "az": -52.0, "elev": 6.0, "size": 1.05},
}
## The sessions the brief gives a start and a finish: guard -> reach, upright -> under the rope, stride -> stride.
const DUAL := ["shadow", "heavy_bag", "pads", "speed_bag", "slip_rope", "roadwork"]
## The clips that are a stand-in for a session the library has no take of.
const STAND_IN := {"roadwork": "jog: loc_advance", "neck": "chin tuck: mc_Box1_M3_Idle's most tucked frame"}

const RATE := 60.0
const SPEED_CLEAR := 0.06     # m the fist must have left the guard by for the speed bag's first contact
const DUCK_LATERAL := 0.5     # weight of a slip's sideways evasion against its head drop

static var _contact: Dictionary = {}


static func is_dual(id: String) -> bool:
	return id in DUAL


static func spec(id: String) -> Dictionary:
	return SPEC.get(id, SPEC["shadow"])


## The finished pose of a session: the clip sampled at the named moment.
static func finish(id: String, bx: Dictionary) -> Dictionary:
	var s: Dictionary = spec(id)
	var clip := str(s["clip"])
	var hand := str(s["hand"])
	var t := 0.0
	match id:
		"shadow", "heavy_bag", "pads":
			t = contact_s(clip)
			if t < 0.0:
				t = _max_reach(bx, clip, hand)
		"speed_bag":
			t = _short_punch(bx, clip, hand)
		"slip_rope":
			t = _deepest(bx, clip)
		"roadwork":
			t = float(roadwork_pair(bx)["end_t"])
		"sparring":
			t = _tight_guard(bx, clip)
		"neck":
			t = _chin_tucked(bx, clip)
	return {"clip": clip, "t": t, "hand": hand}


## The faint figure behind: the guard the move starts from, the upright of the slip, the other stride.
static func start_pose(id: String, bx: Dictionary, finish_pose: Dictionary) -> Dictionary:
	var clip := str(finish_pose["clip"])
	var hand := str(finish_pose["hand"])
	match id:
		"shadow", "heavy_bag", "pads", "speed_bag":
			# The clip opens in the guard: that is the "from" of guard -> reach.
			return {"clip": clip, "t": 0.0, "hand": hand}
		"slip_rope":
			return {"clip": clip, "t": _upright(bx, clip), "hand": hand}
		"roadwork":
			var pair := roadwork_pair(bx)
			return {"clip": clip, "t": float(pair["start_t"]), "hand": hand}
	return {}


## The two ends of the arrow: the glove on both figures, her head for the slip, her foot for the run.
static func arrow_bones(id: String, finish_pose: Dictionary) -> Dictionary:
	match id:
		"slip_rope":
			return {"from": "Head", "to": "Head"}
		"roadwork":
			return {"from": "LeftFoot", "to": "LeftFoot"}
	return {"from": str(finish_pose["hand"]), "to": str(finish_pose["hand"])}


## The recorded contact of a clip (seconds into it), or -1 when the project has not measured this one.
static func contact_s(clip: String) -> float:
	if _contact.is_empty():
		var f := FileAccess.open(CONTACT_PATH, FileAccess.READ)
		if f != null:
			var d: Variant = JSON.parse_string(f.get_as_text())
			if d is Dictionary:
				_contact = d
	return float((_contact.get(clip, {}) as Dictionary).get("contact_s", -1.0))


## The two stride extremes of the run, and where they are: left foot forward is the start, right foot forward the finish.
static func roadwork_pair(bx: Dictionary) -> Dictionary:
	var clip := "advance"
	var length := _length(bx, clip)
	var left_t := 0.0
	var right_t := length * 0.5
	var best_l := -INF
	var best_r := INF
	var t := 0.0
	while t <= length + 0.0001:
		var lf := IdleMatch.pose_point(bx, clip, t, "LeftFoot")
		var rf := IdleMatch.pose_point(bx, clip, t, "RightFoot")
		if lf.z - rf.z > best_l:
			best_l = lf.z - rf.z
			left_t = t
		if lf.z - rf.z < best_r:
			best_r = lf.z - rf.z
			right_t = t
		t += 1.0 / RATE
	return {"clip": clip, "start_t": left_t, "end_t": right_t, "left": best_l, "right": best_r}


static func _length(bx: Dictionary, clip: String) -> float:
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(clip):
		return 0.0
	return ap.get_animation(clip).length


## A short punch: among the frames up to the jab's own contact, the one where her fist is still highest once it has left
## the guard by SPEED_CLEAR - a speed bag is tapped with the hands up, not thrown away. The bag is hung where that fist is.
static func _short_punch(bx: Dictionary, clip: String, hand: String) -> float:
	var guard := IdleMatch.pose_point(bx, clip, 0.0, hand)
	var hit := contact_s(clip)
	var length := hit if hit > 0.0 else _length(bx, clip)
	var best := -1.0
	var best_y := -INF
	var t := 0.0
	while t <= length + 0.0001:
		var g := IdleMatch.pose_point(bx, clip, t, hand)
		if g.z - guard.z >= SPEED_CLEAR:
			if g.y > best_y:
				best_y = g.y
				best = t
		t += 1.0 / RATE
	if best < 0.0:
		return 0.0
	return best


## The deepest moment of a slip: the head furthest below its own upright line and furthest off it sideways.
static func _deepest(bx: Dictionary, clip: String) -> float:
	var upright := _upright(bx, clip)
	var ref := IdleMatch.pose_point(bx, clip, upright, "Head")
	var length := _length(bx, clip)
	var best_t := 0.0
	var best := -INF
	var t := 0.0
	while t <= length + 0.0001:
		var head := IdleMatch.pose_point(bx, clip, t, "Head")
		var hips := IdleMatch.pose_point(bx, clip, t, "Hips")
		var score := (ref.y - head.y) + DUCK_LATERAL * absf(head.x - hips.x)
		if score > best:
			best = score
			best_t = t
		t += 1.0 / RATE
	return best_t


## The most upright frame of the slip: the head nearest straight over her hips.
static func _upright(bx: Dictionary, clip: String) -> float:
	var length := _length(bx, clip)
	var best_t := 0.0
	var best := INF
	var t := 0.0
	while t <= length + 0.0001:
		var head := IdleMatch.pose_point(bx, clip, t, "Head")
		var hips := IdleMatch.pose_point(bx, clip, t, "Hips")
		var score := Vector2(head.x - hips.x, head.z - hips.z).length()
		if score < best:
			best = score
			best_t = t
		t += 1.0 / RATE
	return best_t


## The tightest frame of the guard loop: both gloves closest to her head.
static func _tight_guard(bx: Dictionary, clip: String) -> float:
	var length := _length(bx, clip)
	var best_t := 0.0
	var best := INF
	var t := 0.0
	while t <= length + 0.0001:
		var head := IdleMatch.pose_point(bx, clip, t, "Head") + Vector3(0.0, 0.10, 0.0)
		var score := head.distance_to(IdleMatch.pose_point(bx, clip, t, "LeftHand"))
		score += head.distance_to(IdleMatch.pose_point(bx, clip, t, "RightHand"))
		if score < best:
			best = score
			best_t = t
		t += 1.0 / RATE
	return best_t


## The idle's most chin-tucked frame, read off her own eye line: the face pointing most downward, head lowest.
static func _chin_tucked(bx: Dictionary, clip: String) -> float:
	var length := _length(bx, clip)
	var skel: Skeleton3D = bx["skel"]
	var eyes := [skel.find_bone("LeftEye"), skel.find_bone("RightEye")]
	var best_t := 0.0
	var best := -INF
	var t := 0.0
	while t <= length + 0.0001:
		var head := IdleMatch.pose_point(bx, clip, t, "Head")
		var face := Vector3(0.0, 0.0, 1.0)
		if eyes[0] >= 0 and eyes[1] >= 0:
			var l := IdleMatch.pose_point(bx, clip, t, "LeftEye")
			var r := IdleMatch.pose_point(bx, clip, t, "RightEye")
			face = ((l + r) * 0.5 - head).normalized()
		var score := -face.y * 2.0 - head.y
		if score > best:
			best = score
			best_t = t
		t += 1.0 / RATE
	return best_t


## The furthest her hand gets from its own shoulder: the fallback contact for a clip the project has not measured.
static func _max_reach(bx: Dictionary, clip: String, hand: String) -> float:
	var side := "Left" if hand.begins_with("Left") else "Right"
	var length := _length(bx, clip)
	var best_t := 0.0
	var best := -INF
	var t := 0.0
	while t <= length + 0.0001:
		var score := IdleMatch.pose_point(bx, clip, t, hand).distance_to(
			IdleMatch.pose_point(bx, clip, t, side + "UpperArm"))
		if score > best:
			best = score
			best_t = t
		t += 1.0 / RATE
	return best_t