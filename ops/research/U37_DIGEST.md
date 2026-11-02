# U37 DIGEST — the corner instruction that does nothing

## Option taken

**Option 1** — adapter / screen, no `FightRealtime` entry point.

`FightBeatAdapter` now owns `get_available_corner_instructions` and
`apply_corner_instruction`. The apply writes a modifier onto the fighter's
`preferred_range` (base cached as `preferred_range_base`). `FightIntent.decide`
already reads that field on every decision tick, so the call changes how the
**next** round is fought without touching `FightRealtime.gd`.

Option 2 was unnecessary: the engine already exposes a plan axis that future
ticks read. Option 3 (honest refusal) was not needed once apply worked.

## Future ticks only

**Yes.** Past impacts and past cards are untouched. Only subsequent
`_run_decision` calls see the new range. Rest-window only (G44); standing
dock stays empty on the real-time path.

## Honest omission

"Work the body" is not offered. `_pick_target` does not read the fighter;
biasing regions from the adapter would invent facts about who got hit.

## Gate

- Parse: `FightNightScreen.gd` + `FightBeatAdapter.gd` — 2/0
- `smoke_test.gd` — failures=0 (corner pause/apply/resume OK)
- `--only fight` — 35/0
- `--only ring` — 6/0
- Branch: **master**
