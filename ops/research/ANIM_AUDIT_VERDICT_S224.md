# ANIMATION AUDIT VERDICT (S224) - why Codex kept failing the fight animations

Operator S224: "ask other agents (and ludo ) and yourself audit why codex is failing on the animations ? is anything wrong with the MH
models where is the issue ?" Five audits on one pack (AUDIT_ANIM_S224.md + the 20 s fight clip):
Claude (GLB bone axes) | Codex `AUDIT_ANIM_S224_CODEX.md` (read the code, file:line, 47k) | John `AUDIT_ANIM_S224_JOHN_XAI.md` (xAI,
sourced, 22k) | Ludo `LUDO_ROUND64_REPLY_S224.txt` (23k, saw the frames) | Dola `AUDIT_ANIM_S224_DOLA.md`.

## 1. Are the MetaHuman models broken? NO.
All 28 MetaHuman GLBs (12 boxers, members, staff) and the native jab share one valid skeleton. Their right-side bones point the
opposite way from the left (Unreal's convention). That is normal and all five audits agree it is not damage.

## 2. Where the issue is (Codex's code reading decides; the others guessed from my pack)
Ludo, John and Dola said "the retargeter applies the same local rotation to both sides - flip the right side". Codex read the code
and showed that is WRONG for the main retarget: it already corrects each bone for its own rest. A blanket right-side flip would ADD
a bug. The real defects, with lines:
1. **The mirror is blind** (`FightClipMirror.gd:17-28,62-82`): to make a left-handed move right-handed it negates quaternion parts
   in local space - valid on Mixamo-style rigs (error < 0.003 deg), wrong on MetaHuman (thigh 178 deg, ball 180 deg, upper arm 91 deg,
   forearm 73 deg off). It runs AFTER retargeting on the rear hook and on EVERY reaction (`FightStagePlayer.gd:2351-2354,2392-2407`).
2. **Hard-coded local-angle "pose layers"** (`FightClipPoseLayer.gd:91-105`) add fixed Euler degrees (e.g. a 47 deg upper arm, -42.5 deg
   forearm) tuned on the old legacy rigs - they bend MetaHuman arms and wrists the wrong way.
3. **The foot was aligned by the ankle-to-ball bone line, not the sole** (`FightClipRetarget.gd:327-359`, `FightClipFootPlant.gd:59-65`)
   - S223's change improved it, not finished.
4. **Mirrored reactions get folded twice** (`MetaHumanRig.gd:204-299` + the mirror drops its metadata) - chest and head shift.
5. **Writers that pass their own test but keep the wrong shape**: leg IK keeps the incoming foot angle (`FightStagePlayer.gd:6097-6128`),
   arm IK keeps the incoming hand angle (`:5395-5415`) -> gait and contact tests go green while feet and wrists look wrong.
6. **The native MetaHuman clips are NOT playing in the game.** The MHNATIVE1 digest said they were; the code has no native path - the
   idle is still a retargeted `active_guard.glb`, the hook a RamsterZ FBX. A digest was trusted instead of the code.
7. Correction to my own number: "right foot 94-97% outside the band" counts frames BELOW the band too (rear heel flat at ~4 deg); the
   true ballet excursions are shorter runs (62-88 deg). Still red, but the gate must report below / above / roll separately.

## 3. Why the rounds kept ending red (Codex, about its own work, honestly)
It measured the wrong thing first (bone line, not sole), stacked a new correction per round instead of tracing the worst frame through
every stage, accepted short-run improvements and green gait as progress, and believed a digest over the code. Each round added a place
where the defect could hide. My part: I briefed symptom fixes round after round and never asked for a whole-pipeline audit until you did.

## 4. The fix - decided order (Claude, as developer)
STOP adding layers. One owner per boundary, measured stage by stage.
1. **ANIMFIX1 (Codex, next on the PC seat, before ANIMSOURCE1D):** a rest-aware mirror (Codex's formula: reflect the motion relative to
   each side's own rest, fold exactly once); red witness = the 178/180 deg rest error; prove at the failing rear-uppercut frame
   (seed 930093, body 08, 38.2-38.4 s) by reading the pose after each stage (source -> retarget -> mirror -> fold -> foot bake).
2. **ANIMFIX2:** replace the fixed Euler pose layers with targets in anatomical space (or bake them per rig); gate the wrist and guard.
3. **ANIMFIX3:** wire the 5 native MetaHuman clips for real (what MHNATIVE1 claimed) and A/B them against the retargeted ones on the
   game camera.
4. **ANIMFIX4:** the foot gate reports below / above / roll separately; foot translation AND angle settled by one solver.
Every step: red on today's build first, one change per commit, the sole gate + one contact frame + game-camera stills.

## 5. The direction for you to approve - all five audits agree on the destination
**Stop retargeting library clips at runtime in the fight.** Clips are retargeted and cleaned OFFLINE once onto one MetaHuman master
skeleton (Cascadeur, which we already use, + Blender for export), baked, and played natively; in Godot only one small stack after the
clip: blend -> one foot lock + hand contact solve (Godot 4.6+ has real IK and `RetargetModifier3D` - John's sources). The 49 writer
sites are retired one by one as the new stack takes over their job (Codex: not all 49 are animation layers - undo/setup writes stay).
What it costs: the boxing palette has to be re-baked clip by clip (the 5 native clips first, then the moves the demo uses); runtime
retarget code (FightClipRetarget 1,511 lines) becomes an offline tool. What it saves: no more fix rounds that end red.
Steps 1-4 above are needed either way and start now; the offline-bake switch-over starts after them only with your OK.
