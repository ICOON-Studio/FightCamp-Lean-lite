# Ana's mat plan (MATPLAN_MAP_S433): depth review, critic mp_1_1 (fresh, blind)

Role: lead designer of tactics and game-plan systems. Read whole: CRITIC_PACK, CRITIC_ACCESS, MATPLAN_MAP_S433 and the drawing
matplan_v1.png. Code read for the map's claims: BjjBeat (whole), BjjWalk (choose, attempt, _ctx, _parts), BjjTree (T0, odds, IQ, mf,
node_value), BjjBody (CALLS, aggression thresholds), TheRead (looks), BjjOpen (leak_of, roll_week), NoGi (classes, DRILL_GAIN), BjjFilm,
MatTree header, OpenNight header, assets/data/bjj_tree.json (the escape, finish and opening edges). Line counts checked.

## Score: DEPTH 7 / 10
One line: a real no-gi game plan (opening, A-game, escape order, finish, the score) built on the engine's own numbers, with real prices
and an honest receipt. But two of the drawn numbers would lie on screen, and the opponent cannot play back, so one timing choice is
very likely the best pick every time.

## What the code says, claim by claim
| Map claim | Checked | Verdict |
|---|---|---|
| Line counts (MatTree 499, MatTreeInfo 502, BjjWalk 488, BjjBeat 227, BjjMatch 356, GrapplerPage 448, OpenNight 97, NoGi 312, Grapplers 263, MatOpens 72) | wc | TRUE |
| f["mat_call"] moves aggression, no screen sets it (CALLS hunt +25 / steady 0 / hold -20) | grep: only BjjBody.gd:90 | TRUE |
| Improvising rates answers at the opponent's TRUE levels | BjjWalk._ans reads the defender's real levels; choose uses it | TRUE, and a good catch |
| Only plan picks are read (3 looks each, 16 at white, 5 at brown) | BjjWalk.attempt: read only when why == plan; one shared counter | TRUE |
| Late hold 60 s, 120 s at aggression 35 or less, never at 68+ | LATE_S 60, CAUTIOUS_AGGR 35, HOLD_AGGR 68 | TRUE |
| Under a pin the walk never tries an escape | choose: escapes score below the HOLD row at 0.0; but EPS (0.17 at white) picks the second best, so the bottom does try one now and then | MOSTLY TRUE ("rarely", not "never") |
| SUB_TRAIL halves the trailer's scoring tries | T0 SUB_TRAIL 0.5, BjjBeat._trail_cut | TRUE |
| Two idle beats off a pin = the 20-s count | BjjBeat uses T.STALL_N, and T0 sets it to 5, with IDLE_P 0.82 | STALE: it is 5 beats in the tuned game. The Save row text "20-s count off a pin" is still true in kind |
| The tape was never built | BjjFilm.gd exists, but it is the GrappleMap film of each move (the move player), not scouting | TRUE |
| The gym roll is a free "Test it" | BjjOpen.roll_week walks against Marta, the fixed gym partner, every 2nd Sunday | TRUE as a run, but it does not test the plan against the next opponent |
| Worked numbers of section 5 (0.50, 0.154, 0.197, 0.345, 0.416, ...) | formula correct, BUT see defect 2 | WRONG IN PLAY |
| Swap hint "Kimura grip beats Rosa: 48" | e056 kimura from closed guard is an ENTRY to the kimura trap (miss stays in closed guard); the tap is a second arrow, e026 | MISLEADING, see defect 1 |

## The two defects that would put wrong numbers on screen
1. THE SWAP HINT COMPARES A GRIP TO A TAP. "Armbar from guard 14 in 100" is a finish; "Kimura grip 48" is only the entry to the kimura
   trap. The tap is a second roll (kimura e026, base about 0.16, about 0.18 with no kimura defence). To the tap that is about 48 x 19 = 9 in 100 a
   pass, against the armbar's 14. The entry's miss costs nothing, so tries repeat, and the real comparison is points and taps a match. As drawn, the
   amber line can tell the player to swap to the worse finish. Every chance on the page must be to the end of the line (the score or the tap).
2. THE BOTTOM'S GRIP STACK IS LEFT OUT. In BjjBeat a side with nothing worth trying WORKS (never idles under a pin), so the pinned bottom sits
   at 2 grip stacks (GRIP_MAX). _parts adds 0.15 x (own stacks - other's stacks). An at-once Americana is therefore at -0.30 on the logit, not 0;
   SET IT UP only gets back to even. The drawn "15 at once / 20 set up" should read about 12 / 15. M3's test locks the wrong numbers in to 0.005.

## The structural gap: the opponent cannot play back
- Opponents get a route and the walk's own picks. No escape order, no timing, no scoreboard (the map leaves "opponents with their own scoreboard"
  for later). Under Ana's pins the AI bottom almost never escapes (escape worth below zero, see above), so SET IT UP costs Ana nothing but
  clock. Expect SET IT UP to beat AT ONCE against all five styles. MATFINISH1 asks for a style where AT ONCE wins, but no such bottom exists in
  the game. That is a dominant strategy built in.
- The same gap makes the file thin. The tape can find a route, an answer and a hole, but not HOW Rosa fights from a spot (frames first, escapes
  at once, holds when ahead). Those are the facts that would make Ana's timing choices read against a person.
