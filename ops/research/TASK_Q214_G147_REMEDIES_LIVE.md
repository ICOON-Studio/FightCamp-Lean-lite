# TASK_Q214 - G147 clipping remedies in the LIVE boxing room, measured by Q213

Owner: **qwen** (qwen3-coder, medium, `--yolo`). Model: qwen3-coder medium - fixed at assignment.
Milestone: PLAYABLE WITH A BOXER, stage B "the fight is WATCHABLE" - the Q213 gate is one of its four watchable measures
(ops board: "clipping gate Q213 = FAIL 0%").

## Why
Q213 (merged S120, `c37dd1f9`) measures body-pair overlap events per G147. The LIVE room (180 s, seed 94301, game
switches ON) fails: head 2 failing events (worst 7.49 cm, `LeftUpperArm-LeftLowerArm>Head` at `boxing_slip_counter` /
`boxing_jab_body`), arm 16 (worst 20.26 cm at `boxing_slip_counter/slip`), leg 3 (19.45 cm, same beat), torso 0 failing
but a 35.49 cm `UpperChest-Neck>UpperChest-Neck` frame during `slip`. The slip counter is where the bodies cross.

## What would a human do?
A fight-game animation programmer (G147 Q1: EA UFC 2, UFC 2009 Undisputed, Capcom) does three things, in this order:
(1) a BODY-ONLY push / minimum distance that the trunks and heads may never violate but arms and legs may (limbs are
excluded from the push box); (2) authored strike spacing (C223 certificates carry it); (3) a surface stop - the glove is
pinned to the SURFACE of the target volume the frame it touches (UFC 2 ray head->hand), plus 1-3 frames of hit-stop.
Blends stay short at close range (into-strike 80-150 ms, reaction <= 150 ms): long blends are how gloves swim through heads.

## Prior research (primary studies - read the relevant sections)
`research/G147_CLIPPING_RULE_AND_SMOOTHING.md` (Q1, Q3, Q4, Q5 - the rule and the remedies),
`research/Q213_DIGEST.md` (the numbers above), `research/C191_DIGEST.md` (what still clips, contact_stop),
`research/topics/contact_collision.md`.

## Prefab check
G147 "Prefab check": no runtime middleware fits (HumanIK/Havok/Unreal Control Rig are other engines or DCC). Godot has
`SkeletonModifier3D` / `SkeletonIK3D`; our own pieces already map onto the pattern - `FightSeparation.gd` = push box,
`contact_stop` (`FightWorldLiveScreen._stop_landed_hand_contact`) = surface stop, `FightBodyCapsules.gd` = volumes.
Build on them; add no new system beside them.

## Build (in order; measure after EACH step, keep a step only if it lowers failing events without raising another class)
1. **Trunk/head minimum distance during defensive takes** (slip, pull, slip_counter): the torso class must never cross.
   Find why `FightSeparation` does not hold the slip - its floor is a root gap; a slip leans the trunk past the roots.
   Measure the posed trunk (capsules), not the root. Arms and legs stay OUT of the push.
2. **Glove pinned at the head surface** the frame of contact (extend `contact_stop`): head class 0 failing events.
3. **Hit-stop 1-3 frames on a landed head/body contact** (G147 Q5) - only if 1-2 leave head events.
4. Blend times per G147 Q4 only where a measured event sits inside a blend.
Never change a C223 clip or binding, never loosen a G147 threshold or the Q213 instrument.

## Gate (tier: script edited)
PC watchdog first (`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`; RED = stop).
Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. Focused tests:
`python Godot/tools/run_tests.py --only fight_separation,contact_stop,q213,fight_world_live,fight_body --jobs 1`.
Measure: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script
tools/q213_clip_gate.gd -- as_game mode=live seconds=180 seed=94301` and the same at seeds 94302 and 94303 (report all
three; never tune to one seed). Before/after table per class. Ceiling gate: live failing events head 0, torso 0, arm and leg
LOWER than the before on all three seeds; say so and push if you beat it.

## Owned files
`Godot/scripts/FightSeparation.gd` (134 lines - read whole), `Godot/scripts/FightWorldLiveScreen.gd` (5,024 lines - NEVER
read whole; `sed -n` windows at `_stop_landed_hand_contact`, `:629` `_contact_stop`, `:1563`, `:2949-2975`), a new test
`Godot/tests/q214_*.gd`, `research/Q214_DIGEST.md`. Read-only: everything else (Claude is editing
`FightStagePlayer.gd`, `FightClipBinding.gd`, `FightClipRetarget.gd` for C223 - do not touch them).

## Deliver
Worktree `Temp/FightCamp-Q214`, branch `qwen/q214-g147-remedies` from origin/master. Commit, push the branch (never master).
Q214_DIGEST.md first line: `live failing events before -> after (3 seeds): head A->B, torso, arm, leg`. One
`python Tools/agent_comms.py send --from qwen --to claude --topic Q214 "<one line>"`. Do NOT edit HANDOFF.md.
**Trap:** a push that moves the roots apart makes every number better and the fight worse (they stop being in range) -
print the mean root gap and the landed-punch count before/after beside the events; a remedy that drops landed punches
is not a remedy.
