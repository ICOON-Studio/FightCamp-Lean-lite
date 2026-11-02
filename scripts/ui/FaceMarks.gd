extends RefCounted
## S354 C202 (operator on the HEAD close-up of her face in the fight panel: "you nailed it here, and you can show the cuts if
## any here on her small real face"): the body map's damage drawn ON her headshot - a cut over the eye or on the nose
## bridge, a swollen eye (puffy, darker the worse it is), a closed eye as a slit, a hurt nose reddened.
##   marks(vals, side) -> [{kind: cut|swell|shut|nose, place, at: Vector2 (in close-up radii), k: 0..1}]
##   paint(canvas, centre, radius, vals, side)
## vals = {place: 0..100}; side = BodyMap's per-boxer dict ({"cuts": {place: true}, "closed": {place: true}}).

const BodyMap := preload("res://scripts/rules/BodyMap.gd")

## Where her features sit in the close-up (units of its radius from its centre, +x right, +y down), measured on the baked
## headshots (tools/bake_headshots.gd frames every boxer the same, 3/4 view turned to the viewer's right; BodyCallouts
## FACE_UV crops them). Front view: her LEFT eye is on the viewer's right.
const AT := {"right_eye": Vector2(0.30, -0.02), "left_eye": Vector2(0.74, -0.10), "nose": Vector2(0.62, 0.28)}
## A cut sits on the brow, just above the eye.
const BROW := Vector2(-0.02, -0.15)
const BLOOD := Color(0.72, 0.04, 0.04)
const SWELL := Color(0.45, 0.12, 0.30)


static func marks(vals: Dictionary, side: Dictionary) -> Array:
	var out: Array = []
	var cuts: Dictionary = side.get("cuts", {})
	var closed: Dictionary = side.get("closed", {})
	for place in ["right_eye", "left_eye"]:
		var v := float(vals.get(place, 100.0))
		if bool(closed.get(place, false)):
			out.append({"kind": "shut", "place": place, "at": AT[place], "k": 1.0})
		elif v <= BodyMap.HURT:
			out.append({"kind": "swell", "place": place, "at": AT[place], "k": clampf((BodyMap.HURT - v) / BodyMap.HURT + 0.35, 0.35, 1.0)})
		if bool(cuts.get(place, false)):
			out.append({"kind": "cut", "place": place, "at": AT[place] + BROW, "k": 1.0})
	var nv := float(vals.get("nose", 100.0))
	if nv <= BodyMap.HURT:
		out.append({"kind": "nose", "place": "nose", "at": AT["nose"], "k": clampf((BodyMap.HURT - nv) / BodyMap.HURT + 0.35, 0.35, 1.0)})
	if bool(cuts.get("nose", false)):
		out.append({"kind": "cut", "place": "nose", "at": AT["nose"] + Vector2(-0.06, -0.16), "k": 1.0})
	return out


static func paint(cv: CanvasItem, c: Vector2, r: float, vals: Dictionary, side: Dictionary) -> void:
	for m in marks(vals, side):
		var p: Vector2 = c + (m["at"] as Vector2) * r
		var k := float(m["k"])
		match str(m["kind"]):
			"swell":
				# Soft-edged: three rings, faint outside, dark at the lid.
				cv.draw_set_transform(p, 0.0, Vector2(1.0, 0.62))
				for ring in [[0.21, 0.30], [0.16, 0.55], [0.10, 0.85]]:
					cv.draw_circle(Vector2.ZERO, r * float(ring[0]), Color(SWELL, (0.18 + 0.32 * k) * float(ring[1])))
				cv.draw_set_transform(Vector2.ZERO)
			"shut":
				cv.draw_set_transform(p, 0.0, Vector2(1.0, 0.62))
				cv.draw_circle(Vector2.ZERO, r * 0.19, Color(SWELL, 0.85))
				cv.draw_set_transform(Vector2.ZERO)
				cv.draw_line(p - Vector2(r * 0.13, 0.0), p + Vector2(r * 0.13, 0.0), Color(0.05, 0.0, 0.02, 0.95), 1.6, true)
			"nose":
				cv.draw_circle(p, r * 0.12, Color(BLOOD, 0.25 + 0.4 * k))
			"cut":
				# A short jagged gash with a drip of blood under it, outlined dark so it reads at 30 px.
				var pts := PackedVector2Array([p + Vector2(-0.11, 0.02) * r, p + Vector2(-0.04, -0.03) * r,
					p + Vector2(0.02, 0.02) * r, p + Vector2(0.10, -0.02) * r])
				cv.draw_polyline(pts, Color(0.1, 0.0, 0.0, 0.8), 2.8, true)
				cv.draw_polyline(pts, BLOOD.lightened(0.15), 1.5, true)
				cv.draw_line(p + Vector2(-0.01, 0.01) * r, p + Vector2(0.0, 0.16) * r, Color(BLOOD, 0.85), 1.4, true)
