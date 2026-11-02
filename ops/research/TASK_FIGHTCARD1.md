# TASK_FIGHTCARD1 - the 3D ring stages the plan's card (Cursor)

Model: Cursor (composer default). Discipline: boxing = demo. Repo: **E:\FightCamp\Lean** (worktree
E:\FightCamp\wt\LEAN_FIGHTCARD1, branch `cursor/fightcard1`). Lean rules: its CLAUDE.md, no script over 500 lines, Godot
headless only, nothing opens on the screen. Operator S338: "keep all agents working on animations and you work on the
mechanics and ui" - this is the picture of a mechanic Claude already built (PlanFight, S339).

## Why
Every 30-second exchange is now fought on a ring card (StrikeMap.CARDS: outside / long / mid / inside / clinch / own_ropes /
opp_ropes / corner). LiveRound writes it as `rec["at"]` per exchange (scripts/state/LiveRound.gd:255). The 3D view ignores
it: the S339 still showed the caption "Plan: Pivot off the ropes" while both women stood mid-ring. The picture must show the
card the words name.

## Spec
1. New pure module `scripts/fight3d/CardStage.gd` (extends RefCounted, <= 150 lines):
   `static func target(card: String, a: Vector3, b: Vector3, ring_m: float) -> Dictionary` returns
   `{"a": Vector3, "b": Vector3, "gap": float}` - where each boxer should stand for that card:
   - `own_ropes`: boxer a's back on the ropes NEAREST to her now (the side her pelvis is closest to), her pelvis
     RingPlace.ROPE_LEAN_M inside the rope line; b in front of her at the mid range gap (StrikeMap card "mid").
   - `opp_ropes`: the mirror - b's back on the ropes nearest b, a in front at the mid gap.
   - `corner`: b in the corner nearest her (both axes at the rope line minus ROPE_LEAN_M), a in front on the diagonal.
   - `outside` / `long` / `mid` / `inside`: no move of the middle; `gap` = the middle of the card's `range_m`
     (outside: use 1.6, not the 3.0 top). `clinch` and an unknown card: return `{}` (no staging; Clinch.gd owns it).
2. ExchangeBeats.build (scripts/fight3d/ExchangeBeats.gd, 273 lines): the exchange's FIRST beat gets `"card": str(x.get("at", ""))`.
   Add it after `_arrow` (line ~49). Nothing else in that file changes.
3. FightStage / RingPlace (scripts/fight3d/FightStage.gd 342 lines, scripts/fight3d/RingPlace.gd 102 lines): when a beat
   with a non-empty `card` fires (FightView._fire -> BeatFire.fire, scripts/fight3d/BeatFire.gd:29), the stage takes
   CardStage.target as a walk goal: both boxers WALK there (Footwork steps, the existing `_walk` / `step` path, never a
   teleport) within the exchange's first 2.5 s, then the normal RangeBreath rhythm resumes around the new gap. While a ropes
   or corner card holds, RingPlace._place must not pull the pair's middle back inside `MID_IN_M` for that exchange (that clamp
   is what keeps everyone mid-ring today) - the ropes are allowed, never through them (keep the `edge` clamp).
4. `-- card=own_ropes` on `tools/fight3d_play.gd` forces every exchange's card (for stills only).

## Contract
OWNS: Lean/scripts/fight3d/CardStage.gd, Lean/scripts/fight3d/ExchangeBeats.gd, Lean/scripts/fight3d/RingPlace.gd,
Lean/scripts/fight3d/FightStage.gd, Lean/scripts/fight3d/BeatFire.gd, Lean/tools/fight3d_play.gd, Lean/tests/card_stage_test.gd
(do NOT edit tools/run_tests.sh - Claude adds the test to the list at merge)
RED_TEST: tests/card_stage_test.gd -> PASS card_stage_test
REGRESSION: beat_clips_test, inside_beats_test, clinch_beats_test, plan_bout_test, golden_path_test
VISUAL: yes (Claude renders tools/fight3d_play.gd `-- card=own_ropes` and `-- card=corner` on the hidden desktop and opens the stills)

