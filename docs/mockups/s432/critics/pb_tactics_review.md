# The Playbook, judged by a tactics-systems critic (S432, fresh and blind)

Critic seat: a designer of tactics systems in sports management sims (Football Manager tactics, Madden playbooks). I read
CRITIC_PACK.md and CRITIC_ACCESS.md, the rules (PlanLines, PlanFight, PlanBoard, PlanRead, PlanPressure, PlanRecord, PlanFile,
PlanTemplates, PlanCards, TheRead, ReadBack, FireLevel, Combos, ComboOdds, OwnCombos), the screens (GamePlan, GamePlanRows,
Playbook, ComboBuilder), where the fight reads the plan (LiveRound lines 80-410, BoutNight, FightWhy), the test
`tests/plan_bots_test.gd`, and the real screens 23h (Game plan), 23i (Combos), 19c (corner minute) and 21 (result).
No other critic's file was read.

## Score: depth 5 / 10

One line: the playbook is wired end to end and can be read, but most of it is solved by a lookup: a handful of answers are
never wrong against any opponent, a line costs nothing, the opponent never adapts, and training only matters at one step
(Usable at 30), so the player picks the same plan most of the time.

## What the player decides today, and what each decision changes

| Decision (where) | What it changes in the fight (code) | Can the player see it? |
|---|---|---|
| One answer per place (8 places) and per situation (8 "When ..." rows), up to the coach's limit of 4 to 9 lines (Game plan) | The move she throws on that card in each 30-second exchange; worth +9 (Beats it), +3 (Works) or -7 (Walks into it), minus what she would do with no plan (PlanFight.edge) | Yes: a chip per line, the number on hover |
| Rate against one of 4 kinds of opponent (Game plan) | Nothing; it is a "what if" view | Yes |
| Pace per round: Push / Steady / Save (Game plan, ROUNDS) | The pace each round opens on; a slow starter pays a round-1 push (PlanFile.cold_edge) | Partly: the tape hint says when to push |
| Go-to combination (Game plan) | One own combination takes a bigger share of the combination exchanges while the legs throw it whole | Yes: "R1 whole, R2 whole, R3 too tired" |
| Load a real fight plan (14 boxing plans) | Fills the lines | Yes |
| Answer a found tell ("Answer: <best>", the tape file block) | Writes the line for that situation | Yes |
| Test it (one camp spar night each, 20 quick bouts) | Nothing in the fight; shows a win range and where the plan breaks | Yes, a good feature |
| Build and save an own combination (Combos) | Own pad mastery; can become the go-to combination | Yes: Flows / Gas / Speed / Damage and its landing chance per opponent kind |
| Corner minute: change one line, arm a set-up (a combination on a gap), NOW! | One arrow swapped for the rest of the bout; NOW! adds a big edge if the gap is right | Partly: "3 of 6 arrows worked. Change one: [Keep the plan]" is a bare dropdown |

How strong it is: measured in the code's comments (FightWhy, S397), a plan that reads the opponent well is worth about +24
wins in 100 over no plan and a wrong one about -13; right answers that win build PRESSURE that cuts the opponent's punches for
the rest of the bout, and punished wrong answers shrink the fighter's tank for the rest of the bout. The Why grades the plan
and names a NEXT step; each line keeps a record across real bouts ("In bouts: 7 of 11 won, works"). This wiring is better
than most sports sims manage.

## What is good
- The plan really reaches the fight, exchange by exchange, and the Why grades it by the answers, not by the dice: a good plan
  reads as good even in a loss.
- Lines are a budget: the coach's rating sets how many, and locked slots say what opens them. A real link to staff.
- The tape opens tells and each tell offers its answer as one click: scouting feeds the plan directly.
- Test it is spent from the camp's spar nights and shows a RANGE, narrower with film or the right partner: a good,
  honest tool that links the week to the plan.
- The line record across bouts ("works / fails / too early, under 6 throws") is the start of the cause-and-effect loop.
- Combinations: build, see the price (gas), see the landing chance against each kind of opponent, drill it on the pads, name
  it as the go-to. The "R3 too tired" line is exactly the kind of readable trade-off the rest of the plan lacks.
- PlanRead fades a right answer used past twice in a round: the seed of "opponents adjust".

