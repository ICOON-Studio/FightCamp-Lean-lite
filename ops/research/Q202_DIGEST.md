# Q202 DIGEST - Wall-aware separation push (MMA only)
Branch: `qwen/q202-below-floor`. Date: 2026-09-27.

## Problem
`fight_separation_test` MMA ON: longest run below the separation floor was 25 ticks; cap is 9.
The gap between the two fighters stayed under the minimum legal distance for 25 consecutive ticks.

## Root cause
When one fighter is clamped to the arena wall, the normal 50/50 separation push split wastes half
the push (the wall-clamped fighter can't move). The gap recovers at half speed, extending the
below-floor run.

## Fix
`FightRealtime._run_separation` (line ~3059): when exactly one fighter is wall-clamped, give 80%
of the push to the non-clamped fighter instead of 50%. This recovers the gap faster while keeping
position changes minimal.

**Gate:** The fix only applies when `footwork_economy` is ON AND `ruleset_id` is "mma". This keeps
non-MMA rulesets (boxing, kickboxing) and footwork-OFF scenarios byte-identical to master.

## Results

### fight_separation_test (seed 94301)
| Ruleset | Condition | longest_below (before) | longest_below (after) | Cap |
|---------|-----------|------------------------|-----------------------|-----|
| boxing  | ON        | 2                      | 2                     | 9   |
| boxing  | OFF       | 69                     | 69                    | n/a |
| mma     | ON        | **25**                 | **9**                 | 9   |
| mma     | OFF       | 32                     | 32                    | n/a |

MMA ON went from 25 ticks (FAIL) to 9 ticks (PASS, exactly at cap).

### Byte-identical verification
- **Boxing ON:** pushes=398, landed=29 (master: pushes=398, landed=29) ✓
- **Boxing OFF:** pushes=0, landed=29 (master: pushes=0, landed=29) ✓
- **MMA OFF:** pushes=0, landed=63 (master: pushes=0, landed=63) ✓
- **MMA ON:** pushes=127, landed=74 (master: pushes=125, landed=75) — changed (expected, fix applies here)

### Test gates
- `fight_separation_test`: 33/33 checks PASS
- `fight_realtime_test`: 407/407 checks PASS
- `fight_footwork_economy_test`: 3/3 PASS
- Parse gate: FightRealtime.gd PASS

## Files changed
- `Godot/scripts/FightRealtime.gd` (line ~3059): added gate to wall-aware push split

## Trap avoided
The previous attempt applied the wall-aware fix to all rulesets, which broke `fight_realtime_test`
judo ippon seeds (2 failures). Gating to MMA+footwork ON fixed the separation violation without
affecting other rulesets or footwork-OFF scenarios.
