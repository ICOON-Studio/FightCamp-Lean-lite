# TASK DUESSUMS3C - QWEN (qwen3-coder) - dues sums, third search fixed: a waiting list that can act, ROBUST without a dead lever, a PICK you can repeat (MEASURE ONLY)

Status: OPEN (S433, Claude main; S435: the same brief under a new id - DUESSUMS3B stopped on Antigravity, which has no shell). Discipline: boxing. Model: qwen3-coder.
Source: PR 198 (DUESSUMS3, branch qwen/duessums3, commit 0be37335) is kept as the base, but the S433 review found three faults
before it can go on main (review + second check in ops/tmp_s433/collect_review.json). Its headline "2 ROBUST sets of 8748"
rests on a lever that does nothing. Nothing here is wired into the game. Read `ops/research/TASK_DUESSUMS3.md` (the levers,
the bars) and `ops/research/DUESSUMS2_RESULT_S432.md` first.

## Contract
OWNS: scripts/rules/DuesLevers.gd, tests/dues_levers_test.gd, tests/dues_levers_print.gd (new), docs/DUESSUMS3_RESULT_S433.md (new; Claude copies it to ops/research at collect)
RED_TEST: tests/dues_levers_test.gd -> DUES_LEVERS checks=53 failures=0
REGRESSION: membership_test, membership_why_test
VISUAL: no

## The job
0. Start from the PR's two files, not from main's older ones (main has not touched them since the PR's base aae121b1):
   `git fetch origin qwen/duessums3` then
   `git checkout origin/qwen/duessums3 -- scripts/rules/DuesLevers.gd tests/dues_levers_test.gd`. Commit that copy first,
   alone, titled "DUESSUMS3B: start from PR 198's two files".
1. The waiting list must be able to act. In `DuesLevers.five_year_total` (branch lines 141-144) `cap_full` is
   `after >= cap`, and the keep branch also needs `after < before`: a week that loses members can then never be "full", so
   `waitlist_keep` never runs. Fix: declare `var before: int = members` BEFORE the `Membership.settle_week` call and read
   `var cap_full: bool = before >= cap` (full = the club was at its capacity when the week began). The same `cap_full`
   feeds `waitlist_fee`. Change nothing else in the function, and do not edit Membership.gd or the start count of 40.
   Side effect to expect (not a fault): at cap 60, reputation 80, Premium's fee now starts the week AFTER the count first
   reaches 60, so the old totals and the GOOD count may move a little.
2. A control where Premium at capacity 40 is given its lowest draw: in `_test_waitlist_control` (test line 186) add, for
   Premium at cap 40, reputation 10, 40 and 80, low_rep_draw 0.65, strength 0.50, uplift 0.20 (the other levers neutral,
   as that function's `wl` dictionary already sets them), one line each, from
   `DuesLevers.five_year_total(rep, 40, "premium", levers)` (wrap each value as `int(float(r["..."]))`):
   `  WAITLIST rep%d cap40 low_draw=0.65: premium total=%d waitlist_kept=%d waitlist_fee_extra=%d`.
   (`waitlist_kept` and `waitlist_fee_extra` are dollars over five years, not members.) Keep the existing cap-40 lines
   (`  cap40 rep%d: ...`) printing as they are. If `waitlist_kept` is 0 in all three WAITLIST rows, print once:
   `  WAITLIST: keep never acts - Membership.settle_week walks the count toward a target with no random churn, so a full club loses nobody`.
   Claude's arithmetic expects 0 in all three: at reputation 10 Premium's target with draw 0.65 is 37, so the club does
   lose 3 members, but the keep gate is reputation 40; at reputation 40 the target is 57 and at 80 it is 89, both above
   the cap of 40, so the club never loses anyone (and at exactly 40 keep is 1.0 anyway). `waitlist_fee_extra` should be
   above 0 only at reputation 80 (fee gate 60). Print what the code gives; never invent churn to make it bite.
3. ROBUST without a dead lever. After the search loop in `_test_search`, find the inert levers: a lever is inert when, for
   every set, the set that differs only in that lever's index by one step has the same 27 totals (9 clubs x 3 bands,
   `r[band]["total"]`, within 0.5). Compute it from `all_results`, never from a list typed in. For each of the eight levers
   print `  INERT check <lever>: pairs=%d differing=%d` (pairs = sets that have a next step in that lever; differing = pairs
   where any of the 27 totals moves more than 0.5); a lever is inert when differing is 0. Then print
   `  INERT axes: <names, or none>`. (Expected: pairs 6561 for volunteer_share, 5832 for each other lever; Claude expects
   strength inert and uplift not.) Count ROBUST again with the same rule
   (`gn * 2 >= neighbours`) but over neighbours that change only non-inert levers. Keep the old line
   `  ROBUST sets: N` exactly as it is, add `  ROBUST (inert axes excluded): N`, and give the EXISTING check at test line 306
   that number instead: `_check(robust_ex_keys.size() > 0, "at least one ROBUST set exists, inert axes excluded (%d)" % ...)`.
   No new `_check`, none removed: checks stays 53. If that count is 0 the test fails on that one line; that is a result.
4. The top-5 lines (test line 270) and the PICK line (test line 294) also print `wl_str=%.2f uplift=%.2f`
   (`float(lev["strength"])`, `float(lev["uplift"])`) and `good_neighbors=%d of %d` from the inert-excluded count (good
   neighbours, then all neighbours that change only non-inert levers). PICK and the top 5 are chosen by the inert-excluded
   count: the list is `robust_ex_keys` if it is not empty, else `good_keys`, sorted by that count, highest first, ties
   broken by the key string, smallest first (so the same run always gives the same PICK). PICK no longer leans on copies
   of itself.
5. The test is 497 lines now. Move `_print_table`, `_print_full_table`, `_print_split_table` and `_print_per_lever_counts`
   (test lines 370-428) into tests/dues_levers_print.gd (`extends RefCounted`, static functions; it may preload
   DuesLevers.gd for `BANDS`; the lever value lists are passed in as arguments) and preload it from the test. If the test
   is still over 500 lines, move `_report_bar_failures` (test lines 309-367, printing only) there too. Both files under
   500 lines. Do not name the new file `*_test.gd`.
6. docs/DUESSUMS3_RESULT_S433.md, under 40 lines, plain words: the cap-40 control rows (old and new), the waiting-list
   rows and whether keep ever acted, INERT axes, GOOD / NEAR / ROBUST / ROBUST (inert axes excluded) counts, the GOOD split
   for strength and uplift, PICK with all eight levers, and which reputations the control rows differ at and why
   (fee gate reputation 60, keep gate reputation 40).
7. Do not change a bar, widen a candidate list, add a lever or add the test to tools/run_tests.sh.

## Rulers (Claude runs each at collect; run them yourself before you push)
- `git diff origin/qwen/duessums3 -- scripts/rules/DuesLevers.gd` touches only the `before` / `cap_full` lines in
  `five_year_total` (at most 3 lines out, 3 in).
- `grep -c "_check(" tests/dues_levers_test.gd` prints 28 (27 calls + the `func _check` line, as on the branch);
  `grep -c "_check(" tests/dues_levers_print.gd` prints 0.
- `git diff origin/qwen/duessums3 -- tests/dues_levers_test.gd | grep -E '^[-+].*(1\.25|1\.35|w < 2|w > 5|_CANDIDATES :=|_SHARES :=|_DRAWS :=|_BOXERS :=|_CHANCES :=|LEVER_SIZES)'`
  prints nothing (bars and candidate lists untouched).
- `git diff --name-only origin/main` lists only the four OWNS files.
- The output keeps `  ROBUST sets: N` and has the eight `INERT check` lines with the pair counts in step 3; the PICK's
  `of %d` equals the PICK's neighbours that change only non-inert levers (Claude recounts it from the PICK's levers).
