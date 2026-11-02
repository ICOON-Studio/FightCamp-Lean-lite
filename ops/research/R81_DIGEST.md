# R81 digest — The camp under the burst, and the hand skill steadies

**Agent:** claude · **Date:** 2026-09-09

Closes the follow-up named in BOTH the R80 and C61 digests. The burst R80 built
and U19 printed was real data that no fighter's own history could reach: it read
the same for everyone. It now reads the camp and the skill.

## 1. The camp reaches the jab share

`_build_fighter_state` derives `jab_commitment` (0..1) once per bout from
`technique_progress` — learned lead-hand moves count whole, mid-camp ones count
`reps_completed / requires.reps`, and two fully drilled moves is full
commitment. `_write_burst` adds `JAB_CAMP_SHIFT * jab_commitment` last, after
the headline tilt, before the clamp.

**A fighter who drilled the jab all camp now throws more of it.** That sentence
was false until this landed.

## 2. Skill steadies the hand — measured, not asserted

Every `_burst_rng` span is scaled by
`jitter = lerpf(1.0, BURST_JITTER_FLOOR, technique/100)`, floor `0.45`. 2,000
bursts per level, everything but Technique held constant:

| Technique | `jab_share` SD | `thrown` SD |
| --- | --- | --- |
| 10 | 0.0274 | 0.635 |
| 30 | 0.0241 | 0.563 |
| 50 | 0.0209 | 0.461 |
| 70 | 0.0179 | 0.334 |
| 95 | 0.0138 | 0.147 |

Monotonic. Spread roughly halves on the share and falls to under a quarter on
volume. The floor is deliberate: a master is steadier, never robotic.

## 3. What this settles about C61

**C61's measurement stands and is not reopened** — skill genuinely does not
narrow the *outcome* roll (land-rate SD .0784 → .0864 as Technique rises). C61
was not wrong; it was looking at the wrong surface. Repeatability was never in
the roll that decides who wins, and C61's own honest read was that its
mechanism "barely does anything" (73.6% → 74.0% over 500 bouts).

It belongs on the **texture**, which is drawn after the outcome and printed
straight to the broadcast panel — where the table above is what a player would
actually see. **Recommendation: leave `options.consistency` off and do not
delete it.** It is dormant, tested, costs nothing switched off, and its 200-bout
probe tables are the evidence for why the narrowing lives here instead. Deleting
it would throw away the measurement that justifies this design.

## Determinism

Unmoved, and this is the constraint the whole system hangs on. Each jitter span
is still **exactly one draw** — only its width changed — so the `_burst_rng`
stream keeps its length and its alignment. `{"burst": false}` replays
byte-identically, winner and method included; `judge_panel_test.gd`'s ten pinned
cards did not move; `fight_simulation_test` went 253 → 259 checks, 0 failures.

## The isolation that made it testable

Adding jab techniques to a fixture changes the move pool and therefore the
fight. Reps on an **unlearned** technique do not — an unlearned move never
enters `technique_cache` — so commitment moves while the fight stays
byte-identical. The test asserts that identity as well as the share, which is
what proves the camp is texture and not outcome.

## Verify

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_simulation_test.gd
```
→ `fight_simulation_test: 259 checks, 0 failures`
