# TELLS5M RESULT - the tells: catching his fake pays, and the Jabber's blind cover costs (S567, probe; cloud seat)

Task: `ops/research/TASK_TELLS5M.md` (the fourth and last tells round; prior `docs/TELLS4M_RESULT.md`, read first).
Tool: `proto/twohands/tools/probe_tells.mjs` (new `catch=1` for V5a, new `v=5` for V5b), `tells.mjs` (new `hiddenPunch5` /
`fakeOk5`, a `v >= 5` branch beside v4), `probe_tells_test.mjs` (4 tests added, 12 pass).
Raw: `ops/research/allplay2/tells5m_*.txt` (one run per file: the `s1` files are the n=12 seed=1 trials, the `s2` files the
n=84 seed=2 runs). Nothing else edited: no page, no `rules.mjs` / `balance.mjs` / `play_cli.mjs`, no test deleted or loosened.

**v2, v3 and v4 output unchanged:** the TELLS4M pairs `bot=1 opp=0 n=12 seed=1 v=3` and `bot=2 opp=0 n=12 seed=1 v=4 fix=1`
were run again on the new code; every line is byte for byte the one in `tells4m_reg_v3_b1_jabber.txt` and the trial block of
`tells4m_s2_b2_jabber.txt` (only the runtime-seconds line differs). Regression: `probe_tells_test.mjs` 12 passed (8 old + 4
new), `rules_test.mjs` 37 passed, `page_play_test.mjs` 4 passed. All runs `jobs=2`, one at a time. (The PC watchdog is a
Windows-side check and is not present in this cloud seat; the runs were serial with `jobs=2` as the task requires.)

## How it was played
- As TELLS4M (whole bouts on `order.html` through `rules.mjs`, his beat chosen first with `ai()`, his cue from it, a fake costs
  him 1 stamina, at most 2 fakes a round and never two beats running). BOT 0 = the page's mix (control), BOT 1 = BOT 0 with its
  held hands covering the cue, BOT 2 fixed (`fix=1`) = doubts only that man's lying cue under a holding condition and punches
  into it with the cheapest reaching punch.
- **V5a (`catch=1`, fake rules unchanged at v4) - CAUGHT LOADING:** a punch that lands on him in a beat where his cue was a fake
  does +1 damage. The beat is resolved by `rules.mjs` (not edited); the probe applies the +1 to the man's health after the beat,
  before the knockdown check, and counts it (`plus1`, `plus1Beats`). Nothing else changes.
- **V5b (`v=5`, `catch=1`):** V5a plus the Jabber's shoulder fake may hide his **lead hook to the body**. The page's body hook is
  the **Body hook (`lbody`): lead hand, 2 damage, line body, reach Inside/Mid** - 2 is under 3, so it is the hidden punch (no
  fallback needed), at the ranges it reaches (Inside/Mid); never two punches, never more than 3.

## Step 1 - V5a, caught loading (`catch=1`; n=84 seed=2, trial n=12 seed=1 in brackets; no trial pair over 60% stoppages, highest 58%)
| bot | against | wins of decided [t = trial n=12 seed=1] | health the man dealt a bout (the bot took) [t] | knockdowns a bout (him / you) | stoppages [t] | his fakes per beat | bluff share | his stamina at the bells R1 / R2 / R3 (of 8) | +1s a bout |
|---|---|---|---|---|---|---|---|---|---|
| BOT 0 no tell | mirror mix | **44.6%** (37/83, 1d) [t 50.0%] | **21.5** [t 24.0] | 2.40 (1.30/1.11) | **21.4%** [t 25.0%] | - | - | 1.7 / 2.0 / 2.2 | 0 |
| BOT 0 no tell | Jabber | **82.9%** (68/82) [t 83.3%] | **16.4** [t 16.3] | 2.55 (2.07/0.48) | **40.5%** [t 41.7%] | 18.6% | 100.0% (265/265; hid one 3: 3) | 2.3 / 2.1 / 2.4 | 1.73 |
| BOT 0 no tell | Slugger | **73.5%** (61/83) [t 72.7%] | **17.5** [t 17.8] | 2.46 (1.75/0.71) | **28.6%** [t 8.3%] | 28.4% | 100.0% (417/417; hid one 3: 41) | 2.0 / 2.2 / 2.2 | 2.79 |
| BOT 0 no tell | Body Snatcher | **72.5%** (58/80, 4d) [t 81.8%] | **17.7** [t 17.1] | 2.49 (1.82/0.67) | **31.0%** [t 41.7%] | 21.1% | 100.0% (306/306; hid one 3: 14) | 1.9 / 1.9 / 2.0 | 1.71 |
| BOT 1 blind | Jabber | **97.6%** (81/83) [t 91.7%] | **12.6** [t 11.2] | 2.65 (2.50/0.15) | **63.1%** [t 58.3%] | 18.7% | 100.0% (258/258; hid one 3: 4) | 2.2 / 2.0 / 1.8 | 1.87 |
| BOT 1 blind | Slugger | **78.0%** (64/82) [t 91.7%] | **14.7** [t 13.5] | 2.19 (1.82/0.37) | **31.0%** [t 8.3%] | 28.5% | 100.0% (418/418; hid one 3: 34) | 2.1 / 2.1 / 2.1 | 2.55 |
| BOT 1 blind | Body Snatcher | **86.4%** (70/81, 3d) [t 91.7%] | **15.7** [t 14.8] | 2.30 (1.89/0.41) | **31.0%** [t 33.3%] | 22.8% | 100.0% (334/334; hid one 3: 10) | 2.0 / 1.9 / 1.9 | 2.02 |
| BOT 2 fixed | Jabber | **94.0%** (78/83) [t 83.3%] | **13.2** [t 13.8] | 2.67 (2.42/0.25) | **61.9%** [t 50.0%] | 18.3% | 100.0% (253/253; hid one 3: 1) | 2.0 / 2.0 / 2.3 | 2.19 |
| BOT 2 fixed | Slugger | **94.0%** (78/83) [t 83.3%] | **13.8** [t 16.1] | 2.24 (1.93/0.31) | **36.9%** [t 16.7%] | 28.9% | 100.0% (420/420; hid one 3: 32) | 2.0 / 2.0 / 2.2 | 3.15 |
| BOT 2 fixed | Body Snatcher | **80.2%** (65/81, 3d) [t 63.6%] | **16.1** [t 18.3] | 2.48 (1.92/0.56) | **44.0%** [t 25.0%] | 23.3% | 100.0% (334/334; hid one 3: 7) | 1.9 / 1.9 / 2.3 | 2.50 |

