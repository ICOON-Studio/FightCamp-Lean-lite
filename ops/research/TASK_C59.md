# TASK C59 — CODEX — THE FAMILY MAP THAT SHADOWS EVERY CLIP

**Owner:** codex
**Model:** cheaper tier, effort **low**, Fast **on**.
Reason: a diagnosed one-map fix plus a close-out. No new system, no design
judgement. The diagnosis below is already done — do not re-derive it.

## Why this exists

U18 (merged `d8c6e33`) put this first in its build order: *"Fix the family map
— one-line, unblocks honest clips."* It is first because every later
animation task inherits the bug.

## The bug, already located

There are **two** competing family maps and the coarse one silently wins.

- `FightSimulation.gd:231` — `ANIMATION_FAMILY_BY_ROLE` maps role to a **coarse**
  family: only `strike`, `clinch`, `takedown`, `submission`, `scramble`.
  Every action event gets one stamped on at `:1295` and `:1491`.
- `RingStagePanel.gd:941` — `_family()` returns a **fine** family:
  `feint_setup`, `counter_strike`, `level_change`, `clinch_control`,
  `submission_attack`, `defensive_escape`, `ground_scramble`,
  `footwork_adaptation`, `power_strike`.
- `RingStagePanel.gd:884` — the consumer:
  ```gdscript
  var family := str(event.get("animation_family", _family(event)))
  ```
  `_family(event)` is only the **fallback**. Because every real action already
  carries `animation_family`, the fallback almost never runs.
- `RingStagePanel.gd:889` — the `match family:` block branches on the **fine**
  names. So the coarse value matches none of them and every action falls to the
  default arm.

**Consequence:** a feint, a counter and an adaptation all animate identically as
a generic strike, and the fine branches below `:889` are effectively dead code.
Separately, the slip event at `FightSimulation.gd:1582` stamps
`"animation_family": "evade"`, which is also absent from the `match` arms.

## What to do

Make the two vocabularies agree. **Prefer widening the map over deleting the
fallback** — the fine names are the ones the choreography is written against,
and `RingStagePanel.gd:889`+ already implements them.

1. Give `ANIMATION_FAMILY_BY_ROLE` (`FightSimulation.gd:231`) the **fine**
   names, matching what `_family()` already returns for each role:
   `damage -> power_strike`, `counter -> counter_strike`,
   `setup -> feint_setup`, `adaptation -> footwork_adaptation`,
   `control -> clinch_control`, `takedown -> level_change`,
   `submission -> submission_attack`, `transition -> ground_scramble`,
   `escape -> defensive_escape`.
2. Add `evade` and `cover` arms to the `match family:` block in
   `RingStagePanel.gd` so the slip event at `FightSimulation.gd:1582` and the
   `cover` reaction (`FightSimulation.gd:227`, `CHAIN_REACTIONS`) get their own
   treatment instead of the default. Keep them cheap — a small backward lean and
   a guard-tighten are enough; this task is not authoring a clip library.
3. Leave `_family()` in place as the fallback. It is now the same vocabulary,
   so an event missing `animation_family` still renders correctly.

**Do not** rename the `defense` **attribute** (`FightSimulation.gd:60`,
`Aging.gd:67`). It is one of the seven and is unrelated — the collision is in
the animation vocabulary only. This is the single trap in this task.

## Also: close out C58

C58 is done and pushed (`d529447`) and both verdict messages reached Claude
(*0 regenerations; `apply_girth` is shippable, not a distortion*), but the task
still reads **OPEN** on the board. Convert **your own** C58 block in
`HANDOFF.md` from IN PROGRESS to COMPLETE, max 8 lines. Do not touch any other
agent's block.

## Owned files

- `Godot/scripts/FightSimulation.gd` — **2,954 lines, never open it whole.**
  Anchors: `:60` (STAT_KEYS, do not touch), `:227` (CHAIN_REACTIONS),
  `:231` (the map to widen), `:1295` and `:1491` (stamp sites), `:1582` (slip).
- `Godot/scripts/RingStagePanel.gd` — **1,348 lines, do not open it whole.**
  Anchors: `:884` (consumer), `:889`+ (the `match`), `:941` (`_family`).
- `HANDOFF.md` — your C58 block only.

## Gate

Parse gate first, always:
```bash
python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd Godot/scripts/RingStagePanel.gd
```
Focused tests, then the full suite once in the background before the commit:
```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ring_stage_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_simulation_test.gd
python Godot/tools/run_tests.py
```
`SUITE total=N fails=M` must be **fails=0 or better than you found it** — if you
find a pre-existing failure and fix it too, say so and push. Never gate on an
exact count.

## The trap

`defense` is both one of the seven attributes and, informally, an animation
idea. Widening the animation vocabulary must not touch the attribute, the
`STAT_KEYS` array, or `Aging.gd`. Rename nothing outside
`ANIMATION_FAMILY_BY_ROLE` and the `match` arms.
