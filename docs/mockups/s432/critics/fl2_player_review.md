# FIGHTLINK3 map v2: player-critic review (fresh, blind) - S432

Critic: a player of management sims who hates results that feel random and loves seeing why they won.
Read: CRITIC_PACK, CRITIC_ACCESS, FIGHT_LINK_MAP_S432.md (whole), fightlink_v2.png, the real result screen (critic_pack/screens/21_result_real.png),
and the code: LiveRound.exchange (whole), RingDuel (form, step), Duels (tools, constants), Exchanges (settle, round_of), BoutRules (night_edge,
scorecards, why, weapons_edge), Knockdowns, Attrs._punches, Data.START_MOVE_SHARE, Bouts.start_camp, Sim._as_of, PlanFight.EDGE,
FighterProfile.TRUST; the measured tables in FIGHTER_MODEL_S397 (sections 9-10). The neighbour maps (CLUBWEEK v4.1, RPG, TRAINING, HYPE) were
checked only for their hooks. Nothing was run.

## Score: depth 7 / 10
One line: the right medicine. A real receipt (the same night replayed without each part) plus honest judges turns a deep but hidden fight engine
into one you can learn from. It reaches 7 because almost every row ends in a button that is the next decision. Three holes keep it from 8: it
never explains a stoppage; the replay is only first-order; and the new Aim adds a second "how busy" control beside the Pace that is already built.

## What I checked in the code (the map's trace holds)
- Exchange luck: `Exchanges.settle` margin = d + (roll_a - 0.5) x 66 - (roll_b - 0.5) x 66, a triangle from -66 to +66. Correct.
- Form: `RingDuel.form` rolls randfn(0, 5) for each side once a bout and adds the gap to every duel edge. The gap's spread is about 7, the
  size of 7 points of training (+5 wins 72 in 100). Hidden. Correct, and the single worst thing in the engine for a player like me.
- Scorecards: `BoutRules.scorecards` builds the cards from rounds won alone. The real result screen proves the lie: Lucy won 10 of 18
  exchanges and landed 61 to 56, and still lost. Judge 3's 29-28 bars show Lucy winning rounds 1 and 2, but Lucy lost round 2. That split is
  made up by the formula.
- Canned lines: `BoutRules.why` prints "The camp: <focus> held up when it mattered" for any camp at protocol 2 or higher, and "Your corner call
  ... won that round" for any won round that had a call. Both are canned, as the map says. The second is canned too and the map does not
  name it.
- NO_CAMP_EDGE: -1.5 on every exchange when `f["camp"]` is empty; `Bouts.start_camp` is the only thing that fills it. A camp-free amateur
  fight week would pay this unless it is fixed. The map flags this right (NOCAMP1).
- Uppercut and Check hook start at 0 mastery, so the punch level is clamped to 1. In the Duels table the uppercut weighs 0.40 of the
  inside uppercut tool and 0.17 of short work. A real hole, softened only because a fighter leans on their best tool (BEST_W).
- `Sim._as_of` swaps `stats` only; the moves (the punch levels) and any stored attributes are left at today's values. The map says the
  28-day row is "read through Sim._as_of, built". That is not enough: the Monday snapshot of the abilities AND the move mastery must be stored.
  Without it, THE LAST 4 WEEKS row misses the pads, which is the biggest link from the week to the night.
- Measured levers already on file: corner silence 0.47, the coach's pick 0.52, reading the clue 0.67 (exchanges_test); a good plan 59 / none 45 /
  wrong 41 in 100 (one matchup); +5 training 72, +10 95. So the corner and training are big, the plan medium, and the camp, weapons count,
  combinations count and peak camp are small. The map's verdict table agrees with this.

## What is good
- THE SCALES is exactly what a "why did I lose" player wants. Same dice, each group taken out, exchanges and rounds turned, and the row that
  flipped the RESULT named in one headline. Every row has a button that is the next decision (Train it out, Open the plan, Rest up). This
  closes the loop from the fight back to the week.
