extends SceneTree
## S385 Round 1, rewritten S390 for the operator's final sound set (the first version asked for variants, layers and .wav files
## the set does not have, so it never passed). What it holds:
##   1. the final set: 13 events, one kept file each, every file loads; an unheard or dropped row cannot play.
##   2. levels: the short punches sit on their R12 class, the peak stays inside the Master limiter's reach, the ladder holds.
##   3. Sfx: buses, limiter, volume and pitch from the manifest, cooldown, voice priority, relative ducks, the looped bed.
##   4. FightSfx: each fight word -> its one event, at its time.
##   5. the code: every id any script plays is a kept row, and the hooks are in place.
## Silent: Dummy audio only (--audio-driver Dummy); nothing here reaches a speaker. No ear checks are possible: numbers only.

const SoundBank := preload("res://scripts/audio/SoundBank.gd")
const SfxScript := preload("res://scripts/audio/Sfx.gd")
const FightSfx := preload("res://scripts/audio/FightSfx.gd")
const FightVoice := preload("res://scripts/audio/FightVoice.gd")
const UI := preload("res://scripts/ui/UI.gd")

## Round 0 keeps 1,3,4,6,7,8,9,10 plus the round 1 picks punch_power_head_2, punch_miss_4, knockdown_fall_4, footwork_canvas_2, ui_click_2.
const FINAL := {"punch_jab_head": "fight/punch_jab_head_1", "punch_body": "fight/punch_body_1", "punch_blocked": "fight/punch_blocked_1",
	"punch_big": "fight/punch_big_1", "bell_round_start": "fight/bell_round_start_1", "bell_round_end": "fight/bell_round_end_1",
	"crowd_arena_loop": "crowd/crowd_arena_loop_1", "crowd_roar": "crowd/crowd_roar_1", "punch_power_head": "fight/punch_power_head_2",
	"punch_miss": "fight/punch_miss_4", "knockdown_fall": "fight/knockdown_fall_4", "footwork_canvas": "fight/footwork_canvas_2",
	"ui_click": "ui/ui_click_2"}
## SOUND_BENCHMARK R12: the punches' loudness classes.
const CLASS := {"punch_jab_head": -19.0, "punch_power_head": -17.0, "punch_body": -18.0, "punch_blocked": -21.0, "punch_big": -14.0}
const PEAK_MAX_DB := 2.0   # into the -1 dB limiter, at most the 3 dB audio_prep allows off a transient
const FULL_POWER := ["punch_big", "knockdown_fall"]   # played at power 1.0 (+2 dB); the rest at neutral

var failures := 0
var checks := 0


func _initialize() -> void:
	print("--- sound_bank_test ---")
	await process_frame   # the root enters the tree after _initialize begins: voices only play inside it
	_test_final_set()
	_test_levels()
	await _test_sfx()
	await _test_fightsfx()
	await _test_announcer_crowd()
	_test_code()
	print("SOUND_BANK checks=%d failures=%d" % [checks, failures])
	if failures == 0:
		print("PASS sound_bank_test")
		quit(0)
	else:
		print("FAIL sound_bank_test (%d failures)" % failures)
		quit(1)


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("  FAIL: %s" % what)