What BOT 2 fixed did (n=84): Jabber 419 doubted, 253 really fake (60%), punched into 184; Slugger 537 doubted, 420 really fake
(78%), punched into 209; Body Snatcher 520 doubted, 334 really fake (64%), punched into 215. Its punches into doubted cues are
where its +1s come from (184 / 265 / 210 of the +1s landed, V the Jabber / Slugger / Body Snatcher).

## Step 2 - V5b, the Jabber's lead body hook (`v=5 catch=1`; n=84 seed=2, trial n=12 seed=1 in brackets)
**V5b is numerically identical to V5a: every measured number in the ten runs is the same, and the hidden-body-hook count is 0 in
all ten.** The only differences between the `5a` and `5b` raw files are the version label and the new report lines. Why: the body
hook is 2 damage, under the shoulder cue's promise of 3, so a beat holding only the lead body hook was already a valid bluff
under v4's damage rule (`2 < 3`); a 3-damage body punch would be caught by v4's one-hidden-3 rule; the v5b branch can only fire
for a single lead body-line punch of more than 3 and at most 3 damage - with the page's punches that is unreachable. The rule is
implemented and tested (with a synthetic 3-damage body punch, where the reach clause binds: Inside/Mid yes, Long no) and costs
nothing; it would bite only if the page's punch table changed. The table is therefore the V5a table above.

## The bars (v5a = v5b, n=84, against the same-seed BOT 0 control; V4's numbers from TELLS4M beside each)
- **BOT 1 <= BOT 0 + 5 points, each man: FAIL (1 of 3)** - Jabber 82.9 -> 97.6 (**+14.7**; V4 +5.9), Slugger 73.5 -> 78.0
  (**+4.5**; V4 +5.3), Body Snatcher 72.5 -> 86.4 (**+13.9**; V4 +9.4). The +1 pays the blind bot too: its punches are BOT 0's
  beats, and every one that lands in a fake-cue beat gets the +1.
- **BOT 1 takes less health than BOT 0, at least 2 of 3: PASS (3 of 3)** - 16.4 -> 12.6, 17.5 -> 14.7, 17.7 -> 15.7. The loop
  floor holds: blind covering never takes MORE than the control.
- **BOT 2 (fixed) >= BOT 1 + 5 points OR >= 1.5 less health, at least 2 of 3: FAIL (1 of 3, and the one pass went too far)** -
  Jabber 94.0 v 97.6 (**-3.6 points**; health 13.2 v 12.6, +0.6 more taken); Slugger 94.0 v 78.0 (**+16.0 points** - over the
  15-point "gone too far" line: reported as failed); Body Snatcher 80.2 v 86.4 (**-6.2 points**; health 16.1 v 15.7, +0.4 more
  taken). (V4: 0 of 3.) Catching the lie now pays - but too much against the Slugger, and still nothing against the Jabber and
  the Body Snatcher.
- **His fakes on 15-30% of beats: PASS (9 of 9)** - Jabber 18.6 / 18.7 / 18.3%, Slugger 28.4 / 28.5 / 28.9%, Body Snatcher
  21.1 / 22.8 / 23.3%.