## The problems, plainly
1. **Dominant answers (the big one).** In PlanFight.ANSWERS the double jab, the one-two, jab-jab-cross, pivot off and roll out
   are never "Walks into it" against any of the ten situations. The code's own test says so: `plan_bots_test` rule 4 is OPEN -
   a bot that just looks up the scouting report wins as often (0.720) as one that weighs drills, cards, legs and corner swaps
   (0.725). When reading the opponent adds nothing, the plan is a form to fill in, not a tactic.
2. **A line has no price.** A step back that wins an exchange scores the same as a body-head hook that wins it. There is no
   cost in points on the cards, in energy (except long combinations), or in risk. FM tactics are deep because every
   instruction trades something away; here nothing does.
3. **The opponent never changes their game because of your plan.** "Opponents adjust by round 2" is AGREED, NOT BUILT; the
   opposing corner waiting for your best line (ReadBack) and lines firing by drill level (FireLevel) are in the code but
   SWITCHED OFF. So the corner minute's "change one line" rarely has a reason to exist, and there is no Plan B.
4. **Training reaches the plan at one step only.** A punch is Raw under 30 (cannot be planned), then every tier plays the same
   (FireLevel off: Sharp is worth about 1 win in 100 over Usable). The fighter's attributes do not change a line's worth: a
   slow fighter's step back is as good as a fast one's. The owner asked how building the fighter and training affect the
   fight; for the plan, the honest answer today is "barely, after 30".
5. **Where the fight goes is not shown.** Eight place rows look equal, but against a presser the fight lives at mid range and
   on the ropes. With 4 to 9 lines that is the real allocation decision, and the player cannot see it.
6. **No score-state thinking.** A boxing corner plans "if we are ahead after 2, box; if behind, go". The plan has pace per
   round but no "if ahead / if behind" rows; the round pace does not read the cards.
7. **Readability holes.** The edge number lives only on hover; the corner minute's plan change is a dropdown that does not say
   which line failed or what would answer what the opponent showed; the Why says "GOOD PLAN" and "Keep the plan: it was right"
   after a loss without saying what else lost the fight in the same sentence; Escapes is still its own tab (agreed folded).

## Missing options
- A price on every answer: scores points / safe / costs gas / risky, shown as words on the line.
- Plan B per line: "if the opponent stops doing this, throw that" (needs the opponent to adapt).
- Score-state rows: "Ahead after R2" and "Behind after R2" (pace + one line + the go-to combination).
- How often the fight reaches each place against this opponent (from the tests and the last bouts).
- Bring 4 of the plan to the bout (already in CLUBWEEK v4.1 section 4: "the plan is a hand"; link, do not redesign).
- Arm the set-up before the fight (which gap the go-to combination waits for), not only in the corner minute.
- Save a plan by name ("vs pressers") and copy a line to another of the four fighters.
- "What the pads buy by fight night" on a line that is not ready: how many pad places, and what the line is then worth.

## Useless or weak options
- Escapes as its own tab (agreed to fold into Moves; still separate).
- See the flow and Open the map: two more views of the same lines; keep one "Map" behind the board.
- Rate against, when a bout is booked: the plan should be rated against the booked opponent only; keep "what if" for no bout.
- The corner's "Keep the plan" dropdown as built: a list of every legal swap with no rating.
- The empty GO-TO row before any own combination is drilled (one dead row on every new fighter).
- Fourteen real fight plans with sources in one list: keep the two made for this opponent's game on top, the rest folded.

## New mechanics (only where the decisions are thin without them)
1. **Lines compete (the price).** Each answer gets three short words from three numbers: points on the cards, gas, and risk
   (counter-punches walked onto). Retreating answers score few points; pressing answers cost gas; big shots are risky. Every
   answer is wrong against at least one of the ten situations. Gate: `plan_bots_test` rule 4 must pass (+8 in 100 for the
   bot that reads). This is the "lines compete" work the S397 handover already named.
2. **The opponent adapts, and Plan B.** Switch on the agreed R25: an opponent punished twice by the same line changes game
   (TheRead.swap already rotates games), the corner card names the line that was read, and a line's Plan B fires from then.
   Switch on ReadBack's waiting corner only for an opponent who shared a show card with you (the CLUBWEEK v4.1 rule).
