# TELLS3M RESULT - the tells, version 3, measured on the instrument with bars against the control (S564, probe; Arena seat)

Task: `ops/research/TASK_TELLS3M.md`. Tool: `proto/twohands/tools/probe_tells.mjs` (`v=3`, bluff-share counter added; `v=2`
output unchanged). Merged `origin/main` (`3c61203`) before any runs so `tells.mjs` carries the Body Snatcher's updated second
lie condition (`the beat after he threw a body punch`). Raw: `ops/research/allplay2/tells3m_b<bot>_<man>.txt` (10 files, each
committed and pushed as it finished for the trial and again for the full run). Nothing else edited: no page, no `rules.mjs` /
`balance.mjs` / `tells.mjs` / `play_cli.mjs`, no test.

**Status: both stages ran in full.** The one-rep trial (`n=12`, `seed=1`, `v=3`) had no pair over the 60% stoppage stop rule
(highest was 42%), so all 10 pairs ran at `n=84`, `seed=2`, `v=3` (`jobs=2`). Regression: `probe_tells_test.mjs` 5 passed
before and after, `rules_test.mjs` 37 passed, `page_play_test.mjs` 4 passed.

## How it was played
- Whole bouts on `order.html` through `rules.mjs` (`vtable.json` loaded). The man chooses first with `ai()`, then his cue is
  taken from that plan by `tellOf(opp, his, c, 3)` (`tells.mjs` `LIES3`, `CAP3`: bluff only when his real plan's `ACT` damage
  is strictly less than the smallest punch the cue promises; at most 2 fakes a round, never two beats running; second own-state
  condition on the Slugger `him.st <= 3` and the Body Snatcher `after he threw a body punch`). A fake costs him 1 stamina after
  the beat.
- **BOT 0** = the page's solved mix (`who=mix`, no tell) — the control. **BOT 1** = BOT 0's beat with its HELD hands moved to
  cover the cue (`shoulder` -> high/high; `knees` -> low/low; `foot` -> no back off; `backfoot` / `still` -> unchanged), keeping
  its punches. **BOT 2** = BOT 1, except when `lieHolds(opp, c, 3)` holds (a condition of that man holds and the cap is not
  reached) it plays BOT 0's beat.

