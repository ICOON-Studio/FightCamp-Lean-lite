# C230 — personality and rivalry heat in FightRealtime

## Delivered

- `FightIntent.gd:25-41` adds authored, bounded intent multipliers for all eight career personalities. Fearless biases pressing and away from retreat; Reserved biases holding range; Analytical and Showman lean toward their matching choices. Other labels have small or neutral role weights, with no stat changes.
- `FightRealtime.gd:43,1085,1493-1495,1731-1732` imports Rivalries, enables `identity_in_fight` for the game demo, and carries each fighter's personality and clamped booked heat. Script/tests keep the switch OFF unless explicitly requested.
- `FightRealtime.gd:3578-3608,4170-4174,4649-4652,5200,5298-5299` applies personality and heat to intent, the Rivalries attack bonus on damage/counter/setup roles, the Rivalries stamina scale to movement and strike drain, and the Rivalries hurt penalty to the flash-recovery threshold. All are gated by the same switch and add no RNG draws.
- `FightRealtime.gd:1495,3589-3595` records per-side intent choice counts while enabled for the census.
- `FightWorldLiveScreen.gd:5188` appends an intent/personality caption to the actor's existing `why` line while the switch is active.
- Added `tests/fight_identity_test.gd` and `tools/c230_identity_census.gd`.

## Evidence

The final `check_scripts.py` command covered all five touched scripts. Four parsed; `FightWorldLiveScreen.gd` was rejected because the checkout's missing generated global class cache leaves existing `FightClipBinding`, `PairedClipMount`, `Quantise`, and `FightBeatAdapter` names unresolved. No syntax error was reported for the new caption expression. The engine also reports missing `.godot/imported` font/audio files and a certificate store failure.

Focused `fight_identity_test.gd` passed, 6 checks, after the intent weights and rivalry cost were wired:

- Fearless vs Reserved pressing share: 28.4% vs 27.9% in the six-seed test sample.
- Heat 100 vs heat 0: 1,537 vs 1,407 actions; finish stamina 80.4 vs 83.0.
- OFF event log replay was byte-identical across repeat runs.

The 120-bout-per-arm census completed with 120 OFF and 120 ON bouts. OFF: KO/TKO 17/120 (14.2%), 41.4 thrown per man-round, 25.4% connect. ON: KO/TKO 18/120 (15.0%), 41.0 thrown per man-round, 26.9% connect, 30.0% press share and 81.2 average finish stamina. The strict task targets are not met for stoppage rate, thrown rate, or connect rate in this sample; the identity effects themselves moved in the requested directions. These bands were not loosened.

The requested `run_tests.py --jobs 2 --only fight_identity,fight_realtime,boxing_output,fight_pace,fight_intent,rival` run ended `SUITE total=6 fails=6`: four were classified as engine/import errors from missing `.godot/imported` fonts; `fight_realtime_test.gd` returned rc=1; `boxing_output_test.gd` was also classified as an import error. The direct focused test completed with 6/6 assertions passing, though Godot emitted the same unrelated startup errors. The watchdog reports `C_free=0GB` and cannot query WMI system metrics in this environment.

## Outstanding release gates

- Re-run the parse and tiered gates in an environment with the generated global/import cache and readable certificate store, and resolve any genuine test failures.
- The 120-bout census bands remain red for this chosen matchup. C230 did not alter global boxing output/damage tuning to hide that result.
- No stills were generated or opened; the checkout's current Godot startup fails its imported font/audio dependencies before a reliable live presentation can be captured.

Commit `d95fe46` was pushed to `origin/codex/c230-identity-in-fight`. The strict census, parse cache, test-suite and still-review gates above remain unresolved.

## S138 (Claude) - merged and fixed on master
- Merged as a diff (HANDOFF.md edit dropped). Personality read ~0 (Fearless press 28.4% vs Reserved 27.9%) for two
  reasons: (1) the bias multiplied the weights BEFORE `in_round_recovery`'s rest term (~7 on hold at 80% stamina against
  a ~0.7 close); (2) the intent tally SELF-CORRECTS - a man who closes less spends more ticks out of range, where close
  wins - so a choice share cannot show a style. Fix: `FightIntent.decide(..., identity_bias)` applies personality + heat
  to the FINAL weights; personality also settles the standoff once (`FightIntent.PERSONALITY_RANGE`, Fearless 0.94x,
  Reserved 1.06x - inside the plan range slider's 0.92..1.08); heat adds volume (`heat_volume`, full heat = the plan pace
  slider's top, +12%) because extra stamina drain alone made a grudge throw LESS under in-round recovery.
- `tests/fight_identity_test.gd` now runs the game's DEMO_SWITCHES and reads what a viewer sees, 9/0: mean gap Fearless
  1.073 m vs Reserved 1.168 m; in punching range 91.2% vs 88.1%; control OFF = same fight for both labels; heat 100 vs 0
  thrown 1761 vs 1640 (+7.4%), bell stamina 86.9 vs 88.5. Focused: fight_strike_whole (OFF byte-identical) green.
- OPEN: the 120-bout census on the q212 booked population with as_game (C230's 17/120 KO+TKO on both arms was its
  population, not the switch).
- S138 later: the census read ON = OFF to the decimal - because NO generated fighter had a personality (starter roster and
  every offer opponent read the neutral "Disciplined"; probe: roster 3/3, opponents 6/6), and the fight read the raw
  field while the career screens map flavour labels through CareerGoals.personality_of. Fixed: FightRealtime uses
  personality_of; FightOpponentGenerator.personality_for(key) stamps one of the eight labels (deterministic, drawn
  outside the stat rng) on every offer opponent and on the starter roster (finalize_new_career). Q212 booked census,
  120 bouts per arm, its own save folder per arm (two arms on one folder failed to publish the career):
  ON KO+TKO 43.3% / dec 55.8% / KD 27.5% vs OFF 46.7% / 52.5% / 25.8% - both inside the 40-55 band; OFF unchanged.
