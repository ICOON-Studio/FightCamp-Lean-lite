# JUDGES1 result (S444 helper session) - steps 1 and 3 done, step 2 HELD, step 4 not landed

Verdict: the judges' weights are set and pass (a)-(c). BoutRead was NOT given the judges' model: (d) fails on the three
Maria cases (the one Pressure fighter), and the model it needs is bigger than a constant (below). `JudgeNight.DECIDES`
stays `false`; no stills (they come with the switch). Branch `judges1`.

## Step 1 - the weights (scripts/rules/Judges.gd, WEIGHTS + LEAN_MULT only)

Probe `tools/judges_agree_probe.gd -- 30` (Lucy -6 / as signed / +6 x every OPPONENT + MISMATCH + RIVAL, 990 bouts, 897
decisions, BoutNight.play_out). The probe gained `grid` (re-scores the kept decisions on a weight grid with the same card
rule as Judges.score_round) and `dump <file>` (the kept decisions as JSON). The re-scorer reproduces the engine exactly:
S443 weights 92.0 / 8.2 / 3.3 both ways.

| Weights (clean, big, ring, initiative; lean) | (a) 80-90 | (b) < 15 | (c) split 10-25 | majority | unanimous | draw | flip vs rounds-won |
|---|---|---|---|---|---|---|---|
| S443 estimates 1, 2, 1, 1; x2 | 92.0 | 8.2 | 3.3 | 0.3 | 93.8 | 2.6 | 10.7 |
| 0.25, 3, 0.5, 2; x2 | 85.8 | 11.9 | 7.5 | 0.2 | 90.5 | 1.8 | 17.2 |
| 0.25, 3, 0.5, 2; x3 | 86.1 | 11.1 | 10.6 | 0.6 | 87.0 | 1.9 | 15.9 |
| 0.25, 3, 0.5, 2; x4 | 86.1 | 11.4 | 11.3 | 0.9 | 86.2 | 1.7 | 15.7 |
| **0.25, 3, 0.5, 2; x5 = PICK** | **85.9** | **11.6** | **12.3** | 1.1 | 84.7 | 1.9 | 15.8 |
| 0.25, 3, 0.5, 2; x6 | 85.9 | 11.9 | 12.9 | 1.4 | 84.1 | 1.6 | 15.7 |
| 0.35, 5, 0.25, 2; x8 (most splits) | 85.7 | 12.8 | 15.5 | 1.0 | 81.6 | 1.9 | 17.7 |
| 0.25, 4, 2, 0.25; x8 (least matchup shift, below) | 87.4 | 11.2 | 10.7 (60/pairing) | | | | |

Grids tried: (1) 1,125 sets, clean 0.25-1, big 1-3, ring 0.5-4, initiative 0.5-4, lean x1.5-3: 2 pass, both c ~10;
(2) 720 sets, clean 0.1-0.35, big 2-5, ring 0.25-1, initiative 1-3, lean x3-8: 467 pass; (3) lean fixed at x2: 0 of 384
pass (the most splits a x2 lean reaches is 8.1); (4) x3: 13 of 240. A lean must be at least about x3 for (c).

PICK, written in the same ratios with clean = 1: `WEIGHTS {clean 1, big 12, ring 2, initiative 8, work 1}`, `LEAN_MULT 5`.
In the engine: `JUDGES_AGREE (a) ... 85.9 in 100`, `(b) ... 11.6 in 100`, `(c) split 12.3, majority 1.1, unanimous 84.7,
draw 1.9`, `decisions that change hands against the old rounds-won cards: 15.8 in 100`. Held out, 60 bouts a pairing
(1,736 decisions): 86.3 / 11.9 / 12.0. Work keeps its 1:1 with clean; the probe has no pro bout, so work is unmeasured.

TRADE-OFF (for the coordinator / operator): splits need leans that matter, and leans that matter move matchups. With the
pick, the decision win rate per pairing moves rms 0.086 against rounds-won (worst 0.204; Maria -0.076 averaged over the
three shifts). The least-moving passing set (clean 0.25, big 4, ring 2, initiative 0.25, x8) moves rms 0.057 (worst 0.115,
Maria -0.044) but sits at the split band's edge (10.7). Why: Lucy boxes at range and almost never earns initiative
(forward exchanges won at the place she wanted); the rounds she wins on exchanges but loses on the cards flip mostly on the
opponent's initiative (60 a pairing: the opponent out-initiated Lucy in 40 such Maria rounds, 39 Megan, 33 Ellie, against
9 or fewer where she out-landed Lucy; Jade's flip as often on counts and big shots).

