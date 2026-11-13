extends SceneTree
## KO_CONTINUES (operator, playing the build: "there is no countdown when someone is koed", "ko happenned game doesnt
## continue"): a knockout in a watched 3D round always shows the count 1 to 10 and then the fight moves on to the result.
## Each case opens Danny's bout through the game's own flow (TestJump men_fight -> Begin fight -> MainFlow -> FightView.sync)
## with the ring forced on headless (FightView.force3d; bones and words, no picture), makes the round a knockout and steps
## real frames until the result card or the frame cap.
##   last   = the game's own path: the round's closing shout settles it, then the round is made a KO before the last
##            exchange's beats are built (ExchangeBeats / RoundScript place the big shot and the count beat themselves).
##   first / middle = forced (the game only counts in a round's last exchange): the round is closed there and the shot and
##            the count beat are fired through FightView._fire, as tools/knockdown_film.gd does.
##   then=skip_fall / skip_count / skip_bout: SKIP ROUND or SKIP BOUT pressed during the fall or the count.
## One line a case: "KO_CASE <PASS|FAIL> <case>: <what was seen>". `-- trace` prints the state every second, `-- only=<i,j>`
## runs those cases (only=0,4). Ends "KO_CONTINUES failures=<n>".

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const FPS := 60
const CASE_FRAMES := FPS * 75      # the cap from the count beat to the result card (a KO takes ~25 s of it at 1x)
const SETUP_FRAMES := FPS * 60     # the cap for each wait while a case is set up
const TEN := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

const CASES := [
	{"round": "first", "ex": "last", "down": "b"},
	{"round": "first", "ex": "last", "down": "a"},
	{"round": "final", "ex": "last", "down": "b"},
	{"round": "final", "ex": "last", "down": "a"},
	{"round": "first", "ex": "first", "down": "b"},
	{"round": "first", "ex": "first", "down": "a"},
	{"round": "first", "ex": "middle", "down": "b"},
	{"round": "final", "ex": "first", "down": "a"},
	{"round": "final", "ex": "middle", "down": "a"},
	{"round": "final", "ex": "middle", "down": "b", "fast": true},
	{"round": "first", "ex": "last", "down": "b", "fast": true},
	{"round": "first", "ex": "last", "down": "b", "then": "skip_fall"},
	{"round": "first", "ex": "last", "down": "a", "then": "skip_count"},
	{"round": "final", "ex": "last", "down": "b", "then": "skip_bout"},
]

var main: Node
var view: Node
var failures := 0
var trace := false
var _frames := 0


