extends SceneTree
## PICS2D1 (S539, owner "yes, run the 2D picture test"): ONE real settled round, two ways, for the owner to compare.
##   3d    plays the real game to fight night (the same route as tools/fight3d_play.gd: quick start, sign, camp, weigh-in),
##         watches round 1 in the game's own 3D view from its broadcast camera at normal speed, no corner call clicked, and
##         saves every 2nd frame (with --fixed-fps 20 = a 10 fps film) to <out>/frames_3d/, then the round as data to
##         <out>/round.json (its six exchanges, the 3D view's beats, both bodies). seed=<n> = the same career and bout.
##   pics  plays that round.json as pictures (tools/pics2d_render.gd's stills in stills=<dir>): per exchange its punches
##         picked from the beats (the first, the winner's best landed, a miss), each ~1.1 s: a 0.24 s pop (0.90 -> 1.035
##         -> 1.0), a 0.48 s impact ring and a flash on landed, a "MISS" streak on missed, the exchange's line beside it.
##         Every frame (--fixed-fps 30) to <out>/frames_pics/; pictures.json lists what was shown when.
##   python tools/hidden_desktop.py run --timeout=900 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 20 --script res://tools/pics2d_round.gd -- <out> 3d seed=7
##   ... --fixed-fps 30 --script res://tools/pics2d_round.gd -- <out> pics stills=<dir>
## Prints PICS2D_ROUND ... done.

const W := 1920
const H := 1080
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const PIC_S := 1.1
const POP_S := 0.24
const RING_S := 0.48
const PER_EXCHANGE := 3

var out_dir := "user://pics2d_round"
var main: Node


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	root.size = Vector2i(W, H)
	if args.has("pics"):
		await _pics()
	else:
		seed(int(_arg("seed", "7")))
		await _film_3d()


# ---------------------------------------------------------------- the 3D round, from the game's own bout path

