# The Playbook (PLAYBOOK_MAP_S432) - a blind review by a management-sim player (pb2_player)

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, PLAYBOOK_MAP_S432.md (whole), playbook_v2.png, the real Game plan and Combos screens
(critic_pack/screens 23h, 23i), and the code: PlanFight.gd (whole), FireLevel.gd, ReadBack.gd, PlanRead.gd, LiveRound.gd (the plan
lines 290-410), OwnCombos.gd (head), Exchanges.gd (grade lines), Attrs.gd (the attributes), StrikeMap.gd (places), and the hook
lines of CLUBWEEK_MAP_V41 and TRAINING_MAP. No other critic's file was read.

## Depth score: 7 / 10

One line: the plan finally has trade-offs a player can feel (how well this boxer does a move against how right it is; points
against safety; being read and answering it), and every new rule is linked to the week and the ring with a receipt. It is held
back by numbers in a unit nobody can read, a page that hands over the best answer, and the work of four plans in fight weeks.

## How the plan reaches the fight today (checked in the code)
- Each 30-second exchange is fought on one place. LiveRound.gd line 297 picks the plan's line there (PlanFight.choose: a line
  written for the opponent's current game beats the place's anytime line). With no line, the boxer improvises.
- The line's worth is how it answers the opponent's game (Beats it +9, Works +3, Walks into it -7) minus what the boxer does on
  that place with no plan (PlanFight.edge). So no plan = 0 edge, as the game was balanced. That is a sound base.
- On top: reads (+3.5 a stack, 2 at most), pressure that lasts the bout, the 70% decay after a line is used twice in a round,
  and the ReadBack and FireLevel hooks (line 299 and 312), both off today because the bout keys are absent.
- The player sees it: the round line "Plan (Mid range): Step back - it worked", the per-line record across bouts, the Why.
- So the wiring is real. What is thin today is the decision: Attributes never touch a line (the grade is only on corner
  calls, Exchanges.grade), a line costs nothing, drilling past Usable buys almost nothing, and the opponent never reacts.
  The map answers each of these.

## What is good
- THE GRADE (4.1) is the best idea in the map. It reuses the corner calls' Good/OK/Poor lines (62/50), so the player learns one
  rule for two screens. The swap it creates is real: a Works line done well beats a Beats it line done badly. That turns the
  mornings into plan decisions ("Footwork 48 makes it OK").
- TWO DIALS, TWO PARTS OF THE WEEK (4.2): pads feed combination lines, mornings feed step lines. That ties the Playbook to the
  week with a reason anyone who played a sports manager understands.
- THE PRICE (4.3) gives the plan an internal trade (safe lines win exchanges but score half). Fixing the five answers that are
  never wrong is right: a move that is never wrong is not a choice.
- IF READ (4.4) is one slot, not two, and the map says why. The adapter is a found tell, not every opponent. Good restraint.
- THE RECEIPT (4.11) with Keep / Change / On the pads / On the mornings closes the loop from fight to week in one click.
- "YOUR PLAN AGAINST COACH'S" is the single most useful number on the page: it tells the player what their reading is worth.
- THE CUT RULE and the probes table: every new rule must move 1.5 wins in 100 over a season or it goes. That keeps the page honest.
- The menu table (section 6) covers every place the plan appears, and the golden path walks it end to end.

## What is missing (options and information)
1. A READABLE UNIT. "A use +4.0" is the fight's internal edge points. The player cannot tell whether +4.0 is a lot. The page
   mixes three units: edge points per use, exchanges in the receipt, wins in 100 at the bottom. Cause and effect fogs here.
2. THE DRAWING'S SUM IS WRONG. Section 5 adds the no-plan base where the code subtracts it (PlanFight.edge: worth minus
   card_mean). The draw is (9 x 0.85 - 0.4) x 0.5 = +3.6, not +4.0; at Sharp +5.4, not +6.0. Small, but it is the example the
   coders will copy.
3. UNCERTAINTY. Every worth on the drawing is exact, even with a tell still hidden ("?" weakness) and "where the fight goes"
   marked "about". If every line shows an exact worth and the picker ranks by worth, the best plan is found by sorting. The page
   plays itself. The map says ranking by worth "cannot play the page for the player"; it does.
4. A ROUND FORECAST. The price makes safe lines count half, but nothing shows what the written plan does to the ROUND (won
   exchanges, how many safe, likely round). Without it, the points/safety trade is a chip, not a decision the player can read.
5. THE WORK OF FOUR PLANS. Three boxers share this page, and amateur bouts come every 1 to 2 weeks with no camp (S428). Coach
   writes only one or two lines when you write none. A player with three bouts in a fortnight writes 15 lines with rounds, If
   read and price each time. There is no "Coach drafts the whole plan, I change two", no "keep last plan, re-rated for this
   opponent" and no list of who still needs a plan.
6. THE FIGHTER AS A PERSON. The pack says fighters are people (temper, coachability, discipline exist as values). Nothing in the
   plan reads them. Only morale touches the corner's shouts. A hot-headed boxer follows a careful plan as well as a calm one.
7. WHICH LINE WINS WHEN TWO APPLY. A place line and a situation line can both apply (the code: the situation line wins). The page
   never says so; the player will think the One-two fires at long range when the draw does.
