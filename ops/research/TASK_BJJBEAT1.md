# TASK BJJBEAT1 - CURSOR (GPT-5.6 Sol High) - turn the two-sided BJJ beat ON and tune it into the real bars

Status: OPEN (S399, Claude main). Discipline: no-gi BJJ. Source: ops/research/BJJ_REALISM_S397.md (v2 merged 500c3ca7, its
section "Five paper rounds" + the shipped table), S398 BJJREAL step 3 (BjjBeat.gd, on main with BEATS2 = 0).

## Contract
OWNS: scripts/rules/BjjBeat.gd, scripts/rules/BjjTree.gd, scripts/rules/BjjWalk.gd, tests/bjj_beat_test.gd, tests/bjj_beat_on_test.gd
RED_TEST: tests/bjj_beat_on_test.gd -> BJJ_BEAT_ON failures=0
REGRESSION: bjj_, golden_path_test
VISUAL: no

## Why
The 33-s one-actor beat gives a white match 9 beats: it cannot hold real white-belt action density, a 20-s stall count, a
double pull or a white belt's scrappy pace (critics 4, 6, 7, 8). S398 built the ~11-s beat where BOTH sides choose (BjjBeat,
switch T.BEATS2) and left it OFF. Open bars on main (GAMETREE1 / v2 table): white even subs 0.22-0.23 (bar 0.30-0.55); white
sub attempts 1.3 a bout (bar 2-4); first scorer wins 0.67 (bar 0.80-0.87); bars 3b, 6, 8.

## Do
1. tests/bjj_beat_on_test.gd FIRST: runs tools/bjj_tree_balance.gd's measurement (or the same calls) with BEATS2 = 1 and the
   bars below; it must FAIL on main (BEATS2 = 0 there). Seeded, headless, under 3 min. Start every Godot run through
   `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`.
2. Set BEATS2 = 1 in both T tables and tune ONLY BjjTree.T / BjjBeat keys (bjj_tree_balance.gd `search=` / `sweep=` take any key
   from the command line - no code edit needed for a sweep). Bars, all at once (n >= 1000 for the shares):
   - white even fields: submissions 0.30-0.55; white sub attempts 2-4 an athlete a bout; referee decisions 0.02-0.10;
   - first scorer wins 0.80-0.87;
   - stalling: the 20-s stall count fires in 5-25% of white bouts and < 10% at black;
   - KEEP v2's belt table (tools/bjj_realism_probe.gd parts=walk,inside): one belt 0.70-0.85, white->blue 0.80-0.90,
     brown->black 0.60-0.72, two belts 0.85-0.97, four-stripe vs fresh 0.62-0.76 (white 0.72-0.85);
   - KEEP even subs blue 0.45-0.60, brown 0.45-0.60, black 0.40-0.60.
3. Every BJJ test green (REGRESSION). If a bar cannot be met without breaking another, STOP and write both numbers and the key
   that trades them in the PR body - do not loosen any bar, do not drop samples.
4. Do not touch the boxing fight model, scripts/ui, ops/ or tools/run_tests.sh. Files under 500 lines (BjjWalk is 488: put new
   code in BjjBeat.gd).

## Result lines (PR body)
RESULT: BJJ_BEAT_ON main <fails> -> after failures=0
RESULT: white subs <x> attempts <x> ref <x> | first scorer <x> | stall white <x> black <x>
RESULT: belt table one <x> white->blue <x> brown->black <x> two <x> 4-stripe <x>
RESULT: keys changed <KEY old -> new, ...>
RESULT: regression <pass/fail per test>

## What would a human do?
Watch two white belts roll for five minutes: lots of scrappy attempts, someone stalls on top, the first to score usually wins.
