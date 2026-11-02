# TASK LUDOANIM1 (S219) - Ludo's 3D animation, driven by Codex from the terminal: a 4-clip trial on a MetaHuman boxer

Model: Codex sol (gpt-6.1-sol, NEVER astra). Own worktree E:/FightCamp/wt/LUDOANIM1 (seeded with Tools\seed_godot_cache.ps1), branch
codex/ludoanim1 from master. Never master. Blocked until the operator has run `ludo login` once (check: `ludo account` exits 0).

## Operator, verbatim (S219)
"can you ask from codex to communicate directly with ludo for the animation work ? also can ludo doanimation work for us ?"
Standing: "If ludo can help in animation work use it (huge tasks)" (S204); asset generation approved for any non-AAA asset (S199).

## What Ludo offers (read from `ludo --help`, CLI 0.1.8, installed at E:\FightCamp\tools\npm\ludo.cmd -
not AppData: the Claude app redirects its npm installs)
- `ludo model animate --model <rigged.glb> --prompt "<motion>" [--mode rot_trans|rot_only] [--num-variants 4] [--no-loop]`
  0.2 credits per call, returns N animation-only GLBs (skeleton + one clip, no mesh) + an mp4 preview each. Ludo's own doc:
  "Animation quality is hit-or-miss, which is why multiple candidates are returned". `rot_only` = for retargeting.
- `ludo model rig --model <glb> --rig-type humanoid_template|humanoid_template_hands --joint-naming unreal|mixamo|godot` 1 credit.
- `ludo model animate-preset --model <humanoid_template rig> --preset-id <id> [--in-place]` 0.2 credits (preset list:
  `ludo sprite list-animation-presets`, free). Read `ludo agent-help` first; `ludo docs search --query "..."` before a new feature.
- NOT available: "Ask Ludo" (the design chat). Design questions go to Claude, who asks Ludo in Brave and pastes the answer back.

## Do
1. `ludo init` in the worktree root with `max_credits: 20` in .ludo.json (budget guard, exit 11 = stop and report, never work around).
   Output folder `E:/FightCamp/tmp/ludoanim1/` (NOT the repo; only the clips you keep get copied into Godot/assets/anim/ludo/).
2. Path A (direct): `ludo model animate --model Godot/assets/models/metahuman/mh_boxer_01.glb --mode rot_only --no-loop` with
   these 4 prompts, 4 variants each: "orthodox boxer throws a fast lead jab from a high guard and returns to guard",
   "orthodox boxer throws a rear straight right cross, hips and rear foot pivot, returns to guard",
   "orthodox boxer throws a lead left hook to the head, weight shifts onto the lead leg, returns to guard",
   "orthodox boxer bouncing lightly in a high guard, chin down, hands at the cheekbones". If Ludo rejects the MetaHuman skeleton,
   Path B: rig the same mesh with `--rig-type humanoid_template_hands --joint-naming unreal`, animate that, then retarget the
   rot_only clips onto the real MetaHuman skeleton in Godot (BoneMap + SkeletonProfileHumanoid; see c223_mixamo_adapter.gd).
3. Import the candidates into Godot as AnimationLibrary resources on the MetaHuman skeleton (same pipeline as the mh_*.glb clips).
4. Score every candidate with the ANIMSOURCE1D FIX2 gates (mesh penetration, facing, wrist twist/bend, guard lock) and
   PunchShapeMath.check_frame, beside the current mh_jab / mh_cross / mh_lead_hook / mh_guard_pose. Table: clip, variant, each gate.
5. Keep at most the best variant per move. Nothing gets wired into the fight; this is a source audition.

## Acceptance (the one test, tier: a new test file only)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/ludoanim1_audition_test.gd` - loads every kept clip on
mh_boxer_01, asserts it plays on the MetaHuman skeleton (no missing-track errors), and prints the gate table. Parse gate first:
`python Godot/tools/check_scripts.py <touched .gd>`. Report `ludo spend` at the end.

## Prior research
C75_ANIMATION_SOURCES.md (Ludo clips measured better than the CMU archive for striking, 0.2 credits); R77_REGENERATION.md (Ludo
Rig & Animate used on the S92 fighters); LUDO_ANIMATION_S192.md / LUDO_ANIMATION_BRIEF_S196.md / LUDO_ROUND50_VERDICT_S217.md
(Ludo's numbers for guard, hook, wrists); D44 in DECISION_LEDGER.md (two-body motion cannot be generated - single fighter only).

## What would a human do?
An animator with a cheap mocap-like generator would batch a few prompts, throw away the bad takes, and only retarget the best one
onto the hero rig - then check it in the game's own camera before touching gameplay.

## Prefab check
Ludo's preset library (`animate-preset`) is the prefab: list the boxing/fighting presets (free) and audition up to 4 of them the same
way before spending on text prompts. Mixamo clips are already audited under MIXAMO1B; do not repeat them here.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## The one trap
Ludo returns animation-only GLBs whose rest pose may differ from the MetaHuman's: retarget by bone rest offsets, never by copying
raw local rotations (that is how the S209 pot-belly torso happened). A clip that "plays" can still be wrong - the gates decide.
