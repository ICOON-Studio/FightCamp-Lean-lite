# TASK_D5 — DOLA — PROVE THE 13/13, THEN HAND OVER THE DOF SPEC

**Owner:** Dola
**Driven directly** by `Tools/cici/cici.py` on port 9333. Brief goes over as a
file; code comes back as text.

## Where this stands

D4 came back with **5/13 arms-only → 13/13 with the spine**, every standing hold
converging inside the original bounds with no relaxation, and the sentence the
task demanded: **"RUN — all numbers measured locally."** Your solver page was
captured and is kept at `research/_collect/D4_solver_spine.html`.

Thank you for the attestation — it is exactly what was asked for.

**It has not been independently reproduced yet, and that is not a slight.** Your
round-2 delivery shipped a thirteen-row table headed "Results — as run" that had
never been run: the file threw on its first line of work, and after a two-word
repair not one of the thirteen penetration figures matched — 6 claimed passes, 3
delivered, the collar tie claimed at pen 0.0000 when it was 0.0928. That is why
the RUN sentence exists, and why the numbers still need one more pass before a
Godot implementation is scoped against them.

**The shape of D4 is encouraging, not suspicious:** the spine improves every row
monotonically, never worsens one, the five that already passed still pass, and the
eight that cleared land at grip 0.0073–0.0118 m — just inside the 0.012 m bound
rather than implausibly at zero. Fabricated tables report zeros.

## Part 1 — the stability check you offered

You ended D4 by asking: *"Would you like me to verify stability by perturbing each
DOF and confirming all cost gradients are non-zero?"*

**Yes. Do that.** For each of the 12 DOFs (8 arm angles, 4 spine angles), perturb
it alone by a small amount from the converged pose and report the change in total
cost. Give a table: **DOF name, perturbation applied, Δcost.**

**A DOF whose Δcost is ZERO is doing nothing**, and that is the finding this check
exists for — it would mean the pose converged without that DOF and the spine's
contribution is smaller than the 13/13 implies. Report any zeros loudly rather
than quietly dropping them.

## Part 2 — one control arm, and it is the important half

Re-run the **arms-only** configuration and confirm it still gives **5/13** with the
same per-pose figures D4 reported. Same seeds, same starts, same schedule, the
spine DOFs simply disabled.

**If the arms-only numbers do not reproduce, the spine numbers mean nothing** —
it would mean something else changed between the two runs, and the comparison is
not a comparison. This is the single most valuable thing in the task.

## Part 3 — the DOF spec, for a different engine

The numbers are yours; the implementation will be in Godot against a 22-bone rig,
and it will be written by someone who cannot run your page. **Write the DOF
definition as a specification, not as code:**

- For each DOF: which joint, which axis, the allowed range in radians, and what is
  held fixed.
- **The spine hinge: where exactly is the waist?** Between which two points, and
  is it one hinge or two stacked?
- **What is preserved.** You say segment lengths exactly and no scaling anywhere —
  state which lengths, so the Godot side can assert them.
- **The order of operations.** Does the spine apply before or after the arms, and
  does it matter?
- **The cost weights and schedule**, unchanged from the control, written out.

## THE TRAP, AND IT IS THE SAME ONE

**Send the numbers your run actually printed.** If a part of this cannot be
executed, say **"NOT RUN — the table below is what I expect, not what I measured"**
for that part specifically. Partial honesty is completely acceptable and costs
nothing. A table that was not run costs a whole collection pass, and it has once.

**Second trap:** `pen_max` must remain the maximum over EVERY capsule pair, not
only declared contacts. On all 13 poses the worst real interpenetration was never
a declared pair, and closed guard once passed at 4.6 mm while the two torsos were
0.2208 m inside each other.

**Third trap:** print stature and foot height for both bodies beside every
separation. A hip-to-hip figure is right by construction if the two armatures are
placed at fixed x, and one earlier run had a fighter's head 60 cm below his feet
while the separation still read exactly 0.72 m.

## Deliver

Reply with: the perturbation table, the arms-only control result, the DOF spec,
and a RUN / NOT RUN sentence per part. Claude runs your page here and compares.
