# S130 digest (2026-09-30, Claude) - the rear-hook clipping is placement, not clips; SW1; ops-board Animations page

Nightly cited at start: `AgentComms/nightly/latest.txt` 2026-09-29 at 9b143308, suite 459 / 20 fails (the 09-30 run had not
fired - session opened 00:14). HEAD at start c2505cfb (S129's post-handover note, not ours).

## 1. What now works
- **SW1 fixed** (e0caa490): `git bisect 9b143308..14b99a99` in a detached worktree (D:/FightCamp/wt/SW1), probe = the
  test's own OFF hash. First bad = **3e66fc46** (S127 result clock): it adds `round_seconds` + `rest_seconds` to a STOPPAGE
  result; the boxing bout ends in a stoppage, the mma bout on a decision (its hash never moved). Events unchanged: HEAD with
  those two keys erased hashes 96d0c1f3 (the S118 pin) again, so S123-S129 kept the OFF stream byte-identical. Re-pinned
  boxing 5c14146d; fight_strike_whole_test 3800 checks, 0 failures.
- **Ops board `/animations`** (operator 09-30: "a list of the animations for movement and boxing ... which are ready or
  not ... watch the animations from the opsboard"). `Tools/anim_catalogue.py` DERIVES each status (certified_moves.json,
  FightClipBinding, newest C223 report - probe runs flagged); `Tools/anim_previews.py` encodes gate `video` frames to
  `previews/anim/<id>.mp4`; server serves `/api/animations` + `/media/` (docs/previews only; traversal 404).
  54 animations: 21 CERTIFIED, 14 IN GAME (walks, reactions, block - not C223-gated), 9 NO CLIP (footwork plays the guard
  idle), 10 NOT READY. Videos: the 14 certified single moves + defences + guard idle; walks/reactions rendering (section 5).
- **Meshy clips enter pipeline A**: `c223_mixamo_adapter.gd glb=1` reads Meshy GLBs (spine numbered from the top; `neck`)
  and scales the cm rig by its armature (0.01) - the bind-pose rest in metres against cm keys had given 0.1-0.8 m/s fists.

## 2. The rear hook: root cause found, fix needs the operator
Every rear-hook source clipped the SAME way - Mixamo Boxing_Back_Hand_Hook (bound), RamsterZ (mirrored), the Meshy library
Right_Upper_Hook, QuickMagic T2M (2 takes, 24 QM credits): LEG 5-15 cm, thigh vs thigh. q213 now records WHERE capsules
meet (`worst_where`): **sa=1.00 sb=1.00 - knee to knee, both lead knees within 4 cm of the centre line**. Our fixture (and
the live room) stands the men exactly nose to nose; at hook range their lead knees meet. Anchor offset (Q217's lead ankle
+8/+14 cm) plateaued at 4.6 cm - the knee is not where the ankle moves it. Hip yaw layers: worse (-12) or mixed (+12).
- Probe `lateral=<u>` (opponent stands off-line toward his lead side; rows record `fixture_lateral_m`):
  `s130_hooks_lat16.json` (0.16 u = ~10 cm real): **boxing_rear_hook 4/4 and rear_hook_body 4/4 pass every measured row**;
  shovel_hook still 2.7-5.8 cm (its lead knee drives in). Stills (s130_lat16_*): the **rear foot lifts off the floor
  mid-punch** (Mixamo source + hold_root) - needs a rear-foot plant before the stills pass.
- The Meshy rear hook is a STEP-IN hook (hips travel 77 cm): under hold_root the rear leg flies back - not certifiable.
- DECISION ASKED (operator, scope/visual): stand fighters ~10 cm off-line in the room + gate, re-certify the 17-move palette
  under it, then rear-foot plant + certify rear hook / rear body hook. Not built until he answers.

## 3. Credits (operator: "spend what is left so the refill gives more", then "reset the balance")
Higgsfield: 136 subscription credits spent first, then the free reset (+1,000 bonus, expiring 10-01 00:00 UTC) claimed in
his Chrome. All spent (1.55 left); manifest `D:/FightCamp/meshy_lib/jobs.json`:
- 45 Meshy library clips on our MPFB man (`3d_rigging` 8 cr; carrier = mpfb_male_pilot.glb uploaded as media 2db199e0):
  hooks/uppercuts, 6 punch combos, counters, 4 face/body reactions, 2 knockdowns, 9 blocks, 4 dodges, guard/stance, and for
  the MMA update 5 kicks, knee, elbow, 2 sweeps -> `D:/FightCamp/sources/meshy/` (2 jobs failed, refunded).
- 15 Seedance 2.5 single-boxer videos (5 s, locked camera, whole body; rear hook, body hook, shovel, inside uppercut,
  check hook, 1-2-hook, jab body-head, liver combo, slip counter, six-punch) -> `D:/FightCamp/sources/higgsfield_video/`.
- 7 suit-route grappling videos from checked stills (segment-colour suits, 1x2 synced views; mount GnP, back-mount RNC,
  half guard pass, double-leg, cage clinch, knee on belly, armbar; side control refused as NSFW) -> `.../grappling/`.
QuickMagic: 24 (rear hook T2M) + 16 (two-person test) = 40 of 183; 143 left.

## 4. Operator questions answered
- MoCap Online: in the record (G58/J17/J18, D25) - single-body real mocap, Standard licence <=1M users/$1M; not for the
  demo (standing no-purchase ruling; tonight's hooks were placement, not clips).
- Grappling via Higgsfield: the suit route IS that; the missing link is two overlapping bodies -> two 3D skeletons.
- Kesting RNC tutorial / Grapplearts apps: a technique library and the best-case real footage for the two-person test.
  Operator ruling: copyright of reference footage is "irrelevant to us" (memory saved).

## 5. Collected before ship
- **Previews: 35 clips + 1 real fight on /animations.** Certified singles + defences + guard (production gate `bound render
  video`), 8 walks + 5 reactions + block (`bound render video` WITHOUT `phase` - `phase` needs a guard-matched transition
  those roles lack: SCRIPT ERROR "Invalid access ... 'entry_s'"; the stalled run read ~0.15 core and wrote nothing), the 6
  certified chains (sequence gate, new `video`). Operator: "why no reaction on the opponent" - the certification view holds
  him still ON PURPOSE (one clip judged at a time); the page now says so, and a REAL FIGHT recording leads the page:
  `tools/record_room.gd ... --write-movie ... -- discipline=boxing seed=92012 as_game` (45 s, reactions + camera director),
  `docs/previews/anim/live_boxing_seed92012.mp4` (1.6 MB; original D:/FightCamp/videos/live_boxing_seed92012_s130.avi).
- **QuickMagic two-person test** (Grapplearts footage, `D:/FightCamp/videos/grapplearts/QM2P_*`): clip 1 guard pass - BOTH
  men detected and BOTH skeletons out in one shared space (16 cr; kneeling passer vs seated guard, facing each other) - the
  first time the two-body link worked on real footage. Download awaits the operator's OK (then: both FBX through the
  adapter, overlap check in our pipeline). Clip 2 side control - ONE merged detection: QuickMagic detects on the FIRST frame
  only, wrapped bodies = one person; not run. Clip 3 not uploaded (same failure expected).

## 6. Process notes
- Q217d collected: STUCK (bd329259). Only its `lock_foot anchor_offset` (5 lines) was taken, by hand, as my change, and
  ramped by the lock weight (a full offset on the first blended frame is a pop). `check_workflow.py branch
  qwen/q217-close-range Q217` = 19 defects (FootPlant + previews outside owned files) - the branch is NOT merged; its
  binding edits (incl. a Spine/Hips layer on the certified lead uppercut) were NOT taken.
- A render that reads ~0.15 core and writes nothing has died on a SCRIPT ERROR (memory rule held again).