- Honesty rules that are rare in the genre: no "in 100" on one bout; the cut rule (under 1.5 wins in 100 means cut, merge or show without a
  size); every probe prints today's game first (the control arm); a row that disagrees with a full switch-off probe is demoted to exchanges only.
- The judges move from a formula to scoring (clean punches, big shots, ring control, work) with three leans shown at the weigh-in. A split
  becomes something you could see coming and plan for. That is a decision, not noise.
- THE THREE PLACES strip finally shows the duel engine, which is the backbone and was invisible: "jab 60 against feet 54, wins 6 in 10 here".
  It is the same number before the bout, during it and after it.
- LINES THAT SUIT tie the plan to the build. The same step-back line is right for an out-boxer and wrong for a slugger. That is the RULE4 fix
  this game needs, and it ships behind one gate with the Playbook map.
- The hidden style dials become a choice (Where, one step either side of the fighter's own), priced before the press.
- Form is earned: readiness from the fight week, mood, weight, ring rust and nerves; the spread is cut from 5 to 3 and named after the bout.
- Small levers are cut or sized instead of being listed as reasons (camp night edge, weapons count, peak camp).
- The defects list is real, comes from the code, and is put first in the build order.

## Missing options (and what each would change)
1. THE STOPPAGE. Counts and stoppages are a second set of dice per round (`Knockdowns.round_counts`: margin band, power against chin, damage,
   heart, a referee roll). The scales count exchanges and rounds only. A stoppage loss, the most painful result in the game, gets no receipt.
   Needed: a DAMAGE row or panel: the damage built and which group built it (habit, legs, build gap), power against chin, the count chance,
   and the referee's roll named as luck. Button: Durability and defence mornings, or "pull the fighter out sooner" (a corner choice that exists
   for no one today).
2. A second-order check for the headline. "IT TURNED ON" is the most trusted line on the page, and it is the line most hurt by the first-order
   replay. A habit punished in round 1 also drained the tank for round 3. Make the headline row (and only that row) a TRUE replay: the whole
   bout played again from the bell without that group, on the same seeds. It costs one extra simulation per bout. If the true replay and the
   same-dice replay disagree, show "probably" in place of a flat claim.
3. Where this fighter wins against the field, on the fighter's page (Overview), not only on the bout sheet. The strip against the division's
   typical opponents (out-boxer, presser, counter-puncher, slugger) tells the player WHAT TO BUILD over months. Without it, training direction
   comes only from the next opponent. This is the build-to-fight link for the four-fighter squad.
4. Exchange-level cause in time. Rows say what turned the bout; a strip of 18 tiles (one per 30 seconds) with the biggest part's letter on
   each tile, and gold on the ones that flipped, shows WHEN. The parts already exist per exchange (PARTS1). Clicking a tile gives the
   exchange's parts. This is the cheapest high-value view on the page.
5. One home for the result's sizes. CLUBWEEK v4.1 also puts sizes on the result ("Legs: 9 off the tank, round 3 lost", "your week against
   Coach's"). The scales must be that home: the Legs row IS the CLUBWEEK size, and "your week against Coach's" becomes a line under the
   scales. Otherwise there are two receipts that disagree.
6. The opponent's side in plain view: their habit you punished, their perks, their Legs. Today "against you" covers only what hurt you.
   A "what you did to them" line makes the plan's tells feel earned.

## Useless or overlapping options
- HOW BUSY (Patient / Own pace / Busy) beside the built Pace (Push / Steady / Save). Two "how hard does the fighter work" controls with
  different maths (one moves the edge and punches landed, one moves guard, counters and the Work judge). A player cannot tell them apart.
  Merge: Pace moves the pace dial too (Push = +15, Save = -15), and HYPE's Entertain and Safe map onto the same one control. Keep WHERE as the
  only new pick.
- The LUCK row with "Lucy normal +0.4, Priya sharp +2.6": fine, but folding the exchange dice into it ("the dice: -1") matters more
  than the form detail. Keep one luck row, two parts on hover.
