# JOHN_WEIGHT2_ASK - real-world numbers the weight mechanic needs (S535 WEIGHTMOVE1)

For John (deep research). Ten questions. Each names the number the game will use, the placeholder the greybox probe ran on
(`tools/weight2_probe.gd` MODEL, every one an ESTIMATE) and the form of answer wanted.

Already answered, do not redo (`ops/research/J_WEIGHT1.md`, S375): amateur boxers lose about 4 to 5.5 % of body mass in the last
5 to 10 days (Brown 2021, Hall and Lane 2001, Reljic 2013 / 2015, Breen / Norton 2019); England Boxing's safe rate is 0.5 to
1 kg a week with fluid loss under 1 to 2 %; Reale 2017 puts a same-day weigh-in's short-term loss at 5 % or less.

Answer format for every row: the number, its sample (who, how many, sex, level), the label COUNTED (measured, source opened) /
OFFICIAL (a rule or guidance) / ESTIMATE (your reasoning, say so), and the link. "No source found" is a valid answer. Boxing
first; another striking sport only when boxing has nothing, and say which. Women's numbers separately wherever they exist.

| # | Question | The game uses it for | Placeholder today |
| ---: | :--- | :--- | :--- |
| 1 | Performance lost per 1 % of body mass lost by DEHYDRATION at the time of the bout: repeated-effort output, punch force or power, reaction or movement speed. A curve if there is one (is there a knee near 3 %?). | The four drain slopes: stamina, power, speed per 1 % dry at the bell | Stamina -2.0, speed -0.8, power -0.5 points per 1 %; each 1 % past 3 % counts twice |
| 2 | How much of a water cut is back by the first bell: weighed the SAME DAY (1 to 3 hours before) against the DAY BEFORE (18 to 30 hours). Body mass regained as a share of what was cut, amateur and pro. | `regain`: the one number that separates the amateur scale from the pro scale | 25 % back same day, 80 % back day before |
| 3 | How much heavier than the class limit boxers are IN THE RING, pro (day-before scale) and amateur (same-day scale): mean and spread, and by class if it differs. | The opponent's ring weight; the size gap | Pro +4.5 % over the limit, amateur +0.5 % |
| 4 | Dehydration and the head: any measured link between a cut (or fight-time dehydration) and knockouts, stoppages, concussion signs or brain measures in boxing or another striking sport. | Whether a dry boxer's chin drops at all, and by how much | Chin -1.5 points per 1 % dry (the weakest number in the model: tell us if nothing supports it) |
| 5 | What a body-mass edge in the ring is worth: win rate or stoppage rate by kilos or % heavier at the first bell (ring-weight studies, catchweight results), and punch force against body mass across classes. | Size slopes: power and chin per 1 % ring-weight gap | Power +1.2, chin +1.0 points per 1 % heavier; hand speed -0.4 per 1 % |
| 6 | Boxers who move a class: results in the first 3 to 5 bouts after moving UP against moving DOWN (win rate, stoppage rate for and against), amateur or pro. Does power "carry up"? Counted samples, not famous cases. | The class-move carry-over, and whether a move should cost more than the size rule already takes | Nothing beyond the size rule |
| 7 | Body mass growth of trained boxers (or combat athletes) per year from 16 to 23, men and women: kg a year of lean mass, and the age it flattens. | Natural weight drift of a young signing: when he grows out of a class | +1.5 kg a year to 20, +0.5 to 23, flat after (not in the probe) |
| 8 | Age and the cut: does making weight get harder after about 28 to 30? Any measure: more weight regained between bouts, more misses, class moves by age. | Cut tolerance shrinking with age | -0.2 % of tolerated water a year from 28 (not in the probe) |
| 9 | Holding weight down between bouts: what a standing deficit (500 kcal a day, or being 3 to 5 % under the body's settled weight for weeks) costs in training adaptation, strength gain, illness or injury rate (low energy availability / RED-S in weight-class athletes). | The price of a lean diet in the weekly training gain and the injury roll | Training gain x (1 - 0.12 per 1 % held under), floor 0.4; no injury number yet |
| 10 | Missing weight: how often boxers miss (amateur and pro), what the rule then is (England Boxing 2026 and one pro commission: walkover, bout off, catchweight, purse forfeit %), and how big a boxer's own swing in walking weight is between bouts. | The miss chance, the fine or forfeit, and how far off a "declared walking weight" a boxer really drifts | Miss chance 20 % per 1 % of water past the scale's safe line (2 % same day, 4 % day before), x (1.5 - discipline / 100); $300 and the bout off |

What we do with the answers: each replaces one MODEL number in the probe, the probe is re-run, and only then does the map go
to two fresh critics (bar 8 and 8). A number with no source stays an ESTIMATE and is printed as one wherever the game shows it.
