# TASK TURNPROBE3B - rerun turning pro with the fork fixes + the day-job question (probe, no screen)

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.
Why: ops/research/TURNPROBE3_READ_S530.md - TURNPROBE3's line 6 was void (fixed in tools/turn_pro_probe3_fork.gd on main:
the gap fork reads the boxer's first pro row in c.results), line 7's ask forks never stop at the debut (Bouts.after_fight
clears f["bout"], so "done" is never seen), and day-job careers almost never sign (1 of 60).

## What to change (tools/turn_pro_probe3.gd + tools/turn_pro_probe3_fork.gd, both on main - edit them in place)
1. Parse first (`--check-only` or a 1-career pilot): S530 edited _one_gap_fork by hand.
2. `_fork_one` (the ask fork): stop 7 days after this boxer's first pro row appears in c.results (newest first, fid +
   pro true), the same way _one_gap_fork now reads it; keep the no_ask reproducibility proof.
3. Day-job question: for every career print at w104 wins, losses, best rank reached and the day of the first pro call (or
   none), for both halves (stipend / day job). One line at the end: median wins and best rank, stipend vs day job.
4. Everything else as TURNPROBE3. Result page docs/TURNPROBE3B_RESULT.md (change the DOC constant), last line
   `TURNPROBE3B done`.

## Contract
OWNS: tools/turn_pro_probe3.gd, tools/turn_pro_probe3_fork.gd, docs/TURNPROBE3B_RESULT.md
RED_TEST: tools/turn_pro_probe3.gd -> TURNPROBE3B done
REGRESSION: pro_call_test, pro_offer_wire_test, pro_contract_test (read-only)
VISUAL: no
NOT YOURS: scripts/, tests/, docs/TURNPROBE3_RESULT.md. Each file under 500 lines (turn_pro_probe3.gd is at 500: move a
helper into the fork file). PR body: `RESULT: tools/turn_pro_probe3.gd -> pass=<n>/9 line6=<0.7:x,1.0:y,1.5:z>
line7=<ask:pct,...> dayjob_wins=<med> stipend_wins=<med>`.

## Prior research
ops/research/TURNPROBE3_READ_S530.md, docs/TURNPROBE3_RESULT.md, docs/TURNPROBE2_RESULT.md.
## What would a human do?
Check the stopwatch stops when the fight ends before trusting the times - then ask why the boxer with a day job never
gets the call.
## Prefab check
None: our own probe.
## The one trap
A fork that never sees the debut end still returns a number. Print, per fork, the day the debut row appeared; a fork with
no such day is reported as such, never scored.