- Fix in the same version: the opponents get lines too. Use the Coach's-draft generator on the opponent, with a timing and a scoreboard
  bent by style (a Leg locker Push, a Wrestler at-once escapes, a Guard player frames first). Then FRAME FIRST against an at-once escaper,
  and SET IT UP against a framer, become real reads that the tape finds.

## What is deep and should stay
- Five parts that match how a real no-gi coach plans a match. The hand (3 / 4 / 5 by belt) makes the player rank them. "Left at home" is a
  good visible cut.
- Every line carries real prices from the engine: chance, miss slide, Tank, the read, time under the pin. AT ONCE vs FRAME FIRST vs SIT TIGHT
  is a true trade-off under the beat model (time against odds against the slide).
- KNOWN ANSWERS: improvising today knows the opponent's true answers, so a scripted line can only lose. Fixing that is what gives the file a
  value. Best idea in the map.
- The scoreboard turns a hidden dial (mat_call) into three readable rows, with the boxers' words.
- The corner's grade replays the same dice with Coach's draft. That is an honest "your plan made the difference" for the mat. Receipts,
  KEEP / ON THE MATS and bouts that teach close the loop into training.
- The menu table, golden path, probes with cut rules and build order are complete. The worries the map raises itself (white-belt
  thinness, two engines, files at the line limit) are named, not hidden.

## Smaller points
- WORTH per line is in the text (section 5 columns) but not in the drawing. Without it, the player cannot rank lines for the hand.
- The read is one counter across every brought try, so a line's read depends on when it comes in the match. Show a range, not a fixed "x0.82 by
  the 3rd try".
- "Test it" against Marta on a Sunday does not test the plan against Rosa. The boxers have Test it with limited tries. The mat needs the same:
  seeded matches against Rosa as filmed (her found facts, the field's average for the rest), 3 tries a week.
- FILM and ON THE MATS have a cost (one of three classes; the week's one drilled move) that the button does not show. Show what each one
  takes away: "Seatbelt escape Owned a week later".
- Fighters are people: nothing in the plan reads Ana's Composure or Coachability. A low-Composure athlete holding FRAME FIRST under a pin is the
  mat's version of the boxers' trust rule.
- The scoreboard has score but no clock. "Behind with a minute left" is the most common call in real no-gi. One more column (the last minute)
  is cheap on the same dial.
- The live bout (Fight it) still ignores the plan except for a tag. The map says so. It is the biggest thing left for later.

## To reach 10/10 (most important first)
1. Opponents bring lines: run Coach's draft for each bracket opponent (escape order with timing, finish timing, scoreboard rows) from the
   style (Wrestler at once / stand up, Guard player frames first, Leg locker Push always, Passer Save when ahead). MatLines.pick then runs
   for side 1 too. MATFINISH1 and MATFRAME1 run against these, so each timing loses to some style.
2. Chances to the end of the line: the chip and the swap hint show the chance of the whole line to its score or tap (entry x finish for
   kimura-trap and back-take lines), plus "a miss costs nothing, tries again". The swap hint compares like with like: expected points and taps
   a match from MatPrice.worth.
3. Count the defender's grip stack in every chance (the bottom under a pin at 2 stacks). Redo the section-5 worked numbers and M3's test
   values with it, so the screen shows what the walk plays.
4. The tape finds HOW the opponent fights: file entries for the opponent's escape timing from each pin, their scoreboard when ahead, and their
   opening, after the route, the answer and the hole. The ROSA THERE column shows the found fact on each of Ana's lines.
5. Test it against the next opponent: 200 seeded matches against the opponent as filmed (unfound facts from the field), 3 tries a week. It
   shows win share, beats pinned and finishes, your plan against Coach's. The Sunday roll stays as the free real-practice result.
6. WORTH per line on the screen (points a match against improvising there, a range until MATLINE1). The hand's cut sorts by it.
7. ANA HOLDS IT: Composure (and Coachability) set how often a timing line is followed under a pin ("FRAME FIRST holds 7 in 10; panics into
   at once 3 in 10"), shown on the line. A season of keeping lines raises it (the RPG outcome rule).
8. The scoreboard gets a clock column: until the last minute / the last minute, same Push / Steady / Save. The row text shows the Tank it
   costs ("Tank 58 by then").
9. FILM and ON THE MATS show their cost on the button (the drilled move's weeks to Owned that they push back).
10. Fix the stale STALL_N line (5 beats in T0, IDLE_P 0.82). Show the read as a range. Change "never tries an escape" to "rarely (17% second
    best at white)".
11. Later, in its own version: the live bout runs on BjjBeat, with the player's calls standing in for picks at chosen beats, so one engine plays
    the plan.

## Complete?
No. The design is buildable and well wired (menus, tasks, probes, golden path). But items 1-3 change what M2-M4 and M3's red test should
contain. Build M3 as written and it locks the wrong numbers in. Without opponent lines, SET IT UP is very likely the best pick against
every opponent. Fix 1-3 in the map before M2/M3 are briefed. 4-9 are additions inside the same tasks.

## My 10/10 drawing
docs/mockups/s433/critics/mp_1_1_10.html / mp_1_1_10.png. A-game with chances to the tap (kimura 48 then 19 = 9 to the tap). Lines with
ROSA THERE (her found habit at that spot), ANA HOLDS IT (Composure), PRICE, chance counting her frames, and WORTH. A score-and-clock
scoreboard. ROSA'S PLAN as found by tape, with what FILM costs. TEST IT against Rosa as filmed (2 of 3 left), against Coach's draft. The last
open's receipts.