func _initialize() -> void:
	FightView.force3d = true
	FightIntro.from_corners = true
	Engine.max_fps = FPS
	var only: Array = []
	for a in OS.get_cmdline_user_args():
		trace = trace or str(a) == "trace"
		if str(a).begins_with("only="):
			only = Array(str(a).trim_prefix("only=").split(","))
	# S419 (Claude at collect): the 14 cases take about 9 minutes of real time and CI stops at 12. The daily list runs the two
	# real-path cases (the last exchange, each boxer down); `-- all` runs every case.
	if only.is_empty() and not OS.get_cmdline_user_args().has("all"):
		only = ["0", "1"]
	for i in CASES.size():
		if not only.is_empty() and not only.has(str(i)):
			continue
		var c: Dictionary = CASES[i]
		var name := "%d round=%s exchange=%s down=%s%s%s" % [i, c["round"], c["ex"], c["down"],
			" 2x" if bool(c.get("fast", false)) else "", " then=" + str(c["then"]) if c.has("then") else ""]
		var why := await _case(c)
		if why.begins_with("ok"):
			print("KO_CASE PASS %s: %s" % [name, why.trim_prefix("ok ")])
		else:
			failures += 1
			print("KO_CASE FAIL %s: %s" % [name, why])
		await _close()
	print("KO_CONTINUES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## One case. "ok <what was seen>" or the reason it failed.
func _case(c: Dictionary) -> String:
	FightView.fast = bool(c.get("fast", false))
	paused = false
	Engine.time_scale = 1.0
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	if not TestJump.run(main, "men_fight"):
		return "setup: the men_fight jump did not reach fight night"
	main.act("fightstep", "start")
	await _wait(4)
	if main._fight_layer.get_child_count() == 0:
		return "setup: no fight view on the fight layer"
	view = main._fight_layer.get_child(0)
	_end_intro()
	if not await _until(func(): return bool(view.playing) and int(view.round_n) == 1):
		return "setup: round 1 never started"
	var total := int(view.total)
	var n := 1 if str(c["round"]) == "first" else total
	for k in range(1, n):
		var why := await _skip_to_next(k)
		if why != "":
			return why
	var m: Dictionary = main.modal
	var down := str(c["down"])
	var how := str(c["ex"])
	# Through the shouts that come before the knockout's exchange (each fights the next 30 s, as the shout bar's pick does).
	var shouts := {"first": 0, "middle": 2, "last": Exchanges.EXCHANGES - 2}
	# S459 FIGHTSEAM1: a join settles by itself (the armed call, none here); the test waits for it.
	for k in int(shouts[how]):
		var k0 := int(view._ex_done)
		_jump(float(k0) * Exchanges.EX_SECONDS)
		if not await _until(func(): return int(view._ex_done) > k0):
			return "setup: the join at %.0f s never settled" % float(view.t)
	var count_t := 0.0
	if how == "last":
		# Just short of the closing join: the test settles it itself (FightView._shouted's steps), with the settled round made a
		# knockout before its last exchange is turned into beats; _ex_done moves on, so the view never settles it twice.
		_jump(float(int(view._ex_done)) * Exchanges.EX_SECONDS - 0.05)
		Bouts.fight_step(main.career, main.career.fighter_by_id(str(view.fid)), m, "shout:|pace=steady|aim=")
		if not LiveRound.live(m).is_empty():
			return "setup: the closing shout left the round open"
		_make_ko(m, n, down)
		view._queue(m, int(view._ex_done))
		Engine.time_scale = view.pace()
		count_t = -1.0
		for b in view.beats:
			if str(b["move"]) == "count":
				count_t = float(b["t"])
		if count_t < 0.0:
			return "the round script put no count beat in a knockout round"
		_jump(count_t - 3.0)
	else:
		_jump(float(int(view._ex_done) - 1) * Exchanges.EX_SECONDS + 6.0)
		await _wait(FPS)   # a second of the exchange as it is fought
		Bouts.fight_step(main.career, main.career.fighter_by_id(str(view.fid)), m, "round_out")
		_make_ko(m, n, down)
		view._stop = "KO"
		var t0 := float(view.t)
		_jump(t0)
		var bs: Array = view.beats
		while int(view.next) < bs.size() and float(bs[int(view.next)]["t"]) < t0 + 0.35:
			view.next = int(view.next) + 1   # nothing else fires between the shot and its count
		view._fire({"t": t0, "who": "a" if down == "b" else "b", "move": "cross", "result": "lands", "big": true, "knockback": true, "caption": "", "def": ""})
		if not await _until(func(): return float(view.t) >= t0 + 0.35):
			return "setup: the round clock stopped before the count beat"
		count_t = float(view.t)
		view._fire({"t": count_t, "who": down, "move": "count", "result": "none", "big": false, "knockback": false, "caption": "", "def": ""})
	return await _watch(c, m, n, down, count_t)


## From the count beat on: what the count shows each frame, until the round card is up (or the cap).
func _watch(c: Dictionary, m: Dictionary, n: int, down: String, count_t: float) -> String:
	var kd: Node = view.kd
	var rp: Node = view.replay
	var then := str(c.get("then", ""))
	var scale0 := float(view.pace())
	var seen: Array = []          # every text the count graphic showed, in order
	var phases: Array = []
	var replays := 0
	var was_replay := false
	var pressed := false
	var last := ""
	var frames := 0
	var next_trace := 0
	while frames < CASE_FRAMES:
		await process_frame
		frames += 1
		if not is_instance_valid(view) or not is_instance_valid(kd):
			break
		var shown := str(kd.shown)
		if shown != last:
			last = shown
			if shown != "":
				seen.append(shown)
		if phases.is_empty() or str(phases[-1]) != str(kd.phase):
			phases.append(str(kd.phase))
		if rp.active() and not was_replay:
			replays += 1
		was_replay = rp.active()
		if trace and frames >= next_trace:
			next_trace += FPS
			var rec := ""
			for i in (rp.recs as Array).size():
				var ap: AnimationPlayer = view.stage.boxers[i]["ap"]
				rec += " | boxer %d clip=%s recorder active=%s influence=%.2f clock=%.2f" % [i, str(ap.current_animation), str(rp.recs[i].active), float(rp.recs[i].influence), float(rp.recs[i].clock)]
			print("  TRACE f=%d t=%.2f (count beat %.2f) playing=%s bell_left=%.2f kd.phase='%s' shown='%s' | replay active=%s _hit=%.2f _t=%.2f%s | paused=%s time_scale=%.2f | watched=%s" % [frames,
				float(view.t), count_t, str(view.playing), float(view._bell_left), str(kd.phase), shown,
				str(rp.active()), float(rp.get("_hit")), float(rp.get("_t")), rec, str(paused), Engine.time_scale, str(m.get("watched", 0))])
		if not pressed and then != "":
			if then == "skip_fall" and str(kd.phase) in ["fall", "down"] and not rp.active() and frames >= FPS / 2:
				pressed = true
				view.skip_round()
			elif then in ["skip_count", "skip_bout"] and str(kd.phase) == "count" and int(kd.top) >= 3:
				pressed = true
				if then == "skip_count": view.skip_round()
				else: view.skip_bout()
		if int(m.get("watched", 0)) >= n and not bool(view.playing):
			break
	var state := "count showed %s, phases %s, replays %d, %d frames" % [str(seen), str(phases), replays, frames]
	if not is_instance_valid(view):
		return "the fight view went away under the count; " + state
	if not (int(m.get("watched", 0)) >= n and not bool(view.playing)):
		return "the fight never moved on (cap %d frames): round t %.2f, playing %s, bell_left %.2f, kd.phase '%s', replay active %s / pending %.2f, tree paused %s, time_scale %.2f; %s" % [
			CASE_FRAMES, float(view.t), str(view.playing), float(view._bell_left), str(kd.phase), str(rp.active()), float(rp.get("_hit")), str(paused), Engine.time_scale, state]
	# The round card is up: nothing may still pause the tree or slow it a moment later (a replay cutting in late).
	var paused_after := false
	for k in FPS * 4:
		await process_frame
		paused_after = paused_after or paused
	var bad: Array = []
	if then == "":
		var numbers := seen.filter(func(s): return str(s).is_valid_int())
		if numbers != TEN:
			bad.append("the count did not show 1 to 10 in order (%s)" % str(numbers))
		if seen.is_empty() or str(seen[-1]) != "KO" or seen.find("KO") < seen.find("10"):
			bad.append("no KO after the 10")
	else:
		if not pressed:
			bad.append("the skip was never pressed")
	if paused_after or paused:
		bad.append("the tree was left paused")
	if not is_equal_approx(Engine.time_scale, 1.0):
		bad.append("Engine.time_scale left at %.2f (the menus run at 1.0; the round ran at %.1f)" % [Engine.time_scale, scale0])
	if str(kd.shown) != "" and then != "":
		bad.append("the count graphic is still up ('%s')" % str(kd.shown))
	# The result: the round card's "To the result" (FightNight) books the bout for the boxer still standing.
	if str(Bouts.stopped(m)) != "KO":
		bad.append("the bout is not a KO on the cards ('%s')" % str(Bouts.stopped(m)))
	if then != "skip_bout":
		main.act("fightstep", "end")
	await _wait(4)
	if str(m.get("step", "")) != "result":
		bad.append("the result was not reached (step '%s')" % str(m.get("step", "")))
	elif (str(m.get("outcome", "")) == "win") != (down == "b"):
		bad.append("the wrong boxer won (outcome '%s', down %s)" % [str(m.get("outcome", "")), down])
	if not bad.is_empty():
		return "; ".join(PackedStringArray(bad)) + "; " + state
	return "ok result '%s' reached, tree live, time_scale 1.0; %s" % [str(m.get("outcome", "")), state]


## The settled round n becomes a knockout of `down` (what BoutNight._counts writes for a count he does not beat).
func _make_ko(m: Dictionary, n: int, down: String) -> void:
	var r: Dictionary = (m["rounds"] as Array)[n - 1]
	r["won"] = down == "b"
	r["counts"] = 1
	r["down"] = down
	r["stopped"] = "KO"
	r["up_at"] = [10]


## Round k is skipped (SKIP ROUND) and the corner minute picks "lead": round k + 1 plays (TestJump.to_round3).
func _skip_to_next(k: int) -> String:
	view.skip_round()
	if Bouts.stopped(main.modal) != "":
		return "setup: the skipped round %d ended the bout by itself" % k
	var cm: Node = null
	for i in SETUP_FRAMES:
		await process_frame
		for ch in view.get_children():
			if ch.has_method("cue_walk_out"):
				cm = ch
		if cm != null and cm.get("ui") != null and cm.ui._card.visible:
			break
	if cm == null:
		return "setup: no corner minute after round %d" % k
	cm._pick("lead")
	cm.finish()
	if not await _until(func(): return bool(view.playing) and int(view.round_n) == k + 1):
		return "setup: round %d never started" % (k + 1)
	return ""


## The round clock to `t`: the beats before it are not played (the dull part of a 3:00 round).
func _jump(t: float) -> void:
	if t <= float(view.t):
		return
	view.t = t
	var bs: Array = view.beats
	while int(view.next) < bs.size() and float(bs[int(view.next)]["t"]) < t:
		view.next = int(view.next) + 1


func _end_intro() -> void:
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()


func _close() -> void:
	paused = false
	Engine.time_scale = 1.0
	if is_instance_valid(main):
		main.queue_free()
	main = null
	view = null
	await _wait(4)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, frames: int = SETUP_FRAMES) -> bool:
	for k in frames:
		if cond.call():
			return true
		await process_frame
	return cond.call()
