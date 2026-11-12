extends SceneTree
## S440 (his C312/C313): records what the GAME's mixer plays - the announcer through the PA bus over the arena crowd,
## then the corner's between-rounds lines under the corner duck - into a WAV, so the review board carries the real mix.
##   godot --headless --path . --script res://tools/announcer_preview.gd -- out=<file.wav> [part=announcer|corner]
## The Dummy driver still mixes (AudioEffectRecord on Master reads the mix). Unkept lines are forced on for the preview only.

const Sfx := preload("res://scripts/audio/Sfx.gd")
const SoundBank := preload("res://scripts/audio/SoundBank.gd")
const FightSfx := preload("res://scripts/audio/FightSfx.gd")
const FightVoice := preload("res://scripts/audio/FightVoice.gd")


func _initialize() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		var kv := a.split("=", true, 1)
		if kv.size() == 2:
			args[kv[0]] = kv[1]
	var out := str(args.get("out", "user://announcer_preview.wav"))
	var part := str(args.get("part", "announcer"))
	await process_frame
	var n = Sfx.ensure()
	# The between-rounds lines are unheard: let the preview play them (in memory only, never saved).
	for rel in SoundBank.all_file_data():
		if str(rel).begins_with("assets/audio/voice/between/"):
			SoundBank.all_file_data()[rel]["heard"] = true
			SoundBank.all_file_data()[rel]["verdict"] = "keep"
	var rec := AudioEffectRecord.new()
	AudioServer.add_bus_effect(0, rec)
	rec.set_recording_active(true)
	FightSfx.setup_room({"champ": 9})   # the biggest room: an arena
	if part == "announcer":
		await create_timer(1.0).timeout
		FightVoice.intro_opening()
		await create_timer(FightSfx.line_seconds("voice_announcer_opening") + 2.6).timeout
		FightVoice.intro_corner("red", 1)
		await create_timer(FightSfx.line_seconds("voice_announcer_red_1") + 2.6).timeout
		FightVoice.intro_corner("blue", 1)
		await create_timer(FightSfx.line_seconds("voice_announcer_blue_1") + 2.6).timeout
		FightVoice.intro_seconds_out()
		await create_timer(FightSfx.line_seconds("voice_announcer_seconds") + 0.3).timeout
		FightSfx.bell(true)
		await create_timer(4.0).timeout
		FightVoice.intro_result("decision", "red")
		await create_timer(FightSfx.line_seconds("voice_announcer_red_decision") + 5.5).timeout
	else:
		Sfx.loop("crowd_arena_loop")
		await create_timer(2.0).timeout
		FightSfx.bell(false)
		await create_timer(1.0).timeout
		FightSfx.corner_minute(true)
		for id in ["voice_between_long", "voice_between_body", "voice_between_calm"]:
			await create_timer(0.8).timeout
			Sfx.play(id)
			await create_timer(FightSfx.line_seconds(id) + 0.6).timeout
		FightSfx.corner_minute(false)
		await create_timer(2.5).timeout
	rec.set_recording_active(false)
	var wav: AudioStreamWAV = rec.get_recording()
	if wav == null or wav.data.size() == 0:
		print("PREVIEW FAIL: nothing recorded")
		quit(1)
		return
	wav.save_to_wav(out)
	print("PREVIEW %s %.1f s -> %s" % [part, float(wav.data.size()) / float(wav.mix_rate * (4 if wav.stereo else 2)), out])
	quit(0)
