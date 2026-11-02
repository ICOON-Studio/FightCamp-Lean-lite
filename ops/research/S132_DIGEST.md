# S132 digest (2026-09-30, Claude) - glove bullets fixed (BUL1), one-frame leg kicks found by watching and fixed, four rooms merged

Nightly cited at start: `AgentComms/nightly/latest.txt` 2026-09-29 at 9b143308, suite 459 / 20 fails (the 09-30 run was
postponed by the operator's popup, then ran during this session: 2026-09-30 at c2f2c955, 464 / 18 fails, walkout red). HEAD at start 37f79263 (+ c2f2c955 pulled:
the S131 session corrected its own rule - the watchdog GREEN before each launch is the ONLY agent gate, the nightly is not
a blocker; operator verbatim "i dont mind, they can run if the pc can take it").

## 1. BUL1 - the glove bullets (operator: "some punches are like bullets") - DONE
- Instrument: `tools/s131_hand_pop_probe.gd` now names the CALLER of every arm-IK write (`_bend_arm(..., trace_tag)`:
  `:stop`, `:stop_head`, `:push`, `:aim`, `:c186`, `:s77_smooth`, `:effector_cap`, `:hold_release`) - probe-only labels.
  It put 60 of 67 glove frames >15 m/s on ONE pass: the room's LAST head stop `_correct_refused_head_contact` (Q214),
  which runs after every hand smoother.
- NEW `tools/s132_head_stop_probe.gd` (which overlap made the pass throw a glove, plus a CONTROL: limb-in-head depth at
  frame end): 58 of 62 throws >0.5 m/frame happened while a SHOULDER (`*Shoulder-*UpperArm`, the collarbone) or UPPER ARM
  sat in a head - parts ABOVE the two-bone chain the wrist IK bends, so shoving the glove (up to 0.91 m in one frame)
  could never clear them: the shoulder was still >1 cm in the head at frame end on 55/900 frames WITH the throws.
- FIX (FightWorldLiveScreen): `_wrist_can_move()` - the wrist pass handles glove + forearm only; shoulder/upper-arm vs
  head is the root's to refuse (`head>arm` already feeds `_refused_overlap_from_parts` -> finish separation). The pass had
  a SECOND defect: a branch pushing the OTHER man's wrist along `pair_contact`'s normal, which points INTO the head, while
  that man's own pass pushed out - two passes fighting 12 iterations. Removed: every limb-head overlap is visited once, by
  the limb's own side. An UPPER ARM in a head is turned at the shoulder (`stop_head_contact_upper_arm`, <= 8 deg a frame
  across all passes, like `stop_contact_leg` at the hip) - pushing the wrist to clear it took lever throws, and skipping
  it raised fight_body_overlap's worst to 9.5 mm head>arm (HEAD 1.8 mm; now 2.1 mm hand>head - red before and after).
  Plus a hold/release channel for the head push (`begin_head_hold`/`stop_head_contact_hand`/
  `end_head_hold`/`clear_head_hold`, S125 pattern). Measurement switch `head_stop` (never a game toggle).
- Numbers, seed 92012, 30 s, game switches (`s131_bullet_probe`): GAME BODIES (as_game) HEAD 42 frames >15 m/s, 3 >25,
  max 30.3 -> after 1 >15, 0 >25, max 19.7. Tripo control arm 44 / 0 / 22.4 -> 2 / 0 / 20.0. Control arm `headstop=0`:
  1 >15, max 22.1 - the pass WAS the bullets. Head-stop probe: throws 62 -> 0, arm moves p95 0.754 -> 0.238 m; glove and
  forearm in a head at frame end 0/900 before and after (the guard it exists for still holds). Acceptance (0 >25, <20
  >15 per 30 s) MET on both body sets.
- C223: `c223_parallel production` on jab/cross/rear_hook/jab_body, 4 rigs (`docs/previews/c223/s132_bul1_c223.json`):
  0 mechanical failures, pending = "shot-list visual review" only - identical to S131. The gates call none of the
  changed functions (grep), so the certificates stand by construction.

## 2. "Watch every frame before sending" found a second defect - one-frame LEG KICKS
- Recording seed 92012 through `record_room.gd` - NOTE its flag is `demo=1` (not `as_game`; `as_game` adds the game's
  generated bodies). The first recording (`as_game` only) had every game switch OFF. Game recording = `demo=1 as_game`.
