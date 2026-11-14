# S465 digest (2026-11-14, Claude Opus 5.5)

## His board, answered at start
- Q-220 R58 a fighter leaves: "Yes, build after the fight week" -> stays behind AMATEURWEEK1.
- Q-222 HOSTSHOW1 and Q-223 PUSHTANK: "Show me the map first" -> two map pages drawn (docs/mockups/s465/hostshow_map.png,
  pushtank_map.png: the decisions in time order + every menu each mechanic shows on), re-asked as Q-224 / Q-225 with the maps attached.
- C388 "doesnt look good, needs redesign" (what to learn next): rebuilt as tiles (FighterPage._study_tile): the study slot as one
  bar, the coach's three cards side by side (move, kind, weeks to usable, why, one Study button, why a grey button is grey);
  raw ids become game words ("Opens Push off"). study_pick_walk_test green; real still docs/mockups/s465/study/ on the review board.
- C389 "clipping" (rear uppercut tail, +150/+200 ms): see Glove clash below.

## Glove clash (C389)
- Cause: GloveClear kept a glove out of the other boxer's HEAD only; nothing kept it out of the other's glove or forearm.
- Fix (GloveClear._clear_arms): each boxer publishes its arms as shown (elbow, glove centre, landing-locked); a glove keeps
  0.12 m from the other's glove and 0.10 m from the forearm segment; each side moves 0.6 of the overlap, or ALL of it when the
  other glove is a landing punch (PunchReach on). Log: the rear uppercut's tail keeps its reach weight ~290 frames, so with a
  0.6 share alone the gloves stayed partly inside each other. `-- noclash` = the control arm.
- Evidence: same punch (hit_frame_film seed=4242 uppercuts=1) filmed with and without; his original frames reproduce on main.

## CARDVISIT1 (Qwen, collected; Claude rerun on main identical)
- The "outside" card is never reached (0 of 8382 exchanges): PlanFight.GAME_CARD never names it; the only way in is a WON
  step_out from long. So step_in, feint and 1-1-2 can never fire, and 13 ANSWERS "best" pairs (incl. the she_tired / she_hurt
  answers) are paper. A design call (the card table / answer table), not a node merge.
- CARDFIX1 briefed for Qwen (ops/research/TASK_CARDFIX1.md): four card-table arms (today; counter -> outside; + she_tired ->
  long; + range -> outside), reach, win balance 40-60, and whether step_in / feint / step_out then change results.

## LANDREACH1 step 1 (docs/LANDREACH1_RESULT.md)
- Two landed crosses on the game camera, seed 4242: 1.6 cm and 16.5 cm off the face; the second looks landed on the broadcast
  angle (the gap is along the camera's depth). Still on the review board for his eye. Step 2: the POWER1 stack's clip _c contact.

## Design loop
- TURNPRO1 v1: Dola 7/7/6, Maria 6/5/5 -> Kalli v2 in -> Dola + Maria (SQ113/114). (Dola's file also quotes Kalli's own 6/6/5
  inside the map; that is not Dola's score.)
- Knowledge v3: Maria 7/6/6 (passes the 6/6 bar once the perk leak and the S&C shortcut are fixed); Dola SQ111 queued.
- John's SQ91 (LIVERRIBS1 v2) sat 8 h with no answer (dead bot turn): resent; SQ96/98/104 follow it.

## Board hygiene
- live_runs: KNOWBOTS2, NODEREAD1, KNOWBOTS3, TREEVALUE1, CARDVISIT1 archived (collected) - `start` stops printing COLLECT NOW.
