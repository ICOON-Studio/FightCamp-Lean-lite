# TASK_SOUND1 - the sound engineer, round 1: the sound layer + the fight's core sounds, layered, measured, on the board (Qwen)

Model: Qwen (qwen3-coder). Discipline: boxing demo (+ no-gi BJJ mat sounds in a later round). Repo: **E:\FightCamp\Lean**
(worktree E:\FightCamp\wt\LEAN_SOUND1, branch `qwen/sound1`). Lean rules: its CLAUDE.md, no script over 500 lines, Godot
headless only (`--headless --audio-driver Dummy`), nothing opens on the operator's screens.

## Your role from now on (operator S385, verbatim)
"maybe you should assign one of my agents as sound enginner and take care of all needed sounds, effects etc" and
"i expect top sound quality , check which games have been praised for sound , why , how they did and try to surpass them".
YOU (the Qwen seat) are FightCamp's SOUND ENGINEER: you own every sound, effect and piece of music in the game (operator S227:
one owner per area). Claude designs and integrates; the operator's ear is the only judge.

## THE EAR RULE - read before anything else
You cannot hear. Claude cannot hear. Operator S133, on CC0 fight samples nobody had listened to: "the sounds are so bad wtf ...
did you approve those sounds for a AAA title ?" So:
- Never write that a sound is good, fixed, punchy, AAA or done. Write its NUMBERS (tools/audio_prep.py) and "unheard".
- Every new file goes into assets/audio/sounds.json with `"heard": false`. Only the operator's verdict on the sound board flips it.
- Never delete or overwrite a file whose row says `"heard": true` (he kept it). A redo is a NEW file `<event>_<n+1>.ogg`.
- Every round ends with the sound board rebuilt: `python tools/sound_board.py --round "Round 1"` (html + txt + reel mp4).
- The local model ear (tools/audio_ear.py) is NOT a judge until its blind calibration passes; do not run it (11.5 GB of RAM).

## The quality bar - READ ops/research/SOUND_BENCHMARK_S385.md FIRST
Claude's research on the games praised for sound (Fight Night Champion, Undisputed, Thrill of the Fight, Sifu, DOOM, God of
War, EA FC crowds, Two Point, Hades...). Its "FightCamp sound bar" rules are this task's spec where they touch what you build;
the ones that need numbers are checked by the test below. The short version (Claude, from that report):
- R1 a punch = separate layers picked at runtime: snap (leather, <= 80 ms, bright) + thud (60-250 Hz body) + room from a
  bus reverb (never baked in the file). R2 head / body / block / miss are different families (body darker, block muffled,
  miss = air only). R3 variants: >= 8 per punch layer, block and miss >= 6, footwork >= 10, crowd reactions >= 4, big shot and
  knockdown fall >= 3, the bell 1-2 on purpose. R4 no immediate repeats (PLAYBACK_RANDOM_NO_REPEATS).
- R6 the fight's data drives the sound: power, head/body, big shot, fatigue pick the pool, level and pitch.
- R7 one priority ladder, the top is never ducked: big shot / knockdown > count, bell > landed punches > the rest; crowd and
  music duck 6-9 dB under the top. R8 OUR SIGNATURE: the round is settled before it plays, so 0.6-1.0 s before the big shot the
  crowd drops 10-12 dB with a low-pass sweep to ~1 kHz and music goes silent; on contact the full hit, then the crowd erupts
  150-300 ms later. No boxing game can do this - none knows the future.
- R12 every file levelled to its LOUDNESS CLASS (looped measurement), never one target per kind: big shot -14 LUFS, power -17,
  jab -19, body -18, block -21, miss -25, footwork -30, knockdown fall -17, bell -16, referee -18, crowd reaction -20, crowd bed
  -26, UI click -24, music -18; peaks <= -1 dBFS. (Round 0 levelled everything alike, so its big shot reads QUIETER than a
  power punch and the footwork as loud as a hit - redo the levels.) R13 48 kHz; one-shots WAV 16-bit mono (Godot: low CPU, no
  decode latency); beds and music Ogg q6-8 stereo; no MP3. R14 lead silence <= 5 ms on impacts; tails to -45 dBFS: jab <= 0.25 s,
  power <= 0.40, body <= 0.35, block <= 0.30, big shot <= 1.2, footwork <= 0.20.
