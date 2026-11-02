---
name: project-research-findings-s119
description: "S119 research findings that must carry forward - clipping gate rule (G147), guard styles (D64), boxing draw/judge facts (G146/Q212), RamsterZ jab history, glove/modifier trap"
metadata:
  node_type: memory
  type: project
  originSessionId: f0f5f7b8-9749-4af0-9fa1-f2c31dc54fa9
  modified: 2026-09-28T12:50:58.440Z
---

Operator 2026-09-28 S119: "important research findings need to be in your memory and carry from session to session".
Primary files in `research/`; these are pointers + the conclusions.

- **CLIPPING RULE (G147_CLIPPING_RULE_AND_SMOOTHING.md, Grok):** no studio publishes a cm tolerance. Shipped fight games
  use a BODY-ONLY push box (arms/legs excluded), authored strike spacing, IK pins at the contact (UFC 2 casts
  head->hand and pins the glove to the opponent's surface), physics only as cleanup, short blends up close. Adopted
  gate: FAIL if a head pair >1 cm for >1 frame, or a torso pair >2 cm for >3 frames (arms 3 cm/3 f, hips 2 cm/3 f,
  feet 4 cm/5 f), on any clip or live minute. Smooth = pose+velocity continuity: locomotion 200-300 ms, into strike
  80-150 ms, reaction additive <=150 ms, hit-stop 1-3 f, never >~400 ms. Instrument: Q213.
- **GUARD STYLES (D64_GUARD_STYLES.md, Dola):** 8 guards with pose numbers (classic, high, peek-a-boo, Philly shell,
  long, Mexican, cross-arm, low-hands). Games: style = identity, defence rating clamps how far the guard degrades,
  fatigue blends toward an exhausted guard; elbows flare before hands drop (a hypothesis, not measured). Build as ONE guard idle + additive per-style
  pose layer. Prevalence shares are PROXY; blend formula is authored.
- **BOXING RESULTS (G146 + Q212):** no sourced pro draw rate (PROXY 2-3%). On the game's own booked bouts: KO+TKO
  46.7% (BoxRec 47%), draws 5.8%; the three judges NEVER disagree (0 split in 54 decisions) - open issue. Census
  pairs (even matchups) inflate draws to 11.7% - measure on booked bouts, not hand-picked pairs.
- **RAMSTERZ JAB:** operator prefers RamsterZ look. It failed foot slip on old Tripo rigs (run 3), was replaced by
  Mixamo, then PASSED every smoothness row once the pipeline was fixed but sat out on speed (16 m/s > 9.5 band).
  Nobody re-auditioned it. Fix: RamsterZ sources + run 9's strike_warp into band.
- **GLOVE TRAP:** active ragdoll (OutputPose) and FighterFist are SkeletonModifier3Ds; get_bone_pose never sees their
  output. Anything that follows the hand must read the final pose on skeleton_updated (fixed fb7efb7a).
- **Kickback already has a MASS_TABLE and JointDefinition joint limits** (addons/kickback) - reuse them for a
  final joint-limit clamp and per-part mass; the clip/IK layers have none today.

See [[project-session-S119-2026-09-28]], [[feedback-research-is-the-projects-memory]].
