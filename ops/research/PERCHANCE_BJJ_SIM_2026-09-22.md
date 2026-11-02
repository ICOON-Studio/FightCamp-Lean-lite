# The perchance BJJ sim holds two bodies in contact. The defect is pose identity.

**Checked 2026-09-22 in the operator's Chrome at `https://perchance.org/gro5f7k2s5#edit`.
Server truth read with `__fetchGeneratorDataVersion()`, never off a screenshot:
`editorPayloadRevision 8, saveCount 4, lastEditTime 00:00:37`. Read-only — nothing
was saved. The operator's ruling is to LEAVE THE FILE TO ITS AGENT and re-check
progress each session; two writers collide.**

**THE PROBE'S QUESTION IS ANSWERED, AND THE ANSWER IS YES.** It was asked whether
anything can hold two bodies in contact without interpenetrating. Mount, open
guard and leg entanglement all rendered as two bodies in contact ON THE MAT —
supine bottom man, top man over him, no visible interpenetration. That is a data
point AGAINST `HIGGSFIELD_MMA_PIPELINE_STUDY.md`'s one-body / 0-of-36 verdict,
not for it, and it is the cheapest one we have bought.

## What is built

267 KB of output template, 181 functions. Not a view layer — a system:

- **Rig:** `buildRig`, `applyJoints`, `fkBody`, `writeBackBody`, `limbAngles`
- **Collision:** `segSeg`, `capOf`, `capSpheres`, `spheresNear`, `sysViolation`
- **IK:** `limbIK`, `aimJoint`, `alignDistal`, `alignJoint`, `applyIK`, `placeContacts`
- **Solver:** `solveRoot`, `solveSystem`, `probeSystem`, `finishSolve`, and a
  projection family — `projRigid`, `fitSegSeg`, `projSegPair`, `projFloor`,
  `fitBody`, `bendNormal`, `fitGripTargets`, `fitShapeMatch`, `fitViolations`,
  `projTemplate`, `projSolve`
- **Constants:** `RIG_DEF`, `CAP_DEFS`, `LIMB_R`, `LIMB_AXIS`, `POSE_DEFS`,
  `SUB_POSE`, `POSITIONS`, `SUBS`, `FIT_CLUSTERS`, `FIT_TORSO`
- Two bodies named `top` / `bottom`; plus a full sim layer — attributes, belts,
  teams, win/loss records, archetypes, IBJJF rulesets, play-by-play, a timer.

**This is further than our own port.** `FightPoseSolver.gd` is a capsule solver
wired to nothing; this is a jointed rig with partner IK driving a live match.

## The defect: named position vs rendered pose

Seven ground positions sampled from one saved build, one session:

| label | on the mat | verdict |
|---|---|---|
| MOUNT · RED ON TOP | yes | **correct** |
| OPEN GUARD · BLUE ON TOP | yes | **correct** — bottom seated, legs up, top over him |
| LEG ENTANGLEMENT · RED ON TOP | yes | plausible — both seated, legs tangled |
| BACK CONTROL · RED ON TOP | yes | looks **inverted** — the other man is on top |
| KNEE ON BELLY · RED ON TOP | yes | **wrong** — the TOP man is flat on his back (twice) |
| CLOSED GUARD · BLUE ON TOP | **no** | both upright, top man's feet off the mat |
| LEG ENTANGLEMENT · BLUE ON TOP | **no** | both upright, top man floating |

Same build, same session, so this is an **intermittent solver result, not a
missing pose**. The agent reached the same place independently and is
instrumenting it ("I need hard data on which stage sinks the bodies").

One caveat on its own current conclusion — it wrote *"Two bugs, both in fighter
generation, not the renderer."* The name collision is real (one play-by-play used
three identities for two men: "The Boa Constrictor", "Nowak", "Fischer", plus
"Santiago Nowak"), but knee-on-belly putting the top man supine, twice, is not
fighter generation.

## Pacing — the operator's "it keeps resolving fights in fast forward"

The speed control is a beat interval and nothing else:
`2200 Slow / 1500 Normal (default) / 900 Fast / 420 Blitz` ms. A beat consumes
**~3.8 match-seconds** (8, 0, 0, 6, 9, 0 across six logged beats). So:

- **Normal ≈ 2.5x real time** (the default, what the operator is watching)
- **Slow ≈ 1.7x** — the slowest offered, still faster than real
- **Blitz ≈ 9x**

Raising the interval cannot reach real time; the per-beat clock advance is the
lever.

## Two things this check got wrong first, recorded so the next one does not

1. **A "frozen" clock was a finished match.** Clock, score, label and pose sat
   unchanged for 20 s and that read as a stall. The play-by-play said
   *"…rolls into the Straight Ankle Lock — …fights it, then taps!"* — it had
   ended by submission. A control built on that window (21 s of identical pose)
   was measuring a post-match final frame and proved nothing.
2. **"Ground positions render standing" was far too broad.** It was drawn from
   two samples; most positions reach the floor. The honest claim is the table
   above.

## How to re-check

Read the version first — if `saveCount` is still 4, the saved build has not
moved and only the agent's unsaved buffer has. Then run a match on
`https://perchance.org/gro5f7k2s5` (no `#edit`), sample the label plus the view
every ~8 s, and orbit the camera: a pair that reads as contact from one angle
and as two men in separate rooms from another is framed, not solved (C137).
The generator runs in a cross-origin sandbox iframe
(`d87df8f9b09bf4585f68e208a8a05406.perchance.org`) whose JS is unreachable from
the parent and which will not load standalone — screenshot the run page, or read
`outputTemplate` from the editor tab.