- `wc -l` on the three .gd files: each under 500; the result doc under 40; `grep -niwE "he|she" docs/DUESSUMS3_RESULT_S433.md` prints nothing.

## What the last round got wrong
- Full was read from the end-of-week count beside an `after < before` guard, so the waiting list could never act.
- The dead strength lever stayed in the neighbour search: every GOOD set counted 1-2 copies of itself, so ROBUST=2 was an artefact.
- The PICK and top-5 lines left out strength and uplift, so the PICK could not be repeated.
- The control row was said to "differ by reputation" but only rep 80 moved: say which rows differ and why.
- The brief's pass line "DUES_LEVERS failures=0" never matched the real line; the exact line is "DUES_LEVERS checks=53 failures=0".
- The seat's commit was titled "DUESSUMS3 collected": a seat never writes "collected"; Claude collects.

## Prior research
ops/research/TASK_DUESSUMS3.md (the waiting-list levers), ops/research/DUESSUMS2_RESULT_S432.md,
ops/research/DUESSUMS1_RESULT_S431.md, ops/research/J_CHEAP_CLUB_MONEY_S424_BRIEF_JOHN.md, ops/research/DUES_DESIGN_MAP_S423.md,
ops/research/GDSCRIPT_TRAPS.md. scripts/rules/Membership.gd lines 90-102 (settle_week, no rng) and 45-53 (step_members).

## What would a human do?
An auditor who finds one input changes nothing takes it out of the count before trusting the count, and when a rule has
nothing to act on writes that down plainly instead of tuning the numbers until it seems to work.

## Prefab check
None: our own rules.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
on the PC. Parse every touched .gd first with `--check-only --script res://<file>`.
Line counts: on main DuesLevers.gd 142, dues_levers_test.gd 483; after step 0 they are 188 and 497;
tests/dues_levers_print.gd and the result doc are new. No file over 500 lines. Never "he" or "she" in text.
GDScript traps (GDSCRIPT_TRAPS.md): type every value read from a Dictionary or Array (`var t: float = float(r[band]["total"])`,
never `:=` on a Variant); give each new variable a new name (`gn_ex`, `robust_ex_keys`, `nb_ex`), never reuse a name already
in `_test_search`; a static helper cannot touch the test's `checks` / `failures` (printing only there); `round(0.5)` is 1.0
in GDScript, so a 1-member loss at keep 0.5 keeps 0: say so if it shows, do not change the rounding.

## Result lines (PR body)
RESULT: tests/dues_levers_test.gd -> DUES_LEVERS checks=53 failures=<0 or 1 - say which line failed>
RESULT: tests/membership_test.gd -> MEMBERSHIP checks=N failures=0
RESULT: tests/membership_why_test.gd -> MEMBERSHIP_WHY failures=0
Paste in the PR body: the WAITLIST rows, the eight INERT check lines and INERT axes, both ROBUST counts, the GOOD split for strength and uplift, PICK with all
eight levers, and the line counts of the three .gd files.
