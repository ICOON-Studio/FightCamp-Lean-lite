# TASK C226 - ST1: stamina drives the moves and the decisions (Codex, S133)

Model: gpt-6-luna, reasoning effort MEDIUM (operator rule 2026-09-25: luna low/medium is the default; this is engine
code, not 3D animation). Worktree `D:/FightCamp/wt/C226`, branch `codex/c226-st1-stamina`.

## Why (operator 2026-09-30, verbatim)
"you need to make the stamina have impact on the moves and decision making, this will explain why the 70% exists, you
just need to tune it right". Real boxers spend ~75-85% of a round at low intensity. Today our tired man never CHOOSES
to rest and resting earns him nothing inside a round.

## What exists today (read these windows, never whole big files)
- `Godot/scripts/FightStamina.gd` (125 lines): per-tick movement drain by intent (hold 0.016/s .. close 0.080/s),
  per-strike drain, per-impact drain, `rest_recovery` ONLY between rounds (`_REST_FRACTION_PER_MIN` 0.32).
- `Godot/scripts/FatigueCurve.gd` (72 lines): fatigue lowers output (floor 0.45), technique, power, defence.
- `Godot/scripts/FightIntent.gd` (216 lines): `decide()` (line 127); stamina only moves part of CLOSE weight to
  hold/circle (lines ~196-201).
- `Godot/scripts/FightRealtime.gd` (7441 lines - NEVER read whole; `sed -n` windows): `Stamina` preload line 44;
  between-round rest 2367-2400; movement drain 4119; strike/impact drain 5132-5133; `DEMO_SWITCHES` line 1080 and
  `as_game()` 1085 (game switches: `--script` runs keep them OFF - the tests are the control arm).

## Research you must use (research/)
- `D65_IN_ROUND_RECOVERY_RAW.txt` lines 171-260 (Dola, 2026-09-30, RAW capture - cite it as raw): DECISIONS table.
  DOCUMENTED: PCr fast half-time ~21-22 s (Harris 1992); inside-round bursts 1.2 +-0.8 s, pauses 2.3 +-1.8 s,
  low-intensity 75-85% of a round (time-motion 2017, PLOS One 2017); tired boxers clinch more, guard/evasion fall,
  cross/hook force -4..10%. SECONDARY only: output -15..20% after R5-6; power share ~40% -> 25-30% late. NO STUDY:
  the reset after a big exchange.
- `S131_DIGEST.md` section 8 (the ST1 design note), `G100` / `D22` time-motion, `G99` CompuBox (45-56 thrown per
  3-min round, jab 40-44%). Run `python Tools/prior_research.py stamina fatigue recovery pace` first and read what it
  names.

## What would a human do?
A sports-sim designer: model a fast in-round recovery that only pays while the man is NOT working (hold / guard /
clinch / out of range), give the decision a reason to take it (a tired man's intent weights move toward resting and
his shot choice toward jabs/singles), then tune ONE rate against the published pace and output bands, census
before/after, and leave every other constant alone.

## Prefab check
None applies - this is our own engine. No new dependencies.

## The change (all behind ONE new engine switch `in_round_recovery`, added to `DEMO_SWITCHES`; OFF = byte-identical)
1. In-round recovery: while a man's intent is hold (and while clinched, if the state exposes it) and no strike of his is
   in flight, his stamina recovers toward his round-start level at a rate derived from the ~22 s PCr fast half-time,
   scaled by conditioning like `_recover_scale`. Never above the tank he started the round with (no free refill).
2. Rest-seeking: in `FightIntent.decide`, when stamina is low the HOLD / CIRCLE-away weight rises (not only CLOSE
   falling) - a bias, never a ban.
3. Lighter shots when tired: the technique pick favours the jab / single shots as fatigue rises (the jab share may
   rise; the power-shot share falls), using the existing selection weights - no new catalogue.
Label every new constant AUTHORED or DERIVED (from which D65 row) in a comment, like the file already does.

## Owned files (edit ONLY these; anything else = send-back)
- `Godot/scripts/FightStamina.gd`, `Godot/scripts/FightIntent.gd`, `Godot/scripts/FatigueCurve.gd` (if needed)
- `Godot/scripts/FightRealtime.gd` - ONLY: the `DEMO_SWITCHES` line, the options read for the new switch, the
  movement-tick stamina line (~4119), the technique selection-weights block (~4405-4420), and `_run_decision`
  (:3507, the `Intent.decide(` call at :3557) so FightIntent can receive the switch and the recovery state. Nothing
  else. (S133 send-back 1: this window was missing - Codex was right to stop.)
- NEW: `Godot/tests/fight_in_round_recovery_test.gd`, `Godot/tools/c226_stamina_census.gd`,
  `research/C226_DIGEST.md`.

## Parse gate (before any test)
`python Godot/tools/check_scripts.py Godot/scripts/FightStamina.gd Godot/scripts/FightIntent.gd Godot/scripts/FightRealtime.gd`

## Measure (the census - before your first edit AND after)
Write `tools/c226_stamina_census.gd`: 20 seeded boxing bouts (3 x 3 min), switch OFF vs ON on the SAME seeds, with
LEGAL, DIFFERENT fighters (never two identical fighters - different stats, styles, plans; print the population in the
output). Print per round: thrown per man, jab share, power share, stamina at the bell of each round, share of round
time each man spends in hold, finish rate (KO+TKO) and decision rate.
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/c226_stamina_census.gd`

## Tests (tier: scripts edited) - at the end
`python Godot/tools/run_tests.py --jobs 2 --only fight_stamina,fatigue_curve,fight_intent,boxing_output,fight_pace_anchor,fight_realtime,fight_in_round_recovery`
(never serial; wait on the runner's exit). Plus your new test: switch ON a tired man at hold regains stamina inside a
round, never above his round-start tank; switch OFF is byte-identical to master on one seed (the determinism tripwire).

## Acceptance
1. Census ON: thrown per man per 3-min round inside 45-56 (G99) on the pooled population; low-intensity (hold) share
   of round time rises toward the 75-85% band, reported beside OFF; late-round power share lower than round 1.
2. Finish rate (KO+TKO) with the switch ON stays inside the band the existing tests hold (`fight_pace_anchor_test`,
   `boxing_output_test` green) - report before/after.
3. Switch OFF: every listed test green; the tripwire proves byte-identical.
4. Branch pushed; explicit `git add` by path (never `git add .`, never `Godot/.godot`); 15-line `C226_DIGEST.md` with
   the census table before/after and every new constant with its label.

## The one trap
A tired man who recovers too fast never gets tired, and one who recovers while THROWING breaks the 70%: recovery only
while not working, capped at the round-start tank. Tune ONE rate; if a band will not hold, report the numbers - never
loosen a test's band to pass.
