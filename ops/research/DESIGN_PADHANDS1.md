# PADHANDS1 - the coach's hands as the club's currency: design map v1, from the code (S537, DEPTH35 change 3)

Source: DEPTH_AUDIT_S534.md part 4 change 3, DEPTH_SCOPE_S534.md row 3. Bar (owner S534): the lever is probed on a greybox
BEFORE the critics; then 8+ DEPTH and 8+ PLAY from two fresh critics. Probe: tools/padhands_probe.gd, result
docs/PADHANDS1_RESULT.md. **Read section 6 first: the probe's verdict decides whether this map goes to critics.**

## 1. What the owner already ruled (this map must not break it)
- Q-S294-242 (15 Nov): pad hours shared so "someone goes to the bag that night" - **"No, never short"**.
- Q-S294-260 (16 Nov): boxers on the same night sharing the coach's 75 minutes - **"full pads, no sharing , thats for forcing
  more coaches to be hired ?"**
- Q-S294-273 (18 Nov), club week v11 on pad turns - **"what do you think ?"** (open; this map is the answer proposed).
So the audit's sentence "sharing the pad nights between boxers in camp is agreed and not built" (critic pack 4.2) is OLDER
than his ruling. Nobody is ever made short here. The currency has to be something ON TOP of full pads.

## 2. What the game does today (CODE)
| Claim | Where |
|---|---|
| Every boxer on pads that evening gets the full session; nothing is shared | scripts/state/DrillWeek.gd:149-150 (`on_pads`) |
| One coach rating teaches everybody: `pad_skill` = the hired coach's pads area | scripts/state/DrillWeek.gd:159 |
| A pad night is 240 drill units, split over the cards on it | scripts/rules/PadWeek.gd:38, :333 (`night_minutes`), :338 |
| Nights a week: between fights 2+1 / 3+1 / 4+1 pads+spar, in camp 2+1 / 2+2 / 3+2 | scripts/rules/PadWeek.gd:54, :79 (`nights_for`) |
| The week runs night by night through one function, the same the forecasts call | scripts/rules/PadWeek.gd:369 (`run_week`), :348 (`drill`) |
| Gain = rate x minutes x coach (1 + 0.40 x rating/100) x room left under the cap | scripts/rules/MoveMastery.gd:62-66 |
| A punch's cap = 40 + 0.4 technique + 0.2 ring IQ; a combination is never sharper than its weakest punch | scripts/rules/MoveMastery.gd:47-48, scripts/rules/Combos.gd:81-88 |
| A combination drills at minutes x 2 / its number of punches (longer = slower) | scripts/rules/Combos.gd:92-97 |
| With a bout booked the coach lays the plan's cards on the pad nights in order | scripts/rules/PlanCards.gd:205-213 (`coach_week`) |
| A class night puts the boxers on the bag at half the minutes | scripts/state/DrillWeek.gd:189-193, scripts/rules/ClubClasses.gd:15 |
| In the fight a planned line under 30 never fires; Usable fires 1 in 2, Sharp 3 in 4, Signature always | scripts/rules/FireLevel.gd:17-18, :24, :33-45 |
| The answer to an opponent's game is a table: best / ok / wrong per situation | scripts/rules/PlanFight.gd:49-75 (`ANSWERS`), scripts/rules/OppFile.gd:111 (`main_game`) |
| An amateur bout is known 2 to 4 weeks ahead | scripts/rules/AmateurBooking.gd:10-11 |
| The coaches: Reid pads 74 ("three evenings a week", read by nothing), Hale pads 58 | scripts/state/Data.gd:33-38 |
| A pad-place deal exists as a pure module with no screen and no wiring (asks 3, +2 in fight week) | scripts/rules/ClubDeal.gd:6, :12, :43 (`coach_order`) |
| That module could not serve four boxers: 12 asked against 8 owned, every boxer short every week | docs/LOYAL1_RESULT.md (S461, rerun S462) |

## 3. The rule proposed
1. **Full pads stay.** Every boxer keeps every pad night with the coach's full rating (today's game, his ruling).
2. **The coach's ONE-TO-ONES.** On top, each hired coach has a few one-to-one sessions a week: the sessional coach 2, a
   full-time coach 3 (the note "three evenings a week" finally reads as something). One session = 120 drill units (half a
   pad night) on ONE card of ONE boxer, at that coach's pads rating.
3. **The player deals them on Monday** (the coach deals by his own order when the player does not: fight week first, then
   the nearest bout, then the roster - `ClubDeal.coach_order`'s order). This is the one new decision: whose fight matters
   more this week.
4. **More hands = more coaches.** A second coach brings his own sessions (his answer in Q-260: "forcing more coaches to be
   hired"). No boxer is ever worse off than today; a boxer who gets none loses nothing she has now.
5. **Not built with this map:** loyalty reading who was passed over (Loyalty has no reader of pad places today:
   scripts/state/GymSpend.gd:355 runs the weekly drift only). It enters only if the probe shows the sessions decide bouts.

## 4. Sizing first (LOYAL1's lesson: count the places before the rule)
- Places: 2 sessions a week against 4 boxers. Asked: 1 each in an ordinary week (4), 2 for a boxer with a bout known (up to
  8). Owned 2, so the question exists every week and nobody is "short" of anything he had.
- What one session buys (measured, tools/padhands_probe.gd controls): about +5 on a new two-punch combination, +3 on a
  three-punch one, under +1 near her cap.

## 5. Where it is shown and wired (one row per menu)
| Menu | What appears | Wired to |
|---|---|---|
| Training > coach row (scripts/ui/TrainCoach.gd) | "One-to-ones this week: 2" with the boxers' faces to drop them on | new `f["one_to_one"]` count per boxer, read by DrillWeek.run after `PadWeek.run_week` |
| Training > "Learn on the pads" card (scripts/ui/TrainSide.gd) | each card's forecast with and without a session ("usable Wed" / "usable next Mon") | `PadWeek.project` with the extra minutes |
| Home > Monday needs | "Reid has 2 one-to-ones: Lucy fights Saturday, Kira in 2 weeks" | the bouts known + each boxer's nearest tier line |
| Fights > Fight prep (scripts/ui/FightPrep.gd) | on a plan line not ready by the bell: "one-to-one this week makes it ready" | the same forecast |
| Week review | "Reid's one-to-ones: Kira x2 - slip and counter 24 to 33, usable" | the week's log (`PadWeek.run_week` log rows) |
| Club > People, hiring card | "brings 2 one-to-ones a week" on each coach | the coach's kind |

## 6. The probe's verdict
FAIL (S537): giving EVERY boxer every session moves the club 0.09 to 0.25 wins in 100; in 6 to 8 cells of 10 every deal is a dead tie. The lever that broke: under full pads the normal week already readies an answer in 2 weeks and the answer is worth about 3 wins in 100. Not sent to critics; the rule above stays a proposal. Details and what would have to move: docs/PADHANDS1_RESULT.md.

## 7. The 10/10 target (what the mechanic would have to be)
- A week in which two boxers have a bout known and one answer each is not ready: the player can see, before clicking,
  what each session changes on fight night in wins, not in mastery points.
- No deal order is right more than 6 weeks in 10: nearest fight first loses when the far boxer's answer is the long one.
- The boxer passed over says so (loyalty), and a second coach is a real purchase because of it.
- One golden-path test: Monday deal, the card's forecast moves, the line fires on fight night, the review names the session.
