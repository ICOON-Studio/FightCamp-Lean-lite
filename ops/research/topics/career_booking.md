# Career, booking, rankings, matchmaking, the path

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **The path** a fighting career actually walks (amateur -> pro, gym decisions on sourced minimums) - `C55_THE_PATH.md`;
  selection into championships - `C57_THE_SELECTION.md`; the tournament and the grade - `C52_THE_TOURNAMENT_AND_THE_GRADE.md`.
- **Amateur booking:** a bout is fought 2-4 career weeks after it is offered (never same-day the debut); novices (0-10 bouts)
  meet only novices; the 0-2 debut rule is enforced - `G96_AMATEUR_BOOKING.md` (S75/S76); who is in a real amateur scene
  (no federation publishes a bout-count histogram) - `G98_AMATEUR_POPULATION.md`; how an amateur fight is made - `U4_HOW_AN_AMATEUR_FIGHT_IS_MADE.md`.
- **Rankings and challengers:** store `ranking_mode` (discretionary / published / mixed), never reverse-engineer a formula -
  `C47_THE_CHALLENGER.md`; the real roster's make-up - `K26_THE_REAL_ROSTER.md`.
- **Screens:** the booking, the fight camp, the schedule, the day - `R33_DIGEST.md`, `R34_DIGEST.md`, `U167_DIGEST.md`,
  `R32_DIGEST.md`; the navigation graph has 29 reachable surfaces, 0 orphaned - `C145_THE_NAVIGATION_GRAPH.md`; weigh-in
  honesty and gym-mate booking (miss fine 20% of show purse) - `U169_DIGEST.md`.

## Open
- The whole loop has to be walked in the exported build every stage (S74 found a dead end every test passed) - see `ui_screens.md`.

## Engine
`GameState.gd` (booking, offers, world), `AmateurBooking.gd`, `AmateurMatchmaking.gd`, `WorldPopulation.gd`, `Rankings*`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (46, newest first, generated)

