# TECHSTAGE1 - technique mastery reaches the boxing engine

Branch: `codex/techstage1`. Validation in progress; this is an engine slice, with no windowed player-flow claim.

`TechniqueStage` derives LEARNED / DRILLED / SPARRING-PROVEN / SIGNATURE from reps, sparring rounds and fight lands at the approved
DESIGN gates (1,800 / 25 / 30). Saved stage records are authoritative. Legacy learning reps and live rounds, mapped move-card
minutes at three reps/minute, and pad-routine mastery provide a read-only migration view. Pad mastery contributes up to 1,800
DESIGN reps per affected move, taking the strongest applicable routine rather than summing overlapping routines. Training then
persists the separate mastery ledger without capping reps at the old learning threshold or changing `technique_progress` behavior.
Already-learned sessions still return their original result, but valid sessions add mastery reps and live rounds.

The boxing-only `technique_stages` switch builds the 25 certified per-move modifier entries once. The existing strike weighted
walk, contact thresholds, commitment/recovery clocks, wear and strike-drain paths consume them. Guard selection, tired availability,
guard recovery and answering accuracy also consume the record. Counter openings and pad safety windows use the per-move window
ratio. No RNG stream or draw was added. OFF leaves the stage state/table and action metadata absent. Action metadata ON records
actual per-technique strike stamina spent and the speed multiplier so the measurement observes the charged cost.

## Validation

- Parse: seven owned GDScripts pass; the pre-existing AthleteDevelopment CompetitionData autoload warning remains.
- Pure arithmetic, migration, copy isolation, session accumulation and all certified mappings: 63 checks, zero failures.
- Initial 200-bout/arm measurement before the guard hooks: stage 1 394 lands / 1,433 throws / 101.656 stamina;
  stage 4 520 lands / 1,519 throws / 80.426 stamina. Land uplift +31.98%; OFF control identical across 200 seeds.
- Final focused suite, final 200-bout measurement, baseline control and mutation evidence: pending.

## Scope and rules

The toolkit's windowless Godot executable overrides the generic console-executable instruction. Watchdog AMBER selects `--jobs 1`
under the task's explicit override of CLAUDE.md's usual parallel runner rule. Godot installation and shared Git metadata require
elevated tool execution in this sandbox. AthleteDevelopment edits stay in the original lines 340-380; the requested expansion was
made unnecessary by writing mastery inside the existing early-return body. No GameState edits, training-gate changes, HUD changes
or post-bout fight-land writeback; the verdict assigns writeback to FIGHTLOG1 and the display to DEBRIEF1. Runtime timing here is
commitment and whole-strike recovery; visible clip playback has not been verified by this headless slice.
