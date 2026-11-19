# TASK PROCONTRACT1 - a blind contract test for turning pro (TURNPRO1 v2), with mutants

Status: OPEN (S524, Claude main). Discipline: boxing. Model: Arena (cloud). Seat: Arena (no Godot in the sandbox: write the
test, parse it with gdtoolkit; CI and Claude run it).

## Why
S523-S524 wired turning pro v2 (two promoters side by side, one ask, a 14-day window, the debut night's money, the week
review's ledger lines). The author's tests (tests/pro_offer_wire_test.gd, tests/pro_call_test.gd, tests/pro_week_lines_test.gd)
were written beside the code. A test written from the CONTRACT alone catches what the author's tests share with the
author's bugs (S490 ROPESCONTRACT1 did exactly this).

## The contract - write the test from THIS, from the design `ops/research/DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md`
sections 1-6, and from the HEADER COMMENTS (the `##` lines above each function) of scripts/state/ProOfferWire.gd,
scripts/state/Roster.gd (check_pro, turn_pro, decline_pro, debut_day, debut_night), scripts/rules/ProCall.gd and
scripts/ui/ProWeekLines.gd. Do NOT read the function BODIES of those four files; do not read the author's three tests.
Facts you may rely on:
- A boxer is at the line with 9 wins, or 7 wins and a top-3 ranking. Roster.check_pro(c) then makes c.pro_offer (never
  while the boxer has a bout booked, never at age 32 or older for a first call). c.pro_offer keeps the first house's old
  keys (fid, promoter, purse, terms, step, top) and adds offers (one or two houses), forecast, expires, asked, plain.
- The two houses: Bow Lane Promotions (key "bow", the ticket house: $1,500, break-even 60 tickets, debut 4 weeks out) and
  Harrow & Finch Boxing (key "hf", the guarantee house: $1,800, debut 6 weeks out, an easier first opponent). Both call
  when the ticket forecast is within 15 of 60; far above, Bow Lane alone; far below, Harrow & Finch alone.
- The offer stands 14 days (ProCall.WINDOW_DAYS). Letting it run out is NOT a decline: pro_declines does not move, the
  promoter calls again after 2 more wins (no call before them).
- One ask per house (ProOfferWire.ask(c, key, kind, runway_weeks) -> its answer as text, "" when refused): a "will not"
  answer does not spend the ask; a taken ask or counter spends it; a second ask on the same house is refused; the other
  house keeps its own ask; ProOfferWire.back_to_plain(c, key) restores the plain terms and the ask stays spent.
- Roster.turn_pro(c, key) signs with that house: f["pro"] true, the stipend stops (weekly_salary 0), the debut is booked
  pro on Roster.debut_day(day, the house's weeks), c.pro_offer is empty, f["pro_signed"] = {d, house, stipend (what it
  was), costs (0 when the house pays them from the purse)}. Roster.decline_pro(c): pro_declines + 1, c.pro_offer empty,
  the same house is the first to call next time; 3 declines close the door short of a number 1 ranking.
- ProWeekLines.lines_for(f, day): nothing for an amateur; days 1-28 after signing and before the debut one "signed" line
  ("Amateur cut lost $X; stipend saved $Y (N week(s) since signing).", X = ProCall.LOST_CUT_A_WEEK x N, Y = the stipend
  x N); the debut's week a "ledger" line with share, costs and net and a "next" line starting "NEXT: "; no boxer name in
  any line's text (the name only in "head").

## What to do
1. tests/pro_contract_test.gd (extends SceneTree; under 350 lines). Build careers with Career.quick_start() and
   Data.fighter_state(Data.lucy(), c.day) (see any test under tests/ for the shape: set w, l, age, members). Check every
   bullet above, and the edges: an offer is not made while a bout is booked; a second check_pro on the same day changes
   nothing; the window running out on day 13 vs day 14 (13 = still there); three declines then 9 more wins = no call
   short of a number 1 ranking; a decline's next call puts the declined house FIRST; signing with "bow" books 4 weeks
   out, with "hf" 6 weeks out; ProWeekLines on day 29 after signing = nothing. Print `ok  <what>` / `FAIL <what>` per
   check and `PRO_CONTRACT PASS fails=0` or `PRO_CONTRACT FAIL fails=<n>`, quit(0|1).
2. Five mutants in the PR body: for each, the one-line change your test must catch (e.g. WINDOW_DAYS 14 -> 15; the lapse
   counted as a decline; the declined house not first next time; the stipend recorded after it was zeroed; a name in a
   week-review line) and the check that catches it.

## Contract
OWNS: tests/pro_contract_test.gd
RED_TEST: tests/pro_contract_test.gd -> PRO_CONTRACT PASS fails=0
REGRESSION: pro_offer_wire_test, pro_call_test, pro_week_lines_test (never edit them)
VISUAL: no

## Prior research
ops/research/DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md; ops/research/TASK_ROPESCONTRACT1.md (the same kind of task).

## What would a human do?
A second programmer who never saw the code writes the test from the spec; where it disagrees with the code, one of the
two is wrong and that is the finding.

## Prefab check
None: a test file.

## Rules for this seat
Work on FightCamp-Lean-lite main, your own `arena/` branch, open a PR into main there; never merge, never touch another
file. A check that fails against the code is a FINDING - keep it and say in the PR body which bullet the code breaks;
never weaken it to go green. GDScript: typed vars, no `:=` on a Variant from a Dictionary, tabs; `trait` is a reserved
word in Godot 4.7.
