# S347 digest (2026-11-01) - camera inside the ropes, a lighter HUD in our colours, her tells on her body

## What the operator said (verbatim)
- Board review comments at start: C191/C192 (flow view) "decent but not in par with other menu colours"; C193 (HUD rings)
  "decent it reminds ufc6 too much though ?"; C194/C195 (marked the body view) "still poor".
- On the grapple film (C:\Users\user\Downloads\grapple_walk.mp4): "what ahppenned with this ? how we implement this into
  the game ?" / "can we use it also in training besides in the fight itself ?" / "was that mp4 with the grappling made with
  our game engine ?" / "thenit seems we can have the grappling and everything else in early acess , or no ?"
- Board Q-S294-70 answer: "After boxing, as the MMA update (recommended)"; then in chat: "we can work on bjj at the same time
  as boxing , but need also to work on the training mechanics and menus and fighter profile" (kept as the follow-up).
- "this transparent rope on all your stills start to become annoying, why you do not change angle ?"
- "maybe add a planning page on the ui to work on the training moves and plans ? wher you can try comboos/transitions,escapes
  etc and see all the animations ?" -> Q-S294-71 (PLAYBOOK_S347.md).
- "https://www.youtube.com/watch?v=IGICYFyP_EI check all the links in the description and install anything usefull" ->
  AINEWS_IGICYFyP_EI_S347.md: nothing installed (no two-body motion; NVIDIA-only tools; Audio8 TTS kept for a later voice).
- "you learned how to make nice tooltips , use your skills to lighten the ui/hud".
- On the stage director: "i hope this doesnt mess our animations, because the look fine on the opsboard but when played in
  the fight are not looking so smooth" -> the director is camera only, off only in the still tool; smoothness = SMOOTH3.

## Shipped (Lean, pushed)
| Commit | What |
| --- | --- |
| 387993b | TELLS1 collected after a code audit (Goose #17 r2 read 1/4 on the GPU twice): TellPose._place_hand put the forearm back on the OLD elbow -> PunchReach.solve two-bone; lunge lean 16 -> 26 deg. tell_probe read bones outside the modifier pass (Godot restores the animation pose after the skin update) -> caches the shown pose in skeleton_updated; bounds from a `-- notell` control arm. GPU: TELL OK 4/4, notell 0/4. tell_still: shot seconds after the tell (fired beats at t 0), hips-only framing, the ring director re-placing the lens -> fixed. RingCamera: every broadcast lens and the close-up INSIDE the ropes (IN_M 0.4, smallest turn toward the open ring, closer + wider when needed). ring_lens_test. Suite 84/84. |
| 1c7d2e0 | Lighter HUD: rings in her corner colour (engine) + ivory body ring (amber/red only when hurt), faint glass panels; body view as clay (body_skin.gdshader `clay`, softer part blends); the colour key and punch stats moved into the figure's tooltip (BodyFigure.extra_tip). RingCamera keeps its turn near the ropes (no flip). |
Evidence: GPU stills docs/playtest/S347/ring_lens_inside_fight.png, hud_light.png, hud_light_round1.png,
docs/playtest/tells/tells_sheet.png (all opened by me; on the review board).

## Collected / closed
- FIGHTCARD1 r5 (Cursor): STOPPED by me - its card_stage_test had hung 53 min beside a headless editor left open since
  13:17. Its last push 6f1df14 rendered on the GPU: corner card CARD VIEW 0/12 (the lens jammed behind a boxer's back),
  own_ropes 6/12, ropes across bodies. Five rounds -> not merged; the ring camera is now Claude's (the inside-the-ropes rule
  replaces its hard-cam work). Branch cursor/fightcard1 kept for its CARD probe (tools/fight3d_play.gd card=...).
- TELLS1: merged (above). MOVEPLAYER1: already merged S345; wiring folds into the Playbook (Q-S294-71).
- NOT collected: PADWORK1 r3 (Goose #13, 5633c78) and CLINCH2 (Goose #14, 31ccc38) - first collect next session.

## Decided (Claude is the developer)
- The lens never stands outside the ropes (RING_HALF 2.75, IN_M 0.4, MIN_DIST 1.9 m, HALF_H 1.0 m); the see-through rope
  stays only as a backstop. Real broadcasts shoot across the ring; our ringside lenses at chest height were behind the ropes.
- The body view is clay everywhere (fight, pages): her own shape, heat colours never mix with her kit.
- Grapple: the film was our own Godot render (GrappleMap joint data retargeted live). Plan GROUND_INTO_GAME_S347.md:
  paper rules decide, the plan board steers, the 3D shows; training = drilling + positional sparring.

## HANDOFF
Working commit: see roadmap now.last_working_commit. Next session, in order: (1) the flow view in the whiteboard menu
colours (C191/C192, still open). (2) Collect PADWORK1 r3 + CLINCH2 on the GPU (visual gate). (3) Delegate the BJJ track
(operator: in parallel): GROUND3 paper rules from research/topics/ground.md + G75 to Qwen/Arena; SMOOTH3 audit of the
clip-change joins with tools/smooth_probe.gd control arms. (4) Training mechanics, menus, fighter profile - the
Playbook once Q-S294-71 is answered. (5) Corner cards with the new lens: run FIGHTCARD1's CARD probe on main.
