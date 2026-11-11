# TASK DUESSUMS3 - QWEN (qwen3-coder) - dues sums, third search: a waiting list, the one thing reputation buys a FULL club (pure module + sim, MEASURE ONLY)

Status: OPEN (S432, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: DUESSUMS2 (collected S432) found 0 balanced sets of 972. Read `ops/research/DUESSUMS2_RESULT_S432.md` first
(25 lines). The cause is in the control table: at capacity 40 every band's five-year total is IDENTICAL at reputation 10,
40 and 80 (cheap 188,560, standard 202,730, premium 217,160) - a full small club ignores its name, so Premium can never win
the small famous club while the levers that let Cheap win its home club work everywhere. Nothing here is wired into the game.

## Contract
OWNS: scripts/rules/DuesLevers.gd, tests/dues_levers_test.gd
RED_TEST: tests/dues_levers_test.gd -> DUES_LEVERS failures=0
REGRESSION: membership_test, membership_why_test
VISUAL: no

## The job (keep every function and every check that is there; the test is allowed to stay red - see 4)
1. A new lever in scripts/rules/DuesLevers.gd, the real basis: a well-known club that is full keeps a waiting list, so
   a member who leaves is replaced at once and members stay longer (they waited to get in).
   `waitlist_keep(band, reputation, cap_full: bool, strength) -> float`: a multiplier on the band's monthly member
   loss (churn) - 1.0 when the club is NOT full or for any band at reputation under 40; when full, the loss is multiplied
   by `1.0 - strength * (reputation - 40) / 60.0` (reputation 100 = the whole strength). Premium only gets the full
   effect; Standard half of it; Cheap none (a cheap club's waiting list is juniors, not payers). Candidates for
   strength: 0.0 / 0.25 / 0.50.
   AND the price it lets a full famous club hold: `waitlist_fee(band, reputation, cap_full, uplift) -> float`, the dues
   multiplier, 1.0 unless full and reputation >= 60, then `1.0 + uplift` for Premium only. Candidates uplift 0.0 / 0.10 / 0.20.
2. Both go into `five_year_total` (full = the club at its capacity that week, read from the same member count it already
   computes) and into its returned dictionary as their own keys ("waitlist_kept", "waitlist_fee_extra").
3. tests/dues_levers_test.gd: the same search, now over 972 x 3 x 3 = 8,748 sets (if that runs over 10 minutes headless,
   fix grant chance at 0.33 and show per boxer at 2000 and SAY SO: 108 x 9 = 972 sets). The same nine clubs, the same
   GOOD / NEAR / ROBUST definitions, the same printed tables, plus: for the two new levers, how many GOOD sets use each value;
   and the control row for capacity 40 at reputation 10 / 40 / 80 WITH strength 0.50 and uplift 0.20 (it must now differ
   by reputation: print it).
4. Do NOT change a bar, widen an old list, remove a check or add another lever. The check "at least one ROBUST set exists"
   stays: if there is none, the test fails on that one line and the tables say which bar still decides it. That is a result.
5. Do not add the test to tools/run_tests.sh. Do not edit Membership.gd.

## Prior research
ops/research/DUESSUMS2_RESULT_S432.md, ops/research/DUESSUMS1_RESULT_S431.md, ops/research/TASK_DUESSUMS2.md (the levers),
ops/research/J_CHEAP_CLUB_MONEY_S424_BRIEF_JOHN.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A club treasurer of a famous, full gym knows the name is worth something even when no new member can join: people stay,
and the price can go up a little without emptying the room. Measure that, then see whether every price finds its club.

## Prefab check
None: our own rules.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
on the PC. Parse first with `--check-only --script res://<file>`. No file over 500 lines (move the printing into a helper
script under tests/ if the test grows past it, and name it in the PR). Never "he" or "she" in text.

## Result lines (PR body)
RESULT: tests/dues_levers_test.gd -> DUES_LEVERS checks=N failures=<0 or 1 - say which line failed>
RESULT: tests/membership_test.gd -> MEMBERSHIP checks=N failures=0
Paste in the PR body: the capacity-40 control rows with the new levers, the counts of GOOD / NEAR / ROBUST, the splits,
the per-lever counts for all eight levers, PICK.
