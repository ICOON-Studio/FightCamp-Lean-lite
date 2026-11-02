# S272 DIGEST - 2026-10-20 - Ziva ZIVA9 collected, rear uppercut from Meshy, Rokoko cuts measured, 20 s Black vs White fight

## Operator (verbatim)
- On the S271 Rokoko renders: "the animationslook fine and the fighter does not get distorted like previously , thisis very good"
- On rk_ShadowBoxing@19.50 "Jab (lead)": "i think this is uppercut , i do not see guard"; on @8.27: "this also cuts early"
- "how do we properly match the animations to our moves , are we missing a lot for the box and how much forkickbox ?"
- "we have enough videos already in our research to generate everything ?"; "we need sidesteps,dodges how can we find these";
  "do we have ovehead punch ?"
- "can you ooshow me some the rokoko clips with a white fighter" -> "actually can you make a clip of a fight 20 seconds ?" ->
  "black vs white" -> "weightclass" -> "rokokoks animations right" / "and meshy" / "but they need blending ?"
- "and have ziva rate the new animations and 3d fight realism"
- Board: no open questions, no unseen review comments on the S271 renders at start (newest C121, already closed).

## Landed
- 603acc7c Ziva ZIVA9 rounds 1-3 + LUDO10 items 3/5/9/10/11/13 (22 commits): applicant chip instead of the coach modal, day one at
  1x until the first gain, corner dim + call projections, impact tag, hit sparks + micro-shake, fight camera lowered to a 22 deg
  ringside broadcast (FOV 42). Conflicts resolved (GymHall3D: branch; FightWorldLiveScreen: kept the tag layer, dropped a
  duplicate _sync_corner_dim inserted mid-function). speed_lock_day_one_test fixed (const preload compiled before the
  CompetitionData autoload -> runtime load). 14/14 focused tests PASS. Camera + tag stills on the board: closes on his OK.
- 8b67214c rear uppercut = Meshy 194 (FightClipRokoko `meshy:` take, window 0.20-1.07 s, yaw +26). rokoko_clips_test RED on master
  (old Mixamo uppercut: aim -49 deg, fist behind the chest) -> PASS plain + as_game (forearm 73/66 deg, rise 0.42 m, fist 0.51 m
  ahead, aim -0.2/6.1 deg). Rejected: Meshy 193 (haymaker from hands at the hips), 196 (0.10 m rise, 0.60 m sideways).
  tools/rokoko_path_probe.gd (whole-path measure; `meshy=`, `trace=`). punch_labels: 5 of 10 Rokoko cuts are COMBOS (other hand
  0.59-0.74 m off the head = his "no guard"); 19.50 loads a rear uppercut at ~20.0 s; 11.80 is a rear straight to the body.
  4 Meshy Stand Dodges imported; anim_orbit_render `mx_<file>` roles (Mixamo library) for the dodge census.
  research/MOVE_SOURCES_S272.md = the matching method + coverage (boxing ~70% sourced, kickboxing ~25%, overhand none).
- 6e143a77 recorder `bodies=09,04` (FightWorldStage.forced_body_a/_b; the game never sets them) + the 20 s clip
  docs/previews/s272_fight/fight_20s_black_vs_white_heavy.mp4 (as_game seed 94301, heavyweights 09 African vs 04 European - the only
  Black/White pair inside one weight class). Sent + on the review board. Seen in it: chest-to-chest clinch range at 5 s with
  gloves on heads (FIGHTGAP1 spacing), camera swings behind the ropes at ~18-24 s (cut out of the 20 s).

## Agents
- Cursor NIGHTLY12 (issue #286 body rewritten, relabelled): camp_pays timeout, hold_pair_geometry timeout, clip_slice (red on
  master - likely REAL), stage_realism. #282 and #287 closed (collected 89bbcb42).
- Ziva ZIVARATE1 (TASK_ZIVARATE1.md) sent in the ZIVA9 thread, reasoning Max: rate the new clips, the old ones beside them (five
  worst), blending numbers, 3D realism -> ZIVA_ANIM_REALISM_S272.md. ZIVA9's last run had stopped at 04:59 on a provider
  content-filter false positive ("Jailbreak" label) - if it recurs, switch model in that thread.
- Cursor ZIVAFIX1 (#288) still running. John SQ6/SQ7 still in the seat queue.

## Measured, not fixed
- boxing_idle_binding_test under as_game: 24 fails ("scheduler uses retimed impact" on 11 roles + cross_body guard return) -
  IDENTICAL set with the S272 change removed = pre-existing (punch retime). Not in the nightly arm (plain). Next Cursor round.
- PC went RED on memory (94%) once Ziva's Godot started (5.2 GB) - no more Godot runs from Claude this session.

## Later in S272
- Operator: "meshys animations i think are not good" -> Meshy row OFF (cb2f402c). "can make a clip using only rokoko animations" ->
  FightMoves.palette_override + recorder palette= -> fight_20s_rokoko_only.mp4. "put thos 3 icons lower ,what are these anyway ??"
  -> corner shouts (Off the ropes / Go to the body / Tie him up, "N left" per round); the no-mastery row 200 -> 30 px (bottom edge).
- Operator on the fight: "i didnt see any of that onthe animations earlier" (deep squat, heads together), "this has nothing to do
  with the animations i see on the board", "bodies twisting again looking wierd andnothing is smooth". DECISION: mocap plays PURE
  (all synthetic fight layers fade on a rokoko_clip; root + spacing stay) - Ziva priority 1 (steered into ZIVARATE1), switch
  mocap_pure, red test vs the studio clip. Not measured by Claude: PC RED on memory (93%) during Ziva's run.

## John SQ6 landed (06:10)
Best lead: Fab Ailive "Boxing Animation Pack" (mocap per its page; hooks, uppercuts, duck, sway, footwork) - price/licence to confirm
in his Chrome; Rokoko 263 free pack (licence verified). MOVE_SOURCES_S272.md updated. A download needs his Chrome (Fab sign-in).

## Next (S273) - operator: "focus backto the gym ? next session ?" -> the GYM (LOOP1 two-stores fix first, roadmap now)
0. Collect Ziva's mocap_pure fix first (it decides whether the fight looks like the board renders).
1. Read the operator's verdict on the 20 s fight + Ziva camera/tag stills (review board) and act.
2. Collect Ziva ZIVARATE1: its five-worst-old-clips list decides what is sourced next; its blend numbers decide blend times.
3. Dodge/sidestep census: probe + orbit-render Mixamo Boxing_Dodge_* / Side_Step_* and Meshy Stand_Dodge_* (mx_/ms_ roles),
   bind the ones that pass to boxing_slip/pull; cut the Rokoko rear uppercut at ~20.0 s (guard-to-guard needs a per-take guard ref).
4. Lead hook + lead uppercut: no good captured source - Meshy library page / Mixamo search in his Chrome / John SQ6.
5. Collect Cursor NIGHTLY12; route boxing_idle_binding as_game reds.
