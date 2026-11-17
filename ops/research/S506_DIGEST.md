# S506 digest (2026-11-17) - fight week day 11

## Owner input at start
- Q-266, his answer: "i opened an arena shell and i saw the error" - the Godot install failure was ARENA's own shell, not
  Goose. Noted in ops/AgentComms/AGENT_TOOLS.md (Arena section): Arena briefs never ask it to run Godot.
- C425 (markup on the real scorecard still, 2 WRONG marks: "same info on the card twice"): the rank line ("Unranked: 1
  win from entering.") showed in the header AND under What it means. Now header only (ResultScorecard._means). result_tabs
  green. Same still: two judges named Doherty - ScoreSheet._judge_names now refuses a surname twice (score_sheet_test: 31
  of 300 seeds had a repeat on the old code, 0 now).

## Fight motion (the r11 critics' items 1-3)
1. FREEHAND (item 1, "the rear hand keeps falling to the belt"): GuardTuck holds the glove that is NOT punching at its
   guard point by the chin while a punch clip plays (FREE_W 0.9; body shot 0.5), the same two-bone solve as the guard
   tuck. GuardTuck.free_of(clip, lead) picks the hand (contact row's hand, mirrored for a southpaw;
   tests/free_hand_hold_test.gd). A beat whose AFTER fact is right_low / left_low (the drops-the-right habit raises it)
   lets that free hand go on that punch - the film log and the picture agree. `-- nofreehand` = control.
   A/B (each arm one run): block_meet 3/3, guard_knee 1/1, uppercut_tail 2/2, block_catch 11/11, hit_frame 8/8 - the
   same FAIL labels both arms (all already red, see the debt list).
2. HEADEASE (item 2, head reactions "eased out", peak 2-3 frames then back over 8-12): HitSnap's snap and trunk give
   settled exponentially - 26% of the snap given back on the frame after the peak (a spring). Now smoothstep home over
   SETTLE_S 0.30 (9 frames) / GIVE_SETTLE_S 0.40 (12); worst frame 17% (snap), 12.5% (give). `-- oldsettle` = control.
   fight_feel: 3 new checks red on oldsettle, green now. A/B on block_absorb, hit_frame, block_catch (red, same labels)
   and head_aim, hit_snap_gain, hit_step, knockdown_still (green both).
3. Hooks past the head (item 3), read only: hit_frame `-- show=pro_left_hook_ft`: the reach holds the glove on the face
   83 ms (0.07 m carry, right), then as its weight fades the glove jumps to the bag clip's own follow-through, 0.33 m
   past the face at 11-12 m/s - the fling. hit_frame does NOT run ArmHome (the game does: it brings the clip's arm home
   ahead of the reach), so the game's number must come from the film.
   Traced further (temporary prints, removed): on pro_left_hook_ft the reach weight stays 1.0 to +200 ms - it is NOT the
   release. The aim after contact is fixed (hit point + carry); the stepping take's body moves and turns away, the arm
   cannot reach and the glove rides the shoulder 0.34 m off the face at full weight. A release speed cap (HOOKSTOP,
   tried) changed no number in hit_frame and was taken out. The test plays the clip's own hips; the game's footwork rig
   may not - the film decides whether the _ft / hard hooks fling in the game.
4. HEADEASE side effect found and fixed: BlockCatch's knock on the CATCHING glove rides HitSnap's curves; eased, a
   blocked preview jab sank 3.2 cm into the glove (block_meet 3 -> 4 failures, the same both runs at its FIXED_FPS 30).
   BlockCatch now asks for the old spring (`envelope(t, true)`): block_meet back to 3. NOTE: block_meet runs at 30 fps
   (header FIXED_FPS 30) - at 60 it reads 14.

## Not done (the PC)
- No film: the owner was playing ArcheAge Chronicles (8.5 GB, on E:) the whole session; S505's rule - no renders and
  no heavy E: writes while he plays. The 180 s film (seed 7) vs s505b with tools/free_hand_probe.gd (FREEHAND1) and
  tools/head_ease_probe.gd (HEADEASE1) is the first job on an idle PC.

## Seats
- Qwen FREEHAND1 running (files written, not pushed at 12:40). HEADEASE1 queued for Qwen (ops/research/TASK_HEADEASE1.md).
- PRs 343 (LEANRED1) and 344 (PUNCHEND4) closed: both collected in S505.