8. ONE BUDGET. The header carries "brings 4 a round", "Coach holds 6", "5 written" and a footnote "left at home: not in R1, 80%
   after". Four limits for one idea.
9. A FALLBACK IF ADAPT1 FAILS. The built measurement already says no answer won back more than 3.7 of 7. If ADAPT1 fails, IF READ,
   the adapted note, the amber line and the Adapts tell all go. That is the plan's only "the opponent thinks" layer.
10. THE BJJ FIGHTER. Ana's mat book is left for later. For a version that starts with four fighters, one of them has no plan
    rules of this depth.

## Useless or doubtful options
- "Coach holds 6" in the header: only the number brought matters in the ring. Move it to hover.
- Rate against (when no bout is booked): fine as kept. When booked, hiding it is right.
- Save plan in three slots: harmless, but "Keep last plan, re-rated" does the real job. Drop the slots if it costs a week.
- The drawing's tab row (Profile, Condition, Training, Playbook, Fight plan, Character, Crowd, History) splits Fight plan from
  Playbook, against the agreed Playbook tabs (Moves, Game plan, Combos). Keep the agreed structure.
- "More places" folding is right; folded places must still say "improvises here" so the player knows they are uncovered.

## New mechanics (only where decisions are thin without them)
- OFF-PLAN (character meets the plan). Temper and Coachability, values the game already stores, set how well the plan
  holds:
  - Temper 65 or more: after a knockdown or a lost round, the safe lines fire 1 in 2 for that round (the boxer wants to trade).
  - Coachability under 45: a line written inside the fight week plays at x0.85 (it was never walked).
  - Shown as a red line on the plan ("Tess goes off-plan when hurt"), and in the receipt ("off-plan once, R2"), with a Talk button.
    The goal talk or the TALK corner job (calm) lowers it for that bout.
  - Probe: 1.5 wins in 100 over a season between a player who plans around it and one who does not, else cut.
  - This makes the safe-or-scoring choice depend on WHO fights, not only on the opponent.
- COACH'S DRAFT, YOUR CHANGES. Coach writes a whole plan to their rating (lines graded OK or better, never wrong, as CoachPlan).
  The page marks each line the player changed, and the bottom number becomes "against Coach's draft". This is less a mechanic
  than a workflow. It is what makes four plans in a fight week possible. It also makes "your plan against Coach's" a per-line
  story ("your change: +0.6 exchanges").

## To reach 10/10 (most important first, each buildable)
1. ONE UNIT ON THE PAGE: each line shows "exchanges a bout" (worth a use x expected uses from where the fight goes). The bottom
   shows wins in 100. The receipt uses exchanges too. Hover keeps the edge points. Fix the drawing's sum (subtract the no-plan
   base: the draw +3.6 a use, +5.4 at Sharp).
2. UNCERTAINTY THAT SCOUTING REMOVES: a line's worth is a range while a tell that touches its game is hidden, or while where
   the fight goes is "about". Test it and the tape narrow the range. The line picker sorts by place and read, never by worth.
   "Answer: <best>" names the read, not the worth.
3. ROUND BY ROUND FORECAST from the written plan: won exchanges per round, how many on safe lines, "Round: likely / close /
   likely Jo". This makes the price's points trade a visible decision.
4. COACH'S DRAFT FOR EVERY BOOKED BOXER, your changes marked, "Keep last plan: 3 of 5 still fit" re-rated for the new opponent,
   and a plan flag on each fighter face (plan 5/5, Coach's draft, no bout). Test it on a 12-day amateur fight week in the golden path.
5. OFF-PLAN: Temper and Coachability read by the plan as above, shown on the plan and in the receipt, probed with the cut rule.
6. ONE BUDGET: "4 lines a round" in the header. Coach's capacity in hover. "Left at home" as a chip on the row it applies to.
7. WHICH LINE FIRES: one blue line when a situation line overrides a place line on the same exchanges.
8. ADAPT1 FALLBACK planned now: if the If read answer cannot win back 5 of 7, keep the adapted note for opponents who switch
   their game after losing two exchanges in a row (a mode switch the fight already has). The corner minute's change then answers
   that. The opponent still thinks.
9. ANA'S MAT PLAN with the same three rules (grade from her attributes, a price per move, a receipt) before the version ships with
   four fighters. One page of rules for her own critic, not a copy of this one.
10. KEEP THE AGREED TABS: Playbook > Moves / Game plan / Combos; Fight prep links to Game plan. No separate Fight plan tab.

## Complete for this version?
Yes, with the list applied. The three boxers' path from the first amateur bout (fight week, no camp) to a four-round
professional debut is covered: the grade, the pads and mornings dials, the price, being read, rounds with an ahead or behind
call, the receipt. Item 4 makes it playable with three boxers in fight weeks. Item 9 covers the fourth fighter. Without item 9
the version's BJJ fighter has no plan of this depth, so it is not complete. Without item 4 the plan is deep but too much work to
use every fortnight. Every new rule is subject to its probe; if ADAPT1 and PHASE1 both fail, the score falls to about 6.

Drawing of my 10/10: docs/mockups/s432/critics/pb2_player_10.png (html beside it): the plan in exchanges a bout with a range
where a tell is hidden, the changes from Coach's draft marked, the off-plan line, the override line, the round forecast, the
plan flag on each fighter, and "Keep last plan".
