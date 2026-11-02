# S314 digest (2026-10-30) - Lean update 16: inside range, a longer stance, the referee off the camera side

## What now works (Lean afdc4a9, de55cac; update 16 exported, 32/32 tests, exe smoke 0 errors)
- INSIDE RANGE (real women's finals 17-31 % of a round under 0.65 m; ours 5 %, only the clinches):
  - `scripts/rules/InsideBeats.gd` (Qwen INSIDEBEATS1, collected): picks bursts fought inside (15 % of an exchange x
    situation: press 1.6, range 0.35, counter 0.7, loadup 0.8, tired/hurt 1.2), spell = first punch - 0.38 s to last
    punch + 0.8-1.6 s (1.5-6 s); straights there turn into hooks/uppercuts (TURN 0.75; body shots, combos and the big
    shot untouched; who lands what unchanged). Qwen measured 53 % hooks+uppercuts against its 55 % bound at TURN 0.65
    and reported it instead of tuning; Claude set 0.75 (inside 57 %, round straights 62 %).
  - 3D: RangeBreath phase "inside" (0.55 m; a clinch wins), Footwork (the infighter steps in; the other closes the
    last bit while she punches; each body 0.07 m to her own left = heads 14 cm apart past the shoulder, coaching books
    10-20 cm), FightStage floor eases 0.62 -> 0.48 m, FightView ignores the spell beat.
  - DEFECT FOUND BY THE PROBE: ExchangeBeats shifted `t` and `break_t` into round time but not the new `end_t` -
    4 spells shown of 14 planned (5 %). Fixed; range_probe now lists the planned spells beside the shown ones.
- GAP 7 STANCE: FootPlant stretches the animated feet's front-back spread along her facing by 1.32 (`-- nostagger`
  is the control arm). Feet as shown: control 0.24 NA (p90 0.40), x1.23 0.30, x1.32 0.32 (real 0.30 / 0.32 / 0.34).
- REFEREE: inside work on the ropes (still c06) had him cross to the camera side and stand in front of them. Now he
  stays on the far side and slides along the line (ALONG_TRY). range_probe "in front of the boxers": 12.4 s -> 0 s.

## Evidence (round 1, tools/range_probe.gd on the hidden desktop, 1280x720, fixed 30 fps; same fight every run)
| | S313 | S314 | Real (S310) |
|---|---|---|---|
| inside < 0.65 m | 5 % | 20 % | 17 / 20 / 31 % |
| long > 1.1 m | 62 % | 55 % | 40-63 % |
| swings a minute | 23.5 | 25.2 | 18-35 |
| feet moving | 58 % | 54-56 % | 53-56 % |
| stance stagger | 0.24 NA | 0.32 NA | 0.30-0.34 |
| referee in front of the boxers | 12.4 s | 0 s | - |
Stills (game camera, `tools/clinch_still.gd -- <dir> 6 inside`): E:/FightCamp/tmp/s314/inside (c01-c06), range/pocket
E:/FightCamp/tmp/s314/stills; on the board: previews/s314 (review S314, Q-S294-26).

## Research
- John J_INSIDE1_JOHN.md: no published time share for women's amateurs; Martusciello 2025b clinch shares by weight;
  Davis 2015 punch mix 53 % straights / 40 % hooks / 7 % uppercuts. Our footage stays the anchor.
- John J_INSIDE2_JOHN.md (coaching: Dempsey, Honour & Glory, BoxingWiki, IBA rules): head on/outside the lead
  shoulder, elbows glued to the ribs, short shovel hooks/uppercuts 15-30 cm, mostly to the body; out by a 90 deg pivot
  behind a check hook or tie up until "Break". Next gap from it: the pivot exit; small head sways inside.

## Ziva
Editor up on wt/ZIVA_LEAN (merged main, b8dc155); brief docs/ziva/S314_PLAYTEST_BRIEF.md written. Every run aborted
at once with $0 spent; the operator opened Ziva's Upgrade page himself (weekly limits reset Monday) - his money call,
nothing clicked by Claude.

## Agents
Qwen INSIDEBEATS1 launched 14:26, landed ~14:40, collected, worktree retired. John SQ19 + SQ20 answered.

## Next
S315: board answers Q-S294-24/25/26; Ziva when it runs again (update the brief to 16); the pivot exit from the inside.
