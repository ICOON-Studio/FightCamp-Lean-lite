extends SceneTree
## ANIMFIX1 Track B (S425, operator: "grappling fights that make sens and make understand what is the action happening and
## how to react as a player"): the live BJJ bout AS THE PLAYER GETS IT, on film, with what the rules say written beside every
## frame. The career's real buttons to the mats (tools/open_night_play.gd's route), bout 1 fought live, nothing automatic:
## each call window stays open CALL_SHOWN_S so the film shows the choices, then one is clicked (the first call the plan,
## the next the second offer, and so on round the list, so the film shows what different calls do).
## `log=<csv>` writes, every frame: the movie frame, the match clock, the position the rules name and who they put on top,
## whose hips are DRAWN higher (bones read on Skeleton3D.skeleton_updated), the move playing, whether a call is open, the
## score, who has the initiative and the last line the match printed. Film it under the movie writer on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=900 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --write-movie <out>.avi --script res://tools/mat_live_film.gd -- log=<csv> [secs=330]
## Prints MATFILM lines; `MATFILM bout begins at movie frame <n>` is where to cut the film.
## THE RULER (`probe=1 direct=1 [seed=<n>]`, headless: --headless --fixed-fps 30; `direct=1` starts the bout without the career): four counts a viewer would trip over, printed as
## READ lines, and `MATREAD failures=<n>` (exit 1 on any):
##   down     a move by the woman on top that takes her DOWN the ladder (mount to guard ...) shown as "Move up"
##   repaid   points for a position she was already paid for, with no move of the other woman landing in between
##   calls    the shortest time between two of the player's calls (all three inside ten seconds is no say in the match)
##   early    how long before the bodies arrive the result and the new score are on screen (the longest, and the mean)
##   silent   moves that changed the position or who is on top with no attempt named on screen (a throw to side control
##            with no word and no points; the mount reached a second after her "Take mount" read STOPPED)

const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")
const CALL_SHOWN_S := 2.5
const TAIL_S := 3.0

var main: Node
var secs := 330.0
var _log: FileAccess
var _step := 0
var _t := 0.0
var _frame := 0
var _hips: Array = [NAN, NAN]
var _heads: Array = [NAN, NAN]
var _watching := false
var _call_t := 0.0
var _calls_seen := 0
var _tail := 0.0
var _began := false
var _probe := false
var _direct: Node = null
const RANK := {"guard": 1, "half_guard": 2, "side_control": 3, "mount": 4, "back": 5}
const PAID_KINDS := ["mount", "back", "pass", "knee_on_belly"]
const CALL_GAP_BAR_S := 15.0
const EARLY_BAR_S := 0.5
var _log_n := 0
var _open: Dictionary = {}       # the attempt whose move is playing: {who, kind, hit, pos, top, t, shown_t}
var _down := 0
var _repaid := 0
var _paid: Array = [[], []]
var _call_times: Array = []
var _early: Array = []
var _shown := ""
var _shown_t := -1.0
var _moves := 0
var _last_pts: Array = [0, 0]
var _silent := 0
var _mv: Dictionary = {}         # the move playing: where it started and whether an attempt named it
var _last_log_t := -9.0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("log="):
			_log = FileAccess.open(str(a).substr(4), FileAccess.WRITE)
			_log.store_line("frame,clock,pos,top_rules,top_drawn,hips0,hips1,head0,head1,moving,call_open,score0,score1,init,gas0,gas1,over,last")
		if str(a).begins_with("secs="):
			secs = float(str(a).substr(5))
		if str(a) == "probe=1":
			_probe = true
	root.size = Vector2i(1920, 1080)
	if OS.get_cmdline_user_args().has("direct=1"):
		# the same bout without the career in front of it (the career's road to the mats needs a picture; the ruler runs headless)
		var seed_n := 425
		for a in OS.get_cmdline_user_args():
			if str(a).begins_with("seed="):
				seed_n = int(str(a).substr(5))
		_direct = load("res://scenes/dev/GrappleBrowser.tscn").instantiate()
		_direct.set("career_match", {"athlete": load("res://scripts/rules/NoGi.gd").athlete(),
			"opp": load("res://scripts/rules/BjjOpen.gd").match_opp(load("res://scripts/rules/BjjOpp.gd").generate("white", "Passer", seed_n)),
			"seed": seed_n, "on_end": func(_res: Dictionary): pass})
		root.add_child(_direct)
		_step = 3
		return
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)


