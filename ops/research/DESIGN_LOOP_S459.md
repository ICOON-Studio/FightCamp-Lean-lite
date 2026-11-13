# S459 design loop - every mechanic to 6+ depth and 6+ general design

Operator S459: "use all free agents on loop until all mechanics have been designed . critics need to rate them at least 6 at depth
and 6 at general design etc". Tool: `python ops/Tools/design_loop.py critic|revise <ID> <map> --seat <seat>` (builds the brief:
task + CRITIC_PACK + map [+ critics], queues it on seat_queue; the 30-min reconcile sends it, answers land in ops/research).
DONE = two critics (one fresh) each at 6+ DEPTH and 6+ GENERAL DESIGN. Then it goes to his board, then the build.

| Mechanic | Map now | Last scores (depth / play or general) | Next step (seat) | Queue |
|---|---|---|---|---|
| Fight week (AMATEURWEEK1) | v7 (DESIGN_AMATEURWEEK1_V7_REVISE_KALLI_KALLI, S460) | v7: Dola 8/8 (play 7), John 6/5 (play 6) S463 | Kalli writes v8 from John's list (tank cap, EB weight gaps, fall-through Monday) | SQ88 |
| Coaches: fit, load, growth (COACHFIT1) | v4 (DESIGN_COACHFIT1_V4_REVISE_DOLA_DOLA, S460) | v4: Kalli 6/4, Maria 6/4 (map cut off, says points answered that are not) | Dola writes v5 | SQ86 |
| Hosted club show (HOSTSHOW1) | v4 (DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI, S463) | v3: John 6/5 (play 7) S460 | John + Dola score v4 | SQ89, SQ90 |
| A fighter leaves (R58) | R58_MAP_S439 | Maria 7/7 (play 6) S460, Dola 7/8 (play 7) S463 | DESIGNED (two critics 6+): to his board, then build | - |
| Training as a game (TRAINGAME2) | J (docs/mockups/s458/training_j) | Dola 7/8, Claude 6/5 | K from Claude J's list | Claude |
| Ask for a fight (ASKFIGHT1) | ASKFIGHT_MAP_S441 v4 | 5/6 | waits on fight week v7 | - |
| Push switch + tank (PUSHTANK) | PUSHTANK_MAP_V2_S442 | (read file) | fresh critic | next batch |
| Progression (moves, styles, steps) | PROGRESSION_MAP_S448 v4.1 | approved by him (Q-211) | BUILD (PROGBUILD1, INTEGRATE1) | - |
| Read reveal (READREVEAL1) | no map | - | Claude drafts the map | next batch |
| Camp locations (CAMPLOC1) | camp v3 mockups S449 | - | map + critic | next batch |
| Contract ledger (LEDGER1) | - | - | map + critic | next batch |
| Weight: hold or cut | - | - | short map + critic | next batch |
| Turning pro | - | - | short map + critic | next batch |
| Liver vs ribs (LIVERRIBS1) | v2 (DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI, S463) | v1: John 5/5, Dola 9/9 (Dola lenient; John is the bar) | John + Maria score v2 | SQ91, SQ92 |
| Gear (GEAR1) | - | his Q-212: after fight week | after AMATEURWEEK1 | - |
| Small living world | - | his S425: after the week | after the week | - |
