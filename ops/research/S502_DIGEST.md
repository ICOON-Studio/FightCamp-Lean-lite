# S502 digest (2026-11-16) - fight motion week day 7: range + exit, hit reactions sized

## Collected
- PR 334 PRESSFLASH1 (Qwen): crowd camera flashes keep clear of the boxers' screen boxes and are capped at 46 px.
  Merged by hand with four fixes: `keep_off.is_custom()` (false for a bound method, so the game never asked for the
  boxers), `Node.has("boxers")` (no such method; `"boxers" in s`), the fade rescaled the star every frame (the cap lasted
  one frame; the cap now rides in the pool entry `sf`), and the test camera errored and faced away from every seat (the
  test passed by skipping). The test now awaits a frame for the camera and has a control arm. Commit ced24ff4f.
  NOT SEEN by eye yet: r9 is the first film with it.

## Built (commit 2bf82d3a0)
Both blind critics' (r8: coach 5, animator 4.5) top two items.
1. RANGE + EXIT. The r7 film: 220 of 314 "inside" frames had nobody punching - both in their idle at 0.94 m pelvis to
   pelvis, heads ~0.5 m apart, which reads as forehead to forehead on the side camera. `RangeBreath.phase` now returns
   `{"phase": "pocket", "edge": true}` inside a spell when no punch is in the air, none is due within NEXT_LOOK_S (0.9 s)
   and SPELL_HOLD_S (0.35 s) has passed since the last; `want_m` = jab gap + EDGE_M 0.22; Footwork steps out at
   EXIT_SCALE. EXIT_AFTER_S 0.5 -> 0.4 s (12 frames). `-- noinsideedge` = the old hold.
   r7 -> r9a (same bout, seed 7, 75 s): close idle spells (heads < 60 cm for > 8 frames, no punch) 5 spells / 119 frames
   -> 0; idle inside frames 220 -> 96; slowest exits (p90) 22 -> 16 frames.
2. HIT REACTIONS SIZED. HitImpact.SNAP_DEG jab 15 / cross 28 / hook 28 / uppercut 22 (was 11/16/19/17; `-- oldsnap`); a
   hook snaps along its sideways travel so the head turns instead of going back; a cross drives the trunk further
   (HitSnap.snap `give_mult`, CROSS_GIVE 1.45, cap 20 deg); HitSnap.RISE_S 0.035 -> 0.06 (the bigger snap in one frame
   read as a pop); a clean cross steps back 0.15 m (HitStep.CROSS_BACK_M; a hook stays at 0.10).
   r7 -> r9c: reaction peak median 5 -> 4 frames, late (> 4) 10 -> 7, head travel 9.7 -> 12 cm; by kind jab 8.4 -> 9.5 cm,
   cross 8.4 -> 12 cm, hook 9.8 -> 10.8 cm (now a turn). 80 % of the move lands in 1-3 frames (the "furthest point" ruler
   is fragile on a plateau). Head jumps 22 -> 24: the extra ones are the hit head itself moving 12-17 cm in the contact
   frame (~4 m/s, real punch speed), not clip pops.

## Tests
Green: range_breath, hit_step, fight_feel, body_keep, boxer_footwork, hit_snap_gain, human_feet, knee_calm,
uppercut_tail, crowd_flashes, hit_flash. RED BEFORE THIS SESSION (checked on a clean worktree of main): block_absorb,
hit_carry, join_return, punch_speed, punch_weight (punch_range needs the hidden desktop; file_limits: GamePlan.gd and
MatTree.gd at 501 lines). Against that baseline: join_return one line better, block_absorb one line worse (the blocked
cross B_A), hit_carry reshuffled (24 lines new, 17 gone: it reads the glove on a head that now moves more). These five
are fight-week debt: a session should bring them back to green or re-baseline them on the critics' numbers.

## Seats
- Qwen FILMBAR2 (round 2 of PR 333: a conditional binomial test of two rates), launched 18:19, wt LEAN_FILMBAR2,
  ETA ~20:10. Brief ops/research/TASK_FILMBAR2.md.
- Ziva COACHNECK2: no branch yet.
- Guard damage v1: Dola SQ205 depth 6 / general 7 / play 7 (below the 7+ bar: v2 needed). John SQ204 still out.

## Not done
- Critic item 3 (defence on screen): 48 punches in r9c drew ~9 slips/pulls and ~20 guard catches; some slips are 5-8 cm
  and peak 7-11 frames late (critics: 15-20 cm in 4-8 frames). Shares unchanged until the r9 critics say.
- Items 4 (feet slide) and 5 (hands home: arm out median 6 frames, worst 15 - near the 4-6 bar already).

## Blind round r9 (after the build above, the new low camera)
Coach 4.5 (punches 5, defence/reactions 4.5, feet 4, blending 4, waiting 4); animator 5 (5.5, 5, 4, 4.5, 4). r8 was 5 /
4.5. Both put the FEET first: planted slide 10.64 / 11.74 m a round, `pro_idle` alone 5.81 / 5.48 m. Then the waiting
(longest still guard 5.8 s), punches finishing above the head, hands home in 3-4 frames, follow-up on a hurt man, the
fold rising in ~2 frames. Files E:/FightCamp/tmp/fightweek/r9blind; 10/10 pictures on the review board (S502).
Build exported 19:05.