func _process(delta: float) -> bool:
	_t += delta
	_frame += 1
	match _step:
		0:
			if _t > 1.0:
				main.act("quick")
				var NoGi := load("res://scripts/rules/NoGi.gd")
				if main.career.grapplers.is_empty():
					main.career.grapplers = [NoGi.athlete()]
				main.career.cash = 20000
				var ana: Dictionary = main.career.grapplers[0]
				var d := int(NoGi.opens_after(main.career.day + 1, 1)[0]["d"])
				var why: String = load("res://scripts/state/Grapplers.gd").enter(main.career, str(ana["id"]), d)
				print("MATFILM entered day %d why='%s'" % [d, why])
				main.career.day = d - 1
				load("res://scripts/state/Clock.gd").step(main.career)
				_next()
		1:
			if _t > 0.5:
				var b: Array = load("res://scripts/state/Needs.gd").blockers(main.career)
				var need: Array = b.filter(func(n): return str(n["act"]) == "opennight")
				if need.is_empty():
					print("MATFILM FAIL no open night to go to")
					return true
				main.act("opennight", str(need[0]["arg"]))
				_next()
		2:
			if _t > 2.0:   # the open's card reads for two seconds, then "Fight it: you call the moves"
				main.act("openlive", str(main.modal["fid"]))
				_next()
		3:
			return _bout(delta)
	return false


func _next() -> void:
	_step += 1
	_t = 0.0