func _test_final_set() -> void:
	var evts: Array = SoundBank.events()
	# S395: new sounds may be on the board but unheard (no kept files yet); the set has at least FINAL.size() events.
	_check(evts.size() >= FINAL.size(), "the set has at least %d events (got %d)" % [FINAL.size(), evts.size()])
	for id in FINAL:
		var want := "res://assets/audio/%s.ogg" % FINAL[id]
		var fl: Array = SoundBank.files(id)
		_check(fl == [want], "%s plays exactly %s (got %s)" % [id, want, fl])
		_check(SoundBank.kept(want), "%s is heard and kept" % want)
		_check(FileAccess.file_exists(want + ".import"), "%s has its import sidecar: a clean checkout loads it" % want)
		var stream: Resource = load(want)
		_check(stream is AudioStream, "%s loads as an AudioStream" % want)
		if stream is AudioStream:
			var dur := float(SoundBank.file_data(want.trim_prefix("res://")).get("dur", 0.0))
			_check(absf((stream as AudioStream).get_length() - dur) < 0.06, "%s is the measured file: %.2f s vs %.2f s" % [want, (stream as AudioStream).get_length(), dur])
		_check(SoundBank.bus(id) in SoundBank.VALID_BUSES, "%s bus '%s' is valid" % [id, SoundBank.bus(id)])
	var kept := 0
	for rel in SoundBank.all_file_data():
		var row: Dictionary = SoundBank.all_file_data()[rel]
		# S440: unheard rows are allowed (S438's 26 voices wait on the sound board); a KEPT row must have been heard.
		if str(row.get("verdict", "")) == "keep":
			_check(row.get("heard") == true, "%s is kept, so it was heard" % rel)
			if not rel.begins_with("assets/audio/voice/"):
				kept += 1
	_check(kept == FINAL.size(), "%d sound-effect rows are kept (got %d)" % [FINAL.size(), kept])
	# S440 his ear: the announcer (15) and the corner's shouts (8) kept; the between-rounds voice (3) not.
	var voices_kept := 0
	for rel in SoundBank.all_file_data():
		if rel.begins_with("assets/audio/voice/") and SoundBank.kept("res://" + rel):
			voices_kept += 1
	_check(voices_kept == 23, "23 voice lines are kept (got %d)" % voices_kept)
	_check(not SoundBank.kept("res://assets/audio/voice/between/between_long.ogg"), "the between-rounds voice is not kept")
	# An unheard row in the manifest still cannot play.
	var evs: Dictionary = SoundBank._data["events"]
	evs["planted"] = {"bus": "SFX", "files": ["res://assets/audio/fight/punch_miss_1.ogg"]}
	_check(SoundBank.has("planted") and SoundBank.files("planted").is_empty(), "a dropped file is not served")
	_check(not SfxScript.play("planted"), "and Sfx refuses it")
	evs.erase("planted")


func _test_levels() -> void:
	for id in FINAL:
		var row := SoundBank.file_data(("res://assets/audio/%s.ogg" % FINAL[id]).trim_prefix("res://"))
		var vol := SoundBank.volume_db(id)
		var bus_db: float = SfxScript.BUS_DEFS.get(SoundBank.bus(id), 0.0)
		var tp := float(row["tp"])
		if CLASS.has(id):
			var want := minf(float(CLASS[id]) - float(row["mmax"]), PEAK_MAX_DB - bus_db - tp)
			_check(absf(vol - want) <= 0.051, "%s volume_db %.1f = its class, peak-capped (want %.1f)" % [id, vol, want])
		else:
			_check(vol == 0.0, "%s stays as heard (volume_db %.1f)" % [id, vol])
		var peak := tp + vol + bus_db + (2.0 if id in FULL_POWER else 0.0)
		_check(peak <= PEAK_MAX_DB + 0.001, "%s peak %.1f dB into the limiter <= %.1f" % [id, peak, PEAK_MAX_DB])
	var power := _loud("punch_power_head")
	_check(absf(power - -17.0) < 0.05, "punch_power_head reads -17 (got %.1f; the file alone is -23.5)" % power)
	var ladder := ["punch_big", "punch_power_head", "punch_jab_head", "punch_blocked", "punch_miss"]
	for i in ladder.size() - 1:
		_check(_loud(ladder[i]) > _loud(ladder[i + 1]), "%s (%.1f) is louder than %s (%.1f)" % [ladder[i], _loud(ladder[i]), ladder[i + 1], _loud(ladder[i + 1])])
	_check(_loud("punch_body") > _loud("punch_blocked") and _loud("punch_body") < _loud("punch_power_head"), "the body shot sits between a block and a power punch (%.1f)" % _loud("punch_body"))
	var hard := SoundBank.intensity(0.9)
	var soft := SoundBank.intensity(0.2)
	_check(float(hard["volume_db"]) > float(soft["volume_db"]) and float(hard["pitch_scale"]) < float(soft["pitch_scale"]), "harder = louder and lower")
	var flat := SoundBank.intensity(SoundBank.NEUTRAL)
	_check(is_zero_approx(float(flat["volume_db"])) and is_equal_approx(float(flat["pitch_scale"]), 1.0), "neutral power leaves a file as heard")


func _loud(id: String) -> float:
	return float(SoundBank.file_data(("res://assets/audio/%s.ogg" % FINAL[id]).trim_prefix("res://"))["mmax"]) + SoundBank.volume_db(id)


func _voice_of(n: Node, id: String) -> AudioStreamPlayer:
	var want: String = SoundBank.files(id)[0]
	for p: AudioStreamPlayer in n._pool:
		if p.playing and p.stream != null and p.stream.resource_path == want:
			return p
	return null


func _silence(n: Node) -> void:
	for p: AudioStreamPlayer in n._pool:
		p.stop()
	n._cooldowns.clear()


