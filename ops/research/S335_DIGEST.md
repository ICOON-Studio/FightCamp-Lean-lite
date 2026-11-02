# S335 DIGEST - 2026-11-01 - update 37: the ground-move prototype (GrappleMap on our MetaHumans)

## What the operator said (verbatim)
- Board Q-S294-58: "Build the prototype now".
- "can we make a nice menu with in&outs like in the website for each position and even for bxoing and others"
- "can have animations like this in the training tabs (coach and player etc)" / "make the combos something like the transitions ?"
- "make a game for coach on the visual canvas ?" / "build the corner shouts on the correct or wrong transitions"
- "if you manage to make a mechanic so that the player can mix clips to make own combos i think would be a hit"
- "use different colours on the clothes for each" / "you use blue colour on fighter and blue colour on the mat ? can you use a bit more inteligence ?"
- "grappling pictures look very promising , if animation is also good maybe we can fix kickbox/judo too ?"
- "the video looks amazing, can still be improved"
- "would you recommend paying any api key to help with all animations transitions and blending?"
- He sent https://www.dartfish.com/combatsports/ ("find as much info on this as cyou can") and a pasted striking-map overview.

## What now works (Lean, all pushed to main)
| Commit | What |
|---|---|
| 0204606 | `scripts/grapple/GrappleMapDB.gd`: decodes GrappleMap.txt (public domain, `assets/grapplemap/LICENSE`): 601 positions, 1,485 moves, 8,323 keyframes. Test `grapple_db_test`. |
| 6e4365b | `GrapplePose.gd` (SkeletonModifier3D): 23 joints -> 22 MetaHuman bones by aim + roll per bone (rig-axis free). `GrapplePlayer.gd` (Catmull-Rom keyframes, 0.5 s a segment, pair scaled as one). `GrappleGraph.gd` + `tools/grapplemap_graph.py` -> `assets/grapplemap/graph.json` (each move's ends matched to positions by joint-distance signatures under swap/mirror: 2,703/2,970 ends). `GrappleBrowser.gd` (`-- jump=grapple`, `walk=N`): moves in/out per position, family tabs, search, each move laid on the pose on screen (align: yaw + shift + relabel), so moves chain without a jump. |
| 45cd46c | Grey mat, one colour per woman, walk fixes. |
| 6d538b7 | Two-bone IK on wrists and ankles: wrist error median 8.4 cm -> 0 (95% 1.2 cm), ankles exact; `ik=false` is the control arm. |
| (this stage) | `make_shortcuts.ps1` "Test ground moves"; WHAT_TO_TRY update 37; export. |

Evidence: `grapple_db_test` / `grapple_pose_test` (596 poses: bends 2356/2356 the data's way) / `grapple_graph_test` (mount 18 in / 7 out,
126/126 links chain under 4 cm a joint, an unrelated position stays far) all green; whole suite 58/58 at the first export. Stills
`S335_stills/b01-b04` and film `grapple_walk.mp4` (35 s, 10 moves) opened by me; on the board review page.

## Decided (Claude, why)
- Runtime retarget in Godot, no Blender bake: GrappleMap stores joint positions, and an aim + roll solve per bone doesn't care
  about the rig's bone axes. Bend direction is exact (three real points per limb).
- The graph is precomputed in Python (numpy, 3.5 s). Matching in GDScript would be about 5M signature compares.
- One scale for the pair (our mean leg / 0.86 m) so contacts survive, plus IK so grips land.
- The prototype is a separate scene (`scenes/dev/GrappleBrowser.tscn`), not in the boxing flow.

## Design proposed (operator approves first): Q-S294-61, `STRIKEMAP_S335.md`
The boxing move map: 8 position cards (outside, long, mid, inside, clinch, ropes x2, corner), every combo a move FROM -> TO
(Combos.BOOK gains from/to), clips on the Training page (coach with pads + boxer), the coach's whiteboard plan game
(more arrows for a better coach, the corner changes one arrow a round), corner shouts on right/wrong moves, and the
player's own combos built move by move (a joint is slow when the same hand repeats).

## Research
- `DARTFISH_S335.md` (subagent): partly helps. No data, API or SDK we can use (terms: non-commercial use only). It is a
  design reference: a tape room, and post-fight stats split into thrown / hit / miss / blocked. Real numbers: winners land 32-33% against
  22-26%, and land share alone picks the winner 76.9% of the time (Dunn 2017). Head punches land ~39%, body ~59% (FFB 2023).
- The pasted tools: Miro and draw.io are drawing tools. Kinovea (free, GPL-2) is useful to us for measuring footage. Mixamo
  clips are one body only.
- API key question: recommended NO for now. AI motion APIs make one-body clips (Higgsfield 0/36 composed takedowns,
  settled), the two-body ground motion now comes from GrappleMap for free, and blending is our own runtime code
  (JoinSmoother, this IK).

## Next (roadmap now)
1. Ground prototype polish ("can still be improved"): push the bodies out where they sink into each other in tight
   holds, timing per move (not a flat 0.5 s), hands curled into grips, MMA kit (rash guard, no vest).
2. Act on Q-S294-61 (boxing map + whiteboard plan + shouts + own combos) when he answers; 59 and 60 still open.
3. Judo: GrappleMap has 16 throws, 42 single-leg, 27 double-leg and 125 standing positions. Check the coverage once
   the ground looks right.
4. The other session owns the fight-stills CI (ANIMCLOUD1): runs 41267920481 / 41267894530 failed, 41272207058 timed out.
