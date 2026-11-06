extends SceneTree
## S390 the sound hooks in a real bout: the tools/body_react_probe.gd flow (fresh career -> fight night -> Begin fight, every shout and
## corner answered) for ROUNDS rounds, then leave the fight. Sfx.played against what the fight showed:
##   every id played is a kept row; landed sounds = the punches that showed (FightStage.hit_gaps, not cut off); one opening bell a
##   round, one closing bell a round that rang; the crowd bed started, ran through the replay's pause, and stopped when the view left;
##   a forced knockdown thuds once; the poster thumps once.
## Silent and headless. It proves the calls fire at the right beats, not how they sound: only the operator can judge that.
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/sound_fight_probe.gd -- show3d

const Bouts := preload("res://scripts/state/Bouts.gd")
const SoundBank := preload("res://scripts/audio/SoundBank.gd")
const SfxScript := preload("res://scripts/audio/Sfx.gd")
const PosterReveal := preload("res://scripts/ui/modals/PosterReveal.gd")

const ROUNDS := 2
const TIMEOUT_S := 400.0
const PUNCH_IDS := ["punch_jab_head", "punch_power_head", "punch_body", "punch_big"]

var main: Node
var view: Node
var picked := {}
var fails := 0
var _clock := 0.0
var _begun := false
var _left := false
var _playing_round := 0
var _rounds_done := 0
var _landed := 0
var _cut := 0
var _forced := false
var _falls_before := 0
var _replay_seen := false
var _bed_paused := false


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
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
	main.act("accept", str(offer["id"]))
	await _poster(str(f["id"]))
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
	if main.modal.is_empty() or str(main.modal.get("type", "")) != "fight":
		print("SOUND_PROBE_FAIL no fight modal after fightnight")
		quit(1)
		return
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	await _wait(2)
	if view == null:
		print("SOUND_PROBE_FAIL no fight view: run with `-- show3d`")
		quit(1)
		return
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	await _wait(2)
	_begun = true


## PosterReveal.finish on a stand-in picture (a headless run has no render to cut): one thump, however often it is called.
func _poster(fid: String) -> void:
	var was: int = _plays("knockdown_fall")
	var p: Control = PosterReveal.new()
	p._main = main
	p._fid = fid
	p._size = Vector2(64, 96)
	p._tex = ImageTexture.create_from_image(Image.create(8, 8, false, Image.FORMAT_RGBA8))
	p._board = Control.new()
	p.add_child(p._board)
	root.add_child(p)
	await _wait(2)
	p.finish()
	p.finish()
	_bar(_plays("knockdown_fall") == was + 1, "the poster thumps once (%d)" % (_plays("knockdown_fall") - was))
	p.queue_free()


func _process(delta: float) -> bool:
	_clock += delta
	if _clock > TIMEOUT_S:
		print("SOUND_PROBE_FAIL timeout, %d rounds done" % _rounds_done)
		_report()
		return true
	if not _begun or _left:
		return false
	_count()
	_force_count()
	if view.replay != null and view.replay.active():
		var bed: AudioStreamPlayer = SfxScript.ensure()._loops.get("crowd_arena_loop")
		_replay_seen = true
		_bed_paused = _bed_paused or bed == null or not bed.playing or bed.stream_paused
	if bool(view.playing):
		_playing_round = int(view.round_n)
	elif _playing_round > 0:
		_rounds_done = maxi(_rounds_done, _playing_round)
		_playing_round = 0
	if _rounds_done >= ROUNDS or str(view.get("_stop")) != "":
		_leave()
		return false
	_drive()
	return false


## A short bout may hold no knockdown: round 2 fires one count beat through the real BeatFire, after a landed punch, so the fall,
## its thud and the replay's pause all run.
func _force_count() -> void:
	if _forced or int(view.round_n) != ROUNDS or not bool(view.playing) or float(view.t) < 6.0:
		return
	_forced = true
	_falls_before = _plays("knockdown_fall")
	view._beat.fire(view, {"who": "b", "move": "count"})