func _test_sfx() -> void:
	var n: Node = SfxScript.ensure()
	_check(n != null, "Sfx.ensure() returns a node")
	if n == null:
		return
	_check(n.process_mode == Node.PROCESS_MODE_ALWAYS, "Sfx runs through the replay's pause")
	for bname in SfxScript.BUS_DEFS:
		var idx := AudioServer.get_bus_index(bname)
		_check(idx >= 0, "%s bus exists" % bname)
		_check(is_equal_approx(AudioServer.get_bus_volume_db(idx), SfxScript.BUS_DEFS[bname]), "%s bus at its mix level" % bname)
	_check(AudioServer.get_bus_effect_count(AudioServer.get_bus_index("Room")) > 0, "Room has reverb effect")
	var limiter: AudioEffect = AudioServer.get_bus_effect(0, 0) if AudioServer.get_bus_effect_count(0) > 0 else null
	_check(limiter is AudioEffectHardLimiter and is_equal_approx(limiter.ceiling_db, -1.0), "Master ends in a -1 dB hard limiter")
	# Every one-shot reaches a voice with the manifest's level, bus and pitch spread.
	for id in FINAL:
		if SoundBank.is_loop(id):
			continue
		_check(SfxScript.play(id), "Sfx.play('%s') returns true" % id)
		var p := _voice_of(n, id)
		_check(p != null, "%s is playing on a voice" % id)
		if p != null:
			_check(is_equal_approx(p.volume_db, SoundBank.volume_db(id)), "%s plays at volume_db %.1f (got %.1f)" % [id, SoundBank.volume_db(id), p.volume_db])
			_check(p.bus == SoundBank.bus(id), "%s plays on %s" % [id, SoundBank.bus(id)])
			_check(absf(p.pitch_scale - 1.0) <= SoundBank.pitch(id) + 0.001, "%s pitch %.3f inside its spread" % [id, p.pitch_scale])
	_check(not SfxScript.play("no_such_sound"), "Sfx.play('no_such_sound') returns false")
	_check(not SfxScript.play("crowd_roar"), "crowd_roar cooldown blocks an immediate replay")
	_silence(n)
	# A click must not move the global sequence the game's rolls read.
	seed(7)
	var clean := randf()
	seed(7)
	SfxScript.play("ui_click")
	_check(randf() == clean, "a sound leaves the global rng where it was")
	_silence(n)
	# Priority: a full pool of big shots turns a whiff away; the next big shot takes the oldest voice.
	for i in SfxScript.POOL_SIZE:
		SfxScript.play("punch_big")
	var before: int = n.played.get("punch_miss", 0)
	SfxScript.play("punch_miss")
	_check(int(n.played.get("punch_miss", 0)) == before, "a miss never steals a big shot's voice")
	var big_before: int = n.played["punch_big"]
	SfxScript.play("punch_big")
	_check(int(n.played["punch_big"]) == big_before + 1, "a big shot takes a voice from an equal")
	_silence(n)
	SfxScript.play("footwork_canvas")
	for i in SfxScript.POOL_SIZE - 1:
		SfxScript.play("punch_big")
	SfxScript.play("punch_body")
	_check(_voice_of(n, "footwork_canvas") == null and _voice_of(n, "punch_body") != null, "a landed punch steals the footstep's voice")
	_silence(n)
	# Ducks are relative to the bus's mix level, and overlaps come back to it.
	var crowd := AudioServer.get_bus_index("Crowd")
	SfxScript.duck("Crowd", -4.0, 0.5)
	await _after(0.15)
	_check(absf(AudioServer.get_bus_volume_db(crowd) - -16.0) < 0.1, "a -4 dB duck takes Crowd from -12 to -16 (got %.1f)" % AudioServer.get_bus_volume_db(crowd))
	SfxScript.duck("Crowd", -11.0, 0.5)
	await _after(0.15)
	_check(absf(AudioServer.get_bus_volume_db(crowd) - -23.0) < 0.1, "the newest duck takes over at -23 (got %.1f)" % AudioServer.get_bus_volume_db(crowd))
	await _after(1.2)
	_check(is_equal_approx(AudioServer.get_bus_volume_db(crowd), -12.0), "overlapping ducks end back at -12 (got %.1f)" % AudioServer.get_bus_volume_db(crowd))
	# The bed loops, once, at the manifest's level, and stops.
	SfxScript.loop("crowd_arena_loop")
	SfxScript.loop("crowd_arena_loop")
	var bed: AudioStreamPlayer = n._loops.get("crowd_arena_loop")
	_check(bed != null and bed.playing, "the crowd bed plays")
	if bed != null:
		_check(bed.stream is AudioStreamOggVorbis and (bed.stream as AudioStreamOggVorbis).loop, "the crowd bed really loops")
		_check(bed.bus == "Crowd", "the bed is on the Crowd bus")
		_check(int((n._loop_players as Array).filter(func(p): return p.playing).size()) == 1, "a second call starts no second bed")
		SfxScript.stop("crowd_arena_loop", 0.05)
		await _after(0.3)
		_check(not bed.playing, "the bed stops")
		_check(not n._loops.has("crowd_arena_loop"), "and a new bout can start it again")


