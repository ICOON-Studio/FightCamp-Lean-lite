# Takedowns, throws, judo, balance break (kuzushi), grips

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **MMA takedown rates (S):** success 35.3%, defence 69.8%, 0.29 attempts / min - `J20_THE_VALIDATION_CORPUS.md`; league TD
  accuracy ~40%, ~1.5 attempts per 5-min round, TD defence benchmark ~60% - `J33_WHAT_THE_SPORT_MEASURES.md`; UFC TD success
  39% since 2008, shots ~50% of attempts, upper-body clinch <10% - `G139_THE_FENCE_CLINCH.md`; ~2.5-3.0 attempts / 15 min -
  `Q165_DIGEST.md`. **Do not re-commission takedown rates: G145 was cancelled S114 as a duplicate of these.**
- **Where a takedown/throw lands:** no published split (`Q26_LANDING_SEATS.md`); engine landings measured side 28.1% /
  half 40.6% / guard 31.3% - `Q204_DIGEST.md`, `Q197_DIGEST.md`; G143's entry shares are J grade (`ground.md`).
- **Stuffed shots** -> front headlock 15-25%, turtle 10-15% - `G141_FRONT_HEADLOCK_AND_TURTLE.md`; scrambles cost the man
  put down - `S22_THE_SCRAMBLE.md`.
- **Judo:** Olympic medallists make 6.4 +/- 2.4 attacks per match EACH (the 11-12 figure counts both) -
  `G136_JUDO_GRIP_TO_THROW.md`; ~10% of attempts score, ~1 scored throw per match - `G131_HOW_OFTEN_A_JUDO_THROW_SCORES.md`;
  engine: attempts 0.50 -> 9.26 per 4-min match (band 8-14), scoring share 6.6% - `U190_DIGEST.md` (S98); earlier over-score
  fixed - `U74_JUDO_THROWS_OVERSCORE.md`, `U69_IPPON_LINE.md`, `Q204_DIGEST.md`; per-technique ippon threshold rejected -
  `D10_IPPON_MODEL.md`; matte and endings - `J26_IJF_MATTE_AND_ENDINGS.md`; decisions at time - `Q76_JUDO_AT_TIME.md`;
  escapes - `Q78_JUDO_SAMBO_ESCAPES.md`; judo is not rounds - `G41_NOT_ROUNDS.md`.
- **Balance is a STATE, not a stat** (operator briefing, settled - do not re-ask) - `R131_BALANCE_BREAK_BRIEFING_SOURCE.md`,
  `R131_BALANCE_BREAK_SPEC.md`, `R150_BALANCE_DESIGN.md`; built in stages S19-S23 (`S19_BALANCE_REACHES_THE_FIGHT.md` ...
  `S23_THE_WEAK_LINE.md`); real-break share measured 0.75% (S21).
- **Wrestling scoring** (UWW bands, step-out not scored) - `U29_DIGEST.md`; freestyle naming 100% - `C178_DIGEST.md`.
- **Animation:** Dola's 8 standing wrestling poses all FAILED - `DOLA_WRESTLING_CORPUS_VERDICT.md`; two-body takedowns cannot
  be generated (0/36) - see `ground.md`.

## Open
- A wrestling skill gap on TD success/defence: derive from the J20/J33 league rates plus each man's wrestling stat
  (no new study needed); lands with the fight-level census after Q209.
- Judo scoring share 6.6% (U190) vs the ~10% G131 band - check against the current tree before tuning.

## Engine
`FightRealtime.gd` (takedown/throw resolution, `CLINCH_THROW_P`, judo gates), `GrappleResolve.gd`, `JudoBoard.gd`,
`GrappleAdapter.gd`, balance fields (S19-S23). Tools: `u190_judo_throw_census.gd`, `q197_*`, `q204_*`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (71, newest first, generated)

