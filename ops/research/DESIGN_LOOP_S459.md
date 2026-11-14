# S459 design loop - every mechanic to 6+ depth and 6+ general design

Operator S459: "use all free agents on loop until all mechanics have been designed . critics need to rate them at least 6 at depth
and 6 at general design etc". Tool: `python ops/Tools/design_loop.py critic|revise <ID> <map> --seat <seat>` (builds the brief:
task + CRITIC_PACK + map [+ critics], queues it on seat_queue; the 30-min reconcile sends it, answers land in ops/research).
DONE = two critics (one fresh) each at 6+ DEPTH and 6+ GENERAL DESIGN. Then it goes to his board, then the build.

| Mechanic | Map now | Last scores (depth / play or general) | Next step (seat) | Queue |
|---|---|---|---|---|
| Fight week (AMATEURWEEK1) | v8 (DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI, S463) | v8: Dola 8/8 (play 7) S464; v7 John 6/5 | John scores v8 | SQ96 |
| Coaches: fit, load, growth (COACHFIT1) | v5 (COACHFIT1_V5_MAP_S463, Dola; chat cut section 12 again) | v5: Kalli 6/4 (play 5), Maria 6/4 (play 5) S464 | Dola writes v6 from both lists | SQ109 |
| Hosted club show (HOSTSHOW1) | v4 (DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI, S463) | v4: John 7/7 (play 7), Dola 8/8 S463 | DESIGNED (two critics 6+): to his board, then build | - |
| A fighter leaves (R58) | R58_MAP_S439 | Maria 7/7 (play 6) S460, Dola 7/8 (play 7) S463 | DESIGNED (two critics 6+): to his board, then build | - |
| Training as a game (TRAINGAME2) | J (docs/mockups/s458/training_j) | Dola 7/8, Claude 6/5 | K from Claude J's list | Claude |
| Ask for a fight (ASKFIGHT1) | ASKFIGHT_MAP_S441 v4 | 5/6 | waits on fight week v7 | - |
| Push switch + tank (PUSHTANK) | PUSHTANK_MAP_V2_S442 | v2: Dola 8/7 (play ?), Maria 7/6 (play 6) S464 | DESIGNED (two critics 6+): his board Q-223, build after the fight week | - |
| Progression (moves, styles, steps) | PROGRESSION_MAP_S448 v4.1 | approved by him (Q-211) | BUILD (PROGBUILD1, INTEGRATE1) | - |
| Read reveal (READREVEAL1) | no map | - | Claude drafts the map | next batch |
| Camp locations (CAMPLOC1) | camp v3 mockups S449 | - | map + critic | next batch |
| Contract ledger (LEDGER1) | - | - | map + critic | next batch |
| Weight (WEIGHT1) | WEIGHT_MAP_S434 round 2 (Claude) | r1: coach 7/6, sim designer 6/6; r2 never scored | r2: Kalli 8/6 (play 7) S464; John scores r2 | SQ104 |
| Turning pro (TURNPRO1) | v1 (DESIGN_TURNPRO1_V1_WRITE_KALLI_KALLI, S464) | v1: Dola 7/7 (play 6), Maria 6/5 (play 5) S464 | v2 written (DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI, S465); Dola + Maria score v2 (SQ113/114) | see seat_queue |
| Liver vs ribs (LIVERRIBS1) | v2 (DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI, S463) | v2: Maria 7/6 (play 7) S463; v1 John 5/5 | John scores v2 | SQ91 |
| Progressive knowledge (KNOWLEDGE) | KNOWLEDGE_S411 v2 + proof (KNOWBOTS3 pass, S463) | v2: Dola 8/7, Maria 7/5 (play 7) S464; v3: Maria 7/6 (play 6) S465 - passes the 6/6 bar if fixed: the perk leak + the S&C shortcut | v3 written (S464); Dola scores v3 (SQ111) | see seat_queue |
| Club week (CLUBWEEK1) | v5 (DESIGN_CLUBWEEK1_V5_REVISE_KALLI_KALLI, S463) | (v4 scores in its file) | v5: Dola 8/8 S464; John scores v5; loyal1_probe re-measure before wiring #6/#11 | SQ98 |
| Gear (GEAR1) | - | his Q-212: after fight week | after AMATEURWEEK1 | - |
| Small living world | - | his S425: after the week | after the week | - |
