# STEPTUNE2 result - the footwork steps' levers, sized against the corrected probe

S527, Qwen on the PC (branch `qwen/steptune2`). Brief: `ops/research/TASK_STEPTUNE2.md`.
Read first: `ops/research/S527_PROBES.md`, `E:/FightCamp/tmp/treevalue3.txt` (the full corrected TREEVALUE3),
`docs/TREEVALUE4_ROLLOUT_PUSHOFF.txt` (roll_out / push_off after the `_swept_first` fix).

## Headline

**`StepEffect.TABLE` is shipped UNCHANGED (`git diff` on it is empty), and the gate stays pass=0/10 -
because the gate cannot be reached from TABLE numbers, and the one lever the map leans on (OPEN) is
invisible to this probe for several steps.** That is a measured and arithmetically demonstrated finding,
not a timeout: three separate blocks sit outside this brief's OWNS.

1. **Eight TABLE keys are read by nothing in the exchange** (audit, s1). The map's BREAK, DISTANCE,
   "wrong cost" and tie-up recovery effects were never wired. Only DENY / DRAIN / own tank / OPEN / the
   ropes counts reach the fight (`StepWire`, S525). `deny_on: ""` makes deny inert for six of the ten.
2. **`StepValue.TARGET`'s wrong style is not `PlanFight.ANSWERS`' wrong answer for six of the ten steps**
   (s2), so no wrong cost fires there and the wrong cell reads ~0 or positive. Fit comes from `ANSWERS`;
   a TABLE number cannot create it.
3. **The probe's plan starves OPEN** (s3). The swept step is planned ANY TIME on its own card and the
   surgery removes the punch lines sharing its `when`, so the next exchange is another step or an
   unplanned instinct - both spend the open for nothing. Measured: `step_in` at open 0.28 gives
   **byte-identical cells, win for win, in all six styles** to open 0.12.

On top of that, the per-fire invariant (s4) shows **all ten three-leg windows are empty**: for eight
steps the best and wrong cells are locked together by their fire rates, and for the two that are not
(step_back, cut_off) the other-style cells lock the best cell out of the 1.5..5 band.

What this round did: audited the wiring, measured the OPEN blind spot, sized three rows and ran the
corrected probe on them, and reverted every change the measurement did not support. Probe time used
~55 min of the 3 h budget; the rest was lost to the PC going RED (s5).

## 1. What the exchange actually reads of TABLE (audit)

`LiveRound.exchange` -> `StepWire.open_edge` (before settle) and `StepWire.levers` (after settle);
`RingDuel.settle` -> `StepWire.after` (the ropes count). Grepped repo-wide (`*.gd`):

| key | read by | effect in the fight |
|---|---|---|
| `deny` x `deny_on` | `StepWire.levers` | removes that share of the opponent's landed punches this exchange. `DENY_SHARE` = all 1.0, power 0.5, head_hooks 0.19. **`deny_on` "" -> share 0 -> deny inert** (step_in, cut_off, herd, feint, tie_up, push_off) |
| `drain` | `StepWire.levers` | `lv["opp_drain"] += drain x BODY_COST 1.2`, read by `RingDuel.opp_energy` |
| `tank` | `StepWire.levers` | `lv["cost"] += tank`, read by `RingDuel.her_energy`. **skipped for tie_up** (its refill is `ClinchRest.REFILL` 1.5) |
| `open` | `levers` sets `lv["open"]`, `open_edge` spends it | the next exchange's **planned PUNCH** line gets `+open x Exchanges.EDGE.best 17`. A step line or an unplanned pick spends it for nothing |
| `ropes`, `opp_ropes`, `clears_ropes` | `StepWire.after` | the ropes count -> the next exchange's card at `ROPES_AT` 3 |
| `open_on` | **nothing** | `open_edge` never reads it: the open goes to ANY next planned punch, not to "inside" / "counter" / "power" |
| `distance` | **nothing** | the next card is `StrikeMap.move().to` / `PlanFight.where_next` |
| `break_to` | **nothing** | the opponent's next game is `Exchanges.next_mode` |
| `ends_early` | **nothing** | the exchange always settles in full; tie_up's "both land half" is not implemented |
| `self_tank` | **nothing** | tie_up's energy back is `ClinchRest.refill` |
| `opp_steps_less` | **nothing** | cut_off's "her step lines fire 30% less" was never wired |
| `opp_counter_edge` | **nothing** | feint's "her counter line fires at -0.10" was never wired |
| `wrong_extra_damage` | **nothing** | step_in's "+20% damage taken when wrong" was never wired |

