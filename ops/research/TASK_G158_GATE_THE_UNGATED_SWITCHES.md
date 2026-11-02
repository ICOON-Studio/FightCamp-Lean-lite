# TASK G158 - give every ungated game switch a test that can fail

Model: Grok Build default (grok_task.ps1). Owner: Grok CLI. Worktree `E:/FightCamp/wt/G158`, branch `grok/g158-switch-gates`.

## Why (operator, S143, verbatim)
"Also, tell me if there are still mechanics that are not gated."

## The problem (primary source, measured S143 by grep over Godot/tests/*.gd)
These switches are ON in the game (`demo_switches_on()` / `FightRealtime.DEMO_SWITCHES`) and NO test file names them.
Each was justified by a one-off probe in a digest, but nothing in the suite would go red if one regressed or were
turned off by accident. Each switch's own doc comment says what it fixes and on which probe it was measured:

| Switch | Defined at | What ON must do (from its comment) | Probe it was measured on |
|---|---|---|---|
| `angle_guard` | FightRealtime.gd:1151 / FightDefenceModel.gd:261 | C228 - an attack from an angle opens the guard | tools/c228_angle_census.gd |
| `face_drawn_foe` | FightWorldLiveScreen.gd:677 | body aims at the foe AS DRAWN, not the engine facing | s132_facing_probe.gd |
| `hold_pair_geometry` | :685 | the free man keeps his relative place while the other is held | s133 trace |
| `reface_in_takes` | :694 | a man keeps turning toward his man inside a take | s133_facing_split_probe.gd |
| `warp_on_line` | :704 | a lunge only travels along the fight line, two lunges share the room | s133 trace |
| `sequence_steps` | :709 | a combination steps between its punches | c223_sequence_gate.gd |
| `contact_push_on_line` | :718 | contact push points along the fight line only | s131_bullet_probe.gd |
| `contact_push_carry` | :726 | push capped per frame + folded into the hold origin (no pops) | s133_chop_probe.gd |
| `root_accel_cap` | :733 | a root only speeds up by ROOT_ACCEL_MPS2 | s133_chop_probe.gd |
| `hand_contact_sync` | :742 | hands re-seated after contact_stop (no out-and-back pops) | u203_hand_trace.gd |
| `shuffle_from_bell` | :753 | boxing footwork shuffle from the bell | s131 probes |
| `hands_smooth_in_whole` | :755 | hand smoothing inside whole takes too | s131_hand_pop_probe.gd |

## Build
One new test file per switch group (or one file with a section per switch - your call, but each switch gets its OWN
PASS/FAIL line naming it): `Godot/tests/switch_gate_<name>_test.gd`. For EACH switch:
1. **OFF arm = legacy.** Mount the room headless (copy the mounting pattern from `tests/fight_world_live_test.gd`
   and `tools/record_room.gd`: instantiate, `configure(options)`, THEN setup) with every other demo switch ON and this
   one OFF, and with it ON. Two DIFFERENT fighters (different stats/frames - never identical fighters), seed 92012,
   boxing, 20 s of room time at the fixed 30 fps clock.
2. **ON moves the quantity the switch exists for, in the right direction**, measured the way its probe measures it
   (port the probe's metric; do not invent a new one). Assert a BOUND (e.g. "pops ON <= 0.7 x pops OFF",
   "drawn-vs-engine facing p90 ON < OFF"), never an exact count.
3. **The test can fail:** prove it with a mutant - for each switch, run the test once with the ON arm forced OFF
   (an injection option, no `--`) and show the FAIL line. Paste both outputs in your digest.
For `angle_guard` (an ENGINE switch, no room): FightRealtime bouts with options `angle_guard` on/off, 12 seeds,
assert the angle-attack landed share rises (the c228 census metric).

## Acceptance
- 12 switches, each with a PASS line on master and a demonstrated FAIL under its mutant.
- Each new test < 90 s headless; total wall time printed.
- No production script edited (tests + an injection option at most; if a switch needs an option hook that does not
  exist, add ONLY the `options.get(...)` read beside the existing one and say so).

## Owned files
New: `Godot/tests/switch_gate_*.gd`, `research/G158_DIGEST.md`. Read-only: FightWorldLiveScreen.gd (5,911 lines -
NEVER read whole; `sed -n 670,760p` holds every switch above; `grep -n "_<switch>"` finds each use), FightRealtime.gd
(read `sed -n 1145,1170p` and `grep -n angle_guard`), the probes in `Godot/tools/` named above.

## Prior research
`python Tools/prior_research.py switch byte-identical control arm test` -> C191_DIGEST (instrument + positive
control pattern), research/topics/tooling_process.md. S133_DIGEST and U203_DIGEST hold each probe's before/after.

## What would a human do?
A QA lead writes one regression test per feature flag the day the flag ships: flag off = old behaviour, flag on =
the metric that justified it, and a deliberately broken build to prove the test notices.

## Prefab check
Godot has no built-in feature-flag test harness; GUT/gdUnit4 are not used in this repo - the house pattern is a
`--script` test printing PASS/FAIL lines (see any file in Godot/tests). Use it.

## Test (tier: new test files only)
Parse gate: `python Godot/tools/check_scripts.py <each new .gd>`.
Each test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/<name>.gd`.
Before any Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (exit 1 = wait).

## The one trap
A test that runs headless gets the switches OFF by default (`demo_switches_on()` is false under `--script`) - you
must set each one EXPLICITLY through `configure(options)`, or both arms are identical and the test is green for
nothing. Print the effective value of the switch in each arm in the output.

Rules: never open a viewer or window (file tool only); git add explicit paths; commit; `git push -u origin grok/g158-switch-gates`.
Never edit HANDOFF.md. Do not stop at written - run every test and paste the output.
