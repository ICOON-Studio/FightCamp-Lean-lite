# DESIGN_LADDER1_V1_CRITIC_JOHN_JOHN - John answer (seat queue SQ161)

Brief: research/DESIGN_LADDER1_V1_CRITIC_JOHN.md
Sent: 2026-11-15 06:40 | collected: 2026-11-15 07:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking LADDER1 v1's reputation maths and its gates against the critic pack first, then I'll score it. The owner's computer is still offline, so `CRITIC_ACCESS.md`, the board and the mockups aren't open.

**Logic check.** I recomputed the formulas, the worked tables, the gates and the strategy table. These hold up:
- The loss table (1 + 8 × chance, plus 2 if stopped) is right in every cell.
- Wins at 50% and 30% are right.
- The reach rule matches its own examples: 41 reaches 4 places up, and 60 reaches 6.
- BOOKED (14 Mar, free 28 Mar) and RESTING (2 Feb, free 30 Mar) are right.
- NOVICE / OPEN at 11 bouts matches the code's 0–10.
- Two clicks to a booked bout.
- Removing the yes-chance keeps the pack's "never a random refusal".
- The wiring table covers every menu in the pack.

Fourteen things don't hold, or aren't stated:

1. **One cell is wrong.** A split win at 75% is 5.5 × 0.45 = 2.5, which rounds to **+2**, not +3. Majority wins are in the formula, but in no table.
2. **The strategy table hides the dominant road: a safe win *above* you.**
   - Chance comes from stats, but places come from reputation, so a better-trained boxer often has 75% against boxers above it on the ladder. The table assumes safe means below.
   - The expected gain per bout for an opponent above, unanimous win, scalp once (DERIVED from 1.1–1.2):
     - 30% chance: about +1.6
     - 50% chance: about +2.9
     - 75% chance: about +4.1
     - 90% chance: about +4.6
   - **The highest chance above you always pays best,** and the long shot pays least. The table's +2.6 / +4 / +1 figures don't follow from its own formula.