## The table (`n=84`, `seed=2`, `v=3`; in brackets: `v3t` = v3 trial `n=12` `seed=1`, `v2` = TELLS2M trial `n=12` `seed=1`)
| bot | against | wins of decided | health he dealt a bout | knockdowns a bout (him / you) | stoppages | his fakes per beat | bluff share | his stamina at the bells (R1 / R2 / R3, of 8) |
|---|---|---|---|---|---|---|---|---|
| BOT 0 no tell | mirror mix | **45%** (37/83, 1d) [v3t 50%; v2 50%] | **21.5** [v3t 24.0; v2 24.0] | **2.40** (1.30/1.11) [v2 2.83 (1.33/1.50)] | **21%** [v3t 25%; v2 25%] | - (no tells) | - | **1.7 / 2.0 / 2.2** [v2 1.6 / 2.3 / 3.1] |
| BOT 0 no tell | Jabber | **87%** (73/84) [v3t 73%; v2 83%] | **16.4** [v3t 17.3; v2 14.8] | **2.62** (2.18/0.44) [v2 2.75 (2.33/0.42)] | **43%** [v3t 42%; v2 **50%**] | **19%** [v3t 16%; v2 29%] | **100%** (277/277) [v3t 34/34] | **2.3 / 2.1 / 2.2** [v2 2.3 / 2.0 / 2.3] |
| BOT 0 no tell | Slugger | **79%** (63/80, 4d) [v3t 75%; v2 83%] | **17.2** [v3t 16.8; v2 15.3] | **2.23** (1.62/0.61) [v2 2.00 (1.42/0.58)] | **23%** [v3t 8%; v2 17%] | **28%** [v3t 27%; v2 **36%**] | **100%** (415/415) [v3t 59/59] | **2.0 / 2.2 / 2.1** [v2 1.2 / 2.3 / 2.8] |
| BOT 0 no tell | Body Snatcher | **61%** (49/81, 3d) [v3t 73%; v2 67%] | **18.5** [v3t 20.3; v2 21.3] | **2.12** (1.34/0.77) [v2 2.75 (1.58/1.17)] | **14%** [v3t 33%; v2 17%] | **15%** [v3t 16%; v2 **9%**] | **100%** (231/231) [v3t 33/33] | **2.1 / 1.9 / 2.0** [v2 2.1 / 3.0 / 2.3] |
| BOT 1 blind | Jabber | **95%** (79/83, 1d) [v3t 75%; v2 83%] | **12.3** [v3t 14.4; v2 16.0] | **2.50** (2.29/0.21) [v2 2.50 (1.92/0.58)] | **50%** [v3t 42%; v2 25%] | **19%** [v3t 17%; v2 **31%**] | **100%** (272/272) [v3t 36/36] | **2.1 / 1.9 / 2.2** [v2 2.3 / 2.7 / 2.0] |
| BOT 1 blind | Slugger | **89%** (73/82, 2d) [v3t 83%; v2 75%] | **15.1** [v3t 15.9; v2 15.9] | **1.92** (1.52/0.39) [v2 1.67 (1.33/0.33)] | **18%** [v3t 17%; v2 17%] | **27%** [v3t 25%; v2 29%] | **100%** (409/409) [v3t 52/52] | **2.3 / 2.0 / 2.0** [v2 2.3 / 2.5 / 2.0] |
| BOT 1 blind | Body Snatcher | **89%** (74/83, 1d) [v3t 100%; v2 100%] | **15.5** [v3t 12.5; v2 15.2] | **2.21** (1.76/0.45) [v2 2.42 (2.08/0.33)] | **24%** [v3t 42%; v2 33%] | **17%** [v3t 16%; v2 **11%**] | **100%** (246/246) [v3t 33/33] | **2.1 / 2.0 / 2.1** [v2 2.1 / 2.1 / 2.3] |
| BOT 2 knows the lie | Jabber | **85%** (70/82, 2d) [v3t 83%; v2 83%] | **14.9** [v3t 14.3; v2 14.6] | **2.26** (1.88/0.38) [v2 2.75 (2.17/0.58)] | **32%** [v3t 33%; v2 **42%**] | **18%** [v3t 15%; v2 24%] | **100%** (263/263) [v3t 32/32] | **2.0 / 2.3 / 2.0** [v2 2.3 / 1.6 / 2.4] |
| BOT 2 knows the lie | Slugger | **86%** (71/83, 1d) [v3t 75%; v2 100%] | **15.7** [v3t 16.9; v2 11.7] | **1.94** (1.52/0.42) [v2 1.75 (1.58/0.17)] | **18%** [v3t 17%; v2 33%] | **28%** [v3t 25%; v2 **38%**] | **100%** (416/416) [v3t 52/52] | **2.1 / 2.2 / 1.9** [v2 1.8 / 2.1 / 2.4] |
| BOT 2 knows the lie | Body Snatcher | **84%** (66/79, 5d) [v3t 91%; v2 100%] | **16.2** [v3t 15.2; v2 13.8] | **2.24** (1.71/0.52) [v2 2.25 (2.08/0.17)] | **29%** [v3t 33%; v2 33%] | **17%** [v3t 16%; v2 **13%**] | **100%** (242/242) [v3t 33/33] | **2.1 / 2.0 / 2.1** [v2 2.1 / 2.6 / 2.1] |

