# S467 digest (2026-11-14, Claude Opus)

## Board
- Q-224 hosted club show and Q-225 push switch + tank: both "Yes, build after the fight week" - queued behind AMATEURWEEK1.
- C390/C391 on the S466 cross stills: "Fine", "Fine but i wait to see it in the match".

## Collected
- LIVERRIBS2 (Goose #271): scripts/rules/LiverRibs.gd + tests/liver_ribs_test.gd, only the two added files (the branch was
  behind main; its BodyMap/ReachLimit diffs were older main, not taken). PRs 269/270/272 closed (collected in S466).
- NIGHTLYTRIAGE1 (Qwen #273): tools/nightly_triage.py + docs/NIGHTLY_TRIAGE_S466.md.

## Liver vs ribs wired (LIVERRIBS1 v2, his Q-219 yes)
| Rule | Where | Shown on |
|---|---|---|
| 9 injury split | InjuryRoll.bout_roll: a bout rib injury is the LEFT ribs only, bruised 10-21 d / cracked 35-56 d (LiverRibs.injury_split); the liver never lays her off | Home / Fighter injury line: "Bruised ribs (left)", "Cracked rib (left)" (InjuryRoll.name_of) |
| 1 drain by side | LiveRound keeps f.bout.sides {free, liver, ribs}; RingDuel/LiveRoundAfter.body_units: liver x1.3, ribs x0.55, un-aimed the 60/40 mean (= the old count) | the energy bars (same code path) |
| 5 ribs hurt | LiveRound: a boxer with hurt left ribs (PaceAim.RIB_HURT_AT shots) lands x0.85 | aim hover |
| anatomy | PaceAim.opp_hurt: the liver is on the right for every stance (S466 fixed BodyMap; this one still flipped for southpaws) | the corner's aim buttons |
| words | aim buttons "Liver (right side)!" / "Ribs (left side)!", effect + hover say what each does | corner bar |
| 2-3 liver fold | scripts/state/LiverFold.gd from BoutNight._counts: fresh liver shots past hurt roll LiverRibs.liver_fold_chance; a fold is one count (RSC limits as any count), round line "folds from a shot to the liver: body knockdown, an 8-count" | round lines; result page counts tile "counts, N from the liver" + hover "Body knockdown (liver): round N" |
| 6 crack in the bout | LiverFold._crack (same call): critical left ribs (same per-shot scale), each fresh rib shot rolls LiverRibs.crack_chance; f.bout.cracked; the cracked side lands x0.6 (LiveRound); Injuries passes rib_cracked -> a "Cracked rib (left)" after the bell | round line "...'s left ribs crack: that side is holding on now." |
Tuning (tools/liverfold_probe.gd, 100 played bouts, seeds 100-199): 6.0 pts/shot -> 7 folds of 27 counts (26 %), 7.5 -> 22 of 42,
5.5 -> 0; LIVERPROBE1 (Qwen, 400 bouts) sets the final pair.
Not yet: the opponent's corner retiring a cracked boxer (rule 7) + YOUR 3-choice crack card (rule 8); the crack and the fold
only roll in a round with no other count, side elbow fixes, the opponent switching sides, energy
ceiling -25 after a fold, BoutRead/Scout lines (design s6 rows 3, 5, 6, 7).

## Nightly reds (docs/NIGHTLY_TRIAGE_S466.md, S467 table)
no_pronoun GREEN (two lines), result_defects GREEN (check 2 takes the first seed of 44-63 that fought a wrong answer),
aim_wire GREEN (southpaw liver on the right). block_meet -> Qwen LANDREACH3 (the latched hit point is on the face within
1 cm; the drawn lead glove sits 4-11 cm above/below it on the contact frame). guard_knee -> GUARDKNEE2 queued (bisect).
plan_bots: known cause (the test's GOOD plan uses steps Lucy has not drilled; since S463/S464 steps fire by their bar).
move_tip: known cause (the move card's partner never dodges/blocks; goes with the block pose work).

## Design loop
Fight week v8 passes 6/6 on two critics (John 7/6/6 SQ96 + Dola 8/8). TURNPRO1 v2 Maria 7/6/6; Dola SQ113 pending.