3. **Reputation taxes training.** A win pays by how *unlikely* it looked. The pack says training is the main lever (5 stat points better wins 72 in 100, 10 better 95 in 100), yet the better you train, the less each win is worth: about +3 at 90%. The gym's core loop (the week and the pads) pulls against the ladder's currency.
4. **The plan argument depends on an unchecked fact.** The "long shots are the skill reward" line holds only if the bout-page band leaves out the plan (Kalli's own CHECK). The plan also lifts real odds at 75%, so it helps every road, not just long shots.
5. **The top of the ladder stalls.**
   - Rivals get reputation "by the same rule" as signed prospects, which is capped at 30, so every ladder starts with nobody above 30.
   - A boxer who passes them is 1st, with nobody above for full value or scalps. Everyone is 1–5 places below (half value) or 6+ (zero). The climb to 55 slows exactly where it should end.
   - Pass line 8 (top 5 at 45–75) can't happen without a seeding rule.
6. **Rivals never leave.** No rule says what a rival at 55 does (turn pro and leave the ladder). Without it, pass line 8's "no 3+ boxers over 55 for 8 weeks" has nothing to stop it.
7. **Two gates measure the same thing.** OUT OF REACH (places) and NOT ENOUGH IN IT (a 15-reputation gap) both say "the opponent is too far above" on a ladder sorted by reputation. The player has to learn two words for one idea.
8. **55–59 reach is inconsistent.** The band table says "6+ places up" at 55, but the rule (2 + 1 per 15) gives 5 places until 60.
9. **Defending a place is a non-choice.** Accepting a challenge from 1–5 below at 75% is worth about +0.1 (half of +5 × 0.75, against −7 × 0.25). Passing is free, so the right answer is always pass, unless the inactivity clock is close. Kalli's own 10/10 list admits this.
10. **The short-notice +2 is dead.** Asks book 2+ weeks out, and club offers come 8–12 weeks ahead (2–4 only in the first hour), so no path creates a bout under 14 days.
11. **The inactivity clock isn't defined against booked bouts.**
    - With 8–12 week offer leads, a boxer waiting on a booked bout loses reputation while doing nothing wrong.
    - The 30-day suspension pauses the clock, but the 8-week later-offer rule after a stoppage (`STOP_REST_WEEKS`) doesn't.
    - **RESTING turns an offer delay into an ask ban:** that's NEW, not CODE as marked.
12. **The starting pro fans change pros, which are out of scope.** 55 ÷ 10 = 5 fans clears `TOP_ASK_FANS 3`, so a debutant could ask for a top-5 name straight away. Today's debut fan count isn't in the pack (NOT ESTABLISHED).
13. **Floors and holes:**
    - The prospect formula can go negative (4 × net wins), and reputation has no floor at 0 after an early loss.
    - Two of your own boxers on one ladder can ask each other; there's no clubmate rule.
    - The draw formula doesn't say which win weight applies.
14. **Names and sources:**
    - A name in every ladder row reads S448 loosely. World > Rankings and News already show names in rows, so there's a precedent, but the owner has to rule on it, not the map.
    - The Pro offer modal's quoted "tickets she sells" is a fixed she (S412). That's in the code, not this map.
    - The pro-ladder probes need the bots to write plans; that isn't stated.
    - **Pass lines 1 and 2 can't both pass** if COACH sits near the median: PLAN 25% faster than COACH breaks "no bot 20% faster than the median".

I didn't reverify the BoxRec weights, the England Boxing 2.7.8 and 2.7.9 rules, or the 365-day inactive rule this pass. They stay as John's earlier report.

I score LADDER1 v1 at depth 5, general design 5 and play 6, so it doesn't meet the owner's bar yet. Two changes would carry it past 6: pay reputation by the opponent's reputation instead of the shown chance, and seed and drain the top of the ladder. I judged it from the pack and the map only. `CRITIC_ACCESS.md`, the board, the mockups and the S475 sparring note are on the owner's computer, which is offline.

## Scores

**Depth 5.** The pieces are right: who to ask, when to wait, long shots, defending, and a hosted-show invite. They touch bouts, plan, weight, the fight week, money and the pro offer.

The maths behind them flattens the choices:
- **One road wins.** Asking the highest-chance boxer above you beats every other ask.
- **Defending is always "pass".**
- **Waiting is just losing time.**
- **The stall at 1st place** removes the upset road when it matters most.

That's one real decision (find a safe boxer above) wearing four labels.

**General design 5.** Strong parts:
- the no-roll refusal table, each word with its way to YES;
- one word per idea for the boxer;
- a full wiring list;
- pure rules first, each with a test;
- 10 probes, including the R37 ask test;
- a clean replacement table for the `Roster`, `Region` and `AskBout` constants.

What holds it down:
- the currency taxes training, the game's main lever;
- the 30 cap starves the ladder top, and nothing makes rivals leave;
- two gates for one idea;
- a dead +2;
- an unscoped change to pro fans;
- two pass lines that conflict;
- names in rows that need an owner ruling.

**Play 6.**
- The 0–100 bar with "14 to go" and the 55 pin is a strong reason to come back.
- The result line ("Reputation 31 to 43 (+12: won from 30%, stoppage). Ladder 7th to 4th") makes every fight matter.
- Scalps, and the week review's "rival passed you", give stakes.

But the best road is quiet, safe wins above. A strong boxer earns little per win, and the run ends with the boxer stuck at 1st, out of anyone worth beating.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Ask for this bout | Books an opponent you choose, 2+ weeks out | Keep; the core |
| Within reach / All filter | Which rows show | Keep |
| Next date | Moves the date past a clash or a weight problem | Keep |
| Long shot | Bigger gain, smaller loss | Keep, but it only pays once rewards follow the opponent |
| Accept a challenge from below (defend) | Half value against full risk | **Useless as tuned:** about +0.1, so always pass |
| Pass a challenge | Nothing, while the clock runs | Keep |
| Bring them to your show ($150) | Buys an opponent beyond the gap | Keep; a real money-for-reputation trade |
| Headliner on your show | Tickets, +3 on a win | Keep |
| Short-notice +2 | Nothing; no path creates it | **Useless:** cut it, or add short-notice offers |
| Standing +5 in the gap check | Tiny, hidden pull | **Near useless:** show it on the row or cut it |
| Withdraw before Continue | Free undo | Keep |

**Missing options**
- **Ask for a rematch** after a loss, at half value and full loss cost. It's the most natural ask in real boxing, and the map's repeat rule already prices it.
- **The opponent's file on the card:** the World rival file's found tells, with "found at their last bout". Amateurs can't scout before accepting (S410), so the card has to show what the club already knows, or every ask is blind.
- **The coach's pick:** one row starred "your coach would ask this one", with the reason. This matches how the coach writes the week, and it gives the quiet player a one-click ask.
- **A clubmate rule:** clubmates are never offered and can't be asked. That's one line in AskAnswer.
- **Turn pro / stay amateur at 55** already exists in the code, but the map doesn't say what staying amateur does to the ladder. Offer "Stay for the nationals" with its reputation upside.

## To reach 10/10
1. **Pay reputation by opponent, not by odds** (Elo-style, as in chess ratings).
   - Expected = 1 / (1 + 10^((opponent − yours) / 25)).
   - A win gives 12 × (1 − expected) × the win-type weight, and a loss costs 12 × expected.
   - Beating someone 20 below gives about +1, and someone 20 above about +10. That replaces the whole anti-grind table, the places-below rules and the scalp.
   - Training is rewarded (a stronger boxer beats higher-rated boxers), and so is the plan (it wins bouts the ratings say you'd lose).
   - Keep the shown chance on screen for information only. Run probes 1, 2 and 9 again.
2. **Seed and drain the top.**
   - Rivals at load get a spread, with the top 5 at 40–65 (ESTIMATE, drawn from record and age).
   - A rival at 55+ gets a pro offer, and turns pro and leaves within 8 weeks, 1 in 2. A new rival enters at the bottom each quarter.
   - Then pass line 8 can pass, and 1st place still has someone to chase until the offer arrives.
3. **Merge the two gates into one, NOT ENOUGH IN IT:** an opponent more than (10 + your reputation ÷ 5) above says no. That's 10 at reputation 0 and 21 at 55, with one To-get-a-yes line. Drop reach in places.
4. **Make defending real:** a challenge from below that you pass costs half its loss value, the way a real champion vacates. Accepting pays the Elo value. Then "pass" is a price, not free.
5. **Fix the clock:** a booked bout stops it, and so do the suspension and the 8-week rest. Mark RESTING as NEW, or let asks through after the 30-day suspension.
6. **Leave pros alone:** a debut pro starts at today's fan count (CHECK Claude for the number), and reputation shows only on the Pro offer's ticket line.
7. **Small fixes:**
   - Correct the split cell to +2, and add majority wins to the tables.
   - Reputation floors at 0; the prospect formula takes the larger of 0 and its result.
   - The draw uses the unanimous weight.
   - Cut the short-notice +2.
   - Add the clubmate rule.
   - Rewrite pass lines 1 and 2 as "PLAN fastest, COACH within 10% of the best non-PLAN bot, SAFE and ASKUP 15%+ slower than COACH", and have the bots write plans.
   - Fix the existing "tickets she sells".
8. **Add the rematch ask, the coach's pick and the rival file on the card.**
9. **Ask the owner one names question with the drawn page:** "Ladder rows carry the opponent's name, as World > Rankings does today. OK?"
10. **Run BASE0 and the probes, then draw the page.** Every number above is an ESTIMATE until then.

**Real evidence:** in English amateur boxing, club matchmakers pair boxers on experience and weight at club shows; there's no public league table where you climb by challenge. So the ladder is a game layer on top of real matchmaking, which the map handles well by keeping the real floors fixed. I believe amateur bouts under IBA-style rules always have a winner (no draws). That's a CHECK, not reread this pass.

## The 10/10 page (1920×1080, Look B; FIGHTS, LADDER)

**Shell (0–64):** dark top bar; CONTINUE reads "to Sat 14 Mar, club show".

**Header (64–120):** "WOMEN'S 60 KG: LONDON REGIONAL", with your boxer's portrait and name once. Fighter tabs for each of the club's boxers, by class.

**Reputation strip (120–220):** the 0–100 bar.
- A pin at 55 reads "Pro offer", and a small arrow shows this week's move.
- The band word with the number ("Rated 41").
- One marker line: "Beat a boxer rated 50+ to pass 45".
- Hover breaks the last change into its parts.

**Season strip (220–280):** 13 weeks only, with show Saturdays, booked bouts, fight weeks, your hosted show and nationals close. "Bouts this season 7 of 18".

**Ladder (40–1260), up to 20 rows:** place and its weekly arrow, the name cell, club, record with NOVICE or OPEN, reputation, style word, last bout, the chance band.
- **Win / Loss:** "+9, to 4th / −3, stay 7th".
- **The answer word:** YES, NOT ENOUGH IN IT, BOOKED, RESTING, NOVICE/OPEN, OVER WEIGHT, SEASON FULL or OUT.
- A coach's star on one YES row, with its reason on hover. Challenges from below carry a "Challenge: pass costs 3" chip.
- Your row is highlighted.
- Rivals who'll turn pro soon show a small "Pro talk" tag, so the player sees the top drain coming.

**Card (1300–1880):**
- The opponent's name header, the tale of the tape and the chance.
- **WHAT WE KNOW:** found tells from the rival file, or "no tape yet".
- The date, with a Next date chip, and the clash line only when there is one.
- **Win gives / Loss costs,** with hover parts.
- The answer word with Why and To get a yes.
- **Buttons:**
  - one pulsing gold **Ask for this bout**, shown only on YES;
  - **Bring them to your show** on NOT ENOUGH IN IT;
  - **Ask for a rematch** on a boxer who beat yours.

**Stress state (same layout):** your boxer is 1st at 52. The top three rivals are tagged "Pro talk". The only YES rows are below, at +2 each, and the strip line reads "Nobody above: win the regional stage (+5) or wait for a new entry in April".

## Sources
No new outside sources this pass. Every figure is DERIVED from the critic pack and the map's own formulas. Elo's expected-score formula is standard rating maths. The BoxRec and England Boxing rule numbers are from John's earlier report and weren't reverified here.
