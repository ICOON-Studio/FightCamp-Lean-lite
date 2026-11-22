# DESIGN WEIGHT3 - the depth moves to reading the opponent's cut (S537)

Status: PROBED, FAIL (docs/WEIGHT3_PROBE.md). NOT for critics, NOT for the board as a design. Discipline: boxing.
Owner decision it follows (S537, on docs/WEIGHT2_PROBE5.md): "Yes, move it". Bar (S534): 8+ depth and 8+ play, probe first.
Every CODE line below was opened in this session (file:line); every PROBE line is a number from docs/WEIGHT3_PROBE.md.

## 0. Verdict first

The idea as written does not work on today's fight code, and a one-line repair does not rescue it.
- PROBE: boxing the right plan for the man in front of him is worth +0.0 wins in 100 over boxing the one best plan every
  night (bar 1 not met); one plan is best in 8 of 10 cells (bar 2 not met); a wrong read costs nothing (bar 3 not met).
- PROBE: the brief's own late lines lose against everyone: Push from round 3 -12 wins in 100, "Let your hands go" from
  round 3 -23, whether he cut hard or not.
- A correction to the brief: round 5's section 7 did not show the read worth +1.11 rungs. A lower ladder place is the
  better one; the reading arms finished 0.92 and 1.11 rungs BEHIND blind (docs/WEIGHT2_PROBE5.md lines 486-488).
- What stays true from the decision: OUR side simple (section 1) needs nothing from this probe and can be built as is.

## 1. Our side, simple (unchanged by the probe)

| Rule | Where it is today |
| :--- | :--- |
| A natural class: the boxer boxes the class his walking weight makes | CODE Data.gd:60 (limit, weight on the person); Sim.gd:120-123 cuts only while over the limit with a bout or a cut diet |
| Draining only when forced (a booking at a class below) | CODE Sim.gd:136 weigh_forecast already dry-runs a booking's scale; the offer is where a forced cut is priced |
| The scale itself | CODE Bouts.gd:360-366 weigh; BoutRules.gd:283 made_weight, BoutRules.gd:112 a missed scale $300; club shows use the gap rule (WeighGap.gd:24) |
| What a cut costs him on the night | CODE BoutNight.gd:324: the bout's "stale" comes off his tank at the first bell |
| No diet / water / move-up menu | Nothing to build: round 5 measured STAY best in 10 of 15 cells, UP right for nobody |

## 2. The depth as the decision wrote it

The tape shows "On the scales" beside his walking weight; scouting and film decide how sure the number is; the plan's
late-round lines pay against a drained man and cost against one who did not cut; a wrong read costs.

### 2.1 Menu table: where it would appear and what each is wired to today

| Menu | What would show | Wired to today (CODE) | Missing |
| :--- | :--- | :--- | :--- |
| Tape, "ON THE SCALES" row | his scale weight beside his walking weight ("60.0 kg, walks 66") | TapeVersus.gd:22 titles the Weight row; TapeRows.gd:70-74 builds it; TapeRows.gd:80-86 INVENTS his weight, 0.2 to 0.8 kg under the limit from his name | an opponent has no walking weight and no cut anywhere; the row is decoration |
| Scouting ($250) | narrows the range on his walking weight | Matchmaking.gd:40 SCOUT_COST, :41-42 the range 12 -> 4 on his rating only | no weight in the scouted file |
| Opponent file (film) | "cuts hard" as a tell | OppFile.gd:71 tells, :120 known (file_found); AttrGen.gd:54 the word "fades" = Stamina -14, Recovery -8 | no tell about weight; "fades" is a fixed word of the sheet, not a result of a cut |
| The misread | the shown walking weight is wrong the way Knowledge is wrong | Knowledge.gd:38 SHARED_MISREAD 0.5, :370-376; built for prospects only (docs/KNOWMISREAD1_RESULT.md, "Next" item 3) | not built on the opponent's file |
| Fight plan, ROUND row | Push / Take it easy by round, with a hint | PlanFile.gd:139 pace_for (round_pace); PlanFile.gd:124 already hints "Fades late: save your legs for round 3 and push"; GamePlanRows.gd:42 shows the hints | the hint is wrong on the numbers: section 3 |
| Corner, between rounds | the call for the round | Exchanges.gd:69-94 the eight calls, :124-134 what each is against each situation | - |
| Shout bar | Go to the body | PaceAim.gd:17-19 (half the punches downstairs, +3 once he is burnt), LiveRound.gd:166-172 | the aim is lost at every bell (LiveRound.open, :111, reads a round that was erased) |
| Result page | "he came in dry: rounds 5 and 6 were yours" | ResultCause.gd, FightWhy (not opened here: named only) | nothing about weight |

