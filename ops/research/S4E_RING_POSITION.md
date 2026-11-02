# S4e (1) — RING POSITION AND THE CAGE: WHAT THE ENGINE DID, WHAT IT DOES NOW, AND WHAT IS STILL WRONG

Claude, 2026-09-15. Stage S4e (ENGINE FIRST, operator ruling 2026-09-14 night). Measured with
`Godot/tools/measure_ring_position.gd` through the production path (`FightRealtime.begin` / `advance_tick` /
`place_of`); gated by `Godot/tests/fight_ring_position_test.gd`.

## POPULATION

Two bouts, 30 seeds each, both pairs NON-IDENTICAL and both men LEGAL for the ruleset they fight under — differentiated
by style and attributes inside it, never by removing a technique the ruleset permits (operator rules 2026-09-12).

| bout | floor | A | B |
|---|---|---|---|
| BOXING, 8x180 s | ring, half_width 3.00 m (6 m square) | Out-boxer: reach 190, 188 cm, 79 kg, speed 72, power 48, fight_iq 68 | Pressure fighter: reach 175, 177 cm, 80 kg, speed 52, power 70, fight_iq 48 |
| MMA, 3x300 s | cage, half_width 4.55 m (9.1 m flat to flat) | Striker: reach 188, 185 cm, 84 kg, speed 68, grapple 35 | Grappler: reach 180, 180 cm, 84 kg, speed 55, grapple 78 |

## WHAT WAS THERE BEFORE — three findings, all from the code and the measurement

1. **THE ENGINE CIRCLED ONE WAY.** `FightRealtime._run_movement` set the circle direction to
   `Vector2(-toward.y, toward.x)` and nothing else, so handedness on the `circle` intent read **+0.910, +0.923, +0.920
   and +0.926** on a −1..+1 scale for all four men. The residual 4% is inertia carrying a man through the other side,
   not a decision. Nothing ever chose a direction, and nothing could change one.
2. **THE CAGE WAS A SQUARE BOX.** `combat_rulesets.json` has carried `"arena_profile": "mma_cage"` and
   `"arena_label": "Cage / Octagonal Competition Area"` from the beginning; `rg -n arena_profile` finds consumers in
   `RingStagePanel.gd` and `UIKit.gd` **and nowhere in the simulation**. Every MMA bout was fought in a 9.1 m square
   with four 90-degree corners.
3. **NOBODY CUT ANYBODY OFF, AND NOBODY NEEDED TO.** `close` walked at where the other man *is* — pure pursuit. While
   one man retreated and the other closed, the gap still shrank at **−0.399 m/s** (ring) and **−0.466 m/s** (cage),
   because a 6 m box leaves nowhere to run. The pair's centroid sat **2.20 m** from the centre of a 3.00 m half-width
   ring: the fight lived against the boundary, not in the middle.

## WHAT CHANGED

- `RingSpace.gd` — an additive `shape` argument, defaulting to `SHAPE_SQUARE`. `ring_space_test.gd` pins the square path
  and is byte-green. `SHAPE_OCTAGON` is a regular octagon whose eight walls all sit `half_width` from the centre, and
  `shape_for_arena` maps `mma_cage` to it and everything else to a square. New: `wall_margins` and `open_room`.
- `FightRealtime.begin` — settles `arena_shape` once, off the ruleset's own `arena_profile`, beside `preferred_range`
  and `top_speed`. Two switches, `cut_off` and `circle_out`, both ON, exist so each change can be measured alone.
