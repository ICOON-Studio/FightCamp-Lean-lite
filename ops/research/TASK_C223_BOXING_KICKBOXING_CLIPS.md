# TASK C223 - CODEX - EVERY BOXING AND KICKBOXING MOVE PLAYS ITS OWN CLIP, CHECKED SMOOTH (S115)
Owner: codex. Model: `gpt-6-astra` (spatial: retarget, alignment, contact, scale), medium. Assigned 2026-09-27 (S115).
Branch `codex/c223-boxing-kb-clips` from `origin/master`, own worktree. Claude reviews and merges. **THE PROJECT'S TOP
PRIORITY:** operator 2026-09-27, verbatim: *"do not produce exe or clips until all boxing and kickboxing animation clips
are completed and checked they work smooth and perfect."* No build and no preview video goes out until this task passes.

## Why
Census S115 (`tools/q133_clip_coverage.gd -- disc=boxing,kickboxing`, new per-move listing - run it first):
- **boxing, 36 moves: EXACT 2, NEAR 21, FAMILY 13.** Only `boxing_overhand` and `boxing_double_jab` own a clip. The body
  hook plays the head-hook clip, `boxing_liver_combo` plays a jab, every combination plays ONE jab, and all footwork plays
  `H2H_Dodge_*` / `H2H_RunForward` (Q160 bound them as "free coverage" - a run cycle is not boxing footwork).
- **kickboxing, 20 moves: EXACT 9, NEAR 6, FAMILY 5.** The EXACT label is not trusted: `kickboxing_jab_lowkick` and
  `kickboxing_jab_cross_lowkick` are EXACT on `combo_jab_cross_hook.glb`, which has no kick in it.
"Covered" in the census means "something plays". Done here means **the right motion plays, and it is smooth.**

## What would a human do?
An animation lead on a fighting game: a SHOT LIST per discipline (every move, its start pose, its end pose, its timing),
one clip per move from the best source (mocap, then keyframe fixes), then an ANIMATION QA pass on EVERY clip in the engine
at the game camera - foot skate on the planted foot, pops (a joint jumping between frames), the strike reaching the target
line at full extension, the return to guard blending without a snap, both rigs - and a sign-off sheet per move. Combos are
chains of single-strike clips with authored joins (J19), not one clip stretched.

## Prior research (primary studies - read the whole relevant section)
- **`SHOT_LIST_STRIKING.md` (S115) - the row every clip is reviewed against: the still that proves the move, onset and
  speed bands (G75, J28). Claude rejects a batch against these rows.**
- `Q160_DIGEST.md` Part 2 - how the boxing footwork got its stand-in clips (undo these).
- `R107_HAND_TO_HAND_SET.md` + `U108_CLIP_BEHAVIOUR.md` - the 124 owned RamsterZ H2H clips and what each actually does.
- `C212_DIGEST.md` - Mixamo clips are usable with edits; `C149_CMU_SOURCE.md` - CMU licence.
- `U106_HIGGSFIELD_JAB.md`, `U107_T2M_JAB_TYPES.md`, `C207_DIGEST.md` - Kimodo text-to-motion, one body, 0.1 credit.
- `C221_DIGEST.md` - two-rig auditions: 47 Kimodo takes all rejected (skate 0.28 m, floor penetration). Learn why first.
- `C189_DIGEST.md` (clip plays whole), `J19_THE_JOINS.md` (joins between clips), `K44_FOOT_LOCK_IK.md` (planted foot).
- `topics/clips_sources.md` is the index to the rest - a pointer, not evidence.

## Prefab check
In this order, and name the licence of each clip you take: (1) the OWNED RamsterZ H2H set - some exact moves may be sitting
unbound (uppercuts, body shots, teep, hook kick); (2) Mixamo boxing/kickboxing clips (free, edits allowed - C212);
(3) CMU mocap boxing takes (commercial use allowed, no data resale); (4) THE OPERATOR'S SUIT ROUTE for a move nothing
above covers: Higgsfield video of a performer in a colour-graded mocap suit -> per-segment tracking (C180, PASSED) -> author in
live Blender from that video through the Higgsfield `bl_*` MCP (the C199 method; Blender 5.2.1 CONNECTED as of S115) -> retarget.
Status and wording: `AgentComms/route_decisions.json` C199 (RESUMED). S115 pilot = one suited boxer, lead uppercut.
**KIMODO IS OUT** (operator S116: not his workflow; its 47 C221 takes were all rejected on two rigs). **Buying is OFF** (operator 2026-09-24).

