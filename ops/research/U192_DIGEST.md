# U192 digest — plan + corner reads blind contract

**Owner:** cursor · **Branch:** `cursor/u192-plan-reads-contract` · **Test:** `Godot/tests/plan_reads_contract_test.gd`

## Delivered
Blind contract test loaded from `TASK_U192_PLAN_AND_READS_BLIND_CONTRACT.md` only (fixtures: distinct reach/stats for `ours`/`theirs`; no identical fighters). Covers `FightPlanSetup.ai_sliders` / `ai_scatter` / `ai_reads` / `view().overall`, and `CornerPitStop.cards` / `fits` / `apply` / `rolls_needed`.

## Gates
- Parse: `check_scripts.py` on the test — **pass**
- Run: `plan_reads_contract_test.gd` — **`PLAN_READS_CONTRACT_TEST PASS`** (live modules match contract)

## Mutant kill matrix (scratch wrappers under `user://`, restored after run)
| Mutant | Red check |
|--------|-----------|
| `ai_reads_threshold_60` (tell from 60) | `ai_reads below 75 must be empty at 70` |
| `ai_scatter_increases` (scatter rises with tactical) | `ai_scatter must decrease 25->60->95` |
| `grappling_not_forced_standup` (boxing grappling 0.5) | `grappling must be -1.0 under boxing` |

## Findings
None — implementation agreed with the written contract on this slice.
