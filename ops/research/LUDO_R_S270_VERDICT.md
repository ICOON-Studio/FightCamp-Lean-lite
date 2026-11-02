# LUDO S270 VERDICT (Claude) - Ziva's review -> the plan to 10/10

Ask: `LUDO_ASK_S270_ZIVA_10.txt` (Ziva's full report + Claude's opinion + 7 questions, 3 stills). Reply verbatim:
`ludo_rx/LUDO_S270_ZIVA_10_raw.txt` (22,238 chars, one message, complete). Operator S270: "let ludo know about zivas review and how
to improve to 10/10 and what is your opinion".

## What Ludo says, in one paragraph
The game lacks ONE guiding spine for the first hour. Keep the floor visible: the Day Plan and the coach offer become non-blocking
(drawer / a "1 NEW APPLICANT" reception chip), START DAY tucks the UI to the edges and follows the boxer, day 1 runs at 1x until the
first gain bubble, and each day ends on a receipt with one decision for tomorrow. Keep the 0.40 coachless rule, but make the first
coach hire step 3 of a guided first career so the player feels the jump. In the fight: a lower, closer broadcast camera (22 deg, 11
units, FOV 42) and an impact tag on clean exchanges ("POWER 55 vs GUARD 48 -> CLEAN HIT") so training reads in the bout, plus hit
sparks and a 2 px shake on clean power shots. Corner and result get punchier presentation (circular rest timer, icon chips with a
projected effect, a gym-cut line, an attribute ledger).

## Verdict - BUILD NOW (inside approved features; owners)
| # | Item (Ludo) | Owner | Note |
|---|---|---|---|
| 1 | Globe hit radius + sway freeze on hover | Cursor #288 | Ludo says 32 px + snap to nearest; the brief said 28 -> raised to 32 + snap (issue body updated) |
| 2 | Kill the 4.5 s market-commit freeze (backdrop after the cards) | Cursor #288 | already briefed |
| 3 | Coach offer = "1 NEW APPLICANT" reception chip, never a modal over the plan | Ziva ZIVA9 (P5) | NOT NOW -> self-run day is already on branch s270-b1 |
| 4 | Day Plan as a non-blocking drawer; START DAY tucks the UI and the camera follows him | Ziva ZIVA9 (P4) | Two Point modals rule (TWOPOINT_HUD_S268) still holds for decisions |
| 5 | Day 1 at 1x until the first gain bubble, then the speed buttons unlock | Ziva ZIVA9 (P4) | |
| 6 | End-of-day receipt: gains per attribute, fatigue, the day's cost, coach line, ONE choice (keep plan / swap tomorrow to recovery) | Ziva ZIVA9 (P10) | extend the existing DayWrapDrawer (Ludo r82), do not build a new screen |
| 7 | Drop the duplicate STAMINA / STRAIN bars; the meters panel is the one read | Ziva ZIVA9 (HUD round 2) | |
| 8 | Live gym feed replaces the placeholder line | Cursor #288 (P9) | first-day line already briefed; feed lines later |
| 9 | Fight camera lower/closer (22 deg elevation, 11 units, FOV 42, truck to keep both centred) | Ziva ZIVA9 (fight) | a look change on the live fight: closes only on game-camera stills the operator OKs (visual gate) |
| 10 | Impact tag on clean exchanges (attribute vs attribute -> outcome, 1.2 s) | Ziva wiring + a pure tag-text module | inside FIGHTLINK ("training shows in the fight", approved) |
| 11 | Hit sparks + 2 px micro-shake on clean power shots | Ziva ZIVA9 (fight) | no sound |
| 12 | Money one truth across creation / HUD / review | Claude, done on s270-b1 (P6) | |
| 13 | Corner: circular rest-timer sweep; advice chips with an icon and a projected effect | Ziva ZIVA9 (corner) | projected numbers must come from the engine, never invented |

## NEEDS THE OPERATOR (board Q - new mechanic / scope / look)
- A GUIDED FIRST CAREER: quest chips (MEET YOUR FIGHTER -> ASSIGN A STATION -> first gain -> HIRE YOUR FIRST COACH by 10:00 day 1
  -> book a debut from the office -> fight week -> fight -> week review), Ludo's minute-by-minute beat sheet (raw file PART 2).
  It changes the start of every new career, so it is his call.
- Two-tier venue dressing (club hall vs pro arena) - Ludo tags NEEDS OPERATOR (art scope).
- Manager-licence gym cut (the "$0 TO THE GYM" line) - money system, Ludo tags NEEDS OPERATOR.
- Knockdown cinematic floor cam - Ludo tags NEEDS OPERATOR.

## Where Claude disagrees with Ludo
- `DayResolutionEngine.gd` (PART 8): NOT built. It is a second training model (its own gain formula, fatigue, coach multiplier)
  beside the live one (AttributeTraining + StationFocusTraining + DayLapSplice + BodyReadiness + file_visit). Two models = two truths,
  the exact defect Ziva found with money. The receipt (item 6) reads the live model.
- Ludo's example numbers (+0.42 POWER per block, gain rate "doubles" with a coach, x1.15) are illustrations, not our measured rates
  (a self-run 600-minute day moves the trained stats ~0.15 in total, test self_run_day_test). No rate changes without a measurement
  and a reason - the visible-gain problem is presentation (when and how the bubble shows), not the size of the number.
- "Remove the fullscreen Day Plan modal": the plan stays a decision the player makes each morning (operator S267 "you set his program
  then watch him do it"); it moves to a drawer that does not hide the floor, it does not disappear.

## Operator answers (board, S270)
- Q-S264-3 UltraTex trial: "no, skip it" - dropped.
- Q-S264-4 guided first career: "no guided yet unitl the loop is proven fun keep it simple but what if 2 or 3 boxers come into the
  gym thep player will have to profam each fighter on different stations that might be a good puzzle if you cna show it to the
  player good enough to understand his options" -> NO guided start. The multi-boxer station puzzle went to Ludo
  (LUDO_ASK_S270_MULTIBOXER.txt); its verdict comes back to the board before anything is built.
- Q-S264-5 venues / gym cut / knockdown cam: "do whatever you think is better" -> Claude's call:
  1. GYM CUT LINE - YES, now, as presentation only: the result screen's "TO THE GYM - NO MANAGER CONTRACT FILED - $0" gets one line
     saying how the gym earns from a fighter (a manager contract) and where it is filed. The existing contract system is unchanged
     (no new licence or fee). Owner: Ziva (result screen is in ZIVA9).
  2. CLUB-HALL VENUE - LATER, after the fight camera lands: the demo's bouts are club bouts, so dress one club hall first (Ludo's
     PART 5 brick walls, folding chairs, 30-50 people); the pro arena waits. Art scope goes through Ludo/Maria with stills.
  3. KNOCKDOWN FLOOR CAM - NO for now: a cut that only fires on knockdowns costs camera work while the base broadcast camera is
     still being fixed; revisit after the camera rating reaches 9.