func _test_fightsfx() -> void:
	var n: Node = SfxScript.ensure()
	_silence(n)
	for m in ["cross", "lead_hook", "rear_hook", "lead_uppercut", "rear_uppercut"]:
		_check(FightSfx.resolve_move(m) == "punch_power_head", "%s reads as a power punch" % m)
	_check(FightSfx.resolve_move("jab") == "punch_jab_head", "a jab reads as a jab")
	_check(FightSfx.resolve_move("body_hook") == "punch_body", "a body hook reads as a body shot")
	var was: Dictionary = n.played.duplicate()
	FightSfx.landed("jab", false)
	FightSfx.landed("cross", false)
	FightSfx.landed("body_hook", false)
	_check(_delta(n, was, "punch_jab_head") == 1 and _delta(n, was, "punch_power_head") == 1 and _delta(n, was, "punch_body") == 1, "each landed punch plays its own event")
	_check(_delta(n, was, "punch_big") == 0, "a normal punch is no big shot")
	# The big shot plays alone, and a knockdown on it gives one roar.
	was = n.played.duplicate()
	FightSfx.landed("cross", true)
	_check(_delta(n, was, "punch_big") == 1 and _delta(n, was, "punch_power_head") == 0, "the big shot replaces the power punch")
	FightSfx.knockdown(0.0)
	_check(_delta(n, was, "knockdown_fall") == 1, "the knockdown thuds")
	await _after(FightSfx.ROAR_AFTER_S + 0.15)
	_check(_delta(n, was, "crowd_roar") == 1, "one roar for a big shot and its fall (got %d)" % _delta(n, was, "crowd_roar"))
	# A delayed sound waits for the contact.
	was = n.played.duplicate()
	FightSfx.blocked(0.1)
	FightSfx.missed(0.1)
	_check(_delta(n, was, "punch_blocked") == 0 and _delta(n, was, "punch_miss") == 0, "a block and a miss wait for the contact")
	await _after(0.2)
	_check(_delta(n, was, "punch_blocked") == 1 and _delta(n, was, "punch_miss") == 1, "and then play")
	was = n.played.duplicate()
	FightSfx.step()
	FightSfx.bell(true)
	_check(_delta(n, was, "footwork_canvas") == 1 and _delta(n, was, "bell_round_start") == 1, "a step and the opening bell play")
	_check(n._loops.has("crowd_arena_loop"), "the first bell starts the crowd")
	FightSfx.bell(false)
	_check(_delta(n, was, "bell_round_end") == 1, "the closing bell plays")
	_check(n._loops.has("crowd_arena_loop"), "the crowd stays through the corner")
	FightSfx.crowd_off()
	_check(not n._loops.has("crowd_arena_loop"), "the crowd leaves with the fight view")
	FightSfx.big_shot_ahead(0.3)
	await _after(0.15)
	var crowd := AudioServer.get_bus_index("Crowd")
	_check(absf(AudioServer.get_bus_volume_db(crowd) - -23.0) < 0.1, "the hush before the big shot is -11 dB under the mix (got %.1f)" % AudioServer.get_bus_volume_db(crowd))


## A timer fires before the frame's tweens step: two more frames let a ramp finish however slow the frame was.
func _after(seconds: float) -> void:
	await create_timer(seconds).timeout
	await process_frame
	await process_frame


func _delta(n: Node, was: Dictionary, id: String) -> int:
	return int(n.played.get(id, 0)) - int(was.get(id, 0))


