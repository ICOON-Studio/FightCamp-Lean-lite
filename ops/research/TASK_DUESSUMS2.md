# TASK DUESSUMS2 - QWEN (qwen3-coder) - dues sums, second search: a REGION of balanced numbers, and a reason for the middle price (pure module + sim, MEASURE ONLY)

Status: OPEN (S431, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: DUESSUMS1 (branch goose/issue-193) found 0 balanced sets of 243. Read `ops/research/DUESSUMS1_RESULT_S431.md`
first (40 lines): the volunteer saving was far too strong (Cheap won 9 of 9 clubs in 145 sets), Standard won nothing in 203
sets, and the one set that met the win bars was a knife edge. Nothing here is wired into the game.

## Contract
OWNS: scripts/rules/DuesLevers.gd, tests/dues_levers_test.gd
RED_TEST: tests/dues_levers_test.gd -> DUES_LEVERS failures=0
REGRESSION: membership_test, membership_why_test
VISUAL: no
BASE: goose/issue-193

## The job (start from the two files on the base branch; keep every function that is there)
1. Change the candidate lists in scripts/rules/DuesLevers.gd:
   - GRANT_CHANCES 0.20 / 0.33 / 0.50 (unchanged). GRANT_PAYOUT is now ONE number: 12345 (the real median award).
   - VOLUNTEER_SHARES 0.0 / 0.05 / 0.10 / 0.15 (was up to 0.50: far too strong).
   - SHOW_PER_BOXERS 1000 / 2000 / 3000 (unchanged). LOW_REP_DRAWS 0.85 / 0.75 / 0.65 (unchanged).
2. Two new levers, the middle price's own reason (real basis: a coach in England Boxing's own research, "It is the keep
   fitters that sustain the club": adults pay about 8 pounds a session for keep-fit, children 3):
   - STEADY: `steady_draw(band, steady)`: Standard keeps its adults longest, so its draw is multiplied by `steady`;
     Cheap and Premium by 1.0. Candidates 1.0 / 1.05 / 1.10.
   - CLASSES: `class_year(band, cheap_share)` = 350 x 52 for Standard and Premium (the evening class the game already
     has: $350 a week with a coach), and `cheap_share` x 350 x 52 for Cheap (a club of juniors sells fewer adult
     classes). Candidates cheap_share 1.0 / 0.75 / 0.5.
   Both go into `five_year_total` (steady through settle_week's draw_mult; classes as a yearly sum) and into its
   returned dictionary as their own keys.
3. tests/dues_levers_test.gd:
   a) CONTROL unchanged: every lever at its neutral value (chance 0, share 0, per_boxer 0, low_rep_draw 0.85, steady 1.0,
      cheap_share 1.0) gives Premium 9 of 9. Print the table.
   b) THE SEARCH over all 3 x 4 x 3 x 3 x 3 x 3 = 972 sets, the same nine clubs. GOOD = every price wins at least 2 clubs
      and none more than 5; Cheap wins reputation 10 / cap 120; Premium wins reputation 80 / cap 40; in no club is the
      best price more than 25 in 100 above the worst. NEAR = the same with 35 in 100 (reported, never used to pass).
   c) ROBUST = a GOOD set of which at least half the one-step neighbours (one lever moved one place in its list, the
      others unchanged) are GOOD too.
   d) Print: the count of GOOD, NEAR and ROBUST; the table of wins (cheap / standard / premium) with how many sets give
      each split; for each lever value, how many GOOD sets use it (so the lever that decides it shows); the 5 ROBUST
      sets with the most GOOD neighbours, each with its nine-club winner table and every price's parts.
   e) Checks: the control; totals are the sum of their parts; each lever returns its neutral value where the rule says
      so; at least one ROBUST set exists. `const PICK` = the most robust set (or, if there is none, the GOOD set with
      the most GOOD neighbours, and say so). Last line `DUES_LEVERS checks=%d failures=%d`.
4. Do NOT widen a list, change a bar or add a lever to make a ROBUST set appear. No ROBUST set is a result: the test then
   fails on that one check and the printed tables say which bar and which lever decide it.
5. Do not add the test to tools/run_tests.sh (it is a search of a few minutes, not a gate). Do not edit Membership.gd.

## Prior research
ops/research/DUESSUMS1_RESULT_S431.md, ops/research/TASK_DUESSUMS1.md (the lever definitions),
ops/research/J_CHEAP_CLUB_MONEY_S424_BRIEF_JOHN.md (the real money of cheap clubs), ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A treasurer who found one lucky set of numbers would not trust it: move each number a notch and see whether the answer
still holds.

## Prefab check
None: our own rules.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
on the PC (in the cloud: the plain headless command). Parse first with `--check-only --script res://<file>`. No file over
500 lines (split the test's printing into a helper if it grows). Never "he" or "she" in text.

## Result lines (PR body)
RESULT: tests/dues_levers_test.gd -> DUES_LEVERS checks=N failures=0
RESULT: tests/membership_test.gd -> MEMBERSHIP checks=N failures=0
Paste in the PR body: the control table, the counts of GOOD / NEAR / ROBUST, the table of splits, the per-lever counts, PICK.
