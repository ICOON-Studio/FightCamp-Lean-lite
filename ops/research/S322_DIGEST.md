# S322 digest - the body is the track, part 1: Burn in the rules and in the 3D (Lean update 25, 2026-10-31)

Working commit: Lean de915d0 (pushed). Update 25 exported from 1685692 (38/38 tests); BodyRates (de915d0) lands in the
next build. Game repo: briefs, plan, board.

## Operator input (board, verbatim)
- Q-S294-38 (core mechanic "the body is the track"): "Build it".
- Q-S294-36 (corner ice / cuts): "Change it (say what)" - "the cut should be handled by the cutman , nothing to do for the
  player here." -> written into BODY_TRACK_PLAN_S321.md "S322 operator rulings": the cutman works cuts and swellings by
  himself, the second works the most burning part by default, the player only gives the coach's instructions.
- Asked: Q-S294-40 (what "Pages need work" means; round + result stills attached). Open: Q-S294-39 (update 24 close punches).

## What shipped
1. BodyLoad (Qwen BODYLOAD1, Lean scripts/rules/BodyLoad.gd + tests/body_load_test.gd): per-part Burn (lead/rear shoulder,
   lead/rear arm, core, legs) from the beats; pace, tank, training rates; the minute's rest (55 % back x conditioning, hurt
   ribs 0.7x, the second's 12 off one part); effects. Qwen widened the brief's calibration bounds (reported honestly);
   Claude restored them and tuned the numbers.
2. BodyBurn (scripts/fight3d/BodyBurn.gd): fed one exchange at a time as FightView queues it, eased ACROSS the exchange
   (the beats are queued 30 s ahead of their punches), rest at the bell. Each shoulder drops ITS OWN glove (GuardTuck.tired
   per hand: the jab hand works most and sinks first), legs shorten steps (Footwork vel x legs), each arm's Burn takes snap
   off its own punches (HitImpact). `-- noburn` = control arm.
3. BodyRates (Qwen BODYRATES1, as written): conditioning / technique / speed / power and style set each part's rate; fed
   per exchange from the round profiles' stats + _ctx styles. The gym's training now shows on the fight body.
4. FightStage.gd split 500 -> 342 lines: RingPlace.gd (positions/facing) + HitImpact.gd (hit, hit-stop, recovery cut).
   Behaviour-neutral: hit_gap_probe on master vs split, same 26 landed / 9 cut; far share 8 % / 12 % / 4 % across 3 runs
   = run-to-run jitter (glove miss sizes move by a few cm between identical runs).
5. The double jab: AnimationPlayer.play() on the clip already playing CONTINUES it - a jab right after a jab started at
   0.30 s and passed contact 0.3 s before its hit (the "step-in jab 0.26 s late, speed 1.67" - 1.67 was the recovery
   speed-up, not the clip speed). FightStage._start stops a playing clip of the same name first. Worst shown miss
   0.34 -> 0.20 m; "in" phase far 0.
6. Skipped rounds never rang the bell: BodyMap.end_round (corner relief) and the rest refill were skipped - skip_round now
   calls both.
7. Referee: ref_probe (new) - between the boxers 0.7 % of frames, ALL while parting a clinch; no side flips, never crosses
   their line. The S320 "drift" is not in this build. The burn still showed him pressed to a boxer's back when pinned by
   the ropes: KEEP_M 0.55 -> 0.8.

## Measurements (tools/burn_probe.gd, hidden desktop; round 1 at 0:12 vs round 3 at 2:00-2:30, glove under the face)
- First wiring: guard_drop read the MEAN of both shoulders (lead 41 / rear 17 at round 3) -> never past 50 -> +0.001 m.
  Legs 5 at round 3 (LEGS_PER_S 0.035 in my brief was 5x too low).
- Per-hand drop, EFFECT_FROM 40, legs 0.16: lead glove 0.018 -> 0.191 m (red), 0.026 -> 0.236 (blue); noburn +0.003.
  Shoulder at 0.70/punch still 0.18 m (beats vary per run; round 3's tired tank factor piles up): capped the look,
  TIRED_DROP lead 0.22 -> 0.14 m (shoulder / top-of-chest height). Exe check: see the end of this file.
- Still (Builds/burn_on/burn_round3.png): both boxers' rear glove at the face, jab hand at the chest - reads as tired.

## Decisions (Claude, developer)
- Each glove from its own shoulder (a mean of both never fires for a jabber; real tired boxers drop the jab hand first).
- Burn numbers tuned on the GAME's beats (burn_probe), not only on RoundScript test rounds - the game throws more lead-hand
  punches (habits, combos) than the test builder.

## Traps
- AnimationPlayer.play(name) on the playing animation does not restart it (any "same clip again" path).
- A probe comparison needs both sides measured: the split looked like a regression (12 %) until master gave 8 % and a
  re-run of the split 4 %.
- The board's "Test" runs skip rounds: anything that happens "at the bell" must also run in skip_round.

## Left / next
- The body view (plan step 3): both bodies outlined part by part, coloured by Burn (BodyLoad.band), Hurt outlines from
  BodyMap; stand-in = our glass body (preview_body_track.gd) until a muscle model is bought ("Not yet").
- Pace (Push / Steady / Save) and Aim (tap her body) - BodyLoad already takes pace; aim needs RoundScript/BodyMap.
- Two inside punches still end 0.15-0.20 m to the side (hit_gap_probe "inside far", left -0.15..-0.20).
- Re-bake the side-panel portraits (vest shards at the armpits).
- Q-S294-39 / Q-S294-40 answers.

## Exe check (update 25, burn_probe inside Builds/FightCamp.exe)
Round 1 0:12 -> round 3 2:30, lead glove under the face: red 0.018 -> 0.115 m, blue 0.027 -> 0.102 m. Still
previews/s322/update25_round3_tired_guard.png (review board, Q-S294-41). The same still shows the referee
standing BETWEEN their heads on screen (1.25 m behind the line, centred) - against Referee.gd's own "never between their
heads"; ref_probe only measures the ground line. Next: REFSCREEN1.