- "See the rounds" as YOUR CORNER's button is not a decision. Make it "Replay the shouts" (the round with each shout's result), or point it at
  the coach-level pick in the RPG map.
- The Monday "Your choices this month: +N exchanges" without a comparison is a vanity number. Show it against Coach's week (CLUBWEEK's
  deal), so the number answers "did my choices beat the default?".

## New mechanics (only where decisions are thin without them)
- STOP IT (corner): when the damage panel reaches the doctor band, a corner choice between rounds: retire the fighter (a loss, with no
  suspension beyond the rest and no lasting-damage roll) or send them out (the stoppage and lasting-damage risk named). This makes durability
  a real decision on the night and gives the damage panel an action. It fits the cutman card already agreed (R28).
- Nothing else. The map already adds enough choices (Where, the judges' panel, readiness, the corner's card, lines that suit). More would bury
  the receipt.

## To reach 10/10 (most important first, each buildable)
1. Fix the store first: a Monday snapshot of the 14 abilities AND the 6 moves' mastery (not `Sim._as_of`, which swaps stats only), so
   THE LAST 4 WEEKS row includes the pads. Test: a fighter with +10 hook mastery from pads shows a non-zero row in a pocket-heavy bout.
2. THE DAMAGE panel on the result: head damage built per round with the group that built it, power against chin, the count chance per lost
   round, the referee's roll named as luck. Every stoppage and every count gets a reason line. Probe DAMAGE1: on 400 stoppages the panel's
   biggest group matches a switch-off replay in 8 of 10.
3. The headline row by a TRUE replay (the whole bout again from the bell without that group). Say "probably" when it disagrees with the
   same-dice replay. SCALES1 stays for the other rows.
4. Merge HOW BUSY into the built Pace (Push / Steady / Save also move the pace dial +-15). WHERE stays as the one new pick. AIM1 then tests
   three Wheres x three Paces, and no pair may win on all four matchups.
5. The 18-tile timeline above the scales (the letter of each exchange's biggest part, gold on flipped ones, click for the parts).
6. One receipt: CLUBWEEK's result sizes become scales rows; "your week against Coach's" sits under the scales; the old "What decided it" and
   `BoutRules.why`'s camp and corner-call lines are deleted together (the corner-call line is canned too).
7. "Where this fighter wins" on the fighter's Overview: the three places against the four typical opponents of the division, with the
   pad card or morning that moves each, so the build direction has a target beyond the next bout.
8. STOP IT in the corner minute when the damage reaches the doctor band (with the agreed cutman card), priced in plain words.
9. Label the strip's number "on the build alone" and add one line under it, "plan and corner can add about N" from LEVERS1, so no one reads
   "wins 4 in 10 in the pocket" as the bout's chance.
10. The opponent's half: one line "what you did to them" (their habit you punished, their Legs, the tells your plan answered).
11. Golden-path test extends to a stoppage: a fighter with an open habit and a weak chin is stopped; the damage panel names the habit and the
    referee's roll; its button opens the week.

## Complete for this version?
With the list applied: YES. Four fighters (the Monday sums and the per-fighter Overview strip cover the squad), amateur bouts (judges,
readiness, the fight week with no camp penalty), the BJJ athlete (M11, the mat's own receipt; judges correctly left out), and the first
professional fight (4 rounds, NO_CAMP_EDGE kept for pros, the corner's card matters over 4 rounds). Without items 1 to 3 it is not complete:
the training row would miss the pads, stoppages would be unexplained, and the most trusted line could be wrong.

## My 10/10 drawing
`docs/mockups/s432/critics/fl2_player_10.html` -> `fl2_player_10.png` (1920x1080): the result page with the headline checked by a true replay,
the bout as 18 tiles, the scales with one action each and the month against Coach's week, the judges with round marks and one reason each,
the corner's wrong read named, THE DAMAGE panel, the three places, and one button that puts both fixes on next week's board.
