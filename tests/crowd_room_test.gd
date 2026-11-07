extends SceneTree
## S395 Crowd & Room: the sound scales with attendance, the room follows the fight, and the corner minute ducks the crowd.
## Four requirements:
##   1. Miss sound: only full-power punches that miss play a whoosh; jabs and slips stay silent.
##   2. Room by attendance: crowd bed level, room reverb, and roar scale with the bout's attendance.
##   3. Crowd follows the fight: rise on landed shots, groan on knockdown, hush in close last 10s, swell at round-end bell.
##   4. Corner minute: crowd drops under the coach's voice, comes back for "Seconds out".
## Silent: Dummy audio driver; numbers only. New sounds (crowd_groan, crowd_swell) are on the board but unheard.

const SoundBank := preload("res://scripts/audio/SoundBank.gd")
const SfxScript := preload("res://scripts/audio/Sfx.gd")
const FightSfx := preload("res://scripts/audio/FightSfx.gd")
const Attendance := preload("res://scripts/rules/Attendance.gd")

var failures := 0
var checks := 0


func _initialize() -> void:
	print("--- crowd_room_test ---")
	await process_frame
	_test_miss_sound()
	_test_room_by_attendance()
	_test_crowd_follows_fight()
	_test_corner_minute()
	print("CROWD_ROOM checks=%d failures=%d" % [checks, failures])
	if failures == 0:
		print("PASS crowd_room_test")
		quit(0)
	else:
		print("FAIL crowd_room_test (%d failures)" % failures)
		quit(1)


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("  FAIL: %s" % what)


func _silence(n: Node) -> void:
	for p: AudioStreamPlayer in n._pool:
		p.stop()
	n._cooldowns.clear()


func _delta(n: Node, was: Dictionary, id: String) -> int:
	return int(n.played.get(id, 0)) - int(was.get(id, 0))


## Step 1: the miss sound is quiet and rare - only a full-power punch that misses plays it.
func _test_miss_sound() -> void:
	var n: Node = SfxScript.ensure()
	_silence(n)
	# A jab that misses stays silent.
	var was: Dictionary = n.played.duplicate()
	FightSfx.missed(0.0, "jab")
	_check(_delta(n, was, "punch_miss") == 0, "a jab that misses stays silent (got %d)" % _delta(n, was, "punch_miss"))
	# A full-power punch that misses plays the whoosh, well under the punches.
	was = n.played.duplicate()
	FightSfx.missed(0.0, "cross")
	_check(_delta(n, was, "punch_miss") == 1, "a full-power punch that misses plays the whoosh")
	# The miss is quiet: volume_db is low (well under the punches).
	var miss_vol := SoundBank.volume_db("punch_miss")
	_check(miss_vol <= 0.0, "the miss is quiet (volume_db %.1f <= 0.0)" % miss_vol)


## Step 2: the room scales with attendance - crowd bed level, room reverb, roar.
func _test_room_by_attendance() -> void:
	var n: Node = SfxScript.ensure()
	_silence(n)
	# A hall (220 people) is single voices and a thin murmur.
	FightSfx.setup_room({"champ": 0})
	var hall_bed_offset := FightSfx._bed_offset_db
	var hall_reverb := _room_reverb_wet()
	_check(hall_bed_offset < -3.0, "a hall crowd bed is quiet (offset %.1f < -3.0)" % hall_bed_offset)
	_check(hall_reverb < 0.25, "a hall has a short dry reflection (wet < 0.25, got %.2f)" % hall_reverb)
	# An arena (12000 people) is a wall of sound.
	FightSfx.setup_room({"pro": true, "purse": 999999})
	var arena_bed_offset := FightSfx._bed_offset_db
	var arena_reverb := _room_reverb_wet()
	_check(arena_bed_offset > hall_bed_offset + 4.0, "an arena crowd bed is louder than a hall (%.1f > %.1f + 4)" % [arena_bed_offset, hall_bed_offset])
	_check(arena_reverb > hall_reverb + 0.15, "an arena has a long wide tail (wet %.2f > hall %.2f + 0.15)" % [arena_reverb, hall_reverb])
	# The roar scales: share is higher for bigger crowds.
	var hall_share := Attendance.share(220)
	var arena_share := Attendance.share(12000)
	_check(arena_share > hall_share + 0.3, "arena share is much higher than hall (%.2f > %.2f + 0.3)" % [arena_share, hall_share])


