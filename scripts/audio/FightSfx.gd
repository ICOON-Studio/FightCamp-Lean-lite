extends RefCounted
## S385 Round 1, ported S390: the fight's words -> sound events. Static, no nodes.
## The fight scripts call these (docs/audio/FIGHT_HOOKS.md). Only events with a kept row in sounds.json appear here:
## clinch, the count, the corner bed and the crowd swell come back when the operator has kept a sound for them.
## S395: miss sound is quiet and rare (power punches only); the room scales with attendance; the crowd follows the fight;
## the corner minute ducks the crowd under the coach's voice.

const Sfx := preload("res://scripts/audio/Sfx.gd")
const SoundBank := preload("res://scripts/audio/SoundBank.gd")
const Attendance := preload("res://scripts/rules/Attendance.gd")

const ROAR_AFTER_S := 0.22    # the crowd answers a beat after the big shot and the fall
const BIG_DUCK_DB := -8.0     # S395: deeper duck under the big shot (was -4); the slow-mo moment needs room
const BIG_DUCK_S := 1.0       # S395: matches FightCalls.HOLD_S (the ring is slow for 1 s)
const HUSH_DB := -11.0        # R8: near-silence before the round's big shot
const CORNER_DUCK_DB := -8.0  # S395: the crowd drops under the coach's voice
const CORNER_RESTORE_S := 0.5 # S395: the crowd comes back for "Seconds out"
const HEAT_DECAY := 0.15      # S395: each landed shot adds heat; it decays between exchanges
const HEAT_PER_LANDED := 0.12 # S395: a landed punch raises the crowd heat

## S395: the room's attendance config. Set once at the first bell.
static var _people := 0
static var _room_type := "hall"
static var _share := 0.0
static var _bed_offset_db := 0.0
## S395: the crowd's heat (0..1): a run of landed shots raises it, time decays it.
static var _crowd_heat := 0.0
static var _reaction_count := 0


## `move` lands. The big shot plays alone: every sound was heard on its own, so two whole punches never stack.
## S395: pre_fire_s advances the sound by the file's rise time, so the peak lands with the glove.
## S395: a landed punch raises the crowd heat.
static func landed(move: String, big: bool) -> void:
	var pf := SoundBank.pre_fire_s(resolve_move(move))
	if big:
		Sfx.play("punch_big", {"power": 1.0, "delay": -pf})
		Sfx.sub_bass()
		Sfx.play("crowd_roar", {"delay": ROAR_AFTER_S})
		Sfx.duck("Crowd", BIG_DUCK_DB, BIG_DUCK_S)
	else:
		Sfx.play(resolve_move(move), {"delay": -pf})
	_crowd_heat = minf(1.0, _crowd_heat + HEAT_PER_LANDED)


## `delay`: the seconds to the glove's contact, so the sound lands with the picture.
## S395: pre_fire_s compensates for the file's rise time; the punch must still be running (BeatFire checks cut_off).
static func blocked(delay: float = 0.0) -> void:
	var pf := SoundBank.pre_fire_s("punch_blocked")
	Sfx.play("punch_blocked", {"delay": maxf(0.0, delay - pf)})


## S395: the miss sound is quiet and rare. Only a full-power punch that misses (no defence) plays the whoosh.
## A jab or a slipped shot stays silent. `move`: the punch type. `def`: the defence (empty = pure miss).
static func missed(delay: float = 0.0, move: String = "", def: String = "") -> void:
	if move == "jab" or move == "lead_uppercut" or def != "":
		return
	var pf := SoundBank.pre_fire_s("punch_miss")
	Sfx.play("punch_miss", {"delay": maxf(0.0, delay - pf)})


## R8: the round's big shot is known at its beat. The crowd drops until the contact; landed() takes the bus from there.
static func big_shot_ahead(seconds: float) -> void:
	Sfx.duck("Crowd", HUSH_DB, clampf(seconds, 0.6, 1.0))


static func step() -> void:
	Sfx.play("footwork_canvas")


## S395: the first bell sets the room from the bout's attendance. The crowd bed, the reverb, and the roar all scale.
static func bell(start: bool) -> void:
	if start:
		Sfx.play("bell_round_start")
		Sfx.loop("crowd_arena_loop")
	else:
		Sfx.play("bell_round_end")


## The bed runs from the first bell through the corners; it stops when the fight view leaves.
static func crowd_off() -> void:
	Sfx.stop("crowd_arena_loop")


## `delay`: the seconds from the fall's start to the body on the canvas.
static func knockdown(delay: float = 0.0) -> void:
	Sfx.play("knockdown_fall", {"power": 1.0, "delay": delay})
	Sfx.play("crowd_roar", {"delay": delay + ROAR_AFTER_S})


static func resolve_move(move: String) -> String:
	if move.contains("body"):
		return "punch_body"
	if move == "jab":
		return "punch_jab_head"
	return "punch_power_head"


