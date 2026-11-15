# DESIGN_LADDER1_V2_CRITIC_JOHN_JOHN - John answer (seat queue SQ170)

Brief: research/DESIGN_LADDER1_V2_CRITIC_JOHN.md
Sent: 2026-11-15 11:10 | collected: 2026-11-15 11:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking LADDER1 v2's formula, its tables and its rules against the critic pack first, then I'll score it. The owner's computer is still offline, so `CRITIC_ACCESS.md`, the board and the mockups aren't open.

**Logic check.** I recomputed the formula table, the seeds, the pass-or-accept sums and the probes against the pack.

These hold up:
- **The formula is right.** Expected comes out 86 / 72 / 50 / 28 / 14 in 100 at gaps of −20 / −10 / 0 / +10 / +20.
- **Every win, loss and stopped cell is right,** and so are the draws at −20, 0 and +20.
- **The 8-2 and 16-4 seeds are right.**
- **The worked challenge case is right:** +1.8 at an 80 in 100 chance, −2.2 at 55 in 100.
- **The "far below" line is right:** expected 97.5 in 100 at −40, so a win pays almost nothing.
- **The fix list is complete.** All ten of John's v1 points are answered or honestly marked not done. Lock-step words, closed-panel refusals and no rolls are all kept. No fixed he or she anywhere, and no names in hover text, lines or buttons.

Fifteen things don't hold:

1. **The draw cells at ±10 are wrong.** 16 × (0.5 − 0.715) = −3.4, so −3, not −4, and +3, not +4, at +10.
2. **The 5-2 seed is wrong.** 8 + 4 × 3 + 7 = 27, not 23.
3. **The win weights leak reputation.** A boxer as good as the ladder expects drifts down: majority and split wins pay 0.65 and 0.5 of a win, but the loser loses in full, and a stoppage loss takes 2 more. "Average gain = 16 × (real − expected)" holds only if every win is unanimous. Rivals use the same rules, so the whole ladder deflates over time while quarterly entries arrive at full seed. Probe 8 may pass for the wrong reason.
4. **Accepting a challenge almost always wins.** Accept beats the −2 pass whenever your real chance beats 56 in 100. A challenger is 1–15 below, and your trained boxer usually sits above expected, so probe 11's 30–70% band will very likely fail. The real price of a challenge (it takes the show date you wanted for your own ask) isn't in the map.
5. **The coach's star solves the main choice.** It ranks rows by shown chance minus expected, and the Win/Loss and Chance columns already let the player sort for the same answer. Pass line 1 even asks the star to be within 10% of the best bot. The only choice the star leaves open is "ask up where my plan beats their style", and that hangs on CHECK 2 (whether the shown chance leaves the plan out).
6. **"Chance: Unknown without tape" breaks the code,** which always shows a band that widens when unscouted (pack 4.5, 5.6). With "Unknown", the star has nothing to rank.
7. **The novice safety rule is missing from the refusal table.** The code refuses an unsafe mismatch: a novice (0–10 bouts) can't be matched against an open boxer (pack 4.5). An ask could then reach a bout the game won't let you accept.
8. **WRONG CLASS contradicts the weight rules.** Weight is the player's decision (start a cut, or take a later date for a boxer over the class; pack 4.4), and the code shows it as a "Weight at risk" chip, not a refusal. "Fight week, Train through" is CLUBWEEK1's load setting, not a weight fix.
9. **The ladder and World > Rankings would show the same region two ways.** The code's table lists a boxer from 4 wins and ranks by results. The ladder starts walk-ins at 0 and sorts by reputation, yet the map leaves Rankings "unchanged".
10. **Two words for one thing.** "Place" here, "rank" in the code and the pack ("every fight shows the rank earned", "Rank in the region"). There's also no "Training" tab: the fighter page tabs are Overview, Week, Fight prep, Playbook and History.
11. **CHECK 9 is already answered.** The pack says the code has a draw result ("win on points / stoppage / draw", 4.8). As I recall, amateur rules make each judge pick a winner, so the code is the outlier; that's unverified this pass.
12. **The GRIND probe proves nothing.** "Only opponents 20+ below" has no one to box until about reputation 28, because seeds start at 8. "GRIND reaches 55 in 0 seeds" passes because GRIND never boxes. Above about 28, a grinder at a 95 in 100 real chance still averages +1.2 a bout (2 × 0.95 − 14 × 0.05), so it isn't dead by arithmetic either.
13. **The clock has gaps.**
    - **The nationals run doesn't stop it,** even though no offers come during the run (pack 2.8).
    - **Refusals can count against your boxer.** A week where every ask is refused (BOOKED, NOT ENOUGH IN IT) counts as free, so the player is fined for things they can't act on.
    - **Rivals' inactivity isn't defined.** Only the 52-week exit is.
14. **"Season" is never defined,** yet the owner's ask is a season ladder. Nothing happens at season end: no final table, no moment, no reset. TWICE THIS SEASON and the 18-bout cap both lean on a date that's a CHECK.
15. **Stay amateur to 65 may be unreachable.** The drain removes rivals who hold 55+, so near 60 almost every opponent is below your boxer, and wins pay +2 to +5. The map makes no promise and runs no probe for it.

