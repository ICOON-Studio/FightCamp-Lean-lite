---
name: reference_cmu_paired_mocap
description: "CMU has free frame-synced two-person mocap with a permissive licence; 18/19_05 is the anchor-validation fixture, and there is NO martial arts in it"
metadata: 
  node_type: memory
  type: reference
  originSessionId: b3c5acff-9983-4ea6-a25e-39535f5691fa
  modified: 2026-09-21T11:17:29.769Z
---

`mocap.cs.cmu.edu` — **licence, verbatim from `faqs.php`: "The motion capture
data may be copied, modified, or redistributed without permission."** No
commercial restriction, no attribution clause, no registration. Its two
disclaimers are about data QUALITY, not rights. This is the permissive one.

**A two-person capture is exported as TWO SUBJECTS SHARING TRIAL NUMBERS** —
subject A is one subject id, subject B is the next. That is the "two separate
skeletons" shape a paired/anchor pipeline needs.

| pair | theme | useful trials |
|---|---|---|
| **18 / 19** | human interaction and communication | 03, 04 "A pulls B; B resists"; **05, 06 "A pulls B by the elbow; B resists"** |
| 20 / 21 | at play, formations | link arms + walk, hold hands |
| 22 / 23 | human interaction | 01 "B sits; A pulls up B", 17 "rush up, arm wrestle" |

**`18_05` + `19_05` IS THE FIXTURE**: 438 frames each, frame-synchronised,
sharing one world space, root separation min **0.77 m** — clinch range against
Q115's independently measured 0.719 m hip-to-hip. A sustained grip under active
resistance is the mechanical core of grappling.

**THERE IS NO MARTIAL ARTS IN CMU.** Keyword `martial` returns nothing; `wrestl`
returns one hit and it is ARM wrestling. Useful single-person extras: **`17_10`
is "boxing"** (subject 17 is "different walking styles", not Wushu).

Downloaded to `AssetLibrary/cmu_paired/` (7.5 MB, ASF/AMC — needs conversion
before `FightClipRetarget` can read it). Full measured inventory in
`research/R155_CMU_PAIRED_GROUND_TRUTH.md`.

**AMASS and SFU are NOT equivalent**: research databases whose constituent
datasets commonly carry non-commercial licences. Neither licence has been read.
See [[feedback_assess_pasted_recipes]] and [[project_paired_3d_mocap_on_disk]].
