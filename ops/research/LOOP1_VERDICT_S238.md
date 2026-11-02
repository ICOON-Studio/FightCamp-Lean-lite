# LOOP1 verdict (S238) - one simple boxing loop, everything else OFF

Sources read: your words (LOOP1_SCOPE_S237.md), Ludo's answer (research/ludo_rx/LUDO_R102_LOOP1_raw.txt, 17,841 chars),
Paul's review (AgentComms/pm/PM_REVIEW_20261017_032242.md), our real-world load research (J62, J_STRESS_S206, LoadLedger.gd).
Ludo, Paul and I agree on the shape. Where they disagree, my call is marked **CALL** with the reason.

## The loop you will play
1. **A fighter walks in** with a goal and a deadline (e.g. "get me a fight inside 4 weeks"). A goal card with a
   day countdown and ON TRACK / AT RISK / OFF TRACK sits at the top centre the whole time.
2. **You set his day** (the Morning Day Plan, already built) and **watch him train** on the 3D floor (already built).
3. **THE METERS (your big point)**, top-left under his name, live while he trains:
   - **GAINS** (green bar + arrow "+1.8 today", 7-day sparkline): skill, conditioning, form.
   - **ATTRITION** (bar in three colour zones: cool = productive, amber = pushing it, red = overdone), with two
     small bars under it: **fatigue** and **wear/niggle risk**.
   - **"CHANGE THE PLAN"** signal: gains flatten while attrition is red, so the bar flashes and a pill reads
     "GAINS FLATTENED - SWAP TO RECOVERY". He also *shows* it on the floor: guard drops, hands on knees, slower punches.
   - One click fixes it: swap the current block to recovery (stretch / physio / rest) right from the floor.
   - A short end-of-day and end-of-week card repeats the same two bars with the trend.
4. **The coach**: hire one from a shortlist of 3, assign him to a station, and he walks over and works with the
   fighter (holds pads, steadies the bag, calls cues in a speech bubble: "His jab is dragging - pull him off the bags").
   A coached block gains faster and wears less, and the coach warns you *before* the red zone.
5. **Small daily corrections** for fatigue and stress go through the same meters (the recovery swap, a rest morning).
6. **Find the opponent**, book the fight, then the light camp extras (one-click film study revealing one tell).
7. **The fight**: the result checks the goal and brings the next goal or fighter.

## Keep ON / switch OFF (one `core_loop` preset; nothing deleted, each comes back with its switch)
| Item | Verdict | Why |
|---|---|---|
| Story (campaign, card, inbox, wall) | OFF | your call |
| 11-step tutorial card | OFF | the goal card is the tutorial |
| 6 decision cards a day (PACING1) | OFF in the loop | the meters are the decision now (Paul); the pure module still merges, unwired |
| Random floor events, floor cuts, corner rehearsal, open spar night | OFF | noise around the meters (Ludo, Paul) |
| Promoter traps, away circuit | OFF | after the loop works |
| Opponent-gym spying | OFF | film study is enough (Ludo) |
| Gym expansion / wall moving / walls toggle | OFF | fixed approved hall |
| Side rooms (ROOMS3 4-room build) | PARK | play stays on the floor; the rooms already built stay as they are (Ludo, Paul) |
| Boots (WARDROBE1) | PARK | not in the loop |
| New jab pair (PAIRLIVE1) | KEEP, behind the meters | the fight needs it; your C83/C84 fails stand |
| MMA, kicks, knees, clinch | OFF | boxing demo |
| Other members on the floor | **CALL: ambient only** | Ludo cuts them as a duty; you asked for "other customers" - they train in the background, no fee/admin screens yet |
| Equipment wear | OFF | operator Q-S237-1: "the equipment wear is not what matters on this" |
| Film study (after booking) | KEEP, lean | one click, one tell (Ludo) |
| Day plan, floor, gain bubbles, load ledger, wear, recovery, form, niggles, breakthrough | KEEP | they feed the meters |
| Coach hire + assign + coached blocks | KEEP | your loop step |
| Offers, matchmaking, booking, the fight | KEEP | your loop step |

**CALL - when the opponent comes in:** Ludo wants the opponent picked at the start; your order picks him later. I keep
**your order**: the goal sets the deadline, base training builds him, and booking an opponent opens the camp
(film, the tell). That is how real gyms work between fights. The opponent list shows from day 1, so you can book early.

## Numbers come from real research, not from Ludo's round figures
Ludo's thresholds (75% fatigue and so on) have no sources. The meters use our real-world load model instead:
session-RPE load (Foster) in `LoadLedger.gd`, the overreaching ladder from J_STRESS_S206 (planned dip / non-functional
overreaching / overtraining), and J62's warning that the ACWR thresholds are disputed. John checks the red-zone line
against boxing-camp sources before it ships.

## Build order (each slice ends in a playable .exe for you)
1. **Meters on the day you can already play**: GAINS / ATTRITION / CHANGE THE PLAN + the one-click recovery swap. (Arena builds the pure module; I wire it.)
2. **The coach**: hire 1 of 3, assign to a station, walks over and works with him, boosts the meters, warns early.
3. **Walk-in + goal card**: intake, deadline countdown, on-track status, success/fail.
4. **Opponent + booking + film study + the fight**, closing the loop (needs the jab pair to pass your eyes).

Story, tutorial, decision cards and the other OFF items go dark in the game the moment slice 1 ships.

## APPROVED (operator, board Q-S237-1, 2026-10-17)
"build it, the equipment wear is not what matters on this , the loop , animations,workout,feeling of progrsession and improvement from training these are what matters for now"

So: equipment wear OFF; the priority is the loop, the workout animations, and a visible feeling of progression from training (the GAINS side of the meters is as important as the warning).
