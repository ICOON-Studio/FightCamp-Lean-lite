# GUARDPROBE8 - guard v7: does a guard line cost a move line? (S535)

Brief: `ops/research/TASK_GUARDPROBE8.md`. Probe: `tools/guardprobe8.gd` (measurement only, nothing under scripts/ edited). Two runs on
2026-11-21, both through `godot_slot.py`, 200 bouts a cell and arm, 12 cells, paired seeds 6000-6199. This page is the two generated
result pages under one summary (run A: `-- n=200`; run B: `-- n=200 plan=best`; each run in parts, then `merge=`).

## VERDICT: FAIL - the trade does not exist. A guard line costs no move line, because a four-line plan has only one or two lines that do anything.

`RESULT: tools/guardprobe8.gd -> worth=PASS(8/12) notworth=FAIL(1/12) single=FAIL(9/12) -> FAIL` (run A, the written plans: the pre-registered run)
`RESULT: tools/guardprobe8.gd -> worth=PASS(9/12) notworth=FAIL(0/12) single=PASS(6/12) -> FAIL` (run B, the best plan the boxer can fire)

The bar was: a swap beats the four-move plan by 3+ wins in 100 in at least 3 cells AND loses by 3+ in at least 3; no plan best in more than 7 of 12.

- **The line limit is real but only on the screens.** A new coach holds 4 lines (`PlanBoard.arrow_limit`, PlanBoard.gd 15-16); `GamePlan.gd`
  367-369 refuses a fifth. The bout itself never checks (`BoutNight.gd` 193 stores the number, `LiveRound.gd` 96 copies every line).
  Both runs put the coach at rating 30 so that four lines is a FULL plan (probe 7's rating-60 coach had three lines free).
- **Swapping the weakest move line for a guard line costs nothing.** Mean cost of the slot (the line swapped in, against the same line
  added as a fifth): -0.4 wins in 100 in run A, -0.1 in run B. Dropping the weakest line with nothing in its place moves the win rate by
  0.5 in 100 or less in 8 of 12 cells (A) and 10 of 12 (B); in most of those not one bout of 200 changes (sd 0.0).
- **Why: the plans are mostly dead lines.** Run A, the written plans of probes 6 and 7: `pivot_out`, `tie_up` and `cut_off` change
  nothing when dropped (0.0 with sd 0.0 in every cell they are in): these boxers have not drilled those steps, so the lines never fire
  (`FireLevel`: under 30 a line cannot be planned; `Data.fighter_state` 267-269: a signed boxer starts with step in and step out only).
  Run B was added for that reason, after seeing run A (so it is NOT pre-registered; the bars are the same): the plan is picked one line
  at a time, on the pilot's own seeds, from every line the boxer can do and fire (11 to 14 lines, any time or WHEN a moment it is a best
  answer to). The first line adds 2 to 8 wins in 100, the second 0 to 3, the third and fourth nothing in 11 of 12 cells. On the test's
  seeds the best plan is no better than the written one (mean 40.0 against 39.5 wins in 100).
- **So a guard line is always taken.** With the weakest line given up, a right guard line is 3+ up in 8 (A) and 9 (B) cells and 3+
  down in 1 and 0. Bar 3 fails in A (High WHEN loading up best in 9 of 12) and passes in B (6 / 5 / 1): WHICH guard line is still a
  choice; WHETHER to carry one is not.
- **Only giving up the plan's one live line hurts.** Every swap of the 144 (4 move lines x 3 guard lines x 12 cells): 43 (A) and 44 (B)
  are 3+ up, 11 and 8 are 3+ down, and the losers are the plan's first combination line (`1-1`, `1-2`) in 10 of 11 (A) and 6 of 8 (B;
  the other two are its second combination line, `1-2 WHEN range`). No player would give that line up, so it is a mistake to avoid
  once, not a trade to weigh every bout.
- **The wrong guard line still costs:** High WHEN at range in the free slot loses 3+ in 6 of 12 cells in both runs (-8.5 at worst).
- Self-checks, both runs: the probe's walk = `BoutNight.play_out` in 120 of 120 bouts; the copied guard walk differs by 0.000000; run
  A's BASE column is probe 7's NORMAL column to the decimal in all 12 cells.

### What this means for the v7 map (not built here)
- v7 section 0 says "a guard line takes one of the coach's plan lines, so it is paid for with a move line". Measured: the price is 0.
  The map does not go to critics on this result (the brief: critics only on PASS).
- The limit of 4 prices nothing for ANY line today, not only the guard: a third and a fourth move line add nothing either. That is a
  finding about the plan, older than the guard.
- A guard line needs a price that binds. Candidates for the next revision, none measured: it must be drilled like a step (its own bar,
  it does not fire under 30, so it costs pad nights); or it REPLACES the plan's move in the exchange it fires in (cover or punch, not
  both - today its points are added on top of the move's); or the trade is probed again on a later-career boxer with five or more
  drilled lines and a five-line coach, where a full plan may really be full.
- Not measured here: a read share under 1.00, the corner minute's change, boxers with more drilled lines than these three.

---

# RUN B - the best four-line plan the boxer can fire (added after run A; same bars)

Run: python ops/Tools/godot_slot.py run --who guardprobe8 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe8.gd -- n=200 plan=best (run in parts, part=k/m out=, then merge=)
Seeds 6000-6199, 200 bouts a cell and arm, 12 cells (4 opponent types x amateur 3 / pro 4 / pro 6 rounds), the same seeds for every arm, so every
difference is PAIRED: its sd is in brackets beside it (wins in 100). Measurement only: scripts/ not edited. The guard line is probe 7's local rule,
sizes step s1 ([9.0, 9.0, 8.0, 8.0]), read right every time (read share 1.00).

### The line limit (the game has a hard one, on the plan screens)

