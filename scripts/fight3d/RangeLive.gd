extends RefCounted
## POWER1 step 4, review round 1 (blind review: "straights are not thrown from their own distance in the played fight";
## tests/punch_range_test.gd now reads the bodies AS DRAWN, after every modifier). RangeTable works each punch's distance
## out from the bare clip: her shoulder at the clip's contact and the other's face in the clip's guard. As drawn they stand
## elsewhere (probe lines in the ruler, seed 4242): the stack's posture (GuardTuck, FighterLife's lean, GloveClear's head
## lean, the sway) puts the other's face 0.17-0.34 m in front of her body against the clip's 0.14, and her shoulder at the hit
## sits ahead of the clip's on a straight and behind it on a hook. So a straight thrown from the table's 0.93 m landed with
## the elbow at 54-109 deg. This reads the drawn bodies (Skeleton3D.skeleton_updated, after the stack) and keeps, eased:
##   face      how far each one's face stands in front of the clip's guard face, while she stands in an idle (every frame);
##   shoulder  per punch kind, how far her shoulder on a landed punch's hit frame (before the reach leans her) stands in
##             front of the clip's, her body's carry (PunchWeight) counted in (each hit; HIT_EASE).
## RangeTable adds those to every distance it hands out. It also keeps each body's drawn head and lead toes (UpperRoom).
## Measured live, not typed: until a sample comes in, the bare table. `-- nopunchrange` = off (RangeTable.on).
##   attach(st)   off(st, who, side, kind) -> metres (add to a distance thrown by `who`)

const EASE := 0.05
const HIT_EASE := 0.3
const IDLE_WORDS := ["idle"]


static func attach(st: Node) -> void:
	for i in st.boxers.size():
		var bx: Dictionary = st.boxers[i]
		bx["live"] = {"shoulder": {}, "face": 0.0, "n": 0, "hits": 0, "last_f": -1}
		var skel: Skeleton3D = bx["skel"]
		var who: int = i
		skel.skeleton_updated.connect(func() -> void: drawn(st, who))


## How much further apart the pair must stand for `who`'s punch of `kind` (RangeTable.kind) than the clip says.
static func off(st: Node, who: int, kind: String) -> float:
	var me: Dictionary = st.boxers[who].get("live", {})
	var other: Dictionary = st.boxers[1 - who].get("live", {})
	if me.is_empty() or other.is_empty():
		return 0.0
	return float((me["shoulder"] as Dictionary).get(kind, 0.0)) + float(other["face"])


## Boxer i as drawn this frame (her skeleton_updated).
static func drawn(st: Node, i: int) -> void:
	var bx: Dictionary = st.boxers[i]
	var skel: Skeleton3D = bx["skel"]
	var node: Node3D = bx["node"]
	if skel == null or node == null or not node.is_inside_tree():
		return
	var f := Engine.get_process_frames()
	var lead := str(st.hand_of(i, "LeftHand")).trim_suffix("Hand")
	bx["drawn"] = {"head": _bone(skel, "Head"), "lead_toes": _bone(skel, lead + "Toes"), "f": f}
	var guard: Dictionary = bx.get("guard_parts", {})
	if guard.is_empty():
		return
	var o := node.global_position
	var fwd := node.global_transform.basis.z.normalized()
	var live: Dictionary = bx["live"]
	if _idle(str((bx["ap"] as AnimationPlayer).current_animation)):
		var face: float = (st.target_point(i, false) - o).dot(fwd) - float(guard["face"])
		live["face"] = lerpf(float(live["face"]), face, EASE)
		live["n"] = int(live["n"]) + 1
	var pr: Node = bx.get("reach")
	if pr == null or int(live["last_f"]) == f or int(pr.get("_hit_f")) != f or not (pr.get("hit_s") as Vector3).is_finite():
		return
	var clip := str(pr.get("_clip"))
	var parts: Dictionary = (bx.get("range_parts", {}) as Dictionary).get(clip, {})
	if parts.is_empty():
		return
	live["last_f"] = f
	var pw: Node = bx.get("weight")
	var s_fwd := ((pr.get("hit_s") as Vector3) - o).dot(fwd) + (float(pw.get("carry_now")) if pw != null else 0.0)
	var kind := RangeTable_kind(clip)
	var sh: Dictionary = live["shoulder"]
	var was := float(sh.get(kind, 0.0))
	sh[kind] = lerpf(was, s_fwd - float(parts["s_fwd"]), HIT_EASE)
	live["hits"] = int(live["hits"]) + 1


## RangeTable.kind (not preloaded here: RangeTable preloads this file).
static func RangeTable_kind(clip: String) -> String:
	if clip.contains("uppercut"):
		return "uppercut"
	if clip.contains("body") or clip.contains("kidney"):
		return "body"
	if clip.contains("hook"):
		return "hook"
	return "straight" if clip.contains("jab") or clip.contains("cross") else "body"


static func _idle(clip: String) -> bool:
	for w in IDLE_WORDS:
		if clip.contains(w):
			return true
	return false


static func _bone(skel: Skeleton3D, name: String) -> Vector3:
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(name)).origin