FOLLOW-UP when the judges decide: `JudgeNight.LEAN_TIP`, `JudgeCards` (line 53) and `ResultPage` (line 208) say a lean
"counts double"; with LEAN_MULT 5 that must read "five times" (outside this task's OWNS; hidden until DECIDES).

## Step 2 - BoutRead (HELD: (d) fails, model not written)

`tests/bout_read_test.gd`, 500 bouts a case, chance() unchanged:

| Case | chance() | real, judges off | real, judges deciding (pick) | S443 weights, deciding |
|---|---|---|---|---|
| Lucy v Maria | 0.459 | 0.436 ok | **0.296 FAIL** | 0.366 FAIL |
| Lucy v Priya | 0.209 | 0.220 | 0.230 | |
| Lucy v Erin | 0.227 | 0.236 | 0.248 | |
| Lucy v Dana | 0.039 | 0.054 | 0.046 | |
| Lucy -6 v Maria | 0.251 | 0.242 ok | **0.150 FAIL** | 0.178 FAIL |
| Lucy +6 v Erin | 0.505 | 0.526 | 0.542 | 0.570 FAIL |
| Lucy +10 v Dana | 0.301 | 0.312 | 0.318 | |
| Lucy, a plan v Maria | 0.604 | 0.580 ok | **0.432 FAIL** | |
| Lucy, a plan v Priya | 0.407 | 0.426 | 0.444 | 0.498 FAIL |
| tiredness 60 v Priya | 0.132 | 0.132 | 0.136 | |
| Tuesday for Saturday | 0.194 | 0.206 | 0.216 | |

Runs: flag off `BOUT_READ PASS`; `-- judgesdecide` `BOUT_READ FAIL 3` (the three Maria lines). With the pick every
non-Maria case moves 2 in 100 or less; the Maria cases move 10-17 against the reading.

Why it was not written here: chance() would need, per exchange, the chance each side's win is credited as ring (the place
it wanted) and as initiative (a forward step to it), from RingDuel's place walk (mean_edges keeps the place shares but not
the wants or the forward steps); the big shots, which for Lucy are mostly NOT tied to winning the exchange (counter_sense,
plan reads and set-ups: 0.54 a round even in rounds she wins no exchange) and for the opponent are her hurts on Lucy; and
the counts per round (6.0 in 100 rounds on Lucy, 2.4 on the opponent, a count takes the round on every card). Then three
cards of three rounds, panel drawn from the leans. That is a new rule file (BoutRead is 488 of 500 lines) fitted on its own
population with a held-out check - a model task, not a constant, and beyond this helper's budget. Not tuned against the
test; nothing in BoutRead.gd changed.

## Step 3 - re-measure (judges deciding vs today, pick weights)

- `tools/plan_effect_probe.gd -- 300` (Lucy v Maria, same dice): no plan bouts won 33.3% -> 20.7%; good plan 59.7% -> 41.7%
  with rounds won unchanged (54.7%); exchanges won unchanged (44.2 / 51.6). The plan still reads +21 against no plan
  (was +26), but an out-boxer's right plan against a presser wins more rounds than it loses and still loses most bouts.
- Same probe's WHY lines are rounds-won words: with the judges deciding, a "win" can read "Maria ... took rounds 1 and 2"
  (FightWhy/BoutWhy text must read the judges' cards before the switch; outside this task's OWNS).
- `tools/career_harness.gd -- n=20 weeks=26`: careless closes 20% both ways; sensible closes 0% both ways; sensible wins
  6.2 -> 5.3 a career, careless 5.8 -> 5.3; sensible cash end median 15,029 -> 14,661; bout injuries 6 -> 8 (sensible).
- Probe gate (e) / BalanceHarness / ask_bout season probe: not run (budget; the switch is held).

## Step 4 - switch: NOT landed

Held on (d) and on the two text follow-ups above. No stills.

Tests the new weights touch (flag off): `tests/judges_test.gd` had two hand-worked examples computed on the S443 weights
(exact level totals at clean 1 / big 2 / lean x2) and read `JUDGES failures=2`; both examples were re-worked for the new
weights with the same rule under test (a level card falls to the lean, then clean; a lean outweighs a big shot) - no bar
moved - and it reads `JUDGES failures=0` (mutants `_no_mult`, `_no_counts` caught). `file_limits_test`: `FILE_LIMITS
failures=0`. The other REGRESSION tests, flag off, all rc 0 with no script error: `BOUT_RULES checks=65 failures=0`,
`BOUT_STOPPAGE failures=0`, `RESULT_DEFECTS failures=0`, `PLAN_BOUT failures=0`, `ASK_BOUT failures=0`,
`GOLDEN_PATH failures=0`. With `judgesdecide` they were not run (the switch is held).

## What the next round needs (proposal)
1. A taste call: how far may the judges' taste move a matchup? The pick moves an out-boxer v a presser about 8 in 100
   on decisions (14 in the bout_read Maria case); the least-moving passing set halves that at the split band's edge.
2. A judged-round model for chance() in its own file (above), fitted on the probe population, bout_read_test held out.
3. The lean words ("counts five times") and the WHY text reading the judges' cards.
