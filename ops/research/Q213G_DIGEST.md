# Q213G digest - the drawn glove stays out of the head; the 3 palette moves cleared (Claude Opus 5.5, S156, 2026-10-03)

**In one line:** the clipping gate measured a bare fist the game no longer draws. Measured as drawn, the S155 glove sat
up to 7.9 cm inside the other man's skull. The contact solve now uses the glove's own volume and the head's drawn
surface (switch `glove_contact`, game ON / tests OFF), the uppercut gets a recovery lean-back, and glove-in-head reads
0.00 cm on all 12 move/rig rows of the three moves.

## Operator rulings
- S155: the 3 failing palette moves -> **"Fix their clips first"** (they stay in the palette).
- S156: **"go ahead with the uppercut lean-back"**.

## 1. Instrument: the glove arm (`q213_clip_gate.gd ... glove=1`)
Mounts `CCFighterSkin.mount_procedural_gloves` on both clip bodies (the hand is cut from the mesh under it, as in the
room), poses each glove from the FINAL skeleton pose (what `_on_skeleton_updated` draws) and tests every glove vertex
against the other man's posed skin (`q213e_skin_fast`). Hand vertices no drawn triangle uses are dropped from the skin
sources in this arm (the cut keeps them in the arrays). Prints `Q213G_GLOVE_ROW` (glove-in-head) and
`Q213G_GLOVE_TORSO_ROW` per move/rig.
- Proof it reads worse (heavy_d, master code): lead_uppercut hand row 4.05 cm -> glove row **7.86 cm**; rear_hook_body
  2.66 -> **7.81 cm**. Pose/clock SHA-256 identical with and without the glove arm (mounting gloves changes no pose).

## 2. Root cause - two volumes too small for what is drawn
Diagnostic at the worst frame (lead_uppercut d f70, after the first fix): the deepest glove vertex was INSIDE its own
glove capsule (-0.54 cm) yet 2.7-3.5 cm OUTSIDE both head parts while 5.1 cm inside the drawn skull. The head's p80
sphere (r 0.104 m round the head-vertex centroid) leaves the crown out: the drawn head reaches 0.195 m from that centroid,
and the vertex sat 13.9 cm above it.

## 3. Fix (switch `glove_contact`, FightWorldLiveScreen; `glove_hand=1` in the gate, the C223 production gate and the video)
`FightBodyCapsules.build_body_model(..., glove_discipline)`; empty = the old parts byte for byte.
- `_fit_glove_parts`: mounts the real glove on the throwaway rest body; capsule through the FIST (vertices past the wrist)
  along the glove's long axis, radius = p80 of their distance from the axis (0.0666 m, length 0.027 m), riding the hand bone.
- `_fit_head_part`: capsule along UP through the head-vertex centroid (the Neck->Head bone line leans forward on the MPFB
  rig: a first try along it gave a 5 cm capsule and moved nothing), PLUS the head's drawn surface: head vertices thinned to
  the outermost per 2 cm cell (486 points on heavy_d, reach 7.6 cm past the capsule).
- `FightContactSolve.pair_contact`: a part with a `cloud` is read capsule-vs-points; the deeper reading wins; skipped when
  the cloud cannot reach (`cloud_reach`). Parts without a cloud: unchanged.
- Progression on heavy_d lead_uppercut glove-in-head: 7.86 (none) -> 5.11 (glove capsule) -> 4.96 (head capsule) -> **0.00** (head surface).
- Cost: posed_parts x2 + hand_pushes 0.33 -> 0.56 ms per pass, worst case (glove at the head), two gate runs beside it
  (`tools/q213g_contact_bench.gd`).

## 4. The uppercut lean-back (FightClipBinding boxing_lead_uppercut)
After contact (0.57 s) the held Q217 dip put his head 1.3-2.0 cm into the other man's upper chest at 0.80-0.95 s on
welter_b and heavy_d. Added Spine [-12,0,0] over 0.62-1.4 s (peak 0.88, hold 0.1). Swept: 8 / 12 / 16 deg all clear both
rigs (welter_b worst 0.29 / 0.26 / 0.28 cm); 12 kept for margin. welter_a / heavy_c still PASS (welter_a worst 1.78 -> 2.45
cm, a passing row). The punch up to contact is untouched.

## 5. Gate grading change (said out loud)
In the glove arm a glove against torso/neck/head is measured EXACTLY by the glove mesh vs drawn skin, so the capsule
proxy for that same contact (glove capsule + p80 torso capsule r 0.206 m) is printed (`_proxy`) but not graded. It read
5.15 cm where the drawn glove sat 3.92 cm (heavy_c rear_hook, opened on a frame sheet: the men are chest to chest at the
certified 0.78 m with both guards squeezed between them). Glove-vs-arm capsule pairs stay graded.

## 6. Gate defect fixed: a move's numbers depended on the move list
The same move read 3.52 cm alone and 2.66 cm after the uppercut (pose hashes differed) - every Q213 certificate number
depended on which moves ran before it in the process. Three leaks, found by fingerprinting the start pose: (1) R110
leaves a running loop alone, so the receiver's guard idle carried its phase; (2) the foot lock held the receiver's planted
feet at the previous move's spacing (only the leg bones differed at move start); (3) the attacker began each move from
the last move's end pose. Now: both men take the same guard lead-in from phase 0, foot lock rested, pin carry-over
cleared. Proof: rear_hook_body d byte-identical hash and 3.59 cm alone and after the uppercut.
Cline's NIGHTLY1 found the same leak class in fight_readable_onset_test (`_shown_*` inertializer state) - a public
`FightStagePlayer.reset_to_fresh_mount()` is the clean fix for both; queued.

