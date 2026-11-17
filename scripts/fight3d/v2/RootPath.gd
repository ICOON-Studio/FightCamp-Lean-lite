extends RefCounted
## FIGHTPLAYER2 phase 3 (S512, scope 3b step 3): a take's own hip travel, played on the BODY. FightClips.hold_root_xz
## pins every punch, reaction and defence on the spot and (since S512) keeps what it took away beside the clip
## (FightClips.ROOT_PATH_META). The v2 player moves the boxer's body along that path while the take plays: the take
## travels as bought (a jab's 12 cm, a gut-shot stagger's 50 cm, a slip's 60 cm) with its own feet under it, and when
## the take is cut the boxer stays where it left him - the hit man has really given ground. Pure: no scene access
## except `place`, which only sets the node it is handed. The shipped player never calls this.

const FightClips := preload("res://scripts/fight3d/FightClips.gd")


## The path kept beside `anim` (PackedVector3Array of (dx, time, dz)); empty when the clip was never pinned.
static func of(anim: Animation) -> PackedVector3Array:
	if anim == null or not anim.has_meta(FightClips.ROOT_PATH_META):
		return PackedVector3Array()
	return anim.get_meta(FightClips.ROOT_PATH_META)


## The hips' travel (x, z) from the take's first key at clip time `t`, in the Hips' parent space (linear between keys,
## held past the ends).
static func at(path: PackedVector3Array, t: float) -> Vector2:
	var n := path.size()
	if n == 0:
		return Vector2.ZERO
	if t <= path[0].y:
		return Vector2(path[0].x, path[0].z)
	if t >= path[n - 1].y:
		return Vector2(path[n - 1].x, path[n - 1].z)
	var lo := 0
	var hi := n - 1
	while hi - lo > 1:
		var mid := (lo + hi) / 2
		if path[mid].y <= t:
			lo = mid
		else:
			hi = mid
	var span := path[hi].y - path[lo].y
	var w := 0.0 if span <= 0.0 else (t - path[lo].y) / span
	return Vector2(lerpf(path[lo].x, path[hi].x, w), lerpf(path[lo].z, path[hi].z, w))


## The furthest the take carries the hips from its first key (m), and how far from it the take ends.
static func reach(path: PackedVector3Array) -> Vector2:
	var most := 0.0
	for p in path:
		most = maxf(most, Vector2(p.x, p.z).length())
	var n := path.size()
	return Vector2(most, 0.0 if n == 0 else Vector2(path[n - 1].x, path[n - 1].z).length())


## The world offset of travel `xz` for a skeleton whose global basis is `skel_basis` (the Hips' parent space is the
## skeleton's own for our bodies: Hips hang off the root at the origin).
static func world(skel_basis: Basis, xz: Vector2) -> Vector3:
	var v := skel_basis * Vector3(xz.x, 0.0, xz.y)
	return Vector3(v.x, 0.0, v.z)


## Puts `body` where the take has carried it: `origin` (where the body stood when the take started, world) plus the
## take's travel from `from_s` (where the take was started) to `t`.
static func place(body: Node3D, skel: Skeleton3D, path: PackedVector3Array, origin: Vector3, from_s: float, t: float) -> void:
	if path.is_empty():
		return
	var d := at(path, t) - at(path, from_s)
	var off := world(skel.global_transform.basis, d)
	body.global_position = Vector3(origin.x + off.x, body.global_position.y, origin.z + off.z)
