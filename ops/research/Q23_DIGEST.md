# Q23 DIGEST — FightHudRead carries the seat

## What landed

`FightHudRead.fold(state)` gains one key, `"grapple"`, mirroring
`FightRealtime.grapple_of(state)` without preloads. The fold extracts four
locals (`g`, `grapple_stance`, `grapple_sub_open`, `grapple_top_idx`) and
builds the grapple dict inline in the return value.

## Contract

| Key | Source | Notes |
| --- | --- | --- |
| `grappling` | `state.get("grappling", false)` | Top-level flag, not inside `g` |
| `stance` | `g.get("stance", "standing")` | |
| `seat` | `g.get("seat", "none")` | |
| `top` | index→side: 0="a", 1="b", else="" | The trap: index on engine, side on read |
| `submission_open` | `g.get("sub_open", false)` | |
| `submission_progress` | `g.get("sub_progress", 0)` | |
| `stall_stage` | `g.get("stall_stage", 0)` | |
| `stall_ticks` | 0 on feet or sub open, else `tick - stall_since` | Amber lies if sub_open is ignored |

No-`grapple`-key fixture folds to `grappling false, standing, none, "", false, 0, 0, 0`.

## Tests added (sections 16–20)

- **16**: Hand-built ground grapple, all 8 keys, top=0→"a", stall_ticks=0 while sub_open
- **17**: top=1→"b", stall_ticks = tick - stall_since on the ground with no sub
- **18**: top=-1→"", standing stall_ticks is 0
- **19**: No grapple key at all (older fixture) → all defaults
- **20**: Live bout (seed 92001, 3 rounds) — grappler vs fish, tick-by-tick
  assertion that `fold(state)["grapple"] == FightRealtime.grapple_of(state)`
  on every key at every tick; asserts ground was seen and an open sub was seen

## Verification

- Parse gate: `CHECK total=2 fails=0`
- Focused test: `FIGHT_HUD_READ_TEST PASS (76927 checks)`
- Full suite: zero failures across all logs

## Files touched

| File | Change |
| --- | --- |
| `Godot/scripts/FightHudRead.gd` | +15 lines (grapple locals + dict in fold return) |
| `Godot/tests/fight_hud_read_test.gd` | +134 lines (sections 16–20) |