I can't verify CODE claims from S477 (`CAMP_WEEKS` 2, the 18-bout cap, `AskAnswer`, `ProGate`) this pass.

I score LADDER1 v2 at depth 6, general design 6 and play 6, so it passes the owner's bar narrowly, up from v1's 5/5/6. The core change is right: reputation paid by who you beat against what the ladder expected, with a moving top. Before code, five things need fixing: the reputation leak, the near-free challenge, the coach's star solving the choice, the missing safety rule, and the ladder against World > Rankings.

I judged it from the pack, the map and my v1 critic only. `CRITIC_ACCESS.md`, the board and the mockups are on the owner's computer, which is offline.

## Scores

**Depth 6.** The currency now ties the ladder to the whole game:
- training raises the real chance against everyone;
- tape and the Playbook find the rows where your boxer beats the ladder's expectation;
- the clock pushes activity against stoppage risk and the 8-week rest;
- Pro talk and quarterly entries keep the top moving;
- rematch, pin a target and turn pro or stay amateur are real decisions.

What holds it at 6:
- the star (and the sortable Win/Loss and Chance columns) hand over the answer to "who to ask";
- accepting a challenge is right in almost every case;
- the plan's hidden value depends on CHECK 2;
- staying amateur to 65 has no tested road.

**General design 6.**
- **The structure is clean:** one formula, one refusal table where every "no" has a word, a date and a road to a yes, a wiring table per menu, a build order gated by probes, and honest marks.
- **What holds it at 6:**
  - two arithmetic errors (the ±10 draws, the 5-2 seed);
  - win weights that drain the ladder;
  - WRONG CLASS and "Chance: Unknown" contradict the code;
  - the novice safety rule is missing;
  - "place" against "rank", and a tab name that doesn't exist;
  - two tables for one region;
  - a GRIND probe that proves nothing;
  - CHECK 9 already answered by the pack;
  - "season" is undefined.

**Play 6.**
- **What works:**
  - "+11 reputation, now 3rd" after every bout is a reward the player feels;
  - Pro talk countdowns and the quarterly entry give a reason to check the ladder;
  - pinning a target makes a goal for weeks;
  - the hover's "16 × 0.72 = +11" makes the system learnable.
- **What holds it at 6:** safe wins at the top pay +2, there's no season end, and the star plays the ladder for anyone who follows it.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Ask (a YES row) | Books on the opponent's first free show at least 2 weeks out; pays by the formula | Keep; the core |
| Coach's star | Marks the best chance-minus-expected row | **Solves the choice.** Its accuracy should follow the coach's rating, and it shouldn't use information the player doesn't have |
| Pin as target | NEXT STEP line on Overview | Keep; cheap and good |
| Ask for a rematch | A new ask on the boxer who beat yours, twice a season | Keep |
| Accept a challenge | Books it; pays by the formula | Keep |
| Pass a challenge (−2) | Saves the date and the risk | **Nearly useless** until accepting costs the date |
| Turn pro at 55 | Replaces 7 wins + top 3 / 9 wins | Keep, if probe 3 holds |
| Stay amateur (to 65) | Keeps the nationals | **Untested;** it may never come back |
| Host a show (owner question 3) | +15 on the gap line | Keep; it's a real money-for-reach trade |
| Sort any column | Ordering | Keep as plain table use |
| WRONG CLASS refusal | Blocks the ask | **Wrong.** Make it a chip and keep the weight choice |
| Draw column | A result the rules may not allow | Keep only if the code keeps draws |

**Missing options**
- **A safety word** for a novice asking an open boxer, using the code's "Not safe" chip text.
- **Ask a date instead of the soonest date.** "Earliest free show" may land in a CLUBWEEK1 collision. Offer the first free date and the one after it, both printed.
- **A season end:** a final table, the season's line in Records, and the cap and rematch count reset on that day.
- **Decline-to-a-later-date for a challenge:** "Not this show, the one after" costs 0, keeps the bout and gives up the date choice. It's a real third answer.
- **Ask from the rival file and Rankings.** The card has an Ask, but World > Rankings rows (the same people) don't.

## To reach 10/10
1. **Make the formula balanced so it can't leak.**
   - The loser loses exactly what the winner gains, with the win weight applied to both sides.
   - The stoppage extra is shared the same way: winner +2, loser −2.
   - Floor at 0 by moving the shortfall to nobody, and log it.
   - Fix the ±10 draw cells (−3 / +3) and the 5-2 seed (27).
2. **Give a challenge a real cost.** Accepting books the next free show date, so any ask pending for that date is cancelled. Add a third answer, "Not this show: the one after" (0 reputation, the challenger picks the date). Keep the −2 pass. Probe 11 then has three answers to share.
3. **Make the star the coach's opinion, not the answer.**
   - It uses the coach's read of the chance, so its error follows the coach rating (Luke Reid wider, Marcus Hale narrower).
   - It ignores habits not yet found.
   - The hover says what it doesn't know: "No tape: guess".
   - Change pass line 1 so the PLAN bot beats COACH by 15%+, meaning tape plus a plan beats the star.
