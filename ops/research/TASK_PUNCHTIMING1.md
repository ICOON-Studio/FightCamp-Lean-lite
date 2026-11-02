# TASK PUNCHTIMING1 - when a boxer gets control back after a punch, as one pure rules module (boxing)

Model: Qwen (qwen3-coder, shell seat, pushes a branch). Discipline: BOXING (demo). Fast lane: ADD ONLY the two new files below, touch nothing else.

## Why
Operator board Q-S249-4 (S255): "Approve" - the production roadmap (research/PRODUCTION_ROADMAP_S254.md) puts punch feel in S255.
Evidence: research/UNDISPUTED_STUDY_S254.md - a shipped boxing game returns control at impact + 0.12-0.17 s; ours locks the
boxer until the clip's `recover_s`, 0.42-1.4 s after contact (body hook 0.701 -> 2.082, rear uppercut 0.591 -> 2.069). Ludo r119
(research/ludo_rx/LUDO_R119_raw.txt, summarised in PRODUCTION_ROADMAP_S254.md "PUNCH FEEL") gives the per-punch offsets and new
body contact targets. Claude wires the module into `Godot/scripts/animation/IntentBus.gd:56` (where `recover_s` becomes
`retraction_end_norm`) afterwards - you write only the module + its test.

## Files you create (only these)
1. `Godot/scripts/rules/PunchTiming.gd` - `extends RefCounted`, ALL functions `static`, NO preloads, NO autoloads, NO file reads, NO RNG.
   The caller passes a clip's phase Dictionary (the shape of one entry of `Godot/assets/data/clip_phases.json`:
   `{"start_s", "contact_s", "recover_s", "length_s", "effector", "returns"}`).
2. `Godot/tests/punch_timing_test.gd` - `extends SceneTree`, `OK  <label>` / `FAIL <label>` lines, ends with
   `print("PUNCH_TIMING failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`. The test builds its own phase dicts (no file read).

## PunchTiming.gd API
- `const CONTROL_OFFSET_S: Dictionary` (seconds after contact) - Ludo r119:
  boxing_jab 0.12, boxing_up_jab 0.12, boxing_double_jab 0.11, boxing_jab_body 0.13, boxing_cross 0.15, boxing_cross_body 0.16,
  boxing_check_hook 0.14, boxing_check_hook_pivot 0.14, boxing_body_hook 0.15 (lead body hook), boxing_rear_hook_body 0.16,
  boxing_shovel_hook 0.14, boxing_lead_uppercut 0.14, boxing_inside_uppercut 0.14, boxing_rear_uppercut 0.16, boxing_overhand 0.17.
  `const DEFAULT_OFFSET_S = 0.15` for any other clip id (combos keep their last punch's clip timing - not this module's job).
- `const BODY_CONTACT_TARGET_S: Dictionary` - boxing_body_hook 0.40, boxing_rear_hook_body 0.44, boxing_jab_body 0.32.
  `const LEVEL_CHANGE_START_S = 0.08`.
- `const MIN_RETRACTION_S = 0.14` (anti-pop: the arm never snaps back faster), `const IMPACT_HOLD_FRAMES = 2`.
- `static func contact_s(clip_id: String, phase: Dictionary) -> float` - the BODY_CONTACT_TARGET_S value when the id is in it, else
  `phase.contact_s`.
- `static func control_return_s(clip_id: String, phase: Dictionary) -> float` - `contact_s(...) + offset`, then at least
  `contact_s + MIN_RETRACTION_S`, never above `phase.recover_s` (we only ever shorten the lock), never above `phase.length_s`.
- `static func time_scale_to_contact(clip_id: String, phase: Dictionary) -> float` - playback speed factor so the clip's own
  contact frame lands on the target: `phase.contact_s / contact_s(...)` (1.0 when no target; > 1 means the clip plays faster up to contact).
- `static func blend_tail_s(clip_id: String, phase: Dictionary) -> float` - `phase.length_s - control_return_s(...)` scaled to the
  sped-up timeline is NOT needed: return the seconds of clip left after control returns on the clip's own timeline (>= 0); the integrator
  plays that tail on a blend layer.
- `static func lock_saved_s(clip_id: String, phase: Dictionary) -> float` - `phase.recover_s - control_return_s(...)` (>= 0), for the report.
- Every number is a `const`; the test reads the consts, never repeats the literals.

## The test (from this contract, not from your code)
- jab phase {contact 0.25, recover 0.667, length 0.833}: control return = 0.25 + CONTROL_OFFSET_S.boxing_jab;
- an unknown id uses DEFAULT_OFFSET_S;
- body hook phase {contact 0.701, recover 2.082, length 2.082}: contact_s = 0.40, control return = 0.40 + 0.15 offset const,
  time_scale_to_contact = 0.701 / 0.40;
- clamp up: a fake id whose offset const would be below MIN_RETRACTION_S never returns earlier than contact + MIN_RETRACTION_S
  (inject by testing a phase where recover_s is huge and checking `control_return_s - contact_s >= MIN_RETRACTION_S` for EVERY key);
- clamp down: a phase with recover_s = contact_s + 0.05 returns recover_s (never lengthens the lock);
- for EVERY key in CONTROL_OFFSET_S with the jab phase: 0 <= lock_saved_s, blend_tail_s >= 0, control_return_s <= recover_s;
- the input dict is unchanged after every call (compare a duplicate).
- Mutants: say in the PR body which two consts you nudged and that the test went red.

## Prior research
`python Tools/prior_research.py punch timing control return`: UNDISPUTED_STUDY_S254.md (0.12-0.17 s), PRODUCTION_ROADMAP_S254.md
(Ludo r119 offsets), FightStagePlayer.gd:122 / IntentBus.gd:56 read `recover_s` today. No existing module computes control return.

## What would a human do?
A real boxer is back in guard and able to move a beat after the punch lands - the arm finishes retracting while he already steps or
slips. He is not frozen for a second watching his own glove come home.

## Prefab check
No GDScript punch-timing library exists; the numbers come from our own clip data + Ludo r119. Pure GDScript, no assets.

## Run (parse gate, then the one test)
`python Godot/tools/check_scripts.py Godot/scripts/rules/PunchTiming.gd Godot/tests/punch_timing_test.gd`
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/punch_timing_test.gd`
(NEVER `_console.exe`). Nothing opens on screen; view nothing. Commit both files, push branch `qwen/punchtiming1`, open a PR whose body
carries `RESULT: tests/punch_timing_test.gd -> PUNCH_TIMING failures=0`.

## The one trap
Never lengthen a lock and never touch clip_phases.json - the module only reads a dict and shortens.

## Contract
OWNS: Godot/scripts/rules/PunchTiming.gd, Godot/tests/punch_timing_test.gd
RED_TEST: Godot/tests/punch_timing_test.gd -> PUNCH_TIMING failures=0
REGRESSION: punch_timing_test
VISUAL: no
