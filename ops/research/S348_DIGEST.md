# S348 DIGEST (2026-11-01) - update 49: the Playbook page, her own holo + close-ups, hover her liver, referee off the lens

Lean commits: 32d8dd3, 89c8dc8 (+ WHAT_TO_TRY / build commit). Game: briefs, roadmap, this digest.

## Operator input this session (verbatim)
- Board: Q-S294-70 "After boxing, as the MMA update (recommended)"; Q-S294-71 "Yes, build it" (Playbook).
- Comments: C196 "needs to see video of it" (move player); C197 "doesnt look good , needs a lof of refining" (corner card);
  C198 "looks fine ,needs speed up for a fight , butt looks good for training clip" (grapple chain); C199 "still not great ,
  the holo need to link to tooltips when mouse over head or liver to show stats like damage taken etc"; C200 "the right holo
  has nothing to do with the actual fighter wtf".
- Chat (pictures): "someideas abot the holo" (anatomy charts with close-up circles, a glowing body with organ callouts, a
  martial-arts family tree); "this is a nice idea for training screen setup" (MMA home training: fighter in the middle,
  8 numbered exercise cards around); a "Build a smart combination" sheet (6 numbered steps, key lesson strip); "ideas for
  training screen" (round-by-round pad combos with numbered move pictures + FOCUS; a six-pack sheet, figure + 9 numbered
  cards; gym equipment cards with a body diagram of the muscles each trains).

## What now works (evidence)
1. C200 - the holo is HER: `body_skin.gdshader` makes only her kit clay (a red-hue pixel inside her body parts, any blue
   one); skin, hair, face keep their colours. Stills: docs/playtest/S348/fight/p01_round1_open.png, callouts.png.
2. C199 - `scripts/ui/BodyTip.gd`: on her head / eyes / nose / ribs the tooltip says what landed there (by kind), the big
   shots, the last punch and its round, how hurt (fine / hurt / badly hurt / the doctor may stop it), a cut; her right
   ribs are the LIVER; the place under the mouse is ringed. Real route checked on the hidden desktop: fight3d_play
   "the mouse on her liver reaches her body view", "her liver is ringed", tooltip "LIVER (RIGHT RIBS) fine (94/100) /
   Took 4: 4 body hooks / Last: body hook, round 2" (p06b_hover_liver.png). body_tip_test 5 parts PASS.
3. The holo close-ups (his anatomy pictures) - `scripts/ui/BodyCallouts.gd`: HEAD (her face), LIVER, RIBS round close-ups
   cut from her own portrait in the strip beside the figure, leader line, band-colour ring + number, white flash on a hit,
   hover = the worst place's tooltip. GPU: p06d_hover_callout.png ("the mouse on HEAD reaches the close-up").
4. Referee off the lens (C200's round-1 still): `Referee.LENS_KEEP_M` 2.2 m + spot scoring; `RingCamera`: cut when he is
   within 2.0 m in any mode, the next shot opens on the side away from him, no shoulder shot while their hips are < 0.75 m
   (a clinch), a boxer within 1.3 m of the lens cuts (min hold 0.6 s). ref_probe 150 s: control arm (`nolens`) 24.6 % of
   frames within 2.2 m, closest 0.08 m -> 0.1 %, closest 1.91 m; his head between theirs on screen 12.7 % (control) ->
   13.9 %; 12 cuts a minute (the director's own pace) - no cut storm.
5. PLAYBOOK menu area (Q-S294-71 step 1-2) - `scripts/ui/areas/Playbook.gd`: fighter picker, Moves / Plans / Combos /
   Escapes tabs; StrikeBrowser embedded (signal move_picked, no Back, cards sized to their slot); MovePlayer on her own body
   (Faces.pair), Replay, Slow motion (MovePlayer.speed: clips, contacts, hold, ghost reaction). tools/playbook_film.gd 9/9
   OK + film docs/playtest/S348/playbook/playbook.mp4 (C196's video).
6. FlowView in the whiteboard palette (C191/C192): flow_boxing_lit.png.
7. Tests: run_tests.sh JOBS=2 all PASS (before the close-ups); body_tip_test, body_figure, body_turn, ring_lens, fight_flow.

## Decided (Claude, the developer)
- The holo shows her own skin; only the kit is neutral (both corners): identity first, the burn colours stay readable.
- BodyFigure stays under 500 lines: hover/tooltip text in BodyTip.gd, close-ups in BodyCallouts.gd.
- SMOOTH2 had two red rounds -> code audit (mine) before round 3. Three defects: (1) JoinSmoother carries the SOURCE
  velocity projected on one axis, not (source - target) - not the dead blending its header claims; (2) a join started from
  `animation_finished` (every return to guard) captures before the new clip's pose lands, so that pop is unsmoothed;
  (3) six layers after the smoother switch per clip unsmoothed. Fix order + measures in TASK_SMOOTH3.md (Goose, issue 18).
- Ground: after boxing as the MMA update (Q-S294-70), paper rules in parallel (GROUND3, Qwen) - not in the career.
- C198: the grapple chain stays the training-clip pace; the fight pace waits for the MMA update (GrappleTiming factor).

## In flight (collect in S349)
- GROUND3 (Qwen, wt E:/FightCamp/wt/LEAN_GROUND3, branch qwen/ground3) - GroundRules.gd + ground_rules_test.
- COMBOFLOW1 (Cursor, wt E:/FightCamp/wt/LEAN_COMBOFLOW1, branch cursor/comboflow1) - ComboFlow.gd + combo_flow_test
  (Playbook step 3). Round 2 adds "move your head after punching" (his combination sheet: a chain ending on a defence or
  step scores).
- SMOOTH3 (Goose, ICOON-Studio/FightCamp-Lean issue 18) - the join fixes from the audit.
- Waiting since S347: PADWORK1 r3 (Goose #13 5633c78), CLINCH2 (Goose #14 31ccc38) - collect on the GPU.

## Training screen (Q-S294-72 on the board, mockup docs/playtest/S348/training/training_mockup.png)
His pictures, read: her in the middle, 8 numbered cards around (load, focus, weight, learning, combo, pads, rounds,
roadwork), each with a leader line to the part it trains; plus, from the later pictures: each card a small body chip with
its muscles lit (BodyTrack colours, as the gym equipment cards); "Pad rounds" opens a round-by-round plan - each round a
named combination with numbered move pictures and three focus points (Playbook "Drill this" fills it); the same muscle
chips later on the gym's stations. Build only on his yes.

## Next (S349, in order)
1. Collect GROUND3 / COMBOFLOW1 / SMOOTH3 when they land (Monitor on agent_events.py); PADWORK1 r3 + CLINCH2 on the GPU.
2. Q-S294-72 answer -> the training screen (cards + muscle chips + pad rounds plan).
3. Combos tab on ComboFlow (his "Build a smart combination" layout: numbered rows, a still per move, key-lesson strip).
4. C197 corner card refine under the new lens (FIGHTCARD1's CARD probe on main).
5. Playbook map in the martial-arts-tree look (glowing paths between picture cards) - his holo pictures.
