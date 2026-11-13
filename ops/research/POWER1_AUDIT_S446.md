# POWER1 steps 2-4: audit after two red rounds (S446, Claude)

Rule (memory feedback_audit_before_more_fix_rounds): two red review rounds -> audit before a third. Read for this audit: the
blind read VERDICT.md (S445 side session notes), docs/POWER1_STEP4_RESULT.md on claude/power1 @ 15eb475e, the fix round's
test outputs and sheet_cross.png, `git log main..claude/power1` (24 commits, 39 files, +5297/-1213), and a merge-tree check
against main (merges clean, 3 commits behind).

## What the two rounds proved
The branch is BETTER than main on every ruler that can see the drawn picture, and equal within noise on the rest:

| ruler | main / control arm | claude/power1 |
|---|---|---|
| punch_range (played fight, drawn bodies) | 100 | 74 |
| straights: elbow in band at the hit | 0 of 9 (median 76 deg) | 6 of 9 (median 155) |
| heads closest on a hit (straights) | 0.39 m | 0.60 m |
| reach corrections over 0.30 m | 10 (largest 0.67 m) | 0 |
| punch_speed | 42 | 39 |
| punch_weight | 0 | 0 (the leak is gone) |
| hit_frame / hit_carry / block_meet | 11 / 40 / 11 | 12 / 42 / 11-12 (run-to-run noise ~2) |
| fight_feel, beat_clips, beat_tally, sound_sync, head_aim, human_feet, range_breath, block_set | green | green |

No file under scripts/rules or scripts/state changed: who wins is untouched.

## Why a third fix round would not turn it green
Each remaining red has a cause the reach code cannot reach:
1. **Hooks and uppercuts miss (MISS 20):** the clip's own glove ends > 0.30 m from the target at contact; the honest cap
   stops it short. Fix = hook/uppercut takes thrown at a real target (the mocap packs he buys end of November), not more IK.
2. **Lead uppercut pop (26 m/s):** JoinSmoother captures the clip's raised arm, not the drawn glove. Own task (JOINFIX1).
3. **Head dips and lead toes crossing (HEADS 28, TOES 16):** same rate on main; they come from dodges, body shots and hit
   reactions, not punches. Own task (FEETDIPS1).
4. **Gloves pass through each other after the hit** (sheet_cross f21-f30): no glove-glove collision anywhere. Own task.
5. **Cross/jab reach the face one frame early at 13-15 m/s:** the only red that is POWER1's own; one small fix, folded into
   the collect check below rather than a fourth round.

## The films (S446, tools/hit_frame_film.gd seed=4242 side=1 on claude/power1; "today" = `-- nopunchrange`)
The switch turns step 4 off only; steps 2-3 have no off switch, so both rows carry them. Sheets: docs/mockups/s446/power1_*.png.
- Step 4 is plainly visible: today the cross lands with the arm folded and the heads touching; new, nearly straight from a
  real distance. Jab thrown from further out; uppercuts from their own range.
- Step 2's own goal is NOT met in the played fight, in either row: the glove moves 8-23 % of its top speed on the hit frame
  (cross 15.0 m/s on f18, 1.2 m/s on f19). The hit-stop freezes the drawn glove on contact. Fighting games freeze the hitter
  on contact by design (that freeze is the impact), so the brief's ">= 50 % of top speed on the hit frame" bar may be the wrong
  bar; judge the speed on the frame BEFORE contact plus the carry after the freeze. Logged for steps 5-6, not another round.
- CHECKED AGAINST THE TWO SHIPPED GAMES (operator S446: "check undisputed and blood&canvas how they do it"; read from our
  own earlier REA notes, no new run): BLOOD_CANVAS_STUDY_S392 + REFERENCE_DISTANCES_S439 line 46 - Blood & Canvas freezes
  BOTH boxers 0.04 s on a landed hit (EndHitStop timer, both blueprints). Undisputed has NO hit freeze (no HitStop /
  HitPause / FreezeFrame anywhere); its punch plays on through contact instead: follow-through 0.08-0.09 s (jab, cross),
  0.15-0.31 s (hooks), 0.18-0.28 s (uppercuts); hit reactions snap in within 0.05 s; camera shake; a ragdoll push (impact
  force 0.5-2.5, hand mass x4 while punching). Ours: HitImpact.HOLD_S jab 0.03 / power 0.05 / big 0.06 - Blood & Canvas's
  size. VERDICT: our freeze is the industry's; the ">= 50 % of top speed ON the hit frame" bar is retired. The bar that
  stands is Undisputed's: the glove keeps travelling after the freeze for its follow-through time, and the reaction lands
  within 0.05 s. A 15 m/s single frame before contact is the one speed defect left (step 3: no frame over the band's top
  + 20 %).

## Decision
Stop fix rounds. POWER1 steps 2-4 are collected as "better than main", by the visual gate: a before/after film of the same
punches (seed 4242, side camera) goes to the operator; on his OK the branch merges whole (it merges clean) and the four
causes above become their own queue rows. Steps 5-6 are briefed fresh after, on main.
