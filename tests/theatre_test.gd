extends SceneTree
## S379 the Grappling theatre: every chain is a valid path through the GrappleMap graph (each move starts on the position
## the last one landed on) and plays as one straight reel (joins laid by GrappleGraph.align, under 10 cm a joint); every
## move has a caption (name + one plain line); the documentary director never puts the camera inside a body or under the
## mat at 30 fps, never cuts faster than 1.5 s, never cuts on a join and never turns faster than 10 deg/s (operator S379:
## "the camera spins too fast ... it got me dizzy"); the instrument reads worse on a camera planted
## in a body (control arm). jump=theatre opens the scene, every chain has its picture card, and the scene itself loads,
## switches chains and steps move to move. Prints THEATRE failures=<n>.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const Chains := preload("res://scripts/grapple/TheatreChains.gd")
const Director := preload("res://scripts/grapple/TheatreDirector.gd")
const TUI := preload("res://scripts/grapple/TheatreUI.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")
const SCENE := "res://scenes/dev/GrappleTheatre.tscn"
const LEG_M := 0.82   # our women's hip to ankle, about (the scene measures the real skeletons)
const PRE_S := 1.0
const POST_S := 1.5

var failures := 0


func _initialize() -> void:
	var db: Array = DB.load_db()
	var g = Graph.new()
	var all: Array = Chains.chains()
	var ids := {}
	for c in all:
		ids[str(c["id"])] = true
	_check(all.size() >= 8 and ids.size() == all.size(), "%d chains, ids unique" % all.size())
	_check(ids.has("fifty_fifty"), "the operator's 'to 50/50' chain is in")
	var player: Node = Player.new()
	player.set("contact", false)
	var worst_err := 0.0
	for c in all:
		var r: Dictionary = Chains.resolve(g, c)
		var path := " -> ".join(r["path"].map(func(p): return str(p["id"])))
		_check(bool(r["ok"]), "%s resolves to a graph path (%s) %s" % [c["id"], path, " ".join(r["errors"])])
		var captioned := true
		for s in c["steps"]:
			var line := str(s["line"])
			if str(s["name"]).strip_edges().is_empty() or line.length() < 20 or line.length() > 110:
				captioned = false
				print("  caption missing or too long: %s %s" % [c["id"], s])
		_check(captioned, "%s: a caption for every move (%d)" % [c["id"], (c["steps"] as Array).size()])
		_check(int(c["key"]) >= 0 and int(c["key"]) < (c["steps"] as Array).size(), "%s: its card's key move exists" % c["id"])
		var reel := Chains.reel(db, c)
		var errs: Array = reel["joins"].map(func(j): return float(j["err"]))
		for e in errs:
			worst_err = maxf(worst_err, float(e))
		_check((reel["joins"] as Array).size() == (c["steps"] as Array).size() - 1 and errs.all(func(e): return e < 0.10),
			"%s: %d joins laid on the last keyframe, align err %s m" % [c["id"], errs.size(), ", ".join(errs.map(func(e): return "%.3f" % e))])
		var traded := _traded(reel["frames"])
		_check(traded == 0, "%s: no keyframe trades the women's places mid-move (%d)" % [c["id"], traded])
		_director(c, reel, player)
	# Control arm: a move laid on an unrelated position reads far (the join bar can fail).
	var unrelated: Array = DB.find(db, "full guard kimura")["frames"]
	var far := float(Graph.align(unrelated[0], (db[1235]["frames"] as Array)[0])["err"])
	_check(far > 0.10, "control: 'to 50/50' laid on full guard kimura reads %.3f m (> 0.10)" % far)
	_check(_traded(db[1235]["frames"]) == 1, "control: 'to 50/50' as recorded trades the places once (S379: the bodies flew through each other)")
	player.free()
	_check(TestJump.scene_for(PackedStringArray(["jump=theatre"])) == SCENE and ResourceLoader.exists(SCENE),
		"jump=theatre opens %s" % SCENE)
	var missing := all.filter(func(c): return TUI.card_texture(str(c["id"])) == null).map(func(c): return str(c["id"]))
	_check(missing.is_empty(), "every chain has its picture card (missing: %s)" % ", ".join(missing))
	await _scene_smoke()
	print("THEATRE failures=%d" % failures)
	quit(1 if failures else 0)


