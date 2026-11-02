# S315 digest (2026-10-30) - Lean update 17: ways out of the inside, heads that sway up close

## What now works (Lean 4980e17; update 17 exported, 33/33 tests, exe smoke 0 errors)
- WAYS OUT OF THE INSIDE (John J_INSIDE2 coaching: pivot ~90 deg on the lead foot behind a check hook, or tie up until
  "Break"; before, every spell ended with a straight step back):
  - `scripts/rules/InsideExits.gd` (Claude; the spec was as long as the code) runs after ClinchBeats: each inside spell
    gets `exit` pivot / tie / step and `exit_who` (the pressed boxer leaves). A tie uses only the exchange's own
    clinches (one near the spell's end, or one moved to it with its referee break if no punch falls in the hold), so
    the clinch count stays the real one. A pivot's check hook = the leaver's last free single punch of the spell turned
    into a lead hook (body hooks, combos, big shots untouched; who lands what unchanged); `pivot_t` = end_t + 0.9 s.
    Shares over the realistic mix: pivot 0.43, tie 0.11, step 0.46 (ESTIMATE - no source counts exits; John
    J-INSIDE3 queued, SQ21). `tests/inside_exits_test.gd`: 7 checks over 900 exchanges.
  - 3D: RangeBreath phase "pivot" (end_t..pivot_t), ExchangeBeats shifts pivot_t into round time (the S314 trap),
    Footwork._pivot: once the leaver is back in guard, one fast circle step (scale 1.3) to her lead side at the held
    gap, arc = 70 deg; the presser turns after her at her facing pace.
- HEAD SWAYS INSIDE ("keep making small side-to-side sways"): HitSnap.sway - the trunk leans +-6 deg about the hips
  (~5 cm of head travel) at 0.7-1.0 Hz, each boxer her own pace, weighted by Footwork.inside_w.
- DEFECT FIXED: S314 wrote the update 16 notes only into Builds/WHAT_TO_TRY.txt; tools/export.sh copies docs/ over
  it, so the next export would have dropped them. docs/WHAT_TO_TRY.txt now holds 17 + 16 + the rest.

## Evidence (round 1, tools/range_probe.gd on the hidden desktop, 1280x720, fixed 30 fps; same fight every run)
| | S314 | S315 | Real |
|---|---|---|---|
| exits: pivot / step / tie | 0 / 14 / - | 6 / 7 / 1 | not counted (J-INSIDE3) |
| line turn 1.2 s after a pivot | - | 37-84 deg | ~90 deg body turn (coaching) |
| line turn after a step back | - | 9-39 deg | - |
| inside < 0.65 m | 20 % | 21 % | 17-31 % |
| feet moving | 54-56 % | 54-56 % | 53-56 % |
| referee in front of the boxers | 0 s | 0 s | - |
Stills (game camera, `tools/clinch_still.gd -- <dir> 12 inside`, now also shoots each pivot at 0 / 0.5 / 1.1 s):
E:/FightCamp/tmp/s315/stills (c01-c12). Board: previews/s315 (pivot sequence: Lucy pinned in the corner ->
off the ropes, the pair turned), review S315, Q-S294-27.

## Board
Q-S294-24/25/26 still unanswered at the end of S315. Q-S294-27 (update 17) added with the pivot sequence.

## Agents
John SQ21 J-INSIDE3 (exit shares from real bouts) queued. No PC/cloud code seat used: the rule module's spec would
have been as long as the code. Ziva: still on its weekly allowance (resets Monday) - not started.

## Next
S316: the guard inside (J_INSIDE2 item 2: elbows glued to the ribs, gloves at the cheeks/temples while inside; today
the guard is the long-range tuck) and short shovel hooks/uppercuts inside (15-30 cm of fist travel). Then J-INSIDE3's
real exit shares into InsideExits.PIVOT/TIE; board answers; Ziva when it runs.

## Update 18 (same session, operator: "Keep going") - Lean f804417, 33/33 tests, smoke 0 errors
- THE GUARD UP CLOSE (J_INSIDE2 item 2): GuardTuck.inner (from Footwork.inside_w; `-- noinguard` = control) draws each
  wrist to the cheek on its own side and turns the elbow's bend down and in (PunchReach.solve optional pole).
- GLOVE THROUGH A HEAD (defect found by the new probe, present before S315): GloveClear modifier (after HitSnap, before
  ElbowClear; `-- noglove` = control) moves a glove centre out to 0.15 m from the other's head centre.
- tools/inside_guard_probe.gd (pose as shown via pose_tap, round 1's first 90 s):
  | | control | update 18 |
  |---|---|---|
  | wrist in front of the head (guard, inside) | 0.233 m | 0.138 m |
  | wrist height from the head bone | -0.100 m | -0.032 m |
  | elbow out from the torso axis (median / p90; ElbowClear floor 0.17) | 0.195 / 0.246 | 0.188 / 0.215 |
  | glove centre < 0.09 m from a head centre, inside frames | 36 of 571 | 8 of 571 (0.13 m clearance: 12) |
  Offenders before: pro_left_hook 13, pro_left_jab_b 6, pro_left_hook_v2 5, pro_idle 3. Pocket numbers unchanged.
- Stills E:/FightCamp/tmp/s315/stills2 (c02 9.2 s and c06 21.7 s: gloves at the cheeks, elbows down); board
  previews/s315/guard_up_close.jpg, Q-S294-28. Still c01 (8.4 s): Maria's head reaches past Lucy's in a lean -
  heads may touch in the deepest leans; not measured yet.

## Next (replaces the line above)
S316: board answers (Q-S294-24..28); short shovel hooks/uppercuts inside (15-30 cm of fist travel; the hook clips are
authored at range); measure head-to-head distance inside (still c01); J-INSIDE3 shares into InsideExits; Ziva Monday.
