# RPG layer v3: progression critic (fresh and blind)

Seat: a progression designer for long-running RPG and management hybrids (Darkest Dungeon, Football Manager's staff and player development).
The test: is every growth pick a real trade, and does it show a payoff the player can see?
Read: CRITIC_PACK, CRITIC_ACCESS, RPG_LAYER_MAP_S432 (whole), CLUBWEEK_MAP_V41_S432 (whole), both drawings, and the code behind the hook table.
I did not open any other critic's file.

## Score: depth 7 / 10
One line: most picks are real trades paid in the club week's own coin, and the ledger shows what each one earned. The layer falls short in three places: traits have no upside, a fighter stops growing once the perks run out, and many sizes are so close that a pick is a coin toss.

## What is good (keep it)
- **Picks are paid in shared coin.** Long evenings against Early starts moves pad places against coached mornings, the same counters the board already deals. That is a real trade, not "+5% training".
- **The perk pick is priced on the next three named opponents**, not on a style label. Football Manager never does this, and it is the best idea in the map.
- **The ledger replays the bout with one hook switched off**, using the same dice (BoutRead's swing replay already exists). With Second thoughts beside it, a weak pick can be seen and taken back. That closes the loop most RPG layers leave open.
- **The hook table is honest.** I checked these against the code: `Exchanges.FULL_SHOUTS = 2`, `uptake` halves later shouts; `CornerJobs.RECOVER_POINTS = 3`, `SETUP_MISS = -9`; `talk` reads temper 65, confidence 50/45 and discipline 60; `Knockdowns` REF_STOP x (1.4 - heart/100) and KO_ODDS 0.7 match; the 0.6 count fall-off is there; `stop_mult` is set only for side "b" and `puncher_chance` does not read it (the map says so); `TheRead.looks_needed`, `PerkFight.jab_edge / combo_rate / round_line`, `PushBack.LOW_DISCIPLINE = 50`, the `WeekPlan` hard gain of 1.3, and `style_dials` read by Attrs. Personality heart feeds the fight's heart through `Attrs`. Every effect lands on something that runs.
- The REJECTED list is disciplined: it keeps the real three-count rule, and it drops levels 7 to 10.

## Where it falls short (the progression designer's reading)
1. **Traits only matter going down.** Confidence does something only under 50 and 45. Temper does something only at 65 and over. Heart has no line at all. Coachability has one upside line at 70. The drawing shows "70 Confident" in green, but in the game 70 does nothing that 51 does not. Growth with no payoff is the classic dead stat: the player raises it and nothing changes.
2. **Known and the traits contradict each other.** `Knowledge.gd` puts heart in the FIRE group (`FIRE_ATTRS = durability, composure, heart`). The Character tab shows Fire as a range (Composure 50 to 70), yet it shows Heart as a plain 84 with "x0.56", at Known 2. The map says the knockout odds are "exact at Known 5". As drawn, one system says the number is hidden and the other prints it.
3. **A fighter's growth ends early.** The coach gets five level picks, then a season pick every year. A fighter gets at most eight perk picks, gated by stats near 65 to 70, and has no way to raise potential after signing. Once a boxer has three or four perks and sits near potential (seasons 2 to 5), there is nothing left to choose for them. The coach's arc has a long tail; the fighter's has none.
4. **Many sizes are a coin toss.** The level 4 card shows +1.8 against +1.6 in 100. The perk card shows +1.6 against +1.2 for the season. With a cut line at 1.5, most picks will sit between 1.5 and 2.5, and the two sides will be within noise of each other. A trade feels real when each side wins big in its own setting and does little in the other. Two near-equal payoffs read as "it doesn't matter". COACHPICK1 only asks each side to win somewhere by 1.5. It never asks the two sides to diverge.
5. **The ranges rule is broken.** Club week v4.1 says sizes are "ALWAYS AS A RANGE, never as one exact number". Every RPG number is exact: the perk card's +2.4, +1.1 and +0.3, the level card's +1.8, the ledger's +2.1 and +1.2 in 100. A one-season ledger built from about 10 bouts is noisy, and greying a pick out at "under 0.5" on a single point estimate will grey out good picks.
6. **Direction is free to change.** The dials drift 2 points a week and switching costs nothing. The Character tab shows "+0.9 against Saturday's out-boxer", which invites switching toward each opponent. Since the drift only moves toward the current direction, a player who flips back and forth ends up nowhere, but the screen never warns about that.
7. **The room and the captain are the same effect.** Both give "nobody skips in that session". The map says they "stack", but no-skip cannot stack. When both are present, one of them is dead.
8. **Experience rewards the wrong things.** "+1 a whole stat point gained in your own sessions" pays most for coaching the fighter with the most headroom, the youngest and lowest. "+2 more on a win" when you corner pays you to corner the favourite. Hiding experience at the deal (good) does not stop a player from learning the pattern.
9. **Week 8 brings too much at once.** Direction, moments, perk picks and the ledger all arrive in week 8. That is four new systems in one Monday, on top of the club week's own reveals.
10. **The wiring is all ahead.** Every RPG module is new (no CoachLevel, Loyalty, Moments, CoachStyle or Marks in `scripts/`). `Knowledge.gd` is referenced by no other script. The club week the layer sits on (ClubWeek, ClubDeal, Loyalty) is not built either. The map's menu table is complete, but none of it is in the .exe yet, and Known needs the range display wired into the attribute board, the Profile, the trial cards and the bout sheet before anything can read it.

## Missing options
- An upside line on every trait: confidence 75, temper under 35, heart 70, discipline 75.
- A fighter's own season pick after the third perk: deepen a perk version you took, open the closed version at a price, or raise a potential ceiling.
- A price on changing direction (the drift restarts, loyalty -2) with the date it locks until shown.
- Dropping a mark by choice. And when a fifth mark comes, saying plainly whether the dropped mark's effect ends.
- Experience scaled by how hard the result was (an underdog win, a point above Coach's forecast), not by raw volume.

## Useless options (as drawn)
- **The level 4 pair as sized** (+1.8 against +1.6): a coin flip until the probes make the sides diverge.
- **Confidence and temper numbers between their lines** (the "70 Confident" word): shown, but they do nothing.
- **The room's "nobody skips" when a captain exists**: it duplicates the captain's effect.
- **Eye for the scale (Old hand's level 5 card)**: it acts only over the 1.0 kg walking-weight gap, plus the professional's cut. That will rarely fire, and it is likely under the cut line. It needs a size from COACHPICK1, or a replacement.
- **Switch it up**: the drawing's own ledger greys it at +0.2 ("a pick to rethink").

## To reach 10/10 (most important first, buildable)
1. **Give every trait an upside line**, written into the TRAITLINE1 table with a code hook. Confidence 75: a lost round costs no mood in the corner minute, and "the truth" lands +1.2 whatever the discipline. Temper under 35, COOL HEAD: "Calm down" is free, with no -0.4 cost. Heart 70: one more count is beaten (the KO_ODDS roll at x0.8). Discipline 75: a Hard week never brings a PushBack. Show both lines on each trait bar, the upside in green.
2. **Make Known and the traits agree.** Heart sits in Knowledge's FIRE group, so it shows as a range until Fire is known. Its "x0.56" goes to hover, and only once Fire is known. The signing card's two traits on show are the only ones that bypass the range, and the card says so. Redraw the Character tab.
3. **Give the fighter a season pick** (one a season once three perks are open, priced the same way as the perk card). Choose one of: DEEPEN a picked version (The drain 15% to 25%; The snap x1.4 to x1.6); ALSO OPEN the closed side (price: 4 weeks with no new perk and loyalty -3, so it is never free); RAISE A CEILING (+3 potential on one attribute within 3 points of its ceiling). COACHPICK1's rules apply. This gives seasons 2 to 5 a fighter arc.
4. **Show every size as a range.** That covers the perk card, the level card, the direction line and the ledger (for example "+1 to +3 in 100 over 14 bouts"). Grey a pick out only when the TOP of its range is under 0.5, not its middle.
5. **Make the two sides of a pick diverge.** Add a rule to COACHPICK1 and PERKPICK1: each side is worth 2 or more in 100 in its best line-up or style, and 0.5 or less in the other side's best. A pair whose ranges overlap by more than half everywhere is redesigned. The pick card then prints both columns: "your squad" and "squads built the other way".
6. **Put a price on changing direction.** The drift restarts from week 0, it costs loyalty -2, and the card shows "week 9 of 12, style word in 3 weeks" so the commitment can be seen. The "against Saturday" line moves to hover.
7. **Give each effect one owner.** The captain alone carries "nobody skips"; The room keeps only discipline +1 every 4 weeks (+1 every 3 when deepened) and gains a new half: a shared morning counts 0.9 each, not 0.8. Re-probe it with COACHPICK1.
8. **Earn experience from difficulty, not volume.** A cornered win pays +1, plus 2 x (1 - the win chance at the bell), so an underdog win pays about +2.5 and a sure one about +1.3. A stat point pays only when it beats Coach's forecast for that session. COACHXP1 must also show that the fastest-levelling bot is not the one that coaches only the youngest.
9. **Spread the reveal.** Direction in week 8. The perk pick on the day the first perk opens. Moments in week 9. The ledger in week 12, once there is a season to sum. Marks only on the day the first one is earned.
10. **Wire Known first.** Before any RPG screen, one task wires `Knowledge.range_of` into AttrBoard, the Profile, the trial card and the bout sheet. The golden-path test checks that a Body number turns plain after three weeks of your Cardio mornings. Nothing that reads Known (pips, TRUST ME, the habit week) is built before that.

## Complete?
Yes, once the list is applied: for this version, the RPG layer is complete. With traits that pay going up, a fighter season pick, ranges everywhere and picks that diverge, every growth axis has a trade, a payoff on screen and a long tail. The coach's picks, the fighter's perks and season picks, loyalty, style, direction, Known, moments, marks and the squad cover what a club head coach would expect, without widening into a promotion or a living world. What is left out (poaching, scars, ageing) is rightly left for later. It is not complete as written: items 1 to 3 are holes in the progression, not polish.

Drawing: `docs/mockups/s432/critics/rpg3_progression_10.png` (HTML beside it): the Character tab in season 2 with two-way trait lines, heart as a range until Fire is known, Tess's season pick (deepen, also open, raise a ceiling) with ranges, direction as a commitment, the ledger as ranges, and the level 4 pick sized per line-up.
