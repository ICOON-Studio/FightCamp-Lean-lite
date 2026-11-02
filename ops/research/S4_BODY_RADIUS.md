# S4 (4) — TWO MEN CANNOT STAND ON THE SAME FLOOR

`RingSpace.step` clamped a man to the ropes and **nothing at all** stopped the two of them occupying
the same square metre. The engine has never had a body. It was invisible for as long as the room
ignored the engine — `FightWorldLiveScreen` turned each beat's range band into a gap on one line and
the band table's smallest distance was 1.07 m — and S4 (2) made it a number the day it wired the real
positions through: **2.3% of frames over one round, 1.3% over three**, inside the sum of the two men's
own torso capsules. S4 (2) wrote `S4-2-1` as a live tripwire saying in as many words that the share
**goes to zero the day the engine gets a radius**. This is that day.

## THE RADIUS IS MEASURED, NOT CHOSEN

`tools/measure_body_radius.gd` fits `FightBodyCapsules`' skin-weight capsules to **all twelve rigged
fighter meshes** — eight male, four female, flyweight to heavyweight, boxing, MMA and bare-knuckle
builds — and reads the widest TORSO capsule off each. Divided by the stature that mesh is mounted at,
the twelve agree:

| mesh | kg | target h | scale | mesh h | r local | r world | ratio |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| f01_m_box_welter | 66.0 | 1.740 | 0.9405 | 1.850 | 0.1769 | 0.1664 | 0.0956 |
| f02_m_box_heavy | 93.0 | 1.890 | 1.0216 | 1.850 | 0.1915 | 0.1956 | 0.1035 |
| f03_f_box_fly | 51.0 | 1.580 | 0.9371 | 1.686 | 0.1722 | 0.1614 | 0.1021 |
| f04_f_box_middle | 75.0 | 1.756 | 1.0376 | 1.692 | 0.1867 | 0.1937 | 0.1103 |
| f05_m_mma_light | 70.3 | 1.782 | 0.9633 | 1.850 | 0.1854 | 0.1786 | 0.1002 |
| f06_m_mma_lhw | 93.0 | 1.890 | 1.8900 | 1.000 | 0.1114 | 0.2105 | 0.1114 |
| f07_f_mma_straw | 52.2 | 1.591 | 0.9435 | 1.686 | 0.1744 | 0.1646 | 0.1035 |
| f08_f_mma_bantam | 61.2 | 1.651 | 1.7112 | 0.965 | 0.1022 | 0.1748 | 0.1059 |
| f09_m_bare_welter | 66.5 | 1.745 | 0.9432 | 1.850 | 0.1871 | 0.1764 | 0.1011 |
| f10_m_bare_heavy | 120.0 | 1.930 | 1.0432 | 1.850 | 0.2091 | 0.2181 | 0.1130 |
| f11_f_bare_feather | 57.0 | 1.620 | 0.9600 | 1.688 | 0.1771 | 0.1700 | 0.1049 |
| f12_f_bare_welter | 66.0 | 1.680 | 0.9943 | 1.690 | 0.1611 | 0.1602 | 0.0954 |

**min 0.09535, median 0.10350, mean 0.10392, max 0.11302 — a 17.0% spread across twelve different
bodies.** The kg cancels out of that ratio (the mount scale is `target_height / mesh_height`), so it
is a property of the human shape rather than of one weight class, and `FightBodyRadius
.TORSO_RADIUS_PER_HEIGHT` carries the mean. **A lean 1.83 m man is 0.190 m half-wide at the chest and
two of them cannot close inside 0.380 m centre to centre.**

There is NO published study of how far apart two boxers' centres can be forced, and none is needed:
this is a body, not a behaviour. The number comes off the meshes the game already ships.

**Girth is the second half, and it is not a new idea either.** `FighterPhysique` has priced thickness
from weight and stature since it was written (`sqrt(weight / lean_weight)`, clamped 0.85..1.30) and
the room already widens the mesh with it. The engine multiplies by the SAME function, so a heavyweight
takes more floor than a flyweight and the number the engine enforces is the number the picture draws.
Two different men get two different radii — the identical-fighters rule reaches this file too.

