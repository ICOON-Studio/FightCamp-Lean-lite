# DESIGN_COACHSPEC1_R4_CRITIC_JOHN_JOHN - John answer (seat queue SQ186)

Brief: research/DESIGN_COACHSPEC1_R4_CRITIC_JOHN.md
Sent: 2026-11-15 20:10 | collected: 2026-11-15 20:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll score COACHSPEC1 round 4 as a fresh critic, starting by rechecking its new numbers (the wins and members columns, the corner rule, the roster break point) against the pack. The owner's computer is offline, so `CRITIC_ACCESS.md`, the mockups and the two probe scripts aren't open to me. I'll recompute by hand.

**Logic check.** I recomputed the round-4 numbers from the pack's formulas.

**These hold:**
- **The members column** uses $35 a month, or $8.08 a week: $100 is 13 members, $200 is 25, $380 is 47, $640 is 79 and $840 is 104.
- **The wins column** spreads the points over 3 fighters and 6 stats at 4.4 wins in 100 a point: 2.64 gives +0.6, 3.79 gives +0.9, 1.01 gives +0.2, 6.51 gives +1.6 and 8.75 gives +2.1. The 4.4 is the pack's 5 points = 72%, and it stays nearly linear to 10 points = 95%.
- **The corner multipliers** check out: 55 → 1.06, 58 → 1.07, 66 → 1.10, 72 → 1.13.
- **The round-3 deltas** check out: the full-time coach + S&C A adds +1.38, + S&C B adds +2.23. The held-night rows are internally consistent too, at about 0.3 points per coached morning.
- **The Wednesday pads** come out as before: check hook 21.1 / 15.7, and uppercut 28.0 at 45 min. The 30.2 for you at pads 40 is 30.5 when I integrate it, which is close enough.

