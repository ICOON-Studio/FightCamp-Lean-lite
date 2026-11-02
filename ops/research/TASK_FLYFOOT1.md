# TASK FLYFOOT1 (S219) - "i do not want flying fighters" / "abnormal stance": the body slides across the ring on the IDLE clip

Model: Codex sol (gpt-6.1-sol, NEVER astra). Own worktree E:/FightCamp/wt/FLYFOOT1 (seed it), branch codex/flyfoot1 from master.
Never master. Next free Codex seat - an operator-seen defect goes before TECHSTAGE1 FIX5.

## Operator, verbatim (S219, markup on 8787/review, cast_male_strip.jpg = E:/FightCamp/tmp/cast_male_strip.jpg)
- Frame 3 (round clock 2:38, Miller in purple, blue corner): "i do not want flying fighters" - he is in a near-horizontal split lunge.
- Frame 2 (2:50, Miller): "abnormal stance" - feet crossed/splayed, knees buckled.

## Primary source (Claude S219): E:/FightCamp/tmp/cast_s217/male.csv (the recording behind the strip; male.avi, male.log beside it)
Both frames are BLUE playing `idle` (blend `inertial`), no hit impulse, no flinch. Yet:
- t 22.06-22.49 s: blue pelvis moves (0.08,-0.03) -> (0.44,0.39) = 0.55 m in 0.43 s (~1.3 m/s), then straight back
  (0.44,0.39) -> (-0.14,-0.48) by 22.99 s. Stance width 0.27 -> 1.00 m (22.39 s) with one foot locked (lock0/1 then 1/0).
- t 9.03-9.39 s: same pattern, width 0.60 -> 0.88 -> 0.39 -> 0.68 in 0.36 s, pelvis ~0.45 m/s, feet alternately locked.
So the room/sim moves the body's root at walking-to-running speed while the clip is idle and no stepping (shuffle/human_footwork
gait) plays; the foot lock (FightStagePlayer `_lock_feet`, UNPLANT_RADIUS 35 cm, LOCK_RELEASE 3) pins one foot -> the legs split
("flying") and then cross when it lets go. Find WHO moves the root (FightWorldLiveScreen placement / spacing / separation push
FightSeparation.gd / the movement planner) and why no gait is chosen on these MetaHuman bodies.

## What would a human do?
A boxer never travels without stepping: every root move above ~0.2 m/s is a step or a shuffle (lead foot first going forward, rear
foot first going back), feet never closer than ~shoulder width nor wider than ~1.3x, never crossed (D64_GUARD_STYLES, K46). A spacing
correction is done by stepping, or by slowing the correction to what a step can carry.

## Gate (must read RED on master first - paste the red lines)
A per-frame live-fight probe on the MetaHuman cast (as_game, both men, >= 60 s, 2 seeds, different fighters): for each body
(1) root speed while the clip is idle/guard and no gait is active - max <= 0.25 m/s; (2) stance width (ankle-to-ankle, ground plane)
in [0.30, 0.75] m outside strikes and in [0.25, 0.95] m during them; (3) feet crossed (lead/rear swap across the stance line) = 0
frames; (4) both feet airborne in idle = 0 frames. Report max/p95 per body and the worst frame times. The cast recording above
already shows (1) 1.3 m/s and (2) 1.00 m - your gate must read those red on master.

## Do
1. Gate first (red on master). 2. Fix the cause: either the root mover requests a gait whenever it moves the root faster than
0.25 m/s, or its correction is rate-limited to what the active gait carries - your call, cite what Unreal / Motion Matching do for
root-motion-vs-capsule mismatch (Q103 notes). 3. The foot lock never holds a foot past the stance-width band: release + step.
4. Re-run the gate (green) + `python Godot/tools/run_tests.py --jobs 2 --only realism,foot_lock,footwork,spacing,separation`
(parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`). 5. Stills + a 20 s clip on the game camera (below).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Prior research
FightStagePlayer foot-lock notes (lines ~4730-4790: U93/U94 pops, S131 pivot step, C215 shuffle); FightSeparation.gd; Q103
(Unreal root-motion compensation); K46 / D64_GUARD_STYLES (stance width, stepping); ANIMSOURCE1D_FIX2 spacing gates (do not
duplicate - reuse its spacing band). FightStagePlayer.gd is 6,499 lines: read windows (grep first), never whole.

## Prefab check
Godot 4.7 has no motion-matching locomotion built in; the project's own shuffle/human_footwork gait is the prefab - wire it, do not
write a new gait.

## The one trap
Do not "fix" it by turning the foot lock off - the S116 slip gate goes red (jab slip 4.7 cm). The lock is right; the root must not
outrun the feet.
