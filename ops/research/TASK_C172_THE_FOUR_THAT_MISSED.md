# TASK_C172 — THE FOUR HOLDS THAT MISSED, THEN THE CLINCH'S WORST CONTACT

**STANDING TASK. Owner: codex.** Assigned S59, 2026-09-23. Operator, same day:
*"this is priority, codex needs to start doing the animations"*.

**Model: `gpt-6-astra`, medium effort** (3D animation design, operator ruling
2026-09-21). Started from the desktop app? Pick the model BY HAND - the app
falls back to `gpt-5.6-sol`.

## Owned files

- `Tools/cascadeur/` (build scripts, helpers, working dirs) - yours.
- `Godot/tools/s31_contact_probe.gd`, `Godot/tools/render_paired_hold.gd`,
  `Tools/paired_contact_sheet.py` - fix if a hold breaks them; never widen a gate.
- `Godot/scripts/FightClipBinding.gd` - `PAIRED_STRIKE_BINDINGS` entries only.
- `Godot/assets/anim/audition/cascadeur/Cascy_*.glb` - your exports.
- `research/C172_DIGEST.md` - new, appended PER HOLD.

## HOW TO WORK: C171's LOOP, BOUNDARIES, GATE, RENDER AND READ SET, UNCHANGED

Read `research/TASK_C171_THE_HOLDS_UNTIL_DONE.md` from "THE LOOP" to the
end and apply every section of it as written: declare contacts first, author,
export, bind, gate, RENDER AND LOOK, one hold one commit, one `agent_comms.py
send --from codex --to claude --subject C172` line AFTER EVERY HOLD, fix what
is yours, skip what is not, stop the run only on a hard control. Hard controls
are unchanged: RamsterZ `0.302639 / 0.304671`, clinch 15% or better, side
control 14.8173% or better, **and now also mount / turtle / open guard / 50/50
no worse than your C171 numbers** (11.19%, 21.53%, 11.88%; mount per your
digest). Test tier as C171: parse gate, `--only clip`, `--only grapple`,
`--only pair` (7/1, `fight_pair_live` PARKED), `--only technique_id`. NEVER the
full suite. Do not fetch or rebase.

Also read your own `research/C171_DIGEST.md` - it is the record of what
you already tried on each of these, and **repeating an attempt that already
failed is the one thing this task forbids.**

## THE QUEUE - every item is a hold C171 SKIPPED, so each needs a DIFFERENT approach

| # | id | C171 result | why here |
|---|---|---|---|
| 1 | `bjj_guard` Closed Guard | ankle lock 59.6% -> 46.0% | **27.3% of all ground time and still no clip** - the biggest hole in the game |
| 2 | `bjj_front_headlock` | 30.4% -> 36.2% | the nearest miss; attempt 1 was 0.4 points off the ceiling |
| 3 | `bjj_north_south` | 39.8% -> 33.4% | improving between attempts - a third, different idea may land it |
| 4 | `bjj_knee_on_belly` | knee 65 cm off the belly | the render did not read at all; start from the position, not the numbers |
| 5 | clinch worst contact | `vic_rhand_to_att_larm` **34%** | above the 30% ceiling since C167, hidden under the tracked 15% headline |

**For each of 1-4, write in the digest BEFORE authoring: what C171 tried, why
you believe it failed, and what is different this time.** Two honest NEW
attempts, then skip - exactly C171's rule.

## TRAPS

- **closed guard** - a SAME-BODY ankle lock whose drift is RELATIVE to a short
  segment can explode on a small absolute miss. Before a third pose, measure
  the ankle gap in cm on source and target: if the target rig's legs are too
  short to close around the top man's waist at his proportions, no pose fixes
  it - a broken-down top man (chest low, waist narrower between the legs) is a
  legitimate closed guard and may be the pose that closes. If the miss is the
  retarget and not the pose, record the evidence and skip - do not edit
  `FightClipRetarget.gd`.
- **knee-on-belly** - 65 cm is not a drift, it is a different position. Check
  that `_Att`'s knee is declared on `_Vic`'s abdomen bone and not his pelvis or
  chest before you move a single joint.
- **item 5** - the fix must not move the tracked `att_lhand_to_vic_neck` off
  15%. Report BOTH numbers, and the probe's own `worst=` line.

## HOW THIS ENDS

Queue empty or every item attempted and recorded. Final line: authored,
skipped, worst accepted drift, worst overall.

## REFERENCE FOOTAGE - OPERATOR, 2026-09-23: "i want the videos to go to codex too"

Two real-looking two-fighter videos (Higgsfield Seedance 2.0) are in
`research/_captures/ground_video/`. **Look at them before you pose a
ground hold: they are what a mount with ground-and-pound LOOKS like, and C171
posed every hold from nothing.**

- `mount_gnp_2human_locked.mp4` - 8 s, one locked camera. **The good one**: a
  correct full mount, top man's knees wide and low, and the bottom man shelling
  up, turning his head and bucking - the defender half we have never had.
- `mount_gnp_3cam_v1_REJECTED.mp4` (+ `_sheet.png`) - three camera angles, and
  **REJECTED**: shot 1 reads as guard, not mount, and the bottom man's identity
  drifts across cuts. Use it for body shapes from above only, never as a
  reference for the position itself.
- More angles are being generated; new files land in the same folder with a
  line in `README.md` there saying which are accepted.

**A TRACKER EXISTS for pulling poses out of them** -
`python Tools/footage/track_pairs_rtm.py <video> <out.npz> [max_frames]`
(RTMDet boxes each person, RTMPose 17 COCO keypoints per box, 2D PIXELS). It
finds both men on 100% of frames of the locked clip. Known limits, do NOT treat
them as solved: limbs swap between the two skeletons in some frames, crowd
beyond the fence shows up as extra people (filter by box size), and it is 2D -
metres come from MediaPipe on RTMDet's crop, which got the bottom man on 55%.

**HOW TO USE IT HERE:** as the starting pose for a hold, and as a check on
your render - put your four-view sheet next to a frame of the video and say
whether it is the same position. It does NOT replace the contact probe gate.
**Today's footage shows MOUNT only** - compare your C171 mount against it
first. A per-hold video (closed guard first) is the next thing Claude
generates; do not pose closed guard from the mount clip.