## WHAT LANDED

- **`Godot/scripts/FightBodyRadius.gd`** (new). `of(height_cm, mass_kg)` prices one man's half-width;
  `separate(a, b, ra, rb, half_width, shape, slack)` pushes two overlapping men apart and hands back
  where they end up.
- **`FightRealtime`**: `radius_m` settled once per fighter in `_build_fighter`, beside `top_speed`
  and for the identical reason; `_resolve_bodies` called at the end of `_run_movement`, behind the
  `body_radius` switch, **default ON**.
- **`Godot/tools/measure_body_radius.gd`** (new). The instrument above.
- **`Godot/tests/fight_body_radius_test.gd`** (new). The gate, 19 checks.
- **`fight_room_positions_test`**: S4-2-1 promoted from a printed tripwire to a real check, and its
  floor corrected (below).

**AFTER THE LOOP, NEVER INSIDE IT.** `_run_movement` walks `for side in ["a", "b"]` sequentially, so
resolving per side would hand `a` — always first — a free half-step into `b`, a privilege nothing in
the sport gives him. The resolve runs once, symmetrically, on both settled positions.

**THE OTHER MAN TAKES YOUR MOMENTUM — BUT ONLY THE HALF OF IT THAT IS TRUE, AND THE FIRST CUT GOT THIS
WRONG.** The wall twenty lines up rewrites velocity FROM the displacement it allowed, because a wall
really does truncate where you got to. A body does not: being pushed out of an overlap is a
**positional correction, not momentum gained**. The first cut copied the wall anyway, and a 0.02 m push
over a 20 Hz tick reads as 0.4 m/s of speed a man never accelerated to. **Two gates caught it**:
`fight_body_layers_live_test`'s S4-3-4 saw a man carried at walking pace with no locomotion under him
and called it a slide, and the spurious speed fed `FightFootwork`'s inertia the next tick, which moved
enough of the fight that `fight_bearing_test`'s R21 lost the off-arc moments its A/B depends on.
`_settle_body` now removes the **closing component** of his velocity and adds nothing.

**THE ROPES GET THE LAST WORD.** Each man is clamped to the floor after his push, and a man already
pinned cannot take his half, so whatever the floor refuses is offered to the other man. That is what
working a man onto the cage has to mean once bodies are solid.

**NO DRAW.** `_rng_movement` is not consulted here at all, so R82's stream discipline is untouched and
a switched-off run is byte-identical to S4 (3).

## THE A/B, SIX SEEDED THREE-ROUND BOUTS

Population, named in the test's own output: an **out-boxer** (188 cm, 79 kg, reach 190, speed 72,
technique 70) against a **pressure fighter** (177 cm, 80 kg, reach 175, power 70, conditioning 76)
under BOXING rules from `assets/data/combat_rulesets.json`. Two statures, two masses, two plans,
neither missing a technique boxing permits. Their radii are **0.1926 m and 0.1938 m** — not one shared
constant.

| | OFF | ON |
| --- | ---: | ---: |
| ticks | 57,362 | 57,824 |
| **inside 0.3864 m** | **1.99%** | **0.00%** |
| closest approach | — | 0.3867 m |
| mean gap | 1.3299 m | 1.3367 m |

The mean gap moves **+0.0068 m** and stays inside Schortgen's (ECSS 2023, via K50) 1.23 ± 0.16 m band
both ways. In the room (`fight_room_positions_test`, seed 94301, one round) S4-2-1 reads **0.00%** and
travel per round moves 134.8 → 143.6 m against Thomson's 108 and Schortgen's 155 ± 28.

## TWO THINGS THE STAGE FOUND

1. **THE S4-2-1 FLOOR WAS IN MESH UNITS, NOT METRES.** `FightBodyCapsules` fits its capsules in
   SKELETON-LOCAL space and every caller that poses them multiplies by the mount scale
   (`_pose_parts`). `fight_room_positions_test._torso_radius` did not, so the tripwire compared
   world-metre body positions against a floor in mesh units and printed **0.364 m** for two men whose
   real torsos sum to **0.343 m**. Both meshes happen to mount at about 0.94, so the error was 6% and
   in the SAFE direction — the share it reported was if anything too high. `build_body_model` now
   returns `scale` so there is one place to get it. *A reason a file gives is a claim, and claims get
   checked — this is that rule applied to a number a test printed.*

