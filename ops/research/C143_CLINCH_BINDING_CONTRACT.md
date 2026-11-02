# C143 — authored clinch hold binding contract

## Result

Added `Godot/tests/fight_clinch_binding_test.gd` as a blind contract witness.
The real master tree had no `mma_dirty_boxing` entry at test time, so the witness
correctly printed `SKIP ...`, `failures=0`, and exited 0. No implementation file
was edited.

## Gates

| Gate | Result |
|---|---|
| Parse gate | `CHECK total=1 fails=0` |
| Direct Windows executable | Blocked by sandbox: executable exists, launch returned Access denied |
| Godot 4.7.2 Chocolatey fallback | SKIP GREEN; `failures=0`; exit 0 |

The fallback also reported the host's existing certificate-store warning; it did
not prevent the test from reaching the intended SKIP path.

## Scratch mutation proof

The real binding was absent, so a copied `FightClipBinding.gd` was given a
hand-written stub entry in a temporary scratch project. Each mutant was run
against the copied test and had a failing assertion with exit code 1.

| Mutant | Result | First relevant failure |
|---|---|---|
| `pair_key = "Cascy_Clinch"` | RED, rc=1 | exact `pair_key` |
| `att` suffix changed to `.fbx` | RED, rc=1 | `.glb` suffix (also disk/Cascadeur checks) |
| `vic = att` | RED, rc=1 | `.ends_with("_Vic.glb")` and distinct paths |
| `content_s = end_s - start_s + 0.5` | RED, rc=1 | duration equality |
| `content_s = 1.667` | RED, rc=1 | duration equality and research bound |

The 3–8 s bound is based on Davis et al.'s Olympic boxing data: inferred mean
clinch episodes are roughly 5.0/5.4/6.0 s across rounds from total clinch time
divided by frequency; shorter than 3 s is a statue with a twitch and longer than
8 s is outside the measured range.
