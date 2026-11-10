Seat: management and tactics systems designer (solved choices, hidden-information gaps, invented numbers that decide the game, UI that gives the answer). My 10/10 drawing: docs/mockups/s428/cutman_10_systems.png (+ .html)

# Cutman design map: systems critique

## Scores

| Thing | Score | One line |
|---|---|---|
| Whole design, depth | 5 | A real loop on paper (hire, range, call, scar, hire) but it runs on one night in ten or fewer, against a scripted rival, and the scar/healing half is too weak to feel |
| 1 Cutman tier | 4 | The money does not pay back on any tier; the choice is nearly a wash at club level and a trap at the top |
| 2 Cutter / Head-clasher tells | 3 | Moves a 6% event to 9%; tape is not scarce enough to make it a trade |
| 3 Protect the eye line | 3 | A plan place for a 1-in-10 night, and "Survive" switches the same effect on for free |
| 4 Hidden depth and range | 6 | The best idea on the page, but the numbers that make it work are missing (see below) |
| 5 They hunt it | 4 | Near-solved "hunt when you can"; the rival always hunts, so there is no rival to read |
| 6 Two pairs of hands | 5 | Diminishing returns are good; on most cut nights the answer is "all 3 on the cut" |
| 7 Stop, survive, race | 6 | The strongest decision; "stop" is dominated and "survive/race" are two existing Pace toggles bundled |
| 8 Scar per eye | 3 | Decays faster than it accrues; the multiplier is too small to feel |
| 9 Healing choices | 2 | Surgery is beaten by waiting; style change is a free permanent buff |
| 10 Trust after the call | 4 | The morale table makes pulling out the worst option in every column but one |
| Look | 4 | Nothing drawn yet; a dark, tight corner minute that now carries a fourth job |
| Clarity | 5 | Clear prose, but "hands points", depth, scar and doctor words need teaching and the cut is rare, so they are forgotten between nights |
| What to do | 6 | The action set is clear and the divider rule is right; the UI then names the answer (below) |
| Anticipation | 4 | Almost no build-up: nothing says "this fight might cut" except one tell |
| Reward | 4 | No reveal of what the hidden depth really was, so the player never learns whether the read was right |

## 1. Frequency: the whole design lives on rare nights

The page's own targets are 1 cut in 16 amateur bouts (6%) and 1 in 7 pro bouts (14%).

- Amateur: a gym with 3 active boxers fights about 6 to 8 bouts each a year (camp 3-4 weeks plus offers every 8-12 weeks), so 18-24 bouts. At 6% times (1 + scar/100) that is 1.1 to 1.5 cut nights a year for the whole gym.
- Pro: 1-2 pros at 3-4 bouts each, at 14%, gives 0.6 to 1.1 cut nights a year.
- Total about 2 cut nights per gym-year, of which maybe half get close enough to the doctor's line to be a real stop/survive/race call. That is one real decision a year.

Against that: two new pure modules, two screens, two tells, a new plan situation, a three-tier staff card, a scar bar, three healing actions, a trust table. A player who sees the CUT card once a year forgets the rules between sightings. Every pre-fight decision (1, 2, 3) is insurance against a 6-14% event, so the player never gets feedback on whether it was right. This is the core weakness, bigger than any single number.

## 2. The economy, by hand

Assumptions (mine, stated because the page gives none): a doctor stop on a cut that would otherwise have been fought on turns a fight the boxer wins about half the time into a loss. A win is +8 members (about $3,360 a year in dues at $35 a month) and a loss costs 1-2 members, so a win-versus-loss swing is about $4,000 a year on a club show, about $2,000 once multiplied by the 50% win chance. Stoppage chance given a cut, with 3 hands on the cut and the 100/60/30 returns: None 65%, Club 25%, Seasoned about 12%, Name about 6% (worked from the page's 100/60/30 returns: Club's 50% close per hand gives 1 - 0.5 x 0.7 x 0.85 = 70% with 3 hands; Seasoned 86%; Name 94.5%).