- `U190_DIGEST.md` (2026-09-27) - U190 DIGEST — Judo throws that are tried
- `Q204_DIGEST.md` (2026-09-27) - Q204 DIGEST — Judo: one standing attack in eight scores, not one in five
- `Q197_DIGEST.md` (2026-09-27) - Q197 DIGEST - Where does a thrown man land, and does footwork economy move it?
- `Q196_DIGEST.md` (2026-09-27) - Q196 DIGEST — footwork economy vs submissions/judo throws
- `G140_ONE_DOWN_ONE_UP.md` (2026-09-27) - G140 - One down, one up: the seconds after a knockdown or a stuffed shot (S102)
- `G136_JUDO_GRIP_TO_THROW.md` (2026-09-27) - G136 - JUDO: FROM GRIP TO THROW (Grok, collected S100 2026-09-27)
- `G131_HOW_OFTEN_A_JUDO_THROW_SCORES.md` (2026-09-27) - G131 - HOW OFTEN A JUDO THROW SCORES (Grok, collected S96 2026-09-27)
- `C138_BJJ_LONG_SCRIPT.md` (2026-09-27) - C138 — BJJ long script
- `G99_COMPUBOX_AVERAGES.md` (2026-09-25) - G99 - CompuBox round averages (Grok, verbatim)
- `C203_DIGEST.md` (2026-09-25) - C203 - standing source re-authoring (default OFF)
- `Q154_DIGEST.md` (2026-09-23) - Q154 digest - gloves are ruleset data, not a copy in the skin module
- `Q153_DIGEST.md` (2026-09-23) - Q153 DIGEST — per-ruleset ground policy; Muay Thai/boxing never stay on the ground
- `Q152_DIGEST.md` (2026-09-23) - Q152 DIGEST — Judo and Muay Thai grapple naming coverage
- `Q150_DIGEST.md` (2026-09-23) - Q150 DIGEST — U143 collected against Q147 blind test
- `Q148_DIGEST.md` (2026-09-23) - Q148 DIGEST — The 205 Phase Violations: Full Classification
- `C178_DIGEST.md` (2026-09-23) - C178 digest — U143 wrestling naming regression
- `D10_IPPON_MODEL.md` (2026-09-22) - D10 — IS A PER-TECHNIQUE THRESHOLD THE RIGHT MODEL FOR IPPON AT ALL
- `Q114_HOLD_CENSUS.md` (2026-09-21) - Q114 — HOLD CENSUS: which grapple IDs does the engine ask for and never get?
- `DOLA_WRESTLING_CORPUS_VERDICT.md` (2026-09-21) - Dola's standing wrestling corpus — run, and the split is clean
- `DOLA_WRESTLING_BRIEF.md` (2026-09-21) - Next: the standing wrestling chain, same engine, same pose format
- `S24_THE_EIGHT_NUMBERS.md` (2026-09-20) - S24 — THE EIGHT NUMBERS FINALLY HAVE A TARGET
- `S22_THE_SCRAMBLE.md` (2026-09-20) - S22 — A scramble costs the man who was put on the floor
- `Q112_ROLE_CENSUS.md` (2026-09-20) - Q112 ROLE CENSUS — WHAT ROLE IS EVERY STRIKE THE ENGINE THROWS?
- `M20_THE_SHOT.md` (2026-09-20) - M20 — THE SHOT
- `S21_A_BROKEN_BASE.md` (2026-09-19) - S21 — A broken base delivers less force and absorbs impact worse
- `S20_OVER_COMMITMENT_COSTS_THE_BASE.md` (2026-09-19) - S20 — A MAN INSIDE HIS OWN THROW IS ON A BROKEN BASE (R150 stage 3)
- `R150_BALANCE_DESIGN.md` (2026-09-19) - R150 — HOW BALANCE GOES IN, FROM THE OPERATOR'S DEFINITION
- `S4L_PREFERRED_RANGE.md` (2026-09-17) - S4l (B) — what decides the band? A measurement on `FightIntent.preferred_range`
- `S4E_MOVE_ANATOMY.md` (2026-09-16) - WHAT A MOVE NEEDS, WHICH LIMB THROWS IT, WHERE IT LANDS — AND WHY MOVES DO NOT BLEND
- `U106_HIGGSFIELD_JAB.md` (2026-09-14) - U106 - a Higgsfield jab on our fighter
- `Q109_FOOTAGE_POSTURE.md` (2026-09-14) - Q109 - the fold, measured
- `K58_COMBAT_MOVE_SCRIPTS.md` (2026-09-14) - K58 — How combat games script a move before they animate it
- `K56_WATCH_LIST_2.md` (2026-09-14) - K56 — Watch list 2: kicks, knees, elbows, clinch, takedowns, throws, ground (by discipline)
- `U79_ONLY_A_BLOW_LANDS.md` (2026-09-13) - U79 — Only a blow lands: footwork the realtime engine throws as a strike
- `U74_JUDO_THROWS_OVERSCORE.md` (2026-09-13) - U74 — A landed judo throw is nearly always a score
- `Q93_WHY_BOXERS_NEVER_CLINCH.md` (2026-09-13) - DECISIONS
- `Q91_GROUND_PATHS.md` (2026-09-13) - DECISIONS
- `Q80_THE_FLAT_PALETTE.md` (2026-09-13) - Q80 — THE FLAT PALETTE: EVERY TECHNIQUE IS THROWN ABOUT AS OFTEN AS EVERY OTHER
- `Q78_JUDO_SAMBO_ESCAPES.md` (2026-09-13) - Q78 — Judo and Sambo Escapes and Defences That Do Not Exist
- `Q76_JUDO_AT_TIME.md` (2026-09-13) - Q76 — A judo bout at time is decided by things judo does not score
- `K36_THE_FLOOR_BY_RULESET.md` (2026-09-13) - K36 — WHEN A FIGHTER GOES TO THE FLOOR: WHICH RULESETS LET THE FIGHT CONTINUE THERE, AND FOR HOW LONG
- `J27_FREQUENCIES_AND_THROW_DEFENCE.md` (2026-09-13) - J27 — Frequencies and throw defence
- `J26_IJF_MATTE_AND_ENDINGS.md` (2026-09-13) - J26 — JOHN — MATTE, NE-WAZA LENGTH, AND HOW JUDO BOUTS END
- `U69_IPPON_LINE.md` (2026-09-12) - U69 — THE IPPON LINE STAYED WHERE IT WAS WHEN THE CATALOGUE MOVED
- `U68_BALANCE_BREAK_ROLES.md` (2026-09-12) - U68 — Balance-break put-down role adjudication
- `U65_ROLE_KIND_CENSUS.md` (2026-09-12) - 1. The remap blast radius
- `U60_JUDO_BJJ_TECHNIQUES.md` (2026-09-12) - U60 / U60B — Judo & Brazilian Jiu-Jitsu: the real vocabulary
- `S1D_GROUND_SEATS.md` (2026-09-12) - S1d — THE GROUND HAD NO SEATS: WHAT THE MERGE ERASED, WHAT CAME BACK, WHAT IT EXPOSED
- `R140_THE_JUDO_ANIMSET.md` (2026-09-12) - R140 — THE JUDO PACK, PRICED AND AUDITED FROM THE LISTING
- `R131_BALANCE_BREAK_SPEC.md` (2026-09-12) - R131 — BALANCE BREAK (KUZUSHI): THE SPEC
- `R131_BALANCE_BREAK_BRIEFING_SOURCE.md` (2026-09-12) - R131 — THE OPERATOR'S BALANCE BREAK BRIEFING, VERBATIM
- `Q72_JUDO_NEWAZA.md` (2026-09-12) - Q72 - Judo's ground is held out of S1d: the rules and the seats it needs
- `C87_THE_RETARGET_LADDER.md` (2026-09-11) - C87 — The Retarget Ladder
- `U34_DIGEST.md` (2026-09-10) - U34 DIGEST — JudoBoard gets a caller
- `U29_DIGEST.md` (2026-09-10) - U29 DIGEST — GrappleAdapter blind contract test
- `R93_DIGEST.md` (2026-09-10) - R93 DIGEST — G39's PER-SEAT BANDS, THE CLINCH FOLD, AND THE STALL DECIDED (2026-09-10)
- `Q28_DIGEST.md` (2026-09-10) - Q28 DIGEST — `half` HAS A WRITER, AND THE SWEEP FIRES
- `Q26_LANDING_SEATS.md` (2026-09-10) - Q26 — The throw that can only ever land in two places
- `Q21_DIGEST.md` (2026-09-10) - Q21 DIGEST — THE TWO LADDERS G36 SOURCED, WIRED
- `M19_THE_MISSING_CLIP.md` (2026-09-10) - M19 — THE MISSING CLIP (presenter when R101 names a technique we have no clip for)
- `G41_NOT_ROUNDS.md` (2026-09-10) - G41 — JUDO, WRESTLING AND BJJ ARE NOT ROUNDS
- `G39_THE_CLINCH.md` (2026-09-10) - G39 — THE CLINCH: WHAT IT SCORES, WHAT BREAKS IT, WHAT A THROW FROM IT IS WORTH
- `C74_DIGEST.md` (2026-09-10) - C74 digest — Muay Thai grapple fold
- `G34_GRAPPLING_CONTRACT.md` (2026-09-09) - G34 — Grappling contract for the real-time tick engine
- `RING_NIGHT_SPRITE_SHOT_LIST.md` (2026-09-08) - Ring Night fighter sprites — shot list
- `R73_DIGEST.md` (2026-09-08) - R73 DIGEST — The goal without a belt
- `C57_DIGEST.md` (2026-09-08) - C57 digest — selection pathways
- `C46_THE_BELTS_OWNER.md` (2026-09-08) - C46 — The Belt's Owner, Discipline by Discipline
- `C46_DIGEST.md` (2026-09-08) - C46 digest
- `SHOT_LIST_GROUND.md` (untracked) - SHOT LIST - GROUND (generated S114 from `GroundGraph.EDGES`; regenerate when the graph changes)
- `K53_BODY_TRAVEL_PER_PUNCH.md` (untracked) - Body travel per punch, and the distance each punch is thrown from