- `G125_REGENERATING_THE_FIGHTERS.md` (2026-09-26) - G125 - REGENERATING THE FIGHTERS ON TRIPO PRO, AND HOW PROMOTIONS SHOOT ROSTER PORTRAITS
- `D38_FRESH_EYES_THE_ROSTER_PORTRAITS.md` (2026-09-26) - D38 - FRESH EYES ON THE ROSTER PORTRAITS (Dola)
- `D31_PERCENT_OF_A_POINT_REPLY.md` (2026-09-26) - D31_PERCENT_OF_A_POINT - Dola's reply (collected by Claude S86, 2026-09-26)
- `J54_MENU_ARCHITECTURE_SURVEY.md` (2026-09-25) - J54: HOW SPORTS-MANAGEMENT AND FIGHT GAMES ORGANISE THEIR MENUS
- `G96_AMATEUR_BOOKING.md` (2026-09-25) - G96 - How an amateur's first bouts are booked (Grok, Expert, collected S75 2026-09-25)
- `U169_DIGEST.md` (2026-09-24) - U169 digest — weigh-in honesty and gym-mate booking (Cursor, 2026-09-24)
- `U168_DIGEST.md` (2026-09-24) - U168 digest — profile and result leftovers (Cursor, 2026-09-24)
- `U167_DIGEST.md` (2026-09-24) - U167 digest — the schedule tells the truth (Cursor, 2026-09-24)
- `U125_DIGEST.md` (2026-09-22) - U125 digest (cursor)
- `C145_THE_NAVIGATION_GRAPH.md` (2026-09-21) - C145 — The navigation graph
- `K26_THE_REAL_ROSTER.md` (2026-09-10) - K26 — WHAT A REAL FIGHT ROSTER LOOKS LIKE
- `U27_DIGEST.md` (2026-09-09) - U27 — CAREER PATH on the record tab
- `Q12_DIGEST.md` (2026-09-09) - Q12 DIGEST — The Version Literal That Breaks Every Bump
- `U8_DIGEST.md` (2026-09-08) - U8 DIGEST — THE CAREER AS YEARS, NOT ONLY BOUTS
- `U13_DIGEST.md` (2026-09-08) - U13 digest — THE CAREER THAT IS INVISIBLE (cursor)
- `C57_DIGEST.md` (2026-09-08) - C57 digest — selection pathways
- `C55_THE_PATH.md` (2026-09-08) - C55 — THE PATH: HOW A FIGHTING CAREER IS ACTUALLY WALKED
- `C55_DIGEST.md` (2026-09-08) - C55 DIGEST — THE PATH
- `C52_THE_TOURNAMENT_AND_THE_GRADE.md` (2026-09-08) - C52 — The Tournament and the Grade
- `C48_THE_RESULT_THAT_IS_NOT.md` (2026-09-08) - C48 — THE RESULT THAT IS NOT A RESULT
- `C47_THE_CHALLENGER.md` (2026-09-08) - C47 — The challenger, and how long a champion may sit
- `M11_THE_LONG_CAREER.md` (2026-09-07) - M11 — THE LONG CAREER: AGE, WEAR, AND THE LAST WALK
- `K24_THE_YEAR_TURN.md` (2026-09-07) - 1. Birthday
- `J11_AFTER_THE_LAST_FIGHT.md` (2026-09-07) - J11 — After the Last Fight: What Happens When They Stop Competing
- `J10_THE_YEARS.md` (2026-09-07) - J10 — The Years: Peak, Decline, and Why Careers Actually End
- `C34_DIGEST.md` (2026-09-07) - C34 Digest — The Generations
- `C33_DIGEST.md` (2026-09-07) - C33 — The bout that was not watched on a card
- `R33_DIGEST.md` (2026-09-06) - R33 — THE BOOKING (digest)
- `R32_DIGEST.md` (2026-09-06) - R32 DIGEST — THE DAY (Claude)
- `K20_DIGEST.md` (2026-09-06) - K20 DIGEST — THE BOOKING, HOW IT READS (Kalli)
- `K18_DIGEST.md` (2026-09-06) - K18 DIGEST — THE DAY (Kalli)
- `J2_THE_FEDERATION_PATHWAY.md` (2026-09-06) - J2 — The Federation Pathway: How You Get In, and Who Pays
- `R30_DIGEST.md` (2026-09-05) - R30 DIGEST — THE RANKINGS HUB (Claude)
- `R28_DIGEST.md` (2026-09-05) - R28 DIGEST — CAREER CREATION (the tenth legacy replacement)
- `R24_DIGEST.md` (2026-09-05) - R24 DIGEST — THE SCHEDULE HUB (Claude)
- `R21_DIGEST.md` (2026-09-05) - R21 DIGEST — the GYM hub, the first replacement panel
- `R20_DIGEST.md` (2026-09-05) - R20 DIGEST — the spine: router, career root, fight night
- `K15_DIGEST.md` (2026-09-05) - K15 DIGEST — THE RANKINGS (Kalli)
- `K14_DIGEST.md` (2026-09-05) - K14 DIGEST — THE BOOT (title / slots / settings)
- `K13_DIGEST.md` (2026-09-05) - K13 DIGEST — CAREER CREATION study (Kalli)
- `K10_DIGEST.md` (2026-09-05) - K10 DIGEST — SCHEDULE & EVENTS hub study (Kalli)
- `C7_DIGEST.md` (2026-09-05) - C7 Digest — SCHEDULE & EVENTS read API
- `C3_DIGEST.md` (2026-09-05) - C3 DIGEST — deterministic developer jump harness
- `C16_DIGEST.md` (2026-09-05) - C16 - The Day Attention Read
- `C14_DIGEST.md` (2026-09-05) - C14 DIGEST — THE CREATION READ API
- `C13_DIGEST.md` (2026-09-05) - C13 — Rankings read API