3. **Drill tier and the body behind each line.** Switch on FireLevel (measured +2.8 wins in 100 Sharp over Usable, +2.7
   Signature over Sharp), and scale each line by the attribute it leans on: step back and pivot by Footwork / Speed, tie up and
   push off by Strength, 4-punch lines by Stamina. Then training the fighter shows up on the plan board as a number.
4. **Score-state rows.** "Ahead after R2" / "Behind after R2": pace, one line, the go-to combination. Read from the judges'
   running cards after round 2.

## To reach 10 of 10 (most important first, each buildable)
1. Lines compete: rewrite PlanFight.ANSWERS so no answer is right against every situation, and add a price row per move
   (points, gas, risk) that the exchange actually charges: points feed the judges' cards, gas feeds the tank, risk adds the
   opponent's counter chance. Show it as two word chips on each line ("Safe, few points"). Done when rule 4 of
   `tests/plan_bots_test.gd` passes at +8 in 100 and no move is "best" in more than three situations.
2. Switch on the opponent adapting (R25) and add Plan B to every line: punished twice, the opponent changes game; the line's
   Plan B fires; the corner card names the read line in 14 words at most. Probe first on the played bout.
3. Switch on FireLevel and scale a line by the attribute it leans on (table of move -> attribute, each step of 10 in that
   attribute worth about +1 power point). Show "Usable x0.8 / Sharp x1.0 / Signature x1.2" and "Sharp in 2 weeks" on each
   line, with "what the pads buy by Saturday: +3 to +6 in 100" and a button that puts the card on the pad nights.
4. Show how often the fight reaches each place and situation against this opponent ("6 of 18 exchanges"), from the last test
   or the last bouts; sort the rows by it, and fold places under 1 in 18 into "more places".
5. Add the two score-state rows (ahead / behind after round 2) with pace, one line and the go-to combination.
6. Rebuild the corner minute's plan change: the line that lost most, its tally this bout, and the two best replacements rated
   against the game the opponent showed in that round (Beats it / Works), one click each. No dropdown.
7. The Why gets a per-line receipt (won of thrown, exchanges over improvising, what it did to the opponent's game) with Keep /
   Change buttons that open the Playbook on that line; a loss with a good plan says in the same line what lost it
   (stats, tank, a cut).
8. Plan library per fighter: save a plan by name, load it, copy one line to another of the four fighters; the coach's line
   limit stays per fighter, and "bring 4 to the bout" comes from CLUBWEEK v4.1 (link, not a new rule).
9. Arm the set-up before the bout: pick the gap the go-to combination waits for on the Game plan page; the corner can still
   change it.
10. Tidy: fold Escapes into Moves, merge See the flow and Open the map into one Map, hide Rate against when a bout is booked,
   hide the empty go-to row, put the two made-for-this-game real plans on top and fold the rest.

## Is it complete for this version (four fighters, amateur to a first professional fight) with the list applied?
Yes. With items 1 to 6 the plan becomes a set of trade-offs that the opponent pushes back on, training shows on every line,
and the player can read why a line won or lost; items 7 to 10 make it fast across four fighters. Nothing in the list needs the
professional promotion, the living world or MMA. The BJJ fighter's mat playbook (game tree) is a separate screen and was not
scored here; it should get the same "price per move" and "the opponent adapts" checks before it ships.

## Links (not redesigned here)
- Club week v4.1 (`ops/research/CLUBWEEK_MAP_V41_S432.md`, section 4 and the menu table): bring 4 of the plan, a corner that
  has seen your winning line, pad places that walk two plan lines. Items 1 to 3 above give those rules something to bite on.
- RPG layer (`ops/research/RPG_LAYER_MAP_S432.md`): perk versions that touch plan lines (Fast hands "the flurry" / "the snap"),
  the Ex-pro "one you saw coming". These need item 1 first, or the perk multiplies a line that was already free.
- Training map (`ops/research/TRAINING_MAP_S432.md`) did not exist when this was written; item 3 is the hook it should take.
- Hype (`ops/research/HYPE_MAP_S432.md`): "fight to entertain / box smart / fight safe" is a natural plan-wide price dial
  once item 1 exists.

## My 10 of 10 drawn
`docs/mockups/s432/critics/pb_tactics_10.png` (HTML beside it): the Game plan as a board with, per line, how often the
fight goes there, the fit against the booked opponent, its price, its drill tier, and its Plan B; round by round pace; the
adapt warning; what the pads buy by fight night; the test range; the last bout line by line with Keep / Change.
