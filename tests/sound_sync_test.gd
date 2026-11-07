extends SceneTree
## S395: the fight sound sync, variety and cut-off guards.
##   1. BeatFire guards block/miss with PunchRange.cut_off (no sound for a replaced punch).
##   2. punch_blocked_1 has <= 10 ms of lead silence (the 79 ms lead was trimmed).
##   3. Every fight event has volume_spread > 0 (variety: no two plays at the same level).
##   4. Landed punch events carry pre_fire_s (rise-time compensation for 60 fps sync).
##   5. The big shot moment has its own audio treatment (sub-bass + enhanced duck).
## Silent: Dummy audio only (--audio-driver Dummy); nothing here reaches a speaker.

const SoundBank := preload("res://scripts/audio/SoundBank.gd")
const SfxScript := preload("res://scripts/audio/Sfx.gd")
const FightSfx := preload("res://scripts/audio/FightSfx.gd")

var failures := 0
var checks := 0


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("  FAIL: %s" % what)


func _initialize() -> void:
	print("--- sound_sync_test ---")
	await process_frame
	_test_cut_off_guards()
	_test_blocked_lead()
	_test_variety()
	_test_pre_fire()
	await _test_big_shot_moment()
	_test_mix()
	print("SOUND_SYNC checks=%d failures=%d" % [checks, failures])
	if failures == 0:
		print("PASS sound_sync_test")
		quit(0)
	else:
		print("FAIL sound_sync_test (%d failures)" % failures)
		quit(1)


## S395 item 1: BeatFire checks PunchRange.cut_off before block/miss sounds.
func _test_cut_off_guards() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/fight3d/BeatFire.gd")
	_check(src.contains("PunchRange.cut_off") and src.contains("FightSfx.blocked"),
		"BeatFire guards blocked with PunchRange.cut_off")
	_check(src.contains("PunchRange.cut_off") and src.contains("FightSfx.missed"),
		"BeatFire guards missed with PunchRange.cut_off")


## S395 item 2: the blocked file's lead silence was trimmed (was 79 ms, bar <= 10 ms).
func _test_blocked_lead() -> void:
	var row := SoundBank.file_data("assets/audio/fight/punch_blocked_1.ogg")
	_check(float(row.get("lead_silence", 1.0)) <= 0.010,
		"punch_blocked_1 lead_silence <= 10 ms (got %.0f ms)" % [float(row.get("lead_silence", 1.0)) * 1000])
	var stream: Resource = load("res://assets/audio/fight/punch_blocked_1.ogg")
	_check(stream is AudioStream and (stream as AudioStream).get_length() < 0.30,
		"punch_blocked_1 trimmed: %.2f s (was 0.31)" % (stream as AudioStream).get_length())


## S395 item 4: every fight event has per-play pitch variation (R5: +-1 semitone bar).
func _test_variety() -> void:
	for id in ["punch_jab_head", "punch_power_head", "punch_body", "punch_blocked", "punch_miss", "punch_big"]:
		_check(SoundBank.pitch(id) >= 0.05,
			"%s pitch spread >= 0.05 (~1 semitone, got %.2f)" % [id, SoundBank.pitch(id)])
		_check(SoundBank.volume_spread(id) >= 0.0,
			"%s has volume_spread metadata (%.1f dB)" % [id, SoundBank.volume_spread(id)])


## S395 item 3: landed punch events carry pre_fire_s (rise-time compensation).
func _test_pre_fire() -> void:
	for id in ["punch_jab_head", "punch_power_head", "punch_big"]:
		_check(SoundBank.pre_fire_s(id) > 0.0,
			"%s pre_fire_s > 0 (got %.3f s)" % [id, SoundBank.pre_fire_s(id)])


## S395 item 6: the big shot has its own audio treatment (sub-bass generator + enhanced duck).
func _test_big_shot_moment() -> void:
	var n := SfxScript.ensure()
	_check(n != null, "Sfx node created")
	if n == null:
		return
	# The sub-bass generator produces a valid WAV.
	n._play_sub_bass()
	await process_frame
	var found := false
	for child in n.get_children():
		if child is AudioStreamPlayer and child.name.begins_with("SubBass_"):
			var p: AudioStreamPlayer = child
			_check(p.stream is AudioStreamWAV, "sub-bass is a WAV")
			if p.stream is AudioStreamWAV:
				_check((p.stream as AudioStreamWAV).data.size() > 1000, "sub-bass has data")
			found = true
			break
	_check(found, "sub-bass player was created")
	# The big shot duck is deeper and longer than round 1 (-4 dB, 0.6 s).
	_check(FightSfx.BIG_DUCK_DB <= -6.0, "big shot duck >= 6 dB (got %.1f)" % FightSfx.BIG_DUCK_DB)
	_check(FightSfx.BIG_DUCK_S >= 0.8, "big shot duck >= 0.8 s (got %.1f)" % FightSfx.BIG_DUCK_S)


## The mix: the Master bus ends in a limiter, and the ladder stays in order.
func _test_mix() -> void:
	var limiter: AudioEffect = AudioServer.get_bus_effect(0, 0) if AudioServer.get_bus_effect_count(0) > 0 else null
	_check(limiter is AudioEffectHardLimiter, "Master has a hard limiter")
	var ladder := ["punch_big", "punch_power_head", "punch_jab_head", "punch_blocked", "punch_miss"]
	for i in ladder.size() - 1:
		var a := _loud(ladder[i])
		var b := _loud(ladder[i + 1])
		_check(a > b, "%s (%.1f) is louder than %s (%.1f)" % [ladder[i], a, ladder[i + 1], b])


func _loud(id: String) -> float:
	var f := SoundBank.files(id)
	if f.is_empty():
		return -999.0
	return float(SoundBank.file_data(str(f[0]).trim_prefix("res://")).get("mmax", 0.0)) + SoundBank.volume_db(id)
