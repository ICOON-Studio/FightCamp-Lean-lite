# S504 digest (2026-11-16) - fight motion week day 9: hit reactions on the blow

## Operator this session
- None in chat (session start only). Board: Q-265 asked (Scorecard tab mockup, his S503 idea), waiting on him.

## Hit reactions (both r10 blind critics' item 1)
Ruler: `tools/fight_motion_rulers.py` now prints reaction rows BY KIND (jab / cross / hook / body / uppercut): head cm
(from the hips), frames to the furthest point, step back cm, hip-line turn, head travel in the ring - beside the
critics' targets. Films: log-only `human_fight_film secs=180 seed=7` (37 reactions; 75 s held only 7-14), all in
`E:/FightCamp/tmp/fightweek/s504base .. s504e`.

What was wrong, frame by frame (s504base): the head jumped ~10 cm on frame 1 (the layered snap), then crept to its peak
at frame 4-5, for three reasons stacked:
1. the hit-stop froze the HIT man's reaction clip too (1-2 frames);
2. the reaction clip started 0.10 s before its peak;
3. it entered through the strike join (half-life 0.06 s, 0.3 s), which shows ~45 % of the reaction by frame 2.
And 7 of 37 reactions were cut by the hit man's own punch at frames 3-6 (S311 let him counter at once).

Built (each with a switch back):
- HitImpact: the hit-stop holds only the hitter (FightStage._hold_skip; RingPlace/RingFeet let the hit man's step run).
  `-- holdboth`.
- BeatFire: a punch scheduled while his head snap is under 0.20 s old waits (never dropped), like the S371 fold wait.
  `-- nosnapwait`. Every punch that cuts a reaction now starts at frame 6, after the peak (was 3-6). The ruler's
  CUT_WINDOW is 6, so it still counts them - left as is (changing the ruler to pass would be gaming it).
- BeatClips.REACT_LEAD_S 0.10 -> 0.067.
- HitImpact.REACT_JOIN: a hit reaction's own quicker join. `-- slowreactjoin`.

| film | change | frames to peak (median) | later than 4 f | head jumps > 12 cm (contact) |
|---|---|---|---|---|
| s504base | - | 5 | 25 | 89 (14) |
| s504a | hitter-only hit-stop | 4 | 18 | 88 (14) |
| s504b | + snap wait | 5 | 23 | 87 (14) |
| s504c | + lead 0.067 | 5 | 20 | 83 (14) |
| s504d | + reaction join 0.035 / 0.2 | 3 | 3 | 96 (18) |
| s504e | reaction join 0.045 / 0.22 | 4 | 6 | 82 (15) |
| s504f | reaction join 0.04 / 0.21 - KEPT | 4 | 3 | 90 (16) |

s504f by kind: jab 3.5 f (target 2-3), hook 3 f, cross 1.5 f, body 4 f; head travel in the ring jab 15.8 cm, cross 23.9
(target 18-25), hook 23.2 (20-30), body ~37. 0.035 hit 3 frames median but added jumps (96); 0.04 keeps the jumps at
the baseline's level - the jump cap is the next item. Cross step back still ~9 cm (target 15-25): HitStep's 0.15 m is pulled
back by the range keeper; raising it to 0.20 broke hit_step_test's "a cross steps back less than a body shot" and
the 1.4 m/s cap for +2 cm, so it was reverted. Traced instead: the place moves the full 15 cm, the SHOWN hips trail it
(RingFeet.shown lerps to the feet rig's step centre; HitStep.lean capped the rock at 8 cm). HitStep.lean_max: the rock
cap is 80 % of the step, never under 8 cm (`-- oldlean`). s504f -> s504g: cross step back 9.2 -> 11.4 cm, body 11.8 ->
16.4, nothing else moved. hit_step_test updated (the cap is checked against lean_max) and green.

Head jumps split (s504f, 90 over 12 cm): 54 in the PUNCHER's own clips (body shot lunges 27 cm a frame, jabs at clip
changes), ~25 in reactions - the cap goes on the punch first (next session).

## Seats
- Qwen PUNCHEND1 collected (PR 337 closed): punch_end_test green; r10: 123 punches, 5 end 10+ cm above the head.
  Its "home" reads 30 (never) for nearly every power punch - home is the run's first frame, often mid-blend.
  -> TASK_PUNCHEND2 (home from her guard + from the contact frame), queued for Qwen (dispatch_queue).
- Qwen STANDOFF1 (new, S504) collected: stand_off_test green. s504b: 619 frames inside 1.0 m, ONE 0.3 s glove-press.
  The critics' "stand-offs" are standing close doing nothing, not gloves pressed - the next fix targets that.
- Ziva COACHNECK2: nothing exists - no ziva/coachneck2 branch, ZIVA_LEAN still on ziva/knee1 (S498), no CornerIK
  change (ETA was 18:30). Re-send next session.

## Scorecard (operator's S503 idea)
Mockup `docs/mockups/s504/scorecard/scorecard.png` (1920x1080, our look): header + verdict, SCORECARD tab between
SUMMARY and THE EXCHANGES, three judge sheets (round 10 / 9 in hand, so far, total ringed, corner stamp), a hover on a
score = that judge's reason for the round, round-by-round cards (landed, clean, ring, the reason), what it means (record,
ranking) + Watch round 2 / drill / Continue. Board Q-265 + map frame scorecard1.

## Debt
uppercut_tail_test red before and after (4 failures with the old hit-stop, 2 with the new) - not in the nightly list.
block_absorb, hit_carry, join_return, punch_speed, punch_weight still red since S496-S501.
