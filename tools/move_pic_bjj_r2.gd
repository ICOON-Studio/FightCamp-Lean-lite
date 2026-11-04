extends RefCounted
## MOVEPICS1 r2 (S381 art review: "limb piles, top-down two heads, Ana hidden, tiny arrows") - a BJJ card drawn for
## reading at 256 px (tools/move_pic_bjj_cards.gd says which film, who Ana is, the key contact and the arrow's limb):
##   1. Ana is the one DOING the move (the film's top or bottom man is put in her red body);
##   2. of the film's later keyframes and twelve sides x two LOW heights, the shot whose drawing keeps the two bodies
##      most apart (each body's own area and outline, tools/move_pic_view.gd score) and shows the contact;
##   3. the camera tight on the contact (the far ends of limbs may leave the card, both heads stay);
##   4. the gold arrow along the key limb's path into that keyframe, walked back over earlier keyframes until it is
##      MIN_ARROW_PX long on the card.
## A move with no film: the card's "card pending" name (move_pic_bjj_cards.pending_card).

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const BjjFilm := preload("res://scripts/rules/BjjFilm.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const Cards := preload("res://tools/move_pic_bjj_cards.gd")
const View := preload("res://tools/move_pic_view.gd")
const SPS := preload("res://tools/session_pic_style.gd")
const SPC := preload("res://tools/session_pic_card.gd")

const WALK_S := 0.05          # the film is walked up to its key at this step: GrapplePose keeps each bone's last roll
const MIN_ARROW_PX := 40.0
const LOOK_TOP := 4           # a look-dev run (out=) writes this many of the best shots per card
const FALLBACK := [[0, "LeftHand"], [0, "RightHand"], [0, "LeftAnkle"], [0, "RightAnkle"], [0, "LeftKnee"], [0, "RightKnee"],
	[0, "Head"], [0, "Core"]]


static func bake(t, db: Array, player: Node, id: String, stems: Array) -> void:
	var c := Cards.card(id)
	if bool(c.get("pending", false)):
		var blank: Image = await Cards.pending_card(t, id)
		t.store(id, blank, {"kind": "bjj", "pending": true, "name": NoGi.move_name(id)})
		return
	var i := Cards.film(db, c["film"]) if c.has("film") else BjjFilm.find(db, id)
	if i < 0:
		print("MOVE_PIC_MISSING %s: no GrappleMap film" % id)
		return
	var seq: Dictionary = (db[i] as Dictionary).duplicate()
	var frames: Array = Graph.steady(seq["frames"])
	var ana := _ana(frames, str(c.get("ana", "top")))
	if ana == 1:
		frames = frames.map(func(f): return [f[1], f[0]])
	seq["frames"] = frames
	player.play(seq, player.men, player.scale, Transform3D.IDENTITY)
	player.paused = true
	var keys: PackedFloat32Array = player.key_times()
	var shots := _ranked(player, keys, c, t._view.has("free"))
	var picks: Array = shots.slice(0, int(t._view.get("top", LOOK_TOP))) if t._out_dir != "" else [shots[0]]
	for p in picks:
		var img: Image = await _shoot(t, player, keys, p, c)
		var row: Dictionary = img.get_meta("row")
		row.merge({"film": str(seq["title"]), "keys": keys.size(), "ana_was": "top" if _ana(frames, "top") == 0 else "bottom",
			"bodies": stems, "score": snappedf(float(p["score"]), 0.01)})
		img.remove_meta("row")
		if t._out_dir != "":
			img.save_png(str(t._out_dir).path_join("%s_k%d_az%d_e%d.png" % [id, p["k"], p["az"], p["el"]]))
			print("MOVE_PIC_LOOK %s %s" % [id, JSON.stringify(row)])
		else:
			t.store(id, img, row)


## 0 / 1: which of the film's two men is Ana. top / bottom = higher / lower core at the first keyframe; low_end = the
## one lower at the last keyframe (the shooter of a takedown); p0 / p1 = the film's own first / second man (S383: in
## "top bases bottom triangles" the triangler sits higher at the start - "bottom" put Ana in the kneeling man).
static func _ana(frames: Array, rule: String) -> int:
	if rule == "p0" or rule == "p1":
		return int(rule.right(1))
	var f: Array = frames[-1] if rule == "low_end" else frames[0]
	var core := DB.joint("Core")
	var zero_higher: bool = (f[0] as PackedVector3Array)[core].y > (f[1] as PackedVector3Array)[core].y
	if rule == "top":
		return 0 if zero_higher else 1
	return 1 if zero_higher else 0


## Every (keyframe, side, height) the card may be shot from, best first. A card may pin its key ("key": index) or side;
## `free` (a look-dev run's free=1) ignores the pins, so every shot competes again.
static func _ranked(player: Node, keys: PackedFloat32Array, c: Dictionary, free := false) -> Array:
	var n := keys.size()
	var first := 0 if bool(c.get("all_keys", false)) or free else maxi(1, n / 2)
	if free:
		c = c.duplicate()
		for pin in ["key", "keys", "az", "el"]:
			c.erase(pin)
	var ks: Array = [int(c["key"])] if c.has("key") else c["keys"] if c.has("keys") else range(first, n) if n > 1 else [0]
	var azs: Array = [float(c["az"])] if c.has("az") else range(0, 360, 30)
	var els: Array = [float(c["el"])] if c.has("el") else View.ELEVS
	var out: Array = []
	for k in ks:
		var js: Array = player.joints_at(keys[k])
		for az in azs:
			for el in els:
				out.append({"k": k, "az": int(az), "el": int(el), "score": View.score(js, float(az), float(el), c["contact"])})
	out.sort_custom(func(a, b): return a["score"] > b["score"])
	# A look-dev sheet wants different pictures: one shot per (keyframe, side).
	var seen := {}
	var uniq: Array = []
	for s in out:
		var key := "%d_%d" % [s["k"], s["az"]]
		if not seen.has(key):
			seen[key] = true
			uniq.append(s)
	return uniq


static func _shoot(t, player: Node, keys: PackedFloat32Array, p: Dictionary, c: Dictionary) -> Image:
	var tk: float = keys[int(p["k"])]
	var now := 0.0
	player.seek(0.0)
	await t.process_frame
	while now < tk:
		now = minf(now + WALK_S, tk)
		player.seek(now)
		await t.process_frame
	var js: Array = player.joints_at(tk)
	var b := View.view(float(p["az"]), float(p["el"]))
	var win := View.crop(js, b, c["contact"])
	t._cam.position = (win["centre"] as Vector3) + b.z * t.CAM_DIST
	t._cam.look_at(win["centre"], Vector3.UP)
	t._cam.size = float(win["size"])
	var raw: Image = await t._render(t.BIG)
	# A window that holds the whole pair keeps the drawing off the card's edge: the bone-point padding can fall short of
	# the flesh (S383 posture_closed_guard touched the edge), so it widens until the drawing fits.
	var grow := 0
	while not bool(win["bleeds"]) and not t._fits(raw.get_used_rect(), t.BIG, SPS.MARGIN) and grow < 4:
		t._cam.size *= 1.06
		grow += 1
		raw = await t._render(t.BIG)
	var data := SPC.bg_data().duplicate()
	SPC._over(data, t.blue_layer(SPC.ink_layer(raw)).get_data(), 1.0)
	var img := Image.create_from_data(SPS.PX, SPS.PX, false, Image.FORMAT_RGBA8, data)
	var arrow := _arrow(t, player, keys, int(p["k"]), c["arrow"])
	var drawn: float = t.path_arrow(img, arrow["path"])
	var lo := INF
	for m in js:
		for v in (m as PackedVector3Array):
			lo = minf(lo, v.y)
	img.set_meta("row", {"kind": "bjj", "r2": true, "key": int(p["k"]), "key_t": snappedf(tk, 0.001), "az": int(p["az"]),
		"elev": int(p["el"]), "crop_m": snappedf(float(t._cam.size), 0.01), "bleeds": bool(win["bleeds"]),
		"arrow": arrow["joint"], "arrow_px": snappedf(drawn, 0.1), "lowest_joint_y": snappedf(lo, 0.003)})
	return img


## The arrow: of the card's limbs, the one whose path into keyframe k runs longest on the card; each path starts one
## keyframe back and reaches further back until it is MIN_ARROW_PX long.
static func _arrow(t, player: Node, keys: PackedFloat32Array, k: int, limbs: Array) -> Dictionary:
	t._img_size = Vector2(SPS.PX, SPS.PX)
	var best := {"path": [], "joint": "", "len": 0.0}
	# The card's own limbs first; if none runs MIN_ARROW_PX on the card, any of Ana's that does.
	for limb in limbs + [null] + FALLBACK:
		if limb == null:
			if float(best["len"]) >= MIN_ARROW_PX:
				break
			continue
		var who := int(limb[0])
		var j := DB.joint(str(limb[1]))
		var from := maxi(k - 1, 0)
		while true:
			var pts: Array = []
			var u: float = keys[from]
			var tk: float = keys[k]
			while true:
				var p: PackedVector3Array = player.joints_at(u)[who]
				pts.append(t._px(p[j] + Vector3(0.0, 0.05, 0.0)))
				if u >= tk:
					break
				u = minf(u + WALK_S, tk)
			var seen: Array = t.on_card(pts)
			var n: float = t._path_len(seen)
			if n >= MIN_ARROW_PX or from == 0:
				if n > float(best["len"]):
					best = {"path": seen, "joint": ("" if who == 0 else "partner ") + str(limb[1]), "len": n}
				break
			from -= 1
	return best