## ONE PIPELINE - THE RETARGET (S115, read before batch 1)
Two clip pipelines are live in `FightStagePlayer.gd:800-835`. **A - retarget** (`"retarget": true` -> `FightClipRetarget`,
T-pose `reference`, silhouette corrections, whole clip): PROVEN - C189 matched the vendor reel on our fighter (ankle 6.6 vs
6.6 m/s), U85 measured every whole RamsterZ punch ending in guard. **B - slice + mirror + name graft** (`combo_jab_cross_hook.glb`
cut by U40, mirrored by U41, `BoneTrackGraft`): U85 measured the slices "never came home"; U86 moved jab/cross/hooks to A for
that reason but left `strike_head`, `jab_lead`, `cross_lead` and both kickboxing jab+lowkick rows on B. **Every C223 clip goes
through A as a WHOLE clip; replace those B rows; add no new B row.** A mirror is allowed only on a whole A clip (as `hook_rear`
does). Kimodo/Ludo glTF output enters through the retarget branch too, never the name-only graft.

## Build (batches - push after each)
1. Batch 1, boxing punches: jab, cross, lead hook, rear hook, lead uppercut, rear uppercut, body jab, body cross, body hooks,
   shovel hook, overhand. 2. Boxing defence and counters (slip, pull, catch, check hook, pivots). 3. Boxing footwork (step
   in/out, circle lead/rear, angle step, pivot, switch stance, rhythm change, drawing, feint) - real boxing footwork, not
   dodge or run clips. 4. Boxing combinations as CHAINS of batch-1 clips (a sequence entry, J19 joins). 5. Kickboxing: re-audit
   the 9 EXACT, then front kick, teep, hook kick, question mark, catch-kick-return, switch kick, spinning back, clinch knee,
   and the combos as chains.
For each move: bind it `provenance: "exact"` in `FightClipBinding.gd` ONLY after it passes the gate below.