**What doesn't hold:**
1. **By the map's own currency, the held pad night is still dominant.** Costing 2 of your 4 loses 0.59 stat points. Spread over 3 fighters and 6 stats, that's about 0.14 wins in 100. It buys a Sharp move 3 weeks sooner, worth +2.8 wins in 100 on every bout in that window. Whenever a bout falls in weeks 7–9 it wins by about 20 to 1; with no bout, it costs almost nothing and the mastery stays. Cost 2 made it a trade in stat points, not in wins.
2. **"Pads saturate by week 12" comes from the probe, not the game.** The probe drills one move per fighter. A real fighter has 6 punches, the book's combinations, their own combinations and 10 steps, so there's always a next move to drill, and Signature at 85 sits past Sharp (+2.7 wins). That means the moves route keeps paying after week 10, and "the stats routes last a career, the moves route stops at week 10" is wrong. The headroom clamp also means a better coach mostly gets a fighter to potential sooner, not higher.
3. **The members column can't be paid at the starting gym.** The Unit holds 70 members. "+79" for the full-time coach and "+104" for the full-time coach + S&C B are more than the whole building. The player can't buy members either: members drift at up to 6 a week toward a target set by reputation, dues, premises and coaches.
4. **The members column ignores what a hire brings in.** In the pack, the coach count raises the member target, and a boxing coach brings +$350 a week of evening classes. So the second boxing coach's real cost is lower than $380.
5. **There are two "second coaches".** The code already has the **Second club coach** staff job ($280 a week, +1 roster place, +40 members, fitness classes). R7 adds a second *boxing* coach at $380 or more. The map never says whether these are the same hire, or whether both can be hired.
6. **R13 takes away free money and doesn't define the split.** Today the +$350 a week of classes comes with any coach at no pad cost. Is it $175 a class night, and what is the coach's default week: 0, 1 or 2 nights? Does a second coach's 150 min lose 30 or 60? It isn't written.
7. **The Ex-pro's 55 sparring is still dead once anyone is hired.** The corner is the head boxing coach whenever one is hired, and every coach's sparring (58 or more) beats 55. You never run sparring nights. So it only counts in the no-coach first hour.
8. **R12 (tiredness ×0.85 on the S&C coach's mornings, −3 at the first bell) is the S&C coach's best case, and it's unpriced.** It isn't in the wins column or the probe, so the table shows the S&C hires at +0.6 / +0.9 wins and leaves out the very reason the round says the role exists.
9. **R3 has no owner.** "The deal only moves a morning off the group where the coached morning adds more" reads as automatic, but section 4.2 says the player decides where your 4 go. Who wins when they disagree?
10. **Names and pronouns are still in the body.** It has "Lucy's Normal Stamina morning" (3.1), "Mon Lucy 45 / Josh 30; Wed Kira 75 (you take Lucy)" (3.2), "his GROUP session" (3.0), and "his days" and "out-rates him" (section 5). Section 12 says these were fixed.
11. **Small:**
    - Section 4.4 points to 3.5 for the leaving rule; it's in 3.7.
    - The "women's-coach candidate 72" sparring has no code source.
    - The ×0.85 tiredness doesn't say how it interacts with the training-load spike rule (a 1.5+ ratio means 2–4× injury risk).
    - 3.4 says the mat coach "signs" belts, but the pack's player presses Promote. Say the player promotes within the coach's ceiling.

I score COACHSPEC1 round 4 at depth 7, general design 6 and play 6, so it still misses the owner's bar on general design. Depth now clears 7: there are two real routes for a hire, more stats or faster moves; class nights trade money against pad minutes; and the belt of the mat coach caps the athlete's career. General design falls short for three reasons:
- some things are undefined (which second coach, how R13 splits, who owns the deal);
- two new columns are wrong (members beyond what the building holds, pads that "saturate");
- names and "he" are still in the body.

The held pad night is still the dominant pick once you price it in wins.

I judged it from the pack and the map. `CRITIC_ACCESS.md`, the mockups and both probe scripts are on the owner's computer, which is offline, so I recomputed the numbers by hand.

## Scores

**Depth 7.**
- **What earns it:**
  - Two ladders, stats (S&C, full-time coach) and moves (a second boxing coach), each better for a different club: a bout soon or nationals later.
  - Money tied in through wages and class nights.
  - S&C days placed against each fighter's phase, with R2 dropping a group to ×1.00 when a mate is tapering.
  - The BJJ coach's belt as a ceiling on promotion.
  - R12 load and taper, which gives the S&C coach a job beyond stat points.
- **What stops it at 8:**
  - The held night wins about 20 to 1 in wins whenever a bout is near.
  - The stats routes are worth 0.6–2.1 wins in 100 per fighter over 12 weeks, less than one Sharp line (+2.8). So a player reading the table will always buy pad minutes.
  - R12, the thing that could balance that, is unpriced.

**General design 6.**
- **What's good:**
  - Every round-2 fault has a rule.
  - The better-of-two rule (R1) and the one-runner rule (R3) are clean.
  - The corner floor (R10) can only add.
  - Mobility was cut rather than dressed up.
  - Promotion follows the IBJJF.
  - It speaks in Stamina and Strength.
  - It sequences after CoachedMornings and the training_k split.
- **What costs points:**
  - two second coaches (the existing staff job and R7);
  - R13 undefined, and it nerfs income that's free today without saying so;
  - a members column that ignores the 70-member Unit and what a hire brings in;
  - "pads saturate" taken from a one-move probe;
  - the Ex-pro's 55 still dead after the first hire;
  - R3's deal with no owner;
  - names and fixed "he" still in 3.0, 3.1, 3.2 and section 5.

**Play 6.**
- **What works:**
  - The held night now pays off on screen ("You held the pads on Wednesday: the uppercut turned Usable", then "landed 3 times" in the fight log), which is the best moment in the map.
  - Class nights give a weekly money-against-moves call.
  - The leaving warning comes a week early.
- **What's weak:** the stats routes still show as +0.198 on a morning and under 1 win in 100. The player won't feel the S&C hire unless R12's fresher bell and the extra Hard mornings are shown.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Sessional boxing coach | Pads +30%, 2 coached mornings, the programme, the corner at 58 | Keep |
| Full-time boxing coach | Programme Stamina 90 / Strength 84, pads +23%, 3 mornings, corner ×1.10 | Keep; show that dues can't pay for it at the Unit |
| Second boxing coach (R7) | 150 pad minutes a night, first Sharp 5 weeks sooner | Keep; **merge or separate it from the Second club coach staff job** |
| S&C A / B and their days | Group mornings at ×1.15, tiredness ×0.85, taper −3, injury ×0.85 | Keep; **price R12 in wins** or the table makes it look useless |
| Your 4: coached mornings | ×1.25 at your rating | Weak next to the held night |
| Your 4: hold one pad night (costs 2, once a week) | 75 min at your pads rating | **Still dominant** in wins whenever a bout is near |
| Class nights 0 / 1 / 2 | $ against 30 pad minutes a night | Keep; **define the money per night and the default** |
| Brown or black mat coach | Drill rate +3.2 / +4.0, promotion ceiling purple / black | Keep; the best new decision |
| Guest professor | Black belt signed for a fee | **Missing:** no price, no timing |
| The corner | The head boxing coach's sparring scales good calls | Keep |
| The head coach's background area | Old hand bag, Amateur coach pads, Strength coach strength: used on your mornings or held night | Keep, except the **Ex-pro's sparring 55: useless after the first hire** |

**Missing:**
- a rule tying the second boxing coach to the Second club coach job;
- R13's money and default;
- R12 in the probe;
- the guest professor's price;
- what happens when the player and the coach's deal disagree.

## To reach 10/10
1. **Make the held night a real trade in wins, not in stat points.** Keep cost 2, and add that the fighter whose night you hold loses that night's **sparring partner role**, or that you can't hold a night in a FIGHT WEEK, or make it cost 3. Re-probe until its value in wins is within ±30% of two coached mornings when averaged over a season with the pack's bout spacing (an offer every couple of weeks).
2. **Probe with a real move list.** Each fighter drills the coach's pad cards over 12 and 24 weeks (6 punches, the book's combinations, the steps in the study slot, all toward Signature 85). Report Sharp lines per fighter and Signature lines, then convert at +2.8 and +2.7 wins a line. Drop "the moves route stops at week 10" unless the new probe shows it.
3. **Price R12 and put it in the table.** Simulate tiredness with S&C mornings at ×0.85: how many more Hard mornings fit before 80 (overreached), and what −3 tiredness at the first bell does in the bout engine (run 400 bouts a cell, the S427 method). Add a "Hard mornings a week before overreached" column and a "wins from the fresher bell" column. If R12 is still under 1 win in 100, raise the taper to −6 or the cut to ×0.75.
4. **Settle the two second coaches.** Either R7's second boxing coach *is* the Second club coach job, given a pad rating (one hire: +1 roster place, +40 members, +75 min a night, $280–$380), or they're separate and the screen says why. My pick is to merge them, because the staff job already adds the roster place that creates the fourth boxer the break point needs.
5. **Fix the members column.** Show each route's net cost after its own income (classes +$350, the member-target lift from coaches), and the members needed against the premises cap. The full-time coach at the Unit then reads "needs the Bigger unit", which makes premises and staff one decision.
6. **Define R13.** $175 a class night, the coach's default week is 2 nights (today's +$350), and each class night is −30 of that night's 75 min (−30 of 150 with two coaches). The week review shows "classes: +$350, pads: −60 min".
7. **Give the Ex-pro's edge a use after the first hire:** the Ex-pro adds +0.004 a point on the corner *beside* the hired coach (you work the corner as the second; England Boxing allows a chief second and helpers, CHECK), or move the Ex-pro's 55 to pads.
8. **Give R3 an owner.** The coach deals first, and the player can drag your coin onto any morning; the board shows the runner it ends up with.
9. **Clean the body.** Use role words in 3.0–3.2 and section 5 ("the women's lightweight", "the featherweight", "the S&C coach", "their days"). Names stay only on candidate cards and probe labels.
10. **Define the guest professor:** a one-off fee per black-belt promotion, for example $450 (P), with a CHECK on real UK seminar or grading fees. The athlete page then shows "black belt needs: a 2nd-degree black belt, your coach or a guest ($450)".
11. **Small fixes:**
    - point section 4.4 to 3.7;
    - source the 72-sparring candidate from `CoachMarket`, or drop it;
    - state that the S&C coach's ×0.85 tiredness also lowers acute load in the spike ratio;
    - word 3.4 as "you promote within the mat coach's ceiling".
