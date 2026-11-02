# U159 — reactions play whole on the blow

Population: **MMA seed 92012**, S65 pair **grappler 175 cm vs striker 185 cm** (`height_a_m` / `height_b_m` in probe).

## Part 1 — before (`reactions_play_whole` OFF, 60 s presentation)

Probe: `tools/u159_reaction_probe.gd` — 16 landed blows matched to receiver `react_*` takes.

| Metric | OFF |
| --- | --- |
| Blow → visible reaction (median / p90) | **33 ms / 33 ms** |
| Queue **cut** before recovery | **75.0%** |

Reactions entered at **t=0** of the grafted take (seek 0); presentation queue **cut** most reactions to the readable peak.

## Part 2 — playback fix (no clip edits)

Room switch **`reactions_play_whole`** (default **OFF**), wired in `FightWorldLiveScreen.configure()`.

When ON, `FightStagePlayer`:

- Enters hit reactions at **first keyed motion** (`FIRST_KEYED_MOVE_M` = 1 cm, cached per take).
- **`react_lead_for` → 0** so onset is priced on the impact tick.
- Forces **tempo 1.0** on hit reactions.
- Prices the queue for the **remaining** clip length so decisions stay **play**, not **cut**, unless the man is hit again.

## Part 3 — after (same seed, 60 s)

| Metric | OFF | ON |
| --- | --- | --- |
| Blow → visible reaction (median / p90) | 33 ms / 33 ms | 33 ms / 33 ms |
| Queue **cut** before recovery | 75.0% | **18.8%** |

A/B video: `research/_captures/watch_loop/u159_reactions_ab.mp4` — **10 s** hstack (OFF | ON), seed 92012 MMA, 1280×720, **17.3 MB** (`record_room.gd` + `reactions_play_whole=0|1`).

## Gates

- Parse: `FightStagePlayer.gd`, `FightWorldLiveScreen.gd`, probe, test — clean.
- `tests/fight_reaction_whole_test.gd` — pass (mutant: tiny budget must not CUT when ON).
- Focused suite `--only fight_stage,fight_world,fight_room,paired_stage,fight_body_layers,fight_reaction`: **SUITE total=23 fails=1** (`fight_stage_realism_test`, within ceiling).