- **The real beat behind a fake never more than 3 damage, never two punches: PASS (100%)** - 0 exceptions in all ten runs
  (3,057 of 3,057 fakes inside the rule); the hidden 3 (the lead uppercut) Jabber 3 / 4 / 1, Slugger 41 / 34 / 32, Body Snatcher
  14 / 10 / 7 (BOT 0 / 1 / 2); V5b's hidden lead body hook: **0 of every man's fakes**.
- **Stoppages 10-40%: 5 of 10** - the three Jabber pairs 40.5 / 63.1 / 61.9% fail, beside their control's 40.5% (the control
  alone misses, as in TELLS4M; the +1 pushes the two bots further over); BOT 2 v the Body Snatcher 44.0% fails; the rest 21-37%.
- **BOT 0 v the mirror 40-60%: PASS (44.6%)** - identical to TELLS4M (the mirror has no tells, so `catch=1` changes nothing).
- **NEW knockdowns a bout within 0.3 of the same-seed V4 number for every pair: FAIL (6 of 10 within)** - BOT 0 v Slugger
  2.46 v 1.92 (**+0.54**); BOT 1 v Jabber 2.65 v 2.33 (**+0.32**); BOT 1 v Slugger 2.19 v 1.88 (**+0.31**); BOT 2 v Slugger
  2.24 v 1.75 (**+0.49**). Within: BOT 0 v Jabber 2.55 v 2.63 (-0.08), BOT 0 v Body Snatcher 2.49 v 2.24 (+0.25), BOT 0 v mirror
  2.40 v 2.40 (0.00), BOT 1 v Body Snatcher 2.30 v 2.17 (+0.13), BOT 2 v Jabber 2.67 v 2.44 (+0.23), BOT 2 v Body Snatcher
  2.48 v 2.25 (+0.23). The +1 is lifting knockdowns - every Slugger pair is over - so it is becoming a knockdown rule (the
  n=12 trial fails the same way: +0.75 / +0.41 / +0.33 / +0.59 / +0.42 / -0.33 on six pairs).

## The +1s landed per bout (n=84, each pair)
BOT 0: Jabber 1.73, Slugger 2.79, Body Snatcher 1.71, mirror 0. BOT 1: Jabber 1.87, Slugger 2.55, Body Snatcher 2.02.
BOT 2: Jabber 2.19, Slugger 3.15, Body Snatcher 2.50. The design cap ("at most 2 bonus points a round") is exceeded on five
pairs: a fake beat can carry two of the bot's punches landing (e.g. BOT 2 v the Slugger: 265 +1s in 242 beats with one). BOT 2's
+1s are its punches into doubted cues - the read now pays at once, a little, exactly where it doubts.

## RED_TEST (TELLS4M at n=84, the state this round started from)
Confirmed from the TELLS4M raw files: BOT 2 fixed behind or level with BOT 1 for every man (92.4 v 92.8 Jabber, 83.1 v 85.5
Slugger, 82.9 v 82.9 Body Snatcher), and BOT 1 +5.9 over the control v the Jabber (86.9 -> 92.8). REGRESSION:
`probe_tells_test.mjs` 12, `rules_test.mjs` 37, `page_play_test.mjs` 4. VISUAL: none.

## Three lines
1. **Which version to show the owner: V5a** (V5b is the same measurement - its Jabber body-hook rule adds no fake decisions with
   the page's punches, so there is nothing extra to see; the rule stays in the code as V5b specifies, at zero cost). **Neither is
   ready for the page:** the +5 cap on the blind bot fails on 2 of 3 men, the reader overshoots on the Slugger past the
   15-point line, and the knockdown bar fails on 4 of 10 pairs.
2. **What the player would see:** the same one body cue a beat; when the cue was a fake and his punch lands in that beat, the
   punch does +1 damage - the read pays at once, a little; and the Jabber's shoulder fake may hide his lead hook to the body at
   Inside/Mid (a rule that costs nothing today, as above).
3. **What is still wrong:** the +1 pays any punch landing in a fake beat, not only a read, so the blind bot inflates past the
   +5 cap (Jabber +14.7, Body Snatcher +13.9) while the reader pays too much on the Slugger (+16.0 over BOT 1) and still
   nothing on the Jabber and the Body Snatcher; the +1 is becoming a knockdown rule (4 of 10 pairs over 0.3, all the Slugger
   pairs); and the Jabber's blind-cover cost is still nothing in practice - the hidden body hook never fires, because the body
   hook (2 damage) is already a valid bluff under the shoulder's promise of 3 and the Jabber rarely throws it behind the fake.
   To make blind covering cost against him he would need to actually throw the body hook after backing off (a style change), or
   the shoulder cover would need to cover only the rear side.

TELLS5M DONE
