# TASK R87 — CLAUDE — THE FIGHT YOU CAN WATCH: THE INERT MODULES GET A CONSUMER

Model: Opus, high effort, Fast off. Owner: Claude. **Fresh session — R85 shipped
at `0e045d8`; do not start this inside that session.** Base: `c885c5f`,
`SUITE total=204 fails=0`.

---

## Why this stage exists

**Seven pieces of correct, tested, unreachable code now sit in this area.**
`FightTrauma.gd` (G32, cuts and swelling in pips) and `Cardio.gd` (Q17, a heart
rate) are the sixth and seventh. Both shipped green, both have their own passing
tests, and **nothing calls either one.** Five before them were the same, and
three of those turned out to be defective in ways no test could see, because a
test that checks a function in isolation never asks whether the pieces can line
up.

This stage is the consumer. **Assert that the feature OCCURS, not that it is
permitted** — that is the standing lesson and it is the gate here.

## What to do

1. **Merge U24 AND U25 first — both are finished and unmerged.** U25 landed
   2026-09-09 on `cursor/u25-fight-hud-panel-26c5` (`15fbf9f`, gate PASS, focused
   54/0, suite 205/0): `FightHudPanel.gd` 403 lines, its test 238, a capture tool.
   It renders a `FightHudRead` fold as plain DATA with no preload of that module,
   so it merges cleanly whether or not Q18 has landed. Then the scorecard screen on
   `cursor/u24-scorecard-panel-80cb` (`23617da`, gate PASS): `ScorecardPanel.gd`
   408 lines, `scorecard_panel_test.gd` 198, plus a capture tool and digest.
   Review it, merge to `master`, run the suite. It is the natural consumer for
   the nine cards R85 just pinned. Do this before touching the engine so its
   test count is in the baseline.
2. **Wire `FightTrauma` into `_run_impact`.** A head impact can open or worsen a
   mark. `aggravate(trauma, site, kind, force, roll)` **takes the roll rather
   than drawing one** — Q15's pattern, and the whole reason a seeded fight stays
   seeded. So this needs **its own RNG stream** (`SEED_TRAUMA`, beside
   `SEED_IMPACT`), never a draw off an existing one, or R82's replay gate moves.
   The seven-draws-per-impact assertion in `fight_realtime_test.gd` is a
   witness: decide whether trauma draws are inside that count or beside it, and
   say which in the digest.
3. **Carry `age_years` onto the fighter.** `Cardio.from_stamina(stamina,
   conditioning, age_years)` and `Cardio.zone(bpm, age_years)` both need an age
   and `_build_fighter` does not carry one. Settle it once in `_build_fighter`
   beside `conditioning`, `preferred_range` and `tolerance` — all three are
   already settled-once for exactly this reason.
4. **Trauma sites are a mapping decision, and it is yours to rule.**
   `FightTrauma.SITES` is `left_brow, right_brow, left_eye, right_eye, nose,
   lip` and it has **no `head_neck`** — deliberately, because attrition is
   continuous and trauma is discrete. The engine emits `head_neck` as one
   region. So a head impact must pick a face site, and that pick needs a rule
   and a draw. Rule it explicitly; an implicit uniform pick is a decision you
   made without noticing.
5. **Do NOT build the screen.** U25 (Cursor) owns the HUD and Q18 (Qwen) owns
   `FightHudRead.gd`, the pure fold between the two. Your job ends at the engine
   producing the numbers.

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/scripts/FightRealtime.gd` | 940 | Owned. **Never whole.** `begin` `:181`, `_build_fighter` `:~240`, `advance_tick` `:344`, `_close_round` `:475`, `_run_impact` `:707`. Seed constants and `_stream` near `:230`. |
| `Godot/tests/fight_realtime_test.gd` | 837 | Owned. Never whole. `_test_impacts_carry_u20s_record` `:224`, `_test_each_subsystem_has_its_own_stream` `:275`, `_test_the_impact_stream_still_takes_seven_draws` `:654`. |
| `research/R87_DIGEST.md` | — | Yours. New. |

Read-only: `Godot/scripts/FightTrauma.gd` (158 — read whole; `SITES` `:16`,
`aggravate` `:48`, `worst` `:64`), `Godot/scripts/Cardio.gd` (122 — read whole;
`from_stamina` `:83`, `zone` `:106`). **`GameState.gd` is 12,900+ lines — never
open it whole.**

## Gates

1. **Both modules are REACHED in a real fight**, asserted by occurrence: run a
   seeded bout and assert trauma pips actually accumulate above zero and a heart
   rate actually moves across rounds. A test that only checks the call is
   permitted is the failure this stage exists to end.
2. **R82's replay gate is unmoved**: log, bodies, scorecards, result and
   stoppage byte-identical across two runs of a seed. A new RNG stream must not
   perturb the existing ones.
3. **R85's nine pinned cards do not move.** If they do, the wiring changed the
   fight, and that is a finding to report before it is a re-pin. Never "fix" a
   red card by re-pinning it.
4. `FightTrauma` is not mutated in place — `aggravate` returns a copy and the
   caller must use the return value.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/fight_realtime_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_panel_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`, `total` at least 204 (higher once
U24 and the sibling tasks land; if it is higher, say so and push).

## The trap specific to this task

**A new RNG stream is the easy way to silently break the replay gate.** Draw a
trauma roll off `_rng_impact` and every subsequent impact in the fight shifts —
the log still replays against itself, so the seeded-replay test stays green
while R85's pinned cards all move at once. If those cards move, suspect the
stream before you suspect the cards.
