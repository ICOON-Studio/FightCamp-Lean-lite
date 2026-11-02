# ANIMBALANCE1B — BLOCKED before the master OFF baseline

2026-10-12. Branch `codex/animbalance1b`; work only in `E:/FightCamp/wt/ANIMBALANCE1B`.
This is a partial delivery, not acceptance or feature completion.

## Delivered

- New windowless `tools/c225_balance_gate.gd`, reusing C224/C223's legal welter and heavy fixtures.
  It discovers the four certified slip/pull move IDs from the palette, advances production players
  at 60 FPS, updates the skeleton, and measures BodyBalance's actual signed support margin.
- No production script was changed. `anim_balance`, `BalanceLayer.gd`, and the switch test are NOT implemented.
- No editor import, window, image viewer, browser, Explorer, or other checkout was used.

## Exact external blocker

The FIRST C225 run was OFF on detached master `231b9a3616ec7c04190edb9102bae05cd3323f18`
(only the untracked instrument added). It could not finish constructing its first production pair:

```
WARNING: Reading less data than requested
  _load_fbx (res://scripts/FightClipRetarget.gd:1003)
  build_silhouette_corrections (res://scripts/FightClipRetarget.gd:285)
  _graft_retargeted (res://scripts/FightStagePlayer.gd:2303)
  bind (res://scripts/FightStagePlayer.gd:1502)
ERROR: Parameter "mem" is null.
  _soles (res://scripts/FightClipFootPlant.gd:277)
  bake (res://scripts/FightClipFootPlant.gd:18)
ERROR: Parameter "mem_new" is null.
CrashHandlerException: Program crashed with signal 11
```

The captured process returned 1. Windows also rejected a shell process with error 1455:
"The paging file is too small for this operation to complete."
After the crashed task processes exited, a sequential OFF retry was saved to
`C:/Users/user/AppData/Local/Temp/animbalance1b_c225_off.log`; it repeatedly emitted the same
short-read stack in the first bind and timed out after 240 seconds, with zero C225 rows.
Its process was terminated by Python's timeout handling. No other agent's process was stopped.
The sampled `H2H_JabInPlace.FBX` is 739104 bytes and byte-identical to its tracked master blob;
this does not establish that all source assets or retargeting code are healthy.

The fault's cause (host memory pressure versus a bind/retarget issue) is unresolved.
Repairing `FightClipRetarget.gd`, `FightClipFootPlant.gd`, the body/animation assets, or FSP's
bind/graft windows is outside the task's ownership. Host memory/pagefile changes are also outside it.
No substitute pose, skipped binding, altered BodyBalance maths, or fabricated baseline was used.

## C225 rows (cm)

| Move | Pair | Master OFF | Branch ON |
| --- | --- | --- | --- |
| boxing_slip_counter | generator_welter_av_generator_welter_b | unavailable: bind failed | not run: feature unimplemented |
| boxing_pull_counter | generator_welter_av_generator_welter_b | unavailable: bind failed | not run: feature unimplemented |
| boxing_slip | generator_welter_av_generator_welter_b | unavailable: bind failed | not run: feature unimplemented |
| boxing_pull | generator_welter_av_generator_welter_b | unavailable: bind failed | not run: feature unimplemented |
| boxing_slip_counter | generator_heavy_cv_generator_heavy_d | unavailable: bind failed | not run: feature unimplemented |
| boxing_pull_counter | generator_heavy_cv_generator_heavy_d | unavailable: bind failed | not run: feature unimplemented |
| boxing_slip | generator_heavy_cv_generator_heavy_d | unavailable: bind failed | not run: feature unimplemented |
| boxing_pull | generator_heavy_cv_generator_heavy_d | unavailable: bind failed | not run: feature unimplemented |

Neither OFF attempt reached `C225 total=...`. No numerical measurement is available.

## Every gate result

```
CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0 time=1s
MASTER OFF attempt 1: process rc=1; allocation failure / signal 11; C225 rows=0
MASTER OFF attempt 2: subprocess.TimeoutExpired after 240 seconds; C225 rows=0
CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0 time=0s
```

The second parse checks the final instrument (the generator head endpoint uses C224's scalp offset).
All engine executions were headless with the required non-console 4.7.2 executable; no parallel tests.
The switch test and the specified `--jobs 1` related suite were not run: baseline construction is blocked
and no feature code exists. No claim that existing green tests remain green is made.

## Resume

Resolve the master production bind/allocation blocker, then rerun the OFF gate FIRST and retain every row.
Validate the instrument's joint aliases on the mounted rig once binding succeeds. Implement the owned
switch/call and BalanceLayer, prove byte-identical OFF poses over 30 frames on two different fighters,
prove ON root/feet invariants, and run the specified related suite with `--jobs 1`.
Keep correcting owned feature code until the acceptance is green; this digest must not close the task.

Task overrides applied: only the requested branch may be pushed; the non-console engine replaces the
generic AGENTS console path; FSP reads remain grep-found windows; no full import/full suite.
No HANDOFF block was edited for this instrument/document partial delivery.
