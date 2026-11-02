# Damage, body regions, cardio and fatigue, injury and recovery

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Damage is a stream of impacts in fight-seconds on six body regions** (no per-tick rates) - `U20_DAMAGE_IN_REAL_TIME.md`,
  `U20_DIGEST.md`; the body is six places, not one number - `R55_DIGEST.md`, `U3_THE_BODY_BY_REGION.md`; region bands
  `fine >55 / hurt <=55 / critical <=35 / doctor <=15` (settled, do not retune) - `M23_REGION_READOUT.md`, `K73_REGION_SENTENCES.md`.
- **Damage by strike and target:** no multipliers recommended from real data - `K67_DAMAGE_BY_STRIKE_AND_TARGET.md`; the
  damage half of the pace calibration - `S27_THE_DAMAGE_HALF.md`; kickboxers not getting hurt (per-strike wear) - `Q186_DIGEST.md`.
- **Live limb damage** (hurt legs slow the feet and persist) - built S97, **ON by default since S98**; a leg goes red on its
  own in MMA R3 (S99); body work saps output and does not close in 60 s - `G132_LIVE_DAMAGE_AND_THE_CORNER.md`.
- **Cardio is a heart rate, not a bar** (cut points 70/80/90% of max) - `Q17_DIGEST.md`; a tired man fights worse - `R86_DIGEST.md`;
  gas-tank lessons from WMMA5 - `C65_WMMA5_TEARDOWN.md`; the gas instrument - `M24_GAS_INSTRUMENT.md`.
- **Injury and recovery:** the injury in the save - `R59_DIGEST.md`; the body heals at six speeds - `R60_DIGEST.md` (J12 refuses
  a per-region rate: none published); injury phases per region - `R62_DIGEST.md`; recovery and age differ as a literature, not
  a game number - `J12_RECOVERY_AND_THE_YEARS.md`; what the years cost - `U2_WHAT_THE_YEARS_COST.md`.
- Balance recovery seconds after a failed throw: NOT FOUND - `G59_BALANCE_RECOVERY.md`.

## Open
- Per-body-part recovery between fights is designed, not built (memory `project_per_body_part_recovery`; status deck).

## Engine
`FightRealtime.gd` (impacts, limb damage), `Stamina.gd`, `InjuryPhase.gd`, `InjuryWords.gd`, `GameState` body read
(`get_body_read`). Physio room shows it (`PhysioRoom3D.gd`).

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (48, newest first, generated)