- Watched all 900 frames (30 sheets of 30 consecutive frames). Frame 889: fighter B's lead leg shot out like a front kick
  for exactly ONE frame. Frames 314->315 / 360->361 in the Tripo recording: the pair jumped round each other in a frame.
- NEW `tools/s132_leg_pop_probe.gd` (feet in-and-back > 0.20 m, clip, node vs skeleton vs hips motion) and
  `tools/s132_foot_pop_probe.gd` (hand-pop probe on the FEET, every room stage marked): the root/hips moved <0.16 m while
  a foot moved up to 1.07 m relative to the hips - a LEG solver, two of them:
  (a) U196 `_correct_refused_leg_cross` - twice a frame, up to 4 passes each, every pass turning a touching leg 12 deg at
  the hip; the next frame the clip put it back: 108 of 166 foot frames >6 m/s. FIX: the passes still compute the full
  uncrossing; `FightStagePlayer.begin_leg_cross/end_leg_cross` SHOW it moving at most LEG_CROSS_STEP_DEG = 4 a frame
  (S77's pattern for hands). 108 -> 4.
  (b) the shuffle plants: `_place_bodies` asked for a 0.76 m jump in one frame, `_advance_shuffle` re-seeded the plants at
  that UNCAPPED spot (travel > 0.5), the root cap pulled the body back, and `finish_hand_frame`'s settle bent both legs
  to the far plants. FIX: `_carry_shuffle_plants()` - whatever moves the root after the plants are set moves them too.
  Leg pops (in-and-back > 0.2 m, game bodies): HEAD 24 (max 1.06 m) -> 6 (max 0.42 m).
- STILL OPEN (-> OR1): the room's placement asks for 0.5-0.8 m jumps in one frame (the root cap holds the body, so the
  picture no longer shows them as legs, but it is where the pair's lurches come from); orbit p95 111 deg/s unchanged.
- Final recording (both fixes, `demo=1 as_game`, all 900 frames watched): no glove bullet, no one-frame leg. ONE defect
  left, present before S132 (identical frames in the earlier recording): at 0:28 (frames 840-858) B throws a body jab
  from 1.9 m sideways into empty air, chest ~100 deg off A. NEW `tools/s132_facing_probe.gd`: 6 of 21 strikes start with
  the chest > 45 deg off the foe; the ENGINE facing vs the line to the foe p50 16 / p90 69 / max 117 deg while the room
  follows it (body yaw vs engine facing p50 0) - the engine's bearing lags the orbit, and the whole-strike aim turn is
  capped at 30 deg. That is OR1 (engine balance, bands) -> S133's first item, not an end-of-stage patch. Sent to the
  operator with that named: `docs/previews/anim/live_boxing_seed92012_s132.mp4`.

## 3. Agents (operator: agents "can run if the pc can take it") - all launched, all collected the same session
- Launched with the watchdog GREEN before each: Grok G148 resume (office), Codex C225 (floor tier 1, gpt-6-astra/high),
  Qwen Q218 (staff room, tools probed first: python/git/Blender/file read OK), Cursor U200 (locker room, Sonnet 5),
  Dola D66 (strict review, 15 screenshots) then D65 (in-round recovery research, IN FLIGHT), Kalli K47 (film room spec).
- Collected: U199 lobby (merged adde943e; cooler moved off the street-door mat), G148 office, C225 floor (tier 2
  pixel-identical 0/2,073,600), Q218 staff room, U200 locker room - all `check_workflow` defects=0, merged as diffs.
- `check_workflow` defect fixed: it only read `## Owned files` exactly - five S131 briefs wrote `## Owned files (...)` or
  `## Owned (...)` and a clean branch was refused as "no section".
- K47 -> `research/K47_FILM_ROOM_SPEC.md` + `docs/previews/concepts/room_film_k47_a.png`/`_b.png` (captured from the
  chat by CDP screenshot - the images are cross-origin, canvas export is refused). D66 ->
  `research/D66_STRICT_REVIEW.md`: 5/10 today, "lack of feedback, clarity and meaningful decision weight"; its ONE
  thing before 6 Oct: a guided first-fight flow that explains every screen.
- Grok Bot app trap: `newchat` now lands on a "To:" picker; a REAL mouse click on the bot (CDP Input.dispatchMouseEvent)
  opens the fresh chat - a JS `.click()` does not.

## 4. Operator requests this session
- "document the whole gaming process ... make funny animated videos ... post them": a Claude subagent wrote
  `D:/FightCamp/devlog/FIGHTCAMP_STORY_SO_FAR.md` (14 chapters, cited), `ANGRY_MOMENTS.md` (143 moments, top 10),
  three cartoon episodes 16:9 + 9:16 + thumbnails in `D:/FightCamp/devlog/videos/`, `UPLOAD_PLAN.md`, and
  `tools/update_devlog.py` (incremental, ~0.2 s when nothing is new). NOTHING POSTED - publishing on his channel waits
  for him to watch each and say yes (no YouTube access either). Claude opened every episode's frames.
- "use dola to generate video": Dola has Create Videos (Dreamina Seedance 2.5): 5 s, 4 credits, ~20 min - ONE clip a day
  on the free tier. The test clip came back "For copyright protection, I can't show you the generated video because of
  its audio" - blocked. Dola is not a video source.

## 5. Defect fixed on the way: a spar started with the men sliding apart (fight_room_walkout_test red since S127)
- `tools/s132_start_gap_probe.gd`: the engine starts the pair 2.00 m apart; the spawn marks stand them 0.90 m apart; with
  the walkout OFF (FightNightScreen does that for spars) U198's root cap slid them out over ~13 frames at the bell. The
  walkout (booked bouts) already ended at the engine start - the test's still arm read the slide (1.068 after one frame).
- FIX (setup): no walkout -> the men start at the engine's first sample (+ stance offset), facing each other. Probe: room
  gap = engine gap from frame 0; fight_room_walkout_test 12/0 (was 10/2, red in the 09-30 nightly too).

## 6. Final recording, final code (all 900 frames watched again)
- After the upper-arm turn and the spar start, `docs/previews/anim/live_boxing_seed92012_s132.mp4` was re-recorded
  (demo=1 as_game) and every frame watched: no glove bullet, no one-frame leg; the OR1 sideways body jab at 0:28 remains.
- A wide stance showed at frames 420-445 (legs ~1.3 leg-lengths apart in the corner). `s132_fold_probe` STANCE WIDTH A/B:
  LEG_CROSS_STEP_DEG 4 (shipped) -> 14 frames > 1.3, max 1.36; 180 (= the old instant stop) -> 31 frames, max 1.67. The
  rate limit REDUCES it; the residue is the leg-cross stop itself spreading tangled legs in close work (OR1/placement).
- Process slip, caught: the A/B edited the constant on disk while a focused run was loading scripts - that run was
  discarded and the 17 tests re-run on the restored file.

## 7. Tests (final tree, `run_tests --jobs 4`, 17 focused) and a runner defect
- 15/17 pass. fight_body_overlap red on HEAD too (worst 1.8 mm HEAD vs 2.1 mm fix, allowance 0). fight_strike_whole
  "hang (timeout)": run ALONE it PASSES on HEAD (664 s) and on the fix (657 s), OFF hashes equal - it outgrew the runner's
  600 s ceiling (also the 09-30 nightly's "hang"). run_tests.py SLOW_TEST_TIMEOUT_S gives it 1200 s, measured time beside it.
- Process: two early focused runs were SERIAL (no --jobs) and one waiter keyed on "SUITE total=" sat 2 h because the
  output never carried that line - operator: "why you are not running parallel tests ... as we agreed". CLAUDE.md s6 now
  says run_tests never serial (--jobs 4 idle / --jobs 2 busy) and wait on the runner's exit, never on a string.
- Operator 11:3x on a still from the recording: a fighter turned away in guard ("i hope this fixed soon") = OR1, and "the
  ring does not seem to be in right dimensions" -> RING1 (measured next).

## 8. Operator rulings at the close
- Ring: measured 18 ft (5.486 m, boxing_ring_fl_min - the smallest legal size), ropes 18/30/42/54 in, posts 58 in, fighters
  1.74/1.82 m (`tools/s132_ring_scale_probe.gd`, still `docs/previews/s132_ring_low.png`). Operator, verbatim: "make it 22ft
  on the next session" -> DECISION_LEDGER D28, queue RING1, first item of S133.
- Harmony4D: operator linked the HF repo (352 GB: train 287 GB incl. MMA 12-15 = 53.6 GB, test 65 GB incl. 16_mma5 11 GB).
  Asked download-vs-test-first; the operator dismissed the question -> nothing downloaded; H4D stays in the backlog (MMA
  update) with test/15_mma4 (2.3 GB) already on D:.
- In flight at ship: Dola D65 (in-round recovery research), chat local_8520617112323646.