func _room_reverb_wet() -> float:
	var room_idx := AudioServer.get_bus_index("Room")
	if room_idx < 0 or AudioServer.get_bus_effect_count(room_idx) == 0:
		return 0.0
	var rev: AudioEffect = AudioServer.get_bus_effect(room_idx, 0)
	if rev is AudioEffectReverb:
		return (rev as AudioEffectReverb).wet
	return 0.0


## Step 3: the crowd follows the fight - small reactions.
func _test_crowd_follows_fight() -> void:
	var n: Node = SfxScript.ensure()
	_silence(n)
	FightSfx.setup_room({"pro": true, "purse": 5000})
	# A run of landed shots raises the crowd heat.
	FightSfx._crowd_heat = 0.0
	for i in 3:
		FightSfx.landed("jab", false)
	_check(FightSfx._crowd_heat >= 0.3, "a run of landed shots raises the crowd heat (got %.2f)" % FightSfx._crowd_heat)
	# A knockdown of the home fighter (index 0) triggers a groan reaction (new sound, unheard: check the trigger, not playback).
	var groan_before := FightSfx._reaction_count
	FightSfx.crowd_reaction("knockdown_home", 0)
	_check(FightSfx._reaction_count > groan_before, "a knockdown of the home fighter triggers a groan reaction")
	# A hush in the last 10 seconds of a close round ducks the crowd bus.
	FightSfx.setup_room({"pro": true, "purse": 5000})
	var base_crowd := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Crowd"))
	FightSfx.crowd_reaction("close_round_last10s", 0)
	await _after(0.1)
	var hushed := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Crowd"))
	_check(hushed < base_crowd - 3.0, "a close round's last 10 seconds hush the crowd (> 3 dB duck, got %.1f < %.1f - 3)" % [hushed, base_crowd])
	# A swell at the end-of-round bell triggers a swell reaction.
	var swell_before := FightSfx._reaction_count
	FightSfx.crowd_reaction("round_end", 0)
	_check(FightSfx._reaction_count > swell_before, "the round-end bell triggers a swell reaction")
	# Bigger crowds react more: arena reactions are louder than hall.
	FightSfx.setup_room({"pro": true, "purse": 999999})
	var arena_reaction := FightSfx._reaction_volume("round_end")
	FightSfx.setup_room({"champ": 0})
	var hall_reaction := FightSfx._reaction_volume("round_end")
	_check(arena_reaction > hall_reaction + 2.0, "bigger crowds react louder (arena %.1f > hall %.1f + 2)" % [arena_reaction, hall_reaction])


## Step 4: the corner minute - the crowd drops under the coach's voice, comes back for "Seconds out".
func _test_corner_minute() -> void:
	var n: Node = SfxScript.ensure()
	_silence(n)
	FightSfx.setup_room({"pro": true, "purse": 5000})
	await _after(0.6)
	var base_crowd := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Crowd"))
	# The corner minute starts: the crowd drops under the coach's voice.
	FightSfx.corner_minute(true)
	await _after(0.15)
	var ducked_crowd := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Crowd"))
	_check(ducked_crowd < base_crowd - 5.0, "the corner minute ducks the crowd (> 5 dB, got %.1f < %.1f - 5)" % [ducked_crowd, base_crowd])
	# "Seconds out": the crowd comes back.
	FightSfx.corner_minute(false)
	await _after(0.8)
	var restored_crowd := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Crowd"))
	_check(absf(restored_crowd - base_crowd) < 1.5, "the crowd comes back for 'Seconds out' (%.1f ~= %.1f)" % [restored_crowd, base_crowd])
	# S396: a big-shot duck releases to the room's level, not the default bus level.
	SfxScript.duck("Crowd", -8.0, 0.1)
	await _after(1.6)
	var after_duck := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Crowd"))
	_check(absf(after_duck - base_crowd) < 1.0, "a duck releases to the room's level (%.1f ~= %.1f)" % [after_duck, base_crowd])
	# S396: the game calls them (S395 left them test-only): the room at round 1, the duck on the corner minute.
	var view := FileAccess.get_file_as_string("res://scripts/fight3d/FightView.gd")
	var corner := FileAccess.get_file_as_string("res://scripts/fight3d/CornerMinute.gd")
	_check(view.contains("FightSfx.setup_room("), "FightView sets the room")
	_check(corner.contains("FightSfx.corner_minute(true)") and corner.contains("FightSfx.corner_minute(false)"), "the corner minute ducks and restores the crowd")


func _after(seconds: float) -> void:
	await create_timer(seconds).timeout
	await process_frame
	await process_frame
