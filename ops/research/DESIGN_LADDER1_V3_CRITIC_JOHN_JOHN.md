# DESIGN_LADDER1_V3_CRITIC_JOHN_JOHN - John answer (seat queue SQ178)

Brief: research/DESIGN_LADDER1_V3_CRITIC_JOHN.md
Sent: 2026-11-15 14:40 | collected: 2026-11-15 15:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll check LADDER1 v3's new formula, tables and challenge maths against the pack and my v2 points first, then score it. The owner's computer is still offline, so `CRITIC_ACCESS.md`, the board and the mockups aren't open to me.

**Logic check.** I recomputed the formula, all 54 cells of the payout table, the seeds, the roads, the challenge case and the star's error.

All of these hold up:
- **Expected** comes out 97.5 / 86 / 71.5 / 50 / 28.5 / 13.7 in 100 at gaps of −40 to +20.
- **Every win, loss, split, stopped and draw cell is right.** The ±10 draws are now −3 / +3, and every loss equals the winner's gain with the weight on both sides.
- **The seeds are right:** 42, 27, and 65 capped.
- **The gap line is right:** 10 / 16 / 21.
- **The roads are right:** +1.2, +1.6 and +3.6 a bout.
- **The challenge case is right:** 0.75 × 5 − 0.25 × 11 = +1.0.
- **The star's error is right:** Luke ±13, Marcus ±10.
- **All five of my v2 blockers are answered.** The new clock rule (a week counts only if some row in reach says YES) is better than my fix.

Ten things don't hold:

1. **"Not this show" beats Accept and Pass almost every time.** It costs 0 and the bout still happens later, at the same expected value (+1.0 in the worked case), and it also keeps your pending ask. Accept is only better if a delay costs something. Pass (−2) is only better when the bout averages below −2, which is rare against someone up to 15 below. As written, probe 11 fails. The cost that's there but unpriced is the later date: "their next free date after yours" can land 2 weeks after your own bout, with no fight week and inside the rest if you were stopped.
2. **A booking far below resets the clock for free.** Nothing refuses an ask downward. A boxer at 55 can book someone 40 below: a win pays 0 and a loss risks −16 at 1 in 100, so the average is about −0.16. That resets the free-week count. GRIND dies on points, as intended, but the clock is beaten. Amateur matchmaking pairs boxers by experience in both directions, so the game needs a lower line too.
3. **Probe 2 is confounded.** Marcus Hale trains better than Luke Reid (coach factor 1.018 against 0.906), so "COACH with the 74 coach reaches 55 faster" would pass even if the star's error did nothing. Hold the training coach fixed and vary only the star's error.
4. **The star's error is redrawn every week.** A player who checks the star for a few weeks averages the error away and recovers the coach's real read. Fix the error per opponent until new tape is found.
5. **Rest until is nearly useless.** Offers can already be passed for free (pack 4.5), and probe 15 is designed to show the clock changes the climb by under 10%. Its only real effect is blocking challenges.
6. **The ranked line and the sort fight each other.** A 3-0 boxer at reputation 30 sorts above ranked boxers at 20 but must sit "greyed below a line". The map doesn't say which wins. The S428 line "every fight shows the rank earned" also has nothing to show for a boxer's first three wins.
7. **TOO HEAVY at "about 1 kg a week" ignores the game's own weight model.** The code's cut is 500 kcal a day plus training burn, about 0.45 kg a week from diet alone. The common guidance for athletes is about 0.5–1% of body weight a week, roughly 0.3–0.75 kg at 57–75 kg (from memory; a CHECK). The refusal should come from the code's forecast: refuse only when the forecast at Cut can't make weight by the weigh-in.
8. **The women's 70 kg class (Q-S294-233) isn't in the pack,** which says 57/60/65/75. If that ruling is real, my TRAINGAME2 point about "a 70.0 kg limit on a women's body" was wrong and is withdrawn. The pack needs the update either way.
9. **The table has no "Lose on majority" column,** so it lists three of the four results it names.
10. **"Average = 16 × (real − expected)" holds only for unanimous results.** With mixed results it's 16 × the average weight × (real − expected), plus 2 × (stoppage wins − stoppage losses). It's still balanced, but the hover and the Handbook should say so.

