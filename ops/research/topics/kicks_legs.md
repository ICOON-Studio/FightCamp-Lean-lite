# Kicks, knees and leg strikes; leg-kick share

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Leg share of landed strikes:** MMA league 14-18% (J20 D3, `J20_THE_VALIDATION_CORPUS.md`); kickboxing 20-40% for a
  kicker, 8-15% for a counter striker; a limp after 8-12 clean thigh or 3-6 calf kicks - `G134_KICKBOXING_LEG_KICK_SHARE.md`.
  Both men must be able to kick when this is measured (CLAUDE.md fixture rule; Q67's boxer-only fixture was unreal).
- **What a landed leg kick looks like:** the low kick is ~25% of all kicks; weight-bearing leg swept; after ~8 landed low
  kicks per fighter per K-1 fight, the limp (judgement on G134) - `J57_WHAT_A_LANDED_LEG_KICK_LOOKS_LIKE.md`; an ordinary
  leg kick keeps the man upright (react_leg re-authored) - `C214_DIGEST.md`.
- **History of the leg-share miss:** 65% of kicks could not reach a leg - `R137_THE_KICKS_CANNOT_REACH_THE_LEGS.md`;
  target table - `Q70_KICK_TARGETS.md`, `Q70_DIGEST.md` (the 20% arm branch was dead code); palette funnel -
  `Q66_KICKBOXING_TIER_FIX.md`, `Q67_WHERE_THE_KICKS_GO.md`; MMA leg share with footwork ON 6.3% - `U178_DIGEST.md`;
  kickboxing leg kicks that land (KB_LEG_REGION_SELECT_MULT 2.92) - `U189_DIGEST.md` (merged S98).
- **Kick speed:** foot ~8-14 m/s at impact (roundhouse/TKD) - `U158_DIGEST.md`; kick effector = peak hips-relative speed
  - `U166_DIGEST.md`; what a leg kick does in both engines - `Q79_WHAT_A_LEG_KICK_DOES.md`; target legality by ruleset -
  `U75_STRIKE_TARGET_LEGALITY.md`.
- Live limb damage (hurt legs slow the feet, persist) is ON by default since S98 - see `body_damage.md`.

## Open
- Re-measure MMA and kickboxing leg share against the bands after the ground work (Q208/Q209) changes fight time.

## Engine
`FightMoves.gd` (`_pick_target_region`, `_mma_region_selection_mult`), `FightRealtime.gd` (`kb_leg_region_mult`),
limb damage. Tools: `q184_kb_finish_funnel.gd`, `u189_*`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (30, newest first, generated)

- `U189_DIGEST.md` (2026-09-27) - U189 Digest — Kickboxing leg kicks that land
- `Q174_DIGEST.md` (2026-09-27) - Q174 DIGEST — The Boxing and Kickboxing Clinch (Holding, and the Referee's Break)
- `J57_WHAT_A_LANDED_LEG_KICK_LOOKS_LIKE.md` (2026-09-27) - J57 WHAT A LANDED LEG KICK LOOKS LIKE ON THE MAN WHO TAKES IT
- `G135_FAMOUS_TRAINERS_WHAT_ONLY_THEY_TEACH.md` (2026-09-27) - G135 FAMOUS TRAINERS AND WHAT ONLY THEY TEACH
- `G134_KICKBOXING_LEG_KICK_SHARE.md` (2026-09-27) - G134 KICKBOXING LEG KICK SHARE
- `C214_DIGEST.md` (2026-09-27) - C214 - an ordinary leg kick stays upright
- `U183_DIGEST.md` (2026-09-26) - U183 digest — boxing footwork without lifted knees
- `U178_DIGEST.md` (2026-09-26) - U178 Digest — MMA leg-strike share (footwork ON)
- `Q186_DIGEST.md` (2026-09-26) - Q186 DIGEST — WHY KICKBOXERS ARE NOT GETTING HURT (KB HEAD DAMAGE PER MINUTE)
- `Q184_DIGEST.md` (2026-09-26) - Q184 Digest - Kickboxing Finishes 6.7% vs Glory 33%: Funnel Census + Corner Stoppage Mechanism
- `Q183_DIGEST.md` (2026-09-26) - Q183 Digest - Footwork Switch Decided On Every Anchored Row (incl. leg share)
- `U166_DIGEST.md` (2026-09-24) - U166 digest — kick/knee effector = peak hips-relative speed (not plant-foot displacement)
- `U163_DIGEST.md` (2026-09-24) - U163 digest — take-four kick/hand speed (vendor-world)
- `U158_DIGEST.md` (2026-09-24) - U158 digest — kick playback and smoother walk
- `Q70_DIGEST.md` (2026-09-24) - Q70 DIGEST
- `STANCE_SWITCH_OPINION_GROK.md` (2026-09-23) - Stance-switch opinion - Grok (Expert), verbatim
- `U111_FOOTAGE_ROWS_REMEASURED.md` (2026-09-20) - U111 — Two rows U109 and U110 got wrong, re-measured
- `U110_FOOTAGE_COMMIT_WINDOW.md` (2026-09-20) - U110 — Rear-Hand and Kick Commitment Window
- `Q112_ROLE_CENSUS.md` (2026-09-20) - Q112 ROLE CENSUS — WHAT ROLE IS EVERY STRIKE THE ENGINE THROWS?
- `K56_WATCH_LIST_2.md` (2026-09-14) - K56 — Watch list 2: kicks, knees, elbows, clinch, takedowns, throws, ground (by discipline)
- `U75_STRIKE_TARGET_LEGALITY.md` (2026-09-13) - U75 — Strike target legality by engine ruleset
- `Q79_WHAT_A_LEG_KICK_DOES.md` (2026-09-13) - Q79 - What a landed leg kick does, in both engines
- `C108_ROUND_LENGTH_SWEEP.md` (2026-09-13) - DECISIONS
- `R137_THE_KICKS_CANNOT_REACH_THE_LEGS.md` (2026-09-12) - R137 — 65% OF KICKS ARE STRUCTURALLY INCAPABLE OF HITTING A LEG
- `R128_BOXING_KICKBOXING_TREES.md` (2026-09-12) - R128 — THE BOXING AND KICKBOXING TREES, MADE REAL
- `Q70_KICK_TARGETS.md` (2026-09-12) - Q70 — WHERE EACH KICK LANDS: THE ADJUDICATED TARGET TABLE S2 WILL APPLY
- `Q67_WHERE_THE_KICKS_GO.md` (2026-09-12) - Q67 — Where the Kicks Go: Funnel Measurement
- `Q66_KICKBOXING_TIER_FIX.md` (2026-09-12) - Q66 — Kickboxing Leg Share Fix: Measured Failure
- `C97_COUNTER_RECONCILIATION.md` (2026-09-12) - C97 — Counter Reconciliation
- `Q61_CLIP_SHAPE.md` (2026-09-11) - Q61 — What Is Actually In The Clip
