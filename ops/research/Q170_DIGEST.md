# Q170 Digest — TRAPS round 5: the trap you can reach (round 2)

## Code (landed in round 1, commit 1456c5ff)

Untrapped mount submissions are allowed again under `trap_arm`, at a finish
penalty. `UNTRAPPED_FINISH_SCALE = 0.25` (75%% finish penalty) applied in
`GrappleResolve.submission_advance`. The hard gate that blocked mount
submissions without a live trap is removed. Back is unchanged. OFF byte-identical
(9 hashes proven by `tools/s70_feint_off_hash.gd`).

Scale chosen: 0.25 is the mechanism, not a fit to the anchor. An untrapped
mount attempt is a hopeful arm-grab from a position where most defenders clear;
a 75%% penalty says "the attempt is real but the finish almost always fails."

## Measurement (3 arms × 2 populations × 40 bouts each)

Run with `tools/q168_submission_baseline.gd` (arm= and pop= filters added for
chunked execution). Each arm ran as one command, both populations included.
Outputs: `q170_baseline_current.txt`, `q170_baseline_graph.txt`,
`q170_baseline_trap.txt` at repo root.

### Full table

| Population | Arm | Bouts | Attempts | Finishes | Att/Fight | Fin/Att | Mt Fin | Untrapped Mt Att | Untrapped Mt Fin | Trap Won | Trap Def | Trap Sub Att | Trap Sub Fin | Trap Share |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| A: grappler(82) v striker(34), 77 kg | OFF (current) | 40 | 66 | 6 | 1.65 | 0.09 | 1 | 56 | 1 | — | — | — | — | — |
| A | ON (graph) | 40 | 46 | 3 | 1.15 | 0.07 | 3 | 44 | 3 | — | — | — | — | — |
| A | TRAP (graph+trap_arm) | 40 | 42 | 6 | 1.05 | 0.14 | 4 | 37 | 4 | 5 | 4 | 2 | 0 | 0%% |
| B: brawler(55) v kicker(28), 70 kg | OFF (current) | 40 | 40 | 3 | 1.00 | 0.07 | 2 | 35 | 2 | — | — | — | — | — |
| B | ON (graph) | 40 | 26 | 2 | 0.65 | 0.08 | 2 | 26 | 2 | — | — | — | — | — |
| B | TRAP (graph+trap_arm) | 40 | 22 | 0 | 0.55 | 0.00 | 0 | 19 | 0 | 1 | 1 | 1 | 0 | 0%% |

### Anchors

| Anchor | Target | OFF A | OFF B | Graph A | Graph B | Trap A | Trap B |
|---|---|---:|---:|---:|---:|---:|---:|
| (a) Mount fins ≤ graph arm | — | 1 ≤ 3 ✓ | 2 ≤ 2 ✓ | 3 | 2 | 4 | 0 |
| (b) Att/fight in J20 D6 0.5–1.0 | 0.5–1.0 | **1.65 ✗** | 1.00 ✓ | **1.15 ✗** | 0.65 ✓ | **1.05 ✗** | 0.55 ✓ |
| (c) Fin/att ≈ ~0.20 | ~0.20 | 0.09 | 0.07 | 0.07 | 0.08 | 0.14 | 0.00 |
| (d) Trap-born share of mt fins | — | — | — | — | — | 0%% | 0%% |

### Findings

1. **Mount finishes stay below the graph arm** — anchor (a) passes on both
   populations. The TRAP arm does not inflate mount finishes above the graph
   baseline.

2. **Attempts per fighter-fight MISS the band on the high side for Pop A** —
   OFF is 1.65, graph is 1.15, trap is 1.05. All three are above J20's 0.5–1.0
   for the high-grapple population. Pop B (lower grapple) lands closer: OFF 1.00,
   graph 0.65, trap 0.55. The OFF arm already over-shoots, so the trap mechanism
   is not the cause — the engine generates too many mount attempts for a
   grappler(82) vs striker(34) fixture regardless of trap rules.

3. **Finishes per attempt are well below ~0.20 across all arms** — OFF 0.09/0.07,
   graph 0.07/0.08, trap 0.14/0.00. The 0.25 untrapped finish scale is doing
   what it was designed to do: most untrapped mount attempts fail. The trap arm
   Pop A finish rate (0.14) is the highest of any arm because it has 4 finishes
   from 42 attempts — but 0 of those came from trap-born submissions (trap_sub_fin=0).

4. **Trap-born share of mount finishes is 0%%** — no trap-born submission
   finished in either population across 40 bouts each. Traps were won (5/1) and
   defended (4/1), and trap-born attempts were opened (2/1), but none reached
   a finish. At 40 bouts per population the sample is too small to conclude the
   mechanism cannot work; it says the finish path from trap to tap is not yet
   reliable at this volume.

5. **The attempt count is a pre-existing overshoot, not a trap artifact** — the
   OFF arm (no trap logic at all) already runs 1.65 att/fight for Pop A. The
   trap mechanism reduces it (1.05) but not into the anchor band. REPORTED, NOT
   TUNED: the 0.25 scale was chosen from the mechanism (untrapped mount attempts
   mostly fail), not fitted to the anchor.

## T11 — boxing MAJORITY re-found

Sweep: `tools/q170_find_boxing_majority.gd`, 62-v-64 fixture, same stats as
`_realtime_fighter` in `judge_panel_test.gd`. Seeds 1..900.

- 1..600: **0 majorities**
- 601..900: **2 majorities (677, 877)**

boxing_109 (S62's pin) went unanimous_draw on the current tree. The Q170 diff
is purely ground grappling and cannot affect boxing; the move came from U169
(delivered by S70 between S62 and Q170).

**T11 re-pinned: kickboxing_40 (SPLIT), boxing_677 (MAJORITY).** One ruleset
each, first ascending. Nothing relaxed.

Judge test: `judge_panel_test: 0 failure(s)`.

## Tests

- `ground_trap_test`: failures=0 checks=9
- `judge_panel_test`: 0 failure(s)
- Parse gate: `check_scripts.py` total=3 fails=0 (FightRealtime.gd,
  q168_submission_baseline.gd, judge_panel_test.gd)

## D1 pace

8.31/min vs J20's 6.0-8.0 ceiling. PRE-EXISTING on master (proven round 1 by
stash test). NOT MINE TO FIX.