func _bout(delta: float) -> bool:
	var b: Node = _direct
	if b == null:
		var layer: Control = main.get("_mat_layer")
		b = layer.get_child(0) if layer.get_child_count() > 0 else null
	var m: Node = b.get_node_or_null("BeltMatch") if b != null else null
	if m == null:
		return _t > 30.0
	if not _began:
		_began = true
		print("MATFILM bout begins at movie frame %d" % _frame)
	if not _watching and b.get("player") != null and (b.get("player").get("men") as Array).size() == 2:
		_watching = true
		var men: Array = b.get("player").get("men")
		for i in 2:
			var skel := (men[i] as Node).get_parent() as Skeleton3D
			skel.skeleton_updated.connect(func():
				_hips[i] = (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips")).origin).y
				_heads[i] = (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin).y)
	var st: Dictionary = m.get("st")
	var call: Array = m.get("_call")
	if not call.is_empty():
		_call_t += delta
		if _call_t >= CALL_SHOWN_S:
			var k := _calls_seen % call.size()
			print("MATFILM call %d at %s: clicked offer %d of %d '%s' (%s)" % [_calls_seen + 1, BjjMatch.clock(float(st["t"])), k + 1,
				call.size(), str(call[k]["title"]), ", ".join(call.map(func(o): return str(o["title"])))])
			_calls_seen += 1
			_call_t = 0.0
			_call_times.append(float(st["t"]))
			m.call("_act", 0, call[k], true)
	else:
		_call_t = 0.0
	_read(m, b, st)
	if _log != null:
		var pos_c: String = BjjMatch.classify(m.call("_tags", int(b.get("current"))))
		var top: int = int(m.call("_top", pos_c))
		var drawn := -1
		if not is_nan(float(_hips[0])) and absf(float(_hips[0]) - float(_hips[1])) > 0.08:
			drawn = 0 if float(_hips[0]) > float(_hips[1]) else 1
		var mv: Dictionary = b.get("moving")
		var title := str((mv.get("t", {}) as Dictionary).get("title", "")) if not mv.is_empty() else ""
		_log.store_line(",".join([str(_frame), "%.2f" % float(st["t"]), pos_c, str(top), str(drawn),
			"%.3f" % float(_hips[0]), "%.3f" % float(_hips[1]), "%.3f" % float(_heads[0]), "%.3f" % float(_heads[1]),
			"\"%s\"" % title.replace("\"", "'").replace("\n", " "), str(call.size()), str(int(st["pts"][0])), str(int(st["pts"][1])),
			str(int(st["init"])), "%.2f" % float(st["gas"][0]), "%.2f" % float(st["gas"][1]), "1" if bool(st["over"]) else "0",
			"\"%s\"" % str(m.get("_last")).replace("\"", "'")]))
	if bool(m.get("_ended")) or _t > secs:
		_tail += delta
		if _tail >= TAIL_S or _t > secs + TAIL_S:
			print("MATFILM done t=%.1f ended=%s result=%s" % [_t, str(m.get("_ended")), str(m.call("result")) if bool(m.get("_ended")) else "-"])
			if _log != null:
				_log.close()
			_verdict()
			return true
	return false


## The ruler, one frame: what the match logged against where the bodies were before and after, and when the screen said it.
func _read(m: Node, b: Node, st: Dictionary) -> void:
	var pos_c: String = BjjMatch.classify(m.call("_tags", int(b.get("current"))))
	var top: int = int(m.call("_top", pos_c))
	var moving: bool = not (b.get("moving") as Dictionary).is_empty()
	var score: String = (m.get("_score") as Label).text
	if score != _shown:
		if _shown != "":
			_shown_t = float(st["t"])   # the new score went on screen now
		_shown = score
	if not _open.is_empty() and not moving and float(st["t"]) - float(_open["t"]) > 0.2:
		# the move has played out: where did it leave them, and how long had the screen already said so?
		if bool(_open["hit"]) and str(_open["kind"]) == "advance" and int(_open["top"]) == int(_open["who"]) and top == int(_open["who"]) 				and RANK.has(str(_open["pos"])) and RANK.has(pos_c) and int(RANK[pos_c]) < int(RANK[str(_open["pos"])]):
			_down += 1
			print("READ down at %s: %s from %s to %s, shown as a move up" % [BjjMatch.clock(float(_open["t"])), ["red", "blue"][int(_open["who"])], _open["pos"], pos_c])
		if bool(_open["hit"]) and int(_open["pts"]) > 0:
			# the new score went on screen at _shown_t; not yet on screen as the bodies arrive = not early at all
			_early.append(float(st["t"]) - _shown_t if _shown_t >= float(_open["t"]) - 0.05 else 0.0)
		_open = {}
	if moving and _mv.is_empty():
		_mv = {"pos": pos_c, "top": top, "t": float(st["t"]), "named": float(st["t"]) - _last_log_t < 0.5,
			"title": str(((b.get("moving") as Dictionary).get("t", {}) as Dictionary).get("title", ""))}
	elif not moving and not _mv.is_empty():
		var changed: bool = (pos_c != str(_mv["pos"]) and pos_c != "other" and str(_mv["pos"]) != "other") or (top != int(_mv["top"]) and top >= 0 and int(_mv["top"]) >= 0)
		if changed and not bool(_mv["named"]) and float(st["t"]) - _last_log_t > float(st["t"]) - float(_mv["t"]) + 0.5:
			_silent += 1
			print("READ silent at %s: '%s' took them from %s (top %d) to %s (top %d) and the screen named no attempt" % [
				BjjMatch.clock(float(_mv["t"])), _mv["title"], _mv["pos"], int(_mv["top"]), pos_c, top])
		_mv = {}
	var log: Array = st["log"]
	while _log_n < log.size():
		var e: Dictionary = log[_log_n]
		_log_n += 1
		_last_log_t = float(e["t"])
		if str(e["kind"]) == "hold":
			continue
		_moves += 1
		var who := int(e["who"])
		var pts := 0
		if bool(e["hit"]):
			pts = int(st["pts"][who]) - int(_last_pts[who])   # what this hit put on the board
			_last_pts[who] = int(st["pts"][who])
			if PAID_KINDS.has(str(e["kind"])):
				if pts > 0 and (_paid[who] as Array).has(str(e["kind"])):
					_repaid += 1
					print("READ repaid at %s: %s paid again for %s (+%d) with nothing landed by the other in between" % [
						BjjMatch.clock(float(e["t"])), ["red", "blue"][who], e["kind"], pts])
				if pts > 0:
					(_paid[who] as Array).append(str(e["kind"]))
			_paid[1 - who] = []   # she landed something: the other woman's positions can be paid for again
		_open = {"who": who, "kind": str(e["kind"]), "hit": bool(e["hit"]), "pos": pos_c, "top": top, "t": float(e["t"]), "pts": pts,
			"shown_t": float(st["t"])}


func _verdict() -> void:
	if not _probe:
		return
	var fails := 0
	var gap := INF
	for i in range(1, _call_times.size()):
		gap = minf(gap, float(_call_times[i]) - float(_call_times[i - 1]))
	var worst := 0.0
	var mean := 0.0
	for x in _early:
		worst = maxf(worst, float(x))
		mean += float(x) / _early.size()
	print("READ moves %d, calls at %s" % [_moves, str(_call_times.map(func(t): return BjjMatch.clock(float(t))))])
	print("%s down: %d moves down the ladder shown as a move up (bar 0)" % ["PASS" if _down == 0 else "FAIL", _down])
	print("%s repaid: %d positions paid twice (bar 0)" % ["PASS" if _repaid == 0 else "FAIL", _repaid])
	var calls_ok := _call_times.size() < 2 or gap >= CALL_GAP_BAR_S
	print("%s calls: shortest time between two calls %s s (bar %.0f)" % ["PASS" if calls_ok else "FAIL", ("%.1f" % gap) if gap < INF else "-", CALL_GAP_BAR_S])
	var early_ok := _early.is_empty() or worst <= EARLY_BAR_S
	print("%s early: the score is on screen up to %.2f s before the bodies arrive, %.2f s on average over %d scores (bar %.1f)" % [
		"PASS" if early_ok else "FAIL", worst, mean, _early.size(), EARLY_BAR_S])
	# OPEN (S425, not fixed): BeltMatch._drift plays any recording out whole when she has nothing to try. Sending those turns
	# to the family's hub instead moved the pair without a move at all and the bout ran 44-30; taken out again.
	print("%s silent: %d moves changed the position with nothing named on screen (bar 0)" % ["PASS" if _silent == 0 else "FAIL", _silent])
	for ok in [_down == 0, _repaid == 0, calls_ok, early_ok, _silent == 0]:
		if not ok:
			fails += 1
	print("MATREAD failures=%d" % fails)
	if fails > 0:
		quit(1)
