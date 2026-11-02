# TASK_S12 — the ground hold: two men stay on the canvas while the engine says they are

**Owner:** Claude (lead). **Model:** Opus, HIGH effort, Fast OFF.
**Greenlit 2026-09-18**, OPTION 3 off S6c's three ways on. Options 1 (the clip row)
and 2 (the clinch film) were NOT taken and stay on the board.

## The defect

The room has no ground POSE, only ground FILMS. `_release_grapple`
(`FightWorldLiveScreen.gd:1134`) calls `settle` on both players
(`:1151-1152`), and `settle` (`FightStagePlayer.gd:1146`) queues
`ROLE_IDLE` — the standing stance. So both men come back to their feet the
frame a film ends, while the engine still says `ground_top`/`ground_bottom`.

Before S6c that fired a handful of times a bout, on takedowns. S6c routed
`mma_guard_gnp` (4.65% of all action beats) down the same path, so it now
fires every time a ground strike plays. The picture is right for 1.167 s and
wrong afterwards, where it used to be wrong throughout — better, not right.

## The fix, and it needs no purchase

`Paired_FullMount_Takedown_BodyLock_Loop` is ALREADY bound as
`grapple_control` (`FightClipBinding.gd:816`, content 1.667 s) and S6b watched
it: "nothing advances, two men, mount held". That is exactly what a man should
be doing between ground strikes. It becomes the RESTING STATE.

### 1. The hold
On release, if the two men read a settled mount, re-enter `grapple_control`
instead of settling, and keep re-entering it while that holds.

**SETTLED MOUNT MEANS ONE MAN `ground_top` AND THE OTHER `ground_bottom`, AND
NOTHING ELSE.** `FightRange.GROUND_PHASES` also carries `scramble`,
`ground_entry`, `ground_cage`, `grounded_opponent` — this film shows a HELD
mount, and holding it through a scramble would be the M19 lie in a new place.
Those degrade exactly as they do today. Read the phase off the track sample the
room already keeps (`_shown["pa"]`/`["pb"]`, written at `:1358-1359`).

### 2. The side, which a persistent hold makes visible
`graft_pair` is POSITIONAL: `att_path` retargets onto `_skel_a`, `vic_path`
onto `_skel_b` (`PairedStagePlayer.gd:152-170`). So the grapple path puts body
A on top ALWAYS, whoever the engine says is on top. A 1.667 s film hid that; a
hold that lasts the whole ground sequence will not. Pass the two paths swapped
when B is the `ground_top` man. The registered names stay `_att`/`_vic` by
SIDE, so `_update_grapple`'s cut test (`:1109`) is unaffected — but
`_grapple_content` caches by `pair_key` alone and must carry the side, or a
flip replays the previous assignment.

### 3. A real beat preempts the hold
`_present_grapple_pair` refuses on `not _grapple.is_empty()` →
`already_playing` (`:990-992`), which is **86% of routed ground strikes today —
68 of 79**. A hold is not a beat and must not block one: release it and play
the real film. Count the preemption separately; do NOT let it inflate `played`.

## Owned files

- `Godot/scripts/FightWorldLiveScreen.gd` — `_present_grapple_pair` (:978),
  `_update_grapple` (:1101), `_release_grapple` (:1134), `_grapple_origin` (:1114).
- `Godot/scripts/PairedStagePlayer.gd` — only if the side swap needs it; prefer
  swapping the two arguments at the call site.
- `Godot/tests/fight_grapple_seam_test.gd` — the seam's own test.

## Contract

- `grapple_stats()` gains `hold_entered`, `hold_replayed`, `hold_preempted`.
  `played` keeps counting real beats ONLY.
- A hold never counts as a `cut` or a `completed` grapple.
- With `grapple_beats` off, nothing changes at all.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightWorldLiveScreen.gd Godot/scripts/PairedStagePlayer.gd
python Godot/tools/run_tests.py --only grapple --jobs 3 --timeout 900
python Godot/tools/run_tests.py --only clip --jobs 3 --timeout 900
python Godot/tools/run_tests.py --only stage --jobs 3 --timeout 900
python Godot/tools/run_tests.py --only pair --jobs 3 --timeout 900
python Godot/tools/run_tests.py --jobs 3 --timeout 2400
```
FULL SUITE ONCE, at the end. **fails=6 or better as a CEILING** — if it is
lower, say so and push. The failing FILENAMES must match
`AgentComms/last_suite.json` name for name: `athlete_development_test.gd`,
`fight_pair_live_test.gd`, `fight_ring_position_test.gd`,
`fight_scoring_test.gd`, `fight_stage_presenter_contract_test.gd`,
`fight_stage_realism_test.gd`. THREE JOBS, NOT FOUR — `nproc` is 4 here.

## The trap

A hold that re-enters itself is a LOOP WITH NO FLOOR. `_update_grapple` runs
every frame and a replay that mis-reads its own end condition will re-graft
forever. Print a quantity a broken run cannot fake — `hold_replayed` against
seconds held — and read it before believing the picture.
