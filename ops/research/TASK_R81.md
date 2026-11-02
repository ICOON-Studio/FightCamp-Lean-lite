# TASK R81 — CLAUDE — THE CAMP UNDER THE BURST, AND THE HAND SKILL STEADIES

**Model:** Opus 5 · high effort · Fast off — `FightSimulation.gd` is 2,954 lines.

## Why

Two digests named the same gap and both stopped at it.

- **R80:** the burst's `jab_share` is driven by stance, band and the technique
  thrown. It does **not** read `technique_progress`
  (`AthleteDevelopment.gd:83`), so a fighter who drilled the lead hand every
  session of a camp throws the same share as one who never touched it.
- **C61:** "R80's burst texture remains flat regardless of skill. Narrowing
  burst jitter is the explicitly named follow-up and is out of scope here."

C61 also proved, with numbers, that skill does **not** narrow the *outcome*
roll — land-rate SD went .0784 → .0864 as Technique rose across 200 seeded
bouts per level, i.e. it widens slightly. That result is not reopened. The
claim here is the narrower one C61 left standing: skill narrows the **texture**,
which is drawn after the outcome is already decided and can never move a fight.

## Owned files

- `Godot/scripts/FightSimulation.gd` — **2,954 lines, never open it whole.**
  Anchors: `:368` (`JAB_MARKERS`, add constants after `REAR_HAND_MARKERS`),
  `:859` (`_build_fighter_state`), `:3137` (`_write_burst`).
- `Godot/tests/fight_simulation_test.gd` — append tests; register at `:55`.
- `research/R81_DIGEST.md` — new, short.

## Contract

1. `_build_fighter_state` derives `jab_commitment` (0..1) once, from
   `technique_progress`. Learned lead-hand moves count whole; mid-camp ones
   count `reps_completed / requires.reps`. `JAB_COMMITMENT_FULL = 2.0`.
2. `_write_burst` adds `JAB_CAMP_SHIFT * jab_commitment` to `jab_share`, last,
   after the headline tilt and before the clamp.
3. Every `_burst_rng` span is scaled by
   `jitter = lerpf(1.0, BURST_JITTER_FLOOR, technique/100)`. **Each span stays
   exactly one draw**, so the stream keeps its length.

## The gates

- `{"burst": false}` still replays byte-identically — winner and method
  included. This is the hard one; the burst may never move a fight.
- `judge_panel_test.gd`'s ten pinned cards must not move.
- The burst contract is unchanged: five keys, `thrown`/`landed`/`defense_used`/
  `steps` ints, `jab_share` a float clamped 0..1, `landed <= thrown`.
- Ceiling, not a floor: suite `fails=0`; if it is lower, say so and push.

## The trap

Adding jab techniques to a fixture to test the camp **changes the move pool**
and therefore the fight, which confounds the measurement. Use reps on an
**unlearned** technique instead: an unlearned move never enters
`technique_cache`, so the fight stays byte-identical while commitment moves.
That identity is itself worth asserting.

## Verify

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_simulation_test.gd
```
