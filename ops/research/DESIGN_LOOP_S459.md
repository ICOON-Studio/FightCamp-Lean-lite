# S459 design loop - every mechanic to 6+ depth and 6+ general design

Operator S459: "use all free agents on loop until all mechanics have been designed . critics need to rate them at least 6 at depth
and 6 at general design etc". Tool: `python ops/Tools/design_loop.py critic|revise <ID> <map> --seat <seat>` (builds the brief:
task + CRITIC_PACK + map [+ critics], queues it on seat_queue; the 30-min reconcile sends it, answers land in ops/research).
DONE = two critics (one fresh) each at 6+ DEPTH and 6+ GENERAL DESIGN. Then it goes to his board, then the build.

| Mechanic | Map now | Last scores (depth / play or general) | Next step (seat) | Queue |
|---|---|---|---|---|
| Fight week (AMATEURWEEK1) | v8 (DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI, S463) | v7: Dola 8/8 (play 7), John 6/5 (play 6) S463 | Dola + John score v8 | SQ95, SQ96 |
| Coaches: fit, load, growth (COACHFIT1) | v5 (COACHFIT1_V5_MAP_S463, Dola; chat cut section 12 again) | v4: Kalli 6/4, Maria 6/4 | Kalli + Maria score v5 (told to count the missing wiring table) | SQ99, SQ100 |
| Hosted club show (HOSTSHOW1) | v4 (DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI, S463) | v4: John 7/7 (play 7), Dola 8/8 S463 | DESIGNED (two critics 6+): to his board, then build | - |
| A fighter leaves (R58) | R58_MAP_S439 | Maria 7/7 (play 6) S460, Dola 7/8 (play 7) S463 | DESIGNED (two critics 6+): to his board, then build | - |
| Training as a game (TRAINGAME2) | J (docs/mockups/s458/training_j) | Dola 7/8, Claude 6/5 | K from Claude J's list | Claude |
| Ask for a fight (ASKFIGHT1) | ASKFIGHT_MAP_S441 v4 | 5/6 | waits on fight week v7 | - |
| Push switch + tank (PUSHTANK) | PUSHTANK_MAP_V2_S442 | (read file) | Dola + Maria score v2 (S463) | SQ101, SQ102 |
| Progression (moves, styles, steps) | PROGRESSION_MAP_S448 v4.1 | approved by him (Q-211) | BUILD (PROGBUILD1, INTEGRATE1) | - |
| Read reveal (READREVEAL1) | no map | - | Claude drafts the map | next batch |
| Camp locations (CAMPLOC1) | camp v3 mockups S449 | - | map + critic | next batch |
| Contract ledger (LEDGER1) | - | - | map + critic | next batch |
| Weight (WEIGHT1) | WEIGHT_MAP_S434 round 2 (Claude) | r1: coach 7/6, sim designer 6/6; r2 never scored | Kalli + John score r2 (S463) | SQ103, SQ104 |
| Turning pro (TURNPRO1) | none yet | - | Kalli writes v1 from Claude's code facts + John's J_PRODEBUT1 (S463) | see seat_queue |
| Liver vs ribs (LIVERRIBS1) | v2 (DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI, S463) | v2: Maria 7/6 (play 7) S463; v1 John 5/5 | John scores v2 | SQ91 |
| Progressive knowledge (KNOWLEDGE) | KNOWLEDGE_S411 v2 + proof (KNOWBOTS3 pass, S463) | v1: 5/10, 6.5/10 (S411); v2 never scored | Dola + Maria score v2 | SQ93, SQ94 |
| Club week (CLUBWEEK1) | v5 (DESIGN_CLUBWEEK1_V5_REVISE_KALLI_KALLI, S463) | (v4 scores in its file) | Dola + John score v5; loyal1_probe re-measure before wiring #6/#11 | SQ97, SQ98 |
| Gear (GEAR1) | - | his Q-212: after fight week | after AMATEURWEEK1 | - |
| Small living world | - | his S425: after the week | after the week | - |