## Every id a script hands to Sfx is a kept row; anything but a literal is FightSfx's own lookup, tested above.
## S440 his "i want to hear the announcer mixed with the arena crowd": the bed starts with the first announcer line (not
## the first bell), a name gets the roar after the line, "Seconds out" does not.
func _test_announcer_crowd() -> void:
	SfxScript.stop("crowd_arena_loop", 0.0)
	var n = SfxScript.ensure()
	_check(n != null and not n._loops.has("crowd_arena_loop"), "the bed is off before the walk-in")
	await create_timer(2.1).timeout   # crowd_roar has a 2 s cooldown; the checks above just played it
	var roars := int(n.played.get("crowd_roar", 0))
	_check(FightVoice.intro_opening(), "the kept opening line plays")
	_check(n._loops.has("crowd_arena_loop"), "the arena crowd runs under the announcer's opening")
	var pa := AudioServer.get_bus_index("PA")
	_check(SoundBank.bus("voice_announcer_opening") == "PA" and pa >= 0 and AudioServer.get_bus_effect_count(pa) == 6, "the announcer plays through the PA bus: filters, horn bite, squeeze, slap, hall (C312)")
	var dur := FightSfx.line_seconds("voice_announcer_opening")
	_check(absf(dur - 4.127) < 0.01, "the duck lasts the line (%.3f s)" % dur)
	await create_timer(dur + 0.3).timeout
	_check(int(n.played.get("crowd_roar", 0)) == roars + 1, "the crowd roars once the opening line ends")
	var r2 := int(n.played.get("crowd_roar", 0))
	_check(FightVoice.intro_seconds_out(), "the kept Seconds out plays")
	await create_timer(FightSfx.line_seconds("voice_announcer_seconds") + 0.3).timeout
	_check(int(n.played.get("crowd_roar", 0)) == r2, "no roar after Seconds out (the bell answers it)")
	SfxScript.stop("crowd_arena_loop", 0.0)


func _test_code() -> void:
	var call := RegEx.create_from_string("\\bSfx\\.(play|loop|stop)\\(([^,)]*)")
	var seen := {}
	for path in _gd_files("res://scripts"):
		for line in FileAccess.get_file_as_string(path).split("\n"):
			if line.strip_edges().begins_with("#"):
				continue
			for m in call.search_all(line):
				var arg := m.get_string(2).strip_edges()
				if arg.begins_with("\""):
					var id := arg.trim_prefix("\"").trim_suffix("\"")
					seen[id] = true
					# S395: new sounds may be on the board but unheard (no kept files yet); they're in the manifest.
					_check(SoundBank.has(id), "%s plays '%s': a known event" % [path, id])
				else:
					_check(path.ends_with("FightSfx.gd") and arg.begins_with("resolve_move("), "%s plays a computed id (%s)" % [path, arg])
	print("SOUND_IDS played by the code: %s" % str(seen.keys()))
	_check(seen.size() >= 10, "the scan saw the code's calls (%d ids)" % seen.size())
	var was: int = SfxScript.ensure().played.get("ui_click", 0)
	UI.button("Press", "Btn", func() -> void: pass).pressed.emit()
	_check(int(SfxScript.ensure().played.get("ui_click", 0)) == was + 1, "a UI.button press clicks")
	var hooks := {"res://scripts/ui/UI.gd": ["Sfx.play(\"ui_click\")"], "res://scripts/ui/FlipCard.gd": ["Sfx.play(\"ui_click\")"],
		"res://scripts/ui/modals/PosterReveal.gd": ["Sfx.play(\"knockdown_fall\")"],
		"res://scripts/fight3d/HitImpact.gd": ["FightSfx.landed(move, big)"],
		"res://scripts/fight3d/BeatFire.gd": ["FightSfx.blocked()", "FightSfx.missed(", "FightSfx.step()", "FightSfx.knockdown(", "FightSfx.big_shot_ahead(at)"],
		"res://scripts/fight3d/FightView.gd": ["FightSfx.bell(true)", "FightSfx.bell(false)", "FightSfx.crowd_off()"],
		"res://scripts/fight3d/FightCast.gd": ["FightSfx.bell(true)"]}
	for path in hooks:
		var src := FileAccess.get_file_as_string(path)
		for hook in hooks[path]:
			_check(src.contains(hook), "%s has %s" % [path, hook])
	var impact := FileAccess.get_file_as_string("res://scripts/fight3d/HitImpact.gd")
	_check(impact.find("if was_cut:") < impact.find("FightSfx.landed"), "a punch cut off before contact stays silent")


func _gd_files(dir: String) -> Array:
	var out: Array = []
	for f in DirAccess.get_files_at(dir):
		if f.ends_with(".gd"):
			out.append(dir.path_join(f))
	for d in DirAccess.get_directories_at(dir):
		out.append_array(_gd_files(dir.path_join(d)))
	return out
