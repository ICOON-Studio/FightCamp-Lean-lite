# S264 ZIVAMOTION1 — handover (branch `ziva/playtest`, worktree `E:/FightCamp/wt/ZIVA`)

Every item has a red-first measurement committed. This file is the map: what is fixed, what is measured but not fixed, the
exact command that re-prints each number, and the two decisions that are not a machine's to make.


# S267 (TASK_ZIVAMOTION2) — items 1 and 2 landed with numbers; ITEM 3 NOT STARTED

| commit | item | what it did | red -> after |
|---|---|---|---|
| `c8dee364` | #2 the grapple-release collapse | at f627 the pair is a MOUNT BLEND just started (`mount t=0.03`, clips `idle\|idle`, `_placed=INF` from `_release_grapple`): both bodies are handed the grapple's shared anchor (drawn 0.048 m against the engine's 0.994 m) and interpolated apart over 0.25 s, while the straightener is excluded for the blend AND runs before it. Now the SEPARATION runs again after `_tick_mount_blend`; plus `_landed_strike_prefix` teaches the census the exemption the room already grants a landed kick's leg / punch's hand | test (seed 810039 MMA as_game): **leg=leg 0.3180 at f627 -> gone**; head=head 0.1443 -> 0.0708; hand>head 0.0732 -> 0.0206 |
| `2faefab0` | #1 overlap without skate | the separation gives the WHOLE push to the body whose feet are FREE (`FightStagePlayer.foot_pinned()`); a pinned foot cannot be dragged by it. Both pinned/both free keeps the even split | planted **p95 204.8 -> 34.7 mm** (target <= 40 met), over_gate 12/54 -> **7/56**, mean 26.0 -> 14.1; overlap census 192 (16.0%) -> **172 (14.3%)** frames, p90 0.0450, worst 0.2705 -> 0.2814 |

**ITEM 2 IS STILL RED, with its numbers** (seed 810039 MMA as_game, this build): `arm>leg` **0.2984 m** and `torso>leg`
**0.2881 m** at **f477-478** — a `kickboxing_low_kick` **IN FLIGHT** (`_landed_strike_contact_alpha` is 0 before contact, so
the landed-strike exemption cannot reach it): the swinging shin passes through the receiver's raising arm and torso.
`head>arm` **0.1493 m** at f575 and `head=head` **0.0708 m** at f550 are grapple/clinch frames (drawn 0.000: the paired
clip's own pose is the anchor). Next lever: an in-flight kick clearance (move the RECEIVER's fixed arm off the incoming
line, or exempt pairs the striker's in-flight effector limb will cross within the take's contact window).

### S267 round 2 (Claude's A/B/C) - all three landed

| commit | item | red -> after |
|---|---|---|
| `43ab7b0c` | (A) the landed-strike exemption narrowed to the effector's own chain | side-wide prefix -> `_landed_strike_limbs` (hand: Hand/LowerArm/UpperArm; foot: Toes/Foot/LowerLeg/UpperLeg) + `part_exempt`, shared by room/readback/test. Census seed 95501 boxing 1200 frames: 172 (14.3%) -> **166 (13.8%)** frames, worst 0.2814 -> **0.2472**, p90 0.0450 -> 0.0414, no drawn-gap collapse |
| `9568c565` | (B) the corner's live clock | **GAME BUG FOUND AND FIXED**: `CornerPitStopPanel` ticked its live clock from its own `_process`, so any hand-pumped arm (tests/probes) froze `corner_holds_clock()` at round 1's 3:01 forever (measured: corner=true steps 200-1100, no round 2, no FIGHT OVER). Room now ticks it (`_tick_corner_clock`, `room_drives_clock`). Bout ends at **step 653/800** as_game (784 s incl. real-time corner breaks); test MAX_STEPS 600 -> 800 from that measurement; footwork floors: the shipped arm presents ZERO footwork-type beats (beats 272, played 249) - a population fact made gateable by the new `counts.footwork`, floors became counter<->readout invariants; plain arm 23/0 (carried 3, stanced 3, footwork 6) |
| `a467e1a0` | (C) boxing stills ON vs off=overlap_in_takes, seed 95501 | `docs/previews/s267_gate/{on,off}/{guard,mid,contact}.png`; report per still in the commit. Most visible difference at the crowded moments: OFF draws the pair 3.7-4.2 cm INSIDE the engine's gap with B's lead shin crossing A's rear leg at the trunks' hem (mid), ON keeps the lunge +7.6 cm out and the legs clear; contact frame identical in both arms (drawn 1.197 vs engine 0.845 - the take's own hold) |

**FOUND BESIDE MY WORK, NOT MINE (proven: identical failures with my diff reversed):** `corner_pit_stop_test` (8 fails) and
`corner_wired_test` (4 fails, incl. "switch OFF offers the original six calls (8)") are RED on master as_game - flagged for
whoever owns the corner content.

**MMA stays parked** per Claude: fight_body_overlap_test's remaining red = the in-flight low kick (arm>leg 0.2984 at
f477-478; the landed-strike exemption only reaches a LANDED strike and `_landed_strike_contact_alpha` is 0 before contact).

