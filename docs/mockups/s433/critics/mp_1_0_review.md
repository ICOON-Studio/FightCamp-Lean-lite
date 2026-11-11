# Mat plan (MATPLAN_MAP_S433): critic mp_1_0 - a no-gi black belt who builds competitors' game plans

**Depth: 7 / 10.** The map makes a real game plan: opening, A-game, escape order, finish, and pace by the score. Each line is priced from the walk's own numbers, rated against a file you pay a class to fill, graded after the match and wired to 12 menus. It stops at 7 for three reasons. At white belt, where Ana spends the first season, most lines are only a timing choice. The baseline it is measured against has a pin bug on both sides. And two of the numbers on the screen claim more than the engine gives.

Read: CRITIC_PACK, CRITIC_ACCESS, the map whole, matplan_v1.png, BjjBeat (whole), BjjWalk 37-336 (choose, attempt, start), BjjBody CALLS, BjjTree constants, odds, p_bad and node_value, BjjOpen 29-97, BjjMatch function list, bjj_tree.json (every edge from the bad positions, mount top, side control top, closed guard bottom, half guard, standing).
My 10/10 drawing: `docs/mockups/s433/critics/mp_1_0_10.png`. New parts are in dashed purple.

## What is right (as a coach)
- These five parts are how a real no-gi plan is written: where to start (wrestle or pull), the A-game, "never give the back", where you finish, and "two up, hold it; behind, go". The words are right too: frames underneath, set it up, position before submission.
- The trade-offs are real. SHOOT scores 2 but costs Tank and can hand over the front headlock. PULL GUARD is free and scores nothing. FRAME FIRST is safer but gives the top 22 s. A long script gets read (TheRead looks). The hand by belt (3/4/5) is a good limit: a white belt really cannot carry a plan for 47 positions.
- FILM costs a class, so scouting competes with mat time. That is the right price.
- The receipt, the leak naming the failed line and ON THE MATS close the loop between the match and the week.
- Code claims I checked, all true. BjjWalk.choose rates picks against the opponent's TRUE answers (`_ans`). `mat_call` exists (BjjBody.CALLS) and no screen sets it. SUB_TRAIL x0.5 is written into T on every trailing beat. Under a pin, an escape's score is negative: gain 0 against a loss of 4 plus the top's finish value, and the `[0, {}]` hold candidate wins, so Ana WORKs and never escapes. File sizes: MatTree 499, MatTreeInfo 502, BjjWalk 488.
- KNOWN ANSWERS, TRAILFIX and the MatTreeInfo split are named as foundation tasks (M0, M5), so they count as handled.

## What holds it at 7
1. **The pin bug hits BOTH sides, and the map fixes it only where Ana has a line.** `choose` gives every escape a negative worth, so no side ever escapes a pin unless a script tells it to. The AI opponents never escape Ana's pins. An unlined position (the hand is 3 at white) keeps today's "never escape". So MATPLAN0 / MATLINE1 would measure "a script fixes a bug" rather than "a plan beats a sane improviser". Coach's draft would look like magic, and every opponent would be easier to pin than any real white belt.
2. **At white, the escape "choice" is mostly one move.** In the data: back bottom has only the seatbelt escape. Mount bottom has only shrimp-bridge (no trap-and-roll, which is THE first mount escape every white belt learns). Knee on belly and north-south have only shrimp. Turtle has only stand-up (granby is blue). Side control is the one real pair. So in the first season the player's line is a timing chip on a fixed move. The map says this (risk "worth little at white"), but that only explains the gap, it does not close it.
3. **The FRAME FIRST and SET IT UP price overstates the gain.** The grip lever is `GRIP_W x (own stacks - the other's stacks)`, and the top is working grips too, so it often cancels. AT ONCE is not "the bare chance" either. Ana acts only on the act roll (0.34, +0.25 per stack), so a failed act roll already builds a stack. The real gap between the timings is smaller than "+7" and it changes by opponent. The screen also shows no price for the waiting: how often the top attacks in those 22 s.
4. **The corner's grade from one "same seed" replay is mostly noise.** A different plan uses the dice differently (eps roll, act roll, slide roll), so the replay splits off at the first different pick. One paired replay will often call a good plan WRONG. The boxers' swing count works because their exchange count is fixed. On the mat it is not.
5. **The Tank resets every bout** (`BjjWalk.start`: gas 1.0). An open is three matches in a day. Pacing across the bracket is the biggest pace decision a real competitor makes, and it is missing. Push in R1 costs nothing for the final.
6. **There is no B-game.** When the guard is passed the plan is gone. "Where the match goes" already knows where Ana ends up off the route (half guard bottom against passers) and offers nothing there.
7. **A live bout loses the receipt and the grade.** `BjjOpen.live_bout` stores `path: []`. A player who fights the match themselves gets no per-line receipt, leak line or replay grade. The map warns only that the live bout "reads less of the plan".