## 7. Results (corrected gate, pin=1, 26 exact moves x 4 pairs)
Counts are failing G147 events per rig (a = welter_a, b = welter_b, c = heavy_c, d = heavy_d). "before" = the game as
drawn today (glove arm, no glove_contact); "fix" = glove arm + glove_contact + the uppercut lean-back.
Logs: scratch/q213g/full_{before,fix}_p{0..3}.log (gitignored scratch).

| Move | before (drawn glove, no fix) a/b/c/d failing | fix a/b/c/d failing | fix verdict |
| --- | --- | --- | --- |
| boxing_body_hook | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_catch | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_check_hook | 1/1/1/1 | 0/0/0/0 | PASS |
| boxing_counter_over_jab | 0/1/0/1 | 0/0/0/0 | PASS |
| boxing_cross | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_cross_body | 0/1/1/0 | 0/0/0/0 | PASS |
| boxing_double_jab | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_inside_uppercut | 1/2/1/2 | 1/1/1/1 | FAIL (withdrawn, diagnostic only) |
| boxing_jab | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_jab_body | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_lead_hook | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_lead_uppercut | 1/4/1/2 | 0/0/0/0 | PASS |
| boxing_liver_combo | 6/7/4/6 | 4/4/4/4 | FAIL |
| boxing_one_two | 1/0/0/0 | 0/0/0/0 | PASS |
| boxing_one_two_hook | 2/5/2/3 | 1/2/1/2 | FAIL |
| boxing_overhand | 0/1/0/1 | 0/0/0/0 | PASS |
| boxing_pull | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_pull_counter | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_rear_hook | 2/1/0/1 | 0/0/0/0 | PASS |
| boxing_rear_hook_body | 2/2/2/2 | 0/0/0/0 | PASS |
| boxing_rear_uppercut | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_shovel_hook | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_six_punch_combo | 9/14/8/10 | 7/7/6/8 | FAIL |
| boxing_slip | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_slip_counter | 0/0/0/0 | 0/0/0/0 | PASS |
| boxing_up_jab | 0/0/0/0 | 0/0/0/0 | PASS |

- **All 23 single moves and both 2-part sequences PASS 4/4 with the fix**, including the three target moves. No move is
  worse than before anywhere; 8 moves that clipped a glove into a head/chest as drawn (check_hook, counter_over_jab,
  cross_body, lead_uppercut, one_two, overhand, rear_hook, rear_hook_body) are clean.
- **The three combos fail bare-handed too** on the corrected gate (control run `moves=` the 3 combos, glove=0, all 4 rigs
  FAIL: liver_combo Head>Neck-Head 11.5 cm, one_two_hook legs 5.1 cm, six_punch shoulder>head 4.0 cm on welter_a). Not
  the glove fix: the order-independent lead-in exposes them (their S135 between-part steps walk the attacker into a
  receiver the fixture holds still). Their Q213C PASS was measured under the leaking gate. -> Q213H, next.

## 8. NIGHTLY1 (Cline) - partial, merged
Cline's free model hit its daily limit ("free-models-per-day-stealth") mid-run. Committed from its worktree (90a4c2cd on
cline/nightly1), branch check defects=0, diff applied: fight_readable_onset_test mounts ONE room and resets the reused
body - 1200 s timeout -> 234 s, TOTAL=130 fails=0 (Cline's run). NIGHTLY1_DIGEST.md carries the evidence. The four
flip-hangs (grapple_seam, room_positions, strike_speed, stage_realism) are not started.

## 9. VENUES2 reopened
Operator: "i thought this was the same as the mma rena we have , can we use it ?" -> not the same pack (we ship Marpa's
MMA Arena; this is their Boxing Arena), yes usable; operator: "downloaded it". Package in the Unity cache, sha256
7472f679...; brief `TASK_VENUES2_BOXING_ARENA.md`.

## 10. Tests and what is still owed
- `run_tests.py --only glove,fight_body_overlap,q213,contact,readable_onset --jobs 3`: 10/11. The 11th,
  fight_body_overlap_test, is a CHRONIC red (nightly rc=1 every night since 2026-09-26, before this stage): "no refused
  penetration in 900 frames (worst 0.0029 m hand>head at frame 898)". glove_contact is OFF in tests, so the only change
  this stage makes to its run is the uppercut lean-back clip. Queued (not in NIGHTLY1's list).
- OWED next session: C223 production gate with `glove_hand` vs without (running at ship: scratch/q213g/c223_{base,glove}),
  the landing rows must still touch; the 3 move videos (tools/q213_move_video.gd, glove_hand ON by default) as frame
  sheets, then to the operator.

## 11. Arena seat (operator ruling, same session)
arena.ai Agent Mode added as a free coding worker (683ddd59): rules in CLAUDE.md s8 and AGENT_TOOLS.md, new CI
`.github/workflows/ci.yml` (master, arena/**, PRs; no LFS; test guard `Tools/ci_arena.py`), ARENA line in `start`.
No Arena task launched - the operator picks the first.
