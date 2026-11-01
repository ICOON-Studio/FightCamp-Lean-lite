extends RefCounted
## Where each boxer stands for a ring card (StrikeMap position). Pure geometry on the canvas; FightStage walks them there.

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const RingPlace := preload("res://scripts/fight3d/RingPlace.gd")

const ROPE_LEAN_M := RingPlace.ROPE_LEAN_M


static func target(card: String, a: Vector3, b: Vector3, ring_m: float) -> Dictionary:
	if card in ["clinch", ""] or StrikeMap.card(card).is_empty():
		return {}
	if card in ["outside", "long", "mid", "inside"]:
		return {"a": a, "b": b, "gap": _gap(card)}
	if card == "own_ropes":
		return _ropes(a, b, ring_m, true)
	if card == "opp_ropes":
		return _ropes(a, b, ring_m, false)
	if card == "corner":
		return _corner(a, b, ring_m)
	return {}


static func _gap(card: String) -> float:
	if card == "outside":
		return 1.6
	var r: Array = StrikeMap.card(card).get("range_m", [])
	return (float(r[0]) + float(r[1])) * 0.5


static func _half(ring_m: float) -> float:
	return ring_m * 0.5


static func _rope_pos(p: Vector3, half: float) -> Vector3:
	var edge := half - ROPE_LEAN_M
	var side := _nearest_rope_side(p, half)
	var out := Vector3(p.x, p.y, p.z)
	if side.x != 0.0:
		out.x = side.x * edge
	elif side.z != 0.0:
		out.z = side.z * edge
	return out


static func _nearest_rope_side(p: Vector3, half: float) -> Vector3:
	var dx := half - absf(p.x)
	var dz := half - absf(p.z)
	if dx <= dz:
		return Vector3(1.0 if p.x >= 0.0 else -1.0, 0.0, 0.0)
	return Vector3(0.0, 0.0, 1.0 if p.z >= 0.0 else -1.0)


static func _ropes(a: Vector3, b: Vector3, ring_m: float, a_trapped: bool) -> Dictionary:
	var half := _half(ring_m)
	var gap := _gap("mid")
	var trapped := a if a_trapped else b
	var presser := b if a_trapped else a
	var nt := _rope_pos(trapped, half)
	var to_c := Vector3(-nt.x, 0.0, -nt.z)
	if to_c.length() < 0.01:
		to_c = Vector3(-1.0, 0.0, 0.0)
	to_c = to_c.normalized()
	var np := nt + to_c * gap
	var na := nt if a_trapped else np
	var nb := np if a_trapped else nt
	return {"a": na, "b": nb, "gap": gap}


static func _corner(a: Vector3, b: Vector3, ring_m: float) -> Dictionary:
	var half := _half(ring_m)
	var edge := half - ROPE_LEAN_M
	var gap := _gap("mid")
	var corners: Array = [
		Vector3(edge, 0.0, edge), Vector3(edge, 0.0, -edge),
		Vector3(-edge, 0.0, edge), Vector3(-edge, 0.0, -edge),
	]
	var best: Vector3 = corners[0]
	var best_d := (b - best).length_squared()
	for c in corners:
		var d: float = (b - c).length_squared()
		if d < best_d:
			best_d = d
			best = c
	var nb := best
	var to_c := Vector3(-nb.x, 0.0, -nb.z).normalized()
	var na := nb + to_c * gap
	return {"a": na, "b": nb, "gap": gap}
