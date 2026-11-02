# TASK ANIMSOURCE1D_FIX2 (S217) - operator REJECTED FIX1: bodies inside each other, heads looking away, wrists twisted

Model: Codex sol (gpt-6.1-sol, NEVER astra). Worktree E:/FightCamp/wt/ANIMSOURCE1, branch codex/animsource1 (HEAD f7b7080c). Never master.

## Operator, verbatim (S217, on your FIX1 sheets)
- On `body_hook_contact.png` (0.267 s): "each boxer is looking at different directions and both their hands look wierd, wrists twisted"
- On `body_hook_side.png` frame 0.233 s: "wtf is that"
Claude accepted FIX1 on arm shape alone - that was wrong. Your gates passed all three defects: they are blind. Fix the gates first.

## The three defects (Claude, from E:/FightCamp/tmp/animsource1d/_review_fix1_imported/*.png)
1. BODIES INTERPENETRATE. Side sheet 0.200-0.267 s: the attacker's chest/hips are inside the receiver's torso; the pair stands
   ~chest-to-chest, far closer than a hook range. Your "no penetration" check did not see it -> it does not test the rendered
   BODY MESHES (skinned MetaHuman torso/pelvis/thighs) of both men against each other on every frame.
2. HEADS LOOK AWAY. Contact frame: the attacker's face points past the receiver's left shoulder; the receiver's head is turned
   to his own right, away from the attacker. A boxer's nose points at his opponent (attacker: at the target/opponent's chest-head;
   receiver: at the attacker) except during a slip. Also check the CHESTS: both men must be squared to each other (stance angle
   from D64_GUARD_STYLES), not offset so the camera sees two backs.
3. WRISTS TWISTED. Both men: the gloves are rolled about the forearm (receiver's guard gloves sit sideways at his face; attacker's
   rear glove is rotated outward). Real guard: forearm and glove in line (neutral wrist, no ulnar/radial bend > ~15 deg), palms
   facing in toward the face, knuckles up/forward (CODEX_TOOLKIT guard references; `D64_GUARD_STYLES.md` s6.1;
   `LUDO_ROUND16_S193.md` 1.2 wrist flexion; Ludo r26 guard discipline). On the hook: palm down or facing in, wrist straight.


## LUDO R50 SPEC - build to these numbers (operator S217: "ask ludo if in unsure how to proceed")
Read `research/LUDO_ROUND50_VERDICT_S217.md` (Claude's verdict - what is TAKEN and what is NOT) and the full reply
`research/LUDO_ROUND50_REPLY_S217.txt` (key-frame table section D is your authoring target for the body hook).
Your gates' thresholds are the verdict's bands (spacing, facing, wrist, rear hand, roll, neck counter-turn), not your own.
The canonical high-guard pose (verdict F.1) is part of this task: frames 0 and last of every clip lock to it.

## Do
1. GATES FIRST - each must read RED on f7b7080c before you change any motion (paste the red lines):
   a. mesh penetration: per frame, the skinned body meshes of A vs B (not capsules, not bone distances) - max depth <= 1 cm,
      and torso-to-torso centre distance within real hook range (state the band you use and its source).
   b. facing: per frame, angle between each head's forward vector and the vector to the opponent's head (attacker may use the
      target point) <= 25 deg outside slips; chest-to-chest squareness inside the guard-style band.
   c. wrist: per frame, hand roll relative to forearm (twist) and hand bend vs forearm, both men, both hands, inside anatomical +
      reference limits you cite; report max per hand.
   Run the SAME three gates on the other 21 clips of the palette and on the shared guard/rest pose - report which are red. If the
   guard pose itself is red (likely for defect 3), fix the guard pose too: it feeds every clip.
2. Fix the staging (distance, squareness), the head aim and the wrists - in the native Cascadeur source / the guard pose, not by
   a runtime override - until all three gates are green on the body hook AND on every clip that was red.
3. Re-render review sheets: side/front/top/contact for raw + imported. Every still through `Godot/tools/still_framing.gd`
   `save_if_framed` (both men head to feet). Open EVERY image with your file tool and describe, per image: distance between
   bodies, where each nose points, each wrist. Do not write "inspected" without saying what you saw.
4. Append FIX2 to ANIMSOURCE1D_DIGEST.md (gate red->green numbers per clip); commit; push codex/animsource1.

## Owned files
ANIMSOURCE1 native sources + GLB/packages for the clips you fix and the guard pose, `Godot/tools/move_shape_probe.gd` and new gate
scripts under Godot/tools/, Tools/cascadeur/animsource1/*, review sheets, ANIMSOURCE1D_DIGEST.md.

## Prior research
D64_GUARD_STYLES.md s6.1; LUDO_ROUND16_S193.md (1.2 wrist flexion); LUDO_ANIMATION_BRIEF_S196.md (guard discipline, chin to
sternum); GLOVES2 history in MEMORY_ARCHIVE (gloves on forearm, wrist braced, palms in); CODEX_TOOLKIT.md real motion videos with
pose landmarks - measure a real boxer's guard wrist and head aim from them and cite the numbers.

## What would a human do?
An animator scrubs the clip from the side and the front, sees the two bodies merge and the heads drift, fixes spacing first,
then aims the heads, then straightens the wrists - and checks every clip that shares the guard pose.

## Prefab check
Already sourced (Cascadeur native authoring, MetaHuman bodies). No new source.

## Rules
Watchdog before every Godot/Cascadeur run (RED = wait). Headless/hidden desktop only; no image viewers; never master.
Cascadeur jobs end before 2026-10-27.

## The one trap
A gate that passes the frame the operator called "wtf" is worse than no gate. Prove each gate red on f7b7080c first.
