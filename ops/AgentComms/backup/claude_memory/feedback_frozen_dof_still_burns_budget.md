---
name: frozen-dof-still-burns-budget
description: "Freezing a DOF by zeroing its step does NOT remove it from a budgeted descent — the control arm then gets fewer useful evaluations than the test arm; match the RESOURCE, not just the vector"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: df8f76d1-5782-4bc6-912e-acdfd98f65f9
  modified: 2026-09-22T02:01:18.428Z
---

S46 (2026-09-22) built its arms-only control by giving the four spine DOFs a zero
range and a zero step in the same 24-slot vector the spine arm used — same
schedule, same weights, same scoring. That LOOKED like a matched control. It was
not: `FightPoseSolver.descend` probed every DOF in its index set six times per
sweep, frozen ones included, so the control spent budget on candidates it could
not move and hit the evaluation ceiling with fewer USEFUL evaluations than the
arm it was controlling for. The tell was run-to-run drift on the control's own
rows (collar tie 0.1449 → 0.1525 m) when only the vector LENGTH had changed.

**Why:** a control arm must be matched on the resource that limits the result,
not only on the inputs. A descent's resource is useful evaluations; a frozen DOF
consumes them and returns nothing, so the control was handicapped, not matched.
This is the sibling of [[a-control-that-cannot-move]] and
[[control-arm-must-not-share-the-bug]]: there the control could not read
differently; here it could, but was starved.

**How to apply:** when a control is made by disabling part of a shared
optimiser, check where the optimiser SPENDS — skip disabled dimensions in the
loop (done: `descend` now `continue`s on `step <= 0`, and reads its step floor
from the first LIVE DOF rather than `idx[0]`), and confirm both arms report the
same `evals`. Also: a pass count that flips on the third decimal of a bound
(closed guard 0.0053 vs 0.0067 against 0.006) is inside the method's noise, not
a result — say so rather than banking the +1.
