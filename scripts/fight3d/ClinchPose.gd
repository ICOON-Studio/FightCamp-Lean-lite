extends RefCounted
## SPLIT471: the clinch pose math split out of Clinch.gd (it had reached the 500-line cap).
## Every function here is static: bone lookups, IK target positions for the overhook, blade, flank, elbow, past-shoulder,
## grip and dig points. They take the stage (for boxer bone positions) and the constants they need; no member state.

## Where the hands go, metres: over the shoulder blade (behind and below the shoulder joint), and on the flank.
const BACK_M := 0.13
const BLADE_DOWN_M := 0.06
const FLANK_M := 0.14
## S316 the overhook: the holder's wrist this far outside, behind and above the other's elbow.
const OVERHOOK_OUT_M := 0.07
const OVERHOOK_BACK_M := 0.06
const OVERHOOK_UP_M := 0.08
## S318 the held boxer's grip in the paired clinch: her glove on the outside of the holder's elbow, a little under it.
const ELBOW_OUT_M := 0.06
const ELBOW_DOWN_M := 0.03


## A boxer's bone origin (world), or the node's global position when the skeleton has no such bone.
static func bone(stg: Node, i: int, bone_name: String) -> Vector3:
	var skel: Skeleton3D = stg.boxers[i]["skel"]
	var id := skel.find_bone(bone_name)
	return skel.global_transform * skel.get_bone_global_pose(id).origin if id >= 0 else (stg.boxers[i]["node"] as Node3D).global_position


## The body's forward direction (world Z, normalised).
static func fwd(stg: Node, i: int) -> Vector3:
	return (stg.boxers[i]["node"] as Node3D).global_transform.basis.z.normalized()


## The clip's "left" hand as she plays it: the right one for a southpaw (mirrored clips).
static func lead(stg: Node, i: int) -> String:
	return "Right" if bool(stg.boxers[i].get("south", false)) else "Left"


## Facing each other, her `side` meets the other's opposite side.
static func other_side(side: String) -> String:
	return "Right" if side == "Left" else "Left"


## Over the other's arm just above her elbow on her `side`, from outside and a little behind: the holder's forearm pins it.
static func overhook(stg: Node, i: int, side: String) -> Vector3:
	var left := Vector3.UP.cross(fwd(stg, i)).normalized()
	var out := left if side == "Left" else -left
	return bone(stg, i, side + "LowerArm") + out * OVERHOOK_OUT_M - fwd(stg, i) * OVERHOOK_BACK_M + Vector3.UP * OVERHOOK_UP_M


## On the outside of the other's elbow on her `side`, a little under it.
static func elbow(stg: Node, i: int, side: String) -> Vector3:
	var left := Vector3.UP.cross(fwd(stg, i)).normalized()
	var out := left if side == "Left" else -left
	return bone(stg, i, side + "LowerArm") + out * ELBOW_OUT_M + Vector3.DOWN * ELBOW_DOWN_M


## Over the other's shoulder blade on her `side`.
static func blade(stg: Node, i: int, side: String) -> Vector3:
	return bone(stg, i, side + "UpperArm") - fwd(stg, i) * BACK_M - Vector3.UP * BLADE_DOWN_M


## On the other's flank: `sgn` -1 her right side, +1 her left (her own frame), a little behind the ribs.
static func flank(stg: Node, i: int, sgn: float) -> Vector3:
	var left := Vector3.UP.cross(fwd(stg, i)).normalized()
	return bone(stg, i, "Spine") + left * FLANK_M * sgn - fwd(stg, i) * 0.04 + Vector3.UP * 0.08


## Past the other's shoulder (her own right of the other's head: the heads sit side by side).
static func past(stg: Node, i: int) -> Vector3:
	var left := Vector3.UP.cross(fwd(stg, i)).normalized()
	return bone(stg, i, "Head") - left * 0.35 - fwd(stg, i) * 0.3 - Vector3.UP * 0.15


## The other's rib side: from the lower ribs (Spine + 0.08 m, spine_02) up to the same offset from Chest (spine_03).
static func rib_band(stg: Node, other: int, side: String) -> Array:
	var left := Vector3.UP.cross(fwd(stg, other)).normalized()
	var out := left * (1.0 if side == "Right" else -1.0)
	var lo := bone(stg, other, "Spine") + out * FLANK_M - fwd(stg, other) * 0.04 + Vector3.UP * 0.08
	return [lo, lo + (bone(stg, other, "Chest") - bone(stg, other, "Spine"))]


## The other's ribs on the side the grip hand meets, at the top of the band (spine_03).
static func grip(stg: Node, i: int, side: String) -> Vector3:
	return rib_band(stg, i, side)[1]


## Closest point on a line segment (band[0]..band[1]) to `p`.
static func closest(p: Vector3, band: Array) -> Vector3:
	var a: Vector3 = band[0]
	var ab: Vector3 = (band[1] as Vector3) - a
	if ab.length() < 1e-6:
		return a
	return a + ab * clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)


static func smooth(u: float) -> float:
	return u * u * (3.0 - 2.0 * u)
