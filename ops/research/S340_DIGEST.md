# S340 digest (2026-11-01) - Lean update 42: attributes board, the clinch's price, fight flows; agents on ring staging, clinch, pad work

## Operator input this session (verbatim)
- Board Q-S294-64 (fight flows): "Yes, boxing and wrestling now".
- C156 (hair fix still): "fine". C157 (Lucy's Overview, the attributes box): "need something way more fancy, and also there
  are attributes missing there".
- "someone also needs to perfect the clinch" -> CLINCH2 (Goose).
- "during clinch a small stamina refill but risk of getting hit" -> ClinchRest (Claude).
- Scouting in stages ("each opponent needs to be a big deal to study and decode ...") -> SCOUTING_S340.md, board Q-S294-65.

## Shipped (Lean main)
- b67a838 attributes board (C157): AttrBoard + AttrRadar - radar of 8 fight attributes vs her potential (dashed), every value
  the bout reads in FIGHTING / BODY / MIND (footwork, heart, discipline, confidence, coachability, temper were used by the
  fight but never shown), band-coloured tiles, this week's change, hover = what it does in a fight, AT A GLANCE note.
  Overview (full width) and the Attributes tab. tests/attr_board_test.gd.
- f9c0a93 TIECLIPS1 (Qwen, ff-merged): WrestleChains.clip_for "#id" exact match; the 3 tie-up answers without a clip now play
  GrappleMap #946 / #1385 / #1353. tests/tie_clips_test.gd. Not visually checked (existing public-domain transitions).
- b820bb6 + 447611f the clinch's price (ClinchRest): a tie (corner call, tie-up arrow or instinct, the clinch card) gives back
  1.5 energy (the tie call keeps its own -2); the opponent lands short digs in ~44 % of a presser's tie-ups (BASE 0.30 + style
  + (rating - technique)/100, 0.10-0.65): 2.5 margin a dig, a shot on the break 8 damage; own dice (exchanges without a tie
  play exactly as before). Words line on fight night; the tie call's button says the risk. Her clinch beat carries
  digs/digger for CLINCH2. Balance gates green: plan_bout 0.039, balance_harness, exchanges, habit_fix.
- 44e4f4c fight flows (Q-S294-64 steps 1+3, both sports): FightFlow (pure, sport-free layout + WHEN labels + lit) and
  FlowView (sticky notes, marker arrows; returning/row-skipping arrows route round the right; labels drawn last). Opens from
  the boxing plan board ("See the flow"), the tie-ups plan ("See the flow") and the fight result ("Her plan, lit up").
  tests/fight_flow_test.gd, tools/flow_still.gd. Stills: E:/FightCamp/tmp/s340_flow/*.png.

## Agents (S338 rule: animation only)
- FIGHTCARD1 (Cursor): round 1 8a31e2c passed its tests but FAILED the visual gate - the forced card held for 2 exchanges only;
  own_ropes/corner stills showed both women mid-ring. Round 2 running (force every exchange + CARD STAGED probe).
- CLINCH2 (Goose, issue #14): perfect the clinch (A-frame lean, overhook, jostle, digs, the break) - running.
- PADWORK1 (Goose, issue #13): round 1 39cd654 reported PAD CONTACT 3/3 but every gap was exactly 0.040 (measured its own
  mitt) and the still was EMPTY on a real GPU; round 2 running.
- SMOOTH2 / TAKEFIX1 belong to the fight-stills session (5031cc), untouched here.
- Qwen idle with a reason: every fight-motion file is held by the runs above.

## Lessons
- A green probe that prints the same number for every sample measures itself (PADWORK1 0.040 x5) - check the variance first.
- A forced test arg must hold every time the state is rebuilt (FIGHTCARD1 `_force_at` ran twice; where_next overwrote it).
- A flow layout needs longest-path rows (a place below every place that leads to it, unless it closes a loop) or arrows run
  through cards.

## Next (S341)
Collect FIGHTCARD1 r2 / CLINCH2 / PADWORK1 r2 (stills on the hidden desktop first). Claude: flows step 2 (branches by the
opponent's game: arrow `when`, PlanFight.choose by sit, the WHEN picker), then OPPPLAN1, PLANPADS1; scouting in stages once
Q-S294-65 is answered.
