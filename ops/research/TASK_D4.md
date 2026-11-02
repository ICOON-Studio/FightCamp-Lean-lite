# TASK_D4 — DOLA — ADD THE SPINE DOF AND SAY WHICH HOLDS CLEAR

**Owner:** Dola
**Driven directly** by `Tools/cici/cici.py` on port 9333. Brief goes over as a
file; code comes back as text. **You have no Blender and no Godot** — everything
below is a self-contained script Claude runs here.

## Where this stands, in numbers you produced

Your standing-wrestling corpus was collected and RUN here, and it answered the
question it was built for: **two rigid statues that may only translate and yaw
cannot reach ANY standing hold.** All 8 standing/defensive poses failed, with
grips landing 0.12–0.42 m from the thing they grip.

Then the control arm settled WHY, and this is the number that matters: same cost
function weight-for-weight, same schedule, same start, **one change — each arm may
rotate about its own shoulder on a sphere of its rest length, TWO angles, length
preserved** — and the collar tie went from the worst failure in the set (grip
0.3406, pen 0.0879) to **pen 0.0000, grip 0.0006, a full pass.**

The seven that still fail then floor at **grip ~0.10–0.12 with pen 0.06–0.08 m**,
and that floor is the RIGID TORSO.

**So: arms first, spine second, elbows are not the blocker.** Arms are done. This
task is the spine.

## What to build

Extend your solver with a SPINE DOF and report which of the seven remaining holds
clear. Specifically:

- The torso becomes two segments hinged at the waist: a pelvis and a thorax, with
  the thorax able to **flex forward/back and to side-bend**, two angles, segment
  lengths preserved. Nothing else changes.
- Keep the arm DOF exactly as the control arm had it — two angles per arm about the
  shoulder, on a sphere of rest length.
- **Change nothing else.** Same cost function, same weights, same schedule, same
  starts, same 13 poses. This is a control experiment and it only means anything
  if the spine is the single variable.

## Report, per pose, both arms of the comparison

A table with one row per pose and these columns: **pen_max and grip_max with arms
only (your existing result), and pen_max and grip_max with arms + spine.** Both
arms, side by side. A single after-column cannot show whether the spine helped,
hurt, or did nothing.

State how many of the 13 PASS under each, on the same bounds you used before —
**pen ≤ 0.006 m and grip ≤ 0.012 m.** Do not move those bounds. A solver that
needs its bounds relaxed to pass has not passed.

## THE TRAP, AND IT HAS CAUGHT YOUR WORK TWICE

**RUN IT BEFORE YOU REPORT A NUMBER.** Your round-2 solver shipped with a
thirteen-row table headed "Results — as run". It threw `def.joint is not iterable`
on its FIRST line of work — the LIMBS table wrote `jnt:` and `buildCapsules` read
`def.joint` — and rendered a blank mat. It had never been run. After a two-word
repair, **not one of the thirteen penetration figures matched**: it claimed 6
passes and delivered 3, claimed the collar tie at pen 0.0000 when it was 0.0928,
and claimed "hold lift 0.0000, defender hands grounded" on a sprawl whose hands
were 0.3883 m in the air.

So the deal is: **send the script and the numbers it actually printed, or send the
script and say plainly that you could not run it.** The second is completely
acceptable and costs nothing. The first, when it is not true, costs a whole
collection pass.

If you cannot execute, say: *"NOT RUN — the table below is what I expect, not what
I measured."* That sentence makes the delivery useful. Its absence makes it
dangerous.

## Second trap — score ALL pairs, not just declared contacts

Scoring penetration only over DECLARED contacts is a gate that cannot see the
bodies it grades. On all 13 poses the worst real interpenetration was **NEVER a
declared pair**, and closed guard passed at 4.6 mm while the two torsos were
**0.2208 m inside each other**. Whatever you report, `pen_max` must be the maximum
over EVERY capsule pair between the two bodies.

## Third trap — a separation is a difference, so check an absolute too

Placing two armatures at x = −0.36 and +0.36 makes hip-to-hip 0.72 m whatever the
pose does, which is how a previous delivery reported one figure right by
construction. **Print stature and foot height for both bodies alongside every
separation.** One earlier run had a fighter's head 60 cm BELOW his feet and both
men 0.596 m tall, and the hip separation still read exactly 0.72 m.

## Deliver

Reply with the full script as text, plus the table, plus the RUN / NOT RUN
sentence. Claude runs it here and lands the result.