### 2.2 What the fight code does with a drained man (CODE)

- His tank: BoutNight.gd:324 starts the opponent on a full tank every bout. Only ours pays the scale.
- His word: Exchanges.gd:276, a "fades" opponent fights "Tiring" in half his exchanges from round 3; Exchanges.gd:273, any
  opponent under 45 energy does so in three of four.
- Against "Tiring" the best call is "Let your hands go", the ok one "Go to the body" (Exchanges.gd:130), worth 17 and 5
  points an exchange (Exchanges.gd:18).
- But our own state comes first: Exchanges.gd:194-199. Under 35 energy the exchange is "Your fighter is tired", where
  "Let your hands go" is the WRONG call (Exchanges.gd:132, -10) and costs 3 energy an exchange (Exchanges.gd:82).
- Push: +6 an exchange (PaceAim.gd:11), 1.35 times the gas (PaceAim.gd:12), and it turns against him under 55 energy,
  -12 by 25 (PaceAim.gd:188-196).

## 3. The probe (docs/WEIGHT3_PROBE.md; tools/weight3_probe.gd, weight3_probe_rules.gd, weight3_probe_sum.py)

Round 5's field and cut model unchanged; our boxer at his natural class; every night boxed on each plan with the same
dice; 720 pilot nights x 12 plans, then 4,800 nights x 8 plans on seeds the pilot never saw, championship and pro.

| Bar (written before the main run, pro scale) | Measured | |
| :--- | :--- | :--- |
| 1. The read moves the result (exact read against the best single plan) | +0.0 +- 0.0 wins in 100 | NOT MET |
| 2. No plan best in more than 6 of 10 cells | take rounds 1-2 easy, push from round 5: best in 8 of 10 | NOT MET |
| 3. A wrong read clearly costs | the wrong read is +6.2 over planning nothing (it boxes the same plan) | NOT MET |
| 4. Best against laziest, 3+ wins in 100 | +6.2 +- 1.2, all of it the plan's, none of it the read's | MET |

Championship (three rounds): "take round 1 easy, hands go in round 3" pays 5.8 +- 2.5 more against a hard cutter than
against the rest, the one clear interaction found; a hard cutter there is one night in nine, so the read is worth
+0.1 +- 0.2 wins in 100.

### 3.1 Which lever broke

1. Our tank is the limit. Planning nothing, our boxer ends a six-rounder with about 7 of 100 (14 in three rounds), so the
   late rounds are fought as "your fighter is tired" and every late push or hands line is the wrong call (2.2).
2. A hard cutter is barely different: his tank is 60 against 62 as round 3 opens.
3. One plan is right against everyone (rest early, push from round 5): a rule to learn once, not a read.

### 3.2 The what-if that was tried (NOT the briefed model, not in the game)

His cut off HIS tank, as ours comes off ours (the smallest fix: BoutNight.gd:324). His tank drops to 45 by round 3; the
same three bars still fail (exact read +0.0; one plan best in 6 of 10; no plan pays clearly more against a cutter).

## 4. What it would take (design, not built, not probed)

Both, not one:
- the opponent pays the scale in his tank (BoutNight.gd:324), so a cut is something that happens late and not a word;
- our own boxer has something left to spend: the six-round tank refitted so a steady boxer ends near 30, or a tiring
  opponent outranking our own tiredness in Exchanges.situation.
The second is a change to the fight's stamina balance, far wider than weight. It belongs to the fight plan's own work
(the ROUND row has a dominant plan today, 3.1 item 3), not to a weight mechanic.

## 5. Risks and open items

- The cliff in round 5's model (a 9 % cut fades, an 8 % one only loses rating) was kept as briefed; the what-if has none
  and fails the same way, so the cliff is not why this fails.
- The probe boxes plain bouts, no ladder; our own missed scales are left out (our side is STAY).
- PlanFile.gd:124's hint ("save your legs for round 3 and push") names a plan the probe measured as right against
  EVERY opponent in three rounds and wrong from round 3 in six. A defect of the hint, outside this task's files.
- For the owner (scope): keep our side simple and drop the opponent's-cut read, or fund the stamina change of section 4
  first and probe again. Recommendation: build section 1 only; park the read until the plan's ROUND row is rebalanced.
