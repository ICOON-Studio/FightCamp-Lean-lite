# TASK U182 - CURSOR - THE SPAR IS WATCHED IN THE GYM RING, NOT THE CHAMPIONSHIP ARENA (S87)
Owner: cursor. Assigned S87, 2026-09-26. Model: Composer, medium, `-p --force --trust`. Branch `cursor/u182-gym-ring`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-U171` (`git fetch origin && git checkout -B cursor/u182-gym-ring
origin/master`).

## Why
S87 shipped WATCH THE SPAR: the training floor's ring card opens the booked spar in the 3D fight view
(`FightWorldLive.tscn`), and the day tick settles the SAME spar - same seed, same fighter copies, same engine options,
proven byte-identical by `tests/spar_watch_test.gd`. But the room it plays in is the championship venue (UFC octagon for
MMA, a pro ring for boxing) with a crowd. A spar happens in the gym. U180/U181 (yours) bound the station clips on the
same floor, so you know it.

## What would a human do?
Two gym-mates spar in the gym's own ring: a club ring (smaller than a championship ring), bright gym lighting, bags and
mats around it, a few team-mates watching, no crowd, no walkout, no broadcast card (operator: gym art is bright and
alive, never dark and empty). The coach stands at the ropes.

## The work
1. `Godot/scripts/FightWorldLiveScreen.gd` (4,480 lines - NEVER open it whole; windows at `configure` (`rg -n "func
   configure"`), `_setup` arena build (`rg -n "Arena.build|_arena_half_m ="`), `engine_half_width_for`, `_spec_static`):
   a configure option `"arena_spec_id": String` that overrides the discipline route to a named spec in
   `assets/data/arena_specs.json` / `mat_specs.json` (e.g. `boxing_ring_fl_min`, `mma_cage_gym_6m`), and a `"gym": true`
   option that hides the crowd/venue shell and lights the room like a gym (bright, a few standing team-mates if a cheap
   crowd member exists; no new asset purchase).
2. `engine_half_width_for(discipline, spec_id := "")` MUST honour the same spec, so the off-screen settle and the watch
   fight on one canvas. Then ONE line in `Godot/scripts/GameState.gd` `spar_fight_setup` (`rg -n "engine_half_width_for"`,
   it is the only call): pass the gym spec id for the ruleset (a small `SPAR_ARENA_SPEC := {"boxing":
   "boxing_ring_fl_min", "mma": "mma_cage_gym_6m", ...}` dict beside it; pick the club-size spec for each ruleset the
   spec files carry, name any ruleset with no gym spec in the digest).
3. `Godot/scripts/FightNightScreen.gd` `_start_arena` (`rg -n "spar_plate"`): for a spar pass `arena_spec_id` and
   `gym: true`.
4. Render: `tools/s87_render_spar.gd` exists (Claude's) - copy it to `tools/u182_render_gym_spar.gd` and write
   `docs/previews/u182/arena_spar_gym.png` plus a short MP4 (`--write-movie`), windowed and hidden via
   `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/u182_render_gym_spar.gd`.
   OPEN the PNG and look at it before you report.

## Owned files
The four files above (GameState: the one call and its dict only), `Godot/tools/u182_render_gym_spar.gd`,
`previews/u182/`, `research/U182_DIGEST.md`.

## Tier
Scripts edited. Parse gate on every touched `.gd`, then `tests/spar_watch_test.gd` (it MUST stay 0 failures - its
`arena:` rows prove the 3D room's engine log equals the day tick's), then
`python Godot/tools/run_tests.py --only spar,fight_night,fight_world_live,training_floor,banned_2d --jobs 2`. No full
suite (nightly).

## Research
All research is open: root `RESEARCH_INDEX.md` (G113 gym floor dimensions, G118). Do NOT read HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit with paths on the commit line, push the branch, digest (the spec per ruleset, half-widths before/after, the
render), then `python Tools/agent_comms.py send --from cursor --to claude --topic U182 --body "<spar_watch 0 fails, specs, render path>"`.

## The trap
Changing the ring changes the engine's canvas. If the watched room and `engine_half_width_for` disagree by even a
centimetre, the spar the player watches is not the spar that settles - `spar_watch_test`'s byte-identical-log row is the
check. Change both together or neither.

## Also check (Claude, S87 render)
`docs/previews/s87/arena_spar.png` (boxing, Technical, ~8 s in): the man in red trunks has a KNEE RAISED in a boxing spar.
Find which clip or layer puts it there (a check-kick/knee clip leaking into a boxing palette, or the idle/step layer) and
fix it or name it in the digest with the clip id. A boxer never lifts a knee to his chest in a boxing ring.
