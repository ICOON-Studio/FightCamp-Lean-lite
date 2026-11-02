# S104 DIGEST - D51 applied, D50 leftovers, G141 collected, Q207 written, Q206 sent back (2026-09-27)

Owner: claude. Stage S104. Suite: nightly 2026-09-27 at 40bec39e `SUITE total=439 fails=24` (S97 tree, before S102's
re-pins); this session ran subsets only.

## Shipped
- **D51 (Dola) applied whole** - door corridor 1.5 -> 2.4 m (`TrainingFloorLayout.DOOR_WALKWAY_M`; the ring's rope corner
  sat on the corridor edge and filled the locker door's sight line), a painted walkway strip + edge line
  (`TrainingFloor3D._build_walkway`, sand on worn tiers, grey on clean), door leaves swing OUT of the room (hinge +38).
  Test: walkway node deep as `floor_x0` >= 2.4 m, every leaf at local z < 0.
- **D50 leftovers** - CAUSE shows the lead sentence only (a >5 list still mounts nothing); SWING note "DECIDED THE CARDS".
- `run_tests.py --jobs 2 --only training_floor_3d,fight_result_panel,result_plan_card,ui_post_fight`: total=4 fails=0.
- Renders: `previews/s104/tier1_floor.png`, `tier2_floor.png`, `result_plans_left.png` (sent to the operator).
- **G141 collected** (front headlock / turtle; condensed transcription with Claude's disposition -> Q208 after Q207).
- **D51 collected** -> `D51_DIGEST.md`. **TASK_Q207** (one down / one up) written from G140 §7.
- Sent: **G142** back control (grok.com/c/2b00a75e-8321-43af-938a-7dd00e5f898c), **D52** fresh eyes on the walkway
  (newest Cici chat, render attached as a follow-up).

## Not merged
- **Q206 (Qwen)**: run 1 ended with the seat + over_under->fence drift only (22.3% of clinch fenced); no exits, no
  wall-walk, no leg-share fix, gate not run -> SENT BACK and relaunched (scratchpad q206b_prompt.md, same worktree).
- **U191 (Cursor)**: still running at handover.

## Operator direction
"can you finish each room with one session per room?" -> yes; roadmap `next`: S105 office, S106 locker room, S107 lobby,
S108 mat room, S109 staff room, S110 physio, S111 training floor final.
