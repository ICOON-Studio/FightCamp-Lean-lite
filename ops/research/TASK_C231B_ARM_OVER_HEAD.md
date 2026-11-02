# TASK C231B - an arm goes over a fighter's head before the inside uppercut lands (send-back, Codex)
Model: gpt-6-astra, medium (operator 2026-10-01: "use astra model for 3d, luna for other things").
Owner: Codex. Worktree E:/FightCamp/wt/C231B (S138: D: is failing - its first run died there), branch codex/c231b-arm-over-head (from master - C231 is merged, 5b49ee5b).

## What is wrong (Claude, S138, primary source: the video frames)
`previews/anim/boxing_inside_uppercut.mp4` (frames:
`previews/c223/anim_v_inside_uppercut_generator_welter_a_video/`, 57 frames, 30 fps). In frame 0010
(0.333 s) and again around 0034 (1.133 s) the fighter in RED shorts has one arm raised with the elbow above his own
head - BEFORE the uppercut's contact (0.57 s), so it is not a hit reaction. A boxer never lifts an elbow over his head
inside an exchange. Your C231 numbers all pass (gap -0.19 cm, 8.22 m/s, no failures) - the gate does not measure this.

## OPERATOR VERDICT (S138, verbatim): "this video is terrible what happenned ?" - the move is WITHDRAWN from the palette
Claude's read of the frames (0.467-1.333 s): (1) RED throws, and the arm does not rise under the chin - it swings up and
OVER, glove into blue's face, elbow above his own head at 1.07 s: a clubbing forearm, not an uppercut; (2) the pair is
authored at 1.07 m root spacing, chest to chest - no room to punch, gloves sink into the head; (3) BLUE barely reacts
(upright, feet planted, hands frozen). The gate passed all of it. So the task is the WHOLE move, not only the arm:
- the punch path: a short rising arc from the hip/ribs, elbow BELOW the shoulder, fist finishing under the chin
  (reference: any boxing-instruction footage of an inside/lead uppercut - name the one you used);
- the spacing: an inside uppercut is thrown at close range but with daylight between chests - set the authored spacing so
  the minimum body gap is real (state it in cm) and no glove enters the head;
- the receiver: a visible reaction on contact (head snaps up / back) - the production receiver solver, not a frozen guard.
- the check that can fail (point 4 below) covers elbow-above-shoulder during the strike AND glove-inside-head.
- deliver a full-speed video from the GAME camera at 1280x720 or larger, 1 s of guard before and after, so the operator
  can judge it. The move returns to certified_moves.json ONLY after the operator approves that video.

## Do
1. Find out which rig wears red and whether it is the attacker or the receiver in this render (say it in the digest
   with the evidence - a bone height trace, not a guess).
2. Find the layer that raises the arm (the Cascy clip itself, a guard/idle under it, the receiver's pairing, a
   retarget map in FightStagePlayer's native-Cascy branch) - print the elbow/hand height per frame for the source clip,
   the retargeted clip and the production render, and point at the first stage where it goes above the head.
3. Fix it at that stage. If it is the clip, re-author in Cascadeur (`python Tools/cascadeur/ensure_server.py`,
   `Tools/cascadeur/build_c231_inside_uppercut.py`) - never loosen a gate.
4. Add a check that can fail: elbow (and hand, outside the strike window) never above the head top for either fighter
   during this move - in the C223 production gate as a mechanical failure if that is the right home, with a mutant
   that raises the arm and is rejected. Prove the old clip fails it if the clip was the cause.

## Owned files
- `Godot/assets/anim/c223/cascadeur_c229/Cascy_C231_InsideUppercut.glb` / `_rest.glb` (re-export only if the clip is the cause)
- `Tools/cascadeur/build_c231_inside_uppercut.py`, `Tools/cascadeur/c231_inside_uppercut/*`
- `Godot/scripts/FightStagePlayer.gd` (only the native-Cascy branch ~1936-1990, if that is the cause)
- `Godot/tools/c223_production_gate.gd` (the new elbow-above-head check + its mutant)
- `previews/c223/c231b_*.json`, `previews/c231b/*`, `previews/anim/boxing_inside_uppercut.mp4`
- `research/C231B_DIGEST.md`

## Prior research
C231_DIGEST.md (all of it), S119 research findings (clipping gate G147), `python Tools/prior_research.py elbow above head guard`.

## What would a human do?
An animator scrubs the clip in the DCC, sees the arm, and fixes the curve where it was authored - then checks the
in-game result from the game camera.

## Prefab check
None needed - our own clip and pipeline.

## Tests (tier: scripts edited)
Parse gate on touched .gd; `python Tools/c223_parallel.py production --jobs 2 -- plant phase live_contact bound clips=v_inside_uppercut report=c231b_inside_uppercut.json`
(4/4 rigs must still pass); `python Godot/tools/run_tests.py --jobs 2 --only certified_palette,clip_binding,asset_manifest,fight_clip`;
the video: `Tools\godot_hidden.ps1 --path Godot --script tools/c223_production_gate.gd -- plant phase live_contact bound render video prefix=anim_ rig=generator_welter_a clips=v_inside_uppercut`
then `python Tools/anim_previews.py`. OPEN the frames around 0.33 s and 1.13 s before you call it done.
Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
WITHOUT `bound` the gate measures its own legacy Mixamo candidate for `v_inside_uppercut`, not the game's clip (S138
measured 21.7 cm short and a join pop that way). Every run in this task carries `plant phase live_contact bound`.

## Finish
git add by explicit path, commit, git push -u origin codex/c231b-arm-over-head. Never edit HANDOFF.md. Do not stop at written.
