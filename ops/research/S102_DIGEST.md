# S102 DIGEST - bisect, re-pins, G137 sizes, plan-linked result screen (2026-09-27, Claude)

Nightly cited: `AgentComms/nightly/latest.txt` - 2026-09-27 at 40bec39e, SUITE total=439 fails=24 (before S102's re-pins).

## Merged / collected
- **Q204 (Qwen) MERGED** - IJF throw into `half` = yuko; judo score share 4.9% -> 12.0% [9.1, 15.7]. The S101 review
  premise was wrong: **the IJF reinstated yuko for the LA2028 cycle (Paris GS 2025)**. The seat is the THROWER's, so
  half = uke down on side/back with a leg trapped, not stomach-first. Comment + two half pins updated. c1080a37.
- **Bisect Q203 vs U191**, each ALONE on c1080a37 (digests excluded - the first run's `git apply` failed on them and all
  arms silently ran as base): **Q203 clean** (clears base's landing-order red, adds none) -> MERGED 71068159.
  **U191 adds all three new reds** (doctor stops a championship fight 0/3, hurt man told to protect his head 0,
  R19 defensive_movement_rate) -> SENT BACK, rework section in `TASK_U191_FOOTWORK_SIDE_EFFECTS.md`.
- G138 (Grok, MMA state time-share), G139 (Grok, fence clinch - 5-state machine with rates), D48 + D49 (Dola) collected.

## Re-pins (each re-found by sweep, ascending, never picked to match)
- fight_realtime judo: ippon 94002 94004 94005, shido 94000 94001 94003 (sweep 44 ippon / 2 awasete / 54 shido).
- judge_panel T4/T8R: 3 cards via `s21_repin_judge_cards.py --write` (two runs agree); T11 kickboxing split 561 -> **179**
  (`tools/s102_t11_kb_split.gd`, dense 1..2000; Q195's stride-5 found none); boxing majority 446 survived.
- result_screen_why decision seed 92043 -> **92047** (`tools/s102_find_why_seed.gd`: 3 cards + a knockdown + side a 27+).
- fight_strike_whole OFF hashes re-pinned on 90a9cf26 (now printed as HASH lines).
- Verified green here: fight_realtime, judge_panel, result_screen_why, fight_strike_whole, grapple/judo subset (4/4),
  result_plan_card, both plan tests.

## G137 sizes
READ_CONTACT/READ_DEFENCE 0.03 -> 0.02, PLAN_FIT_EDGE_MAX 0.05 -> 0.03. New CIs:
- Plan setup, Great vs Poor landed diff/min: striker **+0.04 [-0.21, 0.30]** (lost significance), grappler +1.17
  [0.73, 1.60]; **pooled +0.61 [0.33, 0.88]**, win share no lower each side.
- AI corner, tactical 90 vs 30: striker +0.09 [-0.18, 0.36], wins 18 v 19 of 40; grappler +0.50 [0.21, 0.78];
  **pooled +0.29 [0.09, 0.49]**. As the handover ruled, the grounded size wins: both tests now gate POOLED (landed diff
  and wins), per side printed. The striker's coach mismatch is C216's job.

## Result screen (UI)
`PostFightRead.plan_outcomes`: every slider moved past 0.2 gets one line with its denominator - HEAD PLAN / BODY + LEGS
(landed share), KEEP IT STANDING (stuffed of shots) / TAKE HIM DOWN (landed of shots), PUSH THE PACE / PATIENT PACE (thrown
vs his, R1 vs last round), TAKE RISKS / DEFENCE FIRST (clean landed vs clean taken); each landed corner read judged in its
own round: "ROUND 3 READ (THE TELL) · 4 COUNTERS (R2: 1) · 14 LANDED (R2: 9)". D49 order: strongest slider, read, rest; the
plan row lost its number. The right column had overflowed SIDE_FLOOR since S101 (aftermath off-screen): the range card now
yields to THE PLANS and lines shrink to fit. Preview: `docs/previews/s102/result_plans.png` (`tools/s102_render_result_plans.gd`).
Noted: in that render the AI corners called no reads (reads_called 0) - check whether reads need `limb_damage` in state.

## Handed out
Qwen Q205 (MMA state share vs G138, launched), Cursor U191 rework -> C216 -> U192 (waits for a slot: Codex C217 + Qwen
running), Grok G140 (one down / one up, sent), Dola D50 (fresh eyes on the whole result screen, sent with the render).
Process note: killing Godot by image name took Codex's C217 test runs down once; kill by worktree path only.
