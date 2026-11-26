# CLINCHFIX3 RESULT - the clinch loop: his habit read sees clinches (S564, probe)

Seat: Arena (cloud, node only). Repo: `ICOON-Studio/FightCamp-Lean-lite`, branch
`arena/67e7800b-fightcamp-lean-lite`. Discipline: boxing (Ring Switches, order.html).
Task: `ops/research/TASK_CLINCHFIX3.md`. Regression: `proto/twohands/tools/rules_test.mjs` 37 passed (page untouched).

## Note on the H0 baseline
`docs/CLINCHFIX2_RESULT.md` and its `results/clinch2_p0*.txt` are **not in this clone** (they were produced on another
seat's branch, `arena/204b98f9`; this checkout has a single squashed commit). H0's **loop** numbers are therefore the
CLINCHFIX2 P0 numbers quoted in `TASK_CLINCHFIX3.md` and confirmed by `ops/research/S563_DIGEST.md`
("CLINCHFIX2 ... P0 8 of 9 both seeds"): **38% / 63% / 70%** against the Jabber / Slugger / Body Snatcher, no-clinch
control **12 / 13 / 7%**, 8 of 9 bars, the one fail being the punch-landing bar (JABLAND1's). H0's **play bars** could
not be reused (the P0 play files are absent), so they were re-measured in-session on the page with the page's own
`vtable.json`. On that re-measure H0 seed 1 scores **7 of 9**: the push off sits exactly on the 3% dead-bar boundary
(prints 3%, is a hair under), which CLINCHFIX2 recorded as passing. The delta is a boundary artefact, not a rule change.

## The loop table (probe_clinch, n=60; `_loop` files)

| version | Jabber | Slugger | Body Snatcher | no-clinch control (J/S/B) |
|---|---|---|---|---|
| H0 (page; CLINCHFIX2 P0, quoted) | 38% | 63% | 70% | 12 / 13 / 7% |
| H1 (clinch in the habit history) | 48% | 57% | 53% | 12 / 13 / 7% |
| H2 (H1 + clinch +1 stamina) | 37% | 58% | 42% | 7 / 12 / 5% |

One-rep trials (n=12) reproduced the task's H1 trial (58 / 33 / 42) before the n=60 runs.

**The loop bar is not met by either version.** It needs the loop under 30% against every man and at least 15 points
under H0 against the Slugger and the Body Snatcher.
- H1: 48 / 57 / 53 - over 30% against all three; only 6 under H0 vs the Slugger, 17 under vs the Body Snatcher.
- H2: 37 / 58 / 42 - over 30% against all three; only 5 under H0 vs the Slugger (needs 15); 28 under vs the Body Snatcher.

## The 9 bars per seed (balance.mjs play, who=mix opp=mirror, n=84)

| version | seed 1 | seed 2 | failing bar(s) |
|---|---|---|---|
| H0 (page) | 7 of 9 | 8 of 9 | seed1: dead switch (push off 3%, boundary) + punch-landing (Jab 70%, Overhand 74%); seed2: punch-landing (Jab 66%, Overhand 71%) |
| H1 | 8 of 9 | 8 of 9 | seed1: punch-landing (Overhand 73%); seed2: punch-landing (Jab 68%, Body jab 66%, Overhand 76%) |
| H2 | 7 of 9 | 8 of 9 | seed1: punch-landing (Jab 67%, Body hook 65%, Overhand 78%) + stoppages/knockdowns (knockdowns >2.5); seed2: punch-landing (Jab 67%, Overhand 79%) |

H1 holds 8 of 9 on both seeds. H2 holds 7 of 9 on seed 1 (the clinch +1 stamina pushes knockdowns just past the 2.5
cap) and 8 of 9 on seed 2. The punch-landing bar fails in every run including H0 - it is the standing JABLAND1 fail,
not something these versions move.

## Clinch and push-off shares in the mirror (% of beats), and clinches a bout

| version | clinch you/he | push off you/he | clinches a bout |
|---|---|---|---|
| H0 seed1 | 5 / 4 | 3 / 3 | 1.1 |
| H0 seed2 | 5 / 4 | 4 / 4 | 1.2 |
| H1 seed1 | 5 / 3 | 3 / 4 | 1.2 |
| H1 seed2 | 6 / 4 | 4 / 4 | 1.2 |
| H2 seed1 | 5 / 4 | 3 / 4 | 1.0 |
| H2 seed2 | 5 / 4 | 3 / 3 | 1.1 |

Both the clinch and the push off stay at or above 3% of beats in every mirror run (the bar CLINCHFIX2 P1/P2 failed),
so the "clinch and push off dead" problem is not reintroduced by either version. The clinch stays a rescue (1.0-1.2 a
bout, under the 2-a-bout bar).

## His habit read against the loop (`readOf` on his plans, `probe_clinch_read.mjs`, n=60)

| version | Jabber | Slugger | Body Snatcher |
|---|---|---|---|
| H1 | 6.5 a bout | 4.3 a bout | 4.6 a bout |
| H2 | 6.1 a bout | 3.9 a bout | 5.4 a bout |

The read does **not** rarely fire - it fires on most Inside beats of the loop (roughly 4-7 times a bout). The mechanism
is live, but it is not sufficient: the loop is still not brought under the bar, and against the Jabber H1 is actually
*worse* than H0 (48% vs 38%). The read answers the repeated step-in/feint habit the loop shows on its punching beats;
the clinch itself does not repeat inside the 3-beat history window (a clinch resets the range to Mid, so it cannot
land on two consecutive Inside beats), so the read is not pointed at the clinch beat the loop depends on. That is the
reading of the rules behind the number; the measured fact is that the read fires often and the loop still wins 37-58%.

## Verdict

**none: H2 is the nearest, and it misses the loop bar** - the loop still wins 37% vs the Jabber (needs <30%), 58% vs
the Slugger (needs <=48%, i.e. 15 under H0's 63%), and 42% vs the Body Snatcher (needs <30%); H2 also holds only 7 of
9 bars on seed 1 (knockdowns past 2.5). H1 is further from the bar (48 / 57 / 53) and is worse than H0 against the
Jabber. Neither version keeps the clinch and the push off alive (both stay >=3% of beats) while taking the loop under
30% against every man.

## Files
- `ops/research/s558_balance/results/clinch3_h1_loop.txt`, `clinch3_h2_loop.txt` (probe n=60, incl. read count)
- `ops/research/s558_balance/results/clinch3_h1.txt` / `_s2.txt`, `clinch3_h2.txt` / `_s2.txt`, `clinch3_h0.txt` / `_s2.txt`
- `proto/twohands/tools/probe_clinch_read.mjs` (read-count copy of probe_clinch, added for the mechanism number)
- `.vt.json` intermediates under `ops/research/s558_balance/vt_clinch3/` (not committed)

CLINCHFIX3 DONE
