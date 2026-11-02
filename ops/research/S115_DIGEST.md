# S115 DIGEST - 2026-09-27/28 (Claude)

## Shipped (all on master)
- 1294c7bd Q208 back control + U193 blind test merged as diffs (Pop A ceiling scaled per G144 s2). Subset 17/2 (both reds pre-existing).
- 80ddd79a all ten OFF switches ON in the game (operator ruling); `--script` keeps OFF. Cost measured: boxing stoppages 4/30 -> 0/30 (tools/s115_demo_switches_probe.gd).
- 9b601fdf record_room `demo=1`; watch-loop take two sent (before the no-video ruling).
- OPERATOR RULING: no .exe and no preview video until every boxing+kickboxing move is its own clip, checked smooth -> TASK_C223 (Codex), SHOT_LIST_STRIKING.md (56 rows), q133 census per discipline (boxing EXACT 2/36, KB 9/20; two KB "EXACT" rows are a punch combo).
- One clip pipeline (A, whole-clip retarget) decided; B rows (jab_lead, cross_lead, strike_head, KB jab+lowkick) to be replaced in C223.
- 0477b0a9 training floor dresses each fighter for his discipline + sex; 4000c416 boxers wear boxing boots (FighterKit, foot bones; fighter_kit_test 0 fails; subset 7/0). Boot: Higgsfield tripo_3d, 5 credits, ledgered.
- PC Watchdog task fixed (self-restarting); TOOLS keep/use/drop in DECISION_LEDGER.
- D63 collected; seated-root advice REJECTED against C220's measurement (chair/table spacing is the defect).
- ROUTE STATUS in `start` (every live route's PROVEN/OPEN from its digest) after the operator: "stop doing that every session".
- The operator's standing OBJECTIVE + six controls: release = THE WHOLE GAME (product sheet: Steam EA $19.99, v1 stand-up, MMA first update, 1.0 $24.99), milestones M1-M10 (M1 ACTIVE, demo = M5), 19 settled decisions with reopen evidence, tasks mapped to the active milestone, resume point in `now`, DONE needs flow evidence; `Tools/check_workflow.py` (start prints, ship refuses, branch owned-files check with a control arm).
- Three conflict rulings: milestone wins over the agent quota; noticed defects fixed now; carry on, ask only on scope. Old lines marked RETIRED in CLAUDE.md.
- BytePlus terms read (you own Output; AI labelling; Playground terms still owed); pilot = the suit route on one boxer.

## Evidence / numbers
Subsets run this session: back-control 17 (2 pre-existing reds), training_floor 3/0 + discipline checks, fighter_kit/floor/room 7/0, career_loop_walk+arc+smoke 3/0. Nightly cited: 2026-09-27 at 40bec39e SUITE total=439 fails=24 (Q210 owns them). NOT verified in the player flow this session (S115 ruling).

## In flight
- Qwen Q210 (24 nightly reds) - worktree Temp/FightCamp-Q210, branch qwen/q210-nightly-reds, running, nothing pushed yet.
- Codex C223 - finished run 2: banded gate checkpoint 564b4f07; the bands admit a 5 cm foot-slide mutant -> 0 certified. Worktree Temp/FightCamp-C223.