func _count() -> void:
	for row in (view.stage.hit_gaps as Array):
		var d: Dictionary = row
		if d.has("_sound"):
			continue
		d["_sound"] = true
		if bool(d.get("cut", false)):
			_cut += 1
		else:
			_landed += 1


## Out of the fight: the view leaves the tree, and the bed must go with it.
func _leave() -> void:
	_left = true
	var n: Node = SfxScript.ensure()
	_bar(n._loops.has("crowd_arena_loop"), "the crowd bed is on until the fight is left")
	view.skip_bout()
	main.close_modal()
	main.get_tree().create_timer(1.0).timeout.connect(_finish)


func _finish() -> void:
	_report()
	quit(1 if fails > 0 else 0)


func _report() -> void:
	var n: Node = SfxScript.ensure()
	var played: Dictionary = n.played
	print("SOUND_PROBE played %s" % str(played))
	print("SOUND_PROBE rounds %d, punches shown %d, cut off %d" % [_rounds_done, _landed, _cut])
	for id in played:
		_bar(not SoundBank.files(str(id)).is_empty(), "%s is a kept row" % id)
	var sounded := 0
	for id in PUNCH_IDS:
		sounded += int(played.get(id, 0))
	_bar(_landed > 0 and sounded == _landed, "every punch that showed sounded once: %d sounds, %d shown" % [sounded, _landed])
	_bar(int(played.get("bell_round_start", 0)) >= _rounds_done and int(played.get("bell_round_start", 0)) <= _rounds_done + 1, "one opening bell a round (%d)" % int(played.get("bell_round_start", 0)))
	_bar(int(played.get("bell_round_end", 0)) >= 1, "the closing bell rang (%d)" % int(played.get("bell_round_end", 0)))
	_bar(int(played.get("punch_blocked", 0)) + int(played.get("punch_miss", 0)) > 0, "blocks and misses sounded")
	_bar(int(played.get("footwork_canvas", 0)) > 0, "the feet sounded")
	_bar(int(played.get("crowd_arena_loop", 0)) == 1, "one crowd bed for the bout (%d)" % int(played.get("crowd_arena_loop", 0)))
	_bar(_forced and _plays("knockdown_fall") == _falls_before + 1, "the forced knockdown thudded once (%d)" % (_plays("knockdown_fall") - _falls_before))
	_bar(_replay_seen and not _bed_paused, "the crowd bed ran on through the replay's pause (replay seen %s)" % str(_replay_seen))
	_bar(not n._loops.has("crowd_arena_loop"), "the crowd left with the fight view")
	for p: AudioStreamPlayer in n._loop_players:
		_bar(not p.playing, "%s is silent under the menus" % p.name)
	print("SOUND_PROBE fails=%d" % fails)


func _bar(ok: bool, what: String) -> void:
	print("%s %s" % ["SOUND_PROBE ok  " if ok else "SOUND_PROBE FAIL", what])
	fails += 0 if ok else 1


func _plays(id: String) -> int:
	return int(SfxScript.ensure().played.get(id, 0))


## body_react_probe's driver: every shout and corner minute answered.
func _drive() -> void:
	if not is_instance_valid(view) or not view.is_inside_tree():
		return
	var bar: Node = view.get("_shouting")
	if bar != null and is_instance_valid(bar):
		if not picked.has(bar.get_instance_id()):
			picked[bar.get_instance_id()] = true
			if bar.has_method("_set_aim"):
				bar.call("_set_aim", "body")
			bar.call("_pick", "body" if bar.find_child("Shout_body", true, false) != null else "")
		return
	if bool(view.playing):
		return
	for ch in view.get_children():
		if not ch.has_method("cue_walk_out"):
			continue
		if picked.has(ch.get_instance_id()):
			return
		var ui: Node = ch.get("ui")
		var card: Node = ui.get("_card") if ui != null else null
		if card == null or not bool(card.get("visible")):
			return
		picked[ch.get_instance_id()] = true
		ch.call("_pick", "body")
		ch.call("finish")


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
