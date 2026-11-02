# TASK_U163 - take four's switches make kicks 9.75x and hand jumps 4x: fix them before take four is recorded (Cursor)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S66, 2026-09-24.

## Why
Take four will be recorded with `strikes_play_whole` (Codex C190) and `reactions_play_whole` (U159) ON - the fix for the
operator's preview-quality ruling ('We are not buying other clips unless I see the quality that I see on the YouTube
preview videos'). Your U160 round 4 (`5d7a619e`, like-for-like world speeds, vendor FBX world vs live world) found that
with those switches ON: a kick's foot peaks at up to **9.75x** its vendor source (IK / placement, not tempo), and wrist
jumps > 8 m/s while stepping rise from **32 (OFF) to 125 (ON)** on MMA seed 92012 (Muay Thai 92020: 6 -> 39). Elbows are
fine (<= 1.18x) - the operator's 'elbows too fast' is readability, not speed, and is NOT this task.

## Part 1 - attribute, with the switches ON
For the ten worst kick plays and the ten worst hand jumps: split the world-space excess into clip-local motion, C190's
whole-strike root/placement warp (0.4 m / 30 deg bound), foot/arm IK, body layers, and the walk join - per frame, as your
round 2 did. Use U160's vendor-world probe; print the populations (the S65 demo pair, and two different Muay Thai men).

## Part 2 - fix the owner(s)
In the whole-strike path (C190's code in `FightStagePlayer.gd` / `FightWorldLiveScreen.gd`) or the IK/join that fights it.
A kick with the switch ON must peak at its source's world speed within the ratio you justify; hand jumps ON no worse than
OFF. Never by slowing the clip below its source (round 3's lesson). Behind the existing switches - no new default change.

## Owned files
`scripts/FightStagePlayer.gd`, `scripts/FightWorldLiveScreen.gd` (the whole-strike path, IK and joins only),
`scripts/FightBodyLayers.gd` only if Part 1 convicts it, `Godot/tools/u160_speed_probe.gd` (extend), `tests/fight_strike_speed_test.gd`
(extend: switches ON - kick world peak within the justified ratio; hand jumps ON <= OFF; mutants caught), `research/U163_DIGEST.md`.

## Gate (tier: scripts edited)
Parse gate; the extended test with mutants; `--only fight_stage`, `--only fight_world`, `--only fight_reaction`,
`--only fight_strike_whole` (one `--only` per invocation; read `total=`). Branch `cursor/u163-take-four-kicks-hands` off
`origin/master`, then MERGE your `cursor/u160-speed-and-hands` into it first (your walk smoothing and probe live there).
Commit, push, `agent_comms.py send --from cursor --to claude --topic U163`. Do NOT edit HANDOFF.md.
Trap: never divide a world speed by a chest-relative one; and Codex C191 is editing the same files for clipping - keep to
the whole-strike IK/join functions, whoever lands second merges.

## ROUND 2 (S66, 2026-09-24) - the kick cap does not hold; find what writes after it
Round 1 (`6c698fe6`) fixed the hands (take-four ON 125 -> 0 jumps; good - keep it) but the kick did not move: worst
`kickboxing_body_kick` 9.75x -> 9.81x its vendor world peak, even with `finish_strike_effector_frame` capping the foot at
vendor x 1.05. A cap that leaves the peak where it was means the peak is written AFTER it, or measured on something the
cap does not touch (the foot bone vs the probe's sampled point, a root/placement move applied to the whole body, a
frame the cap skips). Print, for the worst five frames of the worst five kicks: the foot's world speed immediately after
the cap, then after every later writer (body layers, foot lock, leg IK, separation, the room's root write), and what the
probe samples. Fix the writer that re-adds it. And say what take4 OFF's 23.74x kick max is (same writer? a probe
artefact on a near-zero vendor sample?) - report whether the RATIO's denominator is sound for every kick (a vendor foot
that barely moves makes any ratio huge; state the vendor m/s beside every ratio).
Same owned files and gate; digest under `## Round 2`. Trap: a cap that measures itself can always pass - check it on
the frame the probe flagged.

## ROUND 3 (S66, 2026-09-24) - is the denominator the STANDING foot?
Round 2 (`ba930df7`): worst `kickboxing_body_kick` screen 23.73 m/s / vendor 2.47 m/s = 9.62x, and you called the
denominator sound. A body kick's striking foot does not peak at 2.47 m/s - that is a walking foot. You also found the cap
was reading LeftFoot from the catalogue while the probe saw LeftFoot move. Settle it:
1. In the VENDOR clip, which foot kicks? Measure both feet's world peak in the kick's window; the kicking foot is the
   one that travels to the target height. Print both beside every kick ratio in the census. If the probe or the
   catalogue names the support foot for any kick, every ratio for it is meaningless - list them all.
2. Anchor the real speed: published peak linear foot velocity of a roundhouse / body kick (sport-science literature -
   cite it, e.g. taekwondo / Muay Thai kinematics studies). If the screen's 23.7 m/s is inside the real range, the
   kick is not too fast and the take-four cap must not slow it.
3. Then re-state which kicks, if any, are genuinely faster than their own kicking foot in the source, and fix only those.
Keep round 2's tail/foot-lock fixes if they still prove out. Digest under `## Round 3`. Trap: a ratio whose denominator
is the wrong limb is not a measurement - it is how rounds 1-3 of U160 went wrong too.