## S395: set the room from the bout's attendance. Called once at the first bell.
## Scales the crowd bed level, the Room bus reverb, and the roar volume.
static func setup_room(bout: Dictionary) -> void:
	_people = Attendance.of(bout)
	_room_type = Attendance.room(_people)
	_share = Attendance.share(_people)
	# The bed: a hall is single voices (-6 dB under the mix), an arena is a wall of sound (+3 dB).
	_bed_offset_db = lerpf(-6.0, 3.0, _share)
	Sfx.bus_offset["Crowd"] = _bed_offset_db
	var crowd_idx := AudioServer.get_bus_index("Crowd")
	if crowd_idx >= 0:
		AudioServer.set_bus_volume_db(crowd_idx, Sfx.level("Crowd"))
	# The room: a hall is short and dry, an arena is long and wide.
	var room_idx := AudioServer.get_bus_index("Room")
	if room_idx >= 0 and AudioServer.get_bus_effect_count(room_idx) > 0:
		var rev: AudioEffect = AudioServer.get_bus_effect(room_idx, 0)
		if rev is AudioEffectReverb:
			var r := rev as AudioEffectReverb
			r.room_size = lerpf(0.3, 0.9, _share)
			r.damping = lerpf(0.8, 0.5, _share)
			r.wet = lerpf(0.15, 0.5, _share)


## S395: the crowd follows the fight. `kind`: "knockdown_home", "close_round_last10s", "round_end".
## `who`: 0 = home fighter. Bigger crowds react more.
static func crowd_reaction(kind: String, who: int) -> void:
	_reaction_count += 1
	match kind:
		"knockdown_home":
			# A groan from the home crowd when their fighter goes down. New sound, unheard: on the board.
			Sfx.play("crowd_groan")
		"close_round_last10s":
			# A hush in the last 10 seconds of a close round.
			Sfx.duck("Crowd", -6.0, 8.0)
		"round_end":
			# A swell at the end-of-round bell. New sound, unheard: on the board.
			Sfx.play("crowd_swell")


## S395: the reaction's volume scales with the crowd's share (bigger crowds react louder).
static func _reaction_volume(kind: String) -> float:
	var base := 0.0
	match kind:
		"round_end":
			base = SoundBank.volume_db("crowd_swell")
		"knockdown_home":
			base = SoundBank.volume_db("crowd_groan")
	return base + lerpf(-3.0, 3.0, _share)


## S440 operator: "i want to hear the announcer mixed with the arena crowd". The bed runs from the walk-in, not the first
## bell; under each announcer line it drops ANNOUNCE_DUCK_DB for the line's length, and a name or a winner gets the roar.
const ANNOUNCE_DUCK_DB := -5.0       # S440 C312: a softer dip, eased in and out, so the room stays under him
const ANNOUNCE_ATTACK_S := 0.35
const ANNOUNCE_RELEASE_S := 2.6      # S442 his C316: the room comes back as a slow swell, not a step
const ROAR_OVERLAP_S := 0.8          # the crowd starts to rise under his last words, not after a gap
const ROAR_SWELL_S := 1.6            # and the roar itself swells in
const RESULT_BED_TAIL_S := 4.0   # the result reads after the ring has gone: the bed plays on this long after the line

static func announcer_line(event: String, cheer: bool) -> void:
	Sfx.loop("crowd_arena_loop")   # no-op when the bed already runs
	var dur := line_seconds(event)
	Sfx.duck("Crowd", ANNOUNCE_DUCK_DB, maxf(dur - ROAR_OVERLAP_S, 0.0), ANNOUNCE_ATTACK_S, ANNOUNCE_RELEASE_S)
	if cheer:
		Sfx.play("crowd_roar", {"delay": maxf(dur - ROAR_OVERLAP_S, 0.0), "fade_in": ROAR_SWELL_S})


## The result is read on the menus, after the ring left (crowd_off): the bed comes back for it, then fades.
static func announcer_result(event: String) -> void:
	announcer_line(event, true)
	Sfx.stop_after("crowd_arena_loop", line_seconds(event) + RESULT_BED_TAIL_S)


## The length of the event's first kept file (0 when nothing is kept).
static func line_seconds(event: String) -> float:
	var fl: Array = SoundBank.files(event)
	if fl.is_empty():
		return 0.0
	return float(SoundBank.file_data(str(fl[0]).trim_prefix("res://")).get("dur", 0.0))


## S395: the corner minute. `start` true: the crowd drops under the coach's voice.
## `start` false: "Seconds out" - the crowd comes back.
static func corner_minute(start: bool) -> void:
	if start:
		Sfx.duck("Crowd", CORNER_DUCK_DB, 60.0)
	else:
		# S396: a zero duck tweens the bed back to the room's level and holds it there.
		Sfx.duck("Crowd", 0.0, 0.0)
