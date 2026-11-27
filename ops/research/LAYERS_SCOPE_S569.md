# LAYERS - draw the fight the fighting-game way: one man per picture, the page owns each man's spot (S569 scope)

Owner S569, on fighters snapping across the ring: "the fighter get displaced without moving"; "sohow fighting games cope
with distance ? what are we doing differently ? ... cant we find a sweet spot"; "if you know the right provcess thenwtf
are you doing ?". His wish since S551 stands: "seeing every card being executed by the fighters".

## METHOD (the finding)
Every frame run bakes BOTH men at fixed spots per range and the page slides the whole picture. So every run must start and
end exactly where both men stand; any run a few px off is a snap. Five patch rounds (GLIDE1, GLIDE2, INSIDE1, the S569 step
and cross-short fixes, RECOIL1 - stopped) each left leftovers. Fighting games (Street Fighter, Tekken, Fight Night,
Undisputed, MMA Arena's 3D cage) keep each fighter's position in CODE and play each animation on top of it; a step or a
hit's pushback moves the position, so the next animation starts where the last one ended. Mixed Martial Cards draws no
fighters at all (distance is a card word) - it cannot jump, but it drops his S551 wish.

## The plan
Rules do not change: Long / Mid / Inside stay three places, every number stays.
1. Renders, one man each (tools/pics2d_anim.gd, pics2d_anim_more.gd, pics2d_head.gd, pics2d_kick.gd, pics2d_bob.gd): the
   same 3D scene and takes, the OTHER man hidden, transparent background, the camera fixed as today; each frame also
   records the man's feet point (root x in metres along the ring axis). Output `<run>_<side>_<k>.webp`, frames.json rows
   with `root: [m, ...]` per frame and the contact frame. About 400 runs x 1 man (a run already names its actor; the
   other man's reaction becomes his own run: hit / blocked / slipped ... reactions, one set a range).
2. ring_ui.js draws two pictures: each man at his own spot (metres -> px from frames.json `camera`), the near man in
   front (z-order from the camera). A step moves the stepper's spot by the run's root track; a landed punch's pushback
   is the reaction run's root track; the push moves the pushed man. A run starts from the man's CURRENT spot: if the
   run needs a different gap at contact, the page eases the puncher over 100 ms first (fighting games' "step in").
3. The old two-man runs stay on the page until a whole family (punches, steps, holds, head moves, kicks) is re-made.
4. Gate: tools/jump_rec.mjs + jump_ana.py over 6 random bouts - no boundary jump over 4 screen px; anim_check PASS;
   page_play_test; full-size stills of each range (beat_shot.mjs) - and his look on the page.

## Order and cost
- Phase 0 (half a day): ONE run family end to end - the guard holds + the jab at all three ranges, both sides; the page
  draws them as layers behind a switch (?layers=1); jump_ana on that family. His look at it.
- Phase 1-3 (a day or two of GPU, one render at a time, no game open): punches, steps + push + clinch, head moves +
  kicks; the switch becomes the default when every family is done.
- Stopped meanwhile: RECOIL1 and PUSH1 (both patch the two-man pictures). GLIDE/step code in ring_ui.js retires with
  the old runs.

## Risks
- The two men overlap at Inside (arms through bodies): the camera z-order and the 3D scene render each man with the
  other as an invisible occluder (depth only) so his arm is cut where the body is in front.
- Shadows on the canvas: one shadow layer per man.
- Hit sparks and the knockdown: the knockdown run carries its own root track (the fall moves him).
