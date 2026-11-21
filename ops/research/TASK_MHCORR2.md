# TASK MHCORR2 - bring the MetaHuman body correctives into fight player v2 (the bodies look terrible)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S535, on two stills from the S534 build (a dark-skinned boxer front-on, a light-skinned boxer side-on, both in guard):
"why the bodies look so terrible ?", "the stomach goes inside weirdly the chest on the black guy look weird".
Standing approval for animation fixes (owner S510). Visual gate: a still from the live fight's own camera, guard AND mid-move,
opened by you, before|after, then his OK.

## Cause (Claude, from the code)
MetaHuman bodies need their corrective helper bones driven (Unreal's RigLogic RBF + twist/swing). The old project ported them
in S263 (MHCORR: `Godot/scripts/MetaHumanCorrectiveRBF.gd`, `CorrectiveRBF.gd`, `Godot/assets/data/mh_correctives_boxer01..04.json`
from the body DNA, test `mh_dna_correctives_test.gd`; digest ops/research/S263_DIGEST.md "MHCORR"). The lean restart never brought
them over: `scripts/fight3d/MHRig.gd:3` says "no DNA correctives"; `MetaHumanTwist.gd:14` says swing outputs are left to
MetaHumanCorrectiveRBF, which does not exist here. So clavicle / upperarm / lowerarm helpers (clavicle_scap, clavicle_pec,
upperarm_fwd ...) sit at rest whatever the arm does: the chest and shoulders fold in the guard. The stomach caving may be a
spine issue (the correctives above cover limbs only) - measure it, do not guess.

## Do
1. Fetch from GitHub ICOON-Studio/FightCamp (read-only archive, `gh api repos/ICOON-Studio/FightCamp/contents/...`): the RBF
   modifier, CorrectiveRBF, the four JSON tables, the test (and the MHRBF2 interpolative-kernel version if it landed - check
   the old repo's git log). Re-read each, strip what v2 does not need; keep every file under 500 lines.
2. Wire it into fight player v2's modifier chain (`scripts/fight3d/v2/Player2.gd:100`, after MetaHumanTwist), GAME_ON switch per
   CLAUDE.md "new features ship ON". Bodies 05-12 use boxer01's deltas (as S263 did) unless a better match exists.
3. Check it does not fight ArmBuild (scripts/fight3d/v2/ArmBuild.gd scales some of the same helpers by Strength, committed AFTER
   the build the owner played): compose scale with the RBF output, never overwrite one with the other.
4. The stomach: compare the guard pose's spine chain against the rest; if the cave is the spine bending (or a missing spine
   corrective / a blend shape), say which and fix it the smallest way; if it is lighting/normal map, say so and show it.
5. Port the test (red on main first: helpers at rest in a 90-degree elbow), plus `tests/arm_build_test.gd` and `tests/player2_test.gd`
   green.
6. Stills on the hidden desktop through godot_slot: `tools/fight3d_still.gd` / `tools/fight3d_play.gd` on the broadcast camera,
   still_framing rules (both men head to feet), guard and mid-punch, the SAME two bodies as the owner's stills (a dark-skinned and a
   light-skinned boxer), before|after side by side. Open each one yourself. Put them in ops/previews/s535_mhcorr/ and on the review
   board: `python ops/Tools/review_add.py --stage S535 --rating "<your score>" --title "Body correctives: before|after" <files>`.

## Prior research
ops/research/S263_DIGEST.md (MHCORR), ASK_MHCORR_JOHN_S262_JOHN.md, AUDIT_ANIM_S224_*.md, BODYLOOK1 (S492, WalkPure.gd header),
memory: feedback_guard_protects_head_s531, project_s531_fp2_film9_critics_swing.

## What would a human do?
Any studio shipping MetaHumans outside Unreal re-drives the corrective joints (or bakes corrective blend shapes); without them
every pose away from the A-pose collapses at the shoulders and chest.

## Prefab check
Our own S263 port (old repo) is the prefab; nothing to buy.

## Contract
OWNS: scripts/fight3d/v2/MetaHumanCorrectiveRBF.gd, scripts/fight3d/v2/CorrectiveRBF.gd, assets/data/mh_correctives_boxer01.json,
assets/data/mh_correctives_boxer02.json, assets/data/mh_correctives_boxer03.json, assets/data/mh_correctives_boxer04.json,
tests/mh_dna_correctives_test.gd, scripts/fight3d/v2/Player2.gd
RED_TEST: tests/mh_dna_correctives_test.gd
REGRESSION: tests/player2_test.gd, tests/arm_build_test.gd
VISUAL: yes (before|after stills on the broadcast camera, guard and mid-punch)

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who mhcorr2 -- <command>`; windowed only on the hidden desktop
(tools/hidden_desktop.py) - nothing on the owner's monitors. Never stage LineGrade.gd, LiveRound.gd, StepWire.gd. Stage explicit
paths, commit to main with the Co-Authored-By line, push, report in two lines (what changed; the stills' paths), stop.
