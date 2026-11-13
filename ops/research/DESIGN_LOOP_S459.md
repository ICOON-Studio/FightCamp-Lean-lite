# S459 design loop - every mechanic to 6+ depth and 6+ general design

Operator S459: "use all free agents on loop until all mechanics have been designed . critics need to rate them at least 6 at depth
and 6 at general design etc". Tool: `python ops/Tools/design_loop.py critic|revise <ID> <map> --seat <seat>` (builds the brief:
task + CRITIC_PACK + map [+ critics], queues it on seat_queue; the 30-min reconcile sends it, answers land in ops/research).
DONE = two critics (one fresh) each at 6+ DEPTH and 6+ GENERAL DESIGN. Then it goes to his board, then the build.

| Mechanic | Map now | Last scores (depth / play or general) | Next step (seat) | Queue |
|---|---|---|---|---|
| Fight week (AMATEURWEEK1) | V6_S455 | John 6/7, Kalli 5/6 | Kalli writes v7 from both lists, then Dola + John score | SQ73 |
| Coaches: fit, load, growth (COACHFIT1) | V3_S454 | John 6/6, Kalli 6/5 | Dola writes v4 from both lists, then Kalli + Maria score | SQ74 |
| Hosted club show (HOSTSHOW1) | HOSTSHOW_MAP_S439 | none yet | John scores | SQ75 |
| A fighter leaves (R58) | R58_MAP_S439 | none yet | Maria scores | SQ76 |
| Training as a game (TRAINGAME2) | J (docs/mockups/s458/training_j) | Dola 7/8, Claude 6/5 | K from Claude J's list | Claude |
| Ask for a fight (ASKFIGHT1) | ASKFIGHT_MAP_S441 v4 | 5/6 | waits on fight week v7 | - |
| Push switch + tank (PUSHTANK) | PUSHTANK_MAP_V2_S442 | (read file) | fresh critic | next batch |
| Progression (moves, styles, steps) | PROGRESSION_MAP_S448 v4.1 | approved by him (Q-211) | BUILD (PROGBUILD1, INTEGRATE1) | - |
| Read reveal (READREVEAL1) | no map | - | Claude drafts the map | next batch |
| Camp locations (CAMPLOC1) | camp v3 mockups S449 | - | map + critic | next batch |
| Contract ledger (LEDGER1) | - | - | map + critic | next batch |
| Weight: hold or cut | - | - | short map + critic | next batch |
| Turning pro | - | - | short map + critic | next batch |
| Liver vs ribs | - | his Q-S294-219 open | waits on his answer | - |
| Gear (GEAR1) | - | his Q-212: after fight week | after AMATEURWEEK1 | - |
| Small living world | - | his S425: after the week | after the week | - |