2. **THE MILLIMETRE GRID PUTS THEM BACK INSIDE EACH OTHER IF YOU LET IT.** Positions are stored as
   fixed-point millimetres (`Quantise.SCALE` 1000), so a pair resolved to EXACTLY touching is rounded
   afterwards and can land up to `sqrt(2) / SCALE` back inside. Measured: **1.2 mm, and it left 0.01%
   of ticks still overlapping** after the first cut of this stage — a gate that passed everything
   except the thing it was written for. The engine now passes that worst case to `separate` as
   `slack`, read off the quantiser rather than typed in.

## WHAT THIS DELIBERATELY DOES NOT DO

**The split is EQUAL** — each man backs off half the overlap. Weighting it by mass so the lighter man
gives more ground is physically reasonable and has **NO STUDY** behind it, so it would be a second
claim riding on this one's back. It stays out, named here, as its own slice if anyone ever measures
it. This stage makes exactly one claim: two solid bodies do not interpenetrate.

## OPEN

1. **A RADIUS IS NOT A CLINCH.** Two men held apart at 0.39 m is correct for a strike exchange and is
   NOT what a clinch looks like, where the torsos genuinely touch and the arms tie up. Nothing in the
   engine distinguishes the two states, so a clinch is currently a hard 0.39 m stand-off. Its own
   slice, and it wants the grappling work the operator parked ("Leave grappling for later",
   2026-09-14).
2. **THE MEAN GAP MOVED +6.8 mm AND NOBODY ORDERED THAT.** It is small, it is inside the band, and it
   is a real consequence: men who used to pass through each other now get pushed. Reported rather than
   tuned.
3. Carried untouched from S4 (2)/(3) and still open: the strafe clips' own stride against the engine's
   lateral speed (`loc_strafe_right` 0.75 m/s × 17,886 frames); `boxing_feint` reachable-but-unselected;
   the openers still have no real-time consumer; the MMA leg share at 7.5% against J20's 14-18%.

## Re-running it

```
python Godot/tools/check_scripts.py Godot/scripts/FightBodyRadius.gd Godot/scripts/FightRealtime.gd
godot --headless --path Godot --script tools/measure_body_radius.gd
godot --headless --path Godot --script tests/fight_body_radius_test.gd
godot --headless --path Godot --script tests/fight_room_positions_test.gd
```

## THE INTEGRATION RUN, AND WHAT IT TAUGHT

`python Godot/tools/run_tests.py --timeout 1200` at 71095b78: **SUITE total=303
fails=11** against master's known five (`athlete_development`, `fight_pair_live`,
`fight_scoring`, `fight_stage_presenter_contract`, `fight_stage_realism`). So six moved,
and **not one of them was the stage being wrong** — four were tests that had been
measuring the defect this stage removed, and two were rare events whose single seed
moved.

### FIXED AND GREEN

| test | what it was | outcome |
| --- | --- | --- |
| `fight_collision_floor_test` (Q35) | costed candidate floors of 0.30/0.45/0.60 m over 200 bouts | 0.30 asserted EMPTY now; **8 checks pass**, separation min **0.3877 m over 2,509,455 ticks** |
| `fight_pushapart_test` (C84) | costed a post-movement minimum-separation constraint, **equal split**, post hoc | 0.30 asserted EMPTY; **16 checks pass** |
| `fight_beat_adapter_test` | one MMA seed had to produce a grapple event | widened to six seeds after measuring; **214 events in 5 of 6 bouts**, 559 checks, 0 fails |
| `fight_bearing_test` | R21's off-arc A/B | condition injected; R22 added; **3 checks pass** |
| `fight_body_layers_live_test` | S4-3-4 slide floor | taken off `FightClipBinding`; **25 checks pass** |
| `judge_panel_test` T4/T8R | eleven seeded scorecards | all eleven re-pinned **from the log**, not by hand |

