# Reviewer Discussion — KM1 Game Review

## Process

Nine reviewers worked independently from the same evidence pack. This file challenges duplicated or weak findings, resolves disagreements with evidence, flags fixes that help one area and hurt another, and confirms the final set serves the intended identity.

## Resolved disagreements

### R1 — `fight_realtime_test.gd` parse error vs. passing run

- **Core Gameplay (F1)** reported the test unloadable with `Identifier "FightMoves" not declared`.
- **Design & Balance** reported the same test passing 378 checks after a headless editor import pass rebuilt the `.godot/` global-class cache.
- **Resolution:** The parse failure is real on a clean worktree without the import cache; it is not a source-code bug in `FightRealtime.gd` or `FightMoves.gd`. The fix is to regenerate the `.godot/` cache, not to edit the test. The severity is downgraded from Critical to **High** because it blocks local gate runs but does not affect the shipped engine.
- **Owner:** Technical & Code / Core Gameplay.

### R2 — Smoke test vs. import cache

- **Core Gameplay (F2)** reported `smoke_test.gd` hangs due to missing import cache.
- **Technical & Code** did not run `smoke_test.gd` but noted the same cache-related font/audio parse errors in other headless runs.
- **Resolution:** Same root cause as R1. `smoke_test.gd` is the real gate; the project needs a documented "first-run" step to build the import cache on a fresh clone/worktree. Severity **High**, fix effort **Small**.

### R3 — Visual direction severity

- **Visual & Animation (F11)** rated mixed art direction **Medium**.
- **Creative Director (F2)** rated it **High** because four competing directions block UI cohesion.
- **Resolution:** Agree with **High**. M34 explicitly states the operator must pick a direction; until then every screen risks drift. The pick itself is small effort, but the downstream implementation is large.

### R4 — Defensive outcomes / block+slip visibility

- **Core Gameplay** and **Visual & Animation** both noted block/slip are computed but rarely shown (~0.3% of shown beats).
- **Audio** noted defensive outcomes other than blocked are silent.
- **Resolution:** This is a cross-system finding. The engine already has the `promote_in_remainder_4` rule that raises block+slip to 16.3% with zero knockdown loss. The fix requires both (a) applying that promotion rule and (b) adding block/slip reaction clips and audio cues. Severity **High**.

### R5 — Generated portraits vs. 3D fighter hair

- **Player & Market (F5)** found generated portraits read as mannequin for 5/8 cards.
- **Visual & Animation (F7)** found 3D fighters are bald while portraits show hair.
- **Resolution:** These are two symptoms of the same pipeline gap: the MPFB generator produces consistent bodies but not yet consistent faces/hair across portrait and 3D. Merge into a single **High** identity finding: finish the face/hair pass on generated bodies so portrait and 3D match and read human.

## Merged / duplicate findings

| Theme | Reviewers | Merged finding | Severity |
|---|---|---|---|
| Boxing clips incomplete | Core, Visual, Player/Market, Creative Director | Boxing 16/36 certified; milestone and .exe blocked | Critical |
| Kickboxing clips absent | Core, Visual, Creative Director | Kickboxing 0/20 certified | High |
| Feints invisible | Core, Visual, Adversarial QA | Feints computed but not presented | High |
| 0 split decisions | Core, Adversarial QA | Booked population produces unanimous cards | Medium |
| Two-engine split | Core, Technical, Creative Director | Real-time/atomic split with missing real-time features | High |
| Body overlap / clipping | Technical, Adversarial QA | 3D body/limb penetration and clipping gate still fail | High |
| Legal/asset blockers | Audio, Visual, Player/Market, Creative Director | Tripo free-plan bodies, YouTube menu music, unconfirmed Ludo terms, missing credits | Critical |
| Living hub | Player/Market, Creative Director, Visual | 3D gym hub is the key differentiator but not yet delivered | High |
| Result screen proof | UI/UX, Player/Market | THE PLANS / plan-outcome lines are buried | High |
| Weigh-in jargon | UI/UX, Player/Market | Fight-week/weigh-in copy confuses first-timers | Medium |

## Trade-offs flagged

### T1 — Clip authenticity vs. milestone speed

- The C223 gate is correct and must not be widened. However, waiting for 36/36 boxing + 20/20 kickboxing before any `.exe` or demo risks missing the 2026-10-04 demo deadline.
- **Recommendation:** Keep the gate for boxing; accept a boxing-only demo if necessary. Do not ship kickboxing/MMA/grappling watchability until they pass the same gate.

### T2 — Real-time feature parity vs. atomic fallback

- Moving judo/taekwondo/wrestling to the real-time engine would unify the architecture but requires authored kicking/target and ippon/points scoring that do not exist.
- **Recommendation:** Keep the atomic fallback for those three rulesets in v1, but disable taekwondo as a playable demo ruleset because its cards are wrong-but-plausible.

### T3 — Two-engine combo reaction

- `RingStagePanel.gd` still calls `FightSimulation.react_to_combo` unconditionally. Removing combo interrupts on the real-time path (as U35 recommended and G44 refused) is a design choice, not a bug.
- **Recommendation:** Make the cut explicit: if real-time rulesets do not get combo reactions, remove the dead call and document it; if they should, add the seam to `FightBeatAdapter`.

### T4 — Visual Direction A vs. demo polish

- Rebuilding every legacy screen in Direction A is large effort. For the demo, prioritize the screens in the boxer walk: THE DAY, profile, training floor, fight night, result.
- **Recommendation:** Apply Direction A only to the demo path screens first; keep the rest as backlog.

## Findings weakened or dropped

- **Core Gameplay F1** (`fight_realtime_test` unloadable): downgraded from Critical to High, merged with Technical & Code import-cache finding. The engine itself is fine once cache exists.
- **Visual & Animation F12** (rooms have no people at work): confidence downgraded to ASSUMPTION because it rests on digest summaries, not live observation.
- **Adversarial QA F9–F12, F16, F17**: several low-severity assumptions about abnormal exits, dev routes, and walk-plan label fragility. These are kept as Low findings in the consolidated report but do not block the milestone.

## Creative Director confirmation

The final finding set serves the intended identity when the three pillars are weighed:

1. **"The fight is real"** — protected by the calibrated engine, threatened by missing clips and invisible defence/feints.
2. **"You run the gym"** — protected by the career loop and management systems, threatened by weak hub feedback and confusing weigh-in copy.
3. **"It tells you why"** — protected by corner/result reads, threatened by burying THE PLANS and flat post-fight fatigue.

The highest-value fixes are: finish 36/36 boxing clips, fix legal blockers, replace menu music, make the hub alive, and surface defence/feints. These serve all three pillars without scope expansion.

## Final consolidated priorities

1. Unblock shippability (legal/assets).
2. Finish boxing animation gate (36/36).
3. Fix 3D overlap/contact and promote defence visuals.
4. Replace placeholder/debug UI text and fix contrast/keyboard accessibility.
5. Make the gym hub feel alive (C-light slice).
6. Tune balance anchors (MMA target mix, boxing output, takedowns).
7. Add broadcast audio placeholders and SFX/crowd controls.
8. Improve result-screen plan-outcome communication.
9. Fix technical performance issues in the 3D room (per-frame loads, O(n²) passes).
10. Address known suite reds before declaring milestone stable.