## The director on one chain, on the player alone (the joints the women are driven by, at our size).
func _director(c: Dictionary, reel: Dictionary, player: Node) -> void:
	player.play({"frames": reel["frames"]}, [], Player.pair_scale([LEG_M, LEG_M]), Transform3D.IDENTITY)
	var kt: PackedFloat32Array = player.key_times()
	var steps: Array = []
	for s in reel["steps"]:
		steps.append({"name": s["name"], "t0": PRE_S + kt[int(s["k0"])], "t1": PRE_S + kt[int(s["k1"])]})
	var joins: Array = reel["joins"].map(func(j): return PRE_S + kt[int(j["k"])])
	var total := PRE_S + float(player.length_s()) + POST_S
	var d := Director.new()
	var sampler := func(t: float) -> Array: return player.joints_at(clampf(t - PRE_S, 0.0, float(player.length_s())))
	d.plan(sampler, steps, total)
	var a := d.audit(30.0)
	var kinds := {}
	var cut_on_join := 0
	for s in d.shots:
		kinds[str(s["kind"])] = true
		for j in joins:
			if absf(float(s["t0"]) - float(j)) < 0.25:
				cut_on_join += 1
	_check(float(a["min_clear"]) >= 0.0, "%s: camera never inside a body (closest %.2f m from a body surface at %.1f s)" % [
		c["id"], float(a["min_clear"]), float(a["worst_t"])])
	_check(float(a["min_y"]) >= Director.CAM_MIN_Y - 0.001, "%s: camera never under the mat (lowest %.2f m)" % [c["id"], float(a["min_y"])])
	_check(float(a["shortest"]) >= 1.5, "%s: no cut faster than 1.5 s (shortest shot %.2f s)" % [c["id"], float(a["shortest"])])
	_check(cut_on_join == 0, "%s: no cut on a join (%d)" % [c["id"], cut_on_join])
	_check(float(a["max_turn"]) <= Director.MAX_TURN_DEG_S + 0.5, "%s: the camera never turns faster than %.0f deg/s inside a shot (%.1f)" % [
		c["id"], Director.MAX_TURN_DEG_S, float(a["max_turn"])])
	_check(kinds.size() >= 3, "%s: %d shots over %d moves (%.1f s), kinds %s" % [c["id"], d.shots.size(), steps.size(), total,
		", ".join(kinds.keys())])
	print("    shots: " + ", ".join(d.shots.map(func(s): return "%s %.1f-%.1f%s" % [s["kind"], float(s["t0"]), float(s["t1"]),
		" (aim %+.0f, blocked %.2f)" % [float(s["aim"]), float(s["blocked"])] if s.has("aim") else ""])))
	var closes: Array = d.shots.filter(func(s): return s.has("blocked"))
	var blocked := 0.0
	for s in closes:
		blocked = maxf(blocked, float(s["blocked"]))
	_check(not closes.is_empty() and blocked <= 0.5, "%s: %d close-ups, each sees its contact past the bodies most of the shot (worst blocked %.2f)" % [
		c["id"], closes.size(), blocked])
	print("    moves: " + ", ".join(steps.map(func(s): return "%s %.1f-%.1f" % [s["name"], float(s["t0"]), float(s["t1"])])))
	var inside := Director.clearance(sampler.call(total * 0.5)[0][DB.joint("Core")], sampler.call(total * 0.5))
	_check(inside < 0.0, "%s control: a camera on a woman's core reads inside (%.2f m)" % [c["id"], inside])