`StepEffect.scaled` grades deny / open / drain / opp_counter_edge / opp_steps_less / self_tank
(x1.2 / 0.85 / 0.35); `tank` and the ropes counts are not graded. The probe forces OK grade (x0.85).

So the levers a TABLE number can move in this probe are: **deny (step_out, step_back, roll_out only),
drain, own tank, open (only where the plan can spend it), opp_ropes**. The rest is decoration until wired.
Note the probe's own FAIL line still says "Only its ropes count is wired today (StepWire)" - that text is
stale (S525 wired the levers); the measurements do read deny / drain / tank / open.

## 2. The wrong cells: TARGET's wrong style is not ANSWERS' wrong answer

The fight's fit cost comes from `PlanFight.ANSWERS[mode].wrong` for the mode that style mostly plays
(`Exchanges.MODE_V`). `StepValue.TARGET`'s wrong style disagrees with it for six steps:

| step | TARGET wrong style | its main mode | `ANSWERS` fit for the step there | measured wrong cell |
|---|---|---|---|---|
| step_in | Counter-puncher | counter .55 | **ok** (`counter.ok` has step_in) | +0.42 |
| step_out | Counter-puncher | counter .55 | **ok** (`counter.ok` has step_out) | +0.83 |
| step_back | Out-boxer | range .60 | wrong (`range.wrong` has step_back) | -1.58 (target -1.5) |
| pivot_out | Out-boxer | range .60 | **none** (not listed) | 0.00 |
| cut_off | Pressure fighter | press .55 | wrong (`press.wrong` has cut_off) | -1.83 (target -1.5) |
| herd | Pressure fighter | press .55 | wrong (`press.wrong` has herd) | -0.25 (fires only 0.18/bout there) |
| feint | Pressure fighter | press .55 | **none** (not listed) | +1.08 |
| tie_up | Out-boxer | range .60 | **none** at range; **best** at loadup / she_tired / she_hurt, which it still reaches | +2.50 |
| roll_out | Volume puncher | press .45 | **best** (`press.best` has roll_out); there is no "body" mode at all | -0.42 |
| push_off | Out-boxer | range .60 | **none** (not listed) | -0.08 |

The three wrong cells that DO read negative (step_back, cut_off, herd) are exactly the three whose TARGET
wrong style is in `ANSWERS.wrong`. Six can never go negative from TABLE: the step is graded ok / none /
best there, and the map's own wrong-cost lever (`wrong_extra_damage`) is inert.
**Fix (outside OWNS): align `StepValue.TARGET`'s wrong styles with `PlanFight.ANSWERS`, or wire
`wrong_extra_damage` in `StepWire.levers` when `PlanFight.fit` says wrong.**

## 3. OPEN is unspendable for step_in in this probe (MEASURED)

`step_in` is `outside -> long`. Its swept plan (`_plan_for` drops the other `when: "range"` arrows,
`2-3` and `1-2-3b`, both `long -> mid`) is:

```
["step_in", "step_back", "pivot_out", "tie_up", "roll_out:loadup", "push_off:press", "1-1-2:press",
 "1-6-3:counter", "slip 2-3:loadup", "3b-3:tiring", "feint:counter", "cut_off:tiring", "herd:hurt",
 "step_out:she_tired"]
```