### C84 IS THE PRIOR ART AND IT NAMED THE METHOD

`fight_pushapart_test` is C84 — *"first-order costing of a post-movement
minimum-separation constraint"* — and its header says the method in as many words:
**"the smallest EQUAL SPLIT that would restore the candidate separation"**, costed post
hoc because *"applying that correction live would change the next decisions and all
later positions"*. S4 (4) is the live implementation of C84, with the same equal split.
The choice this digest recorded as a deliberate non-take was already this project's own
conclusion; it was simply never wired.

### THE GROUND GAME SURVIVES — the one answer that could have sunk the stage

`tools/probe_grapple_reach.gd`, 12 bouts x 3 rounds, both arms, two fixtures:

| | in range | gap p05 | gap min | clinches | takedowns | throws |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| A off | 26.99% | 0.5688 | **0.0085** | 19 | 2 | 6 |
| A on | 25.82% | 0.5949 | **0.3878** | 13 | 4 | 3 |
| B off | 27.21% | 0.5505 | **0.0071** | 12 | 5 | 4 |
| B on | 25.90% | 0.5951 | **0.3980** | 15 | 3 | 5 |

Ticks inside `GRAPPLE_RANGE` lose about 1.2 points; clinches, takedowns and throws stay
the same order and the measured-bodies fixture rises on two of three. **The two men were
standing 8.5 mm and 7.1 mm apart before this stage.** `fight_realtime_test`'s own totals
agree: `R91 TAKEDOWNS bouts=40 attempts=30 kept=15`, `R92 CLINCH clinches=29`, `R93 JUDO
osaekomi_rounds=14`.

**Note the fixture, because it is a finding of its own:** `fight_beat_adapter_test`'s MMA
pair carries neither `height_cm` nor `competition_weight_kg`, so both men fall back to
`FightFootwork`'s reference build and come out with the SAME radius. Population B exists
to keep the probe off two identical bodies.

### FIGHTS RUN LONGER, NOT SHORTER

Recorded because the first reading of the judge cards had it backwards. `boxing_20`'s KO
moved from round 3 to round 6; `boxing_300` went from a round-3 KO to an eight-round
decision; `mma_5` from a round-2 KO to a three-round decision. Men held apart land
slightly less.

### CLOSED 2026-09-16 — ALL FOUR RE-FOUND, NOTHING RE-PINNED GREEN

`f16371cc`. The four items below are the list as it stood when the engine stage
shipped; each one now carries what the sweep actually returned. **Not one
occurrence assertion was relaxed to get there**, and the one place where that was
tempting — boxing losing both of its non-unanimous decision families at once — is
reported instead of bought.

| item | was | is | how |
| --- | --- | --- | --- |
| `judge_panel_test` T11 split | kickboxing 160 | **kickboxing 194** | the paid-for panel sweep |
| `judge_panel_test` T11 majority | boxing 222 | **kickboxing 32** | the same sweep; boxing reaches neither family |
| `grapple_adapter_test` MT witness | 93014 | **93024** | `find_r102_seeds.gd -- mt`, 19 of 400 |
| `fight_realtime_test` final bell | 7002 | **7003** | `find_s4e2_seeds.gd -- distance`, still 30 of 40 |
| `fight_realtime_test` three-knockdown TKO | 77076/77093/77149 | **77047/77086/77155** | `find_r101_seeds.gd -- tko`, 13 of 400 |
| `fight_realtime_test` third shido | 94007/94020/94022 | **94007/94020/94026** | `find_r101_seeds.gd -- judo`, 10 of 100 |
| the two judo occurrence tests' window | 93000..93023 | **93017..93040** | `find_s4_4_seeds.gd -- judowindow`, NEW |