- `FightRealtime._run_movement` — `close` aims at where the other man WILL be (his carried velocity times
  `CUT_OFF_LEAD_S`, scaled by the chaser's `fight_iq`); `circle` picks the side with more open floor, with a deadband.
  **No new random draw**: the movement stream is untouched and seeded replay is unaffected in kind.

`CUT_OFF_LEAD_S`, its `fight_iq` scaling, `CIRCLE_PROBE_M` and `CIRCLE_ROOM_DEADBAND_M` are **AUTHORED** and labelled as
such in the source. No published study gives any of them.

## BEFORE AND AFTER (30 seeds per bout, round time only, rest excluded)

| bout | fighter | boundary share | corner share | circle handedness | pinned spells/min |
|---|---|---|---|---|---|
| BOXING | Out-boxer | 42.3% → **45.3%** | 6.3% → **20.9%** | +0.910 → **+0.204** | 7.19 → 5.33 |
| BOXING | Pressure fighter | 38.9% → **12.8%** | 6.9% → **4.3%** | +0.923 → **+0.004** | 7.23 → 4.39 |
| MMA | Striker | 25.6% → **4.8%** | 2.5% → **1.5%** | +0.920 → **+0.381** | 4.63 → 0.90 |
| MMA | Grappler | 24.6% → **1.2%** | 2.4% → **0.5%** | +0.926 → **+0.137** | 4.70 → 0.29 |

Chase rate (one man retreating, the other closing): ring **−0.399 → −0.533 m/s**, cage **−0.466 → −0.504 m/s**.
Centroid distance from the middle: ring **2.20 → 2.01 m**, cage **3.34 → 1.32 m**.

`fight_ring_position_test.gd`'s own A/B (8 seeds, 3 rounds, switches only, shape constant) isolates the two movement
changes: chase rate ring **−0.496 → −0.570**, cage **−0.237 → −0.469**; handedness ring **+0.917 → +0.127**, cage
**+0.908 → +0.180**.

## WHICH CHANGE DID WHAT — the five-variant matrix, 30 seeds each

A merge is not its branches, so the tool runs each change alone. `base` is the pre-S4e engine.

| variant | ring: out-boxer boundary / corner | ring handedness | ring chase | cage: striker boundary / corner | cage handedness | cage chase | cage centroid |
|---|---|---|---|---|---|---|---|
| base | 42.3% / 6.3% | +0.910 | −0.399 | 25.6% / 2.5% | +0.920 | −0.466 | 3.34 m |
| shape | 42.3% / 6.3% | +0.910 | −0.399 | 27.9% / **9.4%** | +0.913 | −0.416 | 3.03 m |
| cut_off | 42.7% / 6.4% | +0.877 | −0.399 | 24.0% / 1.9% | +0.882 | −0.437 | 3.22 m |
| circle_out | 34.1% / 13.8% | **+0.215** | −0.462 | **3.3%** / 1.3% | **+0.186** | −0.367 | 1.51 m |
| all | 45.3% / 20.9% | +0.204 | **−0.533** | 4.8% / 1.5% | +0.381 | **−0.504** | 1.32 m |

Four things that table says and the merged column alone could not:

1. **`base` and `shape` are byte-identical in the ring.** Boxing is a square and the shape switch is a no-op there —
   the tripwire that says the octagon only touches the cage.
2. **`circle_out` does almost all the work.** It is what collapses handedness (+0.910 → +0.215) and what takes the men
   off the walls (cage boundary 25.6% → 3.3%, centroid 3.34 → 1.51 m). Cutting off alone moves none of it.
3. **`cut_off` alone does NOT close the gap faster** (ring −0.399 → −0.399; cage −0.466 → −0.437, slightly worse) —
   but with `circle_out` on it takes the chase from −0.462 to −0.533 in the ring and −0.367 to −0.504 in the cage.
   Aiming ahead of a man only matters once he can get out of the way. The interaction is the finding, not either
   change.
4. **The octagon has MORE corner time than the square**, not less: cage corner 2.5% → 9.4% with the shape alone. Eight
   135-degree vertices with a 0.75 m margin cover more of the perimeter than four 90-degree ones do. That is the
   opposite of what "a cage has no corners to trap you in" suggests, and it means `CORNER_MARGIN` — tuned for a ring —
   is measuring something different on an octagon. It does not bite in the shipped configuration (corner falls to 1.5%
   with `circle_out` on), and **no new margin was invented to make it look better**. It is on the Open list.

## THE REALISM RULES, AND WHICH ARE GATED

| rule | tier | stands on |
|---|---|---|
| R14 cage_is_an_octagon | **GATED** | SPECIFICATION (geometry). A UFC cage's shape is its specification, not a finding. |
| R15 circle_out_geometry | **GATED** | GEOMETRY. 1,296 placements on both floors: the side chosen never has more than the engine's own deadband less open room than the side rejected, and 544 of them disagree with the old fixed perpendicular. |
| R16 cut_off_closes_the_gap | **GATED** | A/B of the engine against itself on the same seeds. The constants are AUTHORED. |
| R17 cage_engagement_share | REPORT | **DOCUMENTED**: cage/fence engagement 20.91% of match time, 91 UFC bouts (Anne & Antoine 2026, DOI 10.62852/css/2026/243, video-notational; K31 §5). **NOT GATED** — the study counts men ENGAGED at the fence; this column measures standing within 0.75 m of a wall, which is a different quantity. |
| R18 circling_handedness | REPORT | **NO STUDY**. K31 §2: circling direction, circles per round and the effect of stance on circling are all NOT FOUND. |

**NO STUDY is said out loud and the research is assigned**: `TASK_K63` (Kalli) for the ring and cage position, control
and defence statistics that exist; `TASK_U109` (Cursor) for the footage rates — stance switches, direction changes,
resets, level changes and head movement per minute from the 16 tracked videos and the kept UFC round. When they land,
R17 and R18 become gated rules.

## WHAT ELSE MOVED, REPORTED RATHER THAN TUNED

A movement change moves every seeded fight, and this project's rule is to re-run the recorded sweep, print the new
column beside the old ones and re-find the pins — never to tune a constant until the old seeds come back.

- **Judo endings, `tools/find_r101_seeds.gd -- judo`, the same 94000..94099 as every previous stage.** The column now
  reads R84/R101 **17 ippon / 9 shido / 4 KO / 70 decision** (R102) → S4e **13 ippon / 15 shido / 4 KO / 68 decision**.
  Four contests that used to end in a throw now end in a decision or a third penalty. The plausible mechanism is the
  one this stage built: a man who can circle toward the open floor instead of always the same way is harder to put
  down, and a judo contest where nobody scores ends on penalties. **No constant was moved to put the four back.**
  `94018` and `94024` survived as ippon for the third stage running; `94009` crossed out of the family and `94004`
  replaces it in `fight_realtime_test.gd`.
- **The three-knockdown TKO rule, `tools/find_r101_seeds.gd -- tko`, the same 77000..77399.** R84 **19** of 400 →
  R86 **8** → R101 **20** → R102 **14** → S4e **13**. The rule is about as reachable as it was; none of R102's three
  seeds survived, and the pins are now 77058 / 77085 / 77144.
- **The muay thai witness, `tools/find_r102_seeds.gd -- mt`, the same 93000..93399.** Re-found for the seventh time;
  seed 93014 stopped landing its one throw and 93003 replaces it. THE SWEEP ALSO TALLIED EVERY METHOD, because a
  witness re-found without the tally hides what moved it: SUBMISSION **156** / DECISION **193** / KO **51** of 400,
  against S4a (3)'s 136 / 218 / 46. Muay thai still shows submissions it has no business having — an engine finding
  (Q90), recorded, and deliberately not what this witness pins.
- **The judge panel, `tools/find_r101_seeds.gd -- panel`, the same 1..300 per ruleset on the 62-v-64 fixture.** Ten of
  the twelve pinned cards moved and were re-pinned from the test's own printed actual, each reproducible across the two
  runs the test itself makes. **BOXING NOW HAS NO SPLIT DECISION AT ALL** in 300 seeds — 201 unanimous, 19
  unanimous_draw, 8 majority_draw, 4 majority, 68 stopped — where S4a (3) found one at seed 300. Kickboxing keeps
  three (34, 138, 198). T11's pair therefore swaps rulesets again rather than losing one: the split is kickboxing 34,
  the majority boxing 46.
- **The grapple-draw bout and the HUD's live bout both ran on seed 92001, and it stopped reaching the floor.**
  `tools/probe_ground_reach.gd` settles whether that is a regression: 40 seeds with the S4e switches OFF and ON reach
  the ground **27 of 40 both ways** and open a submission 22 then 23. The path is intact; the pins moved.

## THE TWO TESTS S4e BROKE, PROVEN MINE AND LEFT RED ON PURPOSE

The full suite reads **295 total, 5 fails**. Three of the five fail identically with master's scripts in place (proven
by checking out `481cb385 -- Godot/scripts/RingSpace.gd Godot/scripts/FightRealtime.gd`, running the same five test
files serially, and restoring): `athlete_development_test` (`boxing_jab` already_learned), `fight_scoring_test` (the
uchi-mata ippon magnitude, 3 failures) and `fight_stage_realism_test` (13 rules, 7 failing). All three were already in
`AgentComms/last_suite.json`'s 287/4 from 2026-09-14. A fourth, `fight_realtime_test`, was red on master and is GREEN
here — its pins were re-found above.

