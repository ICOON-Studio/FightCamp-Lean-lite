# THURSDAY2 RESULT - how many real problems does a camp week throw up by Thursday?

## Contract
- 40+ camps, 5 boxers (Lucy + 4 prospects) x 4 bouts x different seeds
- Thresholds: tape = tell opened whose answer she does not own (mastery < 30); habit = habits present + sparring night this week; weight = > 0.3 kg above limit; tired = week_peak >= 75 (OVERREACHED 80 - 5); card = drill card not usable by taper start

## Spread
- Distinct opponents: 10
- Distinct boxers: 5
- Distinct camp-week rows: 66
- Camp lengths (days to bell): [23, 16, 9, 2, 30]

## Why THURSDAY1 collapsed
THURSDAY1 set `c.seed` AFTER `Career.quick_start()` returned. The seed affects rival bout records (RivalPast.seed) but Lucy is always the same fighter (from Data.lucy()), and opponents are offered in a fixed order from Data.OPPONENTS. So all 40 'different seeds' produced the same camp: the same Lucy, the same opponent (Maria Ortega), the same tells, the same weeks. Setting the seed after quick_start changed nothing the count depends on.

## Camp week Thursdays
| Open count | Thursdays |
|------------|-----------|
| 0 | 19 |
| 1 | 23 |
| 2 | 18 |
| 3 | 6 |
| 4 | 0 |
| 5 | 0 |

## Quiet week Thursdays
| Open count | Thursdays |
|------------|-----------|
| 0 | 0 |
| 1 | 2 |
| 2 | 3 |
| 3 | 0 |
| 4 | 0 |
| 5 | 0 |

## Problem frequency (camp): tape=19 habit=45 weight=13 tired=0 card=0
## Problem frequency (quiet): tape=0 habit=5 weight=0 tired=0 card=3

## Lookup share: 100%
The same kind of problem is 'best' (most common in 2+ open weeks) 100% of the time. If 70%+, the choice is a lookup.

## Analysis: five sentences
1. 'One change on Thursday' is NOT a real choice: only 36% of camp weeks have 2+ open.
2. For the quiet week to have real problems, the game would need: sparring that reveals habits before the first bout, tape study from a Saturday ringside, and a weight line before a bout is booked.
3. Most common camp problem: habit (45 times); rarest: tired (0 times).
4. Lookup share 100% - always fix habit.
5. What could not be measured: problem urgency, whether one fix addresses multiple problems, and the player's ability to anticipate problems.