## The scene itself (headless): it opens on a chain, switches chain from a card, steps to the next move.
func _scene_smoke() -> void:
	var th: Control = load(SCENE).instantiate()
	root.add_child(th)
	for k in 3:
		await process_frame
	var cards: Dictionary = th.get("_cards")["buttons"]
	_check(cards.size() == Chains.chains().size() and not (th.get("steps") as Array).is_empty(),
		"scene: %d picture cards, opens on '%s' with %d moves" % [cards.size(), th.get("chain_id"), (th.get("steps") as Array).size()])
	(cards["fifty_fifty"] as Button).pressed.emit()
	await process_frame
	th.call("step_move", 1)   # from the held first position to the first move
	th.call("step_move", 1)   # on to the second move: its join
	var t1 := float(th.get("clock"))
	var first_t0 := float((th.get("steps") as Array)[1]["t0"])
	_check(str(th.get("chain_id")) == "fifty_fifty" and is_equal_approx(t1, first_t0),
		"scene: the 50/50 card loads its chain, Next move jumps to the second move's join (%.2f s)" % t1)
	th.call("set_orbit", true)
	th.call("set_speed", 0.25)
	await process_frame
	_check(bool(th.get("orbit")) and is_equal_approx(float(th.get("speed")), 0.25), "scene: free orbit and 0.25x")
	await _drawn(th)
	th.queue_free()
	await process_frame


## Gaps in `frames` where the next keyframe is the last one with the women swapped / mirrored (GrappleGraph.steady's test).
func _traded(frames: Array) -> int:
	var n := 0
	for k in range(1, frames.size()):
		var raw := Graph.gap(frames[k - 1], frames[k])
		if raw > Graph.RELABEL_GAP_M:
			var how := Graph.align(frames[k - 1], frames[k])
			if (bool(how["swap"]) or bool(how["mirror"])) and float(how["err"]) < raw * Graph.RELABEL_LEFT:
				n += 1
	return n


## S379 BJJ9R11 (operator on the 50/50 film at 0:14: "not sure what is this ??" - red's head jumped 0.2 m in one frame, the
## data 5 cm): the 50/50 chain played at 30 fps, the women AS DRAWN (bones read on skeleton_updated, after GrapplePose): no
## trunk or head bone steps over 5 cm in one frame and none of Spine / Chest / upper arms / hands turns over 45 deg.
func _drawn(th: Control) -> void:
	var bones := ["Spine", "Chest", "Neck", "Head", "LeftUpperArm", "RightUpperArm", "LeftHand", "RightHand"]
	var cache: Array = [{}, {}]
	var poses: Array = th.get("poses")
	var hooks: Array = []
	for w in 2:
		var skel := (poses[w] as Node).get_parent() as Skeleton3D
		var hook := func() -> void:
			var d := {}
			for b in bones:
				d[b] = skel.global_transform * skel.get_bone_global_pose(skel.find_bone(b))
			cache[w] = d
		skel.skeleton_updated.connect(hook)
		hooks.append([skel, hook])
	th.call("load_chain", "fifty_fifty")
	th.call("set_playing", false)
	var n := int(float(th.get("total")) * 30.0)
	var step := 0.0
	var turn := 0.0
	var at := ""
	var prev: Array = [{}, {}]
	for f in n:
		th.call("seek", f / 30.0)
		await process_frame
		for w in 2:
			var cur: Dictionary = cache[w]
			if not (prev[w] as Dictionary).is_empty() and not cur.is_empty():
				for b in bones:
					var a: Transform3D = prev[w][b]
					var c: Transform3D = cur[b]
					if b in ["Spine", "Chest", "Neck", "Head"] and a.origin.distance_to(c.origin) > step:
						step = a.origin.distance_to(c.origin)
						at = "%s %s %.2f s" % [["red", "blue"][w], b, f / 30.0]
					if b != "Neck" and b != "Head":
						turn = maxf(turn, rad_to_deg(a.basis.get_rotation_quaternion().angle_to(c.basis.get_rotation_quaternion())))
			prev[w] = cur
	for h in hooks:
		(h[0] as Skeleton3D).skeleton_updated.disconnect(h[1])
	_check(n > 300 and step <= 0.05 and turn <= 45.0,
		"fifty_fifty as drawn: worst trunk/head one-frame step %.3f m (%s), worst Spine/Chest/arm/hand turn %.1f deg a frame" % [step, at, turn])


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