**Two are mine, and both are the 3D room, not the engine:**

| test | master's scripts | S4e | what fails |
|---|---|---|---|
| `fight_pair_live_test` | rc=0 | fails=2 | on seed 810039, one of two qualifying beats is now `out_of_range` and the landed jab at **14.10 s — the operator's own 0:14 before/after shot** — no longer plays the authored pair |
| `fight_stage_presenter_contract_test` | rc=0 | fails=1 | one AnimationPlayer substitution where the contract requires zero |

`FightWorldLiveScreen._present_pair` refuses a pair when the men's gap falls outside the authored variant's
`[min_gap_m, max_gap_m]` — "a pair thrown from there would be a lunge the pair never contained". S4e did not change
`FightIntent.preferred_range`; it changed the PATH the men take to it, so at that one pinned impact they stand outside
the jab pair's authored window.

**This is left red deliberately, and it is not a re-pin candidate.** The two honest fixes are (a) re-find the pinned
moment, which throws away the operator's 0:14 shot, or (b) author a second jab variant for the gap the engine now
produces — Blender work on the operator's PC, not a cloud session. Choosing between them is the operator's call, and it
is the FIRST item of the next session. The operator's own ruling covers this case: ENGINE FIRST, *"the room can only
show what the engine decides"* — an engine that moves men better invalidating one clip's gap window is the order they
asked for, not a surprise.