Cue breakdown at `n=84` (BOT 1 bouts) and how his punch landing moved (`BOT 0 -> BOT 1 -> BOT 2`):
- **Jabber**: `shoulder` fake on 272 of 751 shows (36% fake, down from 50% in v2), `knees` 0 of 281, `foot` 0 of 34, `backfoot` 0 of 243, `still` 0 of 101; overall 81% of beats true. His punches landed: `47% -> 39% -> 45%` (Cross `44% -> 22% -> 32%`).
- **Slugger**: `shoulder` fake on 409 of 730 shows (56% fake), `knees` 0 of 391, `foot` 0 of 86, `backfoot` 0 of 92, `still` 0 of 195; overall 73% of beats true. His punches landed: `50% -> 45% -> 44%` (Cross `55% -> 23% -> 26%`).
- **Body Snatcher**: `knees` fake on 246 of 909 shows (27% fake), `shoulder` 0 of 297, `foot` 0 of 71, `backfoot` 0 of 85, `still` 0 of 117; overall 83% of beats true. His punches landed: `49% -> 43% -> 46%` (Cross `51% -> 21% -> 31%`, Body cross `49% -> 42% -> 46%`).
- How often `lieHolds(opp, c, 3)` held across all beats at `n=84`: Jabber `34%`, Slugger `46–47%`, Body Snatcher `48–50%` — about 1.7x to 3x as often as he actually faked (`18–19%`, `27–28%`, `15–17%`).

## The bars (`n=84`, `seed=2`, `v=3` against the `seed=2` BOT 0 control)
- **TELL ALONE IS NOT THE FIGHT (`BOT 1 <= BOT 0 + 5` points of decided, each man): FAIL (0 of 3 at `n=84`).**
  - Jabber: `86.9% -> 95.2%` (**+8.3 points**, FAIL; `v3t` `72.7% -> 75.0%`, +2.3).
  - Slugger: `78.7% -> 89.0%` (**+10.3 points**, FAIL; `v3t` `75.0% -> 83.3%`, +8.3).
  - Body Snatcher: `60.5% -> 89.2%` (**+28.7 points**, FAIL; `v3t` `72.7% -> 100.0%`, +27.3).
- **THE TELL HELPS A LITTLE (`BOT 1` takes less health from him than `BOT 0`, at least 2 of 3 men): PASS (3 of 3).**
  - Jabber: `16.4 -> 12.3` (**-4.1** health a bout). Slugger: `17.2 -> 15.1` (**-2.1**). Body Snatcher: `18.5 -> 15.5` (**-3.0**). (Also 3 of 3 in `v3t`: `-2.9`, `-0.9`, `-7.8`.)
- **FINDING THE LIE PAYS (`BOT 2 >= BOT 1 + 10` points, OR takes `>= 2.0` less health than `BOT 1`, each man): FAIL (0 of 3 at `n=84` and 0 of 3 in `v3t`).**
  - Jabber: win share `85.4%` vs `95.2%` (**-9.8 points**), health taken `14.9` vs `12.3` (**+2.6** more taken) — FAIL.
  - Slugger: win share `85.5%` vs `89.0%` (**-3.5 points**), health taken `15.7` vs `15.1` (**+0.6** more taken) — FAIL.
  - Body Snatcher: win share `83.5%` vs `89.2%` (**-5.6 points**), health taken `16.2` vs `15.5` (**+0.7** more taken) — FAIL.
- **His fakes on 15–30% of beats against every bot: PASS (9 of 9 at `n=84`, and 9 of 9 in `v3t`).**
  - Jabber `19.3 / 19.3 / 18.0%`, Slugger `27.9 / 27.4 / 27.9%`, Body Snatcher `15.4 / 16.6 / 16.5%` (TELLS2M passed only 4 of 9, spanning `9–38%`).
- **Bluff share — real beat did LESS damage than the cue's smallest punch in 100% of fakes: PASS (`100%`, 0 exceptions).**
  - `2,771 of 2,771` fakes across the nine `n=84` pairs and `364 of 364` across the nine `n=12` trial pairs had `planDmg(his, ACT) < cueMinDmg(cue, ACT)` (`< 3` on every fake `shoulder`, `0` on every fake `knees`; `fakeOver = {}` in every file).
- **Stoppages 10–40% in every pair: FAIL in 2 of 10 at `n=84`.**
  - `b0_jabber` is at **43%** (`36/84`) and `b1_jabber` at **50%** (`42/84`); the other 8 pairs sit at `14–32%` (`21%`, `23%`, `14%`, `18%`, `24%`, `32%`, `18%`, `29%`). The no-tell control against the Jabber (`OPPS[0].hp = 15`) already misses this bar on both versions (`50%` in TELLS2M, `43%` here).
