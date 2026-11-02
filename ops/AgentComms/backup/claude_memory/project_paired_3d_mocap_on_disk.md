---
name: project_paired_3d_mocap_on_disk
description: "38.1 minutes of TWO-FIGHTER 3D motion tracked on the operator's PC - 17 videos, 98,136 two-person frames, world landmarks in metres - and MEASURED 2026-09-21 as usable for STANDING only: do not retarget ground from any file"
metadata: 
  node_type: memory
  type: project
  originSessionId: 56edf8be-ac8b-4ac2-94d2-319c9564c9cf
  modified: 2026-09-21T18:02:36.648Z
---

**The asset nobody knew we had.** `Tools/footage/track_pairs.py` (Claude, 2026-09-14) was written to
measure scalars — turn rates, kick commit times — and it has been saving full 3D skeletal data the
whole time. Measured 2026-09-21 over
`C:/Users/user/AppData/Local/Temp/FightCamp-footage/track/*.npz`:

- **17 tracked videos, 98,136 two-person frames = 38.1 minutes of paired motion.**
- Each `.npz` holds `world (F, 2, 33, 3)` — **33 joints in METRES, hip-centred, for TWO people,
  every frame** (MediaPipe `pose_world_landmarks`) — plus `img (F,2,33,5)` with pixel x/y, z,
  visibility and presence, and `t`, `n`, `fps`, `size`.
- Cleanest three: `-vPZqptk8jo` (118.7 s, vis **0.898**), `HL261oRyURE` (105.8 s, 0.882),
  `FCM7m6TJWUQ` (50.5 s, 0.877). Worst run 0.480–0.732. **Prove anything on the clean ~4.5 minutes
  first.**

**Why it matters:** every other route to paired ground animation has been measured and failed —
text-to-motion returned ONE BODY in 8 of 8 generations and never reached the floor, composing two
generated halves scored 0/36 ([[project_higgsfield_mma_study]]), authoring from nothing is animator
hours never spent, and buying depends on a SKU nobody has found. **This is two real fighters,
tracked together, already on disk**, and the operator's 2026-09-20 ruling — *"i dont mind too much
if some body parts intertwine but the movements need to be accurate"* — makes footage-derived
motion the right shape: accurate by construction.

**THE ANSWER CAME BACK 2026-09-21 AND IT IS "STANDING ONLY". DO NOT QUOTE THIS
MEMORY AS A GRAPPLING ASSET.** U112 delivered `PAIR_WORLD_v1` and measured the
placement error. Its own verdict, verbatim:

> **Do not retarget ground from any file yet** — depth error exceeds ±0.5 m when
> hips are below knee height.

> **Not usable for:** ground grappling (hips near floor — height-in-T proxy
> fails), clinch with heavy occlusion, or any shot where ankles are invisible.

Even on the cleanest standing clip the error is **±0.15 m horizontal / ±0.35 m
depth / ±0.08 m vertical at p90**. A grip in the CMU fixture is 0.099 m, so the
depth error alone is 3.5x the quantity being reproduced, and past 5x on the
ground. Nine of the seventeen videos DO contain ground work — that is the
unusable half, and more footage cannot fix it because it is a property of
monocular tracking through occlusion, not of the sample.

**USE IT FOR:** standing exchanges, footwork, punches and kicks where hip
separation > 0.8 m, from `-vPZqptk8jo`, `HL261oRyURE`, `FCM7m6TJWUQ`,
`wzUWvsviqTM`. That is genuinely valuable and it happens to serve the LARGEST
single hold gap — Q114 ranks `grapple_clinch_engage` (3.8%) top, and it is
standing.

**I got this wrong in chat on 2026-09-21** and told the operator this corpus was
"more central than I made it sound" for grappling, having not re-read U112
before saying so. The correction changed a spending recommendation. Read the
digest, not the headline frame count.

**THE ONE HARD PART, and it is the whole task:** `world` is **hip-centred PER PERSON**. You get each
fighter's pose and NOT where the two stand relative to each other. That must be reconstructed from
`img` (pixels + MediaPipe's rough `z`), and the honest lever is that the same person's `world` size
in metres over their `img` size in pixels gives a per-person per-frame scale — a monocular depth
estimate you do not have to invent. Both men share a floor, which is a free constraint.

**How to apply:**
- Assigned as **TASK_U112 to Cursor** 2026-09-21 (branch `cursor/u112-video-motion`), split so the
  extraction half needs **no Godot** — which mattered because Godot was hard-crashing that night.
  The rig/retarget half belongs to Codex, who found that retargeting discards attacker hip travel.
- **The operator corrected me on this:** motion *capture* was ruled out (2026-09-14, "i ruled out
  motion capturing not motion matching") and that meant suit-and-studio. **Video mocap is not ruled
  out.** The Unity EULA 2.2.1.1(g) AI-training clause covers uploading BOUGHT STORE ASSETS, not
  YouTube footage, so it does not apply here.
- Two men intertwined on the ground is the worst case for markerless tracking (occlusion) — the
  same wall Higgsfield hit. Expect standing work to be usable well before ground work, and make the
  deliverable say **which videos serve which**.
- See [[reference_pc_footage_tools]] for the download/track pipeline and the delete-after rule.
