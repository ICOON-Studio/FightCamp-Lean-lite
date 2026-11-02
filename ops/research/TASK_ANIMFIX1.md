# TASK ANIMFIX1 (S224) - a rest-aware mirror: left-hand moves made right-hand without breaking MetaHuman limbs

Model: Codex gpt-6-astra, effort high, PC, exclusive Godot slot (after ANIMCHAIN2 ends). Worktree E:\FightCamp\wt\ANIMFIX1 from
master (seed it: Tools\seed_godot_cache.ps1). Branch codex/animfix1. Never master.
Source: `research/ANIM_AUDIT_VERDICT_S224.md` + YOUR OWN audit `research/AUDIT_ANIM_S224_CODEX.md` s1 (cause 1, 3) and s8
(first fix + proof). Read both first. This task is exactly s8 - nothing else.

## Do
1. Replace the blind local mirror (`Godot/scripts/FightClipMirror.gd:17-28,62-82`, `(qx,-qy,-qz,qw)` in key-local space) with the
   rest-aware mirror of s8: per paired bone D_left = G_pose_left * inv(G_rest_left); D_right = S * D_left * S; G_pose_right = D_right *
   G_rest_right; back to actual-parent locals. Central chain reflected in the same frame; root/position displacement policy explicit.
   Zero motion must map to each target's own rest; mirror twice must give back the original.
2. Fold exactly once (`MetaHumanRig.gd` fold_intermediate_rests): the mirror declares its output space and carries/rebuilds the
   metadata - no second fold on mirrored reactions (`FightStagePlayer.gd:2392-2407`).
3. Nothing else: no new switch for the old path unless the parity test needs an OFF arm (then the switch goes in GameSwitches.GAME_ON,
   ships ON); no foot/wrist clamps; no threshold change. Do not touch pose layers (ANIMFIX2) or native wiring (ANIMFIX3).

## Gate (red first, on master)
- New `Godot/tests/rest_aware_mirror_test.gd`: (a) RED on master: the neutral-rest mirror error on mh_boxer_05 (thigh ~178, ball 180,
  upperarm ~91, lowerarm ~73 deg) - print it; GREEN after: < 0.5 deg every paired bone, MH05 + MH08; (b) mirror(mirror(clip)) == clip
  within 0.1 deg per key; (c) a signed anatomical rotation (lead knee flex +20 deg, lead wrist flex +15 deg) mirrors to the same
  anatomical rotation on the other side (compare limb DIRECTIONS in skeleton space, not quaternion parts); (d) control: a Mixamo-style
  unflipped rig gives the same result as the old mirror (< 0.01 deg); (e) one fold: a mirrored reaction's chest/head world pose equals
  the unmirrored reaction's reflected pose (< 1 deg).
- Per-stage readback at the failing frame: seed 930093, body 08, 38.225-38.425 s (rear uppercut): print the right sole plane after
  source / retarget / mirror / fold / foot bake. If that clip never goes through the mirror, SAY SO and stop there - do not claim the fix.
- Parse gate on touched .gd; `python Godot/tools/run_tests.py --jobs 2 --only mirror,react,clip,metahuman,foot`.
- Full-duration sole gate (2 seeds x 4 bodies x 60 s) with the result split into below-band / above-band / roll counts per foot.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
Red still first (today's rear hook / a reaction on MH body 08), then game-camera stills via still_framing.gd save_if_framed: guard,
mid rear hook, a mirrored reaction - both bodies head to feet. Per still: gap, noses, wrists, feet. Not accepted until Claude opens
them and the operator closes it.

## Rules
Nothing opens on the operator's screens (godot_hidden.ps1, file tools for images, never _console.exe). Watchdog before every Godot run.
Explicit `git add -- <files>`; never bare stash / reset --hard / checkout . / clean / add -A; no *.import churn. GDSCRIPT_TRAPS.md first.
Write `research/ANIMFIX1_DIGEST.md`: red lines, the change, green lines, per-stage readback, stills - and what is still open.

## Prior research
AUDIT_ANIM_S224_CODEX.md (yours), AUDIT_ANIM_S224_JOHN_XAI.md (Godot RetargetModifier3D / model-space deltas), Q82_GODOT_RETARGET_VS_OURS.md.

## What would a human do?
A rigger mirrors animation relative to each side's rest (Maya/MotionBuilder "mirror with rest pose"), never by negating raw local axes.

## The one trap
Do not "fix" the main retarget or add a blanket right-side sign flip - your audit showed the main retarget is already rest-aware.