**Amateur ($50 / $120 per show, cut chance 6%):**
- Club against None: 0.06 x (0.65 - 0.25) x $2,000 = **$48 returned for $50 spent.** A wash.
- Seasoned against Club: 0.06 x 0.13 x $2,000 = $16 returned for $70 extra. Loses by $54 a show.
- With scar 60 (cut chance 9.6%): Club gains $77 for $50 (now worth it); Seasoned against Club still only $25 for $70. Even at scar 100 it is $31 for $70.
- Seasoned only pays when the stake is about five times a club show (a regional or national final). The page says "right for a scarred boxer"; by this arithmetic it is not.

**Pro ($150 / $300 / $700, cut chance 14%, stake about $1,500 a stoppage avoided):**
- Club against None (coach at half strength, 55% stop): 0.14 x 0.30 x $1,500 = $63 for $150. **None beats Club.**
- Seasoned: $90 for $300. Name: $103 for $700.
- Name against Club: 0.14 x 0.19 x $5,000 (a title stake) = $133 for $550 extra. Name only breaks even above about a $20,000 stake.
- Arithmetic error on the page: "a name cutman on a 4-round tune-up spends about a quarter of the gym's 25% share." The debut purse is $1,500, the gym's share $375, and a Name cutman is $700: **187% of the share.** Even a $3,000 purse gives a $750 share, so $700 is 93%. Name is unaffordable for anything but a ranked night, and even there it does not pay.

**Scar return from a better tier:** the tier scar gap is 25 / 20 / 15 / 10. Scar falls 1 a week by itself, so the whole gap between None and Name (15 points) is gone in 15 weeks, and it changes the next cut chance by 15% of 6-14%, which is 0.9 to 2 percentage points. Nobody buys a $550 premium for that.

**Missing from the tier table:** the existing cutman job halves post-bout layoffs ($150 a pro night). The tiers do not say whether that effect survives, scales, or is replaced. It is the one real return a cutman has today, and it is silently dropped.

**Verdict:** no tier dominates, but because none clearly pays. The page's dominant-strategy check ("the money only pays back on scarred boxers or big nights") is asserted, not computed. Give the design its own probe: for each tier, find the segment (level, scar, stake) where it has the best net return, and fail the build if any tier has none.

## 3. Is the hidden range a real read?

Good: no cutman means 3 band words only; the range narrows with tier; the player reasons from hits landed, cards and range. That is a real read.

Four holes that decide whether it is one:

1. **The midpoint leak.** If the range is the true depth plus or minus the tier width, the midpoint is the exact depth and the "hidden" number is just shown. The range must be offset at random inside the window, and the offset must be carried to the next minute. The page's own example ("CUT, 35-50", width 15) matches none of the three tiers (30, 16, 8), so the page is already inconsistent.
2. **Ranges that re-roll can be intersected.** If each minute draws a fresh offset, the player intersects two ranges and gets the truth. Carried offset plus a visible "landed on the cut" count lets a smart player narrow it by reasoning (last range + hits x 4-8), which is the clever feeling the design wants. Only the carried version is a puzzle.
3. **The numbers that decide the game are not on the page:** the depth a cut opens at; what "closes" does to depth; whether a closed cut reopens; and when the doctor checks (each exchange, each round, or the minute). The hunt is "+1 per exchange"; if that means one landed punch on the cut per exchange at +4 to +8, six exchanges add 24-48 depth a round and the doctor's 70 arrives in one or two rounds, which makes decisions 6 and 7 collapse. If it means +1 point, the cut never matters. The page's own claim "0 hands on the cut is right when ahead and under 50, because the doctor won't stop it this side of the bell" only holds at roughly +5 a round, not at the stated hunt. One of those two statements is wrong.
4. **The doctor is a deterministic line at 70.** The whole decision is then "keep it under 70", a threshold puzzle with no opponent in it. Real doctors differ. A hidden, scoutable doctor temperament (cautious / standard / lenient, shown on the show notice) moves the line and gives the read a second unknown.

At Name tier the range is +/-4: an 8-wide bracket against a hard line at 70. That is nearly full information, so the read disappears exactly where it costs $700.

## 4. Dominant and dead options

