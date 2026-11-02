# TASK MITTPOP1 - the mitt pop: pad hits sound cleaner and sharper as a punch is mastered (boxing, pure rules module)

Model: Arena (cloud). Discipline: BOXING (demo). Fast lane: ADD ONLY the two new files below, touch nothing else.

## Why
Operator board answer Q-S249-6 (S255), question "Ludo says the first playable must have: weigh-in on the scale, a visible cut + cutman,
a mitt pop sound. Which go in?" -> "All three". Ludo r119 (research/ludo_rx/LUDO_R119_raw.txt:66): "When viewing the fighter on
the pads, clean hit audio must trigger with variable pitch based on punch mastery." Mastery per punch already exists (athlete
`move_mastery`, scripts/rules/MoveMastery.gd: RAW 1-29 / USABLE 30-59 / SHARP 60-84 / SIGNATURE 85+). Claude plays the result at the
pad contact in `Godot/scripts/club_look/PadPair.gd` with the CC0 samples in `assets/audio/fight/glove/` (clean) and
`assets/audio/fight/glove_blocked/` (slap) afterwards - you write only the module + its test.

## Files you create (only these)
1. `Godot/scripts/rules/MittPop.gd` - `extends RefCounted`, ALL functions `static`, NO preloads, NO autoloads, NO RNG (rolls 0..1 are
   passed IN), no class_name, no argument modified.
2. `Godot/tests/mitt_pop_test.gd` - `extends SceneTree`, `OK  <label>` / `FAIL <label>` lines, ends with
   `print("MITT_POP failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`.

## MittPop.gd API
- consts: `PITCH_MIN = 0.90`, `PITCH_MAX = 1.12` (mastery 0 -> 100, linear), `VOL_MIN_DB = -9.0`, `VOL_MAX_DB = -2.0` (same ramp),
  `CLEAN_MIN = 0.35` (clean share at mastery 0), `CLEAN_MAX = 0.97` (at mastery 100), `JITTER = 0.03` (pitch +- this, from a roll),
  `FATIGUE_PITCH_DROP = 0.05` (at fatigue 100), `SLAP_PITCH = 0.85`, `SLAP_VOL_DB = -10.0`.
- `static func clean_chance(mastery: float, fatigue: float) -> float` - lerp CLEAN_MIN..CLEAN_MAX by mastery/100, then x (1 - 0.25 x
  fatigue/100); inputs clamped 0..100; result clamped 0..1.
- `static func pop(mastery: float, fatigue: float, roll_clean: float, roll_jitter: float, sample_count: int, roll_sample: float) -> Dictionary`
  -> `{"kind": "clean"|"slap", "pitch_scale", "volume_db", "sample": int}`: clean when roll_clean < clean_chance; clean pitch = lerp
  PITCH_MIN..PITCH_MAX by mastery - FATIGUE_PITCH_DROP x fatigue/100 + (roll_jitter x 2 - 1) x JITTER; clean volume = lerp VOL_MIN_DB..
  VOL_MAX_DB; slap = SLAP_PITCH + the same jitter, SLAP_VOL_DB; sample = clamp(floor(roll_sample x sample_count), 0, sample_count - 1),
  -1 when sample_count <= 0.
- `static func tier_label(mastery: float) -> String` - "RAW" (< 30), "USABLE" (< 60), "SHARP" (< 85), "SIGNATURE" (the MoveMastery bands).
- Every number is a `const`; the test reads the consts, never the literals.

## The test (from this contract, not from your code)
- clean_chance(0, 0) == CLEAN_MIN, (100, 0) == CLEAN_MAX, (100, 100) == CLEAN_MAX x 0.75; monotonic up in mastery, down in fatigue;
- pop with roll_jitter 0.5 (no jitter): mastery 0 -> PITCH_MIN, mastery 100 -> PITCH_MAX, mastery 100 fatigue 100 -> PITCH_MAX - drop;
- jitter bounds: roll_jitter 0 and 1 move pitch by exactly -JITTER / +JITTER;
- roll_clean just below / at clean_chance flips clean -> slap; slap carries SLAP_VOL_DB;
- sample: roll 0 -> 0, roll 0.999 with 5 samples -> 4, roll 1.0 -> 4 (never out of range), count 0 -> -1;
- higher mastery never sounds quieter or lower (sweep step 10, roll_jitter 0.5); tier bands flip at 30 / 60 / 85.
- Mutants: say in the PR body which two consts you nudged and that the test went red.

## Prior research
`python Tools/prior_research.py mitt sound`: topics/audio.md (sound + music page), FightAudio.gd loads the CC0 glove samples
(LICENCES.md), MoveMastery.gd bands. No pad/mitt audio exists yet.

## What would a human do?
Anyone who has held pads knows a good puncher by ear: a sharp snap that cracks off the mitt; a beginner's punch is a dull slap.
Tired fighters lose the snap.

## Prefab check
Samples: the CC0 Freesound glove set already in the repo (assets/audio/fight/LICENCES.md). No audio-variation library needed.

## Contract
OWNS: Godot/scripts/rules/MittPop.gd, Godot/tests/mitt_pop_test.gd
RED_TEST: Godot/tests/mitt_pop_test.gd -> MITT_POP failures=0
REGRESSION: mitt_pop_test
VISUAL: no
