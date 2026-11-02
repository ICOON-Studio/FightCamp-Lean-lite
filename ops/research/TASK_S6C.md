# TASK_S6C — the ground strike gets a path, and a film stops shrinking the man

**Owner:** Claude (lead). **Model:** Opus, HIGH effort, Fast OFF.
**Stage B of the 2026-09-18 greenlight** ("go for A then B"). Stage A was S10.

## The two things, and they are one session because they meet in one file

### 1. A GROUND STRIKE HAD NOWHERE TO ROUTE

`mma_guard_gnp` ("Posture and Ground-and-Pound from Guard", `phases:
[ground_top]`, damage, head and body) is scored by the IMPACT subsystem, so it
arrives as an ordinary action beat and is resolved by
`FightStagePlayer._thrower_clip` (`:994`) — which can only ever offer a
single-body STRIKE role. No standing clip exists for a man punching from mount
and none can, so every one of those beats came back empty: the man held his
guard, on his feet, while the engine said he was hitting someone on the canvas.

S9 sized it at **4.65% of ALL action beats** — rank 1 of the whole degrade
queue — and `mma_dirty_boxing` (`cage_clinch`) adds 1.93%.
`FightClipBinding.gd`'s own note had already written the answer down and
called it a stage: *"They are the best ground-and-pound films in the pack and
they are unusable until the strike side can mount a paired clip; that is a
stage, not a table edit."*

### 2. A PAIRED FILM DROPPED THE PHYSIQUE SCALE

`PairedStagePlayer.graft_pair` assigned `_body_a.transform` WHOLESALE, and the
room builds that origin through `PairedClipMount.shared_origin(...)` ->
`Basis(Vector3.UP, yaw)`, which is orthonormal by construction. So the
`FighterPhysique` scale `FightWorldStage.mount` applied was gone the moment a
film was grafted — and `_release_grapple` hands the post-graft basis back, so
the man stayed the wrong size for the rest of the bout. S6b's first ten contact
sheets are what that looks like: every body buried to the neck.

## Owned files

- `Godot/scripts/PairedStagePlayer.gd` (`bind`, `graft_pair`, `remount`, new `_place`)
- `Godot/scripts/PairedClipMount.gd` (read only — `shared_origin`, `place`)
- `Godot/scripts/FightClipBinding.gd` (`PAIRED_STRIKE_BINDINGS` and its two accessors)
- `Godot/scripts/FightLiveSchedule.gd` (`add_ground_strike`)
- `Godot/scripts/FightWorldLiveScreen.gd` (`_pump_to` routing, `_present_grapple_pair`, `_grapple_refused`)
- `Godot/tests/paired_stage_player_test.gd`, `Godot/tests/fight_grapple_seam_test.gd`
- `Godot/tools/audit_unbound_contact_sheets.gd`, `Godot/tools/measure_presentation_split.gd`
- `research/S6C_GROUND_STRIKES.md` (new), `research/S6C_SHEETS/` (new)

## Rules this task is bound by

- **WATCH THE FILM BEFORE BINDING IT.** A name is not content (R127, and S6b
  found four mislabelled clips in a minute by looking). Render the candidate,
  look at the sheet, then bind.
- **A wrong position is worse than no clip** (`grapple_stall`'s ruling): no
  film in the pack is two men on their FEET, so a `cage_clinch` id gets none.
- **A routed beat may never vanish.** S9's SILENT state must stay 0: a refused
  ground strike falls back to the ordinary action entries.
- Print a quantity a broken run cannot fake beside every contact sheet, and
  LOOK at the sheet before believing the log (S6b's own rule).

## Gate

```
python Godot/tools/check_scripts.py <touched .gd>
python Godot/tools/run_tests.py --only clip,stage,pair,grapple --jobs 3 --timeout 900
python Godot/tools/run_tests.py --jobs 3 --timeout 2400        # FULL, ONCE, at the end
```
**THREE JOBS, NOT FOUR, AND 2400 NOT 1200** (`nproc` is 4 here; four jobs leave
nothing for the OS and manufacture a phantom seventh failure). Ceiling
**fails=6 or better**, and the failing FILENAMES must match
`AgentComms/last_suite.json` name for name.

Re-run `tools/measure_presentation_split.gd` and quote the ground split beside
the old one (85.4% paired / 14.6% degraded).
