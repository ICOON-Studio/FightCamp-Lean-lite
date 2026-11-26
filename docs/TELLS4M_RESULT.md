# TELLS4M RESULT - the tells: a reader bot that reads, then a blind cover that costs (S566, probe; console worker)

Task: `ops/research/TASK_TELLS4M.md` (run on the PC as a console worker, `ops/research/WORKER_S566.md`: Arena was at its daily
limit). Prior: `docs/TELLS3M_RESULT.md`. Tool: `proto/twohands/tools/probe_tells.mjs` (new `fix=1` for BOT 2, new `v=4`),
`tells.mjs` (new `LIES4`, `fakeOk4`, a `v >= 4` branch beside v2 and v3), `probe_tells_test.mjs` (3 tests added, 8 pass).
Raw: `ops/research/allplay2/tells4m_*.txt` (each file: the n=12 trial, then the n=84 run). Nothing else edited: no page, no
`rules.mjs` / `balance.mjs` / `play_cli.mjs`, no test loosened.

**v2 and v3 output unchanged:** the TELLS3M trial pair `bot=1 opp=0 n=12 seed=1 v=3` was run again on the new code and its
SUMMARY is byte for byte the one in `tells3m_b1_jabber.txt` (`tells4m_reg_v3_b1_jabber.txt`); BOT 2 without `fix=1` is the
TELLS3M bot (a test holds it). Regression: `probe_tells_test.mjs` 8 passed, `rules_test.mjs` 37 passed, `page_play_test.mjs` 4 passed.
All runs `jobs=2`, watchdog GREEN/AMBER before each, one at a time.

## How it was played
- As TELLS3M (whole bouts on `order.html` through `rules.mjs`, his beat chosen first with `ai()`, his cue from it, a fake costs
  him 1 stamina, at most 2 fakes a round and never two running). BOT 0 = the page's mix (control), BOT 1 = BOT 0 with its held
  hands covering the cue.
- **BOT 2 fixed (`fix=1`)**: it doubts a cue only when that cue is the one THIS man fakes under a condition that holds now and
  the cap is not reached (`lieCueHolds`). Then it plays BOT 0's beat with one held hand turned into the cheapest punch that
  reaches (range after its own step; affordable; ties: the bigger punch, then the lead hand) - at Mid / Long that is the jab, Inside
  the lead hook. Every other cue it covers like BOT 1.
