S121 (2026-09-28, Claude) - boxing 11/36 -> 16/36 (all five single punches); Q214 merged; nightly reds fixed; Qwen on the counters

Operator this session: "is this the right method to fix animations ? each move individually ?" -> answered: per-move CLIPS
yes (industry + D3), per-move hand-tuning no: variants of certified bases, counters as sequences of certified parts, shared
defects fixed once. "go ahead with that order if we do not deviate from the roadmap" -> punches, then counters as
sequences (= roadmap), footwork stays ONE GATED CLIP PER MOVE (a stepping SYSTEM would change the milestone rule - dropped).
"can you assign qwen to fix animation too ?" -> TASK_Q215 (counters group).

## Shipped (all on master)
- e46eaf64 nightly reds: muay_thai_ground_pin/_recovery removed (no ground game; smoke 700->698, 428->426, range 696->698);
  result_screen_why finds its own decision seed (92075); fight_contact_stop runs 60-180 s until it has 5 landed hands and a
  landed low kick -> exposed a REAL defect: a landed low kick stopped 4.96 cm SHORT of the thigh (the glove stop skips kicks).
  New `_stop_landed_low_kick` + `FightStagePlayer.stop_contact_leg` (hip turn of the airborne leg, 12 deg cap). 145/0.
  Control arm: body_layers_live / body_overlap / pair_live / stage_realism fail IDENTICALLY with the fix disabled (old reds).
- 8ebaa3c7 Q214 (Qwen) merged as its diff. Master re-measure, 3 seeds, now printing landed strikes + root gap
  (q213_clip_gate): head 6->4, arm 53->51, leg 7->5, torso worst 35.5->6.6 cm; landed 57=57, gap unchanged. Gate (head 0) OPEN.
- C223, each bound witness 4/4 legal rows (generator welter a/b, heavy c/d), mid-band, stills reviewed:
  - ea63100d boxing_shovel_hook: the S120 "lunge" was the base take's ROOT TRAVEL (unlayered control lunges the same) ->
    hold_root_xz + solved layer (elbow 3.7 cm off the hip line, forearm rising 44 deg); warp 0.60 (0.45-0.52 read onset at
    the 132 ms floor). 8.0-8.9 m/s, 167 ms.
  - 45b82b96 boxing_up_jab: certified jab + layer holding the lead glove LOW (1.20 -> 0.91 m) in the wind-up. 6.2-6.9 m/s.
  - 963c7af1 boxing_overhand: certified cross + over-the-top arc (fist 1.43 m, elbow above it, descends 13 cm) + 10 deg
    side-bend. 8.4-9.3 m/s, 250 ms. (H2H_Haymaker stays rejected.)
  - 8dd09195 boxing_inside_uppercut (NEW entry, was a pair fallback): certified lead uppercut, warp 0.55, compact layer
    (fist 9 cm closer, forearm 70 deg). 9.1-10.2 m/s, 367 ms. FLAG FOR THE OPERATOR: the rear glove rides to the temple,
    elbow up, mid-punch - it is in the SOURCE (control render, no layer) and in the S119-certified lead uppercut.
  - 6f9b313a boxing_cross_body: certified cross + level change (knees 3%, trunk 18 deg fold), strike span slowed 1.15
    (the fold pushed it to 10.8 of 11.5). 8.5-9.3 m/s, 267 ms.
- Tools: s120_layer_solve prints elbow + forearm rise and takes `at=<t>`; c223_production_gate `hold_root`, `warp=` override a
  variant row; v_cross_body row.

## Findings to carry
- FIXED S122 (see S122_DIGEST) - LATENT DEFECT (not in any shipped move): with hold_root on the RamsterZ hook, ANY Hips drop_frac drags heavy_c's planted
  rear foot 22 cm (bisected: base+hold clean, layer-without-hip clean, hip alone fails). rear_hook_body (Mixamo, drop 0.035)
  and cross_body (RamsterZ cross, drop 0.03) are clean. Fix before the next hip-drop layer. TRIED S121, REVERTED: giving a swinging foot its pre-drop clearance back in the plant bake changed nothing (22.45 cm identical) - the foot is not a swing foot pressed down; measure RightToes per frame next. Controls v_rear_hook_body / v_cross_body stay 4/4 bound.
- The UNBOUND audition fails `join_discontinuity` on every RamsterZ jab/cross variant even with NO layer (control uj21_0):
  the audition path does not phase-match the guard. Certify RamsterZ variants on the BOUND path.
- An onset reading one frame above a band floor is edge-tuned: move off it (shovel 0.45 -> 0.60).

## Q215 (Qwen, worktree Temp/FightCamp-Q215, branch qwen/q215-boxing-counters) - IN FLIGHT
Run 1 (ecfc8561) claimed 4/4 + 7/7: two rigs only, an invented 15 cm join rule, no stills, counter_over_jab = slip+cross,
pivot = a 90-deg turn, FightStagePlayer edited unowned -> send-back 1. Run 2 (fe8e0ddf) honest: 2/4 pieces (slip, pull) on
four rigs, 0/7 counters, no stills; it applied the reference jab's 0.001 guard-join floor to INTERNAL seams (the certified
one-two was never held to that) -> send-back 2 (running at handover): merge master, stills, judge counters with
tools/c223_sequence_gate.gd (the harness that certified boxing_one_two, reference row first), counter_over_jab = slip +
certified overhand, a per-foot pivot rule proven by a lead-foot mutant, catch glove at the face.

## Suite
No full suite in session (nightly rule). Nightly 2026-09-28 at 6d2a4201: 457/23. Fixed this session: muay-thai trio, smoke,
result_screen_why, fight_contact_stop. Focused subsets all green except pre-existing reds (identical with/without changes).

## Next
Collect Q215 send-back 2; then footwork (step_in_out, circle_lead/rear, angle_step, pivot_footwork, switch_stance, rhythm_change)
as ONE GATED CLIP PER MOVE from owned Mixamo step/pivot sources, using Q215's per-foot rule (the moving foot excluded, the other
judged); then feint + drawing; then the remaining combos. Boxing 16/36. No .exe until 36/36 (D3).