func _film_3d() -> void:
	DirAccess.make_dir_recursive_absolute(out_dir.path_join("frames_3d"))
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		_tidy(c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			offer = o
	if offer.is_empty():
		print("PICS2D_ROUND FAIL no bout offer")
		quit(1)
		return
	main.act("accept", str(offer["id"]))
	if bool(offer.get("camp", true)):
		main.act("camp", str(f["id"]))
		main.act("startcamp")
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		_tidy(c)
		main.run_to_stop()
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	main.act("fightnight")
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	if view == null:
		print("PICS2D_ROUND FAIL no 3D view")
		quit(1)
		return
	await _wait(2)
	for ch in view.get_children():   # the intro plays first; skip it to the bell (as fight3d_play does)
		if ch.has_method("cue_touch"):
			ch.finish()
	await _wait(2)
	var frame_t: Array = []
	var n := 0
	var k := 0
	while bool(view.playing) and int(view.round_n) == 1 and float(view.t) < 180.0:
		await process_frame
		k += 1
		if k % 2 == 1:
			continue
		await RenderingServer.frame_post_draw
		var img := root.get_texture().get_image()
		img.resize(960, 540, Image.INTERPOLATE_BILINEAR)
		img.save_jpg(out_dir.path_join("frames_3d/f_%05d.jpg" % n), 0.88)
		frame_t.append(snappedf(float(view.t), 0.01))
		n += 1
	var beats: Array = []
	for b in view._round_beats:
		var d: Dictionary = b
		if str(d.get("move", "")) == "say":
			continue
		beats.append({"t": float(d.get("t", 0.0)), "who": str(d.get("who", "")), "move": str(d.get("move", "")),
			"result": str(d.get("result", "")), "big": bool(d.get("big", false))})
	var exs: Array = []
	var rounds: Array = main.modal.get("rounds", [])
	var src: Array = (rounds[0] as Dictionary).get("exchanges", []) if not rounds.is_empty() else (LiveRound.live(main.modal).get("ex", []) as Array)
	for x in src:
		exs.append({"won": bool(x.get("won", false)), "margin": float(x.get("margin", 0.0)), "landed": x.get("landed", [0, 0]),
			"sit": str(x.get("sit", "")), "verdict": str(x.get("verdict", "")), "duel_line": str(x.get("duel_line", ""))})
	var opp: Dictionary = f["bout"]["opp"]
	var data := {"seed": int(_arg("seed", "7")), "names": [str(c.fighter()["name"]), str(opp["name"])],
		"bodies": view.bodies, "scales": FightCast.body_scales(c.fighter(), opp),
		"stances": [str(c.fighter().get("stance", "orthodox")), str(opp.get("stance", "orthodox"))],
		"exchanges": exs, "beats": beats, "frame_t": frame_t, "fps": 10}
	var fh := FileAccess.open(out_dir.path_join("round.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(data, "  "))
	fh.close()
	print("PICS2D_ROUND 3d frames=%d t_end=%.1f exchanges=%d beats=%d bodies=%s done" % [n, float(view.t), exs.size(), beats.size(), view.bodies])
	quit(0)


func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame


# ---------------------------------------------------------------- the same round as pictures

## A beat's punch as one of our pictured punches (jab / cross / lead_hook), or "" for one we have no picture of.
static func family(move: String) -> String:
	var m := move.to_lower()
	if m.contains("jab") or m == "1":
		return "jab"
	if m.contains("hook") or m == "3":
		return "lead_hook"
	if m.contains("cross") or m.contains("straight") or m.contains("upper") or m == "2":
		return "cross"
	return ""


## Per exchange, up to PER_EXCHANGE punches in time order: the first one, the winner's best landed, a miss.
static func pick(rj: Dictionary) -> Array:
	var out: Array = []
	var exs: Array = rj["exchanges"]
	for k in exs.size():
		var won_a := bool(exs[k]["won"])
		var mine: Array = []
		for b in rj["beats"]:
			var t := float(b["t"])
			if t >= k * 30.0 and t < (k + 1) * 30.0 and family(str(b["move"])) != "" and ["lands", "misses", "blocked"].has(str(b["result"])):
				mine.append(b)
		if mine.is_empty():
			out.append({"k": k, "t": k * 30.0 + 1.0, "pic": "guard", "line": "", "landed": false, "who": ""})
			continue
		var chosen: Array = [mine[0]]
		var win := "a" if won_a else "b"
		var best: Dictionary = {}
		for b in mine:
			if str(b["who"]) == win and str(b["result"]) == "lands" and (best.is_empty() or bool(b["big"])):
				best = b
		if not best.is_empty() and not chosen.has(best):
			chosen.append(best)
		for b in mine:
			if chosen.size() < PER_EXCHANGE and str(b["result"]) != "lands" and not chosen.has(b):
				chosen.append(b)
				break
		chosen.sort_custom(func(x, y): return float(x["t"]) < float(y["t"]))
		for b in chosen:
			var landed := str(b["result"]) == "lands"   # blocked shows as the missed picture (no blocked pictures yet)
			var corner := "red" if str(b["who"]) == "a" else "blue"
			out.append({"k": k, "t": float(b["t"]), "who": str(b["who"]), "move": str(b["move"]), "result": str(b["result"]),
				"landed": landed, "pic": "%s_%s_%s" % [corner, family(str(b["move"])), "landed" if landed else "missed"]})
	return out


func _pics() -> void:
	var rj: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(out_dir.path_join("round.json")))
	var stills := _arg("stills", out_dir.path_join("stills"))
	var contacts: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(stills.path_join("contacts.json")))
	var shows := pick(rj)
	DirAccess.make_dir_recursive_absolute(out_dir.path_join("frames_pics"))
	var ui := Control.new()
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(ui)
	var bg := ColorRect.new()
	bg.color = Color(0.11, 0.12, 0.15)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.add_child(bg)
	var stage_bg := ColorRect.new()   # a lit canvas behind the pair, as a ring floor under lights
	stage_bg.color = Color(0.86, 0.84, 0.78)
	stage_bg.position = Vector2(90, 70)
	stage_bg.size = Vector2(940, 940)
	ui.add_child(stage_bg)
	var pic := TextureRect.new()
	pic.position = Vector2(100, 80)
	pic.size = Vector2(920, 920)
	pic.pivot_offset = pic.size * 0.5
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ui.add_child(pic)
	var fx: Control = load("res://tools/pics2d_round.gd").Fx.new()
	fx.position = pic.position
	fx.size = pic.size
	ui.add_child(fx)
	var flash := ColorRect.new()
	flash.color = Color(1, 1, 1, 0)
	flash.position = stage_bg.position
	flash.size = stage_bg.size
	ui.add_child(flash)
	var names: Array = rj["names"]
	var head := _label(ui, Vector2(1090, 90), 40, "%s  v  %s" % [names[0], names[1]])
	head.add_theme_color_override("font_color", Color(1, 0.86, 0.5))
	var clock := _label(ui, Vector2(1090, 160), 64, "")
	var exl := _label(ui, Vector2(1090, 260), 30, "")
	var what := _label(ui, Vector2(1090, 330), 38, "")
	var line := _label(ui, Vector2(1090, 420), 26, "")
	line.size = Vector2(760, 400)
	line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var texs := {}
	var n := 0
	var log: Array = []
	var fps := 30.0
	for s in shows:
		var p := str(s["pic"])
		if not texs.has(p):
			texs[p] = ImageTexture.create_from_image(Image.load_from_file(stills.path_join(p + ".png")))
		pic.texture = texs[p]
		var k := int(s["k"])
		var x: Dictionary = rj["exchanges"][k]
		var left := 180.0 - float(s["t"])
		clock.text = "Round 1   %d:%02d" % [int(left) / 60, int(left) % 60]
		exl.text = "Exchange %d of 6  -  %s" % [k + 1, "%s won it" % names[0] if bool(x["won"]) else "%s won it" % names[1]]
		var who_n := str(names[0] if str(s.get("who", "")) == "a" else names[1])
		var verb: String = {"lands": "lands the ", "misses": "misses the ", "blocked": "is blocked: the "}.get(str(s.get("result", "")), "")
		what.text = "%s %s%s" % [who_n, verb, str(s.get("move", "")).replace("_", " ")] if str(s.get("who", "")) != "" else "Both on guard"
		line.text = str(x.get("verdict", "")) if str(x.get("verdict", "")) != "" else str(x.get("duel_line", ""))
		var c: Dictionary = contacts.get(p, {})
		var sc := pic.size.x / 1024.0
		fx.start(bool(s["landed"]), Vector2(c.get("glove", [512, 400])[0], c.get("glove", [512, 400])[1]) * sc,
			Vector2(c.get("face", [600, 380])[0], c.get("face", [600, 380])[1]) * sc, str(s.get("who", "")) != "")
		fx.word = "BLOCKED" if str(s.get("result", "")) == "blocked" else "MISS"
		log.append({"frame": n, "t": s["t"], "pic": p, "what": what.text})
		var frames := int(PIC_S * fps)
		for i in frames:
			var u := i / fps
			pic.scale = Vector2.ONE * _pop(u)
			fx.at(u)
			flash.color.a = clampf(0.35 * (1.0 - u / 0.15), 0.0, 0.35) if bool(s["landed"]) else 0.0
			await process_frame
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_jpg(out_dir.path_join("frames_pics/f_%05d.jpg" % n), 0.9)
			n += 1
	var fh := FileAccess.open(out_dir.path_join("pictures.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify(log, "  "))
	fh.close()
	print("PICS2D_ROUND pics shown=%d frames=%d done" % [shows.size(), n])
	quit(0)


## The pop: 0.90 -> 1.035 over the first half of POP_S, -> 1.0 over the second.
static func _pop(u: float) -> float:
	if u >= POP_S:
		return 1.0
	var h := POP_S * 0.5
	if u < h:
		return lerpf(0.90, 1.035, ease(u / h, 0.5))
	return lerpf(1.035, 1.0, ease((u - h) / h, 2.0))


func _label(p: Control, at: Vector2, px: int, t: String) -> Label:
	var l := Label.new()
	l.position = at
	l.text = t
	l.add_theme_font_size_override("font_size", px)
	l.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95))
	p.add_child(l)
	return l


## The impact ring (landed) or the MISS streak (missed), drawn over the picture.
class Fx extends Control:
	var landed := false
	var glove := Vector2.ZERO
	var face := Vector2.ZERO
	var on := false
	var word := "MISS"
	var u := 0.0

	func start(l: bool, g: Vector2, f: Vector2, show: bool) -> void:
		landed = l
		glove = g
		face = f
		on = show
		u = 0.0
		queue_redraw()

	func at(t: float) -> void:
		u = t
		queue_redraw()

	func _draw() -> void:
		if not on:
			return
		if landed:
			if u > 0.48:
				return
			var k := u / 0.48
			var r := lerpf(24.0, 150.0, ease(k, 0.4))
			var a := 1.0 - k
			draw_arc(glove, r, 0.0, TAU, 48, Color(1.0, 0.92, 0.35, a), lerpf(14.0, 3.0, k), true)
			draw_arc(glove, r * 0.62, 0.0, TAU, 40, Color(1, 1, 1, a), lerpf(8.0, 2.0, k), true)
			for i in 10:   # the burst's spikes
				var d := Vector2.from_angle(TAU * i / 10.0 + 0.3)
				draw_line(glove + d * r * 0.7, glove + d * r * 1.15, Color(1, 0.7, 0.2, a), 5.0, true)
		else:
			if u > 0.7:
				return
			var dir := (face - glove).normalized() if face.distance_to(glove) > 1.0 else Vector2.RIGHT
			var a := clampf(1.0 - (u - 0.35) / 0.35, 0.0, 1.0)
			var shift := dir * lerpf(0.0, 60.0, minf(u / 0.3, 1.0))
			for i in 3:
				var o := Vector2(-dir.y, dir.x) * (i - 1) * 16.0
				draw_line(glove + o - dir * 120.0 + shift, glove + o + dir * 30.0 + shift, Color(1, 1, 1, a * 0.8), 4.0, true)
			var font := ThemeDB.fallback_font
			draw_string(font, face + Vector2(-70, -90) + shift, word, HORIZONTAL_ALIGNMENT_LEFT, -1, 64, Color(1, 0.25, 0.2, a))
