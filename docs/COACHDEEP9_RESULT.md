# COACHDEEP9 - coaches v9 (v8 + the three changes its probe named): the greybox probe and THE CUT (S545)

Task: `ops/research/TASK_COACHDEEP9.md`. Map: `ops/research/DESIGN_COACHDEEP9.md` (v8's map whole, changes marked "v9:"; bars s10 =
v7's, stop rule s16, committed before any run: 9398129). Probe: `tools/coachdeep9.gd` + `tools/coachdeep9_rules.gd`, copies of v8's
with the three changes (v8's files untouched), summary `tools/coachdeep9_sum.py`. Nothing under scripts/ or tests/ changed.
Raw (outside the repo): E:/FightCamp/tmp/coachdeep9/ - trial.txt / trial2.txt (+ _sum: one rep, printed in full), full.txt + full_sum.txt
(100 careers a cell per arm, 17 arms, 10 cells, 31.7 min), cut.txt + cut_sum.txt (the same with `cut=fall:back_coach`, 39.2 min).
All runs through `godot_slot.py --who COACHDEEP9`, one at a time, headless, Dummy audio, watchdog GREEN before each; 0 script
errors in the counted runs (one cut run was lost and re-run: another session committed scripts/state/Data.gd while it loaded).

## 1. Verdict: FAIL - 5 of 7 on the full run; 6 of 7 after THE CUT of the falling-out
Stop rule (map s16) applied: bar 3 failed again on the falling-out -> THE CUT (s4). No v10 proposed. No critic brief, nothing queued
for kalli or dola, no code-checked critic owed. Bar 6 (the trial week), which v8 passed, now fails in both runs (s5).

| Bar | Needed | v8 (full) | v9 full run | v9 with THE CUT (falling-out by the rule) |
|---|---|---|---|---|
| (1) no hire best in > 6 of 10 | <= 6 | L 7 - FAIL | **F 4, K 6** - PASS | F 4, K 6 - PASS |
| (2) K > NOHIRE by > 2 SE with a pro / title boxer; not above +2 SE without | 6 + 4 | big_am +5.9 - FAIL | pro/title +20.1, +30.5, +27.4, +37.7, +12.0, +37.7 (all > 2 SE); without -28.8, **-21.9**, -28.6, -41.2 - PASS | same - PASS |
| (3) no answer best in > 6 of 10, each moment | <= 6 | fall coach 8; push refuse 8 - FAIL | **falling-out: back the coach 10**; raise refuse 6 / match 4; push refuse 6 / allow 4 - FAIL | raise 6 / 4, push 6 / 4 - PASS |
| (4) corner: tactician >= 25%, bonded >= 25% | both | 38% / 62% | 45% / 55% (1,373 differing fights) - PASS | same - PASS |
| (5) careless loses in >= 2 cells, careful in <= 1 | both | 5 / 0 | careless 5 cells, careful 0 - PASS | same - PASS |
| (6) trial right (> +2 SE) in >= 2, wrong (< 0) in >= 2 | both | right 4, wrong 6 | **right 1 (big_title +9.0), wrong 9** - FAIL | same - FAIL |
| (7) nothing runs away | all | PASS | members = catchment in every arm; 0 months with two moments; bond max 0.25, chem max 0.72 - PASS | same - PASS |

## 2. The three changes, as run
1. ONE WAGE RULE (grill Q17 "wages scale with ratings"). P = (4 x teaching + 3 x pads + 2 x tactics + 2 x conditioning + motivation
   + film + 0.5 x cutman + 0.5 x weight) / 14; wage = $150 + $125 x (P - 9) + $150 an art past the first + $350 for a known name,
   rounded to $10. Same formula for all five cards, no card tuned:

   | Card | v8 wage | v9 wage | pays for itself at about N members (v9) | moved |
   |---|---|---|---|---|
   | L local pressure, teaching 14 | $200 | $480 | 60 | +$280 |
   | M two-art mat coach, teaching 15 | $450 | $590 | 111 | +$140 |
   | S solid engine room, teaching 7 | $550 | $420 | 48 | -$130 (now the cheapest) |
   | F solid film room, teaching 9 | $480 | $440 | 48 | -$40 |
   | K known name | $1,000 | $960 | never on members | -$40 |
   The best class teacher (L, M) is no longer the cheapest card. Bar 1 now passes: F best in the four cells without a pro, K in
   the six with one. L, best in 7 in v8, is best nowhere (it was the price, not the coach).
2. THE CAREFUL PUSH LINE - this is the probe BOT's policy, not a game rule. In one sentence: "allow a style push from a coach who is
   the main coach of at least half the gym's boxers, refuse one with fewer" (still allow when a refusal would put a second warning
   on him or take him within 10 of the line, as v8). Bar 2 now passes: big_am's K - NOHIRE went from +5.9 +- 2.1 to -21.9 +- 1.7.
3. A STANDING WARNING DRAINS LOYALTY: while one warning stands, the warned person loses 2 a week (see s6 for why 2, not 1) until it
   fades (26 weeks) or a second warning comes; in its first 8 weeks it never takes anyone under 25.

## 3. Score by cell (lines over two years; v7's score), full run
| Cell | NOHIRE | L | M | S | F | K | best | K-NOHIRE | trial-blind (fav -> alt) |
|---|---|---|---|---|---|---|---|---|---|
| small_am | 273.1 | 260.9 | 265.8 | 263.6 | **280.0** | 244.4 | F | -28.8 +- 1.8 | -0.4 +- 0.0 (F -> L) |
| big_am | 298.6 | 295.3 | 305.8 | 298.0 | **314.4** | 276.6 | F | -21.9 +- 1.7 | -3.1 +- 0.7 (S -> L) |
| small_pro | 337.8 | 330.9 | 332.7 | 331.0 | 340.7 | **357.9** | K | +20.1 +- 0.6 | -27.9 +- 0.8 (K -> S) |
| big_pro | 363.3 | 366.6 | 372.9 | 366.7 | 376.5 | **393.7** | K | +30.5 +- 0.6 | -18.2 +- 0.8 (K -> F) |
| small_title | 335.1 | 327.2 | 330.5 | 327.9 | 337.3 | **362.5** | K | +27.4 +- 0.9 | -35.6 +- 1.1 (K -> S) |
| big_title | 360.5 | 363.0 | 370.7 | 363.6 | 373.1 | **398.2** | K | +37.7 +- 0.9 | +9.0 +- 0.7 (S -> F) |
| small_novice | 10.3 | 3.3 | -8.3 | 5.9 | **16.3** | -18.3 | F | -28.6 +- 1.5 | -3.1 +- 0.7 (S -> L) |
| big_hot | 197.8 | 206.7 | 189.2 | 213.2 | **213.8** | 156.6 | F | -41.2 +- 0.2 | -6.9 +- 0.2 (S -> L) |
| small_pro_hot | 235.6 | 234.1 | 221.3 | 240.2 | 238.4 | **247.6** | K | +12.0 +- 0.8 | -0.4 +- 0.0 (F -> L) |
| big_title_mix | 261.2 | 263.7 | 271.2 | 264.3 | 274.9 | **298.9** | K | +37.7 +- 0.9 | -0.4 +- 0.0 (F -> L) |
Population (named in the output, as v7/v8): the TEST CLUB (TestClub.make on Career.quick_start, seed 5391): Lucy (women's lightweight,
Out-boxer, 21), Kira (women's featherweight, Out-boxer, 18), Josh (men's welterweight, Pressure fighter, 23), Ana (no-gi); cells as map s10.

## 4. Forced moments (bar 3), every answer from the same state, the careful line after - and THE CUT
| Cell | falling-out: coach / boxer / split | raise: match / refuse | push: allow / refuse |
|---|---|---|---|
| small_am | **278.1** / 277.7 / 276.4 | 273.0 / **276.5** | **284.4** / 270.0 |
| big_am | **296.2** / 294.7 / 281.5 | 294.4 / **306.0** | 294.8 / **297.4** |
| small_pro | **355.9** / 354.5 / 345.7 | **357.7** / 334.3 | 354.4 / **357.9** |
| big_pro | **391.6** / 390.3 / 376.9 | **393.5** / 365.9 | 390.2 / **393.7** |
| small_title | **360.4** / 359.1 / 350.3 | **361.5** / 336.5 | 359.0 / **362.4** |
| big_title | **361.6** / 360.1 / 346.9 | 360.9 / **366.9** | 360.0 / **363.3** |
| small_novice | **2.6** / 1.4 / -10.8 | 1.1 / **11.5** | **8.2** / 4.8 |
| big_hot | **211.5** / 208.3 / 209.3 | **208.5** / 206.8 | 210.5 / **213.2** |
| small_pro_hot | **236.9** / 236.6 / 235.7 | 232.9 / **238.2** | **238.1** / 233.9 |
| big_title_mix | **271.5** / 271.0 / 270.6 | 268.3 / **275.1** | **276.3** / 263.0 |
The style push is now a real call (allow 4, refuse 6): change 2 plus the drain (a drained coach sits near the line, so the next
push is allowed). The raise stays a real call (6 / 4). The falling-out got worse (back the coach 10 of 10, by 0.3-3.2 lines).

**THE CUT - the falling-out.** It is not a player decision.
- What the game does by itself instead: when a clash pair has worked together 4+ weeks and falls out, the gym backs the coach. The
  boxer takes the warning (loyalty -12, the v8 work cost and the v9 drain); the coach +5. Backing the coach was best in all 10 cells.
- What the player still sees: one news line - "Reid and Kira fell out. The gym backed the coach: Kira is unhappy (warning 1 of 2,
  until 12 May)." The warning shows on the boxer card as before. "Change" on the week plan stays free, so the player can still
  split a clash pair before it falls out (the careful line already does: no falling-out ever fired on its own in a careful arm).
