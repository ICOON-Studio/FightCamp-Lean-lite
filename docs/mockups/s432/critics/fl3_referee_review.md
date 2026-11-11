# FIGHT LINK map v3 (S432) - critic: amateur referee and judge, 20 years (fresh, blind)

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, FIGHT_LINK_MAP_S432.md (whole), fightlink_v2.png, and the code: Knockdowns.gd, BoutRules.gd
(scorecards, verdict, stale_energy, night_edge), Exchanges.gd (round_of, settle, landed bands), LiveRound.exchange, BoutNight (_peak,
outcome_of, _counts, _finish), RingDuel constants, PerkFight, CornerJobs. Nothing was run.

## Score: depth 7 / 10 as designed (about 4 as built today)

One line: the map finally scores and stops bouts the way officials do and ties every row back to a week, a line or a call, but it
still has no referee in it - no fouls, no cautions, no warnings, no stoppage except by counts - and its count card describes a punch
the code never rolls.

## What the code does today (checked)
- Cards are a formula. `BoutRules.scorecards(rounds_won)` writes two identical cards and forces the third one point away: every 2-1
  in rounds is shown as a split, every 3-0 as 30-27, 30-27, 29-28. A count never touches a card. A judge would not sign these cards.
  The map's defect 3 is right, and M2 (clean, big shots, ring control, initiative; leans; 10-8 for a count) is the correct repair.
- A round goes to whoever won more of its six exchanges (`Exchanges.round_of`); "landed" punches are not counted punches, they are
  read off the exchange's margin band (close 4-3, clear 5-2, dominant 6-1). So M2's CLEAN criterion mostly re-counts exchanges won.
- Counts are rolled once per round, AFTER the round, from the round's margin band, power against chin, damage carried and heart
  (`Knockdowns.round_counts`), plus a puncher's chance for the round's winner. No count has an exchange, a minute or a punch.
- Stoppages come only from counts: three in a round, four in a bout, or the referee waving off a counted boxer. There is no
  stoppage for a one-sided bout without counts, no stoppage for a cut (doctor), no disqualification, no corner retirement.
- Professional bouts use the same standing-count rule as amateur ones (nothing in Knockdowns or BoutNight branches on `pro`).
- The clinch (`ClinchRest.tied`, the "Tie up" call and plan lines) has its own dice and costs; holding is never penalised.
- Perks exist for the player's fighter only (`PerkFight` reads `f`); opponents have none. The drawing's "Priya's Counter sense:
  2 counters" chip is a new mechanic the map does not tag NEW.
- LiveRound.gd is 494 lines; the map's parts store and three-way duel go into `LiveRound.exchange`, which breaks the 500-line rule
  unless the exchange is split out first.

## What is good (keep it)
- M2 is real officiating: amateur criteria (quality blows, domination, competitiveness) as CLEAN / RING / INITIATIVE, professional
  ones as CLEAN / RING / WORK, one reason a card, leans known only for officials you know. Honest and earned.
- M12 THE COUNT asks the corner's real questions: what landed, why there, could they take it, was the stop right.
- M13 THE TOWEL is the right hardest decision in the corner, with a lasting price both ways and a line set before the bell.
- The defects found (no-camp tax, the uneven punch start, canned Why lines, fake cards) are real; I checked three of them.
- The bill shows the same rows as the receipt, so the player learns to read their own preparation. Real decisions before the
  bell: the card, pads, the habit card, sparring as the opponent, the week's shape, lines, WHERE, pace, the towel line.

## What a referee and judge sees missing or wrong
1. NO REFEREE'S BOOK. In amateur boxing the biggest scoring swing after a count is a public warning (a point off every card).
   Holding, ducking low, pushing, leading with the head and hitting on the break are what tired and nervous novices do. The game
   already has every cause - "Tie up" lines and calls, a clinch with its own dice, tiredness, Temper, Discipline, Composure, hot
   nights - and none of them can cost a point. This is the most natural link from the build (temperament) and the plan (lines)
   to the cards, and it is absent.
2. THE COUNT HAS NO MOMENT. The drawing says "round 2, at 1:30, Priya's cross". The code rolls counts after the round from the
   margin band. Either the count moves into the exchange (roll it on the exchange that left a side hurt, with the punch that won
   it), or the card must not name a punch or a time.
3. STOPPAGES ARE ONE KIND. Referees also stop one-sided bouts with no count (outclassed), and the doctor stops cuts. Today only
   counts end a bout; the towel's "eye closing" reason has no rule under it. For an amateur the eye is the doctor's call, not the
   corner's, and corners may not work a cut the way a pro cutman does.
4. 10-8 FOR EVERY COUNT IS A PROFESSIONAL HABIT. Amateur judges give 10-8 for a round of clear domination; a count usually earns it,
   but not on every card. Amateur rounds must have a winner on every card (no 10-10), and tied totals after a deduction are settled
   by each judge naming a winner. Pros allow 10-10 rounds and draws.
5. PROFESSIONAL BOUTS RUN ON AMATEUR STOPPAGE RULES. Most professional rules have no standing count and no three-count stop; the
   referee stops on judgement and the corner retires a boxer between rounds. The first pro fight is in this version's scope.
