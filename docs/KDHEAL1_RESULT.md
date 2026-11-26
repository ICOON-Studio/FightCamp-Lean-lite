# KDHEAL1 - does a knockdown heal too much? Three get-up numbers measured (S563, measure loop)

The ALLPLAY2 finding (Ziva item 1, Arena item 10): a man dropped comes back on **more** health than he fell with
(1 -> 6 the first time, 2 -> 6), so "the correct play at 1 health is to walk into a punch". Before proposing a rule to
the owner, the balance tool says what lower get-up numbers do to the bars. Measured on `order.html` through
`tools/rules.mjs` with tweak files only - **the page, rules.mjs, balance.mjs and every test are untouched**
(REGRESSION: `rules_test.mjs` 37 passed, `page_play_test.mjs` 4 passed, run before and after the runs).

Method (one run at a time, seed 1, jobs 2): one-rep trial n=12 each on the page's own table; a version whose
stoppages went over 60% is dropped before its full run; the rest get `balance.mjs table tweak=<f> out=<vt>
iters=300 jobs=2`, then `balance.mjs play who=mix opp=mirror n=84 tweak=<f> table=<vt>`, then
`probe_kd_heal.mjs n=84 tweak=<f> table=<vt>` - the same bout loop with each bout written down, for the three
numbers the play output does not give (comeback share, last-round stoppages, both hands on 1-2 health). Same seed,
jobs and n: the probe's bouts are the play run's bouts (checked: the bars' stoppages, knockdowns and ranges match
exactly). Full outputs in `ops/research/s558_balance/results/kd_heal_0..3.txt`; the per-version tables
(`*.vt.json`) were written outside the repo and are not committed. No plain `order.html` control result for
today's page existed in `results/` (the attr files are attribute tweaks, kick/head are other pages), so the control
KD0 was run fresh.

## The table

| Version | N.kd | Bars passed | Each red bar, with its number | Knockdowns a bout | Stoppages | Stopped in the last round | Comeback share |
|---|---|---|---|---|---|---|---|
| KD0 control (today) | 6, 4 | **8 of 9** | Overhand lands 73% (bar 30-65%) | 2.5 (bar top) | 29% PASS | 27% of bouts | **19%** (9 of 48) PASS |
| KD1 | 4, 3 | 7 of 9 | Stoppages **45%** (bar 10-40%), knockdowns 2.8 (bar <= 2.5); Jab lands 73%, Overhand 70% | 2.8 | **45% FAIL** | 43% of bouts | **14%** (5 of 37) FAIL |
| KD2 | 4, 2 | 7 of 9 | Stoppages **44%**, knockdowns 2.8; Body jab lands 66%, Overhand 68% | 2.8 | **44% FAIL** | 38% of bouts | **4%** (1 of 27) FAIL |
| KD3 | 3, 2 | **dropped at trial** | Stoppages **75%** at n=12 (cap 60%) - no full run | 3.2 (trial) | 75% (trial) | not measured | not measured |

Comeback share = the man 4+ health behind after round 1 wins (PUNCHCHANCE1's bar, 15-30%). Bouts that even had
that gap: 48 of 84 at KD0, 37 at KD1, 27 at KD2. On any health gap after round 1 the winner came back 22% / 24% /
23% - the gap in the bar comes from the man behind being stopped before he can use the shorter climb back. Draws
never passed 4%. The Jab/Overhand red bar fails at every version and failed before this task (S558, PUNCHCHANCE1);
it is not this task's.

## The two feedback loops, measured

- **Lower get-up -> more stoppages -> shorter bouts -> fewer rounds to come back: confirmed.** Stoppages 29% ->
  45% -> 44% -> 75% (trial); the stoppage bar (10-40%) breaks first, at [4, 3]. Stoppages before the last round go
  1% -> 2% -> 6%, and a knockdown in the last round decides 27% -> 43% -> 38% of all bouts.
- **Lower get-up -> a man near 0 holds more -> fewer knockdowns: not what the tool measures.** Knockdowns a bout
  went **up**: 2.5 -> 2.8 -> 2.8 -> 3.2 (trial). The mix cannot pay for holding more near 0: `worth()` and the
  value table are health-blind, so a plan's value never sees the get-up number. Each knockdown simply leaves the
  man nearer the next one (up at 4 is closer to 0 than up at 6), so lower get-ups mean more knockdowns and earlier
  third ones. The control already sits on the knockdown bar's top (2.5 of 2.5) with no headroom.

## Does the "walk into a punch at 1 health" pull go away? One line each

The tool does give the beat counts - through the probe (`probe_kd_heal.mjs`), not through `balance.mjs play`
alone (its report and bars have no counts by health; without the probe the answer would have to say so).

- **KD0 [6, 4]:** a man on 1-2 health throws with both hands in **14%** of his low-health beats, **below** the 17%
  he throws over all beats - no wide-open pull at low health, even today.
- **KD1 [4, 3]:** **15%** (vs 17% overall) - no pull, and no change from KD0.
- **KD2 [4, 2]:** **15%** (vs 17% overall) - no pull. Low-health beats themselves rise (9% -> 11% -> 14% of a
  man's beats) because a man is kept nearer 0, not because he plays differently there.
- **KD3 [3, 2]:** not measured (dropped at its trial).

Why no pull shows at any get-up: the bots cannot take the pay Ziva took - the mix and the value table are
health-blind, so "walking into a punch" is never worth points in a plan. The pull is a rule-level exploit for a
human; the tool shows its size through the outcomes above (more knockdowns, more stoppages, more last-round
decisions), not through a behavior shift.

## Which version to propose to the owner

**None. Keep today's [6, 4].** The control is the only version at 8 of 9 bars. Ziva's own suggested fix - get up on
a fixed 4 - is KD1, and it breaks the stoppage bar (45%) and the knockdown bar (2.8) and takes the comeback under
its own bar (14%); KD2 loses the comeback almost entirely (4%); KD3 ends three of four trial bouts early (75%).
On today's page the heal is load-bearing: with knockdowns already at the bar's top, the get-up number is what
keeps bouts inside the stoppage cap.

What it changes for the player, in two plain lines: lower the get-up and a knockdown stops being a second chance
and becomes the end - nearly half of bouts are stopped inside the distance and the man behind on the cards almost
never sees round three with a way back (19% -> 14% -> 4% comebacks). If the owner still wants the "walk into a
punch at 1 health" pay gone, the number to change is not the get-up alone: the shape Ziva and Arena suggest (get
up never on more than you had, no stamina refill) changes the exploit without moving the get-up floor, and should
be measured as its own task on this same loop.

## Files

- Tweak files (owned): `ops/research/s558_balance/kd_heal_1.json`, `kd_heal_2.json`, `kd_heal_3.json` - only
  `N.kd`; `kd_heal_0` is the page as it is, no tweak.
- Results (owned): `ops/research/s558_balance/results/kd_heal_0.txt` .. `kd_heal_3.txt` - trial, table, play and
  probe outputs per version, committed as each finished.
- New probe: `proto/twohands/tools/probe_kd_heal.mjs` - the `balance.mjs play who=mix opp=mirror` bout loop with
  each bout written down (the PUNCHCHANCE1 pattern; `balance.mjs` itself untouched).
- Not committed: the per-version value tables (`/tmp/kdheal1/*.vt.json`, `~17 min` each to build at iters=300
  jobs=2 on this seat).

KDHEAL1 DONE