**ITEM 3 NOT STARTED** (`fight_world_live_test` as_game): footwork beat readouts read 0 and the bout does not end inside
600 steps. Starting evidence to collect: `footwork_stats()` (`events`/`scheduled`, the room's own counters) vs what the
test reads, and whether the engine's schedule still emits `type == "footwork"` steps (U197 `_schedule_footwork`); decide
game bug vs retired route from those two numbers before touching `FightRealtime.gd` (not mine unless proven the cause).

**S267 tool note:** `probe_body_overlap.gd` re-committed the S58 false witness in its S266 repair — after the deferred
`run()`, `add_child` fires `_ready` -> `setup()`, so `configure` REFUSED and the S266 "off" arm measured the shipped config
twice. It now configures BEFORE `add_child` and checks the refusal (prints PROBE BAD), and prints the pair's state on hot
frames (grapple key, mount blend, both clips, `_placed`/`_overlap_sep_m`/`_axis`, first drawn-gap collapse frame).

# S266 (this session) — the session the operator got a video in, then the overlap defect out of it

| commit | what |
|---|---|
| `99725ede` | merge origin/master into ziva/playtest (Claude's c41c1ed5 released-arm 0.255 m + 501300fe wrist cap + MHTWIST1 kept beside all four of mine; only conflict was master's older copy of THIS file — took ours). 12/12 guard/plant/join/head tests as_game. |
| `de9afc96` | **THE OPERATOR'S VIDEO** `previews/s266_ziva_video/ziva_before_after.mp4` (8.0 MB, 30 s, H.264 1280x720, label burned in): 15 s of the live boxing fight as_game recorded twice through tools/record_room.gd (seed 95501, shot=broadcast, 450 frames each), BEFORE = off=foot_repin,join_default,head_level,guard_ramp_clip, AFTER = all ON; ffmpeg-concatenated BEFORE-then-AFTER. Three frames of the finished mp4 opened and checked (labels, both men head to feet, feet on canvas, gloves in front of faces). The room's movie writer ignored --resolution (frames come out 1920x1080) and the bundled ffmpeg has NO AVI demuxer — the AVI's MJPEG payloads were extracted with a RIFF walker (`/e/FightCamp/tmp/s266_video/script/avi_dump.py`) and fed back as a JPEG sequence. |
| `4c48df12` | #1 residue ACCEPTED as the contract's tolerance + #4 ships as is — written into TASK_ZIVAMOTION1.md with the numbers (3 of 64 vs red 4, 3 reversals, POP_ADDED 81.3 vs red 118.4; head 104.6 -> 81.6 deg) so they are never re-litigated. |
| `607f49fe` | #3 PUNCH LOAD behind switch `punch_load` (GAME_ON): wind-up 6 deg + pelvis 3 cm onto the lead foot, directions read off the live pose, envelope peaks at 0.10 s and clears. MEASURED red->ON: `pelvis_to_lead_mean_cm` 1.954 -> **2.360** (the weight shift measures), load_added 6.0 deg / lead_added 3.0 cm, `load_mean_deg` 1.49 -> 7.79, **`load_opposite` 39 -> 39 (NOT moved — open number)**, shoulder_over 2.372 -> 2.327, plant over_gate 10/56 -> 10/57 mean 32.66 -> 31.27, track_error 118.0 -> 118.3. Tests punch_load_test + 3 neighbours pass. NOTE: the two arms diverge (different runs), so a flat count is not evidence either way — the pass's own applied values are the in-run measurement. |
| `d5d432d6` | **#5 OVERLAP, the operator's visible defect** (both halves of the video show the men on ONE footprint ~5 s in): `overlap_in_takes` (GAME_ON) — `_correct_refused_overlap`'s SEPARATION runs during whole takes (a take owns its own hand; the hand pushes still stand down). Census through the REPAIRED U119 tool `tools/probe_body_overlap.gd` (it pumped before the room was in-tree — fixed to deferred + set_process(false); now prints part NAMES, per-pair histogram, whole-take split, top-6 worst frames with engine/drawn gaps, and can save stills through still_framing): **220 (18.3%) -> 192 (16.0%) frames over the 20 mm gate, worst 0.3104 -> 0.2705 m, p90 0.0671 -> 0.0435 m**; 176 of the 220 were IN-TAKE (154 after). Still pair `previews/s266_overlap/{red,on}/overlap_f0765.png`: red = two men on one spot legs interleaved, on = four feet in their own places. COST (paired motion census): drawn min gap 0.41 -> **0.73 m**, track_error 137.7 -> 119.9, root jumps 66 -> 161 drawn_other (worst still 75 mm), **planted p95 34.7 -> 204.8 mm** (over_gate 12 -> 13) — the separation drags a planted foot up to one 50 mm cap before the next frame re-pins. The trade knob is `OVERLAP_SEP_MPS`/`OVERLAP_SEP_MAX_STEP_M`, untouched. 8/8 tests pass. |

**NEXT SLICE for #5, named with its numbers:** the remaining worst pairs are LIMBS during takes — `arm>torso` 270 mm at
f=756 (drawn 0.351 m = the torso floor) and `head>torso` 243 mm at f=473. A separation cannot clear those and a hand push
must not touch a certified clip's hand — the fix is a take-aware limb rule (e.g. a capped arm push while the take plays,
or making the warp stop at a LOWER floor than the torso floor when the strike's target moved).

**Re-print this session's numbers:**
```
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/probe_body_overlap.gd --fixed-fps 30 -- as_game seed=95501 discipline=boxing frames=1200 [off=overlap_in_takes] [stills=<abs> still_frames=765]
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/fight_motion_probe.gd --fixed-fps 30 -- as_game seconds=40 seed=95501 [off=<switch>]
```

## Committed, in order

| commit | item | what it did | red -> after |
|---|---|---|---|
| `752c6f1a` | #2 foot plant | `FightStagePlayer.repin_needed` + switch `foot_repin` — a planted foot is bent back onto its own pin whatever moved the pose after the lock | plants over the 2 cm gate **34/56 -> 13/56**, mean 42.4 -> 32.6 mm, planted_skate 169/152 -> 159/140 |
| `e6f0d4a0` | merge master | boots, correctives, Claude's guard wrist cap — both guard changes kept | — |
| `7c78bfc1` | #1 guard pop | `default_row` + `REVIEW_DEFAULT_JOIN_S` 0.10 + switch `join_default`: an UNMAPPED take pair was a hard cut | clip teleport 496.8 -> **357.8 mm**, in-run layer pop 311.7 -> 118.3 mm |
| `35136a37` | #3 punch | census `FIGHT_PUNCH*` + RED baseline | shoulder_over 2.4 cm, pelvis_to_lead 2.3 cm, load_opposite 39/82; **recovery clause already GREEN (0.09 cm)** |
| `86d13926` | #5 spacing | census `FIGHT_GAP_STEPS`/`FIGHT_GAP_JUMP` + RED baseline | drawn gap a mean **120 mm** off the engine's; 273/1200 frames warp the roots > 20 mm |
| `02f0e8cc` | #4 head | census `FIGHT_HEAD_SUMMARY` + RED baseline (head/neck bones added to the probe) | `head_follow_k` 2.53, head_max 104.6 deg against a 61.8 deg torso |
| `b419a52e` | #4 attempt 1 | rotating the HEAD bone: BUILT, MEASURED, REVERTED, recorded | 2.53 -> 2.52 -> 2.53 (a no-op — see below) |
| `329d9d8e` | #4 attempt 2 | **TRANSLATION** pass, switch `head_level` | head_max 104.6 -> **81.6 deg**; head_follow_k 2.53 -> 2.43 |

## Do not re-try (measured dead ends)

- **A tighter stance/unplant radius** (#2): moved the gate 34 -> 32 of 56 and made planted_skate worse (321 -> 350). A
  tighter release lets go more often and every release is a pop. Record: `research/S263_stance_unplant_disproved.gd`.
- **Rotating the HEAD bone** (#4): **a bone's own rotation does not move its own origin**, and the measured segment is
  `neck -> HEAD BONE ORIGIN`. Only the NECK can change it, and S262 found the neck opens the MetaHuman head/body seam.
  Record: `research/S264_head_level_attempt.gd`. The working method is a TRANSLATION (`329d9d8e`).
- **A smaller `GUARD_IK_SLEW_M` alone** (#1): see the arithmetic below — the cap is not what stands between us and 5 mm.

## Re-print any number (probe is probe-only: the game never sets its members)

```
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/fight_motion_probe.gd --fixed-fps 30 -- as_game seconds=40 seed=95501
```
Prints `FIGHT_PLANT_SUMMARY`, `FIGHT_PUNCH*`, `FIGHT_GAP_STEPS`/`FIGHT_GAP_JUMP`, `FIGHT_HEAD_SUMMARY`. `off=<switch>`
(or `off=a,b`) is the red arm. Guard A/B stills: `tools/guard_lift_still.gd as_game out=<abs dir> [off=head_level]`.
Guard pop pair: `tools/guard_pop_compare.gd out=<abs dir> [off=join_default]`.

## #1 — the 5 mm gate is NOT reachable, and the cap is not the reason

Measured over the 31 release/return windows of seed 94301: the guard IK hands over a **median 328 mm, worst 614 mm**
correction while the weight timeline allows a 0.08 s release (2-3 frames). `POP_SLIP <= GUARD_IK_SLEW_M` by construction,
so the table is exactly:

| cap mm/frame | POP_SLIP bound | frames for the worst correction | median |
|---|---|---|---|
| 40 (today) | <= 40 mm | 16 (0.53 s) | 9 (0.30 s) |
| 5 (= the gate) | <= 5 mm | **123 (4.10 s)** | **66 (2.20 s)** |

So a 5 mm/frame hand-over is 2.2-4.1 s of visible lag — a different animation. The real lever is the CORRECTION SIZE:
the guard targets sit **33-61 cm** from the clips' own guard hands. Shrink that and a tight gate becomes affordable (a
30 mm correction releases in 6 frames at 5 mm/frame). **S265 — CLAUDE RESTATED THE GATE, AND THE GUARD STAYS.** `GuardPose.gd`'s targets are NOT to be shrunk (the operator
approved this guard, S264 "now this looks good"), and a 5 mm/frame displacement cap is the wrong instrument for a hand
that legitimately moves 100+ mm/frame. The contract is now: **across a release/return window the DRAWN hand's second
difference `|p[t+1] - 2p[t] + p[t-1]|` stays <= the CLIP's own peak second difference inside that punch, with no reversal
of the motion the layer adds.** `GUARD_IK_SLEW_M` (40 mm) and the join hold stay as they are. Both measures are read from
the guarded run alone (the drawn hand vs the clip's own pose in the same run), so the pair's divergence cannot touch
them; `POP_VERDICT_LEGACY` keeps the old cap for the record and no longer decides the exit code.

Measured, seed 94301, shipped switches (`head_level` ON), `dir=previews/s265_pop`:

| | before (`7c78bfc1`'s red arm) | after |
|---|---|---|
| `POP_JOIN` clip teleport (worst) | 496.8 mm | **357.7 mm** |
| `POP_ADDED` (the layer's own one-frame wrist motion) | 311.7 mm | **118.4 mm** |
| `POP_LAG` (wrist off the clip's path when the hand-over ends) | 306.3 mm | **193.4 mm** |
| `POP_SLIP` (the release pop the operator sees) | 46.5 mm | 46.5 mm |
| **`POP_CONTRACT`** (new) | — | **64 windows: 4 over the punch-level clip peak, 45 over the ramp-strict one, 3 reversed -> RED** |

The 4 over-contract windows are all fighter `b` (3 `return`, 1 `release`): `b lead boxing_jab t=10.800` curv 154.6 vs
clip 100.4 is the worst and is the same window the legacy gate flagged worst (`excess_mm` 90.95) - a consistent hot spot.
The 3 reversals are all fighter `a` on `return`, incl. `a rear boxing_jab t=19.567` (added 118.4 mm, the run's worst, and
still under the clip's own 174.4). So the contract is *nearly* met: 4/64 by its own wording, and the residue is fighter
`b`'s returns plus 3 direction reversals the curvature gate does not cover.

### What the residue actually is (estimated from the recording, NOT a run - see the note)

`60 of 64 windows are already inside the contract`; the 4 that are not need their ramp stretched only modestly (k =
1.10-1.54, median 1.18, where k is the ramp-length factor that brings the second difference under the clip's own peak).
The discriminating fact, and it **contradicts the earlier "shrink the corrections" recommendation for this residue**:

| | mean `hold_mm` |
|---|---|
| the 60 windows already inside the contract | 135 mm |
| the 4 violators | **121 mm** |

The violators are not the big corrections - they are **smaller** ones. What marks them is the CLIP being GENTLE at that
moment: the four violate where the clip's own punch peak is only 26-100 mm/frame^2 (`b lead boxing_jab t=10.800` is the
worst: layer 154.6 vs clip 100.4), while windows carrying 213-263 mm corrections sit comfortably inside because their
punch is violent (clip peak 96-133). **The hand-over's speed is roughly fixed, so it mismatches exactly where the clip
itself is slow.** The lever this contract points at is therefore an ADAPTIVE ramp (stretch the release/return by ~1.1-1.55x
where the clip is gentle), not smaller guard corrections - and the 3 reversals are all on inside-contract windows (`a`'s
returns: 32.4 vs 97.4, 125.6 vs 174.4, 43.9 vs 105.6), i.e. they are caught by the reversal clause and by nothing else,
so that clause carries real weight on its own.

Estimate caveat: `curv -> curv/k` treats the correction as given up over k times as long and ignores that a longer ramp
also lets the clip move under the hand, so the true k is likely SMALLER. Read it as a sanity range, then measure a real
run - do not quote these k values as a measurement.

### Rejected framing (kept so nobody re-derives it)

"Shrink the guard corrections" was **my** recommendation before this estimate. It stands as an *aesthetic* argument (a
third-of-a-metre correction means the glove sits where the clip never put it, and it costs the 193 mm POP_LAG), but it is
NOT what this residue needs: the four violating windows carry SMALLER corrections than most of the sixty that pass.

### The adaptive ramp, implemented (`f2e1ffb7`) - and what it did and did not fix

Claude approved it (S265). `guard_ik_slew` now takes the CLIP's own hand speed (`clip_speed_m`) and clamps the cap to
`clip_speed_m * GUARD_IK_SLEW_CLIP_K` (1.0) between `GUARD_IK_SLEW_MIN_M` (5 mm floor, so a still clip cannot pin the hand
forever) and `GUARD_IK_SLEW_M` (40 mm, the S263 cap, kept as the upper bound). No new instrumentation: `_guard_ik_clip_last`
already measures that speed each frame for the join hold (`clip_jump`). `clip_speed_m < 0` = the S263 fixed cap, so
`off=guard_ramp_clip` is the red arm. Tests: `tests/guard_clip_ramp_test.gd` + the pre-existing `guard_ik_slew`/`guard_ik_pass`.

| seed 94301, off vs shipped | red | adaptive |
|---|---|---|
| `POP_CONTRACT` over_clip_punch (of 64) | 4 | **3** |
| over_clip_ramp_strict | 45 | 43 |
| `POP_ADDED` worst | 118.4 mm | **99.0 mm** |
| `POP_SLIP` worst (the pop the operator sees) | 46.5 mm | **41.4 mm** |
| `POP_LAG` worst | 193.4 mm | 196.0 mm (the expected trade of a slower hand-over) |
| `POP_JOIN` worst | 357.7 mm | 357.7 mm (the TAKE's own wrist - untouched, it is the source) |

**CONTRACT NOT CLEARED: 3 windows over, 3 reversals.** The mechanism is vindicated (it broke the fixed cap's ambiguity
and it fixed a window) but the proxy is wrong in one dimension, and the residue says exactly how:

1. **All six remaining flagged windows are `return`s** - the three over-contract ones and all three reversals. The ONE
   window the ramp cleared (`b rear boxing_cross t=39.833`) was the only `release` among the four. So the release side is
   fixed and the **return** side is the remaining defect: taking the correction BACK (the guard pulling the hand home) is
   harsher than the clip's own motion where the clip is gentle.
2. The proxy is a first difference (speed); the contract is a second difference (curvature). A window where the clip is
   fast but smooth is therefore not stretched - `b lead boxing_jab t=10.800` still does curv 157.0 against a clip punch
   peak 100.4 (and 52.1 ramp-strict).

Next levers, both parameterised and one line each: `GUARD_IK_SLEW_CLIP_K` < 1.0 (more stretch; costs POP_LAG) and a
curvature-aware cap / a return-specific stretch. The three reversals are inside the curvature contract (`a`'s returns:
30.2 vs 97.4, 129.7 vs 174.4, 41.3 vs 105.6) - they need the reversal clause handled on its own, not by a rate cap.

## #1 — the old 5 mm gate was NOT reachable, and the cap was not the reason (kept for the record)

## #3 — punch load / weight (measured, fix NOT written)

`shoulder_over_mean_cm` 2.4 (min 0.0), `pelvis_to_lead_mean_cm` 2.3 (0.0 on crosses), `load_opposite` 39/82. **The
recovery clause is already green** (hand lands on the guard target within 0.09 cm worst, gate 2 cm) — do not touch
PunchRetime's timings (`CONTROL_OFFSET_S`, `INERTIA_INTO_STRIKE_S/BACK_TO_STANCE_S` 0.27, `set_inertia_lengths`).
Next: a load/weight pass in the spirit of `_head_level_pass` (switch in `GameSwitches.GAME_ON`, `off=` red arm, red-first
test). Power flows hip -> shoulder -> hand, so a load pass belongs BEFORE the strike warp reads the hand.

## Coupling introduced by `329d9d8e` (read this before touching either #4 or #1)

`_guard_ik_pass` anchors the guard targets to the HEAD BONE'S POSITION: `var head: Vector3 = at.call(head_i)` then
`GuardPose.to_world(head, frame.x, frame.y, frame.z, off)` (~4425-4432). The basis is the shoulder line + torso axis
(`head_frame`), so the head's ROTATION is not involved - but its POSITION is, and `_head_level_pass` moves it (measured:
head origin up 5-10 mm, back 6-18 mm at the still moments). By the triangle inequality the guard correction can move by
at most the anchor's move, i.e. **<= 18 mm** - inside `GUARD_IK_SLEW_M` (40 mm) and far inside the pop machinery's
`GUARD_IK_JOIN_JUMP_M` (150 mm), so `head_level` cannot create a new pop.

Two consequences, stated rather than implied:
- The guard pop's after-numbers in `7c78bfc1` were measured BEFORE `head_level` existed; the shipped configuration now
  nudges the guard target anchor by <= 18 mm. Re-running the pop pair with the shipped switches is cheap and worth doing
  once, and it is the honest way to quote #1's after-number now.
- Order inside a frame: `_guard_ik_pass` reads the head before `_head_level_pass` moves it (the chain), and the head pass
  also runs late in `finish_hand_frame` - so the anchor the guard IK reads is the previous frame's. Stable, but it is a
  one-frame lag between the two features, not a coincidence to be surprised by later.

## #4 — open work, in order

1. **The look IS now verified — `c82a2675`.** `head_cam=1` on `tools/guard_lift_still.gd` frames the neck -> HEAD ORIGIN
   segment close up at every labelled moment (`head_guard/mid/contact.png`), A/B-able with `off=head_level`. What it
   shows at `contact`: the skull lifted a few mm and un-tucked (bones: head up 5-10 mm, back 6-18 mm), **the neck skin
   natural - no seam, no tearing, no pinch, at the pass's full cap** (the S262 risk, checked not assumed). The broadcast
   still CANNOT do this job: at ring distance the head is ~15 px tall and an A/B's two arms differ frame-wide (camera
   framing), so a broadcast A/B of this clause is a coin toss dressed as evidence.
2. **The open question is taste, and it is the operator's**: the pass reads as "less extreme tuck", not as "level" (it
   matches `head_max` 104.6 -> 81.6 and `head_follow_k` 2.53 -> 2.43). Enough, or must the head be held level outright
   (which means more translation, more neck stretch)? Close it from `docs/previews/s264_headcam_{off,on}/`.
3. **`head_follow_k` is the wrong gate.** It is an unweighted regression across the whole run, so it conflates the
   torso's pitch with the CLIP's own head motion through a punch/slip. `head_max` is the honest number. Write a
   per-moment gate instead (the head's segment pitch, binned by torso pitch).

## #5 — drawn-vs-engine spacing (measured, fix NOT written)

Drawn chest gap is a mean 120 mm off the engine's separation; engine moves 16.97 m / drawn 19.19 m / roots 16.25 m over
the run; 273/1200 frames move the pair's roots > 20 mm in one frame (worst 89.3 mm). The distance should change by STEPS
(the same foot lock #2 now re-pins), not by root warps.

### S265 attribution: the jumps are TWO problems, not one (measured, seed 95501)

The census now splits every jump over the 20 mm gate by cause (`FIGHT_GAP_STEPS` gains `jumps_engine_step`,
`jumps_drawn_only` and a max for each; each `FIGHT_GAP_JUMP` line prints `engine_step_mm` and `cause`):

| cause | frames | worst |
|---|---|---|
| `engine_step` - the ENGINE's own separation moved by the jump (a spacing change the drawn bodies followed) | **142** | 89.3 mm |
| `drawn_only` - the drawn bodies moved while the separation barely moved | 132 | 75.0 mm |
| of those `drawn_only`, explained by the STRIKE WARP (`|d(a+b)| > half the jump`) | **0** | - |
| of those `drawn_only`, explained by NO warp | **132** | 75.0 mm |

**Zero of the 132 are the strike warp.** `node_gap = _gap - warp.a - warp.b`, and in all 132 frames neither `_gap` nor
`(warp.a + warp.b)` moved by the jump - so the drawn bodies glided with the engine's separation AND the warps both
standing still. That is the placement's own motion, i.e. the glide the brief names and NOT the designed lunge (a fix that
"corrected" the strike warp would be correcting the game's own design, which this measurement rules out). Prime suspect:
`_refuse_overlap_on_placed` (~596, the overlap easing, which "eases hip gap" without moving the engine's `_gap`) and
`_place_whole_bodies` (~753, which walks the other man back at 1.5 m/s). The classification uses a half-the-jump
threshold, so a jump that a warp only partly explains lands in the `other` column.

### The 70 mm glide clamp: CONFIRMED FIRING ZERO TIMES - refuted, and it is not the overlap easing either

The clamp is real code, but the confirmation test refutes it as #5's cause. The probe now passes the room's
`_rendered_gap_clamps` counter (a counter only, added to FightWorldLiveScreen; no behaviour change) into `_gap_step`, so
each `drawn_only` jump is checked against whether the clamp fired ON THAT FRAME:

    clamps_total 0        jumps_drawn_clamp 0        (seed 95501, 40 s, as_game)

**The clamp never fired once in the whole run**, so the 75.0 mm correspondence was a coincidence and a fix aimed at
`RENDERED_GAP_MAX_STEP_M` would have changed nothing. The overlap easing is ruled out with it: `OVERLAP_SEP_MAX_STEP_M`
is 0.05 m (line 580, from `OVERLAP_SEP_MPS` 2.5), i.e. 50 mm/frame at most - BELOW the 75 mm the census measures, so the
easing cannot produce those jumps either.

So the 132 `drawn_only` jumps are NOT the strike warp (`jumps_drawn_warp` 0), NOT the rendered-gap clamp (0 fires), and
NOT the overlap easing (capped at 50 mm < 75 mm). They are produced by something else in the placement - the men are set
down by `_placement_spots(placed)` from `_mid`/`_axis`, and `_place_whole_bodies` (~806) walks a man back at 1.5 m/s
(50 mm/frame, also below 75). Next step is to trace WHICH of those moves the node, with a per-frame log of `placed`,
`_mid`, `_axis`, `_overlap_sep_m` and the two node positions around a jump - one of the `drawn_other` frames at
t=10.8-16.1s in a seed-95501 run is the place to start. Do not guess at the cap: two of the three candidates are already
eliminated with numbers.

The engine half stands untouched: 142 jumps are the ENGINE's own `_gap` changing, worst **89.3 mm in one frame**.

So the defect the brief names is **132 frames, worst 75 mm** - half the census, not all of it. The other half is the
engine's own spacing moving **89.3 mm in a single frame**, which "distance changes by steps" would want smoothed too (a
step that teleports is still a teleport). Two fixes, not one: the room's placement/root warp for the drawn-only half, and
whatever spacing rule snaps the engine's `_gap` for the engine half. `track_error_mean_mm` 117.4 today (120.5 in the
original baseline - the drawn gap is still a mean 117 mm off the engine's).

Entry points, read in this order:
`FightWorldLiveScreen._placed = Vector3(_gap, 0, 0)` (~1394), `_gap`/`node_gap` (~2629), `warp_offsets()` (~2630),
`_place_whole_bodies` (~753), `_refuse_overlap_on_placed` (~596, this is where overlap easing lives) and the strike
warp's `_warp_along_line` (~3593). Coordinate with #2: a step IS a foot lock, so a placement change that moves a body
must move its feet by the same re-pin.

## House rules that cost time if forgotten

- Nothing on the operator's screens: all Godot through `Tools\godot_hidden.ps1`; `Tools\pc_watchdog.ps1 -Once` before
  every run (RED = wait); never commit `Godot/project.godot`, `Godot/override.cfg`, `*.uid`, `*.import` churn.
- NEVER TOUCH: `_guard_body_pass` / `GUARD_BODY`, `scripts/MetaHumanCorrectiveRBF.gd`, `scripts/rules/CorrectiveRBF.gd`,
  Arena's `scripts/rules/GuardPose.gd`, Claude's wrist cap (`cap_wrist`).
- Parse gate `python Godot/tools/check_scripts.py <touched .gd>` (fresh process = truth; the language server reports
  STALE errors on the big files — it did so ~12 times on `FightStagePlayer.gd` in this session). Tests:
  `python Godot/tools/run_tests.py --jobs 2 --only <names>`.
- `git add -- <explicit paths>` only; push the branch; Claude applies the diff to master.
- Measurement honesty, learned the hard way here: `guard_pop_analysis.gd`'s paired `excess_mm` is CONTAMINATED (the two
  runs diverge up to 519 mm on ~1020/4796 frames). Read `POP_JOIN` and the in-run `POP_ADDED`/`POP_SLIP`. When an
  instrument cannot resolve a quantity, say so in the tool and omit the number (`counter_not_measured` is the pattern).