## Gate - "smooth and perfect", measured per clip, BOTH rigs
Build `Godot/tools/c223_clip_gate.gd` from the existing instruments (`probe_take_skate.gd`, `probe_hand_pop.gd`,
`measure_jerk.gd`, `u183_foot_clearance.gd`, `c189_clip_whole.gd`) and print, per move and rig, achieved beside wanted:
planted-foot skate p95 (m/s), max joint pop (cm/frame over the clip's own p95), foot/knee floor penetration (cm), strike
reach at full extension (the striking hand/foot crosses the target line), played-whole (not cut), and the blend back to
guard (hand/root step at the join). Take the wanted values from the best owned clip we already accept (`H2H_JabInPlace`,
`H2H_RoundhouseKick_InPlace` - print their numbers as the reference row) and from K44/C189; state each threshold's source.
A move that fails any row stays unbound and is listed with the reason. **Plus a contact sheet per move (six stills at the
game camera, PNG) in `previews/c223/` for Claude's eye - STILLS ONLY, NO VIDEO** (operator ruling above).
Test tier: script edited - parse gate, then `python Godot/tools/run_tests.py --jobs 1 --only clip,binding,fight_stage,boxing,kickboxing`.
Never the full suite. PC watchdog before each heavy run; any windowed Godot run through `Tools\godot_hidden.ps1`.
Never test identical fighters, and a fighter must be legal for the ruleset (both kickboxers can kick).

## RUN 7 (S117 - operator: "write it on the roadmap for codex") - ONE brief, the whole job
Start: `git fetch origin && git rebase origin/master` in Temp/FightCamp-C223 (master has run 6 merged at 590ec538 plus S117's
dressed generated fighters, `tools/c223_production_gate.gd -- tripo|prefix=` options). Read `S117_DIGEST.md` and this digest's Run 6.
Bodies: the GENERATED legal pairs only (welter a/b 66.0/66.5 kg, heavy c/d 100/108 kg) - the game's default fighters since S117.
Recipe = exactly what certified the jab: phase-matched guard (Bouncing_Boxing_Idle), FightClipFootPlant bake, fixture at the take's
own authored reach, join-discontinuity measure (seam mutants must stay rejected), live head/body contact helper, all rows on all four.
1. The five other BASE punches: cross, lead hook, rear hook, lead uppercut, rear uppercut. Sources IN-PLACE first - the owned
   RamsterZ H2H straight / hook / uppercuts (their reference numbers already pass), then in-place Mixamo takes. NOT stepping takes:
   run 6's jab_new/cross_new/lead_hook_new/rear_hook_new slid 21-30 cm and were 3-5 m/s. Bind each `provenance: "exact"` and push
   the moment it passes; one `agent_comms.py send` per push.
2. Body versions (jab_body, cross_body, body hooks) from certified heads or their own in-place takes.
3. Combinations and counters (one-two, one-two-hook, double jab, catch/slip/pull counters, counter combination) as SEQUENCE entries
   chaining certified parts (J19 joins) - never a new single-clip hunt for a chain.
Deliver: digest first line `Boxing EXACT-that-PASSED: 1/36 -> N/36`; tokens used in the digest; no video, no .exe, no HANDOFF,
no master push; Kimodo OUT; never loosen a threshold - fix the pipeline. Stop and report (do not spin) if a base punch has no source
that can pass - name it and why.

## RUN 8 (S118) - hooks and uppercuts: re-gate, then fix the JOIN
Run 7 merged to master as a diff (10223311): boxing 2/36 (jab, cross). Claude then fixed a GATE defect on master
(d6372beb): the hook/uppercut onset-to-impact bands misread K32 - uppercut 606-627 ms was two Stanley MEANS (a 21 ms
window) and the hook floor 477 was Piorkowski's earlier ACTION clock. They are now the fist-onset..Stanley bracket the
jab/cross rows already used (hooks 132-657 / 132-586, uppercuts 71-627 / 71-606). Upper bounds did not move.
1. Re-run run 7's remaining-base and body rows under the corrected bands on all four generated legal rows. Report what
   now passes and what still fails. A T that clears does NOT certify a move - J, V and B still stand.
2. J (join discontinuity) is the failure every candidate except jab/cross shares. Find WHY jab/cross join and hooks and
   uppercuts do not (entry phase of Bouncing_Boxing_Idle vs the take's first frame, exit pose back to guard, the inertial
   blend window), and fix it in the PIPELINE the way a game animator would (matched entry pose per take, a proper
   exit-to-guard). Never loosen the per-bone join limits; seam mutants must stay rejected 20/20.
3. Rear hook: an orthodox rear-hook source (Mixamo Boxing_Back_Hand_Hook or the operator archive); a whole-clip mirror
   swaps stance and stays rejected.
4. Then body versions and the one-two / double-jab chains (their only failure was J).
Deliver as before: digest first line `Boxing EXACT-that-PASSED: 2/36 -> N/36`, per-move rows on all four, push per
certified move with one agent_comms send, no video/.exe/HANDOFF/master push, Kimodo OUT.

## RUN 9 (S119) - the slow sources: retime the strike phase, then the rest of the 36
Run 8 merged to master as a diff (8812a447): boxing **5/36** (jab, cross, jab_body, one_two, double_jab). Master also has
Q211 (22d71d18, engine only). Claude merged master INTO the branch (9ded87a3) - start from the branch head, no rebase.
Run 8's own rows name the pattern: every remaining hook fails **V** (5.0-7.9 m/s vs 8-14), uppercuts / rear hook / body hooks
fail **T** (late: 650-983 ms), and rear hook + lead uppercut fail **B** (bodies overlap 3-12 cm). V and T are the SAME defect -
a slow source. **What a game animator does with a slow mocap take: retime the strike phase** (anticipation->impact
compressed to the measured band with its easing kept; guard, recovery and poses untouched) - precedent in
`MOVE_SCRIPT_BOXING.md:60` ("the take's clock retimed, poses ..."). That is a pipeline step, not a threshold change.
1. Add a per-binding strike-phase time warp (e.g. `"strike_warp": {"from_s":a,"to_s":b,"scale":k}`) applied at retarget/bake,
   before foot plant and the guard phases. Re-gate lead hook, rear hook, both uppercuts, body hook on all four generated
   legal rows. Scale only the onset->impact span; a warp that pushes peak speed past the band top, pops, or breaks J fails.
   Seam mutants stay 20/20 rejected; add a mutant that warps the WHOLE clip (recovery included) and show the gate still
   judges it on its own rows (no free pass for warped clips).
2. **B** (rear hook, lead uppercut): the take travels into the receiver. Fix at the fixture/root the way the jab/cross
   did (take's authored reach, root travel held) - never by moving the receiver per frame.
3. Then the rest of the 36 in SHOT_LIST_STRIKING order: cross_body, rear_hook_body, shovel, inside uppercut, overhand,
   up_jab; counters (slip/pull/catch/over-jab/check hook/counter combination) as SEQUENCE entries of certified parts plus a
   defensive take; footwork rows. Push each certified move with one `agent_comms.py send`.
**Finish line: as many of the 36 as pass, each playing in the game via `play_role`; stop and name any move with no
passable source.** Same rules: four generated legal rows, stills opened before measuring, digest first line
`Boxing EXACT-that-PASSED: 5/36 -> N/36`, tokens in the digest, no video/.exe/HANDOFF/master push, Kimodo OUT.

## RUN 10 (S119) - the operator's RamsterZ look, then the rest of the 36
Run 9 merged to master (in 21878ca9): boxing **10/36**. Master merged INTO your branch - start from the branch head.
**Operator S119, verbatim: "the animation looked a bit better with ramsterz" (it looked better).** Claude compared the
two jabs on the same bodies (`tools/s119_showreel.gd -- compare_jab`): the Mixamo Med_Head_Jab lunges with the whole
torso; RamsterZ H2H_JabInPlace is upright and snapped, and its joins are cleaner (hand join 0.27 cm vs 2.1). It sat
out ONLY on speed (15-18 m/s peak vs the 4.5-9.5 jab band) - its run-3 slip failure was on the old Tripo rigs, before
the foot-plant pipeline fix.
1. **RamsterZ first.** For every certified move whose production source is Mixamo (jab, jab_body, and the chains that
   use the jab), audition the RamsterZ H2H take with run 9's `strike_warp` (scale > 1 slows the strike span; recovery
   untouched) so the peak lands INSIDE the band with margin - aim for the band's middle, never a scale tuned to sit on
   an edge (run 9's rear hook passed by 0.001 m/s: note it, and re-open it if a RamsterZ or other source gives margin).
   Rebind only when the RamsterZ row passes every C223 row on all four bodies; keep the Mixamo row when it does not,
   and say why. The one-two / double-jab chains re-certify on the new jab.
2. Then the remaining 26 in SHOT_LIST_STRIKING order (cross_body has no standalone source - skip it and name it).
   `boxing_feint` has NO presentation path in the live room today (the engine throws ~7/min, the room shows none) - a
   feint clip is still wanted; its routing is Claude's.
Same rules as run 9. Digest first line `Boxing EXACT-that-PASSED: 10/36 -> N/36`, and a line naming which moves are now
RamsterZ-sourced.

## Owned files
`Godot/scripts/FightClipBinding.gd` (binding rows only - read `sed -n` windows, grep `boxing_`/`kickboxing_`), new clips under
`Godot/assets/anim/c223/`, `Godot/tools/c223_*.gd`, `previews/c223/`, `research/C223_DIGEST.md`.
Added by Claude's run-5/run-6 briefs (S116-S117, pipeline scope authorised there - per-ruleset guard idle, rest-floor
alignment, bake-time foot plant, join discontinuity, capsules on generated bodies, the jab's clip phase and alias):
`Godot/scripts/FightStagePlayer.gd`, `Godot/scripts/FightClipRetarget.gd`, `Godot/scripts/FightClipFootPlant.gd`,
`Godot/scripts/FightBodyCapsules.gd`, `Godot/scripts/FightBeatAdapter.gd`, `Godot/scripts/FightWorldLiveScreen.gd`,
`Godot/assets/data/clip_phases.json`, `Godot/tests/boxing_idle_binding_test.gd`, `Godot/tests/boxing_join_discontinuity_test.gd`.
Read-only: everything else. `FightRealtime.gd` is ~7,700 lines, `GameState.gd` ~12,900 - never open either whole.

## Deliver
Digest first line: the census before/after for boxing and kickboxing (EXACT that PASSED the gate / total), then the per-move
gate table. Commit and push per batch; one `agent_comms.py send --from codex` line per batch. Do NOT build an .exe, do NOT
record video, do NOT edit HANDOFF.md, do NOT push to master.
**Trap:** a clip that is the right move but skates or pops is NOT done - and a smooth clip of the wrong move is worse,
because it hides. Check the motion is what the name says (the contact sheet) before you measure it.
