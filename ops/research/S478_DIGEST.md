# S478 digest (2026-11-15)

## Glove clipping (CLASH3) - root found, three fixes merged
- **Trace:** tools/clash_meter.gd + hit_frame_film.gd now print each boxer's layer `trail` on every clash frame; a temporary
  GloveClear dbg printed the peer hand's rank/kind and armed clip.
- **08_cross (seed 77) was a LANDED cross** (glove 3 cm from her face at f18), not a blocked one - so BLOCKCLIP1's BlockCatch
  constants could never touch it. At f27-f29 a **blocked rear hook** (`pro_right_hook`, clip t 0.20, contact 0.78) is armed on
  the same hand while it comes home. GloveClear marks a blocked punch kind 2 = "BlockCatch's to meet" and her guard hand
  skips it, but BlockCatch rises only RISE_S (0.25 s) before contact: for ~0.5 s nobody moves.
  **Fix (1c1b3629):** kind 2 only inside the catch's rise window (`_block_up`). Seed 77 08_cross 5 frames worst 0.099 ->
  4 frames worst 0.036; every other shot and seed 4242 identical; regression sets = main.
- **BLOCKCLIP1 (Qwen) merged as a diff (4bdbae47):** MEET_M / SURFACE_M 0.075. 09_cross 4.1 cm -> clear; nothing else moved.
- **OWNGLOVE1 (Qwen) merged as a diff (4af31f4d)** with Claude's order change: Qwen's own pass ran once after the cross pass and
  pushed guard gloves back into the opponent's (seed 77 6 -> 8 frames, 4242 08_jab 2.8 -> 5.4 cm). Own-before-only failed
  own_gloves (0.124). Final: own pass, then OWN_ROUNDS = 2 rounds of (other boxer, own). own_gloves 0.100/0.127 -> -0.007/
  -0.011 (green); OWN frames > 2 cm ~140 -> 0 on both seeds; cross frames 10 -> 8.
- **Left (CLASH4 on Qwen):** 4242 08_jab f40 5.4 cm - both boxers read each other a frame late (`late true` on both), so each
  predicts the other's guard glove and misses. Also 09_jab f19 5.7, 07_cross f19 4.7, 08_cross f29 3.6, 03_lead_uppercut 2.3.
- **Dropped:** claude/clash3-glove-axis (its gain on cross 09 came from BLOCKCLIP1 instead; it carried a block_meet regression).
- Stills on the review board: docs/clash3/cross08_f27_before_after.png, docs/ownglove1/seed77_01_rear_uppercut_f33.png.

## Design loop
- Coach fit v8: John 7/6 + Dola 7/7 -> **passed**. Weight r5: Dola 7/7 + Maria 7/6 -> **passed**. Both on his board with a
  plain page each (BOARD_COACHFIT1_V8_S478.md, BOARD_WEIGHT1_R5_S478.md): Q-232 scale fault, Q-233 70/65 kg classes,
  Q-234 men's 57.5 kg, Q-235 approve coach fit. Weight's code checks answered from the code (7,700 kcal/kg, goal missed -20,
  PlanRead 2 free uses then x0.7).
- Plan flowchart v3: Maria 7/6/6; John (SQ151) out.
- Fight week v9 (Kalli, sparring partner screen replaces trips) in -> Dola SQ155 + John SQ156 critics.

## Seats
- STYLE1 (Arena): stopped at once - its sandbox has no Godot. Told it to fetch the official 4.7.2 Linux build, import, run the
  probe and put error lines in the PR if a run fails. Lesson: every Arena probe brief must say so.
- CLASH4 to Qwen 02:37 (TASK_CLASH4.md). STEPMASTERY1 was already done (S463 f9791ce6): row moved to done.
- Build exported (Builds/FightCamp.exe), WHAT_TO_TRY S478.