6. JUDGES ONLY DIFFER BY LEAN. Real splits come mostly from close rounds that judges see differently. Give each judge a small
   independent eye on close exchanges (seeded, so the replay still works), not only a weighting; otherwise a split happens only
   when leans differ, and the leans become a solved pick.
7. "LANDED" IS NOT LANDED. CLEAN reads punches derived from the margin band. If quality blows are the base of every card, they need
   their own count: punches that scored by kind (jab, power shot, body) from the exchange's winner, its pace and its punch levels.
8. THE RESULT PAGE CARRIES TOO MUCH. Strip, eight rows, chips, count card, towel, judges, places, what you did to them, who decides,
   the Why. The map's own rule ("the count card replaces the places") should go further: one primary story per bout (cards, count,
   or referee), the rest one press away.
9. OPPONENT PERKS AND ANSWERS ARE UNTAGGED NEW WORK. The opponent's perk chip, their readiness and their Legs need their own rows in
   the hook table and their own probes.
10. BJJ (one of the four fighters) gets one paragraph (M11). The referee there decides too: stalling penalties, advantages, the
   decision on a tie. Before a match the grappler's corner has no priced choices (pull guard or wrestle, chase the finish or keep
   the points lead).

## To reach 10/10 (most important first, each buildable)
1. THE REFEREE'S BOOK (new pure rule Fouls.gd + test): per exchange, a foul chance from what the fighter is doing - holding when a
   "Tie up" line or call fires inside, head low when pressed and tired, pushing after the break - times (1 + tiredness over 50 /
   50) times (1.3 - Discipline / 100) times a hot-night factor from Temper and Composure. Amateur: caution, caution, then a public
   warning = -1 on every card; three warnings disqualify. Pro: the referee deducts after warnings. Store each on the exchange; mark
   it on the bout strip; a REFEREE row in the scales; on the bill a "warning risk N in 100" for each holding line; the opponent
   fouls by the same rule. Probe FOULS1: warnings in 3 to 8 bouts in 100 at club level (John checks real rates), and at least 1.5
   wins in 100 between a disciplined and an undisciplined fighter who tie up the same.
2. COUNTS IN THE EXCHANGE: roll the count chance on each lost exchange (margin and the winner's best punch against chin, damage,
   heart), so a count has a minute and a punch, and the 3D view can show the same moment. Keep the round's total chance where it is
   today (probe KDRATE2 against Knockdowns' tuned rates).
3. STOPPAGE KINDS: RSC for a one-sided bout without counts (the referee's patience: damage over a line and no answer back for two
   exchanges), RSC for injury from the cut rule with the doctor's look in the corner minute, DQ from the book, the corner's
   retirement (the towel). Each kind its own result line and its own suspension.
4. PROFESSIONAL RULES BRANCH: no standing counts for pros; knockdowns score 10-8 on every card; 10-10 rounds and draws allowed; the
   referee stops on judgement; the corner retires a boxer between rounds. Amateur: every round has a winner on every card, 10-8 only
   with domination (a count plus a clear round), tied totals settled by each judge's pick.
5. EACH JUDGE'S EYE: a small per-judge seeded noise on close exchanges besides the lean, so splits come from close rounds as they do
   in real bouts; JUDGES1 adds "splits happen in close bouts, almost never in clear ones".
6. PUNCHES THAT SCORED: count scoring punches by kind on each exchange from the winner's punch levels, pace and the place; CLEAN
   reads those, not the margin band. The result shows "clean scoring punches 31 to 27" per judge's view.
7. ONE STORY PER RESULT: the page opens on what decided it - the cards, a count, or the referee's book - and folds the rest behind
   one press each. Never more than six rows on screen.
8. SPLIT LIVEROUND FIRST: move the exchange's edge sum into a pure rule (ExchangeParts.gd) before adding parts, snapshots and the
   three-way duel; keeps every file under 500 lines.
9. TAG AND PROBE THE OPPONENT'S SIDE: opponent perks (by bouts and style), their readiness and Legs as NEW, each with a probe.
10. BJJ RECEIPT WITH DECISIONS: stalling penalties and advantages in BjjRef, the decision on a tie, and two priced choices before a
   match (start standing or pull guard; finish or keep the lead), read back on the mat scales.

## Complete for this version?
Yes, with the list applied. Four fighters from the first amateur bout to the first professional fight need: honest cards (M2 plus
items 4-6), a referee who penalises what the build and the plan do (item 1), counts and stops with a moment and a kind (items 2-3),
the professional rule branch for the debut (item 4), and a grappler's result that reads back the grappler's choices (item 10).
Everything else in the map (the scales, THE COUNT, THE TOWEL, the places, WHERE, readiness) is already enough for this version.

## My 10/10, drawn
`docs/mockups/s432/critics/fl3_referee_10.png` (from `fl3_referee_10.html`): a split decision lost on a public warning for holding.
The bout strip marks cautions and the warning; the headline row is the plan line that caused the holds, with its price on the bill
("30 in 100") and a true replay ("without it Kai wins 29-28, 29-28, 28-29"); the three judges with their lean, the tie each one
settled and one reason; THE REFEREE'S BOOK with times and causes; the towel that never came; and three priced decisions for the
next bout.
