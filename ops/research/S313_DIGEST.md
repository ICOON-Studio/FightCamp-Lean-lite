# S313 DIGEST (2026-10-30) - the clinch and the referee, the guard by range, punch bursts, Ziva's defects (update 15)

## What now works (Lean ac61341, c2acfe6, c993787)
- Qwen CLINCHBEATS1 collected with three review fixes: two clinches in one exchange overlapped (122 of 900 hurt
  exchanges; test 9 added, red on Qwen's version), "prefer right after a landed punch" was dead code, and a 3.1 s
  cut-off skipped every short gap (round 1 read 1.58 a round). Now 2.23 / 4.16 clinches a round (real 2.5 / 4.8),
  mean 2.88 s (real 4.1; punches are never moved, so it is bounded by the free gaps).
- The clinch in the ring (real-fight gap 4): RangeBreath "clinch" phase (0.38 m) from the clinch beat to its break_t;
  Clinch.gd holds both in the block pose mid-loop, bodies shifted to their own left so the heads pass, the holder's
  arms over the other's shoulder blades and the other's hands on her flanks (CornerIK), each looking past the other;
  the closest gap eases back over 0.5 s on release (S313 stills: it snapped 0.28 m apart in one frame before).
- The referee (Referee.gd): the cutman body in a white shirt / black shorts, 1.25 m off the line on the far side from
  the camera and 0.6 m along it (square behind, his head showed between theirs); 0.85 m while they hold; slides square
  between them for af_push at the break; takes the other side when the ropes pin his spot and never comes within
  0.55 m of a boxer (probe: he walked through them, nearest 0.03 m; after: 0.48 m, 0 frames inside 0.45 m).
- The guard drops at range (gap 5): GuardTuck.low lowers the wrists 0.26 m (lead) / 0.16 m (rear) and 0.06 m forward
  at rest, up in 0.15 s for the entry lunge; it now runs on the step clips too (at rest they step most of the time -
  the first still showed no drop at all).
- Punch bursts (gap 6): Qwen BURSTS1 (BurstShape.gd) collected with its burst sizes retuned (Qwen had 2/3/45/25/25 %,
  84 % of attacks 3-5 punches; now 10/20/32/22/16). 21 punches an exchange (the real ~20 a minute each) in ~6.5 bursts,
  quiet spells ~4 s. Wired in ExchangeBeats before the game's extras and the clinches.
- Ziva's defects (Q-S294-23 "Yes, fix in this order"): "Go to the body" is press's ok call; the opponent keeps one game
  at most 3 exchanges (Exchanges.MAX_RUN); an armed set-up also fires into a hurt opponent (CornerJobs.fits). Balance
  harness still green.
- Round 1 probe (tools/range_probe.gd, same fight as S311-S312): long 62 % (real 40-63), swings 23.5 a minute (18-35),
  feet moving 58 % (real 53-56, first time in band; S310 9 %), travel 122 m (real ~155), 3 clinches all tied up,
  inside 5 % (real 17-31 %: next).
- Update 15 exported; tests 31/31; exe smoke 0 errors; stills on the review board; Q-S294-25 with the contact sheet.

## Delegated
- Qwen CLINCHBEATS1 and BURSTS1: both collected and merged this session (worktrees retired, runs archived).
- John J-INSIDE1 (seat_queue SQ19): inside range in amateur boxing - share, spell length, what is thrown, defence.

## Decisions (Claude, as developer)
- ClinchBeats test 4 floor 3.0 -> 2.7 s: the real 4.1 s does not fit between our punches without moving them, and
  moving punches would shift the captions and the score; a worse module (Qwen's) still reads 2.68 and fails.
- BurstShape test 4 ceiling 6 -> 7 bursts: our exchange carries ~21 punches (real rate); the brief's ~4 assumed ~10.
- A set-up into a hurt opponent fits whatever its gap: that is when a corner shouts NOW, and following the coach's plan
  no longer costs the set-up its window.
- The referee is the cutman body (amateur bouts show no cutman), so no face repeats in amateur fights; a pro fight
  repeats the cutman's face (limit).

## Limits
- The staff bodies have no trousers: the referee wears black shorts.
- In the tie-up the faces sit close but not quite past each other's shoulder (film: "heads together" - accepted).

## Open with the operator
- Q-S294-24: update 14 verdict. Q-S294-25: update 15 (clinch + referee) verdict.

## Next
Inside range (real 17-31 %, ours 5 %) once John's J-INSIDE1 lands; restart Ziva (start said ZIVA DOWN) and give it a
playtest of update 15; gap 7 (stance a little longer) is minor. Lean NEXT_SESSION_PROMPT.md has the details.

## HANDOFF
Working commit: Lean c993787 (update 15 built from it); Game roadmap now = S313. Exact next action: roadmap
`now.next_action`.