- `PlanBoard.arrow_limit` (scripts/rules/PlanBoard.gd 15-16): 4 lines for a new coach, +1 per 12 rating, 9 at most. `StyleName.limit` (StyleName.gd 114-115): a named style adds one, to 7 at most.
- Enforced where the plan is written: `GamePlan.gd` 367-369 refuses a line over the limit ("The plan is full: this coach teaches N lines"), `PlanBoard.validate` 31-32 names it.
- NOT enforced in the bout: `BoutNight.gd` 193 only stores the limit (the corner change reads it, 201) and `LiveRound.gd` 96 copies every written line. A plan over the limit would fight as written; only the screens stop it.
- This probe: coach rating 30.0 = limit 4 (probe 7 ran a rating-60 coach = 7 lines, so its three guard lines were free). Limit by format here: am3: 4, pro4: 4, pro6: 4.
  Nothing else in the bout reads the coach's rating. BASE here is the best-plan arm, so it is not probe 7's NORMAL column (run A's is).

### Population (probe 7's, unchanged)

Ours: amateur 3 = Lucy (60 kg), pro 4 = Tess (75 kg), pro 6 = Danny (90 kg), stats jittered +/-3 by the seed, each on the best four lines he or she can fire against that opponent type (the table below).
Opponents at our paper rating, three different generated boxers a type, taken in turn by seed (never two identical fighters).

| type | # | style | generator seed | punch at rating 60 | pace | forward | heart |
|---|---|---|---|---|---|---|---|
| light_presser | 1 | Pressure fighter | 88 | 44.8 | 63 | 84 | 57 |
| light_presser | 2 | Pressure fighter | 190 | 43.5 | 74 | 69 | 76 |
| light_presser | 3 | Pressure fighter | 236 | 45.2 | 66 | 79 | 50 |
| heavy_presser | 1 | Pressure fighter | 299 | 78.7 | 66 | 67 | 36 |
| heavy_presser | 2 | Slugger | 315 | 78.1 | 44 | 72 | 59 |
| heavy_presser | 3 | Pressure fighter | 626 | 78.3 | 72 | 83 | 48 |
| counter | 1 | Counter-puncher | 1 | 58.5 | 35 | 35 | 60 |
| counter | 2 | Counter-puncher | 2 | 61.0 | 18 | 20 | 32 |
| counter | 3 | Counter-puncher | 3 | 54.0 | 26 | 42 | 59 |
| volume | 1 | Volume puncher | 1 | 49.3 | 75 | 67 | 69 |
| volume | 2 | Volume puncher | 2 | 54.3 | 95 | 60 | 70 |
| volume | 3 | Volume puncher | 3 | 64.3 | 80 | 54 | 86 |

Self-check 1: the probe's walk with every guard size off reproduces BoutNight.play_out in 120 of 120 bouts. Self-check 2: the copied guard walk against the game's, max |diff| = 0.000000.

### The best four-line plan (picked one line at a time on the pilot's seeds, from every line the boxer can do and fire)

| cell | lines to pick from | no plan | + line 1 | + line 2 | + line 3 | + line 4 |
|---|---|---|---|---|---|---|
| am3 light_presser | 14 | 60.0 | 1-1 = 64.0 | step_in WHEN range = 64.0 | 1-1 WHEN loadup = 64.0 | 1-1 WHEN press = 64.0 |
| am3 heavy_presser | 14 | 63.0 | 1-1 = 65.0 | step_in = 67.0 | 1-2 WHEN range = 68.0 | step_in WHEN range = 68.0 |
| am3 counter | 14 | 32.0 | 1-1 = 40.0 | 1-2 WHEN range = 43.0 | step_in WHEN range = 43.0 | 1-1 WHEN loadup = 43.0 |
| am3 volume | 14 | 54.0 | 1-1 = 59.0 | 1-2 WHEN range = 62.0 | step_in = 62.0 | step_in WHEN range = 62.0 |
| pro4 light_presser | 14 | 16.0 | 1-1 = 21.0 | 1-2 WHEN range = 24.0 | step_in WHEN range = 24.0 | 1-1 WHEN loadup = 24.0 |
| pro4 heavy_presser | 14 | 36.0 | 1-1 = 39.0 | 1-2 WHEN range = 41.0 | step_in WHEN range = 41.0 | 1-1 WHEN loadup = 41.0 |
| pro4 counter | 14 | 12.0 | 1-1 = 14.0 | step_in = 15.0 | step_in WHEN range = 15.0 | 1-1 WHEN loadup = 15.0 |
| pro4 volume | 14 | 21.0 | 1-1 = 28.0 | 1-2 WHEN range = 31.0 | step_in WHEN range = 31.0 | 1-1 WHEN loadup = 31.0 |
| pro6 light_presser | 11 | 56.0 | 2-3 = 58.0 | step_out WHEN she_tired = 59.0 | step_in = 59.0 | step_in WHEN range = 59.0 |
| pro6 heavy_presser | 11 | 74.0 | 1-2 = 76.0 | step_in WHEN range = 76.0 | 1-2 WHEN range = 76.0 | step_out WHEN she_tired = 76.0 |
| pro6 counter | 11 | 20.0 | 1-2 = 22.0 | step_in WHEN range = 23.0 | 1-2 WHEN range = 23.0 | step_out WHEN she_tired = 23.0 |
| pro6 volume | 11 | 54.0 | 2-3 = 58.0 | step_in WHEN range = 58.0 | 2-3 WHEN range = 58.0 | step_out WHEN she_tired = 58.0 |

### The pilot: which move line is the weakest (seeds 9000-9099, its own, never the test's)

Wins in 100 with that one move line dropped and nothing in its place, against the four moves. The line that costs least to drop is the one given up.

| cell | four moves | line 1 dropped | line 2 dropped | line 3 dropped | line 4 dropped | given up |
|---|---|---|---|---|---|---|
| am3 light_presser | 64.0 | 1-1 -1.0 | step_in WHEN range +0.0 | 1-1 WHEN loadup +0.0 | 1-1 WHEN press +0.0 | step_in WHEN range |
| am3 heavy_presser | 68.0 | 1-1 -3.0 | step_in -2.0 | 1-2 WHEN range -1.0 | step_in WHEN range +0.0 | step_in WHEN range |
| am3 counter | 43.0 | 1-1 -7.0 | 1-2 WHEN range -3.0 | step_in WHEN range +0.0 | 1-1 WHEN loadup +0.0 | step_in WHEN range |
| am3 volume | 62.0 | 1-1 -4.0 | 1-2 WHEN range -3.0 | step_in +0.0 | step_in WHEN range +0.0 | step_in |
| pro4 light_presser | 24.0 | 1-1 -6.0 | 1-2 WHEN range -3.0 | step_in WHEN range +0.0 | 1-1 WHEN loadup +0.0 | step_in WHEN range |
| pro4 heavy_presser | 41.0 | 1-1 -4.0 | 1-2 WHEN range -2.0 | step_in WHEN range +0.0 | 1-1 WHEN loadup +0.0 | step_in WHEN range |
| pro4 counter | 15.0 | 1-1 -2.0 | step_in -1.0 | step_in WHEN range +0.0 | 1-1 WHEN loadup +0.0 | step_in WHEN range |
| pro4 volume | 31.0 | 1-1 -4.0 | 1-2 WHEN range -3.0 | step_in WHEN range +0.0 | 1-1 WHEN loadup +0.0 | step_in WHEN range |
| pro6 light_presser | 59.0 | 2-3 -3.0 | step_out WHEN she_tired -2.0 | step_in +0.0 | step_in WHEN range +0.0 | step_in |
| pro6 heavy_presser | 76.0 | 1-2 +0.0 | step_in WHEN range +0.0 | 1-2 WHEN range +0.0 | step_out WHEN she_tired +0.0 | 1-2 |
| pro6 counter | 23.0 | 1-2 +0.0 | step_in WHEN range -1.0 | 1-2 WHEN range +0.0 | step_out WHEN she_tired +0.0 | 1-2 |
| pro6 volume | 58.0 | 2-3 +0.0 | step_in WHEN range +0.0 | 2-3 WHEN range +0.0 | step_out WHEN she_tired +0.0 | 2-3 |

### The trade: the weakest move line swapped for one guard line (wins in 100 against the four-move plan; sd of the paired difference in brackets)

| cell | today (CONTROL) | four moves (BASE) | given up | dropped, nothing in its place | High WHEN loading up | Loose WHEN tiring | High WHEN your boxer is hurt | wrong: High WHEN at range | best plan |
|---|---|---|---|---|---|---|---|---|---|
| am3 light_presser | 51.5 | 51.5 | step_in WHEN range | +0.0 (0.0) | +5.0 (1.5) | +4.5 (1.5) | +0.5 (0.5) | -1.5 (1.1) | High WHEN loading up |
| am3 heavy_presser | 57.0 | 57.0 | step_in WHEN range | +0.0 (0.0) | +4.5 (1.8) | +3.5 (1.3) | +0.0 (0.7) | -0.5 (0.5) | High WHEN loading up |
| am3 counter | 39.0 | 39.0 | step_in WHEN range | +0.0 (0.0) | +2.5 (1.1) | +3.0 (1.4) | +0.5 (0.5) | -3.5 (1.5) | Loose WHEN tiring |
| am3 volume | 52.5 | 52.5 | step_in | +0.5 (0.5) | +2.0 (1.6) | +3.0 (1.2) | +1.5 (0.9) | -4.5 (1.8) | Loose WHEN tiring |
| pro4 light_presser | 22.5 | 24.5 | step_in WHEN range | -0.5 (0.5) | +3.0 (1.6) | +2.0 (1.2) | -0.5 (0.5) | -3.0 (1.2) | High WHEN loading up |
| pro4 heavy_presser | 32.5 | 33.0 | step_in WHEN range | +0.0 (0.0) | +4.5 (1.9) | +0.0 (1.4) | +1.0 (0.7) | -1.0 (1.0) | High WHEN loading up |
| pro4 counter | 16.5 | 17.0 | step_in WHEN range | +0.0 (0.0) | +2.5 (1.1) | +1.5 (0.9) | +0.0 (0.0) | -2.5 (1.1) | High WHEN loading up |
| pro4 volume | 33.5 | 33.0 | step_in WHEN range | +0.0 (0.0) | +0.5 (1.1) | +1.0 (1.2) | +1.5 (0.9) | -5.0 (1.7) | High WHEN your boxer is hurt |
| pro6 light_presser | 43.0 | 42.5 | step_in | +1.5 (0.9) | +5.0 (2.1) | +7.0 (1.9) | +2.5 (1.1) | +0.0 (1.4) | Loose WHEN tiring |
| pro6 heavy_presser | 55.0 | 55.5 | 1-2 | -0.5 (0.5) | +3.0 (1.9) | +2.0 (1.6) | +1.0 (1.2) | +0.0 (0.7) | High WHEN loading up |
| pro6 counter | 26.5 | 25.5 | 1-2 | -1.0 (0.7) | +1.5 (1.5) | +3.0 (1.6) | +0.0 (1.0) | -4.5 (1.8) | Loose WHEN tiring |
| pro6 volume | 49.0 | 49.5 | 2-3 | -0.5 (0.5) | -1.0 (1.0) | +2.5 (1.3) | +1.0 (1.2) | -8.5 (2.0) | Loose WHEN tiring |

By guard line, over the 12 cells (the weakest move line given up): cells 3+ up / cells 3+ down / mean.
- High WHEN loading up: 6 up, 0 down, mean +2.7.
- Loose WHEN tiring: 6 up, 0 down, mean +2.8.
- High WHEN your boxer is hurt: 0 up, 0 down, mean +0.8.

### What the slot costs: the same guard line ADDED as a fifth line (over the limit) against SWAPPED for the weakest move line

| cell | High WHEN loading up added | swapped | the slot costs | Loose WHEN tiring added | swapped | the slot costs | High WHEN your boxer is hurt added | swapped | the slot costs |
|---|---|---|---|---|---|---|---|---|---|
| am3 light_presser | +5.0 | +5.0 | +0.0 (0.0) | +4.5 | +4.5 | +0.0 (0.0) | +0.5 | +0.5 | +0.0 (0.0) |
| am3 heavy_presser | +4.5 | +4.5 | +0.0 (0.0) | +3.5 | +3.5 | +0.0 (0.0) | +0.0 | +0.0 | +0.0 (0.0) |
| am3 counter | +2.5 | +2.5 | +0.0 (0.0) | +3.0 | +3.0 | +0.0 (0.0) | +0.5 | +0.5 | +0.0 (0.0) |
| am3 volume | +1.5 | +2.0 | +0.5 (0.5) | +2.5 | +3.0 | +0.5 (0.5) | +1.0 | +1.5 | +0.5 (0.5) |
| pro4 light_presser | +3.5 | +3.0 | -0.5 (0.5) | +2.0 | +2.0 | +0.0 (0.0) | +0.0 | -0.5 | -0.5 (0.5) |
| pro4 heavy_presser | +4.5 | +4.5 | +0.0 (0.0) | +0.0 | +0.0 | +0.0 (0.0) | +1.0 | +1.0 | +0.0 (0.0) |
| pro4 counter | +2.5 | +2.5 | +0.0 (0.0) | +1.5 | +1.5 | +0.0 (0.0) | +0.0 | +0.0 | +0.0 (0.0) |
| pro4 volume | +0.5 | +0.5 | +0.0 (0.0) | +1.0 | +1.0 | +0.0 (0.0) | +1.5 | +1.5 | +0.0 (0.0) |
| pro6 light_presser | +5.0 | +5.0 | +0.0 (0.7) | +6.0 | +7.0 | +1.0 (0.7) | +1.0 | +2.5 | +1.5 (0.9) |
| pro6 heavy_presser | +4.0 | +3.0 | -1.0 (0.7) | +2.5 | +2.0 | -0.5 (0.5) | +1.0 | +1.0 | +0.0 (0.0) |
| pro6 counter | +2.5 | +1.5 | -1.0 (0.7) | +4.0 | +3.0 | -1.0 (0.7) | +1.0 | +0.0 | -1.0 (0.7) |
| pro6 volume | -1.0 | -1.0 | +0.0 (0.7) | +3.0 | +2.5 | -0.5 (0.5) | +1.0 | +1.0 | +0.0 (0.7) |

Mean cost of the slot (swapped minus added), the weakest move line: -0.1 wins in 100.

### Every swap: each of the four move lines given up for each guard line (wins in 100 against the four-move plan)

A player who does not know which move line is the weakest gives up one of these. 'drop' = that move line dropped, nothing in its place.

| cell | move line | drop | High WHEN loading up | Loose WHEN tiring | High WHEN your boxer is hurt |
|---|---|---|---|---|---|
| am3 light_presser | 1 1-1 | -0.5 (0.5) | +4.5 (1.6) | +4.0 (1.4) | +0.0 (0.7) |
| am3 light_presser | 2 step_in WHEN range (weakest) | +0.0 (0.0) | +5.0 (1.5) | +4.5 (1.5) | +0.5 (0.5) |
| am3 light_presser | 3 1-1 WHEN loadup | +0.0 (0.0) | +5.0 (1.5) | +4.5 (1.5) | +0.5 (0.5) |
| am3 light_presser | 4 1-1 WHEN press | +0.0 (0.0) | +5.0 (1.5) | +4.5 (1.5) | +0.5 (0.5) |
| am3 heavy_presser | 1 1-1 | -1.5 (0.9) | +4.5 (1.9) | +1.5 (1.5) | -1.0 (1.0) |
| am3 heavy_presser | 2 step_in | +0.0 (0.0) | +4.5 (1.8) | +3.5 (1.3) | +0.5 (0.9) |
| am3 heavy_presser | 3 1-2 WHEN range | -0.5 (0.5) | +4.5 (1.8) | +2.5 (1.3) | -0.5 (0.9) |
| am3 heavy_presser | 4 step_in WHEN range (weakest) | +0.0 (0.0) | +4.5 (1.8) | +3.5 (1.3) | +0.0 (0.7) |
| am3 counter | 1 1-1 | -2.5 (1.3) | +0.0 (1.6) | -1.5 (1.7) | -2.5 (1.3) |
| am3 counter | 2 1-2 WHEN range | -1.5 (0.9) | +2.0 (1.2) | -0.5 (1.3) | -1.0 (1.0) |
| am3 counter | 3 step_in WHEN range (weakest) | +0.0 (0.0) | +2.5 (1.1) | +3.0 (1.4) | +0.5 (0.5) |
| am3 counter | 4 1-1 WHEN loadup | +0.0 (0.0) | +2.5 (1.1) | +3.0 (1.4) | +0.5 (0.5) |
| am3 volume | 1 1-1 | -5.5 (1.6) | -3.0 (2.0) | -4.0 (1.7) | -5.0 (1.7) |
| am3 volume | 2 1-2 WHEN range | -0.5 (0.5) | +1.0 (1.6) | +1.5 (1.1) | +0.5 (0.9) |
| am3 volume | 3 step_in (weakest) | +0.5 (0.5) | +2.0 (1.6) | +3.0 (1.2) | +1.5 (0.9) |
| am3 volume | 4 step_in WHEN range | +0.0 (0.0) | +1.5 (1.5) | +2.5 (1.1) | +1.0 (0.7) |
| pro4 light_presser | 1 1-1 | -5.5 (1.6) | -1.0 (2.1) | -3.0 (2.0) | -5.5 (1.6) |
| pro4 light_presser | 2 1-2 WHEN range | -0.5 (1.1) | +2.5 (1.8) | +1.5 (1.5) | -0.5 (1.1) |
| pro4 light_presser | 3 step_in WHEN range (weakest) | -0.5 (0.5) | +3.0 (1.6) | +2.0 (1.2) | -0.5 (0.5) |
| pro4 light_presser | 4 1-1 WHEN loadup | +0.0 (0.0) | +3.5 (1.5) | +2.0 (1.2) | +0.0 (0.0) |
| pro4 heavy_presser | 1 1-1 | -2.5 (1.3) | +3.5 (2.2) | -3.0 (1.9) | -1.0 (1.2) |
| pro4 heavy_presser | 2 1-2 WHEN range | +0.5 (0.9) | +3.0 (1.9) | +0.5 (1.7) | +0.5 (1.1) |
| pro4 heavy_presser | 3 step_in WHEN range (weakest) | +0.0 (0.0) | +4.5 (1.9) | +0.0 (1.4) | +1.0 (0.7) |
| pro4 heavy_presser | 4 1-1 WHEN loadup | +0.0 (0.0) | +4.5 (1.9) | +0.0 (1.4) | +1.0 (0.7) |
| pro4 counter | 1 1-1 | -2.0 (1.2) | -1.0 (1.6) | -1.0 (1.2) | -2.0 (1.2) |
| pro4 counter | 2 step_in | +0.5 (0.5) | +3.0 (1.2) | +3.0 (1.2) | +0.5 (0.5) |
| pro4 counter | 3 step_in WHEN range (weakest) | +0.0 (0.0) | +2.5 (1.1) | +1.5 (0.9) | +0.0 (0.0) |
| pro4 counter | 4 1-1 WHEN loadup | +0.0 (0.0) | +2.5 (1.1) | +1.5 (0.9) | +0.0 (0.0) |
| pro4 volume | 1 1-1 | -1.5 (1.3) | -0.5 (1.5) | -1.5 (1.5) | -1.0 (1.4) |
| pro4 volume | 2 1-2 WHEN range | -4.0 (1.7) | -4.0 (1.8) | -3.5 (1.9) | -2.5 (1.8) |
| pro4 volume | 3 step_in WHEN range (weakest) | +0.0 (0.0) | +0.5 (1.1) | +1.0 (1.2) | +1.5 (0.9) |
| pro4 volume | 4 1-1 WHEN loadup | +0.0 (0.0) | +0.5 (1.1) | +1.0 (1.2) | +1.5 (0.9) |
| pro6 light_presser | 1 2-3 | +0.5 (1.1) | +6.0 (2.2) | +6.0 (1.8) | +1.5 (1.3) |
| pro6 light_presser | 2 step_out WHEN she_tired | +0.5 (0.5) | +5.0 (2.1) | +6.5 (1.9) | +1.5 (0.9) |
| pro6 light_presser | 3 step_in (weakest) | +1.5 (0.9) | +5.0 (2.1) | +7.0 (1.9) | +2.5 (1.1) |
| pro6 light_presser | 4 step_in WHEN range | +0.0 (0.0) | +5.0 (2.1) | +6.0 (1.8) | +1.0 (0.7) |
| pro6 heavy_presser | 1 1-2 (weakest) | -0.5 (0.5) | +3.0 (1.9) | +2.0 (1.6) | +1.0 (1.2) |
| pro6 heavy_presser | 2 step_in WHEN range | +0.0 (0.0) | +3.5 (1.6) | +2.5 (1.5) | +1.0 (1.2) |
| pro6 heavy_presser | 3 1-2 WHEN range | +0.0 (0.0) | +4.0 (1.7) | +2.5 (1.5) | +1.0 (1.2) |
| pro6 heavy_presser | 4 step_out WHEN she_tired | +0.0 (0.0) | +3.5 (1.8) | +2.5 (1.5) | +1.0 (1.2) |
| pro6 counter | 1 1-2 (weakest) | -1.0 (0.7) | +1.5 (1.5) | +3.0 (1.6) | +0.0 (1.0) |
| pro6 counter | 2 step_in WHEN range | -0.5 (0.5) | +2.5 (1.3) | +3.5 (1.5) | +1.0 (0.7) |
| pro6 counter | 3 1-2 WHEN range | +0.0 (0.0) | +2.5 (1.3) | +4.0 (1.4) | +1.0 (0.7) |
| pro6 counter | 4 step_out WHEN she_tired | -0.5 (0.5) | +2.0 (1.2) | +3.5 (1.5) | +0.5 (0.9) |
| pro6 volume | 1 2-3 (weakest) | -0.5 (0.5) | -1.0 (1.0) | +2.5 (1.3) | +1.0 (1.2) |
| pro6 volume | 2 step_in WHEN range | +0.0 (0.0) | -1.0 (1.0) | +3.0 (1.4) | +1.0 (1.0) |
| pro6 volume | 3 2-3 WHEN range | +0.0 (0.0) | -1.0 (1.0) | +3.0 (1.4) | +1.0 (1.0) |
| pro6 volume | 4 step_out WHEN she_tired | -0.5 (0.5) | -1.5 (1.1) | +3.0 (1.4) | +0.5 (1.1) |

Of the 144 swaps: 44 are 3+ up, 8 are 3+ down. Cells with at least one swap 3+ up: 11 of 12; with at least one 3+ down: 4 of 12.
A move line picked blind (the mean over the four): a guard line loses 3+ in 0 of 12 cells.

### Bars (written in the probe before the run: the weakest move line, by the pilot, is the one given up)

- Bar 1, a guard line is worth its slot: some swap beats the four-move plan by 3+ wins in 100 in at least 3 cells: 9 of 12 = PASS.
- Bar 2, and not everywhere: some swap loses to the four-move plan by 3+ in at least 3 cells: 0 of 12 = FAIL.
- Bar 3, no single plan (the four moves or one of the three swaps) best in more than 7 of 12 cells: { "High WHEN loading up": 6, "Loose WHEN tiring": 5, "High WHEN your boxer is hurt": 1 } (most: High WHEN loading up, 6 of 12) = PASS.
- Not bars, said beside them: cells where EVERY right swap loses 3+ (no guard line is worth the slot): 0 of 12. Swaps of the 36 that are 3+ up and at least 2 sd: 9; 3+ down and at least 2 sd: 0.
- The wrong swap (High WHEN at range for the weakest move line) loses 3+ in 6 of 12 cells.
- BASE against today's game (CONTROL): worst cell 2.0 in 100 apart (the worn-guard edge is the only difference).

RESULT: tools/guardprobe8.gd -> worth=PASS(9/12) notworth=FAIL(0/12) single=PASS(6/12) -> FAIL

(the parts took 3671 s of Godot time together)

---

# RUN A - the written four-move plans of probes 6 and 7 (the pre-registered run)

Run: python ops/Tools/godot_slot.py run --who guardprobe8 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe8.gd -- n=200 (run as two parts, part=k/2 out=, then merge=)
Seeds 6000-6199, 200 bouts a cell and arm, 12 cells (4 opponent types x amateur 3 / pro 4 / pro 6 rounds), the same seeds for every arm, so every
difference is PAIRED: its sd is in brackets beside it (wins in 100). Measurement only: scripts/ not edited. The guard line is probe 7's local rule,
sizes step s1 ([9.0, 9.0, 8.0, 8.0]), read right every time (read share 1.00).

### The line limit (the game has a hard one, on the plan screens)

- `PlanBoard.arrow_limit` (scripts/rules/PlanBoard.gd 15-16): 4 lines for a new coach, +1 per 12 rating, 9 at most. `StyleName.limit` (StyleName.gd 114-115): a named style adds one, to 7 at most.
- Enforced where the plan is written: `GamePlan.gd` 367-369 refuses a line over the limit ("The plan is full: this coach teaches N lines"), `PlanBoard.validate` 31-32 names it.
- NOT enforced in the bout: `BoutNight.gd` 193 only stores the limit (the corner change reads it, 201) and `LiveRound.gd` 96 copies every written line. A plan over the limit would fight as written; only the screens stop it.
- This probe: coach rating 30.0 = limit 4 (probe 7 ran a rating-60 coach = 7 lines, so its three guard lines were free). Limit by format here: am3: 4, pro4: 4, pro6: 4.
  Nothing else in the bout reads the coach's rating, so BASE here must equal probe 7's NORMAL column: it does, in all 12 cells, to the decimal.

### Population (probe 7's, unchanged)

Ours: amateur 3 = Lucy (60 kg), pro 4 = Tess (75 kg), pro 6 = Danny (90 kg), stats jittered +/-3 by the seed, each on guard_probe.gd's written four-move plan.
Opponents at our paper rating, three different generated boxers a type, taken in turn by seed (never two identical fighters).

| type | # | style | generator seed | punch at rating 60 | pace | forward | heart |
|---|---|---|---|---|---|---|---|
| light_presser | 1 | Pressure fighter | 88 | 44.8 | 63 | 84 | 57 |
| light_presser | 2 | Pressure fighter | 190 | 43.5 | 74 | 69 | 76 |
| light_presser | 3 | Pressure fighter | 236 | 45.2 | 66 | 79 | 50 |
| heavy_presser | 1 | Pressure fighter | 299 | 78.7 | 66 | 67 | 36 |
| heavy_presser | 2 | Slugger | 315 | 78.1 | 44 | 72 | 59 |
| heavy_presser | 3 | Pressure fighter | 626 | 78.3 | 72 | 83 | 48 |
| counter | 1 | Counter-puncher | 1 | 58.5 | 35 | 35 | 60 |
| counter | 2 | Counter-puncher | 2 | 61.0 | 18 | 20 | 32 |
| counter | 3 | Counter-puncher | 3 | 54.0 | 26 | 42 | 59 |
| volume | 1 | Volume puncher | 1 | 49.3 | 75 | 67 | 69 |
| volume | 2 | Volume puncher | 2 | 54.3 | 95 | 60 | 70 |
| volume | 3 | Volume puncher | 3 | 64.3 | 80 | 54 | 86 |

Self-check 1: the probe's walk with every guard size off reproduces BoutNight.play_out in 120 of 120 bouts. Self-check 2: the copied guard walk against the game's, max |diff| = 0.000000.

### The pilot: which move line is the weakest (seeds 9000-9099, its own, never the test's)

Wins in 100 with that one move line dropped and nothing in its place, against the four moves. The line that costs least to drop is the one given up.

| cell | four moves | line 1 dropped | line 2 dropped | line 3 dropped | line 4 dropped | given up |
|---|---|---|---|---|---|---|
| am3 light_presser | 68.0 | 1-1 -9.0 | step_back -4.0 | pivot_out +0.0 | tie_up +0.0 | pivot_out |
| am3 heavy_presser | 64.0 | 1-1 -2.0 | step_back +1.0 | pivot_out +0.0 | tie_up +0.0 | step_back |
| am3 counter | 41.0 | 1-1 -8.0 | step_back -1.0 | pivot_out +0.0 | tie_up +0.0 | pivot_out |
| am3 volume | 61.0 | 1-1 -7.0 | step_back -2.0 | pivot_out +0.0 | tie_up +0.0 | pivot_out |
| pro4 light_presser | 17.0 | 1-2 +0.0 | step_in +0.0 | cut_off +0.0 | tie_up +0.0 | 1-2 |
| pro4 heavy_presser | 37.0 | 1-2 +0.0 | step_in +1.0 | cut_off +0.0 | tie_up +0.0 | step_in |
| pro4 counter | 14.0 | 1-2 -1.0 | step_in -1.0 | cut_off +0.0 | tie_up +0.0 | cut_off |
| pro4 volume | 25.0 | 1-2 -2.0 | step_in +1.0 | cut_off +0.0 | tie_up +0.0 | step_in |
| pro6 light_presser | 58.0 | 2-3 -2.0 | feint +0.0 | pivot_out +0.0 | 1-2 +0.0 | feint |
| pro6 heavy_presser | 75.0 | 2-3 +1.0 | feint -2.0 | pivot_out +0.0 | 1-2 +0.0 | 2-3 |
| pro6 counter | 20.0 | 2-3 +1.0 | feint +0.0 | pivot_out +0.0 | 1-2 +0.0 | 2-3 |
| pro6 volume | 59.0 | 2-3 -3.0 | feint -1.0 | pivot_out +0.0 | 1-2 +0.0 | pivot_out |

### The trade: the weakest move line swapped for one guard line (wins in 100 against the four-move plan; sd of the paired difference in brackets)

| cell | today (CONTROL) | four moves (BASE) | given up | dropped, nothing in its place | High WHEN loading up | Loose WHEN tiring | High WHEN your boxer is hurt | wrong: High WHEN at range | best plan |
|---|---|---|---|---|---|---|---|---|---|
| am3 light_presser | 54.5 | 54.5 | pivot_out | +0.0 (0.0) | +5.0 (1.8) | +3.5 (1.3) | +0.5 (0.5) | -2.0 (1.2) | High WHEN loading up |
| am3 heavy_presser | 61.0 | 61.0 | step_back | -4.5 (1.8) | +0.5 (2.2) | -1.5 (1.9) | -4.0 (2.0) | -5.0 (2.0) | High WHEN loading up |
| am3 counter | 37.5 | 37.5 | pivot_out | +0.0 (0.0) | +3.5 (1.3) | +1.5 (1.1) | +0.5 (0.5) | -2.0 (1.4) | High WHEN loading up |
| am3 volume | 53.0 | 53.0 | pivot_out | +0.0 (0.0) | +3.5 (1.6) | +3.5 (1.3) | +1.5 (0.9) | -5.0 (1.8) | High WHEN loading up, Loose WHEN tiring |
| pro4 light_presser | 17.5 | 19.0 | 1-2 | -2.0 (1.0) | +4.5 (1.5) | +2.0 (1.4) | -2.0 (1.0) | -4.0 (1.4) | High WHEN loading up |
| pro4 heavy_presser | 28.5 | 29.0 | step_in | +1.5 (0.9) | +4.5 (1.9) | +0.0 (1.4) | +3.0 (1.2) | +1.0 (1.0) | High WHEN loading up |
| pro4 counter | 16.0 | 16.5 | cut_off | +0.0 (0.0) | +1.0 (1.4) | +0.5 (0.9) | +0.0 (0.0) | -2.5 (1.3) | High WHEN loading up |
| pro4 volume | 31.5 | 31.0 | step_in | +0.0 (0.0) | +1.5 (0.9) | +0.5 (1.1) | +0.5 (0.5) | -5.5 (1.8) | High WHEN loading up |
| pro6 light_presser | 44.5 | 44.5 | feint | +0.0 (0.7) | +3.0 (2.3) | +5.5 (1.8) | +1.0 (1.0) | -1.5 (1.3) | Loose WHEN tiring |
| pro6 heavy_presser | 54.5 | 55.0 | 2-3 | +0.5 (0.5) | +3.5 (1.8) | +2.5 (1.6) | +1.5 (1.3) | +0.5 (0.5) | High WHEN loading up |
| pro6 counter | 23.5 | 24.0 | 2-3 | -1.5 (1.1) | +2.0 (1.6) | +2.5 (1.8) | +0.0 (1.2) | -4.5 (1.6) | Loose WHEN tiring |
| pro6 volume | 49.5 | 49.0 | pivot_out | +0.0 (0.0) | -1.0 (1.0) | +3.5 (1.5) | +1.0 (1.0) | -8.5 (2.0) | Loose WHEN tiring |

By guard line, over the 12 cells (the weakest move line given up): cells 3+ up / cells 3+ down / mean.
- High WHEN loading up: 7 up, 0 down, mean +2.6.
- Loose WHEN tiring: 4 up, 0 down, mean +2.0.
- High WHEN your boxer is hurt: 1 up, 1 down, mean +0.3.

### What the slot costs: the same guard line ADDED as a fifth line (over the limit) against SWAPPED for the weakest move line

| cell | High WHEN loading up added | swapped | the slot costs | Loose WHEN tiring added | swapped | the slot costs | High WHEN your boxer is hurt added | swapped | the slot costs |
|---|---|---|---|---|---|---|---|---|---|
| am3 light_presser | +5.0 | +5.0 | +0.0 (0.0) | +3.5 | +3.5 | +0.0 (0.0) | +0.5 | +0.5 | +0.0 (0.0) |
| am3 heavy_presser | +2.5 | +0.5 | -2.0 (1.6) | +4.0 | -1.5 | -5.5 (1.8) | +0.5 | -4.0 | -4.5 (1.8) |
| am3 counter | +3.5 | +3.5 | +0.0 (0.0) | +1.5 | +1.5 | +0.0 (0.0) | +0.5 | +0.5 | +0.0 (0.0) |
| am3 volume | +3.5 | +3.5 | +0.0 (0.0) | +3.5 | +3.5 | +0.0 (0.0) | +1.5 | +1.5 | +0.0 (0.0) |
| pro4 light_presser | +4.5 | +4.5 | +0.0 (0.7) | +3.0 | +2.0 | -1.0 (1.0) | +0.0 | -2.0 | -2.0 (1.0) |
| pro4 heavy_presser | +3.5 | +4.5 | +1.0 (0.7) | -0.5 | +0.0 | +0.5 (0.5) | +2.0 | +3.0 | +1.0 (0.7) |
| pro4 counter | +1.0 | +1.0 | +0.0 (0.0) | +0.5 | +0.5 | +0.0 (0.0) | +0.0 | +0.0 | +0.0 (0.0) |
| pro4 volume | +1.5 | +1.5 | +0.0 (0.0) | +0.5 | +0.5 | +0.0 (0.0) | +0.5 | +0.5 | +0.0 (0.0) |
| pro6 light_presser | +3.0 | +3.0 | +0.0 (0.7) | +5.0 | +5.5 | +0.5 (0.5) | +1.0 | +1.0 | +0.0 (0.7) |
| pro6 heavy_presser | +3.0 | +3.5 | +0.5 (0.5) | +3.0 | +2.5 | -0.5 (0.5) | +1.5 | +1.5 | +0.0 (0.0) |
| pro6 counter | +2.5 | +2.0 | -0.5 (0.9) | +3.0 | +2.5 | -0.5 (1.3) | +1.5 | +0.0 | -1.5 (1.1) |
| pro6 volume | -1.0 | -1.0 | +0.0 (0.0) | +3.5 | +3.5 | +0.0 (0.0) | +1.0 | +1.0 | +0.0 (0.0) |

Mean cost of the slot (swapped minus added), the weakest move line: -0.4 wins in 100.

### Every swap: each of the four move lines given up for each guard line (wins in 100 against the four-move plan)

A player who does not know which move line is the weakest gives up one of these. 'drop' = that move line dropped, nothing in its place.

| cell | move line | drop | High WHEN loading up | Loose WHEN tiring | High WHEN your boxer is hurt |
|---|---|---|---|---|---|
| am3 light_presser | 1 1-1 | -6.0 (1.8) | -2.0 (1.9) | -2.0 (2.0) | -5.5 (1.9) |
| am3 light_presser | 2 step_back | -3.0 (1.6) | +2.0 (2.0) | +1.5 (2.1) | -2.5 (1.6) |
| am3 light_presser | 3 pivot_out (weakest) | +0.0 (0.0) | +5.0 (1.8) | +3.5 (1.3) | +0.5 (0.5) |
| am3 light_presser | 4 tie_up | +0.0 (0.0) | +5.0 (1.8) | +3.5 (1.3) | +0.5 (0.5) |
| am3 heavy_presser | 1 1-1 | -5.5 (1.8) | -0.5 (2.3) | -2.0 (2.1) | -4.5 (1.9) |
| am3 heavy_presser | 2 step_back (weakest) | -4.5 (1.8) | +0.5 (2.2) | -1.5 (1.9) | -4.0 (2.0) |
| am3 heavy_presser | 3 pivot_out | +0.0 (0.0) | +2.5 (1.9) | +4.0 (1.4) | +0.5 (0.9) |
| am3 heavy_presser | 4 tie_up | +0.0 (0.0) | +2.5 (1.9) | +4.0 (1.4) | +0.5 (0.9) |
| am3 counter | 1 1-1 | -4.0 (1.6) | -0.5 (1.7) | -3.5 (1.8) | -4.0 (1.6) |
| am3 counter | 2 step_back | +0.0 (0.0) | +3.5 (1.3) | +1.0 (1.0) | +0.5 (0.5) |
| am3 counter | 3 pivot_out (weakest) | +0.0 (0.0) | +3.5 (1.3) | +1.5 (1.1) | +0.5 (0.5) |
| am3 counter | 4 tie_up | +0.0 (0.0) | +3.5 (1.3) | +1.5 (1.1) | +0.5 (0.5) |
| am3 volume | 1 1-1 | -9.5 (2.3) | -7.0 (2.4) | -6.5 (2.4) | -8.5 (2.3) |
| am3 volume | 2 step_back | -0.5 (1.7) | +1.0 (1.9) | +1.5 (1.8) | +0.5 (1.8) |
| am3 volume | 3 pivot_out (weakest) | +0.0 (0.0) | +3.5 (1.6) | +3.5 (1.3) | +1.5 (0.9) |
| am3 volume | 4 tie_up | +0.0 (0.0) | +3.5 (1.6) | +3.5 (1.3) | +1.5 (0.9) |
| pro4 light_presser | 1 1-2 (weakest) | -2.0 (1.0) | +4.5 (1.5) | +2.0 (1.4) | -2.0 (1.0) |
| pro4 light_presser | 2 step_in | +0.0 (0.0) | +4.0 (1.4) | +2.5 (1.1) | +0.0 (0.0) |
| pro4 light_presser | 3 cut_off | +0.0 (0.0) | +4.5 (1.5) | +3.0 (1.2) | +0.0 (0.0) |
| pro4 light_presser | 4 tie_up | +0.0 (0.0) | +4.5 (1.5) | +3.0 (1.2) | +0.0 (0.0) |
| pro4 heavy_presser | 1 1-2 | +1.5 (1.1) | +4.0 (1.8) | +0.5 (1.7) | +1.5 (1.1) |
| pro4 heavy_presser | 2 step_in (weakest) | +1.5 (0.9) | +4.5 (1.9) | +0.0 (1.4) | +3.0 (1.2) |
| pro4 heavy_presser | 3 cut_off | +0.0 (0.0) | +3.5 (1.8) | -0.5 (1.3) | +2.0 (1.0) |
| pro4 heavy_presser | 4 tie_up | +0.0 (0.0) | +3.5 (1.8) | -0.5 (1.3) | +2.0 (1.0) |
| pro4 counter | 1 1-2 | -2.0 (1.4) | +0.5 (1.7) | -1.0 (1.4) | -2.0 (1.4) |
| pro4 counter | 2 step_in | +1.5 (0.9) | +1.5 (1.5) | +3.0 (1.4) | +1.5 (0.9) |
| pro4 counter | 3 cut_off (weakest) | +0.0 (0.0) | +1.0 (1.4) | +0.5 (0.9) | +0.0 (0.0) |
| pro4 counter | 4 tie_up | +0.0 (0.0) | +1.0 (1.4) | +0.5 (0.9) | +0.0 (0.0) |
| pro4 volume | 1 1-2 | -6.0 (2.3) | -6.0 (2.3) | -4.5 (2.2) | -5.0 (2.3) |
| pro4 volume | 2 step_in (weakest) | +0.0 (0.0) | +1.5 (0.9) | +0.5 (1.1) | +0.5 (0.5) |
| pro4 volume | 3 cut_off | +0.0 (0.0) | +1.5 (0.9) | +0.5 (1.1) | +0.5 (0.5) |
| pro4 volume | 4 tie_up | +0.0 (0.0) | +1.5 (0.9) | +0.5 (1.1) | +0.5 (0.5) |
| pro6 light_presser | 1 2-3 | -0.5 (0.5) | +2.5 (2.2) | +3.5 (1.6) | +0.5 (0.9) |
| pro6 light_presser | 2 feint (weakest) | +0.0 (0.7) | +3.0 (2.3) | +5.5 (1.8) | +1.0 (1.0) |
| pro6 light_presser | 3 pivot_out | +0.0 (0.0) | +3.0 (2.2) | +5.0 (1.7) | +1.0 (0.7) |
| pro6 light_presser | 4 1-2 | +0.0 (0.0) | +3.0 (2.2) | +5.0 (1.7) | +1.0 (0.7) |
| pro6 heavy_presser | 1 2-3 (weakest) | +0.5 (0.5) | +3.5 (1.8) | +2.5 (1.6) | +1.5 (1.3) |
| pro6 heavy_presser | 2 feint | +0.0 (0.7) | +2.5 (1.9) | +3.0 (1.7) | +1.5 (1.5) |
| pro6 heavy_presser | 3 pivot_out | +0.0 (0.0) | +3.0 (1.9) | +3.0 (1.7) | +1.5 (1.3) |
| pro6 heavy_presser | 4 1-2 | +0.0 (0.0) | +3.0 (1.9) | +3.0 (1.7) | +1.5 (1.3) |
| pro6 counter | 1 2-3 (weakest) | -1.5 (1.1) | +2.0 (1.6) | +2.5 (1.8) | +0.0 (1.2) |
| pro6 counter | 2 feint | -0.5 (0.9) | +1.0 (1.2) | +2.5 (1.5) | +1.0 (1.0) |
| pro6 counter | 3 pivot_out | +0.0 (0.0) | +2.5 (1.3) | +3.0 (1.6) | +1.5 (0.9) |
| pro6 counter | 4 1-2 | +0.0 (0.0) | +2.5 (1.3) | +3.0 (1.6) | +1.5 (0.9) |
| pro6 volume | 1 2-3 | -1.0 (0.7) | -1.0 (1.0) | +1.0 (1.6) | +0.5 (1.3) |
| pro6 volume | 2 feint | +0.0 (0.0) | -1.0 (1.0) | +3.5 (1.5) | +1.0 (1.0) |
| pro6 volume | 3 pivot_out (weakest) | +0.0 (0.0) | -1.0 (1.0) | +3.5 (1.5) | +1.0 (1.0) |
| pro6 volume | 4 1-2 | +0.0 (0.0) | -1.0 (1.0) | +3.5 (1.5) | +1.0 (1.0) |

Of the 144 swaps: 43 are 3+ up, 11 are 3+ down. Cells with at least one swap 3+ up: 11 of 12; with at least one 3+ down: 5 of 12.
A move line picked blind (the mean over the four): a guard line loses 3+ in 0 of 12 cells.

### Bars (written in the probe before the run: the weakest move line, by the pilot, is the one given up)

- Bar 1, a guard line is worth its slot: some swap beats the four-move plan by 3+ wins in 100 in at least 3 cells: 8 of 12 = PASS.
- Bar 2, and not everywhere: some swap loses to the four-move plan by 3+ in at least 3 cells: 1 of 12 = FAIL.
- Bar 3, no single plan (the four moves or one of the three swaps) best in more than 7 of 12 cells: { "High WHEN loading up": 9, "Loose WHEN tiring": 4 } (most: High WHEN loading up, 9 of 12) = FAIL.
- Not bars, said beside them: cells where EVERY right swap loses 3+ (no guard line is worth the slot): 0 of 12. Swaps of the 36 that are 3+ up and at least 2 sd: 10; 3+ down and at least 2 sd: 1.
- The wrong swap (High WHEN at range for the weakest move line) loses 3+ in 6 of 12 cells.
- BASE against today's game (CONTROL): worst cell 1.5 in 100 apart (the worn-guard edge is the only difference).

RESULT: tools/guardprobe8.gd -> worth=PASS(8/12) notworth=FAIL(1/12) single=FAIL(9/12) -> FAIL

(the parts took 1788 s of Godot time together)