- **Stop (pull out) is nearly dominated.** Morale: a loss is already -12; pulling out a truthful boxer adds -6 (total -18), while being stopped after sending out is -12 -4 = -16 (or -20 at low Heart). Pulling out saves layoff and scar only, and the page models neither layoff nor a meaningful scar. A win is +8 members and a loss costs 1, so sending out is right whenever the win chance is above about 10%. Fix: the price of sending out must be a layoff tied to the cut's depth at the bell (cuts are 20% of bout injuries in the existing InjuryRoll; the CUT page never connects to it).
- **Survive and Race are existing Pace toggles bundled** (Save + a plan line; Push + Go for the finish). Fine as a convenience, but they add no new axis.
- **The head-clash branch is about 1% of bouts.** Head-clash cuts are 1% a bout (8% against a Head-clasher); the "survive to the cards" rule only applies after round 4 in pro. That is under 1 night in 100, so the page's best argument for Survive and for tell 2 almost never happens. The amateur rule is still unknown (CHECK).
- **Protect the eye plan line (3) is redundant with Survive.** Survive switches the line on for the round, so writing it costs a plan place to get what Survive gives for free, and it only matters for the round the cut opens in. It is a dead option unless Survive stops applying it.
- **Always hunt (5):** the opponent's cut ends in a TKO win, the cost is "body punches", and the rival never varies. Hunting is right whenever the cut is deep and rounds remain, and their only defence (their cutman) is a hidden roll. Solved.
- **Style change (9):** 6 weeks of Defence work for -25% base cut chance forever. That is cheap and permanent, so everyone does it once. Dominant.
- **Surgery (9):** $2,500 and 8 weeks for -40 scar. Natural decay does 40 in 40 weeks; the extra cut chance in those 40 weeks is at most 5.6 percentage points a pro bout over 3 bouts, so about 0.17 cut nights. Beaten by waiting. Rest (-12 for 4 weeks of no offers) nets only 8 over natural decay. Healing is dominated across the board.
- **Scar never reaches "marks easily".** At 6% it takes two cuts inside about 20 weeks to reach 40; the chance is a few per cent. The scar bar will almost never be above 20.

## 5. Playing one 4-round pro bout, ask by ask

Setup: Club cutman ($150), opponent has the Cutter tell found on tape, 5 plan places, boxer with scar 0.

1. Tier: Club or None. By the arithmetic above they are equal; I pick Club for the range.
2. Tells: spent a tape session on Cutter. +3 percentage points of cut chance. I do not know what to do with it except hire the cutman I already hired.
3. Plan line "Protect the eye": skip it; the place beats a winning line, and Survive will do it anyway.
4. Round 1: nothing. Round 2, exchange 3: a punch cut opens. I only see "CUT" in the panel.
5. Minute: range 30-60. "Possible." Cutman points: 3 on the cut because nothing else needs them (no eye swelling). No decision.
6. If the cut closes (70% / 83% / 86%), the whole divider is moot: nothing to decide, and I never learn what depth it had. If it stays open, I choose survive or race from the cards I already know. Survive, because the page prints "ahead".
7. Round 3: the opponent hunts, as always. I shout Hands up. Nothing else I can do.
8. Minute 3: range 38-68, "possible". Same choice, one round left.
9. Round 4: the doctor does or does not stop it. Either +5 morale (won) or -4 (stopped).

