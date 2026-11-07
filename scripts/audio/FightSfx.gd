extends RefCounted
## S385 Round 1, ported S390: the fight's words -> sound events. Static, no nodes.
## The fight scripts call these (docs/audio/FIGHT_HOOKS.md). Only events with a kept row in sounds.json appear here:
## clinch, the count, the corner bed and the crowd swell come back when the operator has kept a sound for them.

const Sfx := preload("res://scripts/audio/Sfx.gd")
const SoundBank := preload("res://scripts/audio/SoundBank.gd")

const ROAR_AFTER_S := 0.22    # the crowd answers a beat after the big shot and the fall
const BIG_DUCK_DB := -8.0     # S395: deeper duck under the big shot (was -4); the slow-mo moment needs room
const BIG_DUCK_S := 1.0       # S395: matches FightCalls.HOLD_S (the ring is slow for 1 s)
const HUSH_DB := -11.0        # R8: near-silence before the round's big shot


## `move` lands. The big shot plays alone: every sound was heard on its own, so two whole punches never stack.
## S395: pre_fire_s advances the sound by the file's rise time, so the peak lands with the glove.
static func landed(move: String, big: bool) -> void:
	var pf := SoundBank.pre_fire_s(resolve_move(move))
	if big:
		Sfx.play("punch_big", {"power": 1.0, "delay": -pf})
		Sfx.sub_bass()
		Sfx.play("crowd_roar", {"delay": ROAR_AFTER_S})
		Sfx.duck("Crowd", BIG_DUCK_DB, BIG_DUCK_S)
	else:
		Sfx.play(resolve_move(move), {"delay": -pf})


## `delay`: the seconds to the glove's contact, so the sound lands with the picture.
## S395: pre_fire_s compensates for the file's rise time; the punch must still be running (BeatFire checks cut_off).
static func blocked(delay: float = 0.0) -> void:
	var pf := SoundBank.pre_fire_s("punch_blocked")
	Sfx.play("punch_blocked", {"delay": maxf(0.0, delay - pf)})


static func missed(delay: float = 0.0) -> void:
	var pf := SoundBank.pre_fire_s("punch_miss")
	Sfx.play("punch_miss", {"delay": maxf(0.0, delay - pf)})


## R8: the round's big shot is known at its beat. The crowd drops until the contact; landed() takes the bus from there.
static func big_shot_ahead(seconds: float) -> void:
	Sfx.duck("Crowd", HUSH_DB, clampf(seconds, 0.6, 1.0))


static func step() -> void:
	Sfx.play("footwork_canvas")


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