- R17 NO commentary. R18 UI <= 150 ms (card flip <= 250), quiet, one family. R19 music loops >= 90 s (fight night >= 60 s).
- Later rounds (not this one): R9 the crowd as a momentum system (3 beds crossfaded), R10 venue scaling, R20 mix states, R11
  the whole-mix loudness check through Godot's Movie Maker render.

## What exists (round 0, Claude S385 - read, do not redo)
- `docs/audio/SOUND_LIST.md` - the ranked list of 39 events (tier 1 fight, tier 2 feel, tier 3 gym/BJJ/UI, music) + the mix.
- `assets/audio/sounds.json` - 13 events, 13 files (fight/, crowd/, ui/), all unheard. `assets/audio/raw/` keeps Ludo's originals
  (`.gdignore`d; Ludo's ".mp3" were really WAV - audio_prep reads the content, not the name).
- `tools/audio_prep.py` - `add <src> --event --group --bus --kind sfx|loop|music|voice --prompt --credits --tier`: trims lead
  silence, mono one-shots / stereo loops, 48 kHz, levels (one-shots on momentary max, loops/music on integrated LUFS), limits
  under the true-peak ceiling, fades the tail, Ogg Vorbis. `measure <f>`, `check` (all rows against the targets).
- `tools/sound_board.py` - the operator's board. `tools/audio_ear.py` - the gated model-ear calibration (do not run).
- FINDING (numbers, not ears): Ludo's single-prompt punches are thin clicks - jab 0.16 s, body 0.24 s, momentary max
  -22 to -27 LUFS at a -1.3 dB peak (all transient, no body). That is the "no power" sound. Round 1 builds punches in LAYERS.

## Spec - build these (all new files unless named)
### 1. `scripts/audio/SoundBank.gd` (extends RefCounted, static, pure - no nodes, no AudioServer)
Reads `res://assets/audio/sounds.json` once (FileAccess + JSON, cached in a static var). `events() -> Array` (ids),
`event(id) -> Dictionary` ({} when unknown), `files(id) -> Array`, `bus(id) -> String`, `layers(id) -> Array` (an event may list
`"layers": ["punch_snap", "punch_thud_head", "punch_tail"]` - other event ids played together; [] when none), `has(id) -> bool`,
`intensity(id, power: float) -> Dictionary` ({"volume_db", "pitch_scale"}: power 0..1 -> -3..+2 dB and pitch 1.04..0.94 -
a harder punch is louder and lower; clamp power).
### 2. `scripts/audio/Sfx.gd` (extends Node; NO autoload - project.godot is not yours)
Static entry points that work from any script: `Sfx.play(id, opts := {}) -> bool`, `Sfx.loop(id)`, `Sfx.stop(id, fade := 0.5)`,
`Sfx.duck(bus, db, seconds)`, `Sfx.ensure() -> Node`. `ensure()` finds or creates ONE node `/root/Sfx` (via
`Engine.get_main_loop() as SceneTree`, `root.add_child.call_deferred` is NOT enough for a same-frame play - add it directly when
the root is not busy, else deferred and queue the play) and the buses under Master, by name, only if missing:
Music -14 dB, SFX -4 dB, Crowd -12 dB, UI -10 dB, Voice -6 dB, Room (an AudioEffectReverb, small hall, wet only; SFX and
Voice players also send to it - the punch room tail, R1) (AudioServer.add_bus / set_bus_name / set_bus_send "Master").
One `AudioStreamRandomizer` per event (Godot 4 built-in: `playback_mode = PLAYBACK_RANDOM_NO_REPEATS`, pitch (R5): impacts +-1 semitone
(`random_pitch_semitones` if 4.7 has it, else `random_pitch = 1.06`), UI +-0.5 semitone, loops/music none, `random_volume_offset_db` 1.5), a pool of 16 one-shot `AudioStreamPlayer`s (steal the oldest),
2 loop players (crowd, music). `play` plays the event's layers (or itself), applies `opts.power` via SoundBank.intensity and
`opts.delay` (seconds, a SceneTree timer), honours a per-event `cooldown` (s) from sounds.json (crowd roar 2.0, count 0). Returns
false (no error) on an unknown id. Headless with the Dummy driver it must still run every path (the test plays every event).
### 3. `scripts/audio/FightSfx.gd` (extends RefCounted, static) - the fight's words -> events
`landed(move, big, body, power := 0.6)`: body (move contains "body" or "kidney", or `body`) -> `punch_body`; jab -> `punch_jab_head`;
else `punch_power_head`; `big` -> `punch_big` + `crowd_roar` + `Sfx.duck("Crowd", -4, 0.6)`. `blocked(move)` -> `punch_blocked`.
`missed(move)` -> `punch_miss`. `big_shot_ahead(seconds)` (R8, our signature): over `seconds` (0.6-1.0) duck the Crowd bus
-11 dB with a low-pass sweep to 1 kHz (an AudioEffectLowPassFilter on Crowd, cutoff tweened) and the Music bus to silence; `landed(...,
big=true)` then restores them and plays `crowd_roar` after a random 0.15-0.30 s. Priority (R7): a big shot / knockdown play is
never ducked or voice-stolen; the pool steals the oldest LOWEST-priority voice (sounds.json `"priority"` 0-3). `step()` -> `footwork_canvas`. `clinch()` -> `clinch_grab`. `bell(start: bool)` ->
`bell_round_start` (+ `Sfx.loop("crowd_arena_loop")`) / `bell_round_end` + `crowd_round_swell`. `count(n)` -> `ref_count_<n>`
(1..10). `knockdown()` -> `knockdown_fall` + `crowd_roar`. `corner(on: bool)` -> loop / stop `corner_minute_bed`.
Moves to cover: jab, cross, lead_hook, rear_hook, body_hook, lead_uppercut, rear_uppercut (grep scripts/rules/RoundScript.gd and
scripts/fight3d/BeatClips.gd for any other `move` name the beats use - read only - and map it).
### 4. `docs/audio/FIGHT_HOOKS.md` - the fight is NOT yours to edit
`scripts/fight3d/` belongs to the FIGHT9 loop (agy). Write the exact one-line calls Claude will paste, per site:
`BeatFire._punch` when `b.big` (the round's big shot is known at its beat) -> `FightSfx.big_shot_ahead(minf(0.8, at))`
scheduled so the hush ends on contact; `HitImpact.hit` (after the `was_cut` return) -> `FightSfx.landed(move, big, move.contains("body"))`; `BeatFire._punch` block
branch (at the block timer) -> `FightSfx.blocked(move)`, miss branch -> `FightSfx.missed(move)` at `at * 0.6`;
`BeatFire.fire` step_in/step_out -> `FightSfx.step()`, clinch -> `FightSfx.clinch()`; `FightView.play_round` -> `FightSfx.bell(true)`;
`FightView._bell` -> `FightSfx.bell(false)`; `KnockdownCount._number(n)` -> `FightSfx.count(n)`; `BeatFire._count`'s fall timer ->
`FightSfx.knockdown()`; `CornerMinute.run` / `finish` -> `FightSfx.corner(true/false)`; `PadWork._pop_mitt` -> `Sfx.play("gym_pads_pop")`.
Give file, function, the line it goes after (quote the line), and the call.
### 5. UI wiring (yours, inside these windows only)
`scripts/ui/UI.gd` `button()` (lines 275-288): connect `Sfx.play("ui_click")` to `pressed` BEFORE `on_press` (one line).
`scripts/ui/FlipCard.gd` `flip()` (lines 188-198): `Sfx.play("ui_card_flip")` (one line). Nothing else in those files.
### 6. Pipeline first: `tools/audio_prep.py` to the bar (yours)
- Per-event loudness CLASS (R12): `TARGETS` keeps the per-kind defaults, and an event's `"target"` in sounds.json (LUFS)
  overrides it; one-shots are measured LOOPED (20 x, as the benchmark did) instead of padded. Write the R12 class into every
  event's `"target"`. `check` compares each file to its event's target (+-1.5 LU) and the R14 tail limit (`"tail_max"`).
- One-shots (sfx, voice) are written as WAV 16-bit 48 kHz mono `.wav`; loops and music stay Ogg (q6 loops, q7 music).
- Re-run `add` on every round-0 original in assets/audio/raw/ to the new classes and formats (all round-0 files are unheard,
  so replacing them is allowed - remove the old .ogg + its .import and fix the sounds.json rows).
### 7. Assets, round 1 (Ludo CLI on PATH: `ludo audio sound-effect|ambiance|music|speech-preset --help`; budget 200 credits)
Generate, then `python tools/audio_prep.py add ...` each (keep Ludo's original in `assets/audio/raw/<event>/`):
- PUNCH LAYERS (R1): `punch_snap` x8 (dry leather transient, ask for "one short leather glove slap, dry, no reverb, no tail"),
  `punch_thud_head` x8 (low head-impact body, <= 200 ms), `punch_thud_body` x8 (dull torso thump, darker). No tail files: the
  room is a reverb on a `Room` bus you add (Reverb effect, small hall). Layer lists in sounds.json: `punch_jab_head` = snap +
  thud_head (jab class); `punch_power_head` = snap + thud_head; `punch_body` = snap + thud_body; `punch_big` = its own files
  (x3) + snap + thud_head. Keep the round-0 single files as extra variants only if they pass the class + tail check.
- Variants (R3): punch_blocked x6, punch_miss x6, footwork_canvas x10 (single steps, <= 0.2 s each), crowd_roar x4,
  knockdown_fall x3, punch_big x3.
- Crowd: `crowd_arena_loop` must loop >= 60 s with no seam jump (round 0's is 8 s and repeats ~22 times a round, seam 3.3 dB):
  ask Ludo ambiance for the longest it gives; if it stays short, ask for 3 and crossfade-join them with ffmpeg (acrossfade 2 s).
- New events (SOUND_LIST tier 1-2): `ref_count_1`..`ref_count_10` (speech-preset, one gruff referee voice for all ten, each
  number shouted once, bus Voice, kind voice), `clinch_grab`, `ref_break`, `breath_effort` x3, `grunt_hurt` x2,
  `crowd_round_swell`, `corner_minute_bed` (ambiance, loop), `corner_water`, `seconds_out` (speech-preset, same voice), `crowd_finish`.
- UI: `ui_card_flip` x2, `ui_confirm`, `ui_meter_tick` (each under 0.2 s), `ui_click` x1 more.
- Music: `music_menu` and `music_fight_night` (one each, `ludo audio music`, instrumental, no lyrics; kind music, bus Music).
Write each Ludo prompt as a sound designer would (material, distance, dry/room, length, "no music, no crowd" where it applies).
After every file: `audio_prep.py check` stays at failures=0 for your new files, or the failure is written in your PR body with
why (e.g. a deliberately quiet footstep: give that event a `"target"` override in sounds.json and make `check` honour it).
### 8. The board
`python tools/sound_board.py --round "Round 1 - layered punches + count + crowd + UI + music"` - commit the html, txt and mp4.

## Contract
OWNS: scripts/audio/, assets/audio/, docs/audio/, tests/sound_bank_test.gd, tools/audio_prep.py, tools/sound_board.py,
tools/audio_ear.py, scripts/ui/UI.gd:275-288, scripts/ui/FlipCard.gd:188-198
RED_TEST: tests/sound_bank_test.gd -> PASS sound_bank_test
REGRESSION: golden_path_test, card_flip_test, drill_card_test
VISUAL: no (sound; the operator's ear judges on the sound board, never auto-merged without his keep)

## The test (write it FIRST - it fails on main, where scripts/audio/ does not exist)
`tests/sound_bank_test.gd` (extends SceneTree, the `_check(ok, what)` style of tests/grapple_graph_test.gd; prints
`PASS sound_bank_test` and quits 0 only when every check passes):
1. SoundBank: sounds.json parses; every event has >= 1 file; every file `load()`s as an AudioStream (import the new files first:
   `Godot --headless --path . --import` once in your worktree, and COMMIT the `.ogg.import` files beside the .ogg); every layer id
   is itself an event; every bus is one of Master/Music/SFX/Crowd/UI/Voice/Room.
2. Coverage: every event named in docs/audio/SOUND_LIST.md tier 1 exists (parse the `| n | \`id\` |` rows); `ref_count_1..10` exist;
   the four punch events have layers; punch layer events have >= 4 files (snap, thud_head, thud_body).
3. Numbers (from the sounds.json rows audio_prep wrote - no ffmpeg in Godot): every one-shot is a .wav, every loop/music an .ogg;
   every file's loudness within 1.5 LU of its event's `target`; impact `lead_silence` <= 0.005; `tp` <= -1.0; every tail inside its
   event's `tail_max`; UI `dur` <= 0.15 (card flip 0.25); variant counts per R3 (snap/thud >= 8, block/miss >= 6, footwork >= 10,
   crowd_roar >= 4, punch_big and knockdown_fall >= 3); crowd_arena_loop `dur` >= 60; every file `heard` is a bool.
4. Sfx: after `Sfx.ensure()` the six buses exist (Room with its reverb); `Sfx.play(id)` returns true for every event (Dummy driver) and false for
   "no_such_sound"; a cooldown event played twice in a row returns false the second time.
5. FightSfx: landed/blocked/missed for each of the 7 moves (+ any you found) resolve to an existing event; count(1..10) too.
Print one line per event: id, bus, files, layers.

## Prior research
ops/research/SOUND1_SEAT_JOHN_JOHN.md (John's real-world punch recording notes + a prompt for every round-1 event - USE THEM
when the file exists; it is queued as SQ28 and may land after you start: then write your own in the same form);
ops/research/SOUND_BENCHMARK_S385.md (the bar); J22_WHAT_A_FIGHT_SOUNDS_LIKE.md + J22B (cue list: impacts first, then big shot /
knockdown, then block/slip, vocals, crowd); J40_FIGHT_AUDIO_SHORTLIST.md; topics/audio.md. The old repo's Q135/Q136 sound passes
used CC0 samples the operator rejected by ear (S133) - do not reuse them.

## What would a human do?
A game sound designer layers every impact (transient + body + tail), records several takes of each and randomises, mixes on
buses with the crowd ducking under the big moments, levels everything to a loudness standard, and plays it to the director.

## Prefab check
Godot 4 has AudioStreamRandomizer (variants, no-repeat, pitch/volume jitter) and runtime AudioServer buses - use them, no addon.
Sounds come only from Ludo (the operator's Pro plan); no CC0 packs, no other generator.

## The one trap
Headless tests run with `--audio-driver Dummy`: a play "works" with no sound at all. The test proves wiring and numbers, never
quality. Your PR body says "unheard" for every sound, lists credits spent, and ends with the board path.

## PR body
RESULT: tests/sound_bank_test.gd -> PASS sound_bank_test
Credits spent: <n> of 200. Files: <n> new, all unheard. Board: docs/audio/board/sound_board.html