I score LADDER1 v3 at depth 7, general design 7 and play 6, so it clears the owner's bar. The formula is now balanced and the arithmetic checks out cell by cell, and every "no" has a word and a way to a yes. Before code, two holes need closing: "Not this show" beats the other answers, and an ask far down resets the clock for free.

I judged it from the pack, the map and my v2 critic. `CRITIC_ACCESS.md`, the board, the mockups and the S475 sparring note are on the owner's computer, which is offline.

## Scores

**Depth 7.** The decisions are real and tied to the rest of the game:
- tape and a plan to beat a star that carries error;
- which date to ask, against the weight forecast and fight week;
- a challenge that takes your date;
- rematches, pinned targets and Pro talk countdowns, which let the player time a climb;
- turn pro or stay amateur, with two ways back;
- the season's bout cap.

What holds it at 7: "Not this show" beats the other two answers, an ask far down beats the clock, Rest until does almost nothing, and the star's weekly redraw can be averaged away.

**General design 7.**
- **What's good:** clean words (rank, ask, offer, challenge, chance, expected, coach's read); one table shared with World > Rankings; a complete refusal table with code-backed words; the menu wiring table; a build order gated by probes; honest marks; all 54 cells correct.
- **What holds it at 7:**
  - the probe 2 confound;
  - the ranked line contradicting the sort;
  - TOO HEAVY not taken from the code's own cut forecast;
  - the women's 70 kg class missing from the pack;
  - one result column missing.

**Play 6.** The anticipation is good: a season end with a final table, a target pinned with its date, a rival's Pro talk countdown, and "+11 reputation, now ranked 3rd". It stays at 6 because:
- the first three wins show no rank;
- safe wins at the top pay +2;
- nothing is drawn or played yet.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Ask: first free show | Books the bout; pays by the formula | Keep; the core |
| Ask: the one after | Same, 2 weeks later | Keep: avoids fight-week and weight clashes |
| Coach's star | Points to the coach's best read | Keep, with the error fixed per opponent until new tape |
| Pin as target | NEXT STEP line with the date | Keep |
| Ask for a rematch | Twice a season against one opponent | Keep |
| Challenge: Accept | Takes your next date, cancels a pending ask | Keep |
| Challenge: Not this show | 0, the bout comes later | **Dominant as written;** it needs a visible cost |
| Challenge: Pass (−2) | Keeps date and risk | Keep, but it only works once "Not this show" has a cost |
| Rest until (4 weeks) | Pauses the clock, blocks offers and challenges | **Near useless;** cut it, or give it a real effect |
| Show: All / Same stance / Same style | A filter | Keep, cheap |
| Turn pro at 55 | Replaces 7 wins + top 3 / 9 wins | Keep, probe 3 |
| Stay amateur (65, or regional or national win) | Keeps the nationals | Keep, probe 13 |
| Weight at risk chip: Start a cut / Later date | Weight stays the player's choice | Keep |

**Missing options**
- **A lower line ("TOO FAR BELOW"),** mirroring the gap line, so an ask can't reach someone more than (10 + reputation ÷ 5) below. Or such a bout doesn't reset the clock.
- **The rank for an unranked boxer:** "Not ranked yet: 1 more win, would sit 7th" on the result screen and the strip.
- **Where the challenger's later date lands,** printed on "Not this show" ("They pick 12 Apr: 14 days after your bout").

