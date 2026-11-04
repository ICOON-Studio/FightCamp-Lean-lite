extends RefCounted
## MOVEPICS1 (S381) - the move cards' gold arrow along a sampled path in card pixels (SessionPicCard's stroke and head),
## split out of tools/bake_move_pics.gd at r2 (that file had passed the 500-line rule).
##   draw(img, pts) -> px drawn   on_card(pts) -> the stretch on the card   length(pts) -> px

const SPS := preload("res://tools/session_pic_style.gd")
const SPC := preload("res://tools/session_pic_card.gd")


static func length(pts: Array) -> float:
	var n := 0.0
	for i in range(1, pts.size()):
		n += (pts[i] as Vector2).distance_to(pts[i - 1])
	return n


## The stretch of a path that is on the card: a path that starts off the frame (a BJJ limb swung in from outside) is
## drawn from where it comes in; one that leaves and comes back keeps only its last stretch, the one that ends at the target.
static func on_card(all: Array) -> Array:
	var pts: Array = []
	var m := float(SPS.MARGIN)
	for p in all:
		var v: Vector2 = p
		if v.x >= m and v.y >= m and v.x <= SPS.PX - m and v.y <= SPS.PX - m:
			pts.append(v)
		elif not pts.is_empty():
			pts.clear()
	return pts


## The arrow's stroke along the path and its head on the path's last point.
static func draw(img: Image, all: Array) -> float:
	var pts := on_card(all)
	if pts.size() < 2 or length(pts) < 14.0:
		return 0.0
	var end: Vector2 = pts[-1]
	var back := end
	for i in range(pts.size() - 2, -1, -1):
		back = pts[i]
		if back.distance_to(end) >= 8.0:
			break
	var tip := (end - back).normalized()
	var head := clampf(length(pts) * 0.22, 9.0, 15.0)
	var stop := end - tip * head * 0.6
	for i in range(1, pts.size()):
		var a: Vector2 = pts[i - 1]
		var b: Vector2 = pts[i]
		if a.distance_to(end) < head * 0.6:
			break
		if b.distance_to(end) < head * 0.6:
			b = stop
		var n := maxi(1, int(a.distance_to(b)))
		for k in n + 1:
			SPC._stamp(img, a.lerp(b, float(k) / float(n)), SPS.ARROW_PX * 0.5)
	SPC._fill_triangle(img, end, end - tip.rotated(0.42) * head, end - tip.rotated(-0.42) * head)
	return length(pts)


## A path bowed into an arc (S383 r3: the rear hook's real path, seen from the card's camera, ran nearly straight and
## read as a cross): a curve from its first to its last point, `k` x the chord out to the side the path already leans
## to (upward on the card when it is straight).
static func bow(all: Array, k: float) -> Array:
	if all.size() < 2:
		return all
	var a: Vector2 = all[0]
	var b: Vector2 = all[-1]
	var perp := (b - a).orthogonal().normalized()
	var lean := 0.0
	for p in all:
		lean += ((p as Vector2) - a).dot(perp)
	if absf(lean) < 1.0:
		lean = -perp.y
	var c := (a + b) * 0.5 + perp * signf(lean) * a.distance_to(b) * k
	var out: Array = []
	for i in 17:
		var u := float(i) / 16.0
		out.append(a.lerp(c, u).lerp(c.lerp(b, u), u))
	return out

