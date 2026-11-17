# S507 DIGEST (2026-11-17) - fight motion week day 12

The owner played ArcheAge Chronicles all session (5-6.6 GB RAM, watchdog AMBER). Asked in the first message and in the
next-step box whether fight films may render on the hidden desktop while he plays - no answer yet, so no film this session.

## Nightly (05:00, @a05c139e, 369 pass / 11 fail)
- gym_life2 FIXED: it counted 7 hub places; TRAININGK1 (S496) added the 8th, Training. It now reads GymHub.PLACES.
- rokoko_clips red since S503's step lift: the captured-clip route is OFF in the game (S432 opt-in). Recorded, not chased.
- guard_knee, human_feet (foot 5 cm under the canvas, 1 frame), block_meet: known items. Written into roadmap NIGHTLY1.

## Head jumps: 77 -> 91 was mostly a different bout
- s505b and s506a play the same clip starts frame for frame only until frame ~1434 (48 s of film); then one is a frame
  late and the bouts go different ways. Jumps > 12 cm in the shared part: 20 vs 21.
- Per clip start (whole films): punch jumps 0.132 -> 0.168 a punch clip (FreeHand on: 0.162, `nofreehand` 0.154), reaction
  jumps 0.94 -> 1.06 a reaction (HeadEase on, `oldsettle` 0.89). Small real costs, not 14 jumps.
- Split by what moved (median of the jumps): root 2.4 cm, hips on root 1.3, trunk bend 6.3, neck/head on the chest 6.7.
  It is the trunk and the neck, not the slide.
- Every film comparison must count per clip kind and inside the shared part: HEADSPLIT1 (Qwen, running) makes that the
  ruler (scripts/rules/HeadSplit.gd + tools/head_split_probe.gd -- csv= csv2=).
- PopCap (HEAD_MAX_MPS 2.7 = 9 cm a frame) already caps the head - the jumps over 12 cm are its two exemptions: the 0.25 s
  after a hit (FREE_HIT_S) and the trunk under a held landing glove (PunchReach.held). The puncher's own head (50 of 91)
  is the clean target. Films needed.

## Hook fling fixed at its source (critics' r11 item 3: "hooks stop at the head")
- HOOKPAST1 collected (Qwen): s506a runs=35 past_p90 55.8 cm, fling_p90 6.1 m/s, 6 flings; worst pro_left_hook_ft 14.7 m/s,
  76.6 cm past.
- Traced in hit_frame_test (-- show=pro_left_hook_ft, a temporary trace in PunchReach._reach): the reach weight was 1.00
  while the glove left its aim by 0.29 m in one 17 ms frame. Two causes, neither the release:
  1. after the hit each frame's fit started from the CLIP's arm, which in the stepping hook's follow-through is 0.6 m off the
     face; the glove front follows the forearm, so a ring of wrists puts it on the face, and the fit found another one each
     frame. Fix: ReachLimit.warm_from / keep_warm - once the punch has landed, the armed hand's fit starts from last frame's
     solved wrist.
  2. the hand kept the clip's own turn, and the clip's fist turns up and over after a hook: the glove front swung up 0.26 m.
     Fix: ReachLimit.warm_hand - after the hit the fist keeps last frame's turn, easing back to the clip's as the reach
     weight drops.
  `-- nowarmfit` = the control arm for both.
- hit_frame: control 9 failures, fixed 4 (pro_left_hook 0.121, _ft 0.238, _hurt_ft 0.346, _hard_ft 0.180, right_hook_hard
  0.361 -> 0.05-0.09; pro_left_hook_ft now on its aim to the end of the window). Left, as before: pro_right_cross_hurt
  (SPEED/THROUGH/ON), right_hook_hard_ft SPEED.
- hit_frame's THROUGH reading now ignores a dip back under RETURN_M 5 mm (pro_right_uppercut_hurt read 0.031 on a 2 mm
  wobble, then carried to 0.085); it only reads a carry longer, so the control reads one MORE fling (hook_hard_ft 0.180).
- A/B on every punch test (control `-- nowarmfit`, failures): hit_frame 9 -> 4, hit_carry 44 -> 30, block_catch 11 -> 10
  (MEETS B_A pro_right_hook, already red, to_face 0.078 -> 0.065), punch_speed 41 -> 40, join_return 2 -> 3 (rep 3 of
  pro_left_hook: a hit-time event at f04 in every arm; 10.1 m/s at f06 with the fist hold, 8.3 at f05 with `-- nowarmhand`;
  alone, `only=pro_left_hook`, the fix passes and nowarmhand fails 10.6 - next lead), block_meet / punch_range /
  punch_weight / uppercut_tail / block_absorb / punch_end / head_aim unchanged.
- Tried and not kept: the warm start BEFORE the hit too (`-- warmpre`): pro_right_cross_hurt still 0.105 m off at contact,
  hit_carry 30 -> 31. Its fault is elsewhere (the solve flips on the way in: 5.4 / 6.6 / 2.4 / 5.2 m/s).
- PunchReach.gd sits at 499 of 500 lines: the warm fit lives in ReachLimit (solve_capped keeps the wrist).
- The film decides (HOOKPAST on the next film vs s506a).

## FILMED (owner: "Yes, film now")
- s507a (HEAD, WARM_DT 0.05): the stepping hook (pro_left_hook_ft, who 1 @3213) still flung 14.1 m/s. In the film the punch
  plays ~1.5x at 30 fps = 0.050 s of clip a frame, right on WARM_DT: the warm start was refused on exactly those frames
  (glove +21 cm up in a frame, then back). The headless test runs 60 Hz 1x (0.017 s) and never saw it. WARM_DT 0.12.
- s507b (WARM_DT 0.12): that hook 14.7 (s506a) -> 9.7 m/s, and what is left is the RELEASE, not a fling: the hand comes
  home 0.31 m sideways/back (z) and down in one frame while the reach lets go over OUT_S 0.16 s of CLIP time = ~3 frames
  at 1.5x. Next lever: the let-go measured in real time, or hold_one_way slower on fast clips (join_return's 9 m/s bar).
  Landed punches over 6 m/s after contact: s506a 3, s507b 4 (6.1-6.7 hooks, the same in s507a).
- Head jumps (HEADSPLIT1, s506a vs s507b): shared until frame 2136; shared part 34 -> 35 (punch 19 -> 20, reaction 14 -> 14);
  whole 91 -> 92. The warm fit neither costs nor buys head jumps - HEADJUMP1 is still to do.
- HEADSPLIT1 collected (Qwen): scripts/rules/HeadSplit.gd, tools/head_split_probe.gd -- csv= csv2=, head_split_test PASS.

## Seats
- HEADEASE1 PR 346 closed (collected S506). HOOKPAST1 collected. HEADSPLIT1 on Qwen.
