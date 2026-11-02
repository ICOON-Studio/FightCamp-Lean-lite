# S123 digest (Claude, 2026-09-29)

**S123 in one line:** U196 merged (leg-through-leg 7.02 cm -> 1.3 mm), KM1 collected with corrections, C223 defensive pieces slip + pull certified bound 4/4, the gate no longer spaces a defensive piece to its own fist, per-foot pivot rule; KM2 (Kimi) + U196 part 2 (Cursor) in flight.

## Nightly
- No 2026-09-29 run on disk (`AgentComms/nightly/` has head_2026-09-28 last). Latest = 2026-09-28 at 6d2a4201: total=457 fails=23 (list in latest.txt). S122 fixed 5 of them after that run.

## U196 collected (Cursor) - merged as a diff (64921f6c)
- Control arm master 9b143308: fight_body_overlap FAIL leg=leg 7.02 cm f138 (seed 810039); body_layers slide 124 (OFF 195); contact_stop PASS.
- First delivery f35ce99d: overlap PASS but contact_stop REGRESSED (landed low kick 6.4 cm short; OFF arm not off) - corrections ran every frame.
  Send-back 1 (45bfb365): corrections only under contact_stop, skip the landed striker's limb, overlap test measures the game config.
- On master after merge: contact_stop PASS; overlap residual 1.3 mm head>arm f827 (Cursor's run read 0.0; deterministic here). Tried: head
  dead band 1 mm -> 0 made it 2.3 mm - reverted. Subset clip,binding,boxing,overlap,contact_stop,smoke,strike_whole,footwork 23 run: only
  overlap (1.3 mm) + clip_phases (fixed below).
- Open: slide 124 frames -> U196 part 2 (Cursor, running).

## KM1 collected (Kimi trial, c63c8230) - review files only (1331158e)
- Read: KM1_GAME_REVIEW.md whole + 03_technical_code rows. Evidence mostly real (file:line, test output). Corrections written INTO the report:
  Tripo "cannot ship" WRONG (Higgsfield paid + Ludo, asset_manifest tripo_fighters, S92); boxing output 40.3/25.5% is the switch-OFF arm
  (game 47.3/31.5%); "92.6% impacts dropped" predates strikes_play_whole; smoke_test import cache is a worktree artefact.
- Source fixed: S75_PHASE0.html legal rows (fighters + Ludo: can ship).
- New and real (backlog unless on the boxer path): keyboard focus off (UIKit FOCUS_NONE), green-button contrast, placeholder text,
  result-screen order, post-fight fatigue flat +30, empty amateur novice pool [S124: STALE - fixed S76 27b507fb], bald fighters in the ring.
- Price: platform.kimi.ai console needs the operator's login - balance not read.
- Next Kimi task: KM2 (reachability red) launched in D:\FightCamp\wt\KM1 on kimi/km2-reachability.

## C223 - defensive pieces (Claude)
- Gate fix (c223_production_gate): `live_contact` spaced every take to its own fist reach; for a slip that put the receiver 0.615 m away and
  the bodies 22 cm inside each other. DEFENSIVE_PIECES now stay at the fixture range (MID 1.23 m, where the other man's jab lands).
- boxing_slip (RamsterZ SlipLeft) + boxing_pull (RamsterZ FadeBack): bound `plant phase live_contact`, 4/4 legal rows each, 0 pops,
  contact slip <= 0.02 cm, whole, idle reached, gap 0.29-0.57 m. Certificate s123_pieces_bound.json. Stills s123_q215_*, side s123side_*:
  slip = knee bend + trunk tilt off the line; pull = head back over the rear foot, stiff lead arm, back to guard.
- clip_phases entries (effector Head, contact_s = evasion apex) - clip_phases_data_test needs every technique role; green.
- Pivot: per-foot rule (swing foot excluded, pivot foot must hold a planted run) + `lead_slide_mutant`. Audition s123_pivot_audition.json:
  Mixamo High_Left pivot is clean THROUGH the turn (lead toes planted, rear swinging) but slides the lead toes 14 cm in frames 53-70 -
  the exit blend dragging the foot back to guard stance. High_Right 17-28 cm. RamsterZ TurnLeft90 0.0 cm but it STEPS both feet (not a
  ball pivot). Fix = keep the pivot's yaw at the exit (root turn carried, not blended back) - engine work, next.

## C223 - three counters CERTIFIED (boxing 16 -> 19/36)
- boxing_pull_counter (pull -> cross), boxing_slip_counter (slip -> cross), boxing_counter_over_jab (slip -> overhand): bound
  c223_sequence_gate, certificates run8_bound (cross) + s121_ohbound (overhand) + s123_pieces_bound (slip, pull), 12/12 rows, 4 legal rigs.
  Cross 9.0-9.7 m/s in band, onset->impact 267 ms (223-495), on the target line, body gaps 0.23-0.57 m, seam excess 0.0, slip <= 0.03 cm.
  Report s123_counters.json; stills s123_seq_* (first rig).
- Gate: c223_sequence_gate judged every part as a punch (timing/band/target) and HUNG on a slip (TIMING_MS key) - killed by PID. A
  defensive part now gets the body-overlap row only.
- Engine: FightStagePlayer.sequence_plan reads a piece's `piece_cut_s`. The half-return rule (hand vs shoulder) is meaningless for a head
  "effector" and cut the slip at 0.567 s with the lead glove still climbing (11.3 cm/frame^2 at the seam). piece_cut_s 0.667 (= length)
  passed the numbers but the stills showed ~0.9 s of GUARD between slip and punch (the player fell to idle) - not a counter. 0.633 passes
  and the stills run slip -> punch directly.
- Honest caveat: the punch fires as the head comes BACK from the slip (the common slip-and-counter timing), not from the fully slipped
  position SHOT_LIST's row words. Pull counter fires on the return, as its row says.
- Bindings: the three counters were Q133 NEAR single clips; now sequences of certified parts, provenance exact.
- Still open: boxing_catch_counter (catch piece: rear glove at the face), boxing_check_hook + check_hook_pivot (pivot piece - exit drags
  the lead foot 14 cm), boxing_counter_combination (3 parts; sequence gate is 2-part).

## U196 part 2 (Cursor, 7453f017) - slide 124 -> 0
- Cause table (Cursor probe, seed 94301): all 124 frames = C215 `_shuffle_enabled` latched on the first footwork beat and never cleared, so
  walk_at dropped the lower layer even while the upper body was busy. Fix: shuffle only when not busy. OFF arm 195 unchanged, beats 17/17.

## KM2 (Kimi) - stopped: Moonshot 429 "credit balance is running low"
- Mid-run, nothing committed. Its direction (unverified): no MPFB/Tripo body passes the neck approach with the current capsule arm; it was
  about to make FighterCapsules default `split_inlet`. Partial diff saved D:\FightCamp\wt\KM2_partial_FighterCapsules.diff; worktree left
  as is. Resumes only after the operator recharges Moonshot.

## C223 - catch piece: NOT certified (method finding for S124)
- Gate CATCH ROW (c223_production_gate, role boxing_catch): the rear glove must, at some frame, lead the Head bone by 8-30 cm, sit within
  10 cm of its centre line and within +-10 cm of its height; and NO frame may lift it > 10 cm above the Head bone (catch_glove_over_head).
  Control: the plain guard (cg_0) FAILS (glove 17.6 cm below, at the chin) - the row can fail.
- Mixamo High_Right_Block (q215_catch / v_catch warped to 0.765 s): a HIGH COVER - glove over the crown at the peak (12.1 cm above);
  rejected by the overhead row. Its first pass on a looser distance-only row was a false pass caught on the stills (s123ct_*).
- RamsterZ H2H_BlockStart: glove 27-30 cm off, join fails.
- Guard + Euler-grid layer (v_catch_g, layers tools/c223_layers/cg_*.json): best cg_s3 passes every row on the first rig but peaks 9.0 cm
  above the Head bone - glove at the forehead, in front (side still s123cgside_*). Borderline; not certified.
- S124 METHOD: stop guessing Euler angles. Solve the layer by a TARGET: glove centre at nose height, ~12-18 cm in front of the face, on the
  centre line (s120_layer_solve prints the hand position per candidate - add a target and search against it), then all four rigs + stills.

## Handover state
- In flight: U197 (Cursor) D:/FightCamp/wt/U197, branch cursor/u197-footwork-beats, out AgentComms/prompts/U197_out.txt. Its working tree
  also edits FightBeatAdapter.gd + FightLiveSchedule.gd (NOT owned) - judge that at collection (check_workflow branch).
- Stopped: KM2 (Kimi) - Moonshot credit. C161 (Codex) landed, backlog.
- Nightly: no 2026-09-29 run on disk; cite 2026-09-28 (23 fails) until the next one.