After step_in fires, the next exchange is on `long` (it won) or `GAME_CARD` / `LOST_CARD` (it lost):
- `long`: the only arrows there are `cut_off:tiring` and `step_out:she_tired` - both STEPS. Every other
  pick is her instinct (`planned: false`). `open_edge` returns 0 for both.
- `outside` (lost to a counter): `step_in` fires again (a step); `1-1-2:press` only matches press, and a
  loss to press goes to `own_ropes` (`LOST_CARD`), where `pivot_out` (a step) fires.
- `mid` / `inside` / `own_ropes`: every arrow there is a step or a defence.

No reachable next exchange has a planned PUNCH to spend step_in's open. `PlanBoard.pick` confirms the
order (a `when`-matched arrow beats the card's any-time arrow; there is none here). Measurement agrees -
open 0.12 -> 0.28 changed nothing, cell for cell, win for win (sweep A, `only=step_in,cut_off,feint`):

| style | TREEVALUE3 (open 0.12) | sweep A (open 0.28) |
|---|---|---|
| Pressure fighter | 549 / 548, +0.08, seeds [0.0, 0.25, 0.0] | 549 / 548, +0.08, seeds [0.0, 0.25, 0.0] |
| Slugger | 540 / 540, +0.00, seeds [0.25, 0.25, -0.5] | 540 / 540, +0.00, seeds [0.25, 0.25, -0.5] |
| Out-boxer | 542 / 534, +0.67, seeds [0.25, 0.75, 1.0] | 542 / 534, +0.67, seeds [0.25, 0.75, 1.0] |
| Counter-puncher | 589 / 584, +0.42, seeds [0.0, 0.25, 1.0] | 589 / 584, +0.42, seeds [0.0, 0.25, 1.0] |
| Volume puncher | 547 / 544, +0.25, seeds [0.25, 0.0, 0.5] | 547 / 544, +0.25, seeds [0.25, 0.0, 0.5] |
| Boxer-puncher | 541 / 537, +0.33, seeds [0.25, 0.5, 0.25] | 541 / 537, +0.33, seeds [0.25, 0.5, 0.25] |

(with / without wins over 1,200 bouts a cell.) The same card arithmetic says where the open CAN be spent:
- **cut_off** (`long -> opp_ropes`): its plan KEEPS `2-3:range` and `1-2-3b:range`, so a loss to `range`
  (Out-boxer, .60 of her games) lands on a planned punch at long -> spent. A loss to `loadup` spends it
  on `slip 2-3` at mid. This is the one far-from-target step whose open the probe can read.
- **pivot_out / step_back**: no `when` to surgery, so the whole plan stays and the open reaches mid/long
  punches. pivot_out's measured per-fire worth (~0.47 at open 0.08) is consistent with a spent open.
- **feint** (`outside -> outside`): spends only when the game is press (`1-1-2:press`) - its WRONG style.
  Against Counter-punchers the surgery removes `1-6-3:counter`, feint re-fires any-time, and the open is
  wasted: its +3.33 best cell is FIT, not open.
- **push_off** (`clinch -> mid`): the surgery removes `1-1-2:press` (the press punch at mid); it spends
  only on loadup / counter / tiring - about a quarter of its fires vs Pressure.

**Consequence: TREEVALUE2 under-measures OPEN, the lever the map leans on for step_in / feint / push_off.
Fix (outside OWNS): in `tools/treevalue_probe.gd` keep a punch line on the swept step's destination card
(or plan the step for its situation instead of ANY TIME); or in `StepWire.open_edge` do not spend the
open on a step line. Until then an open size for those three cannot be read from these cells.**

## 4. What TABLE numbers can reach: the per-fire invariant

A step's cell against style s is `cell_s = base_s + F_s x L`: `F_s` = fires/bout (measured), `L` = the
per-fire lever package (deny / drain / tank / open), `base_s` = the fit / fallback / ropes part TABLE
cannot touch. For any two styles the combination

```
I(s,r) = cell_s - (F_s / F_r) x cell_r  =  base_s - (F_s / F_r) x base_r
```

is an INVARIANT - no TABLE number changes it. The gate needs `I(best,wrong) > 1.5` (because
`cell_best = I + (F_b/F_w) x cell_wrong < I` when the wrong cell is negative), and for every other style
`I(best,other) >= 1.5 - F_best/F_other`. From the measured cells (TREEVALUE3 + TREEVALUE4):

| step | best | wrong | I(best,wrong) | >1.5? | the block on the others cap |
|---|---|---|---|---|---|
| step_in | Out-boxer | Counter-puncher | +0.415 | no | others reachable, but only via an open the probe cannot spend (s3) |
| step_out | Slugger | Counter-puncher | -0.598 | no | best is its WEAKEST cell; Out-boxer +1.42 / Boxer +1.67 already over the cap |
| step_back | Pressure | Out-boxer | +5.960 | yes | I(P,S)=+0.34 < 0.50 (same fires 2.16): P>=1.5 forces S>=1.16. I(P,C)=+5.78: C>=0 forces P>=5.78 > 5 |
| pivot_out | Pressure | Out-boxer | +1.330 | no | I(P,S)=+0.22 < 0.67 (Slugger fires MORE: 3.40 vs 2.83) |
| cut_off | Out-boxer | Pressure | +2.073 | yes | I(O,C)=-0.73 < 0.36: C<=1 forces O<=0.41. I(O,V)=-2.41: V>=0 forces O>=2.29 |
| herd | Volume | Pressure | +0.361 | no | fires 0.13-0.26/bout: best>=1.5 needs open ~1.27, more than a best call's whole edge |
| feint | Counter-puncher | Pressure | -1.422 | no | fires 5.06 vs Counter, 1.15 vs Pressure: a cost that hurts P hurts C 4.4x more |
| tie_up | Slugger | Out-boxer | -0.038 | no | every lever it has is inert or a benefit; no cost exists to lower O |
| roll_out | Slugger | Volume | +0.070 | no | I(S,P)=-0.67 < 1.00 (Pressure fires 2.43 vs Slugger 1.22): P<=1 forces S<=-0.17 |
| push_off | Pressure | Out-boxer | +0.128 | no | fires 0.83 vs 0.52 with base_O ~ 0: best>=1.5 forces O>=+0.86 |

**All ten three-leg windows are empty.** The largest reachable leg subset per step and the per-fire lever
window `dL` (wins in 100 per fire) that reaches it:

| step | legs now | most reachable | dL window | what it would take |
|---|---|---|---|---|
| step_in | others (1) | best+others | [+0.748, +0.870] | open 0.27-0.29 IF the open could be spent (it cannot, s3) |
| step_out | none (0) | wrong | (-inf, -0.615] | a per-fire COST: tank ~2.5+ (a four-punch combo costs 1.2) - not defensible |
| step_back | best+wrong (2) | best+wrong | [-1.005, +0.616] | already inside it; no third leg exists |
| pivot_out | none (0) | wrong | (-inf, 0.0) | open below 0.08 (0.04 predicted: Out-boxer ~ -0.2) |
| cut_off | wrong (1) | best+wrong | [+1.549, +2.056] | open 0.31-0.41 at FULL spend, more at partial spend |
| herd | wrong (1) | best+others | [+5.769, +5.783] | open ~1.27 - not defensible |
| feint | best (1) | best+others | [-0.362, -0.256] | open 0.048-0.069 IF the open were spent vs Out-boxer (it is not, s3) |
| tie_up | best (1) | wrong | (-inf, -1.453] | a cost lever it does not have (tank skipped, self_tank inert) |
| roll_out | wrong (1) | wrong | (-inf, +0.262] | already inside it |
| push_off | wrong+others (2) | best+others | [+1.807, +2.000] | open ~0.38 at full spend; it spends ~a quarter -> ~1.5 |

Caveat, stated plainly: the invariant treats `L` as style-independent. deny / drain / tank act on the
firing exchange and are close to uniform; OPEN is not (its spend chance depends on the next card and
game, s3), so the open-driven windows are optimistic. deny could also differ by style (a Slugger's
stoppages), which is the one experiment left worth running (s7). The measured cells are the authority.

## 5. Per step: old -> new numbers, cells before and after

Before = the corrected full table: `E:/FightCamp/tmp/treevalue3.txt` for the eight steps whose plans the
`_swept_first` fix does not reorder (their swept card carries no other any-time arrow), and
`docs/TREEVALUE4_ROLLOUT_PUSHOFF.txt` for roll_out / push_off. 1,200 bouts a cell per arm (400 x 3 seed
sets), Sharp 60, OK grade, calibrated opponents (52.89 / 55.95 / 54.24 / 53.29 / 53.02 / 52.64 - sweep A
reproduced them exactly). Legs: B = best in 1.5..5, W = wrong < 0, O = others 0..1.

| step | best cell | wrong cell | other cells (P / S / O / C / V / B, best+wrong omitted) | legs |
|---|---|---|---|---|
| step_in | Out-boxer +0.67 | Counter +0.42 | +0.08 / 0.00 / - / - / +0.25 / +0.33 | O (1) |
| step_out | Slugger +0.25 | Counter +0.83 | +0.75 / - / +1.42 / - / +0.50 / +1.67 | none (0) |
| step_back | Pressure +3.67 | Out-boxer -1.58 | - / +3.33 / - / -0.83 / +2.42 / -0.83 | B+W (2) |
| pivot_out | Pressure +1.33 | Out-boxer 0.00 | - / +1.33 / - / +0.17 / +1.08 / +0.17 | none (0) |
| cut_off | Out-boxer -0.25 | Pressure -1.83 | - / -0.83 / - / +0.42 / -2.67 / -0.92 | W (1) |
| herd | Volume 0.00 | Pressure -0.25 | - / -0.17 / -0.17 / -0.33 / - / -0.33 | W (1) |
| feint | Counter +3.33 | Pressure +1.08 | - / +0.50 / +1.50 / - / +0.50 / +0.83 | B (1) |
| tie_up | Slugger +1.75 | Out-boxer +2.50 | +3.17 / - / - / +1.17 / +2.50 / +2.50 | B (1) |
| roll_out | Slugger -0.25 | Volume -0.42 | +0.83 / - / -0.75 / -0.25 / - / -0.75 | W (1) |
| push_off | Pressure 0.00 | Out-boxer -0.08 | - / 0.00 / - / +0.08 / 0.00 / 0.00 | W+O (2) |

10 of 30 legs, pass 0/10. **After = the same table: every number shipped is the number above.**

### The three rows sized this round, and what the probe said

| row | sized to | why that size | measured | shipped |
|---|---|---|---|---|
| step_in `open` | 0.12 -> 0.28 | the best+others window is open 0.270-0.294 at k_open ~5 (s4); 0.28 sits in it | **INERT**: all six cells byte-identical to 0.12 (s3) - the plan never spends its open | **0.12** (reverted) |
| cut_off `open` | 0.0 -> 0.33 | the best+wrong window is dL +1.55..+2.06 -> open 0.31-0.41 at full spend; its plan keeps the long-card punches so the open IS spendable vs Out-boxer | **NOT MEASURED**: sweep A reached cut_off, then the PC went RED (RAM 99%) and the probe stalled 14+ min on its first cell; its own 55-min timeout ended the run before any cut_off CELL printed | **0.0** (reverted - an unmeasured number is what STEPTUNE1 shipped, and it was not taken) |
| feint `open` | 0.12 -> 0.06 | the best+others window is open 0.048-0.069 | **NOT REACHED** (sweep A ended during cut_off). Card arithmetic says it would only lower the Pressure cell - its WRONG style - and leave Counter / Out-boxer untouched | **0.12** (reverted: lowering it tunes to the probe's blind spot, not to the step's real worth) |

Sweep A command (its log: `E:/FightCamp/tmp/steptune2/runA.log`):

```
python ops/Tools/godot_slot.py run --who qwen -- <godot> --headless --audio-driver Dummy --fixed-fps 60 \
  --path . --script res://tools/treevalue_probe.gd -- only=step_in,cut_off,feint
```

It printed the OK-grade control (10/10 OK), the calibration (identical to TREEVALUE3/4), the determinism
control (204 wins / 861 fires twice) and all six step_in cells, then stalled in cut_off. No
`TREEVALUE2 done pass=` line was printed - the run did not finish, and a filtered run writes no doc.

### Left alone, with the reason (no probe time spent on a proven no-gain)

- **herd** - fires 0.13-0.26 a bout (it needs the opp_ropes card). Best +2.0 would need open ~1.27, more
  than a best call's whole edge. Its wrong cell already reads negative; no defensible number adds a leg.
- **tie_up** - every lever in its row is inert or a benefit: `tank` is skipped for tie_up in
  `StepWire.levers`, `self_tank` / `ends_early` / `break_to` are read by nothing, `deny_on` is "" so deny
  is 0, and open / drain / opp_ropes only help. Its +2.50 wrong cell is ClinchRest's refill plus fit
  (best at loadup / she_tired / she_hurt, which it reaches against every style). No TABLE number can
  lower it; it needs a wired cost first.
- **step_out** - its best style (Slugger +0.25) is its WEAKEST cell, and Out-boxer +1.42 / Boxer +1.67
  already break the others cap. I(best,wrong) = -0.60. The only reachable leg (wrong) needs a per-fire
  cost of ~0.6 wins, i.e. tank ~2.5+ on the map's scale where a four-punch combo costs 1.2 - not a
  defensible price for a lateral step.
- **step_back** - already on target for best (+3.67 vs +3.5) and wrong (-1.58 vs -1.5). The others cap is
  unreachable: Slugger fires exactly as often as Pressure (2.16 both) and sits 0.34 below it, so P>=1.5
  forces S>=1.16; and Counter -0.83 cannot reach 0 without P>=5.78, over the +5 cap.
- **push_off** - Claude's call was an open with open_on "any". **Declined on the arithmetic, not swept.**
  It fires 0.83 vs Pressure and 0.52 vs Out-boxer with base_O ~ 0, so I(best,wrong) = +0.128 caps its
  best cell at +0.13 while the wrong cell stays negative; best+others needs dL +1.8..2.0 = open ~0.38 at
  FULL spend, and its card spends only on loadup / counter / tiring (the surgery removes `1-1-2:press`).
  At a quarter spend that is open ~1.5. Any open big enough to matter lifts its Out-boxer cell positive
  and loses the wrong leg it has today. Its row stays drain 0.3 / tank 0.4 / open 0.
- **roll_out** - the corrected probe fires it (1.2-2.4 a bout) and its worth is -0.8..+0.8. I(S,P) = -0.67
  against a needed +1.00: Pressure fires twice as often as Slugger, so any per-fire lift raises Pressure
  past the others cap before Slugger reaches the band. Its deny 0.4 / open 0.10 stay; the one experiment
  worth running is deny 0.8 to test whether deny is style-dependent (s7).
- **pivot_out** - I(best,wrong) = +1.33 < 1.5 and I(P,S) = +0.22 < 0.67: best unreachable. Its one
  reachable leg (wrong) needs open below 0.08; 0.04 is the next cheap experiment (s7), predicted
  Out-boxer ~ -0.2, Slugger ~ +0.5, Volume ~ +0.6, but Counter / Boxer go slightly negative.

## 6. Tests

The shipped `StepEffect.gd` is byte-identical to HEAD (`git diff -- scripts/rules/StepEffect.gd` empty),
so the runs below are runs of the shipped code. No test number needed updating: no pinned value moved
(`step_effect_test` pins step_back deny 0.35 / tie_up self_tank 0.8 / feint opp_counter_edge -0.1;
`step_levers_test` pins roll_out deny 0.4 and open 0.1 - all unchanged).

- `tests/step_effect_test.gd` -> `STEP_EFFECT PASS fails=0`
- `tests/step_levers_test.gd` -> `STEP_LEVERS failures=0`
- `tests/golden_path_test.gd` (REGRESSION) -> `GOLDEN_PATH failures=0` (bout 1 WIN 29-28 x3, bout 2 WIN,
  twelve weeks, day 84, $13,691, rank 2)
- `tools/treevalue_probe.gd` (RED_TEST) -> **no `TREEVALUE2 done pass=` line**: sweep A was ended by its
  own timeout while stalled in cut_off under PC RED. The gate stands at pass=0/10 on the shipped table
  (the before table in s5 is the corrected measurement of exactly these numbers).

A confirmation re-run of the three tests was queued against the shipped table
(`E:/FightCamp/tmp/steptune2/tests_final.log`); at the time of writing it was waiting at place 4 with
slots 0 (RED, commit ~20 GB free, RAM 99%, the owner's game holding 9 GB). It has its own timeouts and
will end by itself. Nothing was killed: the stalled probe was left to its own timeout, and no Godot
process of another job was touched.

## 7. Resume here (the next round's cheap experiments, in order)

The wiring fixes come first - without them the gate is unreachable (s4) and OPEN is unreadable (s3).
Once one of them lands, these are the sweeps worth the time (each ~12-25 min on a GREEN PC):

1. `cut_off` open 0.33 (then 0.45 / 0.6 if the Out-boxer cell undershoots): the only far-from-target step
   whose open this plan can spend. Window: best+wrong at dL +1.55..+2.06. Alternative wired lever:
   `opp_ropes` 1 -> 2 (two cut-offs trap her instead of three).
   `-- only=cut_off`
2. `roll_out` deny 0.4 -> 0.8 (open stays 0.10): tests whether deny is style-dependent enough to break
   the I(S,P) lock - a Slugger's stoppage risk is the one place deny could pay more than its fire rate.
   `-- only=roll_out`
3. `pivot_out` open 0.08 -> 0.04: the only remaining leg gain on the current wiring (wrong cell negative).
   `-- only=pivot_out`
4. After `wrong_extra_damage` is wired: `step_in` (its Counter cell is the target -2.5 and the code grades
   it ok there) and `feint` (Pressure). After tie_up gets a wired cost: its Out-boxer cell.

Reproduce the gate: `python ops/Tools/godot_slot.py run --who qwen -- <godot> --headless --audio-driver
Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd` (full run ~126 min on a GREEN PC;
`-- only=a,b` sweeps just those steps and prints no doc).

## 8. What would actually unlock the gate (outside this brief's OWNS)

1. `PlanFight.ANSWERS` / `StepValue.TARGET`: make the wrong style wrong in the code (six steps, s2), or
   wire `wrong_extra_damage` in `StepWire.levers` on a wrong fit.
2. `StepWire`: wire the map's missing effects - `opp_steps_less` (cut_off), `opp_counter_edge` (feint),
   `ends_early` / `self_tank` (tie_up), `distance` / `break_to`, and honour `open_on`. tie_up needs a
   wired COST before its wrong cell can be sized at all.
3. `tools/treevalue_probe.gd`: let the swept step's open reach a punch (s3). Until then TREEVALUE2
   measures fit + deny + drain + tank + ropes, and OPEN is invisible for step_in / feint / push_off.
4. `StepValue.TARGET` vs the fire rates: several targets ask a step to be worth +2.5..4 against a style
   it fires LESS often in than against the styles capped at +1 (pivot_out vs Slugger, roll_out vs
   Pressure, feint vs Counter, step_back vs Slugger). With per-fire levers those targets are
   arithmetically out of reach (s4); they need style-aware effects or revised targets.
5. The probe's stale FAIL text ("Only its ropes count is wired today") should be corrected - S525 wired
   the levers, and the text misdirects the next tuning round.