## The test (write it FIRST; red on main)
`tests/card_stage_test.gd` (extends SceneTree):
1. own_ropes with a at (0.4, 0, 0.2), b at (-0.6, 0, 0.2), ring FightStage.RING_M (5.5) -> a's pelvis within
   ROPE_LEAN_M + 0.02 of the +x rope line (ring/2 = 2.75), b between a and the ring centre, |a-b| inside the mid card's range_m.
2. opp_ropes mirrored -> b on the ropes, a in front.
3. corner -> b within 0.1 m of a corner on BOTH axes, a in front on the diagonal.
4. long -> gap inside [1.05, 1.4]; clinch -> `{}`.
5. ExchangeBeats.build for an exchange record with `"at": "own_ropes"` (build the record the way tests/plan_bout_test.gd or
   tests/beat_clips_test.gd do) -> its earliest beat carries `card == "own_ropes"`.
Ends `PASS card_stage_test` / `FAIL <n>`, quit(0/1); a SCRIPT ERROR line is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/card_stage_test.gd`
then the five REGRESSION tests the same way. The plain exe only (never `_console.exe`); stop any Godot run you started that
hangs, by its PID.

## Final answer
`RESULT: tests/card_stage_test.gd -> PASS card_stage_test`, the last lines of each run, files touched + line counts.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, Lean version)
1. On main today the own_ropes still shows both boxers mid-ring (S339 p03b) - that is the red.
2. Stills only via `tools/fight3d_play.gd` on the hidden desktop (`python tools/hidden_desktop.py run ...`, Lean CLAUDE.md):
   guard, one mid-punch, one between, for `card=own_ropes` and `card=corner`.
3. For every still report: gap between bodies / where each nose points / her back to the ropes or not / feet / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it. You cannot see images: report numbers.

## Prior research
searched: ropes corner trapped staging -> J51_FIGHT_CAMERA_CRAFT (broadcast cam head-to-toe, above the second rope),
StrikeMap.CARDS (S335), PlanFight.where_next (S339), RingPlace header (S311: the ropes are reachable, ROPE_LEAN_M).

## What would a human do?
A fight choreographer blocks each exchange: before the punches he puts the fighters where the story says - the trapped one's
back on the ropes, the presser square in front cutting the exit. The audience reads "she is trapped" from the position first.

## Prefab check
None - staging rules on our own ring; Footwork already has the steps. Nothing downloaded.

## The trap
Never teleport a boxer to the target: the pair walks there with the steps they already have. And RingPlace._place's
MID_IN_M clamp silently undoes any ropes position - relax it only while a ropes/corner card holds.
Another seat (Goose SMOOTH2) holds FightStage.gd `_start()` (~lines 165-181) and the consts BLEND_S / GUARD_* (~38-43):
do NOT edit those lines; add your hook elsewhere in FightStage.gd. Also off-limits: JoinSmoother.gd, GloveClear.gd,
PunchReach.gd, BeatClips.gd.

## ROUND 2 (S340, Claude's visual check of 8a31e2c - read this first)
Claude rendered `tools/fight3d_play.gd -- card=own_ropes` and `-- card=corner` on the hidden desktop. At 0:13 of round 2
(p06_round2_mid) both women stand mid-ring in BOTH runs: no ropes behind Lucy, Maria not in a corner. Two causes to fix:
1. `_force_at` sets the card only twice (round 1 start, after the shout); every later exchange takes `at` from
   PlanFight.where_next again, so most exchanges are never forced. Make the forcing hold for EVERY exchange record before
   ExchangeBeats.build runs (e.g. a `static var force_card` on ExchangeBeats that `_card` uses when set, set by the tool only).
2. Nothing measures the staging. Add to tools/fight3d_play.gd: 3.0 s after each exchange's first beat fires, print
   `CARD k=<k> card=<c> a_rope=<m> b_rope=<m> b_corner=<m> gap=<m>` (a_rope = Lucy's pelvis to the nearest rope line,
   b_rope the same for the opponent, b_corner = the opponent's pelvis to the nearest corner post, gap = pelvis gap), then
   at the end `CARD STAGED <n>/<m>` counting exchanges where own_ropes: a_rope <= 0.20; opp_ropes: b_rope <= 0.20;
   corner: b_corner <= 0.40.
Run it yourself on the hidden desktop (never on a monitor): `python tools/hidden_desktop.py run --timeout=500
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --path . --windowed --resolution 1920x1080 --audio-driver Dummy
--script res://tools/fight3d_play.gd -- E:/FightCamp/tmp/fc1_r2 card=own_ropes` (then card=corner). PASS: `CARD STAGED`
>= 80 % of exchanges for both cards, the five REGRESSION tests still green. If the walk cannot reach the rope in 2.5 s,
find out why from the CARD lines (RangeBreath/aim_step pulling them back is the likely one) - fix it inside your owned files.
New final answer line: `RESULT: tools/fight3d_play.gd card=own_ropes -> CARD STAGED n/m` and the same for corner.

