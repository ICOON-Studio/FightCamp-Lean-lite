# The Camp Board: our own loop (S390, 2026-11-06, proposal, not approved)

Operator: "this looks very much to the game gladiatus". Agreed: the live-week wireframe was too close. This page keeps four general ideas from that test
(state you can see, small frequent decisions, a deadline everything points at, rest that pays) and expresses them only through boxing and what we already built.
Correction: there is no gym floor scene in this project, the bible rules it out of the first release, and PLAYER_PATH removes the Gym > Floor stub. Nothing here needs one.

## The thesis
A gym owner's week is a race to the scale. You run overlapping fight camps, you can only stand with one fighter at a time, and what a fighter does when you are not watching is who they are.

## Where it lives
Home, as a whiteboard. One row per fighter in camp, usually two to four. Each row: days to weigh-in and fight; camp phase; the body holo; LEGS, SCALE, RISK for fight night; today's session card. Fighters not in camp sit below as one line each.

## A week
Blind critic, first draft: 6/10. It said the skeleton was still Dominus (rows, ticking days, pause, pick), a daily pick is a solved chore, and "hides a knock" broke pillar 4. So there is no ticking clock and no daily pick.
**Monday is the game.** The coach's week is written by the camp phase, as now. The player spends the coach: a few tokens a week, placed on morning sessions and evening sessions on the board. Mornings build the body, evenings rehearse the plan, so even with one fighter the question is real: which sessions matter most? An assistant coach is more tokens for wages, so money enters. Pillars 1 and 2.
Then **Run the week**: about 10 s, days pass, gauges move, what the coach saw is written up. Nothing to do during it.
Ignore the tokens and the coach places them plainly: the week stays 1-2 minutes when quiet.

## What is new: three rules
**Forecasts are ranges, and the coach narrows them.** Every gauge shows the range between "nothing goes wrong" and "every habit fires", for the plan as it stands. The result always lands inside. Coached sessions take their uncertainty out. Attention buys information; nothing is hidden, only unknown, and the range says why it is wide.
**Habits are what a fighter does unwatched.** Rolled at signing, unknown until the coach catches one:
- Sneaks food: weight drifts up.
- Can't stop: adds hard work, so LEGS worsens.
- Hides a knock: RISK's top end climbs.
**Habits move.** Coached sessions wear a habit down; neglect feeds it. A fighter you stayed close to in camp one is easier in camp three. Attention is a career investment, and two habit-heavy fighters in one month is a hard month. Pillar 3, and it answers C238.

## The deadline
Weigh-in, then fight night, per fighter, as now. PeakCamp already pays for making weight, hitting the stat and never overreaching: all three lines met means peak. Missing weight costs the bout. Camps overlap, so the last week of one eats the coach time of another. Taper is the rest that pays: the ghost shows what a rest day buys for fight night.

## Fatigue on the body
The body holo shows load. For now one heat rising from the legs, as LEGS worsens. Per-muscle load by session is later, if this works.

## Reused, new, out
Reused: WeekPhase, WeekPlan, GaugeRow with ghosts, BodyHolo, PeakCamp, WhiteboardKit, weigh-in, Drill.
New: coach tokens, ranges on GaugeRow (ghosts need them too), habits that move, Run the week.
Out: everything from the earlier test. No skull or ring meters, rooms with beds, dragging, shared arena day, one-skill-until-done, opponent weakness tile, ticking days or pause.

## Risks
Does a range read as honest or as noise? Is placing tokens the fun of planning or a spreadsheet? Parts have precedents (Football Manager ranges, Darkest Dungeon quirks); the claim is only that the combination is ours.

## How we would know
A wireframe on our formulas, two to four fighters. Fail if the same fighter every week, or no tokens at all, scores about the same as placing by need. Every result must land inside its range. Then the operator plays it. Strangers come after the plain screens, as the bible says.

## Result so far (S390)
Playable wireframe: https://claude.ai/artifact/CdMKrLLJVfBConairS9AQ4. Blind critic: page 6/10; wireframe 5/10 as a loop, 3/10 as a test, and "no longer Dominus": closer to a Princess Maker or Football Manager week scheduler with worker placement. Hidden habits you wear down are the fresh part.
Fair run, 2,000 seasons of 20 weeks, every style on the same diet rule: no coach 2.22 wins; same fighter 3.44; even spread 4.02; closest fight first 4.16; placing by worry 3.79. **The page's own test fails: thinking about where to place the coach does not beat a plain even spread.** A coach matters; choosing does not, yet.
An earlier "both matter" reading was wrong: only the winning bot had the hard cut. Forecast ranges held in 216,000 checks at all horizons, with the plan left alone; changing the plan moves them, as the key says, and the check is close to true by construction.
Other open points: about 3 bouts of 9 are lost at the scale or to injury in every style, too harsh; the assistant was not worth its wage in the earlier run and is not re-measured; 15 gauges are a lot to read.
Likely next step, a design question and not tuning: make coaching matter at moments, not by volume, so need really varies from week to week.

## Moments (S390, operator: "board looks nice")
The look stays. Added: each week a few sessions are flagged, shown dashed on the board: weight turns, wobbling, big spar. Coach there, it pays; missed, it costs. Ranges now allow for weeks not yet written, so they tighten as the fight nears: 0 outside in 216,000 checks at all horizons, plan left alone.
Fair run, 2,000 seasons, every style on the same diet rule, strength M_KG 0.35: no coach 1.92 wins; same fighter 3.14; even spread 3.69; by worry 3.69; closest fight 4.10; reads the moments 4.19.
Reading now beats a plain spread by 0.5 wins but only ties "closest fight". Trade-off measured: strong moments (0.5 kg) gave +1.0 over even but cost 3.5+ bouts a season; soft ones (0.22) gave +0.3. Not re-judged by a critic.
Open: peaks fall to 0.0 whenever the hard-cut rule runs, a bug or a bad rule, unread; about 3 of 9 bouts lost in every style, too harsh; the first "by worry" bot may be weak; assistant not re-measured.
