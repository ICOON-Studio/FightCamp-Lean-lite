# TASK ANIMSOURCE1D_FIX1 (S215) - the lead body hook is a straight arm: re-author it as a HOOK

Model: Codex sol. Worktree E:/FightCamp/wt/ANIMSOURCE1, branch codex/animsource1 (HEAD 42609d2b). Never master.
Everything else in the gloved palette stays as accepted by your 42609d2b digest; touch ONLY the lead body hook clip (+ its review sheets).

## What Claude saw (primary source: E:/FightCamp/tmp/animsource1d/_review_exact_hooks_imported/body_hook_side.png + body_hook_top.png)
- 0.233-0.267 s: the punching arm is STRAIGHT and horizontal, travelling straight forward at the opponent's chest/gloves (top view:
  near-straight line from shoulder to target, elbow barely bent). That is a straight body shot, not a hook.
- The deep squat/lunge (front knee far past the toes, hips dropped ~25 cm) reads as a fall, not a level change.

## What a real lead body hook looks like (What would a human do?)
Small level change (bend the knees ~10-15 cm, no lunge), weight shifts onto the lead leg then pivots on the lead ball; the elbow
stays bent ~90 deg and comes round from the SIDE with the forearm roughly horizontal (palm up or facing in), the fist lands on the
opponent's right side - liver/ribs below the elbow - not at the chest centre; rear glove stays at the chin; the punch returns along
the same arc to guard. Contact frame: glove at the receiver's right flank, ~10-20 cm below his elbow line.

## Do
1. Re-author the lead body hook in the native Cascadeur source to the shape above; keep every existing gate/limit (feet planted,
   pivot, guard clearance, actual glove meshes on BOTH models, no penetration). Add a shape check for the hook: elbow angle at
   contact 70-110 deg and the fist's lateral approach (top view) at least 25 deg off the shoulder-to-target line - red on 42609d2b.
2. Re-render the body_hook review sheets (side/front/top/contact) for raw + imported; open every image yourself and describe it.
3. Append a FIX1 section to ANIMSOURCE1D_DIGEST.md; commit; push codex/animsource1.

## Owned files
The lead body hook native source + its GLB/package, the hook shape gate script you already use, review sheets, ANIMSOURCE1D_DIGEST.md.

## Rules
Same as TASK_ANIMSOURCE1D.md. Watchdog before every Godot/Cascadeur run; no image viewers; never master. Cascadeur jobs end before 2026-10-27.

## The one trap
"Arm horizontal" is not "arm straight": the forearm is horizontal with the ELBOW BENT; a straight horizontal arm is the defect.