What is missing for the player to feel clever: (a) a decision with real information gain (the finger test, the doctor's temperament, their cutman quality); (b) a rival who does something different each time; (c) a reveal afterwards that says "your read was right, the cut was 63, the doctor would have stopped at 58"; (d) a price on fighting on that is not just morale; (e) a cut that happens often enough to remember the screen.

## 6. Too much for one corner minute?

On a cut night the minute holds: the coach's call, ONE CHANGE, RECOVER (3 points), SET-UP, TALK, one plan arrow, the cutman's 3 points over two needs, the stop/survive/race divider, plus the range, the doctor words, the cards line, the cause and the stakes line. That is about ten controls and six information blocks, on a screen that is dark and tight and that the player sees once a year. Two parts are a real problem:

- The page folds the coach's "call" into the 3 coach points. In the existing minute the call, the change and the set-up are free picks and only RECOVER is a points pool. Making the call a hand point changes every corner minute, not only cut nights.
- The doctor's chance as a word ("unlikely / possible / will be stopped") computes the decision for the player. Together with the printed card line it tells them to survive when ahead and race when behind. That is the UI giving away the answer.

Fix: make the cut a step before the minute, like the real ring (the doctor looks first), and keep the three coach points as they are. Show facts (range, line, hits landed, cards range, cause) and let the player decide. The drawing does this.

## 7. Invented numbers that decide the game

These need to be locked before anything is built, because the player can feel them directly:

- The hunt rate (+1 per exchange) against +4 to +8 depth per landed punch. Ten times apart depending on reading.
- Initial depth, the effect of "closing", reopening, and doctor timing: not stated at all.
- The doctor's line at exactly 70 with no variance.
- Cut chance 6% / 14%: sets how often anything on this page happens.
- Scar multiplier (1 + scar/100) and decay (1 a week): the choice of 40-scar thresholds makes the system inert.
- Tier prices against the real purse, as in section 2.

## To reach 10/10

Most important first.

1. **Fix frequency.** Put eye damage in every bout: swelling, bruising and nosebleeds happen most nights, and the cutman works them every round. A cut becomes the rare tail of that, not the only event. Target: at least 4 cutman-relevant nights per gym-year and at least 1 real stop/survive/race decision per season; add the count as a probe next to the 1-in-16 / 1-in-7 targets.
2. **Make the money pay somewhere.** Reprice from the arithmetic: Name cutman at 15% of the gym's share of a ranked purse, not a flat $700. Restore the existing "halves layoffs" return on every tier (Club half, Seasoned two thirds, Name three quarters). A probe must show each tier is best on a named segment (level, scar, stake) or the tier is cut.
3. **Pin the missing rules.** Write down: opening depth (for example 15-35), closing sets depth to 0 and reopens after 2 more landed punches, the hunt as +1 landed punch on the cut per exchange the hunter wins (not per exchange), the doctor checks in the minute only (never mid-round). Use random offsets that carry between minutes, so the range cannot be centred or intersected, and a first example with the right width per tier.
4. **Make the doctor a rival.** A hidden doctor temperament (cautious -4 / standard / lenient +4 on the line) visible on the show notice or by tape; the doctor's line is then known to within a few points and the range is a real read. Add the opposing corner's cutman as a scoutable fact so "hunt theirs" has a counter.
5. **Give "send out" a real price.** The cut's depth at the bell feeds the existing InjuryRoll (for example 55 or more is a 6-week layoff; 70 or more is 10). This is what makes Stop right some nights. Fix the morale table so a truthful pull-out is not worse than being stopped (a pull-out is -12 only, and a stoppage after fighting on is -12 -4 -layoff).
6. **Add one hand point with information value.** The finger test (1 cutman hand) says whether the boxer's "I'm fine" is pride or truth, so the trust table is a read instead of a coin flip, and it competes with the cut and the swelling for the same 3 points.
7. **Close the loop with a reveal.** After every cut night the Why shows a cut ledger: the true depth by round, the doctor's line, every punch that landed on it, and what each of your choices changed ("covering the eye saved about 12 depth"). Without it the player cannot learn the read.
8. **Make scar bite where the decision is.** Scar lowers the doctor's line (-scar/5) and the opening depth, so it shows on the card. Slow decay to 1 per 4 weeks, with a floor at 30 that only surgery can clear. Style change: capped at -15% and costs a real goal slot, not a free permanent buff.
9. **Remove redundancies.** Either Survive needs the "Protect the eye" line (so the plan place is a real price and gives a real gain) or the line becomes a free stance that also covers the round the cut opens in. Make Survive and Race differ on more than Pace: Race loses cover, gains finish chance (a stat shown on the card).
10. **Shrink the minute.** Do the cut card as the doctor's visit before the minute: three panels only (what you know, your hands, send out), no verdict words, the coach's three points unchanged. See the drawing.