- **BOT 0 about 50% against the mirror mix (40–60% of decided): PASS (`45%`, 37 of 83 decided, 1 draw; `50%`, 6 of 12 in `v3t`).**

## Feedback loops, the cap, and stamina at the bells
- **Does v3's cap bring BOT 1 inside its bar? No — it tightened the lie band to 15–28%, which actually helped BOT 1 against the Jabber (`+0` points in v2 trial -> `+8.3` at `n=84`) and the Slugger (`-8` in v2 trial -> `+10.3` at `n=84`), while only trimming the Body Snatcher slightly (`+33` -> `+28.7`).** In v2 a fake `shoulder` could hide a 5–7 damage body/uppercut combination, punishing BOT 1's `high/high` guard; in v3 a fake `shoulder` hides `< 3` damage (at most a 2-damage body shot, or a 1-damage jab that high lead already blocks) and a fake `knees` hides `0` punch damage. So falling for a bluff now costs BOT 1 almost zero extra health on the open line while obeying the 73–83% of cues that are true halves his Cross landing (`44–55% -> 21–23%`).
- **Why BOT 2 trails BOT 1:** `lieHolds` tests only the state condition + cap (`34–50%` of beats), not whether his chosen plan is actually a bluff (`15–28%`), AND `botPlan` reverts to BOT 0 on *every* cue when `lieHolds` holds — throwing away `knees` cues against the Jabber/Slugger (`285/285` and `424/424` true) and `shoulder` cues against the Body Snatcher (`289/289` true). Meanwhile, when a cue really *is* a 0-damage fake, BOT 2 still plays BOT 0's guard mix instead of adding a punch into the empty beat, so catching the bluff wins back nothing for the true cues it discarded.
- **His stamina at the bells (`R1 / R2 / R3` of 8, `n=84` beside TELLS2M's trial):** Jabber `2.0–2.3 / 1.9–2.3 / 2.0–2.2` (v2: `2.3 / 1.6–2.7 / 2.0–2.4`), Slugger `2.0–2.3 / 2.0–2.2 / 1.9–2.1` (v2: `1.2–2.3 / 2.1–2.5 / 2.0–2.8`), Body Snatcher `2.1 / 1.9–2.0 / 2.0–2.1` (v2: `2.1 / 2.1–3.0 / 2.1–2.3`). Every man now lands in a tight `1.9–2.3` band at every bell: capping the Slugger's fakes lifted his R1 bell stamina from `1.2` (`b0` in v2) to `2.0`, and adding fakes to the Body Snatcher trimmed his R2 bell from `3.0` to `1.9–2.0`.

## Is version 3 worth showing on the page, and what to change if not?
1. **Not yet on these bars (4 of 7 pass; `BOT 1 <= BOT 0 + 5`, `BOT 2` payoff, and Jabber stoppages fail), though v3's two targeted rule fixes — the 15–28% fake band (9/9) and the 100% damage-bluff guarantee (2,771/2,771) — hold cleanly.**
2. **Fix BOT 2 in the probe before discarding the lie design:** `botPlan` currently ignores *all* cues whenever `lieHolds` is true (including cues that man never fakes, such as the Body Snatcher's 100%-honest `shoulder` and the Slugger's 100%-honest `knees`) and never converts a held hand into a punch when expecting a 0-damage bluff; gating BOT 2 on `tell.cue === L.cue` and punching on suspected bluffs tests what a real reader actually does.
3. **To bring blind following (`+8 / +10 / +29` points) down near `+5`:** a blind cover needs a real cost — either allow a fake `shoulder` to hide a single 3-damage off-line punch (`dmg <= promise`, never a two-punch 5–7 combo) and give the Body Snatcher an occasional bluff on `shoulder` (or fold more of his non-body beats into `still` instead of a 100%-true `shoulder`), or have non-faked secondary cues fire less deterministically so one button rule cannot block half of every man's Crosses for free.

TELLS3M DONE
