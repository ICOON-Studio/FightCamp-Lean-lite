# R87 — THE INERT MODULES GET A CONSUMER

Claude, 2026-09-09. Base `2537f11` (`SUITE total=207 fails=0` before the two
merges). Ends `SUITE total=209 fails=0`.

## What shipped

`FightTrauma` (G32) and `Cardio` (Q17) are reached by a real fight. C66's
integration test — RED BY DESIGN, measuring trauma at 0 pips across 40 bouts,
range 0..0 — is green, unedited and unweakened.

Two merges first, both gate PASS, both additive with no file overlap:
`cursor/u25-fight-hud-panel-26c5` (`15fbf9f`) and
`cursor/u24-scorecard-panel-80cb` (`23617da`). They took the baseline from 207
to 209, which is why the task's predicted 207 reads 209 here.

## Engine changes — `FightRealtime.gd` (982 → 1117)

* `SEED_TRAUMA` beside the other five, `_rng_trauma` beside the other four.
* `_build_fighter` carries `age_years` (settled once, beside `conditioning`)
  and `trauma` (`FightTrauma.fresh()`, a new dictionary per man).
* `_run_impact` gains channel three: three unconditional draws off
  `_rng_trauma`, then `FightTrauma.aggravate` applied to the target's face.
* `_pick_face_site(roll)`, walked over `FightTrauma.SITES` in the module's own
  order rather than over this file's weight dictionary.
* `trauma_opened` state counter — a mark emits no event, so without it the
  channel is invisible to any test that reads the log.

## The two rulings the task asked for explicitly

### 1. Which face site a head impact picks

`FightTrauma.SITES` has six face sites and no `head_neck`. The pick is
**weighted, not uniform**, and both halves of the rule reuse something already
authored rather than inventing a knob:

* **Which blows can mark a face at all.** `TRAUMA_FORCE_FLOOR :=
  Impact.LIVER_CLASS_FORCE_FLOOR` (0.80). A jab that lands perfectly clean does
  not cut anybody; it takes a hard one. The force that folds a liver is the
  force that splits a brow, and one constant covers both rather than two that
  can drift apart.
* **How badly.** The force handed to `aggravate` is
  `force × CONTACT_WEAR_COEFFICIENTS[contact]` — clean 1.0, glancing 0.4,
  absorbed 0.25, and **0.0 for blocked, slipped and missed**. Those three
  therefore produce `aggravate_chance` of exactly zero and can never mark a
  face *without a second test in the engine*, the same way `shock_chance` needs
  no second liver test.
* **Where.** `FACE_SITE_WEIGHTS`: brows .20/.20, nose .18, eyes .15/.15, lip
  .12. Authored, because a flat sixth apiece says a lip splits as often as a
  brow and no fight has ever looked like that. Bone under thin skin cuts first.
* **Cut or swelling.** Off the *reach*, not the thrown force:
  `cut` if `roll < 0.25 + 0.45 × reach`. The flush shot splits, the scraping
  one puffs — so the two contact words leave visibly different faces.

Measured over 24 whole bouts (48 men), reported and **not pinned**:

```
marked=35/48 men  opened=107  pips_total=107  pips_max=7
kinds={cut: 57, swelling: 50}
sites={left_brow: 22, right_brow: 23, nose: 24, left_eye: 15, right_eye: 14, lip: 9}
```

The site histogram tracks the weights, both kinds occur, and neither zero nor
everybody is marked. C66's own sweep: `marked 39/40 bouts, range 0..5 pips`,
cardio `115 → 148 bpm, observed 134..149`.

### 2. Inside or beside the seven-draws assertion — **BESIDE**

`_test_the_impact_stream_still_takes_seven_draws` measures `_rng_impact` by
replaying that one generator. A trauma draw off a separate stream is outside
that count *by construction*, so the assertion is unchanged, still literally
seven, and still true. Widening it to eight would have meant drawing trauma off
`_rng_impact` — the exact trap the task named.

A stream with no draw-count gate of its own is how the next widening arrives,
so `_rng_trauma` gets the same witness: **three draws per built impact, none
per rejected attempt**, measured by replaying the generator, not by trusting
the comment. Both trauma draws sit beside `_rng_stoppage`'s three and are taken
unconditionally, whether or not this blow can mark anybody.

## Gates

| Gate | Result |
| --- | --- |
| C66 green, unedited | PASS — `failures=0`, both modules reached by occurrence |
| R82 replay unmoved | PASS — and **extended**: the gate now compares faces too |
| R85's nine pinned cards | PASS — *all identical*, `judge_panel_test.gd` T4/T8R |
| `aggravate` not mutated in place | PASS — return value stored; C66 asserts purity |

The cards not moving is the whole point of the separate stream. Had trauma
drawn off `_rng_impact`, the seeded-replay test would have stayed green — a log
replays against itself either way — while all nine cards moved at once.

## Tests added to `fight_realtime_test.gd` (837 → 1085, 179 → 192 checks)

* `_test_the_face_is_actually_marked` — the occurrence sweep above. Asserts
  both directions: marks occur, *and* not every man in every fight is marked.
* `_test_only_a_hard_head_shot_ever_marks_a_face` — every mark traced back to
  its own blow, through whole real fights.
* `_test_the_trauma_stream_takes_three_draws` — the R84 draw discipline,
  measured on the new stream.
* `_test_the_age_is_settled_once_on_the_man` — `age_years` wins, the athlete
  record's `age` is accepted, junk falls back rather than walking into
  `220 - age`.
* `_test_a_seeded_fight_replays_exactly` — faces added to the gate. A face is
  STATE, not an event, exactly like `body_condition`.
* `_test_each_subsystem_has_its_own_stream` — generalised. It swept three
  hand-written names and so never noticed R84's `_rng_stoppage`; it now sweeps
  the state's own `_rng_*` keys for pairwise-distinct seeds, and the next
  stream anybody adds is covered without touching the function.

## Found on the way

* **The first draft of gate two hammered `_run_impact` in a 600-call loop and
  opened ZERO marks.** Nothing ticks in that loop, so `FightStamina` empties
  both men inside a hundred calls and R86's `output_multiplier` closes the gate
  on nearly every one after that. A probe that gasses its own subjects measures
  a fight nobody had. It was rewritten to trace real fights through
  `advance_tick`.
* **R75, live.** That same broken draft printed two `SCRIPT ERROR` lines and
  then `FIGHT_REALTIME_TEST PASS (179 checks)`, rc=0. The runner caught it; an
  exit-code gate would have called it green.
* **`Cardio` is reached by the FOLD, not by the engine, and that is correct.**
  A heart rate is a pure projection of stamina, conditioning and age. Storing
  it in authoritative state would be carrying a derived per-tick float across
  ticks, which is what C62 ruled out. The engine's job was `age_years`;
  `FightHudRead.fold` (Q18, already landed) does the arithmetic.

## Follow-up worth a task, not built here

A mark currently leaves **no beat in the log** — only the `trauma_opened`
counter and the final face. A broadcast wants "the cut opened over the left eye
at 2:14 of round three", and a replay cannot reconstruct it from the counter.
Adding `trauma_site` / `trauma_kind` to the impact record is a small, contained
change to the event shape, and it is the natural consumer for
`FightTrauma.words()`. Left out because this stage's job ended at the engine
producing the numbers.

## Verify

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_reaches_its_modules_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_panel_test.gd
python Godot/tools/run_tests.py
```
