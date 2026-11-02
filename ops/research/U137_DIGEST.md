# U137 digest — `ApproachSweep.gd` and probe conversion

## Module

`Godot/scripts/ApproachSweep.gd`: five static functions (`direction`, `point_to_segment`,
`hand_position`, `blocker`, `sweep`) with zero preloads. `sweep` loads
`ApproachBand.gd` at runtime for `in_band` and `banded_fraction`. Sphere caps
use `a == b` in `point_to_segment`; `blocker` scores every candidate and keeps
maximum depth (no early exit). Unknown `target_name` → `{}`.

## Blind contract test

`FIGHTCAMP_STAGE_GATE=off` (stale `.shipped` in this worktree).

```
python Godot/tools/check_scripts.py Godot/scripts/ApproachSweep.gd Godot/tools/s47_contact_offsets.gd Godot/tools/s52_present_ratio.gd
→ CHECK total=3 fails=0
python Godot/tools/run_tests.py --only approach_sweep
→ SUITE total=1 fails=0
```

## Probe before/after (full reachability tables captured)

Logs: `research/u137_s47_{before,after}.log`,
`research/u137_s52_{before,after}.log`.

**No line changed** in either probe’s reachability / exposure table. Diff on all
`neck`/`thorax`/`pelvis` grip rows is empty.

**Why that is expected, not a silent miss:** `origin/master` already scored every
blocker per direction (no `break`) in both `s47_contact_offsets.gd` and
`s52_present_ratio.gd`. This stage extracts that logic into `ApproachSweep` and
routes both probes through `sweep` / `blocker`; it does not reintroduce
first-hit iteration. `point_to_segment` matches the prior
`FightPoseSolver.segment_distance(hand, hand, p0, p1)` clearance used in those
loops, so `usable`, `pct`, `worst`, and depths stay byte-identical. Proof the
module is on the path: both probes `load("res://scripts/ApproachSweep.gd")` and
fail init if it is missing.

`s53_ball_capsules.gd` untouched per task (third copy for a later pass).

## RESEARCH_INDEX grep

- `grep -i sweep RESEARCH_INDEX.md`: hits are other sweeps (ruleset, cage, corner
  order, round length) — not this capsule reachability module.
- `grep -i 'reachab\|exposure'`: cites S52, C158, D7/D9 neck reachability, probe
  tools; no prior `ApproachSweep` entry (negative for a dedicated index row).

## Contract ambiguity

None required a named epsilon in the module. `direction` is explicitly normalized
after the Fibonacci formula so unit length holds even if float drift appears;
the contract’s formula is already unit-length in theory.

## Strongest case the contract is wrong

`sweep` returns nine keys while most callers want `usable`, `pct`, and `worst`.
That invites a tenth field instead of a typed result or a slim `exposure_only`
wrapper. `blocker` and `sweep` are correctly split for blind tests, but
**weakest point:** runtime `load("res://scripts/ApproachBand.gd")` inside every
`sweep` call — fine for probes, wrong if this ever runs inside a tight inner
loop without caching.
