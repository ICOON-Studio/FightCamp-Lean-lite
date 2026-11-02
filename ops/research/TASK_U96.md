# TASK U96 — CURSOR — THE SAME BOUTS AT REAL DISTANCE: OVERLAP, PUNCH REACH AND RING DISTANCE, BEFORE ANY FIX

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u96-real-spacing` - Claude creates it from `master`
before launch. Push the BRANCH. Stage: S4a (the operator's "bodies overlap" and "punches look fake") - the measurement
the next build starts from.

**Test tier: A SCRIPT EDITED.** Parse gate on every touched `.gd`, then `python Godot/tools/run_tests.py --only
fight_world --jobs 2` (the room's own tests), then the two tool runs below. No full suite.
`python research/U96_check.py` must exit 0 before you commit. ONE Godot at a time in your worktree.

## Owned files

- `Godot/scripts/FightWorldLiveScreen.gd` - ONE measurement knob only: `configure` reads an optional `range_m`
  Dictionary (`{"POCKET": m, "MID": m, "LONG": m}`) that replaces `RANGE_M`'s values for this room; with no `range_m`
  the room behaves byte-for-byte as now. Nothing else in this file changes.
- `Godot/tools/measure_body_overlap.gd` (your U95 tool) - a user arg `range=<pocket>,<mid>,<long>` passed as
  `options["range_m"]`; `population=realism` to run only that population and skip the sweep; three NEW class pairs
  `hand=hand`, `arm>hand`, `arm=hand` checked before `other`; an `out=<res path>` arg for the JSON.
- `Godot/tools/measure_contact_miss.gd` (Qwen's Q97 tool) - the same `range=` and `out=` args. Nothing else.
- `research/U96_real_spacing.json`, `research/U96_REAL_SPACING.md` - NEW, 30 lines at most.

## Why this exists

U95 measured the bodies overlapping on 88% of frames, the two guards' gloves and forearms, because the room holds the
men 0.80 / 0.95 / 1.10 m apart where elite boxers stand 1.23 +- 0.16 m (Schortgen ECSS 2023, `research/K50_SPACING_AND_REACH.md`),
and its static sweep found nothing touching past 1.20 m. Moving the men apart is the obvious fix - and it will make
the in-place punches fall short (Q97: at today's distance straights only just reach). The next build pairs the new
distance with a strike warp; it needs, per punch, how far the fist falls short at the real distance.

## The two band sets

- `room` = POCKET 0.80, MID 0.95, LONG 1.10 (today's `RANGE_M`).
- `real` = POCKET 1.07, MID 1.23, LONG 1.39 (K50's DOCUMENTED mean 1.23 m, one SD either side; which word gets which
  number is INFERENCE and is labelled so).

## What to run and record

For EACH band set, on the realism test's seeds and rounds (both tools already use them):
1. `measure_body_overlap.gd -- population=realism range=... out=...`: per seed `frames`, `overlap_frames`,
   `overlap_share`, `depth_p50_m`, `depth_p95_m`, `depth_max_m`, `by_class` (now naming `hand=hand`, `arm>hand`,
   `arm=hand`), `gap` p5/p50/p95.
2. `measure_contact_miss.gd -- range=... out=...`: its `summary` per role (`n`, `hand_to_target_m`, `forward_m`,
   `lateral_m`, `vertical_m`, `closest_m`, each p10/p50/p90).

`U96_real_spacing.json`:
`{"population": {"seeds": [94301, 51227, 77003], "rounds": 3, "fighters": "f01_m_box_welter v f09_m_bare_welter",
   "bands": {"room": {"POCKET": 0.80, "MID": 0.95, "LONG": 1.10}, "real": {"POCKET": 1.07, "MID": 1.23, "LONG": 1.39}},
   "bands_source": "K50: Schortgen ECSS 2023 mean 1.23 +- 0.16 m; the word-to-band mapping INFERENCE"},
  "overlap": {"room": [ {seed row as U95's bouts}, ... ], "real": [ ... ]},
  "contact": {"room": {role: {...Q97 summary...}}, "real": {role: {...}}},
  "reach_short_m": {"real": {role: {"forward_p50": 0.0, "forward_p90": 0.0}}}}`
where `reach_short_m.real[role]` is copied from `contact.real[role].forward_m` p50 and p90 (how far forward the fist
still has to go at the real distance).

## The digest `U96_REAL_SPACING.md`

Opens with `## DECISIONS`: a table - band set -> overlap share, depth p95, gap p50, and for jab / cross / hook_lead /
hook_rear the forward miss p50 and the closest approach p50. Then one line each: how much of the overlap the real
distance removes; how far each punch falls short there, against K50's ~0.28 m of hip travel in a real straight.

## Commit

`git status -s` first. Commit ONLY the owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u96-real-spacing`;
`python Tools/agent_comms.py send --from cursor --to claude --topic U96-ready --body <hash>`. Do not edit HANDOFF.md
or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`, `clean`, `rebase` or `merge`.

## The trap

The `room` runs must reproduce the earlier instruments, and the check pins them: U95's realism rows
(`research/U95_body_overlap.json`, the same code) and Q97's per-role contact counts and medians
(`research/Q97_contact_miss.json`). If `room` does not reproduce, the knob changed the room - fix that before
reading anything off `real`. And a band change the room ignores still produces a table: at `real` the gap p50 must
actually sit near 1.23 m.
