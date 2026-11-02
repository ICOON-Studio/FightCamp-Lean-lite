---
name: project_perchance_bjj_3d_probe
description: "CLAUDE DRIVES IT NOW (operator handed it over 2026-09-22). Two bodies DO hold contact, pose identity FIXED at saveCount 5, and a CAGE/FENCE task is in flight. Generator is gro5f7k2s5 (NOT z1eu8lywkp)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 9e3da6ad-2507-4165-a508-3ceb3183e36d
  modified: 2026-09-21T21:12:28.383Z
---

**CLAUDE OWNS THIS NOW.** The operator closed their own tab and said *"take it
over"* (2026-09-22) — drive it end to end from the Chrome extension, no
pasting. **Only ONE tab may hold the AI conversation**; the traps that cost six
send attempts are in [[feedback_chrome_extension_traps]] and must be read before
touching it again.

**STATE AT HANDOVER: rev 10 / saveCount 5, saved 2026-09-22 00:56 by Claude.**
The agent had run **54 minutes without saving** — everything lived in the
editor's local draft and would have died with the tab. **So: if the agent has
stopped and the version has not moved, SAVE IT** (the `save` control in the
editor's top bar; verify `saveCount` bumps afterwards).

**THE POSE-IDENTITY DEFECT IS FIXED.** At saveCount 4, knee-on-belly put the
TOP man flat on his back and some ground positions never left their feet. At
saveCount 5, side control renders correctly (bottom man supine, top man
perpendicular across his chest) and knee-on-belly is right across three
consecutive samples. It also gained **Pause / Step / Replay** and an orbit
camera, which answers the operator's "it keeps resolving fights in fast
forward".

**IN FLIGHT: the CAGE and the STANDING WRESTLING CHAIN.** Asked for an
octagonal/circular cage with the mat kept as a selectable alternative, plus
cage clinch / wall wrestling, body lock on the fence, a fence-assisted takedown
defence, and the eight standing positions (collar tie, double collar,
underhook, over-under, double-leg with head OUTSIDE the hip, single-leg with
head INSIDE, sprawl, front headlock). **The framing that made it work: the
fence is a THIRD CONTACT SURFACE** — a vertical plane the existing penetration
machinery extends to, with fence violations reported separately from mat ones.
It started immediately, adding a `kind === "fence"` branch to the grip sweep.
**Cage clinch is the one position our own record says cannot be bought at any
price, so if it solves it, that is the headline.**

---

**THE QUESTION IS ANSWERED: YES.** The probe asked whether anything can hold two
bodies in contact without interpenetrating. On 2026-09-22 the saved build
rendered **mount**, **open guard** and **leg entanglement** as two bodies in
contact ON THE MAT — supine bottom man, top man over him, no visible
interpenetration. That is a third data point AGAINST the pessimism of
[[project_higgsfield_mma_study]] (one body, 0 of 36), not for it.

**THE URL IS `https://perchance.org/gro5f7k2s5#edit`.** The `z1eu8lywkp` id this
memory used to carry is a DIFFERENT, earlier generator — do not go back to it.

**Read the server truth, never a screenshot:** `__fetchGeneratorDataVersion()`
in the page console returns `{editorPayloadRevision, lastEditTime, saveCount}`.
At the 2026-09-22 check it was **rev 8, saveCount 4**. The agent's on-screen
preview is its UNSAVED BUFFER and runs ahead of the server — the preview showed
a correct side control while the saved build did not have it. Compare the
version before comparing behaviour, or you will report the wrong artefact.
The generator itself runs in a cross-origin sandbox iframe
(`d87df8f9b09bf4585f68e208a8a05406.perchance.org`), so its JS is NOT reachable
from the parent and the iframe URL will not load standalone — drive it through
screenshots of the run page, or read `outputTemplate` from the editor tab.

**What is built:** 267 KB, 181 functions — a jointed rig (`buildRig`,
`applyJoints`, `fkBody`), capsule collision (`segSeg`, `capSpheres`), IK
(`limbIK`, `alignDistal`, `placeContacts`) and a projection solver (`fitSolve`,
`projSolve`, `fitShapeMatch`). Two bodies named `top`/`bottom`. Plus a full
sim layer: stats, belts, teams, records, play-by-play, IBJJF rules, a timer.

**THE OPEN DEFECT IS POSE IDENTITY, NOT CONTACT.** Across seven sampled ground
positions on one saved build: mount and open guard correct; back control looked
inverted; **knee on belly put the TOP man flat on his back, twice**; and closed
guard and leg entanglement sometimes never left their feet, both men upright
with the top man's feet off the mat. Same build, same session — so it is an
intermittent solver result, not a missing pose.

**Pacing, measured:** the speed control is beat interval only —
`2200 Slow / 1500 Normal (default) / 900 Fast / 420 Blitz` ms — and a beat
consumes ~3.8 match-seconds. So Normal ≈ 2.5x real time, Slow ≈ 1.7x, Blitz
≈ 9x. Real-time pacing needs the per-beat clock advance cut, not the interval
raised. The operator raised this as "it keeps resolving fights in fast forward".

**How to apply:** the operator's standing instruction (2026-09-22) is to CHECK
PROGRESS EACH NEW SESSION and leave the file to its agent — do not edit it, two
writers collide. Read the version first, run a match, orbit the camera (a pair
that reads as contact from one angle and as two men in separate rooms from
another is framed, not solved — C137's lesson), and note which named positions
rendered correctly. Related: [[reference_paired_grappling_market]],
[[project_paired_3d_mocap_on_disk]], [[project_contact_solver]],
[[project_session_log]].