## To reach 10/10
1. **Give "Not this show" a cost.** Either the challenger picks the date, which can be the first show 2 weeks after your bout, with no fight week and printed on the button. Or it costs −1 and the challenge lapses if their date clashes. Probe 11 must show each answer best in 15%+ of challenges.
2. **Add the lower line.** Asks more than (10 + reputation ÷ 5) below get **NOT ENOUGH IN IT** too ("too far below: nothing to win"), or such bookings don't reset the clock. Add probe 16: a boxer at 55 can't hold the clock by booking far down.
3. **Fix the star's error per opponent until new tape is found or a bout is fought,** not weekly. Its hover says "Read from 0 tapes".
4. **Separate probe 2 from training.** Same training coach, star error ±10 against ±13 against ±25; the 74 read must reach 55 at least 5% faster than ±25.
5. **Settle the ranked line.** Boxers under 4 wins sit below the line in reputation order. Rank counts only above the line. Results show "+8 reputation · Not ranked yet: 1 more win (would sit 7th)".
6. **Take TOO HEAVY from the code's forecast.** Refuse only when Cut 500 plus training can't make the limit by the weigh-in. Otherwise show the Weight at risk chip. Put a CHECK on the real-world cut rate.
7. **Cut Rest until,** or make it real: during it, the boxer recovers like a rest week (+4 morale, tiredness reset) and no challenge can arrive. Then probe 15 measures that, not the clock.
8. **Update the pack with the women's 70 kg class (Q-S294-233),** and add "Lose on majority" to the table.
9. **Make the average-gain hover honest:** "16 × weight × (real − expected), plus 2 a stoppage".
10. **Run step 0, then steps 1–4.** Publish all 15 lines (16 with the lower line), change any number a line fails on, get the owner's answers to questions 1–6, read the S475 note, then draw the page.

## The 10/10 page (1920×1080, Look B; Fights, under the offers, per owner question 2a)

**Shell (0–64):** dark top bar. CONTINUE is the only pulsing button. Gold appears only on the selected row's first Ask.

**Header (64–190):** your boxer's portrait and name once, with the class, record, "Reputation 31 · Rated" and "Ranked 6th of 14".

**Strip (190–250), five magnets:**
- CLOCK: "Free 5 weeks: falls from week 8".
- PRO OFFER: "At 55: needs 24".
- SEASON: "Ends 4 Jan · bouts 7 of 18".
- TARGET: "Ranked 3rd · free from 28 Mar".
- NEXT STAGE: "London regional +5".

**Left (40–1180), the table on cream paper:**
- **Rows:** rank and arrow, portrait, club, record, stance, style, reputation, Win / Loss, Chance band, answer stamp.
- **Lines:** a dotted reach line above ("up to 16 above") and below ("down to 16 below"), and the grey "Not ranked yet: 4 wins" line with unranked boxers under it.
- **Marks:** the coach's star with its hover ("Read from 0 tapes: a guess"), and a red Pro talk tag.
- **Filter:** All / Same stance / Same style.

**Right (1220–1880), the card:** the opponent's name in the card header only.
- **WIN / LOSS:** four results, each with its sum on hover.
- **YOUR PLAN:** Beats it / Works / Walks into it.
- **WHAT WE KNOW:** found habits; locked lines say "Tape study opens this".
- **Dates:** booked until, first free show and the one after; any Weight at risk chip with Start a cut / Later date.
- **Buttons:** Ask: 29 Mar (gold), Ask: 12 Apr, Pin as target, Ask for a rematch.

**Bottom (960–1060), the challenge strip:** "Challenge from ranked 9th: Accept (cancels your ask for 29 Mar) · Not this show (they pick 12 Apr, 14 days after your bout) · Pass (−2)".

**Stress state (the default drawing):**
- your boxer ranked 6th;
- a challenge that would cancel the starred ask;
- Pro talk on the boxer ranked 1st;
- one NOT SAFE row and one row below the lower line;
- a Weight at risk chip;
- a 3-0 boxer greyed under the ranked line.

## Sources
No new outside sources this pass. Every number is DERIVED from the map's formulas and the critic pack.
- **CHECK, from memory:** the cut rate for athletes (about 0.5–1% of body weight a week); amateur bouts having to produce a winner.
- **Not rechecked:** the win-weight ratios attributed to BoxRec.
