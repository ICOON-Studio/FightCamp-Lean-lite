# TASK REFEREE1B - "Tonight's referee" shown before the fight (UI half, only when the bout runs `ludo_referee`)

Model: cloud Cursor (issue label `cursor`). Branch: the workflow names it. Never master, never HANDOFF.md, never AgentComms/.
Operator S188 ("yes all picks", REFEREE1): "Referee personalities (fast stopper / lets it go / hometown lean), shown before the fight".
The engine half is merged (REFEREE1A, 83fe52b6): `FightRealtime.begin` picks `state["referee"]` from `options.referee_id` or the bout
seed via `FightRealtime._referee_profile(seed, referee_id)` when `options.ludo_referee` is true (boxing only).

## Owned files
- `Godot/scripts/FightRealtime.gd` - ONE change only: add a public `static func referee_for(seed_value: int, referee_id: String = "")
  -> Dictionary` that returns `_referee_profile(seed_value, referee_id)` (so the UI shows exactly the referee the engine will use).
- `Godot/scripts/FightNightIntro.gd` (355 lines): a referee plate in the intro beats (`_run(beats)` ~98, helpers `_plate` ~187,
  `_text` ~165, `_brass` ~174). Shown only when the bout spec's engine options carry `ludo_referee: true`.
- `Godot/tests/referee_intro_test.gd` (NEW).

## Prior research
- Data: `Godot/assets/data/referee_styles.json` (each profile: name, clinch_break_time_seconds, stoppage_doctor_odds_multiplier,
  home_bias_ratio, ...). Design: `research/LUDO_ROUND17_S193.md` (referee section).
- UI rules: icons over text with tooltips via `UIKit.tip(...)` (never tooltip_text); plain words, no numbers on the plate itself; the
  numbers live in the tips. Nothing overlaps at 1920x1080 and 1280x720.
- How the intro gets its bout: `FightNightIntro.play(bout_spec)` (~52); the bout's seed is in `bout_spec.engine_options.seed` or the
  options FightNightScreen builds (~435 / ~502).

## What would a human do?
On fight night the announcer names the referee; the player sees one line about his habits - "Breaks clinches fast, stops cuts early" -
because that changes how you corner the fight.

## Spec
1. Plate: "REFEREE  <name>" + two icons with words: clinch (fast / normal / lets them work) and cuts (stops early / normal / lets it go),
   words derived from the profile numbers vs the neutral (clinch 2.5 s, odds x1.0) - thresholds named as consts; a home-lean icon only when
   home_bias_ratio > 0 and the bout carries home flags. UIKit.tip on each icon with the real number ("Breaks a clinch after ~1.8 s").
2. Only with `ludo_referee`; without it the intro is byte-identical (no node added).
3. `referee_for` returns exactly what `begin` puts in `state["referee"]` for the same seed/id.

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate on every touched .gd.
- `referee_intro_test.gd`: for 4 seeds, `referee_for(seed)` == `begin(...)["referee"]` (two DIFFERENT boxers; name them); the intro with
  ludo_referee shows the plate with the right name and the words for HAIR_TRIGGER vs LET_EM_FIGHT differ; tips carry the numbers; no
  overlap at both resolutions; without the switch no plate node. RED first on master (paste the count), then green.
- `python Godot/tools/run_tests.py --only fight_night --jobs 2` and `--only referee --jobs 2` -> 0 fails.
Final message: red count, green results.

## The one trap
The intro can play before the engine state exists - never construct a fight to read the referee; call `referee_for(seed, id)` with the
SAME seed the bout will use, or the plate names a different referee than the one in the ring.