**T11 IS THE ONE WORTH READING TWICE.** Boxing 1..300 now returns 205 unanimous,
22 unanimous_draw, 69 stoppages and **four `majority_draw` and nothing else** — no
split, no majority. Every previous re-find kept T11's two examples in different
rulesets; keeping that shape here would have meant asserting `majority_draw` where
the test says `majority`, which turns a decision for a winner into a draw. That is
the quiet relaxation R85 forbids, so the cross-ruleset coverage was given up
instead and both halves come from kickboxing, which reaches both families for
real. What was lost is recorded in the test; what was asserted did not move.

**THE THREE-KNOCKDOWN COLUMN, seven stages of one quantity over the identical
77000..77399:** R84 19 / R86 8 / R101 20 / R102 14 / S4e 13 / S4e (2) 18 / **S4 (4)
13**. A floor under the gap should make a three-knockdown round slightly harder to
reach, and it did. None of S4e (2)'s three survived.

**THE JUDO ENDINGS WENT THE OTHER WAY, which is the interesting one:** 13 ippon /
15 shido / 4 KO / 68 decision (S4e) → 10 / 9 / 4 / 77 (S4e (6)) → **14 / 10 / 5 /
71**. The last two stages both pushed judo contests toward running out the clock;
holding the pair apart pushed finishes back. Reported, not tuned — no constant was
moved in either direction.

**A PIN CAN BE A WINDOW RATHER THAN A SEED, AND THEN THE WINDOW IS WHAT MOVES.**
The two judo occurrence tests do not pin seeds; they both sweep the same 24 and
assert over the totals. After the body radius the four throws that window still
landed all came down in `half`, so judo's yuko band went unreachable and
`throw_points_round` lost its writer again. Picking seeds that produce a `side`
landing would have been choosing the population — the thing the identical-fighters
rule exists to stop — so `tools/find_s4_4_seeds.gd` slides the window instead: it
measures 93000..93199 on the exact test fixture, reports what the ENGINE can reach
before it reports which window reaches it (200 bouts, 42 throws, `half` 30 /
`side` 12, bands `not_scored` 30 / `yuko` 12, **and not one throw into mount or
back in any of them**), and names 93017 as the first start where every assertion
both tests make holds at once. The reported waza-ari finding therefore now rests on
five times as many bouts as the window itself sees.

### THE LIST AS IT STOOD WHEN THE ENGINE STAGE SHIPPED

1. **`judge_panel_test` T11** — needs a SPLIT and a MAJORITY re-found, never re-pinned
   green. `tools/find_r101_seeds.gd -- panel` has already been run and its answer is
   here, so do NOT pay for it again:
   - **boxing 1..300 has NO split and NO majority** — 205 unanimous, 22 unanimous_draw,
     69 stoppages, and **4 majority_draw only: 13, 143, 153, 284**.
   - **kickboxing 1..300**: split at **194** and **260**; majority at **32, 82, 105, 106,
     120, 221, 258**; plus 3 majority_draw, 27 unanimous_draw, 232 unanimous.
   The precedent in the test's own comments for the run where boxing lost its split is
   "the two non-unanimous families that DO occur". Boxing now has only `majority_draw`.
2. **`grapple_adapter_test`** — six striking figures to re-pin from the printed actual,
   and the muay thai witness seed to RE-FIND with `tools/find_r102_seeds.gd -- mt`.
   **That sweep has NOT been run**; it was launched and killed by accident (see below).
3. **`fight_realtime_test`** — seven: the final-bell check, the three-knockdown stoppage
   seeds, the judo throw-scoring rounds (4 throws landed, all in the `half` seat, all
   banded `not_scored`), and the shido seeds. All rare-event seeds to re-find.
4. **The final clean full suite has not been run.** The 303/11 above is the run that
   FOUND this work, not the run that closes it.

### A TRAP THIS SESSION PAID FOR TWICE

**A `kill`/`pkill` pattern matches the job as well as the watcher.** `pkill -f
'<logfile>'` killed the very waiter that was grepping that log, and later `kill` on a
pattern drawn from a sweep's own `echo "=== SWEEPS DONE ==="` killed the sweep runner
between its two halves — the panel sweep survived only because it had already printed.
Match on the PID from `ps -eo pid,etime,args`, never on a string the job itself contains.
