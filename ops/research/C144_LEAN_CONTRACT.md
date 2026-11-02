# C144 - Lean-survival blind contract

Base: master `78225fdf`. Task settings: gpt-6-astra / medium / Fast off.
Only the new test and this report are delivered. No retarget implementation
or Cursor branch/worktree was read. HANDOFF and other digests were not read.
C144's no-HANDOFF and single-test tier override the general handoff/suite rules.

## Contract and measurements

Nine evenly spaced samples cover the bound 0.000..4.000 s, including both ends.
Population: f01 box welter attacker / f02 box heavy victim (distinct bodies).
Runtime loads, pair graft and animation lookup follow the named probes.
Poses use FightPoseBridge.globals_at; world points use pair_gap_report's
explicit body/ancestor transform composition, safe before tree entry.
Missing binding is the prescribed SKIP GREEN; missing plumbing fails loudly.
Every sample checks both lean bounds, opposing horizontal axes and hip heights.
The test also pins the Cascadeur GLBs, exact grapple keys and bought control pair.

**Specification discrepancy:** master has NINE PAIRED_BINDINGS entries, not ten.
Pinned literal 9 and all nine names, following 'read the current key count off master'.
`grapple_control` still names `Paired_FullMount_Takedown_BodyLock_Loop`.

| Measured quantity | Minimum | Maximum | Contract |
|---|---:|---:|---|
| Attacker lean, degrees | 56.804 | 60.275 | >=12 |
| Victim lean, degrees | 27.195 | 29.336 | >=12 |
| Horizontal angle, degrees | 173.544 | 175.292 | >90 |
| Attacker hips Y, metres | 0.017 | 0.051 | 0.6..1.3 |
| Victim hips Y, metres | 0.019 | 0.053 | 0.6..1.3 |

Parse: CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0.
Direct test: FIGHT_LEAN_SURVIVES_TEST checks=85 failures=18, exit 1.
All 18 failures are C5 hip height; C2/C3 lean pass. This is NOT the anticipated
straightened-pose failure. No bounds were weakened, and no fix status is inferred.
An initial probe global_transform call errored before tree entry; replaced with
pair_gap_report's explicit composition. Final run has no runtime/engine errors.
The stale shipped-session gate required FIGHTCAMP_STAGE_GATE=off (announced).
Installed Godot required elevated access. No suite or subsets were run.

## Scratch mutation evidence

Each scratch script parsed first and ran directly, with no runtime errors.
Baseline C5 is already red; assertion-specific counts separate mutant detection.

| Mutation | C2 / C3 / C4 / C5 / C6 failures | Total / exit |
|---|---|---|
| Lean threshold 0 degrees | 0 / 0 / 0 / 18 / 0 | 18 / 1 |
| Same horizontal spine direction | 0 / 0 / 9 / 18 / 0 | 27 / 1 |
| Hip floor raised to 1.5 m | 0 / 0 / 0 / 18 / 0 | 18 / 1 |
| Pinned count changed 9 to 10 | 0 / 0 / 0 / 18 / 1 | 19 / 1 |

Additional controls establish sensitivity despite baseline failures:
upright axes at 12 degrees cause 9 C2 + 9 C3 failures; at zero both disappear.
Synthetic hips at 1.0 m: 85 checks / 0 failures / exit 0; floor 1.5 gives
18 C5 failures / exit 1. Synthetic values exist ONLY in scratch copies.
Scratch logs: `%TEMP%/C144-mutants-sow07dp7/` (four mutants + upright controls).