## To reach 10/10 (most important first)
1. **Fix the improviser's pin value for both sides before any probe (fold into M4, first commit).** In `BjjWalk.choose`, give an escape the cost of staying pinned: the top's expected points and finish threat for the beats left (from node_value of the top's position and the top's best edge from there). Then an unlined pin gets escape attempts at a sane rate and the AI opponents escape Ana's pins. Bar: white bout finish rate and first-scorer share stay in their GAMETREE bands. MATPLAN0 runs only after this.
2. **Give the white belt a real escape choice in bjj_tree.json.**
   - Trap and roll from mount bottom: a reversal, lands Ana in the opponent's closed guard on top, scores 2. The answer is the top posting a hand (new answer move). A miss gives the back.
   - Elbow-knee escape, separate from shrimp-bridge to half guard.
   - From side control, the ghost escape / turn-in.
   - A second back escape: to the hooks side vs to the choke side.
   - Then every white bad position has two moves with a real trade (points and top position vs a safe guard), and "1 of 2" means something.
3. **Price the timings with the beat engine, not the bare formula.** MatPrice gets the chance by running the beat loop (seeded walks per line) with the opponent's grips and the act roll. Add a WHILE ANA WAITS chip:
   - FRAME FIRST: "22 s pinned: the top tries about 0.7, a sub on Ana 3 in 100".
   - SET IT UP: "the bottom escapes 9 in 100".
   - MATFRAME1 checks each chip against measured walks to within 3 in 100.
4. **Grade from 200 paired replays, shown as a range.** Use one rng stream per side per beat (seeded from bout seed + beat + side), so both plans see the same dice on the same beat. Show "+3 points (+1 to +5)". The word is GOOD or WRONG only when the range leaves 0 out, else MIXED.
5. **THE DAY: one Tank for the bracket.** Each bout starts at the Tank left plus recovery from Cardio for 20 min of rest (ESTIMATE, probe MATDAY1: it must move medals by 1.5+ in 100). Show the R1 / R2 / final starting Tank on the Fight plan and the open card. The BEHIND Push row then shows its cost to the final.
6. **B-GAME: one more route.** It starts at the off-route position the field walks Ana into most (MatTreeInfo.leaks / where the match goes). Drafted by Coach, counts as one line of the hand, drawn under the A-game. Example: half guard, underhook up, dogfight, come up on top.
7. **VS THE FIELD when no bracket is drawn.** Show the plan's worth against Coach's for each of the five styles: the boxers' "Rate against", with the green / amber / red bars in my drawing. Planning before the draw becomes a choice, and the screen shows that no plan beats all five.
8. **Keep the receipt and grade for a live bout.** Record BjjMatch calls as tree edges where BjjClash.WHERE maps to a tree position, then build the receipt from them. Where that cannot be done, say "fought live: no grade" on the Fight it button's hover BEFORE the player chooses.
9. **The file says what each entry changed.**
   - The go-to route: "pull first: Rosa's route never starts".
   - The hole: "Swap: 14 -> 48".
   - The opponent's opening by style: "a guard player pulls first 6 in 10", priced against Ana's OPENING.
   - FILM's class cost is then visibly paid back.
10. **The AHEAD row's clock is a setting** (Save holds from 1:00 / 2:00 / 3:00). Today it is a side effect: aggression at 35 or less doubles LATE_S. "Two up with two minutes" is what a coach actually shouts.
11. **Check the escape landings with a coach's table before MATPRICE1 locks the numbers.** The seatbelt escape lands in half guard TOP, and a miss hands over mount with +4 on top of the back's 4. A failed back escape usually stays on the back or flattens out.
12. **Later, only if BJJ gets injuries:** a sub-defence word (tap early: lose the match, no injury; fight it: escape chance, injury roll). It is real coaching and gives a season effect.

## Complete?
Yes, as a build map. Every part has a rule, a screen, a wire (12 menus in the table), a red test, an owner and a probe with a cut rule. The golden path walks the plan from Coach's draft to the drill on next week. Two conditions before the probes are trusted: item 1 (the pin value for both sides) goes in before MATPLAN0, and item 3 (prices from the beat engine) goes into M3. Without them, the screen's "+2 to +6" and "42 in 100" claim more than the engine does.