12. **Re-run both probes, then send to two fresh critics** for the depth-7 gate.

## The 10/10 page (1920×1080, Look B: Club > People > Staff, "Who coaches whom")

**Shell (0–64):** dark top bar. CONTINUE is the only pulsing button.

**Header (64–160):** gym name once and "STAFF: 3 boxers, 70 members max at the Unit".

**Left half (40–940): the role cards,** pinned on cream paper, four in a row.
- **You:** comic portrait, background badge, 5 area meters with words, 4 sun pips.
- **The boxing coach:** pads minutes "75 a night", class nights 0/1/2 as a pill set showing "+$350 / −60 pad min".
- **The S&C coach:** teal day chips, "Hard mornings before overreached 3 → 4", "first bell −3".
- **The mat coach:** belt, drill rate, and "can promote up to: purple".

Faces on the cards, no names in rows. Hover on any number shows its source rule.

**Right half (980–1880): the hire ladder** as a two-axis whiteboard chart. Across is the extra wins in 100 per fighter from stats and freshness; up is the extra wins from moves (Sharp lines × 2.8). Each route is a magnet with $/week net of its own income, and a red tape line marks "needs the Bigger unit" where dues at 70 members run out. The selected magnet opens a strip below: 12-week totals per fighter by face, first Sharp week, and Signature lines.

**Bottom (900–1040):** THIS WEEK's decision box, "Hold the pads on Wednesday?", with two cards: "+1 Sharp line 3 weeks sooner, worth +2.8 a bout before Sat 28" and "two coached mornings, +0.3 Stamina". It's greyed in a FIGHT WEEK, with the reason on hover.

**Stress state (the default drawing):**
- a fourth boxer just signed, with the hire card reading "one coach, 4 boxers: the first Sharp slips to week 13";
- the full-time coach's magnet above the red line;
- the mat coach at brown, with the athlete one stripe from purple.

## Sources
- [IBJJF graduation system](https://ibjjf.com/graduation-system) (OFFICIAL), read 2026-11-15 in the previous round. Art. 6.1–6.3 match the map's R8.
- **CHECK, from memory:** England Boxing's rules on seconds; one club coach working every corner at a show; club mates never matched; the UKSCA as the UK S&C accrediting body.
- Every game number above is DERIVED from the pack's formulas and the map's probe tables.