## Open — what this stage did NOT fix

1. **The out-boxer is now pinned.** Corner time 6.3% → 20.9%, p90 pinned spell 7.90 → 14.70 s, while the pressure
   fighter's fell to 4.3%. Being walked down is a real dynamic and the asymmetry is the point, but an out-boxer whose
   craft is escaping should escape more than this. The cause is not the ring: `FightFootwork.THROTTLE_CIRCLE` is 0.65
   against the chaser's `THROTTLE_CLOSE` 1.0, so circling out cannot outpace a cut-off however well it is aimed.
   Changing that throttle needs a footage rate, which is U109's job.
2. **The cage emptied.** Boundary share 25.6% → 4.8% and 24.6% → 1.2%, away from the one documented figure (20.91%
   engagement). It was NOT tuned toward that number, because the proxy does not measure it — but a cage fight in which
   nobody is put on the fence is wrong, and K63 is what decides the target.
3. **Being cornered is still two lines.** `FightIntent.decide` reads `place` only as `if place == "CORNER"` (circle 0.6
   / retreat 0.4). Nothing else in the engine — technique choice, impact, stamina, the presenter — knows where a man is
   standing. `TASK_C133` (Codex) audits every consumer.
4. **There is still no stance, no chosen dodge, no feint that fails to land, and no between-exchange state.** Four of
   the operator's five behaviours are untouched; this stage is the first.
5. **`_run_movement` resolves A then B in one loop, so B reads A's ALREADY-UPDATED position and velocity** while A read
   B's from the previous tick. That asymmetry predates S4e — `position_of(other)` has always been inside the loop — but
   cutting off now reads the other man's velocity too, so it is one more thing the ordering touches. It is
   deterministic either way and fixing it would move every seeded fight again for no measured gain; recorded here so
   the next person does not rediscover it as a bug.
