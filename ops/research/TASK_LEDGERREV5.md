# TASK LEDGERREV5 - write the contracts map v5 (LEDGER1_V5) from the code, answering both v4 critics

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud), default. RESEARCH ONLY - no game code changes.

## Why
LEDGER1 v4 (`ops/research/DESIGN_LEDGER1_V4.md`, Claude's check at its top) scored Dola 8/8 and Arena 6/5
(`ops/research/DESIGN_LEDGER1_V4_CRITIC_DOLA_DOLA.md` lines ~690-760, `ops/research/DESIGN_LEDGER1_V4_CRITIC_ARENA.md`).
Bar: 7+ DEPTH and 7+ GENERAL from two fresh critics.

## Your job
Write `ops/research/DESIGN_LEDGER1_V5.md` (same sections as v4), changed so that:
1. THE RELEASE FEE IS MONEY IN. `Leaving.gd` pays `c.pay(+fee, "Release fee: ...'s new manager")`: the new manager pays the
   gym (pro only; amateur 0). v4 put it under Cash Out, and Dola's list repeats "Release now: -$X fee". Fix every table,
   the comparison and the probes: the real choice is "fee now vs the share this pro brings per bout" (break-even in bouts
   with `StarDeal.gym_net`) - Arena v4 item 1.
2. ONE BUILD CHANGE NAMED FIRST: `Career.pay(amount, what, fid := "", kind := "")` stores the boxer id and a kind (bout,
   camp, bill, stipend, dues, club); list every call site the per-boxer view needs (grep `.pay(`), and the weekly stipend
   and dues as ledger lines (`Sim.gd` writes them to cash directly today - quote the lines). Both critics' #1/#2.
3. Dues from a win: replay `Membership.settle_week` for the win and show the real effect (Arena item 3), as an ESTIMATE
   line never added to cash; no "$65 a week" figure.
4. Milestone value: after the debut a pro's bout pays purse x share (`BoutFinish.gd`); no $450 ticket cut in the top-3,
   belt or debut lines; each tier from `StarDeal.gym_net` (Arena item 4).
5. The red alert gets club-wide levers with their eight-week cash effect (dues band, kit, half stipend, pause a stipend,
   release, a class night, the overdraft) - only levers the code has (Arena item 5).
6. From Dola: the fee and saving shown ON the comparison where Release is chosen; "Find a bout" on the orange row (opens
   Fights > Ask for a fight); week number + source on each ledger line. Check Dola's "Rest/Break" against what exists
   (rest, injury, stand-down - grep) before keeping it; drop it if it duplicates.
Keep: the wire map (owner S425), plain words, names only in headers (owner S448), no critic scores in the map. End with
"Changed from v4".

## Deliverable
ONE new file `ops/research/DESIGN_LEDGER1_V5.md`. A PR that adds only that file. Do not edit any other file. Do not run
Godot. Under 450 lines.

## Contract
OWNS: ops/research/DESIGN_LEDGER1_V5.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_LEDGER1_V4.md + both v4 critics; CRITIC_PACK.md.
## What would a human do?
A club secretary checks which way each payment really flows before laying the options side by side.
## Prefab check
None: a design document on our own code.