## ROUND 3 (S342, Claude's visual check of 1f48154 - read this first)
Round 2 stages the card: own_ropes CARD STAGED 3/3, corner 2/3 (Claude's run, card=corner k=2 had left the corner by 3 s -
fine, real boxers escape). NOT MERGED: the CAMERA hides the staging. Claude's stills (E:/FightCamp/tmp/s342_fc1_corner
p03_after_shout.png, p06_round2_mid.png; s342_fc1_ropes p06): when the pair stands at the near ropes / near corner the lens
sits OUTSIDE the ring behind a boxer and the corner post - all you see is one back; the trapped boxer is hidden (p03: the
lens is behind Maria, who is IN the corner, i.e. through the post; p06: over Lucy's back, Maria invisible behind her).
Real TV cuts to the camera across the ring (the "hard cam") when the action is on the near ropes.
OWNS (round 3 adds): scripts/fight3d/RingCamera.gd (221 lines) + the round-2 files. Keep every file under 500 lines.
1. `RingCamera._side_of`: when the pair's middle is within 1.3 m of a rope line, or either boxer within 0.6 m of a rope
   (use FightStage.RING_M * 0.5 - RingPlace.ROPE_LEAN_M as the rope line, as the CARD probe does), pick the perpendicular
   that points TOWARD the ring centre (dot(side, -mid) > 0) - continuity with the old side is dropped then; a cut happens
   at most once per HOLD (no flip-flop: keep the inside side until the pair's middle is > 1.8 m from every rope).
2. A "shoulder" shot is never placed behind a boxer whose back is within 0.8 m of a rope or corner (that lens is outside
   the ring): shoot over the OTHER boxer's shoulder, offset wide (side * 1.4) so the trapped boxer's face reads; if the
   lens would still land outside the rope square + 0.3 m, skip to the next shot in SHOTS.
3. Measure it - extend the CARD line in tools/fight3d_play.gd with `lens_in=<0|1> a_vis=<0|1> b_vis=<0|1>`:
   lens_in = the camera's x and z are both inside the rope line + 0.5 m; X_vis = that boxer's head (skeleton "head" bone,
   or pelvis + 1.55 m) projects inside the viewport (Camera3D.is_position_in_frustum) AND the segment camera->head passes
   > 0.22 m from the other boxer's torso line (pelvis -> pelvis + 1.45 m). At the end print
   `CARD VIEW <n>/<m>` = samples with lens_in=1 and both vis=1.
PASS: `CARD STAGED` >= 80 % AND `CARD VIEW` >= 80 % for BOTH card=own_ropes and card=corner, card_stage_test + the five
REGRESSION tests green, FIGHT3D_PLAY failures=0. A small pure test of the side rule in tests/card_stage_test.gd
(pair at a rope -> side points to the centre; pair mid-ring -> continuity kept) - red on 1f48154 first.
Run on the hidden desktop only (never a monitor), --log to read the probe:
`python tools/hidden_desktop.py run --timeout=500 --log=E:/FightCamp/tmp/fc1_r3_ropes.txt "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/fight3d_play.gd -- E:/FightCamp/tmp/fc1_r3_ropes card=own_ropes`
(then card=corner into fc1_r3_corner). You cannot see images: the numbers are your gate; Claude opens the stills.
New final answer lines: `RESULT: tools/fight3d_play.gd card=own_ropes -> CARD STAGED n/m, CARD VIEW n/m` and the same for corner.

## ROUND 4 (S342, Claude's visual check of 400d9aa - read this first)
Round 3 put the lens inside the ring and both faces now read (CARD VIEW 2/2 both cards). NOT MERGED - Claude's stills
(E:/FightCamp/tmp/s342_fc3_corner/p03_after_shout.png, p06_round2_mid.png; s342_fc3_own_ropes/p06_round2_mid.png) show
three defects the probe cannot see yet:
1. NEAR FADE: corner p06 - the lens sits so close to Maria that RingCamera's near-fade (NEAR_FADE 0.9-1.5 m) turns her
   see-through; the referee shows through her body. In a rope/corner shot keep the lens >= 1.6 m from BOTH pelvises.
2. THE REFEREE WALKS INTO THE ACTION: corner p06 he stands BETWEEN the two boxers; corner p03 and own_ropes p06 he is
   almost touching them. Referee.gd keeps "on the far side from the camera" - with the lens now inside the ring looking
   out, the far side IS the ropes the pair is pinned on, so he is squeezed into them. At a rope/corner card he stands
   beside the pair along the rope line (not between them, not between the lens and them), >= 0.8 m (KEEP_M) from both.
   OWNS adds scripts/fight3d/Referee.gd (248 lines; keep < 500).
3. A SHOULDER SHOT OVER THE TRAPPED BOXER: corner p03 the lens is behind Maria, who is the one in the corner (round 3
   rule 2 says never). Check `_over` against the card's trapped boxer, not only the rope distance.
4. TOO FEW SAMPLES: round 3 skips samples during close-ups/corner minutes and measured 2 exchanges a card. Sample every
   exchange of rounds 1 and 2 (3.0 s after its first beat; if a close-up is running then, 1.0 s after it ends) - >= 6
   samples a card.
Extend the CARD line with `near_m=<min lens-to-pelvis m> ref_gap=<min ref-to-boxer pelvis m> ref_off_line=<ref pelvis
to the a-b segment m> ref_cover=<0|1> shot=<SHOTS name> over_trapped=<0|1>` (ref_cover = 1 when the lens->head segment of
either boxer passes < 0.25 m from the ref's torso line, pelvis -> pelvis + 1.45 m). `CARD VIEW` counts a sample only
with lens_in=1, a_vis=b_vis=1, near_m >= 1.5, ref_gap >= 0.75, ref_off_line >= 0.5, ref_cover=0, over_trapped=0.
PASS: CARD STAGED >= 80 % and CARD VIEW >= 80 % with >= 6 samples, for BOTH card=own_ropes and card=corner; card_stage_test
(add the referee-beside-the-pair rule as a pure check) and the five REGRESSION tests green, FIGHT3D_PLAY failures=0.
Run on the hidden desktop with --log exactly as round 3. New RESULT lines carry n/m for STAGED and VIEW with m >= 6.

## ROUND 5 (S344, Claude's visual check of da50828 on the hidden desktop - read this first)
Claude applied round 4 onto main and rendered `tools/fight3d_play.gd -- card=own_ropes` and `-- card=corner` on the real GPU.
VISUAL GATE FAIL (stills: Lean `docs/playtest/fightcard1_r4_red/own_ropes_p06.png`, `corner_p06.png`):
1. corner, 0:14 of round 2: the lens sits right behind the REFEREE's head - his hair and white shirt fill two thirds of the
   frame; neither woman is seen whole. own_ropes, same moment: the referee stands between the lens and Lucy - his shirt
   covers her body from the shoulders down. "Beside the pair along the rope line" put him on the lens's side.
2. Your CARD VIEW 12/12 did not see it: the probe never measured the referee against the lens.
Fix, and prove with numbers Claude can re-measure:
- The referee stands on the FAR side of the pair from the hard-cam (the lens sees both women, he is behind/beside them),
  never inside the lens-to-boxer sight lines. Add to the CARD probe per exchange: `ref_cover` = the share of each boxer's
  screen box (head, both hands, both feet, pelvis projected) covered by the referee's screen box; PASS <= 0.10 for both.
- `lens_ref_m` = lens to referee's head; PASS >= 1.5 m.
- Both women head to feet in frame in every CARD sample (still_framing rule).
Round 4 was REVERTED from the tree (not on main). CardStage.gd alone is on main (the bake of the flow-card stills uses it):
keep its API. Same OWNS, same tests; reply with the probe lines and the five regression tests.
