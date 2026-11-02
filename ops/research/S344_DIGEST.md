# S344 digest (2026-11-01) - the flow in the tape room's look, the operator's still comments, UFC 6's HUD

## Shipped (Lean 9257b55, pushed)
- TAPEFLOW1: FlowView (plan board "See the flow", the bout's lit flow, the tie-up flow) in the tape room's GrappleFlows look:
  white cards with a still of the position (assets/ui/flow/<card>.png, baked by tools/bake_flow_stills.gd through TapeFilm's
  hard camera), name + the coach's first cue (both cues + stay-here lines on hover), the arrow's words in a pill.
  C162 ("maybe some special visual effects and animations ?"): cards rise row by row, arrows draw in, a dot runs along each
  arrow. Arrows that go round travel in the row gaps and a lane right of every card (the first still ran Step back behind
  Inside). Tie-up cards have no still yet (words only). fight_flow_test checks cards, cues, pills, the still.
- C174 ("make it clear to the player what it does"): the WHEN pills say live "Your next move: she throws it only when she
  tires - her answer to that."
- C177-C182 ("why the rope is not transparent"): tools/fight3d_clip_sheet.gd switched the stage's frame off, so the camera
  never faded the ropes as the game does (S311); it calls clear_view now (docs/playtest/S344/ropes_faded_clip_sheet.png).
- "remove stills that have been commented": 28 commented files moved to the board's Removed tab (restorable).
- C163-C171 "fine"/"ok" (tape room, trimmed screens); C172/C173/C176 were on the S341 screens S342 already trimmed.

## UFC 6 HUD (operator: "gotta beat this, check what 6 stats they show")
eyes on youtube 7I_jixI6Y6o: per fighter a shield/white bar, head, body, legs (two lines), stamina (yellow, grey end = lost),
a white-flag purple bar; plus a grapple-advantage tick meter top centre. Plan to beat it: research/FIGHTHUD_S344.md,
board Q-S294-69 (six bars tied to calls, round-edge meter, her guard/heart "?" until scouted).

## Visual gates on the real GPU (agent claims re-measured)
- FIGHTCARD1 r4 (Cursor da50828, claimed CARD VIEW 12/12): FAIL - the referee fills the lens on own_ropes and corner
  (docs/playtest/fightcard1_r4_red). Reverted; CardStage.gd kept. Round 5 running (ref_cover <= 0.10, lens_ref_m >= 1.5).
- TELLS1 (Goose 221acf7): the probe never awaited its measurements (printed 0/4 at once); awaited on the GPU: 1/4 (hand drop
  0.155, guard sinks 0.049 never held, lunge slides the whole body 0.65 m). Out of the tree; round 2 dispatched.
- MOVEPLAYER1 r2 (Goose 4c9fb26): FightStage bodies, but it regressed every S343 fix (clip advance, measured gap/alpha,
  ghost react at contact). Merged by hand in E:/FightCamp/tmp/MovePlayer_merged_s344.gd (+ moveplayer_probe_r2_s344.patch),
  NOT verified, NOT on main.
- PADWORK1 r3 (5633c78) and CLINCH2 (31ccc38) landed - uncollected.

## Lessons
- Never chain `python Godot/tools/check_scripts.py` with no file: it parse-checks the whole old repo and blocks the chain.
  Lean parse gate: `godot --headless --check-only --script res://<file>`.
- An agent probe that calls coroutines without `await` prints its verdict before measuring: read the probe before its line.

## HANDOFF
Working commit Lean 9257b55. Next: Q-S294-69 -> FIGHTHUD2; collect FIGHTCARD1 r5 / TELLS1 r2 / PADWORK1 r3 / CLINCH2 with the
GPU visual gate; verify + wire MOVEPLAYER1; TAPEFIGHT1; scout trip + OPPPLAN1.
