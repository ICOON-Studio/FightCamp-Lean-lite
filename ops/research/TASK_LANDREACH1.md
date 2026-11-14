# TASK LANDREACH1 - landed punches stop short of the face; the move card partner takes the jab

Status: HELD for the main session (2026-11-14 nightly review): animation work, it goes in the animation order with its
seat (Grok Dev / Ziva), not to Cursor (replaced, S446). Discipline: boxing.
Source: nightly 2026-11-14 (commit 7b7ac6e6): block_meet_test and move_tip_test went red; both PASSED on 2026-11-13 (5769c501).

## What the nightly showed
- block_meet_test, 10 failures, all CTRL_LANDED control rows (bar 5 cm glove-to-face on a landed punch): to_face
  6-19 cm, e.g. A_B pro_right_cross 0.189, A_A pro_left_hook 0.050, B_A pro_right_hook 0.168. Every blocked ROW passes
  (27 of 27 read). Pair gaps 0.87-0.91 m.
- move_tip_test, 1 failure: "the partner slips or blocks the jab" - the move card's partner plays only
  pro_hit_by_cross_v2_short / pro_idle / pro_idle_fidget_v6 / ow_bounce_idle / pro_hit_by_cross_v3; no dodge, block or slip.

## Likely cause (not proven)
Landed-path changes between 5769c501 and 7b7ac6e6 in scripts/fight3d: c724c01d (BLOCKLOOK2, BlockCatch), 02282250
(BLOCKLOOK3, the blocker absorbs, glove 3.5-5 cm back, head 1.5-3 cm), e0912e5f (BLOCKLOOK5, blocked straights on the
landed path; its message already says "block_meet 10 -> 9 (only CTRL_LANDED rulers)", so the rulers were red on main
in-session before it), 6f56de81 / aba17ad9 (POWER1D/E uppercut tails). Bisect block_meet_test over those first. The head
moving back 1.5-3 cm on a hit (BLOCKLOOK3) would explain landed gloves missing the face; check whether it also runs on
landed (not blocked) punches.

## Contract
OWNS: decided by the main session after the bisect (scripts/fight3d/*)
RED_TEST: tests/block_meet_test.gd -> BLOCK_MEET failures=0 ; tests/move_tip_test.gd -> MOVE_TIP failures=0
REGRESSION: block_catch_test, uppercut_tail_test, hit_carry_test, punch_snap_test, golden_path_test
VISUAL: yes - stills on the game camera through still_framing.gd save_if_framed (visual gate)

## Prior research
ops/research/S453_DIGEST.md (BLOCKLOOK5 held), docs/BLOCKLOOK4_RESULT.md, docs/BLOCKLOOK5_RESULT.md.

## What would a human do?
A punch that lands touches the face; a pad partner slips or blocks a jab.

## Prefab check
None needed.

## The one trap
CTRL_LANDED is the control arm of block_meet: never raise its 5 cm bar to make it pass. Godot only headless or through
godot_hidden / hidden_desktop; nothing on his monitors.