- Re-scored with the falling-out played by the rule in every arm (cut run): bars 1, 2, 4, 5, 7 PASS with the same numbers to the
  decimal (the careful arms never meet a falling-out; the careless line already backs the coach); bar 3 PASSES on the two moments
  left (raise 6 / 4, push 6 / 4); bar 6 FAILS (right 1, wrong 9). Both tables: full_sum.txt and cut_sum.txt.
- Why it cannot be a call (read off the numbers): backing the boxer warns the coach, and the coach coaches most of the gym - his
  10% work cost lands on every boxer he has, plus 13 weeks of a sulk. Backing the coach warns one boxer, and the game's own
  Loyalty refills her: +1 every full week (Loyalty.MOVES full_week), +2 a won bout. One coach serves many boxers; the trade is
  never even.
The coach game left for the build: the hire (F / K / NOHIRE / ... by cell), the trial week (see s5), the raise, the style push,
the course and the corner pick.

## 5. Bar 6 fails: the trial week (a bar v8 passed)
The trial costs one week of the favourite's wage and swaps to the second card when the favourite clashes with a boxer. It was right
in v8 where it swapped to L at $200 - the cheap superset (big_am +35.7, big_hot +35.8). With one wage rule L costs $480 and the
swap target is never a bargain: right only in big_title (S -> F, +9.0), wrong in nine (the week's wage alone, -0.4, where the
favourite shows no clash; -18 to -36 where the swap drops K's name fee). The line that fails: the trial's swap rule (map s3 + the
probe's blind pick "swap to the next card when the trial shows a clash"), not a number. Per the stop rule nothing was tuned.

## 6. Feedback loops (task "Feedback loops") and the trial
- Warning -> loyalty down -> the person leaves: careless line worst cell 1.05 people a career (stop at 3), careful 0.00 everywhere
  (stop at 1). People who left carrying a warning, cost on / off: careless big_hot 0.32 / 0.04 (the drain took Josh, hot-tempered,
  backed against every time), small_pro / big_pro 0.05 / 0, small_title 0.07 / 0.01; 0 elsewhere. Neither stop fired.
- Who carries the warnings: careful line - one warning a career at most (the film-room coach F refusing a push: small_am,
  small_pro_hot, big_title_mix, 100 of 100 careers); careless line - one person carries every warning (Lucy 79 of 79 careers in
  small_pro / big_pro, 75 of 75 small_title; Josh 100 of 100 big_hot): 4 cells of 10, not more than half. Stop did not fire.
- Wages -> cash: arm means hold (lowest mean end cash -$19.9k, K in small_novice; v8's range was -$26.5k). One single career, K in
  small_novice (a known name in a novice gym with no pro, the card that says it does not pay there), dips to -$42.5k.
- Members at the catchment in every arm, 0 months with two moments, bond max 0.25, chemistry max 0.72, one push a boxer a season.
- ONE-REP TRIAL (printed in full, trial_sum.txt): 6 of 7 (bar 3 failed). Trial stop checks: the best hire differed by cell (F / K);
  bars 4-7 passed. The falling-out's two backing answers differed by 0.0-0.3 lines in eight cells: change 3 did nothing at drain 1.
  Reason: a boxer on full weeks gains +1 loyalty a week (Loyalty.MOVES full_week), exactly the drain. TUNED once, inside the task's
  range: drain 1 -> 2 (net -1 a week for a boxer on full weeks, -2 for a coach), and the pop-up's "lasts about N weeks" counts the
  boxer's +1. trial2 gave the same scores: boxers sit at 75-100 loyalty by week 26, so even -26 over the fade does not reach 25,
  and one warning never makes a coach leave. No drain inside 0.5-2 can move the falling-out; the full run is the verdict.
- The careful line with the cost on scores ABOVE its cost-off arm in small_am (+19.9), small_pro_hot (+6.4), big_title_mix (+9.8):
  the drain moves its later answers (a drained coach sits near the line, so his next push is allowed, and allowing pays there).

## 7. Carried from v8 s6 (for the build, step 5 - the corner pick): the game's win read ignores the corner coach
- `BoutRead.chance(f, opp, camp, coach)` uses the coach only to write plan arrows for a boxer with NO plan (`_read_copy`,
  `CoachPlan.write`); every booked boxer has a plan, so the coach argument is dropped (it still changes the cache key).
- The between-round call `_call(f, n)` is `BoutRules.auto_corner(f["stats"])` and its uptake reads her coachability x trust: no
  coach rating, tactics or chemistry.
- The corner pick's build must wire: (a) `_call` takes the picked coach's call (his tactics deciding best / ok / wrong against the
  opponent, priced by `Exchanges.EDGE`, the probe's `corner_edge`); (b) the uptake x the pair's listen (1 + 0.4 x chemistry) and a
  warned boxer's 0.85, a clash ignoring one call; (c) the coach reaches the read when the boxer has a plan (a dict {tactics, playbook
  fit, chemistry}), with the cache key carrying it; (d) the corner coach's cutman and weight ratings reach the weigh-in miss chance.
- Until then the "about X%" line on the corner pick shows the same number for every coach.

## 8. Decided in this task (no questions asked)
- The wage formula's weights (teaching 4, pads 3 first, as the task said) and its three constants: $150 at P 9, $125 a point, $150
  an art (the sessional mat coach's price), $350 the name (keeps K inside interview 11's $800-1,100). Reid ($460 by the rule) and the
  sessional mat coach stay at $450 / $150: they are not cards.
- "Most of the gym's boxers" = the main coach of at least half the boxers still at the gym; the age-under-23 clause went (the task's
  sentence is the whole rule).
- The falling-out's careful line reads the pop-up's weeks: back whoever would reach the line sooner; both past the fade -> split.
- Drain 2 a week (s6). THE CUT's rule = "back the coach" (10 of 10). A cut run arg `cut=fall:back_coach` (also `push:<answer>`).
- No critic brief (`CRITIC_COACHDEEP9_BRIEF.md` is written only on PASS, per the stop rule).

## 9. Honest limits
- Greybox: v7/v8's limits stand (pro opponents from the top of the rival list, rank moves +1/-2, the corner priced by the probe).
- The wage rule's constants are mine; they set where every card lands. A different slope moves which card is best (F here); the
  formula itself, not a card, is what the owner should judge.
- Bar 6's failure follows from change 1 through the probe's blind swap rule; a trial that swaps by the shown words rather than to
  "the next card" was not tried (stop rule).
- Common bout dice across arms: a 0.3-line win counts as "best" under the tie rule (ties only within 0.01).
