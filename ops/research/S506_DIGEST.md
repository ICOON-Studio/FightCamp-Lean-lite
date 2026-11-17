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

## Films (owner S506: "go ahead film it now" - he was playing; log only, no movie, hidden desktop)
180 s, seed 7, trunktap, `tools/human_fight_film.gd` (the same fight every arm: both-off = s505b to the frame).
| film | free glove off (FreeHand) | free_p50 | head back frames (HeadEase) | peak frame | head jumps >12 cm |
| s505b (before) | 0.78 | 24.1 | 4 (spring) | 3 | 77 |
| s506_bothoff (nofreehand oldsettle) | - | - | - | - | 77 |
| s506a (both on, ease 0.30/0.40) | 0.30 | 19.0 | 13 | 4 | 91 |
| s506_nofreehand | - | - | 14 | 4 | 89 |
| s506_oldsettle | 0.30 | - | 4 | 3 | 85 |
| s506b (ease 0.24/0.32) | 0.30 | 19.1 | 4 | 3 | 91 |
| s506c (ease 0.27/0.36) | - | - | 4 | 3 | 93 |
- FREEHAND works: the free glove leaves the chin on 30% of punches (was 78%), drop p90 25.8 -> 14.0 cm.
- HEADEASE: only 0.30/0.40 eases (back 13 frames, no snaps); 0.24 and 0.27 fall back to 4 frames (the median sits on a
  cliff). Kept 0.30/0.40. Hit reactions grew: jab 12.1 -> 14.4 cm, cross 13.7 -> 16.7.
- COST: head jumps 77 -> 91 - by clip: punch frames 40 -> 50, hit reactions 34 -> 38. Trunk-tap shares unchanged (no one
  new layer). HEADJUMP1 (cap 8 cm a frame) is next and takes this on.
- HOOKPAST1 (Qwen, running): the fling ruler on the film, before the hook fix.

## Not done (the PC)
- No .exe export (a big E: write while he plays). The "no renders while he plays" line was MY caution after S505's
  freeze, not his rule - he asked "why is it blocking you ?" and said "go ahead film it now".

## Seats
- Qwen FREEHAND1 running (files written, not pushed at 12:40). HEADEASE1 queued for Qwen (ops/research/TASK_HEADEASE1.md).
- PRs 343 (LEANRED1) and 344 (PUNCHEND4) closed: both collected in S505.