- `G132_LIVE_DAMAGE_AND_THE_CORNER.md` (2026-09-27) - G132 - LIVE DAMAGE AND THE CORNER (Grok, collected S96 2026-09-27)
- `D60_DIGEST.md` (2026-09-27) - D60 DIGEST - DOLA - FRESH EYES: THE SIX ROOMS AFTER THE PROPS PASS (S112 -> collected S113)
- `D58_DIGEST.md` (2026-09-27) - D58 - Dola fresh eyes: the physio (S110)
- `U181_DIGEST.md` (2026-09-26) - U181 — skipping clip contact + cardio floor bind
- `Q186_DIGEST.md` (2026-09-26) - Q186 DIGEST — WHY KICKBOXERS ARE NOT GETTING HURT (KB HEAD DAMAGE PER MINUTE)
- `G116_GYM_FLOOR_EVENTS.md` (2026-09-26) - G116_GYM_FLOOR_EVENTS (Grok, collected by Claude S85, 2026-09-26)
- `G110_ROOMS_MEDIA_SCOUTING.md` (2026-09-26) - G110_ROOMS_MEDIA_SCOUTING
- `D35_FRESH_EYES_VISITORS.md` (2026-09-26) - D35_FRESH_EYES_VISITORS (Dola, collected by Claude S90, 2026-09-26)
- `Q167_DIGEST.md` (2026-09-24) - Q167_DIGEST — tag every bound strike clip: START, CONTACT, RECOVER-TO-GUARD
- `G91_BRIEF.md` (2026-09-24) - G91 - FROM FIGHTER TO COACH: what a retired fighter becomes, and how good a coach he makes (Research, no code)
- `C190_DIGEST.md` (2026-09-24) - C190 — native strike timing, bounded placement, and recovery queue
- `Q134_DIGEST.md` (2026-09-22) - Q134 DIGEST — THE DEPTH QUESTION, ASKED OF A LIMB FOR THE FIRST TIME
- `M23_REGION_READOUT.md` (2026-09-22) - M23_REGION_READOUT.md
- `K67_DAMAGE_BY_STRIKE_AND_TARGET.md` (2026-09-21) - K67 — What real data exists on damage by strike family and target region
- `S27_THE_DAMAGE_HALF.md` (2026-09-20) - S27 — the damage half: what the pace calibration needs beside it
- `R146_EQUIPMENT_TRAINING_STUDY.md` (2026-09-19) - R146 — EQUIPMENT, TRAINING, STAFF, DIET AND INJURY: a deep study
- `S4E_MOVE_ANATOMY.md` (2026-09-16) - WHAT A MOVE NEEDS, WHICH LIMB THROWS IT, WHERE IT LANDS — AND WHY MOVES DO NOT BLEND
- `U77_THE_LIMB_THAT_SCORES.md` (2026-09-13) - U77 — The limb that scores
- `Q79_WHAT_A_LEG_KICK_DOES.md` (2026-09-13) - Q79 - What a landed leg kick does, in both engines
- `K37_ABSOLVER_FRAMES.md` (2026-09-13) - K37 — ABSOLVER'S MOVES IN FRAMES: HOW LONG AN ATTACK TAKES, HOW IT CHAINS, HOW A HIT IS RECOVERED FROM
- `K32_PUNCH_ARRIVAL_AND_RECOVERY.md` (2026-09-13) - K32 — KALLI — HOW LONG A PUNCH TAKES TO ARRIVE, AND HOW LONG A HIT MAN TAKES TO COME BACK
- `Q65_MUAY_THAI_TECHNIQUES.md` (2026-09-12) - Q65 — MUAY THAI: THE FULL TECHNIQUE VOCABULARY
- `G59_BALANCE_RECOVERY.md` (2026-09-12) - G59 — HOW LONG A FIGHTER STAYS OFF BALANCE
- `C97_COUNTER_RECONCILIATION.md` (2026-09-12) - C97 — Counter Reconciliation
- `Q38_MOVEMENT_QUALITY.md` (2026-09-10) - Q38 — Movement Quality: Are Our Men Moving Like Boxers, or Jittering?
- `U20_DIGEST.md` (2026-09-09) - U20 DIGEST — Damage in real time
- `U20_DAMAGE_IN_REAL_TIME.md` (2026-09-09) - U20 — Damage in real time, on a body that already exists
- `R86_DIGEST.md` (2026-09-09) - R86 DIGEST — THE TIRED MAN FIGHTS WORSE, AND TWELVE ROUNDS STOP BEING A MASSACRE
- `R85_DIGEST.md` (2026-09-09) - R85 DIGEST — THE REBASELINE
- `Q17_DIGEST.md` (2026-09-09) - Q17 DIGEST — Cardio: a heart rate, not a bar
- `C66_DIGEST.md` (2026-09-09) - C66 — The test that would have caught all seven
- `C65_WMMA5_TEARDOWN.md` (2026-09-09) - C65 — What WMMA5 knows about a gas tank
- `C58_THE_TWELVE_SEEN.md` (2026-09-09) - C58 — The Twelve, Seen
- `U9_DIGEST.md` (2026-09-08) - U9 DIGEST — THE INJURY ON THE SCREEN
- `R62_DIGEST.md` (2026-09-08) - R62 DIGEST — THE BODY'S RECORD, AND WHERE EACH INJURY STANDS
- `R60_DIGEST.md` (2026-09-08) - R60 DIGEST — THE BODY HEALS AT SIX SPEEDS
- `R59_DIGEST.md` (2026-09-08) - R59 — THE INJURY IN THE SAVE (Claude, 2026-09-08)
- `J13_THE_BODY_THE_DIET_AND_THE_PICTURE.md` (2026-09-08) - J13 — The Body, the Diet, and the Picture of a Fighter
- `U3_THE_BODY_BY_REGION.md` (2026-09-07) - U3 — THE BODY BY REGION: SIX CLOCKS, ONE FIGHTER (Cursor)
- `U3_DIGEST.md` (2026-09-07) - U3 DIGEST — THE BODY BY REGION
- `U2_WHAT_THE_YEARS_COST.md` (2026-09-07) - U2 — WHAT THE YEARS COST, AND WHO IS TOLD (Cursor)
- `R55_DIGEST.md` (2026-09-07) - R55 — the body is six places, not one number
- `R48_DIGEST.md` (2026-09-07) - R48 — THE HOLD: A BODY THAT CANNOT BE BOOKED (Claude, 2026-09-07)
- `J12_RECOVERY_AND_THE_YEARS.md` (2026-09-07) - J12 — Recovery and the Years: Does an Older Fighter Heal Slower?
- `J11_AFTER_THE_LAST_FIGHT.md` (2026-09-07) - J11 — After the Last Fight: What Happens When They Stop Competing
- `M6_THE_HOLD.md` (2026-09-06) - M6 — THE HOLD: A BODY THAT CANNOT BE BOOKED
- `J4_THE_DESK_AND_THE_CUT.md` (2026-09-06) - J4 — The Desk and the Cut: Manager, Gym, and Where the Purse Stops
- `C5_DIGEST.md` (2026-09-05) - C5 Digest — TRAINING hub read API
