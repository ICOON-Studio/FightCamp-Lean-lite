# TASK PADPAIR1 - the coach holds the mitts, the fighter hits them: one paired pad round from Cascadeur (S239, LOOP1 slice 2)

Seat: Claude on the PC (Cascadeur is GPU + the operator's licence; S228 "Claude tests/stills/Cascadeur/merge"). DEADLINE: Cascadeur
ends 2026-10-27 - this is the first PC job of the next session. Model: Opus high (hard, visual). Discipline: BOXING (demo).

Operator (board Q-S237-1): "...the loop , animations,workout,feeling of progrsession and improvement from training these are what
matters for now". Today the fighter shadow-punches at the pads station and the MetaHuman coach idles beside him (still:
E:/FightCamp/review/2026-10-17_0623_loop1_on_the_floor_goal_card_top_meters_/02_coach_beside_him.jpg).

## Design (Ludo r105 PART A - research/ludo_rx/LUDO_R105_raw.txt lines 9-109; design values)
- One scene, BOTH MetaHuman rigs (the boxer body + mh_staff_coach), coach at origin facing +Z, fighter 1.15 m away facing -Z.
- 240 frames @ 30 fps, looping: idle bounce 0-18; jab contact 24 (coach right mitt eye height 1.62 m, push 20 mm, absorb 35 mm);
  cross contact 42 (left mitt 1.60 m); slip right 45-60 under the coach's mitt jab cue; counter cross contact 66; left hook to the
  body contact 96 (mitt at the coach's rib 1.15 m, palm down 45 deg); circle 99-120; 1-2 burst contacts 134 / 144; glove taps 151-200
  (172); reset 201-240 back to the frame-0 pose (loop seam).
- Coach recoil: on contact T, pin the mitt hand, at T+2 move it 35 mm back along the punch line through shoulder + thoracic spine.
- Export TWO GLBs of identical length, root motion baked into bones, no drift over loops: `mh_pads_fighter_loop.glb`,
  `mh_pads_coach_loop.glb` (Godot/assets/anim/metahuman/).

## Route (read first)
research/ANIMSOURCE1A_DIGEST.md (the native MetaHuman source prep, per-move authoring, physics, raw-GLB review) +
Tools/cascadeur/README.md (`python Tools/cascadeur/ensure_server.py --hidden`, csend.py, apply_pose/measure_contacts for two bodies,
export_pair.py). Recycle only a saved hidden instance between scene loads (Physics Assistant deadlock).

## Wire (GymHall3D, switch pad_pair GAME_ON)
At the pads station when the coach has arrived (COACHWALK1): stand the two bodies at the station's work point 1.15 m apart, facing,
start both clips on the SAME frame, `seek` the coach to the fighter's position whenever they drift > 0.016 s (Ludo A3); both
speed_scale = GymHall3D._work_clip_pace's value (better hands = faster round; Ludo A4). No coach = the old solo pads clip.

## Gates (visual-gate skill, .claude/skills/visual-gate/SKILL.md - all of it)
1. Red on the shipped tree: a game-camera still of the pads station shows the coach NOT holding mitts (the still above is it).
2. measure_contacts: fist-to-mitt distance at frames 24/42/66/96/134/144 <= 4 cm; no interpenetration of the two bodies > 2 cm.
3. Game-camera stills via Godot/tools/still_framing.gd save_if_framed (`record_room ... as_game`, hidden desktop) at frame 0 (guard)
   and at contact 42 and 96 (mid-move): gap, noses, wrists, feet per still; then a short clip of the round for the operator.
4. Operator's OK on the board (review_add + ask --attach) closes it. A test alone closes nothing visual.

## Prior research
C210_DRILL_MOTION_SOURCES.md (no free pad-work mocap exists), topics/paired_holds.md, J30_MOVE_SCRIPT_METHOD.md (Cascadeur two
characters + contact/AutoPhysics), S238_DIGEST.md (the 12 Ludo web coach takes were T-pose arm swings - unusable).

## What would a human do?
An animator puts both characters in one Cascadeur scene, keys the contact poses first (mitt flush on the glove at each impact),
lets AutoPhysics fill the in-betweens, then fixes the feet so neither man slides across the loop seam.

## Prefab check
Mixamo: no mitt-holder (mixamo_s215_catalogue.json, 121 clips, none). CMU subject 14 "boxing" is solo. ActorCore free: none. -> author.

## The one trap
Two separate clips drift apart and the mitt stops meeting the glove after a few loops - one clock drives both (seek on drift), and
the contact gate is measured on the GAME's playback, not only in Cascadeur.

## S242 route notes (Claude, read before starting)
- Sources (gitignored, not in master's checkout): `E:/FightCamp/wt/ANIMSOURCE1/Tools/cascadeur/animsource1/` holds
  `MetaHuman_source.casc` (7.9 MB), `RIG.json` (26.5 KB, native MH controllers + joints), `guard_pose.casc`. Copy them into
  `Tools/cascadeur/padpair1/` (add a .gitignore like animsource1's) - never author inside the ANIMSOURCE1 worktree.
- Two characters in ONE scene needs `File > Import > Import Scene To Current` (a GUI file dialog - not drivable on the hidden
  desktop). Route instead: TWO runs of the same native rig in ONE shared world frame - coach at origin facing +Z, fighter at
  (0, 0, 115 cm) facing -Z (yaw 180). Author the fighter's fist targets first; each coach mitt key = the fighter's fist world
  position at that contact frame (+ the 35 mm absorb at T+2). Fighter local = R180^-1 (world - (0,0,115)).
- Reuse `animsource1/author_moves.py`'s controller keying (`hand_MainPoint_*`, `lowerarm_LimbDir_*`, pelvis/spine shift, foot pivot
  about the ball) and `produce_move.py`'s run order (watchdog -> ensure_hidden -> load source -> key -> AutoPhysics switch + snap ->
  finalize export -> normalize -> animation_only strip). 240 frames instead of 20.
- AutoPhysics moves hands a little: the 4 cm contact gate is measured on the GAME's playback of both exported GLBs, not in Cascadeur.