4. **Use the code's chance band, never "Unknown",** and rank the star on the band's middle.
5. **One table per region.** World > Rankings sorts by reputation and shows the same rows. Drop the "enters at 4 wins" rule, or show boxers under 4 wins greyed below a line. Use one word, **rank**, everywhere: "+11 reputation, now ranked 3rd".
6. **Complete the refusal table.**
   - Add **NOT SAFE** (novice against an open boxer, from the code's rule).
   - Make **WRONG CLASS** a "Weight at risk" chip with the forecast and "Start a cut" or "Later date". It refuses only when the cut needed is more than about 1 kg a week to the weigh-in (ESTIMATE, a CHECK).
   - Add **AT THE NATIONALS** ("From <date the run ends>").
7. **Fix the clock.** Weeks in the nationals run don't count as free. A week where the player made an ask that was refused doesn't count either. Rivals lose −1 every 2 free weeks after 8 too.
8. **Define the season,** in this order:
   - 1 Jan to 31 Dec, unless the code's season says otherwise (CHECK 3);
   - season end on the first Monday of January;
   - the final table goes to Records with the top-3 lines;
   - the cap and rematch counts reset;
   - one week-review line ("Season ends: ranked 4th, reputation 38").
9. **Fix the probes.**
   - GRIND becomes "always the lowest-reputation YES row".
   - Add line 13: "Stay amateur reaches 65 within 2 seasons in 40–80% of seeds for a boxer at 55 with +5 stats".
   - Answer CHECK 9 from the pack: the code has draws. Ask the owner whether amateur draws should exist; I recall amateur judges must pick a winner, which is a CHECK for me.
10. **Correct the tab name.** The ladder tab sits beside Overview, Week, Fight prep, Playbook and History, or on Fights under the offers, where the agreed map puts Ask for a fight (pack 6). Owner question 2 should ask which.
11. **Answer CHECK 2 before the star or PLAN probes.** If the shown chance includes the plan, the plan argument in 1.1 needs another hook, such as the chance band staying wide until the plan is written.
12. **Run steps 1–4 and the probes with all of the above, then draw.**

## The 10/10 page (1920×1080, Look B; FIGHTERS, the fighter page, LADDER tab)

**Shell (0–64):** dark top bar. CONTINUE is the one pulsing button. The gold Ask is the only gold, not pulsing.

**Header (64–200):** the fighter's portrait and name once, with the weight class, record, "Reputation 31 · Rated" and the rank "Ranked 6th of 18". Tabs: Overview, Week, Fight prep, Playbook, History, **Ladder** (selected).

**Strip (200–260):** four magnets.
- **CLOCK:** "Free 5 weeks: falls from week 8".
- **PRO OFFER:** "At 55: needs 24, about 3 wins above you".
- **SEASON:** "Ends 4 Jan · bouts 7 of 18".
- **TARGET:** "Ranked 3rd · free from 28 Mar".

**Left (40–1180), the table:** 18 rows on cream paper. Columns: rank with an arrow for the last week's move; portrait; club; record; stance; style word; reputation and band; **Win / Loss** ("+11 / −5"); **Chance** (the code's band, "40–70" when unscouted); and the answer word as a stamp (YES, NOT ENOUGH IN IT, BOOKED, RESTING, NOT SAFE, CLUBMATE). Each name sits in the name cell, or in the card header only (owner question 5).
- **Your boxer's row:** slate.
- **The coach's star:** on one YES row, hand-drawn. Hover: "Coach's read: about 60, ladder expects 40. No tape: a guess."
- **Pro talk:** a red marker tag, "Pro talk: 3 weeks".
- **The line:** a dotted marker line under the last row your boxer can ask, labelled "Your reach: up to 16 above".

**Right (1220–1880), the card:** the opponent's portrait and name in the header.
- **WIN / LOSS:** the four results with values; the hover gives the sum.
- **WHAT WE KNOW:** style, stance and found habits; locked lines say "Tape study opens this".
- **Dates:** booked until, first free show and the one after.
- **Buttons:**
  - **Ask: 29 Mar** (gold);
  - **Ask: 12 Apr**;
  - **Pin as target**;
  - **Ask for a rematch**, only after a loss to this boxer.

**Bottom (960–1060):** the last challenge, if any. "Challenge from ranked 9th: Accept / Not this show / Pass (−2)", with a line naming what accepting cancels.

**Stress state (the default drawing):** your boxer ranked 6th, a pending challenge that would take the date of the starred ask, a Pro talk tag on the rival ranked 1st, and one NOT SAFE row.

## Sources
No new outside sources this pass. Every figure is DERIVED from the map's formula and the critic pack. The win-weight ratios are attributed to BoxRec in the map and weren't rechecked. The amateur draw rule is from memory and is a CHECK.
