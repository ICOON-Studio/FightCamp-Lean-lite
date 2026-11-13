extends RefCounted
## POWER1 step 4 (b). The floors that keep the two bodies out of each other - RingPlace.MIN_GAP_M / INSIDE_FLOOR_M 0.84
## (where they stand), RingPlace.BODY_KEEP_M 0.82 (the bodies as shown), PunchRange.HOOK_FLOOR_M 0.86 (a punch's step in) -
## were set after "they walk through each other" (HUMANFIGHT1). An uppercut is thrown from 0.70-0.74 m (RangeTable.UPPER_M;
## UPPERCUT_RANGE_S439.md measured the bodies there: heads 0.70-0.74 m apart, lead toes 0.26-0.37 m). While the footwork
## wants an uppercut's distance, the floors come down to FLOOR_M, guarded every frame by the bodies as shown: the heads at
## least HEADS_M apart and the lead toes at least TOES_M short of crossing on the line between them. When the guard fails,
## or no uppercut is wanted, the floor goes back up. The floor moves at EASE_MPS, so no body is shoved in one frame.
##   tick(st, delta, base) (RingPlace.compose once a frame; base = the place floor as it was)
##   floor_m(st, base) -> metres   keep_m(st, base) -> metres

const RangeTable := preload("res://scripts/fight3d/RangeTable.gd")

const FLOOR_M := 0.70
const HEADS_M := 0.50     # the ruler's bar is 0.45 (tests/punch_range_test.gd): this keeps a margin over it
const TOES_M := 0.05
const EASE_MPS := 0.8
## The shown bodies keep this much less than the place floor (as BODY_KEEP_M 0.82 sits under 0.84).
const SHOWN_UNDER_M := 0.02


static func tick(st: Node, delta: float, base: float) -> void:
	RangeTable.relunge(st)   # review round 1 (not about the floor: this is the once-a-frame hook step 4 has)
	var now := float(st.get_meta("upper_floor", base))
	# Back up only as the bodies step apart (the footwork's step out), never by shoving them.
	# S445 (blind read: the floor stayed down after the uppercut, lead toes crossed at 0.707 m in a rest phase): with no
	# uppercut wanted, or crowded, the floor eases back up at EASE_MPS whether or not the bodies have stepped apart.
	var want := base
	if RangeTable.on and float(st.feet.want_m) < base - 0.01 and str(st.feet.phase()) != "clinch":
		want = maxf(FLOOR_M, float(st.feet.want_m) - 0.02)
		var why := _crowded(st)
		if why != "":
			want = base
			st.set_meta("upper_guard", why)
	st.set_meta("upper_floor", move_toward(now, want, EASE_MPS * maxf(delta, 0.0)) if delta > 0.0 else want)


## The place floor now: `base` (the floors as they were) or lower while an uppercut's distance is wanted.
static func floor_m(st: Node, base: float) -> float:
	return minf(base, float(st.get_meta("upper_floor", base))) if RangeTable.on else base


## The shown-body keep now (RingPlace.BODY_KEEP_M as `base`).
static func keep_m(st: Node, base: float) -> float:
	return minf(base, float(st.get_meta("upper_floor", 9.0)) - SHOWN_UNDER_M) if RangeTable.on else base


## "" when the bodies as shown leave room; else what is too close.
## Review round 1: read as DRAWN (RangeLive keeps each body's head and lead toes from its skeleton_updated); from here, in
## the frame's process, the skeleton gives the clip's pose without the stack (the head clearance, the weight, the reach).
static func _crowded(st: Node) -> String:
	var hd := _drawn(st, 0, "head").distance_to(_drawn(st, 1, "head"))
	if hd < HEADS_M:
		return "heads %.2f m" % hd
	var p0: Vector3 = st.boxers[0]["pos"]
	var p1: Vector3 = st.boxers[1]["pos"]
	var axis := Vector3(p1.x - p0.x, 0.0, p1.z - p0.z)
	if axis.length() < 0.01:
		return "on top of each other"
	axis = axis.normalized()
	var t0 := (_drawn(st, 0, "lead_toes") - p0).dot(axis)
	var t1 := (_drawn(st, 1, "lead_toes") - p0).dot(axis)
	return "lead toes %.2f m" % (t1 - t0) if t1 - t0 < TOES_M else ""


static func _drawn(st: Node, i: int, key: String) -> Vector3:
	var d: Dictionary = st.boxers[i].get("drawn", {})
	if d.has(key):
		return d[key]
	var skel: Skeleton3D = st.boxers[i]["skel"]
	var name := "Head" if key == "head" else str(st.hand_of(i, "LeftHand")).trim_suffix("Hand") + "Toes"
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(name)).origin
