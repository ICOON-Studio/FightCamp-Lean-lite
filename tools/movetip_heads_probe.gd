extends SceneTree
## S382 MOVETIP1 round 3 probe: the hover card's studio (MovePlayer, studio on) plays the jab, the one-two, the lead hook
## and the body hook on Danny Osei (a man) and Lucy (a woman) with their partners, three loops each on one player (as the
## card keeps it); every frame it reads both heads in their FINAL pose (Skeleton3D.skeleton_updated, after every modifier),
## each centre riding with its head, and prints the closest pair. move_tip_test uses player() and heads() for its bar.
## Round 2's film (movetip_r2.mp4 0:19.45): on the body hook the partner's head went inside Danny's (0.217 m here then).
##   godot --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/movetip_heads_probe.gd [-- trace]
## Prints HEADS <who> <move> loop<n> min=<m> at=<s> partner=<clip> gap=<m>, then HEADS_PROBE worst=<m>; `trace` prints
## every frame with the heads under 0.45 m.

const MoveTip := preload("res://scripts/ui/MoveTip.gd")
const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const GloveClear := preload("res://scripts/fight3d/GloveClear.gd")
const MOVES := ["jab", "1-2", "lead_hook", "body_hook"]

var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var c: Career = main.career
	Roster.prospect(c, "danny")["state"] = "invited"
	var danny := Roster.sign_prospect(c, "danny", ["signature"])
	var worst := 9.0
	for f in [danny, c.fighters[0]]:
		var p := player(self, f)   # one player through the moves, as the card keeps it (the film's order)
		await process_frame
		for id in MOVES:
			for loop in 3:
				var r: Dictionary = await heads(self, p, MoveTip.info(id, f) if loop == 0 else {})
				print("HEADS %s %s loop%d min=%.3f at=%.2f partner=%s gap=%.3f frames=%d" % [str(f.get("name", "?")), id, loop,
					r["min"], r["at"], r["clip"], r["gap"], r["n"]])
				worst = minf(worst, float(r["min"]))
		p.queue_free()
		await process_frame
	print("HEADS_PROBE worst=%.3f" % worst)
	quit(0)


## A studio player (the hover card's) on fighter f and her partner, in the tree.
static func player(tree: SceneTree, f: Dictionary) -> Control:
	var p: Control = MovePlayer.new()
	var stems: Array = Faces.pair(f, Faces.partner(f))
	p.bodies = [Faces.glb(str(stems[0])), Faces.glb(str(stems[1]))]
	p.studio = true
	p.yaw_deg = MoveTip.YAW_DEG
	p.size = Vector2(320, 240)
	tree.root.add_child(p)
	return p


## One loop of move `d` (MoveTip.info; {} = the loop already playing goes round again) on player p: the closest the two
## heads came in their FINAL pose (read on Skeleton3D.skeleton_updated, after every modifier), when (seconds into the
## loop), the partner's clip then and the pelvis gap. {"min", "at", "clip", "gap", "n" (frames read)}.
static func heads(tree: SceneTree, p: Control, d: Dictionary) -> Dictionary:
	if not d.is_empty():
		if str(d["sm"]) != "":
			p.show_move(str(d["sm"]))
		else:
			p.show_chain(d["clips"])
	var stage: Node3D = p.get("_stage")
	var shown := [Vector3.INF, Vector3.INF]
	var hooks := []
	for i in 2:
		var sk: Skeleton3D = stage.boxers[i]["skel"]
		var hb := sk.find_bone("Head")
		var k := sk.global_transform.basis.get_scale().x
		# The head's centre rides with the head: HEAD_UP_M up the skull in the bind pose (standing upright), turned with the
		# head bone - a folded head's centre is out in front of the bone, where the world-up guess (GloveClear) is not.
		var up_local := sk.get_bone_global_rest(hb).basis.inverse() * (Vector3.UP * GloveClear.HEAD_UP_M / k)
		var cb := func():
			var g := sk.get_bone_global_pose(hb)
			shown[i] = sk.global_transform * (g.origin + g.basis * up_local)
		sk.skeleton_updated.connect(cb)
		hooks.append([sk, cb])
	var out := {"min": 9.0, "at": -1.0, "clip": "", "gap": 0.0, "n": 0}
	var done := [false]
	var on_loop := func(): done[0] = true
	p.looped.connect(on_loop)
	var t0 := Time.get_ticks_msec()
	var t := 0.0
	while not done[0] and Time.get_ticks_msec() - t0 < 8000:
		await tree.process_frame
		t += tree.root.get_process_delta_time()
		if not (shown[0].is_finite() and shown[1].is_finite()):
			continue
		out["n"] = int(out["n"]) + 1
		var dist: float = shown[0].distance_to(shown[1])
		if OS.get_cmdline_user_args().has("trace") and dist < 0.45:
			var g0: Node = stage.boxers[0]["gclear"]
			var g1: Node = stage.boxers[1]["gclear"]
			print("  t=%.2f d=%.3f gc=%.3f push=%d/%d touch=%.2f heads=%s h0=%s h1=%s p1=%s c1=%s" % [t, dist, g0.shown_head.distance_to(g1.shown_head),
				g0.head_pushes, g1.head_pushes, g0.head_touch_m, g0.heads, shown[0], shown[1], stage.boxers[1]["pos"],
				(stage.boxers[1]["ap"] as AnimationPlayer).current_animation])
		if dist < float(out["min"]):
			out["min"] = dist
			out["at"] = t
			out["clip"] = str((stage.boxers[1]["ap"] as AnimationPlayer).current_animation)
			out["gap"] = p.call("_measure_gap")
	p.looped.disconnect(on_loop)
	for h in hooks:
		(h[0] as Skeleton3D).skeleton_updated.disconnect(h[1])
	return out


func _frames(n: int) -> void:
	for i in n:
		await process_frame