- **Version 4**: v3, plus (a) a fake `shoulder` may hide ONE punch of exactly 3 damage on a line both-hands-high leaves open
  (body or under: with the page's punches only the **lead uppercut, Inside** - the lead hook is on the covered side line), and (b)
  the Body Snatcher also fakes `shoulder` on his second condition (the beat after he threw a body punch), knees first, same cap.

## Step 1 - BOT 2 fixed, rules unchanged (`v=3`; n=84 seed=2, trial in brackets; BOT 0 / BOT 1 rows are TELLS3M's same-seed runs)
| bot | against | wins of decided [t = trial n=12 seed=1] | health he dealt a bout | knockdowns a bout (him / you) | stoppages | his fakes per beat | bluff share (fakes within the rule) | his stamina at the bells R1 / R2 / R3 (of 8) |
|---|---|---|---|---|---|---|---|---|
| BOT 0 (TELLS3M, same seed) | Jabber | 86.9% | 16.4 | 2.62 | 42.9% | 19.3% | 100% | 2.3 / 2.1 / 2.2 |
| BOT 1 (TELLS3M, same seed) | Jabber | 95.2% | 12.3 | 2.50 | 50.0% | 19.3% | 100% | 2.1 / 1.9 / 2.2 |
| **BOT 2 fixed** | Jabber | **94.9%** (75/79, 5d) [t 83.3%] | **13** [t 14.7] | 2.38 (2.19/0.19) | **45.2%** [t 25.0%] | 19.6% | 100.0% (281/281) | 2.3 / 2.5 / 2.4 |
| BOT 0 (TELLS3M, same seed) | Slugger | 78.7% | 17.2 | 2.23 | 22.6% | 27.9% | 100% | 2.0 / 2.2 / 2.1 |
| BOT 1 (TELLS3M, same seed) | Slugger | 89.0% | 15.1 | 1.92 | 17.9% | 27.4% | 100% | 2.3 / 2.0 / 2.0 |
| **BOT 2 fixed** | Slugger | **88.0%** (73/83, 1d) [t 58.3%] | **14.4** [t 18] | 1.95 (1.57/0.38) | **23.8%** [t 0.0%] | 27.7% | 100.0% (407/407) | 2.0 / 2.2 / 1.9 |
| BOT 0 (TELLS3M, same seed) | Body Snatcher | 60.5% | 18.5 | 2.12 | 14.3% | 15.4% | 100% | 2.1 / 1.9 / 2.0 |
| BOT 1 (TELLS3M, same seed) | Body Snatcher | 89.2% | 15.5 | 2.21 | 23.8% | 16.6% | 100% | 2.1 / 2.0 / 2.1 |
| **BOT 2 fixed** | Body Snatcher | **77.4%** (65/84) [t 91.7%] | **16** [t 15.5] | 2.13 (1.58/0.55) | **21.4%** [t 33.3%] | 17.0% | 100.0% (252/252) | 2.2 / 2.2 / 2.1 |

What BOT 2 fixed did (n=84): Jabber 445 doubted, 281 really fake (63.1%), punched into 196 (44.0%); Slugger 519 doubted, 407 really fake (78.4%), punched into 204 (39.3%); Body Snatcher 551 doubted, 252 really fake (45.7%), punched into 231 (41.9%).

**Bar - BOT 2 >= BOT 1 + 10 points OR takes >= 2.0 less health, each man: FAIL (0 of 3).**
- Jabber: 94.9% v 95.2% (**-0.3 points**), health 13.0 v 12.3 (**+0.7** more taken).
- Slugger: 88.0% v 89.0% (**-1.0 points**), health 14.4 v 15.1 (**-0.7**, short of 2.0).
- Body Snatcher: 77.4% v 89.2% (**-11.8 points**), health 16.0 v 15.5 (**+0.5** more taken).
- Why: the fixed bot is right about a fake only 63% / 78% / 46% of the time it doubts (his condition holds far more often than he
  fakes, and the Body Snatcher's knees are true on 54% of the beats it doubts), and being right buys little: in v3 a fake hides
  under 3 damage, and the punch it adds is mostly a 1-damage jab, added on only 39-44% of its doubts (the other hand was already
  punching or the stamina was not there). Being wrong costs a cross or a body punch on an open line. Reading the lie is now done
  correctly and still does not pay on these rules.

## Step 2 - version 4 (`v=4`; n=84 seed=2, trial n=12 seed=1 in brackets; no trial pair over 60% stoppages, highest 42%)
| bot | against | wins of decided [t = trial n=12 seed=1] | health he dealt a bout | knockdowns a bout (him / you) | stoppages | his fakes per beat | bluff share (fakes within the rule) | his stamina at the bells R1 / R2 / R3 (of 8) |
|---|---|---|---|---|---|---|---|---|
| BOT 0 no tell | mirror mix | **44.6%** (37/83, 1d) [t 50.0%] | **21.5** [t 24] | 2.40 (1.30/1.11) | **21.4%** [t 25.0%] | - | - | 1.7 / 2.0 / 2.2 |
| BOT 0 no tell | Jabber | **86.9%** (73/84) [t 72.7%] | **16.4** [t 17.3] | 2.63 (2.19/0.44) | **42.9%** [t 41.7%] | 19.4% | 100.0% (279/279; hid one 3: 2) | 2.3 / 2.1 / 2.2 |
| BOT 0 no tell | Slugger | **80.2%** (65/81, 3d) [t 81.8%] | **16.9** [t 15.2] | 1.92 (1.42/0.50) | **17.9%** [t 8.3%] | 28.8% | 100.0% (430/430; hid one 3: 38) | 2.1 / 1.9 / 2.1 |
| BOT 0 no tell | Body Snatcher | **73.5%** (61/83, 1d) [t 66.7%] | **17.9** [t 20.5] | 2.24 (1.54/0.70) | **23.8%** [t 25.0%] | 22.0% | 100.0% (327/327; hid one 3: 16) | 1.9 / 2.1 / 2.0 |
| BOT 1 blind | Jabber | **92.8%** (77/83, 1d) [t 75.0%] | **12** [t 15.6] | 2.33 (2.20/0.13) | **44.0%** [t 41.7%] | 18.3% | 100.0% (256/256; hid one 3: 5) | 2.1 / 2.0 / 2.3 |
| BOT 1 blind | Slugger | **85.5%** (71/83, 1d) [t 83.3%] | **15.5** [t 15.8] | 1.88 (1.44/0.44) | **14.3%** [t 8.3%] | 28.4% | 100.0% (427/427; hid one 3: 48) | 2.2 / 2.1 / 1.9 |
| BOT 1 blind | Body Snatcher | **82.9%** (68/82, 2d) [t 83.3%] | **16.1** [t 13.8] | 2.17 (1.68/0.49) | **25.0%** [t 33.3%] | 23.6% | 100.0% (351/351; hid one 3: 11) | 2.0 / 1.7 / 1.9 |
| BOT 2 fixed | Jabber | **92.4%** (73/79, 5d) [t 83.3%] | **13.6** [t 14.7] | 2.44 (2.18/0.26) | **45.2%** [t 25.0%] | 19.0% | 100.0% (271/271; hid one 3: 2) | 2.1 / 2.4 / 2.3 |
| BOT 2 fixed | Slugger | **83.1%** (69/83, 1d) [t 75.0%] | **15.7** [t 14.6] | 1.75 (1.37/0.38) | **16.7%** [t 16.7%] | 29.2% | 100.0% (437/437; hid one 3: 38) | 2.1 / 2.2 / 2.0 |
| BOT 2 fixed | Body Snatcher | **82.9%** (68/82, 2d) [t 75.0%] | **16.5** [t 18.7] | 2.25 (1.63/0.62) | **23.8%** [t 33.3%] | 22.4% | 100.0% (330/330; hid one 3: 12) | 1.9 / 1.9 / 1.8 |

What BOT 2 fixed did (n=84): Jabber 434 doubted, 271 really fake (62.4%), punched into 196 (45.2%); Slugger 554 doubted, 437 really fake (78.9%), punched into 201 (36.3%); Body Snatcher 549 doubted, 330 really fake (60.1%), punched into 264 (48.1%).
Body Snatcher cues (BOT 1, n=84): shoulder 409 (fake 132), knees 747 (fake 219) - the new shoulder fake is a third of his shoulders.

### The bars (v4, n=84, against the same-seed BOT 0 control)
- **BOT 1 <= BOT 0 + 5 points, each man: FAIL (0 of 3), but much closer** - Jabber 86.9 -> 92.8 (**+5.9**), Slugger 80.2 -> 85.5
  (**+5.3**), Body Snatcher 73.5 -> 82.9 (**+9.4**). TELLS3M: +8.3 / +10.3 / +28.7.
- **BOT 1 takes less health than BOT 0, at least 2 of 3: PASS (3 of 3)** - 16.4 -> 12.0, 16.9 -> 15.5, 17.9 -> 16.1. The loop
  floor holds: blind covering never takes MORE than the control.
- **BOT 2 (fixed) >= BOT 1 + 10 points or >= 2.0 less health: FAIL (0 of 3)** - Jabber 92.4 v 92.8 / 13.6 v 12.0; Slugger 83.1 v 85.5
  / 15.7 v 15.5; Body Snatcher 82.9 v 82.9 / 16.5 v 16.1.
- **His fakes on 15-30% of beats: PASS (9 of 9)** - Jabber 19.4 / 18.3 / 19.0%, Slugger 28.8 / 28.4 / 29.2%, Body Snatcher
  22.0 / 23.6 / 22.4% (up from 15-17%: the shoulder fake).
- **The real beat behind a fake never more than 3 damage, never two punches: PASS (100%)** - 3,108 of 3,108 fakes at n=84 inside
  the rule (0 exceptions); 172 of them hid the one 3-damage lead uppercut (Jabber 2 / 5 / 2, Slugger 38 / 48 / 38, Body
  Snatcher 16 / 11 / 12).
- **Stoppages 10-40%: 7 of 10** - the three Jabber pairs 42.9 / 44.0 / 45.2% fail, beside their control's 42.9% (the control alone
  misses it, as in TELLS3M; not a tells question). Others 14-25%.
- **BOT 0 v the mirror 40-60%: PASS (44.6%)** - identical to TELLS3M (the mirror has no tells).
- **His stamina at the bells** stays in the 1.7-2.4 band of TELLS3M for every man; the Body Snatcher's extra fakes cost him
  about 0.1-0.3 at R2 / R3 (1.7-2.1 v 1.9-2.1).

## Is version 4 worth showing on the page?
1. **Not yet: 4 of 7 bars, the same as v3** - but the one that matters for the player moved the right way: obeying every cue is
   worth +5.9 / +5.3 / +9.4 points (was +8 / +10 / +29) and still helps a little (3 of 3 take less health). The Body Snatcher's
   shoulder fake did most of that; the hidden lead uppercut barely touches the Jabber (2 of 279 fakes: he is rarely Inside).
2. **What the player would see:** the same one body cue a beat; the Body Snatcher now also drops his rear shoulder as a fake after
   his body punches, and now and then a fake shoulder on the Slugger or the Body Snatcher comes with a lead uppercut Inside under
   a high guard - a small, real cost for covering blind.
3. **What is still wrong (not run):** catching the lie pays nothing, because a doubting reader is right only 60-79% of the time
   and its reward is a jab. To fix it I would (a) make a punch thrown into his fake land +1 (he is caught loading, the reward
   for a read), and (b) let the Jabber's hidden 3 be his lead hook to the BODY side - or have the shoulder cover only the rear
   side - so the cost of blind covering reaches the Jabber too (his gap +5.9 is the one left over the bar with the Slugger's +5.3).

TELLS4M DONE
